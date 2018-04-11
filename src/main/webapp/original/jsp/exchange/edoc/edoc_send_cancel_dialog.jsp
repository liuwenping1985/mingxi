<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../exchangeHeader.jsp"%>
<html>
<title><fmt:message key='exchange.send.withdraw'/></title>
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
        if("1"=='${readOnly}') {
            document.getElementById("sendCancelAlert").style.display = "none";
            document.getElementById("subBtn").style.display = "none";
            document.getElementById("sendCancelInfo").readOnly = true;
        }
    }
    
    function subminForm() {
        var formObj = document.getElementById("cancelInfoForm");
        var sendCancelInfo = formObj['sendCancelInfo'];
        if(sendCancelInfo==null||sendCancelInfo.value=="") {
            alert(_("ExchangeLang.exchange_cancelRecord_cancel_cancelInfo_empty"));
            return;
        }
        if((sendCancelInfo.value!=null) && (sendCancelInfo.value.length>85)){
            alert(_("ExchangeLang.exchange_cancelRecord_cancel_cancelInfo_tooLong"));
            return;
        }
        //特殊字符判断
        if(!notSpecChar(sendCancelInfo)){
            return;
        }
        var returnValues = new Array();
        returnValues.push(sendCancelInfo.value);
        transParams.parentWin.withdrawCallback(returnValues);
        commonDialogClose('win123');
    }
    
    function closeDlg() {
        commonDialogClose('win123');
    }

</script>
</head>
<body scroll='no' onload="_init_()" onkeydown="listenerKeyESC()" style="overflow: hidden;">
<form action="" id="cancelInfoForm" method="POST">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel" height="100%">
			<div class="scrollList">
				<table width="100%" height="85%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<div id="sendCancelAlert" name="sendCancelAlert">
							<fmt:message key='exchange.send.cancel.alert'/>
						</div>
					</tr>
					<tr>
						<td height="90%" class="style1" colspan="2">
							<textarea id="sendCancelInfo" name="sendCancelInfo" inputName="<fmt:message key='exchange.stepBack' />" cols="" rows="" class="note-textarea wordbreak">${sendCancelInfo}</textarea>
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
						<input id="cancelBtn" name="cancelBtn" type="button" onclick="closeDlg()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
					</c:otherwise>
			</c:choose>
		</td>
	</tr>
</table>	
</form>
<%-- 不知道下面这个Iframe有什么用，影响样式，先隐藏 --%>
<iframe name="submitStepBackInfoFrame" frameborder="0" style="display: none"></iframe>
</body>
</html>