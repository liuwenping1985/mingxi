
//点击页签事件（即使选中状态下也可以跳转）
function mtsummary_changeMenuTab(clickDiv) {
  /*var menuDiv=document.getElementById("menuTabDiv");
  var clickDivStyle=clickDiv.className;
  //if(clickDivStyle=="tab-tag-middel-sel"){return;}
  var divs=menuDiv.getElementsByTagName("div");
  var i;
  for(i=0;i<divs.length;i++)
  {    
  	clickDivStyle=divs[i].className;  	
  	if(clickDivStyle.substr(clickDivStyle.length-4)=="-sel")
  	{  		
  		divs[i].className=clickDivStyle.substr(0,clickDivStyle.length-4);
  	}  	    
  }
  for(i=0;i<divs.length;i++)
  {
        if(clickDiv==divs[i])
  	    {
  	      divs[i-1].className=divs[i-1].className+"-sel";
  	      divs[i].className=divs[i].className+"-sel";
  	      divs[i+1].className=divs[i+1].className+"-sel";
  	    }    
  }
  var detailIframe=document.getElementById('detailIframe').contentWindow;
  detailIframe.location.href=clickDiv.getAttribute('url');*/
	window.location.href = clickDiv.getAttribute('url'); //xiangfan 修改成getAttribute的方式，修复firefox兼容问题，GOV-2467
}

function showSummary(recordId, mId, openType, proxy, proxyId) {
	if(!openType || openType==0){
		parent.detailFrame.location.href = 'mtSummary.do?method=mydetail&recordId='+recordId+"&mId="+mId+"&proxy="+proxy+"&proxyId="+proxyId;
	}else{
		 var rv = v3x.openWindow({
			 url: 'mtSummary.do?method=mydetail&recordId='+recordId+"&mId="+mId+"&openType="+openType+"&proxy="+proxy+"&proxyId="+proxyId,//xiangfan 添加 openType参数起标示作用，当审核人是当前人的话在'我发布的会议纪要'不需要显示'审批'页签 修复GOV-2185
		     workSpace: 'yes',
		     dialogType: v3x.getBrowserFlag('pageBreak') == true ? 'modal' : '1'
		});
		//xiangfan 添加 2012-04-21 修复关闭窗口后 ，父页面没有刷新的问题 GOV-1883
		if (rv == "true") {
			//getA8Top().document.contentFrame.mainFrame.location = 'mtSummary.do?method=listHome&from=audit&listType=waitAudit';
			if(getA8Top()==null || getA8Top().document.contentFrame==null || getA8Top().document.contentFrame.mainFrame==null) {
				location.reload();
			} else {
				getA8Top().document.contentFrame.mainFrame.location.href = 'mtSummary.do?method=listHome&from=audit&listType=waitAudit';
			}
			//parent.parent.location.reload();
			//alert(getA8Top().document.contentFrame.mainFrame.location);
        	//getA8Top().reFlesh();
		}
	}
}


//删除会议纪要草稿箱
function deleteMtSummaryDraftBox(){
	var ids=document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=id+idCheckBox.value+',';
		}
	}
	if(id==''){
		alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_delete_item"));
		return;
	}
	
	if(confirm(v3x.getMessage("meetingLang.summary_list_toolbar_only_delete_confirm"))) {
    	var myform = document.getElementsByName("listForm")[0];
    	myform.action =  "mtSummary.do?method=deleteFromDraftBox";
    	myform.method =  "post";
    	myform.submit();
	}
}


//逻辑删除我发布的会议纪要（审核未通过）
function deleteMyMtSummary(listType){
	var ids=document.getElementsByName('id');
	var id='';
	var summaryState=null;
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=id+idCheckBox.value+',';
			summaryState= idCheckBox.state;
			if(summaryState!=5){//lijl修改提示信息
				alert(v3x.getMessage("meetingLang.summary_list_tollbar_no_delete"));
				return;
			}
		}
	}
	if(id==''){
		//alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_delete_item"));
		alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_delete_item_1"));
		return;
	}

	if(confirm(v3x.getMessage("meetingLang.summary_list_toolbar_only_delete_confirm"))) {
    	var myform = document.getElementsByName("listForm")[0];
    	myform.action =  "mtSummary.do?method=deleteFromMyPublish&listType="+listType;
    	myform.method =  "post";
    	myform.submit();
	}
}


//逻辑删除我审核的会议纪要（审核通过）
function deleteMyAuditMtSummary(listType){
	var ids=document.getElementsByName('id');
	var id='';
	var summaryState=null;
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=id+idCheckBox.value+',';
			summaryState= idCheckBox.state;
			//xiangfan 添加条件【已审核】都是审核通过的纪要，不需要判断是否审核了GOV-4019
			if(listType != "audited"){
				if(summaryState!=2){alert(v3x.getMessage("meetingLang.meeting_passed_delete"));return;}
			}
		}
	}
	if(id==''){
		alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_delete_item"));
		return;
	}
	if(confirm(v3x.getMessage("meetingLang.summary_list_toolbar_only_delete_confirm"))) {
    	var myform = document.getElementsByName("listForm")[0];
    	myform.action =  "mtSummary.do?method=deleteFromMyAudit&listType="+listType;
    	myform.method =  "post";
    	myform.submit();
	}
}


//撤销我发布的会议纪要（待审核、审核通过）
function cancelMyPublish(listType){
	//lijl添加if和else,修改bug265
	 
	 
		var ids = document.getElementsByName('id');
		var id = '';
		var flag = false;
		var confirmMsg = v3x.getMessage("meetingLang.sure_to_delete");
		for(var i=0;i<ids.length;i++){
			var idCheckBox = ids[i];
			if(idCheckBox.checked){
				//只有创建者可以删除会议
				if(userInternalID != idCheckBox.getAttribute("createUser")){
					alert(v3x.getMessage("meetingLang.you_not_creater"));
					return;
				}
				id=id+idCheckBox.value+'&';
				//xiangfan 修改 GOV-446 审核通过和审核不通过的纪要都能撤销
				//if(idCheckBox.state == 5 || idCheckBox.state == 4) {//撤销条件
				//	alert(v3x.getMessage("meetingLang.summary_list_toolbar_not_cancel_alert"));
				//	return;
				//}
			}
		}
		if(id == ''){
			alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_cancel_item"));
			return;
		}
		//var r=confirm(v3x.getMessage("meetingLang.are_you_sure_revoke"));
		//弹出附言输入框
		var returnValue = v3x.openWindow({
	    url: "mtAppMeetingController.do?method=showAppMeetingCancelAppendex",
	    dialogType : "modal",
	    width: "400",
	    height: "260"
		});
		
		//提交表单
		if(returnValue!=null) {
			document.getElementById("content").value =returnValue;
			var myform = document.getElementsByName("listForm")[0];
	    	myform.action =  "mtSummary.do?method=cancelFromMyPublish&listType="+listType;
	    	myform.method =  "post";
	    	myform.submit();
		}
	
}

/** xiangfan  */
function closeMtWindow(oper){
	if(oper == "MtSummaryAudit"){
		/*if(window.opener){
			window.opener.location.reload();
			window.close();
			return;
		}
		if (window.dialogArguments) {
    	    window.returnValue = "true";
        	getA8Top().close();
	    }*/
		if(getA8Top().window.dialogArguments){
			getA8Top().window.returnValue = "true";
			getA8Top().window.close();
		}else{
			window.location.href = window.location;
		}
	}
}