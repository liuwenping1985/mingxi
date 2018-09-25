function showEditImage(id){
	var element = document.getElementById("edit"+id);
	if(element){
		element.className="editContentImg cursor-hand";
	}
}
function removeEditImage(id){
	var element = document.getElementById("edit"+id);
	if(element){
		element.className="";
	}
}

var i = 0;

var contextPath = "";

/**
 * 主函数。
 */
function RightMenu(_contextPath) {
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
	HTMLstr += "<div id='E_rbpm' class='rm_div'>\n";
		// rbpm = right button pop menu
	HTMLstr += "<table width='110' border='0' cellspacing='0' id='docMenuTable' ";
	HTMLstr += "style='background-image: url("+contextPath+"/common/skin/default/images/xmenu/toolbar_items_bg.gif);background-repeat: repeat-y;'";
	HTMLstr += ">";
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

	TempStr += "<tr id='P_" + id + "' style='cursor: hand;FONT-SIZE: 12px; height: 22px;' "		
		+ "onmouseup='window.event.cancelBubble=true;' "
		+ "onclick='window.event.cancelBubble=true;' "
	
	TempStr	+= "><td nowrap='nowrap' style=\"" + style1 + "\" " 
		+ "onmouseover='this.style.cssText=\"" + styleOver + "\";P_OnMouseOver(\"" + id + "\",\"" + parent + "\");' "
		+ "onmouseout='this.style.cssText=\"" + style1 + "\";P_OnMouseOut(\"" + id + "\",\"" + parent + "\");' " + ">"
		+ "<div style='background-image: url("+contextPath+"/common/skin/default/images/xmenu/arrow.right.png);background-position: right center;background-repeat: no-repeat;'>"
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
	var thesrc ;
	if(typeof(icon) == 'object'){
        var y = parseInt(icon[0],10)-1;
        var x = parseInt(icon[1],10)-1;
        thesrc = '<IMG style="width:16px; height:16px;margin-right: 6px;margin-left:6px;vertical-align: middle; BACKGROUND-POSITION: -'+ (x*16) +'px -' + (y*16) + 'px;  display: inline-block;" height=16; width=16; border=0; class="toolbar-button-icon" align="absmiddle">';
	}
	
	var TempStr = "";

	var ItemStr = "<!-- ITEM : I_" + id + i +" -->";
	if(id.indexOf("separator") != -1)
	{
	  TempStr += ItemStr + "\n";
	  TempStr += "<tr id='I_" + id + i + "' style='height:5px;' onclick='window.event.cancelBubble=true;' onmouseup='window.event.cancelBubble=true;'><td><hr></td></tr>";
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
	TempStr += "<tr id='I_" + id + "' style='cursor: hand;FONT-SIZE: 12px; height: 22px;' "
		+ "onclick='window.event.cancelBubble=true;' "
	TempStr += "onmouseover='I_OnMouseOver(\"" + id + "\",\"" + parent + "\")' ";
	TempStr += "onmouseout='I_OnMouseOut(\"" + id + "\")' ";
	if(location == null)
		TempStr += "onmouseup='I_OnMouseUp(\"" + id + "\",\"" + parent + "\",null)' ";
	else
		TempStr += "onmouseup='I_OnMouseUp(\"" + id + "\",\"" + parent + "\",\"" + location + "\",\"" + flag + "\")' ";

	TempStr	+= "><td nowrap='nowrap' style=\"" + style1 + "\" " 
		+ "onmouseover='this.style.cssText=\"" + styleOver + "\"' "
		+ "onmouseout='this.style.cssText=\"" + style1 + "\"' " + ">"
		+ (typeof(icon) == 'object' ? thesrc : icon ? "<img src='" + icon + "' border='0' height=16 style='margin-right: 6px;margin-left:6px;vertical-align: middle;'>" : "")
		+ name 		
		+ "</td></tr>\n"
	
	TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->";

	HTMLstr = HTMLstr.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", TempStr);
}


function GetMenu() {
	return HTMLstr;
}


function I_OnMouseOver(id, parent)
{
	var Item;
	if(parent != "rbpm")
	{
		var ParentItem;
		//ParentItem = eval("P_" + parent);
		ParentItem = document.getElementById("P_" + parent);
		
		//ParentItem.className = "over";
	}
	Item = document.getElementById("I_" + id);
	//Item.className = "over";
	HideAll(parent, 1);
}


function I_OnMouseOut(id)
{
	var Item;
	Item = document.getElementById("I_" + id);
	//Item.className = "out";
}


function I_OnMouseUp(id, parent, location, flag) {	
	var name = id;
	
	var ParentMenu;
	v3x.getEvent().cancelBubble = true;
	OnClick()
	ParentMenu = document.getElementById("E_" + parent);	
	ParentMenu.display = "none";
	if(currentAddressBook){
		if(id=='sendMessage'){
		  var message = getA8Top().v3x.getParentWindow().getA8Top().getUCStatus();
	    if (message != '') {
	      alert(message);
	      return;
	    }
			getA8Top().v3x.getParentWindow().getA8Top().sendUCMessage(currentAddressBook.memberName, currentAddressBook.memberId);
		}
		if(id=='sendSMS'){
			sendSMSV3X(currentAddressBook.memberId);
		}
		if(id=='sendMail'){
			sendMail(currentAddressBook.email);
		}
		if(id=='viewMember'){
			showV3XMemberCard(currentAddressBook.memberId);
		}
	}
	
}


function P_OnMouseOver(id, parent) {
	var Item;
	var Extend;
	var Parent;
	if(parent != "rbpm")
	{
		var ParentItem;
		//ParentItem = eval("P_" + parent);
		ParentItem = document.getElementById("P_" + parent);
		//ParentItem.className = "over";
	}
	HideAll(parent, 1);
	Item = eval("P_" + id);
	Extend = eval("E_" + id);
	Parent = eval("E_" + parent);
	//Item.className = "over";
	Extend.style.display = "block";
	Extend.style.posLeft = document.body.scrollLeft + Parent.offsetLeft + Parent.offsetWidth;
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


function P_OnMouseOut(id, parent)
{
}


function HideAll(id, flag) {
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
			//Temp = eval("P_" + Area[i]);
			Temp = document.getElementById("P_" + Area[i]);
			//Temp.className = "out";
		}
	}
}
function AddressBook(memberId,telephone,email,memberName){
	this.memberId = memberId;
	this.telephone = telephone;
	this.email = email;
	this.memberName = memberName;
}
document.onmouseup = OnClick;
var currentAddressBook;
function OnMouseUp(addressBook) {
  var showMenu = false;
  if(currentUserId==addressBook.memberId){
    noDisplayMenu('I_sendMessage');
  }else{
    displayMenu('I_sendMessage');
    if(document.getElementById('I_sendMessage')){
      showMenu = true;
    }
  }
	if(!!addressBook.telephone){
		displayMenu('I_sendSMS');
		if(document.getElementById('I_sendSMS')){
		  showMenu = true;
		}
	}else{
		noDisplayMenu('I_sendSMS');
	}
	if(!!addressBook.email){
		displayMenu('I_sendMail');
		if(document.getElementById('I_sendMail')){
      showMenu = true;
    }
	}else{
		noDisplayMenu('I_sendMail');
	}
	
	if(!showMenu){
	  return;
	}
	
	var PopMenu;
	//PopMenu = eval("E_rbpm");
	PopMenu = document.getElementById("E_rbpm");
	currentAddressBook = addressBook;
	
	HideAll("rbpm", 0);
	PopMenu.style.display = "block";
//	PopMenu.style.posLeft = document.body.scrollLeft + v3x.getEvent().clientX;
//	PopMenu.style.posTop = document.body.scrollTop + v3x.getEvent().clientY;
//	if(PopMenu.style.posLeft + PopMenu.offsetWidth > document.body.scrollLeft + document.body.clientWidth)
//		PopMenu.style.posLeft = document.body.scrollLeft + document.body.clientWidth - PopMenu.offsetWidth;
//	if(PopMenu.style.posLeft < 0) 
//		PopMenu.style.posLeft = 0;
//	if(PopMenu.style.posTop + PopMenu.offsetHeight > document.body.scrollTop + document.body.clientHeight)
//		PopMenu.style.posTop = document.body.scrollTop + document.body.clientHeight - PopMenu.offsetHeight;
//	if(PopMenu.style.posTop < 0) 
//		PopMenu.style.posTop = 0;
 	var scrollLeft = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);    
	var scrollTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
	var popLeft = document.getElementById("edit" + addressBook.memberId).getBoundingClientRect().left + 8 + scrollLeft;
	var popTop = document.getElementById("edit" + addressBook.memberId).getBoundingClientRect().top + 8 + scrollTop;
	if(popLeft + PopMenu.offsetWidth > document.body.clientWidth){
		popLeft -= PopMenu.offsetWidth;
	}
	if(popTop + PopMenu.offsetHeight > document.body.clientHeight){
		popTop -= PopMenu.offsetHeight;
	}
	PopMenu.style.left = popLeft < 0 ? (0+"px") : (popLeft+"px");
	PopMenu.style.top = popTop < 0 ? (0+"px") : (popTop+"px");	
}
function OnClick() {
	HideAll("rbpm",0);
}
function displayMenu(id){
	var elemenet = document.getElementById(id);
	if(elemenet){
		elemenet.style.display='';
	}
}
function noDisplayMenu(id){
	var elemenet = document.getElementById(id);
	if(elemenet){
		elemenet.style.display='none';
	}
}



 