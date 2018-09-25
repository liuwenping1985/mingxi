var _addCheckBoxToGrid = false;

$(document).ready(function () {
	_addCheckBoxToGrid = flagStatPage;
	if(flagStatPage && hasScoreRole.toLocaleLowerCase() == 'true'){
		 loadToolbar() ;
		 loadStyle(); 
	}else{
		_addCheckBoxToGrid = false;
		loadStylePage();
	}
	loadData();
});
 
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
	 
 function loadStylePage() {
	 	//初始化布局
	     new MxtLayout({
	         'id': 'layout',
	         'centerArea': {
	             'id': 'center',
	             'border': false,
	             'minHeight': 20
	         }
	     });
	 }
	 
 //加载页面数据
 var grid;
 function loadData(){
	 var firstCol = {
             display: $.i18n("infosend.listInfo.number"),//序号
             name: 'number',
             sortable : true,
             width: '5%',
             isToggleHideShow:false
         }
	 
	 if(_addCheckBoxToGrid){
		 firstCol.type = 'checkbox';
	 }
	 
	 grid = $('#listInfoPublishScoreRecordManual').ajaxgrid({
         colModel: [
             firstCol,
         {
             display: $.i18n("infosend.listInfo.subject"),//信息标题
             name: 'subject',
             sortable : true,
             width: '35%'
         }, {
             display: $.i18n("infosend.listInfo.category"),//信息类型
             name: 'categoryName',
             sortable : true,
             hide : true,
             width: '12%'
         },
         {
             display: $.i18n("infosend.score.label.scoreUser"),//评分人
             name: 'scoreUserName',
             sortable : true,
             width: '14%'
         }, {
             display: $.i18n("infosend.score.label.scoreTime"),//评分时间
             name: 'scoreTime',
             ifFormat:'%Y-%m-%d %H:%M',
             sortable : true,
             width: '14%'
         },{
             display: $.i18n('infosend.score.label.socreStandand'),//评分标准
             name: 'scoreName',
             sortable : true,
             width: '24%'
         },{
             display: $.i18n('infosend.score.publish.level'),//刊登级别
             name: 'scoreLevelName',
             sortable : true,
             hide:true,
             width: '12%'
         },{
             display: $.i18n("infosend.listInfo.score.currentScore"),//当前得分
             name: 'currentScore',
             sortable : true,
             width: '9%'
         },{
             display: $.i18n("infosend.score.label.scoreNote"),//评分备注
             name: 'scoreDesc',
             sortable : true,
             width: '34%'
         }],
        parentId: $('.layout_center').eq(0).attr('id'),
        managerName : "infoPublishScoreManager",
        managerMethod : "getInfoPublishScoreRecordList"
     });
     var o = new Object();
     o.listType = listType;
     o.infoId = _infoId;
     $("#listInfoPublishScoreRecordManual").ajaxgridLoad(o);
 }
 
 function loadToolbar() {
	    $("#toolbars").toolbar({
	    	isPager:false,
	        toolbar: [{
	            id: "editScore",
	            name:"评分",//删除
	            className: "ico16 del_16",
	            click:doManualGrading
	        },{
	            id: "delScore",
	            name:"删除",//删除
	            className: "ico16 del_16",
	            click:deleteScore
	        }]
	    });
	}
 function loadToolbarPublishPage() {
	 $("#toolbars").toolbar({
		 isPager:false,
		 toolbar: [{
			 id: "editScore",
			 name:"评分",//删除
			 className: "ico16 del_16",
			 click:doManualGrading
		 }]
	 });
 }
 var manualGradingDialog;
 function doManualGrading() {
 	var rows = grid.grid.getSelectRows();
 	if (rows.length === 0) {
 		$.alert($.i18n('infosend.score.alert.selectScoreData')); //请选择评分数据！
 		return;
 	}
 	var infoIds = "";
 	for ( var count = 0; count < rows.length; count++) {
 		if(infoIds.indexOf(rows[count].infoId)<0){
 			if (count == rows.length - 1) {
 	 			infoIds += rows[count].infoId;
 	 		} else {
 	 			infoIds += rows[count].infoId + ",";
 	 		}
 		}
 	}
 	manualGradingDialog = $.dialog({
 		url : _ctxPath + "/info/magazine.do?method=manualGrading",
 		width : "700",
 		height : "500",
 		title : $.i18n('infosend.score.label.score'),//评分
 		id : 'manualGradingDialog',
 		transParams : {
 			"win" : window
 		},
 		targetWindow : getCtpTop(),
 		closeParam : {
 			show : true,
 			autoClose : false,
 			handler : function() {
 				manualGradingDialog.close();
 			}
 		},
 		buttons : [ {
 			id : "okButton",
 			btnType : 1,//按钮样式
 			text : $.i18n("common.button.ok.label"),
 			handler : function() {
 				var values = manualGradingDialog.getReturnValue();
 				if (values == undefined) {
 					return;
 				}

 				//if (!values.scoreTypeIds || !values.scoreTime || !values.scoreUserName) {
 				if (!values.scoreTypeIds) {
 					$.alert($.i18n('infosend.score.alert.scoreInvalid'));//当前评分无效！
 					return;
 				}

 				// 验证长度
 				if(values.scoreDesc && values.scoreDesc.length > 85){
 					$.alert($.i18n('infosend.score.alert.scoreNoteMaxLen'));//评分备注最大长度：85！
 					return;
 				}
 				if(values.scoreUserName.length > 85){
 					$.alert($.i18n('infosend.score.alert.maxScoreUserName'));//评分人最大长度：85！
 					return;
 				}
 				values.infoIds = infoIds;
 				var isManager = new infoPublishScoreManager();
 				var flag = isManager.saveManualGrading(values);
 				if(flag == "success"){
 					manualGradingDialog.close();
 					window.location.reload();
 				}else{
 					
 				}
 			}
 		}, {
 			id : "cancelButton",
 			text : $.i18n("common.button.cancel.label"),
 			handler : function() {
 				manualGradingDialog.close();
 			}
 		} ]
 	});
 }
//刷新当前页面
 function refreshW() {
 	location.reload();
 }
 
 function deleteScore(){
	 var rows = grid.grid.getSelectRows();
	    if(rows.length === 0){
	        $.alert("请选择一条评分信息！");//请选择一条记录
	        return;
	    }else{
	    var ids='';
    	for(i=0;i<rows.length;i++){
    		ids+=rows[i].id;
    		ids+=',';
    	}
    	ids = ids.substring(0,ids.length-1);
    	var publishScore = new infoPublishScoreManager();
    	 var tranObj = new Object();
         tranObj.ids = ids;
         publishScore.delStatScoreList(tranObj,{
             success : function(){
            	 refreshW();
             }, 
             error : function(request, settings, e){
                $.alert(e);
             }
          });
	    }
 }