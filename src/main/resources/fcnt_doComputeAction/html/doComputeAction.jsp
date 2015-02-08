<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fmt:message var="description" key="actions.doComputeAction.description"/>
<dl class="dl-horizontal">
    <dt><i class="icon-bookmark"></i>&NonBreakingSpace;<@= label @></dt>
    <dd data-toggle="tooltip" title="${description}">${functions:abbreviate(description,200,300,'...')}
    </dd>
</dl>