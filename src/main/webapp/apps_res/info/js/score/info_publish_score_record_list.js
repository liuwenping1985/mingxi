 $(document).ready(function () {
	 loadStyle();
	 loadData();
	 //loadToolbar();
});
 

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
 //加载页面数据
 var grid;
 
 /**
  * 加载自动评分数据
  */
 function loadData() {
    //表格加载
	 grid = $('#listInfoPublishScoreRecord').ajaxgrid({
         colModel: [{
             display: $.i18n("infosend.listInfo.number"),//序号
             name: 'number',
             sortable : false,
             width: '5%',
             isToggleHideShow:false
         }, {
             display: $.i18n("infosend.listInfo.subject"),//信息标题
             name: 'subject',
             sortable : true,
             hide:true,
             width: '20%'
         }, {
             display: $.i18n("infosend.listInfo.category"),//信息类型
             name: 'categoryName',
             sortable : true,
             hide : true,
             width: '12%'
         }, {
             display: $.i18n('infosend.magazine.list.condition.subject'),//期刊名称
             name: 'magazineName',
             sortable : true,
             width: '26%'
         }, {
             display: $.i18n('infosend.magazine.auditDone.issue'),//期号
             name: 'magazineNo',
             sortable : true,
             hide : true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.score.publishTime'),//发布时间
             name: 'publishTime',
             ifFormat:'%Y-%m-%d %H:%M',
             sortable : true,
             width: '14%'
         }, {
             display: $.i18n('infosend.listInfo.score.currentRange'),//当次发布范围
             name: 'publishDestName',
             sortable : true,
             width: '23%'
         }, {
             display: $.i18n('infosend.score.label.socreStandand'),//评分标准
             name: 'scoreName',
             sortable : true,
             width: '23%'
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
         }],
         parentId: $('.layout_center').eq(0).attr('id'),
         managerName : "infoPublishScoreManager",
         managerMethod : "getInfoPublishScoreRecordList"
     });
     var o = new Object();
     o.listType = listType;
     o.infoId = _infoId;
     $("#listInfoPublishScoreRecord").ajaxgridLoad(o);
}
 
 function deleteScore() {
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

 function loadStyle() {
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
 
 var manualGradingDialog;
 function doManualGrading() {
 	var rows = grid.grid.getSelectRows();
 	if (rows.length === 0) {
 		$.alert($.i18n('infosend.score.alert.selectScoreData')); //请选择评分数据！
 		return;
 	}
 	var infoIds = "";
 	for ( var count = 0; count < rows.length; count++) {
 		if (count == rows.length - 1) {
 			infoIds += rows[count].infoId;
 		} else {
 			infoIds += rows[count].infoId + ",";
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