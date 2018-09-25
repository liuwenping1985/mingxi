function newSalaryInfo(){
	parent.detailFrame.location.href = hrSalaryURL + "?method=newSalaryInfo";
}

function modify(){
	if(checkSelectedId(parent.listFrame)){
		alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
		return false;
	}
	var salaryId = getSelectId(parent.listFrame);
	parent.detailFrame.location.href = hrSalaryURL + "?method=viewSalary&sId=" + salaryId + "&dis=false";
}

function deleteSalary(){
	var sIds = getSelectIds(parent.listFrame);
	if (sIds == '') {
		alert(v3x.getMessage("HRLang.hr_staffInfo_choose_delete"));
		return false;
	}
	
	if(!confirm(v3x.getMessage("HRLang.hr_operation_destroy_salary_confirm_message"))){
		return false;
	}

	parent.listFrame.document.getElementById("sIds").value = sIds;
	parent.listFrame.document.getElementById("salaryform").action = hrSalaryURL + "?method=destroySalary";
	parent.listFrame.document.getElementById("salaryform").submit();
}


function transferSalary(userId,userName){
	var sIds = getSelectIds(parent.listFrame);
	if (sIds == '') {
		alert(v3x.getMessage("HRLang.hr_staffInfo_choose_transfer"));
		return false;
	}
	if(!confirm(v3x.getMessage("HRLang.hr_staffInfo_choose_transfer_confirm",userName))){
		return false;
	}

	parent.listFrame.document.getElementById("sIds").value = sIds;
	parent.listFrame.document.getElementById("salaryform").action = hrSalaryURL + "?method=transferSalary&&userId="+userId;
	parent.listFrame.document.getElementById("salaryform").submit();
}

function setMembersNewPassWrod(){
	getA8Top().winSalaryPwd = getA8Top().$.dialog({
        title: setPasswordI18n,
        transParams:{'parentWin':window},
        url: hrSalaryURL + "?method=membersNewSalaryPassword",
        width: 400,
        height: 280,
        isDrag:false
	});
	
	
}

function stripscript(s) {
    var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）&mdash;—|{}【】‘；：”“'。，、？]")
        var rs = "";
    for (var i = 0; i < s.length; i++) {
        rs = rs + s.substr(i, 1).replace(pattern, '');
    }
    return rs;
}

function searchSalaryRecords(){
	var condition = document.searchForm.condition.value;
	var staffName = document.searchForm.staffName.value;
	var fromTime = document.getElementById("fromTime").value;
	var toTime = document.getElementById("toTime").value;
	var salaryDeptId = document.getElementById("salaryDeptId").value;
	var acceptPerson = document.getElementById("acceptPerson").value;
	var tansferfromTime = document.getElementById("tansferfromTime").value;
	var tansfertoTime = document.getElementById("tansfertoTime").value;

    if(condition == ""){
         alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_condition"));
         return false;
    }
   
	if(condition == "salaryDate"){
		var fromTime1 = fromTime + "-01";
		var toTime1 = toTime + "-01";
		if(compareDate(fromTime1, toTime1) > 0){
			alert(v3x.getMessage("HRLang.hr_message_checkdate_enddoeslatestart"))
			return false;
		}
	}
	if(condition == "tansferTimestamp"){
		if(compareDate(tansferfromTime, tansfertoTime) > 0){
			alert(v3x.getMessage("HRLang.hr_message_checkdate_enddoeslatestart"))
			return false;
		}
	}
	
	location.href = hrSalaryURL + "?method=transferSalaryRecord&condition=" + condition + "&staffName=" + encodeURIComponent(staffName) + "&acceptPerson=" + encodeURIComponent(acceptPerson) + "&fromTime=" + fromTime + "&toTime=" + toTime + "&salaryDeptId=" + salaryDeptId+ "&tansferfromTime=" + tansferfromTime+ "&tansfertoTime=" + tansfertoTime;
}

function exportTemplate(){
	parent.listFrame.location.href = hrSalaryURL + "?method=exportTemplate";
}

function importExcel(){
    fileUploadQuantity = 1;
    insertAttachment("true", '&selectRepeatSkip=fileupload.page.add&selectRepeatCover=fileupload.page.skip', 'importExcelCallback', 'false');
}
function importExcelCallback(){
	if(getFileAttachmentNumber(0) > 0) {
		saveAttachment();
		deleteAllAttachment(0);
		getA8Top().startProc('');
		formExcel.action = hrSalaryURL + "?method=importExcel";
		formExcel.submit();
	}
}

function exportExcel(){
	var fromTime = document.getElementById("exFromTime").value;
	var toTime = document.getElementById("exToTime").value;
	var isSearch = document.getElementById("isSearch").value;
	var resultCount = parent.listFrame.document.getElementById("resultCount").value;
	if(resultCount == 0){
		alert(v3x.getMessage("HRLang.hr_export_noData"));
		return false;
	}
	
	parent.listFrame.location.href = hrSalaryURL + "?method=exportExcel&fromTime=" + fromTime + "&toTime=" + toTime + "&isSearch=" + isSearch;
}

function onEnterPress2(){
	if(v3x.getEvent().keyCode == 13){
		searchSalaryRecords();
	}
}

function onEnterPress(){
	if(v3x.getEvent().keyCode == 13){
		searchSalarys();
	}
}

function searchSalarys(){
	var condition = document.searchForm.condition.value;
	var staffName = document.searchForm.staffName.value;
	var fromTime = document.getElementById("fromTime").value;
	var toTime = document.getElementById("toTime").value;
	var salaryDeptId = document.getElementById("salaryDeptId").value;
    if(condition == ""){
         alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_condition"));
         return false;
    }
    
    //不允许姓名称为空
   /* if(condition=="staffName" && staffName == ""){
         alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
         return false;
    }*/
    
	/*if(condition == "salaryDept" && salaryDeptId == ""){
	     condition="staffName";//如果部门为空　则查询全部
	 	//alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
		//return false;
	 }*/
	/*if(condition == "salaryDate"){
	    if(fromTime == "" && toTime == ""){
	        condition="staffName";//如果日期都为空　则查询全部
	    }
	    else if((fromTime == "" && toTime != "") || (fromTime != "" && toTime == "")){ //只有一个是空，那就行
	        alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
	        return false;
	    }
	}*/
	
	if(condition == "salaryDate"){
		var fromTime1 = fromTime + "-01";
		var toTime1 = toTime + "-01";
		if(compareDate(fromTime1, toTime1) > 0){
			alert(v3x.getMessage("HRLang.hr_message_checkdate_enddoeslatestart"))
			return false;
		}
	}
	
	parent.listFrame.location.href = hrSalaryURL + "?method=salaryInfo&condition=" + condition + "&staffName=" + encodeURIComponent(staffName) + "&fromTime=" + fromTime + "&toTime=" + toTime + "&salaryDeptId=" + salaryDeptId;
}
//个人工资查看 月份查询
function searchSalary(){
	var fromTime =  document.getElementById('fromTime').value;
	var toTime =document.getElementById('toTime').value;
    
	if(fromTime == "" || toTime == ""){
	    parent.listFrame.location.href = hrViewSalaryURL + "?method=viewData&isSearch=true";     
		/*alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
		return false;*/
	}
	
	var fromTime1 = fromTime + "-01";
	var toTime1 = toTime + "-01";
	if(compareDate(fromTime1, toTime1) > 0){
		alert(v3x.getMessage("HRLang.hr_message_checkdate_enddoeslatestart"))
		return false;
	}
	
	document.getElementById("isSearch").value = "1";
	document.getElementById("exFromTime").value = fromTime;
	document.getElementById("exToTime").value = toTime;
   
	parent.listFrame.location.href = hrViewSalaryURL + "?method=viewData&fromTime=" + fromTime + "&toTime=" + toTime+"&isSearch=true";
}

var password_new_Win;
function setNewPassWrod(){
	if(v3x.getBrowserFlag('OpenDivWindow')){
		getA8Top().winSalaryPwd = getA8Top().$.dialog({
	        title: v3x.getMessage("HRLang.passwordWin"),
	        transParams:{'parentWin':window},
	        url: hrViewSalaryURL +"?method=newSalaryPassword",
	        width: 400,
	        height: 280,
	        isDrag:false
		});
	}else{
		password_new_Win = v3x.openDialog({
	    	id: "password_new_Win",
	    	title: v3x.getMessage("HRLang.passwordWin"),
	    	url: hrViewSalaryURL + "?method=newSalaryPassword",
	    	width: 350,
	        height: 300,
	        targetWindow: parent.listFrame,
	        top: 50,
	        left: 30,
	        buttons: [{
	        	id: 'password_new_Win_ok',
	            text: v3x.getMessage("HRLang.submit"),
	            handler: function(){
	        		var rv = password_new_Win.getReturnValue();
	            }
	        },
	        {
				id: 'password_new_Win_cancel',
	            text: v3x.getMessage("HRLang.cancel"),
	            handler: function(){
	        		password_new_Win.close();
	        	}
        	}]
		});
	}
}

function valid(id){
	var s= document.getElementById(id).value;
	if(InValidChar(s)){
		alert("英文项：只允许输入英文字母！汉字、数字或其他字符无效");
		return false;
	 }else{
		return true;
	 }
}
	 
function InValidChar(s){//无效输入判断(为真说明输入无效）
	var haserrorChar;
	var CorrectChar = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ";
	return isCharsNotInBag(s, CorrectChar);
}
   
function isCharsNotInBag(s,bag){//逐个判断s字符串中每个字符是否都在限定范围bag内
	var i, c;     
	for(i = 0; i < s.length; i ++){
		c = s.charAt(i);
		if(bag.indexOf(c) < 0){//不在则返回真
			return true;
		}
	}
	return false;
}