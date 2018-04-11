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
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<script type="text/javascript">
<!--
/**
 * 将Word正文转化为PDF
 */
function transformWordToPdf(newPdfId){
        try{
          document.getElementById("content").value = fileId;
        }catch(e){}
        var zwIframe = null;
        if(v3x.isFirefox){
        	zwIframe = window.componentDiv.document.getElementById("zwIframe").contentWindow;
    	}else{
    		zwIframe = componentDiv.zwIframe;
    	}
        
        var flag = zwIframe.transformWordToPdf(newPdfId);
        return flag;
}
/**
 * 协同转新闻
 * @param summaryId 协同ID
 * @param affairId 事项ID
 * @param bodyType 正文类型
 * @param callback 回调函数（由调用方处理）
 * @returns {Number}
 */
function newsIssue(summaryId,affairId,bodyType,callback,rightId,failed_callback){
	if( !newsIssueAuthority() ){
		alert("${ctp:i18n('news.issue.notAuthority')}");
		if(typeof(failed_callback) == 'function'){
	    	 failed_callback();
	    }
		return false;
	}
    var dialog = $.dialog({
      htmlId : "issueNews",
      title : "${ctp:i18n('news.issue.dialog.title')}",
      height:450,
      width:400,
      targetWindow:top,
      url:_ctxPath+'/newsIssue.do?method=preIssue&summaryId='+summaryId+"&affairId="+affairId+"&bodyType="+bodyType+"&entry=0",
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
      buttons : [ {
          text : "${ctp:i18n('news.issue.dialog.ok')}",
          handler : function() {
    	  	var rv = dialog.getReturnValue();
    	  	if( rv && rv.length==10 ){
                var pdfFileId = "";

                if( rv[5]=="1" && rv[6]=="OfficeWord"){
                    pdfFileId = getUUID();
                    transformWordToPdf(pdfFileId);
                }
	    	 	
	    	 	issueNewsBack_Properties.put("rv0", rv[0]);
	    	 	issueNewsBack_Properties.put("rv1", rv[1]);
	    	 	issueNewsBack_Properties.put("rv2", rv[2]);
	    	 	issueNewsBack_Properties.put("rv3", rv[3]);
	    	 	issueNewsBack_Properties.put("rv4", rv[4]);
	    	 	issueNewsBack_Properties.put("rv5", pdfFileId);
	    	 	issueNewsBack_Properties.put("rv6", rv[7]);
	    	 	issueNewsBack_Properties.put("rv7", rv[8]);
	    	 	issueNewsBack_Properties.put("rv8", rightId);
	    	 	issueNewsBack_Properties.put("rv9", rv[9]);
	            dialog.close();
	            
	            //此方法需要由接口调用者实现，例如保存协同
	            if(callback){
                    callback(issueNewsBack);
                }
	          }
          }
        }, {
          text : "${ctp:i18n('news.issue.dialog.cancel')}",
          handler : function() {
        	try{
        	    failed_callback();
        	} catch (e) {
        	}
            dialog.close();
          }
        } ]
    });
}
var issueNewsBack_Properties = new Properties();
function issueNewsBack() {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsIssueManager", "issueNews", false);
    requestCaller.addParameter(1, "String", issueNewsBack_Properties.get("rv0"));
    requestCaller.addParameter(2, "String", issueNewsBack_Properties.get("rv1"));
    requestCaller.addParameter(3, "String", issueNewsBack_Properties.get("rv2"));
    requestCaller.addParameter(4, "String", issueNewsBack_Properties.get("rv3"));
    requestCaller.addParameter(5, "String", issueNewsBack_Properties.get("rv4"));
    requestCaller.addParameter(6, "String", issueNewsBack_Properties.get("rv5"));
    requestCaller.addParameter(7, "String", issueNewsBack_Properties.get("rv6"));
    requestCaller.addParameter(8, "String", issueNewsBack_Properties.get("rv7"));
    requestCaller.addParameter(9, "String", issueNewsBack_Properties.get("rv8"));
    requestCaller.addParameter(10, "String", issueNewsBack_Properties.get("rv9"));
    var result = requestCaller.serviceRequest();
}

/**
 * 判断当前登陆用户是否有发布权限
 * @returns true/false
 */
function newsIssueAuthority(){
  return callBackendMethod("newsIssueManager","hasAuthority");
}
//-->
</script>