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
	<tr><td style="margin-top:10px; padding:15px 0px 0px 25px;"><fmt:message key='edoc.disagreeDeal.alert' /></td></tr>
	<tr>
		<td class="bg-advance-middel">
		<table width="70%" border="0" cellpadding="0" cellspacing="0" style="margin:0 auto;">
				<tr style="text-align:center;">
					<td height="100%"  style="padding:15px 6px 15px 6px">
						<!-- 继续 -->
						<label>
				    	<input style="vertical-align: text-bottom;" type="radio" value="continue" id="radio1" name="option" class="radio_com" checked/><fmt:message key='edoc.continue' />
				    	</label>
				    	<!-- 回退 -->
				    	<c:if test = "${param.stepBack != 'hidden'}">
				    	<label>
				    	<input style="vertical-align: text-bottom;"  type="radio" value="stepBack" id="radio2" name="option" class="radio_com" <c:if test="${param.disableTB eq '1'}">disabled</c:if>/><fmt:message key='permission.operation.Return' />
				    	</label>
				    	</c:if>
				    	<!-- 终止  -->
				    	<c:if test = "${param.stepStop != 'hidden'}">
				    	<label>
				    	<input style="vertical-align: text-bottom;"  type="radio" value="stepStop" id="radio3" name="option" class="radio_com"/><fmt:message key='permission.operation.Terminate' />
				    	</label>
				    	</c:if>
				    	<!-- 撤销  -->
				    	<c:if test = "${param.repeal != 'hidden'}">
				    	<label>
				    	<input style="vertical-align: text-bottom;"  type="radio" value="repeal" id="radio4" name="option" class="radio_com"/><fmt:message key='permission.operation.Cancel' />
				    	</label>
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