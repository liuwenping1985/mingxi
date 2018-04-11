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
	jsonGateway : ajaxUrl + "eipPortalColumnDetailManager",
	
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
    var code = "${columnId}";
	var b = true;
	if(code == "pl_news" || code == "pl_bulletin" || code == "pl_launch"){
	    b = false;
	}
    //顶端功能条
    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,       
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            /*栏目名称*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "栏目名称",
            sortable: true,
            name: 'columnId',
            hide: true,
            align: 'center',
            width: '10%'
        },
        {
            /*栏目名称*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "栏目名称",
            sortable: true,
            name: 'columnName',
            align: 'center',
            width: '10%',
		    codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalColumnIndustryEnum'" 
        },
        {
            /*内容标题*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "内容标题",
            sortable: true,
            name: 'columnDetailTitle',
            align: 'center',
            width: '20%',
		    codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnDetailEnum'" 
        },
        {
            /*内容URL*/
            display: "内容URL",
            sortable: true,
            name: 'columnDetailUrl',
            align: 'center',
            width: '30%',
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
        managerName: "eipPortalColumnDetailManager",
        managerMethod: "findPageColumns",
        width: "auto",
        usepager: b,
        parentId: 'center'     
    });
    //加载列表
    var o = new Object();
    o = $.parseJSON("{'columnId':'${columnId}'}");
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
               	objParam = $.parseJSON("{'columnId':'${columnId}','"+ returnValue.condition + "':'" + returnValue.value.escapeJavascript() +"'}");
              }else{
          		objParam = $.parseJSON("{'columnId':'${columnId}'}");
          	  }
          }else{
          		objParam = $.parseJSON("{'columnId':'${columnId}'}");
          }
          $("#mytable").ajaxgridLoad(objParam);
        },
        conditions: [
        {
            /*栏目名称*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            id: 'search_columnDetailTitle',
          	name: 'search_columnDetailTitle',
          	type: 'input',
          	text: "内容标题",
          	value: 'columnDetailTitle'
        }
        ]
        
      });
      //点击事件
    function gridclk(data, r, c) {
        
    }
    
    // 双击修改
    function griddbclick() {
        
    }
    
    function getCount(){
        $("#count")[0].innerHTML = total.format(mytable.p.total);
    }
});

var num = ${num};
function OK() {
	    var roles = new Array();
	    var boxs = $("#mytable input:checked");
	    if (boxs.length < 1) {
	    	$.alert("请选择一条或多条数据！");
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
		    var portalNames = '';
		    var columnDetailUrls = '';
		    var columnDetailTitles = '';
		    for(var i=0; i<v.length ;i++){
		    	ids += v[i].id +',';
		    	portalNames += v[i].portalName +',';
		    	columnDetailUrls += v[i].columnDetailUrl +',';
		    	columnDetailTitles += v[i].columnDetailTitle +',';
		    }
	    	return {"ids":ids,"portalNames":portalNames,"columnDetailUrls":columnDetailUrls,"columnDetailTitles":columnDetailTitles};
	    }else{
	    	return {"id":v[0].id,"columnId":v[0].columnId,"columnName":v[0].columnName,"columnDetailTitle":v[0].columnDetailTitle,"columnDetailUrl":v[0].columnDetailUrl};
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