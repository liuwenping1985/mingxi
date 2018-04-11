<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp"%>
<style type="text/css" media=print>
<!--
.Noprint{display:none;}
.PageNext{page-break-after: always;}
-->
</style>
<OBJECT classid="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2" height="0" id="wb" name="wbprint" width="0"></OBJECT>
<center class="Noprint" >
<input type="button" name="button_print" value="<fmt:message key='edoc.element.print'/>" onclick="javascript:printit()"> 
<input type="button"　name="button_setup" value="<fmt:message key='edoc.print_settings'/>"  onclick="javascript:printsetup();"> 
<input type="button"　name="button_show" value="<fmt:message key='edoc.print.preview'/>"  onclick="javascript:printpreview();"> 
<input type="button" name="button_fh" value="<fmt:message key='edoc.print.close'/>" onclick="javascript:window.close();">
</center>
<script language="javascript">
　　function printsetup(){
	var wb = document.all("wbprint"); 
	　　// 打印页面设置 
	　　wb.execwb(8,1); 
　　} 
　　function printpreview(){ 
	var wb = document.all("wbprint"); 
	　　// 打印页面预览 
	　　wb.execwb(7,1); 
　　} 
　　function printit() 
　　{ 
	var wb = document.all("wbprint"); 
	　　if (confirm("<fmt:message key='edoc.print.confirm'/>")) { 
	　　		wb.execwb(6,6) 
	　　} 
　　}
</script>
