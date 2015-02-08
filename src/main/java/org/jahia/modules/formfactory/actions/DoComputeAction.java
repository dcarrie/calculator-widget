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

        //TODO:Implement Action execution
        //Action execution result

        JSONObject jsonAnswer = new JSONObject();
        jsonAnswer.append("actionName", resource.getTemplate());
        jsonAnswer.append("status", "success");
        jsonAnswer.append("code", HttpServletResponse.SC_CREATED);
        jsonAnswer.append("redirectUrl", "");
        jsonAnswer.append("message", "The action Do Compute has been called.");
        return new ActionResult(HttpServletResponse.SC_OK, null, jsonAnswer);
    }
}