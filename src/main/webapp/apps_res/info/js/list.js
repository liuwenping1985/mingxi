//刷新当前页面
function refreshW() {
	parent.location.reload();
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

//回调函数
function rend(txt, data, r, c) {
	if(c===1){
		txt ="<span class='grid_black'>"+txt+"</span>";
	}
	return txt;
}
function modifyRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
        $.alert($.i18n('infosend.score.alert.pleaseSelect'));//请选择一条信息！
        return;
    }
    if(rows.length>1){
        $.alert($.i18n('infosend.score.alert.selectOne'));//只能选择一条信息进行修改！
        return;
    }
    grid.grid.resizeGridUpDown('middle');
	$('#summary').attr("src", _ctxPath+"/info/score.do?method=edit&id="+rows[0].id+"&openForm=edit");
}
//添加评分标准设置
function addScore(){
	 grid.grid.resizeGridUpDown('middle');
	$('#summary').attr("src", _ctxPath+"/info/score.do?method=edit&openForm=add");
}
//定义setTimeout执行方法
var TimeFn = null;
//定义单击事件
function clickRow(data, rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    TimeFn = setTimeout(function(){
    	$('#summary').attr("src", _ctxPath+"/info/score.do?method=edit&openForm=view&id="+data.id);
    }, 10);
}
//定义双击事件
function clickModifyRow(data, rowIndex, colIndex) {
	 clearTimeout(TimeFn);
	    TimeFn = setTimeout(function(){
	    	$('#summary').attr("src", _ctxPath+"/info/score.do?method=edit&openForm=edit&id="+data.id);
	    }, 10);
}


//修改启用状态
function changeEnable(){
	change('1');//启用
}
//修改停用状态
function changeDisable(){
	change('0');//停用
}

function change(status){
	var rows = grid.grid.getSelectRows();
	
	var tempReportCount = 0;//上报评分标准数量 
	
	if(rows.length === 0){
        $.alert($.i18n('infosend.score.alert.pleaseSelect'));//请选择一条信息！
        return;
    }else{
    	var ids='';
    	for(i=0;i<rows.length;i++){
    		ids+=rows[i].id;
    		ids+=',';
    		if(rows[i].type=='0'){//数据类型为上报评分标准
    			tempReportCount++;
    		}
    	}
    	if(tempReportCount > 1 && status === '1'){//最多只能选择一条上报评分标准
    		var tempLable = $.i18n('infosend.status.enable');//启用
    		$.alert($.i18n('infosend.score.state.change.disable', tempLable));//信息上报只能停用/启用一项评分标准
    		return;
    	}
    	 ids = ids.substring(0,ids.length-1);
    	var smanage = new infoScoreManager();
    	 var tranObj = new Object();
         tranObj.ids = ids;
         tranObj.state=status;
         smanage.updateScoreStatus(tranObj,{
             success : function(msg){
                 //刷新列表
            	 if(msg == 'true'){
            		 refreshW();
            	 }else{
            		 $.alert(msg);
            	 }
             }, 
             error : function(request, settings, e){
                     $.alert(e);
             }
          });
    }
}

/**弹出发布范围**/
var magazineRangeDialog
function magazineRange(){
	var data = new Date();
	magazineRangeDialog = $.dialog({
        url: _ctxPath+"/info/magazine.do?method=publishRange",
        width: "700",
        height: "500",
       	title: $.i18n('infosend.label.publish'),//发布
        id:'magazineRangeDialog',
        transParams:{"win":window},
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
            	magazineRangeDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            btnType : 1,//按钮样式
            text: $.i18n("common.button.ok.label"),
            handler: function () {
        		var values = magazineRangeDialog.getReturnValue();
        		if(values==undefined){
        			return;
        		}
        		$("#publishRange").val(values.checkPublistTypes);
        		$("#viewPeopleId").val(values.viewPeopleId);
        		$("#publicViewPeopleId").val(values.publicViewPeopleId);
        		$("#orgSelectedTree").val(values.orgSelectedTree);
        		$("#UnitSelectedTree").val(values.UnitSelectedTree);
        		$("#viewPeople").val(values.viewPeople);
        		$("#publicViewPeople").val(values.publicViewPeople);
        		magazineRangeDialog.close();
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	magazineRangeDialog.close();
            }
        }]
    });
}


