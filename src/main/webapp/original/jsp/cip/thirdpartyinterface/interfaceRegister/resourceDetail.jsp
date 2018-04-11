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
    var $resource = $("#resourceList");
    gridObj = $resource.ajaxgrid({
        colModel : [ {
            display : 'id',
            name : 'id',
            width : '10%',
            sortable : false,
            align : 'center',
            type : 'checkbox',
            isToggleHideShow : false
        }, {
            display : "${ctp:i18n('cip.base.interface.register.product')}",
            name : 'productFlag',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.extendedresource.lab.resourceno')}",
            name : 'resourceCode',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.extendedresource.lab.resourcename')}",
            name : 'resourceName',
            width : '15%'
        }, {
            display : "${ctp:i18n('cip.extendedresource.lab.resourcebag')}",
            name : 'resourceFileName',
            width : '25%'
        }],
        render : rend,
        managerName : "extendedResourceManager",
        managerMethod : "listCipResourcePackageVo",
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
    o.resourceList = "resourceList";
	o.resourceValue = "${product_flag}";
    $resource.ajaxgridLoad(o);
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
			}else if(choose == "resourceCode"){
				o.condition = "resource_code";
				o.value = res.value;
			}else if(choose == "resourceName"){
				o.condition = "resource_name";
				o.value = res.value;
			}else if(choose == "resourceFileName"){
				o.condition = "filename";
				o.value = res.value;
			}
		    o.resourceList = "resourceList";
			o.resourceValue = "${product_flag}";
		    var $resource = $("#resourceList");
		    $resource.ajaxgridLoad(o);
        },
        conditions: [{
            id: 'product',
            name: 'product',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.product')}',
            value: 'product'
        },{
        	id: 'resourceCode',
            name: 'resourceCode',
            type: 'input',
            text: '${ctp:i18n('cip.extendedresource.lab.resourceno')}',
            value: 'resourceCode'
        },{
        	id: 'resourceName',
            name: 'resourceName',
            type: 'input',
            text: '${ctp:i18n('cip.extendedresource.lab.resourcename')}',
            value: 'resourceName'
        },{
        	id: 'resourceFileName',
            name: 'resourceFileName',
            type: 'input',
            text: '${ctp:i18n('cip.extendedresource.lab.resourcebag')}',
            value: 'resourceFileName'
        }]
    });
}
function OK() {
	var hasChecked = $("input:checked", $("#resourceList"));
    if (hasChecked.length == 0) {
        return "";
    }
    var ids = "";
    for (var i = 0; i < hasChecked.length; i++) {
    	ids += "," + hasChecked[i].value;
    }
	return ids;
}
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbars"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:true">
			<div id="center">
				<table class="flexme3" id="resourceList"></table>
			</div>
		</div>
	</div>
</body>
</html>