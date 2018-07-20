<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

<script type="text/javascript">
  $().ready(function() {
      $('#tab1').click(function() {
          $('#tab_iframe').attr("src", "${path}/doc/knowledgeController.do?method=showKnowledgeIntegrationSetting");
          });
      $('#tab2').click(function() {
          $('#tab_iframe').attr("src", "${path}/doc/knowledgeController.do?method=toSetIntegralDaren");
          });    
    
  });
</script>


</head>
<body class="page_color over_hidden h100b" >
    <div id="tabs" class="comp" comp="type:'tab'">
        <div id="tabs_head" class="common_tabs clearfix margin_5">
            <ul class="left">
                <li id="tab1" class="current"><a class="border_b" hideFocus="true" href="javascript:void(0)" tgt="tab_iframe">${ctp:i18n('doc.title.integral.setting')}</a></li>
                <li id="tab2"><a hideFocus="true" class="border_b last_tab" class="last_tab" href="javascript:void(0)" tgt="tab_iframe" >${ctp:i18n('doc.title.knowledge.favorite')}</a></li>
            </ul>
        </div>
        <div id="tabs_body" class="common_tabs_body">
            <iframe id="tab_iframe" border="0" src="${path}/doc/knowledgeController.do?method=showKnowledgeIntegrationSetting" frameBorder="no" width="100%" style="overflow: hidden;"></iframe>
        </div>
    </div>
</body>
</html>