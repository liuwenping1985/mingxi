 function go(){
   var pageSize=document.getElementById("pageSize");
   var pagenum=document.getElementById("pageNum");
   if(!numCheck(pagenum.value)||!numCheck(pageSize.value)){
 		alert(getA8Top().v3x.getMessage("V3XLang.index_input_num_error"));
 		return;
 	}

   var currentIntValue=parseInt(currentPage);
   var intValue=parseInt(pagenum.value);
   if(intValue>0&&intValue<=totalPage){
   var kw=document.getElementById("keyword");
   kw.value=keyword;
   var myform=document.getElementById("form1");
   myform.submit();
   }
 }
  
 function numCheck(value) { 
    var isNum=/^[0-9]*$/;
 	if(!isNum.test(value)){ 
 	return false; 
 	} 
 	return true;
 }
 
 String.prototype.trim=function(){   
				return this.replace(/(^(\s|\*)*)|(\s*$)/g, "");    
			} 
			function IsNull(value){    
				if(value.length==0){    
					return true;   
				}
				return false;
			}

function searchAction(sort){
	var keyword=document.getElementById("keyword").value.trim();
	//document.getElementById("keyword").value = keyword;
	var author=document.getElementById("author").value.trim();
	var title=document.getElementById("title").value.trim();
	if(IsNull(keyword)&&IsNull(title)&&IsNull(author)){
		alert(getA8Top().v3x.getMessage("V3XLang.index_input_error"));
		return;
	}
	var myform=document.getElementById("form1");
	var beginDate = myform.SEARCHDATE_BEGIN;
	var endDate = myform.SEARCHDATE_END;
	if(beginDate.value !='' && endDate.value !='' && beginDate.value>endDate.value){
		alert(getA8Top().v3x.getMessage("V3XLang.index_input_endDate_less_beginDate"));
		return;
	}
	var pageNum=document.getElementById("pageNum");
	if(pageNum!=null)pageNum.value=1;
	if(3 == sort){
		if(document.getElementById("viewType")) {
			document.getElementById("viewType").value="table";
		}
	}else{
		if(document.getElementById("viewType")) {
			document.getElementById("viewType").value="";
		}
	    if(document.getElementById("sortid")) {
	    	document.getElementById("sortid").value=sort;
	    }
	}
    myform.submit();
	
}
function goNextPage(){
	var pagenum=document.getElementById("pageNum");
	document.getElementById("preornext").value="next";;
   if(!numCheck(pagenum.value)){
 		alert(getA8Top().v3x.getMessage("V3XLang.index_input_num_error"));
 		return;
 	}
   var intValue=parseInt(pagenum.value);
   var totalNumValue=parseInt(totalPage);
   if(intValue==totalNumValue) {
      return;
   }
   if(intValue>0&&intValue<=totalPage){
   var kw=document.getElementById("keyword");
   kw.value=keyword;
   var myform=document.getElementById("form1");
   myform.submit();
   }
}

function prevPage(){
	var pagenum=document.getElementById("pageNum");
	document.getElementById("preornext").value="pre";;
   if(!numCheck(pagenum.value)){
 		alert(getA8Top().v3x.getMessage("V3XLang.index_input_num_error"));
 		return;
 	}
   var intValue=parseInt(pagenum.value);
   var totalNumValue=parseInt(totalPage);
   if(intValue>totalNumValue) {
      return;
   }
   if(intValue>0&&intValue<=totalPage){
   var kw=document.getElementById("keyword");
   kw.value=keyword;
   var myform=document.getElementById("form1");
   myform.submit();
   }
}
function first(){
	document.getElementById("pageNum").value=1;
	var myform=document.getElementById("form1");
	myform.submit();
}

function last(){
	document.getElementById("pageNum").value=totalPage;
	var myform=document.getElementById("form1");
	myform.submit();
}
//回车执行查询 
function doKeyPressedEvent()
{
   if(event.keyCode==13){
     go();
   }
}
function enterSubmit(obj, type){
	if(v3x.getEvent().keyCode == 13){
		if(type == "pageSize"){
			pagesizeChange();
		}
		else if(type == "intpage"){
			pageChange(obj);
		}
	}
}
function pagesizeChange(){
	go();
}
function pageChange(obj){

		if(!new RegExp("^-?[0-9]*$").test(obj.value)){
			alert(getA8Top().v3x.getMessage("V3XLang.index_input_num_error"));
			return;
		}
	if(obj.value > parseInt(totalPage)){
		document.getElementById("pageNum").value=totalPage;
	}
	go();
}
function fileDownload(fileid,createDate,fileName)
{
	if(fileid.indexOf("zip")!=-1)
	{
		fileid=fileid.split('zip')[1];
		  var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docDownloadCompress",false);
		  requestCaller1.addParameter(1, "long", fileid);
		  var ds=requestCaller1.serviceRequest();
			 if(ds != null){
				 location.href=v3x.baseURL+"/doc.do?method=docDownloadNew&id="+fileid;
			  }else{
				alert("下载异常：原文件不存在");  
			  }
		
	}else{
		  var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "fileIllegal",false);
		  requestCaller1.addParameter(1, "string", fileid);
		  var v=requestCaller1.serviceRequest();
		  if(v != null){
				location.href=v3x.baseURL+ "/fileUpload.do?method=download&viewMode=download&fileId=" + fileid + "&createDate=" + createDate.substring(0, 10) + "&filename=" + encodeURI(fileName)+"&v="+v; 
			}else{
				alert("下载异常");  
			  }
		
	}
	
}
function openInfoMore(apptype,typeId)
{
	if(apptype==10){
		getA8Top().document.getElementById("main").src=v3x.baseURL+"/inquirybasic.do?method=more_recent_or_check&openFrom=index&typeId="+typeId;
	}else if(apptype==7){
		getA8Top().document.getElementById("main").src=v3x.baseURL+"/bulData.do?method=bulMore&homeFlag=true&openFrom=index&typeId="+typeId;
	}else if(apptype==8){
		getA8Top().document.getElementById("main").src=v3x.baseURL+"/newsData.do?method=newsMore&homeFlag=true&openFrom=index&typeId="+typeId;
	}else if(apptype==9){
		getA8Top().document.getElementById("main").src=v3x.baseURL+"/bbs.do?method=listAllArticle&openFrom=index&boardId="+typeId;
	}
}

function showMemberDisable(type)
{
	var author=document.getElementById("author");
	var title=document.getElementById("title");
	var stardate=document.getElementById("SEARCHDATE_BEGIN");
	var enddate=document.getElementById("SEARCHDATE_END");
	var library=document.getElementsByName("library");
	var y=0;
	var member='13'
	 for(var i=0;i<library.length;i++)
     {
			var idCheckBox=library[i];
			if(y==2)
			{
				break;
			}
			if(idCheckBox.checked)
			{
				 y++;
				 member=idCheckBox.value;
			}
	 }
	if(y==1&&member=='13')
	{
		author.disabled=true;
		title.disabled=true;
		stardate.disabled=true;
		enddate.disabled=true;
		author.value ="";
		title.value ="";
		stardate.value ="";
		enddate.value ="";
	}else{
		author.disabled=false;
		title.disabled=false;
		stardate.disabled=false;
		enddate.disabled=false;
	}
}
