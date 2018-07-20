<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../edocHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<html:link renderURL='/edocSupervise.do?method=sendMessage' var='sendURL'/>
<title><fmt:message key="hasten.label" bundle="${colI18N}"/></title>
<script type="text/javascript">
function ok(){

	var theForm = document.getElementById("theForm");
	if(!checkForm(theForm))
		return;

    var id_checkbox = document.getElementsByName("deletePeople");
    if (!id_checkbox) {
        return true;
    }

    var hasMoreElement = false;
    var len = id_checkbox.length;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
        	var obj = id_checkbox[i];
            hasMoreElement = true;
            break;
        }
    }

    var content = "";
    $("textarea").each(function() {
    	if(this.name == "content"){
    		content = this.value;
    	}
    });
        if(content.length>300)
    {
    	 alert(v3x.getMessage("edocLang.edoc_word_count1")+content.length+v3x.getMessage("edoc_word_count2"));
    	 return false;
    }
    if (!hasMoreElement) {
    <c:choose>
     <c:when test="${flowData!=null}">
        alert(v3x.getMessage('collaborationLang.collaboration_least_select_singleton'));
     </c:when>
     <c:otherwise>
     	alert(v3x.getMessage('collaborationLang.collaboration_nobody'));
     </c:otherwise>
    </c:choose>
        return false;
    }

    theForm.b1.disabled = true;
    theForm.b2.disabled = true;
    
    theForm.submit();
}
function checkedDefault()
{
	var objcts = document.getElementsByName("deletePeople");	
	if(objcts != null){
		for(var i = 0; i < objcts.length; i++){
			if(objcts[i].disabled == true){
				continue;
			}
			objcts[i].checked = true;
		}
	}
	document.getElementById("allCheckbox").checked=true;
}
<%-- 催办完成后，将催办次数值传回父窗口，以便关闭父窗口后列表中对应记录的催办次数实时更新 --%>
function setHastenTimesBack(times){
	try{
		window.dialogArguments.parent.document.getElementById("hastenTimes").value = times;
	}catch(e){}
	window.close();
}
<%-- 点击取消时，传给父窗口不用更新催办次数的标识值，同时关闭窗口--%>
function cancelHasten(){
	setHastenTimesBack('0');
}
//-->
</script>
</head>
<body scroll="no" style="overflow: hidden" onload="checkedDefault()" onkeydown="listenerKeyESC()">
<form id="theForm" method="post" action="edocSupervise.do?method=sendMessage" target="hantenIframe">
<input type="hidden" name="summaryId" value="${param.summary_id}" />
<input type="hidden" name="superviseId" value="${param.superviseId}" />
<input type="hidden" name="processId" value="${param.processId}" />
<input type="hidden" name="activityId" value="${param.activityId}" />

<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="hasten.label" /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<table width="100%" align="center" height="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="26"><fmt:message key="selectPeople.please.label" bundle="${colI18N}"/></td>
				</tr>
				<tr>
					<td height="60%">
					<div class="scrollList" style="border: solid 1px #666666;">
						<table class="sort" width="100%"  border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
						<thead>
						<tr class="sort">
							<td width="5%" align="center"><input type='checkbox' id='allCheckbox' onclick='selectAll(this, "deletePeople")'/></td>
							<td type="String"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" /></td>
						</tr>
						</thead>
						<tbody>
						<c:set value="${col:showDecreaseNode(flowData)}" var="data" />
						<c:choose>
							<c:when test="${data == null}">
								<tr class="sort">
									<td align="center" class="sort" colspan="2"><fmt:message key="collaboration.deletePeople.nobody.label" bundle="${colI18N}"/></td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach items="${data}" var="d">
								<tr class="sort">
									<td align="center" class="sort" width="5%">${d[0]}</td>
									<td class="sort" type="String">${d[1]}</td>
								</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						</tbody>
						</table>
					</div>
					</td>
				</tr>
				<tr>
					<td height="28"><fmt:message key="postscript.label" bundle="${colI18N}"/></td>
				</tr>
				<tr>
				    <td valign="top">
				        <textarea id="content" name="content" rows="5" cols="" class="input-100per" validate="maxLength"
				                  inputName="<fmt:message key='postscript.label' bundle='${colI18N}'/>" maxSize="${param.maxSize == null?80:param.maxSize }"></textarea>
				    </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" align="right" class="bg-advance-bottom">
			<input type="button" name="b1" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<input type="button" name="b2" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</form>

<iframe name="hantenIframe" frameborder="0" height="0" width="0" scrolling="no"></iframe>

</body>
</html>