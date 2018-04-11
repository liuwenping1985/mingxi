<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%-- 查看页面 --%>
<title>查看页面</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=magazineListManager"></script>
<script>var listType = "${listType}";</script>
<style>
table{ border-collapse:collapse; width:90%; border:1px blue solid}
td{ border:1px solid #cccccc;}
</style>
</head>
<body>
<div id='layout'>
     ${infoStatView}
</div>
</body>

<script type="text/javascript">
function showScore(ids, index,varType) {
	 var id=$("#"+ids).val();
	 if(varType == 'manual') {
		 var title = $.i18n('infosend.listInfo.sendCount');//发布次数
		 var url = _ctxPath+"/info/publishscore.do?method=listInfoPublishScoreRecordManual&openScoreView=statManualView&infoIds="+id;
		 openInfoDialog(url, title);
	 } else {
		 var title = $.i18n('infosend.listInfo.sendCount');//发布次数
		 var url = _ctxPath+"/info/publishscore.do?method=listInfoPublishScoreRecord&listType=listInfoPublishScoreRecord&openScoreView=statAuto&infoIds="+id;
		 openInfoDialog(url, title);
	 }
}
</script>
</html>
