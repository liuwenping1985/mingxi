/////////////////////////////////////////////////
///////////////edit by zf///////////////////////
///////////////rss /////////////////////////////
try {
    getA8Top().endProc();
}
catch(e) {
}



function addCategory() {
	if(!parent.rssTree && !parent.rssTree.tree){
	 	return ;
	}
	var selected= parent.rssTree.tree.getSelected() ;
	
	if(selected) {
		selectId = selected.businessId ;		
	}else {
		parent.rssTree.tree.select();
	}
	
	var url = rssURL + "?method=addCategoryView";
	var returnvalue = v3x.openWindow({
		url : url,
		width : "380",
		height : "200",
		resizable : "no",
		scrollbars : "no"
	});
	if(returnvalue != null ) {
			parent.rssTree.location.reload(true);
	}				
}

function editSomething(){
	
	if(currentFocus == 'category'){
		editCategory();
	}else{
		modifyRssChannel();
	}
	
}
function deleteSomething(){
	if(currentFocus == 'category'){
		deleteCategory();
	}else{
		deleteChannel();
	}
}

function editCategory() {

     var category= parent.theTop.document.all.categoryId
		 if(category!=null){
	 categoryId = parent.theTop.document.all.categoryId.value;
	
	 }else{
	 alert(v3x.getMessage('RssLang.rss_category_alter_not_select'));
	 return;
	 }
	if(categoryId == 0) {
		alert(v3x.getMessage('RssLang.rss_category_alter_not_select'));
		return ;
	}
	var url = rssURL + "?method=editCategoryView&categoryId="+categoryId;
	selectId = categoryId ;
	var returnvalue = v3x.openWindow({
		url : url,
		width : "380",
		height : "200",
		resizable : "no",
		scrollbars : "no"
	});
	
	if(returnvalue == 'true') {
		parent.rssTree.location.reload(true);
	}
}


function deleteCategory() {	
	var categoryId = parent.theTop.document.all.categoryId.value;
	if(categoryId == 0) {
		alert(v3x.getMessage('RssLang.rss_category_alter_select_deleted'));
		return false;
	}
	theForm.target = "toolIframe";
	if(window.confirm(v3x.getMessage('RssLang.rss_category_alter_delete_confirm'))){
		theForm.action = rssURL + "?method=deleteRssCategory&categoryId="+categoryId;
		theForm.submit();
	}
}


function addRssChannel() {
	var categoryId = parent.theTop.document.all.categoryId.value;
	parent.theBottom.location.href = rssURL + "?method=addChannelView&categoryId="+categoryId;
}


function modifyRssChannel() {
	var theId = parent.theTop.document.getElementsByName("id");
	var id = "";
	var number = 0;
	for(var i = 0; i < theId.length; i++) {
		if(theId[i].checked){
			id = theId[i].value;
			number = number + 1;
		}
	}
	
	if(number == 0) {
		alert(v3x.getMessage('RssLang.rss_channel_alter_not_select'));
		return ;
	}
	if(number > 1) {
		alert(v3x.getMessage('RssLang.rss_channel_alter_select_one'));
		return ;
	}
	parent.theBottom.location.href = rssURL + "?method=editChannelView&channelId=" + id + "&flag=edit";
}

function disableButton( button1, button2 ){
	button1.disabled = true ;
	button2.disabled = true ;
	return true ;
}

function createRssChannel() {
	var button1 = document.getElementById("button1") ;
	var button2 = document.getElementById("button2") ;
   if(!disableButton(button1,button2)){
   	 return ;
   }
   if(!checkForm(theForm)){
		button1.disabled = false ;
		button2.disabled = false ;
		return;
	}
	
	var rssName = document.getElementById("name");
	var theURL = document.getElementById("url");
	var categoryId = document.getElementById("categoryId").value ;
	if(rssName.value == rssName.deaultValue){
		alert(v3x.getMessage('RssLang.rss_channel_alter_name_null'));
		button1.disabled = false ;
		button2.disabled = false ;
		return ;
	}
	
	if(theURL.value == theURL.deaultValue){	
		alert(v3x.getMessage('RssLang.rss_channel_alter_address_null'));
		button1.disabled = false ;
		button2.disabled = false ;	
		return ;
	}
	/**
	 * 验证名字是不是重复
	 */
	var requestCaller = new XMLHttpRequestCaller(this, "rssChannelManager", "checkRepName", false);
	requestCaller.addParameter(1,"String" ,rssName.value) ;
	requestCaller.addParameter(2,"long",categoryId) ;
	var flag = requestCaller.serviceRequest() ;	
	if(flag != 'true'){
		alert(v3x.getMessage('RssLang.rss_exception_name'));
		button1.disabled = false ;
		button2.disabled = false ;
		return ;
	}

	/**
	 * 验证地址是不是有效
	 */
    requestCaller = new XMLHttpRequestCaller(this, "rssChannelManager", "checkURL", false);
	requestCaller.addParameter(1,"String" ,theURL.value) ;
	flag = requestCaller.serviceRequest() ;	
	if(flag != 'true'){
		alert(v3x.getMessage('RssLang.rss_exception_address'));
		button1.disabled = false ;
		button2.disabled = false ;	
		return ;	
	}	

	theForm.target = "rssIframe";
	theForm.action = rssURL + "?method=createRssChannel";
	theForm.submit();
}


function updateRssChannel() {
		if(!checkForm(theForm))
		return;
	
	var rssName = document.getElementById("name");
	var theURL = document.getElementById("url");
	if(rssName.value == rssName.deaultValue){
		alert(v3x.getMessage('RssLang.rss_channel_alter_name_null'));
		return ;
	}
	
	if(theURL.value == theURL.deaultValue){
		alert(v3x.getMessage('RssLang.rss_channel_alter_address_null'));
		return ;
	}
	theForm.target = "rssIframe";
	theForm.action = rssURL + "?method=updateRssChannel";
	theForm.submit();
}

//删除频道信息
function deleteChannel(){
	var theId=parent.theTop.document.getElementsByName("id");
	var str="";
	var theNumber=0;
	for(var i=0;i<theId.length;i++){
		if(theId[i].checked){
			str+=theId[i].value;
			str+=",";
			theNumber=theNumber+1;
		}
	}

	
	if(theNumber == 0){
		alert(v3x.getMessage('RssLang.rss_channel_alter_select_deleted'));
		return ;
	}
	str=str.substring(0,str.length-1);
	var requestCaller = new XMLHttpRequestCaller(this, "rssChannelManager", "isSubscribe", false);
	requestCaller.addParameter(1,"String" ,str)
	var flag = requestCaller.serviceRequest() ;
	if(flag == 'true'){
        alert(v3x.getMessage('RssLang.rss_channel_has_subscribed'));
		return ;
	}
	
	theForm.target="toolIframe";
	if(window.confirm(v3x.getMessage('RssLang.rss_channel_alter_delete_confirm'))){
		theForm.action=rssURL + "?method=deleteRssChannel&deleteId="+str;
//		alert(theForm.action)
		theForm.submit();
	}
}

/////////////////////////////////////////////
/////////   添加订阅			////////////////
function addSubscribe(channelId,str){
	theForm.target="channelIframe";
	theForm.action = rssURL + "?method=addSubscribe&channelId="+channelId+"&addOne=true";
	theForm.submit();
	document.getElementById(str).innerHTML="<a href='#' class='link-blue' onclick=\"cancelSubscribe('"+channelId+"','"+str+"');\">["+v3x.getMessage('RssLang.rss_unsubscribe_label')+"]</a>";
	//parent.parent.left.treeFrame.location.reload(true);
}

//取消一个订阅
function cancelSubscribe(channelId,str){
	theForm.target = "channelIframe";
	theForm.action = rssURL+"?method=deleteSubscribe&channelId="+channelId;
	theForm.submit();
	
	document.getElementById(str).innerHTML="<a href='#' class='link-blue' onclick=\"addSubscribe('"+channelId+"','"+str+"');\">["+v3x.getMessage('RssLang.rss_subscribe_label')+"]</a>";
	//parent.parent.left.treeFrame.location.reload(true);
}

//获取一个类别所有的频道
function moreInfo(categoryId,selectedId){
	theForm.action = rssURL+"?method=getMoreCategoryChannel&categoryId="+categoryId+"&selectedId="+selectedId;
	theForm.submit();
}

//订阅选中的项
function subscribeSelected(userId){
	var theId=document.getElementsByName("id");
	var theForm=document.getElementById("theForm");
	var str="";
	var number=0;
	for(var i=0;i<theId.length;i++){
		if(theId[i].checked){
			str+=theId[i].value;
			number=number+1;
			str+=",";
		}
	}
	if(number == 0){
		alert(v3x.getMessage('RssLang.rss_channel_alter_select_subscribe'));
		return ;
	}
	str=str.substring(0,str.length-1);
	theForm.target="rssIframe";
	theForm.action=rssURL+"?method=addSubscribe&addOne=false&channelIds="+str+"&userId="+userId;
	theForm.submit();
}

function changePic(obj){
	obj.className="rss-onmoseover";	
}

function changeOut(obj){
	obj.className="rss-onmoseout";
}


function showOrhidden() {
	var width;
	if(parent.parent.$("#west_region").width() > 0){
		width = 1;
	}else{
		width = 150;
	}
	
	parent.parent.$('body').layout('panel', 'west').panel('resize', {
		width:width
	});
	parent.parent.$('body').layout().resize();
}
/**
 * 展开摘要
 */
function showDescribse(theID){
	     var id = "Div_" + theID ;
	     var hidddenID = "hidden_" + theID ;
	     var showID = "show_" + theID ;
	     var static1 = document.getElementById(id).style.display ;
	     if(static1 == ''){
	 	     document.getElementById(id).style.display='block';
	         document.getElementById(hidddenID).style.display='block';
	         document.getElementById(showID).style.display='none';   
	     	
	     }
	     else if(static1 == 'none'){
	 	     document.getElementById(id).style.display='block';
	         document.getElementById(hidddenID).style.display='block';
	         document.getElementById(showID).style.display='none';   
	     }
	    else {
	         document.getElementById(id).style.display='none';
	         document.getElementById(hidddenID).style.display='none';
	         document.getElementById(showID).style.display='block';  
	     }

}
/**
 * 隐藏摘要
 */
function hiddendeScribse(theID){
   	     var id = "Div_" + theID ;
	     var hidddenID = "hidden_" + theID ;
	     var showID = "show_" + theID ;
	     document.getElementById(id).style.display='none';
	     document.getElementById(hidddenID).style.display='none';
	     document.getElementById(showID).style.display='block';  
}


	