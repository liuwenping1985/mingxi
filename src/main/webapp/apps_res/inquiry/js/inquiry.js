function checkSubject(obj, isShowBlack) {
    var def = obj.getAttribute("deaultValue");
   
    if (isShowBlack) {    //显示空白
        if (obj.value == def) {
            obj.value = "";
        }
    }
    else {
        if (obj.value == "") {
            obj.value = def;
        }
    }

}
var selectIndex;
var s = new Array();
//问题： key-排序号、value-Question对象
var questions = new Properties();
function objQuestion(index){
	if(index != -1){
		selectIndex= index;
		var vquestion = questions.get(index);
		mainForm.otherItem.value = "1";
		mainForm.discuss.value = "1";	
		//alert("otherItem=====" + mainForm.otherItem.value);
		//alert( "discuss===" + mainForm.discuss.value);
		if(vquestion != null){
			mainForm.title.value=vquestion.title;
			
			if(typeof vquestion.desc == "string"){
				mainForm.desc.value=vquestion.desc;
			} else {
				mainForm.desc.value="";
			}
				
			if(vquestion.singleOrMany=="1"){   //多选
				document.getElementsByName("singleOrMany")[0].checked = false;
				document.getElementsByName("singleOrMany")[1].checked = true;
				document.getElementsByName("singleOrMany")[2].checked = false;
				mainForm.hsom.value=1;
				selectMax(1);
				mainForm.smaxselectnum.value=vquestion.maxSelect;
			}else if(vquestion.singleOrMany=="0"){   //单选
				document.getElementsByName("singleOrMany")[0].checked = true;
				document.getElementsByName("singleOrMany")[1].checked = false;
				document.getElementsByName("singleOrMany")[2].checked = false;
				mainForm.hsom.value=0;
				selectMax(2);
				mainForm.smaxselectnum.value=0;
			}else if(vquestion.singleOrMany=="2"){   //问答式
				document.getElementsByName("singleOrMany")[0].checked = false;
				document.getElementsByName("singleOrMany")[1].checked = false;
				document.getElementsByName("singleOrMany")[2].checked = true;
				mainForm.hsom.value=2;
				selectMax(0);
				mainForm.smaxselectnum.value=0;
			}
	
			if(vquestion.otherItem == "0"){
				mainForm.otherItem.checked = true;
				mainForm.otherItem.value = "0";			
			}
			else if(vquestion.otherItem == "1"){
				mainForm.otherItem.checked = false;
			}
			
			if(vquestion.discuss == "0"){
				mainForm.discuss.checked = true;
				mainForm.discuss.value = "0";	
			} else if(vquestion.discuss == "1"){
				mainForm.discuss.checked = false;
			}
			
			if(vquestion.items != null){
				//alert(vquestion.items.size() + "=============")
				arraddSubject(vquestion.items);
			}
		}else{
			mainForm.title.value=mainForm.projectBox.options[mainForm.projectBox.selectedIndex].text;
			mainForm.desc.value="";
			mainForm.maxselectnum.value = "0";
			mainForm.otherItem.checked = false;
			mainForm.discuss.checked = false;
			
			if(typeof mainForm.itemarr == "object"){
				var len = mainForm.itemarr.length;
				if(!v3x.isMSIE){
					var theParentNode = mainForm.itemarr[0].parentNode.parentNode.parentNode;
					var theChild=theParentNode.children;
						for(var j = 0; j < len;j++)
							theParentNode.removeChild(theChild[0]);
				}else{
					for(var j = 0; j < len;j++){
						mainForm.itemarr[0].parentNode.parentNode.removeNode(true);
					}
				}	
			}
			
			oneQuestion(index);
		}
		document.getElementById("addProjectBox").style.display="";
		document.getElementById("memo").style.display="";
		
	}
}
//交换对象
function moveObj(index,flag){
	//下移
	if(flag == 1){
		var o = questions.get(index - 1);
		var n = questions.get(index);
		questions.put(index,o);	
		questions.put(index - 1,n);	
	}
	//上移
	if(flag == 0){
		var o = questions.get(index + 1);
		var n = questions.get(index);
		questions.put(index,o);	
		questions.put(index + 1,n);	
	}
}

function is_ht_number(o){
		if(isNaN(o.value)){
			alert(v3x.getMessage("InquiryLang.inquiry_enter_number_alert"));
			o.value='0';
			return false;
		}
		var reg1 =  /^\d+$/;
		if(!reg1.test(o.value)){
		  alert(v3x.getMessage("InquiryLang.inquiry_enter_number_alert"));
      o.value='0';
      return false;
		}
}
//初始化参数
function oneQuestion(){
	var index = selectIndex;
	var title = mainForm.title.value;
	var desc = mainForm.desc.value;
	var singleOrMany = mainForm.hsom.value;
	var otherItem = mainForm.otherItem.value;
	var discuss = mainForm.discuss.value;
	var maxSelect = mainForm.smaxselectnum.value;
	if(title=="" || title.length==0){
		alert(v3x.getMessage("InquiryLang.inquiry_question_null_alert"));
		mainForm.title.value = mainForm.projectBox.options[index].text;
		return;
	}
	var itemarray = mainForm.itemarr;
	if(questions.get(index) != null) {
		//Chrome 下itemarray是数据的话也有value
		if(itemarray != null && typeof itemarray.value == "string" && itemarray.length <=1 ) {
			questions.get(index).items.clear();
			if(singleOrMany!='2')
				questions.get(index).items.add(itemarray.value);
		} else if(itemarray != null && itemarray.length>=1){
			questions.get(index).items.clear();
			for(var il = 0 ; il < itemarray.length ; il++){
				questions.get(index).items.add(itemarray[il].value);	
			}	
		}else if(itemarray != null){
			questions.get(index).items.clear();
			questions.get(index).items.add(itemarray.value);
		}

		var qu = new Question(title, desc, singleOrMany, otherItem, discuss, maxSelect, questions.get(index).items);
	} else {		
		var qu = new Question(title, desc, singleOrMany, otherItem, discuss, maxSelect);
	}
	questions.put(index,qu);	
	/*mainForm.projectBox.options[mainForm.projectBox.options.selectedIndex].text = title;
	mainForm.projectBox.options[mainForm.projectBox.options.selectedIndex].title = title;*/
}
/**
 * 问题
 */
function Question(title, desc, singleOrMany, otherItem, discuss, maxSelect, items){
	this.title = title;
	this.desc = desc;
	this.singleOrMany = singleOrMany;
	this.otherItem = otherItem;
	this.discuss = discuss;
	this.maxSelect = maxSelect;
	this.items = items || new ArrayList();
}

Question.prototype.toInput = function(sort){
	var str = "";
	
	var inputName = "question" + sort;
	var hiddenquestion = questions.get(sort);
	
	if(typeof hiddenquestion.desc != "string"){
		hiddenquestion.desc = "";
	}
	if(typeof hiddenquestion.singleOrMany != "string"){
		hiddenquestion.singleOrMany = 1;
	}
	if(typeof hiddenquestion.otherItem != "string"){
		hiddenquestion.otherItem = 1;
	}
	if(typeof hiddenquestion.otherItem != "string"){
		hiddenquestion.discuss = 1;
	}
	if(typeof hiddenquestion.maxSelect != "string"){
		hiddenquestion.maxSelect = 0;
	}
	//alert(hiddenquestion.title + "\n" + hiddenquestion.desc + "\n" + hiddenquestion.singleOrMany + "\n" + hiddenquestion.otherItem + "\n" + hiddenquestion.discuss + "\n" + hiddenquestion.maxSelect + "\n" + hiddenquestion.items.size());


	str += "\n<input type='hidden' name='" + inputName + "Title' value=\"" + hiddenquestion.title.escapeHTML() + "\">";
	str += "\n<input type='hidden' name='" + inputName + "Desc' value=\"" + escapeStringToHTMLWithout(hiddenquestion.desc) + "\">";
	str += "\n<input type='hidden' name='" + inputName + "SingleOrMany' value=\"" + hiddenquestion.singleOrMany + "\">";
	str += "\n<input type='hidden' name='" + inputName + "OtherItem' value=\"" + hiddenquestion.otherItem.escapeHTML() + "\">";
	str += "\n<input type='hidden' name='" + inputName + "Discuss' value=\"" + hiddenquestion.discuss.escapeHTML() + "\">";
	str += "\n<input type='hidden' name='" + inputName + "MaxSelect' value=\"" + hiddenquestion.maxSelect + "\">\n";
	
	if(hiddenquestion.items == null){
		alert(v3x.getMessage("InquiryLang.inquiry_question_is_null_alert"));
		return false;
	}
	
	for(var m = 0; m < hiddenquestion.items.size(); m++) {		
		str += "<input type='hidden' name='" + inputName + "Item' value=\"" + hiddenquestion.items.get(m).escapeHTML() + "\">";
	}
	//str += "<input type='hidden' name='" + inputName + "Item' value=\"" + hiddenquestion.items + "\">";

	return str;	
}
function questions2Input(){
	if(questions == null || questions.isEmpty()){
		alert(v3x.getMessage("InquiryLang.inquiry_no_question_alert"));
		return false;
	}
	
	var html = "";
	var keys = questions.keys();
	for(var i = 0; i < keys.size(); i++) {
		var sort = keys.get(i);//key=? value=?
		html += "\n<input type='hidden' name='questionSort' value='" + sort + "'>\n";
		var question = questions.get(sort);

		if(question == null){
			return false;
		}
		html += question.toInput(sort);
	}
	document.getElementById("tableForm").innerHTML=html;
	disableBtn();
	saveAttachment();
	cloneAllAttachments();
	disableButton("save");
	disableButton("send");
	disableButton("saveAsTemp");
	mainForm.submit();
}


function setPeopleFields(elements)
{
	if(!elements){
		return;
	}
	document.getElementById("peopleValue").value=getNamesString(elements);
	document.getElementById("peopleId").value=getIdsString(elements,false);
	//alert(document.getElementById("peopleId").value);
	
}
function setPeopleFieldsSecond(elements)
{
	if(!elements){
		return;
	}
	document.getElementById("peopleValueSecond").value=getNamesString(elements);
	document.getElementById("peopleIdSecond").value=getIdsString(elements,false);

}
function selectPerson(obj){
   if(obj==1){
         document.getElementById("selectpersonTag").style.display="block";
         if(!document.getElementById("peopleIdSecond").value){
              //document.getElementById("peopleValueSecond").click();
         }
   }
   if(obj==2){
	     document.getElementById("selectpersonTag").style.display="none";
	     document.getElementById("peopleIdSecond").value="";
	     document.getElementById("peopleValueSecond").value="";
   }
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
 * 页面右上角的查询查询
 */
function inqDoSearch(){
	var url = "/seeyon/inquiry.do" ;
	//alert("url") ;
	if(!checkForm(searchForm))
		return ;
	var fvalue = searchForm.flag.value ;
	var spaceType = searchForm.spaceType.value ;
	//spaceType = docment.getElementById("spaceType").value;
	var method = "" ;
	if(fvalue == "typeName"){
		//按模块名称查询
		method = "inqQueryByTypeName&typename="+encodeURIComponent(searchForm.typename.value) ;
	}else if(fvalue == "totals"){
		//按数量查询
		var totalsMatch = searchForm.totalsMatch.value ; //判断比较的方式 equal为等于 more为大于 less为小于
		if(totalsMatch == null){
			alert(v3x.getMessage("DocLang.doc_search_select_condition_alert"));
			return ;	
		}
		method = "inqQueryByTotals&num="+encodeURIComponent(searchForm.totalsMax.value)+"&match="+totalsMatch;
	}else if(fvalue == "managerUsers" ){
		//按管理员查询
		method = "inqQueryByManagerUsers&managerUsersName="+encodeURIComponent(searchForm.managerUsersName.value) ; 
	}else if(fvalue == "auditFlag"){
		//按是否需要审查查询
		var flag = searchForm.auditFlag.value ;
		method = "inqQueryByAuditFlag&auditFlag="+flag ;
	}else if(fvalue == "auditUser"){
		//按审查员查询
		var auditUserName = searchForm.username.value ;
		method = "inqQueryByAuditUserName&auditUserName="+encodeURIComponent(auditUserName) ;
	}else{
		alert(v3x.getMessage("DocLang.doc_search_select_condition_alert"));
		return ;
	}
	
	var docUrl = url + "?method="+method +"&queryFlag=true&group="+spaceType ;
	
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

function refreshWhenInvalid(key,from) {
	if(key && key=='pigeonhole')
		alert(v3x.getMessage("InquiryLang.inquiry_not_found"));
	if(window.opener) {
		window.opener.getA8Top().reFlesh();
		window.close();
	} else {
		if(window.dialogArguments) {
			window.dialogArguments.callback(window.dialogArguments.sectionId);
		} else {
			window.parent.location.reload();
		}
	} 
}
function showOrHideAheadSet(className) {
	if(className=='show') {
		document.getElementById("allowAdminViewResultLabel").className = "";
	} else {
		document.getElementById("allowAdminViewResultLabel").className = "hidden";
	}
}

var basicURL = "inquirybasic.do";

/**
 * 调查首页－发起调查
 */
function inquiryCategoryList(id, group){
     var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "getInquirytypeById", false);
	 requestCaller.addParameter(1, "Long", id);
	 var ds = requestCaller.serviceRequest();
	 if(ds=='false'){
	 	alert(v3x.getMessage("InquiryLang.inquiry_has_delete_by_admin"));
	 	window.location.reload(true);
	 	return;
	 }
	 var spaceType = document.getElementById("spaceType").value;
	 var spaceId = document.getElementById("spaceId").value;
	 var acturl = basicURL + "?method=puliscIndex&surveytypeid=" + id + "&group=" + group + "&spaceType=" + spaceType + "&spaceId=" + spaceId;
	 document.location.href = acturl;
}

/**
 * 自定义空间调查更多页面－发起调查
 */
function inquiryPublish(spaceId) {
	window.location.href=basicURL + "?method=puliscIndex&surveytypeid="+spaceId+"&group=&custom=true"; 
}

/**
 * 自定义空间调查更多页面－调查管理
 */
function inquiryManage(spaceId) {
	window.location.href=basicURL + "?method=survey_index&surveytypeid="+spaceId+"&group=&mid=mid&custom=true"; 
}

/*查看调查*/

//有其他选项时当点击其他选项前的radio才让其可用
function enabledOtherItems(otherItemSort){
	var otherItem = document.getElementById(otherItemSort+"content");
	otherItem.disabled = false;
}

//点击其他radio时将其他选项内容清空并置为不可用
function clearOtherItems(otherItemSort){
	var otherItem = document.getElementById(otherItemSort+"content");
	otherItem.value = "";
	otherItem.disabled = true;
}

//结束调查
function closeInquiry(bid, tid){
      if(confirm(v3x.getMessage("InquiryLang.inquiry_stop_alert"))){
          mainForm.action = basicURL + "?method=basic_end&bid=" + bid + "&surveytypeid=" + tid;
          mainForm.target = 'closeThis';
          mainForm.submit();
      }
}
//结束调查
function afterCloseInquiry(){
          var op = parent.opener;
          if(op){
          	  op.getA8Top().reFlesh();
          }
          parent.window.close();
          try{
              if(parent.window.dialogArguments){
                 parent.window.dialogArguments.callback();
              } else {
              	 window.location.reload();
              }
            }catch(e){
            } 
      
}
function escapeStringToHTMLWithout(str){
	if(!str){
		return "";
	}
	
	str = str.replace(/&/g, "&amp;");
	str = str.replace(/</g, "&lt;");
	str = str.replace(/>/g, "&gt;");
	str = str.replace(/\r/g, ""); 
	str = str.replace(/\'/g, "&#039;");
	str = str.replace(/"/g, "&#034;");
	
	return str;
}
function disableBtn(){
	var tempClass=document.getElementById("saveAsTemp").className;
	var tempButton = document.getElementById("saveAsTemp");
	tempButton.className = tempClass +" common_button_disable";
	tempButton.onclick=null;
	tempButton.onmouseout=null;
	tempButton.onmouseover=null;
}
function enableBtn(){
	var tempButton = document.getElementById("saveAsTemp");
	tempButton.className = "webfx-menu--button";
	tempButton.getElementsByTagName("div")[0].className="webfx-menu--button-content";
	tempButton.onclick = function(){viewPage(3);};
	tempButton.onmouseout= function (){ this.className='webfx-menu--button';this.getElementsByTagName("div")[0].className="webfx-menu--button-content";};
	tempButton.onmouseover= function (){this.className='webfx-menu--button-sel';this.getElementsByTagName("div")[0].className='webfx-menu--button-content-sel';};
}