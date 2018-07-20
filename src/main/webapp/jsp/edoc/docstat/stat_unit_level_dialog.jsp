<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style type="text/css">
    .stadic_body_top_bottom{
        bottom:140px;
        top:0px;
    }
    
    /**v5.1标准弹出框内容边距为上右下左:16px 26px 16px 26px**/
    .DIALOG_CONTENT_MARGIN {
    	margin-top: 16px;
    	margin-button: 16px;
    }
</style>
<script type="text/javascript">

$(document).ready(function () {
	loadStyle();
    loadData();
    setGridWidthAndHeight();
    setTimeout(loadSelected,500); 
});

function loadStyle() {
	//初始化布局
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 0,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
}

//加载页面数据
var grid;
function loadData() {
   //表格加载
    grid = $('#unitLevelEnumItemList').ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'value',
            label: 'label',
            width: '15%',
            type: 'checkbox',
            isToggleHideShow:false
        }, {
            display: "名称",
            name: 'label',
            sortable : true,
            width: '82%'
        }],
        usepager : false,
        managerName : "edocStatNewManager",
        managerMethod : "getEdocEnumitemList"
    });
   var obj = new Object();
   obj.fieldName = "unit_level";
    $("#unitLevelEnumItemList").ajaxgridLoad(obj);
}

function loadSelected() {
	var enumitemIds = "${ctp:escapeJavascript(param.enumitemIds)}";
	if(enumitemIds != "") {
		var enumitemIdArray = enumitemIds.split(",");
		$(grid).find("input[type='checkbox']").each(function(i) {
			for(var j=0;j<enumitemIdArray.length;j++) {
				if($(this).context.value == enumitemIdArray[j]) {
					$(this).context.checked = true;
				}	
			}	
		});
	}
}

function setGridWidthAndHeight() {
    $(".flexigrid").css("height", "100%");
    $(".flexigrid").css("width", "100%");
    $(".bDiv").css("height", $(".flexigrid").height()-$(".pDiv").height()-$(".hDiv").height()-5);
 }

function OK() {
	var object = new Object();
	var id_checkbox = grid.grid.getSelectRows();
	var enumitemLabels = "";
	var enumitemIds = "";
	for(var i=0; i<id_checkbox.length; i++) {
		enumitemIds += id_checkbox[i].value+",";
		enumitemLabels += id_checkbox[i].label+"、";
	}
	if(enumitemIds != "") {
		enumitemIds = enumitemIds.substring(0, enumitemIds.length-1);
	}
	if(enumitemLabels != "") {
		enumitemLabels = enumitemLabels.substring(0, enumitemLabels.length-1);
	}
	object.enumitemIds = enumitemIds;
	object.enumitemLabels = enumitemLabels;
	return object;
}
</script>
</head>
<body>
<div id='layout'>
	<div class="layout_north bg_color" id="north">
    </div>
       <div class="layout_center over_hidden" id="center">
           <table  class="flexme3" id="unitLevelEnumItemList"></table>
       </div>
</div>
</body>