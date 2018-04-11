<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>
<html>
<head>
<%@ include file="../common/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
<title><fmt:message key='${newEdoclabel}'/></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript"><!--

//给精灵弹出的窗口设置title参数。
if(typeof(parent.document.title)!="undefined")parent.document.title="<fmt:message key='${newEdoclabel}'/>";
var isNewColl = true ;
var isBoundSerialNo = "${isBoundSerialNo}";
var logoURL = "${logoURL}";
var processing=false;
var currentPage="newEdoc";//公文督办的时候，如果是新页面就不提交，否则提交到服务器。
//设置收文登记页面支持PDF正文。
var supportPdfMenu=('${appType}'=='20'?true:false);

var hasDiagram = <c:out value="${hasWorkflow}" default="false" />;        
var caseProcessXML = '${process_xml}';
var caseLogXML = "";
var caseWorkItemLogXML = "";
var currentNodeId = null;
var showHastenButton = "";
var appName="${appName}";
var isTemplete = false;
var templeteCategrory="${templeteCategrory}";
var defaultPermName="<fmt:message key='${defaultPermLabel}' bundle='${v3xCommonI18N}'/>";
//原始正文的ID，即联合发文的时候原始正文的ID.如果拟文的时候，联合发文需要套红的话就要使用此变量来调出服务器端保存的原始正文。
var oFileId=""; 
var draftTaoHong="";
var noDepManager = "${noDepManager}";
var isOnlySender = "${isOnlySender}";
if(isOnlySender != "true")
{
if(noDepManager == "true"){
	alert(_("edocLang.edoc_supervise_nodepartmentManager"));
}
}


var policys = null;
var nodes = null;

var unallowedSelectEmptyGroup_wf = true;


var isFromTemplate = <c:out value="${isFromTemplate}" default="false" />
var selfCreateFlow=${selfCreateFlow};
var templateType="${templateType}";
var showMode = 1;
showMode = ((isFromTemplate && templateType !='text') || selfCreateFlow==false) ? 0 : showMode;

var hiddenColAssignRadio_wf = true;
var editWorkFlowFlag = "true"
var actorId="${actorId}";

var jsEdocType=${formModel.edocSummary.edocType};

hasWorkflow = <c:out value='${hasWorkflow}' default='false'/>;
var selectedElements = null;
//var _canUpdateContent=${canUpdateContent};
var _canUpdateContent=false;

//对登记时正文本地保存的权限进行控制:有公文开关<外来公文登记是否允许修改>的权限 = 有本地保存的权限。
var officecanSaveLocal="${canUpdateContent}";

function edocFormDisplay(){
			/*if(!v3x.isMSIE){
				alert(_("edocLang.isNotIe"));
				window.location= "<c:url value='/edocController.do?method=entryManager&entry=recManager'/>";
			}*/
			canUpdateContent=_canUpdateContent;
			enableButton("send");			
    		var xml = document.getElementById("xml");
			var xsl = document.getElementById("xslt");
			if(canUpdateContent==false)
			{
				/*try{
    				initReadSeeyonForm(xml.value,xsl.value);
				}catch(e){
					alert(_("edocLang.edoc_form_xml_error") +e);
					disableButton("send");
					window.location.href=window.location.href;
					return false;
				}*/
		       //bug 31615 收文登记外来文不允许修改的时候，让内部文号可以编辑。 312SP1 muj
			  
			  myBar.disabled("bodyTypeSelector");
			}
			//34171 320单独控制正文，不控制文单
			try{
			    //设置修复字段宽度的传参 这里感觉已经被废弃了
		        window.fixFormParam = {"isPrint" : false, "reLoadSpans" : true};
   				initSeeyonForm(xml.value,xsl.value);
			}catch(e){
				alert(_("edocLang.edoc_form_xml_error") +e);
				disableButton("send");
				window.location.href=window.location.href;
				return false;
			}
    		
			setObjEvent();
    		initContentTypeState();
    		substituteLogo(logoURL);
    		//初始化公文处理意见，有可能来自回退、撤销的待发流程
    		if(typeof(opinions)!="undefined")
    		{
    			dispOpinions(opinions,sendOpinionStr);
    		}
    		//外来文登记，不允许保存待发
    		if(canUpdateContent==false && "${comm}"=="register")
    		{
    			myBar.disabled("save");
    		}
    		<%--控制正文类型菜单置灰与否--%>
    		if((isFromTemplate==true && templateType !='workflow' && appName!="recEdoc")
    	    		||'${comm}' == 'register')
    		{				
    			myBar.disabled("bodyTypeSelector");
    		}
    		if(selfCreateFlow == false && isFromTemplate !=true){
    			myBar.disabled("workflow");	
    			openTemplete(templeteCategrory,'${templete.id==null?1:templete.id}');
        	}
    		confirmSelectPersonSetDefaultValue();
    		return false;
    	}
 
  
formOperation = "aa";
${opinionsJs}
//维持一个Map,保存正文的ID和正文编号（0：原始正文 1：套红1 2：套红2）
${contentRecordId}

function adjustDivHeight()
{  
  var formDivObj=document.getElementById("formAreaDiv");
  formDivObj.style.height=(screen.availHeight-258)+"px";  
}

//分枝 开始
//分支
	var branchs = new Array();
	var keys = new Array();
	var team = new Array();
	var secondpost = new Array();
	<c:if test="${branchs != null}">
		var handworkCondition = _('edocLang.handworkCondition');
		<c:forEach items="${branchs}" var="branch" varStatus="status">
			var branch = new ColBranch();
			branch.id = ${branch.id};
			branch.conditionType = "${branch.conditionType}";
			branch.formCondition = "${v3x:escapeJavascript(branch.formCondition)}";
			branch.conditionTitle = "${v3x:escapeJavascript(branch.conditionTitle)}";
			//if(branch.conditionType!=2)
				branch.conditionDesc = "${v3x:escapeJavascript(branch.conditionDesc)}";
			/*else
				branch.conditionDesc = handworkCondition;*/
			branch.isForce = "${branch.isForce}";
			eval("branchs["+${branch.linkId}+"]=branch");
			keys[${status.index}] = ${branch.linkId};
		</c:forEach>
	</c:if>
	<c:if test="${teams != null}">
		<c:forEach items="${teams}" var="team">
			team["${team.id}"] = ${team.id};
		</c:forEach>
	</c:if>
	<c:if test="${secondPosts != null}">
		<c:forEach items="${secondPosts}" var="secondPost">
			secondpost["${secondPost.depId}_${secondPost.postId}"] = "${secondPost.depId}_${secondPost.postId}";
		</c:forEach>
	</c:if>
//分枝 结束


//跟踪相关函数
function setTrackRadiio(){
	var obj = document.getElementById("isTrack");
	if(obj!=null){
		var all = document.getElementById("trackRange_all");
		var part = document.getElementById("trackRange_part");
		if(obj.checked){
			all.disabled = false;
			part.disabled = false;
			
			all.checked = true;
		}else {
			all.disabled = true;
			part.disabled = true;

			all.checked = false;
			part.checked = false;
		}
	}
}
function setTrackCheckboxChecked(){
	var obj = document.getElementById("isTrack");
	if(obj!=null){
		obj.checked = true;
	}
}
function selectPeopleFunTrackNewCol(){
	setTrackCheckboxChecked();
	selectPeopleFun_track();
}
function setPeople(elements){
	var memeberIds = "";
	if(elements){
		for(var i= 0 ;i<elements.length ; i++){
			if(memeberIds ==""){
				memeberIds = elements[i].id;
			}else{
				memeberIds +=","+elements[i].id;
			}
		}
		document.getElementById("trackMembers").value = memeberIds;
	}
}

var summaryId = "${formModel.edocSummaryId}";
var isAllowContainsChildDept_ExchangeUnit = true;

function unload(summaryId){
	try{
		unlockHtmlContent(summaryId);
	}catch(e){
	}
}
//
--></script>
</head>
<body scroll="no" onload="edocFormDisplay()" onUnload="unload('${formModel.edocSummaryId}')">
<form name="sendForm" id="sendForm" method="post">
<%-- 套红代码的JS中需要使用此变量--%>
<input type="hidden" id="currContentNum" name="currContentNum" value="0"/>
<%-- 后台保存获取数据需要使用此变量--%>
<input type="hidden" id="contentNo" name="contentNo" value="0"/>
<input type="hidden" id="isUniteSend" name="isUniteSend" value="false"/> 
<input type="hidden" name="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" name="comm" id="comm" value="${comm}">
<input type="hidden" name="id" value="${formModel.edocSummaryId}">
<%-- 套红代码的JS中需要使用此变量--%>
<input type="hidden" id="summaryId" name="summaryId" value="${formModel.edocSummaryId}">
<input type="hidden" name="process_desc_by" value="${process_desc_by}" />
<input type="hidden" name="process_xml" value="" />
<input type="hidden" id = "edocType" name="edocType" value="${formModel.edocSummary.edocType}"/>
<input type="hidden" name="exchangeId" value="${param.exchangeId}"/>
<input type="hidden" name="actorId" value="${actorId}"/>
<input type="hidden" name="templeteId" value="${templateId==null?param.templeteId:templateId}" />
<input type="hidden" name="currentNodeId" value="start" />
<input type="hidden" name="supervisorId" id="supervisorId" value="${colSupervisors }">
<input type="hidden" name="supervisors" id="supervisors" value="${colSupervise.supervisors }">
<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${colSupervisors }">
<input type="hidden" name="sVisorsFromTemplate" id="sVisorsFromTemplate" value="${sVisorsFromTemplate}">
<input type="hidden" name="awakeDate" id="awakeDate" value="${superviseDate}">
<input type="hidden" name="superviseTitle" id="superviseTitle" value="${colSupervise.title }">
<input type="hidden" name="fromSend" id="fromSend" value="${fromSend}"/>
<input type="hidden" name="loginAccountId" id="loginAccountId" value="${v3x:currentUser().loginAccount}" >
<input type="hidden" name="orgAccountId" id="orgAccountId" value="${formModel.edocSummary.orgAccountId}" >
<%--strEdocId:收文登记的时候，保存来文EdocSummary的ID--%>
<input type="hidden" name="strEdocId" id="strEdocId" value="${strEdocId}" >
<input type="hidden" name="__ActionToken" readonly value="SEEYON_A8" > <%-- post提交的标示，先写死，后续动态 --%>
<input type="hidden" name="archiveId" value="${formModel.edocSummary.archiveId}">
<!-- 接收从弹出页面提交过来的数据 -->
<input type="hidden" name="popJsonId" id="popJsonId" value="">
<input type="hidden" name="popNodeSelected" id="popNodeSelected" value="">
<input type="hidden" name="popNodeCondition" id="popNodeCondition" value="">
<input type="hidden" name="popNodeNewFlow" id="popNodeNewFlow" value="">
<input type="hidden" name="allNodes" id="allNodes" value="">
<input type="hidden" name="nodeCount" id="nodeCount" value="">
<%@include file="unitId.jsp" %>

<span id="people" style="display:none;">
<c:out value="${peopleFields}" escapeXml="false" />
</span>

<v3x:selectPeople id="wf" panels="Department,Post,Team" selectType="Department,Member,Post,Team" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
 jsFunction="setPeopleFields(elements, 'detailIframe')" viewPage="selectNode4EdocWorkflow"/>
 
<script>
<!--
onlyLoginAccount_wf=false;
//-->
</script>
<script>isNewOfficeFilePage=true;</script>

<script>showOriginalElement_wf=false;</script>
<script>
showAccountShortname_wf="yes";
accountId_wf="${formModel.edocSummary.orgAccountId}";
</script>
<div name="edocContentDiv" id="edocContentDiv" width="0px" height="0px" style="display:none">
<v3x:editor htmlId="content" editType="${canUpdateContent?'1,0':'1,0'}" content="${content}" type="${formModel.edocBody.contentType}" createDate="${createtime}" originalNeedClone="${formModel.edocBody.contentType=='gd' ? false : cloneOriginalAtts}" category="<%=ApplicationCategoryEnum.edoc.getKey()%>"  contentName="" />
</div>
<script>
var newEdocBodyId=fileId;
//调用模板的时候使用。
if(isFromTemplate || "${comm}"=="register" ) {
	contentOfficeId.put("0",fileId); 
}
</script>
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="7" height="22" valign="top">
		<script type="text/javascript">
		<fmt:message key="common.${(isFromTemplate && templateType !='text')? 'view':'design'}.workflow.label" bundle="${v3xCommonI18N}" var="workflowLable" />
		var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		var saveAs = new WebFXMenu;
		saveAs.add(new WebFXMenuItem("saveAsText", "<fmt:message key='templete.text.label' />", "saveAsTemplete('text')", "<c:url value='/apps_res/collaboration/images/text.gif'/>"));
		saveAs.add(new WebFXMenuItem("saveAsWorkflow", "<fmt:message key='templete.workflow.label' />", "saveAsTemplete('workflow')", "<c:url value='/apps_res/collaboration/images/workflow.gif'/>"));
		saveAs.add(new WebFXMenuItem("saveAsTemplete", "<fmt:message key='templete.category.type.0' />", "saveAsTemplete('templete')", "<c:url value='/apps_res/collaboration/images/text_wf.gif'/>"));
		var insert = new WebFXMenu;
		insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
		insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "quoteDocumentEdoc('${appType}')"));
		var workflow = new WebFXMenu;
		workflow.add(new WebFXMenuItem("", "<fmt:message key='workflow.new.label' />", "doWorkFlow('new')"));
		workflow.add(new WebFXMenuItem("", "<fmt:message key='workflow.edit.label' />", "designWorkFlow('detailIframe')"));
		myBar.add(new WebFXMenuButton("send", "<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' />", "send()", [1,4], "", null));
		myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.savesend.label' bundle='${v3xCommonI18N}'/>", "save()", [1,5], "", null));
		//myBar.add(new WebFXMenuButton("saveAs", "<fmt:message key='saveAs.label' />", null, "<c:url value='/apps_res/collaboration/images/saveAs.gif'/>", "", saveAs));    	
		myBar.add(new WebFXMenuButton("workflow", "${workflowLable}", "designWorkFlow('detailIframe','${(isFromTemplate && templateType !='text')}')", [3,6], "", null));
		myBar.add(new WebFXMenuButton("templete", "<fmt:message key='common.toolbar.templete.label' bundle='${v3xCommonI18N}'/>", "openTemplete(templeteCategrory,'${templete.id==null?1:templete.id}')", [3,7], "", null));
		myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}'/>", null, [1,6], "", insert));
		myBar.add(${v3x:bodyTypeSelector("v3x")});
 		myBar.add(new WebFXMenuButton("content", "<fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' />","dealPopupContentWinWhenDraft('0');", [8,10], "", null));
		<c:if test="${appType==19}">
			<c:if test="${hasBody1}">
				myBar.add(new WebFXMenuButton("content", "<fmt:message key='edoc.contentnum1.label' />","dealPopupContentWinWhenDraft('1');", [8,10], "", null));
			</c:if>
			<c:if test="${hasBody2}">
				myBar.add(new WebFXMenuButton("content", "<fmt:message key='edoc.contentnum2.label' />","dealPopupContentWinWhenDraft('2');", [8,10], "", null));
			</c:if>
		</c:if>
		myBar.add(new WebFXMenuButton("superviseSetup", "<fmt:message key='common.toolbar.supervise.label' bundle='${v3xCommonI18N}' />", "openSuperviseWindow()", [3,10], "", null));
		document.write(myBar.toString());
		document.close();
		</script>	</td>
  </tr>
  <tr class="bg-summary lest-shadow">
    <td width="8%" height="29" class="bg-gray"><fmt:message key="workflow.label" />:</td>
    <td>  
    <fmt:message key="${selfCreateFlow?'default.workflowInfo.value':'alert_notcreateflow_loadtemplate'}" var="dfwf" /><c:set value="${col:getWorkflowInfo(workflowInfo, flowPermPolicyMetadata, pageContext)}" var="wfInfo" />      
        <input id="workflowInfo" name="workflowInfo" class="input-100per cursor-hand" readonly value="<c:out value="${wfInfo}" default="${dfwf}" />" onClick="doWorkFlow('new')" ${((isFromTemplate == true && templateType !='text') || selfCreateFlow==false) ? 'disabled' : ''}></td>
    <td width="8%" nowrap="nowrap" class="bg-gray"><fmt:message key="process.cycle.label"/>:</td>     
    <td width="10%">
    	<select name="deadline" id="deadline" class="input-100per" onChange="javascript:compareTime(this)">
    	<v3x:metadataItem metadata="${deadlineMetadata}" showType="option" name="deadline" selected="${formModel.deadline}" bundle="${colI18N}"/>
    	</select>    </td>
    <td width="10%" class="bg-gray"><fmt:message key="common.remind.time.label" bundle='${v3xCommonI18N}' />:</td>
    <td width="10%">
    	<select name="advanceRemind" id="advanceRemind" class="input-100per" onChange="javascript:compareTime(this)">
    	<v3x:metadataItem metadata="${remindMetadata}" showType="option" name="deadline" selected="${formModel.edocSummary.advanceRemind}"  bundle="${v3xCommonI18N}"/>
    	</select>    </td>
    <td align="center"></td>
  </tr>
  <tr class="bg-summary"> 
    <td nowrap="nowrap" height="24" class="bg-gray"><fmt:message key="edocTable.label" />:</td>
    <td nowrap="nowrap"><select name="edoctable" id="edoctable" class="input-100per" onChange="javascript:changeEdocForm(this, ${edocFormId});" <c:if test="${isFromTemplate && templateType!='workflow'}">DISABLED</c:if>>
    <c:forEach var="edocForm" items="${edocForms}">
    <option value="<c:out value="${edocForm.id}"/>" <c:if test="${edocForm.id==edocFormId}">selected</c:if>><c:out value="${edocForm.name}"/></option>
    </c:forEach>
    </select></td>

   	
 	<td nowrap="nowrap" height="24" class="bg-gray">
  		<label for="isTrack">
   			<input type="checkbox" name="isTrack" value="1"  onclick="setTrackRadiio();"id="isTrack" 
   				<c:if test="${formModel.edocSummary.canTrack==1}">checked</c:if> /><fmt:message key="track.label" />:
   		</label>
    </td>
     <td nowrap="nowrap">
   		<label for="trackRange_all">
			<input type="radio" name="trackRange" id="trackRange_all" onclick="setTrackCheckboxChecked();" value="1" ${empty trackIds && formModel.edocSummary.canTrack ==1 ?'checked':''}/><fmt:message key="col.track.all" bundle="${v3xCommonI18N}" />
		</label>
		<label for="trackRange_part">
			<c:set value="${v3x:parseElementsOfIds(trackIds, 'Member')}" var="mids"/>
			<input type="hidden" value="${trackIds}" name="trackMembers" id="trackMembers"/>
			<v3x:selectPeople id="track" panels="Department,Team,Post,Outworker,RelatePeople" selectType="Member" jsFunction="setPeople(elements)" originalElements="${mids}"/>	
			<input type="radio" name="trackRange"  id="trackRange_part" onclick="selectPeopleFunTrackNewCol()" value="0" ${not empty trackIds?'checked':''}/><fmt:message key="col.track.part" bundle="${v3xCommonI18N}" />
		</label>
   	</td>
    <c:choose>
    	<c:when test="${isFromTemplate}">
    		<td nowrap="nowrap" class="bg-gray"><fmt:message key="prep-pigeonhole.label" />:</td>     
	    	<td colspan="1">
			    <select id="selectPigeonholePath" class="input-100per" onchange="pigeonholeEvent(this)" disabled>
			    	<option id="defaultOption" value="1"><fmt:message key="common.default" bundle="${v3xCommonI18N}"/></option>   
			    	<option id="modifyOption" value="2">${v3x:_(pageContext, 'click.choice')}</option>
			    	<c:if test="${archiveName ne null && archiveName ne ''}" >
			    		<option value="3" selected>${archiveName}</option>
			    	</c:if>
			    </select>
	    	</td>
    	</c:when>
    	<c:otherwise>
    		<td nowrap="nowrap" class="bg-gray"></td>     
    		<td></td>    
    	</c:otherwise>
    </c:choose>
    <td>&nbsp;</td>
  </tr>
  
  <tr id="attachment2TR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="6" valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>)</div><div id="attachment2Area" style="overflow: auto;"></div></td>
  </tr>
  <tr id="attachmentTR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="6" valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
		<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="${canDeleteOriginalAtts}" originalAttsNeedClone="${cloneOriginalAtts}" />      </td>
  </tr>
 
  <tr>
  	<td colspan="7" height="6" class="bg-b"></td>
  </tr>
  <tr valign="top">
	<td colspan="7"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr valign="top">
			<td>		
			<div id="formAreaDiv" class="scrollList">
			
			<div style="display:none">
			<textarea id="xml" cols="40" rows="10">
				 ${formModel.xml}
         	</textarea>
         	</div>
         	<div style="display:none">
		   	<textarea id="xslt" cols="40" rows="10">   
				${formModel.xslt}
			</textarea>
		    </div>
		    <!-- 愚昧啊,div 加个边框就可以滚动了,要不就把页面撑开了 -->
		 	<div id="html" name="html" style="border:1px solid;border-color:#FFFFFF;height:0px;"></div>
		 	
		 	<div id="img" name="img" style="height:0px;"></div>	
			<div style="display:none">
			<textarea name="submitstr" id="submitstr" cols="80" rows="20"></textarea>
			</div>
		 	
			</div>			
			</td>
			<td width="45px" id="noteAreaTd" nowrap="nowrap">
		    	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="noteArea">
		   			<tr>
				  		<td valign="top" class="sign-button-bg"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				   			<tr>
				   				<td class="right-scroll-bg">
								<div id="noteMinDiv" style="height: 100%" class="sign-min-bg">
									<div class="sign-min-label" onclick="changeLocation('senderNote');showNoteArea()"><fmt:message key="sender.note.label" /></div>
									<div class="separatorDIV"></div>
									<!--
									<div class="sign-min-label" onclick="changeLocation('colQuery');showNoteArea()"><fmt:message key="edoc.query.label" /></div>
									<div class="separatorDIV"></div>
									  -->
								</div>
				   				<table id="noteAreaTable" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				   					<tr>
						   				<td height="25">
						   				<div id="hiddenPrecessAreaDiv" onclick="hiddenNoteArea()" title="<fmt:message key='common.display.hidden.label' bundle='${v3xCommonI18N}' />"></div>
						   				<script type="text/javascript">
											var panels = new ArrayList();
											panels.add(new Panel("senderNote", '<fmt:message key="sender.note.label" />'));
											//panels.add(new Panel("colQuery", '<fmt:message key="edoc.query.label"/>'));
											
											showPanels(false);
											</script>
								  		</td>
						  			</tr>
									<tr>
										<td height="25" class="senderNode"><fmt:message key="sender.note.label"/>(<fmt:message key="common.charactor.limit.label" bundle="${v3xCommonI18N}"><fmt:param value="500" /></fmt:message>)<td>
									</tr>
									<tr id="senderNoteTR" style="display:none;">
										<td class="note-textarea-td">
											<input type="hidden" name="policy" value="${policy}">
											<textarea cols="" rows="" name="note" validate="maxLength" inputName="<fmt:message key='sender.note.label' />" maxSize="500" class="note-textarea wordbreak"><c:out value='${formModel.senderOpinion.content}' escapeXml='true' /></textarea>
										</td>
									</tr>
									<tr id="colQueryTR" style="display:none;">
										<td>&nbsp;</td>
									</tr>		   				
				   				</table></td>
							</tr>
				    	</table></td>
				   </tr>
				</table>			</td>
		</tr>
	</table></td>
  </tr>
</table>

<div style="display:none" id="processModeSelectorContainer">
</div>
</form>

<iframe name="personalTempleteIframe" scrolling="no" frameborder="0" height="0" width="0"></iframe>
<script type="text/javascript">
//initWorkFlow();
initProcessXml();
hiddenNoteArea();
<c:if test="${isFromTemplate}" >
isFromTemplate = true;
</c:if>
<c:if test="${not isFromTemplate}" >       
isFromTemplate = false;
</c:if>

<c:if test="${!empty formModel.senderOpinion.content}">
changeLocation('senderNote');
showNoteArea();
</c:if>
if(v3x.isIpad){
	var oHtml = document.getElementById('html'); 
	if(oHtml){
		oHtml.style.height = "470px";	
		oHtml.style.overflow = "auto";	
		touchScroll("html");
	}
}
</script>
<iframe name="toXmlFrame" scrolling="no" frameborder="1" height="0px" width="0px"></iframe>
</body>
</html>