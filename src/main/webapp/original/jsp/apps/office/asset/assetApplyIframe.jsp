<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
</style>
<title>${ctp:i18n('office.asset.assetApplyIframe.pbgsbsysq.js') }</title>
<script type="text/javascript">
$(function() {
  var userName = encodeURIComponent("${CurrentUser.name}");
  var accountName = encodeURIComponent("${CurrentUser.loginAccountName}");
  if ("${ctp:escapeJavascript(param.operate)}" == 'add' || "${ctp:escapeJavascript(param.operate)}" == 'modify') {
    $("#officeTemplate").attr("src", "${path}/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate=true&scene=2&processId=${processId}&appName=office&san=asset&currentUserName=" + userName + "&currentUserAccountName=" + accountName);
  } else {
    $("#officeTemplate").attr("src", "${path}/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate=true&scene=3&processId=${processId}&caseId=${caseId}&currentNodeId=${param.workItemId}&appName=office&san=asset");
  }
});

var isInit = false ;
function fnInitTBar(){
  if (!isInit && "${ctp:escapeJavascript(param.operate)}" != 'add' && "${ctp:escapeJavascript(param.operate)}" != 'modify' && "${ctp:escapeJavascript(param.operate)}" != 'dLend'){
  	isInit = true ;
    officeTBar().addAll(["print"]).init("toolbar");
  }
}

function fnPrint(){
  var autoApplyEdit = $("#autoApplyEdit");
  var autoApplyEditIframe = $(autoApplyEdit[0].contentWindow.document);
  var url = autoApplyEdit.attr("src");
  var applyId = getMultyWindowId("applyId",url);
    //操作区
  var tabHtml = autoApplyEditIframe.find("#assetHandleTabDiv").clone(false)
      .find('.calendar_icon_area ').hide().end()
      .find("tr,th").attr("onclick","").attr("onmouseenter","").attr("onmouseleave","").attr("onmousedown","").attr("onmouseup","").end()
      .html();
  var applyEditHeight = parseInt(autoApplyEdit.height());
  if(tabHtml != null){
    tabHtml = "<div style='width: 735px;margin-left: 75px;'>"+fnTabCSSChange(tabHtml)+"</div>";
    applyEditHeight =applyEditHeight - parseInt(autoApplyEditIframe.find("#assetHandleTabDiv").height());
  }
  var bodyContent ="<iframe id='autoApplyEdit' border='0' src='${path}/office/assetUse.do?method=assetApplyEdit&applyId="+applyId+"&print=true' frameBorder='0' height='"+applyEditHeight+"' width='900'></iframe>";

  var printFrame = new PrintFragment("", bodyContent);
  var tablePft = new PrintFragment("",tabHtml);
  var mainList = new ArrayList();
  mainList.add(printFrame);
  if(tabHtml!=null){
	  mainList.add(tablePft);
  }
  var cssList = new ArrayList();
  printList(mainList, cssList, "true");
}

/**
 * 拖动列表打印样式替换
 */
function fnTabCSSChange(sTabHtml) {
	var tabHtml = $("<div>"+sTabHtml+"</div>");
  var mxtgrid = tabHtml.find(".flexigrid");
  if(mxtgrid.length > 0 ){
  		tabHtml.find(".flexigrid a").removeAttr('onclick');
  		tabHtml.find(".hDivBox thead th div,.bDiv tbody td div").each(function(){
          var _html = $(this).html();
          $(this).parent().html(_html);
      });
      
      var tablHeader = tabHtml.find(".hDivBox thead");
      var tableBody = tabHtml.find(".bDiv tbody");
      var headerHtml = tablHeader.html();
      var bodyHtml = tableBody.html();
      
      if(headerHtml == null || headerHtml == 'null'){
      	headerHtml ="";
      }
      
      if(bodyHtml == null || bodyHtml=='null'){
          bodyHtml = "";
      }
      
      var toColTabHtml = "";
      toColTabHtml+="<table class='table-header-print " + (mxtgrid.hasClass('dataTable') ? "table-header-print-dataTable":"") 
      + "' border='0' cellspacing='0' cellpadding='0'><thead>"
      toColTabHtml += headerHtml + "</thead><tbody>" + bodyHtml + "</tbody></table>";
      return toColTabHtml;
  }else{
  	return sTabHtml;
  }
}
</script>
<style>
    #toolbar .common_toolbar_box{
        padding-right: 5px;
        background: none;
    }
</style>
</head>
<body class="h100b bg_color over_hidden">
  <div id="toolbar" class="right"></div>
  <div id="divId" class="margin_5 h100b" >
    <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="autoApplyEdit"><span>
              <c:if test="${param.operate eq 'dLend'}">
                ${ctp:i18n('office.asset.dlend.bill.js')}
              </c:if>
               <c:if test="${param.operate ne 'dLend'}">
                  ${ctp:i18n('office.asset.assetApplyIframe.pzw.js')}
              </c:if>
            </span></a></li>
          <c:if test="${not empty processId}">
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="officeTemplate"><span>${ctp:i18n('office.asset.assetApplyIframe.plc.js') }</span></a></li>
          </c:if>
        </ul>
      </div>
      <div id="tabs_body" class="common_tabs_body border_all">
        <!-- 申请 -->
        <iframe id="autoApplyEdit" border="0" ${(param._isModalDialog eq 'true' or param.operate eq 'dLend' or (empty processId)) ? 'src':'hSrc'}="${path}/office/assetUse.do?method=assetApplyEdit&applyId=${param.applyId}&operate=${ctp:toHTML(param.operate)}&isOpenWin=${param._isModalDialog}" frameBorder="0" width="100%"></iframe>
        <c:if test="${not empty processId}">
        <iframe id="officeTemplate" border="0" frameBorder="0" width="100%" class="display_none"></iframe>
        </c:if>
      </div>
    </div>
  </div>
</body>
</html>