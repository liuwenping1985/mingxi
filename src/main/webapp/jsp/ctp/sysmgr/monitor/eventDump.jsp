<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.event.*,com.seeyon.ctp.common.*,com.seeyon.ctp.util.annotation.*,com.seeyon.ctp.common.aspect.*,java.lang.annotation.Annotation"%>
<%@page import="java.util.*"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Event Dump</title>
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
            String action = request.getParameter("action");
            if("resetRestPassword".equals(action)){
                Map<String,com.seeyon.ctp.usersystem.manager.DynamicRestUserInitializer> beans = AppContext.getBeansOfType(com.seeyon.ctp.usersystem.manager.DynamicRestUserInitializer.class);
                if(beans.size()>0){
                    for(com.seeyon.ctp.usersystem.manager.DynamicRestUserInitializer bean : beans.values()){
                        bean.reset();
                        out.println("密码重置成功！");
                        break;
                    }
                     
                }    
            }
        %>
		<h3>ListenEvent:</h3>
		<%
			EventDispatcher dispacher = new EventDispatcher();
			Map map = dispacher.getAllListener();
			out.println("<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\">");
			out.println("<tr><th>事件</th><th>监听</th></tr>");
			for (Object key : map.keySet()) {
				Object v = map.get(key);
				List list = (List) v;
				int len = list.size();
				String rowspan = "";//len>1 ? " rowspan=\"" + len + "\" " : "";
				out.println("<tr>");
				out.println("<td" + rowspan + ">");
				out.println(key);
				out.println("</td>");
				out.println("<td>");

				for(Object l : list ){
					out.println(l.toString().replace("AnnotationReflectListener:",""));
					out.println("<br/>");
				}
				out.println("</td>");
				out.println("</tr>");
			}
			out.println("</table>");
		%>
        <hr/>
        <h3>ClassAnnotation:</h3>
		<%

			AnnotationFactory handler = (AnnotationFactory) AppContext.getBean("annotationFactory");
			Map m = handler.getAllAnnotationOfClass();
			out.println(dumpAnnotations(m));
        %>
        <hr/>
        <h3>MethodAnnotation:</h3>
        <%
			m = handler.getAllAnnotationOfMethod();
			out.println(dumpAnnotations(m));
		%>
		<h3>After:</h3>
		<%

			map = AspectAnnotationAware.getAllListener(After.class);
			map = new TreeMap(map);
			out.println("<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\">");
			out.println("<tr><th>执行后</th><th>调用</th></tr>");
			for (Object key : map.keySet()) {
				Object v = map.get(key);
				List list = (List) v;
				out.println("<tr>");
				out.println("<td>");
				out.println(key);
				out.println("</td>");
				out.println("<td>");

				for(Object l : list ){
					out.println(l.toString().replace("AnnotationReflectListener:",""));
					out.println("<br/>");
				}
				out.println("</td>");
				out.println("</tr>");
			}
			out.println("</table>");
		%>
	</body>
</html>
<%!
    void handleAnnotation(Annotation anno,StringBuffer sb){
        if(anno instanceof CheckRoleAccess){
            CheckRoleAccess cra = (CheckRoleAccess) anno;
            sb.append("[");
            for(com.seeyon.ctp.organization.OrgConstants.Role_NAME rt : cra.roleTypes()){
                sb.append(rt.name()).append("&#160;");
            }
            sb.append("]&#160;");
        }
    }
	String dumpAnnotations(Map map) throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\">");
		sb.append("<tr><th>Annotation</th><th>Bean & Method</th></tr>");
		for (Object key : map.keySet()) {
            if(key == ListenEvent.class){
                // continue;
            }
			sb.append("<tr>");
			sb.append("<td>");
			sb.append(key);
			sb.append("</td>");
			sb.append("<td>");
			Object v = map.get(key);
			Set list = (Set) v;
			for(Object l : list ){
				if(l instanceof MethodAnnotation){
					MethodAnnotation a = (MethodAnnotation) l;
                    handleAnnotation(a.getAnnotation(),sb);

					sb.append(a.getBeanName());
					sb.append(".");
					sb.append(a.getMethodName());
					sb.append("()<br/>");
				}else if(l instanceof ClassAnnotation){
					ClassAnnotation a = (ClassAnnotation) l;
                    handleAnnotation(a.getAnnotation(),sb);
					sb.append(a.getBeanName());
					sb.append("<br/>");
				}

			}
			sb.append("</td>");
			sb.append("</tr>");
		}
		sb.append("</table>");
		return sb.toString();
	}
%>
