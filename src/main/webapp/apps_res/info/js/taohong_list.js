/**
 * 类型列表-公文/信息报送
 */

var grid;
$(document).ready(function () {
	
	loadUE();
	
  	//工具栏
    var toolbarArray = new Array();
    toolbarArray.push({id:"create", name:$.i18n('common.toolbar.new.label'), className:"ico16", click:createTemplate});//新增
    toolbarArray.push({id:"modify", name:$.i18n('common.toolbar.update.label'), className:"ico16 editor_16", click:modifyTemplate});//修改
    toolbarArray.push({id:"delete", name:$.i18n('common.toolbar.delete.label'), className:"ico16 del_16", click:deleteTemplate});//删除
    toolbarArray.push({id:"downloadTemplate", name:$.i18n('infosend.magazine.label.downloadTemp'), className:"ico16 download_16", click:downloadTemplate});//下载模板书签列表
    //toolbarArray.push({id:"move", name:'移动', className:"ico16 move_16", click:moveCategory});//移动
    $("#toolbars").toolbar({
    	isPager:false,
        toolbar: toolbarArray
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
                o.name = $('#template_name').val();
            }else if(choose === 'status'){
                o.status = $('#state').val();
            }else if(choose === 'rang'){
                o.rang = $('#scope').val();
            }
            var val = searchobj.g.getReturnValue();
            if(val !== null){
                $("#listTaohong").ajaxgridLoad(o);
            }
        },
        conditions: [{
            id: 'template_name',
            name: 'template_name',
            type: 'input',
            text: $.i18n('infosend.label.template'),//模板名称
            value: 'name',
            maxLength:100
        }, {
            id: 'state',
            name: 'state',
            type: 'select',
            text: $.i18n('infosend.status'),//状态
            value: 'status',
            items: [{
                text: $.i18n('infosend.status.enable'),//启用
                value: '1'
            }, {
                text: $.i18n('infosend.status.disable'),//停用
                value: '0'
            }]
        }/*, {
            id:'scope',
            name:'scope',
            type:'input',
            text: $.i18n('infosend.label.rang'),//授权范围
            value:'rang',
            //ifFormat:'%Y-%m-%d',
            dateTime: false
        }*/]
    });
    
    //表格加载
    grid = $('#listTaohong').ajaxgrid({
    	colModel: [{
            display: 'id',
            name: 'affairId',
            width: '4%',
            type: 'checkbox',
            isToggleHideShow:false
        }, {
            display: $.i18n('infosend.label.template'),//模板名称
            name: 'name',
            sortable : true,
            width: '56%'
        },{
            display: $.i18n('infosend.status'),//状态
            name: 'status',
            sortable : true,
            width: '20%'
        }, {
            display: $.i18n('infosend.label.rang'),//授权范围
            name: 'range',
            sortable : true,
            width: '20%'
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
        managerName : "infoFormatManager",
        managerMethod : "getTemplateList"
    });
    //var o = new Object();
    //o.appType = '32';
    $("#listTaohong").ajaxgridLoad();
    //页面底部说明加载
    setTimeout(function(){
    	$('#summary').attr("src", _ctxPath+"/info/taohong.do?method=listDesc"+"&size="+grid.p.total);
    	},"300");
});

function createTemplate(){
	//$('.slideUpBtn').trigger('click');
	listTaohong.grid.resizeGridUpDown('middle');
	$('#summary').attr("src", _ctxPath+"/info/taohong.do?method=findFormat&action=create");
}

function modifyTemplate(){
	var _system_template = "";
	var v = $("#listTaohong").formobj({
		gridFilter: function(data, row) {
			return $("input:checkbox", row)[0].checked;
      	}
    });
	if(v.length > 0){
		for (i = 0; i < v.length; i++) {
			if(v[i].isSystem == "1"){
				_system_template = _system_template + v[i].name + "、";
			}
		}
	}
	if (v.length < 1) {
		$.alert($.i18n("category.alert.1"));
	} else if (v.length > 1) {
		$.alert($.i18n("category.alert.2"));
	//} else if(_system_template != ""){
	//	_system_template = _system_template.substring(0, _system_template.length-1);
	//	$.alert($.i18n("infosend.alert.foramt.sysEdit",_system_template));
	}else {
		listTaohong.grid.resizeGridUpDown('middle');
		$('#summary').attr("src", _ctxPath+"/info/taohong.do?method=findFormat&action=doModify&id="+v[0].id);
	}
}

function deleteTemplate(){
	var v = $("#listTaohong").formobj({
		gridFilter: function(data, row) {
			return $("input:checkbox", row)[0].checked;
      	}
    });
	if (v.length < 1) {
		$.alert($.i18n("category.alert.3"));
	}else {
		var template_name = "";
		var _system = "";
		for (i = 0; i < v.length; i++) {			
            if (i != v.length - 1) {
            	template_name = template_name + v[i].name + "、";
            } else {
            	template_name = template_name + v[i].name;
            }
            if(v[i].isSystem == "1"){
            	_system = _system + v[i].name + "、";
        	}
        }
		if(_system != ""){
			_system = _system.substring(0, _system.length-1);
			$.alert($.i18n("infosend.alert.foramt.sysDelete",_system));
			return ;
		}
		$.confirm({
            //'msg': $.i18n("infosend.alert.confirm",template_name),
			'msg': $.i18n("infosend.format.alert.delete"),
            ok_fn: function() {
				info_manager.deleteFormat(v, {
                success: function() {
                  $("#listTaohong").ajaxgridLoad();
                  //window.parent.$("#categoryTree").treeObj().reAsyncChildNodes(null, "refresh");
                  setTimeout(function(){
      				$('#summary').attr("src", _ctxPath+"/info/taohong.do?method=listDesc"+"&size="+grid.p.total);
          			},"500");
                }
              });
            }
        });
	}
}

//定义setTimeout执行方法
var TimeFn = null;
//定义单击事件
function clickRow(data, rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    //clearTimeout(TimeFn);
    //执行延时
    /*if(!isAffairValid(data.affairId)){
        $("#listGrid").ajaxgridLoad();
        $(".spiretBarHidden3").trigger("click");
        return;
    }*/
    /*TimeFn = setTimeout(function(){
        $('#summary').attr("src", _ctxPath+"/info/infoElement.do?method=edit&listType=listElement&id="+data.id);
    },300);*/
    $('#summary').attr("src", _ctxPath+"/info/taohong.do?method=findFormat&action=find&id="+data.id);
}

//双击事件
function dbclickRow(data, rowIndex, colIndex){
    // 取消上次延时未执行的方法
    //clearTimeout(TimeFn);
	if(data.isSystem == "1"){
		$('#summary').attr("src", _ctxPath+"/info/taohong.do?method=findFormat&action=find&id="+data.id);
	} else {
		$('#summary').attr("src", _ctxPath+"/info/taohong.do?method=findFormat&action=doModify&id="+data.id);
	}
    //var title = data.subject;
    //doubleClick(url,escapeStringToHTML(title));
}

//回调函数
function rend(txt, data, r, c) {
	if(c === 1){
		txt ="<span class='grid_black'>"+txt+"</span>";
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


