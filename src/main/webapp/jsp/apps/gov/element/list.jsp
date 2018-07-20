<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/element_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>信息元素</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=elementManager"></script>
<script type="text/javascript" src="${path}/apps_res/gov/element/js/list.js${ctp:resSuffix()}"></script>
<script>

$(document).ready(function () {
	loadStyle();
	loadToolbar();
	loadCondition();
	loadData();
	loadSummaryDesc();
});

function loadToolbar() {
	//工具栏
    var toolbarArray = new Array();
    toolbarArray.push({id:"create", name:"${ctp:i18n('common.toolbar.update.label')}", className:"ico16 editor_16", click:modifyRow});//修改
    toolbarArray.push({id:"create", name:"${ctp:i18n('common.state.normal.label')}", className:"ico16 enabled_16", click:changeEnable});//启动
    toolbarArray.push({id:"create", name:"${ctp:i18n('common.state.invalidation.label')}", className:"ico16 disabled_16", click:changeDisable});//停用
    toolbarArray.push({id:"create", name:"${ctp:i18n('common.toolbar.exportExcel.label')}", className:"ico16 export_excel_16", click:exportElement });//导出Excel
    $("#toolbars").toolbar({
    	isPager:false,
        toolbar: toolbarArray
    });
}

var grid;
function loadData() {
	//表格加载
    grid = $('#listGrid').ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            type: 'checkbox',
            isToggleHideShow:false
        }, {
            display: "${ctp:i18n('element.column.name')}",//元素名称
            name: 'subject',
            sortable : true,
            width: '35%'
        }, {
            display: "${ctp:i18n('element.column.code')}",//元素代码
            name: 'fieldName',
            sortable : true,
            width: '20%'
        }, {
            display: "${ctp:i18n('element.column.datatype')}",//数据类型
            name: 'dataType',
            sortable : true,
            width: '15%'
        }, {
            display: "${ctp:i18n('element.column.elementtype')}",//元素类型
            name: 'elementType',
            sortable : true,
            width: '15%'
        }, {
            display: "${ctp:i18n('element.column.currentstate')}",//当前状态
            name: 'currentState',
            sortable : true,
            width: '10%'
        }],
        click: clickRow,
        dblclick: modifyRow,
        render : rend,
        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: true,
		vChangeParam: {
            overflow: "hidden",
			autoResize:true
        },
        slideToggleBtn: true,
        managerName : "elementManager",
        managerMethod : "getElementList"
    });
    var o = new Object();
    o.appType = appType;
    $("#listGrid").ajaxgridLoad(o);
    setTimeout(function(){
    	$('#summary').attr("src", _ctxPath+"/element/element.do?method=listDesc"+"&size="+grid.p.total);
    },"300");
}

function loadCondition() {
	//定义搜索条件选项
    var condition = new Array();
    //元素名称
    condition.push({id:'name', name:'name', type:'input', text:"${ctp:i18n('element.column.name')}", value:'name', maxLength:85, validate:false});
  	//当前状态
    condition.push({id: 'status', name:'status', type:'select', text: "${ctp:i18n('element.column.enablestate')}", value:'status',
        items: [{
            text: "${ctp:i18n('common.state.normal.label')}",//启用
            value: '1'
        }, {
            text: "${ctp:i18n('common.state.invalidation.label')}",//停用
            value: '0'
        }]
    });
    //元素代码
    condition.push({id:'fieldName', name:'fieldName', type:'input', text: "${ctp:i18n('element.column.code')}", value:'fieldName', maxLength:85, validate:false});
    
  	//搜索框
    var searchobj = $.searchCondition({
        top:2,
        right:10,
        searchHandler: function(){
            searchFunc();
        },
        conditions:condition
    });
  	
  	//搜索框执行的动作
    function searchFunc(){
        var o = new Object();
        o.appType = appType;
        var choose = $('#'+searchobj.p.id).find("option:selected").val();
        if(choose === 'name'){
            o.name = $('#name').val();
        }else if(choose === 'status'){
            o.status = $('#status').val();
        }else if(choose === 'fieldName'){
            o.fieldName = $('#fieldName').val();
        }
        o.condition = choose;
        var val = searchobj.g.getReturnValue();
        //保存搜索条件
          $("#condition").val(o.condition);
	      $("#name").val(o.name);
	      $("#_status").val(o.status);
	      $("#fieldName").val(o.fieldName);
	     //保存搜索条件
        if(val !== null){
            $("#listGrid").ajaxgridLoad(o);
        }
    }
}

function loadSummaryDesc() {
	 //页面底部说明加载
   // $('#summary').attr("src", _ctxPath+"/gov/govmain.do?method=summaryDesc&listType=listElement&size="+grid.p.total);
}

function exportElement(){
	var condition=$("#condition").val();
    var name= encodeURI($("#name").val());
    var status=$("#_status").val();
    var fieldName=$("#fieldName").val();
	document.getElementById("queryConditionForm").action =  "${elementControllerURL}?method=exportElementToExcel&condition="+condition+"&name="+name+"&fieldName="+fieldName+"&status="+status+"&appType="+appType;
	document.getElementById("queryConditionForm").target = "toExportElementFrame";
	document.getElementById("queryConditionForm").method = "post";
	document.getElementById("queryConditionForm").submit();
}
</script>
</head>
<body>
    <form id="queryConditionForm" action="" method="post">
        <input type="hidden" id="condition" class=""/>
        <input type="hidden" name="name" value="${name}">
        <input type="hidden" id="_status" name="_status" value="${status}">
        <input type="hidden" name="fieldName" value="${templateId}">
    </form>
  
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div id="toolbars"> </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listGrid"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" name='summaryF' width="100%" height="100%" frameborder="0"  class="calendar_show_iframe" style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
    <!-- 用户导出Excel模版，解决OA-56996 -->
    <iframe id="toExportElementFrame" name="toExportElementFrame" width="0" height="0" style="display: none;"></iframe>
</body>
</html>
