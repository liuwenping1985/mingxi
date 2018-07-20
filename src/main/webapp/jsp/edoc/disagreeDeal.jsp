<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../common/INC/noCache.jsp"%>
<%@ include file="edocHeader.jsp" %>
<title></title>
<script type="text/javascript">
function ok(){
	var optionO = document.getElementsByName("option");
	var optionV = "";
	if(optionO){
		for(var i=0;i<optionO.length;i++){
			if(optionO[i].checked==true){
	        	 optionV = optionO[i].value;
	         }
		}
		transParams.parentWin.edocSubmitCallback(optionV);
}
}
function cencel(){
	transParams.parentWin.enablePrecessButtonEdoc();
	commonDialogClose('win123');
}
</script>
</head>
<body scroll="no">
<form name="commentForm">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td class="align_center" style="margin-top:10px; padding-top:15px;"><fmt:message key='edoc.disagreeDeal.alert' /></td></tr>
	<tr>
		<td class="bg-advance-middel">
		<table width="70%" border="0" cellpadding="0" cellspacing="0" style="margin:0 auto;">
				<tr>
					<td height="100%"  style="padding:15px 6px 15px 6px">
						<!-- 继续 -->
				    	<input type="radio" value="continue" id="radio1" name="option" class="radio_com" checked/><fmt:message key='edoc.continue' />
				    	<!-- 回退 -->
				    	<c:if test = "${param.stepBack != 'hidden'}">
				    	<input type="radio" value="stepBack" id="radio2" name="option" class="radio_com" <c:if test="${param.disableTB eq '1'}">disabled</c:if>/><fmt:message key='edoc.toolbar.rollback.label' />
				    	</c:if>
				    	<!-- 终止  -->
				    	<c:if test = "${param.stepStop != 'hidden'}">
				    	<input type="radio" value="stepStop" id="radio3" name="option" class="radio_com"/><fmt:message key='edoc.termination' />
				    	</c:if>
				    	<!-- 撤销  -->
				    	<c:if test = "${param.repeal != 'hidden'}">
				    	<input type="radio" value="repeal" id="radio4" name="option" class="radio_com"/><fmt:message key='edoc.repeal.2.label' />
				    	</c:if>
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
		<td height="30px" align="right" class="bg-advance-bottom">
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">
			<input type="button" onclick="cencel()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
		</tr>
	</table>
</form>
</body>
</html>