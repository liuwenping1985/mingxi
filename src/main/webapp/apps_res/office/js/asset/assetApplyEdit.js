// js开始处理
$(function() {
	pTemp.ajaxM = new assetUseManager();
	pTemp.useTab =  $("#assetUseTab");
	pTemp.applyDescTR = pTemp.useTab.find("#applyDescTR");//申请事由
	pTemp.auditContentTR = pTemp.useTab.find("#auditContentTR");//审核意见
	pTemp.assetHandleTab = $("#assetHandleTab");//处理意见tab
	pTemp.isCheckInfoState = "true";
	fnPageInIt();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	 var prompts = [];
	 prompts.push($("#assetNum").prompt({content: $.i18n('office.asset.assetUse.xzbgsb.js')}));
	 pTemp.prompts = prompts;
	//初始化
	pTemp.auditContentTR.hide();
	if (pTemp.jval != '') {
		pTemp.row = $.parseJSON(pTemp.jval);
		pTemp.workFlow = pTemp.row.workFlow;
		if (pTemp.row.assetNum != null) {
			pTemp.prompts[0].clearPrompt();
		}
		// 加载打开页面数据
		fnPageReload(pTemp.row);
	}
	//如果是打印
	var print = getURLParamPub("print");
	if(print == 'true'){
		$(".layout_center").css("height","");
	}
	
	if(parent.window.fnInitTBar){
		parent.window.fnInitTBar();
	}
}

/**
 * 页面刷新
 */
function fnPageReload(p) {
	pTemp.useTab.resetValidate();
	var operate = getURLParamPub("operate");
	if (operate != 'add' && operate != 'dLend') {
		pTemp.useTab.fillform(p);
		fnFillRadioPub($("#isOften"), p)
	}
	
	if(operate != 'dLend'){
		//选人组件回填
		$("#userDiv").comp({value : "Member|"+p.applyUser,text : p.applyUserName});
		$("#depDiv").comp({value : "Department|"+p.applyDept,text : p.applyDeptName});
	}else{
		$(".applyAmountClass").hide();
	}
	
	//审核意见显示
	if((p.state >= 1 && p.state != 35 && p.state != null) && operate != 'add' && operate != 'modify' && operate != 'dLend'){
  	pTemp.auditContentTR.show();
  }
	
	//审核意见的禁用
	if(p.state > 1 || operate != 'audit'){
		pTemp.auditContentTR.disable();
		pTemp.auditContentTR.find("#auditContent").removeClass("bg_color_white").addClass("bg_color");
	}
	
	
	if(operate != 'add' && operate != 'modify' && operate != 'dLend'){
		pTemp.useTab.disable();
	}
	
	//table
	if (((operate =='' || operate =='view') && (p.state == 10 || p.state == 15 || p.state == 20 || p.state == 30)/*普通人員查看*/)
			||(operate == 'lend') || (operate == 'remind')
			|| (operate == 'dLend')){
		pTemp.tab = officeTab().addAll(["operateType","amount","handleTime","handleUser","handleDesc"]).init("assetHandleTab", {
			 argFunc : "fnTabItem4Handle",
			 parentId : $('.layout_south').eq(0).attr('id'),
			 slideToggleBtn : false,// 上下伸缩按钮是否显示
			 resizable : false,// 明细页面的分隔条
			 usepager: false,
			 render:fnOperatRender,
			 onSuccess:fnTabLoaded
		});
		
		var tabRows = {rows:pTemp.row.handleLogs};
		if (pTemp.row.admin && ((operate == 'lend' && p.state == 5) 
				|| (operate == 'remind' && (p.state == 10 || p.state == 15)))
				|| (operate == 'dLend')){
			var oType = (p.state == 5) ? 0 : 1;
			tabRows.rows.push({id:'-188',handleUserName:$.ctx.CurrentUser.name,type:oType});
		}
		//table回填
	  pTemp.tab.reLoad(tabRows);
	}
	
	if(operate =='modify'){
		fnIsOften($("#isOften"));
	}
	pTemp.useTab.resetValidate();
}

function fnIsOften(_this){
	var useEndTimeDiv = $("#useEndTimeDiv");
	var isOften = $(_this).is(":checked");
	if(isOften){
		//缓存
		pTemp.useEndTimeObj = useEndTimeDiv.formobj();
		useEndTimeDiv.clearform();
		useEndTimeDiv.disable();
		useEndTimeDiv.find("input").removeClass("validate");
	}else{
		useEndTimeDiv.enable();
		useEndTimeDiv.fillform(pTemp.useEndTimeObj);
		useEndTimeDiv.find("input").addClass("validate");
	}
	pTemp.useTab.resetValidate();
}

/**
 * 打开选择设备
 */
function fnSelectAsset() {
	//如果不选人，按照当前人，如果选人，按照选择人员
	var applyUser = $("#applyUser").val();
	if (applyUser != "" && applyUser.length > 5) {
		applyUser = applyUser.split("|")[1];
		openSelectAssetWinPub(applyUser);
	} else {
		$.alert($.i18n('office.asset.apply.select.member.js'));
	}
}

/**
 * 选择设备确定回调函数
 */
function fnSelectAssetOK(p){
	var rows = p.okParam.rows;
	if(rows.length == 0){
		$.alert($.i18n('office.asset.assetApplyEdit.qxzbgsb.js'));
		return;
	}
	
	if(parseInt(rows[0].currentCount) == 0){
		var msg = $.i18n('office.asset.assetApplyEdit.gsbdqkcwsfqdysq.js');
		$.confirm({'msg': msg,
	    ok_fn: function () {
	    	pTemp.useTab.fillform(rows[0]);
				p.dialog.close();
	    }
		});
	}else{
		pTemp.useTab.fillform(rows[0]);
		p.dialog.close();
	}
	
	$("#assetNum").removeClass("color_gray");
}

/**
 * 选择设备确定取消回调函数
 */
function fnSelectAssetCancel(p){
	p.dialog.close();
}

/**
 * 申请，修改
 */
function fnOK(operate) {
	pTemp.prompts[0].clearPrompt();
	pTemp.useTab.resetValidate();	
	var isAgree = pTemp.useTab.validate();
	if (!isAgree){
		if(!v3x.isMSIE8 && !v3x.isMSIE7){//ie8,7 下不能用
			pTemp.prompts[0].prompt();
		}
		return {isAgree:false};
	}
	
	var assetUse = pTemp.useTab.formobj();
	var isOften = $("#isOften").is(":checked");
  if (fnParseDatePub(assetUse.useStartTime).getTime() >= fnParseDatePub(assetUse.useEndTime).getTime() && !isOften) {
    $.alert($.i18n('office.asset.assetApplyEdit.sbsydksrqbndydyjsrq.js'));
    return;
  }
  
  pTemp.assetUse = assetUse;
  openProcePub();
	pTemp.assetUse.applyUser = pTemp.assetUse.applyUser.split("|")[1];
	pTemp.assetUse.applyDept = pTemp.assetUse.applyDept.split("|")[1];
	if(getURLParamPub("operate") == "dLend"){
		 fnDLend('agree');
		 return;
	}
	pTemp.assetUse.operate = "check";
	pTemp.ajaxM.saveApply(pTemp.assetUse,{
		success : function(rval) {
			endProcePub();
			fnParseMsg(rval,"assetApply",true);
		},
    error : function(rval) {
    	endProcePub();
    	var msg = $.i18n('office.asset.assetApplyEdit.sqsb.js'),type = 'error';
    	fnMsgBoxPub(msg,type,function(){
    		fnReloadPagePub({page:"assetApply"});
				fnAutoCloseWindow();
			});
    }
	});
}

/**
 * 工作流预提交
 */
function workFlowPreSubmit() {
  preSendOrHandleWorkflow(window,"-1",pTemp.row.workFlow.workflowId,"-1","start", $.ctx.CurrentUser.id,"-1",$.ctx.CurrentUser.loginAccount,null,"office",null,window,"-1",fnWorkFlowCallSubmit);
}

/**
 * 工作流预提交回调提交
 */
function fnWorkFlowCallSubmit(){
	//工作流数据获取
	pTemp.assetUse.workFlow = $("#workFlowDiv").formobj();
	pTemp.ajaxM.saveApply(pTemp.assetUse,{
		success : function(rval) {
			endProcePub();
			rval.isWorkFlowCallBack = true;
			fnParseMsg(rval,"assetApply");
		},
    error : function(rval) {
    	endProcePub();
    	var msg = $.i18n('office.asset.assetApplyEdit.sqsb.js'),type = 'error';
    	fnMsgBoxPub(msg,type,function(){
    		fnReloadPagePub({page:"assetApply"});
				fnAutoCloseWindow();
			});
    }
	});
}

/**
 * 取消按钮
 */
function fnCancel() {
	var confirm = $.confirm({
    'msg': $.i18n('office.asset.assetApplyEdit.qdfqdqczm.js'),
    ok_fn: function () {
    	endProcePub();
    	fnAutoCloseWindow();
    }
	});
}

/**
 * 借出
 */
function fnLend(isAgree){
	var assetUse = fnCheckLendRemind(isAgree);
	if(assetUse.isError){
		return;
	}
	openProcePub();
	assetUse.isAgree = isAgree;
	assetUse.isCheckInfoState = pTemp.isCheckInfoState;
	if(isAgree == 'agree'){
		assetUse.type = 0;//借出
	}else{
			assetUse.type = 2;//不借出
	}
	
	pTemp.ajaxM.updateLendApply(assetUse,{
		success : function(rval) {
			fnParseMsg(rval,"assetHandle");
		},
    error : function(rval) {
    	endProcePub();
    	var msg = $.i18n('office.asset.assetApplyEdit.jcsb.js'),type = 'error';
    	fnMsgBoxPub(msg,type,function(){
    		fnReloadPagePub({page:"assetHandle"});
				fnAutoCloseWindow();
			});
    }
	});
}

function fnDLend(isAgree){
	if(isAgree == 'agree'){
		var _assetUse = fnCheckLendRemind(isAgree);
		if(_assetUse.isError){
			endProcePub();
			return;
		}
		var assetUse = pTemp.assetUse;
		assetUse.handleTime = _assetUse.handleTime;
		assetUse.handleDesc = _assetUse.handleDesc;
		assetUse.amount = _assetUse.amount;
		assetUse.isAgree = isAgree;
		if(isAgree == 'agree'){
			assetUse.type = 0;//借出
		}else{
				assetUse.type = 2;//不借出
		}
		
		pTemp.ajaxM.saveDLendApply(assetUse,{
			success : function(rval) {
				fnParseMsg(rval,"assetHandle");
			},
	    error : function(rval) {
	    	endProcePub();
	    	var msg = $.i18n('office.asset.assetApplyEdit.jcsb.js'),type = 'error';
	    	fnMsgBoxPub(msg,type,function(){
	    		fnReloadPagePub({page:"assetHandle"});
					fnAutoCloseWindow();
				});
	    }
		});
	}else{
		fnAutoCloseWindow();
	}
}

/**
 * 归还
 */
function fnRemind(){
	var assetUse = fnCheckLendRemind();
	if(assetUse.isError){
		return;
	}
	openProcePub();
	assetUse.type = 1;//归还
	pTemp.ajaxM.updateRemindApply(assetUse,{
		success : function(rval) {
			fnParseMsg(rval,'assetHandle');
		},
    error : function(rval) {
    	endProcePub();
    	var msg = $.i18n('office.asset.assetApplyEdit.ghsb.js'),type = 'error';
    	fnMsgBoxPub(msg,type,function(){
    		fnReloadPagePub({page:"assetHandle"});
				fnAutoCloseWindow();
			});
    }
	});
}

/**
 * 选人界面的回调
 */
function fnUserCallBack(rv) {
  var memberId = rv.obj[0].id;
  var member = getCtpTop().getObject("Member", memberId);
	if(member){//回填部门信息
		var dept = getCtpTop().getObject("Department",member.departmentId);
		if (dept) {
			var deptName = dept.name;
			//显示外单位
			if(dept.accountId != $.ctx.CurrentUser.loginAccount){
				var account = getCtpTop().getObject("Account",member.accountId);
				deptName += "("+account.shortname+")";
			}
			
			if($("#applyDept").val()==''){
				$("#depDiv").comp({value : "Department|"+dept.id,text : deptName});
			}
		}
	}
	//清空设备信息
	//$("#assetNum,#assetTypeName,#assetName,#assetBrand,#assetModel,#assetDesc").val("");
}

function fnParseMsg(rval,pageId,isCheck){
	endProcePub();
	var msg =$.i18n('office.asset.assetApplyEdit.clcg.js'),type = 'ok',isCloseWin=false,operate = getURLParamPub("operate")
	,callBackFunc=null,callBakArg=null;
	if (rval.state == "assetInfoModify") {
		//自己和管理员
		//选择的设备状态是维修中，确定要借出。点击确定，正常借出，点击取消，回到借出窗口
		type = "alert";
		if(pTemp.row.admin && operate=="lend"){
			msg = $.i18n('office.asset.assetApplyEdit.xzdsbzssqdyjc.js',rval.msg);
			type = "confirm";
			callBackFunc = fnLend;
			callBakArg = "agree";
			pTemp.isCheckInfoState = false;//不检查设备
		}else{
			type = "alert";
			if(operate == "dLend"){
				msg = $.i18n('office.asset.error.state.js');
			}else{
				msg = $.i18n('office.asset.assetApplyEdit.nxzdsbzsbxgbksqqzxxz.js');
			}
		}
	} else if (rval.state == "notEnough") {
		type = "alert";
		msg = $.i18n('office.asset.assetApplyEdit.dqsbkclbz.js');
	} else if (rval.state == "adminNoAcl4House") {
		type = "alert";
		msg = $.i18n('office.asset.assetApplyEdit.nyjmydqbgsbkdglqx.js');
		if (operate != "dLend") {
			isCloseWin = true;
		}
	}else if(rval.state == "NoAcl4House"){
		type = "alert";
		if(pTemp.row.admin && operate!="dLend"){
			msg = $.i18n('office.asset.assetApplyEdit.syzyjmydqsbkdsyqx.js');
		}else{
		  type = "confirm";
			msg = $.i18n('office.asset.assetApplyEdit.nyjmydqsbkdsyqxqdyzxxzsbm.js');
			if (operate == "dLend") {
				msg = $.i18n('office.asset.not.acl.for.dlent.js',$("#applyUser_txt").val());
			}
		}
	}else if(rval.state == "remindAmountBig"){
		type = "alert";
		msg = $.i18n('office.asset.assetApplyEdit.znsrdyqxydydghdsbsl.js');
	}else if(rval.state == "handled"){
		type = "alert";
		msg = $.i18n('office.asset.assetApplyEdit.gbgsbsqyjbcxhqsglycl.js');
	}
	
	if (type == 'ok') {
		if(pageId == 'assetHandle'){
			fnMsgBoxPub(msg, type,function(){
				fnReloadPagePub({page:pageId});
				fnAutoCloseWindow();
			});
		}else if(pageId == 'assetApply' && !rval.isWorkFlowCallBack){
				pTemp.assetUse.operate = getURLParamPub("operate");
			  workFlowPreSubmit();
		}else{
			fnReloadPagePub({page:pageId});
			fnAutoCloseWindow();
		}
	}else if(type == 'error'){
		fnMsgBoxPub(rmsg.msg, rmsg.type,function(){
			fnReloadPagePub({page:pageId});
			fnAutoCloseWindow();
		});
	}else if(type == 'confirm'){
			var confirm = $.confirm({
		    'msg': msg,
		    ok_fn: function () {
		    	if(callBackFunc){
		    		callBackFunc(callBakArg);
		    	}
		    },
		    cancel_fn:function() {
		    	fnReloadPagePub({page:pageId});
					fnAutoCloseWindow();
		    }
			});
	}else{
		fnMsgBoxPub(msg, type);
		if(isCloseWin){
			fnReloadPagePub({page:pageId});
			fnAutoCloseWindow();
		}
	}
}

function fnNotCheckOk(){
	//不检查用品状态
	pTemp.assetUse.operate = getURLParamPub("operate");
	workFlowPreSubmit();
}

function fnCheckLendRemind(isAgree){
	var hTime = pTemp.assetHandleTab.find("#handleTime").val(),desc = pTemp.assetHandleTab.find("#handleDesc").val();
	var applyAmount = pTemp.assetHandleTab.find("#amount").val(),operate = getURLParamPub("operate");
	
	if (hTime == null || hTime == '') {
		var sType = (operate == 'lend'||operate == 'dLend') ? $.i18n('office.asset.assetApplyEdit.jc.js'):$.i18n('office.asset.assetApplyEdit.gh.js');
		$.alert(sType + $.i18n('office.asset.assetApplyEdit.sjbnwk.js'));
		return {isError:true};
	}
	
	//校验归还时间
	if(operate != 'lend' && operate != 'dLend' && fnParseDatePub(hTime).getTime() < fnParseDatePub(pTemp.lendHandleTime).getTime()){
		$.alert($.i18n('office.asset.assetApplyEdit.ghsjdyjcsj.js'));
		return {isError:true};
	}	
	
	var lendMsg = $.i18n('office.asset.assetApplyEdit.znsrdyqxydysbkclznsrdyqxydydghdsbsl.js'),remindMsg = $.i18n('office.asset.assetApplyEdit.znsrdyqxydysbkclznsrdyqxydydghdsbs2.js'),reg =/^[1-9][0-9]{0,8}$/;
	if (!reg.test(applyAmount) && isAgree !='notAgree') {
		if(operate == 'lend'||operate == 'dLend'){
			$.alert(lendMsg);
		}else	if(operate == 'remind'){
			$.alert(remindMsg);
		}
		return {isError:true};
	}
	
	if(operate == 'lend' && isAgree !='notAgree'){
		if(parseInt(applyAmount) > pTemp.row.currentCount){
			$.alert(lendMsg);
			return {isError:true};
		}
	}
	
	if(operate == 'remind'){
		if(parseInt(applyAmount) > fnCountRemindAmount()){
			$.alert(remindMsg);
			return {isError:true};
		}
	}
	
	if (desc != null && desc.length > 600) {
		$.alert($.i18n('office.asset.assetApplyEdit.blsmzdcd.js'));
		return {isError:true};
	}
	
	var assetUse = {id:pTemp.row.id,assetApplyId:pTemp.row.id,operateType:operate,handleTime:hTime,handleDesc:desc,amount:applyAmount};
	return assetUse;
}

//计算已归还的数量
function fnCountRemindAmount(){
	var rows = pTemp.row.handleLogs, remindAmount = 0, lendAmount = 0;
	for (var i = 0; i < rows.length; i++) {
		var row = rows[i];
		if(row.type == 1 && row.amount != null){
			remindAmount += row.amount;
		}
		
		if(row.type == 0){
			lendAmount += row.amount;
		}
	}
	return lendAmount - remindAmount ;
}

function fnOperatRender(text, row, rowIndex, colIndex, col){
	var _text = (text == null) ? "" : text;
	
	if(row.id =='-188'){
		if (col.name === 'amount') {
			var applyAmount = '';
			if(row.type == 0){//借出
				applyAmount = pTemp.row.applyAmount;
			}else{
				applyAmount = fnCountRemindAmount();
			}
			return "<input id='amount' value='"+applyAmount+"' style='width:65px;' class='font_size12' type='text' maxlength='9'>";
		}
		
		if (col.name === 'handleTime') {
			return "<div class='common_txtbox_wrap clearfix'><input id='handleTime' value ='"+pTemp.row.now+"' class='font_size12' type='text' readonly></div>";
		}
	}
	
	if (col.name === 'type') {
		if(row.type == 0){
			//缓存借出日期
			pTemp.lendHandleTime = row.handleTime;
			_text = $.i18n('office.asset.assetApplyEdit.jc.js');
		}else if(row.type == 1){
			_text = $.i18n('office.asset.assetApplyEdit.gh.js');
		}else{
			_text = $.i18n('office.asset.assetApplyEdit.bjc.js');
		}
	}
	
  return _text;
}

/**
 * 直接借出-申请数量与借出数量联动
 */
function fnAmountChange(){
	var operate = getURLParamPub("operate");
	if(operate == 'dLend'){
		$("#amount").val($("#applyAmount").val());
	}
}

function fnTabLoaded(){
	var operate = getURLParamPub("operate");
	if(pTemp.row.admin && ((operate =='lend' && pTemp.row.state == 5) 
		|| (operate =='remind' && (pTemp.row.state == 10 || pTemp.row.state ==15 ))
		||(operate =='dLend'))){
		var tab = $("#assetHandleTab");
		var editRow = tab.find("#row-188");
		editRow.unbind();
		editRow.attr("height","62");
		editRow.find("td div").last().css("height","58px").html("<textarea id='handleDesc' style='width: 90%; height: 45px;' class='font_size12 padding_5 margin_r_5'></textarea>");
		
		editRow.find("#handleTime").calendar({
			 ifFormat : '%Y-%m-%d %H:%M',
			 showsTime : true
	  });
	}
}

function fnTabItem4Handle(){
 return {
		 "operateType" : {
	       display : $.i18n('office.asset.assetApplyEdit.czlx.js'),
	       name : 'type',
	       width : '60',
	       sortable : false,
	       align : 'center'
	   },
	   "amount" : {
		       display : $.i18n('office.asset.assetStcInfoShow.sl.js'),
		       name : 'amount',
		       width : '90',
		       sortable : false,
		       align : 'left'
	   },
	   "handleTime" : {
	     display : $.i18n('office.asset.assetApplyEdit.blsj.js'),
	     name : 'handleTime',
	     width : '140',
	     sortable : false,
	     align : 'center'
	   },
	 	"handleUser" : {
	   display : $.i18n('office.asset.assetApplyEdit.blr.js'),
	   name : 'handleUserName',
	   width : '95',
	   sortable : false,
	   align : 'left'
	 	},
	 	"handleDesc" : {
		 display : $.i18n('office.asset.assetApplyEdit.blsm.js'),
		 name : 'handleDesc',
		 width : '265',
		 sortable : false,
		 align : 'left'
	 	}
	 };
}
