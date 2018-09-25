$(document).ready(function () {	
	 //切换统计维度时调用
	 $("#dataList a").click(function() {
		 var trObj = $(this).parent().parent();
		 var deptOrMemberId = trObj.attr("deptId");
		 var listType = trObj.attr("listType");
		 var type = $(this).attr("type");
		 var deptOrMName =trObj.attr("deptOrMName");
		 var statRangeType =trObj.attr("statRangeType");
		 var statRangeId =trObj.attr("statRangeId");
		 var ids = $(this).parent().children("input").val();
		 openStatResultDialog(deptOrMName,listType,deptOrMemberId,type,statRangeType,statRangeId,ids)
	 });
	
 });
//打开穿透列表
function openStatResultDialog(deptOrMName,listType,deptOrMemberId,type,statRangeType,statRangeId,ids) {
	var startTime = $("#checkSTime").val();
	var endTime = $("#checkETime").val();
	var checkDeptId = $("#checkDeptId").val();
	var statId = $("#statId").val();
	//生成打开窗口的标题
    var listTitle = initTitle(deptOrMName,type);
	var url = edocStatUrl + "?method=workStatEdocList&listTitle="+listTitle+"&listType="+listType+"&deptOrMemberId="+deptOrMemberId+"&type="+type+"&statRangeType="+statRangeType+"&statRangeId="+statRangeId+"&checkDeptId="+checkDeptId+"&statId="+statId+"&startTime="+startTime+"&endTime="+endTime+"&ids="+ids;
	showSummayDialogByURL(url, listTitle);
}
//生成窗口标题
function initTitle(deptOrMemberName,type){
	var reTitle = deptOrMemberName;
	if(type =="2"){
		reTitle +="发文数";
	}else if(type =="4"){
		reTitle +="发文已办结";
	}else if(type =="5"){
		reTitle +="发文办理中";
	}else if(type =="7"){
		reTitle +="发文超期件数";
	}else if(type =="10"){
		reTitle +="收文数";
	}else if(type =="11"){
		reTitle +="收文已办结";
	}else if(type =="12"){
		reTitle +="收文办理中";
	}else if(type =="14"){
		reTitle +="收文超期件数";
	}else if(type =="17"){
		reTitle +="总计";
	}else if(type =="18"){
		reTitle +="已办结总计";
	}else if(type =="19"){
		reTitle +="办理中总计";
	}else if(type =="21"){
		reTitle +="超期件数总计";
	}
	reTitle +="穿透列表";
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