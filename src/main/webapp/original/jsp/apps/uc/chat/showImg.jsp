<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>${ctp:i18n('uc.title.js')}</title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/uc/chat/css/uc.css${ctp:resSuffix()}' />">
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/jquery.ztree.all-3.5.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/json2.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc.upload-debug.js${ctp:resSuffix()}" />"></script>
</head>
<body>
<table width="100%" height="100%" id="showTab" style="table-layout:fixed;">
<tr>
<td height="400"  width="400" align="center" valign="center" style="BACKGROUND-COLOR:#888888">
<img id="imgs" src="" class="maxHeight_680" />
</td>
</tr>
<tr>
<td height="20" align="right">
<span class="font_size_12 margin_b_5"><a href="javaScript:void(0)" onclick="showBackImg()">${ctp:i18n('uc.title.showImg.js') }</a><a href="javaScript:void(0)" onclick="saveImgBy()" class="margin_r_5 margin_l_10">${ctp:i18n('uc.title.sava.js') }</a></span>
</td>
</tr>
</table>
</body>
<script type="text/javascript">
getA8Top().startProc();
var fid = '${fileId}';
var fname = '${fname}';
queryImgPath('show');
function  queryImgPath (_type) {
	var iqs = window.parent.connWin.newJSJaCIQ();
	iqs.setFrom(window.parent.connWin.jid);
	iqs.setIQ('filetrans.localhost', 'get');
	var query1 = iqs.setQuery('filetrans');
	query1.setAttribute('type' ,'get_picture_download_url');
	query1.appendChild(iqs.buildNode('id', '', fid));
	window.parent.connWin.con.send(iqs, showImgFun,_type);
}

function showImgFun (iq,_type) {
	getA8Top().endProc();
	if (iq && iq.getType() != 'error') {
		var url = iq.getNode().getElementsByTagName('downloadurl')[0].firstChild.data;
		if (_type == 'show') {
			document.getElementById('imgs').src = url;
		} else {
			var imgopen = window.open();
			imgopen.document.write("<img src='"+url+"'/>") 
		}
	}
}

function showBackImg () {
	queryImgPath('open');
}

function saveImgBy () {
	downFilePath(fid,fname,window.parent.connWin.con,window.parent.connWin,'image');
}
</script>
    <iframe id="downloadFileFrame" src="" class="hidden"></iframe>
    <form method="get" target="_blank" id="downloadFileFrom"></form>
</html>