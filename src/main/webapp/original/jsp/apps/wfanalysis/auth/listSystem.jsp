<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<title>${ctp:i18n('wfanalysis.auth.type.system')}</title>
</head>
<body style="height: 100%; overflow: hidden; padding: 0px; margin: 0px; border: 0px; cursor: default;">
	<div id="layout" class="comp page_color" comp="type:'layout'" >
		<div class="layout_center page_color over_hidden" id="center">
			<%--系统授权的内容 --%>
           <table id="systemAuth" class="flexme3" style="display: none"></table>
        </div>
	</div>
	<script type="text/javascript">
		$(function(){
			$("#systemAuth").ajaxgrid({
			      colModel : [{
                    display : 'authId',
                    name : 'authId',
                    width : '5%',
                    align : 'center',
                    type : 'checkbox'
                  },{
			        display : "${ctp:i18n('wfanalysis.auth.system.orgentName')}",
			        name : 'orgentName',
			        width : '35%'
			      },{
			    	display : "${ctp:i18n('wfanalysis.auth.system.templates')}",
				    name : 'templateNames',
				    width : '60%'
			      }],
			      managerName : "wfAnalysisAuthManager",
			      managerMethod : "findWfSystemAuths",
			      parentId: $('.layout_center').eq(0).attr('id')
			    });
			$("#systemAuth").ajaxgridLoad();
		});
	</script>
</body>
</html>
