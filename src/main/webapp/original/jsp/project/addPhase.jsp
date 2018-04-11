<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<c:if test="${param.type == 'add'}">
	<fmt:message key='project.phase.add.title.label' var='titleLabel' />
</c:if>
<c:if test="${param.type == 'update'}">
	<fmt:message key='project.phase.title.edit.label' var='titleLabel' />
</c:if>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${titleLabel}<fmt:message key='project.body.phase.label' /></title>
<script type="text/javascript">
	$(document).ready(function(){
		if(${param.type == "update"}){
			var obj = transParams.parentWin;
			var phase = obj.projectArr.get("${param.id}");
			$("#phaseId").val(phase.phaseId);
        	$("#phaseName").val(phase.phaseName);
        	$("#phaseBegintime").val(phase.phaseBegintime);
        	$("#phaseClosetime").val(phase.phaseClosetime);
        	$("#beforeAlarmDate").val(phase.beforeAlarmDate);
        	$("#endAlarmDate").val(phase.endAlarmDate);
        	$("#phaseDesc").val(phase.phaseDesc);
		}
	});
	
	/**
	 * 增加项目阶段
	 */
	function addPhase(){
		var myForm = $("#addPhaseForm")[0];
		
		if(!checkForm(myForm)){
			return;
		}

		if(!notSpecChar($("#phaseName")[0]) || !notSpecChar($("#phaseDesc")[0])){
			return;
		}

		var obj = transParams.parentWin;

		var parentBegintime = obj.$("#begintime").val();
		var parentClosetime = obj.$("#closetime").val();
		var phaseBegintime = $("#phaseBegintime").val();
		var phaseClosetime = $("#phaseClosetime").val();
		
		if(phaseBegintime == '' || phaseBegintime.length == 0){
			alert(v3x.getMessage("ProjectLang.project_phase_startdate_can_not_null"));
			return;
		}
		
		if(phaseClosetime == '' || phaseClosetime.length == 0){
			alert(v3x.getMessage("ProjectLang.project_phase_enddate_can_not_null"));
			return;
		}
		
		if(compareDate(phaseBegintime, parentBegintime) < 0){
			alert(v3x.getMessage("ProjectLang.phase_startdate_must_late_than_project_startdate"));
			return;
		}else if(compareDate(phaseBegintime, parentClosetime) > 0){
			alert(v3x.getMessage("ProjectLang.phase_startdate_can_not_late_than_project_enddate"));
			return;
		}
		
		if(compareDate(phaseClosetime, parentBegintime) < 0){
			alert(v3x.getMessage("ProjectLang.phase_enddate_must_late_than_project_startdate"));
			return;
		}else if(compareDate(phaseClosetime, parentClosetime) > 0){
			alert(v3x.getMessage("ProjectLang.phase_enddate_can_not_late_than_project_enddate"));
			return;
		}
		
		if(compareDate(phaseBegintime, phaseClosetime) > 0){
			alert(v3x.getMessage("ProjectLang.phase_startdate_can_not_late_than_enddate"));
			return;
		}

       	var phaseId;
       	if(${param.type == "update"}){
       		phaseId = $("#phaseId").val();
		}else{
			phaseId = getUUID();
		}

       	var phaseName = $("#phaseName").val();
       	
       	if(!checkPhase(obj, phaseBegintime, phaseClosetime, "${param.type}", phaseId, phaseName)){
			return;
		}
		
       	var phaseBegintime1 = phaseBegintime;
       	var phaseClosetime1 = phaseClosetime;
       	var beforeAlarmDate = $("#beforeAlarmDate").val();
       	var endAlarmDate = $("#endAlarmDate").val();
       	var phaseDesc = $("#phaseDesc").val();
       	var phase;
       	if(${param.type == "update"}){
       		phase = obj.projectArr.get(phaseId);
       		phase.phaseName = phaseName;
       		phase.phaseBegintime = phaseBegintime1;
       		phase.phaseClosetime = phaseClosetime1;
       		phase.beforeAlarmDate = beforeAlarmDate;
       		phase.endAlarmDate = endAlarmDate;
       		phase.phaseDesc = phaseDesc;
		}else{
			phase = new Phase(phaseId, phaseName, phaseBegintime1, phaseClosetime1, beforeAlarmDate, endAlarmDate, phaseDesc);
        	obj.projectArr.put(phaseId, phase);
		}
       	obj.addPhaseTr(phaseId, "${param.type}");

       	closeWindow();
    }
	
	/**
	 * 校验阶段在某个时间段内是否已存在
	 */
    function checkPhase(obj, phaseBegintime, phaseClosetime, type, id, phaseName){
        var phases = obj.projectArr;
        var phasesKeys = phases.keys();
        var update = true;
        for(var i = 0; i < phasesKeys.size(); i ++){
            var phaseObj = phases.get(phasesKeys.get(i));
            var phaseObjBegintime = phaseObj.phaseBegintime;
            var phaseObjClosetime = phaseObj.phaseClosetime;
            if(type == "update"){
                update = phasesKeys.get(i) != id;
            }else{
                update = true;
            }
            if(update){
            	if(phaseObj.phaseName == phaseName){
                	alert(v3x.getMessage("ProjectLang.project_phase_name_repeat"));
            		return false;
	            	break;
                }
                
            	//屏蔽验证阶段时间重叠的功能
	            /**if((compareDate(phaseBegintime, phaseObjBegintime) >= 0 && compareDate(phaseBegintime, phaseObjClosetime) <= 0) || 
	            		(compareDate(phaseClosetime, phaseObjBegintime) >= 0 && compareDate(phaseClosetime, phaseObjClosetime) <= 0)){
	        		alert(v3x.getMessage("ProjectLang.project_phase_valid"));
	            	return false;
	            	break;
	            }*/
            }
        }
        return true;
	}
   
   	/**
	 * 判断是否有变动
	 */
	var i=0;
	function sign(){
   		i++;   	
	}

	/**
	 * 取消
	 */
	function cancle(){
		if(i == 0){
			closeWindow();
	   	}else{
	   		if(confirm(v3x.getMessage("ProjectLang.project_phase_is_change"))){
				addPhase();
	   		}else{
	   			closeWindow();
	   		}
	   	}
	}
	
	function closeWindow(){
		getA8Top().addPhaseDialog.close();
	}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
	<form action="" method="post" name="addPhaseForm" id="addPhaseForm">
		<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="20" class="PopupTitle" colspan="5" nowrap="nowrap"> 
                    ${titleLabel}<fmt:message key='project.body.phase.label' />
				</td>
			</tr>
			<tr>
				<td align="right" nowrap="nowrap"><font color="red">*</font><fmt:message key='project.phase.name.label' />:</td>
				<td colspan="3" style="padding-left: 10px;" nowrap="nowrap">
					<input type="hidden" id="phaseId" name="phaseId"/>
					<input type="text" id="phaseName" name="phaseName" class="input-100per" onchange="sign();" validate="notNull" maxlength="30" inputName="<fmt:message key='project.phase.name.label' />"/>
				</td>
				<td width="10%">&nbsp;</td>
			</tr>
			<tr>
				<td align="right" width="15%" nowrap="nowrap"><font color="red">*</font><fmt:message key='project.startime' />:</td>
				<td style="padding-left: 10px;" width="40%" nowrap="nowrap">
					<input type="text" id="phaseBegintime" name="phaseBegintime" onchange="sign();" readonly="readonly" class="textfield cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'date');" />
				</td>
				<td width="10%" align="right" nowrap="nowrap"><font color="red">*</font><fmt:message key='project.endtime' />:</td>
				<td align="right" width="20%" nowrap="nowrap">
					<input type="text" id="phaseClosetime" name="phaseClosetime" onchange="sign();" readonly="readonly" class="textfield cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'date');" />
				</td>
				<td width="10%" nowrap="nowrap">&nbsp;</td>
			</tr>
			<tr>
				<td align="right" width="15%" nowrap="nowrap"><fmt:message key='cal.event.alarmFlag' />:</td>
				<td style="padding-left: 10px;" width="40%" nowrap="nowrap">
					<select id="beforeAlarmDate" name="beforeAlarmDate" onchange="sign();" class="textfield">
						<v3x:metadataItem metadata="${remindTimeMetaData}" showType="option" name="beforeAlarmDate" selected="" />
					</select>
				</td>
				<td width="10%" align="right" nowrap="nowrap"><fmt:message key='cal.event.alarmFlag.beforend'/>:</td>
				<td align="right" width="20%" nowrap="nowrap">
					<select id="endAlarmDate" name="endAlarmDate" onchange="sign();" class="textfield">
						<v3x:metadataItem metadata="${remindTimeMetaData}" showType="option" name="endAlarmDate" selected="" />
					</select>
				</td>
				<td width="10%">&nbsp;</td>
			</tr>
			<tr>
				<td align="right" valign="top"><fmt:message key='project.desc' />:</td>
				<td valign="top" colspan="3" style="padding-left: 10px;">
					<textarea style="resize: none;" id="phaseDesc" name="phaseDesc" onchange="sign();" rows="6" class="input-100per" inputName="<fmt:message key='project.desc' />" maxSize="150"  validate="maxLength" ></textarea>
				</td>
				<td width="10%">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5" align="center" class="bg-advance-bottom" style="background: #F3F3F3">   
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="center">
								<input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="addPhase();">
								<input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="cancle();">
							</td>   
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>