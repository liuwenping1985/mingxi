<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./include/taglib.jsp" %>
<%@ include file="./include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.bulletin.resources.i18n.BulletinResource" var="bulI18N" />
<%
	String summaryId = request.getParameter("summaryId");
	String affairId = request.getParameter("affairId");
	//公文转公告：1，协同转公告：0
	String entry = request.getParameter("entry");
	//判断是否需要在发布范围中显示外部人员标签（公文不需要，协同需要。）
	String outworkerPanel = request.getParameter("outworkerPanel");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js" />"></script>
<title><fmt:message key="select.space.type" bundle='${v3xCommonI18N}' /></title>

<%
	if( "1".equals(outworkerPanel) ){
%>
<v3x:selectPeople id="scope1" showAllAccount="true"
panels="Department,Team,Post,Level,Outworker" 
selectType="Member,Department,Account,Level,Post,Team" 
departmentId="${v3x:currentUser().departmentId}"
jsFunction="setIssusPeopleFields(elements)"  />	
<%
	}else{
%>
<v3x:selectPeople id="scope1" showAllAccount="true"
panels="Department,Team,Post,Level" 
selectType="Member,Department,Account,Level,Post,Team" 
departmentId="${v3x:currentUser().departmentId}"
jsFunction="setIssusPeopleFields(elements)"  />
<%
	}
%>

<v3x:selectPeople id="scope2" showAllAccount="true" 
panels="Account,Department,Team,Post,Level" 
selectType="Member,Department,Account,Level,Team" 
departmentId="${v3x:currentUser().departmentId}"
jsFunction="setIssusPeopleFields(elements)" />	

<script type="text/javascript">

var isNeedCheckLevelScope_scope1 = false;
var isNeedCheckLevelScope_scope2 = false;

//为了避免先选择了发布范围，随后再切换不同空间类型公告板块所导致的发布范围与空间类型不互相匹配的问题，将选人界面设定为不回显原有被选数据，对用户略有不便
var showOriginalElement_scope1 = false;
var showOriginalElement_scope2 = false;

//限制自定义单位、集团、团队空间的发布范围
var includeElements_scope1 = "";
var includeElements_scope2 = "";

window.onload = function(){
	var selectedArr = document.getElementsByName("issus_space_type");
	if(selectedArr && selectedArr.length>0){
		//默认选中列表中的第一个公告板块
		selectedArr[0].checked = true;
		//根据第一个板块的空间类型，判断是否需要显示发布人范围
		updateType(selectedArr[0].getAttribute('extAttribute1'), selectedArr[0].getAttribute('extAttribute2'));
	}
};

var selectPeopleFlag = 1;//1--选人界面scope1,2--选人界面scope2

function updateType(spaceType, accountId){
	if(spaceType == 2){//单位
		document.getElementById("issus_scope").style.display = "";
		
		onlyLoginAccount_scope1=true;
		accountId_scope1 = accountId;
		selectPeopleFlag = 1;
	}else if(spaceType == 1){//部门
		document.getElementById("issus_scope").style.display = "none";
	}else{//其他
		document.getElementById("issus_scope").style.display = "";
		selectPeopleFlag = 2;
	}
	
	clearSelectPeopleResult();
}

function clearSelectPeopleResult() {
	//清空选择的发布范围的ID
   if(document.getElementById("memberIdsStr")) {
   		document.getElementById("memberIdsStr").value = '';
   }
   //清空选择人员组件选中的信息
   if(document.getElementById("issusScope")) {
   		document.getElementById("issusScope").value = "<fmt:message key='common.default.issueScope.value' bundle='${v3xCommonI18N}'/>";
   }
}

function changeBullSpace(st, accountId, index)
{
   $("#Name_" + index).click();
   clearSelectPeopleResult();
}

function callSelectPeople(){
	/*
	* 空间类型如果为自定义单位、集团空间、团队空间，则需要获取到空间的授权范围，限制选人界面的发布公告的范围。
	*/
	
	//获取空间ID
	var selectedArr = document.getElementsByName("issus_space_type");
 	var selectedAccountId = null;
 	var selectedType = null;
	for(var i=0; i<selectedArr.length; i++){
		if(selectedArr[i].checked == true){
			selectedType = selectedArr[i].getAttribute("extAttribute1");
			selectedAccountId = selectedArr[i].getAttribute("extAttribute3");
			break;
		}
	}
	
	//根据空间ID获取发布范围字符串
	var publishScopeStr = "";

	if( selectedType=="4" || selectedType=="17" || selectedType=="18" ){//4：自定义团队空间；17：自定义单位空间；18：自定义集团空间
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulIssueManager", "getIssueScope", false);
		requestCaller.addParameter(1, "String", selectedAccountId);
		publishScopeStr = requestCaller.serviceRequest();
	}else{
		includeElements_scope1 = "";
		includeElements_scope2 = "";
	}

	//弹出选人界面
	if(selectPeopleFlag == 1){
		includeElements_scope1 = publishScopeStr ;
		includeElements_scope2 = "";
		selectPeopleFun_scope1();
	}else{
		includeElements_scope1 = "";
		includeElements_scope2 = publishScopeStr ;
		selectPeopleFun_scope2();
	}
}

function setIssusPeopleFields(elements) {
	
    var theForm = document.getElementsByName("preIssusForm")[0];
    if (!elements) {
        return false;
    }
    var workFlowContent = "";
    var isShowShortName = false;
    for (var i = 0; i < elements.length; i++) {
    	if(i > 0){
    		workFlowContent += _("V3XLang.common_separator_label");
    	}
        var person = elements[i];
		var _text = person.name;
        if(isShowShortName == true && person.accountShortname != "null" && person.accountShortname != "undefined" && person.accountShortname != ""){
        	_text = "(" + person.accountShortname + ")" + _text;
        }
        workFlowContent += _text;
    }
	var workflowInfoObj = document.getElementById("issusScope");
	workflowInfoObj.value = workFlowContent;
	var memberIdsObj = theForm.memberIdsStr;
	memberIdsObj.value = getIdsString(elements, true);
    return true;
}

//dialog的回调函数
function OK(){
	var result = [];
	var selectedArr = document.getElementsByName("issus_space_type");
	var selectedValue = null;
 	var selectedType = null;
	for(var i=0; i<selectedArr.length; i++){
		if(selectedArr[i].checked == true){
			selectedValue = selectedArr[i].value;
			selectedType = selectedArr[i].getAttribute("extAttribute1");
			break;
		}
	}
	
	var scopePeople = document.getElementById("memberIdsStr").value;
	if(selectedType==null){
		getA8Top().$.alert(_("bulletin.please_select_issus_space"));
		return result;
	}
	if(selectedType!="1" && scopePeople==""){
		getA8Top().$.alert(_("bulletin.please_set_issus_scope"));
		return result;
	}

	//打印控制
	var allowPrintStr = document.getElementById("allowPrint") && document.getElementById("allowPrint").checked ? "1" : "0";
	var toPDFStr = document.getElementById("toPDF") && document.getElementById("toPDF").checked ? "1" : "0";
	var showPublishUserFlag = document.getElementById("showPublishUserFlag") && document.getElementById("showPublishUserFlag").checked ? "1" : "0";
	var noteCallInfo = document.getElementById("noteCallInfo") && document.getElementById("noteCallInfo").checked ? "1" : "0";
	var publishContent = document.getElementById("publishContent2") && document.getElementById("publishContent2").checked ? "content" : "form";
	result = [ scopePeople , selectedValue , allowPrintStr , toPDFStr , noteCallInfo , showPublishUserFlag, publishContent];
	
	return result;
}
</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()" >
<form name="preIssusForm" action="" target="preIssusIframe" method="post" >
<input type="hidden" id="memberIdsStr" name="memberIdsStr" value=""/>
<input type="hidden" id="bodyType" name="bodyType" value="${bodyType}"/>
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel">
			<div style="border: solid 1px #666666;  overflow-y:auto; height:350px">
				<table class="sort" width="100%"  border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
					<thead>
					<tr class="sort">
						<td type="String" colspan="2"><fmt:message key="bul.type.typeName" /></td>
					</tr>
					</thead>
					<tbody>
						<c:forEach items="${typeList}" var="typeData" varStatus="sta">
						<tr class="sort" align="left" onclick="updateType('${typeData.spaceType}', '${typeData.accountId}')">
							<td align="center" class="sort" width="5%">
								<input type="radio" name="issus_space_type" id="spaceTypeName" value="${typeData.id}" extAttribute1="${typeData.spaceType}" extAttribute2="${typeData.accountId}" extAttribute3="${typeData.accountId}" onclick="changeBullSpace('${typeData.spaceType}', '${typeData.accountId}', '${sta.index}')"/>
							</td>
							<td class="sort" type="String" style="color:#000;" id="Name_${sta.index}">
								${v3x:toHTML(typeData.typeName)}
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</td>
	</tr>
	<c:if test="${param.formContent == 'true'}">
	<tr style="background-color: #F6F6F6;">
		<td height="28" nowrap="nowrap" style="padding-left:6px;">
			<fmt:message key="issue.content.label" />:
			<label for="publishContent1">
                <input type="radio" name="publishContent" id="publishContent1" checked="checked" />
                <span class="margin_l_5"><fmt:message key="application.2.label" /></span>
            </label>
            <label for="publishContent2">
                <input type="radio" name="publishContent" id="publishContent2" />
                <span class="margin_l_5"><fmt:message key="common.toolbar.content.label" /></span>
            </label>
		</td>
  	</tr>
  	</c:if>
	<tr id="issus_scope" style="background-color: #F6F6F6;">
		<td height="28" align="left" nowrap="nowrap" style="padding-left:6px;"><fmt:message key="common.issueScope.label" bundle='${v3xCommonI18N}' />:
			<input type="text" id="issusScope" name="issusScope" class="cursor-hand" style="width:84%" readonly onclick="callSelectPeople()">
		</td>
  	</tr>
  	<tr id="ctrl_print_read" style="background-color: #F6F6F6;">
		<td height="28" align="left" nowrap="nowrap" style="padding-left:6px;">
            <label for="showPublishUserFlag">
                <input type="checkbox" name="showPublishUserFlag" id="showPublishUserFlag" ><span class="margin_l_5"><fmt:message key="bul.dataEdit.showPublishUser" /></span>
            </label>            
            <label for="noteCallInfo">
                 <input type="checkbox" name="noteCallInfo" id="noteCallInfo" ><span class="margin_l_5"><fmt:message key="bul.dataEdit.noteCallInfo" /></span>
            </label>
             <label for="allowPrint">
                <input type="checkbox" name="allowPrint" id="allowPrint" /><span class="margin_l_5"><fmt:message key="bul.dataEdit.printAllow" bundle="${bulI18N}" /></span>
            </label>
			<c:if test="${bodyType == 'OfficeWord' || bodyType == 'WpsWord'}">
				<label for="toPDF">
					<input type="checkbox" name="changePdf" id="toPDF" /><span class="margin_l_5"><fmt:message key="common.transmit.pdf" bundle="${v3xCommonI18N}" /></span>
				</label>
			</c:if>
		</td>
  	</tr>
</table>
</form>
<iframe src="" name="preIssusIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>