<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.ctp.monitor.perfmon.PerfLogConfig"%>
<%@page import="com.seeyon.ctp.monitor.domain.MonitorConfig"%>
<%@page import="com.seeyon.ctp.plugin.sensor.domain.Dispatcher"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
  <script type="text/javascript">
	  var v3x = new V3X();
	  v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
	  showCtpLocation('F13_sysInfoOpen');
  </script>
<jsp:useBean id="perfCfg" class="com.seeyon.ctp.monitor.perfmon.PerfLogConfig"/>
<jsp:useBean id="mConfig" class="com.seeyon.ctp.monitor.domain.MonitorConfig"/>
<%
    String isRunning = request.getParameter("isRunning");
    if (isRunning != null) {
        if (isRunning.equals("false")) {
            perfCfg.setRunning(false);
            //关闭传感器
            Dispatcher.getInstance().stop();
        } else {
            perfCfg.setRunning(true);
            //开启传感器进行日志收集
            Dispatcher.getInstance().autoDispatch();
        }
        perfCfg.setRecordControllerParam(request.getParameter("isRecordControllerParam") != null);
        perfCfg.setRecordControllerStartTime(request.getParameter("isRecordControllerStartTime") != null);
        perfCfg.setRecordManagerParam(request.getParameter("isRecordManagerParam") != null);
        perfCfg.setRecordManagerStartTime(request.getParameter("isRecordManagerStartTime") != null);
        perfCfg.setRecordDaoParam(request.getParameter("isRecordDaoParam") != null);
        perfCfg.setRecordDaoStartTime(request.getParameter("isRecordDaoStartTime") != null);
        perfCfg.setSlowlaunchDaoTime(Integer.parseInt(request.getParameter("slowlaunchDaoTime")));
        perfCfg.setSlowlaunchManagerTime(Integer.parseInt(request.getParameter("slowlaunchManagerTime")));
    }
    if (request.getParameter("intervalTime") != null) {
        mConfig.setIntervalTimems(Long.parseLong(request.getParameter("intervalTime")) * 1000);
        mConfig.setSpareDBConThreshold(Long.parseLong(request.getParameter("spareDbCon")));
        mConfig.setBusyThreadsCount4HttpThreshold(Long.parseLong(request.getParameter("httpThreshold")));
        mConfig.setBusyThreadsCount4AjpThreshold(Long.parseLong(request.getParameter("ajpThrehold")));
    }
    %>
<html>
  <head>
    <title>性能跟踪配置</title>
  </head>
  <body>

    <form action="perflogcfg.do" id="form1" method="post">
    <fieldset>
    <legend>性能跟踪开关</legend>
        <div class="common_radio_box clearfix">
            <label for="radio1" class="margin_r_10 hand"> <input type="radio" value="true" id="openPara"
                name="isRunning" class="radio_com" <%=perfCfg.isRunning() ? "checked" : ""%>>开启
            </label> <label for="radio2" class="margin_r_10 hand"> <input type="radio" value="false" id="closePara"
                name="isRunning" class="radio_com" <%=perfCfg.isRunning() ? "" : "checked"%>>关闭
            </label>
        </div>
        <!--  <a id="btnsave" class="common_button common_button_gray" href="javascript:void(0)">高级选项</a> -->
    </fieldset>
        <fieldset>
            <legend>关键指标调整</legend>
            <div class="common_txtbox clearfix">
                <label class="margin_r_10 left title" for="text">监控间隔(秒):</label>
                <div class="common_txtbox_wrap">
                    <input type="text" id="intervalTime" name="intervalTime" class="validate"
                        validate="notNull:true,isInteger:true,min:3"
                        value="<%=mConfig.getIntervalTimems() / 1000%>">
                </div>
            </div>
            <div class="common_txtbox clearfix">
                <label class="margin_r_10 left title" for="text">空闲数据库连接数:</label>
                <div class="common_txtbox_wrap">
                    <input type="text" id="spareDbCon" name="spareDbCon" class="validate"
                        validate="notNull:true,isInteger:true,min:1"
                        value="<%=mConfig.getSpareDBConThreshold()%>">
                </div>
            </div>
            <div class="common_txtbox clearfix">
                <label class="margin_r_10 left title" for="text">HTTP繁忙线程数:</label>
                <div class="common_txtbox_wrap">
                    <input type="text" id="httpThreshold" name="httpThreshold" class="validate"
                        validate="notNull:true,isInteger:true,min:5"
                        value="<%=mConfig.getBusyThreadsCount4HttpThreshold()%>">
                </div>
            </div>
            <div class="common_txtbox clearfix">
                <label class="margin_r_10 left title" for="text">AJP繁忙线程数:</label>
                <div class="common_txtbox_wrap">
                    <input type="text" id="ajpThrehold" name="ajpThrehold" class="validate"
                        validate="notNull:true,isInteger:true,min:5"
                        value="<%=mConfig.getBusyThreadsCount4AjpThreshold()%>">
                </div>
            </div>
        </fieldset>
        
        <table border="0">
        <tr>
            <td>
                <fieldset>
                    <legend>控制层</legend>
                    <div class="common_checkbox_box clearfix ">
                        <label for="radio1" class="margin_t_5 hand display_block"> <input type="checkbox"
                            value="true" id="Checkbox1" name="isRecordControllerParam" class="radio_com"  <%=perfCfg.isRecordControllerParam() ? "checked" : ""%>>记录参数
                        </label> <label for="radio2" class="margin_t_5 hand display_block"> <input type="checkbox"
                            value="true" id="Checkbox2" name="isRecordControllerStartTime"class="radio_com"  <%=perfCfg.isRecordControllerStartTime() ? "checked" : ""%>>记录开始时间
                        </label>
                    </div>                   
                </fieldset>
            </td>
            <td><fieldset>
                    <legend>业务层</legend>
                    <div class="common_checkbox_box clearfix ">
                        <label for="radio1" class="margin_t_5 hand display_block"> <input type="checkbox"
                            value="0" id="Checkbox3" name="isRecordManagerParam" class="radio_com"  <%=perfCfg.isRecordManagerParam() ? "checked" : ""%>>记录参数
                        </label> <label for="radio2" class="margin_t_5 hand display_block" > <input type="checkbox"
                            value="0" id="Checkbox4" name="isRecordManagerStartTime" class="radio_com"  <%=perfCfg.isRecordManagerStartTime() ? "checked" : ""%>>记录开始时间
                        </label>
                    </div>
                    <div class="common_txtbox clearfix">
                        <label class="margin_r_10 left title" for="text">超时阀值：</label>
                        <div class="common_txtbox_wrap">
                            <input type="text" id="slowlaunchManagerTime" name="slowlaunchManagerTime" class="validate" validate="notNull:true, isInteger:true, min:0,max:600000" value="<%=perfCfg.getSlowlaunchManagerTime()%>">
                        </div>
                    </div>
                </fieldset></td>
            <td><fieldset>
                    <legend>数据访问层</legend>
                    <div class="common_checkbox_box clearfix ">
                        <label for="radio1" class="margin_t_5 hand display_block"> <input type="checkbox"
                            value="0" id="Checkbox5" name="isRecordDaoParam" class="radio_com"  <%=perfCfg.isRecordDaoParam() ? "checked" : ""%>>记录参数
                        </label> <label for="radio2" class="margin_t_5 hand display_block"> <input type="checkbox"
                            value="0" id="Checkbox6" name="isRecordDaoStartTime" class="radio_com"  <%=perfCfg.isRecordDaoStartTime() ? "checked" : ""%>>记录开始时间
                        </label>
                    </div>
                    <div class="common_txtbox clearfix">
                        <label class="margin_r_10 left title" for="text">超时阀值：</label>
                        <div class="common_txtbox_wrap">
                            <input type="text" id="slowlaunchDaoTime"  name="slowlaunchDaoTime"  class="validate"  validate="notNull:true, isInteger:true, min:0,max:600000" value="<%=perfCfg.getSlowlaunchDaoTime()%>">
                        </div>
                    </div>
                </fieldset></td>
        </tr>
    </table>
     <a id="btnok" class="common_button common_button_emphasize" >${ctp:i18n('common.button.ok.label')}</a>
</form>
     <!-- 按照要求此功能调整到系统监控中
     <div style="margin-left:auto;margin-right:auto;width:500px;">
               <span style="color:red">Notes<br/>Date format:yyyy-MM-dd,eg:2015-04-03</span><br/><br/>
               Log Date:<input type="text" id="logDate" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"></input>
               <a  id="confirmBtn" class="common_button common_button_emphasize" href="javascript:void(0)">Confirm Upload</a>
     </div> 
     -->
  </body>
  <script type="text/javascript">
  $(document).ready(function () {
    $("#btnok").click(function () {
    	$.progressBar();
        $('#form1').submit();
        })
        });
  </script>
</html>