var searchConditionObj;

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

var queryDialog;
function openQueryViews(openFrom){
    searchobj.g.clearCondition();
    queryDialog = $.dialog({
        url:  _ctxPath + "/info/magazinelist.do?method=magazineCombinedQuery&listType="+openFrom,
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
            text: $.i18n("common.button.ok.label"),
            btnType : 1,//按钮样式
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
    $('#'+o.listFrom).ajaxgridLoad(o);
}
