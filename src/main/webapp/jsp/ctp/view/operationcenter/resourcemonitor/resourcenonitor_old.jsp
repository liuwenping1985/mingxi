<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.lang.management.*" %>
<%@page import="javax.management.*" %>
<%@page import="java.util.*,java.io.File" %>
<%@page import="com.seeyon.ctp.login.online.*" %>
<%@page import="com.seeyon.ctp.util.Datetimes"%>
<%@page import="com.seeyon.v3x.dbpool.datasource.DataSourceConProvider,com.seeyon.ctp.common.init.MclclzUtil" %>
<%@ page import="com.seeyon.ctp.common.filemanager.manager.*" %>

<%!
String formatSize(Object obj, boolean mb) {
    long bytes = -1L;

    if (obj instanceof Long) {
        bytes = ((Long) obj).longValue();
    } else if (obj instanceof Integer) {
        bytes = ((Integer) obj).intValue();
    }

    if (mb) {
        long mbytes = bytes / (1024 * 1024);
        long rest = 
            ((bytes - (mbytes * (1024 * 1024))) * 100) / (1024 * 1024);
        return (mbytes + "." + ((rest < 10) ? "0" : "") + rest + " MB");
    } else {
        return ((bytes / 1024) + " KB");
    }
}
%>
<%
response.setContentType("text/html; charset=UTF-8");

long startTime = System.currentTimeMillis();

java.io.PrintWriter writer = response.getWriter();

MBeanServer mBeanServer = org.apache.commons.modeler.Registry.getRegistry(null, null).getMBeanServer();

writer.println("<html>");
writer.println("<head>");
writer.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
writer.println("<title>Management Monitor</title>");
writer.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../common/css/default.css\">");
writer.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../common/skin/default/skin.css\">");
writer.println("<style type=\"text/css\">div.gauge {height:400px;} div.textinfo{display:none;}</style>");

String rf = request.getParameter("rf");
if(rf != null && Integer.parseInt(rf) > 0){
    writer.println("<meta http-equiv='Refresh' content='" + (Integer.parseInt(rf) * 60) + ";url=status.do?rf=" + rf + "' />");
}

 writer.println("<script type=\"text/javascript\">");
 writer.println("function toggle(targetid){ ");
 writer.println("     if (document.getElementById){  target=document.getElementById(targetid); ");
  writer.println("            if (target.style.display=='block'){  target.style.display='none';  ");
  writer.println("            } else {  target.style.display='block';}  } }");
 writer.println("</script>");

writer.println("</head>");
writer.println("<body>");

writer.println("<div class=\"comp\" comp=\"type:'breadcrumb',code:'T01_gauge'\"></div>");

writer.println("<table border='0' width='100%' cellspacing='0' cellpadding='0'>");
writer.println("<tr>");
writer.println("<td width='50%'>&nbsp;</td>");
writer.println("<td width='50%' align='right'><form method='get' style='margin:0px'>");
writer.print("Auto-Refresh Time: <input value='" + (rf == null ? "1" : rf) + "' name='rf' type='text' maxlength='3' size='3'> Minutes");
writer.print("&nbsp;&nbsp;<input value='go' name='b1' type='submit'>");
if(rf != null){
    writer.print("&nbsp;<a href='index.do'>Cancel</a>");
}
writer.println("</form>");
writer.println("</td>");
writer.println("</tr>");
writer.println("</table>");

writer.println("<hr size=\"1\" noshade=\"noshade\">");

writer.print("<div style='padding: 10px'>");
writer.println("<b>Now: " + Datetimes.formatDatetime(new Date()) + "</b>");

/********************************************** A8 ***********************************************/

//writer.print("<h4>A8 (" + ProductInfo.getEditionA() + " " + ProductInfo.getVersion() + ProductInfo.getSpVersion() + ")</h4>");
writer.println("<pre>");


 writer.println("<script src=\"../../../common/js/echarts-all.js\"></script>");
//writer.println(" <table><tr>");
writer.println("<td><div id=\"onlineUser\" class=\"gauge\" onclick='toggle(\"onlineUserText\")'></div></td>");
writer.println("<td><div id=\"onlineUserM1\" class=\"gauge\"  onclick='toggle(\"onlineUserText\")'></div></td>");
//writer.println("</tr> </table>");

     Class<?> c1 = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");
       Object o = MclclzUtil.invoke(c1, "getInstance", new Class[] { String.class }, null, new Object[] { "" });
        Long servernum = (Long) MclclzUtil.invoke(c1, "getTotalservernum", null, o, null);
        Long m1num = (Long) MclclzUtil.invoke(c1, "getTotalm1num", null, o, null);

OnlineManager onLineManager = ((OnlineManager)com.seeyon.ctp.common.AppContext.getBean("onLineManager"));
writer.println("    <script type=\"text/javascript\">        ");
 writer.println("       var myChart = echarts.init(document.getElementById('onlineUser')); ");
writer.println("        option = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'', max:"+servernum+",type:'gauge', detail : {formatter:'{value}%'},            data:[{value:"+OnlineRecorder.getOnlineUserNumber4Server()+", name: 'PC Online Users'}] }]};");
 writer.println("       myChart.setOption(option); ");

  writer.println("       var myChart2 = echarts.init(document.getElementById('onlineUserM1')); ");
writer.println("        option2 = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'', max:"+m1num+",type:'gauge', detail : {formatter:'{value}%'}, data:[{value:" + OnlineRecorder.getOnlineUserNumber4M1()+", name: 'M1 Users'}] }]};");
 writer.println("       myChart2.setOption(option2); ");

 writer.println("   </script>");

writer.print("<div id='onlineUserText' class='textinfo'>Online Users: " + OnlineRecorder.getOnlineUserNumber4Server());
writer.print("; Peak Online Users: " + OnlineRecorder.getPeakOnlineUserNumber4Server() + " (" + Datetimes.formatDatetime(new Date(OnlineRecorder.getPeakOnlineUserTimestamp4Server())) + ")");
writer.println("");

writer.print("M1 Users: " + OnlineRecorder.getOnlineUserNumber4M1());
writer.print("; Peak M1 Users: " + OnlineRecorder.getPeakOnlineUserNumber4M1() + " (" + Datetimes.formatDatetime(new Date(OnlineRecorder.getPeakOnlineUserTimestamp4M1())) + ")");
writer.println("</div>");

RuntimeMXBean runtimeMXBean = ManagementFactory.getRuntimeMXBean();

ObjectName operatingSystemObjectName = new ObjectName(ManagementFactory.OPERATING_SYSTEM_MXBEAN_NAME);

boolean hasOperatingSystemBean = false;
try{
    mBeanServer.getMBeanInfo(operatingSystemObjectName);
    hasOperatingSystemBean = true;
}
catch (Exception e) {
}

writer.println("</pre>");

/*********************************************** Server **********************************************/

writer.println("<div id='serverText' class='textinfo'><h4>Server</h4>");
writer.println("<pre>");
writer.print("OS Name: " + System.getProperty("os.name"));
writer.print("; OS Version: " + System.getProperty("os.version"));
writer.print("; OS Architecture: " + System.getProperty("os.arch"));
writer.println("");
writer.print("Processors: " + Runtime.getRuntime().availableProcessors());

if(hasOperatingSystemBean){
    writer.print("; Free Physical Memory Size: " + formatSize((Long)mBeanServer.getAttribute(operatingSystemObjectName, "FreePhysicalMemorySize"), true));
    writer.print("; Total Physical Memory Size: " + formatSize((Long)mBeanServer.getAttribute(operatingSystemObjectName, "TotalPhysicalMemorySize"), true));
    writer.print("; Free Swap Space Size: " + formatSize((Long)mBeanServer.getAttribute(operatingSystemObjectName, "FreeSwapSpaceSize"), true));
    writer.print("; Total Swap Space Size: " + formatSize((Long)mBeanServer.getAttribute(operatingSystemObjectName, "TotalSwapSpaceSize"), true));
    writer.println("</div>");

writer.println("<div id=\"PhysicalMemory\" class=\"gauge\" onclick='toggle(\"serverText\")'></div>");
writer.println("<div id=\"SwapSpace\" class=\"gauge\"  onclick='toggle(\"serverText\")'></div>");

writer.println("    <script type=\"text/javascript\">");
 writer.println("       var myChart = echarts.init(document.getElementById('PhysicalMemory')); ");
writer.println("        option = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'', type:'gauge', detail : {formatter:'{value}%'},            data:[{value:"+(100-(Long)mBeanServer.getAttribute(operatingSystemObjectName, "FreePhysicalMemorySize")*100/(Long)mBeanServer.getAttribute(operatingSystemObjectName, "TotalPhysicalMemorySize"))+", name: 'Physical Memory'}] }]};");
 writer.println("       myChart.setOption(option); ");

  writer.println("       var myChart2 = echarts.init(document.getElementById('SwapSpace')); ");
writer.println("        option2 = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'',type:'gauge', detail : {formatter:'{value}%'},            data:[{value:"+(100-(Long)mBeanServer.getAttribute(operatingSystemObjectName, "FreeSwapSpaceSize")*100/(Long)mBeanServer.getAttribute(operatingSystemObjectName, "TotalSwapSpaceSize"))+", name: 'Swap Space'}] }]};");
 writer.println("       myChart2.setOption(option2); ");

 writer.println("   </script>");
}
writer.println("</pre>");

/********************************************** JVM ***********************************************/

List<MemoryPoolMXBean> memoryPoolMXBeans = ManagementFactory.getMemoryPoolMXBeans();
if(memoryPoolMXBeans != null && !memoryPoolMXBeans.isEmpty()){
    Map<String, Long> heapMem = new HashMap<String, Long>();
    writer.println("<div  id='jvmText'  class='textinfo' >");
    writer.print("<table border='0' cellspacing='0' cellpadding='0' class='sort'>");
    writer.print("<thead>");
    writer.print("<tr class=\"sort\">");
    writer.print("  <td class=\"sort\" width='80'>Type</td>");
    writer.print("  <td class=\"sort\" width='120'>Gen</td>");
    writer.print("  <td class=\"sort\" width='80' align='right'>Init</td>");
    writer.print("  <td class=\"sort\" width='80' align='right'>Used</td>");
    writer.print("  <td class=\"sort\" width='80' align='right'>Max</td>");
    writer.print("  <td class=\"sort\" width='80' align='right'>Committed</td>");
    writer.print("  <td class=\"sort\" width='80' align='right'>Peak</td>");
    writer.print("  <td class=\"sort\" width='80' align='right'>Used Ratio</td>");
    writer.print("  <td class=\"sort\" width='80' align='right'>Peak Ratio</td>");
    writer.print("</tr>");
    writer.print("</thead>");
    writer.print("<tbody>");
    
    java.text.NumberFormat nf = java.text.NumberFormat.getPercentInstance();
    long oldPerc=0;
    long perPerc=0;
    for(MemoryPoolMXBean memoryPoolMXBean : memoryPoolMXBeans){
        String type = memoryPoolMXBean.getType().name();
        MemoryUsage memoryUsage = memoryPoolMXBean.getUsage();
        
        Long max = memoryUsage.getMax();
        Long init = memoryUsage.getInit();
        Long used = memoryUsage.getUsed();
        Long committed = memoryUsage.getCommitted();
        
        Long peakUsed = memoryPoolMXBean.getPeakUsage().getUsed();
        
        if(heapMem.containsKey(type)){
            heapMem.put(type, heapMem.get(type) + used);
        }
        else{
            heapMem.put(type, used);
        }
        
        String peakType = "Peak_" + type;
        if(heapMem.containsKey(peakType)){
            heapMem.put(peakType, heapMem.get(peakType) + peakUsed);
        }
        else{
            heapMem.put(peakType, peakUsed);
        }
        
        writer.print("<tr>");
        writer.print("  <td class=\"sort\">" + type + "</td>");
        writer.print("  <td class=\"sort\">" + memoryPoolMXBean.getName() + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + formatSize(init, true) + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + formatSize(used, true) + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + formatSize(max, true) + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + formatSize(committed, true) + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + formatSize(peakUsed, true) + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + nf.format((double)used / (double)(max + 1)) + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + nf.format((double)peakUsed / (double)(max + 1)) + "</td>");
        writer.print("</tr>");
        if("CMS Old Gen".equals(memoryPoolMXBean.getName())){
            oldPerc=100-used*100/(max+1);
        }else if("CMS Perm Gen".equals(memoryPoolMXBean.getName())){
            perPerc=100-used*100/(max+1);
        }

    }
    writer.print("</tbody>");
    writer.print("</table></div>");

writer.println("<div id=\"CMSOldGen\" class=\"gauge\" onclick='toggle(\"jvmText\")'></div>");
writer.println("<div id=\"CMSPermGen\" class=\"gauge\"  onclick='toggle(\"jvmText\")'></div>");

writer.println("    <script type=\"text/javascript\">");
 writer.println("       var myChart = echarts.init(document.getElementById('CMSOldGen')); ");
writer.println("        option = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'', type:'gauge', detail : {formatter:'{value}%'},            data:[{value:"+oldPerc+", name: 'CMS Old Gen'}] }]};");
 writer.println("       myChart.setOption(option); ");

  writer.println("       var myChart2 = echarts.init(document.getElementById('CMSPermGen')); ");
writer.println("        option2 = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'',type:'gauge', detail : {formatter:'{value}%'},            data:[{value:"+perPerc+", name: 'CMS Perm Gen'}] }]};");
 writer.println("       myChart2.setOption(option2); ");

 writer.println("   </script>");

}


/******************************************** JDBC *************************************************/

java.util.List<DataSourceConProvider> map = DataSourceConProvider.getDataSources();
for(DataSourceConProvider entry : map){
    writer.println("<div id=\""+entry.getName() +"Text\" class='textinfo'><h5>" + entry.getName() + "</h5>");
    entry.getFProvider().printInfo(writer);
    writer.println("</div>");

writer.println("<div id=\"" + entry.getName() + "\" class=\"gauge\" onclick='toggle(\""+entry.getName() +"Text\")'></div>");

writer.println("    <script type=\"text/javascript\">");
 writer.println("       var myChart = echarts.init(document.getElementById('" + entry.getName() + "')); ");
writer.println("        option = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'',max:"+entry.getFProvider().getMaxCount()+", type:'gauge', detail : {formatter:'{value}%'},            data:[{value:"+entry.getFProvider().getNoUseCount()+", name: '" + entry.getName() + "'}] }]};");
 writer.println("       myChart.setOption(option); ");

 writer.println("   </script>");

}

writer.println("<div id=\"attPartition\" class=\"gauge\" onclick='toggle(\"onlineUserText\")'></div>");
writer.println("<div id=\"appServerPath\" class=\"gauge\"></div>");

                        PartitionManager partitionManager = ((PartitionManager)com.seeyon.ctp.common.AppContext.getBean("partitionManager"));
                        File[] roots = File.listRoots();
                        String appServerPath=request.getSession().getServletContext().getRealPath("/");     
                        String attPartition=partitionManager.getPartitionPath(new Date(),true);
                        for (File file : roots) {   
                            long useRatio=0;
                            if(attPartition.startsWith(file.getPath()) ){
                                useRatio=100 - file.getFreeSpace()*100/file.getTotalSpace();
writer.println("    <script type=\"text/javascript\">");
 writer.println("       var myChart = echarts.init(document.getElementById('attPartition')); ");
writer.println("        option = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'', type:'gauge', detail : {formatter:'{value}%'},            data:[{value:"+useRatio+", name: 'Attach Use Ratio'}] }]};");
 writer.println("       myChart.setOption(option); ");

                            }
                            if(appServerPath.startsWith(file.getPath()) ){
                                useRatio=100 - file.getFreeSpace()*100/file.getTotalSpace();
  writer.println("       var myChart2 = echarts.init(document.getElementById('appServerPath')); ");
writer.println("        option2 = {");
writer.println("    tooltip : {        formatter: \"{a} <br/>{b} : {c}%\"    },");
 writer.println("   series : [{ name:'',type:'gauge', detail : {formatter:'{value}%'},            data:[{value:"+useRatio+", name: 'AppServer Use Ratio'}] }]};");
 writer.println("       myChart2.setOption(option2); ");

 writer.println("   </script>");

                            }  
                        }

%>
<script type="text/javascript">
<!--
function log(){
    var today = "<%=Datetimes.formatDate(new Date())%>";
    
    var fn = window.prompt("Please input log file name, eq. ctp, capability", "ctp");
    var date = window.prompt("Please input date, format: yyyy-MM-dd", today);
    var index = window.prompt("Please input index, eg.1,2,3,4...", "1");
    var url = null;
    if(today == date){
        url = "../../../logs/" + fn + ".log";
    }
    else{
        url = "../../../logs/" + date + "/" + fn + ".log." + date + "." + index + ".log";
    }
    
    window.open(url);
}
//-->
</script>
<%
writer.println("<hr size=\"1\" noshade=\"noshade\"><center style='padding: 10px'><font size=\"-1\" color=\"#525D76\"><em>Copyright &copy; 2009, www.seeyon.com " + (System.currentTimeMillis() - startTime) +"ms</em></font></center>");
writer.println("</body>");
writer.println("</html>");
%>
