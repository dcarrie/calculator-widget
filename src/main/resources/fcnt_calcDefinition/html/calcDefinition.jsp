<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="flowRequestContext" type="org.springframework.webflow.execution.RequestContext"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>

<div id="<@= id @>" class="control-group">
    <label class="control-label" for="<@= id @>_block_<@= calc1_id @>">
        <@= label @>
    </label>
    <div class="controls">
        <input type="hidden" value="calculator" name="<@= id @>_block_<@= rendererName_id @>">
        <input id="<@= calc1_id @>" name="<@= id @>_block_<@= calc1_id @>" type="text" placeholder="<@= calc1placeholder @>"
        <@ if(validations != undefined && validations.address) { @> required="required" <@ } @> >
        <span id="<@= id @>_block_<@= calc1_id @>" class="hide help-inline"></span>
    </div>
    <div class="controls" style="margin-top: 10px;">
        <input id="<@= calc2_id @>" name="<@= id @>_block_<@= calc2_id @>" type="text" placeholder="<@= calc2placeholder @>">
    </div>


    <div class="controls">
        <@ if (helptext.length > 0) { @>
        <p class="help-block"><@= helptext @></p>
        <@ } @>
    </div>
</div>

