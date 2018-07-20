<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp" %>
<%@include file="projectHeader.jsp"%>

<c:set value="${v3x:hasMenu('F02_planListHome')}" var="hasNewPlan" />
<c:set value="${v3x:hasMenu('F02_taskPage')}" var="hasNewTask" />
<c:set value="${v3x:hasMenu('F02_eventlist')}" var="hasNewCal" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/decorations/layout/D2-M_5-5_T/css/styles.css${v3x:resSuffix()}" />">
<style type="text/css">
.messageReplyDiv .replyDiv {
	position: absolute;
	z-index: 10;
	border: 1px #ccc solid;
	right: 0;
	bottom: 28px;
	padding:5px;
	background: #F7F7F7;
}
.mxt-grid-header{
	background: #ffffff;
}
.project-layout-TwoColumns 
{ 
float: left; 
border: 0px solid blue; 
width: 100%; 
} 
.project-layout-TwoColumns #banner 
{ 
width: 100%; 
float: left; 
display: inline; 
border: 0px solid red; 
} 
.project-layout-TwoColumns #column0 
{ 
width: 49.9%; 
_width: 49.6%; 
float: left; 
} 
.project-layout-TwoColumns #column1 
{ 
width: 49.5%; 
float: right; 
margin-left: 4px; 
position:relative; 
_position:static; 
right:2px; 
right:0px\9; 
}
</style>
<script type="text/javascript" charset="UTF-8" src="<c:url value="apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
<!--
// getA8Top().hiddenNavigationFrameset();//隐藏当前位置

// 系统类型的打开
function openPigeonholeDetail(appEnumKey, sourceId, docId,openFrom) {

    var jsColURL = "/seeyon/collaboration/collaboration.do";
    var jsMeetingURL = "/seeyon/mtMeeting.do";
    var jsPlanURL = "/seeyon/plan.do";
    var jsMailURL = "/seeyon/webmail.do";
    var jsNewsURL = "/seeyon/newsData.do";
    var jsBulURL = "/seeyon/bulData.do";
    var jsEdocURL = "/seeyon/edocController.do";
    var jsInquiryURL = "/seeyon/inquirybasic.do";
    var infoURL="/seeyon/infoDetailController.do";
    var infoStatURL="/seeyon/infoStatController.do";
    
    var dialogType = "modal";
    var data = new appEnumData();
    // 判断是不是以模态对话框打开
    //var isModel = getA8Top().window.dialogArguments;
    // 归档源是否存在的判断
    var existFlag = pigeonholeSourceExist(appEnumKey, sourceId);
    if(existFlag == 'false') {
        alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
        return;
     }
    // 访问次数
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
         "accessOneTime", false);
    requestCaller.addParameter(1, "Long", docId);
    requestCaller.serviceRequest();
    
    _url = "";
    
    if(appEnumKey == data.collaboration || appEnumKey == data.edoc) {
        var ret = "200";
        if(openFrom=="lenPotent") {
            var requestCaller = new XMLHttpRequestCaller(this, "docAclManager", "getEdocBorrowPotent", false);
            requestCaller.addParameter(1, "long", docId);               
            ret = requestCaller.serviceRequest();
        } else {
            if(appEnumKey == data.edoc) {
                var requestCaller = new XMLHttpRequestCaller(this, "docAclManager", "getEdocSharePotent", false);
                requestCaller.addParameter(1, "long", docId);               
                ret = requestCaller.serviceRequest();
            }
            else {
                ret = "111";
            }
        }
        
        if(appEnumKey == data.collaboration) {
            _url = jsColURL + "?method=detail&from=Done&affairId=" + sourceId + "&type=doc&docId=" + docId + "&lenPotent=" + ret + "&openFrom=" + openFrom;
        }
        else {
            if(openFrom!=null){
                _url = jsEdocURL + "?method=edocDetailInDoc&openFrom="+openFrom+"&summaryId=" + sourceId+"&lenPotent="+ret+"&docId="+docId+"&isLibOwner="+isLibOwner;
            }
            else {
                _url = jsEdocURL + "?method=edocDetailInDoc&openFrom="+openFrom+"&summaryId=" + sourceId+"&lenPotent="+ret+"&docId="+docId; 
            }
        }
    }
    else if(appEnumKey == data.meeting){
        _url = jsMeetingURL + "?method=mydetail&id=" + sourceId+"&fromdoc=1";
    }else if(appEnumKey == data.plan){
        _url = jsPlanURL + "?method=initDetailHome&editType=doc&id=" + sourceId;
    }else if(appEnumKey == data.mail){
        _url = jsMailURL + "?method=showMail&id=" + sourceId;
    }else if(appEnumKey == data.inquiry){
        _url = jsInquiryURL + "?method=showInquiryFrame&bid=" + sourceId+"&fromPigeonhole=true";
    }else if(appEnumKey == data.news){
        _url = jsNewsURL + "?method=userView&id=" + sourceId+"&fromPigeonhole=true";
    }else if(appEnumKey == data.bulletin){
        _url = jsBulURL + "?method=userView&id=" + sourceId+"&fromPigeonhole=true";
    }else if(appEnumKey == data.info){
        _url = infoURL + "?method=detail&summaryId=" + sourceId + "&affairId=&from=Done";
    }else if(appEnumKey == data.infoStat){
        _url = infoStatURL + "?method=showStatResult&id=" + sourceId;
    }
    var rv = v3x.openWindow({
        url: _url,
        workSpace : 'yes',
        resizable : "false",
        dialogType :dialogType
    });
    if(rv == true || rv == 'true') {
        try {
            window.location.href = window.location;
        } catch(e) {}
    }
}

// 归档源存在的判断
function pigeonholeSourceExist(appEnumKey, sourceId){
    try {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
             "hasPigeonholeSource", false);
        requestCaller.addParameter(1, "Integer", appEnumKey);
        requestCaller.addParameter(2, "Long", sourceId);
        var flag = requestCaller.serviceRequest();
        return flag;
    } catch (ex1) {
        return 'false';
    }
}

function appEnumData() {
    this.global = '0'; // 全局
    this.collaboration = '1'; // 协同应用
    this.form = '2'; // 表单
    this.doc = '3'; // 知识管理
    this.edoc = '4'; // 公文
    this.plan = '5'; // 计划
    this.meeting = '6'; // 会议
    this.bulletin = '7'; // 公告
    this.news = '8'; // 新闻
    this.bbs = '9'; // 讨论
    this.inquiry = '10'; // 调查
    this.mail = '12'; // 邮件
    this.organization = '13'; // 组织模型
    this.info = '32'; // 信息报送
    this.infoStat = '33'; // 信息报送统计
}

//得到打开类型
function docOpenType(id) {
    try {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
             "getTheOpenType", false);
        requestCaller.addParameter(1, "Long", id);
        var flag = requestCaller.serviceRequest();
        return flag;
    } catch (ex1) {
        alert("Exception : " + ex1.message);
    }
}


function setPortalLayoutCenterDiv(){
	try{
		var browser=navigator.appName;
		var b_version=navigator.appVersion;
		var version=b_version.split(";"); 
		var trim_Version=version[1].replace(/[ ]/g,""); 
		var right_div_portal_sub = document.getElementById('right_div_portal_sub');
		var rightChildList = null;
		var contentHeight = 0;
		var isScroll = false;
		if(right_div_portal_sub){
			right_div_childList = right_div_portal_sub.getElementsByTagName('div');
			var right_div_portal_childs = right_div_portal_sub.childNodes;
			rightChildList = new Array();
			if(right_div_portal_childs.length>0){
				for(var i = 0;i<right_div_portal_childs.length;i++){
					var tempobj = right_div_portal_childs[i];
					if(tempobj!=null && tempobj!=undefined && tempobj.tagName!=null && tempobj.tagName.toUpperCase() == 'DIV'){
						contentHeight+=parseInt(tempobj.clientHeight);
						rightChildList.push(tempobj);
					}
				}
			}
		}
		if(rightChildList.length>0){
			if(contentHeight>document.body.clientHeight){isScroll = true;}
			if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE6.0"){ 
				right_div_portal_sub.style.width = (parseInt(document.body.clientWidth));
				for(var j = 0; j<rightChildList.length; j++){
					var temp = rightChildList[j];
					if(isScroll){
						temp.style.width = (parseInt(document.body.clientWidth)-23);
					}else{
						temp.style.width = parseInt(document.body.clientWidth)-3;
					}
				}
			}else if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE7.0"){ 
				right_div_portal_sub.style.width = parseInt(document.body.clientWidth)-1;
				for(var j = 0; j<rightChildList.length; j++){
					var temp = rightChildList[j];
					if(isScroll){
						temp.style.width = parseInt(document.body.clientWidth)-20;
					}else{
						temp.style.width = parseInt(document.body.clientWidth)-13;
					}
				}
			}else{
				right_div_portal_sub.style.width = parseInt(document.body.clientWidth)-1;
				for(var j = 0; j<rightChildList.length; j++){
					var temp = rightChildList[j];
					if(isScroll){
						temp.style.width = parseInt(document.body.clientWidth)-23;
					}else{
						temp.style.width = parseInt(document.body.clientWidth)-3;
					}
				}
			} 
		}
	}catch(e){}
}
function addportalLayoutResize(){
	var right_div_portal_sub = document.getElementById('right_div_portal_sub');
	if(document.all){
		if(right_div_portal_sub)right_div_portal_sub.attachEvent("onresize",setPortalLayoutCenterDiv);
		if(right_div_portal_sub)right_div_portal_sub.attachEvent("onfocus",setPortalLayoutCenterDiv);
		window.attachEvent("onresize",setPortalLayoutCenterDiv);
		window.attachEvent("onfocus",setPortalLayoutCenterDiv);
    }else{
    	if(right_div_portal_sub)right_div_portal_sub.addEventListener("resize",setPortalLayoutCenterDiv,false);
    	if(right_div_portal_sub)right_div_portal_sub.addEventListener("focus",setPortalLayoutCenterDiv,false);
    	window.addEventListener("resize",setPortalLayoutCenterDiv,false);
    	window.addEventListener("focus",setPortalLayoutCenterDiv,false);
	}
}
function initPortalLayout(){
	addportalLayoutResize();
	setTimeout(function(){setPortalLayoutCenterDiv();},500);
	
}
var dNum=1;
function exist(){
	var exist = '${exist}';
	if('false' == exist){	
		alert(v3x.getMessage("ProjectLang.project_is_null_alert"));
		getA8Top().contentFrame.topFrame.backToPersonalSpace();
    }
	showCtpLocation("F02_projectPersonPage");
	initPortalLayout();
	try{//插件判定，只有安装了才显示
		var pw=getA8Top();
		var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
		pw.installDoc= ocxObj.WebApplication(".doc");
		pw.installXls=ocxObj.WebApplication(".xls");
		pw.installWps=ocxObj.WebApplication(".wps");
		pw.installEt=ocxObj.WebApplication(".et");
		}catch(e){
			pw.installDoc=false;
			pw.installXls=false;
			pw.installWps=false;
			pw.installEt=false;
		}
		if(pw.installDoc){
			document.getElementById("newWord").style.display='';
			++dNum;
		}
		if(pw.installXls){
			document.getElementById("newXls").style.display='';
			++dNum;
		}
		if(pw.installWps){
			document.getElementById("newWpsWord").style.display='';
			++dNum;
		}
		if(pw.installEt){
			document.getElementById("newWpsXls").style.display='';
			++dNum;
		}
}
	
function showProjectDetail(){
	 var projectIdvalue = document.getElementById("hiddenProjectId").value;
	 window.showModalDialog("${basicURL}?method=showprojectDetail&projectId="+projectIdvalue,window,"DialogHeight:450px;DialogWidth:400px;status=no;");
}

function dealCol(url){
    //var rv = v3x.openWindow({
    //    url: url,
    //    workSpace: 'yes'
    //});
	//location.reload(true);
	openCtpWindow({'url':url});
}

/**
 * 上传文件
 */
function fileUpload(){
	var docResId = window.docResId;
	var docLibId = window.docLibId;
	var docLibType = window.docLibType;
	var parentCommentEnabled = window.parentCommentEnabled;
	var parentVersionEnabled = window.parentVersionEnabled;
	fileUploadQuantity = 5;
	fileUploadAttachments.clear();
	insertAttachment(null, null, 'callbackInsertAtt', 'false');
}

function callbackInsertAtt(){
	if(fileUploadAttachments.isEmpty() == false) {
		saveAttachment();
		var theForm = document.getElementById("mainForm");
		theForm.target = "uploadIframe";
		theForm.action = "${docURL}?method=docUpload&projectId=${projectCompose.projectSummary.id}&projectPhaseId=${phaseId}";
		theForm.submit();
	}
}



/**
 * 查看事件
 */
function openCal(id){
	  var newurl = "<html:link renderURL='/calendar/calEvent.do' />?method=editCalEvent&id=" + id+'&randoNmumber='+Math.random();
	  window.showModalDialog(newurl,window,'dialogHeight:450px;dialogWidth:580px;status:no;scroll:no;help:no');  
}

/**
 * 打开页面
 */
function openDetailURL(URL){
	
   	//var rv = v3x.openWindow({
	//    url: URL,
	//    workSpace: 'yes'
    //});
   	//setTimeout("window.location.href = window.location.href;",300);
	openCtpWindow({'url':URL});
}

function hideDiv(obj){
   obj.style.display="none";
}

function showDiv(obj){
   obj.style.display="block";
}

function autoReply_moveOut(divId){
	document.getElementById(divId).style.display='none';
}

function autoReply(divId){
    if(document.getElementById(divId).style.display=='block'){
       document.getElementById(divId).style.display='none';
    }else{
       document.getElementById(divId).style.display='block';
    }
}
   
function autoReply_m(obj,divId,num){
	var postionX = parseInt(obj.getBoundingClientRect().left) ;
	var postionY = parseInt(obj.getBoundingClientRect().top) ;    
	var menu = document.getElementById(divId);
	if(num==1){
		menu.style.top = (postionY - 115)+"px";
		menu.style.left = (postionX - 42)+"px";
	}else if(num==2){
		menu.style.top = (postionY - 100)+"px";
		menu.style.left = (postionX - 25)+"px";
	}else if(num==3){
		menu.style.height=(dNum*25 + 5)+'px';
		menu.style.top = (postionY - dNum*25 - 5)+"px";
		menu.style.left = (postionX - 25)+"px"; 
	}
	menu.style.display='block';
}

function forwardCol(summaryId, affairId, forwardType, canForward) {
    if(canForward == true || canForward == "true") {
        forwardColV3X(summaryId, affairId, forwardType);
    } else {
        alert(v3x.getMessage("collaborationLang.unallowed_forward_affair"));
    }
    
}
//模板
var paramValue = "${projectCompose.projectSummary.templates}";

function fnRefreshDocProjectInfo() {
	getA8Top().reFlesh();
}

//-->
</script>
<style>
.sectionTitle{margin-left: 5px;}
.portal-layout-cell{
    border:1px solid #B6B6B6;
    margin-bottom: 10px;
}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=knowledgePageManager,knowledgeManager,docHierarchyManager"></script>
</head>
<%-- 原先在body标签里面但没有找到所以注掉 onkeydown="replyKeyAction(event)" --%>
<body scroll="no" onload="exist()">
<c:set var="hasNewColl" value="${v3x:hasNewCollaboration()}"/>
	<div class="main_div_center">
		<div class="right_div_center">
			<div id="right_div_portal_sub" class="center_div_center">
				<div class="banner-layout">
					<%@ include file="projectBanner.jsp"%>
				</div>
                <c:if test="${banben != true }">
    				<div class="project-layout-TwoColumns">
    					<div id="column0" class="portal-layout-column">
    						<div class="portal-layout-cell">
    							<%@ include file="projectCol.jsp"%>
    						</div>
    						<div class="portal-layout-cell">
    							<%@ include file="projectPlanMeetingEvent.jsp" %>
    						</div>
    						<div class="portal-layout-cell">
    							<%@ include file="projectBbs.jsp"%>
    						</div>
    					</div>
    					
    					<div id="column1" class="portal-layout-column">
                            
                                <div class="portal-layout-cell">
                                     <%@ include file="projectTasks.jsp"%>
                                 </div>
                            
    						<div class="portal-layout-cell">
    							<c:if test="${hasDoc == 'yes' }">
                                    <%@ include file="projectDoc.jsp"%>
                                </c:if>
    						</div>
    						<div class="portal-layout-cell">
    							<%@ include file="projectLeaveWord.jsp"%>
    						</div>
    					</div>
    				</div>
                </c:if>
                <c:if test="${banben == true }">
                    <div class="project-layout-TwoColumns">
                        <div id="column0" class="portal-layout-column">
                            <div class="portal-layout-cell">        
                                <%@ include file="projectCol.jsp"%>
                            </div>
                            <div class="portal-layout-cell">
                                <c:if test="${hasDoc == 'yes' }">
                                    <%@ include file="projectDoc.jsp"%>
                                </c:if>
                            </div>
                          
                        </div>
                        <div id="column1" class="portal-layout-column">
                            <div class="portal-layout-cell">
                                <%@ include file="projectPlanMeetingEvent.jsp" %>
                            </div>
                            <div class="portal-layout-cell">
                                <%@ include file="projectBbs.jsp"%>
                            </div>
                        </div>
                         <div id="column2" class="portal-layout-column portal-layout-cell">
                            <%@ include file="projectLeaveWord.jsp"%>
                        </div>
                    </div>
                </c:if>
			</div>
		</div>
	</div>

	<iframe height="0%" name="empty" width="0%" frameborder="0"></iframe>
	
	<!------------项目协同模板----------->
	<div oncontextmenu="return false" onmouseout="hideDiv(this)"  onmouseover="showDiv(this)" style="position:absolute; left:162px; top:195px; width:120px; height:120px; z-index:2; background-color: #ffffff;display:none;overflow:yes;text-align:left" id="divAutoReply3">
		<span id="spanAutoReply3" style="position:absolute; left:0px; top:2px; width:120px; height:115px; z-index:3; background-color: #f9f8f7;border:1px solid #000000;overflow:auto;filter:progid:DXImageTransform.Microsoft.Shadow(color=#aaaa99,direction=130,strength=6)">
			<table border="0">
				<tr height="40%">
					<td height="40" valign="top">
						<c:if test="${fn:length(colTempleteList)>0}">
							<c:forEach items="${colTempleteList}" var="ctl">
								<a href="${colURL}?method=newColl&templeteId=${ctl.id}" target="_self">${ctl.subject}</a><br>
							</c:forEach>
						</c:if>
					</td>
				</tr>
			</table>
		</span>
	</div>
	<!------------新增文挡类型----------->
	<div oncontextmenu="return false" onMouseOut="hideDiv(this)"  onmouseover="showDiv(this)" style="position:absolute; right:125px; width:85px; z-index:2; background-color: #ffffff;display:none;overflow:yes;text-align:left" id="divAutoReply">
		<span id="spanAutoReply" class="common_drop_list" style="position:absolute; left:0px; top:2px; width:85px; height:100%; z-index:3; background-color:#ffffff;border:1px solid #c7c7c7;overflow:auto;">
			<table border="0">
				<tr>
					<td><a href="${docURL}?method=addDocIndex&projectId=${projectCompose.projectSummary.id}&projectPhaseId=${phaseId}&bodyType=HTML"><fmt:message key='project.new.ducument.label' /></a></td>
				</tr>
				<tr id='newWord' style="display:none">
					<td><a href="${docURL}?method=addDocIndex&projectId=${projectCompose.projectSummary.id}&projectPhaseId=${phaseId}&bodyType=OfficeWord"><fmt:message key='project.new.word.label' /></a></td>
				</tr>
			
				<tr id = 'newXls' style="display:none">
					<td><a href="${docURL}?method=addDocIndex&projectId=${projectCompose.projectSummary.id}&projectPhaseId=${phaseId}&bodyType=OfficeExcel"><fmt:message key='project.new.excel.label' /></a></td>
				</tr>
				<tr id='newWpsWord' style="display:none">
					<td><a href="${docURL}?method=addDocIndex&projectId=${projectCompose.projectSummary.id}&projectPhaseId=${phaseId}&bodyType=WpsWord"><fmt:message key='common.body.type.wpsword.label' bundle='${v3xCommonI18N}' /></a></td>
				</tr>
				<tr id = 'newWpsXls' style="display:none">
					<td><a href="${docURL}?method=addDocIndex&projectId=${projectCompose.projectSummary.id}&projectPhaseId=${phaseId}&bodyType=WpsExcel"><fmt:message key='common.body.type.wpsexcel.label' bundle='${v3xCommonI18N}' /></a></td>
				</tr>
			</table>
		</span>
	</div>
	<form action="" name="mainForm" id="mainForm"  method="post">
		<div id="UploadDiv" style="visibility:hidden"><div><v3x:fileUpload applicationCategory="3" /></div></div>
		<script>
			var fileUploadQuantity = 5;
		</script>
	</form>
	<iframe name="uploadIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
	<style>
	.common_drop_list td{height:22px;}
	.common_drop_list a{color:#000;display:block; padding:3px; }
	.common_drop_list a:hover{background:#d2d2d2;}
	</style>
	<!------------新增计划类型----------->
	<div oncontextmenu="return false" onMouseOut="hideDiv(this)"  onmouseover="showDiv(this)" style="position:absolute; left:132px; top:470px; width:85px; height:80px; z-index:2; background-color: #ffffff;display:none;overflow:yes;text-align:left" id="divAutoReply2">
		<span id="spanAutoReply2" class="common_drop_list" style="position:absolute; left:0px; top:2px; width:85px; height:100px; z-index:3; background-color: #fff;border:1px solid #c7c7c7;overflow:auto;">
			<table border="0">
				<tr>
					<td><a href="${planURL}?method=newPlan&type=1&relateProject=${projectCompose.projectSummary.id}&phaseId=${phaseId}"><fmt:message key='project.palntype.day.label' /></a></td>
				</tr>
			
				<tr>
					<td><a href="${planURL}?method=newPlan&type=2&relateProject=${projectCompose.projectSummary.id}&phaseId=${phaseId}"><fmt:message key='project.palntype.week.label' /></a></td>
				</tr>
			
				<tr>
					<td><a href="${planURL}?method=newPlan&type=3&relateProject=${projectCompose.projectSummary.id}&phaseId=${phaseId}"><fmt:message key='project.palntype.month.label' /></a></td>
				</tr>
			
				<tr>
					<td><a href="${planURL}?method=newPlan&type=4&relateProject=${projectCompose.projectSummary.id}&phaseId=${phaseId}"><fmt:message key='project.palntype.anyscope.label' /></a></td>
				</tr>
			</table>
		</span>
	</div>
</body>
</html>