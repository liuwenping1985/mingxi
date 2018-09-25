

function modifyRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
        $.alert($.i18n('element.info.alert.selectInfoFormEle'));//请选择一条报送单元素！
        return;
    }
    if(rows.length>1){
        $.alert($.i18n('element.info.alert.selectOneEle', $.i18n('common.toolbar.update.label')));//只能选择一条报送单元素进行修改！
        return;
    }
    grid.grid.resizeGridUpDown('middle');
	$('#summary').attr("src", _ctxPath+"/element/element.do?method=edit&listType=listElement&id="+rows[0].id+"&editFlag=true");
}

//定义setTimeout执行方法
var TimeFn = null;
//定义单击事件
function clickRow(data, rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    //执行延时
    /*if(!isAffairValid(data.affairId)){
        $("#listGrid").ajaxgridLoad();
        $(".spiretBarHidden3").trigger("click");
        return;
    }*/
    TimeFn = setTimeout(function(){
    	$('#summary').attr("src", _ctxPath+"/element/element.do?method=edit&listType=listElement&id="+data.id);
    }, 10);
}
//双击事件
function dbclickRow(data, rowIndex, colIndex){
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    var url = _ctxPath+"/info/infoElement.do?method=edit&listType=listElement&id="+data.id;
    var title = data.subject;
    //doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
}

//回调函数
function rend(txt, data, r, c) {
	if(c===1){
		txt = "<span class='grid_black'>"+txt+"</span>";
	}
	return txt;
}

function loadStyle() {
	//初始化布局
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

//修改元素启用状态
function changeEnable(){
	change('1');//启用
}
//修改元素停用状态
function changeDisable(){
	change('0');//启用
}


function change(status){
	var rows = grid.grid.getSelectRows();
	if(rows.length === 0){
		$.alert($.i18n('element.info.alert.selectInfoFormEle'));//请选择一条报送单元素！
        return;
    }else{
    	var ids='';
    	for(i=0;i<rows.length;i++){
    		ids+=rows[i].id;
    		ids+=',';
    	}
    	 ids = ids.substring(0,ids.length-1);
    	var element = new elementManager();
    	 var tranObj = new Object();
         tranObj.ids = ids;
         tranObj.state=status;
         element.updateElementStatus(tranObj,{
             success : function(){
                 //刷新列表
            	 refreshW();
             }, 
             error : function(request, settings, e){
                     $.alert(e);
             }
          });
    }
}
//刷新当前页面
function refreshW() {
	location.reload();
}