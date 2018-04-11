<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
var ss=null;
    $(document).ready(function() {
        ss = $("#flexme3").ajaxgrid({
            managerName : 'knowledgeManager',
            managerMethod : 'getAllDarenLevels',
            click : cellAction,
            dblclick : cellActionDB,
            isHaveIframe : true,
            colModel : [{
                display : "${ctp:i18n('doc.daren.level')}",
                name : 'integralLevel',
                width : '15%',
                sortable : true,
                align : 'left'
            }, {
                display : "${ctp:i18n('doc.daren.medal')}",
                name : 'medal',
                width : '20%',
                sortable : true,
                align : 'left'
            }, {
                display : "${ctp:i18n('doc.daren.medal.image')}",
                name : 'medalIcon',
                width : '10%',
                sortable : true,
                hide : true,
                align : 'left'
            }, {
                display : "${ctp:i18n('doc.daren.integral')}",
                name : 'integratingRange',
                width : '20%',
                sortable : false,
                align : 'left'
            }, {
                display : "${ctp:i18n('doc.explain')}",
                name : 'description',
                width : '45%',
                align : 'left'
            } ],
            usepager : false,
            sortname : "id",
            sortorder : "asc",
            showTableToggleBtn : false,
            parentId : $('.layout_center').eq(0).attr('id'),
            vChange : true,
            vChangeParam : {
                overflow : "hidden",
                autoResize : true
            },
            slideToggleBtn : true
        });
        var o = new Object();
        $("#flexme3").ajaxgridLoad(o);
        function cellAction(row, rowIndex, colIndex) {
            $("#detailIframe")[0].contentWindow.check("disable",getSelectRow(row,rowIndex));
        }
        function cellActionDB(row, rowIndex, colIndex){
        	$("#detailIframe")[0].contentWindow.check("disable",getSelectRow(row,rowIndex));
            $("#detailIframe")[0].contentWindow.check("modify",getSelectRow(row,rowIndex));
        }
        
        function getSelectRow(row, rowIndex){
        	var rows = ss.p.datas.rows;
        	var nextIndex = rowIndex+1,preIndex= rowIndex-1;
        	if(nextIndex > 9){
        		nextIndex=9;
        	}
        	
        	if(preIndex<0){
        		preIndex=0;
        	}
        	return {isFrist:(rowIndex == 0),isEnd:(rowIndex == 9),nextRow:rows[nextIndex],selectRow:row,preRow:rows[preIndex]}
        }
    });
</script>
</head>
    <body>
		<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_KnowledgeIntegralDaren'"></div>
        <div id='layout' class="comp page_color" comp="type:'layout'">
            <div class="layout_north" layout="height:7,sprit:false,border:false">
            </div>
            <div class="layout_center page_color over_hidden" layout="border:false">
                <table id="flexme3" class="flexme3" style="display: none;">
                </table>
				<div id="grid_detail">
	                <iframe src="/seeyon/doc/knowledgeController.do?method=toDetailIntegralDaren" id="detailIframe" width="100%" height="100%" frameborder="0"></iframe>
				</div>
            </div>
        </div>
    </body>
</html>