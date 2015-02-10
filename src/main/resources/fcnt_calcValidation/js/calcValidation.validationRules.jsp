<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="flowRequestContext" type="org.springframework.webflow.execution.RequestContext"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<jcr:node path="${currentNode.path}/messageaddress" var="nodeRequiredMessageAddress"/>
<jcr:node path="${currentNode.path}/messagecity" var="nodeRequiredMessageCity"/>
<jcr:node path="${currentNode.path}/messagecountry" var="nodeRequiredMessageCountry"/>
<jcr:node path="${currentNode.path}/messagezipcode" var="nodeRequiredMessageZipCode"/>

<c:set var="requiredMessageAddress" value="${nodeRequiredMessageAddress.properties['jsonValue'].string}"/>
<c:set var="requiredMessageCity" value="${nodeRequiredMessageCity.properties['jsonValue'].string}"/>
<c:set var="requiredMessageCountry" value="${nodeRequiredMessageCountry.properties['jsonValue'].string}"/>
<c:set var="requiredMessageZipCode" value="${nodeRequiredMessageZipCode.properties['jsonValue'].string}"/>
{
    fn: function(value, blockname, model) {

        //Address mandatory fields list
        var mandatoryFields = {
            <c:choose>
                <c:when test="${not empty requiredMessageAddress}">
                    address1: '${functions:escapeJavaScript(requiredMessageAddress)}',
                </c:when>
                <c:otherwise>
                    address1: "<fmt:message key='address.error.address1'/>",
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${not empty requiredMessageCity}">
                    city: '${functions:escapeJavaScript(requiredMessageCity)}',
                </c:when>
                <c:otherwise>
                    city: "<fmt:message key='address.error.city'/>",
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${not empty requiredMessageCountry}">
                    country: '${functions:escapeJavaScript(requiredMessageCountry)}',
                </c:when>
                <c:otherwise>
                    country: "<fmt:message key='address.error.country'/>",
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${not empty requiredMessageZipCode}">
                    zipcode: '${functions:escapeJavaScript(requiredMessageZipCode)}'
                </c:when>
                <c:otherwise>
                    zipcode: "<fmt:message key='address.error.zipcode'/>"
                </c:otherwise>
            </c:choose>
        }

        //Init error Object
        var fields = [];
        _.each(mandatoryFields, function(errorMessage, field){
            var fieldName = blockname + "_block_" + field + "_id";
            fields.push({name: fieldName, message: errorMessage, error: false});
        });

        //Check fields value
        _.each(mandatoryFields, function(errorMessage,field){
            var fieldName = blockname + "_block_" + field + "_id";
            //Get field error Object
            var errorObject = _.find(fields, function(field){
                return field.name == fieldName;
            });
            //set field error value
            errorObject.error = !model[blockname + "_block_" + field + "_id"];
        });

        //Get error State from fields
        var errorState = _.reduce(fields, function(errorBoolean, field){
            return errorBoolean || field.error;
        }, false);

        //return false if no error or field in the other case;
        return errorState?fields:errorState;
    }
}

