<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>直接派车单</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
  $(function() {
    //打印
    if("${param.operate}"!="add"){
	    officeTBar().addAll(["print"]).init("toolbar");
    }
  });
  
  function fnPrint(){
    var curentTab = $("li.current");
    var cId = curentTab.find("a").attr("tgt");
    
    var url = $("#"+cId).attr("src");
    var applyId = getMultyWindowId("applyId",url),method=getMultyWindowId("method",url);  
    var bodyContent ="<iframe id='autoApplyEdit' border='0' src='${path}/office/autoUse.do?method="+method+"&applyId="+applyId+"' frameBorder='0' style='height:600px;' height='100%' width='100%'></iframe>"
    
    var printFrame = new PrintFragment("", bodyContent);
    var mainList = new ArrayList();
    mainList.add(printFrame);
    var cssList = new ArrayList();
    printList(mainList, cssList);
  }
</script>
</head>
<body class="h100b bg_color over_hidden">
<div id="divId" class="margin_5 h100b" >
  <!-- 设置在什么状态 -->
  <c:set var="isRecede" value="${(state == 15) or (state == 20)}" scope="page"/>
  <c:set var="tabIndex" value="${isRecede?1:0}" scope="page"/>
  <div id="tabs" class="comp bg_color" comp="type:'tab',parentId:'divId',showTabIndex:${tabIndex}" style="position: relative;">
    <div class="clearfix right" id="toolbar" style="position: absolute; top:-5px; right:0px;"></div>
    <div id="tabs_head" class="common_tabs clearfix" >
      <ul class="left">
        <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="autoDSendEdit"><span>${ctp:i18n('office.auto.use.send.bill.js')}</span></a></li>
        <c:if test="${isRecede}">
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="autoRecede"><span>${ctp:i18n('office.auto.autorecade.bill.js')}</span> </a></li>
        </c:if>  
      </ul>
    </div>
    <div id="tabs_body" class="common_tabs_body border_all">
      <!-- 派车单 -->
      <iframe id="autoDSendEdit" border="0" ${isRecede?'hSrc':'src'}="${path}/office/autoUse.do?method=autoDSendEdit&applyId=${param.applyId}&isEdit=${ctp:toHTML(param.isEdit)}&isDEdit=${ctp:toHTML(param.isDEdit)}&isFromMsg=${ctp:toHTML(param._isModalDialog)}" onload="fnResadeHeight(this)" frameBorder="0" width="100%"></iframe>
      <c:if test="${isRecede}">
        <iframe id="autoRecede" border="0" hSrc="${path}/office/autoUse.do?method=autoRecedeEdit&applyId=${param.applyId}&isRecedeEdit=${param.isRecedeEdit}" onload="fnResadeHeight(this)" frameBorder="0" width="100%"></iframe>
      </c:if>
    </div>
  </div>
</div>
</body>
<script type="text/javascript">
function fnResadeHeight(obj) {
	var iframeHeight = $('#tabs_body').height();
	$(obj).height(iframeHeight);
}
</script>
</html>