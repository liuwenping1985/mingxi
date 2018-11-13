<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.hibernate.impl.SessionFactoryObjectFactory,org.hibernate.SessionFactory,org.hibernate.stat.Statistics"%>
<%@page import="java.util.Collection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.NameNotFoundException"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.Reference"%>
<%@page import="org.hibernate.impl.SessionFactoryObjectFactory"%>
<%@page import="java.util.Collection"%>

<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<pre>
<%
if(session.getAttribute("GoodLuckA8") == null){
    response.sendRedirect("hello.jsp");
    return;
}
Collection<Object> sessionFactory = SessionFactoryObjectFactory.getAll();

for(Object o1 : sessionFactory){
    if(!(o1 instanceof org.hibernate.engine.SessionFactoryImplementor)){
        continue;
    }
    
    org.hibernate.engine.SessionFactoryImplementor sf = (org.hibernate.engine.SessionFactoryImplementor)o1;
    
    java.util.Collection<Object> m = sf.getQueryPlanCache().getPlanCache().values();
    if(m.isEmpty()){
        continue;
    }
    
    java.util.Set<String> l = new java.util.HashSet<String>();
    
    for(Object o : m){
        if(o instanceof org.hibernate.engine.query.HQLQueryPlan){
            org.hibernate.engine.query.HQLQueryPlan p = (org.hibernate.engine.query.HQLQueryPlan)o;
            l.add(p.getSourceQuery());
        }
        else{
            org.hibernate.engine.query.NativeSQLQueryPlan p = (org.hibernate.engine.query.NativeSQLQueryPlan)o;
            l.add(p.getSourceQuery());
        }
    }
    java.util.List<String> n = new java.util.ArrayList<String>(l);
    java.util.Collections.sort(n);
    
    out.println("<p>HQLQueryPlan : " + n.size() + "</p>");
    
    boolean isCheck = "a".equals(request.getParameter("a"));
    
    Pattern p = Pattern.compile("\\d{8,}+");
    
    for (String s : n) {
        if(isCheck){
            Matcher m1 = p.matcher(s);
            if(!m1.find()){
                continue;
            }
        }
        
        out.println(s.trim());
    } 
    
    out.println("***************************************************");
    
    java.util.Iterator i = sf.getQueryPlanCache().getSqlParamMetadataCache();
    while(i.hasNext()){
        String s = String.valueOf(i.next());
        
        if(isCheck){
            Matcher m1 = p.matcher(s);
            if(!m1.find()){
                continue;
            }
        }
        
        out.println(s);
    }
    
    if("true".equalsIgnoreCase(request.getParameter("clear"))){
        m.clear();
    }
}
%>

<a href="?a=a">Check SQL-Injection</a>
</pre>
</body>
</html>