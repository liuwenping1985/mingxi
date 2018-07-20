<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${v3x:_(pageContext, 'doc.jsp.home.more.alert.title')}</title>
<script>
function changedType(type){
	if(type==1){
	    document.getElementById('l-f-1').className='tab-tag-left-sel';
	    document.getElementById('m-f-1').className='tab-tag-middel-sel';
	    document.getElementById('r-f-1').className='tab-tag-right-sel';
	    document.getElementById('l-f-2').className='tab-tag-left';
	    document.getElementById('m-f-2').className='tab-tag-middel';
	    document.getElementById('r-f-2').className='tab-tag-right';
		detailIframe.location.href="${detailURL}?method=docAlertLatestMore&status=0&flag=${flag}";
	}else if(type==2){
	    document.getElementById('l-f-2').className='tab-tag-left-sel';
	    document.getElementById('m-f-2').className='tab-tag-middel-sel';
	    document.getElementById('r-f-2').className='tab-tag-right-sel';
	    document.getElementById('l-f-1').className='tab-tag-left';
	    document.getElementById('m-f-1').className='tab-tag-middel';
	    document.getElementById('r-f-1').className='tab-tag-right';
		detailIframe.location.href="${detailURL}?method=docAlertLatestMore&status=1&flag=${flag}";
	}
	
}
showCtpLocation('F04_docAlertLatestMore');
</script>
</head>
<body scroll="no" class="padding5">
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
<tr>
	<td valign="bottom" height="26" class="tab-tag">
		<div class="div-float">
			<div class="tab-separator"></div>
			<div id="l-f-1" class="tab-tag-left-sel"></div>
			<div id="m-f-1" class="tab-tag-middel-sel" onClick="changedType(1)"><fmt:message key="doc.my.importent.file"/></div>
			<div id="r-f-1" class="tab-tag-right-sel"></div>
						
			<div class="tab-separator"></div>
			<div id="l-f-2" class="tab-tag-left"></div>
			<div id="m-f-2" class="tab-tag-middel" onClick="changedType(2)"><fmt:message key="doc.other.recommend.file"/></div>
			<div id="r-f-2" class="tab-tag-right"></div>	
			<div class="tab-separator"></div>
		</div>
	</td>
</tr>
<tr>
	<td colspan="2" class="page-list-border" style="border-top: 0">
		<iframe noresize src="${detailURL}?method=docAlertLatestMore&status=0&flag=${flag}" frameborder="no" name="detailIframe" id="detailIframe" style="width:100%;height: 100%;" border="0px" scrolling="no"></iframe>	
	</td>
</tr>
</table>
</body>
</html>
