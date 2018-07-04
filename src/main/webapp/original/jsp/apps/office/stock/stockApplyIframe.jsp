<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
</style>
<title>${ctp:i18n('office.manager.StockUseManagerImpl.bgyplysq.js')}</title>
<style type="text/css">
#toolbar .common_toolbar_box {
    background: none;
    margin-right: 5px;
}
</style>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(function() {
  var userName = encodeURIComponent("${CurrentUser.name}");
  var accountName = encodeURIComponent("${CurrentUser.loginAccountName}");
  
  if ("${ctp:escapeJavascript(param.operate)}" == 'add' || "${ctp:escapeJavascript(param.operate)}" == 'modify') {
    $("#officeTemplate").attr("src", "${path}/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate=true&scene=2&processId=${processId}&appName=office&san=stock&currentUserName=" + userName + "&currentUserAccountName=" + accountName);
  } else {
    $("#officeTemplate").attr("src", "${path}/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate=true&scene=3&processId=${processId}&caseId=${caseId}&currentNodeId=${param.workItemId}&appName=office&san=stock");
  	//打印
    officeTBar().addAll(["print"]).init("toolbar");
  }
});

function fnPrint(){
    //获取日期控件的value
    var obj=document.getElementById("autoApplyEdit").contentWindow;  
    var ifmObj=obj.document.getElementById("applyDate");  
    var dept = obj.document.getElementsByName("applyDept_txt")[0];  
    var users = obj.document.getElementsByName("applyUser_txt")[0];
    var deptValue = $(dept).val();
    var applyDate = $(ifmObj).val();
    var userValue = $(users).val();
    $(ifmObj).attr('value',applyDate);
    $(dept).attr('value',deptValue);
    $(users).attr('value',userValue);
    var norThDivHtml = "<div>" + obj.$('.layout_north').find('.calendar_icon_area ').hide().end().html() + "<div>";
    var bdivStyle = obj.$('.layout_center').find(".bDiv").attr("style");
    var htmlObj = obj.$('.layout_center').find(".bDiv").attr("style","").end().html();
    var centerHtml ="<div style='width:915px;'>" +  htmlObj + "</div>";
    var southHtml = "<div style='margin-left: 0px;''>" + obj.$('.layout_south').find('#countTr').attr('height','40').end().html() + "</div>";
    var printFrame = new PrintFragment("", "<div style='width:1115px;margin-left: 75px;' align='center'>"+ norThDivHtml +centerHtml + southHtml+"</div>");
    var mainList = new ArrayList();
    mainList.add(printFrame);
    var cssList = new ArrayList();
    printList(mainList, cssList, "true");
    //还原之前的设置
    obj.$('.layout_center').find(".bDiv").attr("style",bdivStyle);
    obj.$('.layout_north').find('.calendar_icon_area ').show();
    obj.$('.layout_south').find('#countTr').removeAttr("height");
}
</script>
</head>
<body class="h100b bg_color over_hidden">
<div id="toolbar" class="right"></div>
<div id="divId" class="margin_5 h100b" >
  <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
    <div id="tabs_head" class="common_tabs clearfix">
      <ul class="left">
        <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="autoApplyEdit"><span>${ctp:i18n('office.asset.assetApplyIframe.pzw.js')}</span></a></li>
        <li><a class="no_b_border" href="javascript:void(0)" tgt="officeTemplate"><span>${ctp:i18n('office.asset.assetApplyIframe.plc.js')}</span></a></li>
      </ul>
    </div>
    <div id="tabs_body" class="common_tabs_body border_all">
      <!-- 申请 -->
      <iframe id="autoApplyEdit" border="0" src="${path}/office/stockUse.do?method=stockApplyEdit&applyId=${param.applyId}&operate=${ctp:toHTML(param.operate)}" frameBorder="0" width="100%"></iframe>
      <iframe id="officeTemplate" border="0" frameBorder="0" width="100%" class="display_none"></iframe>
    </div>
  </div>
</div>
</body>
</html>