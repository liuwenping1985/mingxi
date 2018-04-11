<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/form_taglib.jsp"%>
<%@ include file="include/form_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>信息报送单</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=govformManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=govformAjaxManager"></script>
<script type="text/javascript" src="${path}/apps_res/gov/govform/js/list.js${ctp:resSuffix()}"></script>
<c:set value="govform.column.typename.default_${ctp:escapeJavascript(paramMap.appType)}" var="typeNameLabel" />
<script>

var appType = "${ctp:escapeJavascript(paramMap.appType)}";
var listType = "${ctp:escapeJavascript(paramMap.listType)}";
var currentUserDomainId = ${currentUser.loginAccount};
var statusDefault = "1";

/****** 页面加载：按扭 *****/
function loadToolbar() {
    var toolbarArray = new Array();
    toolbarArray.push({id:"createObj", name:"${ctp:i18n('common.toolbar.new.label')}", className:"ico16", click:createRow});//新建
    toolbarArray.push({id:"updateObj", name:"${ctp:i18n('common.toolbar.update.label')}", className:"ico16 editor_16", click:modifyRow});//修改
    toolbarArray.push({id:"deleteObj", name:"${ctp:i18n('common.toolbar.delete.label')}", className:"ico16 del_16 ", click:deleteRow});//删除
    toolbarArray.push({id:"enableObj", name:"${ctp:i18n('common.state.normal.label')}", className:"ico16 enabled_16", click:enableRow});//启用
    toolbarArray.push({id:"disableObj", name:"${ctp:i18n('common.state.invalidation.label')}", className:"ico16 disabled_16", click:disabledRow});//停用
    if(isGroup) {
    	toolbarArray.push({id:"authObj", name:"${ctp:i18n('common.toolbar.auth.label')}", className:"ico16 authorize_16 ", click:authRow });//授权
    }
    toolbarArray.push({id:"setdefaultObj", name:"${ctp:i18n('govform.column.typename.setdefault_32')}", className:"ico16 setting_16", click:setDefaultRow });//设置默认单
    $("#toolbars").toolbar({
    	isPager:false,
        toolbar: toolbarArray
    })
}

/****** 页面加载：查询条件 *****/
function loadCondition() {
	//定义搜索条件选项
    var condition = new Array();
    //元素名称
    condition.push({id : 'name', name:'name', type:'input', text:"${ctp:i18n('common.name.label')}", value:'name', maxLength:85, validate:false});
  	//当前状态
    condition.push({id: 'status', name:'status', type:'select', text: "${ctp:i18n('element.column.enablestate')}", value:'status',
        items: [{
            text: "${ctp:i18n('common.state.normal.label')}",//启用
            value: '1'
        }, {
            text: "${ctp:i18n('common.state.invalidation.label')}",//停用
            value: '0'
        }]
    });
  	//搜索框
    var searchobj = $.searchCondition({
        top:2,
        right:10,
        searchHandler: function(){
            searchFunc();
        },
        conditions:condition
    });
  	
  	//搜索框执行的动作
    function searchFunc() {
        var o = new Object();
        o.appType = appType;
        var choose = $('#'+searchobj.p.id).find("option:selected").val();
        if(choose === 'name') {
            o.name = $('#name').val();
            o.status = statusDefault;
        }else if(choose === 'status') {
            o.status = $('#status').val();
        }
        o.condition = choose;
        var val = searchobj.g.getReturnValue();
        //保存搜索条件
        $("#condition").val(o.condition);
	    $("#name").val(o.name);
	    $("#status").val(o.status);
	    //保存搜索条件
        if(val !== null){
            $("#listGrid").ajaxgridLoad(o);
        }
    }
}

/****** 页面加载：列表数据 *****/
var grid;
function loadData() {
	//表格加载
	var colModels = new Array();
	colModels.push({display: 'id', name: 'id', isSystem: 'isSystem', isDefault: 'isDefault', type: 'type', status: 'status', domainId: 'domainId', authUnitIds: 'authUnitIds', authUnitNames: 'authUnitNames', width: '4%', type: 'checkbox', isToggleHideShow:false });
	if(isGroup) {
		colModels.push({display: "${ctp:i18n('common.name.label')}", name: 'name', sortable : true, width: '36%' });//subject
	} else {
		colModels.push({display: "${ctp:i18n('common.name.label')}", name: 'name', sortable : true, width: '65%' });//subject
	}
	colModels.push({display: "${ctp:i18n(typeNameLabel)}", name: 'defaultTypeName', sortable : true, width: '15%'});//fieldName
	if(isGroup) {
		colModels.push({display: "${ctp:i18n('common.toolbar.auth.label')}", name: 'authUnitNames', sortable : true, width: '15%' });//elementId
	}
	colModels.push({display: "${ctp:i18n('common.state.label')}", name: 'stateName', sortable : true, width: '15%' });//elementId
	if(isGroup) {
		colModels.push({display: "${ctp:i18n('govform.column.made.unitname')}", name: 'madeUnitName', sortable : true, width: '15%' });//elementId
	}
	grid = $('#listGrid').ajaxgrid({
        colModel: colModels,
        click: clickRow,
        dblclick: dbclickRow,
        render : rend,
        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: true,
		vChangeParam: {
            overflow: "hidden",
			autoResize:true
        },
        slideToggleBtn: true,
        managerName : "govformManager",
        managerMethod : "getFormList",
        onSuccess: function(){
            loadSummaryDesc();
        }
    });
    var o = new Object();
    o.appType = appType;
    o.status = statusDefault;
    $("#listGrid").ajaxgridLoad(o);
}

</script>
</head>
<body>
	<input type="hidden" id="appType" name="appType" value="${ctp:toHTML(paramMap.appType)}" />
	<input type="hidden" id="type" name="type" value="${paramMap.type }" />
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div id="toolbars"> </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listGrid"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" name='summaryF' width="100%" height="100%" frameborder="0"  class="calendar_show_iframe" style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
</body>
</html>
