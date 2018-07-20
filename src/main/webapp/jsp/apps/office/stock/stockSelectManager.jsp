<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b">
<head>
<style type="text/css">
.stadic_layout_head {
  height: 22px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用品库设置</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/stockPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(function() {
	fninitAutoMan();
});

/**
*	点击设置管理员或驾驶员事件
*/
function fninitAutoMan(){
	var value = window.parentDialogObj["selectManager"].getTransParams();
		pTemp.tab = officeTab().addAll(["id","name"]).init("selectRowTable", {
			argFunc : "initManagerTable",
			parentId: $(".layout_center").eq(0).attr("id"),
	        slideToggleBtn: false,
	        showTableToggleBtn: false,
	        resizable: false,
	        striped:true,
	        usepager: false,
	        width: "auto",
	        managerName: "stockHouseManager",
	        managerMethod: "listStockManager",
	        onSuccess: function() {
	            if(typeof(value) != "undefined" && '' != value) {
	                var temRoles = value.split(",");
	                for(i=0;i<temRoles.length;i++) {
	                    $("input[value='"+temRoles[i]+"']").attr("checked","checked");
	                }
	            }
           }
		});
		var proce = $.progressBar();
		pTemp.tab.load();
		proce.close();
}

function initManagerTable(){
	return {
		"id" : {
			display : 'id',
			name : 'id',
			width : '15%',
			sortable : false,
			align : 'center',
			type : 'checkbox',
			isToggleHideShow : true
		},
		"name" : {
			display : "${ctp:i18n('office.auto.drivername.js')}",
			name : 'name',
			width : '84%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		}
	};
}


function OK(){
	var selectRows = pTemp.tab.selectRows();
	return selectRows;
}
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_center over_hidden" id="center" layout="border:false" >
            <table id="selectRowTable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>