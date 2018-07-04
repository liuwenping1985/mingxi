<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@page import="java.util.*"%>
<html>
<head>
<!--  <script type="text/javascript" charset="UTF-8" src="/seeyon/common/js/V3X.js?V=V5_0_product.build.date"></script>-->
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js?V=V5_0_product.build.date"></script>
<script type="text/javascript">
var contpath="seeyon";
function _favorite(type){
  if(type=="1"){
    favorite('3', document.getElementById("attid").value, 'false', '4');
  }else if(type=="2"){
    favorite('3', document.getElementById("fileid").value, 'false', '3');
  }else if(type=="3"){
    doc_recommend(document.getElementById("fileid").value);
  }
}
</script>
</head>
<body>
<div align=center>
${ctp:i18n('doc.log.attachment.number')}：<input type=text id="attid" value="-5179698836666759922">
${ctp:i18n('doc.log.resource.number')}：<input type=text id="fileid" value="3777222902220604298"><br>
<input type=button value="${ctp:i18n('doc.log.attachment.collect')}" onclick="_favorite(1)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type=button value="${ctp:i18n('doc.log.text.collect')}" onclick="_favorite(2)">
<br><br>
<input type=button value="${ctp:i18n('doc.log.document.recommend')}" onclick="_favorite(3)">
</div>
</body>
</html>