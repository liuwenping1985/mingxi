<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>版式设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/apps_res/info/js/taohong_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=infoFormatManager"></script>
<script type="text/javascript">
var info_manager = new infoFormatManager();

function downloadTemplate(){
	//var name = encodeURI('${fileName}');
	//var downloadUrl =_ctxPath+"/fileDownload.do?method=download&fileId=${fileId}&v=${ctp:digest_1(fileId)}&createDate=${createDate}&filename="+ name;
	var name = encodeURI('期刊版式制作指南.doc');
	var downloadUrl =_ctxPath+"/fileDownload.do?method=doDownload&fileId=${fileId}&v=${ctp:digest_1(fileId)}&createDate=${createDate}&isInfoTemplate=true&tempType=0&filename="+ name;
	$("#myForm").attr("action",downloadUrl);
	$("#myForm").attr("target","temp_frame");
	$("#myForm").submit();
	$("#myForm").attr("action","");
}

</script>
</head>
<body>
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div id="toolbars"> </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table class="flexme3" id="listTaohong"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" name='summaryF' width="100%" height="100%" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
    <form id="myForm" method="post"></form>
    <iframe id="temp_frame" name="temp_frame"></iframe>
</body>
</html>
