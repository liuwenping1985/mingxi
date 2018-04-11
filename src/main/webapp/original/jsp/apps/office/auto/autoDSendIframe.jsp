<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.auto.use.dosend.bill.js')}</title>
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
    // var applyId = getMultyWindowId("applyId",url);
    var method=getMultyWindowId("method",url);  
    var obj = null;
    if(method=="autoRecedeEdit"){//还车单
      obj=document.getElementById("autoRecede").contentWindow;
    }
    if(method=="autoDSendEdit"){//派车单
      obj=document.getElementById("autoDSendEdit").contentWindow;
    }
    var items = obj.document.getElementsByTagName("input");
    for(var i = 0;i<items.length;i++){
      var targetObj =items[i];
      var targetValue = $(targetObj).val();
      $(targetObj).attr('value',targetValue);
    }
    var textareas = obj.document.getElementsByTagName("textarea");
    for(var i = 0;i<textareas.length;i++){
      var targetObj =textareas[i];
      var targetValue = $(targetObj).val();
      $(targetObj).html(targetValue);
    }
    var applyDepartType = obj.$("select option:selected").html();//用车范围
    obj.$("td:has(#applyDepartType)").attr("id","tempSelect").html("<DIV id='applyDepartTypeDiv' class='common_txtbox_wrap'><input disabled='disabled' class='validate font_size12 w100b' id='applyDep' type='text' maxLength='80' value='"+applyDepartType+"' validate='type:'string',name:'"+$.i18n('office.autoapply.startplace.js')+"'' _da='true'></div>");
    var formDivHtml = null;
    if(method=="autoRecedeEdit"){//还车单
      formDivHtml = "<div style='width:1000px;height: 600px;' align='center'>"+ obj.$('.stadic_layout_body').find('.calendar_icon_area ').hide().end().html()+"</div>";
    }else{//派车单
      formDivHtml = "<div style='width:1000px;height: 600px;' align='center'>"+ obj.$('.stadic_layout').find('.calendar_icon_area ').hide().end().html()+"</div>";
    }
    // var bodyContent ="<iframe id='autoApplyEdit' border='0' src='${path}/office/autoUse.do?method="+method+"&applyId="+applyId+"' frameBorder='0' style='height:600px;' height='100%' width='100%'></iframe>"
    
    // var printFrame = new PrintFragment("", bodyContent);
    var printFrame = new PrintFragment("", "<style type='text/css'>.stadic_layout_body{position:static} .common_txtbox_wrap span{width:98%;height:20px;}</style><div style='height: 600px;' align='center'>"+ formDivHtml+"</div>");
    var mainList = new ArrayList();
    mainList.add(printFrame);
    var cssList = new ArrayList();
    printList(mainList, cssList, "true");
    obj.$('#tempSelect').html("<select disabled='disabled' class='w100b font_size12' id='applyDepartType' _da='true'><option value='0' selected = 'selected'>"+applyDepartType+"</option></select>");
  }
</script>
<style type="text/css">
  #toolbar .common_toolbar_box {
    background: none;
  }
</style>
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