<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n('calendar.event.list.title')}</title>
<style>
.stadic_head_height {
  height: 30px;
}

.stadic_body_top_bottom {
  bottom: 0px;
  top: 30px;
}
</style>
<script type="text/javascript">
  $(function() {
    var curTab = "${curTab}";
    if (curTab == "all") {
      $("#tab1_iframe_a").trigger("click");
    } else if (curTab == "calEventView") {
      $("#tab3_iframe_a").trigger("click");
    } else {
      $("#tab2_iframe_a").trigger("click");
    }
    $("#tabs_head a").click(function() {
      var iframe = $(this).attr("tgt");
      $("#tabs_body iframe").not($("#" + iframe)).attr("src", "");
    })
  });
</script>
</head>
<body class="h100b over_hidden page_color">
  <div class="comp"
    comp="type:'breadcrumb',comptype:'location',code:'F02_eventlist'"></div>
  <div id="center" class="h100b">
    <DIV id=tabs class="comp" comp="type:'tab',parentId:'center',refreashTab:true">
      <DIV id=tabs_head class="common_tabs clearfix margin_t_5">
        <UL class="left">
          <LI class="<c:if test='${curTab=="all"}'>current</c:if>"><A
            hideFocus style="WIDTH: auto" href="javascript:void(0)"
            class=" no_b_border" tgt="tab1_iframe" id="tab1_iframe_a"><SPAN>${ctp:i18n('calendar.event.list.title')}</SPAN></A>
            <LI class="<c:if test='${curTab=="other"}'>current</c:if>"><A
            id="tab2_iframe_a" hideFocus style="WIDTH: auto"
            href="javascript:void(0)" tgt="tab2_iframe" class=" no_b_border"><SPAN>${ctp:i18n('calendar.event.share.title')}</SPAN></A>
          
          <LI class="<c:if test='${curTab=="calEventView"}'>current</c:if>"><A
            hideFocus id="tab3_iframe_a" style="WIDTH: auto"
            href="javascript:void(0)" tgt="tab3_iframe" class=" no_b_border"><SPAN>${ctp:i18n('calendar.event.calendar.view.title')}</SPAN></A>
          
          <LI><A hideFocus style="WIDTH: auto" class="last_tab no_b_border"
            href="javascript:void(0)" tgt="tab4_iframe"><SPAN>${ctp:i18n('calendar.event.Statistics.title')}</SPAN></A>
          </LI>
        </UL>
      </DIV>
      <div class="hr_heng"></div>
      <DIV id="tabs_body" class="common_tabs_body">
              <IFRAME id="tab1_iframe" border=0
                src="${path}/calendar/calEvent.do?method=listCalEvent&curTab=personal"
                hSrc="${path}/calendar/calEvent.do?method=listCalEvent&curTab=personal"
                frameBorder=no class="w100b"></IFRAME>
        <IFRAME id=tab2_iframe class="w100b hidden" border=0
                hSrc="${path}/calendar/calEvent.do?method=listShareAllEvent&curTab=${curTab}"
                frameBorder=no></IFRAME>
        <IFRAME id=tab3_iframe class=hidden border=0
                hSrc="${path}/calendar/calEvent.do?method=calEventView&curTab=${curTab}&curDate=${curDate}"
                frameBorder=no width="100%"></IFRAME>
        <IFRAME id=tab4_iframe class=hidden border=0
                hSrc="${path}/calendar/calEvent.do?method=statisticsCalEvent"
                frameBorder=no width="100%"></IFRAME>
      </DIV>
    </DIV>
  </div>
</body>
</html>

