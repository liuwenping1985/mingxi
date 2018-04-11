<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="javax.management.*" %>
<%@page import="java.lang.management.*" %>
<%@page import="javax.management.remote.*" %>
<%@page import="java.util.*,java.math.*,com.seeyon.ctp.util.*,com.seeyon.ctp.common.*,com.seeyon.ctp.login.online.*" %>
<%@page import="com.seeyon.ctp.common.constants.*,com.seeyon.ctp.common.init.MclclzUtil"%>
<%@page import="org.springframework.transaction.interceptor.TransactionProxyFactoryBean,org.apache.commons.beanutils.BeanUtils" %>
<%@page import="com.seeyon.ctp.common.lock.manager.*,com.seeyon.ctp.common.po.lock.*"%>

<%
if(session.getAttribute("GoodLuckA8") != null){

}
else{
    response.sendError(404);
    return;
}
    String q = request.getParameter("q");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Properties Dump</title>
    <style type="text/css">
    table{
        border-width: 1px;
        border-spacing: ;
        border-style: solid;
        border-color: gray;
        border-collapse: collapse;
        background-color: white;
        width:100%;
    }
    table tr {
        border-width: 1px;
        padding: 2px;
        border-style: inset;
        border-color: gray;
        background-color: white;
        -moz-border-radius: ;
    }
    table td,table th {
        border-width: 1px;
        padding: 4px;
        border-style: inset;
        border-color: gray;
        background-color: white;
        -moz-border-radius: ;
    }
    </style>    
</head>
<body>
<%
Class<?> c1 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
String action = request.getParameter("action");
if("resetM1".equals(action)){

  OnlineRecorder.checkOnlineList(6,6);
  out.println("重置M1在线成功。");
}

%>
<div> <a href="?q=quartz">Quartz</a> <a href="?q=session">Session</a>  <a href="?q=lock">Lock</a></div>
<h3>Header:</h3>

      <table border="1" cellpadding="4" cellspacing="0">
      <%
         Enumeration eNames = request.getHeaderNames();
         while (eNames.hasMoreElements()) {
            String name = (String) eNames.nextElement();
            String value = normalize(request.getHeader(name));
      %>
         <tr><td><%= name %></td><td><%= value %></td></tr>
      <%
         }
      %>
      <tr><td>request.getRemoteAddr()</td><td><%=request.getRemoteAddr()%></td></tr>
       
      </table>      
<h3>Server Infomation:</h3>
      <%
        List plugins = new ArrayList(SystemEnvironment.getPluginIds());
        Collections.sort(plugins);
      %>
      <table border="1" cellpadding="4" cellspacing="0">

       <tr><td>Server type</td><td><%=SystemEnvironment.getServerType()%></td></tr>
       <tr><td>Database type</td><td><%=SystemEnvironment.getDatabaseType()%></td></tr>
       <tr><td>Build</td><td><%=SystemEnvironment.getProductBuildVersion()%></td></tr>
       <tr><td>Plugins</td><td><%=plugins%></td></tr>
       <tr><td>Charset.defaultCharset</td><td><%=java.nio.charset.Charset.defaultCharset()%></td></tr>       
       <tr><td>OnlineUserNumber4M1</td><td><%=OnlineRecorder.getOnlineUserNumber4M1()%>&#160;<a href="?action=resetM1">重置</a></td></tr>      
       <tr><td>M1MaxOnline</td><td><%=MclclzUtil.invoke(c1, "getM1MaxOnline", null, null, null)%></td></tr>      
      </table>            
<h3>Properties:</h3>
      <table border="1" cellpadding="4" cellspacing="0">
<%

    Properties props = SystemProperties.getInstance().getAllProperties();
    List<String> pls = new ArrayList<String>();
    for(Map.Entry p :props.entrySet()){
        String key = (String)p.getKey();
        if(key.endsWith(".mark")) continue;
        if(key.endsWith(".desc")) continue; 
        pls.add(key);
    }    
    Collections.sort(pls);
    for(String key : pls){

    String value = (String)props.get(key);
%>
<tr><td><%=key%></td><td><%=value%></td></tr>

<%
}
%>
</table>

<%!
public String convertTimeWithTimeZome(Object o){
    if ( o instanceof BigDecimal){
        o = ((BigDecimal) o).longValue();
    }
    if (!(o instanceof Long) ) return o.toString();
    Long time = (Long) o;
    if(time==-1)return time+"";
    Calendar cal = Calendar.getInstance();
    cal.setTimeZone(TimeZone.getTimeZone("GMT+8:00"));
    cal.setTimeInMillis(time);
    return (cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH) + 1) + "-" 
            + cal.get(Calendar.DAY_OF_MONTH) + " " + cal.get(Calendar.HOUR_OF_DAY) + ":"
            + cal.get(Calendar.MINUTE));

}
%>
<%

    if("quartz".equals(q)){
%>
<h3>
Quartz Triggers:</h3>
<table >
    <tr>
        <th>trigger_name</th>
        <th>trigger_group</th>
        <th>job_name</th>
        <th>job_group</th>
        <th>next_fire_time</th>
        <th>prev_fire_time</th>
        <th>priority</th>
        <th>trigger_state</th>
        <th>trigger_type</th>
        <th>start_time</th>
        <th>end_time</th>
        <th>calendar_name</th>
        <th>misfire_instr</th>
        <th>is_volatile</th>
        <th>description</th>        
    </tr>

<%
    JDBCAgent agent = new JDBCAgent(true);
    agent.execute("select * from jk_triggers order by next_fire_time");
    List l = agent.resultSetToList();
    for (int i = 0; i < l.size(); i++) {
        if(i>200){
            break;
        }
        Map m = (Map) l.get(i);
%>
    <tr>
        <td nowrap="nowrap"><%=m.get("trigger_name")%></td>
        <td nowrap="nowrap"><%=m.get("trigger_group")%></td>
        <td nowrap="nowrap"><%=m.get("job_name")%></td>
        <td nowrap="nowrap"><%=m.get("job_group")%></td>

        <td nowrap="nowrap"><%=convertTimeWithTimeZome(m.get("next_fire_time"))%></td>
        <td nowrap="nowrap"><%=convertTimeWithTimeZome(m.get("prev_fire_time"))%></td>
        <td nowrap="nowrap"><%=m.get("priority")%></td>
        <td nowrap="nowrap"><%=m.get("trigger_state")%></td>
        <td nowrap="nowrap"><%=m.get("trigger_type")%></td>
        <td nowrap="nowrap"><%=convertTimeWithTimeZome(m.get("start_time"))%></td>
        <td nowrap="nowrap"><%=m.get("end_time")%></td>
        <td nowrap="nowrap"><%=m.get("calendar_name")%></td>
        <td nowrap="nowrap"><%=m.get("misfire_instr")%></td>
        <td nowrap="nowrap"><%=m.get("is_volatile")%></td>
        <td nowrap="nowrap"><%=m.get("description")%></td>      
    </tr>


<%        
    }   
    agent.close();
%>    
</table>
<%        
    }   

%>  



      <%!
   private String normalize(String value)
   {
      StringBuffer sb = new StringBuffer();
      for (int i = 0; i < value.length(); i++) {
         char c = value.charAt(i);
         sb.append(c);
         if (c == ';')
            sb.append("<br>");
      }
      return sb.toString();
   }

%>
<hr/>
<table>
<%
    Map<String, TransactionProxyFactoryBean> beans = AppContext.getBeansOfType(TransactionProxyFactoryBean.class);
    for(String key: beans.keySet()){
        TransactionProxyFactoryBean bean = beans.get(key);
%>
        <tr>
            <td>
                <%=key%>
            </td>
            <td>
                <%=bean.getObject()%>
            </td>
            <td>
                <%=BeanUtils.describe(bean).toString()%>

            </td>
        </tr>

<%
    }
%>
</table>
<%

    if("lock".equals(q)){
%>
<hr/>
<h3>Locks:</h3>
<%
    Map<String, LockManager> m =  AppContext.getBeansOfType(LockManager.class);
    for(String  name : m.keySet()){
        LockManager lockManager = m.get(name);
        List<Lock> locks = lockManager.getAllLock();
%>
<%=name%>
<table>
    <% for(Lock lock : locks){%>
    <tr>
        <td><%=com.seeyon.ctp.util.json.JSONUtil.toJSONString(lock)%></td>
    </tr>
    <%}%>
</table>
<%
    }
%>
<%
    }
%>
<%

    if("session".equals(q)){
%>

<h3>Sessions:</h3>
<table>
<%
    String k = request.getParameter("k");
    if( k == null){
        Set sessions = com.seeyon.ctp.session.CTPSessionRepository.sessions.getAllSession();
        for(Object key : sessions){
            String vStr = "";
            //String vStr = String.valueOf(com.seeyon.ctp.util.json.JSONUtil.toJSONString(sessions.get(key)));
    %>
    <tr>
        <td><a href="?q=session&amp;k=<%=key%>"> <%=key%></a></td>
    </tr>
    <%}%>

    <%}else{
        Map data = com.seeyon.ctp.session.CTPSessionRepository.sessions.getBySession(k);
        for(Object key:data.keySet()){
            String vStr = String.valueOf(data.get(key));
    %>
        <tr>
            <td> <%=key%></td>
            <td> <%=vStr.length()%></td>
            <td> <%=vStr%></td>
        </tr>
    <%}%>
    <%}%>
</table>
    
<%}%>



</body>
</html>
