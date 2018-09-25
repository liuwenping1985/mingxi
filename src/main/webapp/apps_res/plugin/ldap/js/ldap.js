function openUserTree(editstate,isModify) {
	disableLdap();
	var sendResult = v3x.openWindow({
		url : "/seeyon/ldap.do?method=viewUserTree",
		width : "410",
		height : "325",
		scrollbars : "yes"
	});
	if (!sendResult) {
		return;
	} else {
		var stringLenth = sendResult.split("::" + "check" + "::");
		if (stringLenth != null && stringLenth != ''&& stringLenth != "undefind") {
			document.getElementById("ldapUserCodes").value = stringLenth[0];
		}
		if (stringLenth.length == 1) {
			var requestCaller = new XMLHttpRequestCaller(this,"ajaxLdapBindingMgr", "getUserAttributes", false);
			requestCaller.addParameter(1, "String", stringLenth[0]);
			var arrayString = requestCaller.serviceRequest();
			if (arrayString != null) {
				if (arrayString[1] != null && arrayString[1] != 'undefined'&& arrayString[1] != '') {
					document.getElementById("name").value = arrayString[1];
				}
				if (arrayString[2] != null && arrayString[2] != 'undefined'&& arrayString[2] != '') {
					document.getElementById("telNumber").value = arrayString[2];
				}
				if (arrayString[0] != null && arrayString[0] != 'undefined'&& arrayString[0] != '') {
					if(editstate==""||editstate==null||editstate=="null")
					{
						document.getElementById("loginName").value = arrayString[0];
					}else{
						if(isModify=="true"||isModify==true)
						{
							return;
						}
						if(confirm(v3x.getMessage("organizationLang.orgainzation_member_change_loginName"))){
							document.getElementById("loginName").value = arrayString[0];
							setPassword();
						}
					}
			}
		}
	}
}
}
function enableLdap() {
	document.all("ldapUserCodes").disabled = true;
	document.all("ldapUserCodes").value = "";
	document.getElementById("ldapUserCodes").validate = "";
}
function disableLdap() {
	document.all("ldapUserCodes").readOnly = true;
	document.getElementById("ldapUserCodes").validate = "notNull";
}
function showEntry() {
	document.getElementById("entryLable").style.display = "block";
	document.all("ldapUserCodes").disabled = false;
	disableLdap();

	document.getElementById("newEntryLable").style.display = "none";
}
function hiddenEntry() {
	document.getElementById("entryLable").style.display = "none";
	enableLdap();

	document.getElementById("newEntryLable").style.display = "block";
}
function setPassword() {
	document.getElementById("member.password").value="";
	document.getElementById("member.password1").value="";
}
function openLdap() {
	var sendResult = v3x.openWindow({
		url : "/seeyon/ldap.do?method=viewOuTree",
		width : "410",
		height : "325",
		scrollbars : "yes"
	});
	if (!sendResult) {
		return;
	} else {
		document.getElementById("selectOU").value = sendResult;
	}

}