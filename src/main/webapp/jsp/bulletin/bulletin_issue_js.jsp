<%--
/**
 * $Author: renjia $
 * $Rev: 15711 $
 * $Date:: 2013-03-08 15:42:15#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
<!--
/**
 * 将Word正文转化为PDF
 */
function transformWordToPdf(newPdfId){
        try{
          document.getElementById("content").value = fileId;
        }catch(e){}
        var bodyType = "${bodyType}";
        //只能转化Word或者WPS正文
        if(bodyType != 'OfficeWord' && bodyType != 'WpsWord'){
           return true;
        } 
        var zwIframe = null;
        if(v3x.isFirefox){
        	zwIframe = window.componentDiv.document.getElementById("zwIframe").contentWindow;
    	}else{
    		zwIframe = componentDiv.zwIframe;
    	}
        var flag = zwIframe.officeEditorFrame.transformWordToPdf(newPdfId);
        return flag;
}
/**
 * 协同转公告
 * @param summaryId 协同ID
 * @param affairId 事项ID
 * @param bodyType 正文类型
 * @param callback 回调函数（由调用方处理）
 * @returns 
 */
 function bulletinIssue(summaryId,affairId,bodyType,callback,rightId,failed_callback){
   if( !bulletinIssueAuthority() ){
       alert("${ctp:i18n('bulletin.issue.notAuthority')}");
       if(typeof(failed_callback) == 'function'){
    	   failed_callback();
       }
       return false;
   }
   var dialog = $.dialog({
     htmlId : "issueBull",
     title : "${ctp:i18n('bulletin.issue.dialog.title')}",
     height:450,
     width:400,
     targetWindow:top,
     url:_ctxPath+'/bulIssue.do?method=preIssue&summaryId='+summaryId+"&affairId="+affairId+"&bodyType="+bodyType+"&entry=0&outworkerPanel=1",
     closeParam : {
         'show':true,
         'autoClose':false,
         handler:function(){
             try{
                 failed_callback();
             } catch (e) {
             }
             dialog.close();
        }  
     },
     buttons : [{
         text : "${ctp:i18n('bulletin.issue.dialog.ok')}",
         handler : function() {
           var rv = dialog.getReturnValue();
           if( rv && rv.length==6 ){
               var pdfFileId = "";

               if( rv[3]=="1" ){
                   pdfFileId = getUUID();
                   transformWordToPdf(pdfFileId);
               }
               
               issueBullBack_Properties.put("rv0", summaryId);
               issueBullBack_Properties.put("rv1", affairId);
               issueBullBack_Properties.put("rv2", bodyType);
               issueBullBack_Properties.put("rv3", rv[0]);
               issueBullBack_Properties.put("rv4", rv[1]);
               issueBullBack_Properties.put("rv5", rv[2]);
               issueBullBack_Properties.put("rv6", pdfFileId);
               issueBullBack_Properties.put("rv7", rightId);
               issueBullBack_Properties.put("rv8", rv[4]);
               issueBullBack_Properties.put("rv9", rv[5]);
               
               //此方法需要由接口调用者实现，例如保存协同
               if(callback){
                   callback(issueBullBack);
               }
           }
           if(rv != false){
               dialog.close();
           }
         }
       }, {
         text : "${ctp:i18n('bulletin.issue.dialog.cancel')}",
         handler : function() {
          try{
              failed_callback();
          } catch (e) {
          }
           dialog.close();
         }
       }]

   });
}
var issueBullBack_Properties = new Properties();
function issueBullBack() {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulIssueManager", "issueBulletion", false);
    requestCaller.addParameter(1, "String", issueBullBack_Properties.get("rv0"));
    requestCaller.addParameter(2, "String", issueBullBack_Properties.get("rv1"));
    requestCaller.addParameter(3, "String", issueBullBack_Properties.get("rv2"));
    requestCaller.addParameter(4, "String", issueBullBack_Properties.get("rv3"));
    requestCaller.addParameter(5, "String", issueBullBack_Properties.get("rv4"));
    requestCaller.addParameter(6, "String", issueBullBack_Properties.get("rv5"));
    requestCaller.addParameter(7, "String", issueBullBack_Properties.get("rv6"));
    requestCaller.addParameter(8, "String", issueBullBack_Properties.get("rv7"));
    requestCaller.addParameter(9, "String", issueBullBack_Properties.get("rv8"));
    requestCaller.addParameter(10, "String", issueBullBack_Properties.get("rv9"));
    
    var result = requestCaller.serviceRequest();
}
/**
 * 公文转公告
 * @param summaryId 协同ID
 * @param bodyType 正文类型
 * @param callback 回调函数（由调用方处理）
 * @returns {Number}
 */
function edocBulletinIssue(summaryId,bodyType,callback){
	if( !bulletinIssueAuthority() ){
		alert(issue_v3x.getMessage("bulletin.issue_not_auth"));
		return false;
	}
    var dialog = $.dialog({
        htmlId : 'issueBullEdoc',
        title : issue_v3x.getMessage("bulletin.issue_dialog_title"),
        height:450,
        width:400,
        targetWindow:top,
        url:_ctxPath+'/bulIssue.do?method=preIssue&summaryId='+summaryId+"&bodyType="+bodyType+"&entry=1&outworkerPanel=0",
        buttons : [ {
            text : issue_v3x.getMessage("bulletin.ok"),
            handler : function() {
      	  		var rv = dialog.getReturnValue();
      	  	
      	  		//此方法需要由接口调用者实现，例如保存公文
      	  		if(callback){
      	  			callback(rv);
      	  		}
      	  	
      	  		dialog.close();
            }
          }, {
            text : issue_v3x.getMessage("bulletin.calcel"),
            handler : function() {
              dialog.close();
            }
          } ]

      });
}

/**
 * 判断当前登陆用户是否有发布权限
 * @returns true/false
 */
function bulletinIssueAuthority(){
  var bulIssueManagerAjax = new bulIssueManager();
  var hasAuthority = bulIssueManagerAjax.hasAuthority();
  return hasAuthority;
}
//-->
</script>