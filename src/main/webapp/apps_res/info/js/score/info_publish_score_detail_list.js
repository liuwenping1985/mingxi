 $(document).ready(function () {
	 
	loadListStyle();
	if(hasScoreRole.toLocaleLowerCase() == 'true'){
		loadToolbar();
	}
    loadCondition();
    loadData();
    loadAClick();
});

function loadToolbar() {
     $("#toolbars").toolbar({
    	 isPager:false,
         toolbar: [{
             id: "editScore",
             name: $.i18n('infosend.score.label.score'),//评分
             className: "ico16 editor_16",
             click:doManualGrading
         }]
     });
 }

 var searchobj;
 function loadCondition() {//搜索框
     var topSearchSize = 2;
     if($.browser.msie && $.browser.version=='6.0'){
         topSearchSize = 5;
     }
     searchobj = $.searchCondition({
         top:topSearchSize,
         right:85,
         searchHandler: function(){
             var o = new Object();
             var choose = $('#'+searchobj.p.id).find("option:selected").val();
             if(choose === 'subject'){
                 o.subject = $('#subject').val();
             }else if(choose === 'reportUnit'){
                 o.reportUnit = $('#reportUnit').val();
             }else if(choose === 'reportDept'){
                 o.reportDept = $('#reportDept').val();
             }else if(choose === 'categoryName'){
                 o.categoryName = $('#categoryName').val();
             }
             var val = searchobj.g.getReturnValue();
             if(val !== null){
                 o.listType = listType;
                 o.condition = choose;
                 searchConditionObj = o;
                 $("#listInfoPublishScoreDetail").ajaxgridLoad(o);
             }
         },
         conditions: [{
             id: 'subject',
             name: 'subject',
             type: 'input',
             text: $.i18n('infosend.listInfo.subject'),//信息标题
             value: 'subject',
             maxLength:100
         },{
             id: 'reportDept',
             name: 'reportDept',
             type: 'input',
             text: $.i18n('infosend.listInfo.reportDept'),//上报部门
             value: 'reportDept',
             maxLength:100
         },{
             id: 'reportUnit',
             name: 'reportUnit',
             type: 'input',
             text: $.i18n(unitView),//上报单位
             value: 'reportUnit',
             hide:true,
             maxLength:100
         },{
             id: 'categoryName',
             name: 'categoryName',
             type: 'input',
             text: $.i18n('infosend.listInfo.category'),//信息类型
             value: 'categoryName',
             maxLength:100
         }]
     });
  }
 //加载页面数据
 var grid;
 function loadData() {
    //表格加载
     grid = $('#listInfoPublishScoreDetail').ajaxgrid({
         colModel: [{
             display: 'id',
             name: 'id',
             infoId : 'infoId',
             width: '5%',
             type: 'checkbox',
             isToggleHideShow:false
         }, {
             display: $.i18n("infosend.listInfo.subject"),//标题
             name: 'subject',
             sortable : true,
             width: '35%'
         }, {
             display: $.i18n(unitView),//上报单位
             name: 'reportUnit',
             sortable : true,
             hide:true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reportDept'),//上报部门
             name: 'reportDept',
             sortable : true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reportDate'),//上报日期
             name: 'reportDate',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reporter'),//上报人
             name: 'reporter',
             sortable : true,
             hide:true,
             width: '12%'
         },{
             display: $.i18n('infosend.listInfo.category'),//信息类型
             name: 'categoryName',
             sortable : true,
             width: '12%'
         },{
             display: $.i18n("infosend.listInfo.score.scoreAutoMatic"),//系统积分
             name: 'scoreAutoMatic',
             sortable : true,
             width: '8%'
         },{
             display: $.i18n("infosend.listInfo.score.scoreManual"),//手工评分
             name: 'scoreManual',
             sortable : true,
             width: '8%'
         },{
             display: $.i18n("infosend.listInfo.score.scoreTotal"),//总分
             name: 'scoreTotal',
             sortable : true,
             width: '8%'
         }],
         click: clickRow,
         render : rend,
         showTableToggleBtn: true,
         parentId: $('.layout_center').eq(0).attr('id'),
         vChange: true,
         vChangeParam: {
            overflow: "hidden",
            autoResize:true
         },
         resizable : false,
         slideToggleBtn: true,
         managerName : "infoPublishScoreManager",
         managerMethod : "getInfoPublishScoreDetailList"
     });
}

function rend(txt, data, r, c) {
	 if(c === 1){
		 txt = "<span class='grid_black'>"+txt;
        //附件
        if(data.attachment === true){
            txt = txt + "<span class='ico16 affix_16'></span>" ;
        }
        //信息类型
        if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
            txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
        }
        //流程状态
        if(data.state !== null && data.state !=="" && data.state != "0"){
            txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
        }
        txt = txt +"</span>";
	 }
	 if(c == 7) {//自动评分
		 txt = "<a class='scoreA color_blue' onClick='openInfoScoreAutoMaticRecord(\""+data.infoId+"\")'>" + txt + "</a>" ;
	 } else if(c == 8) {//手工评分
		 txt = "<a class='scoreA color_blue' onClick='openInfoScoreManualRecord(\""+data.infoId+"\")'>" + txt + "</a>" ;
	 }
     return txt;
}

 var TimeFn = null;
 function clickRow(data, rowIndex, colIndex) {
	 if(colIndex == 7 || colIndex == 8) {
		 return;
	 }
	 var _url = _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Done&id="+data.infoId;
	 var title = data.subject;
	 doubleClick(_url,escapeStringToHTML(title));
}

function doubleClick(url,title){
	 var parmas = [$('#summary'),$('.slideDownBtn'),$('#listPending')];
	 showSummayDialogByURL(url,title,parmas);
}

function loadAClick() {
	$("#listPublishScore").find("tr").each(function() {

	});
}

var queryDialog;
function openQueryViews(listType){
    searchobj.g.clearCondition();
    queryDialog = $.dialog({
        url:  _ctxPath + "/info/infoMain.do?method=combinedQuery&listType="+listType,
        width: 500,
        height: 240,
        title: $.i18n('infosend.listInfo.combinedQuery'), //组合查询
        id:'queryDialog',
        transParams:[window],
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
                queryDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            btnType : 1,//按钮样式
            text: $.i18n("common.button.ok.label"),
            handler: function () {
                queryDialog.getReturnValue();
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
                queryDialog.close();
            }
        }]
    });
}

function loadFormData(o) {
	searchConditionObj = o;
    $('#'+o.listType).ajaxgridLoad(o);
}

/**
 * 执行手动评分
 */
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

				// values.currentScore
				// values.scoreTime
				// values.scoreUserId
				// values.scoreTypeIds
				// values.scoreUserName
				// values.scoreDesc
				values.infoIds = infoIds;
				values.scoreType="scoreForm";
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