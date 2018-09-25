var newsDataURL = "newsData.do";
var newsManagerName = "ajaxNewsDataManager";
var newsUrl="";

function focusNews(baseUrl, cancelFlag){
	var ids=document.getElementsByName('id');
	var id='';
	var noNeedOper = true;
	var count = 0;
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=id+idCheckBox.value+',';
			if(cancelFlag){
				
				noNeedOper = (noNeedOper && (idCheckBox.focusNews=="false"));
				
			}else{
				
				noNeedOper = (noNeedOper && (idCheckBox.focusNews=="true") );
				
			}
		}
	}
	if(id==''){
		if(cancelFlag)
			alert(v3x.getMessage("NEWSLang.select_focus_record_cancel"));
		else
			alert(v3x.getMessage("NEWSLang.select_focus_record"));
		return;
	}else if(noNeedOper){
		
		if(cancelFlag)
			alert(v3x.getMessage("NEWSLang.bul_focus_cancel_no_valid_alert"));
		else
			alert(v3x.getMessage("NEWSLang.bul_focus_no_valid_alert"));
		return;
	}
	parent.window.location.href=baseUrl+'&id='+id;
}

function publishNews(){
	var ids=getSelectIds();
	if(ids==''){
		alert(v3x.getMessage("bulletin.please_select_record"));
		return;
	}
	var custom = document.getElementById("_custom").value;
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
				var state2 = getStateOfData(idCheckBox.value, newsManagerName);
				if(state2 == '20')
					continue;
				if(state2 == '40'){
					alert(v3x.getMessage('bulletin.bul_not_pass'));
				}else if(state2 == '10' || state2 == '0'){
					alert(v3x.getMessage('bulletin.bul_not_audit'));
				}else if(state2 == '30')
					alert(v3x.getMessage('NEWSLang.news_already_poss'));
				return false;
			} else {
				var state3 = getStateOfData(idCheckBox.value, newsManagerName);
				var state = document.getElementById(idCheckBox.value+"_state").value;
				if(state3 == '30' && state == state3) {
					count += 1;
				}
				if(count==selectedCount) {
					alert(v3x.getMessage('NEWSLang.news_already_poss'));
					return false;
				}
			}
		}
	}
	if(count > 0){
		alert(v3x.getMessage('NEWSLang.news_already_poss'));
	}
	
	parent.window.location.href='newsData.do?method=publishOper'+'&id='+ids+'&form_oper=publish'+'&custom='+custom+'&spaceId='+spaceId;
}

/**
 * 新闻首页－板块管理
 */
function adminTypeEvent(typeid, spaceType){
	var flag = validTypeExist(typeid, 'ajaxNewsDataManager');
	var spaceId = document.getElementById("spaceId").value;
	if(flag == 'false') {
		alert(v3x.getMessage("bulletin.type_deleted"));
		window.location.href = newsDataURL + "?method=index&spaceType=" + spaceType + "&spaceId=" + spaceId;
	} else {
		location.href = newsDataURL + "?method=listBoardIndex&spaceType=" + spaceType + "&newsTypeId="+typeid + "&spaceId="+spaceId;
	}		
}

/**
 * 新闻首页－更多
 */
function viewTypeList(typeId, baseUrl){
	document.location.href = baseUrl + "type=" + typeId;
}

/**
 * 打印
 */
function printResult(dataFormat){
   if(dataFormat != 'HTML' && dataFormat != 'FORM' && dataFormat != 'Pdf'){
		window.officeEditorFrame.officePrint();
		return;
   } else if (dataFormat == 'Pdf') {
       window.officeEditorFrame.pdfPrint();
       return;
   }
   var mergeButtons  = document.getElementsByName("mergeButton");    
   for(var s= 0;s<mergeButtons.length;s++){
      var mergeButton = mergeButtons[s]; 
      mergeButton.style.display="none";
   }
   var p = document.getElementById("printThis");
   var mm = "<div style='width: 100%;height:auto !important;min-height:500px;'>"+p.innerHTML+"</div>";
   var list1 = new PrintFragment("",mm);
   var tlist = new ArrayList();
   tlist.add(list1);
   var cssList=new ArrayList();
   //OA-78317新闻查看页面的文字字体和打印页面不一致 恢复引用
   cssList.add(v3x.baseURL + "/common/RTE/editor/css/fck_editorarea5Show.css");
   cssList.add(v3x.baseURL + "/apps_res/news/css/news.css");
   cssList.add(v3x.baseURL + "/apps_res/bulletin/css/default.css");
   printList(tlist,cssList);       
   for(var s= 0;s<mergeButtons.length;s++){
       var mergeButton = mergeButtons[s];
       mergeButton.style.display="";
   }
}

/**
 * 自定义空间新闻更多页面－发布新闻
 */
function newsPublish(spaceId) {
	window.location.href=newsDataURL + "?method=publishListIndex&newsTypeId="+spaceId+"&spaceType=3&custom=true"; 
}

/**
 * 自定义空间新闻更多页面－新闻管理
 */
function newsManage(spaceId, spaceType) {
	window.location.href=newsDataURL + "?method=listBoardIndex&spaceType=" + spaceType + "&newsTypeId="+spaceId+"&custom=true";
}

function getImageId(){
	var ids=document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++){
	var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=idCheckBox.imageId;
			break;
		}
	}
	return id;
}

/**
 * 查看栏目图片
 */
function look(){
	v3x.openWindow({
		url : genericControllerURL + "?ViewPage=news/audit/lookImage",
		workSpace : true,
		scrollbars : false,
		resizable : "yes",
		dialogType : "open",
		width : 140,
		height : 100
	});
}
/**
 * 内外网-新闻推送
 */
//推动时钟
var pushTime = 0;
var pushRandom = 0;

function pushOutside(){
  var checkedIds = getSelectIds();
  pushRandom = Math.random()*10000; 
  pushTime = 30;
  getA8Top().startProc();
  if (checkedIds == "") {
    alert(v3x.getMessage("websiteIntegrate.websiteIntegrate_grid_nochoicerow_js"));
  } else {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager",
        "outsidePush", true);
    requestCaller.addParameter(1, "String", checkedIds);
    requestCaller.addParameter(2, "String", pushRandom);
    this.invoke = function(rs) {
    }
    requestCaller.serviceRequest();
    pushOutsideClock();
  }
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

function checkPushOutside() {
  var checkedIds = getSelectIds();
  if (checkedIds == "") {
    alert(v3x.getMessage("websiteIntegrate.websiteIntegrate_grid_nochoicerow_js"));
  } else {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager",
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
  clock = setInterval(function(){
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager",
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

