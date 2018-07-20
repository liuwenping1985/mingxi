<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=colManager"></script>
<script type="text/javascript">
/**
 * 调用模板，如新建协同的调用模板页面,只能选择一个模板
 * @param category {link TemplateCategory.TYPE}
 * @param accountId 单位ID，不传值默认为当前用户的登录单位
 * @return 模板ID，如12345
 */
function callTemplate(category,accountId,callback){
    var ur='<c:url value="/govTemplate/govTemplate.do?method=templateChoose&category='+category+'"/>';
    if(typeof(accountId)!='undefined'){
        ur+='&accountId='+accountId;
    }
    var dialog = $.dialog({
        url:ur,
        width: 800,
        height: 450,
        title: "${ctp:i18n('template.templateJs.callTemplate')}",//调用模板
        targetWindow: getCtpTop(),
        buttons: [{
            text: "${ctp:i18n('collaboration.pushMessageToMembers.confirm')}", //确定
            btnType : 1,//按钮样式
            handler: function () {
               var rv = dialog.getReturnValue();
               if("notclicktemplate" == rv){
                 $.messageBox({
                    'type' : 0,
                    'title':"${ctp:i18n('system.prompt.js')}",
                    'msg' : "${ctp:i18n('collaboration.alert.pleasechoosetemplate')}",
                    'imgType':2,
                    ok_fn : function() {
                    }
                  });
                return;
               }
               //YozoOffice
               //本地是否安装的永中office，并且模板正文是wps正文则给出提示并返回
               var isYozoWps = checkIsYoZoWps(rv);
               var isYoZoOffice = parent.isYoZoOffice();
               if(isYozoWps && isYoZoOffice){
                  //对不起，您本地office软件不支持当前所选模板的正文类型！
                  alert("${ctp:i18n('collaboration.template.alertWpsYozoOffice')}");
                  return;
               }
               if(callback){
            	   callback(rv);
               }
               dialog.close();
            }
        }, {
            text: "${ctp:i18n('collaboration.pushMessageToMembers.cancel')}", //取消
            handler: function () {
                isFormSubmit = true;
                dialog.close();
            }
        }]
    });
}
function checkIsYoZoWps(templateId) {
  var retValue = false;
  if (templateId && templateId != "") {
    var requestCaller = new XMLHttpRequestCaller(this,"templateManager", "getBodyType", false);
    requestCaller.addParameter(1, "String", templateId);
    var tempBodyType = requestCaller.serviceRequest();
    if (tempBodyType && (tempBodyType == "WpsWord" || tempBodyType == "WpsExcel" || tempBodyType == "43" || tempBodyType == "44")) {
      retValue = true;
    }
  }
  return retValue;
}
function setButtonStyle(){
    $(":li").removeClass("current");
}
//正文展现
 function showContent(){
     $(":li").removeClass("current");
     $("#contentBut").addClass("current");
     $("#displayIframe").src("http://www.baidu.com");
 }
 //流程图
 function showWorkFlow(){
     $(":li").removeClass("current");
     $("#contentBut").addClass("current");
     $("#displayIframe").src("http://www.baidu.com");
 } 
 //使用说明
 function showWorkFlowDesc(){
     $("#content_view_li").removeClass("current border_b last_tab");
     $("#workflow_view_li").addClass("current border_b last_tab");
     $("#display_content_view").hide();
     $("#display_workflow_view").show();
 } 

 function checkTemplateCanUse(templateId){
	 var callerResponder = new CallerResponder();
     var collManager = new colManager();	
      var strFlag = collManager.checkTemplateCanUse(templateId);
	  if(strFlag.flag =='cannot'){
		 return false;
	  }else{
		 return true;
     }
 }
</script>