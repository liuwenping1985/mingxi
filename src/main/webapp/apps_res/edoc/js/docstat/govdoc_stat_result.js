$(document).ready(function () {	
	 //切换统计维度时调用
	 $("#dataList a").click(function() {
		 var trObj = $(this).parent().parent();
		 var listType = $(this).attr("listType");
		 var displayName = trObj.attr("displayName");
		 var sfClickOn = trObj.attr("sfClickOn");
		 if(sfClickOn=='true'){//可以穿透
			 var listTitle = initTitle(trObj.attr("displayName"), listType);
			 var url = edocStatUrl + "?method=statToListGovdoc";
			 url += "&statId="+$("#statId").val();
			 url += "&statType="+$("#statType").val();
			 url += "&statRangeType="+$("#statRangeType").val();
			 url += "&statRangeId="+$("#statRangeId").val();
			 url += "&listType="+listType;
			 url += "&listTitle="+listTitle;
			 url += "&displayType="+trObj.attr("displayType");
			 url += "&displayId="+trObj.attr("displayId");
			 url += "&displayName="+trObj.attr("displayName");
			 url += "&startTime="+$("#startTime").val();
			 url += "&endTime="+$("#endTime").val();
			 url += "&docMark="+$("#docMark").val();
			 url += "&docMark_txt="+$("#docMark_txt").val();
			 url += "&serialNo="+$("#serialNo").val();
			 url += "&serialNo_txt="+$("#serialNo_txt").val();
			 url = encodeURI(url);
			 showSummayDialogByURL(url, listTitle);
		 }
	 });
	var sfClick = $("#dataList  tr:first").attr("sfClickOn");
	if(sfClick=='false'){
		$("#dataList  tr:first").children("td").each(function(i){ 
			$(this).html($(this).text());
	   }); 
	}
 });

//生成窗口标题
function initTitle(displayName, listType) {
	var reTitle = displayName;
	if(listType == "1") {
		reTitle += "发文数";
	} else if(listType == "3") {
		reTitle += "发文已办结";
	} else if(listType == "2") {
		reTitle += "发文办理中";
	} else if(listType == "4") {
		reTitle += "发文超期件数";
	} else if(listType =="5") {
		reTitle += "收文数";
	} else if(listType =="7") {
		reTitle += "收文已办结";
	} else if(listType =="6") {
		reTitle += "收文办理中";
	} else if(listType =="8") {
		reTitle += "收文超期件数";
	} else if(listType =="9"){
		reTitle += "总计";
	} else if(listType =="11"){
		reTitle += "已办结总计";
	} else if(listType =="10"){
		reTitle += "办理中总计";
	} else if(listType =="12") {
		reTitle += "超期件数总计";
	}
	reTitle += "穿透列表";
	return reTitle;
}

//打开对话窗口
var dialogDealColl;
function showSummayDialogByURL(url,title) {
  	var width = $(getA8Top().document).width() - 130;
  	var height = $(getA8Top().document).height() - 50;
  	dialogDealColl = $.dialog({
        url: url,
        width: width,
        height: height,
        title: title,
        id:'dialogDealColl',
        targetWindow:getCtpTop(),
        transParams: {'parentWin':window},
        closeParam: {
          'show':true,
          autoClose:false,
          handler:function(){
        	  dialogDealColl.close();
          }
        }        
    });
}