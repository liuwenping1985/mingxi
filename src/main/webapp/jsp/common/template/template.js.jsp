<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=colManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=templateManager"></script>
<script type="text/javascript">
$(document).ready(function(){
    
});
/**
 * 调用模板，如新建协同的调用模板页面,只能选择一个模板
 * @param category {link TemplateCategory.TYPE}
 * @param accountId 单位ID，不传值默认为当前用户的登录单位
 * @return 模板ID，如12345
 */
 var isWaitSendopen = false ;
function callTemplate(category,accountId,callback,isFenban){
	 if(!isWaitSendopen){//BDGW-2206 关闭公文开关中可否自建流程，打开保存待发的公文，还提示请选择公文模板
		 //因为新公文和协同调用模版都会走这个地方，如果是协同就没有isWaitSend这个变量。
		 if(typeof(isWaitSend) != 'undefined' && isWaitSend =="true"&&typeof(vobjTemplateId) != 'undefined'&&vobjTemplateId!=null&&vobjTemplateId!=""){//
			 isWaitSendopen = true;
			 return false ;
		 } 
	 }
	 
    var ur='<c:url value="/template/template.do?method=templateChoose&category='+category+'"/>';
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
            btnType:1,
            handler: function () {
            	if(('401' == category || '402' == category ||'403' == category) && isFenban && isFenban != 'true' && isFenban != true){
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
            	   	 	 return false;
            	   }
            		 var confirm = "";
			      confirm = $.confirm({
			          'msg': $.i18n('govdoc.alert.chooseTemp.message'), 
			          ok_fn: function () {
			           if(confirmCallBack(dialog,callback)){
			        	   dialog.close();
			           }
			           confirm.close();
			          },
			          cancel_fn:function(){
			            confirm.close();
			          }
			       });
            	}else{
            		 confirmCallBack(dialog,callback);
		             dialog.close();
            	}
            	
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
function confirmCallBack(dialog,callback){
 	isFormSubmit = false;
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
   	 	 return false;
      }
      //本地是否安装的永中office，并且模板正文是wps正文则给出提示并返回
      var isYozoWps = checkIsYoZoWps(rv);
      var isYoZoOffice = parent.isYoZoOffice();
      if(isYozoWps && isYoZoOffice){
	   	   //对不起，您本地office软件不支持当前所选模板的正文类型！
	   	   $.alert("${ctp:i18n('collaboration.template.alertWpsYozoOffice')}");
	   	   return false;
      }
      if(callback){
   	   		callback(rv);
      }
      return true;
}
function checkIsYoZoWps(templateId){
	var retValue=false;
	if(templateId && templateId != ""){
		var tempManager = new templateManager();
		var tempBodyType = tempManager.getBodyType(templateId);
		if(tempBodyType && (tempBodyType == "43" || tempBodyType == "44")){
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


 /**
 *模板左右选择组件,参数没有就传null
 *@param callback 回调函数
 *@param isMul 是否支持多选，默认为true
 *@param moduleType 模板分类，取ModuleType的枚举值Key
 *@param accountId 单位ID，默认为当前登录单位ID
 *@param scope 数据范围：枚举值["MemberUse","MaxScope","MemberAnalysis"]
 *@param excludeTemplateIds : 不包含的模板ID，以，分隔的字符串，eg:123232,12121,43,21212 不宜太多，10个以下为好
 *@param reportId:报表ID，F8专用
 *@param rew
 */
/**
*回显数据
*var templateOrginalData=new Object();
*templateOrginalData["ids"]  = ids;  ids:以,分隔的ID串
*templateOrginalData["names"]= names; names:以数组Array的形式传入
*templateOrginalData["namesDisplay"] = namesDisplay;模板组件返回给外层应用的显示数据，外层应用不需要传入
*/
 var templateOrginalData ; 
 function templateChoose(callback,moduleType,isMul,accountId,scope,excludeTemplateIds,reportId){
	  var ur='<c:url value="/template/template.do?method=templateChooseMul&isComponent=Y"/>';
      if(typeof(moduleType)!='undefined' && moduleType != null) ur+="&moduleType="+moduleType;
      if(typeof(isMul)!='undefined' && isMul!= null) ur+="&isMul="+isMul;
      if(typeof(accountId)!='undefined' && accountId != null) ur+="&accountId="+accountId;
      if(typeof(scope)!='undefined' && scope != null) ur+="&scope="+scope;
      if(typeof(excludeTemplateIds)!='undefined' && excludeTemplateIds != null ) ur+="&excludeTemplateIds="+excludeTemplateIds;
      if(typeof(reportId)!='undefined' && reportId != null) ur+="&reportId="+reportId;
      var ids = "";
      var names = "";
      if(typeof(templateOrginalData)!='undefined' && templateOrginalData != null ){ 
    	  ids = templateOrginalData["ids"];
    	  names = templateOrginalData["names"];
      }
	  var dialog = $.dialog({
          url : ur,
          title: "${ctp:i18n('template.templateJs.selectTemplate')}", //选择模版
          width: 580,
          height: 450,
          transParams: {'_tids':ids , '_tnames':names},
          targetWindow:getCtpTop(),
          buttons: [{
              text: "${ctp:i18n('collaboration.pushMessageToMembers.confirm')}", //确定
              handler: function () {
                templateOrginalData = dialog.getReturnValue();
            	if(templateOrginalData["ids"].length<1){
                    //您至少需要选择一个模版!
            	    $.alert("${ctp:i18n('template.templateJs.leastSelectTemplate')}");
            		return;
            	}
              	if(callback){
              		callback(templateOrginalData["ids"],templateOrginalData["names"],templateOrginalData["namesDisplay"]);
              	}
                 dialog.close();
              }
          }, {
              text: "${ctp:i18n('collaboration.pushMessageToMembers.cancel')}", //取消
              handler: function () {
                  dialog.close();
              }
          }],
          minParam: {
              show: false
          },
          maxParam: {
              show: false
          }
      }); 
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