<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="../exchangeHeader.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/exchange/js/exchange.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
function setPeopleFields(elements) {
	etr.setPeopleFields(elements);
}
function closeDialog(){
	etr.closeDialog();
}

function oprateSubmit(){
	etr.oprateSubmit();
}
//不能选择集团
var isCanSelectGroupAccount_grantedDepartId=false;
var sendUnitNotNullAlert = '<fmt:message key="edoc.turnrec.send.unit.not.null"  bundle="${edocI18N }"/>';
function showContentDiv(){
	var contentDiv=$("#contentDiv");
	var displayVal=contentDiv.css("display");
	if(displayVal=="block"){//隐藏正文
		contentDiv.css("display", "none");
		p_getCtpTop().turnRecDialog.reSize({height:100});
		$("#iconSpan").removeClass("arrow_2_t");
		$("#iconSpan").addClass("arrow_2_b");
	}else{//展现正文
		contentDiv.css("display", "block");
		p_getCtpTop().turnRecDialog.reSize({height:400});
		$("#iconSpan").removeClass("arrow_2_b");
		$("#iconSpan").addClass("arrow_2_t");
	}
}
$(function(){
	var grantedDepartId = document.getElementById("grantedDepartId");
	var opinion = document.getElementById("opinion");
	var deptSelect = document.getElementById("depSelect");
	var orgSelect = document.getElementById("orgSelect");
	window.etr = new ExchangeTurnRec(grantedDepartId,opinion,deptSelect,orgSelect,"${param.summaryId}");
	$(deptSelect).bind("click",etr.hideMemberList);
	$(orgSelect).bind("click",etr.showMemberList);
	
	//是否已经被转发
	var canTurnRec="${not empty turnRec}";
	if(canTurnRec=="true"){
		var infoDivObj=$("#infoDiv");
		infoDivObj.css("display", "block");
		
		var contentDiv=$("#contentDiv");
		contentDiv.css("display", "none");
	}
});
</script>
<style type="text/css">
.stadic_footer_height{
    height:35px;
}
</style>
</head>
<body>

<v3x:selectPeople id="grantedDepartId" panels="Account,Department,ExchangeAccount,OrgTeam" selectType="Account,Department,ExchangeAccount,OrgTeam" jsFunction="setPeopleFields(elements)" originalElements="${grantedDepartId}"  viewPage="" minSize="0"  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"/>
<form id="detailForm" name="detailForm" action="exchangeEdoc.do?method=turnRecExcute" method="post">
<input type="hidden" name="summaryId" value="${param.summaryId}"/>
<input type="hidden" id="sendUserDepartmentId" value="${sendUserDepartmentId}"/>
<input type="hidden" id="sendUserAccountId" value="${sendUserAccountId}"/>
<input type="hidden" id="deptSenderList" value="${fn:escapeXml(deptSenderList)}"/>
<input type="hidden" id="returnDeptId" name="returnDeptId" value="${sendUserDepartmentId }"/>
<!--提示信息 -->
<div id="infoDiv" class="padding_t_10" style="display:none;">
	<table width="100%" height="" align="center">
		<tr>
			<td class='padding_l_10'>
				<span class="ico16 risk_16"></span>
				<fmt:message key="edoc.has.turn.rec.not.again" />
			</td>
			<td class="padding_r_10" align="right">
				<a onclick="showContentDiv()">显示详情</a>
				<span id="iconSpan" class="ico16 arrow_2_b"></span>
			</td>
		</tr>
	</table>
</div>
<div id="contentDiv">
	<hr/>
	<table width="450">
		<tr>
			<td width="60"> &nbsp;&nbsp; </td>
			<td><fmt:message key='exchange.edoc.sendToNames'/></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
			<input type="text" inputName="<fmt:message key="exchange.edoc.sendToNames" />" validate="notNull" id="depart" name="depart" value="${sendUnitNames }" title="${sendUnitNames }" <c:if test="${!empty turnRec}">disabled</c:if> style="width:100%" onclick="selectPeopleFun_grantedDepartId();"  readonly/>
			<input type="hidden" id="grantedDepartId" name="grantedDepartId" value="${turnRec.typeAndIds}"/>	
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>${turnRec.userName}<fmt:message key="edoc.deal.opinion" bundle="${edocI18N }"/></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
			   <textarea cols="70" style="height: 190px;" id="opinion" name="opinion" <c:if test="${hasTurnRec == 'true' }">readonly</c:if>>${turnRec.opinion }</textarea>
			   <br/>(4000<fmt:message key="edoc.turnrec.charactor.limit.label"  bundle="${edocI18N }"/>)</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
			<div class="metadataItemDiv">
			<label for="depSelect">
				<input type="radio" name="exchangeType" id="depSelect" value="0" <c:if test="${!empty turnRec}">disabled</c:if> <c:if test="${(empty turnRec && defaultType == 0) ||turnRec.exchangeType == 0 }">checked</c:if>/><fmt:message key="edoc.exchangetype.department.label" bundle="${edocI18N}"/>
			</label>
			<label for="orgSelect">	
				<input type="radio" name="exchangeType" id="orgSelect" value="1" <c:if test="${!empty turnRec}">disabled</c:if> <c:if test="${(empty turnRec && defaultType == 1) ||turnRec.exchangeType == 1 }">checked</c:if>/><fmt:message key="edoc.exchangetype.company.label" bundle="${edocI18N}"/>
			</label>
			</div>
			<div class="metadataItemDiv">
			<div id="selectMemberList" <c:if test="${(empty turnRec && defaultType == 0) ||turnRec.exchangeType == 0 }">style="display:none;"</c:if>>
				<select name="memberList" class="condition" style="width: 115px" <c:if test="${!empty turnRec}">disabled</c:if>>
					<option value=""><fmt:message key="select.label.unitEdocOper" bundle="${edocI18N}"/></option>
					<c:forEach items="${memberList}" var="member">
					 	<option value="${member.id}" <c:if test="${!empty turnRec && turnRec.exchangeUserId == member.id}">selected</c:if>>${v3x:toHTML(member.name)}</option>
					</c:forEach>
				</select>
			</div>
			</div>
			</td>
		</tr>
	</table>
</div>

<div class="stadic_layout_footer stadic_footer_height" align="right" style="position:absolute;bottom:0;width:100%;line-height:30px;background:#F3F3F3;">
    <c:if test="${empty turnRec}">
    <input type="button" id="oprateButton" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize margin_r_5 margin_t_5" onclick="oprateSubmit();"/>
    </c:if>
    <input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2 margin_r_10 margin_t_5" onclick="closeDialog();"/>
</div>
</form>  
</body>
</html>