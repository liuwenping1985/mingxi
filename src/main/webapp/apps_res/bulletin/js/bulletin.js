try {
    getA8Top().endProc();
}
catch(e) {
}


//配置当前运行环境是否为测试状态
//如果为测试状态，则使用模拟的选人对话框
var test=false;
var baseUrl="";
var managerName = "ajaxBulDataManager";
//var v3x.getMessage("bulletin.please_select_record")=v3x.getMessage("bulletin.please_select_record");
//	function myPigeonhole(appName){
//		var ids=getSelectIds();
//		if(ids==''){
//			alert(v3x.getMessage("bulletin.please_select_record"));
//			return;
//		}
//		if(!confirm(v3x.getMessage("bulletin.confirm_pigeonhole"))) return;
//		
//		if(pigeonhole(appName,ids)){
//			parent.location.href=baseUrl+"pigeonhole"+'&id='+ids;
//		}else{
//			alert(v3x.getMessage("bulletin.pigeonhole_failure"));
//		}
//	}
		function getTypeSelectId(){
		var ids=document.getElementsByName('id');
		var count = 0;
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				count += 1;
				if(count > 1) {
					id='false';
					break;
				}
				id=idCheckBox.value;		
			}
		}
		return id;	
	}

	var myPigeonholeItem = {};
	function myPigeonhole(appName, spaceType, appType){
		var theForm = document.getElementsByName("listForm")[0];
	    if (!theForm) {
	        return false;
	    }
		
		var ids=getSelectIds();
		var showAudit=document.getElementById('showAudit').value;
		var result = "";
		if(ids==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		var atts = getSelectAtts();
		myPigeonholeItem.spaceType = spaceType;
		myPigeonholeItem.appType = appType;
		myPigeonholeItem.showAudit = showAudit;
		pigeonhole(appName,ids, atts,"","","bulletionPigeonCollBack");
	}
	
	function bulletionPigeonCollBack (result) {
		var theForm = document.getElementsByName("listForm")[0];
	    if (!theForm) {
	        return false;
	    }
		if(result=='failure'){
			alert(v3x.getMessage("bulletin.pigeonhole_failure"));
			return;
		}else if(result=='cancel'){
			return;
		}else{
			var ids=getSelectIds();
			var _archiveIds = result.split(",");
			for (var i=0; i<_archiveIds.length; i++){
		    	var archiveId = _archiveIds[i];
		    	//var element = document.createElement("<INPUT TYPE=HIDDEN NAME=archiveId value='" + archiveId + "' />");
		    	var element = document.createElement("input");
		    	element.type = "hidden";
		    	element.name = "archiveId";
		    	element.value = archiveId;
			    theForm.appendChild(element);
	    	}
			theForm.action = baseUrl+"pigeonhole"+'&id='+ids + "&spaceType=" + myPigeonholeItem.spaceType + "&type=" + myPigeonholeItem.appType +"&showAudit=" +myPigeonholeItem.showAudit;
			theForm.method = "post";
		    theForm.target = "_self";
			theForm.submit();
		}
	}
	
	function myPigeonhole4Ipad(appName, spaceType, appType){
		var ids=getSelectIds();
		if(ids==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		var showAudit=document.getElementById('showAudit').value;
		var atts = getSelectAtts();
		var type = "";
    	var validAcl = undefined;
		var result = v3x.openDialog({
    	    	id:"mypigeonholeIpad",
    	    	title:"",
    	    	url : pigeonholeURL + "?method=listRoots&isrightworkspace=pigeonhole&appName=" + appName + "&atts=" + atts + "&validAcl=" + validAcl+"&pigeonholeType="+type,
    	    	targetWindow:getA8Top(),
    	    	width: 500,
    	        height: 500,
    	        //type:'panel',
    	        //relativeElement:obj,
    	        buttons:[{
    				id:'btn1',
    	            text: v3x.getMessage("collaborationLang.submit"),
    	            handler: function(){    	        	
    	        		var returnValues = result.getReturnValue();
	    	        	var theForm = document.getElementsByName("listForm")[0];
	   					if (!theForm) {
	        				return false;
	    				}
	    	        	if(returnValues){
	    	            var pigeonholeData = returnValues.split(",");
	    	            pigeonholeId = pigeonholeData[0];
	    	            pigeonholeName = pigeonholeData[1];
	    	            if(pigeonholeId == "" || pigeonholeId == "failure"){
	    	            	theForm.archiveName.value = "";
	    	            	alert(v3x.getMessage("collaborationLang.collaboration_alertPigeonholeItemFailure"));
	    	            }
		    			var archiveId = pigeonholeId;
		    			var element = document.createElement("input");
		    			element.setAttribute("type","hidden");
		    			element.setAttribute("name","archiveId");
		    			element.setAttribute("value",archiveId);
			    		theForm.appendChild(element);
						theForm.action = baseUrl+"pigeonhole"+'&id='+ids + "&spaceType=" + spaceType + "&type=" + appType +"&showAudit=" +showAudit;
						theForm.method = "post";
		    			theForm.target = "_self";
						theForm.submit();
	    	            
		        		result.close();
		        		}
	            }
    	            
    	        }, {
    				id:'btn2',
    	            text: v3x.getMessage("collaborationLang.cancel"),
    	            handler: function(){
    	        		result.close();
    	            }
    	        }]
    	    });
	}
	
	function checkEditWindowIsOpen(winId){
		var _wmp = getA8Top()._windowsMap;
		if(_wmp){
			for(var p = 0;p<_wmp.keys().size();p++){
				var _kkk = _wmp.keys().get(p);
				try{
					var _fff = _wmp.get(_kkk);
					var _dd = _fff.document;
					if(_dd){
						var _p = parseInt(_dd.body.clientHeight);
						if(_p == 0){
							_wmp.remove(_kkk);
							p--;
						}
					}else{
						_wmp.remove(_kkk);
						p--;
					}
				}catch(e){
					_wmp.remove(_kkk);
					p--;
				}
			}
			var exitWin = _wmp.get(winId);
			if(exitWin){
				alert(v3x.getMessage("bulletin.bul_edit_window_not_close"));
				exitWin.focus();
				return false;
			}
		}
		return true;
	}

	function getSelectId(){
		var ids=document.getElementsByName('id');
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
	function getSelectState(){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=idCheckBox.dataState;
				break;
			}
		}
		return id;
	}
	function getCheckNum(){
		var ids=document.getElementsByName('id');
		var count = 0;
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				count++
			}
		}
		return count;
	}
	
	function getSelectIds(){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		return id;
	}
	
	function getSelectAtts(){
		var ids = document.getElementsByName('id');
		var id = '';
		for ( var i = 0; i < ids.length; i++) {
			var idCheckBox = ids[i];
			if (idCheckBox.checked) {
				id = id + idCheckBox.getAttribute("attflag") + ',';
			}
		}
		return id;
	}

	
	function editTemplate(){
		var id=getSelectId();
		if(id==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		parent.location.href=baseUrl+"edit"+'&id='+id;
	}
	
	function editType(){
		var spaceId = document.getElementById("_spaceId").value;
		var spaceType = document.getElementById("_spaceType").value;
		var id=getTypeSelectId();
		if(id=='false'){
			alert(v3x.getMessage("bulletin.bul_news_update"));
			return;
		}
		if(id==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		parent.detailFrame.location.href=baseUrl+"edit"+'&id='+id+'&spaceType='+spaceType+'&spaceId='+spaceId;
	}
	/**
	 * @deprecated 只使用editType()
	 */
	function groupEditType(){
		var id=getTypeSelectId();
		if(id=='false'){
			alert(v3x.getMessage("bulletin.bul_news_update"));
			return;
		}
		if(id==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		parent.detailFrame.location.href=baseUrl+"groupEdit"+'&id='+id;
	}
	
	function editTemplateLine(id){
		parent.location.href=baseUrl+'edit'+'&id='+id;
	}
	
	function editData(id){
		if(!id){
			var num = getCheckNum();
			if(num == 0){
				alert(v3x.getMessage("bulletin.please_select_record"));
				return;
			}else if(num > 1){
				alert(v3x.getMessage("bulletin.please_select_only_one_edit"));
				return;
			}
		
			id=getSelectId();
		}
		
		var state = getSelectState();

		editDataLine(id, "", state);
	}
	
	function editDataLine(id, from, state){
		if(!id)
			return;
			
		var _state = getStateOfData(id, "ajaxBulDataManager");
		
		if(_state && typeAuditFlag == "true"){
			if(_state == '20'){
				alert(v3x.getMessage("bulletin.audited_no_edit"));
				if(state && (state != _state))
					window.location.reload(true);
				return ;
			}else if(_state == '30'){
				alert(v3x.getMessage("bulletin.published_no_edit"));
			  window.location.reload(true);
				return ;
			}
		}
		var spaceId = document.getElementById("spaceId").value;
		openCtpWindow({'url':baseUrl+'edit'+'&id='+id+'&spaceId='+spaceId});
	}
	
	function editNewsData(id){
		if(!id){
			var num = getCheckNum();
			if(num == 0){
				alert(v3x.getMessage("bulletin.please_select_record"));
				return;
			}else if(num > 1){
				alert(v3x.getMessage("bulletin.please_select_only_one_edit"));
				return;
			}
			id=getSelectId();
		}
		
		var state = getSelectState();

		editNewsDataLine(id, "", state);
	}
	
	function editNewsDataLine(id, from, state){
		if(!id)
			return;
			
		var _state = getStateOfData(id, "ajaxNewsDataManager");
		
		if(_state && typeAuditFlag == "true"){
			if(_state == '20'){
				alert(v3x.getMessage("bulletin.audited_no_edit"));
				if(state && (state != _state))
					window.location.reload(true);
				return ;
			}else if(_state == '30'){
				alert(v3x.getMessage("bulletin.published_no_edit"));
				window.location.reload(true);
				return ;
			}
		}
		var custom = document.getElementById("_custom").value;
		var spaceId = document.getElementById("spaceId").value;
		openCtpWindow({'url':baseUrl+'edit'+'&id='+id+'&custom='+custom+'&spaceId='+spaceId});
	}
	
	function getStateOfData(id, mgrName){		
		var requestCaller = new XMLHttpRequestCaller(this, mgrName,
			 "getStateOfData", false);
		requestCaller.addParameter(1, "long", id);
				
		var state = requestCaller.serviceRequest();
		
		return state;
	}
	
	/**
	 * 判断公告、新闻板块审核员是否可用
	 */
	function validAuditUserEnabled(typeId, mgrName){
		var requestCaller = new XMLHttpRequestCaller(this, mgrName, "isAuditUserEnabled", false);
		requestCaller.addParameter(1, "Long", typeId);
		return requestCaller.serviceRequest();
	}
	
	function validTypeExist(id, mgrName){
		var requestCaller = new XMLHttpRequestCaller(this, mgrName,
			 "typeExist", false);
		requestCaller.addParameter(1, "long", id);
				
		var ret = requestCaller.serviceRequest();
		
		return ret;
	}
	
	function publishData(){
		var ids=getSelectIds();
		if(ids==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		var spaceId = document.getElementById("spaceId").value;
		var ids2=document.getElementsByName('id');
		var id='';
		var selectedCount = 0;
		var count = 0;
		for(var i=0;i<ids2.length;i++){
			var idCheckBox=ids2[i];
			if(idCheckBox.checked){
				selectedCount += 1;
				var auditFlag = idCheckBox.auditFlag; 
				if('true' == auditFlag){
					var state2 = getStateOfData(idCheckBox.value, managerName);
					if(state2 == '20')
						continue;
					if(state2 == '40'){
						alert(v3x.getMessage('bulletin.bul_not_pass'));
					}else if(state2 == '10' || state2 == '0'){
						alert(v3x.getMessage('bulletin.bul_not_audit'));
					}else if(state2 == '30')
						alert(v3x.getMessage('bulletin.bul_news_already_poss'));
					return false;
				} else {
					var state3 = getStateOfData(idCheckBox.value, managerName);
					if(state3 == '30') {
						count += 1;
					}
					if(count==selectedCount) {
						alert(v3x.getMessage('bulletin.bul_news_already_poss'));
						return false;
					}
				}
			}
		}
		
		parent.window.location.href=baseUrl+'publishOper'+'&id='+ids+'&form_oper=publish&spaceId='+spaceId;
		if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
	}
	
	function publishDataNews(){
		var ids=getSelectIds();
		if(ids==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		parent.parent.window.location.href=baseUrl+'publishOper'+'&id='+ids+'&form_oper=publish';
	}
	
	function sendData(){
		var ids=getSelectIds();
		if(ids==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		parent.window.location.href=baseUrl+'send'+'&id='+ids;
	}
	
	function cancelPublishData(spaceType, appType , showAudit, category){
		var custom = document.getElementById("_custom").value;
		var spaceId = document.getElementById("spaceId").value;
		var ids=getSelectIds();
		if(ids==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		var i18nKey = "bulletin.bulletin_delete";
		if (category == "news") {
		    i18nKey = "bulletin.news_delete";
		}
		if (confirm(v3x.getMessage(i18nKey))) {
		    parent.window.location.href=baseUrl+'publishOper'+'&id='+ids+'&form_oper=cancelPublish&gotoid=gotoid&custom=' + custom
            + "&spaceType=" + spaceType + "&type=" + appType +"&showAudit=" + showAudit +"&sendMessage=true&spaceId=" + spaceId;
		}
	}
	
	function publishDataLine(id, from){
		parent.location.href=baseUrl+'publish'+'&id='+id;
	}
	
	function auditDataLine(id, from){
		var theURL = baseUrl+'audit'+'&id='+id + "&from=" + from;
		
		openWin(theURL);

		parent.parent.location.href = parent.parent.location.href;
	}
	
	function auditData(type,from){
		var id=getSelectId();
		if(id==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		var state=document.getElementById(id+"_state").value;
		
		if(type=="audit" && state=='20'){
			alert(v3x.getMessage("bulletin.bulletin_already_audit"));
			return;
		}
		if(type=="cancel" && state=='10'){
			alert(v3x.getMessage("bulletin.bulletin_not_audit"));
			return;
		}
		auditDataLine(id, from);
	}
	
	function cancelAudit(){
		var ids=getSelectIds();
		if(ids==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
//		var state=document.getElementById(id+"_state").value;

//		if(state=='10'){
//			alert(v3x.getMessage("bulletin.bulletin_not_audit"));
//			return;
//		}

		var ids2=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids2.length;i++){
			var idCheckBox=ids2[i];
			if(idCheckBox.checked){
			
				var state2 = getStateOfData(idCheckBox.value, managerName);
				
				if(state2 == '30'){
					alert(v3x.getMessage('bulletin.bul_news_already_poss'));
					break;
				}
			}
		}
		var spaceId = document.getElementById("spaceId").value;
		var _form = document.getElementById("auditListForm");
		_form.action = baseUrl + "cancelAudit&ids=" + ids + "&spaceId=" + spaceId;
		_form.target = "emptyIframe";
		_form.submit();
		
		//parent.parent.location.reload(true);
	}
	
	function auditNewsData(type,from){
		var selCount = getCheckNum();
		if(selCount > 1){
			alert(v3x.getMessage("bulletin.please_select_only_one_edit"));
			return;			
		}
		
		var id=getSelectId();
		if(id==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		var state=document.getElementById(id+"_state").value;
		
		if(type=="audit" && state=='20'){
			alert(v3x.getMessage("bulletin.news_already_audit"));
			return;
		}
		if(type=="cancel" && state=='10'){
			alert(v3x.getMessage("bulletin.news_not_audit"));
			return;
		}
		
		parent.location.href=baseUrl+"audit"+'&id='+id + "&from=" + from;
	}
	
	function editTypeLine(id){
		parent.detailFrame.location.href=baseUrl+'edit'+'&id='+id+"&isDetail=readOnly";
	}
	function editDBTypeLine(id){
		parent.detailFrame.location.href=baseUrl+'edit'+'&id='+id;
	}
	
	function editDbTypeLine(id){
		parent.detailFrame.location.href=baseUrl+'edit'+'&id='+id;
	}
	function groupEditTypeLine(id){
		parent.detailFrame.location.href=baseUrl+'groupEdit'+'&id='+id+"&isDetail=readOnly";
	}
	function groupEditDBTypeLine(id){
		parent.detailFrame.location.href=baseUrl+'groupEdit'+'&id='+id;
	}
	
	/**
	 * 增加统计页面的高度（从410到510），并使其大小可以改变，以适应统计项较多的情况 added by Meng Yang 2009-05-27
	 */
	function viewStatistics(baseUrl){
		/*if(v3x.getBrowserFlag('openWindow') == false){
			 var win=v3x.openDialog({
    	 				id:"statistics",
    					title:"",
    	 				url : baseUrl,
    	 				targetWindow:getA8Top(),
    	 				width: 600,
					    height: 500
					    //type:'panel'
				});
		} else {
			var dlgArgs=new Array();	
			dlgArgs['html']=false;	
			dlgArgs['width']=608;
			dlgArgs['height']=510;
			dlgArgs['url']=baseUrl;
			v3x.openWindow(dlgArgs);
		}*/
		openCtpWindow({'url':baseUrl});
	}
	function viewLog(baseUrl){
		var dlgArgs=new Array();		
		dlgArgs['html']=false;	
		dlgArgs['width']=608;
		dlgArgs['height']=410;
		dlgArgs['url']=baseUrl;
		v3x.openWindow(dlgArgs);
	}
	
	function configWrite(baseUrl){
		var dlgArgs=new Array();		
		dlgArgs['width']=608;
		dlgArgs['height']=410;
		dlgArgs['url']=baseUrl;
		v3x.openWindow(dlgArgs);
	}
	
	
	function deleteRecord(baseUrl){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				//判断是否已经发布
				//var state2 = getStateOfData(idCheckBox.value, managerName);
				//if(state2 == '30'){
				 // alert(v3x.getMessage('bulletin.bul_news_poss_del'));
				 // return false;
				//}
				
				id=id+idCheckBox.value+',';
			}
		}
		if(id==''){
			alert(v3x.getMessage("bulletin.select_delete_record"));
			return;
		}
		if(baseUrl.indexOf("bulData.do")>-1){
			if(confirm(v3x.getMessage("bulletin.confirm_delete"))){
				parent.window.location.href=baseUrl+'&id='+id;
			    if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
			}
		}else if(baseUrl.indexOf("newsData.do")>-1){
			if(confirm(v3x.getMessage("bulletin.confirm_delete_news"))){
				parent.window.location.href=baseUrl+'&id='+id;
			    if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
			}    
		}
	}
	
	function deleteCalEventRecord(baseUrl){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				var periodicalId = idCheckBox.getAttribute("periodicalId");
				if(periodicalId){
					alert(v3x.getMessage("CalLang.periodical_cannot_deleted"));
					return false;
				}
				id=id+idCheckBox.value+',';
			}
		}
		if(id==''){
			alert(v3x.getMessage("bulletin.select_delete_record"));
			return;
		}
		
		if(confirm(v3x.getMessage("bulletin.confirm_delete")))
			parent.window.location.href=baseUrl+'&id='+id;
	}
	
	function deleteRecordNews(baseUrl){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		if(id==''){
			alert(v3x.getMessage("bulletin.select_delete_record"));
			return;
		}
		
		if(confirm(v3x.getMessage("bulletin.confirm_delete")))
			parent.parent.window.location.href=baseUrl+'&id='+id;
	}
	
	function displayDetail(id){
		parent.detailFrame.location.href=baseUrl+'detail&id='+id;
	}
	
	function showPageByMethod(id,method){
		var spaceId = document.getElementById("spaceId").value;
		parent.detailFrame.location.href=baseUrl+method+'&id='+id+'&from=list'+'&spaceId='+spaceId;
	}
	
	function setSelectValue(selectName,value){
		var select=document.getElementById(selectName);
		select.value=value;
	}
	
	function setRadioValue(radioName,value){
		var radios=document.getElementsByName(radioName);
		for(var i=0;i<radios.length;i++){
			var radio=radios[i];
			if(radio.value==value){
				radio.checked=true;
			}else{
				radio.checked=false;
			}
		}
	}
	

	function selectPeople(elemId,idElem,nameElem){
		if(!test)
			eval('selectPeopleFun_'+elemId+'()');
		else{
			var dlgArgs=new Array();		
			dlgArgs['width']=238;
			dlgArgs['height']=310;
			dlgArgs['url']='/seeyon/selectPeople.jsp';
			var elements=v3x.openWindow(dlgArgs);
			if(elements!=null && elements.length>0)
				setBulPeopleFields(elements,idElem,nameElem);
				showOriginalElement_per=true;
		}
		activeOcx();
	}

	function setBulPeopleFields(elements,idElem,nameElem){
		if(idElem=='managerUserIds' || idElem=='auditUser' || idElem.indexOf('writeUserIds_')>-1
				|| idElem=='publishDepartmentId' || idElem=='conferees' || idElem=='recorderId' || idElem=='emceeId'
			){
			//zhangxw 2012-10-30
			//$(idElem).value=getIdsString(elements,false); //原来的代码
			document.getElementById(idElem).value=getIdsString(elements,false);
		}else{
			//zhangxw 2012-10-30
			//$(idElem).value=getIdsString(elements,true); //原来的代码
			document.getElementById(idElem).value=getIdsString(elements,true); 
		}
		//zhangxw 2012-10-30
		//$(nameElem).value=getNamesString(elements); //原来的代码
		document.getElementById(nameElem).value=getNamesString(elements);
	}
	
	function setNewsPeopleFields(elements,idElem,nameElem){
		if(idElem=='managerUserIds' || idElem=='auditUser' || idElem.indexOf('writeUserIds_')>-1
				|| idElem=='publishDepartmentId'
			){
			$(idElem).value=getIdsString(elements,false);
		}else{
			$(idElem).value=getIdsString(elements,true);
		}
		
		$(nameElem).value=getNamesString(elements);
	}
	

	function topData(baseUrl, topCount, topedCount, cancelFlag) {
        var ids = document.getElementsByName('id');
        var id = '';
        var noNeedOper = true;
        var count = 0;
        for ( var i = 0; i < ids.length; i++) {
            var idCheckBox = ids[i];
            if (idCheckBox.checked) {
                id = id + idCheckBox.value + ',';
                if (cancelFlag) {
                    noNeedOper = (noNeedOper && (idCheckBox.getAttribute('dataTopOrder') <= 0));
                } else {
                    noNeedOper = (noNeedOper && (idCheckBox.getAttribute('dataTopOrder') > 0));
    
                    if (idCheckBox.getAttribute('dataTopOrder') <= 0) {
                        count++;
                    } else {
                        alert(v3x.getMessage("bulletin.bul_top_no_valid_alert",idCheckBox.getAttribute('dataName')));
                        return;
                    }
                }
            }
        }
        if (noNeedOper) {
            if (id == '') {
                if (cancelFlag)
                    alert(v3x.getMessage("bulletin.select_top_record_cancel"));
                else
                    alert(v3x.getMessage("bulletin.select_top_record"));
                return;
            }
        }
        if (topedCount >= topCount && !cancelFlag) {
            alert(v3x.getMessage("bulletin.toped_full", topCount));
        } else {
    
            if (id == '') {
                if (cancelFlag)
                    alert(v3x.getMessage("bulletin.select_top_record_cancel"));
                else
                    alert(v3x.getMessage("bulletin.select_top_record"));
                return;
            } else if (noNeedOper) {
                if (cancelFlag)
                    alert(v3x.getMessage("bulletin.bul_top_cancel_no_valid_alert"));
                else
                    alert(v3x.getMessage("bulletin.bul_top_no_valid_alert"));
                return;
            }
            if (!cancelFlag && (count + parseInt(topedCount) > topCount)) {
                alert(v3x.getMessage("bulletin.bul_top_selected_too_much",
                        topCount, topedCount, (topCount - topedCount)));
                return;
            }
    
            parent.window.location.href = baseUrl + '&id=' + id;
        }
	}
	
	

	
/******
 * 讨论区、调查、新闻、公告首页 所需JS方法 added by mazc 07-11-30
 * 
 */
	
//讨论区、调查、新闻、公告首页 - 改变页签状态 
function cursorTag(tagNum){
	for(var i=0; i<2; i++){
		if(i == tagNum){
			document.getElementById("Tag" + tagNum + "_left").className = "tab-tag-left-sel";
			document.getElementById("Tag" + tagNum + "_middle").className = "tab-tag-middel-sel";
			document.getElementById("Tag" + tagNum + "_right").className = "tab-tag-right-sel";
			document.getElementById("content" + tagNum).style.display = "";
			
		}else{
			document.getElementById("Tag" + i + "_left").className = "tab-tag-left";
			document.getElementById("Tag" + i + "_middle").className = "tab-tag-middel";
			document.getElementById("Tag" + i + "_right").className = "tab-tag-right";
			document.getElementById("content" + i).style.display = "none";
			
		}
	}
}

//调查、新闻、公告 - 查看页面弹出窗口公用方法
function openWin(urls){
  openCtpWindow({'url':urls});
}
function openWinHome(url, dataid, divId){
	var d=new Date();
	var rv = openWinWithRv(url+"&t="+d.getTime());
	//location.reload(true);
//	var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager",
//		 "getReadCount", false);
//	requestCaller.addParameter(1, "long", dataid);
//			
//	var ret = requestCaller.serviceRequest();

	
	if(rv){
		var ele = document.getElementById(divId);
		if(ele)
			ele.innerHTML = rv;
	}

}
function openWinWithRv(url){
	var windowWidth =  screen.width-155;
	var windowHeight =  screen.height-160;
	var rv = v3x.openWindow({
		url : url,
		width : windowWidth,
		height : windowHeight,
		top : 100,
		left : 140,
		resizable: "yes",
		dialogType: "open"
	});
	return rv;
}

/**
 * 公告根据发布人进行查询
 */
function setPublisher(elements){
		if(!elements) {
			return;
		}
		document.getElementById("publisher").value = getNamesString(elements);
		var theid = getIdsString(elements, false);
		document.getElementById("per_textfield").value = theid;
		document.getElementById("showPer").value = getNamesString(elements);
}

/**
 * 公告条件回显
 */
function bulShowCondition(condition, value, showValue){
	var ele;
	var conditionObj = document.getElementById("condition");
	selectUtil(conditionObj, condition);
    showNextCondition(conditionObj);
	
	if(condition == 'title')
		document.getElementById("titleInput").value = value;
	else if(condition == 'publishDate')
		document.getElementById("dateInput").value = value;
	else if(condition == 'publishUserId'){
		//发布者是选人界面时候回显这个
		//document.getElementById("publisher").value = showValue;
		//document.getElementById("per_textfield").value = value;
		document.getElementById("publishUserIdInput").value = value;
	}
}

/**
 * 标题列样式
*/

function titlemouseover(obj){
	obj.style.color='#ff6633';
}
function titlemouseout(obj){
	obj.style.color='#333333';
}

function noEditAuditUserAlert(){
	alert(v3x.getMessage("bulletin.audit_user_has_pending"));
}

/**
 * 
 */
function setFlag(flag) {
	//alert(searchForm.flag.value);
	searchForm.flag.value = flag;
	searchForm.spaceType.value = document.getElementById("spaceType").value;
}
function clearFlag() {
	searchForm.flag.value = "";	
	searchForm.spaceType.value = "";
}
/*
 * 
 */
function setspaceType(flag) {
	//alert(searchForm.flag.value);
	searchForm.spaceType.value = flag;
}
function clearspaceType() {
	searchForm.spaceType.value = "";	
}
/*
 * 查询
 */
function bulDoSearch(){
	var url = "/seeyon/bulType.do" ;
	if(!checkForm(searchForm))
		return ;
	var fvalue = searchForm.flag.value ;
	var spaceType = searchForm.spaceType.value ;
	var method = "" ;
	if(fvalue == "typeName"){
		//按模块名称查询
		method = "bulQueryByTypeName&typename="+encodeURIComponent(searchForm.typename.value) ;
	}else if(fvalue == "totals"){
		//按数量查询
		var totalsMatch = searchForm.totalsMatch.value ; //判断比较的方式 equal为等于 more为大于 less为小于
		if(totalsMatch == null){
			alert(v3x.getMessage("DocLang.doc_search_select_condition_alert"));
			return ;	
		}
		method = "bulQueryByTotals&num="+encodeURIComponent(searchForm.totalsMax.value)+"&match="+totalsMatch;
	}else if(fvalue == "managerUsers" ){
		//按管理员查询
		method = "bulQueryByManagerUsers&managerUsersName="+encodeURIComponent(searchForm.managerUsersName.value) ; 
	}else if(fvalue == "auditFlag"){
		//按是否需要审查查询
		var flag = searchForm.auditFlag.value ;
		method = "bulQueryByAuditFlag&auditFlag="+flag ;
	}else if(fvalue == "auditUser"){
		//按审查员查询
		var auditUserName = searchForm.username.value ;
		method = "bulQueryByAuditUserName&auditUserName="+encodeURIComponent(auditUserName) ;
	}else{
		alert(v3x.getMessage("DocLang.doc_search_select_condition_alert"));
		return ;
	}
	
	var docUrl = url + "?method="+method +"&queryFlag=true&spaceType="+spaceType ;
	
	location.href = docUrl ;
}

/*
 * 单选按钮改变选择结果时的触发事件
 * 
 */
function radioChange(){
	var publicBulId = document.getElementById("publicBulId") ;
	publicBulId.disabled = "disabled" ;
}
function radioChangeRep(){
	var publicBulId = document.getElementById("publicBulId") ;
	publicBulId.disabled = "" ;
}
/*
 * 关联文档查看
 */
function openDetail(subject, _url) {
    _url = jsColURL + "?method=summary&" + _url;
    var rv = v3x.openWindow({
        url: _url,
        workSpace: 'yes'
    });

}
/**将焦点设置到office控件上，否则容易出现因为打开模态对话框以后
* office控件焦点丢失不能编辑的问题。
* */
function activeOcx(){
	try{
		activeOfficeOcx();
	}catch(e){
		
	}
}
function insertAttachmentAndActiveOcx(callMethod){
	insertAttachment(null,null,callMethod);
	activeOcx();
}
function doSearchInq() {
		var theForm = document.getElementsByName("searchForm")[0];
		var condition = theForm.condition;
		if(condition.value == 'publishDate') {			
			var startDate = document.getElementById("startdate").value;
			var endDate = document.getElementById("enddate").value;
			if(startDate!=""&&endDate!=""){
				if(compareDate(startDate,endDate)>0){
					alert(v3x.getMessage("bulletin.bul_time_alert"));
					return false;
				}
			}
		}
		if(condition.value == 'updateDate') {			
			var startDate = document.getElementById("startdate1").value;
			var endDate = document.getElementById("enddate1").value;
			if(startDate!=""&&endDate!=""){
				if(compareDate(startDate,endDate)>0){
					alert(v3x.getMessage("bulletin.bul_time_alert"));
					return false;
				}
			}
		}
		doSearch();
}

function hiddenTR() {
	document.getElementById('breakTR').style.display='none';
}
function searchWithKey() {
	if(v3x.getEvent().keyCode==13)
		doSearch();
}
var idArr = ['a', 'b', 'c'];
function chooseStyle(chosenId) {
	$(chosenId).checked = true;
	for(i=0; i<idArr.length; i++) {
		if(idArr[i]!=chosenId) {
			$(idArr[i]).checked = false;
		}
	}
}
function refreshAndCloseWhenInvalid(condition, from, alertMsg) {
	if(condition == true) {
		alert(alertMsg);
		if("list" == from) {
			try {
			  parent.location.reload();
			}catch(e) {}
		} else {
			if(window.parentDialogObj&&parentDialogObj['dialogDealColl']){
				parentDialogObj['dialogDealColl'].transParams.callback();
			}else {
				if(window.opener && !window.opener.closed  && "message" != from) {
					opener.location.reload();
				}
				window.close();
			}
		}
	}
}

var bulDataURL = "bulData.do";

/**
 * 部门公告－发布公告
 */
function bullPublish(spaceType, typeId){
	getA8Top().document.getElementById('main').src = bulDataURL + "?method=publishListIndex&spaceType=" + spaceType + "&bulTypeId=" + typeId;
}

/**
 * 空间公告－发布公告
 */
function bullSpacePublish(spaceType, typeId){
	getA8Top().document.getElementById('main').src = bulDataURL + "?method=publishListIndex&bulTypeId=" + typeId + "&spaceType=" + spaceType + "&spaceId=" + typeId;
}

/**
 * 部门公告－管理公告
 */
function bullManage(typeId){
	window.location.href = bulDataURL + "?method=listMain&spaceType=1&type=" + typeId;
}

/**
 * 空间公告－管理公告
 */
function bullSpaceManage(typeId){
	window.location.href = bulDataURL + "?method=listMain&custom=true&spaceType=4&type=" + typeId + "&spaceId=" + typeId;
}

/**
 * 切换部门
 */
function changeDeptBulletin() {
	var deptId = "";
	var selectObj = document.all.departmentIdSelect;
	if(selectObj){
		deptId = selectObj.value;
	}
	location.href = bulDataURL + "?method=bulMore&back=myBul&spaceType=1&typeId=" + deptId;
}

/**
 * 显示阅读信息
 */
function showReadList(bulletinId,_title){
	var url = bulDataURL + "?method=showReadList&id=" + bulletinId;
	_title = _title ? _title:" ";
	if (getA8Top().isCtpTop) {
		getA8Top().showReadListWin = getA8Top().$.dialog({
			id:"showReadDiv",
	        title:_title,
	        transParams:{'parentWin':window},
	        url: url,
	        width: 800,
	        height: 500,
	        isDrag:false
	    });
	} else {
		getA8Top().showReadListWin = v3x.openDialog({
			id:"showReadDiv",
	        title:_title,
	        transParams:{'parentWin':window},
	        url: url,
	        width: 800,
	        height: 500,
	        isDrag:false
	    });
	}
}

/**
 * 显示阅读信息
 */
function showReadList1(bulletinId,_title,fromPigeonhole){
  var url = bulDataURL + "?method=showReadList&id=" + bulletinId+"&fromPigeonhole="+fromPigeonhole;
  _title = _title ? _title:" ";
  if (getA8Top().isCtpTop) {
    getA8Top().showReadListWin = getA8Top().$.dialog({
      id:"showReadDiv",
          title:_title,
          transParams:{'parentWin':window},
          url: url,
          width: 800,
          height: 500,
          isDrag:false
      });
  } else {
    getA8Top().showReadListWin = v3x.openDialog({
      id:"showReadDiv",
          title:_title,
          transParams:{'parentWin':window},
          url: url,
          width: 800,
          height: 500,
          isDrag:false
      });
  }
}

/**
 * 打印
 */
function printResult(dataFormat, isChangedPdf){
	
   if(dataFormat != 'HTML' && dataFormat != 'FORM'){
   		if(dataFormat == 'Pdf' || isChangedPdf == 'false'){
   			if (parent.officeEditorFrame) {
   				parent.officeEditorFrame.pdfPrint();
   			} else {
   				window.officeEditorFrame.pdfPrint();
   			}
   		}else{
   			if (parent.officeEditorFrame) {
   				parent.officeEditorFrame.officePrint();
   			} else {
   				window.officeEditorFrame.officePrint();
   			}
   		}
		return;
   }
   var noPrintDiv;
   try{
      noPrintDiv=document.getElementById("noprint");
      noPrintDiv.style.visibility="hidden";
   }catch(e){}
   var mergeButtons  = document.getElementsByName("mergeButton");
   for(var s= 0;s<mergeButtons.length;s++){
	  var mergeButton = mergeButtons[s]; 
	  mergeButton.style.display="none";
   }
   var p = document.getElementById("printThis");
   document.getElementById('paddId').className='';
   var mm = "<div style='width: 100%;height:auto !important;min-height:500px;'>"+p.innerHTML+"</div>";
   var list1 = new PrintFragment("",mm);
   var tlist = new ArrayList();
   tlist.add(list1);
   var cssList=new ArrayList();
   cssList.add(v3x.baseURL + "/common/RTE/editor/css/fck_editorarea5Show.css")
   cssList.add(v3x.baseURL + "/apps_res/bulletin/css/default.css")   			   	
   printList(tlist,cssList);
   document.getElementById('paddId').className='padding35';
   for(var s= 0;s<mergeButtons.length;s++){
     var mergeButton = mergeButtons[s];
     mergeButton.style.display="";
   }
   try{	        
     noPrintDiv.style.visibility="visible";	           
   }catch(e){} 
}
/**
*显示当前位置
*/
function toHtml(spaceName,padName){
	var html;
	if(spaceName!=''){
        html = '<span class="nowLocation_content"><a href="#">'+spaceName+'</a>'+
            ' > '+
            '<a href="###" onclick="showMenu(\''+window.location.href+'\')">'+padName+'</a></span>';
	}else {
		html = '<span class="nowLocation_content"><a href="###" onclick="showMenu(\''+window.location.href+'\')">'+padName+'</a></span>';
	}
    return html;
}

/*
 * 移动版块
 */
function moveTo(typeList){
	var ids=getSelectIds();
	if(ids==''){
		alert(v3x.getMessage("bulletin.please_select_record_to_move"));
		return;
	}
	var urls = window.location.href.split("?");
	getA8Top().moveWin = getA8Top().$.dialog({
        title:' ',
        transParams:{'parentWin':window,'showButton':true},
        url: urls[0] + "?method=listType&typeIds="+typeList+"&ids="+ids,
        width: 256,
        height: 332,
        isDrag:false
	});

}

function moveCollBack (returnValue) {
	getA8Top().moveWin.close();
	if(returnValue==true){
		location.href = location.href;
	}
}
/**
 * 推送
 */
//推动时钟
var pushTime = 0;
var pushRandom = 0;

function pushOutside() {
  var checkedIds = getSelectIds();
  pushRandom = Math.random()*10000; 
  pushTime = 30;
  getA8Top().startProc();
  if (checkedIds == "") {
    alert(v3x.getMessage("websiteIntegrate.websiteIntegrate_grid_nochoicerow_js"));
  } else {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager",
        "outsidePush", true);
    requestCaller.addParameter(1, "String", checkedIds);
    requestCaller.addParameter(2, "String", pushRandom);
    this.invoke = function(rs) {
    }
    requestCaller.serviceRequest();
    pushOutsideClock();
  }
}
function checkPushOutside() {
  var checkedIds = getSelectIds();
  if (checkedIds == "") {
    alert(v3x.getMessage("websiteIntegrate.websiteIntegrate_grid_nochoicerow_js"));
  } else {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager",
        "checkForPushoutside", true);
    requestCaller.addParameter(1, "String", checkedIds);
    this.invoke = function(result) {
      if (result != "true") {
        if(window.confirm(v3x.getMessage("websiteIntegrate.websiteIntegrate_push_checkpushed_js")+"\n"+result)){
          pushOutside();
        }else{
          return false;
        }
      }
      if (result == "true") {
        pushOutside();
        return false;
      } 
    }
    requestCaller.serviceRequest();
  }
}

function pushOutsideClock() {
  pushTime--;
  result = "noResult";

  
  var clock;
  clock= setInterval(function(){
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager",
        "outsideResult", true);
    requestCaller.addParameter(1, "String", pushRandom);
    this.invoke = function(rs) {
      if(rs == "noResult"){
        //计时器自然结束条件
        if (pushTime == 0) {
          alert(v3x.getMessage("websiteIntegrate.websiteIntegrate_push_timeout_js"));
          clearInterval(clock);
          getA8Top().endProc();
          return null;
        }
        pushTime--;
      }else{
        if (rs == "success") {
          getA8Top().$.infor(v3x.getMessage("websiteIntegrate.websiteIntegrate_push_success_js"));
        } else{
          alert(v3x.getMessage("websiteIntegrate.websiteIntegrate_push_fail_js")+ "\n" + rs + "\n" + v3x.getMessage("websiteIntegrate.websiteIntegrate_push_tryagain_js"));
        }
        clearInterval(clock);
        getA8Top().endProc();   
      }
    }
    requestCaller.serviceRequest();
  } ,
  2000);
}

function outerSectionPush(baseUrl,sectionName){
	var ids=document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){		
			id=id+idCheckBox.value+',';
		}
	}
	if(id==''){
		alert("请从列表中选出要推送到门户的条目！");
		return;
	}
	if(confirm("确认将选择数据推送到门户栏目《"+sectionName+"》")){
		parent.window.location.href=baseUrl+'&id='+id;
	    if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
	}
}

function outerSectionDel(baseUrl,sectionName){
	var ids=document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){		
			id=id+idCheckBox.value+',';
		}
	}
	if(id==''){
		alert("请从列表中选出要取消推送门户的条目！");
		return;
	}
	if(confirm("确认取消推送至门户栏目《"+sectionName+"》")){
		parent.window.location.href=baseUrl+'&id='+id;
	    if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
	}
}
