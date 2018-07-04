<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<title>${ctp:i18n('wfanalysis.auth.index.title') }</title>
</head>
<body class="h100b over_hidden page_color">
	<%-- 面包屑导航 --%>
	<div class="comp"
			comp="type:'breadcrumb',comptype:'location',code:'F08_performanceReport'"></div>
	<div id="center" class="h100b">
    	<div id=tabs class="comp" comp="type:'tab',parentId:'center',refreashTab:true">
      		<div id=tabs_head class="common_tabs clearfix margin_t_5">
		        <ul class="left">
		          <li class="current"><A hideFocus style="WIDTH: auto" href="javascript:void(0)"
		            class=" no_b_border" tgt="tab1_iframe" id="tab1_iframe_a"><SPAN>${ctp:i18n('wfanalysis.auth.type.user')}</SPAN></A>
		          <li><A id="tab2_iframe_a" hideFocus style="WIDTH: auto"
		            href="javascript:void(0)" tgt="tab2_iframe" class=" no_b_border"><SPAN>${ctp:i18n('wfanalysis.auth.type.system')}</SPAN></A>
		        </ul>
      	</div>
      	<div id="tabs_body" class="common_tabs_body">
      		<IFRAME id="tab1_iframe" border=0
                src="${path}/wfanalysisAuth.do?method=listUser"
                hSrc="${path}/wfanalysisAuth.do?method=listUser"
                frameBorder=no class="w100b"></IFRAME>
        	<IFRAME id=tab2_iframe class="w100b hidden" border=0
                hSrc="${path}/wfanalysisAuth.do?method=listSystem"
                frameBorder=no></IFRAME>
      	</div>
    </div>
  </div>
</body>
</html>