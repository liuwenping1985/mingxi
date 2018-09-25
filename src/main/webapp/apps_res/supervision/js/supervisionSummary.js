var arrTop=["3px","-72px","74px","-95px","100px","-74px","72px","3px"];
var arrLeft=["-90px","-62px","-62px","5px","5px","70px","70px","100px"];
/**以下方法是在事项查看summary_supervision.jsp页面调用**/
$(function(){
	//6-29 计算基本情况页面的高度
	//获得屏幕的高度
	var clientHeight=parseInt(document.documentElement.clientHeight);
	$(".xl-body").css("height",clientHeight+"px");
	//form-main的高度-54px的表头，10px的外边距,下方留20px的边距
	var formHeight=clientHeight-54-10-20;
	$(".xl-body .form-main").css("height",formHeight+"px");
	//iframe的高度为-72px的页签，10px的边距
	var frameHeight=formHeight-72-10;
	$("#frametable").css("height",frameHeight+"px");

	initDataNum();

	//默认隐藏快捷功能所有图标
	$(".xl-menu").find("div").hide();
	
	//为页签添加单击事件
	$(".form-thead>li").click(function(index){
	    $(this).addClass("bg_click").siblings(".bg_click").removeClass("bg_click");
	    var index=$(this).index();
	    var url="";
	    if(index==0){
	    	url=_ctxPath+"/content/content.do?method=index&isFullPage=true&moduleId="+moduleId+"&moduleType="+moduleType+"&rightId="+rightId+"&contentType=20&viewState="+viewState;
	    }else{
	    	 var tableName=$(this).find("a").attr("id");
	    	 var dmethod=$(this).find("a").attr("dmethod");
	    	 if(dmethod=='' || dmethod==undefined || dmethod=='undefined'){
	    		 dmethod="";
	    	 }
	         url=_ctxPath+"/supervision/supervisionController.do?method="+dmethod+"formsonList&tableName="+tableName+"&masterDataId="+moduleId;
	    }
	    document.getElementById("frametable").src=url;
	});

	var isAtten=$("#isAttention").val();
	initAttention(isAtten);
	
	if(rCode=='' || supType=='' || supType=='70' || supType=='80' || (rCode=='F20_SuperviseStaffSpace' && supType >=0 && supType<10)){
		$(".quick-menu").hide();
	}else if(rCode=='F20_ResponsibleUnitSpace' && isUndertaker=='false' && isSuperviseUser=='false'){//承办空间，非承办人，非督办人（主要判断的是分解事项）
		$(".quick-menu").hide();
	}else if(rCode=='F20_SuperviseStaffSpace' && isSuperviseUser=='false'){//督办空间，非督办人（主要判断的是分解事项）
		$(".quick-menu").hide();
	}else if(isWriteOff()){
		$(".quick-menu").hide();
	}else{
	    $(".add").click(function(){
	    	$(".xl-mask").toggleClass("xl-mask-hidden");
	        $(this).toggleClass("add_click");
	        $(".xl-menu").toggleClass("xl-menu-hidden");
	        
	        var displayDiv=new Array();
	        if(rCode=='F20_SuperviseStaffSpace'){//督办人空间
	        	//1.催办
	        	displayDiv.push("urgeDiv");
	        	//2.评价、催办(签收后)
	        	if(isProgressSign()){
	        		displayDiv.push("evaluateDiv");
	        		if(schedule==1){//判断反馈进度是否到达100%
	        			displayDiv.push("writeOffDiv");
	        		}
	        	}
	        }else if(rCode=='F20_SuperviseLeaderSpace'){//督办领导
	        	//1.关注、批示
	        	displayDiv.push("concernDiv");
	        	displayDiv.push("instructionsDiv");
	        	//2.关注、批示、评价（分管领导）
	        	if(cantonalLeaderState=='true' && isProgressSign()){
	        		displayDiv.push("evaluateDiv");
	        	}
	        }else if(rCode=='F20_ResponsibleUnitSpace'){//承办人空间
	        	//承办空间需要判断，如果是二级事项，当前登录人是此事项的创建人和承办人，则显示评价、销账、催办、签收、计划、自评、变更、反馈
	    		//如果登录人是此事项的承办人，则显示签收、计划、自评、变更、反馈
	    		//如果登录人是此事项的创建人，则显示评价、销账、催办
	        	if(isWaitSign()){//待签收
	        		displayDiv.push("signDiv");
	        	}
	    		if(isProgressSign() && isBreakSupervise=='true' && isUndertaker=='true' && isSuperviseUser=='false'){
	    			//登录人是此事项的承办人，并且状态是进行中，则显示计划、自评、变更、反馈
	    			displayDiv.push("planDiv");
	    			displayDiv.push("changeDiv");
	    			displayDiv.push("self_evaluateDiv");
	    			displayDiv.push("feedbackDiv");
	    		}else if(isBreakSupervise=='true' && isUndertaker=='true' && isSuperviseUser=='true'){//当前登录人是此事项的创建人和承办人
	    			displayDiv.push("urgeDiv");//催办
	    			if(isProgressSign()){//进行中 显示计划、变更、自评、反馈、评价、催办
	    				displayDiv.push("planDiv");
	    				displayDiv.push("changeDiv");
	    				displayDiv.push("self_evaluateDiv");
	    				displayDiv.push("feedbackDiv");
	    				displayDiv.push("evaluateDiv");
	    			}
	    			if(schedule==1){//判断反馈进度是否到达100%
	        			displayDiv.push("writeOffDiv");
	        		}
	    		}else if(isBreakSupervise=='true' && isUndertaker=='false' && isSuperviseUser=='true'){//登录人是此事项的创建人 则显示评价、销账、催办
	    			//1.催办
		        	displayDiv.push("urgeDiv");
		        	//2.评价、催办(签收后)
		        	if(isProgressSign()){
		        		displayDiv.push("evaluateDiv");
		        		if(schedule==1){//判断反馈进度是否到达100%
		        			displayDiv.push("writeOffDiv");
		        		}
		        	}
	    		}else{//一级事项承办人
	    			if(isProgressSign()){//进行中
	    				//登录人是此事项的承办人，并且状态是进行中，则显示计划、自评、变更、反馈
		    			displayDiv.push("planDiv");
		    			displayDiv.push("changeDiv");
		    			displayDiv.push("self_evaluateDiv");
		    			displayDiv.push("feedbackDiv");
	    			}
	    		}
	        }
	        //解析displayDiv
	        if(displayDiv && displayDiv.length>0){
	        	for(var i=0;i<displayDiv.length;i++){
	        		var divName=displayDiv[i];
	        		$("."+divName).css("top",arrTop[i]);
	        		$("."+divName).css("left",arrLeft[i]);
	        		$("."+divName).show();
	        	}
	        }
	    });
	}

	$("#concernMenu").find("p").click(function(){//关注
		if(isAttention()){
			$.ajax({
				url : _ctxPath + '/supervision/supervisionController.do?method=delAttention&timestamp=' + (new Date()).getTime(),
				data : {"tableName":"attention","masterDataId":masterDataId,"type":"del"},
				type:"post",
				success : function(data){
			    	var success=eval('('+data+')').success;
					if(success=='true'){
						//alert("取消成功");
						successmsg('取消成功');
						subCallBack('attention');
						initAttention('false');
					}
		    	}
			});
		}else{
		    $.ajax({
		        url : _ctxPath+'/supervision/supervisionController.do?method=saveSubTables&timestamp=' + (new Date()).getTime(),
		        data : {"tableName":"attention","masterDataId":masterDataId},
		        type:"post",
		        success : function(data){
		        	var success=eval('('+data+')').success;
					if(success=='true'){
						//alert("关注成功");
						successmsg('关注成功');
						subCallBack('attention');
						initAttention('true');
					}
		        }
		    });
		}
		
	});

	$(".write_off_menu").click(function(){//销账
		var cWindow = document.getElementById("frametable").contentWindow;
	    if(isWaitSign()){
			dbAlert("事项还未签收，不能销账！");
			return;
		}
	    if(isWriteOff()){
	    	dbAlert("事项已销账，不能重复销账！");
			return;
		}
	    if(schedule!=1){
	    	dbAlert("事项未完成，不能销账！");
			return;
		}
	    var offConfirm = dbConfirm({
            'msg':'该操作将同步影响分解事项，是否需要进行销账操作？',
            ok_fn: function () {
            	$.ajax({
        	        url : _ctxPath+'/supervision/supervisionController.do?method=updateState&field=field0126',
        	        data : {"masterDataId":masterDataId,"state":"offSign"},
        	        type:"post",
        	        success : function(data){
        	        	var success=eval('('+data+')').success;
        				if(success=='true'){
        					successmsg('销账成功');
            				$("#status").val('3');
            				subCallBack('basicInfo');
        					//销账后，隐藏快捷功能
        					$(".quick-menu").hide();
        				}else{
        					dbAlert("销账失败");
        				}
        	        }
        	    });
            }
        });
	});

	$(".evaluate_menu").click(function(){//评价按钮
	 	if((cantonalLeaderState || isSuperviseUser=='true')||(isBreakSupervise && isSuperviseUser=='true')){
	 		//事项的督办人或分管领导 || 二级事项的督办人
	 		if(isWriteOff()){
	 			dbAlert("事项已销账，不能进行评价！");
	 			return;
	 		}
	 		if(isWaitSign()){
	 			dbAlert("事项还未签收，不能进行评价！");
	 			return;
	 		}
	 		window.othervaluateWin = getA8Top().$.dialog({
		    	id:'othervaluate',
			    title:'<font class=\'dialog_title\'>评价</font>',
			    transParams:{'parentWin':window, "popWinName":"othervaluateWin", "popCallbackFn":window.subCallBack},
				url:  _ctxPath+"/supervision/supervisionController.do?method=enterOthervaluatePage&tableName=othervaluate&masterDataId="+masterDataId,
			    targetWindow:getA8Top(),
			    width:"500",
			    height:"345"
			});
	 	}else{
	 		dbAlert("没有评价权限！");
	 	}
	});

	$(".urge_menu").click(function(){//催办	    
	    if(!isSuperviseUser){//是否是当前事项的督办人
	    	dbAlert("没有催办权限！");
	    }
	    window.remindSupWin = getA8Top().$.dialog({
	    	id:'remindSup',
		    title:'<font class=\'dialog_title\'>催办</font>',
		    transParams:{'parentWin':window, "popWinName":"remindSupWin", "popCallbackFn":window.subCallBack},
		    url:  _ctxPath+"/supervision/supervisionController.do?method=enterHastenPage&tableName=hasten&masterDataId="+masterDataId,
		    targetWindow:getA8Top(),
		    width:"500",
		    height:"228"
		});
	});

	$(".instructions_menu").click(function(){//批示       

        //判断当前人是否为事项的分管领导
		/*
		 * 2017-6-10  经核实领导角色可以对主子事项进行批示，故先注释
		 * if(cantonalLeaders.indexOf(""+$.ctx.CurrentUser.id) == -1){
			alert("您不是分管领导，不能进行批示！");
			return;
		}*/
        window.commentsWin = getA8Top().$.dialog({
        	id:'commentsSup',
    	    title:'<font class=\'dialog_title\'>批示</font>',
    	    transParams:{'parentWin':window, "popWinName":"commentsWin", "popCallbackFn":window.subCallBack},
    	    url:  _ctxPath+"/supervision/supervisionController.do?method=enterSubTableEditPage&tableName=comments&masterDataId="+masterDataId,
    	    targetWindow:getA8Top(),
    	    width:"520",
    	    height:"260"
    	});
    });
	
	$(".sign_menu").click(function(){//签收
		var cWindow = document.getElementById("frametable").contentWindow;	   
	    if(isWriteOff()){
	    	dbAlert("事项已销账，不能进行签收！");
			return;
		}
		if(isProgressSign()){
			dbAlert("事项已签收，不能重复签收！");
			return;
		}
        var time=new Date().format("yyyy-MM-dd");
        $.ajax({
            url :_ctxPath+'/supervision/supervisionController.do?method=updateState&field=field0125',
            data : {"masterDataId":masterDataId,"state":"underWay","field0125":time},
            type:"post",
            success : function(data){
            	var success=eval('('+data+')').success;
    			if(success=='true'){
    				$("#status").val('2');
    				successmsg('签收成功');
    				subCallBack('basicInfo');
    			}else{
    				dbAlert("签收失败");
    			}
            }
        });
	});

	$(".plan_menu").click(function(){//计划
		//计划时判断事项状态是否已销账 待签收 登录人是事项承办人
		if(isWriteOff()){
			dbAlert("事项已销账，不能制定计划！");
			return;
		}
		if(isWaitSign()){
			dbAlert("事项还未签收，不能制定计划！");
			return;
		}	    
	    window.planWin = getA8Top().$.dialog({
	    	id:'plan',
		    title:'<font class=\'dialog_title\'>计划</font>',
		    transParams:{'parentWin':window, "popWinName":"planWin", "popCallbackFn":window.subCallBack},
		    url:  _ctxPath+"/supervision/supervisionController.do?method=enterPlanPage&tableName=plan&masterDataId="+masterDataId,
		    targetWindow:getA8Top(),
		    width:"530",
		    height:"330"
		});
	});

	$(".self_evaluate_menu").click(function(){//自评	    
	    if(isWriteOff()){
	    	dbAlert("事项已销账，不能进行自评！");
			return;
		}
		if(isWaitSign()){
			dbAlert("事项还未签收，不能进行自评！");
			return;
		}
	    window.selfevaluateWin = getA8Top().$.dialog({
	    	id:'selfevaluate',
		    title:'<font class=\'dialog_title\'>自评</font>',
		    transParams:{'parentWin':window, "popWinName":"selfevaluateWin", "popCallbackFn":window.subCallBack},
		    url:  _ctxPath+"/supervision/supervisionController.do?method=enterSubTableEditPage&tableName=selfevaluate&masterDataId="+masterDataId,
		    targetWindow:getA8Top(),
		    width:"480",
		    height:"228"
		});
	});

	$(".change_menu").click(function(){//变更
	    
	    if(isWriteOff()){
	    	dbAlert("事项已销账，不能进行变更！");
			return;
		}
		if(isWaitSign()){
			dbAlert("事项还未签收，不能进行变更！");
			return;
		}
		try{
			var supManager = new supervisionManager();
			var value = supManager.getTemplateBySupervise("change");
			if(typeof(value)=='undefined' || value==""){
				dbAlert("无法获取变更单，请联系表单管理员！");
				return;
			}
			var templateId=value.templateId;
			if(templateId==""){
				dbAlert("无法获取变更单，请联系表单管理员！",parent);
				return;
			}
			var relationField=value.relationField;
			if(typeof(relationField)=='undefined' || relationField==''){
				relationField='';
			}
			var url=_ctxPath+"/collaboration/collaboration.do?method=newColl&relationField="+relationField+"&templateId="+templateId+"&from=templateNewColl&operType=change&supType="+supType+"&masterDataId="+masterDataId;
			var app=value.app;
			var sub_app=value.sub_app;
			if(value.app!="" && value.sub_app!=""){
				url+="&contentDataId=&contentTemplateId=&oldSummaryId=&distributeAffairId=&app="+app+"&sub_app="+sub_app+"&forwardText=&forwardAffairId=&isFenbanFlag=false&curSummaryID=";
			}
			openCtpWindow({"url":url});
		}catch(e){
			dbAlert("无法获取变更单，请联系表单管理员！");
			return;
		}
	});
	
	$(".feedback_menu").click(function(){//反馈
		//反馈时判断事项状态是否已销账 待签收  登录人是事项承办人
		if(isWriteOff()){
			dbAlert("事项已销账，不能进行反馈！");
			return;
		}
		if(isWaitSign()){
			dbAlert("事项还未签收，不能进行反馈！");
			return;
		}
	    
	    window.feedbackWin = getA8Top().$.dialog({
	    	id:'feedbackWin',
		    title:'<font class=\'dialog_title\'>反馈</font>',
		    transParams:{'parentWin':window, "popWinName":"feedbackWin", "popCallbackFn":window.subCallBack},
		    url:  _ctxPath+"/supervision/supervisionController.do?method=enterFeedbackPage&tableName=feedback&masterDataId="+masterDataId,
		    targetWindow:getA8Top(),
		    width:"520",
		    height:"380"
		});
	});
})

function initField(){
	var cWindow = document.getElementById("frametable").contentWindow;
    $(cWindow.document).find("#field0100").hide();
	$(cWindow.document).find("#field0100_txt").hide();
	$(cWindow.document).find("#field0100_span").hide();

	$(cWindow.document).find("div[id^='attachment2Area']").css("border","1px solid #D7D7D7");

	if($(cWindow.document).find(".more").length>0){
		$(cWindow.document).find(".more").click(function(){
            $(this).toggleClass("down");
            if($(this).hasClass("down")){
                $(cWindow.document).find(".down_content").show();
            }else{
                $(cWindow.document).find(".down_content").hide();
            }
            $(cWindow.document).find("#field0019").css("width","316px");
        });
    }

	//销账时间
	$(cWindow.document).find("#field0126").css("width","324px");
	//会议视图 议定序号
	$(cWindow.document).find("#field0091").css("width","324px");
	//$(cWindow.document).find("span[height='auto']").css("height","100%");
	$(cWindow.document).find("span.xdRichTextBox").each(function(){
		$(this).css("height","25px");
	});

	var fieldIds=["field0025","field0019","field0026","field0028","field0014","field0023","field0089","field0090","field0101","field0030","field0151"];
	for(var i=0;i<fieldIds.length;i++){
		var oldWidth=$(cWindow.document).find("#"+fieldIds[i]).css("width");
		$(cWindow.document).find("#"+fieldIds[i]).css("width",(parseInt(oldWidth)+17)+"px");
	}
	//$(cWindow.document).find("#")
	//为log添加click事件
	$(cWindow.document).find(".log").click(function(){
		var url = _ctxPath + "/form/formData.do?method=showLog&single=true&recordId="+masterDataId+"&formId="+formId;
	     var dialog = $.dialog({
	         url: url,
	         title : $.i18n('log.record.single.label'),
	         width:850,
	         height:500,
	         targetWindow:getCtpTop(),
	         buttons : [{
	             text : $.i18n('form.trigger.triggerSet.confirm.label'),
	             id:"sure",
	             handler : function() {
	                 dialog.close();
	             }
	         }]
	     });
	});

	//事项查看信息
	$(cWindow.document).find(".more").click();
	
	//修改或查看时，如果上级事项不为空，添加穿透
	var pSupId=$("#field0131",cWindow.document).text();
	$(cWindow.document).find("#field0019_span").parent().show();
	if(pSupId!=''){
		var url=_ctxPath+"/supervision/supervisionController.do?method=formIndex&masterDataId="+pSupId+"&isFullPage=true&moduleId="+pSupId+"&moduleType=37&contentType=20&viewState=2";
		var pSupTitle=$("#field0019",cWindow.document).html();
		var pHtml="<a style=\"cursor: hand;\" title='"+pSupTitle+"' onclick=\"openDetailURL('"+url+"')\" class=\"hand\">"+pSupTitle+"</a>";
		$("#field0019",cWindow.document).html('');
		$("#field0019",cWindow.document).append(pHtml);
	}
}

function subCallBack(value){
	var cWindow = document.getElementById("frametable").contentWindow;
	if(value!=undefined && value!='undefined' && value!=''){
		if(value=='feedback'){
			$(".form-thead>li").find("a[id='basicInfo']").click();
			var scheduleValue=$("#field0028",cWindow.document).text();
			//schedule=parseInt(scheduleValue)/100;
			//alert(schedule);
		}
		$(".form-thead>li").find("a[id*='"+value+"']").click();
	}
	$(".add").click();
	//默认隐藏快捷功能所有图标
	$(".xl-menu").find("div").hide();
	//催办、关注、批示、签收、反馈、销账几种操作时刷新上级列表页面
	if(value!='undefined' && (value=='hasten' || value=='attention' || value=='basicInfo'|| value=='comments'||value=='feedback')){
		refreshListPage();
	}
	setTimeout(function(){
		$(".xl_success_hidden").removeClass("xl_success");
		$(".xl_success_hidden").hide();
	},2000);
}

function successmsg(msg){
	$(".xl_success_hidden>span").html(msg);
	$(".xl_success_hidden").addClass("xl_success");
	$(".xl_success_hidden").show();
}

function initDataNum(){
	//初始化所有的重复表数据条数

	if(attentionNum>0){
		$("#attentionNum").attr("class","urge_num");
		$("#attentionNum").text(attentionNum);
	}
	if(commentsNum>0){
		$("#commentsNum").attr("class","urge_num");
		$("#commentsNum").text(commentsNum);
	}
	if(changeNum>0){
		$("#changeNum").attr("class","urge_num");
		$("#changeNum").text(changeNum);
	}
	if(feedbackNum>0){
		$("#feedbackNum").attr("class","urge_num");
		$("#feedbackNum").text(feedbackNum);
	}
	if(evaluateNum>0){
		$("#evaluateNum").attr("class","urge_num");
		$("#evaluateNum").text(evaluateNum);
	}
	if(hastenNum>0){
		$("#hastenNum").attr("class","urge_num");
		$("#hastenNum").text(hastenNum);
	}
}
//初始化关注按钮的样式
function isAttention(){
	 var supManager = new supervisionManager();
	 var isAttention = supManager.isAttentionByCurUser(masterDataId);
	 return isAttention;
}
function isWriteOff(){
	//判断是否已销账
	var status=$("#status").val();
	if(status!='' && status=='3'){
		return true;
	}
	return false;
}
function isWaitSign(){
	//判断是否待签收
	var status=$("#status").val();
	if(status!='' && status=='0'){
		return true;
	}
	return false;
}
function isProgressSign(){
	//判断是否进行中
	var status=$("#status").val();
	if(status!='' && status=='2'){
		return true;
	}
	return false;
}

function initAttention(isAtten){
	if(isAtten=='true'){//已关注
		$("#concernMenu").find("p").removeClass("concern_menu").removeClass("concern_menu_click").addClass("cancel_concern_menu");
		$("#concernMenu").find("span").html('取消关注');
		$("#concernMenu").find("span").css("padding-left","0px");
	}else{
		$("#concernMenu").find("p").removeClass("cancel_concern_menu").removeClass("cancel_concern_menu_click").addClass("concern_menu");
		$("#concernMenu").find("span").html('关注');
		$("#concernMenu").find("span").css("padding-left","12px");
	}
}

//催办、关注、批示、签收、反馈、销账几种操作时刷新上级列表页面
function refreshListPage(){
	//获取上级ID，检查是否需要刷新二级页面
	try{
    	if(window.opener && (typeof window.opener.refreshFormDataPage != 'undefined')){
    		if(typeof(parentId)!='undefined' && parentId!=''){
    			window.opener.breakId=parentId;
    		}
    		window.opener.refreshFormDataPage();
    	}
	}catch(e){}
}
/**以上方法是在事项查看summary_supervision.jsp页面调用**/