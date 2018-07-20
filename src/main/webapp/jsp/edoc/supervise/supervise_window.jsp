<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>    
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>公文督办</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

	/**
	 *内部方法，向上层页面返回参数
	 */
	function _returnValue(value){
	    if(transParams.popCallbackFn){//该页面被两个地方调用
	        transParams.popCallbackFn(value);
	    }else{
	        transParams.parentWin.openSuperviseWindowCallback(value);
	    }
	}
	
	/**
	 *内部方法，关闭当前窗口
	 */
	function _closeWin(){
	    if(transParams.popWinName){//该页面被两个地方调用
	        transParams.parentWin[transParams.popWinName].close();
	    }else{
	        transParams.parentWin.openSuperviseWindowWin.close();
	    }
	}

	function doIt(){
		var thisMid = "${ctp:escapeJavascript(param.supervisorId)}";
		var count = "${ctp:escapeJavascript(param.count)}";
		var unCancelledVisor = document.getElementById("unCancelledVisor");
	 
		var mId = document.getElementById("supervisorMemberId");
		if(unCancelledVisor.value == '' && mId.value=="" ){
			//cancel supervise
			if(thisMid != ''){
			    _returnValue(mId.value + "||||true");
			}else{
			    _returnValue(mId.value + "|||");
			}
			_closeWin();
			return true;
		}
				//var canModify = document.getElementById("canModify").value;
		
			var uArray = unCancelledVisor.value.split(",");
			for(var i=0;i<uArray.length;i++){
				var have = mId.value.search(uArray[i]);
				if(have == -1){
					alert("<fmt:message key='edoc.template.notAllowed.delete'/>");
					return;
				}
			}
		if(mId.value == null || mId.value == ""){
			alert(_("collaborationLang.col_supervise_select_member"));
			return;
		}
		
		var sDate = document.getElementById("superviseDate");
		if(sDate.value == null || sDate.value == ""){
			alert(_("collaborationLang.col_supervise_select_date"));
			return;
		}
		
		var sNames = document.getElementById("supervisorNames");
		
		var number = mId.value.split(",");
		if((count!=null && count!="undefined" && (new Number(count) > 10)) || number.length > 10){
			alert(_("collaborationLang.col_supervise_supervisor_overflow"));
			return;
		}
		
		var superviseTitle = document.getElementById("title").value;
		/* branches_a8_v350sp1_r_gov 政务 向凡 修复GOV-4552，不允许输入特殊字符，因为特殊字符影响到了内容的截取 Start */
		if(!(/^[^\|"']*$/.test(superviseTitle))){
			alert(_("collaborationLang.col_inputSpecialChar"));
			return ;
		}
		/* branches_a8_v350sp1_r_gov 政务 向凡 修复GOV-4552，不允许输入特殊字符，因为特殊字符影响到了内容的截取 End */
		if(superviseTitle.length>85){
			alert(_("collaborationLang.col_supervise_title_overflow"));
			return;
		}
		

		_returnValue(mId.value + "|" + sDate.value + "|" + sNames.value + "|" + superviseTitle);
		_closeWin();
	}
	
	function sv(elements){
	if(elements){
		var obj1 = getNamesString(elements);
		var obj2 = getIdsString(elements,false);
		document.getElementById("supervisorNames").value = obj1;
		document.getElementById("supervisorMemberId").value = obj2;
		}
	}

	function selectDateTime(request,obj,width,height){
	
		var now = new Date();//当前系统时间

		whenstart(request,obj, width, height,'datetime');
		
		if(obj.value != ""){
			var days = obj.value.substring(0,obj.value.indexOf(" "));
			var hours = obj.value.substring(obj.value.indexOf(" "));
			var temp = days.split("-");
			var temp2 = hours.split(":");
			var d1 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
			if(d1.getTime()<now.getTime()){
				if(!window.confirm(v3x.getMessage("collaborationLang.col_alertTimeIsOverDue"))){
					obj.value = "";
					return false;
				}
			}
		}
	}

</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()">
<form name="sendForm" id="sendForm" method="post">
<input type="hidden" name="summaryId" id="summaryId" value="${param.summaryId }">
<input type="hidden" name="superviseId" id="superviseId" value="${param.superviseId }">
<input type="hidden" name="supervisorMemberId" id="supervisorMemberId" value="${param.supervisorId}"/>
<input type="hidden" name="remindMode" id="remindMode" />
<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${ctp:toHTML(param.unCancelledVisor)}">


<script>
	onlyLoginAccount_sv=true;
	isNeedCheckLevelScope_sv = false;
</script>
<c:set value="${v3x:showOrgEntitiesOfIds(param.supervisorId, 'Member', pageContext)}" var="authStr" />
<c:set value="${v3x:parseElementsOfIds(param.supervisorId, 'Member')}" var="authIds" /> 
<v3x:selectPeople id="sv" panels="Department" selectType="Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="sv(elements)"
                  originalElements="${authIds}"
                  minSize="0" maxSize="10"/>
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle">
					<fmt:message key="edoc.supervise.label" bundle="${colI18N}"/>
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<%--
				<tr>
					<td id="assigned_supervisor" name="assigned_supervisor">&nbsp;&nbsp;<fmt:message key="edoc.supervise.assigned.supervisor" />&nbsp;:&nbsp;<font color="red">${supervisorNames}</font></td></tr>
				<tr>
					<td id="assigned_endDate" name="assigned_endDate">&nbsp;&nbsp;<fmt:message key="edoc.supervise.assigned.endDate" />&nbsp;:&nbsp;<font color="red"><fmt:formatDate value="${endDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/></font></td>
				</tr>
				--%>
				<fmt:message key='common.default.selectPeople.value' bundle="${v3xCommonI18N}" var="spd" />
			    <tr>
			        <td width="17%" height="26"><fmt:message key="col.supervise.staff" bundle="${colI18N }"/>:</td>
			        <td width="83%">
			        	<input type="text" id="supervisorNames" class="input-100per cursor-hand" name="supervisorNames" readonly="true" 
			           				onclick="selectPeopleFun_sv();" 
			           				value="<c:out value='${authStr}' default='${spd}' escapeXml='true' />" >
			        </td>
			    </tr>
			    <tr>
			        <td height="28"><fmt:message key="col.supervise.deadline"  bundle="${colI18N }"/>:</td>
			        <td>
			           	<input type="text" name="superviseDate" id="superviseDate" class="cursor-hand input-100per" value="${ctp:toHTMLWithoutSpace(param.awakeDate)}" readonly="true"
			           	onclick="selectDateTime('${pageContext.request.contextPath}',this,400,200);"
						value="<font color='red'>${ctp:toHTML(param.awakeDate)}</font>">
			        </td>
			    </tr>
			    <tr>
			    	<td valign="top"><fmt:message key="col.supervise.title"  bundle="${colI18N }"/>:</td>
			    	<td>
						<textarea name="title" id="title" rows="7" cols="" class="input-100per"><c:out value='${superviseTitle}' escapeXml='true' default='${superviseTitle}' /></textarea>
			    	</td>
			    </tr>
			    <%--  tr>
			    	<td colspan="2">
			    	<label for="canModify">
			    		&nbsp;&nbsp;<input type="checkbox" name="canModify" id="canModify" ${canModify=='0'?'':'checked' }>&nbsp;&nbsp;<fmt:message key="col.supervise.canModify"/>
			    	</label>
			    	</td>
			    </tr> --%>   
			</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" colspan="2">
		    <input type="button" onclick="doIt();" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" />&nbsp;
		    <input type="button" onclick="_closeWin()" name="close" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" />
		</td>
	</tr>
</table>
</form>
</body>
</html>