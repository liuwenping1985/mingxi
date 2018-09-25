

var _grid = null;//信息评分标准列表

$(document).ready(function() {
	new MxtLayout({
        'id': 'layout',
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
	loadData();
});

//定义单击事件
function clickRow(data, rowIndex, colIndex) {
	if(colIndex == "0"){
		 return ;
	 }
}

/**
 * 单击checkBox触发事件
 * @param obj
 */
function clickCheckBox(obj) {
	var idAndValue = obj.value;
	var tempArray = idAndValue.split("|");
	parent.quoteDocumentSelected(obj, tempArray[0], tempArray[1]);
}

//定义双击事件
function doubleClickRow(data, rowIndex, colIndex) {
}

//回调函数
function rend(txt, data, r, c,col) {
	if(c === 1){
		txt ="<span class='grid_black'>"+txt+"</span>";
	}
	if(col.id === "id"){
		 txt = "<input type='checkbox' id='boxId"+data.id+"' onclick='clickCheckBox(this)' value='"+data.id+"|"+data.score+"'/>";
	 }
	 return txt;
}

//加载页面数据
function loadData() {
	//表格加载
	_grid = $('#scoreTypeList').ajaxgrid({
        colModel: [{
            //display: 'id',
        	id: "id",
            name: 'id',
            width: '5%',
            isToggleHideShow:false
        }, {
            display: $.i18n('infosend.score.database.name'),//信息评分标准名称
            name: 'name',
            sortable : true,
            width: '34%',
           isToggleHideShow:true
        }, {
            display: $.i18n('infosend.score.publish.level'),//刊登级别
            name: 'enumToString',
            sortable : true,
            width: '34%'
        }, {
            display: $.i18n('infosend.score.number'),//分数
            name: 'score',
            sortable : true,
            width: '15%'
        }, {
            display: $.i18n('infosend.score.state.label'),//状态
            name: 'currentState',
            sortable : true,
            width: '12%'
        }],
        click: clickRow,
        dblclick: doubleClickRow,
        render : rend,
//        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
//        vChange: true,
//        vChangeParam: {
//            overflow: "hidden",
//            autoResize:true
//        },
//        resizable : true,
//        slideToggleBtn: false,
//        
        height:300,
        managerName : "infoScoreManager",
        managerMethod : "getEnablePublishScoreList"
    });
    var o = new Object();
    $("#scoreTypeList").ajaxgridLoad(o);
}