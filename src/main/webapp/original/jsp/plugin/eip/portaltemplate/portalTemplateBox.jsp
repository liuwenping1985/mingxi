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
	jsonGateway : ajaxUrl + "eipPortalTemplateManager",
	
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
var mManager = null;
$().ready(function() {
    //var total = '${ctp:i18n("info.totally")}';
    mManager=new ColumnManager(); 
    //表单id
    
    //新建
    
    //顶端功能条
    
    var mytable = $("#mytable").ajaxgrid({
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
            /*模板编号*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "模板编号",
            sortable: true,
            name: 'templateCode',
            width: '10%'
        },
        {
            /*模板名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "模板名称",
            sortable: true,
            name: 'templateName',
            width: '10%'
        },
        {
            /*行业分类 枚举值*/
            display: "行业分类",
            sortable: true,
            name: 'industrySort',
            width: '10%',
			align : 'center',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalTemplateIndustryEnum'"
        },
        {
            /*模板布局样式*/
            display: "模板布局样式",
            sortable: true,
            name: 'templateLayout',
            width: '10%'          
        },
        	/*模板样式 */
        {
            display: "模板样式 ",
            sortable: true,
            name: 'templateCss',
            width: '10%'          
        },
        {
        	/*模板图标*/
            display: "模板图标",
            sortable: true,
            name: 'templateIco',
            width: '10%'          
        }/* ,
        {
        	//模板栏目id值，多值已逗号分隔存储
            display: "模板栏目",
            sortable: true,
            name: 'columnIds',
            width: '10%'          
        } */,
        {
        	/*模板栏目id值，多值已逗号分隔存储*/
            display: "模板栏目",
            sortable: true,
            name: 'columnCodes',
            width: '10%'          
        },
        {
        	/*是否启用*/
            display: "状态",
            sortable: true,
            name: 'isEnable',
            width: '10%',
            align : 'center',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnTypeEnum'"     
        },
        {
        	/*备注*/
            display: "备注",
            sortable: true,
            name: 'backUpValue',
            width: '10%'          
        }
        ],
        managerName: "eipPortalTemplateManager",
        managerMethod: "findPageColumns",
        width: "auto",
        usepager:"true",
        parentId: 'center'      
    });
    //加载列表
    var o = new Object();
    o = $.parseJSON("{'isEnable':'${isEnable}'}");
    $("#mytable").ajaxgridLoad(o);
    //mytable.grid.resizeGridUpDown('middle');
    var searchobj = $.searchCondition({
        top: 0,
        right: 10,
        searchHandler: function() {
          var returnValue = searchobj.g.getReturnValue();
          var objParam = new Object();
          objParam = $.parseJSON("{'isEnable':'${isEnable}'}");
          if(returnValue != null && returnValue.value!="") {
              if (returnValue.condition.length > 0) {
               	objParam = $.parseJSON("{'"+ returnValue.condition + "':'" + returnValue.value.escapeJavascript() +"','isEnable':'${isEnable}'}");
              }
          }
		  $("#mytable").ajaxgridLoad(objParam);
        },
        conditions: [{
        	/*模板名称*/
          id: 'search_templateName',
          name: 'search_templateName',
          type: 'input',
          text: "模板名称",
          value: 'templateName'
        },{
        	/*模板编号*/
          id: 'search_templateCode',
          name: 'search_templateCode',
          type: 'input',
          text: "模板编号",
          value: 'templateCode'
        },{
        	/*行业分类 枚举值*/
          id: 'search_industrySort',
          name: 'search_industrySort',
          type: 'select',
          text: "行业分类",
          value: 'industrySort',
          codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalTemplateIndustryEnum'"
        }/** ,{
        	//是否启用
          id: 'search_isEnable',
          name: 'search_isEnable',
          type: 'select',
          text: "状态",
          value: 'isEnable',
          codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnTypeEnum'"
        } */]
        
      });
      //点击事件
    function gridclk(data, r, c) {
        
    }
    
    // 双击修改
    function griddbclick() {
        
    }
    
    // 初始化行数据
    function onSuccess() {
		var columnId = '${ids}';
		initOnSuccess(columnId);
	}
});
	function initOnSuccess(columnId){
	    if(!columnId || columnId == ''){
	    	return;
	    }
		var ids = columnId.split(",");
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
function OK() {
	    var roles = new Array();
	    var boxs = $("#mytable input:checked");
	    if (boxs.length != 1) {
	    	$.alert("请选择一条数据！");
	    	return false;
	    }
	    var v = $("#mytable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    /* var ids = '';
	    var portalNames = ''
	    for(var i=0; i<v.length ;i++){
	    	ids += v[i].id +',';
	    	portalNames += v[i].portalName +',';
	    } */
	    return {"id":v[0].id,"templateCode":v[0].templateCode};
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv"></div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="mytable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>