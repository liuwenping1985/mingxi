<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../common/INC/noCache.jsp"%>
<%@ include file="edocHeader.jsp"%>
<title><fmt:message key='col.choose.message.recevier' bundle="${v3xCommonI18N}"/></title>
<fmt:message key="col.input.username" bundle="${v3xCommonI18N}" var="colInputUsername"/>
<script type="text/javascript">
<!--

var ql = new Array();
<c:forEach var="affair" items="${affairs}" varStatus="index">
	ql[${index.index}] = "${v3x:showMemberNameOnly(affair.memberId)}";
</c:forEach>
var defaultValue ="<fmt:message key='col.input.username' bundle='${v3xCommonI18N}'/> ";


var dataLength = ql.length;
function doSearch(){
	var keyword = document.getElementById("searchText").value;
	for(var i = 0; i < dataLength; i++){
		var text = ql[i];
		var trHidden = false;

		//branches_a8_v350sp1_r_gov 常屹修改
		//GOV-4725 公文消息推送选人的选择框在没有任何内容的情况下建议搜索全部数据
		//当搜索框中什么都没有填时，此时显示的为  <输入姓名>，这时候点查询按钮，也要将全部人员显示出来，所以当keyword == defaultValue就显示全部
		if(!keyword || text.indexOf(keyword) > -1||keyword == defaultValue || keyword == '' || keyword == '${colInputUsername }'){ //显示
			trHidden = false;
		}
		else{
			trHidden = true;
		}

		var memberIdObj = document.getElementById("checkbox" + i);

		if(!trHidden){ //显示当前选项
			memberIdObj.disabled = false;
		}
		else if(trHidden && !memberIdObj.checked){ //隐藏当前选项，如果没有选择就置灰，这样selectAll就不会选中它
			memberIdObj.disabled = true;
		}

		document.getElementById("tr" + i).style.display = trHidden ? "none" : "";

		if(!memberIdObj.checked){
			document.getElementById("allCheckbox").checked = false;
		}
	}
}

function ok(){
	//ret[0] = id,ret[1] = name
	var ret = [];
	var memberIds = "";
	var names = "";
	var obj = document.getElementsByName("chb");
	if(obj){
		for(var i=0;i<obj.length;i++){
			if(obj[i].checked){
				var affairId = document.getElementById("affairId"+obj[i].value).value;
				var memberId = document.getElementById("memberId"+obj[i].value).value;
				var memberName = document.getElementById("memberName"+obj[i].value).value;
				var v = affairId+","+memberId;
				if(memberIds ==""){
					memberIds = v;
					names = memberName;
				}else{
					memberIds += "#"+v;
					names += ","+memberName;
				}
			}
		}
	}
	ret[0] = memberIds;
	ret[1] = names;
	transParams.parentWin.showPushWindowCallback(ret);
	commonDialogClose('win123');
}
//-->
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<form name="listForm" id="listForm" action="" method="get" onsubmit="return false" style="margin: 0px">
 <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" onkeypress="doSearchEnter()" cellpadding="0">
	<%--<tr>
		<td height="15px" class="PopupTitle">
			<div class="div-float">
				<fmt:message key='col.choose.message.recevier'bundle="${v3xCommonI18N}" />
			</div>
		</td>
	</tr--%>
	<tr>
		<td height="15px" align="right">
			<table width="100%" height="100%" cellpadding="0">
				<tr>
					<td align="right" nowrap="nowrap">
						<fmt:message key='common.search.label'/>:
						<fmt:message key='col.input.username' bundle="${v3xCommonI18N}" var="_myLabelDefault"/>
						<input type="text"  id="searchText" name="searchText" size ="12"  style="height: 19px;"
							value="${_myLabelDefault}"  deaultValue="${_myLabelDefault}"
						   onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"/>
					</td>
					<td width="20">
						<span class="inline-block condition-search-button cursor-hand" onclick="javascript:doSearch()"></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="100%" class="bg-advance-middel">
			<div style="border: solid 1px #333; margin-bottom:3px; overflow:auto;height:270px;" class="scrollList">
				<table class="sort" width="100%"  border="0" cellspacing="0" cellpadding="0" >
					<thead>
						<tr class="sort">
							<td width="5%" align="center">
								<input type='checkbox' id='allCheckbox' onclick='selectAll(this, "chb")'/>
							</td>

							<td colspan="2">
								&nbsp;<fmt:message key='col.name' bundle="${v3xCommonI18N}" />
							</td>
						</tr>
					</thead>
					<tbody id="attBody">
						<c:forEach var="affair" items="${affairs}" varStatus="index">
								<tr class="sort" id="tr${index.index}">
									<td width="5%" align="center" class="cursor-hand sort proxy-false">
										<input type='checkbox' ${v3x:containInCollection(sels,affair.id)?"checked":""} name="chb" id="checkbox${index.index}"value="${index.index}"/>
										<input type="hidden" id="affairId${index.index}" value="${affair.id}"/>
										<input type="hidden" id="memberId${index.index}" value="${affair.memberId}"/>
										<c:set value="${v3x:showMemberNameOnly(affair.memberId)}" var="memberName" />
										<input type="hidden" id="memberName${index.index}" value="${memberName}"/>
									</td>
									<td class="cursor-hand sort proxy-false">
										 ${memberName}&nbsp;
									</td>
									<td class="cursor-hand sort proxy-false">
										<c:choose>
											<c:when test ="${ '2' eq affair.state}">
												<c:set value="${affair.memberId }" var="senderMemberId" />
												${ctp:i18n('cannel.display.column.sendUser.label') }
											</c:when>
											<c:when test ="${ '4' eq affair.state}">
												${ctp:i18n('collaboration.default.haveBeenProcessedPe') }
											</c:when>
											<c:when test ="${ '15' eq affair.subState}">
												${ctp:i18n('collaboration.default.stepBack') }
											</c:when>
											<c:when test ="${ '17' eq affair.subState}">
												${ctp:i18n('collaboration.default.specialBacked') }
											</c:when>
											<c:when test ="${affair.subState == 16 && affair.state == 1}">
												${ctp:i18n('cannel.display.column.sendUser.label') }
											</c:when>
											<c:when test ="${affair.subState == 16}">
												${ctp:i18n('collaboration.default.specialBacked') }
											</c:when>
											<c:when test ="${affair.state == 3 && (affair.subState == 11 || affair.subState == 12)}">
												${ctp:i18n('collaboration.default.currentToDo') }
											</c:when>
											<c:otherwise>
												${ctp:i18n('collaboration.default.stagedToDo') }
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" valign="middle">
			<input type="button" id='jt' onclick="ok();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="commonDialogClose('win123');" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<script>
window.onload = function(){
	document.getElementById("jt").focus();
}
</script>
</body>
</html>