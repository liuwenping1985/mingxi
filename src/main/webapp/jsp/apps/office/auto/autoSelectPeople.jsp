<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆编辑</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script>
$(function() {
	fninitAutoMan();
});

/**
*	点击设置管理员或驾驶员事件
*/
function fninitAutoMan(){
	var param = window.parentDialogObj["manOrdriver"].getTransParams();
	var _type = param.type;
	var value = param.value;
	pTemp.type = _type;  //页面全局变量
	
	if(_type==="manager"){ //设置管理员
		pTemp.tab = officeTab().addAll(["id","name"]).init("selectRowTable", {
				argFunc : "initManagerTable",
				parentId: $(".layout_center").eq(0).attr("id"),
	        slideToggleBtn: false,
	        showTableToggleBtn: false,
	        resizable: false,
	        striped:true,
	        usepager: false,
	        width: "auto",
	        managerName: "autoInfoManager",
	        managerMethod: "listAutoManager",
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
	}else if(_type==="driver"){//设置驾驶员
		pTemp.tab = officeTab().addAll(["id","name"]).init("selectRowTable", {
				argFunc : "initDriverTable",
				parentId: $(".layout_center").eq(0).attr("id"),
	        slideToggleBtn: false,
	        showTableToggleBtn: false,
	        resizable: false,
	        striped:true,
	        usepager: false,
	        width: "auto",
	        managerName: "autoDriverManager",
	        managerMethod: "getAll",
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
	} else if (_type==="driverChecked") {
        pTemp.tab = officeTab().addAll(["id","name"]).init("selectRowTable", {
            argFunc : "initDriverTables",
            parentId: $(".layout_center").eq(0).attr("id"),
        slideToggleBtn: false,
        showTableToggleBtn: false,
        resizable: false,
        striped:true,
        usepager: false,
        width: "auto",
        managerName: "autoDriverManager",
        managerMethod: "getAll",
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
	} else if(_type=="auto"){
	      pTemp.tab = officeTab().addAll(["id","name","autoBrand","autoModel"]).init("selectRowTable", {
              argFunc : "initAutoTable",
              parentId: $(".layout_center").eq(0).attr("id"),
          slideToggleBtn: false,
          showTableToggleBtn: false,
          resizable: false,
          striped:true,
          usepager: false,
          width: "auto",
          managerName: "autoInfoManager",
          managerMethod: "findAllAutoByAccount",
          onSuccess: function() {
              if(typeof(value) != "undefined" && '' != value) {
                  var temRoles = value.split(",");
                  for(i=0;i<temRoles.length;i++) {
                      $("input[value='"+temRoles[i]+"']").attr("checked","checked");
                  }
              }
         }
      });
      pTemp.tab.load();
	} else if (_type=="autoChecked") {
        pTemp.tab = officeTab().addAll(["id","name","autoBrand","autoModel"]).init("selectRowTable", {
            argFunc : "initAutoTables",
            parentId: $(".layout_center").eq(0).attr("id"),
        slideToggleBtn: false,
        showTableToggleBtn: false,
        resizable: false,
        striped:true,
        usepager: false,
        width: "auto",
        managerName: "autoInfoManager",
        managerMethod: "findAllAutoByAccount",
        onSuccess: function() {
            if(typeof(value) != "undefined" && '' != value) {
                var temRoles = value.split(",");
                for(i=0;i<temRoles.length;i++) {
                    $("input[value='"+temRoles[i]+"']").attr("checked","checked");
                }
            }
       }
       });
        var obj = new Object();
        obj.manager = "true";
        pTemp.tab.load(obj);
	} else if(_type == "managerOrDriver") {
        pTemp.tab = officeTab().addAll(["id","name"]).init("selectRowTable", {
            argFunc : "initDriverOrManagerTable",
            parentId: $(".layout_center").eq(0).attr("id"),
            slideToggleBtn: false,
            showTableToggleBtn: false,
            resizable: false,
            striped:true,
            usepager: false,
            width: "auto",
            managerName: "autoDriverManager",
            managerMethod: "getAllDriverAndCarsAdmin",
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
			display : "${ctp:i18n('office.auto.drivername.js')}",
			name : 'name',
			width : '82%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		}
	};
}

function initDriverTable(){
	return {
		"id" : {
			display : 'id',
			name : 'id',
			width : '15%',
			sortable : false,
			align : 'center',
			type : 'radio',
			isToggleHideShow : true
		},
		"name" : {
			display : "${ctp:i18n('office.auto.drivername.js')}",
			name : 'memberNameShow',
			width : '82%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		}
	};
}

function initDriverTables(){
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
            name : 'memberNameShow',
            width : '84%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        }
    };
}

function initAutoTable(){
    return {
        "id" : {
            display : 'id',
            name : 'id',
            width : '13%',
            sortable : false,
            align : 'center',
            type : 'radio',
            isToggleHideShow : true
        },
        "name" : {
            display : "${ctp:i18n('office.auto.autoStcInfo.cph.js')}",
            name : 'autoNum',
            width : '30%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "autoBrand" : {
            display : "${ctp:i18n('office.asset.apply.assetBrand.js')}",
            name : 'autoBrand',
            width : '30%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "autoModel" : {
            display : "${ctp:i18n('office.auto.model.js')}",
            name : 'autoModel',
            width : '24%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        }
    };
}


function initAutoTables(){
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
            display : "${ctp:i18n('office.auto.autoStcInfo.cph.js')}",
            name : 'autoNum',
            width : '30%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "autoBrand" : {
            display : "${ctp:i18n('office.asset.apply.assetBrand.js')}",
            name : 'autoBrand',
            width : '30%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "autoModel" : {
            display : "${ctp:i18n('office.auto.model.js')}",
            name : 'autoModel',
            width : '24%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        }
    };
}

function initDriverOrManagerTable(){
    return {
        "id" : {
            display : 'id',
            name : 'id',
            width : '15%',
            sortable : false,
            align : 'center',
            type : 'radio',
            isToggleHideShow : true
        },
        "name" : {
            display : "${ctp:i18n('office.auto.drivername.js')}",
            name : 'name',
            width : '82%',
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
<body class="h100b w100b over_auto" >
	<div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_center over_hidden" id="center" layout="border:false" >
            <table id="selectRowTable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>