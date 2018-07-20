<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/hr" prefix="hr" %>
<script language="JavaScript">
function cancel(){
    window.location.href= "${hrStaffURL}?method=userDefinedHome&page_id=${page_id}&staffId=${staffId}";
}  
</script>
<c:set var="ro" value="${v3x:outConditionExpression(dis, 'readOnly', '')}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
		<td class="categorySet-head" height="10"></td>
	</tr>
	<c:choose>
		<c:when test="${operation == 'Save'}">
    		<hr:salaryAddTag model="staff" language="${v3x:getLocale(pageContext.request)}" properties="${webProperties}" />
    	</c:when>
    	<c:otherwise>
    		<hr:salaryViewTag model="staff" language="${v3x:getLocale(pageContext.request)}" properties="${webProperties}" readonly="${ro}" />
    	</c:otherwise>
    </c:choose>
    <c:if test="${save}">
	    <tr>
	    	<td align="center" class="bg-advance-bottom">
			   <input type="submit" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			   <input type="button" onclick="cancel()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
	   	 </td>
	    </tr>
	</c:if>
</table>