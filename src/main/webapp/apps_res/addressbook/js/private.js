//设置树的根结点
function setTeamId(teamid) {
	document.getElementById("tId").value = teamid;
}

//点击类别树的节点,显示该类别成员页面
function showOwnTeam(teamid){
	document.getElementById("tId").value = teamid;
	try{
	   parent.listFrame.document.getElementById("click").value = "ownTeam";
	   parent.listFrame.document.getElementById("otId").value = teamid;
	}catch(e){}
	parent.listFrame.location.href = addressbookURL+"?method=listOwnTeamMembers&addressbookType=2&tId="+teamid+"&otId="+teamid+"&click=ownTeam";
}

//显示人员卡片，可修改
//回调函数在toolbar.js中公用newMemberCollBack
function viewMember(memberId){
	getA8Top().newMemberWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: addressbookURL+"?method=viewMember&addressbookType=2&mId="+memberId+"&edit=1",
        width: 680,
        height: 490,
        isDrag:false
    });
}
