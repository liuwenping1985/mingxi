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
<v3x:selectPeople id="scope1" panels="Department,Team,Post,Level,Outworker" selectType="Member,Department,Account,Level,Post,Team" jsFunction="setIssusPeopleFields(elements)"  />	
<%
	}else{
%>
<v3x:selectPeople id="scope1" panels="Department,Team,Post,Level" selectType="Member,Department,Account,Level,Post,Team" jsFunction="setIssusPeopleFields(elements)"  />
<%
	}
%>

<v3x:selectPeople id="scope2" panels="Account,Department,Team,Post,Level" selectType="Member,Department,Account,Level,Team" jsFunction="setIssusPeopleFields(elements)" />	

<script type="text/javascript">

isNeedCheckLevelScope_scope1 = false;
isNeedCheckLevelScope_scope2 = false;

//为了避免先选择了发布范围，随后再切换不同空间类型公告板块所导致的发布范围与空间类型不互相匹配的问题，将选人界面设定为不回显原有被选数据，对用户略有不便
showOriginalElement_scope1 = false;
showOriginalElement_scope2 = false;

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

function changeBullSpace(st, accountId)
{
   clearSelectPeopleResult();
}

function callSelectPeople(){
	if(selectPeopleFlag == 1){
		selectPeopleFun_scope1();
	}else{
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

function ok(){
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
		return false;
	}
	if(selectedType!="1" && scopePeople==""){
		getA8Top().$.alert(_("bulletin.please_set_issus_scope"));
		return false;
	}

	//打印控制
	var allowPrintStr = document.getElementById("a") && document.getElementById("a").checked ? "1" : "0";
	//是否转Pdf
	var toPDFStr = document.getElementById("toPDF") && document.getElementById("toPDF").checked ? "1" : "0";
    var showPublishUserFlag = document.getElementById("showPublishUserFlag") && document.getElementById("showPublishUserFlag").checked ? "1" : "0";
    var noteCallInfo = document.getElementById("noteCallInfo") && document.getElementById("noteCallInfo").checked ? "1" : "0";
    var returnValue  =  [scopePeople,selectedValue,allowPrintStr,toPDFStr,noteCallInfo,showPublishUserFlag];
    transParams.parentWin.edocBulletinIssueCallBackFun(returnValue);
}

function cancelIssus(){
	 var returnValue  = [];
	 transParams.parentWin.edocBulletinIssueCallBackFun(returnValue);
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
			<div style="border: solid 1px #666666;  overflow-y:auto; height:300px">
				<table class="sort" width="100%"  border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
					<thead>
					<tr class="sort">
						<td type="String" colspan="2"><fmt:message key="inquiry.categoryName.label" bundle='${v3xCommonI18N}' /></td>
					</tr>
					</thead>
					<tbody>
						<c:forEach items="${typeList}" var="typeData">
						<tr class="sort" align="left" onclick="updateType('${typeData.spaceType}', '${typeData.accountId}')">
							<td align="center" class="sort" width="5%">
								<input type="radio" name="issus_space_type" id="spaceTypeName" value="${typeData.id}" extAttribute1="${typeData.spaceType}" extAttribute2="${typeData.accountId}" onclick="changeBullSpace('${typeData.spaceType}', '${typeData.accountId}')"/>
							</td>
							<td class="sort" type="String">
								${v3x:toHTML(typeData.typeName)}
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</td>
	</tr>
	<tr id="issus_scope" style="background-color: #F6F6F6;">
		<td height="28" align="left" nowrap="nowrap" style="padding-left:6px;"><fmt:message key="common.issueScope.label" bundle='${v3xCommonI18N}' />:
			<input type="text" id="issusScope" name="issusScope" class="cursor-hand" style="width:84%" readonly onclick="callSelectPeople()">
		</td>
  	</tr>
  	<tr id="ctrl_print_read" style="background-color: #F6F6F6;">
		<td height="28" align="left" nowrap="nowrap" style="padding-left:6px;">
             <label for="showPublishUserFlag">
                <input type="checkbox" name="showPublishUserFlag" id="showPublishUserFlag" ><span class="margin_l_5"><fmt:message key="bul.dataEdit.showPublishUser"/></span>
            </label>            
            <label for="noteCallInfo">
                 <input type="checkbox" name="noteCallInfo" id="noteCallInfo" ><span class="margin_l_5"><fmt:message key="bul.dataEdit.noteCallInfo"/></span>
            </label>
			<label for="a">
				<input type="checkbox" name="allowPrint" id="a" /><fmt:message key="bul.dataEdit.printAllow" bundle="${bulI18N}" />
			</label>
			<c:if test="${bodyType == 'OfficeWord' || bodyType == 'WpsWord'}">
				<label for="toPDF">
					<input type="checkbox" name="changePdf" id="toPDF" /><fmt:message key="common.transmit.pdf" bundle='${v3xCommonI18N}' />
				</label>
			</c:if>
		</td>
  	</tr>
  	<tr>
		<td height="28" align="right" class="bg-advance-bottom" colspan="2">
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="cancelIssus()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<iframe src="" name="preIssusIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>