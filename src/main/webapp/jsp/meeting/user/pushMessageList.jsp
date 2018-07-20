<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<title><fmt:message key='mt.choose.message.recevier'/></title>
<script type="text/javascript">
window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递

/**
 *内部方法，向上层页面返回参数
 */
function _returnValue(value){
    if(transParams.popCallbackFn){//该页面被两个地方调用
        transParams.popCallbackFn(value);
    }else{
        transParams.parentWin.showMessagerCallback(value);
    }
}

/**
 *内部方法，关闭当前窗口
 */
function _closeWin(){
    if(transParams.popWinName){//该页面被两个地方调用
        transParams.parentWin[transParams.popWinName].close();
    }else{
        transParams.parentWin.showMessagerWin.close();
    }
}

var ql = new Array();
<c:forEach var="reply" items="${replyList}" varStatus="index">
	ql[${index.index}] = "${v3x:showMemberNameOnly(reply.userId)}";
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
		if(!keyword || text.indexOf(keyword) > -1||keyword == defaultValue){ //显示
			trHidden = false;
		}
		else{
			trHidden = true;
		}

		var memberIdObj = document.getElementById("checkbox" + i);

		if(memberIdObj && !trHidden){ //显示当前选项
			memberIdObj.disabled = false;
		}
		else if(trHidden && memberIdObj && !memberIdObj.checked){ //隐藏当前选项，如果没有选择就置灰，这样selectAll就不会选中它
			memberIdObj.disabled = true;
		}

		if(document.getElementById("tr" + i))
		  document.getElementById("tr" + i).style.display = trHidden ? "none" : "";

		if(memberIdObj && !memberIdObj.checked){
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
				var memberId = document.getElementById("memberId"+obj[i].value).value;
				var memberName = document.getElementById("memberName"+obj[i].value).value;
				if(memberIds ==""){
					memberIds = memberId;
					names = memberName;
				}else{
					memberIds += ","+memberId;
					names += ","+memberName;
				}
			}
		}
	}
	ret[0] = memberIds;
	ret[1] = names;
	_returnValue(ret);
	_closeWin();
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<form name="listForm" id="listForm" action="" method="get" onsubmit="return false" style="margin: 0px">
 <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" onkeypress="doSearchEnter()" cellpadding="0">
	<tr>
		<td height="15px" class="PopupTitle">
			<div class="div-float">
				<fmt:message key='mt.choose.message.recevier'/>
			</div>

		</td>
	</tr>
	<tr>
		<td height="15px" align="right">
			<table width="100%" height="100%" cellpadding="0">
				<tr>
					<td align="right" nowrap="nowrap">
						<input type="text"  id="searchText" name="searchText" size ="12"  style="height: 19px;"
						 onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"
						 deaultValue="<fmt:message key='col.input.username' bundle="${v3xCommonI18N}"/> ">
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
			<div style="border: solid 1px #333; margin-bottom:3px;" class="scrollList">
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
						<c:forEach var="reply" items="${replyList}" varStatus="index">
                            <c:if test="${reply.feedbackFlag == 1 || reply.feedbackFlag == 0 || reply.feedbackFlag == -1 || reply.feedbackFlag == 3 || (reply.userId == meetingRecorderId && reply.userId == meetingCreateUserId) || (reply.userId == meetingEmceeId && reply.userId == meetingCreateUserId)}">
								<tr class="sort" id="tr${index.index}">
									<td width="5%" align="center" class="cursor-hand sort proxy-false">
										<input type='checkbox' ${v3x:containInCollection(sels,reply.id)?"checked":""} name="chb" id="checkbox${index.index}"value="${index.index}"/>
										<input type="hidden" id="memberId${index.index}" value="${reply.userId}"/>
										<c:set value="${v3x:showMemberNameOnly(reply.userId)}" var="memberName" />
										<input type="hidden" id="memberName${index.index}" value="${memberName}"/>
									</td>
									<td class="cursor-hand sort proxy-false">
										 ${memberName}&nbsp;
									</td>
                                    <td class="cursor-hand sort proxy-false">
                                        <c:choose>
                                            <c:when test="${reply.userId == meetingEmceeId && reply.userId == meetingCreateUserId}">
                                                <!-- <fmt:message key="mt.mtMeeting.emceeId" /> -->
                                                <fmt:message key="mt.mtReply.feedback_flag.1" />
                                            </c:when>
                                            <c:when test="${reply.userId == meetingRecorderId && reply.userId == meetingCreateUserId}">
                                                <!-- <fmt:message key="mt.mtMeeting.recorderId" /> -->
                                                <fmt:message key="mt.mtReply.feedback_flag.1" />
                                            </c:when>
                                            <c:when test="${reply.feedbackFlag == 1}">
                                                <c:choose>
                                                <c:when test="${reply.type eq 'createUser' }">
                                                    <fmt:message key="mt.mtMeeting.createUser" />
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:message key="mt.mtReply.feedback_flag.1" />
                                                </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:when test="${reply.feedbackFlag == 0 }">
                                                <fmt:message key="mt.mtReply.feedback_flag.0" />
                                            </c:when>
                                            <c:when test="${reply.feedbackFlag == -1 }">
                                                <fmt:message key="mt.mtReply.feedback_flag.-1" />
                                            </c:when>
                                        </c:choose>
                                    </td>
								</tr>
                            </c:if>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" valign="middle">
			<input type="button" id='jt' onclick="ok();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="_closeWin()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
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