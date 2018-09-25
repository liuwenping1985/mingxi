
var searchInput = null;
var _oldStatWin = null;//老信息统计查看窗口

$(document).ready(function() {
	loadStyle();
	loadData();
	
	searchInput = new inputChange($("#searchName"), $.i18n('infosend.label.pleaseInputSubjuect'));//请输入标题
});

function loadStyle() {
	new MxtLayout({
		'id' : 'layout',
		'northArea' : {
			'id' : 'north',
			'height' : 30,
			'sprit' : false,
			'border' : false
		},
		'centerArea' : {
			'id' : 'center',
			'border' : false,
			'minHeight' : 20
		}
	});
}

/**
 * 如果数据为空,显示图片
 */
function showNoDataPic(){
	setTimeout(function(){
		var $ParentDiv = $("#listView").parent();
		var pHeight = $ParentDiv[0].offsetHeight;
		var pWidth = $ParentDiv[0].offsetWidth;
		var $PicTable = $("#__NoDataPicTable");
		if($PicTable.length < 1){
			var picTableHTML = '<div id="__NoDataPicTable" style="width: 179px;height: 65px;overflow: hidden;"><img align="middle" src="'+_ctxPath+'/apps_res/info/images/pic_none.png"/></div>';
			$PicTable = $(picTableHTML);
			$ParentDiv.append($PicTable);
		}
		
		var marginLeft = (pWidth - 179)/2;
		var marginTop = (pHeight - 65)/2;
		$PicTable.css({"margin-left": marginLeft + "px", "margin-top": marginTop + "px"});
		
		if(grid.p.total == 0){
			$PicTable.show();
			$("#listView").hide();
		}else{
			$("#__NoDataPicTable").hide();
			$("#listView").show();
		}
    },"500");
}

/**
 * 执行搜索
 */
function doSearch(){
//	if($("#searchName").val() == "请输入标题"){
//		$('#searchName').val("");
//	}
	
	var tempName = "";
	if(!searchInput.obj.hasClass(searchInput.color)){//没有内容
		tempName = $('#searchName').val();
	}
	
	 var o = new Object();
	 o.condition = "nameQuery";
	 o.name = tempName;
	 $("#listView").ajaxgridLoad(o);
	 showNoDataPic();
}

// 加载页面数据
var grid;
function loadData() {
	// 表格加载
	grid = $('#listView').ajaxgrid({
		colModel : [ {
			//display : $.i18n('infosend.magazine.auditPending.journalName'),// 期刊名称,//期刊名称
			name : 'nameAndTime',
			id:'id',
			sourceId:'sourceId',
			sortable : false,
			width : '99%'
		}],
		click : clickRow,
		dblclick: dbclickRow,
		render : rend,
		showTableToggleBtn : false,
		parentId : $('.layout_center').eq(0).attr('id'),
		vChange : false,
		vChangeParam : {
			overflow : "hidden",
			autoResize : true
		},
		resizable : false,
		slideToggleBtn : true,
		managerName : "magazineListManager",
		managerMethod : "getInfoMagazinePublishViewList"
	});
	
	 var o = new Object();
	 o.condition = "nameQuery";
	 o.name = "";
	 $("#listView").ajaxgridLoad(o);
	 showNoDataPic();
	 
	 //影藏表头
	 $(".nBtn,.nDiv, .hDiv,.cDrag").css("display", "none");
}

/**
 * 单击事件
 * @param data
 * @param rowIndex
 * @param colIndex
 */
function clickRow(data, rowIndex, colIndex) {
	
}

/**
 * 双击事件
 * @param data
 * @param rowIndex
 * @param colIndex
 */
function dbclickRow(data, rowIndex, colIndex) {
}

/**
 * 打开期刊查看
 */
var TimeFn = null;
function openMagazineDetail(magazineId, title){
	//取消上次延时未执行的方法
	 clearTimeout(TimeFn);
	 var _url = _ctxPath+"/info/magazine.do?method=summary&openFrom=viewPage&magazineId="+magazineId;
	 doubleClick(_url,title);
	 grid.grid.resizeGridUpDown('down');
}


function doubleClick(url,title){
	 var parmas = [$('#summary'),$('.slideDownBtn'),$('#listPending')];
	 showSummayDialogByURL(url,title,parmas);
}

function openStatDetail(statId, listType){
	
	var tempPageUrl = _ctxPath+"/info/infoStat.do?method=showInfoStatView&listType="+listType+"&statId="+statId;
	
	if("oldStatView" == listType){
		if(_oldStatWin && _oldStatWin.closed != true){
			_oldStatWin.close();
		 }
		_oldStatWin = window.open(tempPageUrl, "InfoStatWin");
	}else {
		var dialog = $.dialog({
		      url : tempPageUrl,
		      width : 800,
		      height : 400,
		      title :$.i18n('infosend.label.infoDetail'),//信息详情
		      targetWindow:window,
		      buttons : [{
		          text : $.i18n('collaboration.dialog.close'),
		          handler : function() {
		            dialog.close();
		          }
		      }]
		  });
	}
}

/**
 * 数据绑定事件
 * @param txt
 * @param data
 * @param r
 * @param c
 * @returns
 */
function rend(txt, data, r, c) {
	var tempType = data.type;
	//if(tempType == '0'){//期刊发布
	if(tempType == '0'){//期刊发布
		if(data.isOld){
			var tempName = escapeStringToHTML(escapeStringToHTML(data.name));
			txt = "<a class='scoreA color_blue' onClick='openMagazineList(\""+data.sourceId+"\", \""+tempName+"\", 4)'>" + txt + "</a>";
		}else{
			var tempName = escapeStringToHTML(escapeStringToHTML(data.name));
			txt = "<a class='scoreA color_blue' onClick='openMagazineDetail(\""+data.sourceId+"\", \""+tempName+"\")'>" + txt + "</a>" ;
		}
	}else if(tempType == '1'){//统计发布
		if(data.isOld){
			//展示老的信息数据
			txt = "<a class='scoreA color_blue' onClick='openStatDetail(\""+data.sourceId+"\", \"oldStatView\")'>" + txt + "</a>" ;
		}else{
			txt = "<a class='scoreA color_blue' onClick='openStatDetail(\""+data.sourceId+"\", \"showInfoStatView\")'>" + txt + "</a>" ;
		}
	}
    return txt;
}
