<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=portalConfigManager"></script>
<script type="text/javascript">

//var mManager = null;
$().ready(function() {
    //var total = '${ctp:i18n("info.totally")}';
    //mManager=new ColumnManager(); 
    //表单id
    
    //新建
    
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
            display: "${ctp:i18n('cip.register.appcode')}",
            sortable: true,
            name: 'appCode',
            width: '20%'
        },
        {
            display: "${ctp:i18n('cip.register.appname')}",
            sortable: true,
            name: 'registerName',
            width: '25%'
        },
      /*   {
            display: "${ctp:i18n('cip.servcie.url')}",
            sortable: true,
            name: 'registerServiceUrl',
            width: '25%'
        }, */
        {
            display: "${ctp:i18n('cip.portal.login.pattern')}",
            sortable: true,
            name: 'loginPattern',
            width: '25%',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.AccessTypeEnum'"
        },
        {
            display: "${ctp:i18n('cip.manager.enabled')}",
            sortable: true,
            name: 'isEnable',
            width: '25%',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.CipEnableEnum'"
        }],
        managerName: "eipApi",
        managerMethod: "showThirdPortalList",
/*      managerName: "portalConfigManager",
        managerMethod: "showThirdPortalList", */
        width: "auto",
        usepager:"true",
        parentId: 'center'      
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    //mytable.grid.resizeGridUpDown('middle');
    
    //点击事件
    function gridclk(data, r, c) {
        
    }
    
    // 双击修改
    function griddbclick() {
        
    }
    
});

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
	    if(v[0].pcPageUrl && v[0].pcPageUrl!=''){
	    	return {"id":v[0].id,"registerId":v[0].registerId,"pcPageUrl":v[0].pcPageUrl};
        }
        $.alert("您选择的应用系统数据未设置PC登录地址！请重新选择！");
        return false;
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

