<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<html>
<head>
<title><fmt:message key='print.preview.label' bundle='${v3xCommonI18N}' /></title>
<script type="text/javascript">
<!--
	function init(){
		var contentHTML=window.dialogArguments.contentHTML;
		$('#contentDiv').append(contentHTML);
		$('#contentDiv').find('tFoot').remove();
		if ($('#contentDiv').find('thead > tr > td > input').size() > 0) {
			$('#contentDiv').find('thead > tr > td').eq(0).remove();
			$('#contentDiv').find('tbody > tr').each(function() {
				$(this).find('td').eq(0).remove();
			});
		}
		$('#buttonDiv').show();
	}
	
	$(function(){
		$('#contentDiv').find('td').click(function() {
			return false;
		});
	});
	
	function viewMember(id) {
	    return false;
    }

    function viewRecord(id) {
	    return false;
    }

//-->
</script>
<script Language="Javascript">
	function printit(){
		$('#buttonDiv').hide();  
		if (window.print) {
		    window.print() ;  
		} else {
		    var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
			document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
		    WebBrowser1.ExecWB(6, 2); 
		}
	}
</script>
</HEAD>
<BODY onload="init();" onkeydown=return(!(event.keyCode==78&&event.ctrlKey)) oncontextmenu="return false;" style="FONT-SIZE: 9pt" bgColor=#FFFFFF leftMargin=0 topMargin=0 >
<table border="0" cellpadding="0" cellspacing="0" height="10px"><tr><td>&nbsp;</td></tr></table>
<div id="buttonDiv" align=center>
  <input onClick="printit()" type=button value="<fmt:message key='print.label' bundle='${v3xCommonI18N}'/>" name=ok>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <input onClick="self.close()" type=button value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" name=cancel>
  <hr>
</div>
<div id="contentDiv"></div>
</BODY>
</HTML>
