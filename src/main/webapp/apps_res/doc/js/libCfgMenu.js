var i = 0;

var contextPath = "";

function RightMenu(_contextPath)
{
	contextPath = _contextPath || "";
	this.AddExtendMenu = AddExtendMenu;
	this.AddItem = AddItem;
	this.GetMenu = GetMenu;
	this.HideAll = HideAll;
	this.I_OnMouseOver = I_OnMouseOver;
	this.I_OnMouseOut = I_OnMouseOut;
	this.I_OnMouseUp = I_OnMouseUp;
	this.P_OnMouseOver = P_OnMouseOver;
	this.P_OnMouseOut = P_OnMouseOut;

	A_rbpm = new Array();
	HTMLstr  = "";
	HTMLstr += "<!-- RightButton PopMenu -->\n";
	HTMLstr += "\n";
	HTMLstr += "<!-- PopMenu Starts -->\n";
	HTMLstr += "<div id='E_rbpm' class='rm_div' style='width:130px'>\n";
	// rbpm = right button pop menu
	HTMLstr += "<table width='110' border='0' cellspacing='0' id='docMenuTable' ";
	HTMLstr += "style='background-image: url("+contextPath+"/common/skin/default/images/xmenu/toolbar_items_bg.gif);background-repeat: repeat-y;'";
	HTMLstr += ">\n";
	HTMLstr += "<!-- Insert A Extend Menu or Item On Here For E_rbpm -->\n";
	HTMLstr += "</table>\n";
	HTMLstr += "</div>\n";
	HTMLstr += "<!-- Insert A Extend_Menu Area on Here For E_rbpm -->";
	HTMLstr += "\n";
	HTMLstr += "<!-- PopMenu Ends -->\n";
}

/**
 * 增加子菜单项。
 */
function AddExtendMenu(id, name, icon, parent) {
	var TempStr = "";
	if(HTMLstr.indexOf("<!-- Extend Menu Area : E_" + id + " -->") != -1)
	{
		alert("E_" + id + "already exist!");
		return;
	}
	eval("A_" + parent + ".length++");
	eval("A_" + parent + "[A_" + parent + ".length-1] = id");  // 将此项注册到父菜单项的ID数组中去
	TempStr += "<!-- Extend Menu Area : E_" + id + " -->\n";
	TempStr += "<div id='E_" + id + "' class='rm_div'>\n";
	TempStr += "<table width='100%' border='0' cellspacing='0' ";
	TempStr += "style='background-image: url("+contextPath+"/common/skin/default/images/xmenu/toolbar_items_bg.gif);background-repeat: repeat-y;'";
	TempStr += ">\n";
	TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + id + " -->";
	TempStr += "</table>\n";
	TempStr += "</div>\n";
	TempStr += "<!-- Insert A Extend_Menu Area on Here For E_" + id + " -->";
	TempStr += "<!-- Insert A Extend_Menu Area on Here For E_" + parent + " -->";
	HTMLstr = HTMLstr.replace("<!-- Insert A Extend_Menu Area on Here For E_" + parent + " -->", TempStr);

	eval("A_" + id + " = new Array()");
	TempStr  = "";
	TempStr += "<!-- Extend Item : P_" + id + " -->\n";

	var style1 = "padding:2px 4px 0px " + (icon ? "0" : "28") + "px;";
	var styleOver = style1 + "background-image: url("+contextPath+"/common/skin/default/images/xmenu/toolbar_select_bg.gif);background-position: center center;background-repeat: repeat-x;";

	TempStr += "<tr id='P_" + id + "' style='cursor: pointer;FONT-SIZE: 12px; height: 22px;' "		
		+ "onmouseup='window.v3x.getEvent().cancelBubble=true;' "
		+ "onclick='window.v3x.getEvent().cancelBubble=true;' "
	
	TempStr	+= "><td nowrap='nowrap' style=\"" + style1 + "\" " 
		+ "onmouseover='this.style.cssText=\"" + styleOver + "\";P_OnMouseOver(\"" + id + "\",\"" + parent + "\");' "
		+ "onmouseout='this.style.cssText=\"" + style1 + "\";P_OnMouseOut(\"" + id + "\",\"" + parent + "\");' " + ">"
		+ "<div style='background-image: url(/seeyon/common/skin/default/images/xmenu/arrow.right.png);background-position: right center;background-repeat: no-repeat;'>"
		+ (icon ? "<img src='" + icon + "' border='0' height=16 style='margin-right: 6px;margin-left:6px;vertical-align: middle;'>" : "")
		+ name
		+ "</div>"
		+ "</td></tr>\n";

	TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->";
	HTMLstr = HTMLstr.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", TempStr);
}

/**
 * 增加菜单项。
 */
function AddItem(id, name, icon, parent, location, flag) {
	var TempStr = "";

	var ItemStr = "<!-- ITEM : I_" + id + i +" -->";
	if(id == "separator")
	{
	  TempStr += ItemStr + "\n";
	  TempStr += "<tr id='I_" + id + i + "' style='height:5px;' onclick='window.v3x.getEvent().cancelBubble=true;' onmouseup='window.v3x.getEvent().cancelBubble=true;'><td><hr></td></tr>";
	  TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->";
	  HTMLstr = HTMLstr.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", TempStr);
	  i++;
	  return;
	}
	if(HTMLstr.indexOf(ItemStr) != -1)
	{
	  alert("I_" + id + "already exist!");
	  return;
	}

	var style1 = "padding:2px 4px 0px " + (icon ? "0" : "28") + "px;";
	var styleOver = style1 + "background-image: url("+contextPath+"/common/skin/default/images/xmenu/toolbar_select_bg.gif);background-position: center center;background-repeat: repeat-x;";

	TempStr += ItemStr + "\n";
	TempStr += "<tr id='I_" + id + "' style='cursor: pointer;FONT-SIZE: 12px; height: 22px;' "
		+ "onclick='window.v3x.getEvent().cancelBubble=true;' "
	TempStr += "onmouseover='I_OnMouseOver(\"" + id + "\",\"" + parent + "\")' ";
	TempStr += "onmouseout='I_OnMouseOut(\"" + id + "\")' ";
	if(location == null)
		TempStr += "onmouseup='I_OnMouseUp(\"" + id + "\",\"" + parent + "\",null)' ";
	else
		TempStr += "onmouseup='I_OnMouseUp(\"" + id + "\",\"" + parent + "\",\"" + location + "\",\"" + flag + "\")' ";
	
	TempStr	+= "><td nowrap='nowrap' style=\"" + style1 + "\" " 
		+ "onmouseover='this.style.cssText=\"" + styleOver + "\"' "
		+ "onmouseout='this.style.cssText=\"" + style1 + "\"' " + ">"
		+ (icon ? "<img src='" + icon + "' border='0' height=16 style='margin-right: 6px;margin-left:6px;vertical-align: middle;'>" : "")
		+ name 		
		+ "</td></tr>\n"
	
	TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->";

	HTMLstr = HTMLstr.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", TempStr);
}


function GetMenu()
{  
	return HTMLstr;
}

function I_OnMouseOver(id, parent)
{
	var Item;
	if(parent != "rbpm")
	{
		var ParentItem;
		ParentItem = eval("P_" + parent);
	}
	//Item = eval("I_" + id);
	Item = document.getElementById("I_" + id);
	HideAll(parent, 1);
}


function I_OnMouseOut(id)
{
	var Item;
	//Item = eval("I_" + id);
	Item = document.getElementById("I_" + id);
}


function I_OnMouseUp(id,parent,location,flag)
{	  
	var exist;	
	var docResourceId = data.docResourceId;
	exist = docExist(docResourceId, true);	
	if(exist == 'false'){
	   window.location.reload(true) ;
		return; 		
	}
			
	var name = "I_" + id;
	if(document.getElementById(name).isDisabled)
		return;
	
	var ParentMenu;
	window.v3x.getEvent().cancelBubble=true;
	OnClick();
	//ParentMenu = eval("E_"+parent);
	ParentMenu = document.getElementById("E_"+parent);
	ParentMenu.display="none";


	if(flag == "acl") {	
		libGrant();
	} 
	else if(flag == "log") {
		libLog();
	} 
	else if(flag == "alert") {	
		alertview(data.docResourceId, true);
	} 
	else if(flag == "checkin") {
		libCheckoutAdmin();	
	} 
	else if(flag == "column") {	
		libSetColumn();
	} 
	else if(flag == "property") {
		libProp();
	}else if(flag == "columnDefault"){
		setColumnDefault();
	}
	else if(flag == "searchConditionDefault") {
		setDocSearchConfigDefault(data.docLibId, 'Menu');
	}
	else if(flag == "searchCondition") {
		setDocSearchConfig(data.docLibId, 'Menu');
	}
}

// 設置文檔庫顯示欄目為默認
function setColumnDefault(){
	top.startProc();
	
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocLibManager",
		 "setListColumnToDefault", false);
	requestCaller.addParameter(1, "Long", data.docLibId);
			
	var columnNames = requestCaller.serviceRequest();

	top.endProc();
	alert(v3x.getMessage("DocLang.doc_lib_column_default_success"));
	
	window.location.reload(true);
}

function P_OnMouseOver(id,parent)
{
	var Item;
	var Extend;
	var Parent;
	if(parent != "rbpm")
	{
	  var ParentItem;
	  ParentItem = eval("P_" + parent);
	  ParentItem.className = "over";
	}
	HideAll(parent,1);
//	Item = eval("P_" + id);
//	Extend = eval("E_" + id);
//	Parent = eval("E_" + parent);
	Item = document.getElementById("P_" + id);
	Extend = document.getElementById("E_" + id);
	Parent = document.getElementById("E_" + parent);
	Item.className = "over";
	Extend.style.display = "block";
	Extend.style.posLeft = document.body.scrollLeft + Parent.offsetLeft + Parent.offsetWidth - 4;
	if(Extend.style.posLeft + Extend.offsetWidth > document.body.scrollLeft + document.body.clientWidth)
		Extend.style.posLeft = Extend.style.posLeft - Parent.offsetWidth - Extend.offsetWidth + 8;
	if(Extend.style.posLeft < 0) 
		Extend.style.posLeft = document.body.scrollLeft + Parent.offsetLeft + Parent.offsetWidth;
	Extend.style.posTop = Parent.offsetTop + Item.offsetTop;
	if(Extend.style.posTop + Extend.offsetHeight > document.body.scrollTop + document.body.clientHeight)
		Extend.style.posTop = document.body.scrollTop + document.body.clientHeight - Extend.offsetHeight;
	if(Extend.style.posTop < 0) 
		Extend.style.posTop = 0;
}

function P_OnMouseOut(id,parent)
{
}

function HideAll(id,flag)
{
	var Area;
	var Temp;
	var i;
	if(!flag)
	{
		//Temp = eval("E_" + id);
		Temp = document.getElementById("E_" + id);
		Temp.style.display = "none";
	}
	Area = eval("A_" + id);
	if(Area.length)
	{
		for(i = 0; i < Area.length; i++)
		{
			HideAll(Area[i], 0);
			//Temp = eval("E_" + Area[i]);
			Temp = document.getElementById("E_" + Area[i]);
			Temp.style.display = "none";
			Temp = eval("P_" + Area[i]);
			Temp.className = "out";
		}
	}
}


 document.onmouseup=OnClick;
  function OnMouseUp(docResourceId, ownerId, userId, docLibId, docLibType, columnEditable, allAcl, editAcl, addAcl, readOnlyAcl, browseAcl, listAcl, isOwner, name, noShare, isDefault, searchConditionEditable, isSearchConditionDefault,vForProperties,vForShare)
  {
  		libCfgMenuDisable("I_acl");
		libCfgMenuDisable("I_log");
		libCfgMenuDisable("I_alert");
		libCfgMenuDisable("I_checkin");
		libCfgMenuDisable("I_column");
		libCfgMenuDisable("I_columnDefault");
		libCfgMenuDisable("I_searchCondition");
		libCfgMenuDisable("I_searchConditionDefault");
		libCfgMenuDisable("I_property");
  	
// 利用 function data() 的属性保存数据
	data.docResourceId = docResourceId;
	data.ownerId = ownerId;
	data.userId = userId;
	data.docLibId = docLibId;
	data.docLibType = docLibType;
	data.columnEditable = columnEditable;
	data.allAcl = allAcl;
	data.editAcl = editAcl;
	data.addAcl = addAcl;
	data.readOnlyAcl = readOnlyAcl;
	data.browseAcl = browseAcl;
	data.listAcl = listAcl;
	data.propEditValue = false;
	data.isOwner = isOwner;
	data.name = name;
	data.noShare = noShare;
	data.vForProperties = vForProperties;
	data.vForShare = vForShare;
	data.searchConditionEditable = searchConditionEditable;
	
//	data.isPersonalLib = isPersonalLib;
	if(allAcl == 'true' || editAcl == 'true') {
		data.propEditValue = true;
	}

	if(data.allAcl == 'true') {
		libCfgMenuDisplay("I_acl");
		libCfgMenuEnable("I_acl");
		libCfgMenuEnable("I_log");
		libCfgMenuEnable("I_alert");
		libCfgMenuEnable("I_checkin");
	
		if (data.columnEditable == "true" && isOwner == 'true') {
			libCfgMenuEnable("I_column");
			if(isDefault == 'false')
			libCfgMenuEnable("I_columnDefault");
		}
		else {
			libCfgMenuDisable("I_column");
			libCfgMenuDisable("I_columnDefault");
		}
		
		if(data.searchConditionEditable == "true" && isOwner == 'true') {
			libCfgMenuEnable("I_searchCondition");
			if(isSearchConditionDefault == 'false')
				libCfgMenuEnable("I_searchConditionDefault");
		}
		else {
			libCfgMenuDisable("I_searchCondition");
			libCfgMenuDisable("I_searchConditionDefault");
		}
		
		if(isOwner == 'true'){
			libCfgMenuEnable("I_checkin");
		}else {
			libCfgMenuDisable("I_checkin");
		}

		libCfgMenuEnable("I_property");
		
		if(noShare == 'true'){
			libCfgMenuNoneDisplay("I_acl");
		}
	} 
	else {
		libCfgMenuDisplay("I_acl");
		libCfgMenuDisable("I_acl");
		libCfgMenuDisable("I_log");
		libCfgMenuDisable("I_alert");
		libCfgMenuDisable("I_checkin");
		libCfgMenuDisable("I_column");
		libCfgMenuDisable("I_columnDefault");
		libCfgMenuDisable("I_property");
		
		if(noShare == 'true'){
			libCfgMenuNoneDisplay("I_acl");
		}
	}
	
	//列表以上权限可以查看属性
	if (data.allAcl == 'true' || data.editAcl == 'true' || data.addAcl == 'true' || data.readOnlyAcl == 'true' || data.browseAcl == 'true' || data.listAcl == 'true') {
		libCfgMenuEnable("I_property");
	} else {
		libCfgMenuDisable("I_property");
	}
	  
      var PopMenu;
      //PopMenu = eval("E_rbpm");
      PopMenu = document.getElementById("E_rbpm");
      HideAll("rbpm",0);
      PopMenu.style.display="block";
//      PopMenu.style.left=document.body.scrollLeft+window.v3x.getEvent().clientX;
//      PopMenu.style.top=document.body.scrollTop+window.v3x.getEvent().clientY;
//      if(PopMenu.style.left+PopMenu.offsetWidth > document.body.scrollLeft+document.body.clientWidth)
//        PopMenu.style.left=document.body.scrollLeft+document.body.clientWidth-PopMenu.offsetWidth;
//      if(PopMenu.style.left < 0) PopMenu.style.left=0;
//      if(PopMenu.style.top+PopMenu.offsetHeight > document.body.scrollTop+document.body.clientHeight)
//        PopMenu.style.top=document.body.scrollTop+document.body.clientHeight-PopMenu.offsetHeight;
//      if(PopMenu.style.top < 0) PopMenu.style.top=0;
	 
	 	var scrollLeft = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);    
		var scrollTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
		var popLeft = document.getElementById("_" + docLibId).getBoundingClientRect().left + 8 + scrollLeft;
		var popTop = document.getElementById("_" + docLibId).getBoundingClientRect().top + 8 + scrollTop;
		if(popLeft + PopMenu.offsetWidth > document.body.clientWidth){
			popLeft -= PopMenu.offsetWidth;
		}
		if(popTop + PopMenu.offsetHeight > document.body.clientHeight){
			popTop -= PopMenu.offsetHeight;
		}
		PopMenu.style.left = popLeft < 0 ? (0+"px") : (popLeft+"px");
		PopMenu.style.top = popTop < 0 ? (0+"px") : (popTop+"px");
  }

  function OnClick()
  {
    HideAll("rbpm",0);
  }

  // 保存页面传输过来的数据
  function data() {}

function libGrant(){
	var docResourceId = data.docResourceId;
	var ownerId = data.ownerId;
	var userId = data.userId;
	var surl = ""
		
	surl = jsURL + "?method=docPropertyIframe&isP=false&isB=false&isM=false&isC=true&docLibType="
	+data.docLibType+"&isShareAndBorrowRoot=false&docResId="+data.docResourceId
	+"&isFolder=true&isLib=true&isPersonalLib=false&propEditValue="+data.propEditValue+"&allAcl="+data.allAcl
	+"&docLibId=" + data.docLibId + "&v=" + data.vForShare;	
	
	//直接调用doc.js中的打开窗口方式，不用这么多套js，便于维护，muyunxing
	v3xOpenWindow(surl,v3x.getMessage('DocLang.doc_jsp_properties_title'));
}
var winColumn;
function libSetColumn(){
	var surl =  managerURL + "?method=setDocListColumn&docLibId="+data.docLibId;
	if(v3x.getBrowserFlag('openWindow') == false){
	winColumn = v3x.openDialog({
		id : "column",
		title : "",
		url : surl,
		width : 500,
		height : 400,
		//type : 'panel',
		buttons : [{
			id:'btn1',
    	    text: v3x.getMessage("DocLang.submit"),
    	    handler: function(){
	    	   	winColumn.getReturnValue();
	        }
		}, {
    		id:'btn2',
    	    text: v3x.getMessage("DocLang.cancel"),
    	    handler: function(){
    	    	winColumn.close();
    	    }
		}]
	
	});
	} else {
		var movevalue = v3x.openWindow({
				url : surl,
				width : "500",
				height : "400",
				resizable : "false"
		});
		
		if(typeof(movevalue) != "undefined"){
			window.location.reload(true);
		}
	}
}

function libLog() {
	//alert(data.docResourceId)
	var theURL=jsURL + "?method=docLogViewIframe&docResId=" + data.docResourceId + "&docLibId=" + data.docLibId 
			+ "&isFolder=true&name=" + encodeURI(data.name) + "&isLib=true";
	var openArgs = {};
	openArgs["url"] = theURL;
	if(v3x.getBrowserFlag('openWindow') == false){
		openArgs["dialogType"] = "open";
	} 
	openArgs["workSpace"] = 'yes';
	openArgs["resizable"] = 'false';
	var log = v3x.openWindow(openArgs);
}

function libCheckoutAdmin(){
	var theURL=jsURL + "?method=docCheckoutIframe&docLibId=" + data.docLibId;
	var openArgs = {};
	openArgs["url"] = theURL;
	if(v3x.getBrowserFlag('openWindow') == false){
		openArgs["dialogType"] = "open";
	} 
	openArgs["workSpace"] = 'yes';
	openArgs["resizable"] = 'false';
	
	v3x.openWindow(openArgs);
}
function libProp() {
	surl = jsURL+"?method=docPropertyIframe&isP=true&isB=false&isM=false&isC=false&docLibType=" 
			+ data.docLibType + "&isShareAndBorrowRoot=false&docResId="
			+ data.docResourceId + "&isFolder=true&isPersonalLib=false&propEditValue="
			+ data.propEditValue + "&allAcl=" + data.allAcl + "&editAcl=" + data.editAcl + "&addAcl=" + data.addAcl + "&readOnlyAcl=" + data.readOnlyAcl
			+ "&browseAcl=" + data.browseAcl+ "&isLib=true&docLibId=" + data.docLibId + "&v="+ data.vForProperties;
//	alert(surl)
	//新改造 v3x.openWindow
	getA8Top().LibPropWin = getA8Top().$.dialog({
        title:v3x.getMessage("DocLang.doc_jsp_lib_roperties_title"),
        transParams:{'parentWin':window,'showButton':true},
        url: surl,
        width: 500,
        height: 500,
        isDrag:false
	});
}

function libCfgMenuEnable(id) {
    var cfgMenuObj = document.getElementById(id);
	if(navigator.appName == "Microsoft Internet Explorer"){
	    if(cfgMenuObj){
	        cfgMenuObj.disabled = false;
	        enableElement(cfgMenuObj);
	    }
	} else { 
		if(cfgMenuObj != null){
			cfgMenuObj.setAttribute("class","");
			if(cfgMenuObj.getAttribute("onclick1") != null){
				cfgMenuObj.setAttribute("onclick",cfgMenuObj.getAttribute("onclick1"));
			}
			if(cfgMenuObj.getAttribute("onmouseover1") != null){
				cfgMenuObj.setAttribute("onmouseover",cfgMenuObj.getAttribute("onmouseover1"));
			}
			if(cfgMenuObj.getAttribute("onmouseout1") != null){
				cfgMenuObj.setAttribute("onmouseout",cfgMenuObj.getAttribute("onmouseout1"));
			}
			if(cfgMenuObj.getAttribute("onmouseup1") != null){
				cfgMenuObj.setAttribute("onmouseup",cfgMenuObj.getAttribute("onmouseup1"));
			}
		}
	}
}

function libCfgMenuDisable(id) {
    var cfgMenuObj = document.getElementById(id);
	if(navigator.appName == "Microsoft Internet Explorer"){
		if(cfgMenuObj){
		    cfgMenuObj.disabled = true;
		    disableElement(cfgMenuObj);
		}
	} else { 
		if(cfgMenuObj != null){
			if(cfgMenuObj.getAttribute("onclick") != null && cfgMenuObj.getAttribute("onclick") != ""){
				cfgMenuObj.setAttribute("onclick1",cfgMenuObj.getAttribute("onclick"));
			}
			if(cfgMenuObj.getAttribute("onmouseover") != null && cfgMenuObj.getAttribute("onmouseover") != ""){
				cfgMenuObj.setAttribute("onmouseover1",cfgMenuObj.getAttribute("onmouseover"));
			}
			if(cfgMenuObj.getAttribute("onmouseout") != null && cfgMenuObj.getAttribute("onmouseout") != ""){
				cfgMenuObj.setAttribute("onmouseout1",cfgMenuObj.getAttribute("onmouseout"));
			}
			if(cfgMenuObj.getAttribute("onmouseup") != null && cfgMenuObj.getAttribute("onmouseup") != ""){
				cfgMenuObj.setAttribute("onmouseup1",cfgMenuObj.getAttribute("onmouseup"));
			}
			cfgMenuObj.setAttribute("class","disabled");
			cfgMenuObj.setAttribute("onclick","");
			cfgMenuObj.setAttribute("onmouseover","");
			cfgMenuObj.setAttribute("onmouseout","");
			cfgMenuObj.setAttribute("onmouseup","");
		}
	}
}

function libCfgMenuDisplay(id) {
	var ele = document.getElementById(id);
	if(ele){
		ele.style.display = "";
		ele.disabled = false;
		enableElement(ele);
	} 	
}

function libCfgMenuNoneDisplay(id) {
	var ele = document.getElementById(id);
	if(ele){
	    ele.style.display = "none";
	    disableElement(ele);
	}
		
}