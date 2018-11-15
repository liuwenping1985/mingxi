<%@page import="com.seeyon.ctp.util.Datetimes"%>
<%@page import="com.seeyon.v3x.dbpool.datasource.DataSourceConProvider" %>
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

writer.println("<hr size=\"1\" noshade=\"noshade\">");
writer.print("<div style='padding: 10px'>");
writer.println("<b>Now: " + Datetimes.format(new java.util.Date(), "yyyy-MM-dd HH:mm:ss") + "</b>");
writer.println("<pre>");

java.util.List<DataSourceConProvider> map = DataSourceConProvider.getDataSources();
for(DataSourceConProvider entry : map){
	entry.getFProvider().printInfo(writer);
	entry.getFProvider().printInUseList(writer);
	writer.println("\n");
}

writer.println("</pre>");
writer.println("</div>");
writer.println("<hr size=\"1\" noshade=\"noshade\"><center><font size=\"-1\" color=\"#525D76\"><em>Copyright &copy; 2009, www.seeyon.com</em></font></center>");

writer.println("</body>");
writer.println("</html>");
%>
