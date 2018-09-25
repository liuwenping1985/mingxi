/**isearch\home.jsp中方法**start**/
    //查询类型
	function onChangeAppType(ele){
		document.getElementById("appKey").value = ele.value;
		enabledCondition();
		var ops = ele.options;
		for(var i = 0; i < ops.length; i++){
			var op = ops[i];
			if(op.selected){
				if(op.getAttribute("docLibSelect") == 'true'){
					enabledDocLibEles();
					disabledPigEles();
				}else {
					disabledDocLibEles();
					disabledPigEles();
					if(op.getAttribute("hasPiged") == 'true'){
						enabledPigEles();					
						var pigedEle = document.getElementById("auditOption5");
						if(pigedEle.checked)
							enabledDocLibEles();
						else
							disabledDocLibEles();
					}
					
				}
				break;
			}
		}
		/*if (ele.value >= 7 && ele.value <= 10) {
		    disabledPigEles();
		}*/
		makeDataDumpOption();
	}
	
	//启用发起条件
	function enabledCondition(){
	    document.getElementById("auditOption1").checked = true;
        document.getElementById("auditOption1").disabled = false;
        document.getElementById("auditOption2").disabled = false;
        document.getElementById("auditOption3").disabled = false;
        onChangeSendType(document.getElementById("auditOption1"));
    }
	
	//禁用发起条件
    function disabledCondition(){
        document.getElementById("auditOption1").checked = false;
        document.getElementById("auditOption2").checked = false;
        document.getElementById("auditOption3").checked = false;
        document.getElementById("auditOption1").disabled = true;
        document.getElementById("auditOption2").disabled = true;
        document.getElementById("auditOption3").disabled = true;
    }
	
	//协同：显示“转储数据”
	function makeDataDumpOption(){
        if(document.getElementById("dumpDataDiv")){
            document.getElementById("dumpDataDiv").style.display = (document.getElementById("condition").value == "1" ? "" : "none");
            if(document.getElementById("auditOption6").checked){
                document.getElementById("auditOption4").checked = true;
            }
        }
	}

	function enabledDocLibEles(){
		document.getElementById("docLibSelect").disabled = false;
		document.getElementById("keywords").disabled = false;
		//document.getElementById("key1").className = "";
		//document.getElementById("key2").className = "";
		var appkey = document.getElementById("condition").value;
		if(appkey >= 7 && appkey <= 10) {
			var pigedEle = document.getElementById("auditOption5");
			if(pigedEle.checked)
				disabledCondition();
		} 
	}
	function disabledDocLibEles(){
		document.getElementById("docLibSelect").disabled = true;
		document.getElementById("keywords").disabled = true;
		document.getElementById("keywords").value = "";
		//document.getElementById("key1").className = "hidden";
		//document.getElementById("key2").className = "hidden";	
		var appkey = document.getElementById("condition").value;
		if(appkey >= 7 && appkey <= 10) {
			var pigedEle = document.getElementById("auditOption5");
			if(!pigedEle.checked)
				enabledCondition();
		} 
	}
	function disabledPigEles(){
		document.getElementById("auditOption4").disabled = true;
		document.getElementById("auditOption5").disabled = true;
	}
	function enabledPigEles(){
		document.getElementById("auditOption4").disabled = false;
		document.getElementById("auditOption5").disabled = false;
	}
	//已归档下拉列表
	function onChangeDocLib(ele){
		document.getElementById("docLibId").value = ele.value;
	}
	//我发出的，发给我的
	function onChangeSendType(ele){
		var value = ele.value;
		if("send" == value){
			if(document.getElementById("otherSendSpan")){
				document.getElementById("otherSendSpan").innerHTML=v3x.getMessage("IsearchLang.isearch_target_people");
			}
			if( elements_per ){
				elements_per=null;
			}
			document.getElementById("currentSendType").value = 'send';
			
			document.getElementById("fromUserId").value = '';
			document.getElementById("toUserId").value = '';
			document.getElementById("fromUserId").value = currentUserId;
			showOriginalElement_per=false;
		}else if("to" == value){
			if(document.getElementById("otherSendSpan")){
				document.getElementById("otherSendSpan").innerHTML=v3x.getMessage("IsearchLang.isearch_target_people");
			}
			if( elements_per ){
				elements_per=null;
			}
			document.getElementById("currentSendType").value = 'to';
			
			document.getElementById("fromUserId").value = '';
			document.getElementById("toUserId").value = currentUserId;
			showOriginalElement_per=false;
		}else if("other" == value){
			var lastSendType = document.getElementById("currentSendType").value;
			if( lastSendType!='other' ){
				document.getElementById("fromUserId").value = '';
				document.getElementById("currentSendType").value = 'other';
			}
			
			document.getElementById("toUserId").value = currentUserId;
			selectPeopleFun_per();
			showOriginalElement_per=true;
		}
	}

	//未归档
	function onChangePigFlag(ele){
		var value = ele.value;
		if('1' == value){
			enabledDocLibEles();
		}else{
			disabledDocLibEles();
		}
	}
	//submit
	function dealOnSubmit(form_){
		if(!checkForm(form_))
			return false;
	
		var b = "isearchCForm.beginDate.value";
 		
 		var e = "isearchCForm.endDate.value";
        
        if(typeof(eval(b))!="undefined" && typeof(eval(e))!="undefined"){
			if(compareDate(eval(b),eval(e)) > 0){			
				alert(v3x.getMessage("IsearchLang.isearch_begin_later_than_end_alert"));
				return false;
			}	 	 		
 		}
 		return true;
	}
	//v3x:selectPeople
	function otherSend(elements){
		if(!elements) {
			return;
		}
		var theid = getIdsString(elements, false);
		document.getElementById("otherSendSpan").innerHTML = getNamesString(elements);
		document.getElementById("fromUserId").value = theid;
	}
/**isearch\home.jsp中方法**end**/

/**isearch\dataList.jsp中方法**start**/

	function openDataDetail(_url, appKey) {
		//公告，新闻，讨论，调查 打开方式为xia mian de 方法
		if(appKey && ('7' == appKey || '8' == appKey || '9' == appKey || '10' == appKey)){
			openWinDetail(_url);
		}else if(appKey && '11' == appKey){// 日程事件
			var rv = v3x.openWindow({
				url: _url,
				width : 550,
				height: 430,
	            resizable: false,
	            dialogType:v3x.getBrowserFlag('openWindow')?'modal':'open'
			});
		}else{
			var rv = v3x.openWindow({
				url: _url,
				workSpace: 'yes',
				dialogType:v3x.getBrowserFlag('openWindow')?'modal':'open'
			});
			if(rv && 'true' == rv)
				window.location.reload(true);
		}

	}
	//调查、新闻、公告、讨论 - 查看页面弹出窗口公用方法
	function openWinDetail(urls){
		var windowWidth =  screen.width-155;
		var windowHeight =  screen.height-160;
		v3x.openWindow({
			url : urls,
			width : windowWidth,
			height : windowHeight,
			top : 130,
			left : 145,
			resizable: "yes",
			dialogType: "open"
		});
	}
	
	
	
/**isearch\dataList.jsp中方法**end**/