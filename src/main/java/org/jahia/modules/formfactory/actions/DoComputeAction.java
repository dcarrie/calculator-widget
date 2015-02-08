package org.jahia.modules.formfactory.actions;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.validator.UrlValidator;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRContentUtils;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;


/**
 * Created by darcy on 08/02/15.
 */
public class DoComputeAction extends Action {
    @Override
    public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver) throws Exception {

        // Get the node who contains the form structure
        JCRNodeWrapper formStructure = session.getNodeByIdentifier(parameters.get("formId").get(0));

        // Create json to send at the url
        JSONObject jsonToSend = new JSONObject();
        jsonToSend.append("formName", formStructure.getName());

        // Register the url of origin of the result
        jsonToSend.append("origin", req.getRequestURL().toString());

        List<JCRNodeWrapper> stepsList = JCRContentUtils.getChildrenOfType(formStructure, "fcnt:step");
        for (JCRNodeWrapper stepNode : stepsList) {
            for (Map.Entry<String, List<String>> entry : parameters.entrySet()) {
                if (stepNode.hasNode(entry.getKey())) {
                    JCRNodeWrapper field = stepNode.getNode(entry.getKey());

                    JSONObject jsonCurrentResult = new JSONObject();

                    // Set the label of the field
                    jsonCurrentResult.put("label", field.getNode("label").getProperty("jsonValue").getString());

                    // Set the result of the field
                    List<String> values = entry.getValue();
                    String[] array = values.toArray(new String[values.size()]);
                    jsonCurrentResult.put("result", array);

                    // Set if the field was mandatory or not
                    if ((!field.hasNode("validations")) || (field.hasNode("validations") && !field.getNode("validations").hasNode("required"))) {
                        jsonCurrentResult.put("optional", true);
                    }
                    jsonToSend.append("formResponses", jsonCurrentResult);
                }
            }
        }

        // Get the node who contains the form actions
        JCRNodeWrapper formActions = formStructure.getNode("actions");

        List<JCRNodeWrapper> actionsSendDataToList = JCRContentUtils.getChildrenOfType(formActions, "fcnt:sendDataToUrlAction");

        ActionResult actionResult = new ActionResult(HttpServletResponse.SC_OK);
        for (JCRNodeWrapper actionSendDataTo : actionsSendDataToList) {
            JSONObject jsonAnswer = new JSONObject();
            UrlValidator urlValidator = new UrlValidator();
            String url = actionSendDataTo.getNode("sendto").getProperty("jsonValue").getString();

            jsonAnswer.append("actionName", resource.getTemplate());
            jsonAnswer.append("redirectUrl", "");

            if (StringUtils.isNotEmpty(url) && urlValidator.isValid(url)) {
                HttpClient httpClient = new HttpClient();

                // Get parameter
                String parameter = actionSendDataTo.getNode("parametername").getProperty("jsonValue").getString();

                PostMethod postMethod = new PostMethod(url);
                postMethod.getParams().setContentCharset("UTF-8");
                postMethod.setRequestEntity(new StringRequestEntity(jsonToSend.toString(), "application/json", "UTF-8"));
                // Set parameter
                if (StringUtils.isNotEmpty(parameter)) {
                    postMethod.addParameter(parameter, jsonToSend.toString());
                }
                int responseCode = httpClient.executeMethod(postMethod);

                String responseStatus = postMethod.getStatusLine().toString();

                if (responseCode >= 200 && responseCode < 300) {
                    jsonAnswer.append("code", responseCode);
                    jsonAnswer.append("status", "success");
                    jsonAnswer.append("message", "Data : " + jsonToSend + " sent to : " + url + " code : " + responseCode + " Response : " + responseStatus);
                } else {
                    jsonAnswer.append("code", responseCode);
                    jsonAnswer.append("status", "error");
                    jsonAnswer.append("message", "Data : " + jsonToSend + " not sent to : " + url + " error code : " + responseCode + " Response : " + responseStatus);
                }
                actionResult.setJson(jsonAnswer);
            } else {
                jsonAnswer.append("status", "error");
                jsonAnswer.append("message", "Data : " + jsonToSend + " not sent, they have an error with the url provided, please check and correct : " + url);

                actionResult.setJson(jsonAnswer);
            }
        }
        return actionResult;
    }
}