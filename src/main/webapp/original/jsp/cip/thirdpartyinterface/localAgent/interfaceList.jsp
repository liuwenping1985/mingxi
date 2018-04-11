<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<style type="text/css"></style>
</head>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=extendedResourceManager"></script>
<script type="text/javascript">
$(document).ready(function() {
    initGrid();
    initSearchObj();
});
/**
 * 初始化列表组件
 */
function initGrid() {
	var $interface = $("#interface");
    gridObj = $interface.ajaxgrid({
        colModel : [ {
            display : 'ID',
            name : 'iD',
            width : '10%',
            sortable : false,
            align : 'center',
            type : 'checkbox',
            isToggleHideShow : false
        }, {
            display : "${ctp:i18n('cip.base.interface.register.product')}",
            name : 'product_flag',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.base.interface.register.name')}",
            name : 'interface_name',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.base.interface.register.inttype')}",
            name : 'vALUE0',
            width : '15%'
        }, {
            display : "${ctp:i18n('cip.base.interface.register.des')}",
            name : 'interface_des',
            width : '25%'
        }],
        render : rend,
        managerName : "interfaceRegisterManager",
        managerMethod : "listCipInterfaceRegisterVo",
        parentId : $('.layout_center').eq(0).attr('id'),
        height : 360,
        isHaveIframe : true,
        vChange : true,
        vChangeParam : {
            overflow : "hidden",
            autoResize : true
        }
    });
    var o = {};
	o.treeValue = "${ids}";
	var $interface = $("#interface");
    $interface.ajaxgridLoad(o);
}
function rend(txt, data, r, c) {
	return txt;
}
/**
 * 初始化搜索框
 */
function initSearchObj() {
    var topSearchSize = 7;
    if ($.browser.msie && $.browser.version == '6.0') {
        topSearchSize = 5;
    }
    var searchObj = $.searchCondition({
        top: topSearchSize,
        right: 10,
        searchHandler: function () {
            var choose = $('#' + searchObj.p.id).find("option:selected").val();
            wholeObj = searchObj;
            var res = searchObj.g.getReturnValue();
			var o = {};
			if(choose == "product"){
				o.condition = "product_flag";
				o.value = res.value;
			}else if(choose == "interfaceName"){
				o.condition = "interface_name";
				o.value = res.value;
			}else if(choose == "type"){
				o.condition = "value0";
				o.value = res.value;
			}else if(choose == "describ"){
				o.condition = "interface_des";
				o.value = res.value;
			}
			o.treeValue = "${ids}";
			var $interface = $("#interface");
			$interface.ajaxgridLoad(o);
        },
        conditions: [{
            id: 'product',
            name: 'product',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.product')}',
            value: 'product'
        },{
        	id: 'interfaceName',
            name: 'interfaceName',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.name')}',
            value: 'interfaceName'
        },{
        	id: 'type',
            name: 'type',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.inttype')}',
            value: 'type'
        },{
        	id: 'describ',
            name: 'describ',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.des')}',
            value: 'describ'
        }]
    });
}
function OK() {
	var hasChecked = $("input:checked", $("#interface"));
    if (hasChecked.length == 0) {
        return "";
    }
    if(hasChecked.length > 1){
    	return "more";
    }
    id = hasChecked[0].value
    var manager = new interfaceRegisterManager();
	var data = manager.findInterfaceVoById(id);
	return data.iD + "," + data.interface_name;
}
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbars"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:true">
			<div id="center">
				<table class="flexme3" id="interface"></table>
			</div>
		</div>
	</div>
</body>
</html>