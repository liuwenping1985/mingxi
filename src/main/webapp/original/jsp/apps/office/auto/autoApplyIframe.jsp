<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.stadic_layout_body{
  bottom: 0px;
  overflow: hidden;
  <c:if test="${param.fnTabClk eq 'false'}">
   top:0px;
  </c:if>
}
.stadic_layout_head{
  <c:if test="${param.fnTabClk eq 'false'}">
    height:0px;
  </c:if>
}
#toolbar .common_toolbar_box {
  background: none;
}
.title_view{
  padding-top: 0px;
}
</style>
<title>${ctp:i18n('office.app.auto.use.apply.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(function() {
  <c:if test="${param.fnTabClk eq 'false'}">
    $("#head").hide();
  </c:if>
  var userName = encodeURIComponent("${CurrentUser.name}");
  var accountName = encodeURIComponent("${CurrentUser.loginAccountName}");
  
  if ("${ctp:escapeJavascript(param.operate)}" == "new") {
    $("#officeTemplate").attr("src", "${path}/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate=true&scene=2&processId=${processId}&appName=office&san=auto&currentUserName=" + userName + "&currentUserAccountName=" + accountName);
  } else {
    $("#officeTemplate").attr("src", "${path}/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate=true&scene=3&processId=${processId}&caseId=${caseId}&currentNodeId=${ctp:escapeJavascript(param.workItemId)}&appName=office&san=auto");
  }
  
  //待还车状态
  if(getURLParamPub("isRecedeEdit") == "true"){
    $(".common_tabs").find("a[tgt='autoOutEdit']").click();
    $(".common_tabs").find("a[tgt='autoRecede']").click();
  	//fnTabsClk2ReLoadFirst("autoRecede","autoApplyEdit");
  }
  //打印
  officeTBar().addAll(["print"]).init("toolbar");
});

function fnPrint(){
  var curentTab = $("li.current");
  var cId = curentTab.find("a").attr("tgt");
  if(cId == "officeTemplate"){
    cId = $("li:first").find("a").attr("tgt");
  }
  var url = $("#"+cId).attr("src");
  var method=getMultyWindowId("method",url);
  
  if(method=="autoApplyEdit"){
    var obj=document.getElementById("autoApplyEdit").contentWindow;
  }
  if(method=="sendEdit"){
    var obj=document.getElementById("sendEdit").contentWindow;
  }
  if(method=="autoOutEdit"){
    var obj=document.getElementById("autoOutEdit").contentWindow;
    var realOuttimeObj=obj.document.getElementById("realOuttime");  
    var realOuttimeValue = $(realOuttimeObj).val();
    $(realOuttimeObj).attr('value',realOuttimeValue);
  }
  if(method=="autoRecedeEdit"){
    var obj=document.getElementById("autoRecede").contentWindow;
    obj.$("th").width("120px");
  }
  var items = obj.document.getElementsByTagName("input");
  for(var i = 0;i<items.length;i++){
    var targetObj =items[i];
    var targetValue = $(targetObj).val();
    $(targetObj).attr('value',targetValue);
    if(targetObj.getAttribute("type") == "checkbox"){
        $(targetObj).attr('checked',targetObj.checked);
    }
  }
  var textareas = obj.document.getElementsByTagName("textarea");
  for(var i = 0;i<textareas.length;i++){
    var targetObj =textareas[i];
    var targetValue = $(targetObj).val();
    $(targetObj).html(targetValue);
  }
  var applyDepartType = obj.$("select option:selected").html();//用车范围
  obj.$("td:has(#applyDepartType)").attr("id","tempSelect").html("<DIV id='applyDepartTypeDiv' class='common_txtbox_wrap'><input disabled='disabled' class='validate font_size12 w100b' id='applyDep' type='text' maxLength='80' value='"+applyDepartType+"' validate='type:'string',name:'"+$.i18n('office.autoapply.startplace.js')+"'' _da='true'></div>");
  if(method=="sendEdit"){
    var formDivHtml = "<div style='width:720px;height: 600px;' align='center'>"+ obj.$('.layout_center').find('.calendar_icon_area ').hide().end().html()+"</div>";
  }else{
    var formDivHtml = "<div style='width:720px;height: 600px;' align='center'>"+ obj.$('.stadic_layout_body').find('.calendar_icon_area ').hide().end().html()+"</div>";
  }
  var printFrame = new PrintFragment("", "<style type='text/css'>.stadic_layout_body{position:static} .common_txtbox_wrap span{width:98%;height:20px;}</style><div style='height: 600px;' align='center'>"+ formDivHtml+"</div>");
  var mainList = new ArrayList();
  mainList.add(printFrame);
  var cssList = new ArrayList();
  printList(mainList, cssList, "true");
  obj.$('#tempSelect').html("<select disabled='disabled' class='w100b font_size12' id='applyDepartType' _da='true'><option value='0' selected = 'selected'>"+applyDepartType+"</option></select>");
  if(method=="autoRecedeEdit"){
    obj.$("th").width("80px");
  }
  if(method=="sendEdit"){
	    obj.$('.layout_center').find('.calendar_icon_area :even').show();
  }else{
	  	obj.$('.stadic_layout_body').find('.calendar_icon_area :even').show();
  }
}
</script>
</head>
<body class="h100b bg_color over_hidden">
<div class="stadic_layout">
<div class="stadic_layout_head stadic_head_height">
  <div id="head" class="newinfo_area title_view">
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
      <tr>
        <td width="65">
          <div class="title_area">${ctp:i18n('office.autoaudit.sender.js') }:</div>
        </td>
        <td align="left"><a href="javascript:void(0)" onclick="fnPeopleCardPub('${startMemberId}');">${startMemberIdName}</a>（${applyDate}）</td>
        <td align="right"><div id="toolbar" class="clearfix right margin_b_5"></div></td>
      </tr>
    </table>
  </div>
</div>
<div class="stadic_layout_body stadic_body_top_bottom">
      <c:set var="showTabIndex" value="${(state eq 15 and param.isRecedeEdit eq 'true') ? 2:0}"></c:set>
      <div id="divId" class="margin_5 h100b" >
      <div id="tabs" class="comp" comp="type:'tab',parentId:'divId',showTabIndex:${showTabIndex}">
        <div id="tabs_head" class="common_tabs clearfix">
          <!-- 设置在什么状态 -->
          <ul class="left">
            <li>
              <c:if test="${(empty state) or state eq 1 or state eq 25 or state eq 30 or state eq 35}">
                <a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="autoApplyEdit"><span>${ctp:i18n('office.app.auto.use.apply.bill.js') }</span> </a>
              </c:if>
              <c:if test="${state eq 5}"><!-- 待派车 -->
                <a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="sendEdit"><span>${ctp:i18n('office.app.auto.use.apply.bill.js') }</span> </a>
              </c:if>
              <c:if test="${(state eq 10) or (state eq 15) or (state eq 20)}"><!-- 待出车，待还车，已换车 -->
                <a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="autoOutEdit"><span>${ctp:i18n('office.app.auto.use.apply.bill.js') }</span> </a>
              </c:if>
            </li>
            <c:if test="${not empty processId}"><!-- 流程设置 -->
              <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="officeTemplate"><span>${ctp:i18n('office.app.auto.use.apply.flow.js') }</span> </a></li>
            </c:if>
            <c:if test="${(state == 15) or (state == 20)}">
              <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" tgt="autoRecede"><span>${ctp:i18n('office.auto.autorecade.bill.js') }</span> </a></li>
            </c:if>   
          </ul>
        </div>
        <div id="tabs_body" class="common_tabs_body border_all">
          <!-- 申请 -->
          <c:if test="${(empty state) or state eq 1 or state eq 25 or state eq 30 or state eq 35}">
            <iframe id="autoApplyEdit" border="0" src="${path}/office/autoUse.do?method=autoApplyEdit&applyId=${param.applyId}&operate=${ctp:toHTML(param.operate)}&fnTabClk=${ctp:toHTML(param.fnTabClk)}" onload="fnResadeHeight(this)"  frameBorder="0" height="" width="100%"></iframe>
          </c:if>
          <c:if test="${state eq 5}"><!-- 待派车 -->
            <iframe id="sendEdit" border="0" src="${path}/office/autoUse.do?method=sendEdit&applyId=${param.applyId}&isEdit=${param.isEdit}&operate=${param.operate}" frameBorder="0" onload="fnResadeHeight(this)" width="100%"></iframe>
          </c:if>
          <c:if test="${(state eq 10) or (state eq 15) or (state eq 20)}"><!-- 待出车，待还车，已换车 -->
            <iframe id="autoOutEdit" border="0" src="${path}/office/autoUse.do?method=autoOutEdit&applyId=${param.applyId}&isEdit=${param.isEdit}" frameBorder="0" onload="fnResadeHeight(this)" width="100%"></iframe>
          </c:if>
          
          <c:if test="${not empty processId}"><!-- 流程设置 -->
            <iframe id="officeTemplate" border="0" frameBorder="0" width="100%" class="display_none"></iframe>
          </c:if>
          
          <c:if test="${(state == 15) or (state == 20)}">
            <iframe id="autoRecede" border="0" src="${path}/office/autoUse.do?method=autoRecedeEdit&applyId=${param.applyId}&isRecedeEdit=${param.isRecedeEdit}" onload="fnResadeHeight(this)" frameBorder="0" width="100%"></iframe>
          </c:if>
        </div>
      </div>
  </div>
</div>
</div>
</body>
<script type="text/javascript">
function fnResadeHeight(obj) {
	if ($(obj).attr('id') == 'autoApplyEdit') {
		$(obj).height(document.body.scrollHeight-$('#tabs_head').height());
	} else {
    	$(obj).height(document.body.scrollHeight-$('#head').height()-$('#tabs_head').height());
	}
}
</script>
</html>