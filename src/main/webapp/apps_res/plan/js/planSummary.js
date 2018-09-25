
function submit_status(fromPage){
    var domains = [];
    var content = $("#summaryText").val();
    var rate = document.getElementById("rate");
    var planStatus = document.getElementById("planStatus");
    if(rate.value>100){ //若完成率为100，则计划状态只能为“已完成”
        //提示存在时间差再重置一下
        rate.value='100';
        planStatus[2].selected="selected";
    }
    if(fromPage =="tab1" || fromPage == "tab3"){
        if(checkStatusFrom()) {
            domains.push("tab1_div");
			if(typeof(content)=="string"){ //mod by caow 2013.12.9 OA-50312还不能总结的计划，修改状态完成率报错
				if(content.length>1200){
					$.alert($.i18n('plan.summary.tab.nomorethan1200'));
					return;
				}
				if(content.length > 0) { 
					domains.push("tab2_div");
				}
			}
        } else {
            return;
        }
    }
    if(fromPage =='tab2'){
        if(checkSummaryForm()) {
            if(content.length>1200){
                $.alert($.i18n('plan.summary.tab.nomorethan1200'));
                return;
            }
            domains.push("tab2_div");
        } else {
            return;
        }
        domains.push("tab1_div");
    }
	var url = _ctxPath+"/plan/plan.do?method=changeStatusAndSummary";

	var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
	var isajax = false;
	if(fromPage =="tab3"&&isChrome){
		isajax = true;
	}
	if($("#from_source").val() == "portal") {
		if(window.navigator.userAgent.indexOf("Mozilla") !== -1) {
			isajax = true;
		}
	}
  if(fromPage =="tab1"){     
    $("#submitit").addClass("common_button_disable");
    $("#submitit").removeAttr("onclick");
  }else if(fromPage =="tab2"){
    $("#submitit2").addClass("common_button_disable");
    $("#submitit2").removeAttr("onclick");
  }
	$("#tabs_body").jsonSubmit({
			ajax:isajax,
			action:url,
			domains : domains,
			callback:function(){
				var msg;
				if(fromPage =="tab1" || fromPage == "tab3"){
					msg = $.i18n('plan.alert.plansummary.modifysuccess');
				}else if(fromPage =="tab2"){
					msg = $.i18n('plan.alert.plansummary.summarysuccess');
				}
				if(parent.location.href.indexOf("plan")!=-1){
				var win = new MxtMsgBox({
					'title':$.i18n('plan.alert.plansummary.sysmessage'),
					'type': 0,
					'imgType':0,
					'msg': msg,
					close_fn:function(){
						refreshOperaPage(fromPage);
					},
					ok_fn:function(){
						refreshOperaPage(fromPage);
					}
				});
			}
		}
	});
}
function refreshOperaPage(fromPage) {
	if(fromPage =="tab1"){
		parent.myActions+="-changeStatus";
	}else if(fromPage =="tab2"){
		parent.myActions+="-summary";
	}else if(fromPage =="tab3"){
		return;
	}
	//OA-66367
	if(getA8Top().location.href.indexOf('a8genius.do') > -1){
		getA8Top().window.close();
	}
	if(parent.window.opener){
		if(parent.window.opener.sectionHandler){
			parent.window.opener.sectionHandler.reload("projectPlanAndMtAndEvent",true);
		}
	}
	//parent.myActions+="-changeStatus";
	refreshPlanListAndContentFrame();
	reLoadContentFrame($("#plan_Id").val());
}
function submit_summary(){
	var content = $("#summaryText").val();
	if(content.length>1200){
		$.alert($.i18n('plan.summary.tab.nomorethan1200'));
		return;
	}
	if(checkSummaryForm()){
		$("#tabs_body").jsonSubmit({
			action:_ctxPath+"/plan/plan.do?method=doSummary",
			domains:["formDomain"],
			callback:function(){
				var win = new MxtMsgBox({
					'title':$.i18n('plan.alert.plansummary.sysmessage'),
				    'type': 0,
				    'imgType':0,
				    'msg': $.i18n('plan.alert.plansummary.summarysuccess'),
				    close_fn:function(){
				    	parent.myActions+="-summary";
						refreshPlanListAndContentFrame();
						reLoadContentFrame($("#plan_Id").val());
					},
					ok_fn:function(){
						parent.myActions+="-summary";
						refreshPlanListAndContentFrame();
						reLoadContentFrame($("#plan_Id").val());
					}
				});
				}
		});
	}
}

function submit_commont(){
	$("#submitit").attr("disabled","true");
	var content = $("#replyContent").val();
	if(content.length>1200){
		$.alert($.i18n('plan.summary.tab.nomorethan1200'));
		$("#submitit").removeAttr("disabled");
		return;
	}
	hideProcPanel();               //计划回复确定后，需要隐藏计划回复区域。
    $("#replyform #content").val(content);
    $("#replyform #hidden").val($("#isHidden")[0].checked);
	saveAttachment(document.getElementById("attachmentTR"));
    $("#replyform #relateInfo").val($.toJSON($("#attachmentTR").formobj()));
  	var obj = $("#replyform").formobj();     
  	var pmg = new planManager();
  	pmg.savePlanReply(obj,{                     //局部刷新计划回复
  		success:function(ret){
  			$("#submitit").removeAttr("disabled");
  			if(ret=="delete"){
  				$.alert($.i18n('plan.alert.plansummary.isdeletecannotmodifyreply'));
  				return;
  			}else if(ret=="over"){
  				$.alert($.i18n('plan.alert.plansummary.isovercannotmodifyreply'));
  				return;
  			}	
  			var comment =$.parseJSON(ret);
  			parent.myActions+="-submitComment";
		    $("#planReply").slideUp();
		    $("#replyContent").val("");
		    showNewComment(comment);
		    //回复意见总数+1
		    var newTotalComment = parseInt(parent.document.getElementById("commentSum").value)+1;
		    parent.document.getElementById("commentSum").value=newTotalComment;
		    $("#opinionComment",parent.document).html($.i18n('plan.opinion.handleOpinion',newTotalComment));
		    var _h1 = $("#iframe_area",parent.document).height();  //回复之后，应该将垂直滚动条置底至最新回复计划处。
		    var _h2 = $("#summaryAndComment",parent.document).height();
			var _scrollHeight = _h1+_h2;
		    $("#contentDiv",parent.document).scrollTop(_scrollHeight); 
		    refreshPlanList();
  		}
  	});
}
function showNewComment(comment){    //根据回复内容拼接成html，添加到planReplyContent。

	var replyI18n = $("#i18n_reply").val();
	var replyOpinion = $("#i18n_replyOpinion").val();
	var lengthRange = $("#i18n_lengthRange").val();
	var opinionhide = $("#i18n_opinionhide").val();
	var _divStr1 = "<h3 class='per_title'><span class='title align_left'>"
		+"<a id='commentSearchCreate1' class='showPeopleCard' style='font-size: 14px;' onclick='$.PeopleCard({memberId:\""+comment.createId+"\"})' href='javascript:void(0)'>"+comment.createName+"</a>&nbsp"
		+"<span class='align_right' style='font-size: 14px;'>"+comment.createDateStr+"</span>"
		+"</span>"
		+"<span class='add_new font_size12' onclick=\"commentShowReply('"+comment.id+"');\"><a href='javascript:void(0)'>"+replyI18n+"</a></span>"
		+"</h3>"
		+"<input id='mcp_"+comment.id+"' value='"+comment.maxChildPath+"' type='hidden'><input id='cp_"+comment.id+"' value='"+comment.path+"' type='hidden'>"
		+"<ul>"
		+"<li class='content_in font_size12'>"+comment.escapedContent+"</li>";
	var _divStr2 = "<li id='replyContent_"+comment.id+"' class='color_gray display_none'><h4>"+replyOpinion+"</h4> </li>"
		+" <li id='reply_"+comment.id+"' class='form_area display_none clearFlow'>"
		+"<input id='pid' value='"+comment.id+"' type='hidden'>"
		+"<input id='clevel' value='"+comment.clevel+1+"' type='hidden'>"
		+"<input id='path' type='hidden'>"
		+"<input id='moduleType' value='"+comment.moduleType+"' type='hidden'>"
		+"<input id='moduleId' value='"+comment.moduleId+"' type='hidden'>"
		+"<input id='ctype' value='1' type='hidden'>"
		+"<input id='affairId' value='' type='hidden'>"
		+"<div class='common_txtbox clearfix'><textarea id='content' class='validate' cols='20' rows='5' name='content' validate='notNull:true,maxLength:500'></textarea></div>"
		+"<div class='chearfix'>"
		+"<table style='border:0;width: 100%'>"
		+"<tbody><tr><td nowrap='nowrap' width='90%'>"
		+"<table style='border:0'><tbody><tr><td nowrap='nowrap'>"
		+"<span class='left green'>"+lengthRange+"</span></td>"
		+"<td nowrap='nowrap' width='100%'>"
		+"<span class='bt' style='height:41px;float:right;vertical-align:bottom;padding-right:30px;'>"
		+"<span><label class='margin_r_10 hand'><input id='hidden' class='radio_com' name='hidden' value='true' type='checkbox'>"+opinionhide+"<input type='hidden' id='showToId' name='showToId' value='Member|"+$("#planCreateUser").val()+"' /></label></span>"
		+"<span><a class='common_button common_button_gray margin_r_5' onclick=\"commentReply('"+comment.id+"')\" href='javascript:void(0)'>"+$("#i18n_submit").val()+"</a>"
		+"<a class='common_button common_button_gray ' onclick=\"commentHideReply('"+comment.id+"')\" href='javascript:void(0)'>"+$("#i18n_cancel").val()+"</a>"
		+"<div style='display: none;' class='common_txtbox common_txtbox_dis clearfix'>"
	    +"<input id='reply_pushMessage_"+comment.id+"' onclick=\"pushMessageToMembers($(this),$('#reply_"+comment.id+" #pushMessageToMembers'),null,'"+comment.createId+"')\" value=\""+comment.createName+"\" type='text'></span>"
	    +"</div>"
		+"</span>"
		+"</td></tr></table>"
		+"</td></tr></table></div>";
		+"</li>"
		+"</ul>"; 
	if(comment.hasRelateAttach){           //如果有附件
		var divStr = _divStr1
			+"<li>"
			+"<span class='font_bold font_size12 left'>"+$("#attachment_label").val()+"：</span>"
			+"<span><div id='"+comment.id+"_attachmentDiv' class='comp' comptype='fileupload' comp=\"type:'fileupload',applicationCategory:'"+comment.moduleType+"',attachmentTrId:"+comment.id+",canDeleteOriginalAtts:false,canFavourite:false\" attsdata='"+comment.relateInfo+"'></div></span>"
			+"</li>"
			+_divStr2;
	}else{
		var divStr = _divStr1+_divStr2;
	}
	$("#planReplyContent",parent.document).append(divStr);
	parent.showAtts(comment.id+"_attachmentDiv");
	$("#detailRightFrame",parent.document).attr("src","plan.do?method=getPlanSummary&planId="+$("#param_planId").val()+"&path="+$("#commentMaxPathStr").val()+"&readOnly="+$("#param_readOnly").val());

}

function checkStatusFrom(){
	var finishRatio = $("#finishRatio").val();
	var rate = document.getElementById("rate");
	var status = document.getElementById("planStatus");
	var publishStatus = $("#publishStatus").val();
	if(publishStatus == 1){
	  $.alert($.i18n('plan.alert.plansummary.cannotmodifystatus'));
	  return false;
	}
	if(rate.value==""||rate.value==null){
		$.alert($.i18n('plan.alert.plansummary.enterfinish'));
		$(rate).focus();
		return false;
	}
	if(rate.value==finishRatio && $("#plan_Statu").val()==status.value){
		$.alert($.i18n('plan.alert.plansummary.cannotsubmit'));
		return false;
	}
	if(rate.value!=""){
	    var dotindex = rate.value.indexOf(".");
	    if(dotindex>-1){
	      $.alert($.i18n('plan.alert.plansummary.dotmoretwo'));
	      return false;
	    }
	}
	return true;
}

function checkSummaryForm(){
	if($("#planPublishStatus").val() == 1){
	  $.alert($.i18n('plan.alert.plansummary.cannotaddsummary'));
	  return false;
	}
	var text = document.getElementById("summaryText").value;
	var atts = $(".attachment_block").length;
	//mod by caow 总结内容必须要有文字
	if(text==""){
		$.alert($.i18n('plan.alert.plansummary.summarynotbeblanck'));
		return false;
	}
	return true;
}

function initByRateInput(){
	var rate = document.getElementById("rate");
	var planStatus = document.getElementById("planStatus");
	
	if(!isNum(rate.value)){
		rate.value='';
		return;
	}
	
	if(rate.value<=0){ // 若完成率为0，则分两种情况：如果计划为已取消或者已经推迟，则计划状态不变，否则计划状态改为未开始
		rate.value='0';
		if( planStatus.value!='4' && planStatus.value!='5' ){
			planStatus[0].selected="selected";
		}
	}else if(rate.value<100){ // 若完成率为（0，100），则分两种情况：如果计划为已取消或者已经推迟，则计划状态不变，否则计划状态改为进行中
		if( planStatus.value!='4' && planStatus.value!='5' ){
			planStatus[1].selected="selected";
		}
	}else if(rate.value==100){ //若完成率为100，则计划状态只能为“已完成”
		planStatus[2].selected="selected";
	}else if(rate.value>100){ //若完成率为100，则计划状态只能为“已完成”
		rate.value='100';
		planStatus[2].selected="selected";
		$.alert($.i18n('plan.alert.plansummary.notmorethan100'));
	}
}

function isNum(NUM){
	  var i,j,strTemp,pointSize;
	  pointSize = 0;
	  strTemp="0123456789.";
	  if ( NUM.length== 0) return false;
	  for (i=0;i<NUM.length;i++){
	    j=strTemp.indexOf(NUM.charAt(i)); 
	    if (j==-1){    //说明有字符不是数字
		  $.alert($.i18n('plan.alert.plansummary.enternumber'));
	      return false;
	    }
	    if (NUM.charAt(i)=='.'){
	    	pointSize = pointSize + 1;
	    }
	  }
	  if(pointSize>1){//有一个以上的小数点，不是数字
	  	$.alert($.i18n('plan.alert.plansummary.entervalidnumber'));
	  	return false;
	  }
	  return true;
	//var reg = new RegExp("^[0-9]+(.[0-9]{1})?$", "g");
	//return reg.test(NUM);
	}


function initByPlanStatus(){
	var varRate = document.getElementById("rate");
	var varPlanStatus = document.getElementById("planStatus");
	
	if(varPlanStatus.value=='1'){ // 计划为未开始，完成率只能为0
		varRate.value=0;
	}else if(varPlanStatus.value=='2'){ // 计划进行中，完成率不能为0%和100%
		if(varRate.value==0){
			varRate.value='';
			$.alert($.i18n('plan.alert.plansummary.enterfinish'));
			varRate.focus();
		}else if(varRate.value==100){
			varRate.value='';
			$.alert($.i18n('plan.alert.plansummary.notmore100ing'));
			varRate.focus();
		}
	}else if(varPlanStatus.value=='3'){ // 计划已完成，完成率不能为0%
		varRate.value=100;
	}else if(varPlanStatus.value=='4'){ // 计划已取消，完成率不能为100%
		if(varRate.value==100){
			varRate.value='';
			$.alert($.i18n('plan.alert.plansummary.notmore100ed'));
			varRate.focus();
		}
	}else if(varPlanStatus.value=='5'){ // 计划已推迟，完成率不能为100%
		if(varRate.value==100){
			varRate.value='';
			$.alert($.i18n('plan.alert.plansummary.notmore100chi'));
			varRate.focus();
		}
	}
}
//刷新列表
function refreshPlanList(){
	if(typeof(parent.window.opener)=="undefined"){
		if(parent.parent.plan != undefined && parent.parent.loadList!= undefined ){
			parent.parent.needLoadListDesc = false;
			parent.parent.loadList();
			parent.parent.currentHeight = 0;
			parent.parent.expendContentFrame();
		}
	}else{
		if(parent.window.opener == null && parent.parent.loadList != undefined){
			parent.parent.needLoadListDesc = false;
			parent.parent.loadList();
			parent.parent.currentHeight = 0;
			parent.parent.expendContentFrame();
		}else if(parent.window.opener.plan != undefined && parent.window.opener.loadList!= undefined ){
			parent.window.opener.needLoadListDesc = false;
			parent.window.opener.loadList();
			parent.window.opener.currentHeight = 0;
			parent.window.opener.expendContentFrame();
		}		
	}
}
//刷新列表和下面的内容区
function refreshPlanListAndContentFrame(){
	if(typeof(parent.window.opener)=="undefined" || parent.window.opener == null){
		if(parent.parent.plan != undefined && parent.parent.loadList!= undefined ){
			parent.parent.needLoadListDesc = false;
			parent.parent.loadList();
			parent.parent.currentHeight = 0;
			parent.parent.expendContentFrame();
		}
		var planContentFrame = parent.parent.document.getElementById("planContentFrame");
		if(planContentFrame){
			planContentFrame.src=_ctxPath+"/plan/plan.do?method=initPlanDetailFrame&planId="+$("#plan_Id").val()+"&doneAction="+parent.myActions;
		}
	}else{

		if(parent.window.opener.plan != undefined && parent.window.opener.loadList!= undefined ){
			parent.window.opener.needLoadListDesc = false;
			parent.window.opener.loadList();
			parent.window.opener.currentHeight = 0;
			parent.window.opener.expendContentFrame();
		}
		var planContentFrame = parent.window.opener.document.getElementById("planContentFrame");
		if(planContentFrame){
			planContentFrame.src=_ctxPath+"/plan/plan.do?method=initPlanDetailFrame&planId="+$("#plan_Id").val()+"&doneAction="+parent.myActions;
		}
/*		parent.window.close();
              		 removeCtpWindow('123123123123123123',2);
              		 removeCtpWindow('123123123123123123456',2);
  					removeCtpWindow(null,2);*/
	}
}

//刷新整个弹出窗口
function reLoadContentFrame(planId){
	//var planContentFrame = parent.parent.document.getElementById("showPlan_main_iframe_content");//弹出窗口Frame
	if(typeof(parent.window.opener)=="undefined"){
		var planContentFrame = $("iframe[id$='_main_iframe_content']",parent.parent.document)[0];
		if(planContentFrame){
			planContentFrame.src=_ctxPath+"/plan/plan.do?method=initPlanDetailFrame&planId="+planId+"&doneAction="+parent.myActions;
		}
		if(planContentFrame==undefined){
			try{
				var iframe=getCtpTop().$("#docOpenDialogOnlyId").find("iframe[id$='-iframe']")[0];
				if(iframe!=undefined){
					planContentFrame=iframe;
					planContentFrame.src=_ctxPath+"/plan/plan.do?method=initPlanDetailFrame&planId="+planId+"&doneAction="+parent.myActions;
				}else{
					//这里分支怎么那么多,完全考虑不全,不利于维护,后续是不是要改改？
					parent.location.href=_ctxPath+"/plan/plan.do?method=initPlanDetailFrame&planId="+planId+"&doneAction="+parent.myActions;
				}
			}catch(e){}
		}
	}else{
		parent.location.href=_ctxPath+"/plan/plan.do?method=initPlanDetailFrame&planId="+planId+"&doneAction="+parent.myActions;
	}
	if(parent.document.getElementById("dataSource")){
		var dataSource = parent.document.getElementById("dataSource").value;
	}
	if(typeof(dataSource) != undefined && dataSource =="project"){
		parent.window.close();
	}
}

//展示常用语
function showphrase(str) {
  var callerResponder = new CallerResponder();
  //实例化Spring BS对象
  var pManager = new phraseManager();
  /** 异步调用 */
  var phraseBean = [];
  pManager.findCommonPhraseById({
    success : function(phraseBean) {
      var phrasecontent = [];
      var phrasepersonal = [];
      for ( var count = 0; count < phraseBean.length; count++) {
        phrasecontent.push(phraseBean[count].content);
        if (phraseBean[count].memberId == str
            && phraseBean[count].type == "0") {
          phrasepersonal.push(phraseBean[count]);
        }
      }
      $("#cphrase").comLanguage({
        textboxID : "replyContent",
        data : phrasecontent,
        newBtnHandler : function(phraseper) {
          $.dialog({
            url : _ctxPath + '/phrase/phrase.do?method=gotolistpage',
            transParams : phrasepersonal,
            targetWindow : getCtpTop(),
            title : $.i18n('phrase.sys.js.cyy')
          });
        }
      });
    },
    error : function(request, settings, e) {
      alert(e);
    }
  });

}
function hideProcPanel(){
	parent.detailLayout.setEast(45);
	var attdivobj = parent.$("#attachmentTRa");
	var reldocdivobj = parent.$("#attachment2TRb");
	
	if(attdivobj[0].style.display==""||reldocdivobj[0].style.display==""){
		var h1 = parent.$("#contentHead_1").height();
		parent.$("#contentHead").css("height",h1);
		parent.$("#contentDiv").css("top",h1+5);
	}
	var btnDiv = document.getElementById("processBtn");
	var procDiv = document.getElementById("processPanel");
	btnDiv.style.display="block";
	procDiv.style.display="none";
}

function showProcPanel(btnId){
	parent.detailLayout.setEast(310);
	var attdivobj = parent.$("#attachmentTRa");
	var reldocdivobj = parent.$("#attachment2TRb");	
	if(attdivobj[0].style.display==""||reldocdivobj[0].style.display==""){//有附件时增加左边高度11个像素
		var h1 = parent.$("#contentHead_1").height()+10;
		parent.$("#contentHead").css("height",h1);
		parent.$("#contentDiv").css("top",h1+5);
	}
	$("#tabs_head").width(310);
	$("#tabs_body").width(310);
	var btnDiv = document.getElementById("processBtn");
	var procDiv = document.getElementById("processPanel");
	btnDiv.style.display="none";
	procDiv.style.display="block";
	if(btnId){
		$("#tabs").tabCurrent(btnId);
	}
}

function showAllAttachement(){
  document.getElementById("attachmentArea").style.overflow = "visible"; 
}