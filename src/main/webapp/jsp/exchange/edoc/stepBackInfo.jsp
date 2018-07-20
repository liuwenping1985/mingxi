<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../exchangeHeader.jsp"%>
<html>
<title><fmt:message key='exchange.stepBack'/></title>
<style type="text/css">
.style1 {
    text-align: left;
}
.style3 {
    text-align: center;
}
</style>

<script language="JavaScript">

    function _init_(){
        var readOnly = '${readOnly}';
        if("1"==readOnly){
            var formObj = document.forms[0];
            var subBtnObj = formObj.subBtn;
            var stepBackAlertObj = document.getElementById("stepBackAlert");
            stepBackAlertObj.style.display = "none";
            subBtnObj.style.display = "none";
            formObj.stepBackInfo.readOnly = true;
        }
    }

    function subminForm(){
        var stepBackSendEdocId = '${stepBackSendEdocId}';
        var stepBackEdocId = '${stepBackEdocId}';
        var formObj = document.forms[0];
        var stepBackInfo = formObj.stepBackInfo;
        if(stepBackInfo==null||stepBackInfo.value.trim()==""){
            alert(_("ExchangeLang.exchange_stepBackRecord_stepBack_stepBackInfo_empty"));
            return;
        }
        if((stepBackInfo.value!=null)&&(stepBackInfo.value.length>85)){
            alert(_("ExchangeLang.exchange_stepBackRecord_stepBack_stepBackInfo_tooLong"));
            return;
        }

        //特殊字符判断
        if(!notSpecChar(stepBackInfo)){
            return;
        }

        var returnValues = new Array();
        returnValues.push(1);
        returnValues.push(stepBackSendEdocId);
        returnValues.push(stepBackEdocId);
        returnValues.push(stepBackInfo.value);
        transParams.parentWin.huituiCallback(returnValues);
        commonDialogClose('win123');
    }
    
    function closeDlg(){
        var returnValues = new Array();
        returnValues.push(0);
        window.returnValue = returnValues;
        window.close();
    }

</script>

</head>
<body scroll='no' onload="_init_()" onkeydown="listenerKeyESC()" style="overflow:hidden">
<form action="" id="stepBackInfoForm" method="POST">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='exchange.stepBack' /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" height="100%">
			<div class="scrollList">
				<table width="100%" height="85%" border="0" cellspacing="0"
							cellpadding="0">
							<tr>
								<div id="stepBackAlert" name="stepBackAlert">
								<c:choose>
									<c:when test="${'1'==isResgistering}">
										<!-- lijl Add -->
										<fmt:message key='exchange.stepBack.alert.sign'/>
									</c:when>
									<c:when test="${'0'==isResgistering}">
										<!-- lijl Add -->
										<fmt:message key='exchange.stepBack.alert.fwd'/>
									</c:when>
									<c:otherwise>
										<!-- lijl Add -->
										<fmt:message key='exchange.stepBack.alert.register'/>
									</c:otherwise>
							</c:choose>
								</div>
							</tr>
							<tr>
								<td height="90%" class="style1" colspan="2">
								<%--GOV-5045 公文签收时退回，附言是特殊字符，查看退回附言，报js --%>
									<textarea id="stepBackInfo" name="stepBackInfo" inputName="<fmt:message key='exchange.stepBack' />" cols="" rows="" class="note-textarea wordbreak"><c:if test="${'1'==readOnly}">${stepBackInfo}</c:if></textarea>
								</td>
							</tr>
						</table>
			</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input id="subBtn" name="subBtn" type="button" onclick="subminForm()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<c:choose>
					<c:when test="${'1'==readOnly}">
						<input id="cancelBtn" name="cancelBtn" type="button" onclick="commonDialogClose('win123');" value="<fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}' />" class="button-default-2"> 
					</c:when>
					<c:otherwise>
						<input id="cancelBtn" name="cancelBtn" type="button" onclick="commonDialogClose('win123');" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
					</c:otherwise>
			</c:choose>
		</td>
	</tr>
</table>	
</form>
<%-- 不知道下面这个Iframe有什么用，影响样式，先隐藏 --%>
<iframe name="submitStepBackInfoFrame" frameborder="0" style="display: none;"></iframe>
</body>
</html>