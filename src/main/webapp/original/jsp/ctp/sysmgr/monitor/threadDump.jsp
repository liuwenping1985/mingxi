<%@page import="com.seeyon.ctp.thread.ThreadInfoHolder"%>
<%@page import="javax.management.*" %>
<%@page import="java.lang.management.*" %>
<%@page import="javax.management.remote.*" %>
<%@page import="java.util.*" %>
<%@page import="com.seeyon.ctp.util.Datetimes"%>
<%!
private void printThreadInfo(java.io.PrintWriter writer, ThreadInfo ti) {
    String threadName = ti.getThreadName();
    
	writer.print("\"" + threadName + "\"" + " Id=" + ti.getThreadId() + " in " + ti.getThreadState());
	if (ti.getLockName() != null) {
		writer.print(" on lock=" + ti.getLockName());
	}
	if (ti.isSuspended()) {
		writer.print(" (suspended)");
	}
	if (ti.isInNative()) {
		writer.print(" (running in native)");
	}
	
	if (ti.getLockOwnerName() != null) {
		writer.print("     owned by " + ti.getLockOwnerName() + " Id=" + ti.getLockOwnerId());
	}
	
	ThreadInfoHolder.CtpThreadInfo ctpThreadInfo = ThreadInfoHolder.getInstance().get(ti.getThreadId());
	if(ctpThreadInfo != null){
	    long s = ctpThreadInfo.getWorkBeginTime();
	    writer.print("  " + Datetimes.formatDatetime(new Date(s)) + "/" + ((System.currentTimeMillis() - s) / 1000));
	}
	
	writer.println();

	// print stack trace with locks
	StackTraceElement[] stacktrace = ti.getStackTrace();
	for (int i = 0; i < stacktrace.length; i++) {
		StackTraceElement ste = stacktrace[i];
		writer.println("    at " + ste.toString());
	}
	writer.println();
}
%>
<%
response.setContentType("text/html; charset=UTF-8");

if(session.getAttribute("GoodLuckA8") == null){
	response.sendRedirect("index.jsp");
	return;
}

java.io.PrintWriter writer = response.getWriter();


writer.println("<html>");
writer.println("<head>");
writer.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
writer.println("<title>A8 Management Monitor</title>");
writer.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"../common/css/default.css\">");
writer.println("</head>");
writer.println("<body>");

writer.println("<a href='index.jsp'><img border=\"0\" src=\"../common/images/A8-logo.gif\"></a>");
writer.println("<hr size=\"1\" noshade=\"noshade\">");

writer.print("<div style='padding: 10px'>");
writer.println("<b>Now: " + Datetimes.formatDatetime(new java.util.Date()) + "</b>  <input type='button' value='Clean' onclick='clean0()'>");
writer.println("<h4>Full Java thread dump</h4>");
writer.println("<pre id='aaa'>");

ThreadMXBean  tmbean = ManagementFactory.getThreadMXBean();
try {

	long[] tids = tmbean.getAllThreadIds();
	ThreadInfo[] tinfos = tmbean.getThreadInfo(tids, Integer.MAX_VALUE);

	for (ThreadInfo ti : tinfos) {
		printThreadInfo(writer, ti);
	}
}
catch (Exception e) {
	e.printStackTrace(writer);
}
writer.println("</pre>");
writer.println("<h4>Deadlock</h4>");
writer.println("<pre>");
try{
    long[] tids = tmbean.findMonitorDeadlockedThreads();
    if (tids != null) { 
        ThreadInfo[] tinfos = tmbean.getThreadInfo(tids, Integer.MAX_VALUE);
        for (ThreadInfo ti : tinfos) {
            printThreadInfo(writer, ti);
        }
    }
    else{
    	writer.println("No Found");
    }
}
catch (Exception e) {
	e.printStackTrace(writer);
}
writer.println("</pre>");

writer.println("</div>");
writer.println("<hr size=\"1\" noshade=\"noshade\"><center><font size=\"-1\" color=\"#525D76\"><em>Copyright &copy; 2009, www.seeyon.com</em></font></center>");

writer.println("</body>");
writer.println("</html>");
%>
<script type="text/javascript">
<!--
function clean0(){
	var aaaStr = document.getElementById("aaa").innerText;
	var aaaArray = aaaStr.split("\n");
	
	var a1 = "";
	
	for(var i = 0; i < aaaArray.length; i++){
		var line = aaaArray[i];
		
		if(line.indexOf("\"") == 0){
			a1 += line + "\n";
		}
	
		if((line.indexOf("com.seeyon") >= 0
			|| line.indexOf("net.joinwork") >= 0) && line.indexOf("$$FastClassBySpringCGLIB") < 0 && line.indexOf("$$EnhancerBySpringCGLIB") < 0){
			a1 += line + "\n";
		}
	}
	
	document.getElementById("aaa").innerText = a1;
	
	clean2();
}

function clean2(){
	var aaaStr = document.getElementById("aaa").innerText;
	var aaaArray = aaaStr.split("\n");
	
	var a1 = "";
	
	for(var i = 0; i < aaaArray.length; i++){
		var line0 = aaaArray[i];
		var line1 = aaaArray[i + 1];

	
		if(line0.indexOf("\"") == 0 && (line1 != null && line1.indexOf("\"") == 0)){
			continue;
		}
		else{
			if(line0.indexOf("\"") == 0){
				a1 += "\n";
			}
			a1 += line0 + "\n";
		}
		
	}
	
	document.getElementById("aaa").innerText = a1;
}
//-->
</script>
