// js开始处理
$(function(){
	pTemp.ajaxM = new publishInfoStcManager();
	pTemp.mode = {"news":$.i18n('news.stc.news.js'),"bbs":$.i18n('news.stc.bbs.js'),"bulletin":$.i18n('news.stc.bulletin.js'),"inquiry":$.i18n('news.stc.inquiry.js')};// 来源于那个模块
	pTemp.queryEnum  = ["publishNum","publishMember","clickNum","voteNum","state"];
	pTemp.stcWay = $("#stcWay"),pTemp.stcMember =$("#stcMember"),pTemp.stcBy =  $("#stcBy");
	pTemp.cndAreaDiv = $("#cndAreaDiv");
	pTemp.jval =  $.parseJSON(pTemp.jval);
	pTemp.year = pTemp.jval.year;
	// toolbar
	pTemp.TBar = $("#toolBar").toolbar(fnTBarArgs());
	fnPageInIt();
});

/**
 * 页面初始化
 */
function fnPageInIt(){
	fnInitComp();
	fnStcTypeRadioToggle();
	fnSetCss();
	fnRefreshTab();
	setTimeout(fnOK,400);
}

/**
 * table数据载入
 */
function fnRefreshTab(){
	var staticBodyDiv = $("#staticBodyDiv");
	staticBodyDiv.html($("#stcTabDiv").html());
	pTemp.tab = staticBodyDiv.find("#stcTab");
	pTemp.table = pTemp.tab.ajaxgrid(fnTabArgs());
}

function fnStcWayOnChange(){
	var stcWay = pTemp.stcWay.val();
	if(stcWay =="publishMember"){
		$(".stcToTh").show();
		$(".stcToThNull").hide();
	}else{
		$(".stcToTh").hide();
		$(".stcToThNull").show();
	}
	
	if(stcWay =="clickNum"||stcWay =="replyNum"||stcWay =="voteNum" ||stcWay =="state"){
		pTemp.stcBy.attr("checked",true);
		fnStcTypeRadioToggle();
		$("#stcTypeDiv").hide();
	}else{
		$("#stcTypeDiv").show();
	}
	
	if(pTemp.jval.isStcAccHide){
		$(".stcAcc").hide();
	}
	
	if(pTemp.jval.isStcDeptHide){
		pTemp.stcMember.attr("checked",true);
		$(".stcToTh").hide();
		$(".stcToThNull").show();
	}
	
}

/**
 * 页面样式控制
 */
function fnSetCss(){
	pTemp.title = pTemp.mode[pTemp.jval.mode] + $.i18n('news.stc.stcName.js');
	$("#stcTitle").html(pTemp.title);
	$(document).attr('title',pTemp.title);
	
	if(pTemp.jval.isStcAccHide){
		$(".stcAcc").hide();
	}
	
	if(pTemp.jval.isStcDeptHide){
		pTemp.stcMember.attr("checked",true);
		$(".stcToTh").hide();
		$(".stcToThNull").show();
	}
}

/**
 * 统计
 */
function fnOK(isGetCnd){
	// 取值，构造对象
	var stcCnd = pTemp.cndAreaDiv.formobj();
	// 校验日期是否正确
	if($("#stcByYear").attr("checked")=="checked"){
		if(parseInt(stcCnd.publishDateStart)>parseInt(stcCnd.publishDateEnd)){
			$.alert($.i18n('news.stc.date.is.big.js'));
			return;
		}
		
		if(parseInt(stcCnd.publishDateEnd) - parseInt(stcCnd.publishDateStart)>10){ 
			$.alert($.i18n('news.stc.date.toLong.js',10)); return; 
	  }
	}else if($("#stcByMonth").attr("checked")=="checked"){
		var sDate = fnToDate(stcCnd.publishDateStart),eDate = fnToDate(stcCnd.publishDateEnd);
		if(sDate.getTime() > eDate.getTime()){
			$.alert($.i18n('news.stc.date.is.big.js'));
			return;
		}
		
		if(((eDate.getTime()-sDate.getTime())/1000/60/60/24/30)>36){
			$.alert($.i18n('news.stc.month.toLong.js',36)); return; 
		}
	}else{
		if(fnToDate(stcCnd.publishDateStart).getTime()>fnToDate(stcCnd.publishDateEnd).getTime()){
			$.alert($.i18n('news.stc.date.is.big.js'));
			return;
		}
	}
	
	//处理raido
	var stcTos = ["Member","Dept","Acc"];
	for ( var i = 0; i < stcTos.length; i++) {
		if(stcCnd["stc"+stcTos[i]]!=null){
			stcCnd.stcTo= stcTos[i].toLowerCase();
			break;
		}
  }
	var timeTos = ["Month","Year"];
	stcCnd.stcBy ="day";
	for ( var i = 0; i < timeTos.length; i++) {
		if(stcCnd["stcBy"+timeTos[i]]!=null){
			stcCnd.stcBy = timeTos[i].toLowerCase();
			break;
		}
  }
	
	//处理参数
	stcCnd.spaceType=pTemp.jval.spaceType;
	stcCnd.spaceId=pTemp.jval.spaceId;
	stcCnd.typeId=pTemp.jval.typeId;
	stcCnd.isGroupStc=pTemp.jval.isGroupStc;
	stcCnd.mode =pTemp.jval.mode;
	
	if(isGetCnd){
		return stcCnd;
	}
	fnRefreshTab();
	pTemp.tab.ajaxgridLoad(stcCnd);
}

/**
 * 重置
 */
function fnCancel(){
	pTemp.stcWay.val("publishNum");
	pTemp.stcMember.attr("checked",true);
	pTemp.stcBy.attr("checked",true);
	$("#stcTypeDiv").show();
	fnStcTypeRadioToggle();
	fnStcWayOnChange();
}

/**
 * 数据导出
 */
function fnExp(){
	var stcCnd = fnOK(true);
	stcCnd.title = pTemp.title;
	$("#btnOK").jsonSubmit({
		action : _path + "/newsData.do?method=stcExpToXls",
		paramObj:stcCnd,
    callback: function() {
    }
  });
}

/**
 * 转发协同
 */
function fnSendToColl(){
	var tabHtml = fnTabCSSChange(fnPrint(true).tabHtml);
	$("#stcTitle4sendToColl").html(pTemp.title);
	$("#formTitle").val(pTemp.title);
	$("#formContent").val($("#sendToCollTitleDiv").html()+tabHtml);
	var winMain = opener.window.top.main;
	winMain.document.write($("#formDiv").html());
	winMain.sendToCol.submit();
	setTimeout(function(){window.close();},300);
}

/**
 * 打印
 */
function fnPrint(isHtml){
	var titleDiv = $($("#stcTitleDiv").html());
	var tabHtml = titleDiv.find("#staticBodyDiv").html();
	titleDiv.find("#prindClearTr").find("td").html("");
	titleDiv.find("#staticBodyDiv").html("");
	
	var titleHtml = titleDiv.html().replace(/stadic_layout_head/gi,""); 
	var titlePft = new PrintFragment("",titleHtml);
	var tablePft = new PrintFragment("",tabHtml);
	var cssList = new ArrayList();
	var contentList = new ArrayList();
	contentList.add(titlePft);
	contentList.add(tablePft);
	if(isHtml==true){
		return {"titleHtml":titleHtml,"tabHtml":tabHtml};
	}
	printList(contentList,cssList);
}

/**
 * 统计方式click事件
 */
function fnStcTypeRadioToggle(){
	 setTimeout(function(){// 延迟200毫秒执行
		 $("#publishDateTab").remove();
		 var publishDateParentTab = $("#publishDateParentTab");
		 if ($("#stcTypeDiv input[id=stcByMonth]").attr("checked") === "checked") {// 按月汇总
			 publishDateParentTab.html(pTemp.dateMonthCndTabHtml);
			 $("#publishDateStart").val(pTemp.jval.publishDateStart.substring(0,pTemp.jval.publishDateStart.length-3));
			 $("#publishDateEnd").val(pTemp.jval.publishDateEnd.substring(0,pTemp.jval.publishDateEnd.length-3));
		 }else if($("#stcTypeDiv input[id=stcByYear]").attr("checked") === "checked"){// 按年汇总
			 publishDateParentTab.html(pTemp.dateYearCndTabHtml);
			 $("#publishDateStart").val(pTemp.year-2);
			 $("#publishDateEnd").val(pTemp.year);
			 if(v3x.isMSIE7){
				 $("#publishDateSelectTab").attr("border","1");
			 }
		 }else{// 汇总
			 publishDateParentTab.html(pTemp.dateDayCndTabHtml);
			 $("#publishDateStart").val(pTemp.jval.publishDateStart);
			 $("#publishDateEnd").val(pTemp.jval.publishDateEnd);
		 }
		 $(".mycal").each(function(){$(this).comp();});
	 },200);
}

/**
 * 初始化组件为默认值
 */
function fnInitComp(){
	if(!pTemp.initDateComp){// 缓存日期组件
		 var compByMonth = "type:'calendar',ifFormat:'%Y-%m'",publishDate = $("#publishDateTab").find("#publishDateStart,#publishDateEnd");
		 // 初始化日期
		 $("#publishDateTab").find("#publishDateStart").val(pTemp.jval.publishDateStart);
		 pTemp.dateDayCndTabHtml = $("#publishDateTab").html();
		 publishDate.attr("comp",compByMonth);
		 pTemp.dateMonthCndTabHtml = $("#publishDateTab").html();
		 // 年份准备，现在年份 2014-27 --2014+2
		 var optionHtml="";
		 for ( var i = (pTemp.year-27); i < (pTemp.year+1); i++) {
			 optionHtml+="<option value='"+i+"'>"+i+"</option>"
     }
		 $("#publishDateSelectTab").find("#publishDateStart,#publishDateEnd").html(optionHtml);
		 pTemp.dateYearCndTabHtml = $("#publishDateSelectTab").html();
		 pTemp.initDateComp = true;
	 }
}

function fnTBarArgs(){
	return {
		"isPager" : false,
	  toolbar : [ {
	    id : "sendToColl",
	    name : $.i18n('news.stc.sendToColl.js'),
	    className : "ico16 forwarding_16",
	    click : function(){
		    fnSendToColl();
	    }
	  },{
	    id : "export",
	    name : $.i18n('news.stc.export.xls.js'),
	    className : "ico16 export_excel_16",
	    click : function(){
		    fnExp();
	    }
	  }, {
	    id : "print",
	    name : $.i18n('news.stc.print.js'),
	    className : "ico16 print_16",
	    click : function(e){
		    e.id = this.id;
		    fnPrint(e);
	    }
	  }]
	};
}

function fnTabArgs(){
	return {
    "vresize" : false,
    "isHaveIframe" : false,
    "usepager" : false,// 是有翻页条
    "showTableToggleBtn" : false,
    "vChange" : true,
    "slideToggleBtn" : false,// 上下伸缩按钮是否显示
    "parentId" : "staticBodyDiv",// grid占据div空间的id
    "resizable" : false,// 明细页面的分隔条
    "customize":false,
    "render":fnColRender,
    "managerName" : "publishInfoStcManager",
    "managerMethod" : pTemp.jval.mode + "Stc",
    "vChangeParam" : {
        overflow : "hidden",
        autoResize : true
    },
    "colModel":fnTabColModel()};
}

function fnTabColModel(){
	var stcWay = pTemp.stcWay.val();
	if(stcWay=='publishNum'){
		return [
		        {
		          display :$.i18n('news.stc.time.js'),
		          name : 'stcTime',
		          width : '48%',
		          sortable : true,
		          align : 'left'
		      },
		      {
		          display : $.i18n('news.stc.num.js'),
		          name : 'stcNum',
		          width : '50%',
		          sortable : true,
		          align : 'left'
		      }];
	}else if(stcWay=='publishMember'){
		var colModel = [{
      display :$.i18n('news.stc.accName.js'),
      name : 'accName',
      width : '20%',
      sortable : true,
      align : 'left'
		},{
      display :$.i18n('news.stc.deptName.js'),
      name : 'deptName',
      width : '20%',
      sortable : true,
      align : 'left'
		},{
      display :$.i18n('news.stc.memberName.js'),
      name : 'memberName',
      width : '10%',
      sortable : true,
      align : 'left'
		},{
      display :$.i18n('news.stc.num.js'),
      name : 'stcNum',
      width : '38%',
      sortable : true,
      align : 'left'
		}];
		if($("#stcMember").attr("checked")=="checked"){
		}else if($("#stcDept").attr("checked")=="checked"){
			colModel = arrayDel(colModel,2);
		}else if($("#stcAcc").attr("checked")=="checked"){
			colModel = arrayDel(arrayDel(colModel,1),1);
		}
		
		// 不是集团统计
		if(!pTemp.jval.isGroupStc||pTemp.jval.isStcAccHide){
			colModel = arrayDel(colModel,0);
		}
		
		// 普通汇总，按月汇总，按年汇总
		if($("#stcByMonth").attr("checked")=="checked"){
			colModel = fnStcBy('month',colModel);
		}else if($("#stcByYear").attr("checked")=="checked"){
			colModel = fnStcBy('year',colModel);
		}
		return colModel;
		
	}else if(stcWay=='clickNum'||stcWay=='voteNum'||stcWay=='replyNum'){
		var numName = {'clickNum':$.i18n('news.stc.clickNum.js'),'voteNum':$.i18n('news.stc.voteNum.js'),'replyNum':$.i18n('news.stc.replayNum.js')};
		var colModel = [{
      display :$.i18n('news.stc.title.js'),
      name : 'stcTitle',
      width : '50%',
      sortable : true,
      align : 'left'
		},{
      display :$.i18n('news.stc.publish.user.js'),
      name : 'memberName',
      width : '25%',
      sortable : true,
      align : 'left'
		},{
      display :numName[stcWay],
      name : 'stcNum',
      width : '23%',
      sortable : true,
      align : 'left'
		}];
		return colModel;
	}else if(stcWay=='state'){
		var colModel = [{
      display :$.i18n('news.stc.state.js'),
      name : 'state',
      width : '20%',
      sortable : true,
      align : 'left'
		},{
      display :$.i18n('news.stc.num.js'),
      name : 'stcNum',
      width : '78%',
      sortable : true,
      align : 'left'
		}];
		return colModel;
	}
	return [];
}
/**
 * 动态构造日期间隔列
 * 
 * @param type
 * @param colModel
 */
function fnStcBy(type,colModel){
	var year2month={'year':$.i18n('news.stc.year.js'),'month':$.i18n('news.stc.month.js')};
	// 删除最后一列数量
	colModel = arrayDel(colModel,colModel.length-1);
	// 追加数量
	var stcCnd = pTemp.cndAreaDiv.formobj();
	if(type=='month'){
		var publishDateStart = fnToDate(stcCnd.publishDateStart),publishDateEnd = fnToDate(stcCnd.publishDateEnd);
		var monthNum = parseInt(parseFloat(Math.abs(publishDateEnd.getTime()-publishDateStart.getTime())/1000/60/60/24/30).toFixed(0))+1;
		var cDate = new Date();
		
		if(year2month.year=='year'){
			year2month.year="-",year2month.month="";
		}
		
		for ( var i = 0; i < monthNum; i++) {
			cDate.setTime(publishDateEnd.getTime());
			cDate.setMonth(cDate.getMonth()-i);
			var strDate = cDate.format('yyyy'+year2month.year+'MM'+year2month.month);
			colModel.push({
	      display :strDate,
	      name : 'stcNum'+cDate.format('yyyyMM'),
	      width : '120',
	      sortable : true,
	      align : 'center'
			});
    }
	}else if(type=='year'){
		var sYear = parseInt(stcCnd.publishDateStart),eYear = parseInt(stcCnd.publishDateEnd);
		var yearNum = eYear - sYear +1;
		
		if(year2month.year=='year'){
			year2month.year="",year2month.month="";
		}
		
		for ( var i = 0; i < yearNum; i++) {
			colModel.push({
	      display :(eYear-i)+year2month.year,
	      name : 'stcNum'+(eYear-i),
	      width : '120',
	      sortable : true,
	      align : 'center'
			});
		}
	}
	return colModel;
}

function fnColRender(text, row, rowIndex, colIndex, col){
  if (text == null) {
  	return (col.name.indexOf("stcNum")!=-1) ? "0":"";
  }
  
  if(col.name == "state"){
  	if(text!=null){
  		var state = parseInt(text),mode = pTemp.jval.mode;
    	if(mode =="news"||mode=="bulletin"||mode =="bbs"){
    		return state == 100 ? $.i18n('news.stc.piged.js') : $.i18n('news.stc.published.js');
    	}else if(mode =="inquiry"){
    		switch (state) {
        case 5:
	        text = $.i18n('news.stc.ended.js');
	        break;
        case 8:
	        text = $.i18n('news.stc.published.js');
	        break;
        default:
        	text = $.i18n('news.stc.piged.js');
	        break;
        }
    	}
  	}
  }
  
  if(text==null){
  	return "";
  }
  
  return text;
}

function arrayDel(arr,index){
	if(index<0){
		return arr;
	}else{
		return arr.slice(0,index).concat(arr.slice(index+1,arr.length));
	}
}

function fnToDate(str) {
	var date = new Date();
	try {
		if (str instanceof Date) {
			return str;
		} else {
			var year = 1900, month = 0, day = 1, hour = 0, minute = 0, second = 0, dateStrs = '', timeStrs = '';
			var tempStrs = str.split(" ");
			if (tempStrs.length >= 1) {
				dateStrs = tempStrs[0].split("-");
				year = parseInt(dateStrs[0], 10);
				month = parseInt(dateStrs[1], 10) - 1;
				if(dateStrs.length == 3){
					day = parseInt(dateStrs[2], 10);
				}
			}
			
			if (tempStrs.length >= 2 && (tempStrs[1].length == 5 || tempStrs[1].length == 8)) {
				timeStrs = tempStrs[1].split(":");
				hour = parseInt(timeStrs[0], 10);
				minute = parseInt(timeStrs[1], 10);
				if (tempStrs[1].length == 8) {
					second = parseInt(timeStrs[2], 10);
				}
			}
		}
		date = new Date(year, month, day, hour, minute, second);
	} catch (e) {
	}
	return date;
}

/**
 * 拖动列表打印样式替换
 */
function fnTabCSSChange(sTabHtml) {
	var tabHtml = $("<div>"+sTabHtml+"</div>");
  var mxtgrid = tabHtml.find(".flexigrid");
  if(mxtgrid.length > 0 ){
  		tabHtml.find(".flexigrid a").removeAttr('onclick');
  		tabHtml.find(".hDivBox thead th div,.bDiv tbody td div").each(function(){
          var _html = $(this).html();
          $(this).parent().html(_html);
      });
      
      var tablHeader = tabHtml.find(".hDivBox thead");
      var tableBody = tabHtml.find(".bDiv tbody");
      var headerHtml = tablHeader.html();
      var bodyHtml = tableBody.html();
      
      if(headerHtml == null || headerHtml == 'null'){
      	headerHtml ="";
      }
      
      if(bodyHtml == null || bodyHtml=='null'){
          bodyHtml = "";
      }
      
      var toColTabHtml = "";
      toColTabHtml+="<table class='table-header-print " + (mxtgrid.hasClass('dataTable') ? "table-header-print-dataTable":"") 
      + "' border='0' cellspacing='0' cellpadding='0'><thead>"
      toColTabHtml += headerHtml + "</thead><tbody>" + bodyHtml + "</tbody></table>";
      return toColTabHtml;
  }else{
  	return sTabHtml;
  }
}