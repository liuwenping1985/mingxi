<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../exchangeHeader.jsp"%>

<html>
<title><fmt:message key='hasten.label' bundle='${edocI18N}'/></title>
<style type="text/css">
.style1 {
    text-align: left;
}
.style3 {
    text-align: center;
}
</style>

<script type="text/javascript">
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
       var cuibanInfo = formObj.cuibanInfo;
       if(cuibanInfo==null||cuibanInfo.value==""){
           alert(_("ExchangeLang.exchange_cuibanRecord_cuiban_cuibanInfo_empty"));
           return;
       }
       if((cuibanInfo!=null)&&(cuibanInfo.value.length>85)){
           alert(_("ExchangeLang.exchange_cuibanRecord_cuiban_cuibanInfo_tooLong"));
           return;
       }

       //特殊字符判断
       if(!notSpecChar(cuibanInfo)){
           return;
       }

       var returnValues = new Array();
       returnValues.push(1);
       returnValues.push(cuibanInfo.value);
       transParams.parentWin.openCuibanCallback(returnValues);
       commonDialogClose('win123');
     }
     
     function closeDlg(){
         var returnValues = new Array();
         returnValues.push(0);
         transParams.parentWin.openCuibanCallback(returnValues);
         commonDialogClose('win123');
     }
</script>
</head>
<body scroll='no' onload="_init_()" onkeydown="listenerKeyESC()">
<form action="" id="stepBackInfoForm" method="POST">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td height="20" class="PopupTitle"><fmt:message key='hasten.label' bundle='${edocI18N}'/></td>
    </tr>
    <tr>
        <td class="bg-advance-middel" height="100%">
            <div class="scrollList">
                <table width="100%" height="85%" border="0" cellspacing="0"
                            cellpadding="0">
                            <tr>
                                <td height="90%" class="style1" colspan="2">
                                <%--GOV-5045 公文签收时退回，附言是特殊字符，查看退回附言，报js --%>
                                    <textarea id="cuibanInfo" name="cuibanInfo" inputName="<fmt:message key='hasten.label' bundle='${edocI18N}'/>" cols="" rows="" class="note-textarea wordbreak"></textarea>
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
                        <input id="cancelBtn" name="cancelBtn" type="button" onclick="commonDialogClose('win123')" value="<fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}' />" class="button-default-2"> 
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
<iframe name="submitStepBackInfoFrame" frameborder="0" style="display: none;"></iframe>
</body>
</html>