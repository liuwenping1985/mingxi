
/**
 * 复选框转换为单选框，最多只能选中一个
 * 按钮事件
 */
function checkBox2radioBtn(checkBoxGroupName, checkBoxIndex, isSendOnlineCheckboxId){

	var checkBox1Obj = document.getElementById(checkBoxGroupName + 1);
	var checkBox2Obj = document.getElementById(checkBoxGroupName + 2);
	var isSendOnlineCheckboxObj = document.getElementById(isSendOnlineCheckboxId);
	
	switch(checkBoxIndex){
		case 1:	if(checkBox2Obj){
					checkBox2Obj.checked = false;
				}
				break;
				
		case 2: if(checkBox1Obj){
					checkBox1Obj.checked = false;
				}
				break;
	}
	
	isSendOnlineCheckboxObj.disabled = !( (checkBox1Obj && checkBox1Obj.checked) || (checkBox2Obj && checkBox2Obj.checked));
	if(isSendOnlineCheckboxObj.disabled == true){
		isSendOnlineCheckboxObj.checked = false;
	}
}

/**
 * 移动应用设置-恢复默认 （集团版）
 */
function appSettingInit(isCanUseWapFlag, isCanUseSMSFlag, isCanUseWappushFlag, version){
	
	radioState2Default(isCanUseWapFlag, isCanUseSMSFlag, isCanUseWappushFlag);
	setSelectValue("isCanUseWap");
	setSelectValue("isCanUseSMS");
	setSelectValue("isCanUseWappush");
}
/**
 * 恢复默认 - 企业版
 */  
function radioState2Default(isCanUseWapFlag, isCanUseSMSFlag, isCanUseWappushFlag){
	if(isCanUseWapFlag){
		var isCanUseWapObj = document.getElementById("isCanUseWap_Y");
		if(isCanUseWapObj){
			isCanUseWapObj.checked = true;
		}
	}else{
		var isCanUseWapObj = document.getElementById("isCanUseWap_N");
		if(isCanUseWapObj){
			isCanUseWapObj.checked = true;
		}		
	}
	if(isCanUseSMSFlag){
		var isCanUseSMSObj = document.getElementById("isCanUseSMS_Y");
		if(isCanUseSMSObj){
			isCanUseSMSObj.checked = true;
		}
		setSMSSuffix(true);
	}else{
		var isCanUseSMSObj = document.getElementById("isCanUseSMS_N");
		if(isCanUseSMSObj){
			isCanUseSMSObj.checked = true;
		}	
		setSMSSuffix(false);
	}
	if(isCanUseWappushFlag){
		var isCanUseWappushObj = document.getElementById("isCanUseWappush_Y");
		if(isCanUseWappushObj){
			isCanUseWappushObj.checked = true;
		}
	}else{
		var isCanUseWappushObj = document.getElementById("isCanUseWappush_N");
		if(isCanUseWappushObj){
			isCanUseWappushObj.checked = true;
		}
	}
}
/**
 * 设置短信息后缀
 */
function setSMSSuffix(canUseSMS){
	var smsTr = document.getElementById("suffixDisplayTR");
	if(smsTr){
		if(canUseSMS){
			smsTr.className = "show";
		}else{
			smsTr.className = "hidden";
		}
	}
}
function setDefaultSuffix(){
	var suffix = document.getElementById("smsSuffix");
	if(suffix){
		suffix.value = defaultSMSSuffix;
	}
}

/**
 * 更改复选框的状态 是否可用
 */
function setSelectValue(seleceNameBegin){
	var flag = true; //是否勾选'checkbox_all'
	var obj = document.getElementById(seleceNameBegin + "_N");
	if(obj){
		var _NChecked = obj.checked;
		for(var i=0; i<accountSize; i++){
			var checkboxObj = document.getElementById(seleceNameBegin + i);
			if(checkboxObj){
				checkboxObj.disabled = _NChecked;
				if(_NChecked == true){
					checkboxObj.checked = false;
				}
				if(!checkboxObj.checked){
					flag = false;
				}
			}
		}
		var checkbox_all = document.getElementById(seleceNameBegin + "_all");
		if(checkbox_all){
			checkbox_all.disabled = _NChecked;
			checkbox_all.checked = flag;
		}
	}
}

/**
 * 移动消息授权 选人界面返回后的处理
 */
function mobileMgrPopedom(textareaObjId, hiddenInputObjId, elements){
	if(!elements){
		return ;
	}
	document.getElementById(textareaObjId).value = getNamesString(elements);
	document.getElementById(hiddenInputObjId).value = getIdsString(elements);
}

/**
 * 显示隐藏授权fieldset
 */
function displayPopedomFieldset(){
	var scrollListDiv = document.getElementById("scrollListDiv");
	var scrollListDiv_hight = scrollListDiv.clientHeight;
	var isCanUseSMSObj = document.getElementById("isCanUseSMS_Y");
	var isCanUseWappushObj = document.getElementById("isCanUseWappush_Y");

	var isCanUseSMS_Y = false;
	var isCanUseWappush_Y = false;
	if(isCanUseSMSObj){
		isCanUseSMS_Y = isCanUseSMSObj.checked;
	}
	if(isCanUseWappushObj){
		isCanUseWappush_Y = isCanUseWappushObj.checked;
	}

	var sendSMSPopedomDIVObj = document.getElementById("sendSMSPopedomDIV");	
	var popedomFieldsetObj = document.getElementById("popedomFieldset");	
	if(isCanUseSMS_Y == true){
		sendSMSPopedomDIVObj.style.display = "";
		popedomFieldsetObj.style.display = "";
		scrollListDiv.style.height = scrollListDiv_hight +"px";
		return;
	}
	else{
		if(sendSMSPopedomDIVObj){
			sendSMSPopedomDIVObj.style.display = "";
		}
	}
	if(isCanUseWappush_Y == true){
		popedomFieldsetObj.style.display = "";
		return;
	}
	
	popedomFieldsetObj.style.display = "none";
}

/**
 * 消息通道设置,选中所有应用
 */
function selectAllApp(checkBoxObj, flag){
	var anotherFlag = "1";
	if(flag==1){
		anotherFlag = "2";
	}
	var isChecked = checkBoxObj.checked;
	if(flag==3){
		for(var i=0; i<=32; i++){
			changeOnlineCheckbox(i,isChecked);
		}
		if(otherMsgSystemKey && otherMsgSystemKey.length > 0){
			for(var j=0; j<otherMsgSystemKey.length; j++){
				changeOnlineCheckbox(otherMsgSystemKey[j],isChecked);
			}
		}
	}
	else{
		for(var i=0; i<=32; i++){
			changeCheckbox(i,flag,anotherFlag,isChecked);
		}
		if(otherMsgSystemKey && otherMsgSystemKey.length > 0){
			for(var j=0; j<otherMsgSystemKey.length; j++){
				changeCheckbox(otherMsgSystemKey[j],flag,anotherFlag,isChecked);
			}
		}
	}
}
function changeOnlineCheckbox(currentId,isChecked){
  var sendOfOnlineObj = document.getElementById("isSendOfOnline"+currentId);
  if(sendOfOnlineObj){
    if(sendOfOnlineObj.disabled == false){
      sendOfOnlineObj.checked = isChecked;
    }
  }
}
function changeCheckbox(currentId,flag,anotherFlag,isChecked){
  var obj = document.getElementById("checkBox"+currentId+flag);
  var anotherObj = document.getElementById("checkBox"+currentId+anotherFlag);
  if(obj){
    obj.checked = isChecked;
    if(anotherObj){
      if(anotherObj.checked && isChecked){
        anotherObj.checked = false;
      }
    }
  }
  var sendOfOnlineObj = document.getElementById("isSendOfOnline"+currentId);
  if(sendOfOnlineObj){
    sendOfOnlineObj.disabled = !((obj && obj.checked) || (anotherObj && anotherObj.checked));
    if(sendOfOnlineObj.disabled == true){
      sendOfOnlineObj.checked = false;
    }
  }
}
/**
 * 移动统计-改变TR背景
 */
var prevIndex = 0;
function changeTRColor(selIndex){
	
	var leftTd = document.getElementById("L"+selIndex);
	var middleTd = document.getElementById("M"+selIndex);
	var rightTd = document.getElementById("R"+selIndex);
	if(leftTd && middleTd && rightTd){
		leftTd.className = "sort mobileCountTRBg";
		middleTd.className = "sort mobileCountTRBg";
		rightTd.className = "sort mobileCountTRBg";		
	}
	var leftTd1 = document.getElementById("L"+prevIndex);
	var middleTd1 = document.getElementById("M"+prevIndex);
	var rightTd1 = document.getElementById("R"+prevIndex);
	if(leftTd1 && middleTd1 && rightTd1){
		leftTd1.className = "sort";
		middleTd1.className = "sort";
		rightTd1.className = "sort";
	}
	prevIndex = selIndex;
}