/**
 * 
 */
function reloadHeight(){
	var _height = document.body.scrollHeight;
	if (_height > 0) { // 隐藏时为0
		if(_height > 240){
			_height = 240;
		}
		parent.document.getElementById('divPhrase').style.height = _height;
	}
}
var phraseType = null;
function showPhrase(showTop){
	if(phraseType && phraseType == "col"){
		colShowPhrase();
	}else{
		if(showTop && (typeof(showTop)=='string'  || typeof(showTop)=='number' )){
			defaultPhrase(showTop);
		}else if(showTop && (typeof(showTop)=='object')){
	        defaultPhrase(showTop);
		}else{
			defaultPhrase();
		}
	}
}


//政务版公文专用意见常用语
function showPhrase_gov(showTop){
	if(showTop && (typeof(showTop)=='string'  || typeof(showTop)=='number' )){
		defaultPhrase_gov(showTop);
	}else if(showTop && (typeof(showTop)=='object')){
      defaultPhrase_gov(showTop);
	}else{
		defaultPhrase_gov();
	}
	
}

//政务版公文专用意见常用语显示位置
function defaultPhrase_gov(showTop){
	var _phraseFrame = document.getElementById('phraseFrame');
	if(_phraseFrame.src != phraseURL){
		document.getElementById('phraseFrame').src = phraseURL;
	}
	var divPhrase = document.getElementById('divPhrase');
	if(typeof(showTop)!="undefined" && showTop){
		divPhrase.style.top = "30px";
		divPhrase.style.left="120px";
		divPhrase.style.right="auto";
		divPhrase.parentNode.className="position_relative";
		
		
	}
	document.getElementById('divPhrase').style.display = '';
}


function defaultPhrase(showTop){
	var _phraseFrame = document.getElementById('phraseFrame');
	if(_phraseFrame.src != phraseURL){
		document.getElementById('phraseFrame').src = phraseURL;
	}
	var divPhrase = document.getElementById('divPhrase');
	if(typeof(showTop)!="undefined" && showTop){
		divPhrase.style.top = showTop;
	}
	document.getElementById('divPhrase').style.display = '';
}
function colShowPhrase(){
	var adv = document.getElementById("processAdvanceDIV");
	var dealTD = document.getElementById("dealTD");
	var bottomId = document.getElementById("bottomId");
	defaultPhrase(adv.style.posTop+dealTD.offsetHeight+bottomId.offsetHeight-120)
}
function colShowNodeExplain(affairId,templeteId,processId) {
	var rv = "";
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "getDealExplain", false, "POST");
		requestCaller.addParameter(1, "String", affairId);
		requestCaller.addParameter(2, "String", templeteId);
		requestCaller.addParameter(3, "String", processId);
		rv = requestCaller.serviceRequest();
	}
	catch (ex1) {
	}
	if(rv =='undefined') rv ="";
	 var intro = document.getElementById("nodeExplainDiv") ;
	 var nodeExplainTd = document.getElementById("nodeExplainTd") ;
	 nodeExplainTd.innerHTML = rv;
	 intro.style.display = "block";
}
function hiddenNodeIntroduction() {
	var intro = document.getElementById("nodeExplainDiv") ;
	intro.style.display = "none";
}

function hiddenPhrase(){
	document.getElementById('divPhrase').style.display = 'none';;
}

function usePhrase(obj){
	var appName = parent.document.getElementById("appName");
	var _content = "";
	
	//if(typeof(appName)!=="undefined" &&  _content != null && appName.value == '4'){  //公文
	//bug:37000 start author:MENG
    if(appName &&  _content != null && (appName.value == '4' || appName.value == '32')){  //公文，32-信息报送
    //bug:37000 end
		_content =  parent.document.getElementById("contentOP");
	}else{
		_content =  parent.document.getElementById("content");
	}
	
	if(_content){
		if(_content.value.trim()){
			_content.value =_content.value +"\r\n" +obj.innerText; 
		}else{
			_content.value = obj.innerText;
		}
	}

	parent.hiddenPhrase();
}
/**
 * 
 */
function showEditPhrase(){
    var rv = v3x.openWindow({
        url: phraseURL,
        height: 400,
        width:600
    });
    
    document.location.href = document.location.href;
//    if(rv == "true"){
//    	location.reload();
//    }
}

function showButton(id){
	if(id == 1){
		document.getElementById("buttonDiv1").style.display = "inline";
		document.getElementById("buttonDiv2").style.display = "none";
	}
	else{
		document.getElementById("buttonDiv1").style.display = "none";
		document.getElementById("buttonDiv2").style.display = "inline";
	}
}

function cancelEdit(){
	phraseFrameContent.location.assign(phraseURL + "?method=list4Edit")
}

function newPhrase(){
	phraseFrameContent.location.assign(phraseURL + "?method=edit")
}

function frameSavePhrase(){
	phraseFrameContent.savePhrase();
}

function savePhrase(){
	var theForm = document.forms[0];
	if(checkForm(theForm)){
		theForm.submit();
	}
}

function ok(){
	window.returnValue = "true";
	window.close();
}
/**
 *   系统常用语的点击列表筐的出发事件
 */
function phraseOnclick(id){
	parent.detailFrame.location.href = systemPhraseURL+"?method=modifyPhrase&id="+id+"&isDetail=readOnly";	
}

/**
 * 取得列表中所有选中的id
 */	
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

function validEmail(element){
	var value = element.value;
	if(value.length > 0){
	if(value.indexOf("，")>0)
		value=value.replace(/，/ig,',');
		var emails = value.split(",");
		for(var i = 0; i < emails.length; i++){
			var start = emails[i].indexOf("<");
			var end = emails[i].indexOf(">");
			if(start != -1 && end != -1){
				var email = emails[i].substring(start+1, end);
				if(!isMyEmail(element, email)){
					return false;
				}
			}else{
				if(!isMyEmail(element, emails[i])){
					return false;
				}
			}
		}
		return true;
	}
	return true;
}
function isMyEmail(element, value){
	var inputName = element.getAttribute("inputName");
	if(!testRegExp(value, '^[-!#$%&\'*+\\./0-9=?A-Z^_`a-z{|}~]+@[-!#$%&\'*+\\/0-9=?A-Z^_`a-z{|}~]+\.[-!#$%&\'*+\\./0-9=?A-Z^_`a-z{|}~]+$')){
		writeValidateInfo(element, v3x.getMessage("V3XLang.formValidate_isEmail", inputName));
		return false;
	}
	
	return true;
}
