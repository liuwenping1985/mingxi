<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html style="${transparentStyle}">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>项目空间头部信息</title>
  <script type="text/javascript" src="${path}/ajax.do?managerName=projectAjaxManager"></script>
  <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/projectConfigListEvent.js${ctp:resSuffix()}"></script>
  <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/projectSpaceHead.js${ctp:resSuffix()}"></script>
  <script type="text/javascript">
  $(document).ready(function() {
  	$(".projectTask_head").css("background-color","#e8e8e8");
    //设置图标上的事件
    var _NameStr = "${v3x:toHTML(longPojectName) }";
    if($.browser.msie&&parseInt($.browser.version,10)<=7)
    {
		$("#p_title").html(cutString(_NameStr,40));
    }else{
    	$("#p_title").html(_NameStr);
    }
    var phaseName = "${phaseName}";
    $("#phaseName").html(cutPhaseName(phaseName));
    $("#phaseName").attr("title",phaseName);
    
    if(${isManagerOrAssistant}){//判断是否是 项目负责人 或者 项目助理
    	$("#projectSet").attr("title","${ctp:i18n('project.info.title.set')}");
    	$("#setEm").addClass("ico24 project_search_24");
    	if(!${projectIsOver}){//判断项目状态  项目已开始
			$("#projectSet").menuSimple({
				width:100,
				offsetLeft : -115,
				offsetTop : -60,
				disabled:"BL",
				data: [{
					name: "${ctp:i18n('project.set.label')}",
					handle: function () {
						//设置项目
						var data = new Object();
						data.id = "${projectId}";
						data.projectIState = ${projectState};
						data.canEditorDel = true;
						viewOrSetProgect(data)
					}
				}, {
					name: "${ctp:i18n('project.space.settings')}",
					handle: function () {
						getCtpTop().showMenu("${setProjectSpaceURL}");
					}
				}]
			});
   			$("#setEm").mouseenter(function(){
				$("#projectSet").click();
   			});
   		}else {//项目 已完成
   			$("#projectSet").menuSimple({
				width:100,
				offsetLeft : -115,
				offsetTop : -60,
				disabled:"BL",
				data: [{
					name: "${ctp:i18n('project.view.this.project')}",
					handle: function () {
						//查看项目
						var data = new Object();
						data.id = "${projectId}";
						data.projectIState = ${projectState};
						data.canEditorDel = true;
						viewOrSetProgect(data, "${ctp:i18n('project.view.this.project')}")
					}
				}, {
					name: "${ctp:i18n('project.space.settings')}",
					handle: function () {
						getCtpTop().showMenu("${setProjectSpaceURL}");
					}
				}]
			});
   			$("#setEm").mouseenter(function(){
				$("#projectSet").click();
   			});
   		}	
   	}else{
   		$("#projectSet").attr("title","${ctp:i18n('project.view.this.project')}");
   		$("#setEm").addClass("ico24 project_view_24");
   		$("#projectSet").unbind("click").bind("click",function(){
   			var data = new Object();
			data.id = "${projectId}";
			data.projectIState = ${projectState};
			data.canEditorDel = false;
			doubleClickEvent(data, "", "","")
   		});
   	}
    //动态设置项目空间的的最小宽度
    var tb = $("#projectTask_head_body").width();
    var tw = $(".projectTask_head table").width();
    if(tb<tw){
    	$("body", parent.document).css({"min-width":$(".projectTask_head table").width()+30})
    }
  });
  </script>
</head>
<body class="h100b over_hidden" style="${transparentStyle}" id="projectTask_head_body">
  <div class="projectTask_head">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td nowrap="nowrap">
          <p onclick="reloadPageCallBack();" class="title hand" title="${projectName}" id="p_title"></p>
          <p>${ctp:i18n('project.detail.projecttime')}：${projectTime}
          	<input type="hidden" id="beginDate" value="${beginDate}"/>
          	<input type="hidden" id="endDate" value="${endDate}"/>
          	<c:if test="${not empty phaseBeginDate}">
          		<c:forEach var="phase" varStatus="status" items="${phaseSet}">
							<c:if test="${phaseId == phase.id}">
								<input type="hidden" id="phaseBeginDate" value="${phaseBeginDate }"/>
          						<input type="hidden" id="phaseEndDate" value="${phaseEndDate }"/>
							</c:if>
				</c:forEach>	
          	</c:if>
          	<c:if test="${not projectIsOver and timing le 5 and timing ge 0}">
          		<span class="countdown_time">${ctp:i18n('project.the.countdown')}<span class="num">${timing}</span>${ctp:i18n('project.end.day')}</span>
			</c:if>
          	<c:if test="${not projectIsOver and  timing lt 0}">
          		<span class="countdown_time color_red">${ctp:i18n('project.body.projectstate.4')}</span>
			</c:if>
          </p>
        </td>
        <td width="1%" nowrap="nowrap" class="padding_l_20 padding_r_20">
          	<div style="padding-top:2px"><c:if test="${not empty projectCharges}">${ctp:i18n('project.body.manger.label')}：
          		<c:forEach var="memberBo" varStatus="status" items="${projectCharges}">
          			<a class="cursor-hand color_black" title="${memberBo.memberName}" onclick="displayMemberInfo('${memberBo.memberId}')">${memberBo.shortName}</a>
        		</c:forEach>
        		</c:if>
        		<c:if test="${empty projectCharges}">&nbsp;</c:if>
          	</div>
          	<div style="padding-top:12px">${ctp:i18n('project.body.responsible.label')}：
          		<c:forEach var="memberBo" varStatus="status" items="${projectLeader}">
          			<a class="cursor-hand color_black" title="${memberBo.memberName}" onclick="displayMemberInfo('${memberBo.memberId}')">${memberBo.shortName}</a>
        		</c:forEach>
			</div>
        </td>
        <td width="224" class="padding_r_10" nowrap="nowrap">
        	<c:if test="${not empty phaseSet}">
						<p>
						${ctp:i18n('project.body.phase.current.label')}：<span id="phaseName"></span>
							<c:if test="${isManagerOrAssistant}">
								<c:if test="${!autoChangePhase}">
									<em title="${ctp:i18n('project.edit.phase')}" onclick="modifyPhase()" class="ico16 bannerEditor_16"></em>
								</c:if>
								<c:if test="${autoChangePhase}">
									<%-- 自动切换状态，em图标就不显示了 --%>
								</c:if>
							</c:if> 
						</p>
				<div style="white-space:nowrap; overflow:hidden;max-width:200px">
				${ctp:i18n('project.body.phaseSwitch.label')}：<select name="changePhase" style="max-width:120px" onchange="changePhase()" id="changePhase" class="changeSelect">
						<option value="1"}>${ctp:i18n('project.phase.all')}</option>
						<c:forEach var="phase" varStatus="status" items="${phaseSet}">
							<option value="${phase.id}" ${phaseId == phase.id ? 'selected' : ''}>${phase.phaseName}</option>
						</c:forEach>	
				</select>
				</div>
			</c:if>
        </td>
        <td width="60" align="center" id="showTD">
          <div class="percentage" id="percentage" >${projectProcess}%</div>
        </td>
        <td width="60" align="center" class="hidden" id="editTd">
        <div class="percentage_errorTips hidden" id="percentage_edit_error_div">
            <div><span class="arrow"><span></span></span><em class="ico16 stop_contract_16"></em>${ctp:i18n('project.modify.process.prompt') }</div>
          </div>
          <div class="percentage_edit">
          	<input type="text" width="20" id="percentageEdit"  onBlur="modifyFinish();" onkeyDown="keyDown(event)" value="${projectProcess}">%
          </div>
        </td>
        <td width="16" align="left" valign="bottom">
        	<c:if test="${isManagerOrAssistant}">
        		<!-- OA-87771目标管理：项目任务--更多--导出/新建/修改进度的小图标显示不全 -->
          		<em onclick="modifyProcess()" title="${ctp:i18n('project.edit.process')}" class="ico16 bannerEditor_16 margin_b_1"></em>
			</c:if>
        </td>
        <td width="65" align="right" valign="bottom">
          <div id="projectSet" style="width:20px;"><em id="setEm"></em></div>
        </td>
      </tr>
    </table>
    <div class="projectTask_head_bg_white"></div>
    <div class="projectTask_head_bg_blue hidden">
    	<input type="hidden" id="projectId" name="projectId" value="${projectId}"/>
		<input type="hidden" id="phaseId" name="phaseId" value="${phaseId}"/>
		<input type="hidden" id="projectProcess" name="projectProcess" value="${projectProcess}"/>
		<input type="hidden" id="projectIsOver" name="projectIsOver" value="${projectIsOver}"/>
    </div>
  </div>
 </body>
</html>