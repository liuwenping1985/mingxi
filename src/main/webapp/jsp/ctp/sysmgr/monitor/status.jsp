<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.lang.management.*" %>
<%@page import="javax.management.*" %>
<%@page import="java.util.*" %>
<%@page import="com.seeyon.ctp.login.online.*" %>
<%@page import="com.seeyon.ctp.util.Datetimes"%> 
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

String formatTime(Object obj, boolean seconds) {
    long time = -1L;

    if (obj instanceof Long) {
        time = ((Long) obj).longValue();
    } else if (obj instanceof Integer) {
        time = ((Integer) obj).intValue();
    }

    if (seconds) {
        return ((((float) time ) / 1000) + " s");
    } else {
        return (time + " ms");
    }
}
String formatTime(long time) {
	long day = time / (24 * 60 * 60 * 1000);
	long hour = (time % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000);
	long minute = (time % (60 * 60 * 1000)) / (60 * 1000);
	
	return day + " days " + hour + " hours " + minute + " minutes";
}

String filter(Object obj) {
    if (obj == null)
        return ("?");
    String message = obj.toString();

    char content[] = new char[message.length()];
    message.getChars(0, message.length(), content, 0);
    StringBuffer result = new StringBuffer(content.length + 50);
    for (int i = 0; i < content.length; i++) {
        switch (content[i]) {
        case '<':
            result.append("&lt;");
            break;
        case '>':
            result.append("&gt;");
            break;
        case '&':
            result.append("&amp;");
            break;
        case '"':
            result.append("&quot;");
            break;
        default:
            result.append(content[i]);
        }
    }
    return (result.toString());
}

void writeProcessorState(java.io.PrintWriter writer, ObjectName pName, MBeanServer mBeanServer)throws Exception {
	int stage = (Integer) mBeanServer.getAttribute(pName, "stage");
	boolean fullStatus = true;
	boolean showRequest = true;
	String stageStr = null;

	switch (stage) {
	case (1/*org.apache.coyote.Constants.STAGE_PARSE*/):
		stageStr = "P";
		fullStatus = false;
		break;
	case (2/*org.apache.coyote.Constants.STAGE_PREPARE*/):
		stageStr = "P";
		fullStatus = false;
		break;
	case (3/*org.apache.coyote.Constants.STAGE_SERVICE*/):
		stageStr = "S";
		break;
	case (4/*org.apache.coyote.Constants.STAGE_ENDINPUT*/):
		stageStr = "F";
		break;
	case (5/*org.apache.coyote.Constants.STAGE_ENDOUTPUT*/):
		stageStr = "F";
		break;
	case (7/*org.apache.coyote.Constants.STAGE_ENDED*/):
		stageStr = "R";
		fullStatus = false;
		break;
	case (6/*org.apache.coyote.Constants.STAGE_KEEPALIVE*/):
		stageStr = "K";
		fullStatus = true;
		showRequest = false;
		break;
	case (0/*org.apache.coyote.Constants.STAGE_NEW*/):
		stageStr = "R";
		fullStatus = false;
		break;
	default:
		// Unknown stage
		stageStr = "?";
		fullStatus = false;
	}

	writer.write("<td class=\"sort\"><b>");
	writer.write(stageStr);
	writer.write("</b></td>");

	if (fullStatus) {
		writer.write("<td class=\"sort\">");
		writer.print(formatTime(mBeanServer.getAttribute(pName, "requestProcessingTime"), false));
		writer.write("</td>");
		writer.write("<td class=\"sort\">");
		if (showRequest) {
			writer.print(formatSize(mBeanServer.getAttribute(pName, "requestBytesSent"), false));
		} else {
			writer.write("?");
		}
		writer.write("</td>");
		writer.write("<td class=\"sort\">");
		if (showRequest) {
			writer.print(formatSize(mBeanServer.getAttribute (pName, "requestBytesReceived"), false));
		} else {
			writer.write("?");
		}
		writer.write("</td>");
		writer.write("<td class=\"sort\">");
		writer.print(filter(mBeanServer.getAttribute(pName, "remoteAddr")));
		writer.write("</td>");
		writer.write("<td nowrap class=\"sort\">");
		writer.write(filter(mBeanServer.getAttribute(pName, "virtualHost")));
		writer.write("</td>");
		writer.write("<td nowrap class=\"sort\">");
		if (showRequest) {
			writer.write(filter(mBeanServer.getAttribute  (pName, "method")));
			writer.write(" ");
			writer.write(filter(mBeanServer.getAttribute  (pName, "currentUri")));
			String queryString = (String) mBeanServer.getAttribute(pName, "currentQueryString");
			if ((queryString != null) && (!queryString.equals(""))) {
				writer.write("?");
				writer.print(queryString);
			}
			writer.write(" ");
			writer.write(filter(mBeanServer.getAttribute(pName, "protocol")));
		} else {
			writer.write("?");
		}
		writer.write("</td>");
	}
	else {
		writer.write("<td class=\"sort\">?</td><td class=\"sort\">?</td><td class=\"sort\">?</td><td class=\"sort\">?</td><td class=\"sort\">?</td><td class=\"sort\">?</td>");
	}
}
%>
<%
response.setContentType("text/html; charset=UTF-8");

if(session.getAttribute("GoodLuckA8") == null){
	response.sendRedirect("index.do");
	return;
}
Class<?> c1 = com.seeyon.ctp.common.init.MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
Object customName = com.seeyon.ctp.common.init.MclclzUtil.invoke(c1, "getCustomName",new Class[]{},null,new Object[]{});

long startTime = System.currentTimeMillis();

java.io.PrintWriter writer = response.getWriter();

MBeanServer mBeanServer = org.apache.commons.modeler.Registry.getRegistry(null, null).getMBeanServer();

writer.println("<html>");
writer.println("<head>");
writer.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
writer.println("<title>Management Monitor</title>");
writer.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../common/css/default.css\">");
writer.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../common/skin/default/skin.css\">");

String rf = request.getParameter("rf");
if(rf != null && Integer.parseInt(rf) > 0){
	writer.println("<meta http-equiv='Refresh' content='" + (Integer.parseInt(rf) * 60) + ";url=status.do?rf=" + rf + "' />");
}
writer.println("</head>");
writer.println("<body>");

writer.println("<table border='0' width='100%' cellspacing='0' cellpadding='0'>");
writer.println("<tr>");
writer.println("<td width='50%'>&nbsp;"+customName+"</td>");
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

OnlineManager onLineManager = ((OnlineManager)com.seeyon.ctp.common.AppContext.getBean("onLineManager"));
//writer.print("<h4>A8 (" + ProductInfo.getEditionA() + " " + ProductInfo.getVersion() + ProductInfo.getSpVersion() + ")</h4>");
writer.println("<pre>");
writer.print("Online Users: " + OnlineRecorder.getOnlineUserNumber4Server());
writer.print("; Peak Online Users: " + OnlineRecorder.getPeakOnlineUserNumber4Server() + " (" + Datetimes.formatDatetime(new Date(OnlineRecorder.getPeakOnlineUserTimestamp4Server())) + ")");
writer.println("");

writer.print("M1 Users: " + OnlineRecorder.getOnlineUserNumber4M1());
writer.print("; Peak M1 Users: " + OnlineRecorder.getPeakOnlineUserNumber4M1() + " (" + Datetimes.formatDatetime(new Date(OnlineRecorder.getPeakOnlineUserTimestamp4M1())) + ")");
writer.println("");

RuntimeMXBean runtimeMXBean = ManagementFactory.getRuntimeMXBean();
writer.print("StartTime: " + Datetimes.formatDatetime(new Date(runtimeMXBean.getStartTime())));
writer.print("; Runtime: " + formatTime( runtimeMXBean.getUptime()));

ObjectName operatingSystemObjectName = new ObjectName(ManagementFactory.OPERATING_SYSTEM_MXBEAN_NAME);

boolean hasOperatingSystemBean = false;
try{
	mBeanServer.getMBeanInfo(operatingSystemObjectName);
	hasOperatingSystemBean = true;
}
catch (Exception e) {
}

if(hasOperatingSystemBean){
	writer.println("; Process CPU Time: " + formatTime((Long)mBeanServer.getAttribute(operatingSystemObjectName, "ProcessCpuTime") / 1000000));
}
writer.println("</pre>");

/*********************************************** Server **********************************************/

writer.println("<h4>Server</h4>");
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
}
writer.println("</pre>");

/********************************************** JVM ***********************************************/

writer.println("<h4>JVM</h4>");
writer.println("<pre>");
writer.print("JVM Version: " + System.getProperty("java.vm.name") + " (" + System.getProperty("java.version") + ", " + System.getProperty("java.vm.version") + ", " + System.getProperty("java.vm.info") + ")");
writer.print("; JVM Vendor: " + System.getProperty("java.vm.vendor"));
writer.print("; Data Model: " + System.getProperty("sun.arch.data.model"));
writer.println("");
writer.print("Free memory: " + formatSize(Runtime.getRuntime().freeMemory(), true));
writer.print("; Total memory: " + formatSize(Runtime.getRuntime().totalMemory(), true));
writer.print("; Max memory: " + formatSize(Runtime.getRuntime().maxMemory(),  true));
writer.println("</pre>");
writer.println("");
writer.println("VM Options: ");
java.util.List<String> inputArguments = runtimeMXBean.getInputArguments();
for(String inputArgument : inputArguments){
	writer.print("\t");
	writer.println(inputArgument);
}
writer.println("");
List<MemoryPoolMXBean> memoryPoolMXBeans = ManagementFactory.getMemoryPoolMXBeans();
if(memoryPoolMXBeans != null && !memoryPoolMXBeans.isEmpty()){
    Map<String, Long> heapMem = new HashMap<String, Long>();
    writer.println("<pre>");
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
    }
    writer.print("</tbody>");
    writer.print("</table>");
    writer.print("<br>");
    if(heapMem.containsKey("HEAP")){
    	writer.print("HEAP: " + formatSize(heapMem.get("HEAP"), true) + "; Peak: " + formatSize(heapMem.get("Peak_HEAP"), true) + "<br>");
    }
    if(heapMem.containsKey("NON_HEAP")){
    	writer.print("NON_HEAP: " + formatSize(heapMem.get("NON_HEAP"), true) + "; Peak: " + formatSize(heapMem.get("Peak_NON_HEAP"), true));
    }
	writer.println("</pre>");
}

/******************************************* GC **************************************************/
writer.print("<h4>GC</h4>");
writer.println("<pre>");
try{
	List<GarbageCollectorMXBean> garbageCollectorMXBeans = ManagementFactory.getGarbageCollectorMXBeans();
	for(GarbageCollectorMXBean garbageCollectorMXBean : garbageCollectorMXBeans){
		writer.print(garbageCollectorMXBean.getName());
		writer.print("  Time: " + formatTime(garbageCollectorMXBean.getCollectionTime(), true));
		writer.print("; Count: " + garbageCollectorMXBean.getCollectionCount());
		writer.print("<br>");
	}
}
catch (Exception e) {
	e.printStackTrace(writer);
}

writer.print("<a href=\"gc.do\" onclick=\"return confirm('GC will cost to run a certain performance. Continue?')\">Run GC</a>");
writer.println("</pre>");


/******************************************** SESSION *************************************************/

try{
    ObjectName sessionON = new ObjectName("Catalina:type=Manager,path=/seeyon,host=localhost");
    ObjectInstance sessionMB = mBeanServer.getObjectInstance(sessionON);
    
    writer.println("<h4>Session</h4>");
    writer.println("<pre>");
    writer.println("Current Active: " + mBeanServer.getAttribute(sessionON, "activeSessions"));
    writer.println("Max Active: " + mBeanServer.getAttribute(sessionON, "maxActive"));
    writer.println("</pre>");
}
catch (Exception e) {
    e.printStackTrace(writer);
}
writer.println("<br>");


/******************************************** JDBC *************************************************/

writer.println("<h4>Connection Pooling</h4>");

writer.println("<pre>");

writer.println("</pre>");

/******************************************** Thread *************************************************/

writer.println("<h4>Thread</h4>");

ThreadMXBean tmbean = ManagementFactory.getThreadMXBean();

writer.print("Thread Count: " + tmbean.getThreadCount());
writer.print("; Daemon Thread Count: " + tmbean.getDaemonThreadCount());
writer.print("; Peak Thread Count: " + tmbean.getPeakThreadCount());
writer.print("; Total Started Thread Count: " + tmbean.getTotalStartedThreadCount());

writer.println("</pre>");


/******************************************** HTTP *************************************************/
try {
    
    writer.print("<table border='0' cellspacing='0' cellpadding='0' class='sort'>");
    writer.print("<thead>");
    writer.print("<tr class=\"sort\">");
    writer.print("  <td class=\"sort\" width='120'>Type</td>");
    writer.print("  <td class=\"sort\" width='100' align='right'>Max threads</td>");
    writer.print("  <td class=\"sort\" width='100' align='right'>Current count</td>");
    writer.print("  <td class=\"sort\" width='100' align='right'>Current busy</td>");
    writer.print("</tr>");
    writer.print("</thead>");
    writer.print("<tbody>");
    
    Set set = mBeanServer.queryMBeans(new ObjectName("*:type=ThreadPool,*"), null); //
    Iterator iterator = set.iterator();
    while (iterator.hasNext()) {
        ObjectInstance oi = (ObjectInstance) iterator.next();
        ObjectName objectName = oi.getObjectName();
        
        String name = objectName.getKeyProperty("name");
        
        writer.print("<tr>");
        writer.print("  <td class=\"sort\">" + name + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + mBeanServer.getAttribute(objectName, "maxThreads") + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + mBeanServer.getAttribute(objectName, "currentThreadCount") + "</td>");
        writer.print("  <td class=\"sort\" align='right'>" + mBeanServer.getAttribute(objectName, "currentThreadsBusy") + "</td>");
        writer.print("</tr>");
    
        /*
        try {
            Object value = mBeanServer.getAttribute(objectName, "keepAliveCount");
            writer.print(" Keeped alive sockets count: ");
            writer.print(value);
        }
        catch (Exception e) {
        }
        */
    }
    
    ObjectName tomcatThreadPoolON = new ObjectName("Catalina:type=Executor,name=tomcatThreadPool");
    ObjectInstance tomcatThreadPoolMB = mBeanServer.getObjectInstance(tomcatThreadPoolON);
    String name = tomcatThreadPoolON.getKeyProperty("name");
    
    writer.print("<tr>");
    writer.print("  <td class=\"sort\">" + name + "</td>");
    writer.print("  <td class=\"sort\" align='right'>" + mBeanServer.getAttribute(tomcatThreadPoolON, "maxThreads") + "</td>");
    writer.print("  <td class=\"sort\" align='right'>" + mBeanServer.getAttribute(tomcatThreadPoolON, "poolSize") + "</td>");
    writer.print("  <td class=\"sort\" align='right'>" + mBeanServer.getAttribute(tomcatThreadPoolON, "activeCount") + "</td>");
    writer.print("</tr>");
    writer.println("</table>");
}
catch (Exception e) {
    e.printStackTrace(writer);
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
writer.println("</div>");
writer.println("<div align='center' style='padding: 30px'>");
writer.println("<a target='_blank' href='dataSource.do' onclick=\"return confirm('Show Busy Connections will cost to run a certain performance. Continue?')\">JDBC Dump</a>");
writer.println("&nbsp;&nbsp;|&nbsp;&nbsp;");
writer.println("<a target='_blank' href='threadDump.do' onclick=\"return confirm('Thread-Dump will cost to run a certain performance. Continue?')\">Thread Dump</a>");
writer.println("&nbsp;&nbsp;|&nbsp;&nbsp;");
writer.println("<a target='_blank' href='cacheDump.do' onclick=\"return confirm('Cache-Dump will cost to run a certain performance. Continue?')\">Cache Dump</a>");
writer.println("&nbsp;&nbsp;|&nbsp;&nbsp;");
writer.println("<a target='_blank' href='hql.do' onclick=\"return confirm('HQL-Dump will cost to run a certain performance. Continue?')\">HQL Dump</a>");
writer.println("&nbsp;&nbsp;|&nbsp;&nbsp;");
writer.println("<a href='javascript:log()'>LOGs</a>");
//writer.println("&nbsp;&nbsp;|&nbsp;&nbsp;");
//writer.println("<a target='_blank' href='annotationDump.do'>Annotation Dump</a>");
writer.println("&nbsp;&nbsp;|&nbsp;&nbsp;");
writer.println("<a target='_blank' href='eventDump.do'>Event Dump</a>");
writer.println("&nbsp;&nbsp;|&nbsp;&nbsp;");
writer.println("<a target='_blank' href='scriptDump.do'>Script Dump</a>");
writer.println("&nbsp;&nbsp;|&nbsp;&nbsp;");
writer.println("<a target='_blank' href='eventDump.do?action=resetRestPassword'>重置REST动态密码</a>");
writer.println("</div>");

writer.println("<hr size=\"1\" noshade=\"noshade\"><center style='padding: 10px'><font size=\"-1\" color=\"#525D76\"><em>Copyright &copy; 2009, www.seeyon.com " + (System.currentTimeMillis() - startTime) +"ms</em></font></center>");
writer.println("</body>");
writer.println("</html>");
%>
