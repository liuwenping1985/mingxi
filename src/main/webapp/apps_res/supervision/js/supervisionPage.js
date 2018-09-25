/**以下方法是在重复表编辑页面调用**/
window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递
function _closeWin(returnVal) {
	if(returnVal){
		if(transParams && transParams.popCallbackFn && returnVal){//该页面被两个地方调用
	        transParams.popCallbackFn(returnVal);
	    }else{
	    	window.returnValue = returnVal;
	    }
	}else{
		if(transParams && transParams.popCallbackFn){
	        transParams.popCallbackFn();
	    }
	}
	if (transParams && transParams.popWinName) {
		//列表中打开时需要刷新页面
		if(transParams.parentWin && typeof transParams.parentWin.refreshFormDataPage === 'function'){
				transParams.parentWin.refreshFormDataPage();
		}
		transParams.parentWin[transParams.popWinName].close();
	} else {
		window.close();
	}
}

function refreshCount(id,count){
	//获取父页面中存放条数的对象
	if(count>0){
		parent.document.getElementById(id).className="urge_num";
		parent.document.getElementById(id).innerHTML=count;
	}else{
		parent.document.getElementById(id).className="";
		parent.document.getElementById(id).innerHTML="";
	}
}
/**以上方法是在重复表编辑页面调用**/

function validatamsg(obj,path){
	if(typeof(path)=='undefined' || path==''){
		path=_ctxPath;
	}
	var errorClass=$(obj).find(".error-form");
	var initli="<li><img src=\""+path+"/apps_res/supervision/img/error.png\"><span>@title@</span></li>";
	var liHtml="";
	if(errorClass.length>0){
		$("#errorMsg>ul").html('');
		$("#errorTr").show();
		$(errorClass).each(function(){
			var title=$(this).attr("title");
			liHtml=initli.replace("@title@",title);
			$("#errorMsg>ul").html($("#errorMsg>ul").html()+liHtml);
		});
		//$("#errorMsg>ul").html(liHtml);
	}else{
		$("#errorTr").hide();
		$("#errorMsg>ul").html('');
	}
}

function sendsuccess(message){
	$(".xl_success_hidden>span",parent.document).html(message);
	$(".xl_success_hidden",parent.document).addClass("xl_success");
	$(".xl_success_hidden",parent.document).show();
}

function showSummaryCol(masterDataId,id,relationField,path){
   	try{
   		var dialogId = 'dialogDealColl';
       dialogDealColl = getA8Top().$.dialog({
           id:dialogId,
           url: path + "/supervision/supervisionController.do?method=showSummaryCol&masterDataId="+masterDataId+"&hastenId="+id+"&relationField="+relationField+"&dialogId="+dialogId,
           width: 1200,
           height: 800,
           title: "查看",
           targetWindow:getA8Top()
       });
   	}catch(e){
   	 alert(e.name + ": " + e.message);
   	}
}
$(function(){
	//调用此页面中的弹出框，标题颜色进行手动修改
})