<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>    
<%@ include file="edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="${title}" /></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

    window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递
	
    /**
	 *内部方法，向上层页面返回参数
	 */
	function _returnValue(value){
	    if(transParams.popCallbackFn){//该页面被两个地方调用
	        transParams.popCallbackFn(value);
	    }else{
	        transParams.parentWin.openSuperviseWindowCallBack(value);
	    }
	}
	
	/**
	 *内部方法，关闭当前窗口
	 */
	function _closeWin(){
	    if(transParams.popWinName){//该页面被两个地方调用
	        transParams.parentWin[transParams.popWinName].close();
	    }else{
	        commonDialogClose('win123');
	    }
	}

	var count = '${count}';
	var submitIt = "${submitIt}";
	var oldSuperviseId = "${ctp:escapeJavascript(supervisorId)}";
	var isDelete = false;
	function doIt(){
		var mId = document.getElementById("supervisorMemberId");
		if(mId.value == null || mId.value == ""){
			if(oldSuperviseId == ""){
				alert(_("collaborationLang.col_supervise_select_member"));
				return;
			}
			else{
				isDelete = true;
			}
		}

		
		var sNames = document.getElementById("supervisorNames");
		var supervisorIds = document.getElementById("supervisorMemberId");
		
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
		
		//var canModify = document.getElementById("canModify").value;

		var sVisorsFromTemplate = document.getElementById("sVisorsFromTemplate");
		var unCancelledVisor = document.getElementById("unCancelledVisor");
		if(sVisorsFromTemplate!=null && sVisorsFromTemplate.value=="true"){
			//模板自带的督办人和现有选择的督办人进行对比验证BUG-OA-39192
			var uArray = unCancelledVisor.value.split(",");
			for(var i=0;i<uArray.length;i++){
				//var have = sNames.value.search(uArray[i]);
				//OA-49881 调用含有督办人员设置的模版，已发增加督办人员，却提示模版自带的人员不能删除，导致不能修改督办人员
				var have = supervisorIds.value.search(uArray[i]);
				if(have == -1){
					alert("<fmt:message key='edoc.template.notAllowed.delete'/>");//alert("模板自带督办人员不允许删除");
					return;
				}
			}
		}
		var sDate = document.getElementById("superviseDate");
		if(sDate.value == null || sDate.value == ""){
			if(oldSuperviseId == "" || mId != ""){
				alert(_("collaborationLang.col_supervise_select_date"));
				return;
			}
		}
		if(submitIt == "1"){
			if(isDelete){
				document.getElementById("isDelete").value = "true";
			}
			
			var _form = document.getElementsByName("sendForm")[0];
			_form.action = "edocSupervise.do?method=saveSupervise&r="+new Date().getTime();
			_form.target="_submitFrame";
			_form.submit();
			
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

	//选督办人时显示外单位兼职
	onlyLoginAccount_sv = true;
	isNeedCheckLevelScope_sv = false;
	showConcurrentMember_sv = true;
</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()">
<form name="sendForm" id="sendForm" method="post">
<input type="hidden" name="summaryId" id="summaryId" value="${ctp:toHTML(param.summaryId)}">
<input type="hidden" name="superviseId" id="superviseId" value="${superviseId }">
<input type="hidden" name="supervisorMemberId" id="supervisorMemberId" value="${supervisorId}"/>
<input type="hidden" name="remindMode" id="remindMode" />
<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${ctp:toHTML(unCancelledVisor)}">
<input type="hidden" name="sVisorsFromTemplate" id="sVisorsFromTemplate" value="${ctp:toHTML(sVisorsFromTemplate)}">
<input type="hidden" name="isFromEdoc" id="isFromEdoc" value="${isFromEdoc}">
<input type="hidden" name="isDelete" id="isDelete" value="false">
<c:set value="Department,Team" var="depPer" />
<c:choose>
	<c:when test="${isFromEdoc == 'true'}" >
		<c:set value="Department" var="depPer" />
	</c:when>
</c:choose>
<c:set value="${v3x:showOrgEntitiesOfIds(supervisorId, 'Member', pageContext)}" var="authStr" />
<c:set value="${v3x:parseElementsOfIds(supervisorId, 'Member')}" var="authIds" /> 
<v3x:selectPeople id="sv" panels="${depPer}" selectType="Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="sv(elements)"
                  originalElements="${authIds}" minSize="0" maxSize="10"
                  />
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="${title}"/></td>
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
			        <td width="1%" height="26" nowrap="nowrap"><fmt:message key="col.supervise.staff" />&nbsp;:&nbsp;</td>
			        <td>
			        	<input type="text" id="supervisorNames" class="input-100per cursor-hand" name="supervisorNames" readonly="true" 
			           				onclick="${temformParentId==null||temformParentId==''?'selectPeopleFun_sv()':'' }" 
			           				value="<c:out value='${authStr}' default='${spd}' escapeXml='true' />" >
			        </td>
			    </tr>
			    <tr>
			        <td height="28"><fmt:message key="col.supervise.deadline" />&nbsp;:&nbsp;</td>
			        <td>
			           	<input type="text" name="superviseDate" id="superviseDate" class="cursor-hand input-100per" value="${ctp:toHTMLWithoutSpace(awakeDate)}" readonly="true"
			           	<c:if test="${temformParentId==null||temformParentId==''}">
			           		onclick="selectDateTime('${pageContext.request.contextPath}',this,400,200);"
			           	</c:if>
						value="<font color='red'>${ctp:toHTML(awakeDate)}</font>">
			        </td>
			    </tr>
			    <tr>
			    	<td valign="top"><fmt:message key="col.supervise.title"/>&nbsp;:&nbsp;</td>
			    	<td>
						<textarea name="title" id="title" style="height:70px" cols="52"  ${temformParentId==null||temformParentId==''?'':'readonly' }>${ctp:toHTML(superviseTitle)}</textarea>
			    	</td>
			    </tr>  
			</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" colspan="2">
		    <input type="button" onclick="doIt();" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" ${temformParentId==null||temformParentId==''?'':'disabled' }/>&nbsp;
		    <input type="button" onclick="_closeWin();" name="close" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" />
		</td>
	</tr>
</table>
 <iframe  frameborder="0" style="display:none;width:0px;height: 0px" name="_submitFrame" id="_submitFrame"></iframe>
</form>
</body>
</html>