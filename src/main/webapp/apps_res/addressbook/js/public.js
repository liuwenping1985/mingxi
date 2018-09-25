//点击部门树的单位节点,显示单位信息页面
function showAccount(accountid,from){
	if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
		parent.listFrame.document.getElementById("click").value = "dept";
		parent.listFrame.document.getElementById("mem").value = "all";
		parent.listFrame.document.getElementById("deptId").value = accountid;
		//parent.listFrame.document.getElementById("condition").value = "";
		parent.listFrame.location.href = addressbookURL+"?method=listAllMembers&addressbookType=1&accountId="+accountid+"&from="+from;
	} else {
		return;
	}
}

//点击部门树的部门节点,显示部门信息页面
function showDepartment(deptid){
	if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
		parent.listFrame.document.getElementById("click").value = "dept";
		parent.listFrame.document.getElementById("deptId").value = deptid;
		parent.listFrame.document.getElementById("mem").value = "";
		parent.listFrame.location.href = addressbookURL+"?method=listDeptMembers&addressbookType=1&pId="+deptid
		+"&accountId="+accountID+"&click=dept"+"&deptId="+deptid+"&isDepartment="+parent.isDepartment;
	} else {
		return;
	}
}

//切换单位
function changeType(accountId){
	parent.parent.location.href = addressbookURL+"?method=home&addressbookType=1&accountId="+accountId;
}

//点击个人组树的系统组节点,显示该个人组成员页面
function showOwnTeam(teamid){
	document.getElementById("tId").value = teamid;
	if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
		parent.listFrame.document.getElementById("click").value = "ownTeam";
		parent.listFrame.document.getElementById("otId").value = teamid;
		parent.listFrame.location.href = addressbookURL+"?method=listOwnTeamMembers&tId="+teamid+"&click=ownTeam"
		+"&otId="+teamid+"&click=ownTeam";
	} else {
		return;
	}
}

//点击系统组树的系统组节点,显示该系统组成员页面
function showSysTeam(teamid, accountid){
	if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
		parent.listFrame.document.getElementById("click").value = "sysTeam";
		parent.listFrame.document.getElementById("sysId").value = teamid;
		parent.listFrame.document.getElementById("condition").value = "";
		parent.listFrame.location.href = addressbookURL+"?method=listSysTeamMembers&addressbookType=3&accountId=" + accountid + "&tId="+teamid+"&click=sysTeam"+"&sysId="+teamid;
	} else {
		return;
	}
}

//系统组切换单位
function changeTypeSysTeam(accountId){
	parent.parent.location.href = addressbookURL+"?method=home&addressbookType=3&accountId="+accountId;		
}

//显示人员卡片
function viewMember(memberId,accountId,dN,lN,pN,sP,type){
	var genericControllerURL =v3x.baseURL+ "/genericController.do?ViewPage=";
	if(v3x.getBrowserFlag('OpenDivWindow')){
		v3x.openWindow({
			url : genericControllerURL + "collaboration/memberCard&memberId=" + memberId,
			width : 680,
			height: 400,
			dialogType:v3x.getBrowserFlag('openWindow')?'modal':'open'
		});
	}else{
		var member_view_win = new MxtWindow({
	        id: 'member_view_win',
	        title: v3x.getMessage("ADDRESSBOOKLang.view"),
	        url: genericControllerURL + "collaboration/memberCard&memberId=" + memberId,
	        width: 640,
	        height: 400,
			type:'window',//类型window和panel为panel的时候title不显示
			isDrag:false,//是否允许拖动
	        buttons: [{
				id:'member_view_win_btn2',
	            text: v3x.getMessage("ADDRESSBOOKLang.cancel"),
	            handler: function(){
	        		member_view_win.close();
	            }
	        }]
		});
	}
}