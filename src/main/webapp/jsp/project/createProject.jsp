<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<%
response.setHeader("Cache-Control", "Public");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
	<style>
		#color_wheel td{ padding:5px; width:40px;height: 50px; vertical-align: top; text-align: right;}
		#color_wheel .ok{ display: block; width: 15px; height: 14px; background: url(./apps_res/project/images/ok.png);}
	</style>
<script type="text/javascript">
<!--
	var excludeElements_manageArray = new Array();
	var excludeElements_assistantArray = new Array();
	var excludeElements_memberArray = new Array();
	var excludeElements_chargeArray = new Array();
	var excludeElements_interfixArray = new Array();
	
	//不进行职务级别的筛选(工作范围限制)
	isNeedCheckLevelScope_manage = false;
	isNeedCheckLevelScope_assistant = false;
	isNeedCheckLevelScope_member = false;
	isNeedCheckLevelScope_charge = false;
	isNeedCheckLevelScope_interfix = false;
	
	//项目阶段
	var projectArr = new Properties();
	//模板
	var paramValue = "";
//-->
</script>
<!-- 项目负责人回显 -->
<c:set value="${v3x:parseElementsOfIds(currentUserId, 'Member')}" var="org" />
<v3x:selectPeople id="manage" panels="Department,Outworker" selectType="Member" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsManage(elements)" maxSize="5" originalElements="${org}" />
<v3x:selectPeople id="assistant" panels="Department,Outworker" selectType="Member" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsAssistant(elements)" maxSize="5" minSize="0" />
<v3x:selectPeople id="member" panels="Department,Outworker" selectType="Member" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsMember(elements)" minSize="0" />
<v3x:selectPeople id="interfix" panels="Department,Outworker" selectType="Member" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsInterfix(elements)" minSize="0" />
<v3x:selectPeople id="charge" panels="Department,Outworker" selectType="Member" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsCharge(elements)" minSize="0" maxSize="5" />
<v3x:selectPeople id="department" panels="Department" selectType="Department" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsDepartment(elements)" maxSize="1" />
</head>
<script>
	excludeElements_manageArray = elements_manage;
	<c:if test="${create =='create' }">
		//parent.listFrame.location.reload();
		parent.listFrame.location.href = parent.listFrame.location.href;
	</c:if>
	function doResize(){
		var clientHeight = document.documentElement.clientHeight;
		if(clientHeight==0 || parseInt(clientHeight)>500){
			clientHeight = document.body.clientHeight;
		}
		var oHeight = parseInt(clientHeight)-20;
		var isNewDlg = $("#isNewDialog").val();
		if (isNewDlg == 0) {
			oHeight = parseInt(clientHeight)-85;
		}
		if(oHeight < 0) {
			oHeight = 0;
		}
		$("#scrollListDiv").css("height",oHeight+"px");
		
		initFFScroll('scrollListDiv',oHeight);
	}

	function OK(){
		if(!checkThisForm(projectForm)){
		    return false;
	    }
		projectForm.submit();
		return true;
	}
	
	var _color = ["#006aff","#15a4fa","#06a8a9","#0dab60","#18a10f","#dd0865"];
	$(function () {
		$("#color_wheel td").click(function () {
			$("#color_wheel .ok").hide();
			$(this).find(".ok").show();
			$("#backGround").val($(this).attr("color"));
		});
	})
</script>
<body style="overflow-y:auto;overflow-x:hidden" height="100%" onresize="doResize();" id="createPage">
<c:set value="${empty param.isNewDialog ? 0 : param.isNewDialog}" var="isNewDialog" />
<input type="hidden" id="isNewDialog" value="${isNewDialog}"/>
<form id="projectForm" name="projectForm" method="post" action="${basicURL}?method=createProject" onSubmit="return checkThisForm(this)">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<c:if test="${isNewDialog == 0 }">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
				getDetailPageBreak(); 
			</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	</c:if>
	<tr>
		<td class="categorySet-head" style="padding:0px 20px 0px 0px;">
			<div class="categorySet-body" id="scrollListDiv" style="overflow:auto;">
				
					<table width="80%" border="0" align="center" cellpadding="0" cellspacing="5" >
						<tr height="0">
							<td width="10%"></td>
							<td width="10%"></td>
							<td width="30%"></td>
							<td width="10%"></td>
							<td width="30%"></td>
							<td width="10%"></td>
						</tr>
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right" height="25"><font color="red">*</font><fmt:message key='project.body.projectName.label' />:</td>
							<td width="20%" colspan="3">
								<input class="input-100per" type="text" name="projectName" validate="notNull" maxlength="100" inputName="<fmt:message key='project.body.projectName.label' />" />
							</td>
							<td></td>
						</tr>
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.projectType.label' />:</td>
							<td>
								<select id="projectTypeId" name="projectTypeId" onchange="syncProjectTypeName(this)" style="font-size: 12px; width: 100%;">
									<c:forEach items="${pTypeList}" var="type">
										<option value="${type.id}">${v3x:toHTMLWithoutSpace(type.name)}</option>
									</c:forEach>
								</select>
								<input type="hidden" name="projectType" id="projectType" value="${v3x:toHTMLWithoutSpace(pTypeList[0].name)}" />
								<c:forEach items="${pTypeList}" var="type">
									<input type="hidden" name="projectType_${type.id}" id="projectType_${type.id}" value="${v3x:toHTMLWithoutSpace(type.name)}" />
								</c:forEach>
							</td>
                            <td class="bg-gray" align="right" style="padding-right:0;white-space:nowrap;"><fmt:message key='project.body.projectNum.label' />:</td>
                            <td>
                                <input class="input-100per" type="text" name="projectNum" id="projectNum" maxlength="40" inputName="<fmt:message key='project.body.projectNum.label' />" />
                            </td>
							<td></td>
						</tr>
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.startdate.label' />:</td>
							<td>
								<input class="input-100per" type="text" name="begintime" id="begintime" readonly="readonly" onclick="selectProjectDate('start', '${pageContext.request.contextPath}', this)" validate="notNull" maxlength="50" value="<fmt:formatDate value='${init}' pattern='yyyy-MM-dd'/>" inputName="<fmt:message key='project.body.startdate.label' />" />
							</td>
							<td class="bg-gray" align="right" style="padding-right:0;white-space:nowrap;"><font color="red">*</font><fmt:message key='project.body.enddate.label' />:</td>
							<td>
								<input class="input-100per" type="text" name="closetime" id="closetime" readonly="readonly" onclick="selectProjectDate('end', '${pageContext.request.contextPath}', this)" validate="notNull" maxlength="50" inputName="<fmt:message key='project.body.enddate.label' />" />
							</td>
							<td></td>
						</tr>
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right" nowrap="nowrap"><font color="red">*</font><fmt:message key='project.body.responsible.label' />:</td>
							<td colspan="3"  nowrap="nowrap">
								<input type="hidden" name="manager" id="managers" value="${currentUserId}">
								<input class="input-100per" type="text" name="managerWeb" id="managerWeb" readonly="readonly" onclick="isSelectManager()" value="${currentUserName}" validate="notNull" inputName="<fmt:message key='project.body.responsible.label' />" />
							</td>
							<td></td>
						</tr>
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right"><fmt:message key='project.body.assistant.label' />:</td>
							<td colspan="3">
								<input type="hidden" name="assistant" id="assistants" value="">
								<input class="input-100per" type="text" name="assistantWeb" id="assistantWeb" readonly="readonly" onclick="isSelectAssistant()" value="" inputName="<fmt:message key='project.body.assistant.label' />" />
							</td>
							<td></td>
						</tr>
			
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right"><fmt:message key='project.body.members.label' />:</td>
							<td colspan="3">
								<input type="hidden" name="member" id="members" value="">
								<textarea name="memberWeb" id="memberWeb" rows="2" validate="maxLength" style="width: 100%; resize: none;height: 40px;" class="font-12px" onclick="isSelectMember()" readonly="readonly" inputName="<fmt:message key='project.body.members.label' />" /></textarea>
							</td>
							<td></td>
							<td></td>
						</tr>
			
						<tr style="vertical-align: top;">
							<td></td>	
							<td class="bg-gray" align="right"><fmt:message key='project.body.manger.label' />:</td>
							<td colspan="3">
								<input type="hidden" name="charge" id="charges" value="">
								<textarea name="chargeWeb" id="chargeWeb" rows="2" validate="maxLength" style="width: 100%; resize: none;height: 40px" class="font-12px" onclick="isSelectCharge()" readonly="readonly" inputName="<fmt:message key='project.body.manger.label' />" /></textarea>
							</td>
							<td></td>
						</tr>
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right"><fmt:message key='project.body.related.label' />:</td>
							<td colspan="3">
								<input type="hidden" name="interfix" id="interfixs" value="">
								<textarea name="interfixWeb" id="interfixWeb" rows="2" validate="maxLength" style="width: 100%; resize: none;height: 40px" class="font-12px" onclick="isSelectInterfix()" readonly="readonly" inputName="<fmt:message key='project.body.related.label' />" /></textarea>
							</td>
							<td style="vertical-align: bottom;"  nowrap="nowrap">
								[<a href="###" onclick="javascript:showDescription();"><fmt:message key="project.toolbar.comment.label" /></a>]
							</td>
							<td></td>
						</tr>
<!--						<tr style="vertical-align: top;">-->
<!--							<td></td>-->
<!--							<td></td>-->
<!--							<td colspan="2">-->
<!--								[<a href="###" onclick="javascript:showDescription();"><fmt:message key="project.toolbar.comment.label" /></a>]-->
<!--							</td>-->
<!--							<td></td>-->
<!--							<td></td>-->
<!--						</tr>-->
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray"></td>
							<td colspan="3">
								<input type="button" value="<fmt:message key='project.phase.add.title.label' />" class="button-default-2" onclick="addPhases('add')">
								<input type="button" value="<fmt:message key='project.phase.title.edit.label' />" class="button-default-2" onclick="addPhases('update')">
								<input type="button" value="<fmt:message key='project.phase.title.delete.label' />" class="button-default-2" onclick="deletePhases()">
			 				</td>
			 				<td></td>
						</tr>
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.phase.label' />:</td>
							<td colspan="3">
								<div class="phaseDiv">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" id="phasesTable">
										<tr>
											<td width="5%" style="border-bottom: 1px solid #CCC; border-right: 1px solid #CCC;" align="center"><input type="checkbox" onclick="selectAll(this, 'id')"></td>
											<td width="45%" style="border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; padding-left: 10px;"><fmt:message key='project.docment.title' /></td>
											<td width="50%" style="border-bottom: 1px solid #CCC; padding-left: 10px;"><fmt:message key='project.time' /></td>
										</tr>
									</table>
								</div>
			 				</td>
			 				<td></td>
						</tr>
						
						<tr class="hidden" id="currentPhaseTr" style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.phase.current.label' />:</td>
							<td colspan="3">
								<input type="hidden" id="currentPhaseId" name="currentPhaseId"/>
								<input id="currentPhaseName" name="currentPhaseName" readonly style="width: 200px;"/>
								&nbsp;&nbsp;
								<a onclick="javascript:setPhaseForCreate();">[<fmt:message key='common.button.modify.label' bundle='${v3xCommonI18N}' />]</a>
							</td>
							<td></td>
						</tr>
						
						<tr>
							<td></td>
							<td class="bg-gray" align="right"  nowrap="nowrap"><font color="red">*</font><fmt:message key='project.body.teamopen.label.new' />:</td>
							<td colspan="3"  nowrap="nowrap">
								<label for="publicGroup1">
									<input type="radio" id="publicGroup1" name="publicGroup" value="0" /><fmt:message key="common.yes" bundle="${v3xCommonI18N}" />
								</label>
								<label for="publicGroup2">
									<input type="radio" id="publicGroup2" name="publicGroup" value="1" checked="checked" /><fmt:message key="common.no" bundle="${v3xCommonI18N}" />
								</label>
							</td>
							<td></td>
						</tr>
						
						<tr>
							<td></td>
							<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key="project.body.state.label" />:</td>
							<td colspan="3">
								<label for="projectState1">
									<input type="radio" id="projectState1" name="projectState" value="0" checked /><fmt:message key="project.body.projectstate.0" />
								</label>
								<label for="projectState2">
									<input type="radio" id="projectState2" name="projectState" value="2" /><fmt:message key="project.body.projectstate.2" />
								</label>
							</td>
							<td></td>
						</tr>
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.desc.label' />:</td>
							<td colspan="3" align="left" valign="top">
								<textarea name="projectDesc" cols="" rows="3" style="resize: none;" validate="maxLength" maxSize="1000" class="font-12px breakWord" inputName="<fmt:message key='project.body.desc.label' />"></textarea>
							</td>
							<td></td>
						</tr>
						
						<tr style="vertical-align: top;">
							<td></td>
							<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.templates.label' />:</td>
							<td colspan="3">
								<input type="hidden" name="templates" id="templates" value="">
								<textarea name="templatesWeb" id="templatesWeb" rows="3" style="resize: none;" class="font-12px breakWord" onclick="setProjectTemplete('false')" readonly="readonly" inputName="<fmt:message key='project.body.templates.label' />" /></textarea>
			 				</td>
			 				<td></td>
						</tr>
						<tr style="vertical-align: top;">
							<td><input type="hidden" name="backGround" id="backGround" value="#006aff"></td>
							<td class="bg-gray" align="right" valign="top" nowrap><fmt:message key='project.body.backGround.label' />:</td>
							<td colspan="3" align="left">
	<table id="color_wheel" align="left" cellspacing="9" cellpadding="0" border="0" class="">
		<tr>
			<td color="#006aff" style="background:#006aff;"><span class="ok" style="display:block;"></span>&nbsp;</td>
			<td color="#15a4fa" style="background:#15a4fa;"><span class="ok" style="display:none;"></span>&nbsp;</td>
			<td color="#06a8a9" style="background:#06a8a9;"><span class="ok" style="display:none;"></span>&nbsp;</td>
			<td color="#0dab60" style="background:#0dab60;"><span class="ok" style="display:none;"></span>&nbsp;</td>
			<td color="#18a10f" style="background:#18a10f;"><span class="ok" style="display:none;"></span>&nbsp;</td>
			<td color="#dd0865" style="background:#dd0865;"><span class="ok" style="display:none;"></span>&nbsp;</td>
		</tr>
	</table>
			 				</td>
			 				<td></td>
						</tr>
					</table>
				
			</div>
		</td>
	</tr>
	<c:if test="${isNewDialog == 0 }">
	<tr height="42px;">
		<td height="100%" align="center" class="bg-advance-bottom">
			<input type="hidden" name="ptest" value="">
			<input type="submit" id="b1" name="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2" style="cursor: pointer;background-color:rgb(66, 179, 229);background-repeat:repeat-x;">&nbsp; 
			<input type="reset" id="b2" name="b2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="cancelOk()">
		</td>
		<td></td>
	</tr>
	</c:if>
</table>
</form>
<script>
doResize();
</script>
</body>
</html>
