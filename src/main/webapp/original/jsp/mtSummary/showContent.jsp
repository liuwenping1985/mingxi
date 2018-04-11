<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="../meeting/include/taglib.jsp" %>
<%@ include file="../meeting/include/header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>">
<script type="text/javascript">

//重新计算高度
function _resizeWindow(){
	var officeFrameDiv = document.getElementById("officeFrameDiv");
    var summaryContentDIV = document.getElementById("summaryContentDIV");
    if(officeFrameDiv && typeof(officeFrameDiv.offsetTop)!="undefined"&&officeFrameDiv.offsetTop!=null){
		try{
			var cHeight = document.documentElement.clientHeight;
           	if (cHeight == 0) {
             	cHeight = document.body.clientHeight;
           	}
           
           	if(v3x.isFirefox && cHeight<document.body.clientHeight){
          	 	cHeight = document.body.clientHeight;
           	}
           	var officeFrameDivHeight = cHeight - officeFrameDiv.offsetTop;
           	summaryContentDIV.style.display = "none";
           	summaryContentDIV.style.height = (officeFrameDivHeight-19) + "px";
           	summaryContentDIV.style.display = "";
        } catch(e) {}
	}
}
	
//会议总结转发协同
function summaryToCol() {
	var parentObj = getA8Top().window.dialogArguments;
			
	//判断会议总结是否存在   做防护
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtSummaryTemplateManager", "isMeetingSummaryExist", false);
	requestCaller.addParameter(1, "Long", '${bean.id}');
	var ds = requestCaller.serviceRequest();
	if(ds=='false') {
		alert(v3x.getMessage("meetingLang.meeting_has_delete"));
		return;
	}
			
	if(parentObj) {
		var a8Top = parentObj.getA8Top().window.dialogArguments;
		if(a8Top){
			a8Top.parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
		} else {
			parentObj.getA8Top().parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
		}
		parentObj.close();
		window.close();
	} else {
		parent.parent.parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
	}
}
		
function _init_() {
	try {
		if(window.trans2Html){
			//HTML正文，进行转换后的正文高度计算
			resetTransOfficeHeight("summaryContentDIV", "summaryContentDIV");
		} else {
			_resizeWindow();
            //添加事件
			window.onresize = _resizeWindow;
        }
    } catch(e) {}
}
</script>

</head>
<body class="body-bgcolor" style="overflow: auto;" onload="_init_()">

<v3x:attachmentDefine attachments="${attachments}" />

<div id="summaryContentDIV" style="width: 100%;height: auto">
    <v3x:showContent content="${mtSummary.content}" type="${mtSummary.dataFormat}" createDate="${mtSummary.createDate}" htmlId="col-contentText" />
</div>

<div class="body-line-sp"></div>

</body>
</html>