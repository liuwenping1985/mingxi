<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="inquiryHeader.jsp"%>
<title>${title}</title>
<script type="text/javascript">
function iframeReSize(){
  if(v3x.isChrome){
    var tempIframe = document.getElementsByTagName('iframe')[0];
    tempIframe.setAttribute('height',window.document.body.clientHeight);
  }
}
</script>
</head>
<body scroll="no" style="overflow: hidden;" onLoad="iframeReSize()" onResize="iframeReSize()">
<iframe src="${basicURL}?method=survey_detail&spaceId=${param.spaceId}&userId=${param.userId}&bid=${param.bid}&surveytypeid=${v3x:toHTML(param.surveytypeid)}&manager_ID=${v3x:toHTML(param.manager_ID)}&group=${v3x:toHTML(param.group)}&auditFlag=${param.auditFlag}&alauditFlag=${param.alauditFlag}&listShow=${listShow}&from=${from}&fromPigeonhole=${param.fromPigeonhole}&frommessage=${frommessage}&affairId=${affairId}&fromReminded=${fromReminded}&notShowButton=${notShowButton}&survey_check=${param.survey_check}&openFrom=${param.openFrom}" name="showInquiryFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>