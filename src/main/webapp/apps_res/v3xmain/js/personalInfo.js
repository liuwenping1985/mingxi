function checkMobileNum(){
    var telNumber = document.all.telNumber.value;		
	if(telNumber != "0" && (isNaN(telNumber) || telNumber.indexOf("0") == 0 || !testRegExp(telNumber, "^-?[0-9]*$"))){
		alert(v3x.getMessage("HRLang.hr_staffInfo_input_validation",v3x.getMessage("HRLang.hr_staffInfo_mobilephone")));
		document.all.telNumber.focus();
		return false;
	}
	return true;
}