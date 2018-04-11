<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<title>导入Excel</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=neigouCorpinforManager"></script>
<script type="text/javascript" language="javascript">

$().ready(function() {
	var manager = new neigouCorpinforManager();
    //列表
    var grid = $("#importLogTable").ajaxgrid({
        colModel: [
        {
            display : "${ctp:i18n('voucher.plugin.cfg.subject.excel.log.data')}",
            name : 'data',
            width : '20%'
        },
        {
            display : "${ctp:i18n('voucher.plugin.cfg.subject.excel.log.result')}",
            name : 'result',
            width : '15%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.neigou.util.NeigouResult',query:'true'"
        },
        {
            display : "${ctp:i18n('voucher.plugin.cfg.subject.excel.log.explanation')}",
            name : 'desc',
            width : '60%',
        }],
        width: "auto",
        managerName: "neigouCorpinforManager",
        managerMethod: "showImportLogList",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    o1.fileId = $("#fileId").val();
    $("#importLogTable").ajaxgridLoad(o1);
    
    $(window).bind('beforeunload',function(){
    	manager.deleteTempLogFile($("#fileId").val());
    });

});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
	 	return $("#fileId").val();
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv">
	        	<input type="hidden" id="fileId" name="fileId" value="${ctp:toHTML(param.data)}">
	        </div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="importLogTable" class="flexme3" style="display: none">
            </table>
        </div>
    </div>
</body>
</html>