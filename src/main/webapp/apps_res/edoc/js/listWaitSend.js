
var distributeRetreatParam = {}
function distributeRetreat(){
    
	var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }
	var id_checkbox = document.getElementsByName("id");
	var hasMoreElement = false;
    var len = id_checkbox.length;
    var countChecked = 0;
    var obj;
    var exchangeMode=0;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
        	obj = id_checkbox[i];
            hasMoreElement = true;
            exchangeMode=obj.getAttribute("exchangeMode");
            countChecked++;
        }
    } 
    if(exchangeMode==1){
		alert(v3x.getMessage("edocLang.edoc_exchange_sursen"));
		return;
	}  
    if (!hasMoreElement) {
        alert(v3x.getMessage("edocLang.edoc_alertStepBackItem"));
        return true;
    }
    
    if(countChecked > 1){
    	alert(v3x.getMessage("edocLang.edoc_alertSelectStepBackOnlyOne"));
        return true;
    }
    
    var isAutoRegister = obj.getAttribute("autoRegister");
    var tempReceiveId = obj.getAttribute("receiveId");
    if((isAutoRegister == "1" || isAutoRegister == "") && (!tempReceiveId || tempReceiveId == "0" || tempReceiveId == "1")){
        //手动分发的数据不能进行回退
        //对不起，当前选择的公文不支持回退。
        alert(v3x.getMessage("edocLang.edoc_alert_register_stepback2"));
        return;
    }
    
    var registerType = obj.getAttribute("registerType");
    
    //指定回退-直接提交回退者不能回退
    var tempSubState = obj.getAttribute("subState");
    if(16 == tempSubState){//指定回退-直接提交，我的状态
        //当前公文为“指定回退-提交给我”的策略，不能回退！
        alert(v3x.getMessage("edocLang.edoc_alert_register_stepback3"));
        return;
    }

    //纸质登记的，登记开关关闭时，就不能回退了
  //2015年8月28日 修改isOpenRegister判断  简化公文交换环节，以前开关只有两个选项，是boolean类型，现在有三个选项，修改判断 xiex 
    if(isG6 == "true" && _isOpenRegister != "1" && registerType != 1){
        //当前环境已关闭登记环节，纸质登记与二维码登记的公文暂时不能回退。
        alert(v3x.getMessage("edocLang.edoc_alert_register_stepback1"));
        return;
    }
    
    var resgisteringEdocId = obj.getAttribute("registerId");
    var canSubmit = true;
    var competitionAction = "no";
    var jzRun=true;
    
    if(isG6 = "true"){//G6逻辑
      //当如果是自动登记的，分发回退就需要判断 原签收人还有签收权限吗
    	//2015年8月28日 修改isOpenRegister判断  简化公文交换环节，以前开关只有两个选项，是boolean类型，现在有三个选项，修改判断 xiex 
        if(_isOpenRegister != "1" || isAutoRegister == 1){
            //获得签收记录id
            var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "getRecieveIdByRegisterId", false);
            //传递签收ID
            requestCaller.addParameter(1, 'Long', resgisteringEdocId);
            var recieveId = requestCaller.serviceRequest();
            var exchangeCheck = checkStepBackCompetition(recieveId);
            if(exchangeCheck){
                canSubmit = exchangeCheck.canSubmit;
                competitionAction=exchangeCheck.competitionAction;
            }else{
                canSubmit = false;
            }
        }
    }else{//A8逻辑
        
        //通过当前签收数据ID，获取签收人ID，然后通过AJAX判断当前签收人及当前单位是否有权限
        var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "checkEdocRecieveMember", false);
        //传递签收ID
        requestCaller.addParameter(1, 'String', tempReceiveId);
        var re = requestCaller.serviceRequest();
        //获取返回值
        if(re[0] == 'false') {
            //[0]=false当前签收人已经无公文交换的权限
            if(re[1] == 'true') {//发送人已经不是收发员了，是否让其它收发员竞争
                if(confirm(v3x.getMessage('ExchangeLang.edoc_register_stepBack_ToOther_exchangeRole'))) {
                    competitionAction = "yes";
                    canSubmit = true;
                }
            } else {//发送人已经不是收发员了，并且发送单位已经没有收发员了
                alert(v3x.getMessage('ExchangeLang.edoc_register_stepBack_hasnot_exchangeRole'));
                return;
            }
        } else if(re[0]=='true'|| re[0] == 'null') {
            canSubmit = true;
        }
    }
    
    //2015年8月28日 修改isOpenRegister判断  简化公文交换环节，以前开关只有两个选项，是boolean类型，现在有三个选项，修改判断 xiex 
    //判断公文登记人是否还有权限（    登记开关打开  && isAutoRegister：这条登记数据是否自己登记产生 ）
    if(isG6 == "true" && _isOpenRegister == "1" && isAutoRegister != 1){
        var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "checkRegisterByRegisterEdocId", false);
        requestCaller.addParameter(1, 'Long', resgisteringEdocId);
        var res = requestCaller.serviceRequest();
        res = res.split(",");
        if(res[0] == "false" && res[1] == "false"){
            alert(_("edocLang.edoc_noRegisterExistCannotStepBack"));
            return;
        }else if(res[0] == "false" && res[1] == "true"){
            if(!window.confirm(_("edocLang.edoc_confirmRegisterCancelStepBackOther"))){
                return;
            }else{
                jzRun=false;
                competitionAction = "yes";
            }
        }
    }
    
    if(canSubmit){
        
        if (jzRun && !window.confirm(_("edocLang.edoc_confirmStepBackItem"))){
            return;
        }
        
        distributeRetreatParam.resgisteringEdocId = resgisteringEdocId;
        distributeRetreatParam.competitionAction = competitionAction;
        
        getA8Top().win123 = getA8Top().$.dialog({
            title:v3x.getMessage("edocLang.edoc_label_stepback_title"),//回退附言
            transParams:{'parentWin':window},
            url:'exchangeEdoc.do?method=openStepBackDistribute&resgisteringEdocId='+resgisteringEdocId,
            width:"400",
            height:"300",
            resizable:"0",
            scrollbars:"true",
            dialogType:"modal"
        });
    }
}

function huituiCallback(returnValues){
    
    if(returnValues!=null && returnValues != undefined){
        
        if(1==returnValues[0]){
            var resgisteringEdocId = distributeRetreatParam.resgisteringEdocId;
            var competitionAction = distributeRetreatParam.competitionAction;
            var theForm = document.getElementsByName("listForm")[0];
            
            theForm.action = genericURL+'?method=distributeRetreat&registerId='+resgisteringEdocId+'&stepBackInfo='+ encodeURIComponent(returnValues[3])
                +'&competitionAction='+competitionAction;
            theForm.method = "POST";
            theForm.submit();
        }
    }
}

function doSearch2(){
	var flag = true;
	var recieveDate = document.getElementById("recieveDateDiv");
	if(recieveDate && recieveDate.style.display == "block"){
		var begin = document.getElementById("recieveDateBegin").value;
		var end = document.getElementById("recieveDateEnd").value;
		flag = timeValidate(begin,end);
	}

	var registerDate = document.getElementById("registerDateDiv");
	if(registerDate && registerDate.style.display == "block"){
		var begin = document.getElementById("registerDateBegin").value;
		var end = document.getElementById("registerDateEnd").value;
		flag = timeValidate(begin,end);
	}
	
	if(flag){
		doSearch();
	}
}