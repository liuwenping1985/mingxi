<%--
 $Author: leikj $
 $Rev: 4195 $
 $Date:: 2012-09-19 18:18:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<link type="text/css" href="${path}/main/frames/desktop/index.css" rel="stylesheet" />
<script type="text/javascript" src="${path}/main/frames/desktop/js/desktop-ajax.js"></script>
<script>
//快捷库分类下拉对象
var metroCategoryDropdown = null;
//编辑状态标记
var portletState = "show";
var deskMgr = new deskManager();
//全局变量，用来显示分类
var category = {};
//全局变量，用来显示当前桌面添加的快捷
var addedPortletList = new Array();
//获取当前栏目的已选磁贴数据
var transParams = window.parentDialogObj['shortcut'].getTransParams();
var selectPortlet = "";
if(transParams){
	selectPortlet = transParams.selectPortlet;
	var selectPortlets = selectPortlet.split(",");
	for(var i = 0 ; i < selectPortlets.length; i ++){
		var portletStr = selectPortlets[i];
		var portlet = portletStr.split("|");
		if(portlet.length > 0){
			addedPortletList.push(portlet);
		}
	}
}
$(function () {
    //兼容ie6高度
    ie6ReSize();

    //快捷库信息
    initMetroShortcuts("PortletCategory");
    
    $(".dialogCloseBtn").click(function () {
        $(".metroShortAddDialog,.metroShortAddDialog_mask").fadeOut();
        saveAllPortletSort();
    });

	//搜索框
	$("#metroShortAddDialog_search_textbox").attr("ready","true").focusout(function(event) {
		if ($(this).val() == "") {
			$(this).val($.i18n("desk.alert.searchtip"));
			$(this).attr("ready","true");
            $(this).parent().removeClass("metroShortAddDialog_search_textbox_focus");
		};
	}).click(function(event) {
		if ($(this).attr("ready") == "true") {
			$(this).val("");
			$(this).attr("ready","false");
            $(this).parent().addClass("metroShortAddDialog_search_textbox_focus");
		};
	}).change(function(){
        metroShortcutSearch();
    }).keydown(function(e){
        if(e.keyCode == "13"){
            metroShortcutSearch();
        }
    });
    $("#metroShortSearch").click(function(){
        metroShortcutSearch();
    });
	$.scrollAuto();
    shortcutBlock_hover();
    //快捷库大分类选择
    metroCategoryDropdown = $.dropdown({
        id : "metroCategory",
        onchange : function(){
            var metroCategory = $("#metroCategory").val();

            if(metroCategory){
                initMetroShortcuts(metroCategory);
            }
        }
    });
});

//兼容ie6高度
function ie6ReSize() {
    if ($.browser.msie) {
        if ($.browser.version < 7) {
            $("#desktop_stadic_layout_body").height($(window).height() - $("#desktop_stadic_layout_head").height());
            $(window).resize(function() {
                $("#desktop_stadic_layout_body").height($(window).height() - $("#desktop_stadic_layout_head").height());
            });
        }
    }
}

/***
*快捷-鼠标滑动-hover出边框(四个div拼凑成边框)
***/
function shortcutBlock_hover (){
	$("body").append('<div class="shortcutBlock_hover shortcutBlock_hoverT">&nbsp;</div><div class="shortcutBlock_hover shortcutBlock_hoverR">&nbsp;</div><div class="shortcutBlock_hover shortcutBlock_hoverB">&nbsp;</div><div class="shortcutBlock_hover shortcutBlock_hoverL">&nbsp;</div>');
	$(".shortcutBlock").live("mouseenter" , function(){
		var _left = $(this).offset().left;
		var _top = $(this).offset().top;
		$(".shortcutBlock_hoverT").css({
			left: _left ,
			top: _top - 3,
			width : $(this).width()
		});
		$(".shortcutBlock_hoverB").css({
			left: _left,
			top: _top + 155,
			width : $(this).width()
		});
		$(".shortcutBlock_hoverL").css({
			left: _left -3,
			top: _top - 3
		});
		$(".shortcutBlock_hoverR").css({
			left: _left + $(this).width(),
			top: _top - 3
		});
		$(".shortcutBlock_hover").show();
	}).live("mouseleave",function(){
		$(".shortcutBlock_hover").hide();
	});
	$(document).mousedown(function(event) {
		$(".shortcutBlock_hover").hide();
	});
}

jQuery.extend({
    //快捷库
	metroShortAddDialog_itemList: function(allPortlets) {
	    var obj = $("#metroShortAddDialog_itemList");
	    obj.html("");
	    var html = '';
		for(var key in allPortlets){
			var portlets = allPortlets[key];
			html += '<div class="item_title" id="'+key+'_item">' + categoryMap[key] + '</div>';
	        html += '<div class="item_list scrollAuto"><ul class="item_box">';
			
			for(var i = 0 ; i < portlets.length; i++){
				var portlet = portlets[i];
				var images = portlet.imageLayouts;

                var selectedCss = "";
                var active = "";
                var selected = "";
                var hasSelected = false;
                if(addedPortletList != null && addedPortletList.length > 0 ){
                    for(var j = 0 ; j < addedPortletList.length; j++){
                        if(addedPortletList[j][0] == portlet.portletId){
                            hasSelected = true;
                            continue;
                        }
                    }
                }
                if(hasSelected == true){
                    selectedCss = "selected_32";
                    active += "active";
                    selected = " selected";
                }

				if(images!=null && images.length > 0){
                    var imageUrl = images[0].imageUrl;
                    if(imageUrl.indexOf("/")>=0){
                        imageUrl = _ctxPath+imageUrl;
                    }else{
                        imageUrl = _ctxPath+"/main/skin/desktop/"+getCtpTop().skinPathKey+"/portletImages/"+imageUrl;
                    }
                    if (portlet.size == 1) {
						html += '<li class="item_size'+portlet.size + selected +'" onclick="$.addShortToLayout(this);" >';
                        html += "<img src='" +imageUrl+ "' border='0' width='280' height='175' class='left' />";
                    }else{
						html += '<li class="item_size'+portlet.size + selected +'" onclick="$.addShortToLayout(this);" style="background:url('+imageUrl+')" >';
                    }
					html += "<input type='hidden' name='portletBeanId' value='"+portlet.id+"'>";
					html += "<input type='hidden' name='portletId' value='"+portlet.portletId+"'>";
					html += "<input type='hidden' name='portletSize' value='"+portlet.size+"'>";
					html += '<p class="left '+active+'"><span title="'+portlet.displayName+'">'+portlet.displayName+'</span><em class="ico32 '+ selectedCss +'"></em></p>';
					html += '</li>';
				}
			}
			html += '</ul></div>';
		}
	    
	    obj.html(html);
	    $.scrollAuto(obj);
	    obj.find(".item_box").each(function(){
            var _itemWidth = 0;
            var _mozillaWidth = 0;
            if ($.browser.mozilla) {
                _mozillaWidth  = 80;
            };
            $(this).find("li").each(function(i,_liObj){
                _itemWidth += $(_liObj).width() + _mozillaWidth;
            });
            $(this).width(_itemWidth);
	    });
	    obj.find("li").click(function () {
	        //$(this).addClass("selected");
	    }).mouseenter(function(event) {
	    	$(this).find("p").addClass('active');
	    }).mouseleave(function(event) {
            if (!$(this).hasClass("selected")) {
    	    	$(this).find("p").removeClass('active');
            };
	    });
	},
	//空间滚动区域初始化
	metroShortAddDialog_roundItemList : function(portlets){
		var roundItem = $("#roundabout");
		roundItem.html("");
		var html = "";
		if(portlets != null){
			$(".roundabout_area").show();
			for(var i=0 ; i < portlets.length; i++){
        var portlet = portlets[i];
				html += "<li title='" + portlet.displayName.escapeHTML() + "' class='hand' onclick='$.addSpaceShortToLayout(this);'>";
				var images = portlet.imageLayouts;

                var selectedCss = "";
                var active = "";
                var selected = "";
                var hasSelected = false;
                if(addedPortletList != null && addedPortletList.length > 0 ){
                    for(var j = 0 ; j < addedPortletList.length; j++){
                        if(addedPortletList[j][0] == portlet.portletId){
                            hasSelected = true;
                            continue;
                        }
                    }
                }
                if(hasSelected == true){
                    selectedCss = "selected_32";
                    active += "active";
                    selected = " selected";
                }

				html += "<input type='hidden' name='portletBeanId' value='"+portlet.id+"'>";
				html += "<input type='hidden' name='portletId' value='"+portlet.portletId+"'>";
				html += "<input type='hidden' name='portletSize' value='"+portlet.size+"'>";

				if(images.length>1){
					
				}else if(images.length == 1){
					var imageUrl = images[0].imageUrl;
                    if(imageUrl.indexOf("/")>=0){
                        imageUrl = _ctxPath+imageUrl;
                    }else{
                        imageUrl = _ctxPath+"/main/skin/desktop/"+getCtpTop().skinPathKey+"/portletImages/"+imageUrl;
                    }
					html += "<img src='"+imageUrl+"'/>";
					html += "<p class='"+active+"'><span>"+portlet.displayName.escapeHTML()+"</span><em class='ico24 "+selectedCss+"'></em></p>";
				}else{
				
				}
				html +="</li>";
			}
		}
		roundItem.html(html);
        roundItem.find("li").click(function () {
        	$(this).find("p em").addClass("selected_32");
        }).mouseenter(function(event) {
            if(!$(this).find("p").hasClass("active")){
                $(this).find("p").addClass('active');
            }   
        }).mouseleave(function(event) {
            if (!$(this).find("p em").hasClass("selected_32")) {
                $(this).find("p").removeClass('active');
            };
        });
	},
    //添加空间到桌面
    addSpaceShortToLayout : function(obj){
        var _o = $(obj).find(".ico24");
        if (_o.hasClass('selected_32')) {
            return;
        };
        $.addShortToLayout(obj);
    },
	//添加快捷到桌面
	addShortToLayout : function(obj){
		var portletBeanId = $(obj).find("input[name='portletBeanId']").val();
		var portletId = $(obj).find("input[name='portletId']").val();
        //过滤已添加的
        if ($(obj).hasClass("selected")) {
        	if(addedPortletList.length == 1){
        		$.alert($.i18n("section.shortcut.min.label",1));
        		return;
        	}
        	var _list = new Array();
        	for(var i=0; i < addedPortletList.length; i++){	
       			if(portletId == addedPortletList[i][0]){
       				continue;
       			}else{
       				addedPortletList[i][2] = i;
       				_list.push(addedPortletList[i]);
       			}
        	}
        	addedPortletList = _list;
        	$(obj).removeClass("selected");
        	$(obj).find("p em").removeClass("selected_32");
        }else{
        	if(addedPortletList.length < 20){
        		$(obj).addClass("selected");
        		$(obj).find("p em").addClass("selected_32");
        		var portletBeanId = $(obj).find("input[name='portletBeanId']").val();
        		var portletId = $(obj).find("input[name='portletId']").val();
        		var param = [];
        		param[0] = portletId;
        		param[1] = portletBeanId;
        		param[2] = addedPortletList.length;
        		addedPortletList.push(param);
        	}else{
        		$.alert($.i18n("section.shortcut.max.label",20));
        		return;
        	}
        };
		
	},
    //快捷库，左侧分类
	metroShortAddDialog_navList : function(option,category) {
	    var p = option;
	    var obj = $("#metroShortAddDialog_navList");
	    obj.html("");
	    var html = '';
	    for (var i = 0; i < p.length; i++) {
	    	var imgName = "desktop_icon.png";
            if(category != "BusinessAppCategory" || p[i][0] == "all"){
                imgName = "desktop_"+p[i][0]+".png";
            }
            html += '<li class="clearFlow" id="'+p[i][0]+'" onclick="$.showCategoryPortlets(\''+p[i][0]+'\')" title="'+p[i][1]+'"><em class="ico24" style="background:url(/seeyon/main/frames/desktop/images/shortcut_sort/'+imgName+') center no-repeat;"></em><span class="t">'+p[i][1]+'</span></li>';
     	}
	    obj.html(html);
	    obj.find("li:first").next().addClass("current");
	},
	//快捷库，分类定位
	showCategoryPortlets : function(cate){
		 
        //如果是all，进行查询初始化
        if(cate == "all"){
            var metroCategory = $("#metroCategory").val();
            initMetroShortcuts(metroCategory);
        }
        
        if ($("#"+cate).hasClass("current")) {
            //点击当前不滚动
            return;
        };
       
        $("#metroShortAddDialog_navList li").removeClass('current');
        $("#"+cate).addClass("current");

        var _objScroll = $(".stadic_content");
        var _objItemPositionTop;
        var _oldTopNum = _objScroll.scrollTop();
        _objScroll.scrollTop(0);
        //没有找到，滚动到顶部
        if ($("#"+ cate +"_item").size() > 0) {
            _objItemPositionTop = $("#"+ cate +"_item").position().top;
            if (cate != "space" && $("#space").size() > 0) { //判断是否含有空间的，加上空间的高度
                _objItemPositionTop += 190; 
            };
        } else {
            _objItemPositionTop = 0;
        };
        _objScroll.scrollTop(_oldTopNum);
        $(".stadic_content").stop(true).animate({scrollTop: _objItemPositionTop}, 500);
	},
	//滚动条
	scrollAuto : function (obj){
		var $scrollAuto;
		if (obj == undefined) {
			$scrollAuto = $(".scrollAuto");
		} else {
			$scrollAuto = obj.find(".scrollAuto");
		}

		$scrollAuto.css("overflow","hidden");
		$scrollAuto.each(function(){
			var tObj = $(this);
			tObj.mouseenter(function() {
				tObj.css("overflow","auto");
			});
			tObj.mouseleave(function() {
				tObj.css("overflow","hidden");
			});
		});
	}

});
function initMetroShortcuts(category,queryParam){
	//重置分类信息
    if(metroCategoryDropdown){
        metroCategoryDropdown.setValue(category);
    }
    //分类信息
    var categoryList = deskMgr.getCategoryList(category);
    categoryMap = {};
    //快捷添加分类信息
    if(categoryList!=null){
        //初始化全局分类
        for(var i=0 ; i<categoryList.length; i++){
            categoryMap[categoryList[i][0]] = categoryList[i][1];
        }
    }

    $(".roundabout_area").hide();
    $("#roundabout").html("");
    // $('#roundabout').data("init",false);

    var param = new Object();
    param['metroCategroy'] = category;
    param['queryParam'] = queryParam;

    var allPortlets = deskMgr.getAllPortletsForSection(param);
    if(allPortlets!=null){
    	var categoryArray = [];
    	categoryArray[0] = [];
    	categoryArray[0][0] = "all";
    	categoryArray[0][1] = $.i18n("desk.category.all");
    	
        var otherPortlets = {};
        for(var i = 0; i < allPortlets.length ; i++){
            var pls = allPortlets[i];
            for(var key in pls){
            var portlets = pls[key];
            categoryArray[i+1] = [];
            categoryArray[i+1][0] = key;
            categoryArray[i+1][1] = categoryMap[key];
            //空间显示与其他有区别
            /* if("space" == key){
                $.metroShortAddDialog_roundItemList(portlets);
                var _objRoundabout = $("#roundabout");
                var _size = _objRoundabout.find("li").size();
                _objRoundabout.width(260 * _size);
            }else{ */
                otherPortlets[key] = portlets;
            /* } */
        }
        }
        /*if(categoryArray.length == 1){
            categoryArray = [];
        }*/
        $.metroShortAddDialog_navList(categoryArray,category);
        //其他portlets初始化
        $.metroShortAddDialog_itemList(otherPortlets);
        
    }
}
//portlet查询
function metroShortcutSearch(){
    var queryParam = $("#metroShortAddDialog_search_textbox").val();
        if("" == queryParam){
            return;
        }
        var metroCategory = $("#metroCategory").val();
        initMetroShortcuts(metroCategory,queryParam);
}
//在数组中删除一个目标元素
function removeArrayData(list,data){
    if(list != null && data != null && list.length > 0){
        for(var i=0; i<list.length; i++){
            var f = list.shift();
            if(f == data){
                return;
            }else{
                list.push(f);
            }
        }
    }
}
function OK(){
	var s = [];
	s[0] = [];
	if(addedPortletList && addedPortletList.length > 0 ){
		for(var i=0; i < addedPortletList.length; i++){
			var sPortlet = addedPortletList[i];
			s[0][i] = sPortlet[0]+"|"+sPortlet[1]+"|"+i;
		}
	}
	return s;
}
</script>
</head>
<body>
	<div class="metroShortAddDialog" style="display:block;width:100%;height:100%;top:0px;left:0px;">
        <div class="stadic_layout">
            <div class="stadic_layout_head stadic_head_height">
                <div class="metroShortAddDialog_search">
                    <span class="metroShortAddDialog_search_nav" style="width:100px">
                        <select id="metroCategory" class="common_drop_down">
                        	<c:forEach items="${metroCategoryList}" var="categroy">
                        		<c:if test="${categroy == 'PortletCategory'}">
		                            <option value="PortletCategory">${ctp:i18n("desk.metro.col")}</option>
                        		</c:if>
                        		<c:if test="${categroy == 'PortletAppCategory'}">
		                            <option value="PortletAppCategory">${ctp:i18n("desk.metro.Integrate")}</option>
                        		</c:if>
                        		<c:if test="${categroy == 'BusinessAppCategory'}">
		                            <option value="BusinessAppCategory">${ctp:i18n("desk.metro.business")}</option>
                        		</c:if>
                        	</c:forEach>
                        </select>
                    </span>
                    <div class="metroShortAddDialog_search_textbox">
                        <span class="ico16" id="metroShortSearch"></span><input id="metroShortAddDialog_search_textbox" type="text" name="name" value="${ctp:i18n('desk.alert.searchtip')}" />
                    </div>
                </div>
            </div>
            <div class="stadic_layout_body stadic_body_top_bottom clearfix" style="top:50px">
                <div class="stadic_right">
                    <div class="stadic_content scrollAuto">
                        <!-- 快捷库 所有 -->
                        <div class="roundabout_area scrollAuto">
                                <ul id="roundabout">
                                    
                                </ul>
                        </div>
                        <div id="metroShortAddDialog_itemList" class="metroShortAddDialog_itemList"></div>
                    </div>
                </div>
                <div class="stadic_left scrollAuto">
                    <!-- 左侧导航 -->
                    <ul id="metroShortAddDialog_navList" class="metroShortAddDialog_navList"></ul>
                </div>
            </div>
        </div>	
    </div>
</body>
</html>