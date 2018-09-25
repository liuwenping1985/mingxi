var isIncludeCanUpdateElement=false;//记录公文单中是否有可以修改的元素；点击修改文单的时候，如果没有可以修改的元素，给用户提示
var firstCanEditElementId=""; //记录第一个可以修改的公文元素的ID，修改文单的时候，得到焦点；

fieldObjList = new Array();//用于保存js对象
fieldStructList = new Array();//用于重复表或重复节字段的查找
var fieldInputListArray=new Array();//用于存放xml数据中的控件对象

String.prototype.trim = function() {
    // 用正则表达式将前后空格
    // 用空字符串替代。
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

function NewHTTPCall() {
   var xmlhttp;
   try {
     xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
     return xmlhttp;
   } catch (e) {
     return null;
   }
}

function init(aUrl) {
	var httpCall = NewHTTPCall();
	var nowresult;
	if (httpCall ==  null){
		alert("浏览器不支持XMLHttp请求!");
		return null;
  	}
	httpCall.open('GET', aUrl, false);
	httpCall.onreadystatechange = function() {
  	if (httpCall.readyState != 4)
    	return;
  	nowresult = httpCall.responseText;
  	if (nowresult == "")
  		throw "装载信息出错";
	};
	httpCall.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
	httpCall.send(null);
	return nowresult;
}

///////////////////////////////////////////// 只读报送单 ///////////////////////////////////////////////////////////
function initReadSeeyonForm(s,x) {
	var str = s;
	var xslStart = str.indexOf("&&&&&&&  xsl_start  &&&&&&&&");
	var dataStart = str.indexOf("&&&&&&&&  data_start  &&&&&&&&");
	var inputStart = str.indexOf("&&&&&&&&  input_start  &&&&&&&&");
	if(xslStart == -1)
	    throw  "没有找到xsl";
	if(dataStart == -1)
	    throw "没有找到data";
	if(inputStart == -1)
	    throw "没有找到input";
	var xsl = str.slice(xslStart + 28, dataStart);
	var data = str.slice(dataStart + 30, inputStart);
	var finput = str.slice(inputStart + 31);
	var html = document.getElementById("html");

	var fnow=transformNode(data, x);
	//infopath设置了自动换行，转化为html的时候会自动添加下面这个可编辑的属性，导致意见元素可编辑，所以需要替换掉。
	fnow= fnow.replace(/contentEditable=\"true\"/g,"");
	html.innerHTML = fnow;
	initReadHtml(finput);
	initJSObject(data);
	try{setOpinionSpandefaultHeight();}catch(e){}
}


function initReadHtml(aInput){
	Init_Image();
	var fFiledList = paseFormatXML(getXmlContent(aInput))

	convertReadHtml(fFiledList);
	var repeatTable = new Seeyonform_rtable();
	repeatTable.change();

	var reSection = new Seeyonform_rsection();
	reSection.change();
}


function convertReadHtml(aFieldList){
	var field;
	var fAreas;
	for(var i = 0; i < aFieldList.length; i++){
		field = aFieldList[i];
		fAreas = field.findArea(field.fieldName);

		if(fAreas != 0){
			for(var j =0; j < fAreas.length;j++){
				//312sp1 bug 31615 将内部文号独立出来，不根据开关“是否允许修改外来文登记”来控制。后续进行根细化的处理。
				if(field.fieldName=="my:serial_no" && typeof(currentPage)!="undefined" && currentPage=="newEdoc"){
					if(field.access == "edit" || field.access == null ){
						field.change(fAreas[j]);
						if(firstCanEditElementId==""){firstCanEditElementId=field.fieldName;}
						isIncludeCanUpdateElement=true;
					}else{
						field.browse(fAreas[j]);
					}
				}else{
					field.browse(fAreas[j]);
				}
			}
		}else{
			//throw "页面没有名为"+ field.fieldName +"的span元素";
		}
	}
}

///////////////////////////////////////////// 可编辑报送单 ///////////////////////////////////////////////////////////
function initSeeyonForm(s,x) {
	var str = s;
	var xslStart = str.indexOf("&&&&&&&  xsl_start  &&&&&&&&");
	var dataStart = str.indexOf("&&&&&&&&  data_start  &&&&&&&&");
	var inputStart = str.indexOf("&&&&&&&&  input_start  &&&&&&&&");
	if(xslStart == -1)
			throw  "没有找到xsl";
	if(dataStart == -1)
			throw "没有找到data";
	if(inputStart == -1)
			throw "没有找到input";
	var xsl = str.slice(xslStart + 28, dataStart);
	var data = str.slice(dataStart + 30, inputStart);
	var finput = str.slice(inputStart + 31);
	var html = document.getElementById("html");
	var fnow=transformNode(data, x);
	fnow= fnow.replace(/contentEditable=\"true\"/g,"");
	html.innerHTML = fnow;
	initHtml(finput);
	initJSObject(data);
	try{setOpinionSpandefaultHeight();}catch(e){}
}

function setOpinionSpandefaultHeight(){
	try{
		var spans=document.getElementsByTagName("span");
		if(!spans)return;
		for(var i=0;i<spans.length;i++){
			if(!spans[i].getAttribute("xd:binding")) continue;
			if(!(spans[i].style.height))
				spans[i].style.height="18px";

		}
	}catch(e){}

}

function transformNode(xml, xsl){
	var xmlDoc = getXMLDoc(getXmlContent(xml));
	if(xmlDoc == null || xmlDoc.documentElement == null)
		throw "解析XML信息失败!";
	
	xsl=xsl.replace(/&/g,"&amp;");//xml中&是特殊字符
	var xslDoc = getXMLDoc(getXmlContent(xsl));
	if(xslDoc == null || xslDoc.documentElement == null)
		throw "解析XML信息失败!";
	modify(xslDoc);//对图片的路径进行编辑 加上 /seeyon
	return getXSLDoc(xmlDoc, xslDoc);
}

//对图片的路径进行编辑 加上 /seeyon
function modify(xslElement){
	var imgs = xslElement.getElementsByTagName("img");
	for(var i = 0; i < imgs.length; i++){
		if(imgs[i].getAttribute("srcId") != null)
			imgs[i].setAttribute("src", v3x.baseURL + imgs[i].getAttribute("src"));
	}
}

function initStr(aUrl){
	var requestCaller = new XMLHttpRequestCaller(null, "", "", false, "GET", "false", aUrl);
	var rs = requestCaller.serviceRequest();
	if(rs == ""){
  		alert(v3x.getMessage("collaborationLang.formdisplay_loaderror"));
  	}
	return rs;
}

function Init_Image(){
	var content = "<div id='add' style='display: none;Z-INDEX: 98;POSITION: absolute;'>" +
			          "<img id='addImg' onclick='add()'></img></div>" +
			          "<div id='del' style='display: none;Z-INDEX: 98;POSITION: absolute;'>" +
			          "<img id='delImg' onclick='del()'></img></div>";

	var arrow = document.getElementById( "img" );
	arrow.innerHTML = content;
}

//取到area并进行替换
function initHtml(aInput){
	Init_Image();
	//document.onclick = SeeyonForm_BuildDocClickHandler('common');
	var fFiledList = paseFormatXML(getXmlContent(aInput))
	convertHtml(fFiledList);
	var repeatTable = new Seeyonform_rtable();
	repeatTable.change();
	var reSection = new Seeyonform_rsection();
	reSection.change();
}

function convertHtml(aFieldList){
	var field;
	var fAreas;
	for(var i = 0; i < aFieldList.length; i++) {
		 field = aFieldList[i];
		 fAreas = field.findArea(field.fieldName);
		 if(fAreas != 0){
			 for(var j =0; j < fAreas.length;j++){
				 	if(field.access == "edit" || field.access == null ){
				 		field.change(fAreas[j]);
				 		if(firstCanEditElementId==""){firstCanEditElementId=field.fieldName;}
					 	isIncludeCanUpdateElement=true;
				 	}else if(field.access == "browse"){
				 		 field.browse(fAreas[j]);
				 	}else if(field.access == "hide"){
				 		 field.hide(fAreas[j]);
					}else{}
		 	}//for
		 }else{
		 	//throw "页面没有名为"+ field.fieldName +"的span元素";
		 }
	}
}

function initJSObject(data){
	var xmlDoc = getXMLDoc(getXmlContent(data));
	if(xmlDoc == null || xmlDoc.documentElement == null)
     	throw "解析XML信息失败!";
	var root = xmlDoc.documentElement;
	formRecordId = root.getAttribute("recordid");//表单ID
	var nodes = root.childNodes;
	var field = null;
	for(var i = 0; i < nodes.length; i++){
  		var fo = new FieldObject();
  		if(isDataValueNode(nodes[i])){
  			field = new Field();
  			field.name = nodes[i].nodeName;
  			if(nodes[i].getAttribute("value") != null){
  				field.defaultValue = getXMLAttValue(nodes[i],"value");
  			}
  			field.value = nodes[i].nodeValue;
  			if(fo.fieldList == null){
  				fo.fieldList = new Array();
  			}
  			fo.fieldList[fo.fieldList.length] = field;
  			fieldObjList[fieldObjList.length] = fo;
  		}else{//如果是重复表或是重复节
  			var path = nodes[i].nodeName;
  			path = path + "/" + nodes[i].childNodes[0].nodeName;
  			for(var j = 0; j < nodes[i].childNodes.length; j++){
  				fo = new FieldObject();
  				fo.path = path;
				fo.recordid = nodes[i].childNodes[j].getAttribute("recordid");
				var groupNodes = nodes[i].childNodes[j].childNodes;
				for(var igroupNodes = 0; igroupNodes < groupNodes.length; igroupNodes++){
					fo.recordid = nodes[i].childNodes[j].getAttribute("recordid");
					field = new Field();
					field.name = groupNodes[igroupNodes].nodeName;
					if(groupNodes[igroupNodes].getAttribute("value") != null){
						field.defaultValue = getXMLAttValue(groupNodes[igroupNodes],"value");
					}
					field.value = getDataNodeValue(groupNodes[igroupNodes]);
					if(fo.fieldList == null)
							fo.fieldList = new Array();
					fo.fieldList[fo.fieldList.length] = field;
				}
				if(nodes[i].childNodes[j].getAttribute("recordid") != "-1"){//如果不是新建需要往JS对象和数据框架填加
					fieldObjList[fieldObjList.length] = fo;
				}
				if(!hasObject(fo.path)){
					fieldStructList[fieldStructList.length] = fo;
				}
  	  		}
  		}
	}
}

/***************************** Seeyonform_label start *************************************/
//变成label的具体实现
function Seeyonform_label(){
	this.fieldName = null;
	this.access = null;
	this.allowprint = null;
	this.allowtransmit = null;
}
Seeyonform_label.prototype.change = function(aArea) {
	aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + "  value=\"" +
	                 aArea.innerText + "\" name='" + this.fieldName +"' id='" + this.fieldName +"' style='" + aArea.style.cssText + "; border:0px;' disabled />";
}
Seeyonform_label.prototype.browse = function(aArea) {
	aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + "value=\"" +
	                 aArea.innerText + "\" style='" + aArea.style.cssText + "; border:0px;' disabled />";
}
Seeyonform_label.prototype.hide = function(aArea){
	aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + "value='*' style='" + aArea.style.cssText + "; border:0px;' disabled />";
}
Seeyonform_label.prototype.findArea = function(aName){
	var spans = document.getElementsByTagName("span");
	var fields = new Array();
	var j = 0;
	for(var i = 0; i < spans.length; i++){
			if(spans[i].getAttribute("xd:binding") == aName){
					fields[j] = spans[i];
					j++;
			}
	}
	return fields;
}
/***************************** Seeyonform_label end *************************************/

/***************************** Seeyonform_text start *************************************/
//变成text的具体实现
function Seeyonform_text(){
	 this.fieldName = null;
	 this.access = null;
	 this.allowprint = null;
	 this.allowtransmit = null;
	 this.is_null = true;
	 this.required = null;
	 this.fieldtype= null;
	 this.length = null;
	 this.digit = null;
	 this.maxLength = null;
	 this.inputName = null;
}
Seeyonform_text.prototype.change = function(aArea) {
	var styleStr=aArea.style.cssText;
	var readOnlyStr="";
	var titleStr="";
	var onclickStr="";
	if(this.fieldtype=="date") {//<span class='calendar_icon_area _autoBtn'><span class='calendar_icon' style='left: -20px; top: -1px; position: absolute;'></span></span>" + "</div>
		styleStr+=";cursor:hand;width:98%;";
		readOnlyStr=" readOnly";
		//titleStr=jsStr_ClickInput;
	}
	if(this.required && this.required== "true" && replaceApos(aArea.innerText) == ""){
        //先保存原背景颜色
	    aArea.setAttribute("bgColor", aArea.style.backgroundColor);
	    styleStr+=";background-Color:#FCDD8B";
    }
	var objValue=aArea.innerText;
	objValue=toJsStr(objValue);
	if(this.fieldtype == "date") {
		aArea.outerHTML="<input class='comp input_date' comp='type:\"calendar\",ifFormat:\"%Y-%m-%d %H:%M\",showsTime:true'  canSubmit='true' "+ getFieldAttr(this) + " value=\"" +
        objValue + "\" name='" + this.fieldName +"' id='" + this.fieldName +"' style='" + styleStr + "' title='"+titleStr+"'"+readOnlyStr+" onClick='"+onclickStr + "' onpropertychange = 'onkeyupColor(this)' onkeyup = 'onkeyupChangeColor(this)' />";
	} else {
		aArea.outerHTML="<input class='xdTextBox' canSubmit='true' "+ getFieldAttr(this) + " value=\"" +
        objValue + "\" name='" + this.fieldName +"' id='" + this.fieldName +"' style='" + styleStr + "' title='"+titleStr+"'"+readOnlyStr+" onClick='"+onclickStr + "' onpropertychange = 'onkeyupColor(this)' onkeyup = 'onkeyupChangeColor(this)' />";
	}
}
Seeyonform_text.prototype.browse = function(aArea) {
	var objValue=aArea.innerText;
	objValue=toJsStr(objValue);
	var cssStr = aArea.style.cssText;//name='" + this.fieldName + "'   id='" + this.fieldName + "'
	if(cssStr.indexOf("WHITE-SPACE: normal")!=-1||cssStr.indexOf("WORD-WRAP: break-word")!=-1){
		if(cssStr.toLowerCase().indexOf("text-align: center")!=-1 && cssStr.toLowerCase().indexOf("white-space: nowrap")!=-1){
			cssStr = cssStr.replace(/white-space: nowrap;/,"word-break: break-all;");
		}
		objValue = objValue.replace(/<br>/gi,"\n");
		aArea.outerHTML = "<textarea title='"+objValue+"' wrap='physical'" +
						  " ' style='" + cssStr + ";overflow:visible;border:0px '" + getFieldAttr(this) + " readOnly=true>" +
						  objValue + "</textarea>";
	}else{//name='" + this.fieldName +"' id='" + this.fieldName +"'
		aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this, true) + " value=\"" +
              objValue + "\""+ " title=\""+objValue+"\" "+" style='" + aArea.style.cssText + "; border:0px;' readOnly=true/>";
	}
}
Seeyonform_text.prototype.hide = function(aArea){
	aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + " value='*' name='" + this.fieldName +"' id='" + this.fieldName +"' style='" + aArea.style.cssText + "; border:0px;' disabled/>";
}
Seeyonform_text.prototype.findArea = function(aName){
	var spans = document.getElementsByTagName("span");
	var fields = new Array();
	var j = 0;
	for(var i = 0; i < spans.length; i++){
			if(spans[i].getAttribute("xd:binding") == aName){
					fields[j] = spans[i];
					j++;
			}
	}
	return fields;
}
function toJsStr(str) {
	if(!str){
		return str;
	}
	var strTemp=str.replace(/"/g,"&quot;");
	strTemp=strTemp.replace(/</g,"&lt;");
	strTemp=strTemp.replace(/>/g,"&gt;");
	return strTemp;
}
/***************************** Seeyonform_text end *************************************/

/***************************** Seeyonform_textArea start *************************************/
//变成textArea的具体实现
function Seeyonform_textArea(){
	this.fieldName = null;
	this.access = null;
	this.allowprint = null;
	this.allowtransmit = null;
	this.required = null;
	this.inputName = null;
}
Seeyonform_textArea.prototype.change = function(aArea){
	var cssStr = aArea.style.cssText;
	if(cssStr.indexOf("TEXT-ALIGN: center;")!=-1 && cssStr.indexOf("WHITE-SPACE: nowrap;")!=-1){
		cssStr = cssStr.replace(/WHITE-SPACE: nowrap;/,"word-break: break-all;");
	}else if(cssStr.indexOf("TEXT-ALIGN: center")!=-1 && cssStr.indexOf("WHITE-SPACE: nowrap;")!=-1){
		cssStr = cssStr.replace(/WHITE-SPACE: nowrap;/,"word-break: break-all;");
	}else if(cssStr.indexOf("text-align: center;")!=-1 && cssStr.indexOf("white-space: nowrap;")!=-1){
		cssStr = cssStr.replace(/white-space: nowrap;/,"word-break: break-all;");
	}
    if(this.required && this.required== "true" && replaceApos(aArea.innerText) == ""){
        //先保存原背景颜色
        aArea.setAttribute("bgColor", aArea.style.backgroundColor);
        cssStr+=";background-Color:#FCDD8B";
    }
	//增加access属性，处理公文时如果textarea是readOnly的，再判断access属性是否为edit
    // 因为之前<> 进行了转义，所以现在判断的时候，必须得转回来
    var tempAreaValue = aArea.innerText?aArea.innerText.replace(/&lt;br&gt;/gi,"<br>").replace(/<br>/gi,"\n"):aArea.innerText;
    tempAreaValue = toJsStr(tempAreaValue);

//	aArea.outerHTML = "<textarea name='" + this.fieldName + "' id='" + this.fieldName + "' wrap='physical'" +
//	                  " ' style='" + cssStr + "' " + getFieldAttr(this) + " canSubmit='true' onpropertychange = 'onkeyupColor(this)' >"
//	                  +(aArea.innerText?aArea.innerText.replace(/<br>/gi,"\n"):aArea.innerText)+"</textarea>";

	aArea.outerHTML = "<textarea name='" + this.fieldName + "' id='" + this.fieldName + "' wrap='physical'" +
	" ' style='" + cssStr + "' " + getFieldAttr(this) + " canSubmit='true' onpropertychange = 'onkeyupColor(this)' onkeyup = 'onkeyupChangeColor(this)' >"
	+(tempAreaValue)+"</textarea>";

}
Seeyonform_textArea.prototype.browse = function(aArea){
	var cssStr = aArea.style.cssText;
	if(cssStr.indexOf("TEXT-ALIGN: center;")!=-1 && cssStr.indexOf("WHITE-SPACE: nowrap;")!=-1){
		cssStr = cssStr.replace(/WHITE-SPACE: nowrap;/,"word-break: break-all;");
	}else if(cssStr.indexOf("TEXT-ALIGN: center")!=-1 && cssStr.indexOf("WHITE-SPACE: nowrap;")!=-1){
		cssStr = cssStr.replace(/WHITE-SPACE: nowrap;/,"word-break: break-all;");
	}else if(cssStr.indexOf("text-align: center;")!=-1 && cssStr.indexOf("white-space: nowrap;")!=-1){
		cssStr = cssStr.replace(/white-space: nowrap;/,"word-break: break-all;");
	}
	var str = aArea.innerText;
	//考虑到单行文本中也调用toJsStr方法，所以在这里转换
	if(str){
		// 因为之前<> 进行了转义，所以现在判断的时候，必须得转回来
		var strBr = str.replace(/&lt;br&gt;/gi,"<br>");
		str = strBr.replace(/<br>/gi,"\n");
	}
		str=str.replace(/ /g,"&nbsp;");
		str=toJsStr(str);


	var ua = "";//

	//padding-right:20px:主要是控制多行文本的每行的字数和录入的时候的字符一样39385。
	if(v3x.isMSIE7||(v3x.isMSIE && (ua.indexOf('MSIE 6.0') != -1))){//当IE7或者IE6的时候不添加title为了避免打印的时候有特殊字符使样式显示不出来,bug40374
		aArea.outerHTML = "<textarea id='" + this.fieldName + "' wrap='physical'" +
	                  " ' style='" + cssStr + ";overflow:visible;border:0px ;'" + getFieldAttr(this, true) + " readOnly=true>" +
	                  str + "</textarea>";
	} else {//name='" + this.fieldName + "' id='" + this.fieldName + "'
		aArea.outerHTML = "<textarea id='" + this.fieldName + "' title='"+str+"' wrap='physical'" +
		                  " ' style='" + cssStr + ";overflow:visible;border:0px ;'" + getFieldAttr(this, true) + " readOnly=true>" +
		                  str + "</textarea>";
	}
}
Seeyonform_textArea.prototype.hide = function(aArea){
	aArea.outerHTML = "<textarea name='" + this.fieldName + "' id='" + this.fieldName + "' wrap='physical'" +
	                  " ' style='" + aArea.style.cssText + "; border:0px;  '" + getFieldAttr(this) + " disabled>" +
	                  "*" + "</textarea>";
}
Seeyonform_textArea.prototype.findArea = function(aName){
	var spans = document.getElementsByTagName("span");
	var fields = new Array();
	var j = 0;
	for(var i = 0; i < spans.length; i++){
			if(spans[i].getAttribute("xd:binding") == aName){
					fields[j] = spans[i];
					j++;
			}
	}
	return fields;
}
/***************************** Seeyonform_textArea end *************************************/

/***************************** Seeyonform_select start *************************************/
//变成select的具体实现
function Seeyonform_select(){
	this.fieldName = null;
	this.valueList = null;
	this.access = null;
	this.allowprint = null;
	this.allowtransmit = null;
	this.required = null;
	this.inputName = null;
}
Seeyonform_select.prototype.change = function(aArea) {
	var fOption = "";
	if(this.valueList == null)
			throw  "没有为"+ field.fieldName +"的元素赋valueLis值";
	else {
	        var fromSend=document.getElementById("fromSend");
			if(typeof(currentPage)!="undefined" && currentPage=="newEdoc"
				&&(this.fieldName=="my:doc_mark" || this.fieldName=="my:doc_mark2" || this.fieldName=="my:serial_no")
				&& this.valueList.length==2 && fromSend && fromSend.value!="true") {
				for(var i = 0; i < this.valueList.length; i++){
					if(this.valueList[i].value!="")
							fOption += "<option value=\"" + escapeStringToHTML(this.valueList[i].value) + "\" selected>" + escapeStringToHTML(this.valueList[i].label) + "</option>";
					else
							fOption += "<option value=\"" + escapeStringToHTML(this.valueList[i].value) + "\">" + escapeStringToHTML(this.valueList[i].label) + "</option>";
				}
			}else{
				for(var i = 0; i < this.valueList.length; i++){
					if(aArea.innerText == this.valueList[i].value)
							fOption += "<option value=\"" + escapeStringToHTML(this.valueList[i].value) + "\" selected>" + escapeStringToHTML(this.valueList[i].label) + "</option>";
					else
							fOption += "<option value=\"" + escapeStringToHTML(this.valueList[i].value) + "\">" + escapeStringToHTML(this.valueList[i].label) + "</option>";
				}
			}
			var styleStr=aArea.style.cssText;
			if(this.required && this.required== "true" && replaceApos(aArea.innerText) == ""){
		        //先保存原背景颜色
			    aArea.setAttribute("bgColor", aArea.style.backgroundColor);
			    styleStr+=";background-Color:#FCDD8B";
		    }
			aArea.outerHTML="<select class='xdComboBox xdBehavior_Select' id='" + this.fieldName + "' name='" + this.fieldName  + "' " + getFieldAttr(this) +" style='"+styleStr+"' onpropertychange = 'onkeyupColor(this)' onkeyup = 'onkeyupChangeColor(this)' >" +
	                 		fOption +
	                 		"</select>";
	}
}
Seeyonform_select.prototype.browse = function(aArea){
	var fOption;
	if(this.valueList == null)
			throw  "没有为"+ field.fieldName +"的元素赋valueLis值";
	else{
		for(var i = 0; i < this.valueList.length; i++){
		    var _innerValue = aArea.innerText;
		    _innerValue = _innerValue.replace(/^\n+|\n+$/g, "");
			if(_innerValue == this.valueList[i].value){
				var tempStr = this.valueList[i].label;
				if(this.valueList[i].value == ""){
					tempStr = "";
				}//name='" + this.fieldName +"' id='" + this.fieldName +"'
						//fOption += "<option value='" + this.valueList[i].value + "' selected>" + this.valueList[i].label + "</option>";
				aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this, true) + "  value=\"" +
               	 tempStr + "\" realValue='" + aArea.innerText +"' style='" + aArea.style.cssText + "; border:0px;' readOnly=true/>";
			}
		}
		//公文文号为“只读”当调用模板拟文或者直接拟文时不显示公文文号
		if((this.fieldName=="my:doc_mark"
			||this.fieldName=="my:doc_mark2"
			||this.fieldName=="my:serial_no" )
			&& typeof(currentPage)!="undefined" && currentPage=="newEdoc") {
			tempStr = "";//name='" + this.fieldName +"' id='" + this.fieldName +"'
			aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + "  value=\"" +
          	tempStr + "\" realValue='" + aArea.innerText +"' style='" + aArea.style.cssText + "; border:0px;' readOnly=true/>";
		}
	}
}
Seeyonform_select.prototype.hide = function(aArea){
	var fOption;
	if(this.valueList == null)
			throw  "没有为"+ field.fieldName +"的元素赋valueLis值";
	else{
			for(var i = 0; i < this.valueList.length; i++){
					if(aArea.innerText == this.valueList[i].value){
							//fOption += "<option value='" + this.valueList[i].value + "' selected>" + this.valueList[i].label + "</option>";
							aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + "  value='*' name='" + this.fieldName +"' id='" + this.fieldName +"' style='" + aArea.style.cssText + "; border:0px;' disabled/>";
					}
			}
	}
}
Seeyonform_select.prototype.findArea = function(aName){
	var spans = document.getElementsByTagName("span");
	var fields = new Array();
	var j = 0;
	for(var i = 0; i < spans.length; i++){
			if(spans[i].getAttribute("xd:binding") == aName){
					fields[j] = spans[i];
					j++;
			}
	}
	return fields;
}
/***************************** Seeyonform_select end *************************************/

/***************************** Seeyonform_extend start *************************************/
//变成extend的实现
function Seeyonform_extend(){
	this.fieldName = null;
	this.furl = null;
	this.fimg = null;
	this.access = null;
	this.allowprint = null;
	this.allowtransmit = null;
}
Seeyonform_extend.prototype.change = function(aArea) {
	aArea.style.pixelWidth = aArea.style.pixelWidth - 18;
	aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + " name='" + this.fieldName + "' id='" + this.fieldName + "' style='" + aArea.style.cssText +"' value=\"" + aArea.innerText +"\">" +
                  "</input>" +
                  "<img src='" + this.fimg + "' onclick=" + this.furl + " />";

}
Seeyonform_extend.prototype.browse = function(aArea) {	//name='" + this.fieldName + "' id='" + this.fieldName + "'
	aArea.outerHTML="<input class='xdTextBox' style='" + aArea.style.cssText +"' value=\"" + aArea.innerText +
	                "\"; border:0px;' " + getFieldAttr(this, true) + " readOnly=true>" +
                  "</input>";
}
Seeyonform_extend.prototype.hide = function(aArea){//name='" + this.fieldName + "' id='" + this.fieldName + "'
	aArea.outerHTML="<input class='xdTextBox' style='" + aArea.style.cssText +"' value='*" +
	                "; border:0px;' " + getFieldAttr(this) + " disabled>" +
                  "</input>";
}
Seeyonform_extend.prototype.findArea = function(aName){
	var spans = document.getElementsByTagName("span");
	var fields = new Array();
	var j = 0;
	for(var i = 0; i < spans.length; i++){
			if(spans[i].getAttribute("xd:binding") == aName){
					fields[j] = spans[i];
					j++;
			}
	}
	return fields;
}
/***************************** Seeyonform_extend end *************************************/

/***************************** Seeyonform_radio start *************************************/
//变成radio的实现
function Seeyonform_radio(){
	this.fieldName = null;
	this.valueList = null;
	this.access = null;
	this.allowprint = null;
	this.allowtransmit = null;
}
Seeyonform_radio.prototype.change = function(aArea) {
	var fRadio = "";
	if(this.valueList != null){
		for(var i = 0; i < this.valueList.length; i++){
			if(aArea.innerText == this.valueList[i].value){
				fRadio += "<label>" +
							"<input class='xdBehavior_Boolean' type='radio' " + getFieldAttr(this) + " value=\"" +
							this.valueList[i].value +"\" name='" + this.fieldName +"' id='" + this.fieldName + "' checked />" +
							this.valueList[i].label + "</label>";
			}else{
				fRadio += "<label>" +
							"<input class='xdBehavior_Boolean' type='radio' " + getFieldAttr(this) + " value=\"" +
							this.valueList[i].value +"\" name='" + this.fieldName +"' id='" + this.fieldName +"'/>" +
							this.valueList[i].label + "</label>";
			}
		}
		aArea.outerHTML=fRadio;
	} else {
		throw  "没有为"+ this.fieldName +"的元素赋valueList值";
	}
}
Seeyonform_radio.prototype.browse = function(aArea){
	var fRadio = "";
	if(this.valueList != null){
		for(var i = 0; i < this.valueList.length; i++){
			if(aArea.innerText == this.valueList[i].value){
				aArea.outerHTML= "<input class='xdTextBox' style='" + aArea.style.cssText +"' value=\"" + this.valueList[i].label +
	                						"\"; border:0px;' " + getFieldAttr(this) + " readOnly=true>" +
                  						"</input>";
			}
		}
	} else {
		throw  "没有为"+ this.fieldName +"的元素赋valueList值";
	}
}
Seeyonform_radio.prototype.hide = function(aArea){
	var fRadio = "";
	if(this.valueList != null) {
		for(var i = 0; i < this.valueList.length; i++){
			if(aArea.innerText == this.valueList[i].value){
				aArea.outerHTML= "<input class='xdTextBox' name='" + this.fieldName + "' id='" + this.fieldName + "' style='" + aArea.style.cssText +"' value='*" +
										   "; border:0px;' " + getFieldAttr(this) + " disabled>" +
										   "</input>";
			}
		}
	} else {
		throw  "没有为"+ this.fieldName +"的元素赋valueList值";
	}
}
Seeyonform_radio.prototype.findArea = function(aName){
	var spans = document.getElementsByTagName("span");
	var fields = new Array();
	var j = 0;
	for(var i = 0; i < spans.length; i++){
		if(spans[i].getAttribute("xd:binding") == aName){
			fields[j] = spans[i];
			j++;
		}
	}
	return fields;
}
/***************************** Seeyonform_radio end *************************************/

/***************************** Seeyonform_combo start *************************************/
//变成combo的实现
function Seeyonform_combo(){
	this.fieldName = null;
	this.calcList = null;
	this.access = null;
	this.allowprint = null;
	this.allowtransmit = null;
}
Seeyonform_combo.prototype.change = function(aArea){
	aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + " value=\""+
							  aArea.innerText + "\" name='" + this.fieldName +"' id='" + this.fieldName +"' style='" + aArea.style.cssText + "'/>";
}
Seeyonform_combo.prototype.browse = function(aArea){
	aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + " value=\""+
	                 		  aArea.innerText + "\" style='" + aArea.style.cssText + "; border:0px;' readOnly=true />";
}
Seeyonform_combo.prototype.hide = function(aArea){
	aArea.outerHTML="<input class='xdTextBox' " + getFieldAttr(this) + " value='"+
	                          "*' name='" + this.fieldName +"' id='" + this.fieldName +"' style='" + aArea.style.cssText + "; border:0px;' disabled />";
}
Seeyonform_combo.prototype.findArea = function(aName){
	var spans = document.getElementsByTagName("span");
	var fields = new Array();
	var j = 0;
	for(var i = 0; i < spans.length; i++){
			if(spans[i].getAttribute("xd:binding") == aName){
					fields[j] = spans[i];
					j++;
			}
	}
	return fields;
}
/***************************** Seeyonform_comb end *************************************/

//显示值类
function Display_value(label, value){
	this.value = value;
	this.label = label;
}

function Cacl_value(){
	this.value = null;
	this.name = null;
}

function Cacl_Opertion (){
	this.operation = null;
	this.display = null;
}
//取得元素的access allowprint allowtransmit属性
function getFieldAttr(aField, isBrower){
	var fieldAttr = " ";
	if(aField.access != null) {
			fieldAttr = "access='" + aField.access + "' ";
	}
	if(aField.allowprint != null) {
			fieldAttr += "allowprint='" + aField.allowprint + "' ";
	}
	if(aField.allowtransmit != null){
			fieldAttr += "allowtransmit='" + aField.allowtransmit + "' ";
	}
	if(aField.required != null && !isBrower){
        fieldAttr += "required='" + aField.required + "' ";
	}
	if(aField.maxLength != null) {
		fieldAttr += "maxLength='" + aField.maxLength + "' ";
	}
	if(aField.inputName != null) {
		fieldAttr += "inputName='" + aField.inputName + "' ";
	}
	return fieldAttr;
}

/***************************** Seeyonform_rtable start *************************************/
//重复表实现
function Seeyonform_rtable(){}
Seeyonform_rtable.prototype.findTbody = function(){
	arrayTbody = new Array();
  var iTbody = 0;
	var tbodys = document.getElementsByTagName("tbody");
	for(var i = 0; i < tbodys.length; i++){
			if(tbodys[i].getAttribute("xd:xctname") == "RepeatingTable"){
					arrayTbody[iTbody] = tbodys[i];
			 		arrayTbody[iTbody].setAttribute("id", "rtable" + iTbody);
			 		iTbody++;//返回tbody数组
			 		this.changeTr(tbodys[i]);
			}
	}
}
Seeyonform_rtable.prototype.change = function(){
	this.findTbody();
}
Seeyonform_rtable.prototype.changeInput = function(){}
Seeyonform_rtable.prototype.changeTr = function(tbody){
		var trs = tbody.getElementsByTagName("tr");
		for(var i = 0; i < trs.length; i++){
				trs[i].setAttribute("oper", "add");
		}
}
/***************************** Seeyonform_rtable end *************************************/

/***************************** Seeyonform_rsection start *************************************/
//重复节的实现
function Seeyonform_rsection() {}
Seeyonform_rsection.prototype.chgSection = function(){
	arrayDiv = new Array();
	var iDiv = 0;
	var divs = document.getElementsByTagName("div");
	for(var i = 0; i < divs.length; i++){
			if(divs[i].getAttribute("xd:xctname") == "RepeatingSection"){
			 		arrayDiv[iDiv] = divs[i];
	  	 		arrayDiv[iDiv].setAttribute("oper", "add");
	  	 		iDiv++;//返回div数组
		}
	}
}
//得到所有重复节
Seeyonform_rsection.prototype.getSection = function(){
	arrayDiv = new Array();
var iDiv = 0;
	var divs = document.getElementsByTagName("div");
	for(var i = 0; i < divs.length; i++){
			if(divs[i].getAttribute("xd:xctname") == "RepeatingSection"){
			 		arrayDiv[iDiv] = divs[i];
			 		iDiv++;//返回div数组
		}
	}
}
/*
Seeyonform_rsection.prototype.findBySid = function(sid){
	arrayDiv = new Array();
var iDiv = 0;
	var divs = document.getElementsByTagName("div");
	for(var i = 0; i < divs.length; i++){
			if(divs[i].getAttribute("sid") == sid){
					arrayDiv[iDiv] = divs[i];
			 		iDiv++;//返回div数组
			}
	}
}*/
Seeyonform_rsection.prototype.findByPath = function(path){
	arrayDiv = new Array();
	var iDiv = 0;
	var divs = document.getElementsByTagName("div");
	for(var i = 0; i < divs.length; i++){
			if(divs[i].getAttribute("path") == path){
			 		arrayDiv[iDiv] = divs[i];
			 		iDiv++;//返回tbody数组
			}
	}
}
Seeyonform_rsection.prototype.change = function(){
	this.chgSection();
}
/***************************** Seeyonform_rsection end *************************************/

/***************************** Seeyonform_方法 start *************************************/
function SeeyonForm_RefreshXmlToEditItem( source , isSetItemId ){
	var add = document.getElementById( "add" );
	var del = document.getElementById( "del" );
	if( add == null ){
		return null;
	}
	if( del == null ){
		return null;
	}
	var itemXmlToEdits = SeeyonForm_GetItemXmlToEdits( source );
	if( itemXmlToEdits.xmlToEditNames.length > 0 ){
		var itemElement = itemXmlToEdits.itemElement;
		if( isSetItemId ){
			add.setAttribute( "itemId" , SeeyonForm_GetElementOper( itemElement ) );
			del.setAttribute( "itemId" , SeeyonForm_GetElementOper( itemElement ) );
		}
		return itemElement;
	}
}
function SeeyonForm_GetItemXmlToEdits( source ){
	var xmlToEditItems = new Array();
	var xmlToEditItem = new Object();
	xmlToEditItem.name = "addItem";
	xmlToEditItem.items = "add".split(";");
	xmlToEditItems[ xmlToEditItems.length ] = xmlToEditItem;
	var itemXmlToEdits = new Object();
	itemXmlToEdits.xmlToEditNames = new Array();
	SeeyonForm_GetItemElement( itemXmlToEdits , xmlToEditItems , source );
	return itemXmlToEdits;
}
function SeeyonForm_GetItemElement( itemXmlToEdits , xmlToEditItems , source ){
	if( source == null || source.tagName.toLowerCase() == "body" ){
		return;
	}
	for( var i = 0 ; i < xmlToEditItems.length ; i ++ ){
		var items = xmlToEditItems[ i ].items;
		for( var m = 0 ; m < items.length ; m ++ ){
			if( items[ m ] != "" ){
				if( SeeyonForm_GetElementOper( source ) == items[ m ] ){
					itemXmlToEdits.xmlToEditNames[ itemXmlToEdits.xmlToEditNames.length ] = xmlToEditItems[ i ].name;
				}
			}
		}
	}
	if( itemXmlToEdits.xmlToEditNames.length > 0 ){
		itemXmlToEdits.itemElement = source;
		return;
	}
	SeeyonForm_GetItemElement( itemXmlToEdits , xmlToEditItems , SeeyonForm_GetParent( source ) );
	return;
}
function SeeyonForm_IsIE(){
	if( document.all ){
		return true;
	}else{
		return false;
	}
}
function SeeyonForm_ShowArrow( itemElement ){
	var addImg = document.getElementById( "addImg" );
	var delImg = document.getElementById( "delImg" )
	var xdPrefix = "xd:";
	var xctName = itemElement.getAttribute( xdPrefix + "xctname" );
	addImg.src = "./image/add.gif";
	delImg.src = "./image/delete.gif";
	var pos = SeeyonForm_GetPos( itemElement );
	var add= document.getElementById( "add" );
	var del = document.getElementById( "del" );
	var tr = document.getElementById("oper");
	if(tr != null){
		tr.setAttribute("id","");//图标消失去除tr 的id ="oper";
	}
	itemElement.setAttribute("id", "oper");
	add.style.left = pos.left - 18 + 2;
	add.style.top = pos.top + 2;
	add.style.display = "block";
	del.setAttribute("index", itemElement.getAttribute("index"));//把tr的index赋与img
	del.style.left = pos.left - 18 + 2;
	del.style.top = pos.top + 12 + 2;
	del.style.display = "block";
}
function SeeyonForm_GetPos( element ){
	var pos = {left:0 , top:0};
	if( SeeyonForm_IsIE() ){
		var rect = element.getBoundingClientRect();
	  var frameType = 0;
		var offsetX = 0;
		var offsetY = 0;
		if( frameType == 0 ){
			offsetX = -2;
			offsetY = -2;
		}else if( frameType == 1 ){
			offsetX = 0;
			offsetY = 0;
		}else if( frameType == 2 ){
			offsetX = -2;
			offsetY = 0;
		}else if( frameType == 3 ){
			offsetX = 0;
			offsetY = 0;
		}else if( frameType == 4 ){
			offsetX = 0;
			offsetY = -2;
		}else if( frameType == 5 ){
			offsetX = 0;
			offsetY = 0;
		}else if( frameType == 6 ){
			offsetX = -2;
			offsetY = 0;
		}else if( frameType == 7 ){
			offsetX = 0;
			offsetY = -2;
		}else if( frameType == 8 ){
			offsetX = -2;
			offsetY = -2;
		}else if( frameType == 9 ){
			offsetX = -2;
			offsetY = -2;
		}
		pos.left = rect.left + offsetX + document.body.scrollLeft;
		pos.top = rect.top + offsetY + document.body.scrollTop;
	}else{
		SeeyonForm_GetPosByOffset( element , pos );
	}
	return pos;
}
function SeeyonForm_GetPosByOffset( element , pos ){
	pos.left += element.offsetLeft;
	pos.top += element.offsetTop;
	var parent = element.offsetParent;
	if( parent != null ){
		SeeyonForm_GetPosByOffset( parent , pos );
	}
}
function SeeyonForm_HideArrow(){
	var add = document.getElementById( "add" );
	var del = document.getElementById( "del" )
	if( add )
		add.style.display = "none";
	if( del )
		del.style.display = "none";
	var tr = document.getElementById("oper");
	if(tr != null)
		tr.setAttribute("id","");//图标消失去除tr 的id ="oper";
}
function SeeyonForm_BuildDocClickHandler(type){
 	return function(){ SeeyonForm_OnClick(window.event,window.event.srcElement,type); };
}
function SeeyonForm_OnClick( event , source , type ){
	SeeyonForm_OnFocus( event , source , type );
}
function SeeyonForm_OnFocus( event , source , type ){
	var itemElement = SeeyonForm_RefreshXmlToEditItem( source , true );
	if( itemElement != null ){
		InfoJet_ItemElement = itemElement;
		SeeyonForm_ShowArrow( itemElement );
	}else{
		SeeyonForm_HideArrow();
	}
}
function SeeyonForm_GetParent( element ){
	if( element == null ){
		return null;
	}
	if( SeeyonForm_IsIE() ){
		return element.parentElement;
	}else{
		return element.parentNode;
	}
}
function SeeyonForm_GetElementOper( element ){
	var oper = null;
	if(element.tagName == "TR" ){
		for(var i = 0; i < element.attributes.length; i++){
			if(element.attributes[i].name == "oper"){
				 oper = element.getAttribute("oper");
				 return oper;
			}
		}
	}
	if(element.tagName == "DIV" ){
		for(var i = 0; i < element.attributes.length; i++){
			if(element.attributes[i].name == "oper"){
				 oper = element.getAttribute("oper");
				 return  oper;
			}
		}
	}
}
/***************************** Seeyonform_方法 end *************************************/

function getElement( source ){//取得重复表或重复节的父元素
	if(source.tagName == "TABLE"){
			return source;
	}
	if(source.tagName == "DIV" ){
			for(var i = 0; i < source.attributes.length; i++){
					if(source.attributes[i].name == "xd:xctname" && source.attributes[i].value == "RepeatingSection"){
				 			return source;
					}
			}
	}
	return	getElement(SeeyonForm_GetParent( source ));
}

function add(){
	var ftr = document.getElementById("oper");
	var ftable = getElement(ftr);
	var recordid;
 	if(ftable.tagName == "TABLE"){
			var flastTr = ftable.rows[ftable.rows.length-1];
 			var faddTr = ftable.insertRow(ftable.rows.length);
 			faddTr.setAttribute("path", ftr.getAttribute("path"));
  			faddTr.setAttribute("oper", "add");
			recordid = parseInt(flastTr.getAttribute("recordid"));//取得重复表的最后一天记录
			if(recordid > 0)
				faddTr.setAttribute("recordid","-1");
			else
				faddTr.setAttribute("recordid",recordid - 1);
 			var fcells = ftr.cells;
 			var ftd;
 			for(var i = 0; i < fcells.length; i++){
 					ftd = faddTr.insertCell(i);
 					ftd.innerHTML = fcells[i].innerHTML;
 			}
 	}else{
 			var reSection = new Seeyonform_rsection();
	 	 	reSection.findByPath(ftable.getAttribute("path"));
	 	 	var addDiv = arrayDiv[arrayDiv.length -1].cloneNode(true);
			recordid = parseInt(addDiv.getAttribute("recordid"));
			if(recordid > 0)
				addDiv.setAttribute("recordid","-1");
			else
				addDiv.setAttribute("recordid",recordid - 1);

	 	 	arrayDiv[arrayDiv.length - 1].outerHTML = arrayDiv[arrayDiv.length - 1].outerHTML + addDiv.outerHTML;
	 	 	reSection.chgSection();
 	}
 	ftr.setAttribute("id", "");
}

function del() {
	var ftr = document.getElementById("oper");
	var ftable = getElement(ftr);
	if(ftable.tagName == "TABLE"){
		if(ftable.rows.length -1 > 1){
			var rowIndex = ftr.rowIndex;
				if(ftable.rows[rowIndex].getAttribute("recordid") != -1){
					for(var i = 0; i < fieldObjList.length; i++){
						if(fieldObjList[i].recordid == ftable.rows[rowIndex].getAttribute("recordid") && fieldObjList[i].path == ftable.rows[rowIndex].getAttribute("path")){
							fieldObjList[i].state = "delete";
							break;
						}
					}
				}
				ftable.deleteRow(rowIndex);
			}else{
				alert("no delete");
			}
	}else{
		var reSection = new Seeyonform_rsection();
	  	reSection.findByPath(ftable.getAttribute("path"));
	  	if(arrayDiv.length != 1 ){//修改在js对象中的相应状态
	  			if(ftable.getAttribute("recordid") != -1){
	  					for(var ifol = 0; ifol < fieldObjList.length; ifol++){
									if(fieldObjList[ifol].recordid == ftable.getAttribute("recordid") && fieldObjList[ifol].path == ftable.getAttribute("path")){
											fieldObjList[ifol].state = "delete";
											break;
									}
							}
	  			}
					ftable.outerHTML = "";
			}else
					alert("no delete");
	}
	ftr.setAttribute("id", "");
}

function paseFormatXML(finput){
	var inputList = new Array();
	var xmlDom = getXMLDoc(finput);
	if( xmlDom == null || xmlDom.documentElement == null)
     	throw "解析XML信息失败!";
	var root = xmlDom.documentElement;
	if (root.tagName!="FieldInputList")
		throw "XML信息不是SeeyonFormat的格式!找不到 'FieldInputList' 节点";
	var fNodelist = root.childNodes;
	var fien = fNodelist.length;
	var fFieldinput = getXMLNode(fNodelist,"FieldInput");
	if (fFieldinput==null)
		throw "XML信息不是SeeyonFormat的格式!<br>找不到 'FieldInput' 节点";
	for(var i = 0 ; i < fFieldinput.length; i++){
   	var attrs = fFieldinput[i].attributes;
   	for(var j = 0 ; j < attrs.length; j++){
   		if(attrs[j].name == "type"){
   			var fFieldinputType = fFieldinput[i].getAttribute("type");
   			if (fFieldinputType==null)
   				throw "XML信息不是SeeyonFormat的格式!<br> 'FieldInput'节点没有'type'属性";
                if (fFieldinputType=="label")
                     inputList[i] = paseFieldinput_LabelList(fFieldinput[i]);
                else if (fFieldinputType=="text")
                     inputList[i] = paseFieldinput_TextList(fFieldinput[i]);
                else if (fFieldinputType=="textarea")
                     inputList[i] =  paseFieldinput_TextAreaList(fFieldinput[i]);
                else if (fFieldinputType=="select")
                     inputList[i] =  paseFieldinput_SelectList(fFieldinput[i]);
                else if (fFieldinputType=="radio")
                     inputList[i] =  paseFieldinput_RadioList(fFieldinput[i]);
                else if (fFieldinputType=="comboedit")
                     inputList[i] =  paseFieldinput_ComboList(fFieldinput[i]);
                else if (fFieldinputType=="extend")
                     inputList[i] =  paseFieldinput_ExtendList(fFieldinput[i]);
            }
   		}
	}
    fieldInputListArray=inputList;
    return inputList
}

/***************************** paseFieldinput_方法 start *************************************/
//对label进行解析
function paseFieldinput_LabelList(aNode){
	var flabel = new Seeyonform_label();
   	var attrs = aNode.attributes;
   	for(var j = 0 ; j < attrs.length; j++){
   		if(attrs[j].name == "name"){
   			flabel.fieldName = aNode.getAttribute("name");
   			if (flabel.fieldName==null)
   				throw "XML信息不是SeeyonFormat的格式!<br> 'FieldInput'节点没有'name'属性";
   		}
        else if(attrs[j].name == "access"){
        	flabel.access = aNode.getAttribute("access");
        }
        else if(attrs[j].name == "allowprint"){
        	flabel.allowprint = aNode.getAttribute("allowprint");
        }
        else if(attrs[j].name == "allowtransmit"){
        	flabel.allowtransmit = aNode.getAttribute("allowtransmit");
        }
   	}
    return flabel;
}
//对text进行解析
function paseFieldinput_TextList(aNode){
	var ftext = new Seeyonform_text();
	var attrs = aNode.attributes;
	for(var j = 0 ; j < attrs.length; j++){
		if(attrs[j].name == "name"){
			ftext.fieldName = aNode.getAttribute("name");
			if (ftext.fieldName==null)
				throw "XML信息不是SeeyonFormat的格式!<br> 'FieldInput'节点没有'name'属性";
        }
        else if(attrs[j].name == "access"){
        	ftext.access = aNode.getAttribute("access");
        }
        else if(attrs[j].name == "allowprint"){
        	ftext.allowprint = aNode.getAttribute("allowprint");
        }
        else if(attrs[j].name == "allowtransmit"){
        	ftext.allowtransmit = aNode.getAttribute("allowtransmit");
        }else if(attrs[j].name == "is_null"){
   			ftext.is_null = aNode.getAttribute("is_null");
        }else if(attrs[j].name == "required"){
   			ftext.required = aNode.getAttribute("required");
        }else if(attrs[j].name == "fieldtype"){
   			ftext.fieldtype = aNode.getAttribute("fieldtype");
        }else if(attrs[j].name == "length"){
   			ftext.length = aNode.getAttribute("length");
        }else if(attrs[j].name == "digit"){
   			ftext.digit = aNode.getAttribute("digit");
        }else if(attrs[j].name == "maxLength"){
   			ftext.maxLength = aNode.getAttribute("maxLength");
        }else if(attrs[j].name == "inputName"){
   			ftext.inputName = aNode.getAttribute("inputName");
        }
	}
    return ftext;
}
//对TestArea进行解析
function paseFieldinput_TextAreaList(aNode){
   var ftextArea = new Seeyonform_textArea();
   var attrs = aNode.attributes;
   for(var j = 0 ; j < attrs.length; j++){
   		if(attrs[j].name == "name"){
   			ftextArea.fieldName = aNode.getAttribute("name");
   			if (ftextArea.fieldName==null)
   				throw "XML信息不是SeeyonFormat的格式!<br> 'FieldInput'节点没有'name'属性";
   		}
   		else if(attrs[j].name == "access"){
        	 ftextArea.access = aNode.getAttribute("access");
        }
        else if(attrs[j].name == "allowprint"){
        	ftextArea.allowprint = aNode.getAttribute("allowprint");
        }
        else if(attrs[j].name == "allowtransmit"){
        	ftextArea.allowtransmit = aNode.getAttribute("allowtransmit");
        }else if(attrs[j].name == "required"){
            ftextArea.required = aNode.getAttribute("required");
        }else if(attrs[j].name == "inputName"){
            ftextArea.inputName = aNode.getAttribute("inputName");
        }
   	}
    return ftextArea;
}
//对select进行解析
function paseFieldinput_SelectList(aNode){
	var fselect = new Seeyonform_select();
   	var dvList = new Array();
   	var attrs = aNode.attributes;
   	for(var k = 0 ; k < attrs.length; k++){
   		if(attrs[k].name == "name"){
   			fselect.fieldName = aNode.getAttribute("name");
   			if (fselect.fieldName==null)
   				throw "XML信息不是SeeyonFormat的格式!<br> 'FieldInput'节点没有'name'属性";
   		}
        else if(attrs[k].name == "access"){
        	fselect.access = aNode.getAttribute("access");
        }
        else if(attrs[k].name == "allowprint"){
        	fselect.allowprint = aNode.getAttribute("allowprint");
        }
        else if(attrs[k].name == "allowtransmit"){
        	fselect.allowtransmit = aNode.getAttribute("allowtransmit");
        }else if(attrs[k].name == "required"){
            fselect.required = aNode.getAttribute("required");
        }else if(attrs[k].name == "inputName"){
            fselect.inputName = aNode.getAttribute("inputName");
        }
   	}
	var fNodelist = aNode.childNodes;
	var flen = fNodelist.length;
    var fInput=getXMLNode(fNodelist,"Input");
    if (fInput==null)
        throw "XML信息不是SeeyonFormat的格式!<br>找不到 'Input' 节点";
	for(var i = 0; i < fInput.length; i++){
    	var attrs = fInput[i].attributes;
    	var dv = new Display_value();
    	for(var j = 0 ; j < attrs.length; j++){
   	    	if(attrs[j].name == "display"){
   	    		var fInputDisplay = fInput[i].getAttribute("display");
   	            dv.label =  fInputDisplay ;
   	            if (fInputDisplay==null)
   	            	throw "XML信息不是SeeyonFormat的格式!<br> 'Input'节点没有'display'属性";
   	    	}
   	        else if(attrs[j].name == "value"){
   	        	var fInputValue = fInput[i].getAttribute("value");
   	            dv.value =  fInputValue ;
   	            if (fInputValue==null)
   	            	throw "XML信息不是SeeyonFormat的格式!<br> 'Input'节点没有'value'属性";
            }
    	    dvList[i] = dv;
        }
	}
    fselect.valueList = dvList;
    return fselect;
}
//对radio进行解析
function paseFieldinput_RadioList(aNode){
	var fradio = new Seeyonform_radio();
	var dvList = new Array();
	var attrs = aNode.attributes;
	for(var k = 0 ; k < attrs.length; k++){
		if(attrs[k].name == "name"){
			fradio.fieldName = aNode.getAttribute("name");
			if (fradio.fieldName==null)
  	        	throw "XML信息不是SeeyonFormat的格式!<br> 'FieldInput'节点没有'name'属性";
        }
         else if(attrs[k].name == "access"){
        	 fradio.access = aNode.getAttribute("access");
        }
        else if(attrs[k].name == "allowprint"){
        	fradio.allowprint = aNode.getAttribute("allowprint");
        }
        else if(attrs[k].name == "allowtransmit"){
        	fradio.allowtransmit = aNode.getAttribute("allowtransmit");
        }
	}
	var fNodelist = aNode.childNodes;
	var flen = fNodelist.length;
	var fInput=getXMLNode(fNodelist,"Input");
	if (fInput==null)
		throw "XML信息不是SeeyonFormat的格式!<br>找不到 'Input' 节点";
	for(var i = 0; i < fInput.length; i++){
		var attrs = fInput[i].attributes;
		var dv = new Display_value();
		for(var j = 0 ; j < attrs.length; j++){
			if(attrs[j].name == "display"){
				var fInputDisplay = fInput[i].getAttribute("display");
   				dv.label =  fInputDisplay ;
   	            if (fInputDisplay==null)
   	            	throw "XML信息不是SeeyonFormat的格式!<br> 'Input'节点没有'display'属性";
			}
			else if(attrs[j].name == "value"){
				var fInputValue = fInput[i].getAttribute("value");
   				dv.value =  fInputValue ;
   	            	if (fInputValue==null)
   	            		throw "XML信息不是SeeyonFormat的格式!<br> 'Input'节点没有'value'属性";
        	}
        	dvList[i] = dv;
		}
	}
    fradio.valueList = dvList;
    return fradio;
}
 //对combo进行解析
function paseFieldinput_ComboList(aNode){
	var fcombo = new Seeyonform_combo();
    var cvList = new Array();
    var coList = new Array();
    var attrs = aNode.attributes;
	for(var j = 0 ; j < attrs.length; j++){
		if(attrs[j].name == "name"){
			fcombo.fieldName = aNode.getAttribute("name");
			if (fcombo.fieldName==null)
				throw "XML信息不是SeeyonFormat的格式!<br> 'FieldInput'节点没有'name'属性";
        }
        else if(attrs[j].name == "access"){
        	fcombo.access = aNode.getAttribute("access");
        }
        else if(attrs[j].name == "allowprint"){
        	fcombo.allowprint = aNode.getAttribute("allowprint");
        }
        else if(attrs[j].name == "allowtransmit"){
        	fcombo.allowtransmit = aNode.getAttribute("allowtransmit");
        }
    }
    var fNodelist = aNode.childNodes;
    var fCalculate=getXMLSNode(fNodelist,"Calculate");
    if (fCalculate==null)
        throw "XML信息不是SeeyonFormat的格式!<br>找不到 'Calculate' 节点";
    var fCalculist = fCalculate.childNodes;
    for (i = 0; i<fCalculist.length; i++){
    	if(fCalculist[i].tagName == "Value"){
    		var attrs = fCalculist[i].attributes;
        	var cv = new Cacl_value();
   	       	for(var d = 0 ; d < attrs.length; d++){
   	       		if(attrs[d].name == "value"){
   	       			var fValueValue = fCalculist[i].getAttribute("value");
   	       			cv.value =  fValueValue;
   	            	if (fValueValue==null)
   	            		throw "XML信息不是SeeyonFormat的格式!<br> 'Value'节点没有'value'属性";
   	       		}
   	       		else if(attrs[d].name == "name"){
   	       			var fValuetName = fCalculist[i].getAttribute("name");
   	       			cv.name =  fValuetName ;
   	       			if (fValuetName==null)
   	       				throw "XML信息不是SeeyonFormat的格式!<br> 'Value'节点没有'name'属性";
   	       		}
   	       	}
			if(fcombo.calcList == null)
				fcombo.calcList = new Array();
			fcombo.calcList[fcombo.calcList.length] = cv;
    	}
    	else if(fCalculist[i].tagName == "Cacl_Opertion"){
    		var attrs = fCalculist[i].attributes;
			var co = new Cacl_Opertion();
			for(var b = 0 ; b < attrs.length; b++){
				if(attrs[b].name == "operation"){
					var fCacl_OpertionValue = fCalculist[i].getAttribute("operation");
					co.operation =  fCacl_OpertionValue ;
					if (fCacl_OpertionValue==null)
                		throw "XML信息不是SeeyonFormat的格式!<br> 'Cacl_Opertion'节点没有'value'属性";
            	}
				else if(attrs[b].name == "display"){
					var fCacl_OpertionDisplay = fCalculist[i].getAttribute("display");
					co.display =  fCacl_OpertionDisplay ;
					if (fCacl_OpertionDisplay==null)
                		throw "XML信息不是SeeyonFormat的格式!<br> 'Cacl_Opertion'节点没有'display'属性";
				}
			}
			if(fcombo.calcList == null)
				fcombo.calcList = new Array();
			fcombo.calcList[fcombo.calcList.length] = co;
		}
	}
    return fcombo;
}
//对extend进行解析
function paseFieldinput_ExtendList(aNode){
     var fextend = new Seeyonform_extend();
     var attrs = aNode.attributes;
     for(var j = 0 ; j < attrs.length; j++){
    	 if(attrs[j].name == "name"){
    		 fextend.fieldName = aNode.getAttribute("name");
    		 if (fextend.fieldName==null)
    			 throw "XML信息不是SeeyonFormat的格式!<br> 'FieldInput'节点没有'name'属性";
    	 }
         else if(attrs[j].name == "access"){
        	 fextend.access = aNode.getAttribute("access");
        }
        else if(attrs[j].name == "allowprint"){
        	fextend.allowprint = aNode.getAttribute("allowprint");
        }
        else if(attrs[j].name == "allowtransmit"){
        	fextend.allowtransmit = aNode.getAttribute("allowtransmit");
        }
	}
	var fNodelist = aNode.childNodes;
	var fCom = getXMLSNode(fNodelist,"Com");
	if (fCom==null)
        throw "XML信息不是SeeyonFormat的格式!<br>找不到 'Com' 节点";
	fextend.furl=getXMLAttValue(fCom,"url");
	if (fextend.furl==null)
		throw "XML信息不是SeeyonFormat的格式!<br> 'Com'节点没有'url'属性";
	var fImg = getXMLSSNode (fCom,"img");
	if (fImg==null)
		throw "XML信息不是SeeyonFormat的格式!<br>找不到 'img' 节点";
	var fImgLink=getXMLAttValue(fImg,"src");
    fextend.fimg = fImgLink ;
    return fextend;
}
/***************************** paseFieldinput_方法 end *************************************/

/***************************** getXMLSNode start *************************************/
function getXMLSNode(aNodeList,aNodeName){
	if (aNodeList==null) return null;
	var flen = aNodeList.length;
	for (var i = 0; i < flen; i++) {
		if (aNodeList[i].tagName == aNodeName)
			return aNodeList[i];
	}
	return null;
}
function getXMLSSNode(aNode,aNodeName){
	if (aNode==null) return null;
	if(aNode.firstChild.nodeName == aNodeName){
		return aNode.firstChild;
	}
    return null;
}
function getXMLNode(aNodeList,aNodeName){
	var inputArray = new Array();
	var j = 0;
	if (aNodeList==null)
		return null;
	var flen = aNodeList.length;
	for (var i = 0; i < flen; i++) {
		if (aNodeList[i].tagName == aNodeName)
			inputArray[j] = aNodeList[i];
		j++
	}
	return inputArray;
}
function getXMLNodeValue(aNode){
	if (aNode==null) return null;
	if (aNode.firstChild==null) return null;
	return aNode.firstChild.nodeValue;
}
function getXMLAttValue(aNode,aAttName){
	if (aNode==null) return null;
	if (aNode.attributes.length==0) return null;
	var fatt=aNode.attributes.getNamedItem(aAttName);
	if (fatt==null) return null;
	return fatt.nodeValue;
}//End Function
/***************************** getXMLSNode end *************************************/

/***************************方法工具 start ********************************/
function FieldObject(){
	this.path = null;
	this.state = null;
	this.recordid = null;
	this.fieldList = null;
}
function Field(){
	this.name = null;
	this.value = null;
	this.defaultValue = null;
	this.access = null;
}
//取得xml文件的内容
function getXmlContent(xml){
	 var i;
	 for(i = 0; i < xml.length; i++){
		 if(xml.charAt(i) == '<'){
			 break;
		 }
	}
	return xml.substring(i, xml.length);
}
function isDataValueNode(aNode){
	return !aNode.hasChildNodes() || (!aNode.firstChild.hasChildNodes());
}
function getDataNodeValue(aNode){
	if (!aNode.hasChildNodes())
		return "";
	else
		return aNode.firstChild.nodeValue;
}
function hasObject(path){
	var flag = false;
	for(var ifsl = 0; ifsl < fieldStructList.length; ifsl++){
		if(fieldStructList[ifsl].path == path){
			flag = true;
			break;
		}
	}
	return flag;
}

function genJSObject(){
	//主表数据填加
	for(var i = 0; i < fieldObjList.length; i++){
		if(fieldObjList[i].path == null){
			var name = fieldObjList[i].fieldList[0].name;//取得元素名
			var element = document.getElementById(name);
			if(element.tagName == "INPUT"){
				if(element.type == "select"){
					fieldObjList[i].fieldList[0].value = element.options[element.selectedIndex].value
					fieldObjList[i].fieldList[0].access = getAccessAttr(element);
				}else if(element.type == "radio"){
					element = document.getElementsByName(name);
					for(var iRadio = 0; iRadio < element.length; iRadio++){
						if(element[iRadio].checked){
	 						fieldObjList[i].fieldList[0].value = element[iRadio].value;
							fieldObjList[i].fieldList[0].access = getAccessAttr(element[iRadio]);
						}
					}
				}else{
						fieldObjList[i].fieldList[0].value = element.value;
						fieldObjList[i].fieldList[0].access = getAccessAttr(element);
				}
			}else{
					fieldObjList[i].fieldList[0].value = element.value;
					fieldObjList[i].fieldList[0].access = getAccessAttr(element);
			}
		}
	}
	//填加重复表记录
	var fieldList = new Array();
	var field = null;
	for(var iTbody = 0; iTbody < arrayTbody.length; iTbody++){
		var trs = arrayTbody[iTbody].getElementsByTagName("tr");
		for(var iTrs = 0; iTrs < trs.length; iTrs++){
			if(parseInt(trs[iTrs].recordid) < 0){
				for(var ifsl = 0; ifsl < fieldStructList.length; ifsl++){
					if(trs[iTrs].getAttribute("path") == fieldStructList[ifsl].path){
						var fObject = new FieldObject();
						fObject.path = fieldStructList[ifsl].path;
						fObject.state = "add";
						var fl = fieldStructList[ifsl].fieldList;
						for(var ifl = 0; ifl < fl.length; ifl++){
							var allElement = trs[iTrs].all;//取得tr中的所有元素
							for(var iallElement = 0; iallElement < allElement.length; iallElement++){
								if(fl[ifl].name == allElement[iallElement].name){
									var relement = allElement[iallElement];
									field = new Field();
									field.name = fl[ifl].name;
									if(relement.tagName == "INPUT"){
										if(relement.type == "SELECT"){
											field.value = relement.options[relement.selectedIndex].value
										}else{
											field.value = relement.value;
										}
									}else{
										field.value = relement.value;
									}
									field.access = getAccessAttr(relement);
									if(fObject.fieldList == null)
										fObject.fieldList = new Array();
									fObject.fieldList[fObject.fieldList.length] = field;
								}
							}
						}
						fieldObjList[fieldObjList.length] = fObject;
					}
				}
			}else{//已经存在的记录给access属性赋值
				for(var ifol = 0; ifol < fieldObjList.length; ifol++){
					if(fieldObjList[ifol].recordid == trs[iTrs].recordid && fieldObjList[ifol].path == trs[iTrs].path){
						var allElement = trs[iTrs].all;//取得tr中的所有元素
						var fl = fieldObjList[ifol].fieldList;
						for(var iallElement = 0; iallElement < allElement.length; iallElement++){
							for(var ifl = 0; ifl < fl.length; ifl++){
								if(fl[ifl].name == allElement[iallElement].name)
									fl[ifl].access = getAccessAttr(allElement[iallElement]);
							}
						}
					}
				}
			}
		}
	}
	/** 填加重复节记录 start **/
	var ffield = null;
	var resection = new Seeyonform_rsection();
	resection.getSection();
	for(var iDiv = 0; iDiv < arrayDiv.length; iDiv++){
		for(var ifsl = 0; ifsl < fieldStructList.length; ifsl++){
			if(arrayDiv[iDiv].getAttribute("path") == fieldStructList[ifsl].path){//如果数据框架的path和div的path相等
				if(parseInt(arrayDiv[iDiv].recordid) < 0){
					var fObject = new FieldObject();
					fObject.path = fieldStructList[ifsl].path;
					fObject.state = "add";
					ffield = new Field();
					var fl = fieldStructList[ifsl].fieldList;
					for(var ifl = 0; ifl < fl.length; ifl++){
						var allElement = arrayDiv[iDiv].all;//取得div中的所有元素
						for(var iallElement = 0; iallElement < allElement.length; iallElement++){
							if(fl[ifl].name == allElement[iallElement].name){
								var relement = allElement[iallElement];
								ffield.name = fl[ifl].name;
								if(relement.tagName == "INPUT"){
									if(relement.type == "SELECT"){
										ffield.value = relement.options[relement.selectedIndex].value;
									}else{
										ffield.value = relement.value;
									}
								}else{
									ffield.value = relement.value;
								}
								ffield.access = getAccessAttr(relement);
								if(fObject.fieldList == null)
									fObject.fieldList = new Array();
								fObject.fieldList[fObject.fieldList.length] = ffield;
							}
						}
					}
					fieldObjList[fieldObjList.length] = fObject;
				}else{
					for(var ifol = 0; ifol < fieldObjList.length; ifol++){
						if(fieldObjList[ifol].recordid == arrayDiv[iDiv].getAttribute("recordid") && fieldObjList[ifol].path == arrayDiv[iDiv].getAttribute("path")){
							var allElement = arrayDiv[iDiv].all;//取得tr中的所有元素
							var fl = fieldObjList[ifol].fieldList;
							for(var iallElement = 0; iallElement < allElement.length; iallElement++){
								for(var ifl = 0; ifl < fl.length; ifl++){
									if(fl[ifl].name == allElement[iallElement].name)
										fl[ifl].access = getAccessAttr(allElement[iallElement]);
								}
							}
						}
					}
				}
			}
		}
	}
	/** 填加重复节记录 end **/
	createXML();
}

//取得节点access的属性
function getAccessAttr(element){
	if(element.getAttribute("access") == null)
		return "edit"
	else
		return element.getAttribute("access");
}
function createXML(){
	var doc = new ActiveXObject("Msxml2.DOMDocument");
	var header = doc.createProcessingInstruction("xml","version='1.0' encoding='UTF-8'");
	doc.appendChild(header);
	//var root = doc.createNode(1,"SeeyonFormSubmit", "xmlns:my", "www.seeyon.com/form/2007");
	var root = doc.createNode(1,"SeeyonFormSubmit","");
	var xmlns_my = doc.createAttribute("xmlns:my");
	xmlns_my.value = "www.seeyon.com/form/2007";
	root.setAttributeNode(xmlns_my);

	//user节点
	var user = doc.createElement("User");
	var user_userid = doc.createAttribute("userid");
	user_userid.value = "1";
	var user_username = doc.createAttribute("username");
 	user_username.value = "宋牮";
 	user.setAttributeNode(user_userid);
	user.setAttributeNode(user_username);
	var user_loginname = doc.createAttribute("longinname");
	user_loginname.value = "songj";
	user.setAttributeNode(user_loginname);
	root.appendChild(user);

	//action节点
	var action = doc.createElement("Action");
	var action_appname = doc.createAttribute("appname");
	action_appname.value = "产品销售";
	action.setAttributeNode(action_appname);
	var action_formname = doc.createAttribute("formname");
	action_formname.value = "软件产品定货单";
	action.setAttributeNode(action_formname);
	var action_opration = doc.createAttribute("operation");
	if(formOperation == "01")
		action_opration.value = "填写";
	if(formOperation == "02")
		action_opration.value = "审批";
	action.setAttributeNode(action_opration);
	if(formRecordId != null){
		var action_recordid = doc.createAttribute("recordid");
		action_recordid.value = formRecordId;
		action.setAttributeNode(action_recordid);
	}
	root.appendChild(action);

	//FormData节点
	var formData = doc.createElement("FormData");
	var formData_type = doc.createAttribute("type");
	formData_type.value = "seeyonfrom";
	formData.setAttributeNode(formData_type);
	root.appendChild(formData);

	//Engine节点
	var engine = doc.createElement("Engine");
	engine.text = "infopath";
	formData.appendChild(engine);

	//SubmitData节点
	var submitData = doc.createElement("SubmitData");
	var submitData_type = doc.createAttribute("type");
	submitData_type.value = "submit";
	submitData.setAttributeNode(submitData_type);
	var submitData_state = doc.createAttribute("state");
	submitData_state.value = "1";
	submitData.setAttributeNode(submitData_state);
	formData.appendChild(submitData);

	//my:fileds节点
	var my_fileds = doc.createElement("my:myFields");
	submitData.appendChild(my_fileds);

	for(var ifol = 0; ifol < fieldObjList.length; ifol++){
		if(fieldObjList[ifol].path == null){//主表
			var fnode = doc.createElement(fieldObjList[ifol].fieldList[0].name);
			if(fieldObjList[ifol].fieldList[0].defaultValue == null){
				if(fieldObjList[ifol].fieldList[0].value == null){
					fnode.text = "";
				}else{
					fnode.text = fieldObjList[ifol].fieldList[0].value
				}
			}else{
				fnode.text = fieldObjList[ifol].fieldList[0].defaultValue;
			}
			if(fieldObjList[ifol].fieldList[0].access == "edit")
				my_fileds.appendChild(fnode);
		}else{//重复表或重复节
			var fgroup1 = fieldObjList[ifol].path.split("/")[0];
			var fgroup2 = fieldObjList[ifol].path.split("/")[1];
			var group1 = root.selectNodes("//" + fgroup1);
			//如果没有group1节点
			if(group1.length == 0){
				var x_group1 = doc.createElement(fgroup1);
				my_fileds.appendChild(x_group1);
			}
			//填加group2节点
			group1 = root.selectNodes("//" + fgroup1);
			if(group1.length == 1){
				var x_group2 = doc.createElement(fgroup2);
				group1[0].appendChild(x_group2);
				if(fieldObjList[ifol].recordid != null){//如果不是新加记录
						var x_group2_recordid = doc.createAttribute("recordid");
						x_group2_recordid.value = fieldObjList[ifol].recordid
						x_group2.setAttributeNode(x_group2_recordid);
				}
				if(fieldObjList[ifol].state != null){//数据状态
						var x_group2_state = doc.createAttribute("state");
						x_group2_state.value = fieldObjList[ifol].state;
						x_group2.setAttributeNode(x_group2_state);
				}
				//填加数据
				var fl = fieldObjList[ifol].fieldList;//重复表记录集
				for(var ifl = 0; ifl < fl.length; ifl++){
					var frnode = doc.createElement(fl[ifl].name)
					if(fl[ifl].defaultValue == null){
						frnode.text = fl[ifl].value;
					}else{
						frnode.text = fl[ifl].defaultValue;
					}
					if(fl[ifl].access == "edit")
						x_group2.appendChild(frnode);
				}
			}
		}
	}
	var bindAppData = doc.createElement("BindAppData");
	var bindAppData_type = doc.createAttribute("type");
	bindAppData_type.value = "flow";
	bindAppData.setAttributeNode(bindAppData_type);
	root.appendChild(bindAppData);
	var xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
	var xml = xmlHeader + root.xml;
	document.getElementById("submitstr").value = xml;
}

//去掉my:
function delNameSapce(aStr){
	return aStr.substr(aStr.indexOf(":") + 1);
}
//显示时对单引号进行转义
function replaceApos(aStr){
	return aStr.replace(/'/g, "&#039;");
}

/**
* 字段为必填项初始加标识，鼠标事件
*/
function onkeyupColor(field){
	var propertyName = window.event.propertyName;
	if(propertyName=="value"){
		if(field.getAttribute("required") == "true"){
			if(field.value != "" ){
				if(field.getAttribute("bgColor") != null){
					field.style.backgroundColor = field.getAttribute("bgColor");
				}else{
					field.style.backgroundColor = "#FFFFFF";
				}
			}else{
				field.style.backgroundColor = "#FCDD8B";
			}
		}
	}
}
function onkeyupChangeColor(field){
	if(field.getAttribute("required") == "true"){
		if(field.value != "" ){
			if(field.getAttribute("bgColor") != null){
				field.style.backgroundColor = field.getAttribute("bgColor");
			}else{
				field.style.backgroundColor = "#FFFFFF";
			}
		}else{
			field.style.backgroundColor = "#FCDD8B";
		}
	}
}
/***************************方法工具 end ********************************/

/***************************字段校验用 start********************************/
//判断是否是空
function Is_Null(aFieldValue, aFieldName, aMsg) {
	if(aFieldValue == ""){
		aMsg += "不能为空\r\n";
	}
	return aMsg;
}
///判断是否由数字(int or long or float)组成 数据提交时使用
function IsNum(aFieldValue, aFieldName, aMsg) {
	if(aFieldValue==""||aFieldValue.length==0) return aMsg;
	flag_Dec = 0;
	var str
	if(aFieldValue.substr(0,1) == "-" )
		str = aFieldValue.substr(1);
	else
		str = aFieldValue;
	for(ilen=0;ilen<str.length;ilen++) {
		if(str.charAt(ilen) == '.') {
			flag_Dec++;
			if(flag_Dec > 1){
				aMsg += "输入不是数字\r\n"
					return aMsg;
			} else
				continue;
		}
		if(str.charAt(ilen) < '0' || str.charAt(ilen) > '9' ){
			aMsg += "输入不是数字\r\n"
				return aMsg;
		}
	}
	return aMsg;
}
//判断是否由数字(int or long or float)组成 用于计算字段值校验
function IsNum1(aValue) {
	var fvalue = aValue.trim();
	if(fvalue==""||fvalue.length==0) return false;
	flag_Dec = 0;
	var str
	if(fvalue.substr(0,1) == "-" )
		str = fvalue.substr(1);
	else
		str = fvalue;
	for(ilen=0;ilen<str.length;ilen++) {
		if(str.charAt(ilen) == '.') {
			flag_Dec++;
			if(flag_Dec > 1){
				return false;
			}else
				continue;
		}
		if(str.charAt(ilen) < '0' || str.charAt(ilen) > '9' ){
			return false;
		}
	}
	return true;
}
//判断是数字或字符串长度，数据提交时使用
function validFieldLength(aFieldValue, aFieldLength, aFieldName, aMsg){
	if(aFieldValue == "" || aFieldValue.length == 0) return aMsg;
	var l = aFieldValue.length;
	var blen = 0;
	for(i = 0; i < l; i++) {
		if((aFieldValue.charCodeAt(i) & 0xff00) != 0) {
			blen = blen+2;
		}
		blen++;
	}
	if (blen > parseInt(aFieldLength)){
		var characterLength = Math.floor(parseInt(aFieldLength) / 3);
		aMsg += aFieldName+"长度不能超过" + characterLength + "\r\n";
	}
	return aMsg;
}

//判断大文本是否超长
function validTextareaLength(aFieldValue, aFieldLength, aFieldName, aMsg){
	if(aFieldValue == "" || aFieldValue.length == 0) return aMsg;
	var l = aFieldValue.length;
	var blen = 0;
	for(i = 0; i < l; i++) {
		if((aFieldValue.charCodeAt(i) & 0xff00) != 0) {
			blen = blen+2;;
		}
		blen++;
	}
	if (blen > parseInt(aFieldLength)){
		var characterLength = Math.floor(parseInt(aFieldLength) / 3);
		aMsg += aFieldName + "长度不能超过" + characterLength + "\r\n";
	}
	return aMsg;
}

//判断数字整数位和小数位长度，数据提交时使用
function validDigit(aFieldValue, aFieldLength, aDigit, aFieldName, aMsg){
	if(aDigit == null) aDigit = 0;
	if(aFieldValue == "" || aFieldValue.length == 0) return aMsg;
	var len = parseInt(aFieldLength);//字段长度
	var digit = parseInt(aDigit);//小数位长度
	var integer = len - digit;//整数位长度
	var str = aFieldValue.split(".");
	if(str[0].length > integer){
		if(integer != 0)
			aMsg += "整数位长度不能超过" + integer + "\r\n";
		else
			aMsg += "不能有整数位\r\n";
	}
	if(str.length == 2){
		if(str[1].length > digit){
			if(aDigit == 0){
				aMsg += "不能有小数位\r\n";
			}else{
				aMsg += "小数位长度不能超过" + digit + "\r\n";
			}
		}
	}
	return aMsg;
}

//判断是否是日期
function isDate(aFieldValue, aFieldName, aMsg) {
    if(aFieldValue==""||aFieldValue.length==0) return aMsg;
    ymd1=aFieldValue.split("-");
    month1=ymd1[1]-1
    var Date1 = new Date(ymd1[0],month1,ymd1[2]);
    if (Date1.getMonth()+1!=ymd1[1]||Date1.getDate()!=ymd1[2]||Date1.getFullYear()!=ymd1[0]||ymd1[0].length!=4)  {
       //alert("非法日期,请依【YYYY-MM-DD】格式输入");
       aMsg += "非法日期\r\n";
    }
    return aMsg;
}
//设置数据域长度校验时候的长度。
function getValidateLength(fieldName,initialValue){
	if(fieldName=="my:subject")   return 750;
	if(fieldName=="my:send_unit") return 4000;
	return initialValue;
}
function validField(aField,inputValue, aMsg){
	var msg = aMsg;
	if(aField.fieldtype == "varchar") {
		var fieldName="";
		if(aField.fieldName=="my:serial_no") {
			fieldName="内部文号";
		} else if(aField.fieldName=="my:doc_mark") {
			fieldName="公文文号";
		} else if(aField.inputName){
			fieldName = aField.inputName;
		} else {
			fieldName = aField.fieldName;
		}
		if(fieldName.indexOf("my:")!=-1){
			fieldName=v3x.getMessage("V3XLang.edoc_element")+"("+fieldName.substring(3)+")";
		}
		msg = validFieldLength(inputValue.trim(), getValidateLength(aField.fieldName,255), fieldName, msg);
	}

	if(aField.fieldtype == "int" || aField.fieldtype == "decimal") {
		var old = msg;
		msg = IsNum(inputValue.trim(), aField.fieldName, msg);
		if(old == msg){
			//暂不提交
			if(aField.fieldtype == "int"){
				msg = validDigit(inputValue.trim(), 10, aField.digit, aField.fieldName, msg);
			}else if(aField.fieldtype == "decimal"){
				msg = validDigit(inputValue.trim(), 16, 4, aField.fieldName, msg);
			}
		}
	}
	if(aField.fieldtype == "TIMESTAMP" || aField.fieldtype == "date"){
		msg = isDate(inputValue.trim(), aField.fieldName, msg);
	}
	if(document.getElementById(aField.fieldName) && document.getElementById(aField.fieldName).tagName=="TEXTAREA"){
		//TODO 需要做国际化
		var fieldName = "主送单位";
		if(aField.fieldName=="my:copy_to")
			fieldName = "抄送单位";
		else if(aField.fieldName=="my:report_to")
			fieldName = "抄报单位";
		else if(aField.fieldName=="my:send_to2")
			fieldName = "主送单位2";
		else if(aField.fieldName=="my:copy_to2")
			fieldName = "抄送单位2";
		else if(aField.fieldName=="my:report_to2")
			fieldName = "抄报单位2";
		msg = validTextareaLength(inputValue.trim(), 4000, fieldName, msg);
	}
	return msg;
}

//字段输入校验
function validFieldData() {
	var value;
	var msg = "";
	var inputObj;
	var aField;
	for(var i = 0; i <fieldInputListArray.length; i++) {
		aField=fieldInputListArray[i];
		if(aField instanceof Seeyonform_text) {
			inputObj=document.getElementById(aField.fieldName);
			if(inputObj==null || inputObj.disabled==true || inputObj.readOnly==true){continue;}
			msg = validField(aField,inputObj.value,msg);
			if(msg!="") {
				alert(msg);
				inputObj.focus();
				return false;
			}
		}else if(aField.fieldName=="my:send_to" || aField.fieldName=="my:copy_to" || aField.fieldName=="my:report_to"
						|| aField.fieldName=="my:send_to2" || aField.fieldName=="my:copy_to2" || aField.fieldName=="my:report_to2")	{
			inputObj=document.getElementById(aField.fieldName);
			if(inputObj==null || inputObj.disabled==true){continue;}
			msg = validField(aField,inputObj.value,msg);
			if(msg!="") {
				alert(msg);
				return false;
			}
		}
	}
	return true;
}
/***************************字段校验用 end********************************/
