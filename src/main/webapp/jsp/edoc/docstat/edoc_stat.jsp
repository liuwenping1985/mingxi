<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=edocStatNewManager"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/edoc_stat.js${v3x:resSuffix()}" />"></script>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<script>
	var _ctxPath = '${path}';
	var edocStatUrl = _ctxPath+"/edocStatNew.do";
	var startTimeLabel_0 = '${ctp:i18n("edoc.element.createdate")}';
	var startTimeLabel_1 = '${isG6Version ? ctp:i18n("edoc.edoctitle.disDate.label") : ctp:i18n("edoc.edoctitle.regDate.label")}';
	var startTimeTitleLabel_0 = '${ctp:i18n("edoc.stat.condition.rangeTime.label.nigao")}';
	var startTimeTitleLabel_1 = '${isG6Version ? ctp:i18n("edoc.stat.condition.rangeTime.label.fengfa") : ctp:i18n("edoc.stat.condition.rangeTime.label.dengji")}';
	var isAccountExchange = "${isAccountExchange}"=="true";
	var isDeptExchange = "${isDeptExchange}"=="true";
	var currentDeptId = "${currentDeptId}";
	var currentAccountId = "${currentAccountId}";
	var currentDeptIds = "${currentDeptIds}";
	var allDeptIds = "${allDeptIds}";
	var isG6Version = "${isG6Version}"=="true";
	var startRangeTime = "${startRangeTime}";
	var endRangeTime = "${endRangeTime}";
	var defaultRangeNames = "${defaultRangeNames}";
	var defaultRangeIds = "${defaultRangeIds}";
</script>
<title></title>
<style type="text/css">
    .stadic_body_top_bottom{
        bottom: 0px;
    }
    .stadic_body_footer_bottom{
        bottom: 35px;
    }
    .set_search input[type="text"]{ width:237px; height:26px}
</style>
</head>
<body scroll="">
<div id="layout" class="comp bg_color" comp="type:'layout'">
	<div class="layout_north" id="layout_north" layout="height:180,maxHeight:180,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(180);}}">
		
		<div id="tabs" class="margin_t_5 margin_r_5 ">
      		<div class="border_alls">
           		<div class="form_area"  id="queryCondition" >
           			<form id="statConditionForm">
           			<div class="form_area set_search">
           				<table border="0" cellpadding="0" cellspacing="0" class="common_center w90b">
           					<tbody>
           						<tr class="margin_b_10">
           							<td align="right" width="60" nowrap="nowrap" class="padding_r_10"><label id="startTimeLabel"></label>:</td><%-- 拟稿日期 --%>
									<td class="padding_tb_5">
										<input id="startRangeTime" lastTime="${startRangeTime }" value="${startRangeTime }" readonly="readonly" style="width:115px; height:26px" class="comp validate" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,onUpdate:checkAwakeDate" validate="name:'开始日期',notNull:true"  />
										<span>-</span>
										<input id="endRangeTime" lastTime="${endRangeTime }" value="${endRangeTime }" readonly="readonly" style="width:115px; height:26px" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,onUpdate:checkAwakeDate" />
									</td>
									<td style="width:130px;">&nbsp;</td>
           							<td align="right" width="60" nowrap="nowrap" class="padding_r_10">${ctp:i18n("edoc.stat.condition.edocType") }:</td><%-- 公文类别 --%>
	           						<td colspan="2" class="padding_r_50">
	           							<div class="common_selectbox_wrap" style="width:247px; margin-left:0px;">
								             <select id="edocType" name="edocType" style="height:30px" onchange="cleaTtemplate()">
												 <%--xuker 统计公文模板的选择加上新公文模板的类别 2016-03-03 start--%>
								             	<option value="0" modelType="19,401">${ctp:i18n("edoc.stat.condition.edocType.0") }</option><%-- 发文 --%>
												<option value="1" modelType="20,402" selected>${ctp:i18n("edoc.stat.condition.edocType.1") }</option><%-- 收文 --%>
												<%--xuker 统计公文模板的选择加上新公文模板的类别 2016-03-03 end--%>
												 <option value="2" modelType="21,404">${ctp:i18n("edoc.stat.condition.edocType.2") }</option><%-- 签报 --%>
								               </select>
										</div>
									</td>
           						</tr>
           						<tr>
									<td align="right" nowrap="nowrap" class="padding_r_10">${ctp:i18n("edoc.stat.org") }:</td><%-- 统计范围 --%>
									<td>
										<div align="left" class="common_txtbox_wrap" style="width:237px;margin-left:0px;">
											<input type="text" id="rangeNames" value="${defaultRangeNames }" readonly="readonly" class="validate color_gray" defaultValue="${ctp:i18n('edoc.stat.condition.defaultValue') }"/>
											<input type="hidden" id="rangeIds" value="${defaultRangeIds }" />
										</div>
									</td>
									<td>&nbsp;</td>
									<td align="right" nowrap="nowrap" class="padding_r_10">${ctp:i18n("edoc.stat.condition.unitLevel") }:</td><%-- 按公文级别 --%>
									<td colspan="2" class="padding_tb_5 padding_r_50">
										<div align="left" class="common_txtbox_wrap" style="width:237px;margin-left:0px;">
											<input type="text" id="unitLevelName" readonly="readonly" class="validate color_gray" defaultValue="${ctp:i18n('edoc.stat.condition.defaultValue') }"/>
											<input type="hidden" id="unitLevelId" />
										</div>
									</td>
           						</tr>
           						
           						<tr>
           							<td rowspan="2" align="right" valign="top" nowrap="nowrap" class="padding_r_10 padding_t_5">${ctp:i18n("edoc.stat.condition.statTo") }:</td><%-- 统计到 --%>
									<td rowspan="2" class="padding_t_5">
										<table class="w100b" border="0" cellpadding="0" cellspacing="0">
           									<tr>
	           									<td width="50"><input type="radio" class="margin_r_5 margin_b_5" name="displayType" value="1" checked />${ctp:i18n("edoc.stat.condition.statTo.Department") }</td><%-- 部门 --%>
	           									<td></td>
	           								</tr>
		           							<tr>
		           								<td><input type="radio" class="margin_r_5 " name="displayType" value="2" />${ctp:i18n("edoc.stat.condition.statTo.Member") }</td><%-- 个人 --%>
		           								<td></td>
		           							</tr>
		           							<tr>
		           								<td><input type="radio" class="margin_r_5 " name="displayType" value="3" />${ctp:i18n("edoc.stat.condition.statTo.Time") }</td><%-- 时间 --%>
		           								<td >
		           									<div class="common_selectbox_wrap" style="width:60px;margin-left:5px;">
										             	<select id="displayTimeType" name="displayTimeType" class="w100b">
										             		<option value="1">${ctp:i18n("edoc.stat.condition.statTo.Time.year") }</option>
															<option value="2">${ctp:i18n("edoc.stat.condition.statTo.Time.quarter") }</option>
															<option value="3">${ctp:i18n("edoc.stat.condition.statTo.Time.month") }</option>
															<option value="4">${ctp:i18n("edoc.stat.condition.statTo.Time.date") }</option>
														</select>
													</div>
		           								</td>
		           							</tr>
           								</table>
									</td>
									<td rowspan="2">&nbsp;</td>
           							<td align="right" nowrap="nowrap" class="padding_r_10">${ctp:i18n("edoc.element.sendtype") }:</td><%-- 行文类型 --%>
           							<td colspan="2">
										<div align="left" class="common_txtbox_wrap" style="width:237px;margin-left:0px;">
											<input type="text" id="sendTypeName" readonly="readonly" class="validate color_gray" defaultValue="${ctp:i18n('edoc.stat.condition.defaultValue') }" />
											<input type="hidden" id="sendTypeId" />
										</div>
									</td>	
           						</tr>
           						<tr>
         								<td align="right" class="padding_r_10">${ctp:i18n("edoc.stat.condition.workflow") }:</td><%-- 按流程类型 --%>
										<td width="175">
											<div class="common_checkbox_box"  style="width: 160px;">
												<input type="checkbox" id="workflowByPersonal" value="self" class="margin_r_5" checked />${ctp:i18n("edoc.stat.condition.workflow.self") }<%-- 自由流程 --%>
												<input type="checkbox" id="workflowBySystem" value="template" class="margin_r_5 margin_l_10" checked />${ctp:i18n("edoc.stat.condition.workflow.system") }<%-- 模板流程 --%>
											</div>
										</td>
										<td>
											<div align="left" class="common_txtbox_wrap " style="width:63px;margin-left:0px;">
												<input type="text"  id="templateName" readonly="readonly" class="validate color_gray" defaultValue="${ctp:i18n('edoc.stat.condition.defaultValue') }"/>
												<input type="hidden" id="operationTypeIds" />
												<input type="hidden" id="operationType" value=""/>
											</div>
										</td>
         							</tr>          			
                                <!--页面 "统计" "重置" 按键居中  -->
								<tr>
           						<td class="align_center" colspan="7">
           							<div class="align_center clear padding_lr_5 padding_b_10" id="button_div"> 
	    								<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_5" id="querySave" onclick="executeStatistics()">${ctp:i18n("edoc.stat.execute.statistics") }</a><%-- 统计 --%>
	    								<a id="queryReset" class="common_button common_button_gray margin_r_10" href="javascript:void(0)" onclick="resetResult()">${ctp:i18n("edoc.stat.execute.reset") }</a><%-- 重置 --%>
	    							</div>
           						</td>           						
           						</tr> 
           						
           					</tbody>
           				</table>
           			</div>
           			<input type="hidden" id="statTitle" name="statTitle" />
           			</form>
           		</div>           		
                <form action="#" id="resolveExecel">
                    <div id="execelCondition"></div>
                </form>
            </div><!-- border_alls -->
        </div><!-- tabs -->
	</div><!-- layout_north -->
	<div class="layout_center stadic_layout" layout="border:true">
		<div class="set_search align_left" id="oper">
			<table class="w100b">
       			<tr>
                	<td colspan="2">
                    	<span class="left">
                    		<a class="img-button" href="javascript:void(0)" id="sendTo" onclick="pushStatResult()"><em class="ico16 send_to_16"></em>${ctp:i18n("common.search.PushHome.label")}</a>
                        	<a class="img-button" href="javascript:void(0)" id="reportToExcel" onclick="fnDownExcel()"><em class="ico16 export_excel_16"></em>${ctp:i18n("edoc.tbar.export.js")}</a> 
                            <a class="img-button" href="javascript:void(0)" id="printReport" onclick="printColl()"><em class="ico16 print_16"></em>${ctp:i18n("edoc.tbar.print.js")}</a> 
                     	</span>
                 	</td>
             	</tr>
       		</table> 
		</div>
     	<div class="stadic_layout_body stadic_body_top_bottom" id="reportResult" style="overflow:hidden;">
			<div id="tabs" class="w100b h100b">
				<div id="tabBody" class="border_tb common_tabs_body stadic_layout_body stadic_body_top_bottom" style="top:0px;bottom:30px;overflow:hidden;">
				    <div style="position: absolute;height: 100%;left: 5px;top: 0px;right: 5px;">
				        <iframe id="resultFrame" name="resultFrame" src="" scrolling="no" frameborder="0" style="width:100%;height:100%;background-color:white;"></iframe>
				    </div>
				</div>
				<div class="stadic_layout_footer stadic_footer_height margin_l_5" style="line-height: 30px;">
       				${ctp:i18n("edoc.stat.result.note") }
           		</div><!-- stadic_layout_footer -->
			</div><!-- tabs -->
      	</div><!-- reportResult -->

	</div>
</div><!-- layout -->
</body>
</html>