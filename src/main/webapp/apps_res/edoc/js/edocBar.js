
//相对路径
var contextPath = "";
var leftMenuBuffer = new StringBuffer();

//公文左菜单导航
function V3XEdocBar(_contextPath, divId) {
	this._showstate = 1;
	this._divId = divId;
	this.menus = [];
	contextPath = _contextPath || "";
}

//菜单对象
function V3XEdocMenu(htmlId, sText, sHref, show_state, level) {
	this._htmlId = htmlId;
	this._sText = sText;
	this._sHref = sHref;
	this._showstate = 0;
	this._level = 1;
	if(show_state) {
		this._showstate = show_state;
	}
	if(level) {
		this._level = level;
	}	
	this._parentMenu;
	this._subMenu = [];
}

V3XEdocMenu.prototype.add = function (subMenuItem) {
	if(!subMenuItem){
		return;
	}
	subMenuItem._parentMenu = this;
	this._subMenu[this._subMenu.length] = subMenuItem;
};

V3XEdocBar.prototype.add = function (menuItem) {	
	if(!menuItem){
		return;
	}
	menuItem._parentMenu = this;
	this.menus[this.menus.length] = menuItem;
};

var left_navigation_open_level1 = "left_navigation_open_level1";
var left_navigation_close_level1 = "left_navigation_close_level1";
var left_navigation_open_level2 = "left_navigation_open_level2";
var left_navigation_close_level2 = "left_navigation_close_level2";
var left_navigation_open_level3 = "left_navigation_open_level3";
var left_navigation_close_level3 = "left_navigation_close_level3";
var menu_show_class = "show";
var menu_hide_class = "hide";

V3XEdocBar.prototype.toString = function () {
	leftMenuBuffer.append("<div id='"+this._divId+"'>");
	//菜单显示
	if(this.menus!=null && this.menus.length>0) {
		leftMenuBuffer.append(getSubMenus(this.menus));
	}
	leftMenuBuffer.append("</div>");
	return leftMenuBuffer.toString();
}

function getShowClass(level, showstate) {
	var liClass = "";
	if(showstate == 1) {
		liClass = "left_navigation_open_level"+level;
	} else {
		liClass = "left_navigation_close_level"+level;
	}
	return liClass;
}

function getSubMenus(submenus) {
	var menuBuffer = new StringBuffer();
	var showstate = submenus[0]._parentMenu._showstate;
	var show_class = "";
	if(showstate == 1) {
		show_class = menu_show_class;
	} else {
		show_class = menu_hide_class;
	}
	menuBuffer.append("<li class='"+show_class+"'>");
	menuBuffer.append("<ul>");
	for(var j=0; j<submenus.length; j++) {
		var level = submenus[j]._level;
		var showstate = submenus[j]._showstate;
		var class_level = getShowClass(level, showstate);
		menuBuffer.append("<li id='"+submenus[j]._htmlId+"' show='"+showstate+"' class='"+class_level+"' onClick='liClick(this, \""+submenus[j]._sHref+"\")' onmouseover='changeLiClass(this, 1)' onmouseout='changeLiClass(this, 2)' level='"+level+"'><a href='javascript:void(0)'>"+submenus[j]._sText+"</a></li>");
		if(submenus[j]._subMenu!=null && submenus[j]._subMenu.length>0) {
			menuBuffer.append(getSubMenus(submenus[j]._subMenu));
		}
	}
	menuBuffer.append("</ul>");
	menuBuffer.append("</li>");
	return menuBuffer.toString();
} 

function changeLiClass(obj) {
	var level = obj.level;
	var openClass = getShowClass(level, 1);
	var closeClass = getShowClass(level, 0);
	if(obj.show == 0) {
		var levelI = $("li[@level='"+level+"'][@show='1']");
		levelI.removeClass(openClass);
		levelI.addClass(closeClass);
		$(obj).removeClass(closeClass);
		$(obj).addClass(openClass);
		if(levelI!=null) {
			levelI.attr("show", 0);
		}
		if(levelI.next()!=null && levelI.next().find("ul").length>0) {
			levelI.next().removeClass("show");
			levelI.next().addClass("hide");
		}
		if($(obj).next() != null && $(obj).next().find("ul").length>0) {
			$(obj).next().removeClass("hide");
			$(obj).next().addClass("show");
		}
		obj.show = 1;
	}
	changeSubMenuClass(level);
}

function liClick(obj, nowurl) {
	var level = obj.level;
	var openClass = getShowClass(level, 1);
	var closeClass = getShowClass(level, 0);
	if(obj.show == 0) {
		var levelI = $("li[@level='"+level+"'][@show='1']");
		levelI.removeClass(openClass);
		levelI.addClass(closeClass);
		$(obj).removeClass(closeClass);
		$(obj).addClass(openClass);
		if(levelI!=null) {
			levelI.attr("show", 0);
		}
		if(levelI.next()!=null && levelI.next().find("ul").length>0) {
			levelI.next().removeClass("show");
			levelI.next().addClass("hide");
		}
		if($(obj).next() != null && $(obj).next().find("ul").length>0) {
			$(obj).next().removeClass("hide");
			$(obj).next().addClass("show");
		}
		obj.show = 1;
	}
	changeSubMenuClass(level);
	parent.listFrame.location.href = nowurl;
}

function changeSubMenuClass(level) {
	if(level == 1) {
		$("li[@level=2]").attr("show", 0);
		$("li[@level=3]").attr("show", 0);
		$("li[@level=2]").attr("class", "left_navigation_close_level2");
		$("li[@level=3]").attr("class", "left_navigation_close_level3");
	} else if(level == 2) {
		$("li[@level=3]").attr("show", 0);
		$("li[@level=3]").attr("class", "left_navigation_close_level3");
	}
}

function changeLiClass(obj, type) {
	var openClass = getShowClass(obj.level, 1);
	var closeClass = getShowClass(obj.level, 0);
	if(type == 1) {//鼠标进入事件
		if($(obj).attr("class").indexOf(closeClass)>=0) {//如果当前按钮是关闭的
			$(obj).removeClass(closeClass);
			$(obj).addClass(openClass);
		}
	} else {//鼠标划出事件
		if($(obj).attr("class").indexOf(openClass)>=0) {//如果当前按钮是打开的
			if($(obj).attr("show")!=1) {//如果鼠标进入前本身就是选中状态
				$(obj).removeClass(openClass);
				$(obj).addClass(closeClass);
			}
		}
	}	
}

