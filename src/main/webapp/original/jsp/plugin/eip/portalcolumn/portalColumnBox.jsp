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
	jsonGateway : ajaxUrl + "eipPortalColumnManager",
	updateColumn : function() {
		return this.c(arguments, "saveOrUpdateColumn");
	},
	createColumn : function() {
		return this.c(arguments, "createColumn");
	},
	deleteColumn : function() {
		return this.c(arguments, "deleteColumn");
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
var mManager = null;
$().ready(function() {
    var total = '${ctp:i18n("info.totally")}';
    mManager=new ColumnManager(); 
    //表单id;
    //初始禁止填写项
    
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
            /*企业门户*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "企业门户",
            sortable: true,
            name: 'portalName',
            align: 'center',
            width: '20%',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnablePortalTypeEnum'" 
        },
        {
            /*栏目名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "栏目名称",
            sortable: true,
            name: 'columnName',
            align: 'center',
            width: '15%',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalColumnIndustryEnum'" 
        },
        {
            /*栏目编码*/
            display: "栏目编码",
            sortable: true,
            name: 'columnCode',
            align: 'center',
            width: '15%',
        },
        {
            /*栏目标题*/
            display: "栏目标题",
            sortable: true,
            name: 'columnTitle',
            align: 'center',
            width: '15%',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalColumnIndustryEnum'"        
        },
        {
            /*图片规格*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "图片规格",
            sortable: true,
            name: 'systemImgSpec',
            align: 'center',
            width: '5%'
        },
        	/*更多设置 */
        {
            display: "更多设置 ",
            sortable: true,
            name: 'moreSetup',
            align: 'center',
            width: '25%'          
        }
        ],
        managerName: "eipPortalColumnManager",
        managerMethod: "findPageColumns",
        width: "auto",
        usepager:"true",
        parentId: 'center'     
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    //mytable.grid.resizeGridUpDown('middle');
    var searchobj = $.searchCondition({
        top: 0,
        right: 10,
        searchHandler: function() {
          var returnValue = searchobj.g.getReturnValue();
          var objParam = new Object();
          if(returnValue != null && returnValue.value!="") {
              if (returnValue.condition.length > 0) {
               	objParam = $.parseJSON("{'"+ returnValue.condition + "':'" + returnValue.value.escapeJavascript() +"'}");
              }
          }
          $("#mytable").ajaxgridLoad(objParam);
        },
        conditions: [{
        	/*企业门户*/
          id: 'search_portalName',
          name: 'search_portalName',
          type: 'select',
          text: "企业门户",
          value: 'portalName',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnablePortalTypeEnum'" 
        },{
        	/*栏目名称*/
          id: 'search_columnName',
          name: 'search_columnName',
          type: 'select',
          text: "栏目名称",
          value: 'columnName',
		  codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalColumnIndustryEnum'" 
        },{
        	/*栏目编码*/
          id: 'search_columnCode',
          name: 'search_columnCode',
          type: 'input',
          text: "栏目编码",
          value: 'columnCode',
        },{
        	/*栏目标题*/
          id: 'search_columnTitle',
          name: 'search_columnTitle',
          type: 'input',
          text: "栏目标题",
          value: 'columnTitle',
        }]
        
      });
      //点击事件
    function gridclk(data, r, c) {
        
    }
    
    // 双击修改
    function griddbclick() {
        
    }
    
    // 初始化行数据
    function onSuccess() {
		var columnId = '${columnCodes}';
		initOnSuccess(columnId);
	}
    function getCount(){
        $("#count")[0].innerHTML = total.format(mytable.p.total);
    }
});
	function initOnSuccess(columnId){
		var ids = columnId.split(",");
		var v = $("#mytable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0];
	      	}
	    });
		for(i=0;i<ids.length;i++){
			for(j=0;j<v.length;j++){
				var d = v[j];
				if(d.columnCode == ids[i]){
					if((num && num>0)){
						var templateCode= d.columnCode;
						if(templateCode && templateCode!='' &&( templateCode.indexOf("pl_login")>-1 
					        	|| templateCode.indexOf("pl_bulletin")>-1 || templateCode.indexOf("pl_news")>-1)){
							$("#mytable input[value='"+d.id+"']").attr("disabled", 'true');
							$("#mytable input[value='"+d.id+"']").css("display", 'none');
							$("#mytable input[value='"+d.id+"']").after("<input type=\"checkbox\" class=\"noClick\" checked=\"checked\" disabled=\"true\">");
					    }
					}
					$("#mytable input[value='"+d.id+"']").attr("checked",'true');
					break;
				}
			}
		}
	}
var num = ${num};
function OK() {
	    var roles = new Array();
	    if(num && num>0){
		    initOnSuccess('pl_bulletin,pl_login,pl_news');
	    }
	    var boxs = $("#mytable input:checked");
	    if (boxs.length < 1) {
	    	$.alert("请至少选择一条数据！");
	    	return false;
	    }
	    if(!(num && num>0) && boxs.length > 1){
	    	$.alert("请选择一条数据！");
	    	return false;
	    }
	    var v = $("#mytable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    if(num && num>0){
	    	var ids = '';
		    var columnNames = '';
		    var columnCodes = '';
		    for(var i=0; i<v.length ;i++){
		    	ids += v[i].id +',';
		    	columnNames += v[i].columnName +',';
		    	columnCodes += v[i].columnCode +',';
		    }
	    	return {"ids":ids,"columnNames":columnNames,"columnCodes":columnCodes};
	    }else{
	    	return {"id":v[0].id,"columnName":v[0].columnName,"columnCode":v[0].columnCode,"systemImgSpec":v[0].systemImgSpec};
	    }
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