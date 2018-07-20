
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<HTML>
<HEAD>
<TITLE>${ctp:i18n('form.forminputchoose.rename')}</TITLE>
<style>
</style>
</HEAD>
<BODY>
<form method="post">
    <div style="width: 100%;height: 100%;font-size: 12px;">
	    <div style="margin: 5px;line-height: 25px;">
	        <span style="display: inline-block;width: 60px;">${ctp:i18n('form.forminputchoose.renamedata')}：</span>
	        <span><label id="rowheader" name="statRowHeader"></label></span>
	    </div>
	    <div style="margin: 5px;line-height: 25px;">
	        <span style="display: inline-block;width: 60px;text-align: right;">${ctp:i18n('form.forminputchoose.title')}：</span>
	        <span><input type="text" id="title" class=""/></span>
	    </div>
	    <div style="margin: 5px;line-height: 25px;">
	        <font color='red'>${ctp:i18n('form.forminputchoose.titleerror')}</font>
	    </div>
    </div>
</form>
<%@ include file="forminputchooserename.js.jsp"%>
</BODY>
</HTML>