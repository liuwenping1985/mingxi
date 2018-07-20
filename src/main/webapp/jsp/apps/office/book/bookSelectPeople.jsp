<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/bookPub.js${ctp:resSuffix()}"></script>
<script>
$(function() {
	fninitBookMan();
});

/**
*	点击设置管理员或驾驶员事件
*/
function fninitBookMan(){
	var param = window.parentDialogObj["bookMember"].getTransParams();
	var _type = param.type;
	var value = param.value;
	pTemp.type = _type;  //页面全局变量
	
	if(_type==="BookMember"){ //设置管理员
		pTemp.tab = officeTab().addAll(["id","name"]).init("selectRowTable", {
				argFunc : "initManagerTable",
				parentId: $(".layout_center").eq(0).attr("id"),
	        slideToggleBtn: false,
	        showTableToggleBtn: false,
	        resizable: false,
	        striped:true,
	        usepager: false,
	        width: "auto",
	        managerName: "bookInfoManager",
	        managerMethod: "listBookManager",
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
			display : $.i18n('office.asset.assetSelectManager.pxm.js'),
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
	for(var i=0;i<selectRows.length;i++){
		selectRows[i].memberName = selectRows[i].memberNameShow;
	}
	return selectRows;
}
</script>
</head>
<body class="h100b w100b over_auto">
	<div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_center over_hidden" id="center" layout="border:false" >
            <table id="selectRowTable" class="flexme3" style="display: none,overflow-x:hidden;"></table>
        </div>
    </div>
</body>
</html>