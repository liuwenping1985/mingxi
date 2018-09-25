/**
 * 类型列表-公文/信息报送
 */

var grid;
$(document).ready(function () {
	
	loadUE();
	
  	//工具栏
    var toolbarArray = new Array();
    toolbarArray.push({id:"create", name:$.i18n('common.toolbar.new.label'), className:"ico16", click:createCategory});//新增
    toolbarArray.push({id:"modify", name:$.i18n('common.toolbar.update.label'), className:"ico16 editor_16", click:modifyCategory});//修改
    toolbarArray.push({id:"delete", name:$.i18n('common.toolbar.delete.label'), className:"ico16 del_16", click:deleteCategory});//删除
    //toolbarArray.push({id:"move", name:'移动', className:"ico16 move_16", click:moveCategory});//移动
    $("#toolbars").toolbar({
        toolbar: toolbarArray,
        isPager:false
    });
    
    //搜索框
    var topSearchSize = 2;
    if($.browser.msie && $.browser.version=='6.0'){
        topSearchSize = 5;
    }
    var searchobj = $.searchCondition({
        top:topSearchSize,
        right:10,
        searchHandler: function(){
            var o = new Object();
            var choose = $('#'+searchobj.p.id).find("option:selected").val();
            if(choose === 'name'){
                o.name = $('#category_name').val();
            }else if(choose === 'level'){
                o.level = $('#category_level').val();
            }else if(choose === 'createUserName'){
                o.createUser = $('#createUser').val();
            }else if(choose === 'createTime'){
                var fromDate = $('#from_createDate').val();
                var toDate = $('#to_createDate').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.createTime = date;
            }
            var val = searchobj.g.getReturnValue();
            if(val !== null){
                $("#listCategory").ajaxgridLoad(o);
            }
        },
        conditions: [{
            id: 'category_name',
            name: 'category_name',
            type: 'input',
            text: $.i18n('category.column.name.app_32'),//信息类型名称
            value: 'name',
            maxLength:100
        }, {
            id: 'createUser',
            name: 'createUser',
            type: 'input',
            text: $.i18n('category.column.creater'),//创建人
            value: 'createUserName'
        }, {
            id:'createDate',
            name:'createDate',
            type:'datemulti',
            text: $.i18n('category.column.createtime'),//创建时间
            value:'createTime',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }]
    });
    
    //表格加载
    grid = $('#listCategory').ajaxgrid({
    	colModel: [{
            display: 'id',
            name: 'affairId',
            width: '4%',
            type: 'checkbox',
            isToggleHideShow:false
        }, {
            display: $.i18n("category.column.name.app_32"),//信息类型名称
            name: 'name',
            sortable : true,
            width: '56%'
        },{
            display: $.i18n("category.column.sort"),//排序号
            name: 'sort',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("category.column.desc"),//描述
            name: 'desc',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("category.column.createtime"),//创建时间
            name: 'createTime',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("category.column.creater"),//创建人
            name: 'createUserName',
            sortable : true,
            width: '10%'
        }],
        click: clickRow,
        dblclick: dbclickRow,
        render : rend,
        height: 200,
        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:true,
        managerName : "categoryManager",
        managerMethod : "getCategoryList"
    });
    //var o = new Object();
    //o.appType = '32';
    $("#listCategory").ajaxgridLoad();
    //页面底部说明加载
    //var totalNum = grid.p.total - 1;
    setTimeout(function(){
    	$('#summary').attr("src", _ctxPath+"/category/category.do?method=summaryDesc"+"&size="+grid.p.total);
    	},"500");
});

function createCategory(){
	listCategory.grid.resizeGridUpDown('middle');
	$('#summary').attr("src", _ctxPath+"/category/category.do?method=create&action=doCreate");
}

function modifyCategory(){
	var v = $("#listCategory").formobj({
		gridFilter: function(data, row) {
			return $("input:checkbox", row)[0].checked;
      	}
    });
	if (v.length < 1) {
		$.alert($.i18n("category.alert.1"));
	} else if (v.length > 1) {
		$.alert($.i18n("category.alert.2"));
	}else {
		listCategory.grid.resizeGridUpDown('middle');
		$('#summary').attr("src", _ctxPath+"/category/category.do?method=find&action=doModify&category_id="+v[0].id);
	}
}

function deleteCategory(){
	var v = $("#listCategory").formobj({
		gridFilter: function(data, row) {
			return $("input:checkbox", row)[0].checked;
      	}
    });
	if (v.length < 1) {
		$.alert($.i18n("category.alert.3"));
	}else {
		var category_name = "";
		var system_category = "";
		for (i = 0; i < v.length; i++) {			
            if (i != v.length - 1) {
            	category_name = category_name + v[i].name + "、";
            } else {
            	category_name = category_name + v[i].name;
            }
            if(v[i].isSystem == "1"){
        		system_category = system_category + v[i].name + "、";
        	}
        }
		if(system_category != ""){
			system_category = system_category.substring(0, system_category.length-1);
			$.alert($.i18n("category.alert.system",system_category));
			return ;
		}
		$.confirm({
            'msg': $.i18n("category.alert.confirm",category_name),
            ok_fn: function() {
              cManager.deleteCategory(v, {
                success: function() {
                  $("#listCategory").ajaxgridLoad();
                  //window.parent.$("#categoryTree").treeObj().reAsyncChildNodes(null, "refresh");
                  setTimeout(function(){
      				$('#summary').attr("src", _ctxPath+"/category/category.do?method=summaryDesc"+"&size="+grid.p.total);
          			},"500");
                }
              });
            }
        });
	}
}

function moveCategory(){
}

//定义setTimeout执行方法
var TimeFn = null;
//定义单击事件
function clickRow(data, rowIndex, colIndex) {
    $('#summary').attr("src", _ctxPath+"/category/category.do?method=find&action=show&category_id="+data.id);
}

//双击事件
function dbclickRow(data, rowIndex, colIndex){
    $('#summary').attr("src", _ctxPath+"/category/category.do?method=find&action=doModify&category_id="+data.id);
}

//回调函数
function rend(txt, data, r, c) {
	if(c===1){
		txt = "<span class='grid_black'>"+txt+"</span>";
	}
	if(c === 4){
		txt = data.createTime.split(" ")[0];
	}
	return txt;
}

function loadUE() {
	/** UE样式 */
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 30,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
}


