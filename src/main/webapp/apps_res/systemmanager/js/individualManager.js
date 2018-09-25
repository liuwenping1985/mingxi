	// 进行编辑
	function showEdit1(){
		document.getElementById("submitOk").style.display= "";
		document.getElementById("formerpassword").disabled="";
		document.getElementById("nowpassword").disabled="";
		document.getElementById("validatepass").disabled="";
	}
	// 取消编辑
	function notEdit1(){
		try{
		document.getElementById("submitOk").style.display="none";
		document.forms['postForm'].reset();//去掉填写的内容
		document.getElementById("formerpassword").disabled=true;
		document.getElementById("nowpassword").disabled=true;
		document.getElementById("validatepass").disabled=true;
		myBar.enabled("editBtn");
		}
		catch(e){}
	}
	function editData(){
		document.getElementById("submitOk").style.display="block";
		document.forms['postForm'].reset();//去掉填写的内容
		document.getElementById("formerpassword").disabled=false;
		document.getElementById("nowpassword").disabled=false;
		document.getElementById("validatepass").disabled=false;
		//myBar.disabled("editBtn");
	}

	// 验证密码相同否
	function validate1(){
		var oldpasword = document.getElementById("nowpassword").value;
		var validatepassword = document.getElementById("validatepass").value;
		if (oldpasword == validatepassword){
			return true;
		} else {		
			alert(sameOrNot);
			document.getElementById("validatepass").value = "";
			return false;
		}
	}
	
	// 验证原密码
	function validateOldPassword1(){
		var oldPassword = document.getElementById("formerpassword").value;
		var individualName    = document.getElementById("individualName").value;
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManager", "isOldPasswordCorrect", false);
		requestCaller.addParameter(1, "String", individualName);
		requestCaller.addParameter(2, "String", oldPassword);
		var ds = requestCaller.serviceRequest();
		if(ds=="true"){
			return true;
		}else{
			alert(oldPasswordMsg);
			return false;
		}
	}