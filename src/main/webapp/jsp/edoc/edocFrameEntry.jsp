<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Enumeration"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>&nbsp;</title>
<%--<%@ include file="edocHeader.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/content/workflow.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/collaboration/batch/batch.js.jsp"%>

<style type="text/css">
html,body{height:100%;width: 100%;border: 0;padding: 0;margin: 0}
</style>

<script type="text/javascript">
var batchReflash = "";
var edocTypeReflash = "";
//批处理
function batchEdoc(checkBoxs,listType,edocType){
	batchReflash = listType;
	edocTypeReflash = edocType;
  //var checkBoxs = document.getElementsByName("id");
  if(!checkBoxs){
    alert(_("edocLang.batch_select_affair"));
    return ;
  }
  var process = new BatchProcess();
  for(var i = 0 ; i < checkBoxs.length;i++){
    if(checkBoxs[i].checked){
      var affairId = checkBoxs[i].getAttribute("affairId");
      var subject = checkBoxs[i].getAttribute("subject");
      var app = "4";
      process.addData(affairId,checkBoxs[i].value,app,subject);
    }
  }
  if(!process.isEmpty()){
    var r = process.doBatch("getA8Top().contentFrame.topFrame.refreshWorkspace()");
  }else{
    alert(v3x.getMessage("edocLang.batch_select_affair"));
    return ;
  }
}

function checkIsYoZoWps(templateId){
	var retValue=false;
	if(templateId && templateId != ""){
		var requestCaller = new XMLHttpRequestCaller(this, "templateManager", "getBodyType",false);
		requestCaller.addParameter(1, "String", templateId);
		var tempBodyType=requestCaller.serviceRequest();
		if(tempBodyType && (tempBodyType == "43" || tempBodyType == "44")){
			retValue = true; 
		}
	}
	return retValue;
}

function openEdocTemplete(templeteCategrory){
  _url="template/template.do?method=templateChoose&category="+templeteCategrory;
  var dialog = $.dialog({
      url:_url,
      width: 800,
      height: 500,
      title: "${ctp:i18n('templete.label')}",
      targetWindow: getA8Top(), 
      buttons: [{
          text: "${ctp:i18n('collaboration.pushMessageToMembers.confirm')}",
          handler: function () {
             var rv = dialog.getReturnValue();
             openTemplateById(rv);
             dialog.close();
          }
      }, {
          text: "${ctp:i18n('collaboration.pushMessageToMembers.cancel')}",
          handler: function () {
              dialog.close();
          }
      }]
  });
}
function openTemplateById(rv){
	if(rv==null || rv == ""){
        return;
      }
      if(rv=="notclicktemplate" || rv == 19||rv==20|| rv==21||rv==100){
        alert("${ctp:i18n('edoc.mustselect_templet')}");
        return;  
      }
    	 //本地是否安装的永中office，并且模板正文是wps正文则给出提示并返回
      var isYozoWps = checkIsYoZoWps(rv);
    	 
      var isYoZoOffice = parent.isYoZoOffice();
      if(isYozoWps && isYoZoOffice){
   	   //对不起，您本地office软件不支持当前所选模板的正文类型！
   	   alert(_("edocLang.edoc_template_alertWpsYozoOffice"));
   	   return;
      }
      var mainpage;
      if(detailIframe){
       mainpage = detailIframe.mainIframe.listFrame;
      }else{
       mainpage = mainIframe.listFrame;
      }
      //从待登记直接到收文分发，然后打开调用模板，从收文页面中取的签收id
      var waitRegister_recieveId = mainpage.document.getElementById("waitRegister_recieveId").value;
      
      var templeteType=rv;
      var workflow = "";
      var bodyContent = "";
      var xml="";
      var xslt="";
      var edocFormId="";
      var exchangeId=mainpage.document.sendForm.exchangeId.value;
      var registerId=mainpage.document.sendForm.registerId.value;
      var distributeEdocId=mainpage.document.sendForm.distributeEdocId.value;
      var backBoxToEdit = mainpage.document.sendForm.backBoxToEdit.value;
      var edocType=mainpage.document.sendForm.edocType.value;
      var nowCheckOption = mainpage.document.sendForm.checkOption.value;
      isFormSumit = true;
      var fromStateParam="";
      var exchangeRegister="";
      var comm=mainpage.document.sendForm.comm.value;
      if(comm=="transmitSend")
      {
          fromStateParam="&fromState=transmitSend";
      }
      
      //BUG20120725011863_G6_v1.0_徐州市元申软件有限公司_公文收文结束转发文，调用模板附件、正文、文单内容丢失
      if(comm=="forwordtosend")
      {
          var recieveId = mainpage.document.sendForm.recieveId.value;
          var strEdocId=mainpage.document.getElementById("relationRecId").value;
          var forwordType = mainpage.document.sendForm.forwordType.value;
          var relationRecd=mainpage.document.getElementById("relationRecd").value;
          var relationSend=mainpage.document.getElementById("relationSend").value;
          var recSummaryId=mainpage.document.getElementById("recSummaryIdVal").value;

          fromStateParam="&fromState=forwordtosend&checkOption="+nowCheckOption+"&edocId="+strEdocId+
                         "&recieveId="+recieveId+"&forwordType="+forwordType+
                        "&relationRecd="+relationRecd+"&relationSend="+relationSend+"&recSummaryId="+recSummaryId+"&comm="+comm;
      }
      //BUG20120725011863_G6_v1.0_徐州市元申软件有限公司_公文收文结束转发文，调用模板附件、正文、文单内容丢失-end
      
      
      if(exchangeId!="") {
          var strEdocId=mainpage.document.getElementById("strEdocId").value;
          exchangeRegister+="&strEdocId="+strEdocId+"&exchangeId="+exchangeId;
      }
      
      if((registerId!="" && registerId!="-1") || distributeEdocId!="") {
          if(registerId!="" && registerId!="-1") {
              exchangeRegister += "&registerId="+registerId;
          }
          if(distributeEdocId!="" && distributeEdocId!="")  {
              exchangeRegister += "&distributeEdocId="+distributeEdocId;
          }
          exchangeRegister += "&register="+comm;
      }
     
      if(backBoxToEdit!="") {
          var backBoxToEdit=mainpage.document.getElementById("backBoxToEdit").value;
          exchangeRegister+="&backBoxToEdit="+backBoxToEdit;
      }
      
      mainpage.cancel_onbeforeunload();
      var u = "edocController.do?method=newEdoc&edocType="+edocType+"&templeteId="+rv+fromStateParam+exchangeRegister;
      
      //转发调用模板，affair中需要设置forwardMemberId(依然属于转发业务逻辑)
      var forwardMemberId = mainpage.document.getElementById("forwardMember").value;
      if(forwardMemberId != ""){
        u +="&forwardMemberId="+forwardMemberId; 
      }
      var forwordtosend_recAffairId = mainpage.document.getElementById("forwordtosend_recAffairId").value;
      if(forwordtosend_recAffairId != ""){
        u +="&recAffairId="+forwordtosend_recAffairId; 
      }
      var newSummaryId = mainpage.document.getElementById("newSummaryId").value;
      mainpage.location.href=u + "&waitRegister_recieveId="+waitRegister_recieveId+"&newSummaryId="+newSummaryId;
}

</script>
<script>
    var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/edoc/js/i18n");
v3x.loadLanguage("/common/office/js/i18n");
v3x.loadLanguage("/common/pdf/js/i18n");
v3x.loadLanguage("/apps_res/collaboration/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
</script>


${v3x:showAlert(pageContext)}
<%
//读取传递过来的其它参数
String name="";
StringBuffer params=new StringBuffer();
Enumeration paramKeys= request.getParameterNames();
while(paramKeys.hasMoreElements())
{
  name=paramKeys.nextElement().toString();
  if("entry".equals(name) || "_spage".equalsIgnoreCase(name) || "method".equals(name) || "varTempPageController".equals(name)){continue;}
  params.append("&").append(name).append("=").append(request.getParameter(name));
}
request.setAttribute("otherParams",params.toString());
%>
<c:set value="${varTempPageController == null ? edoc : supervise}" var="tempCurrentController" />
</head>
<body style="overflow: hidden" <%--onload="onLoadLeft()"  onunload="unLoadLeft()"--%> > 
<iframe frameborder="no" marginheight="0" marginwidth="0" src="${tempCurrentController}?method=${v3x:toHTML(entry)}${v3x:toHTML(otherParams)}&toNewRegister=${toNewRegister}&isFromHome=${isFromHome}&app=${app}&sub_app=${sub_app}" id="detailIframe" name="detailIframe" scrolling="no" class="page-list-border" style="display: block;border: 0;width: 100%;height: 100%"></iframe>
</body>
</html>