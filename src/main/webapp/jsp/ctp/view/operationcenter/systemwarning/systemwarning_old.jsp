<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<%@ page import="java.util.*,java.io.File" %>
<%@ page import="com.seeyon.ctp.common.config.manager.*,com.seeyon.ctp.common.filemanager.manager.*" %>
<jsp:useBean id="perfCfg" class="com.seeyon.ctp.monitor.perfmon.PerfLogConfig"/>

<%
ConfigManager configManager = ((ConfigManager)com.seeyon.ctp.common.AppContext.getBean("configManager"));
String rebuildIndexStatus=configManager.getConfigValue("com.v3x.plugin.indexresume.Configuration", "RESUME_STATE");
String rebuildIndexStartTime=configManager.getConfigValue("com.v3x.plugin.indexresume.Configuration", "RESUME_START_TIME");
String rebuildIndexStopTime=configManager.getConfigValue("com.v3x.plugin.indexresume.Configuration", "RESUME_END_TIME");
String attachEncrypt=configManager.getConfigValue("system_switch", "attach_encrypt");

boolean isNight=false;

if("true".equals(rebuildIndexStatus)){
    if( Integer.parseInt( rebuildIndexStartTime.substring(0, rebuildIndexStartTime.indexOf(":")) )>=18 && Integer.parseInt( rebuildIndexStopTime.substring(0, rebuildIndexStopTime.indexOf(":")) )<=8)
        isNight=true;
}
%>

<!DOCTYPE html>
<html class="over_hidden h100b">
<head>
    <title></title>
</head>

<body class="over_hidden h100b">

<div class="comp" comp="type:'breadcrumb',code:'T01_earlyWarnin'"></div>

    <fieldset class="margin_5">
        <legend>系统配置预警</legend>
        <div class="form_area align_center relative padding_b_15">
            <table class="only_table  no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
                <thead>
                    <tr>
                        <th width="100">分类 </th>
                        <th>预警描述</th>
                        <th>建议方案</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="erow">
                        <td>系统开关</td>
                        <td>附件加密：<%=attachEncrypt %></td>
                        <td><% if("no".equals(attachEncrypt)){ %>建议开启附件加密<%} else{ %>无<%} %></td>
                    </tr>
                    
                    
                      <tr class="erow">
                        <td>系统开关</td>
                        <td>性能跟踪开关：<%=perfCfg.isRunning()  %></td>
                        <td><% if(perfCfg.isRunning() ){ %>生产环境建议关闭性能跟踪开关<%}else{ %>无<%} %></td>
                    </tr>
                                      
                    <tr class="erow">
                        <td>系统开关</td>
                        <td>重建索引设置：<%=rebuildIndexStatus%>
                        <%
                        if("true".equals(rebuildIndexStatus)){
                        %>
                        运行时间：每天<%=rebuildIndexStartTime  %>  停止时间：每天<%=rebuildIndexStopTime  %>
                        <%}%>
                        </td>
                        <td>
                        <%
                         if("true".equals(rebuildIndexStatus) && !isNight){
                        %>
                       建议重建索引的运行时间设置在系统较为空闲时期进行
                        <%}else{ %>无<%} %>                       </td>
                    </tr>
                    
                </tbody>
            </table>            

        </div>
    </fieldset>

<!--     <fieldset class="margin_5">
        <legend>系统配置预警</legend>
        <div class="form_area align_center relative padding_b_15">
            <table class="only_table  no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
                <thead>
                    <tr>
                        <th width="100">分类 </th>
                        <th>预警描述</th>
                        <th>建议方案</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="erow">
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>            

        </div>
    </fieldset> -->

    <fieldset class="margin_5">
        <legend>容量预警</legend>
        <div class="form_area align_center relative padding_b_15">
            <table class="only_table  no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
                <thead>
                    <tr>
                        <th width="100">分类 </th>
                        <th>预警描述</th>
                        <th>建议方案</th>
                    </tr>
                </thead>
                <tbody>
 <%
                        PartitionManager partitionManager = ((PartitionManager)com.seeyon.ctp.common.AppContext.getBean("partitionManager"));
                        File[] roots = File.listRoots();//获取磁盘分区列表   
                        String appServerPath=request.getSession().getServletContext().getRealPath("/");     
                        String attPartition=partitionManager.getPartitionPath(new Date(),true);
                        for (File file : roots) {   
                            long useRatio=0;
                            if(attPartition.startsWith(file.getPath()) ){
                                useRatio=100 - file.getFreeSpace()*100/file.getTotalSpace();
                           %>
                    <tr class="erow">
                        <td>附件分区目录</td>
                        <td>当前附件分区（<%= attPartition%>）使用率：<%=useRatio %>%</td>
                        <td><%if(useRatio>=90){ %>建议及时新增附件分区<%}else{ %>无<%} %></td>
                    </tr>
                                                <%                            
                            }
                            if(appServerPath.startsWith(file.getPath()) ){
                                useRatio=100 - file.getFreeSpace()*100/file.getTotalSpace();
                           %>
                    <tr class="erow">
                        <td>应用目录</td>
                        <td>当前应用分区（<%= appServerPath%>）使用率：<%=useRatio %>%</td>
                        <td><%if(useRatio>=90){ %>建议清理系统日志，或及时扩容应用程序所在分区空间<%}else{ %>无<%} %></td>
                    </tr>
                                                <%                            
                            }  
                        }
                        %>
                </tbody>
            </table>            

        </div>
    </fieldset>
</body>
</html>
