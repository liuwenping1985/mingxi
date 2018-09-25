//显示留言对话框 -　部门空间首页进入
function showLeaveWordDlg(departmentId)
{ 
	var leaveWordURL = v3x.baseURL + "/guestbook.do?method=showLeaveWordDlg&departmentId="+departmentId;
	var result = v3x.openWindow({
		url: leaveWordURL,
		width:"500",
		height:"350",
		scrollbars:"no"
	});
	if(!result) return;
	refreshSection(departmentId);

}
function showLeaveWordDiv(idstr,departmentId)
{ 
	var oReplyDiv = document.getElementById('replyDiv'+idstr);
	var oShowLeaveWordsDIV = document.getElementById(idstr);
	var iWidth = parseInt(oShowLeaveWordsDIV.clientWidth);
	var textareaStyle = "";
  if(iWidth>350){
    oReplyDiv.style.width = 350 + "px";
    textareaStyle = " class='contentArea' ";
  }else{
    oReplyDiv.style.width = iWidth + "px";
    textareaStyle = " style='width:" + (iWidth - 1) + "px;height:80px;border:1px #AFAEA8 solid' ";
  }
	oReplyDiv.className= "replyDiv";
	//oReplyDiv.style.position="fixed";
	//oReplyDiv.style.bottom="20px";
	//oReplyDiv.style.right="20px";
	
	var replyId = arguments[2];
	var replyerId = arguments[3];
	oReplyDiv.innerHTML="<div class='header'><div class='title'>"+_("MainLang.leaveMessageRange")+"</div><div class='close' onclick='hiddenLeaveWordDlg(\""+idstr+"\")'></div></div><div class='content'><textarea id='contentReplyArea"+idstr+"'" + textareaStyle + "></textarea></div><div class='footer'><div class='sentMessage'><label for='sendMessage'><input id='sendMessage"+idstr+"' checked type='checkbox'/>"+_("MainLang.sendMessage")+"</label></div><div class='sentButton'><input type='button' class='sendAction' id='sendActionButton"+idstr+"' onclick=\"sendMessage('"+departmentId+"','"+replyId+"','"+replyerId+"','"+idstr+"')\" value='"+_("MainLang.sendAction")+"'/></div></div>";
	focusArea('contentReplyArea'+idstr);
	/**
	if(v3x.isMSIE6 && !v3x.isMSIE7 && !v3x.isMSIE8 && !v3x.isMSIE9){
		var idstrDiv = document.getElementById(idstr);
		if(idstrDiv){
	        var posX = idstrDiv.offsetLeft;
	        var scrollLeft = idstrDiv.scrollLeft;
	        var posY = idstrDiv.offsetTop;
	        var scrollTop = idstrDiv.scrollTop;
	        var aBox = idstrDiv;//需要获得位置的对象
	        do {
	        
	            aBox = aBox.offsetParent;
	            scrollLeft+=aBox.scrollLeft;
	            posX += aBox.offsetLeft;
	            posY += aBox.offsetTop;
	            scrollTop+=aBox.scrollTop;
	            
	        }
	        while (aBox.tagName != "BODY");
	        
	        oReplyDiv.style.top = parseInt(posY-scrollTop)+parseInt(idstrDiv.clientHeight)-parseInt(oReplyDiv.clientHeight)+"px";
	        oReplyDiv.style.left = posX-scrollLeft+"px";
	        
		}
	}*/
}

function showProjectLeaveWord(idstr,departmentId){
	var oReplyDiv = document.getElementById('replyDiv'+idstr);
	var oShowLeaveWordsDIV = document.getElementById(idstr);
	var iWidth = parseInt(oShowLeaveWordsDIV.clientWidth);
	var textareaStyle = "";
	if(iWidth>350){
		oReplyDiv.style.width = 350 + "px";
		textareaStyle = " class='contentArea' ";
	}else{
		oReplyDiv.style.width = iWidth + "px";
		textareaStyle = " style='width:" + (iWidth - 1) + "px;height:80px;border:1px #AFAEA8 solid' ";
	}
	oReplyDiv.className= "replyDiv";
	var replyId = arguments[2];
	var replyerId = arguments[3];
	oReplyDiv.innerHTML="<div class='header'><div class='title'>"+_("MainLang.leaveMessageRange")+"</div><div class='close' onclick='hiddenLeaveWordDlg(\""+idstr+"\")'></div></div><div class='content'><textarea id='contentReplyArea"+idstr+"'" + textareaStyle + "></textarea></div><div class='footer'><div class='sentMessage'><label for='sendMessage'><input id='sendMessage"+idstr+"' checked type='checkbox'/>"+_("MainLang.sendMessage")+"</label></div><div class='sentButton'><input type='button' class='sendAction' id='sendActionButton"+idstr+"' onclick=\"sendMessage('"+departmentId+"','"+replyId+"','"+replyerId+"','"+idstr+"')\" value='"+_("MainLang.sendAction")+"'/></div></div>";
	focusArea('contentReplyArea'+idstr);
	/**
	if(v3x.isMSIE6 && !v3x.isMSIE7 && !v3x.isMSIE8 && !v3x.isMSIE9){
		var idstrDiv = document.getElementById(idstr);
		if(idstrDiv){
	        var posX = idstrDiv.offsetLeft;
	        var scrollLeft = idstrDiv.scrollLeft;
	        var posY = idstrDiv.offsetTop;
	        var scrollTop = idstrDiv.scrollTop;
	        var aBox = idstrDiv;//需要获得位置的对象
	        do {
	            aBox = aBox.offsetParent;
	            scrollLeft+=aBox.scrollLeft;
	            posX += aBox.offsetLeft;
	            posY += aBox.offsetTop;
	            scrollTop+=aBox.scrollTop;
	        }
	        while (aBox.tagName != "BODY");
	        oReplyDiv.style.top = parseInt(posY-scrollTop)+parseInt(idstrDiv.clientHeight)-parseInt(oReplyDiv.clientHeight)+"px";
	        oReplyDiv.style.left = posX-scrollLeft+"px";
		}
	}*/
}
function checkSendMessage(str){
	str = str.trim();
	if(str.length == 0){
		alert(v3x.getMessage("MainLang.leaveMessageIsNull"));
		return false;
	}
	
	if(/^[^\\"'<>]*$/.test(str)){
		if(str.length > 1200){
			alert(v3x.getMessage("MainLang.leaveMessageNowLength") + str.length + v3x.getMessage("MainLang.leaveMessageChange"));
			return false;
		}else{
			return true;
		}
	}else{
		alert(v3x.getMessage("MainLang.leaveMessageIsSpecial"));
		return false;
	}
}

function sendMessage(departmentId,replyId,replyerId,idstr){
	try{
		var sendMessage = 'true';
		var contentReplyMessage = '';
		var oSendMessage = document.getElementById('sendMessage'+idstr);
		var oContentReplyArea = document.getElementById('contentReplyArea'+idstr);
		if(document.getElementById('theSpaceId'))
			var spaceId = document.getElementById('theSpaceId').value;
		if(oSendMessage){
			if(!oSendMessage.checked){
				sendMessage = 'false';
			}
		}
		if(oContentReplyArea){
			var strTemp = oContentReplyArea.value.trim();
			contentReplyMessage = strTemp;
			if(!checkSendMessage(contentReplyMessage)){return;}
		}else{return;}
		var replyIdTemp = 'no';
		if(replyId!=null && replyId!='' && replyId!='undefined'){
			replyIdTemp =replyId;
		}
		var replyerIdTemp = 'no';
		if(replyerId && replyerId!='' && replyerId!='undefined'){
			replyerIdTemp = replyerId;
		}
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "saveAjaxLeaveWord", false);
    	requestCaller.addParameter(1, "String", departmentId);
    	requestCaller.addParameter(2, "String", sendMessage);
    	requestCaller.addParameter(3, "String", contentReplyMessage.escapeHTML());
    	requestCaller.addParameter(4, "String", replyIdTemp);
    	requestCaller.addParameter(5, "String", replyerIdTemp);
    	var isSpace = document.getElementById('hiddenSpace1');
    	var projectPhaseId = document.getElementById("hiddenArguments1");
    	if(projectPhaseId){
    		requestCaller.addParameter(6, "String", "project");
    		requestCaller.addParameter(7, "Long", projectPhaseId.value);
    	}else if(isSpace){
    		requestCaller.addParameter(6, "String", "custom");
    	}else{
    		requestCaller.addParameter(6, "String", "no");
    		requestCaller.addParameter(7, "Long", 1);
    		requestCaller.addParameter(8, "Long", spaceId);
    	}
    	
    	var resultStr = requestCaller.serviceRequest();
    	projectPhaseId = document.getElementById("hiddenArguments2");
    	if(resultStr == 'true'){
    		if(projectPhaseId){
    			refreshProjectLeaveword(departmentId, projectPhaseId.value, idstr);
    		}else{
    			refreshSectionNew(departmentId,idstr);
    		}
    		hiddenLeaveWordDlg(idstr);
    	} else {
    		//如果返回false则表示留言已经被删除
    		alert(_("MainLang.guestbook_rep_not_select"));
    		if(projectPhaseId){
    			refreshProjectLeaveword(departmentId, projectPhaseId.value, idstr);
    		}else{
    			refreshSectionNew(departmentId,idstr);
    		}
    		hiddenLeaveWordDlg(idstr);
    	}
    }catch(e){
    	
    }
}
function replyMessage(leaveWordId,departmentId,replyerId,idstr){
	if(leaveWordId=='' || departmentId == ''){return;}
	MxtLeaveMessage.stopFlag = false;
	
	var oReplyDiv = document.getElementById('replyDiv'+idstr);
	var oShowLeaveWordsDIV = document.getElementById(idstr);
	var iWidth = parseInt(oShowLeaveWordsDIV.clientWidth);
	var textareaStyle = "";
	if(iWidth>350){
		oReplyDiv.style.width = 350 + "px";
		textareaStyle = " class='contentArea' ";
	}else{
		oReplyDiv.style.width = iWidth + "px";
		textareaStyle = " style='width:" + (iWidth - 1) + "px;height:80px;border:1px #AFAEA8 solid' ";
	}
	oReplyDiv.className= "replyDiv";
	//oReplyDiv.style.position="fixed";
	//oReplyDiv.style.bottom="20px";
	//oReplyDiv.style.right="20px";
	
	var replyId = leaveWordId;
	var replyerId = replyerId;
	oReplyDiv.innerHTML="<div class='header'><div class='title'>"+_("MainLang.leaveMessageRange")+"</div><div class='close' onclick='hiddenLeaveWordDlg(\""+idstr+"\")'></div></div><div class='content'><textarea id='contentReplyArea"+idstr+"'" + textareaStyle + "></textarea></div><div class='footer'><div class='sentMessage'><label for='sendMessage'><input id='sendMessage"+idstr+"' checked type='checkbox'/>"+_("MainLang.sendMessage")+"</label></div><div class='sentButton'><input type='button' class='sendAction' id='sendActionButton"+idstr+"' onclick=\"sendMessage('"+departmentId+"','"+replyId+"','"+replyerId+"','"+idstr+"')\" value='"+_("MainLang.sendAction")+"'/></div></div>";
	focusArea('contentReplyArea'+idstr);
}
function hiddenLeaveWordDlg(idstr){
	var oReplyDiv = document.getElementById('replyDiv'+idstr);
	var oReplyText = document.getElementById('contentReplyArea'+idstr);
	oReplyText.blur();
	oReplyDiv.className= "replyDivHidden";
}
function delLeaveWord(listForm)
{
	var i;
	var ids="";
	var objs=document.getElementsByName("id");	
	
	for(i=0;i<objs.length;i++)
	{
	  if(objs[i].checked==false){continue;}	  
	  ids+=objs[i].value+",";	  
	}
	if(ids.length>0){ids=ids.substr(0,ids.length-1);}
	if(ids.length<=0)
	{
		alert(_("MainLang.guestbook_del_not_select"));
		return;
	}
	if(window.confirm(_("MainLang.sure_to_delete"))==false)
	{
		return;
	}
 
  try
  {
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "clearLeaveWords", false);
    	requestCaller.addParameter(1, "String", ids);
    	var ds = requestCaller.serviceRequest();
    	if(ds=="true")
    	{ 
    		location.reload(true);
    	}    	
    }catch(e){
    }
       

}

//显示留言对话框 -　更多页进入
function showLeaveWordDlgFromMore(departmentId)
{ 
	var leaveWordURL = v3x.baseURL + "/guestbook.do?method=showLeaveWordDlg&departmentId=" + departmentId + "&from=more";
	var result = getA8Top().v3x.openWindow({
		url: leaveWordURL,
		width:"500",
		height:"350",
		scrollbars:"no"
	});
	if(!result) return;
	location.href = locationHref;
}

function ok(date){
	if(v3x.getBrowserFlag('OpenDivWindow')){
		if(date){
			window.returnValue = [currentUserName, document.getElementById("leaveWordContent").value, parseInt(date, 10)];
		}else{
			window.returnValue = "reloadMorePage";		
		}
		window.close();
	}else{
		if(date){
			parent.setReply([currentUserName, document.getElementById("leaveWordContent").value, parseInt(date, 10)]);
		}
	}
}
//Ctrl + Enter　按键事件
function doKeyPressedEvent()
{
   if(event.ctrlKey && event.keyCode==13){
     document.getElementById("submitBtn").disabled = true;
     var content = document.all.leaveWordContent.value;
     if(content == "")return false;
   	 document.getElementsByName("leaveWordForm")[0].submit(); 
   }
   else if(event.keyCode == 27){
		window.close();
	}
}


//定义留言对象
function LEAVE_WORD(creatorName, content, createTime)
{
 this.creatorName = creatorName;	
 this.content = content || "";
 this.createTime = createTime;
}

//加载留言             
function loadLeaveWords()
{
	var innerStr = "";
	for(var i=0; i<leaveWordsArray.length; i++){
		var LeaveWordObj = leaveWordsArray[i];
		innerStr += addThisLeaveWord(LeaveWordObj);
	}
	document.getElementById("showLeaveWordsDIV").innerHTML = innerStr;
}

//添加当前留言
 function addThisLeaveWord(LeaveWordObj)
{
	 var contextPath = getA8Top().v3x.baseURL;
	var datetime = new Date(parseInt(LeaveWordObj.createTime, 10)).format(datetimePattern);
	//定义留言信息显示结构	
	var divBody = "<div><img src='" + contextPath + "/common/images/icon.gif' width='10' height='10'>&nbsp;";
		divBody += "  <span style='color: #1039B2'>" + LeaveWordObj.creatorName + " ( " + datetime + " )</span>";
		divBody += "</div>";
		divBody += "<div style='padding: 2px 0px 4px 16px'> " + LeaveWordObj.content.escapeHTML() + "</div>";
		
	return divBody;
}

function checkLeaveWordFrom(formObj){
	if(checkForm(formObj)){
		document.getElementById('submitBtn').disabled = true;
		return true;
	}else{
		return false;
	}
}

/**
 * 刷新留言
 */
function refreshSection(deptId){
	try{
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "reloadLeaveWords", false);
    	requestCaller.addParameter(1, "String", deptId);
    	var resultStr = requestCaller.serviceRequest();
    	if(resultStr){
    		document.getElementById("showLeaveWordsDIV").innerHTML = resultStr;
    	}
    }
    catch(e){}
}
function refreshSectionNew(deptId,idstr){
	try{
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "reloadLeaveWords", false);
    	requestCaller.addParameter(1, "String", deptId);
    	requestCaller.addParameter(2, "String", idstr);
    	var resultStr = requestCaller.serviceRequest();
    	if(resultStr){
    		var aObjs = document.getElementsByName('messageReplyDivHidden');
    		if(aObjs.length>=1){
    			for(var i = 0; i<aObjs.length;i++ ){
    				var p = aObjs[i].nextSibling.nextSibling;
    				if(p){
    					p.innerHTML = resultStr;
    				}
    			}
    		}else{
    			document.getElementById(idstr).innerHTML = resultStr;
    		}
    		MxtLeaveMessage.clearAll();
    		initAllDiv();
    	}
    }
    catch(e){}
}

/**
 * 项目空间新增留言后局部刷新
 */
function refreshProjectLeaveword(projectId, projectPhaseId, flagStr){
	try{
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxProjectManager", "refreshProjectLeaveword", false);
    	requestCaller.addParameter(1, "Long", projectId);
    	requestCaller.addParameter(2, "Long", projectPhaseId);
    	requestCaller.addParameter(3, "String", flagStr);
    	var rv = requestCaller.serviceRequest();
    	if(rv){
    		var obj = document.getElementById(flagStr);
    		if(obj){
				obj.innerHTML = rv;
    		}
    		MxtLeaveMessage.clearAll();
    		initDiv(flagStr);
    	}
	}catch(e){
		
	}
}

/***留言板**/

function MxtLeaveMessage(obj,intervals){
	this.rootElement = obj;
	this.getUserAgent  =  navigator.userAgent;
	this.isGecko  =  this.getUserAgent.indexOf( "Gecko" )  !=   - 1 ;
	this.isOpera  =  this.getUserAgent.indexOf( "Opera" )  !=   - 1 ;
	this.isIe = (document.all) ? true : false;
	this.showFlag = true;
	this.stopFlag = true;
	this.timerId = null;
	this.intervalId = null;
	this.timerMoveInId = null;
	this.newObj = null;
	this.children = null;
	this.currentElement = null;
	this.intervals = intervals ? intervals : 1;
	this.timeInterval = 3000*intervals;
	this.idflag = obj.id;
	
	this.init();
	//this.attachBehaviors();
	//this.startAction();
}
MxtLeaveMessage.array = new Array();
MxtLeaveMessage.clearById = function(idstr){
	if(MxtLeaveMessage.array.length>0){
		for(var i =0;i<MxtLeaveMessage.array.length;i++){
			if(MxtLeaveMessage.array[i].idflag == idstr){
				MxtLeaveMessage.array[i].clearStart();
				MxtLeaveMessage.array[i] = null;
			}else{
				continue;
			}
		}
	}
}
MxtLeaveMessage.clearAll = function(){
	if(MxtLeaveMessage.array.length>0){
		for(var i =0;i<MxtLeaveMessage.array.length;i++){
			MxtLeaveMessage.array[i].clearStart();
			MxtLeaveMessage.array[i] = null;
		}
		MxtLeaveMessage.array = new Array();
	}
}
MxtLeaveMessage.prototype.startAction = function (e){
	this.clearStart();
	var self = this;
	//new MxtLeaveMessage.newInterval(self);
	this.intervalId = setInterval(function(e){self.flowable();},self.timeInterval);
}
//MxtLeaveMessage.newInterval = function(self,ele){
//	self.intervalId = setInterval(function(e){self.flowable();},self.timeInterval);
//}
MxtLeaveMessage.prototype.flowable = function(e){
	if (this.showFlag && this.stopFlag) {
		if (this.children.length > 1) {
			this.getMessageDiv();
			this.showFlag = false;
			this.stopFlag = false;
			this.children[0].className = 'messageDiv';
			this.rootElement.insertBefore(this.newObj, this.children[0]);
			this.moveIn(this.newObj);
		}
		
	}
}
MxtLeaveMessage.prototype.attachBehaviors = function (){
	if(this.children.length>0){
		for(var i = 0; i<this.children.length; i++){
			var ele = this.children[i];
			var self = this;
			new MxtLeaveMessage.newAction(self,ele);
		}
	}
}
MxtLeaveMessage.newAction = function(self,ele){
	MxtLeaveMessage.addEventListener(ele, "mouseover", function(e) { return self.mouseOverFun(ele); }, false);
	MxtLeaveMessage.addEventListener(ele, "mouseout", function(e) { return self.mouseOutFun(ele); }, false);
//	MxtLeaveMessage.addEventListener(document, "keydown", function(e) { return self.quckAction(e); }, false);
//	MxtLeaveMessage.addEventListener(window, "unload", function(e) { return self.unload(e); }, false);
}
MxtLeaveMessage.prototype.init = function(){
	this.children = new Array();
	this.children = this.rootElement.childNodes;
	MxtLeaveMessage.array[MxtLeaveMessage.array.length] = this;
}
MxtLeaveMessage.prototype.clearStart = function (e){
	if(this.timerId!=null){
		clearTimeout(this.timerId);
	}
	if(this.intervalId!=null){
		clearInterval(this.intervalId);
	}
	if(this.timerMoveInId!=null){
		clearInterval(this.timerMoveInId);
	}
	this.showFlag = true;
	this.stopFlag = true;
}
MxtLeaveMessage.addEventListener = function(element, eventType, handler, capture)
{
	try
	{
		if (element.addEventListener)
			element.addEventListener(eventType, handler, capture);
		else if (element.attachEvent)
			element.attachEvent("on" + eventType, handler);
	}
	catch (e) {}
};

 MxtLeaveMessage.prototype.removeElement  =   function  (ele) {
    ele.parentNode.removeChild(ele);
};


MxtLeaveMessage.prototype.mouseOverFun = function(ele){
	this.stopFlag = false;
	ele.style.backgroundColor = "#EEECEC";
}
MxtLeaveMessage.prototype.mouseOutFun = function(ele){
	this.stopFlag = true;
	ele.style.backgroundColor = "";
}

MxtLeaveMessage.prototype.createMessageDiv = function(){
	var divObj = document.createElement('div');
	divObj.className = "messageDivFirst";
	var styleStr = "margin-top:-40px;";
	divObj.style.cssText = styleStr;
	var alphaStr="";
	alphaStr += (MxtLeaveMessage.isIe) ? "filter:alpha(opacity=0);" : "opacity:0;";
	var htmlStr = "<table cellpadding='0' style='"+alphaStr+"' cellspacing='0' width='100%'><tr><td class='phtoImgTD'><div class='phtoImg'></div></td><td><div class='messageContent'><span class='peopleName'>马传佳</span><span class='peopleSay'>说:</span><span class='peopleMessage'>这是新添加的div!</span></div><div class='messageTime'><span class='reply'>回复</span><span class='meaageTime'>2010-11-12 10:36</span></div></td></tr></table>";
	divObj.innerHTML = htmlStr;
	MxtLeaveMessage.newObj = divObj;
}
MxtLeaveMessage.prototype.getMessageDiv = function(){
	var styleStr = "margin-top:-40px;";
	var alphaStr="";
	alphaStr += (this.isIe) ? "filter:alpha(opacity=0);" : "opacity:0;";
	this.newObj = this.children[this.children.length-1];
	this.newObj.style.cssText = styleStr;
	this.newObj.className = 'messageDivFirst';
	this.newObj.childNodes[0].style.cssText = alphaStr;
}

MxtLeaveMessage.prototype.fadeIn = function (obj,endInt){
	try{
	if (this.isIe) {
		obj.filters.alpha.opacity += 2;
		
		if (obj.filters.alpha.opacity < endInt) {
			var self = this;
			this.timerId = setTimeout(function() {
				self.fadeIn(obj, endInt)
			}, 5);
		}else{
			this.showFlag = true;
			this.stopFlag = true;
			if (this.children.length >4) {
				//MxtLeaveMessage.removeElement(MxtLeaveMessage.children[MxtLeaveMessage.children.length-1]);
				this.children[4].className = 'messageDivHidden';
			}
		}
	} else {
		var al = parseFloat(obj.style.opacity);
		al += 0.02;
		obj.style.opacity = al;
		if (al < (endInt / 100)) {
			var self = this;
			this.timerId = setTimeout(function() {
				self.fadeIn(obj, endInt)
			}, 5);
		}else{
			this.showFlag = true;
			this.stopFlag = true;
			if (this.children.length >4) {
				//MxtLeaveMessage.removeElement(MxtLeaveMessage.children[MxtLeaveMessage.children.length-1]);
				this.children[4].className = 'messageDivHidden';
			}
		}
	}
	}catch(e){}
}
MxtLeaveMessage.prototype.moveIn = function (obj){
	var top = parseInt(obj.style.marginTop);
	top+=5;
	obj.style.marginTop = top+'px'; 
	if(top<0){
		var self = this;
		this.timerMoveInId = setTimeout(function() {
			self.moveIn(obj)
		},50);
	}else{
		var el = obj.childNodes[0];
		if (el) {
			var self = this;
			self.fadeIn(el, 100);
		}
	}
}
/**
 * 
 * innerHTML中js不执行
 * */
function set_innerHTML(obj_id, html, time) {
	var global_html_pool = []; 
	var global_script_pool = []; 
	var global_script_src_pool = []; 
	var global_lock_pool = []; 
	var innerhtml_lock = null; 
	var document_buffer = ""; 

    function get_script_id() { 
        return "script_" + (new Date()).getTime().toString(36) 
          + Math.floor(Math.random() * 100000000).toString(36); 
    } 

    document_buffer = ""; 

    document.write = function (str) { 
        document_buffer += str; 
    } 
    document.writeln = function (str) { 
        document_buffer += str + "\n"; 
    } 

    global_html_pool = []; 

    var scripts = []; 
    html = html.split(/<\/script>/i); 
    for (var i = 0; i < html.length; i++) { 
        global_html_pool[i] = html[i].replace(/<script[\s\S]*$/ig, ""); 
        scripts[i] = {text: '', src: '' }; 
        scripts[i].text = html[i].substr(global_html_pool[i].length); 
        scripts[i].src = scripts[i].text.substr(0, scripts[i].text.indexOf('>') + 1); 
        scripts[i].src = scripts[i].src.match(/src\s*=\s*(\"([^\"]*)\"|\'([^\']*)\'|([^\s]*)[\s>])/i); 
        if (scripts[i].src) { 
            if (scripts[i].src[2]) { 
                scripts[i].src = scripts[i].src[2]; 
            } 
            else if (scripts[i].src[3]) { 
                scripts[i].src = scripts[i].src[3]; 
            } 
            else if (scripts[i].src[4]) { 
                scripts[i].src = scripts[i].src[4]; 
            } 
            else { 
                scripts[i].src = ""; 
            } 
            scripts[i].text = ""; 
        } 
        else { 
            scripts[i].src = ""; 
            scripts[i].text = scripts[i].text.substr(scripts[i].text.indexOf('>') + 1); 
            scripts[i].text = scripts[i].text.replace(/^\s*<\!--\s*/g, ""); 
        } 
    } 

    var script;

    for (var i = 0; i < scripts.length; i++) {
    	  document_buffer += global_html_pool[i];
	      script = document.createElement("script"); 
	      if (scripts[i].src) { 
	          script.src = scripts[i].src; 
	          if (typeof(global_script_src_pool[script.src]) == "undefined") { 
	              global_script_src_pool[script.src] = true; 
	          } 
	      } 
	      else { 
	          script.text = scripts[i].text; 
	      } 
	      script.defer = true; 
	      script.type =  "text/javascript"; 
	      script.id = get_script_id(); 
	      global_script_pool[script.id] = script; 
          document.getElementsByTagName('head').item(0).appendChild(global_script_pool[script.id]);
    } 
    document.getElementById(obj_id).innerHTML = document_buffer;
}
var checkMany = function(){
	var aObjs = document.getElementsByName('messageReplyDivHidden');
	if(aObjs.length>=1){
		return true;
	}else{
		return false;
	}
}
function initAllDiv(){
	var aObjs = document.getElementsByName('messageReplyDivHidden');
	if(aObjs.length>=1){
		for(var i = 0; i<aObjs.length;i++ ){
			var p = aObjs[i].nextSibling.nextSibling;
			if(p){
				new MxtLeaveMessage(p,1)
			}
		}
	}
}
function initDiv(id){
	setTimeout(function() {
		var obj = document.getElementById(id);
		if(obj){
		    new MxtLeaveMessage(obj,1);
		}
	}, 5000);
	/*document.onkeydown=function(ev){
		 ev  =  ev  ||  window.event; 
		 var oReplyDiv = document.getElementById('replyDiv'+id);
		 if(!oReplyDiv){return;}
		 if(ev.keyCode==13){
			 
			 if(oReplyDiv.style.display =="none" || oReplyDiv.className=="replyDivHidden"){
				 var hiddenId = document.getElementById('messageReplyDivHidden'+id);
				 if(hiddenId){
					 showLeaveWordDiv(id,hiddenId.value);
					 focusArea('contentReplyArea'+id);
				 }
			 }
		 }	
		 
		 
		 
		 if(ev.keyCode==13 && ev.ctrlKey){
			 if(oReplyDiv.style.display =="block" || oReplyDiv.style.display == ''){
				 keyDownSubmit(ev,'sendActionButton'+id);
			 }	 
		 }	
		 
		

	}*/
}
//根据回复总数和新的每页条数计算获取新的总页数
function getTotalPages(totalCount, newPageSize) {
	var totalRecords = parseInt(totalCount);
	var newTotalPages = 1; 
	if((totalRecords%newPageSize)==0 && totalRecords>0) {
		newTotalPages = totalRecords/newPageSize;
	} else {
		newTotalPages = parseInt(totalRecords/newPageSize + 1);
	}
	return newTotalPages;
}
//获取用户自定义的每页回复总条数
function getPageSize() {
	var newPageSizeStr = document.getElementById("pageSize").value.trim();
	
	if(!new RegExp("^-?[0-9]*$").test(newPageSizeStr) || parseInt(newPageSizeStr, 10) < 1){
		return;
	}
	
	return parseInt(newPageSizeStr);
}
//校验是否是整数，如果不是整数，则使用默认值：每页10条，第1页
function isInt(num) {
	var re=new RegExp("^-?[ \\d]*$");
	if(re.test(num))
		return !isNaN(parseInt(num));
	else
		return false;
}
function focusArea(id){
	 var o = document.getElementById(id);
	 if(o){
		 o.focus(); 	
	 }
}
function keyDownSubmit(ev,id){
	 var o = document.getElementById(id);
	 if(o){
		 ev  =  ev  ||  window.event;   
		 if(ev.keyCode==13 && ev.ctrlKey){
			o.click();
		}	
	 }
}

/**
 * 
 * @param element
 * @param singleBoardId
 */
function showSingleBoardId(element,singleBoardId){
	var node = element.parentNode.getElementsByTagName("DIV")[1] ;
	if(node)
		node.style.display = '' ;
}

function hideSingleBoardId(element,singleBoardId){
	var node = element.parentNode.getElementsByTagName("DIV")[1] ;
	if(node)
		node.style.display = 'none' ;
}
/**
 * 
 * @param tdelement
 * @param imageSrc
 */
function changeReortMap(tdelement,imageSrc){
	var node = tdelement.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.getElementsByTagName("IMG")[0] ;
	if(node && imageSrc){
		node.src = imageSrc ;
	}
}

/**
 * 公示板发表内容
 */
function showNoticeDiv(idstr, spaceType, spaceId, fragmentId, ordinal, boardId, sectionId){
	var oReplyDiv = document.getElementById('replyDiv' + idstr);
	var oShowLeaveWordsDIV = document.getElementById(idstr);
	var iWidth = parseInt(oShowLeaveWordsDIV.clientWidth);
	var textareaStyle = "";
  if(iWidth>350){
    oReplyDiv.style.width = 350 + "px";
    textareaStyle = " class='contentArea' ";
  }else{
    oReplyDiv.style.width = iWidth + "px";
    textareaStyle = " style='width:" + (iWidth - 1) + "px;height:80px;border:1px #AFAEA8 solid' ";
  }
	oReplyDiv.className= "replyDiv";

	var contentReplyAreaHtml = document.getElementById('messageReplyDivHidden' + idstr).value;
	//将HTML中的<br/>转换为\r\n
	if(contentReplyAreaHtml!=""){
		contentReplyAreaHtml = contentReplyAreaHtml.replace(/<br\/>/g,"\r\n");
	}
	
	oReplyDiv.innerHTML = 
		"<div class='header'>" +
		"<div class='title'>" + _("MainLang.post_content_length") + "</div>" +
		"<div class='close' onclick='hiddenLeaveWordDlg(\"" + idstr + "\")'></div>" +
		"</div>" +
		"<div class='content'><textarea id='contentReplyArea" + idstr + "'" + textareaStyle + ">" + contentReplyAreaHtml + "</textarea></div>" +
		"<div class='footer'>" +
		"<div class='sentMessage'><label for='sendMessage" + idstr + "'><input id='sendMessage" + idstr + "' type='checkbox'/>" + _("MainLang.sendMessage") + "</label></div>" +
		"<div class='sentButton'><input type='button' class='sendAction' id='sendActionButton" + idstr + "' onclick='sendNotice(\"" + idstr + "\", \"" + spaceType + "\", \"" + spaceId + "\", \"" + fragmentId + "\", \"" + ordinal + "\", \"" + boardId + "\", \"" + sectionId + "\")' value='" + _("MainLang.sendAction") + "'/></div>" +
		"</div>";
	focusArea('contentReplyArea' + idstr);
	if(v3x.isMSIE6 && !v3x.isMSIE7 && !v3x.isMSIE8 && !v3x.isMSIE9){
		var idstrDiv = document.getElementById(idstr);
		if(idstrDiv){
	        var posX = idstrDiv.offsetLeft;
	        var scrollLeft = idstrDiv.scrollLeft;
	        var posY = idstrDiv.offsetTop;
	        var scrollTop = idstrDiv.scrollTop;
	        var aBox = idstrDiv;//需要获得位置的对象
	        do {
	            aBox = aBox.offsetParent;
	            scrollLeft += aBox.scrollLeft;
	            posX += aBox.offsetLeft;
	            posY += aBox.offsetTop;
	            scrollTop += aBox.scrollTop;
	        }
	        while (aBox.tagName != "BODY");
	        
	        oReplyDiv.style.top = parseInt(posY - scrollTop) + parseInt(idstrDiv.clientHeight) - parseInt(oReplyDiv.clientHeight) + "px";
	        oReplyDiv.style.left = posX - scrollLeft + "px";
		}
	}
}

/**
 * 保存公示板内容
 */
function sendNotice(idstr, spaceType, spaceId, fragmentId, ordinal, boardId,sectionId){
	try{
		var sendMessage = 'true';
		var oSendMessage = document.getElementById('sendMessage' + idstr);
		if(oSendMessage && !oSendMessage.checked){
			sendMessage = 'false';
		}
		
		var contentReplyMessage = '';
		var oContentReplyArea = document.getElementById('contentReplyArea' + idstr);
		
		if(oContentReplyArea){
			var contentReplyMessage = oContentReplyArea.value;
			if(contentReplyMessage != ''){
				if(contentReplyMessage.length > 1000){
					alert(_("MainLang.notice_content_length", 1000));
					return;
				}
			}else{
				alert(_("MainLang.notice_content_null"));
				return;
			}
		}else{
			return;
		}
		
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxNoticeManager", "saveNotice", false);
    	requestCaller.addParameter(1, "String", sendMessage);
    	requestCaller.addParameter(2, "String", contentReplyMessage);
    	requestCaller.addParameter(3, "String", spaceType);
    	requestCaller.addParameter(4, "String", spaceId);
    	requestCaller.addParameter(5, "String", fragmentId);
    	requestCaller.addParameter(6, "String", ordinal);
    	requestCaller.addParameter(7, "String", boardId);
    	var resultStr = requestCaller.serviceRequest();
    	if(resultStr == 'true'){
    		hiddenLeaveWordDlg(idstr);
    		if(sectionId){
    			sectionHandler.reload(sectionId, true);
    		}else{
    			sectionHandler.reload("noticeSection", true);
    		}
    	}
    }catch(e){
    	
    }
}