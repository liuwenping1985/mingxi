<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.seeyon.ctp.util.annotation.MethodAnnotation"%>
<%@page import="com.seeyon.ctp.util.annotation.ClassAnnotation"%>
<%@page import="java.util.Set"%>
<%@page import="java.lang.annotation.Annotation"%>
<%@page import="java.util.List"%>
<%@page import="com.seeyon.ctp.util.annotation.AnnotationFactory"%>
<%@page import="com.seeyon.ctp.common.AppContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if(session.getAttribute("GoodLuckA8") != null){

}
else{
	response.sendError(404);
	return;
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Annotation Dump</title>
</head>
<body>
<pre>
<%
AnnotationFactory annotationFactory = (AnnotationFactory)AppContext.getBean("annotationFactory");
Set<Class<? extends Annotation>> annotationTypes = annotationFactory.getAllAnnotationTypes();

for(Class<? extends Annotation> annotationType : annotationTypes){
	out.println("<B>================= " + annotationType + " =================</B>");
	
	Set<ClassAnnotation> ca0 = annotationFactory.getAnnotationOfClass(annotationType);
	Set<MethodAnnotation> ma0 = annotationFactory.getAnnotationOfMethod(annotationType);
	
	out.println("<B>----- ClassAnnotation  -----</B>");
	if(ca0 != null){
		List<ClassAnnotation> ca = new ArrayList<ClassAnnotation>(ca0);
		//Collections.sort(ca);
		
		for(ClassAnnotation c : ca){
			out.println(c.getClazz().getCanonicalName());
		}
	}
	
	out.println("<B>----- MethodAnnotation -----</B>");
	if(ma0 != null){
		List<MethodAnnotation> ma = new ArrayList<MethodAnnotation>(ma0);
		//Collections.sort(ma);
		
		for(MethodAnnotation m : ma){
			out.println(m.getClazz().getCanonicalName() + "\t" + m.getMethodName() + "()");
		}
	}
	out.println("");
}
%>
</pre>
</body>
</html>