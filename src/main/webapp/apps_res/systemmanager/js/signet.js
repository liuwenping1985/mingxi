/**
 * 刷新页面
 */
function refreshIt() {
    location.reload();
}

/**
 * 页面回退
 */
function locationBack() {
    history.back(-3);
}

/**
 * 取得列表中选中的id
 */
	function getSelectId(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=idCheckBox.value;
				break;
			}
		}
		return id;
	}
	
/**
 * 取得列表中所有选中的id
 */	
	function getSelectIds(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		return id;
	}
	
	//单击列表中的某一行,显示该行的详细信息
	function showDetailSignet(id,tframe){
		tframe.location.href = signetURL+"?method=modifySignet&id="+id+"&isDetail=readOnly";
	}
	//双击列表中的某一行,显示该行的详细信息
	function showDbDetailSignet(id,tframe){
		tframe.location.href = signetURL+"?method=modifySignet&id="+id;
	}
	
	// 双击列表中的某一行,显示该行的详细信息
	function dbclick(id,type){
		parent.detailFrame.location.href = partitionURL+"?method=modify"+type+"&id="+id+"&isDetail=readOnly";
	}
	//检查两次输入的密码是否一致
	function checkPassword(){
		var pass = parent.detailFrame.document.getElementById("adminPass").value;
		var pass1 = parent.detailFrame.document.getElementById("adminPass1").value;
		if(pass != pass1){
			alert(_("sysMgrLang.system_signet_password"));
			
			return false;
		}
	}
/*
 *  验证密码前后是否想的
 */
function validatepassword(){
	var oldpassword = document.getElementById("userword").value;
	var newpassword = document.getElementById("validateword").value;
   if(oldpassword.length<6 || newpassword.length<6 || oldpassword.length>50 || newpassword.length>50) {
		alert(_("sysMgrLang.system_unit_password"));		
		return false;
	}else if (oldpassword == newpassword) {
		return true;
	}else{
		alert(_("sysMgrLang.system_signet_password"));		
		return false;
	}

}
/*
 *  验证原密码和新秘密是否相等的 AJAX
 */
function validsignet(_select){
	var oldword = document.getElementById("password").value;
	if ( oldword != "" && _select != "" ){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxSignetManager", "getSignet", false);
		requestCaller.addParameter(1,"long",_select);
		requestCaller.addParameter(2,"String",oldword);
		requestCaller.addParameter(3,"boolean",true);
		var sig = requestCaller.serviceRequest();
		if ( sig == 0 ){
			alert("您输入的原密码不正确,请查证后在进行操作!");
			return false;
		}else{
			return true;
		}
	}
}
function validateSignetpassword(){
	var oldpassword = document.getElementById("newSignetword").value;
	var newpassword = document.getElementById("validateSignetword").value;
	if (oldpassword == newpassword) {
		return true;
	} else {
		alert(_("sysMgrLang.system_signet_password"));		
		return false;
	}

}

	