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
if( v3x ){
	v3x.loadLanguage("/apps_res/bulletin/js/i18n");
}

/**
 * 公文转公告
 * @param summaryId 协同ID
 * @param bodyType 正文类型
 * @param callback 回调函数（由调用方处理）
 * @returns {Number}
 */
var edocBulletinIssueItem = {};
function edocBulletinIssue(summaryId,bodyType,callback,type){
	edocBulletinIssueItem.callback = callback;
	edocBulletinIssueItem.summaryId = summaryId;
	edocBulletinIssueItem.type = type;
	edocBulletinIssueItem.bodyType = bodyType;
    if( !bulletinIssueAuthority() ){
        alert( _("bulletin.not_purview") );
        return false;
    }

    if (getA8Top().$ && getA8Top().$.dialog) {
      getA8Top().edocBulletinIssueWin = getA8Top().$.dialog({
          title:"${ctp:i18n('select.space.type')}",
          transParams:{'parentWin':window},
          url: "/seeyon/bulIssue.do?method=preIssue&summaryId="+summaryId+"&bodyType="+bodyType+"&entry=1&outworkerPanel=1",
          width: 400,
          height: 485,
          isDrag:false
      });
  	} else {
        getA8Top().edocBulletinIssueWin = getA8Top().v3x.openDialog({
            title:"${ctp:i18n('select.space.type')}",
            transParams:{'parentWin':window},
            url: "/seeyon/bulIssue.do?method=preIssue&summaryId="+summaryId+"&bodyType="+bodyType+"&entry=1&outworkerPanel=1",
            width: 400,
            height: 485,
            isDrag:false
        });
    }
}


function edocBulletinIssueCallBackFun(returnValue) {
	getA8Top().edocBulletinIssueWin.close();
	var isSuccess = true;
    if( returnValue && returnValue.length==6 ){
        //word转pdf
        var pdfFileId = "";
        if( returnValue[3] && returnValue[3]==1 ) {
            pdfFileId = getUUID();
            transformWordToPdf(pdfFileId);
        }
        var requestCaller;
		if(edocBulletinIssueItem.type == "edoc"){
			requestCaller = new XMLHttpRequestCaller(this, "ajaxBulIssueManager", "issueEdocBulletion", false);
		}else if(edocBulletinIssueItem.type == "govdoc"){
			requestCaller = new XMLHttpRequestCaller(this, "ajaxBulIssueManager", "issueGovdocBulletion", false);
		}
        requestCaller.addParameter(1, "String", edocBulletinIssueItem.summaryId);
        requestCaller.addParameter(2, "String", edocBulletinIssueItem.bodyType);
        requestCaller.addParameter(3, "String", returnValue[0]);
        requestCaller.addParameter(4, "String", returnValue[1]);
        requestCaller.addParameter(5, "String", returnValue[2]);
        requestCaller.addParameter(6, "String", pdfFileId);
        requestCaller.addParameter(7, "String", returnValue[4]);
        requestCaller.addParameter(8, "String", returnValue[5]);

        var result = requestCaller.serviceRequest();
        
        isSuccess = true;
    }else{
        isSuccess = false;
    }


    if( edocBulletinIssueItem.callback ){
    	edocBulletinIssueItem.callback( isSuccess );
    }
}

/**
 * 判断当前登陆用户是否有发布权限
 * @returns true/false
 */
function bulletinIssueAuthority(){
  var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulIssueManager", "hasAuthority", false);
  var hasAuthority = requestCaller.serviceRequest();
  return hasAuthority;
}
//-->
</script>