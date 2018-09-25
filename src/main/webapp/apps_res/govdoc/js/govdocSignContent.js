function browserPanduan(wid,heigh){
	var s="";
	if(navigator.userAgent.indexOf("Chrome")>0 || navigator.userAgent.indexOf("Firefox")>0){
		s = "<object id='HWPostil1' type='application/x-itst-activex' align='baseline' border='0'"
			+ "style='LEFT: 0px; WIDTH: "+wid+"%; TOP: 0px; HEIGHT: "+heigh+"%'"
			+ "clsid='{FF1FE7A0-0578-4FEE-A34E-FB21B277D561}' "
			+ "event_NotifyCtrlReady='HWPostil1_NotifyCtrlReady' "
			+ "event_NotifyChangePage='HWPostil1_NotifyChangePage'>"
			+ "</object>";
	
	}else {
		s = "<OBJECT id='HWPostil1' align='middle' style='LEFT: 0px; WIDTH: "+wid+"%; TOP: 0px; HEIGHT: "+heigh+"%'"
			+ "classid=clsid:FF1FE7A0-0578-4FEE-A34E-FB21B277D561 "
		var isvs=window.navigator.platform;
	if(isvs=="Win32"){
		s += "codebase='./common/HWPostil.ocx#version=3,1,2,6'>";
	}else{
		s += "codebase='./common/HWPostil64.ocx#version=3,1,2,6'>";
	}
		s += "</OBJECT>";
	}
	document.write(s);
	
}
function saveWebAip(HWPostil1,_summaryId,url2){
	HWPostil1.HttpInit(); //初始化HTTP引擎。
	HWPostil1.HttpAddPostString("summaryId",_summaryId);
	HWPostil1.HttpAddPostCurrFile("FileBlod");//设置上传当前文件,文件标识为FileBlod。
	var id=HWPostil1.HttpPost(url2+"?summaryId="+_summaryId+"&currentUserId="+_currentUserId+"&currentUserAccount="+currLoginAccount);
	if(id=='0'){
		alert('错误');
		return;
	}
	return id;
}
String.prototype.replaceAll = function(s1,s2){ 
	return this.replace(new RegExp(s1,"gm"),s2); 
}
function setEdocSummaryData(HWPostil1,_iframe){//设置aip里面的数据  根据aip的元素取值
	//HWPostil1.Login("HWSEALDEMO**", 4, 65535, "DEMO", "");
	//obj.Login("", 1, 65535, "","");
	//obj.CurrAction =264;//手写状态
	var objArray = new Array();
	_iframe.$("span[id^=field][id$=_span]").each(function(){
		if(typeof($(this).attr("fieldVal"))!='undefined'){
			var fieldVal = $.parseJSON($(this).attr("fieldVal"));
			if(!fieldVal.value||fieldVal.value.indexOf("\r\n")==-1){
				fieldVal.value = $(this).text();
			}else if(fieldVal.inputType=='edocDocMark'){
				fieldVal.value = $(this).text();
			}
			objArray.push(fieldVal);
			try{
			if(fieldVal.inputType=='edocflowdealoption'){
					var opinions = _iframe.$("#opinion_"+fieldVal.name)[0];
					if(opinions){/*
						var i = 0;
						while(opinions.indexOf("<div")!=-1){
							opinions = opinions.replace(opinions.substring(opinions.indexOf("<div"),opinions.indexOf("\>",opinions.indexOf("<div"))+1),"");
							var changeStr = "";
							if(i!=0){
								changeStr = "needEnter";
							}
							opinions = opinions.replace("</div>",changeStr);
							i++;
						}
						while(opinions.indexOf("<a")!=-1){
							opinions = opinions.replace(opinions.substring(opinions.indexOf("<a"),opinions.indexOf("\>",opinions.indexOf("<a"))+1),"\n");
							opinions = opinions.replace("</a>","");
						}
						opinions = opinions.replace(/\r\n/g,"");
						opinions = opinions.replaceAll("<br>","\n");
						$("#edocSignOpinionModel").html(opinions);
						opinions = $("#edocSignOpinionModel").text();
						opinions = opinions.replaceAll("needEnter","\n");*/
						var html = opinions.innerText;
						var reg =/[\t\r\n]+/g;///[\x20\t\f\r\n]+/g;
			            var arr = html.split(reg);
			            fieldVal.value = arr.join("\r\n");
						//fieldVal.value = opinions.innerHTML;//听说火狐不支持innerText，就用outerText
					}else{
						fieldVal.value="";
					}
			}
			if($(this).hasClass("edit_class")&&fieldVal.inputType!='edocflowdealoption'){
				var value = fieldVal.value;
				$(this).children().each(function(){
					if(this.nodeName !="undefined" && (this.nodeName == "SELECT" || this.nodeName == "select")){
						var index = this.selectedIndex;
						value = this.options[index].text;
						var fieldId = $(this).attr("id");
						var fieldTxt;
						if(fieldId && fieldId!="") {
							var fieldTxt = _iframe.$("#" + fieldId + "_txt");
							if(fieldTxt && fieldTxt.attr("id") && fieldTxt.attr("id")!="") {
								value = fieldTxt.val();
							}
						}
					}
					if(typeof($(this).attr("mappingField"))!="undefined"&&this.nodeName !="undefined" && (this.nodeName == "INPUT" || this.nodeName == "input")){
						value = this.getAttribute("value");
					}
					if(fieldVal.inputType=='member'||fieldVal.inputType=='account'||fieldVal.inputType=='department'||fieldVal.inputType=='post'){
						value = this.getAttribute("title");
					}
					if(typeof(value)=='object'){
						value="";
					}
				});
				fieldVal.value = value;
			}
			}catch(e){}
			if(fieldVal.inputType=='attachment'){
				var attsarr = new Array();
				$(this).find("div[id^='attachmentDiv_']").each(function(){
					attsarr.push($(this).text().replace(/^[\s　]+|[\s　]+$/g,''));
				});
				fieldVal.value=attsarr.join("\r\n");
			}
		}
	});
	var User="";
	while(User=HWPostil1.JSGetNextUser(User)){//循环用户
		var NoteInfo="";
		while(NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo)){//循环节点
				//获取aip节点的id
			var str= new Array();   
			   //split函数分割字符串
			str = NoteInfo.split("."); 
			var idd = str[1];
			idd = idd.trim();
			for(var i = 0;i<objArray.length;i++){
				if(objArray[i].displayName && idd==objArray[i].displayName) {
					HWPostil1.SetValue(idd, "");
					HWPostil1.SetValue(idd, objArray[i].value);//编辑区赋值
				}
			}
		}
	}
}
