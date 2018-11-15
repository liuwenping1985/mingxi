<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.script.ScriptEvaluator"%>
<%@page import="javax.management.*" %>
<%@page import="java.lang.management.*" %>
<%@page import="javax.management.remote.*" %>
<%@page import="java.util.*,java.math.*,com.seeyon.ctp.util.*,org.apache.commons.collections.map.LRUMap,com.seeyon.ctp.common.*,org.springframework.transaction.interceptor.TransactionProxyFactoryBean,org.apache.commons.beanutils.BeanUtils" %>
<%@page import="com.seeyon.ctp.common.constants.*"%>
<%
if(session.getAttribute("GoodLuckA8") != null){

}
else{
    response.sendError(404);
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Script Dump</title>
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
<br>
<hr size="1" noshade="noshade">
<%Map lm=ScriptEvaluator.getInstance().getScriptCache();
int size=lm.size();
%>
<div style='padding: 10px'><b>Script Dump (count:<%=size %>)</b><br>
<b>Now: <%=Datetimes.format(new java.util.Date(), "yyyy-MM-dd HH:mm:ss") %></b><br>
<%
if(lm!=null&&lm.size()>0){
    lm = new java.util.TreeMap(lm);
	Iterator<Map.Entry<String, Object>>  it=lm.entrySet().iterator();
	int i=1;
	while(it.hasNext()){
		Map.Entry<String, Object> entry=it.next();
        String k = entry.getKey().replace("import static com.seeyon.ctp.form.modules.engin.formula.function.FormulaDateFunction.*;import static com.seeyon.ctp.form.modules.engin.formula.function.FormulaOrgFunction.*;import static com.seeyon.ctp.form.modules.engin.formula.FormulaFunction.*;import static com.seeyon.ctp.workflow.script.WorkFlowFunctions.*;","f:    &#160;");
        k = k.replace("import static com.seeyon.ctp.workflow.script.WorkFlowFunctions.*;import static com.seeyon.ctp.form.modules.engin.formula.FormulaFunction.*;","w:    &#160;");
        k = k.replace("use (com.seeyon.ctp.common.script.CtpGroovyCategory){","");
        k = k.substring(0,k.length()-1);
%>
		<%=i%>. <%= k %> <br>
<%	i++;
	}
}else{%>
nothing!<br>
<%} %>
</div>
<hr size="1" noshade="noshade"><center><font size="-1" color="#525D76"><em>Copyright &copy; 2009, www.seeyon.com</em></font></center>
</body>
</html>
