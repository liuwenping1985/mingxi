var isAHref = false;
var parents = [];
var clickObj = [];
var clicks = [];
var hrefs = [];
var clickFlag = true;
var approveState = 0;

var formIsChange = false; // 记录是否有修改
var attHTML = "";
var docHTML = "";
var attHashChange = false;

function initLeave(edocType) {
  return ;//TODO 5.0
	if(edocType!=0) {
		return;
	}
	var i = 0;
	var index = 0;
	parents[0] = parent;
	if(parents[0]==null) return;/***********parents[0]不为空**************/
	////////////////////////////////公文左导航
	if(parents[0].treeFrame != null) {
		clickObj[index] = [];
		clicks[index] = [];
		var treeFrame = parents[0].treeFrame.document;
		$(treeFrame).find("div[@class='webfx-tree-item']").find("a[@id*='webfx-tree-object-']").each(function() {
			var obj = this;
			if(obj != null) {
				clickObj[index][i] = obj.onclick;
				clicks[index][i] = obj;
				hrefs[i] = obj.href;
				obj.href = "#";
				obj.xy = i;
				$(obj).unbind("click");
				obj.onclick = function() {
					isAHref = true;
					myClick(obj);
				}
				i++;
			}			
		});
	}
		

	parents[1] = parents[0].parent;
	if(parents[1]==null) return;/***********parents[1]不为空**************/
	//////////////////////////////公文主页面上菜单		
	i = 0;
	index++;
	clickObj[index] = [];
	clicks[index] = [];
	//if(parents[1].name == "mainFrame") {
	if(parents[1].name == "detailIframe") {
		var detailIframe = parents[1].document;
		
		$(detailIframe).find("div.div-float > div.cursor-hand").each(function() {
			var obj = this;
			if(obj != null) {
				clickObj[index][i] = obj.onclick;
				clicks[index][i] = obj;
				obj.xy = i;
				$(obj).unbind("click");
				obj.onclick = function() {
					myClick(obj);
				}
				i++;
			}
		});		
	}
	
	parents[2] = parents[1].parent.parent;
	if(parents[2]==null) return;/***********parents[2]不为空**************/
	if(parents[2].name=="") {
		parents[2] = parents[1].parent;
	}	

	if(parents[2].name == "contentFrame") {
		if(parents[2].leftFrame==null) return;
		//////////////////////////////左侧菜单
		i = 0;
		index++;
		clickObj[index] = [];
		clicks[index] = [];		
		var leftFrame = parents[2].leftFrame.document;
		var menuItemsDiv = $(leftFrame).find("table.leftBg_head").find("#menuItemsDiv");
		menuItemsDiv.find("div[@id*='LeftMenu']").each(function() {
			var obj = this;
			if(obj != null) {
				clickObj[index][i] = obj.onclick;
				clicks[index][i] = obj;
				obj.xy = i;
				$(obj).unbind("click");
				obj.onclick = function() {
					myClick(obj);
				}
				i++;
			}
		});		
		//////////////////////////////面板事件
		i = 0;
		index++;
		clickObj[index] = [];
		clicks[index] = [];
		var toolsPaneDiv = $(leftFrame).find("table.leftBg_head").find("#toolsPaneDiv");
		toolsPaneDiv.find("table tr td div").each(function() {
			var obj = this;
			if(obj != null) {
				clickObj[index][i] = obj.onclick;
				clicks[index][i] = obj;
				obj.xy = i;
				$(obj).unbind("click");
				obj.onclick = function() {
					myClick(obj);
				}
				i++;
			}
		});				
		//////////////////////////////左框架面板设置
		i = 0;
		index++;
		clickObj[index] = [];
		clicks[index] = [];
		var leftBottomIconBg = $(leftFrame).find("table.leftBg_head").find("div.bottomIconBg");
		if(leftBottomIconBg!=null) {
			var obj = leftBottomIconBg[0];
			if(obj != null) {
				clickObj[index][i] = obj.onclick;
				clicks[index][i] = obj;
				obj.xy = i;
				$(obj).unbind("click");
				obj.onclick = function() {
					myClick(obj);
				}
				i++;
			}
		}
	}
	
	//////////////////////////////上框架二级菜单
	parents[3] = parents[2].parent;
	if(parents[3]==null) return;/***********parents[3]不为空**************/
	if(parents[3].name == "") {
		i = 0;
		index++;
		clickObj[index] = [];
		clicks[index] = [];
		if(parents[2].topFrame==null||parents[2].topFrame=='undefined') {
			return;
		}
		parents[2].topFrame.clickObj = [];
		parents[2].topFrame.clicks = [];		
		var seeyonFrame = parents[3].document;
		var DrawdownMenuItemsDIV = $(seeyonFrame).find("#DrawdownMenuItemsDIV");
		if(DrawdownMenuItemsDIV != null) {
			DrawdownMenuItemsDIV.attr("newLeave", "true");
		}
	}

	var topFrame = parents[2].topFrame;
	if(topFrame == null) return;
	//////////////////////////////上框架菜单设置
	var topBottomIconBg = $(topFrame.document).find("table[@class='topBg bg_banner_left']").find("table.bg_menu_left").find("div.bottomIconBg");
	if(topBottomIconBg!=null) {
		i = 0;
		index++;
		clickObj[index] = [];
		clicks[index] = [];	
		var obj = topBottomIconBg[0];
		if(obj != null) {
			clickObj[index][i] = obj.onclick;
			clicks[index][i] = obj;
			obj.xy = i;
			$(obj).unbind("click");
			obj.onclick = function() {
				myClick(obj);
			}
			i++;
		}
	}
	
	//////////////////////////////上框架高级
	var advance_higher = $(topFrame.document).find("input[@class='advance_higher']");
	if(advance_higher!=null) {
		i = 0;
		index++;
		clickObj[index] = [];
		clicks[index] = [];	
		var obj = advance_higher[0];
		if(obj != null) {
			clickObj[index][i] = obj.onclick;
			clicks[index][i] = obj;
			obj.xy = i;
			$(obj).unbind("click");
			obj.onclick = function() {
				myClick(obj);
			}
			i++;
		}
	}

	//////////////////////////////上框架全文检索
	var advance_btn = $(topFrame.document).find("input[@class='advance_btn']");
	if(advance_btn!=null) {
		i = 0;
		index++;
		clickObj[index] = [];
		clicks[index] = [];	
		var obj = advance_btn[0];
		if(obj != null) {
			clickObj[index][i] = obj.onclick;
			clicks[index][i] = obj;
			obj.xy = i;
			$(obj).unbind("click");
			obj.onclick = function() {
				myClick(obj);
			}
			i++;
		}
	}
	
	////////////////////////////个人空间
	i = 0;
	index++;
	clickObj[index] = [];
	clicks[index] = [];
	var trPanel = $(topFrame.document).find("#trPanel");
	trPanel.find("div[@id*='tdPanel_space_']").each(function() {
		var obj = this;
		if(obj != null) {
			clickObj[index][i] = obj.onclick;
			clicks[index][i] = obj;
			obj.xy = i;
			$(obj).unbind("click");
			obj.onclick = function() {
				myClick(obj);
			}
			i++;
		}
	});	
	////////////////////////////刷新退出按钮
	i = 0;
	index++;
	clickObj[index] = [];
	clicks[index] = [];
	var bannerRightTable = $(topFrame.document).find("#bannerRightTable").find("tr:eq(0)").find("table");
	bannerRightTable.find("div").each(function() {
		var obj = this;
		if(obj != null) {
			clickObj[index][i] = obj.onclick;
			clicks[index][i] = obj;
			obj.xy = i;
			$(obj).unbind("click");
			obj.onclick = function() {
				myClick(obj);
			}
			i++;
		}
	});	
	
	formChangeLoad();
}

function myClick(obj, newLeave) {
	
	if(approveState != 30) {
		clickFlag = false;	
		document.body.onbeforeunload = null;

	//if(formHasChange()) {
		var rv = v3x.openWindow({
	        url: "mtAppMeetingController.do?method=newLeave",
	        width: "350",
	        height: "150",
	        status : "no",
	        resizable : "no"
		});
		if (rv == "saveYes") {
			if(parents[3].document.getElementById("DrawdownMenuItemsDIV")!=null) {
				parents[3].document.getElementById("DrawdownMenuItemsDIV").newLeave = false;
			}
	    	if(!saveAsDraft(false)){
	    		return false;
	    	}else{
	    		reductClick(newLeave);
				$(obj).trigger("click");
	    	}
	    	
		} else if (rv == "saveNo") {
			if(parents[3].document.getElementById("DrawdownMenuItemsDIV")!=null) {
				parents[3].document.getElementById("DrawdownMenuItemsDIV").newLeave = false;
			}
			reductClick(newLeave);
			$(obj).trigger("click");		
	    } else {
	    	return false;
	    }
	//} else {
		//parents[3].document.getElementById("DrawdownMenuItemsDIV").newLeave = false;
		//reductClick(newLeave);
		//$(obj).trigger("click");
	//}
	} else {//不通过的会议不能保存到草稿箱中
		//clickFlag = true;
		//$("body").trigger("beforeunload");
		if(parents[3].document.getElementById("DrawdownMenuItemsDIV")!=null) {
			parents[3].document.getElementById("DrawdownMenuItemsDIV").newLeave = false;
		}
		reductClick(newLeave);
		$(obj).trigger("click");
	}
}


function topLinkClick(newLeave) {
	if(parents[3]!=null) {
		var seeyonFrame = parents[3].document;
		var DrawdownMenuItemsDIV = $(seeyonFrame).find("#DrawdownMenuItemsDIV");
		if(DrawdownMenuItemsDIV!=null) {
			DrawdownMenuItemsDIV.attr("newLeave", newLeave);
		}		
	}
}

function reductClick(newLeave) {
	for(var i=0; i<clicks.length; i++) {
		//转发 中点击保存进草稿箱，这里会报错，所以加一个判断
		if(clicks[i]){
			for(var j=0; j<clicks[i].length; j++) {
				$(clicks[i][j]).unbind("click");
				clicks[i][j].onclick = clickObj[i][j];
				if(isAHref && hrefs[j]) {
					clicks[i][j].href = hrefs[j];
				}
			}
		}
	}
	if(newLeave && newLeave=="true") {
		var topFrame = parents[2].topFrame;
		if(topFrame!=null) {
			var parentClickObj = parents[2].topFrame.clickObj;
	    	var parentClicks = parents[2].topFrame.clicks;
		    for(var i=0; i<parentClicks.length; i++) {
				for(var j=0; j<parentClicks[i].length; j++) {
					$(parentClicks[i][j]).unbind("click");
					parentClicks[i][j].onclick = parentClickObj[i][j];
				}
			}
		}
	}
	isAHref = false;
}

 
function formChangeLoad() {
	/*
	var dataForm = document.getElementById('dataForm');
	var elements = dataForm.elements;
	for (var i =0; i < elements.length; i ++) {
	 	elements[i].onchange = formChange; // 为所有的表单元素注册修改事件.
	}
	attHTML = $("#attachment2Area").html();
	docHTML = $("#attachmentArea").html();
	*/
}

// 统一处理修改的触发事件
function formChange() {
	formIsChange = true;
}

function formHasChange() {
	if(formHasChange!=true) {
		if(attHTML!=$("#attachment2Area").html()) {
			formHasChange = true;
		}
	}
	if(formHasChange!=true) {
		if(docHTML!=$("#attachmentArea").html()) {
			formHasChange = true;
		}
	}
	return formIsChange;
}

function myOnUnload() {
	isAHref = true;
	reductClick(false);
    topLinkClick(false);
}

function onbeforeunload() {
	if(clickFlag) {
		return "";
	}
}