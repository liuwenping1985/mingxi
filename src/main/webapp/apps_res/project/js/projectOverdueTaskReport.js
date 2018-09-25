function initTaskReport(){
	var taskInfoReportManager_=new taskInfoReportManager();
	var obj=$("#drillDownDiv").formobj();
	var reportResult=taskInfoReportManager_.getReportByAjax(obj);
	if(reportResult.gridData.table){
		$("#taskGridReport").html(reportResult.gridData.table);
		if($("#taskGridReport td").length==0){
			var str="<tr><td colspan='2' style='text-align:center'>没有可以显示的数据！</td></tr>";
			$("#taskGridReport tr").after(str);
		}
		$("[name='overdueT2'] a").css("color","red");
	}
}

function drillDownDetail(url){
	var body=$('#body', parent.parent.document);
	if(body.length>0){
		body.attr("src",_ctxPath+url);
		body.parent().css("margin-top","-8px");
	}
	var moreBody=$('#body', parent.document);
	if(moreBody.length>0){
		moreBody.attr("src",_ctxPath+url);
		moreBody.parent().css("margin-top","-8px");
	}
}

