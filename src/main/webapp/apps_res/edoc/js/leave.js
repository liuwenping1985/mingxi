var isAHref = false;
var parents = [];
var clickObj = [];
var clicks = [];
var hrefs = [];
var clickFlag = true;
var isLeave = false;

function initLeave(edocType) {
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
		//GOV-4830 个人空间-我的快捷，点击'发文拟文'后弹出错误消息，发文单加载不起
		if(parents[2].topFrame){
			parents[2].topFrame.clickObj = [];
			parents[2].topFrame.clicks = [];		
			var seeyonFrame = parents[3].document;
			var DrawdownMenuItemsDIV = $(seeyonFrame).find("#DrawdownMenuItemsDIV");
			if(DrawdownMenuItemsDIV != null) {
				DrawdownMenuItemsDIV.attr("newLeave", "true");
			}
		}
		
		
		//moreSubMenuDivSet
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
	
}


function trim(mystr){  
	while ((mystr.indexOf(" ")==0) && (mystr.length>1)){
	mystr=mystr.substring(1,mystr.length);
	}//去除前面空格
	while ((mystr.lastIndexOf(" ")==mystr.length-1)&&(mystr.length>1)){
	mystr=mystr.substring(0,mystr.length-1);
	}//去除后面空格
	if (mystr==" "){
	mystr="";
	}
	return mystr;

}  



function myClick(obj, newLeave) {
	if(isLeave==false) {
		//当没有填写公文标题时,就不弹出是否保存进草稿箱的窗口
		if(document.getElementById("my:subject") && trim(document.getElementById("my:subject").value) == ""){
			//先将之前的控件click事件恢复
			reductClick(newLeave);
			topLinkClick(newLeave);
			//触发恢复后的click事件
			$(obj).trigger("click");
			return;		
		} 
		clickFlag = false;	
		document.body.onbeforeunload = null;
		
		//mark by xuqiangwei Chrome37修改，这里应该没有用了
		var rv = v3x.openWindow({
	        url: "mtAppMeetingController.do?method=newLeave",
        	width: "350",
	        height: "150",
	        status : "no",
	        resizable : "no"
		});
		if (rv == "saveYes") {
		  //lijl添加,在离开拟文时标题不能为空
		  if(document.getElementById("my:subject") && document.getElementById("my:subject").value==""){
			  alert(v3x.getMessage("edocLang.edoc_inputSubject"));
			  return false;
		  }
		  /*
		  else if(!(/^[^\|"']*$/.test(document.getElementById("my:subject").value))){alert(3333);
				alert(_("edocLang.edoc_inputSpecialChar"));
				if(document.getElementById("my:subject").disabled==true)
				{
					alert(_("edocLang.edoc_alertSetPerm"));
					return false;
				}    		
				document.getElementById("my:subject").focus();
				return false;
		  }*/
		  else{
			  topLinkClick(false);
			  if(!saveAsDraft(false)){//xiangfan 添加判断条件，返回false时，不应该跳转，由BUG：GOV-4358 引申出来的
				  return false;
			  };
			  reductClick(newLeave);
			  $(obj).trigger("click");
		  }
		} else if (rv == "saveNo") {
			topLinkClick(false);
			reductClick(newLeave);
			$(obj).trigger("click");		
	    } else {
	    	return false;
	    }
	} else {//退件箱发文不能保存到草稿箱中
		topLinkClick(false);
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

function myOnUnload() {
	isAHref = true;
	reductClick(false);
    topLinkClick(false);
}

function onbeforeunload() {
	if(clickFlag) {
		clickFlag = false;	
		document.body.onbeforeunload = null;
		return "";
	}
}
