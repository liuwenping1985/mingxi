<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<script type="text/javascript"
		src="/seeyon/ajax.do?managerName=roleManager,orgManager,accountCfgManager"></script>
<script type="text/javascript">
/**
 * 根据字段id，获取字段信息并填充到字段内容区域 //TODO
 * 
 * @param columnId 字段Id
 */
 //定义manager
var ColumnManager = RJS.extend({
	jsonGateway : ajaxUrl + "eipUserCustomManager",
	
	findByNumberIdAndColumnCode : function() {
		return this.c(arguments, "findByNumberIdAndColumnCode");
	},
	updateCustomColumn : function() {
		return this.c(arguments, "updateCustomColumn");
	},
	getColumnLists : function() {
		return this.c(arguments, "getColumnLists");
	},
	getColumnToJSON : function() {
		return this.c(arguments, "getColumnToJSON");
	},
	getColumnById : function() {
		return this.c(arguments, "getColumnById");
	}
});
var portalCode = "${portalCode}";
var mManager = null;
var mytable = null;
var selectData = "";
$().ready(function() {
    //var total = '${ctp:i18n("info.totally")}';
    mManager=new ColumnManager(); 
    //表单id
    
    //新建
    
    //顶端功能条
    $("#toolbar").toolbar({
        toolbar: [
        {
			id : "upData",
			name : '向上移动',
			className : "ico16 repeater_plus_16",
			click : function() {
				upData();
			}
		} ,{
			id : "downData",
			name : '向下移动',
			className : "ico16 repeater_reduce_16",
			click : function() {
				downData();
			}
		}/* ,{
			id : "search",
			name : '选择分类',
			className : "ico16 authorize_16",
			click : function() {
				searchclick();
			}
		} */]
    });
   mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,
        onSuccess : onSuccess,      
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            /*栏目id*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "栏目名称",
            sortable: true,
            name: 'columnCode',
            hide: true,
            width: '25%',
            align : 'center',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalUserColumnIndustryEnum'" 
        },
        {
            /*栏目名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "栏目显示名称",
            sortable: true,
            name: 'columnName',
            align: 'center',
            width: '25%' ,
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalUserColumnIndustryEnum'" 
        },
        {
            /*应用名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "应用名称",
            sortable: true,
            name: 'appSystemName',
            align: 'center',
            width: '25%'
        },
        {
            /*序号*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "序号",
            sortable: true,
            name: 'appSystemCode',
            align: 'center',
            width: '20%'
        }
        ],
        managerName: "eipUserCustomManager",
        managerMethod: "findAppPageByNumberIdAndColumnCode",
        width: "auto",
        usepager:"true",
        parentId: 'center',
        onCurrentPageSort : true,
        usepager : false    
    });
    //加载列表
    var o = new Object();
    o = $.parseJSON("{'portalCode':'${portalCode}','columnCode':'pl_appsystem','templateCode':'${templateCode}'}");
    $("#mytable").ajaxgridLoad(o);
    //mytable.grid.resizeGridUpDown('middle');
    var searchobj = $.searchCondition({
        top: 7,
        right: 10,
        searchHandler: function() {
          var returnValue = searchobj.g.getReturnValue();
          var objParam = new Object();
          if(returnValue != null && returnValue.value!="") {
              if (returnValue.condition.length > 0) {
               	objParam = $.parseJSON("{'portalCode':'${portalCode}','"+ returnValue.condition + "':'" + returnValue.value.escapeJavascript() +"','templateCode':'${templateCode}'}");
              }else{
              	objParam = $.parseJSON("{'portalCode':'${portalCode}','columnCode':'pl_appsystem','templateCode':'${templateCode}'}");
              }
          }
          $("#mytable").ajaxgridLoad(objParam);
        },
        conditions: [{
        	/*模板名称*/
          id: 'search_columnCode',
          name: 'search_columnCode',
          type: 'select',
          text: "栏目名称",
          value: 'columnCode',
          codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalUserColumnIndustryEnum'"
        }]
        
      });
      searchobj.g.setCondition("search_columnCode","pl_appsystem");
      //点击事件
    function gridclk(data, r, c) {
        
    }
    
    // 双击修改
    function griddbclick() {
        
    }
    // 初始化行数据
    function onSuccess() {
		//mytable.selectData = selectData;
		var ids = selectData.split(",");
		var v = $("#mytable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0];
	      	}
	    });
		for(i=0;i<ids.length;i++){
			for(j=0;j<v.length;j++){
				var d = v[j];
				if(d.id == ids[i]){
					$("#mytable input[value='"+d.id+"']").attr("checked",'true');
					break;
				}
			}
		}
	}
    // 向上移动
    function upData() {
        //向上事件
        var roles = new Array();
	    var boxs = $("#mytable input:checked");
	    if (boxs.length < 1) {
	    	$.alert("请选择数据！");
	    	return false;
	    }
	    var v = $("#mytable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    var ids = '';
	    for(var i=0; i<v.length ;i++){
	    	ids += v[i].id +',';
	    }
	    
		var sort = v[0].columnCode;
				/* var confirm = $.confirm({
		            'msg' : '向上移动！',
		            ok_fn : function() {
		            	
		            },
		            cancel_fn : function() {
		            }
		        }); */
						var returnValue = searchobj.g.getReturnValue();
		            	if(returnValue != null && returnValue.value!="") {
				            if(returnValue.condition.length > 0) {
				               	var columnManager = new ColumnManager();
				            	var objParam = $.parseJSON("{'portalCode':'${portalCode}','templateCode':'${templateCode}','columnCode':'"+returnValue.value.escapeJavascript()+"','ids':'"+ids+"','type':'-1'}");
				            	var b = columnManager.updateCustomColumn(objParam);
				            	if(b){
				            		$("#mytable").ajaxgridLoad();
				                	selectData = ids;
				            	}else{
				            		$.error("向上移动失败！");
				            	}
				            	/* columnManager.updateCustomColumn(-1,returnValue.value.escapeJavascript(),"${portalCode}",ids, {
				                    success : function() {
				                    	$("#mytable").ajaxgridLoad();
				                		mytable.selectData = ids;
				                    },
				                    error : function(request, settings, e) {
				                        $.error("向上移动失败！");
				                    }
				                }); */
				          	}
		                }
    }
    // 向下移动
    function downData() {
    	var roles = new Array();
	    var boxs = $("#mytable input:checked");
	    if (boxs.length < 1) {
	    	$.alert("请选择数据！");
	    	return false;
	    }
	    var v = $("#mytable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    var ids = '';
	    for(var i=0; i<v.length ;i++){
	    	ids += v[i].id +',';
	    }
	    
		var sort = v[0].columnCode;
				/* var confirm = $.confirm({
		            'msg' : '向上移动！',
		            ok_fn : function() {
		            },
		            cancel_fn : function() {
		            }
		        }); */
		            	var returnValue = searchobj.g.getReturnValue();
		            	if(returnValue != null && returnValue.value!="") {
				            if(returnValue.condition.length > 0) {
				               	var columnManager = new ColumnManager();
				            	var objParam = $.parseJSON("{'portalCode':'${portalCode}','templateCode':'${templateCode}','columnCode':'"+returnValue.value.escapeJavascript()+"','ids':'"+ids+"','type':'1'}");
				            	var b = columnManager.updateCustomColumn(objParam);
				            	if(b){
				            		$("#mytable").ajaxgridLoad();
				                	selectData = ids;
				            	}else{
				            		$.error("向上移动失败！");
				            	}
				            	/* columnManager.updateCustomColumn(-1,returnValue.value.escapeJavascript(),"${portalCode}",ids, {
				                    success : function() {
				                    	$("#mytable").ajaxgridLoad();
				                		mytable.selectData = ids;
				                    },
				                    error : function(request, settings, e) {
				                        $.error("向上移动失败！");
				                    }
				                }); */
				          	}
		                }
        
    }
    // 选择分类
    function searchclick() {
        
    }
    
});

</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
    	<div class="layout_north" layout="height:40,sprit:false,border:false">        
	        <div id="toolbar"></div>
	    </div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="mytable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>