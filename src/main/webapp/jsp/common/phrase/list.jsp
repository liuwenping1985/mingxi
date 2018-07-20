<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp" %>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/v3xmain/css/phrase.css${v3x:resSuffix()}" />">
<style type="text/css">
/***layout*row1+row2+row3****/
.main_div_row3 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row3 {
 width: 100%;
 height: 100%;
 _padding:0px 0px 25px 0px;
}
.main_div_row3>.right_div_row3 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row3 {
 width: 100%;
 height: 135px;
 /*background-color:#00CCFF;*/
 overflow:auto;
 overflow-x:hidden;
}
.right_div_row3>.center_div_row3 {
 height:auto;
 position:absolute;
 top:0px;
 bottom:25px;
}
.bottom_div_row3 {
 height:25px;
 line-height: 25px;
 vertical-align: middle;
 width:100%;
 background-color:#EEE;
 position:absolute;
 bottom:0px;
 _bottom:-1px; /*-- for IE6.0 --*/
}
/***layout*row1+row2+row3**end**/
</style>

<script type="text/javascript">
<!--
var phraseURL = "phrase/phrase.do?method=gotolistpage&app=4";
var personalphraselist = [];
var i = 0;

function showEditPhrase(){
	getA8Top().win123 = getA8Top().$.dialog({
		transParams:{'parentWin':window},
		title: "${ctp:i18n('phrase.sys.js.neworupdate')}",
		url : phraseURL,
		height: 400,
        width:600
    });
}
//-->
</script>
</head>
<body>
<div class="main_div_row3">
  <div class="right_div_row3">
    <div class="center_div_row3">
		<c:set value="1" var="loop" />
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<c:forEach items="${phrases}" var="phrase">
			<tr valign="middle" onMouseOver="this.style.backgroundColor='#eeeeee'" onMouseOut="this.style.backgroundColor='white'">
				<td class="phrase-div-1" width="30">&nbsp;${loop}.&nbsp;</td>
				<td class="phrase-div-1" onclick="usePhrase(this)"><span class="phrase-type-${phrase.type}" title='<fmt:message key="phrase.system.label" />'></span>${phrase.content}</td>
			</tr>			
			<script>
				var type = ${phrase.type};
				if(type == 0) {
					personalphraselist[i] = new Object();
					personalphraselist[i].id = '${phrase.id}';
					personalphraselist[i].memberId = '${phrase.memberId}';
					personalphraselist[i].type = type;
					personalphraselist[i].content = '${v3x:toHTML(phrase.content)}';
					i++;
				}
			</script>
			<c:set value="${loop + 1}" var="loop" />
		</c:forEach>
		</table>
    </div>
    <div class="bottom_div_row3">
		<div class="phrase-div-0" onClick="showEditPhrase()">
			<a class="like-a" href="javascript:void(0)"><fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}" />/<fmt:message key="common.toolbar.edit.label" bundle="${v3xCommonI18N}" /></a>
		</div>
		<div class="cursor-hand like-a" style="float:right;padding-right:5px" onclick="parent.hiddenPhrase()" title='<fmt:message key="common.button.close.label" bundle="${v3xCommonI18N}" />'><fmt:message key="common.button.close.label" bundle="${v3xCommonI18N}" />&nbsp;</div>
    </div>
  </div>
</div>
</body>
</html>