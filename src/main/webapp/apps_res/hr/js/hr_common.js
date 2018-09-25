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
	
	//added by paul at 2007/8/24
	function getSelectIdsNoLastComma(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		//去掉最后的','
		if (id != '' && id.lastIndexOf(',') > 0) id = id.substring(0, id.lastIndexOf(','));
		return id;
	}

	//判断是否选中一条记录 added by paul at 2007/8/25
	function checkSelectedId(frame){
		var ids = frame.document.getElementsByName('id');
		var count = 0;
		for(var i = 0; i<ids.length; i++){
			var idCheckBox = ids[i];
			if(idCheckBox.checked){
				count++;
			}
		}
		if(count == 1){
			return false;
		}else{
			return true;
		}
	}
	
	/**
	 * 判断是否有选中记录
	 */
	function checkSelectedOne(frame){
		var ids = frame.document.getElementsByName('id');
		for(var i = 0; i < ids.length; i++){
			if(ids[i].checked){
				return false;
			}
		}
		return true;
	}
	
    //ajax export excel(只针对3X，返回script，做了特殊处理，删除多余的script脚本，并执行)
    function exportIt(exportedURL) {
		$.ajax({ url: exportedURL,
	             type:"get",           
	             dataType:"html",
	             success:function(msg){ 
	             	eval(msg.substring(msg.indexOf('<script>')+8, msg.indexOf('<\/script>')));
	             } 
	    });    
    } 
/**
判断确认密码是否一致
**/
function validate(){
		var oldpasword = document.getElementById("newPassword").value;
		var validatepassword = document.getElementById("validatepass").value;
		if(validatepassword == '' || oldpasword == ''){
		   return false;
		}
		if (oldpasword == validatepassword){
			return true;
		} else {	
			alert(v3x.getMessage("HRLang.manager_vialdateword"));
			document.getElementById("newPassword").value = "";
			document.getElementById("validatepass").value = "";
			return false;
		}
}    

/**
 * 判断密码是否是数字、字母、下划线
 */
function isCriterionWord(element){
	var value = element.value;
	if(!testRegExp(value, '^[\\w-]+$')){
		document.getElementById("validateInfo").innerHTML = v3x.getMessage("HRLang.hr_formValidate_isCriterionWord");
		return false;
	}else{
		document.getElementById("validateInfo").innerHTML = "";
		return true;
	}
};
var selectItem = {};
function selectDates(id){
	selectItem.id = id;
	var event = v3x.getEvent();
	getA8Top().selectDateHrWin = getA8Top().$.dialog({
        title:' ',
        left:event.screenX - 325,
        top:event.screenY - 150,
        transParams:{'parentWin':window},
        url: v3x.baseURL+"/genericController.do?ViewPage=hr/viewSalary/calendarFrame",
        width: 250,
        height: 200,
        isDrag:false
	});
}

function selectDateCollBack (returnValue) {
	getA8Top().selectDateHrWin.close();
	if(returnValue != undefined){
		document.getElementById(selectItem.id).value = returnValue;
	}
}

function isSameName(){
	alert(v3x.getMessage("HRLang.name_exists"));
	try{
		document.getElementById("b1").disabled = false;
	}catch(e){
		
	}
}

function reSet(){
	document.location.href = detailURL;
}