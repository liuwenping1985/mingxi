<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../docHeader.jsp"%>
<script type="text/javascript">
var _linkType = "";
var _linkShowType = "";
var _sourceType = "";
var _sourceValue = "";
function getSelectedData() {
  var _listFrame = document.getElementById("listFrame").contentWindow;
  var ids = _listFrame.document.getElementsByName("id");
  for(var i = 0; i < ids.length; i++){
    if(ids[i].checked){
      _linkType = "doc";
      if (ids[i].getAttribute("isFolder") == "true") {
        _linkShowType = "1";
      } else {
        _linkShowType = "0";
      }
      _sourceType = "6";
      _sourceValue = ids[i].value;
    }
  }
}
</script>
</head>
    <frameset cols="150,*" id="docQuoteFrameset" border="5" frameBorder="1"  bordercolor="#ececec">
        <frame src="${detailURL}?method=docQuoteTree&isrightworkspace=quote&appName=${param.appName}&referenceId=${v3x:toHTML(param.referenceId)}&from=${param.from}&secretLevel=${param.secretLevel}" frameborder="1" bordercolor="#ececec" name="treeFrame" id="treeFrame" scrolling="no"><%--fb  关联文档传主信息的流程密级 --%>
    	<frame id="listFrame" name="listFrame" src="${detailURL}?method=docQuoteList&isQuote=true&referenceId=${param.referenceId}&from=${param.from}&secretLevel=${param.secretLevel}" framespacing="0" frameborder="no" border="0" scrolling="no"><%--fb  关联文档传主信息的流程密级 --%>
    	<noframes>
        	<body topmargin="0" leftmargin="0">
        	</body>
    	</noframes>
    </frameset>
</html>