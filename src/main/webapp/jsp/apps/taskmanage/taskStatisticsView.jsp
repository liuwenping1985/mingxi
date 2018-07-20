<%--
 $Author: xiangq $
 $Rev: 1785 $
 $Date:: 2013-1-9 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('common.toolbar.statistics.label')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<%@ include file="taskStatisticsView.js.jsp" %>
<%@ include file="taskStatisticsViewEvent.js.jsp" %>
<script>
$(document).ready(function(){
    initUI();
    initStatisticsPic();
    initBindEvent();
    $("#importExcel").click(function(){
            $("#condition_set").hide("normal",function(){
    			if ($(this).is(':hidden')) {
    				layout.setNorth(80);
    				return;
    			}
    	    });
    });
});
</script>
</head>
<body class="h100b overflow_hidden page_color" id="layout">
        <div class="layout_north page_color" id="north">
            <div class="form_area set_search padding_b_10 margin_5 ">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td width="100%" valign="top">
                            <fieldset class="fieldset_box margin_t_5 page_color" id="condition_content_area">
                                <legend>查询条件:</legend>
                                <table>
                                	<tr>
                                		<td>
			                                <div id="statistics_frm" class="margin_5">
			                                    <label class="margin_r_5" for="text">时间:</label>
			                                    <select id="select_date" name="select_date" >
			                                        <option value="week">本周</option>
			                                        <option value="month">本月</option>
			                                        <option value="random">任意期</option>
			                                    </select>                                    
			<!--                                     <a id="btnweek" class="common_button common_button_gray active" href="javascript:void(0)">本周</a> -->
			<!--                                     <a id="btnmonth" class="common_button common_button_gray margin_l_5" href="javascript:void(0)">本月</a> -->
			                                    &nbsp;&nbsp;&nbsp;&nbsp;
			                                    <input id="startTime" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d '" readonly="readonly"/>
			                                    <label class="margin_r_5 margin_l_5" for="text" id="txt">至</label>                  
			                                    <input id="endTime" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d '" readonly="readonly"/>
			                                    &nbsp;&nbsp;&nbsp;
			                                    <a id="condition_set_btn" href="javascript:void(0)">条件设置</a>
			                                    <input type="hidden" id="statisticsType" name="statisticsType" />
			                                    <input type="hidden" id="userId" name="userId" />
			                                    <input type="hidden" id="roleType" name="roleType" />
			                                    <input type="hidden" id="status" name="status" />
			                                    <input type="hidden" id="riskLevel" name="riskLevel" />
			                                    <input type="hidden" id="importantLevel" name="importantLevel" />
			                                    <input type="hidden" id="statistics_id" name="statistics_id" />
			                                    
			                                </div>
			                                <div id="condition_set" class="form_area clearfix padding_b_5 border_all hidden" style="width: 474px;margin-left: 5px">
			                                    <table class="margin_l_5" cellpadding="0" width="100%" cellspacing="0" >
			                                        <tr>
			                                            <th nowrap="nowrap"><label class="margin_r_5" for="text">人员选择:</label></th>
			                                            <td width="100%">
			                                                <div class="common_selectbox_wrap left">
			                                                    <select id="select_user" name="select_user"  style="width: 100px;">
			                                                    </select>
			                                                </div>
			                                            </td>
			                                        </tr>
			                                        <tr id="role_select_info">
			                                            <th nowrap="nowrap"><label class="margin_r_5" for="text">我的角色:</label></th>
			                                            <td width="100%" colspan="4">
			                                                <div class="common_checkbox_box clearfix ">
			                                                    <label class="margin_r_10 hand" for="all_role_chk">
			                                                        <input id="all_role_chk" class="radio_com" name="role_type_all" value="-1" type="checkbox">全部</label>
			                                                    <label class="margin_r_10 hand" for="inspectors_chk">
			                                                        <input id="inspectors_chk" class="radio_com" name="role_type" value="3" type="checkbox">${ctp:i18n("taskmanage.inspector")}</label>
			                                                    <label class="margin_r_10 hand" for="managers_chk">
			                                                        <input id="managers_chk" class="radio_com" name="role_type" value="1" type="checkbox">${ctp:i18n("taskmanage.manager")}</label>
			                                                    <label class="margin_r_10 hand" for="participators_chk">
			                                                        <input id="participators_chk" class="radio_com" name="role_type" value="2" type="checkbox">${ctp:i18n("taskmanage.participator")}</label>
			                                                    <label class="margin_r_10 hand" for="create_user_chk">
			                                                        <input id="create_user_chk" class="radio_com" name="role_type" value="0" type="checkbox">${ctp:i18n("common.creater.label")}</label>
			                                                </div>
			                                            </td>
			                                        </tr>
			                                        <tr id="status_select_info">
			                                            <th nowrap="nowrap"><label class="margin_r_5" for="text">状态:</label></th>
			                                            <td width="100%" colspan="4">
			                                                <div class="common_checkbox_box clearfix ">
			                                                    <label class="margin_r_10 hand" for="all_status_chk">
			                                                        <input id="all_status_chk" class="radio_com" name="status_all" value="-1" type="checkbox">全部</label>
			                                                    <label class="margin_r_10 hand" for="notstarted_chk">
			                                                        <input id="notstarted_chk" class="radio_com" name="status_ck" value="1" type="checkbox">${ctp:i18n("taskmanage.status.notstarted")}</label>
			                                                    <label class="margin_r_10 hand" for="marching_chk">
			                                                        <input id="marching_chk" class="radio_com" name="status_ck" value="2" type="checkbox">${ctp:i18n("taskmanage.status.marching")}</label>
			                                                    <label class="margin_r_10 hand" for="finished_chk">
			                                                        <input id="finished_chk" class="radio_com" name="status_ck" value="4" type="checkbox">${ctp:i18n("taskmanage.status.finished")}</label>
			                                                    <label class="margin_r_10 hand" for="delayed_chk">
			                                                        <input id="delayed_chk" class="radio_com" name="status_ck" value="3" type="checkbox">${ctp:i18n("taskmanage.status.delayed")}</label>
			                                                    <label class="margin_r_10 hand" for="canceled_chk">
			                                                        <input id="canceled_chk" class="radio_com" name="status_ck" value="5" type="checkbox">${ctp:i18n("taskmanage.status.canceled")}</label>
			                                                </div>
			                                            </td>
			                                        </tr>
			                                        <tr id="risk_select_info">
			                                            <th nowrap="nowrap"><label class="margin_r_5" for="text">风险:</label></th>
			                                            <td width="100%" colspan="4">
			                                                <div class="common_checkbox_box clearfix ">
			                                                    <label class="margin_r_10 hand" for="all_risk_chk">
			                                                        <input id="all_risk_chk" class="radio_com" name="risk_level_all" value="-1" type="checkbox">全部</label>
			                                                    <label class="margin_r_10 hand" for="no_chk">
			                                                        <input id="no_chk" class="radio_com" name="risk_level" value="0" type="checkbox">${ctp:i18n("taskmanage.risk.no")}</label>
			                                                    <label class="margin_r_10 hand" for="low_chk">
			                                                        <input id="low_chk" class="radio_com" name="risk_level" value="1" type="checkbox">${ctp:i18n("taskmanage.risk.low")}</label>
			                                                    <label class="margin_r_10 hand" for="normal_chk">
			                                                        <input id="normal_chk" class="radio_com" name="risk_level" value="2" type="checkbox">${ctp:i18n("taskmanage.risk.normal")}</label>
			                                                    <label class="margin_r_10 hand" for="high_chk">
			                                                        <input id="high_chk" class="radio_com" name="risk_level" value="3" type="checkbox">${ctp:i18n("taskmanage.risk.high")}</label>
			                                                </div>
			                                            </td>
			                                        </tr>
			                                        <tr id="importantlevel_select_info">
			                                            <th nowrap="nowrap"><label class="margin_r_5" for="text">重要程度:</label></th>
			                                            <td width="100%" colspan="4">
			                                                <div class="common_checkbox_box clearfix ">
			                                                    <label class="margin_r_10 hand" for="all_importantlevel">
			                                                        <input id="all_importantlevel" class="radio_com" name="importantlevel_all" value="0" type="checkbox">全部</label>
			                                                    <label class="margin_r_10 hand" for="general_chk">
			                                                        <input id="general_chk" class="radio_com" name="important_level" value="1" type="checkbox">${ctp:i18n("common.importance.putong")}</label>
			                                                    <label class="margin_r_10 hand" for="important_chk">
			                                                        <input id="important_chk" class="radio_com" name="important_level" value="2" type="checkbox">${ctp:i18n("common.importance.zhongyao")}</label>
			                                                    <label class="margin_r_10 hand" for="veryimportant_chk">
			                                                        <input id="veryimportant_chk" class="radio_com" name="important_level" value="3" type="checkbox">${ctp:i18n("common.importance.feichangzhongyao")}</label>
			                                                </div>
			                                            </td>
			                                        </tr>
			                                    </table>
			                                    <a href="javascript:void(0)" id="save_statistics" class="margin_l_5">保存到我的统计</a>
			                                    <a class="margin_l_10 hidden" href="javascript:void(0)" id="delete_statistics">删除我的统计</a>
			                                </div>
                                		</td>
			                            <td valign="bottom">
			                            	<a class="common_button margin_l_20" href="javascript:void(0)" id="statistics_btn">统计</a>
			                            </td>
                            		</tr>
                            	</table>
                            </fieldset>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <!--查询设置end-->
        <div class="layout_center over_hidden" id="center">
         <div class="stadic_layout_head stadic_head_height" style="height:30px;">
          
            <div class="  set_search align_right">
                <span class="right"><a class="img-button margin_r_5" href="javascript:void(0)" id="importExcel"><em class="ico16 export_excel_16"></em>导出Excel</a></span>
                <span class="left margin_5 margin_b_10">统计结果：</span>
                <span class="left margin_t_5 margin_b_10">
                    <div class="common_radio_box clearfix align_left" id="chart_info">
                        <input type="hidden" id="index_names" name="index_names" value="未开始,进行中,已完成,已取消,已延迟"/>
                        <input type="hidden" id="data_list" name="data_list" value="100,50,200,30,130"/>
                        <label class="margin_r_10 hand" for="chart_radio1" title="饼图">
                            <input id="chart_radio1" class="radio_com" name="chart_option" value="pie" type="radio" checked="checked"/>
                            <span class="ico16 pie_chart_16"></span>
                        </label>
                        <label class="margin_r_10 hand" for="chart_radio2" title="折线图">
                            <input id="chart_radio2" class="radio_com" name="chart_option" value="line" type="radio"/>
                            <span class="ico16 line_chart_16"></span>
                        </label>
                        <label class="margin_r_10 hand" for="chart_radio3" title="柱状图">
                            <input id="chart_radio3" class="radio_com" name="chart_option" value="histogram" type="radio"/>
                            <span class="ico16 histogram_chart_16"></span>
                        </label>
                        <label class="margin_r_10 hand" for="chart_radio4" title="表格">
                            <input id="chart_radio4" class="radio_com" name="chart_option" value="biaoge" type="radio"/>
                            <span class="ico16 form_16"></span>
                        </label>
                    </div>
                </span>
                <iframe id="exportExcelIframe" name="exportExcelIframe" frameborder="0" marginheight="0" marginwidth="0" style="display: none;"></iframe>
            </div>
          
        </div>
      <div class="stadic_layout_body stadic_body_top_bottom h100b" style="top:30px;bottom:0;background:#fff;">  
            <div class="search_result clear" style="">
                <table id="statistics_table" class="only_table edit_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
                
                </table>
                <div id="statistics_chart" class="align_center"></div>
            </div>
       </div>
        </div>
    </body>
</html>
