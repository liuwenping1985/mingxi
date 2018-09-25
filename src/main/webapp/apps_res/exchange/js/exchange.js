		
		
		function modelTransfer(modelType, listType){
			var url = exchangeURL+'?method=listMain&modelType='+modelType;
			if(listType) {
				url += "&listType="+listType;
			}
			parent.location.href = url;
		}

		//公文交换，签收，回退，该函数用于关闭公文交换界面及刷新父页面
		function doEndSign_exchange(alertMsg,affairId) {
			if(alertMsg && alertMsg != "") {
				alert(alertMsg);
			}
			try {
				//办公桌面
		    	try{
			    	if(typeof(window.top)!='undefined'
			    		&& typeof(window.top.opener)!='undefined'
			    		&& typeof(window.top.opener.getCtpTop)!='undefined'
			    		&& typeof(window.top.opener.getCtpTop().refreshDeskTopPendingList) !='undefined'){
			    			window.top.opener.getCtpTop().refreshDeskTopPendingList();
			    	}
		    	}catch(e){}
				//判断当前页面是否是主窗口页面
			    if(getA8Top().isCtpTop){
			    	//暂时没有弹出的dialg
			    } else {
					var _win = window.top.opener.$("#main")[0].contentWindow;
				    if (_win != undefined) {
				        //判断当前是否是首页栏目
				        if (_win.sectionHandler != undefined) {
				            //首页栏目（当点击了统计图条件后处理）
				            if (_win.params != undefined && _win.params.selectChartId != "") {
				                _win._collCloseAndFresh(_win.params.iframeSectionId,_win.params.selectChartId,_win.params.dataNameTemp);
				            } else {
				                //进入首页待办栏目直接处理
				                _win.sectionHandler.reload("pendingSection",true);
				            }
				        } else {
				            //刷新列表
				            _win.location = _win.location;
				        }
				    } else {  //刷新公文列表
				    	_win = window.top.opener.$("#main")[0];
				    	if (_win != undefined) {
				    		//刷新列表
				            _win.location = _win.location;
				    	}
				    }
				    //删除多窗口记录
				    if (affairId) {
				    	removeCtpWindow(affairId,2);
				    }
			    }
			} catch (e){}
			getA8Top().close();
		}
		
		function doEndSign(type) {    
  	 	 if (getA8Top().window.dialogArguments) {
   	    		window.returnValue = "true";
   	    		getA8Top().window.close();
  	 		 }else if(type=='toSend'){
				modelTransfer('toSend', 'listExchangeToSend');
			 }else if(type=='toReceive'){
			 	modelTransfer('toReceive', 'listExchangeToReceive');
			 }else if(type=='sent'){
			 	modelTransfer('sent', 'listExchangeSent');
			 }else{
			 	location.reload();
			 }
		}
		
		
	function setMenuState(menu_id){
 		 var menuDiv=document.getElementById(menu_id);
		 if(menuDiv!=null){
	  		 menuDiv.className='webfx-menu--button-sel';
	  		 menuDiv.firstChild.className="webfx-menu--button-content-sel";
	  		 menuDiv.onmouseover="";
	   		 menuDiv.onmouseout="";
 		 }
	}
	
	function showNextSpecialCondition(conditionObject) {
		    var options = conditionObject.options;
		
		    for (var i = 0; i < options.length; i++) {
		        var d = document.getElementById(options[i].value + "Div");
		        //alert(d);
		        if (d) {
		            d.style.display = "none";
		        }
		  }
	if(document.getElementById(conditionObject.value + "Div") == null) return;
		    document.getElementById(conditionObject.value + "Div").style.display = "block";
	}
	
	function sendPrint2(){
		
	    var imgObj = document.getElementById("grantedDepartIdImg");
	    if(imgObj){
	        imgObj.style.display = "none";
	    }
	    
		var edocBody = document.getElementById("mainDiv").innerHTML;
		
		if(imgObj){
            imgObj.style.display = "";
        }
		
		var edocBodyFrag = new PrintFragment("交换单", edocBody);
	
	var cssList = new ArrayList();
	cssList.add(v3x.baseURL + "/apps_res/exchange/css/exchange.css");
	var pl = new ArrayList();
	pl.add(edocBodyFrag);
	printList(pl,cssList);
}

function recPrint() {
	var pDiv = document.getElementById("pDiv");
	if(pDiv){
		pDiv.style.display = "none";
	}		
	//签收编号
	var recNo = document.getElementById("recNo");
	if($("#recNoSpan") && $("#recNoSpan").size()>0) {
		$("#recNoSpan").remove();
	}
	//OA-30107 公文交换-已签收，打开签收单，点击打印，报js错。
	if(recNo) {
		//recNo.options[recNo.selectedIndex].setAttribute("selected", true);
	  //因采用autocomplete组件，这里打印时，要显示出选择的签收编号，需要将autocomplete中选择的值设置到一个新创建的span中，然后将autocomplete隐藏掉
	  $("#recNo_autocomplete").after("<span id=recNoSpan>"+$("#recNo_autocomplete").val()+"</span>");
    $("#recNo_autocomplete").css("display","none");
    $("#toReceive_recNo img").css("display","none");
    $("#toReceive_recNo button").css("display","none");
	}
	
	//保存期限
	var keepperiod = document.getElementById("keepperiod");
	if(keepperiod && keepperiod.options[keepperiod.selectedIndex]!=null) {
		keepperiod.options[keepperiod.selectedIndex].setAttribute("selected", true);
	}
	//附件说明做多浏览器处理
	var remark = document.getElementById("remark");
	var tempRemarkDiv = null;
	if(remark) {
		try {
		    
		    var remarkValue = remark.innerHTML;
		    if(remarkValue == ""){
		    	remarkValue = remark.value;
            }
	        remarkValue = remarkValue.replace(/&/ig, "&amp;");
	        remarkValue = remarkValue.replace(/</ig, "&lt;");
	        remarkValue = remarkValue.replace(/>/ig, "&gt;");
	        remarkValue = remarkValue.replace(/ /ig, "&nbsp;");
	        remarkValue = remarkValue.replace(/"/ig, "&quot;");
	        remarkValue = remarkValue.replace(/\r\n/ig, "</br>");
	        remarkValue = remarkValue.replace(/\n/ig, "</br>");
	        remarkValue = remarkValue.replace(/\r/ig, "</br>");

	        var remarkHeight = Math.max(remark.scrollHeight, remark.offsetHeight,remark.clientHeight, remark.scrollHeight, remark.offsetHeight);
            var remarkWidth  = Math.max(remark.scrollWidth, remark.offsetWidth,remark.clientWidth, remark.scrollWidth, remark.offsetWidth);
		    
            tempRemarkDiv = document.createElement("DIV");
            tempRemarkDiv.style.height = remarkHeight + "px";
            tempRemarkDiv.style.width = remarkWidth + "px";
            tempRemarkDiv.innerHTML = remarkValue;
            
            remark.style.display = "none";
            remark.parentElement.appendChild(tempRemarkDiv);
            
			//remark.innerHTML = remark.value;
		} catch(e){}		
	}
	
	var edocBody = document.getElementById("div1").innerHTML;
	
	//还原页面
	if(tempRemarkDiv){
	    remark.parentElement.removeChild(tempRemarkDiv);
	}
	remark.style.display = "block";
	
	var edocBodyFrag = new PrintFragment("交换单", edocBody);
	
	var cssList = new ArrayList();
	cssList.add(v3x.baseURL + "/apps_res/exchange/css/exchange.css");
	var pl = new ArrayList();
	pl.add(edocBodyFrag);
	printList(pl,cssList);
	
	var pDiv = document.getElementById("pDiv");
	if(pDiv){
		pDiv.style.display = "";
	}
	//恢复autocomplete的显示，将span删掉
	$("#recNo_autocomplete").css("display","");
	$("#recNoSpan").remove();
	$("#toReceive_recNo img").css("display","");
  $("#toReceive_recNo button").css("display","");
}

/**
 * 1 待登记退回
 * 2 V5-G6 登记开关关闭，待分发回退
 * 上面两种情况，退回时都需要校验 原来的签收人员是否还有签收权限 
 * recieveId  签收数据id
 */
function checkStepBackCompetition(recieveId){
	var exchangeCheck = {};
	//------------------------------从V5待登记列表迁移过来的------------------------------------------start
	//验证是否有公文交换权限
    //V5SP2工作项-V51-1-222公文交换完善（签收-登记阶段）
	var canSubmit = false;//初始提交元素为false状态
	var competitionAction="no";//用来验证当前是不是竞争执行
	//通过当前签收数据ID，获取签收人ID，然后通过AJAX判断当前签收人及当前单位是否有权限
	var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "checkEdocRecieveMember", false);
	//传递签收ID
    requestCaller.addParameter(1, 'String', recieveId);
    var re = requestCaller.serviceRequest();
    //获取返回值
    if(re[0] == 'false') {
        //[0]=false当前签收人已经无公文交换的权限
    	if(re[1] == 'true') {//发送人已经不是收发员了，是否让其它收发员竞争
    		if(confirm(v3x.getMessage('ExchangeLang.edoc_register_stepBack_ToOther_exchangeRole'))) {
    			competitionAction="yes";
    			canSubmit = true;
    		}
    	} else {//发送人已经不是收发员了，并且发送单位已经没有收发员了
    		alert(v3x.getMessage('ExchangeLang.edoc_register_stepBack_hasnot_exchangeRole'));
    	}
    } else if(re[0]=='true'|| re[0] == 'null') {
    	canSubmit = true;
    }
    exchangeCheck.canSubmit = canSubmit;
    exchangeCheck.competitionAction = competitionAction;
    return exchangeCheck;
}

var ExchangeTurnRec = function(grantedDepartId,opinion,deptSelect,orgSelect,summaryId){
	this.grantedDepartId = grantedDepartId;
	this.opinion = opinion;
	this.deptSelect = deptSelect;
	this.orgSelect = orgSelect;
	this.summaryId = summaryId;
}
ExchangeTurnRec.prototype = {
		oprateSubmit:function(){
			var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeTurnRecManager", "isTurnReced",false);
			requestCaller.addParameter(1, "String", this.summaryId);
			var ds = requestCaller.serviceRequest();
			if(ds=="true"){
				alert("已经转收文了，不能再次向下级单位转发!");
				closeDialog();
				return;
			}
			
			if(this.opinion.value.length>4000){
				//alert("办理意见不能超过4000个字!");
				alert(_("edocLang.edoc_alert4000Max"));
				return;
			}
			if(this.grantedDepartId.value==""){
				alert("送往单位不能为空!");
				return;
			}
			if(this.grantedDepartId.value.length>1800){//字段长度是varchar2000
				alert("送往单位超过最大数量!");
				return;
			}
		
			this.checkExchangeRole({"callbackFn":_checkExchangeRoleCallback});//
		},
		checkExchangeRole:function(params){
			var sendUserDepartmentId=document.getElementById("sendUserDepartmentId").value;
			var sendUserAccountId=document.getElementById("sendUserAccountId").value;;
			var selectObj = document.getElementsByName("memberList")[0];
			var selectdExchangeUserId = (selectObj.options[selectObj.selectedIndex]).value;
			var selectdExchangeUserName = (selectObj.options[selectObj.selectedIndex]).innerHTML;
			var callBackFn = params.callbackFn || function(){};
			var hasDeptSelect = false;//是否进行了部门勾选
			
			var typeAndIds="";
			var msgKey="edocLang.alert_set_departExchangeRole";	  
			var obj=this.deptSelect;
			if(obj==null){return true;}
			if(obj.checked){
				var list=document.getElementById("deptSenderList").value;
				  if(list!=null&&list!="undifined"&&list!=""){
					  var _url= genericControllerURL+"edoc/selectDeptSender&memberList="+encodeURIComponent(list);
					  var listArr=list.split("|");
					  if(listArr.length>1){
					      
						  window.selectExchangeDeptParam = {};
						  window.selectExchangeDeptParam.callbackFn = callBackFn;
						  window.selectExchangeDeptParam.msgKey = msgKey;
						  window.selectExchangeDeptParam.selectdExchangeUserName = selectdExchangeUserName;
						  
						  window.selectExchangeDeptWin = getA8Top().$.dialog({
					            title:'选择交换部门',
					            transParams:{'parentWin':window, "popWinName":"selectExchangeDeptWin", "popCallbackFn":_selectExchangeDeptCallback},
					            url: _url,
					            targetWindow:getA8Top(),
					            width:"342",
					            height:"185"
					        });
						  hasDeptSelect = true;
						      
					  }else if(listArr.length==1){
						  sendUserDepartmentId=listArr[0].split(',')[0];
						  document.getElementById("returnDeptId").value=sendUserDepartmentId;
					  }
				  }
				  if(!hasDeptSelect){
				      typeAndIds="Department|"+sendUserDepartmentId;      
	                  selectdExchangeUserId="";
				  }
			 }
			  else
			  {
			  	typeAndIds="Account|"+sendUserAccountId;
			  	msgKey="edocLang.alert_set_accountExchangeRole";
			  }
			
			if(!hasDeptSelect){//不选择部门直接往下执行
			    _selectExchangeDeptAfter(typeAndIds, selectdExchangeUserId, selectdExchangeUserName, msgKey, callBackFn);
			}
		},
		showMemberList:function(){
			var memberListDiv = document.getElementById("selectMemberList");
			memberListDiv.style.display = "";
		},
		hideMemberList:function(){
			var memberListDiv = document.getElementById("selectMemberList");
			memberListDiv.style.display = "none";
		},
		setPeopleFields:function(elements){
			if(elements) {
				var obj1 = getNamesString(elements);
				var obj2 = getIdsString(elements,false);
				
				//document.getElementById("depart").value = getNamesString(elements);
				//document.getElementById("depart").setAttribute("value", getNamesString(elements));
				//setAttribute浏览器不兼容，在IE10下存在问题，不知为何将以前的方法调整成setAttribute，这里修改为用jquery方式来赋值
				//$("#depart").attr("value",getNamesString(elements));
				//document.getElementById("grantedDepartId").value = getIdsString(elements,true);
				
				var sendUnit = getNamesString(elements);
				//$("#depart").val(sendUnit);
				//OA-50892 公文收发员打开待发送公文单，添加送往单位时，送往单位选择框显示不出来刚选择的单位
				document.getElementById("depart").value = sendUnit;
				//OA-49069  在公文交换-待发送列表中填写了送往单位，点击打印，打印的时候显示不出来刚填写的送往单位 
				document.getElementById("depart").setAttribute("value", sendUnit);
				document.getElementById("depart").setAttribute("title", sendUnit);
				$("#grantedDepartId").val(getIdsString(elements,true));
			}
		},
		closeDialog:function(){
			p_getCtpTop().turnRecDialog.close();
		}
}

/**
 * 选择部门交换或者不需要选择时进行执行
 */
function _selectExchangeDeptAfter(typeAndIds, selectdExchangeUserId, selectdExchangeUserName, msgKey, callbackFn){
    
    var requestCaller = new XMLHttpRequestCaller(this,
            "ajaxEdocExchangeManager", "checkExchangeRole", false);
    requestCaller.addParameter(1, "String", typeAndIds);
    requestCaller.addParameter(2, "String", selectdExchangeUserId);
    var ds = requestCaller.serviceRequest();
    if (ds == "check ok") {
        callbackFn(true);
    } else if (ds == "changed") {// xiangfan 添加逻辑判断
        alert("<fmt:message key='edoc.Cancel.exchange.privileges1' />"
                + selectdExchangeUserName
                + "<fmt:message key='edoc.Cancel.exchange.privileges2'/>");
        callbackFn(false);
    } else {
        alert(_(msgKey, ds));
        callbackFn(false);
    }
}

/**
 * 选择交换部门后弹出框
 */
function _selectExchangeDeptCallback(sendUserDepartmentId) {

    var callbackFn = window.selectExchangeDeptParam.callbackFn;
    var msgKey = window.selectExchangeDeptParam.msgKey;
    var selectdExchangeUserName = window.selectExchangeDeptParam.selectdExchangeUserName;
    
    if (sendUserDepartmentId == "cancel"
            || typeof (sendUserDepartmentId) == 'undefined') {
        callbackFn(false);
    }else{
        document.getElementById("returnDeptId").value = sendUserDepartmentId;
        var typeAndIds = "Department|" + sendUserDepartmentId;
        var selectdExchangeUserId = "";
        _selectExchangeDeptAfter(typeAndIds, selectdExchangeUserId, selectdExchangeUserName, msgKey, callbackFn);
    }
}

/**
 * 选择交换部门后回调函数
 * @param value
 */
function _checkExchangeRoleCallback(value){
    if(value==false){
        //不做处理
    }else{
        $("#oprateButton").attr("disabled","disabled");
        var form = $("#detailForm")[0];
        form.submit();
    }
}