//发送手机短信-Form校验
function check(){
	if(document.all.sendTo.value=="")
	{
		alert(_("MainLang.mobileMsg_send_alert_noReceiver"));
		selectPeopleFun_addReceiver();
		return false;
	}
	if(document.all.content.value==""){
		alert(_("MainLang.mobileMsg_send_alert_noContent"));
		document.getElementById("msgContent").focus();
		return false;
	}
	document.getElementById("submitButton").disabled = true;
	return true;
 }

//发送手机短信-按键事件
function doKeyPressedEvent(){
	if(event.ctrlKey && event.keyCode==13){
	  check();
	  document.all.sendForm.submit();
	}
	else if(event.keyCode == 27){
		window.close();
	}
}
function windowLoadCheck(isAdmin, isAllowCustom){
  if ($(".tr_26_0").find("input:checked").length > 0) {
    document.getElementById("App_26_0").checked=true;
  }
  if ($(".tr_26_1").find("input:checked").length > 0) {
    document.getElementById("App_26_1").checked=true;
  }
  if ($(".tr_26_2").find("input:checked").length > 0) {
    document.getElementById("App_26_2").checked=true;
  }
  if ($(".tr_26_3").find("input:checked").length > 0) {
    document.getElementById("App_26_3").checked=true;
  }
  
  var parentIndex=['7','8','9','10'];
  for(var i=0;i<parentIndex.length;i++){
    if ($(".tr_" + parentIndex[i] + "_all").find("input:checked").length < 1) {
      if(document.getElementById("App_" + parentIndex[i])){
    	  document.getElementById("App_" + parentIndex[i]).checked = false;
      }
    }
    
    var parentObj=document.getElementsByName("App"+parentIndex[i]+"_Q");
    if(parentObj!=null){
      for(var k=0;k<parentObj.length;k++){
        var parentflag=false;
        var obj = document.getElementsByName("Option"+parentIndex[i]+"_" +(k+1));
        if(obj != null){
          for(var n = 0; n < obj.length; n++){
            if(obj[n]&&obj[n].checked){
              parentflag=true;
            }
          }
        }
        if(parentObj){
          parentObj[k].checked=parentflag;
        }
      }
    }
  }
  
  if ($(".tr_78910_all").find("input:checked").length < 1) {
	if(document.getElementById("App_78910")){
		document.getElementById("App_78910").checked = false;
	}
  }
  
  if ($(".tr_31_1").find("input:checked").length > 0) {
    document.getElementById("App31_1").checked=true;
  }
  if ($(".tr_31_2").find("input:checked").length > 0) {
    document.getElementById("App31_2").checked=true;
  }
  
  if (isAdmin == "false" && isAllowCustom == "false") {
  	$("#msgSettingTr").find("input[type='checkbox']").attr("disabled", "disabled"); 
  }
}
//发送手机短信-选择接收者的事件处理
function showReceiver(elements){
	if(!elements){
		return;
	}
	document.all.sendTo.value = getNamesString(elements);
	document.all.receiverIds.value = getIdsString(elements, false);
}

//发送结果返回信息
//noTelNumberMembers
function showSendResult(noTelNumberMembers){
	var returnMsg = _("MainLang.mobileMsg_send_alert_putInQueue");
	if(noTelNumberMembers){
		returnMsg += "\n----------------------------------------------------\n";
		returnMsg += _("MainLang.mobileMsg_send_alert_noTelNumTip");
		returnMsg += "\n" + noTelNumberMembers;
	}
	transParams.parentWin.sendSmsCollBack(returnMsg);
}

//发送结果返回信息
function showSendPersonalSMSResult(){
	var returnMsg = _("MainLang.mobileMsg_send_alert_putInQueue");
	transParams.parentWin.sendSmsCollBack(returnMsg);
}

//所选接收者都未填写手机号码
function showErrorResult(){
	transParams.parentWin.sendSmsCollBack(_("MainLang.mobileMsg_send_error_noLegitimacyTelNum"));
}



/****
 * **************************************************************
 * 
 * 个人消息转移设置
 * 
 * **************************************************************
 */
//选中所有子项并设置AllInput的值
function selectAndSetAll(appEnumValue){
	var theAllInputObj = document.getElementById("AllInput_" + appEnumValue);
	var objcts = document.getElementsByName("Option_" + appEnumValue);
	//选中父项
	if(document.getElementById("App_" + appEnumValue).checked){
	    theAllInputObj.value = "ALL";
		if(objcts != null){
			for(var i = 0; i < objcts.length; i++){
				objcts[i].checked = true;
			}
		}
	}
	else{
		theAllInputObj.value = "";
		if(objcts != null){
			for(var i = 0; i < objcts.length; i++){
				objcts[i].checked = false;
			}
		}
	}
}

function selectAndSetAll1(index){
  var apps=document.getElementById("App_" + index);
  var theAllInputObj26 = document.getElementById("AllInput_26");
  
  var theAllInputObj5 = document.getElementById("AllInput_5");
  var theAllInputObj30 = document.getElementById("AllInput_30");
  var theAllInputObj11 = document.getElementById("AllInput_11");
  
  var theAllInputObj7 = document.getElementById("AllInput_7");
  var theAllInputObj8 = document.getElementById("AllInput_8");
  var theAllInputObj9 = document.getElementById("AllInput_9");
  var theAllInputObj10 = document.getElementById("AllInput_10");
  
  var theAllInputObj31 = document.getElementById("AllInput_31");
  
    if (apps.checked) {
    	if (index == "26") {
    		theAllInputObj26.value = "ALL";
    	} else if (index == "53011") {
    		theAllInputObj5.value = "ALL";
            theAllInputObj30.value = "ALL";
            theAllInputObj11.value = "ALL";
    	} else if (index == "78910") {
    		theAllInputObj7.value = "ALL";
            theAllInputObj8.value = "ALL";
            theAllInputObj9.value = "ALL";
            theAllInputObj10.value = "ALL";
    	} else if (index == "31") {
    		theAllInputObj31.value = "ALL";
    	}
        $(".tr_" + index + "_all").find("input[type='checkbox']").attr("checked", "checked");
    } else {
    	if (index == "26") {
            theAllInputObj26.value = "";
        } else if (index == "53011") {
            theAllInputObj5.value = "";
            theAllInputObj30.value = "";
            theAllInputObj11.value = "";
        } else if (index == "78910") {
            theAllInputObj7.value = "";
            theAllInputObj8.value = "";
            theAllInputObj9.value = "";
            theAllInputObj10.value = "";
        } else if (index == "31") {
            theAllInputObj31.value = "";
        }
        $(".tr_" + index + "_all").find("input[type='checkbox']").attr("checked", "");
    }
}

function selectAndSetAll2(appEnumValue, index){
    var apps=document.getElementById("App_" + index);
  var appObj=document.getElementById("App_" + appEnumValue);
  var theAllInputObj = document.getElementById("AllInput_" + appEnumValue);
  
  if (appObj.checked) {
        theAllInputObj.value = "ALL";
        $(".tr_" + appEnumValue + "_all").find("input[type='checkbox']").attr("checked", "checked");
    } else {
        theAllInputObj.value = "";
        $(".tr_" + appEnumValue + "_all").find("input[type='checkbox']").attr("checked", "");
    }
    
  if ($(".tr_" + index + "_all").find("input:checked").length > 0) {
    apps.checked=true;
  } else {
    apps.checked=false;
  }
}

function selectAndSetAll3(appEnumValue, index){
  var appObj=document.getElementById("App_" + appEnumValue);
  var obj = document.getElementById("App_" + appEnumValue + "_" + index);
  var theAllInputObj = document.getElementById("AllInput_" + appEnumValue);
  
  if (obj.checked) {
        $(".tr_" + appEnumValue + "_" + index).find("input[type='checkbox']").attr("checked", "checked");
    } else {
        theAllInputObj.value = "";
        $(".tr_" + appEnumValue + "_" + index).find("input[type='checkbox']").attr("checked", "");
    }
    
  if ($(".tr_" + appEnumValue + "_all").find("input:checked").length > 0) {
    appObj.checked=true;
  } else {
    appObj.checked=false;
  }
}

function selectAndSetAll4(appEnumValue, index){
    var appObj=document.getElementById("App_" + appEnumValue);
    var obj = document.getElementById("App" + appEnumValue + "_" + index);
    var theAllInputObj = document.getElementById("AllInput_" + appEnumValue);
    
    if (obj.checked) {
          $(".tr_" + appEnumValue + "_" + index).find("input[type='checkbox']").attr("checked", "checked");
      } else {
          theAllInputObj.value = "";
          $(".tr_" + appEnumValue + "_" + index).find("input[type='checkbox']").attr("checked", "");
      }
      
    if ($(".tr_" + appEnumValue + "_all").find("input:checked").length > 0) {
      appObj.checked=true;
    } else {
      appObj.checked=false;
    }
  }

//设置父节点状态 <当前复选框, 应用序号值, 取消全部子项时是否同步取消父项的勾选>
function checkParentNode(checkboxObj, appEnumValue){
    //选中子项勾选父菜单
    var parentObj = document.getElementById("App_" + appEnumValue);
    var theAllInputObj = document.getElementById("AllInput_" + appEnumValue);
    var checkedFlag = checkboxObj.checked;
    if(checkedFlag){
        parentObj.checked = true;
    }   
    var objcts = document.getElementsByName("Option_" + appEnumValue);
    if(objcts != null){
        for(var i = 0; i < objcts.length; i++){
            if((checkedFlag&&!objcts[i].checked) || (!checkedFlag&&objcts[i].checked)){
                theAllInputObj.value = "";
                break;
            }
            if(i == objcts.length-1){
                parentObj.checked = checkedFlag;
                theAllInputObj.value = checkedFlag? "ALL" : "";
            }
        }
    }
}

function checkParentNode2(checkboxObj,appEnumValue,index){
  //选中子项勾选父菜单
  var parentObj = document.getElementById("App_" + appEnumValue);
  var parentObj2 = document.getElementById("App"+appEnumValue+"_" +index );
  var parentObj3 = document.getElementById("App_78910");
  var theAllInputObj = document.getElementById("AllInput_" + appEnumValue);
  var objflag=false;
  var allflag=true;
  var checkedFlag = checkboxObj.checked;
  if(checkedFlag){
    parentObj.checked = true;
    parentObj2.checked = true;
    if(appEnumValue=='7'||appEnumValue=='8'||appEnumValue=='9'||appEnumValue=='10'){
      parentObj3.checked = true;
    }
  }
  var objcts = document.getElementsByName("Option"+appEnumValue+"_" +index );
  if(objcts != null){
    for(var i = 0; i < objcts.length; i++){
      if((checkedFlag&&!objcts[i].checked) || (!checkedFlag&&objcts[i].checked)){
        theAllInputObj.value = "";
        allflag=false;
        break;
      }
      if(i == objcts.length-1){
        parentObj2.checked = checkedFlag;
        theAllInputObj.value = checkedFlag? "ALL" : "";
      }
    }
    var appObjQ=document.getElementsByName("App" + appEnumValue+"_Q");
    if(appObjQ){
      for(var i=0;i<appObjQ.length;i++){
        if(appObjQ[i].checked){
          objflag=true;
        }
        if(!appObjQ[i].checked){
          allflag=false;
        }
      }
      parentObj.checked = objflag;
      if(allflag){
        var allObjValue="ALL";
        for(var j=0;j<appObjQ.length;j++ ){
          var objcts1 = document.getElementsByName("Option"+appEnumValue+"_" +(j+1) );
          if(objcts1 != null){
            for(var i = 0; i < objcts1.length; i++){
              if(!objcts1[i].checked){
                allObjValue="";
              }
            }
          }
        }
        //theAllInputObj.value =allObjValue;
      }
    }
    if(parentObj.checked==false &&(appEnumValue=='7'||appEnumValue=='8'||appEnumValue=='9'||appEnumValue=='10')){
      var parentAllflag=false;
      var parentIndex=['7','8','9','10'];
      if(appEnumValue==7||appEnumValue==8||appEnumValue==9||appEnumValue==10){
        for(var i=0;i<parentIndex.length;i++){
            var obj=document.getElementsByName("App" + parentIndex[i]+"_Q");
            if(obj != null){
              for(var n = 0; n < obj.length; n++){
                if(obj[n]&&obj[n].checked){
                  parentAllflag=true;
                }
              }
            }
       }
       document.getElementById("App_78910").checked=parentAllflag;
      }
    }
  }
}
function checkParentNode3(checkboxObj,appEnumValue,index){
  //选中子项勾选父菜单
  var parentObj = document.getElementById("App_" + appEnumValue);
  var parentObj2 = document.getElementById("App_" + index);
  var theAllInputObj = document.getElementById("AllInput_" + appEnumValue);
  var checkedFlag = checkboxObj.checked;
  var allflag=true;
  var parentAllflag=false;
  if(checkedFlag){
    parentObj.checked = true;
    parentObj2.checked = true;
  }
  var objcts = document.getElementsByName("Option_" +appEnumValue );
  if(objcts != null){
    for(var i = 0; i < objcts.length; i++){
      if((checkedFlag&&!objcts[i].checked) || (!checkedFlag&&objcts[i].checked)){
        theAllInputObj.value = "";
        allflag=false;
        break;
      }
      if(i == objcts.length-1){
        parentObj.checked = checkedFlag;
      }
    }
   // theAllInputObj.value =parentObj.checked?(allflag? "ALL" : ""):"";
    if(parentObj.checked==false){
      var parentIndex=['30','5'];
      for(var i=0;i<parentIndex.length;i++){
        if(parentIndex[i]!=appEnumValue){
          var obj = document.getElementsByName("Option_" +parentIndex[i] );
          if(obj != null){
            for(var n = 0; n < obj.length; n++){
              if(obj[n]&&obj[n].checked){
                parentAllflag=true;
              }
            }
            if(appEnumValue!=11&&document.getElementById("App_11").checked){
              parentAllflag=true;
            }
            parentObj2.checked=parentAllflag;
          }
        }  
      }
    }
  }
}
function checkParentNode4(checkboxObj,appEnumValue,index){
  var parentObj = document.getElementById("App_" + appEnumValue);
  var parentObj2 = document.getElementById("App_" + index);
  var theAllInputObj = document.getElementById("AllInput_" + appEnumValue);
  if(checkboxObj.checked){
    parentObj2.checked = true;
    parentObj.checked = true;
  }
  
  if ($(".tr_" + index).find("input:checked").length > 0) {
    parentObj2.checked=true;
  } else {
    parentObj2.checked=false;
  }
  
  var objcts = document.getElementsByName("Option_" +appEnumValue );
  if(objcts != null){
  	var allflag=true;
    for(var i = 0; i < objcts.length; i++){
      if(!objcts[i].checked){
        allflag=false;
        break;
      }
    }
    theAllInputObj.value =allflag? "ALL" : "";
     if ($(".tr_" + appEnumValue + "_all").find("input:checked").length > 0) {
        parentObj.checked=true;
      } else {
        parentObj.checked=false;
      }
  }
}
function trShowOrHide(obj,index){
  $(".tr_"+index).toggle();
  if(obj.className=='ico16 arrow_2_b'){
    obj.className='ico16 arrow_2_t';
  }else{
    obj.className='ico16 arrow_2_b';
  }
}
function toDefault(){
  var index=['1','3','4','5','6','7','8','9','10','11','25','26','30','31','32'];
  for(var i=0;i<index.length;i++){
    if(type == "pc"){
        if (document.getElementById("AllInput_" + index[i])) {
            document.getElementById("AllInput_" + index[i]).value="ALL";
        }
    }else{
        if (document.getElementById("AllInput_" + index[i])) {
            document.getElementById("AllInput_" + index[i]).value="";
        }
    }
  }
  if(type == "pc"){
    $(":checkbox").attr("checked",true);
  }else{
    $(":checkbox").attr("checked",false);
  }
  $("#allowCustom").attr("checked",true);
}

function sendSmsCollBack (sendResult) {
	getA8Top().senSmsWin.close();
	if(!sendResult){
		return;
	}
	alert(sendResult);
}