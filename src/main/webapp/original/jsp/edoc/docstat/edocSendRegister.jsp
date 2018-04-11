<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<title>${ctp:i18n('edoc.send.register')}<%-- 发文登记簿 --%></title>
<script type="text/javascript">
	var hasSursen="${v3x:hasPlugin('sursenExchange')}";
    var defalutPushName = '${ctp:escapeJavascript(defalutPushName)}';
    var registerName = "${ctp:i18n('edoc.send.register')}";
    var fromListType = "${listType}";
    
    var initCondition = {};
    try{
        initCondition = ${initCondition};//未升级数据可能有问题先括起来
    }catch(e){}
    
    var showColumn = "${showColumn}";
    var dataRight = "${dataRight}";
</script>
<script type="text/javascript" src="${path}/apps_res/edoc/js/docstat/edocRegister.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/edoc/js/docstat/edocSendRegister.js${ctp:resSuffix()}"></script>
</head>
<body>
	<div id='layout' class="comp page_color" comp="type:'layout'">
		<div class="layout_north f0f0f0" layout="height:40,sprit:false,border:false">
			<div class="absolute" id="sendRegist_toolbar"></div>
			<div class="absolute" style="top:7px; right:10px;">
                <a id="combinedQuery" style="margin-right: 5px;" class="font_size14">${ctp:i18n('edoc.label.advanced')}</a>
            </div>
            <div style="clear: both;"></div>
		</div>
		<div class="layout_center page_color over_hidden" id="center" layout="border:false">
			<table id="sendRegisterDataTabel" class="flexme3" style="display: none;">
			</table>
			
			<%-- 动态创建 推送条件或导出Excel的查询条件和查询列，采用jsonform分组提交 --%>
			<div id="dynamicForm" style="display: none;">
			    <div id="columnDomain"></div>
			    <div id="queryDomain"></div>
			</div>
		</div>
	</div>
</body>
</html>