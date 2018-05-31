

$(function () {

	

    //工作桌面分类
    sortTabArea();

    //设置横向滚动宽度
    resize_desktop_body_area();
    
    //兼容ie6高度
    ie6ReSize();
    //绑定快速处理的前一个后一个点击事件
    $.initPrevAndNextClick();

    //快捷添加
    $(".shortcutBlock_more").live("click",function () {
        //快捷库信息
        initMetroShortcuts("PortletCategory");
		//获取容器Id
        var metroShortcutId = $(this).parent(".metroShortcut_box").parent(".metroShortcut").attr("id");
		currentLayoutId = metroShortcutId.substring("metroShortcut".length+1,metroShortcutId.length);
		currentPortletOrder = $(this).parent(".metroShortcut_box").children("div:not(.shortcutBlock_more)").size();
		
        if (getCtpTop().$(window).height() * 1 < 800 ) {
            $(".metroShortAddDialog").css({
                height: 550
            });
        };

        var _top = ($(window).height() - $(".metroShortAddDialog").height() - 50) / 2;
        _top < 0 ? _top = 0 : null;
        $(".metroShortAddDialog").css({
            left: ($(window).width() - 980) / 2,
            top: _top
        });

        //ie8下使用fadeIn会把透明度样式冲掉
        if($.browser.msie){
            if($.browser.version == "8.0"){
                $(".metroShortAddDialog,.metroShortAddDialog_mask").show();
            } else {
                $(".metroShortAddDialog,.metroShortAddDialog_mask").fadeIn();
            }
        } else {
            $(".metroShortAddDialog,.metroShortAddDialog_mask").fadeIn();
        }
        
        metroShortAddDialogShow(true);
    });
    $(".dialogCloseBtn").click(function () {
        $(".metroShortAddDialog,.metroShortAddDialog_mask").fadeOut();
        saveAllPortletSort();
        metroShortAddDialogShow(false);
    });

	$.initSkinDesk();
	$.dragSkinDesk();

	// ie6屏蔽换肤
	if ($.browser.msie) {
		if ($.browser.version < 7) {
			$("#skin").hide();
		};
	};
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
	//初始化 工作桌面显示
	$.desktop_showhide();	
	//设为首页
	$.setHomepage();

	$.scrollAuto();

	//初始化桌面分类
	$.initDeskCate(deskCateList);
	//$.initDeskPending(pendingList);
	//绑定代办列表事件
    /*$(".toDoList li .toDoList_brief").click(function() {
        $(".toDoListDialog").css({
            top : $(this).parents("li").addClass('current').position().top + 28
        }).show();
        var _top = $(this).parent().position().top * 1 + 25;
        $(".toDoListDialog").stop(true).animate({
            width : 590,
            height : 500,
            left : 105,
            top : 28
        }, "fast" ,function () {
            var _toDoListDialog_arrow = $(".toDoListDialog .toDoListDialog_arrow span");
            var _color = "#F2F3FD";
            if (_top >= 35 && _top < 355) {
                _color = "#FFFFFF";
            }
            _toDoListDialog_arrow.css({
                top: _top,
                color: _color
            });
            $(".toDoListDialog").css("overflow","visible");
        });
        
    });*/
    $(".dialogBtn_close").live("click",function () {
        var _top;
        if ($(".toDoList li.currentPending").size() == 1) {
            _top = $(".toDoList li.currentPending").position().top + 28;
        } else {
            _top = 28;
        };
        $(".toDoListDialog").stop(true).animate({
            width : 490,
            height : 110,
            left : 160,
            top : _top
        }, "fast" , function () {
            $(".toDoListDialog").css("overflow","hidden").hide();
            $(".toDoList li").removeClass("currentPending");
        });
    });
    //进入编辑状态
    $("#editBtn").toggle(
        function(){
            portletState = "edit"; 
            $(".close_btn").show();
            $(".tip_number").hide();
           //verification_shortcut();
        },
        function(){
            portletState = "show";
            $(".close_btn").hide();
            $(".tip_number").show();
        }
    );

    //数据轮循启动 10分钟一次
    setInterval("$.initMetroPortlet({shortcutScroll:false,isRefresh:true})",2*60*1000);
    setInterval("$.initDeskPending()",30*1000);

    //退出
    $("#logout").click(function(){
        window.location.href = _ctxPath+"/main.do?method=logout";
    });
    
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

    //换肤控制
    var desk_background_image = getCtpTop().desk_background_image;
    var desktop_background_color = getCtpTop().desktop_background_color;
    if(desktop_background_color){
        skin_init("color", desktop_background_color);
    }else if(desk_background_image){
        skin_init("image", desk_background_image);
    } else {
        skin_init("defalut");
    }
});
function skin_init (showType, str) {
    var _objDesktopBg = $("#desktop_body_bg"); //工作桌面背景
    var _objHomeBg = getCtpTop().$("#layout_header_bg"); //首页头背景
    var _objHomeBgMask = getCtpTop().$("#layout_header_bg_mask"); //首页头背景-遮罩
    if (showType == "image") {	//皮肤为图片
        _objDesktopBg.attr("src", _ctxPath + '/main/skin/desktop/'+skinPathKey+'/skin/' + str).css('background', "");
				$('#bgColorContainer li').empty();
        if (skinPathKeyController()) {
            _objHomeBg.show().attr("src", _ctxPath + '/main/skin/desktop/'+skinPathKey+'/skin/' + str).css('background', "");
            //_objHomeBgMask.show();
        };
    }
    if (showType == "color") {	//皮肤为颜色
        _objDesktopBg.attr("src", _ctxPath + '/main/frames/desktop/images/empty.gif').css('background', str);
        if (skinPathKeyController()) {
            _objHomeBg.show().attr("src", _ctxPath + '/main/frames/desktop/images/empty.gif').css('background', str);
						$("#skin_set .skinImage_list img").css("border", "solid 3px #fff");
            //_objHomeBgMask.show();
        };
    };
    if (showType == "defalut") {	//默认皮肤
        _objDesktopBg.attr("src", _objDesktopBg.attr("defaultsrc"));
        _objHomeBg.attr("src", _objDesktopBg.attr("defaultsrc"));
        if (skinPathKeyController()) {
            _objHomeBg.show();
            //_objHomeBgMask.show();
        } else {
            _objHomeBg.hide();
            _objHomeBgMask.hide();
    }
    };
}
//皮肤控制器---工作桌面换肤，是否遮罩头部
function skinPathKeyController () {
    /*if (skinPathKey == "harmony" || skinPathKey == "wisdom" || skinPathKey == "peaceful" || skinPathKey == "material" || skinPathKey == "morning" || skinPathKey == "tint") {
        return true;
    };
    return false;*/
    return true;
}

/**
 * 快捷库遮罩显示隐藏控制（因为工作桌面为iframe方式引用）
 * @param  true为显示dialog，false为隐藏
 * @return 
 */
function metroShortAddDialogShow (bool) {
    if (bool == true) {
        window.parent.$("#desktopIframe").css("z-index","999999");
        window.parent.$("body").append('<div class="metroShortAddDialog_mask" style="position: absolute;top: 0;left: 0;z-index: 20001;width: 100%;height: 100%;background-color: #000000;opacity: 0.7;filter: alpha(opacity=70);"></div>');
    }
    if (bool == false) {
        window.parent.$("#desktopIframe").css("z-index","");
        window.parent.$(".metroShortAddDialog_mask").remove();
    };
}

function openMetroShortcut(obj){
    var id = obj.id;
    var portletId = obj.portletId;
    var url = obj.portletUrl;
    var urlType = obj.portletUrlType;
    var entityId = obj.entityId;
    if(portletState == "show" && urlType){
    	if(urlType=="space"){
            getCtpTop().showSpace(null,entityId,url,portletId,null,null);
            getCtpTop().$(".return_ioc2").click();
        }else if(urlType == "workspace"){
            var path = _ctxPath + url;
            getCtpTop().showMenu(path,null,null,"main");
            getCtpTop().$(".return_ioc2").click();
           //window.open(_ctxPath + url, "newWindow"); 
        }else if(urlType == "link"){
            window.open(url, new Date().getTime()); 
        }else{
            var path = _ctxPath + url;
            getCtpTop().showMenu(path,null,null,"newWindow");
            //getCtpTop().$(".return_ioc2").click();
        }
    }
    return true;
}

//校验排序
function verification_shortcut() {
    $(".metroShortcut").each(function (index) {
        var areaObj = $(".metroShortcut").eq(index);
        var boxObj = $(".metroShortcut_box").eq(index);
        var areaHeight = areaObj.height();
        var boxHeight = boxObj.height();
        //判断高度是否超出
        try{
        if (boxHeight > areaHeight) {

            if($(".metroShortcut").eq(index * 1 + 1).size()>0){
                areaObj.find(".shortcutBlock").last().hide().prependTo($(".metroShortcut").eq(index * 1 + 1).find(".metroShortcut_box")).fadeIn("slow");
                verification_shortcut();
            }else{
                //最后一个容器填充满的情况下，新增一个新的容器
                var layoutOrder = $("div[id^='metroShortcut_']").size();
                var cateId = currentDeskCateId;
                var param = new Object();
                param['cateId'] = cateId;
                param['layoutOrder'] = layoutOrder;
                deskMgr.saveDeskLayout(param,{
                    success : function(layout) {
                        var html = $.initMetroLayout(layout);
                        $("#desktop_body_area").append(html);
                        $("#desktop_body_area").width(function () {
                            var w = 0;
                            w += $(".toDoList").width();
                            $(".metroShortcut").each(function () {
                                w += $(this).width() + 50;
                            });
                            return w;
                        });
                        //添加拖拽功能
                        portletSortable();
                        areaObj.find(".shortcutBlock").last().hide().prependTo($(".metroShortcut").eq(index * 1 + 1).find(".metroShortcut_box")).fadeIn("slow");
                        verification_shortcut();
                    }
                });
            }
        }

    }
        catch(e){
            //TODO:可能会死循环
            alert(e.message);
        }
    });
}	
//工作桌面分类
function sortTabArea(option) {
	//分类点击操作
    $("#sortTabArea li").live("click", function () {
    	portletState = "show";
        $(".close_btn").hide();
        $(".tip_number").show();
        if ($(this).attr("noclick") != "true") {
        	$("#desktop_stadic_layout_body").scrollLeft(0);//滚动条定位到最左边
            $("#sortTabArea li").removeClass("current");
            $(this).addClass("current");
			var cateId = $(this).children("input[name='cateId']").val();
			if(cateId != null && cateId != ""){
				deskMgr.getDeskData(cateId,{
					success : function(layoutList){
						//赋值标记当前的分类
						currentDeskCateId = cateId;
						//只有第一个分类有待办列表
						if($("#sortTabArea li:first").find("input[name='cateId']").val() != cateId){
							$("#toDoList").hide();
						}else{
							$("#toDoList").show();
						}
						$.initMetroLayoutPortlet(layoutList);	
					}
				});
			}
        }
    });
    //Portlet删除操作
    $(".shortcutBlock").find(".close_btn").live("click",function(){
    	var obj = $(this).parent();
    	var pId = obj.find("input[name='pId']").val();
        var portletId = obj.find("input[name='portletId']").val();
    	if(pId){
    		deskMgr.deletePortlet(pId,{
    			success : function () {
    				$(obj).remove();
    			}
    		});

    	}   	
    });
    //打开编辑功能
    $("#sortTabArea li:not(.addBtn)").live("dblclick", function () {
        $(this).removeClass("text_overflow");
        $(this).addClass("contenteditable");
        $(this).find("span").attr("contenteditable", "true").focus();
        //最常使用不能删除
        if ($(this).index() != 0) {
            $(this).after($('<em class="close_area"><em class="close_btn ico16"></em></em>'));
        }
    });
    //关闭编辑功能
    $(document).click(function (e) {
        if (!$(e.target).parents().hasClass("sortTabArea")) {
            //$("#sortTabArea li").removeAttr("contenteditable");
			$("#sortTabArea .contenteditable").each(function(i,obj){
				var categoryName = $.trim($(obj).children("span").text());
				//var otherCategoryNamesLen = $("#sortTabArea").find(".text_overflow").find("span").length;
				if("" == categoryName){
					alert($.i18n("link.user.errorMessage"));
					$(obj).children("span").attr("contenteditable", "true");
					$("#sortTabArea li.addBtn").show();
					return true;
				}
				if(categoryName.replace(/[\u4E00-\u9FA5]/g, "a").length > 20){
					alert($.i18n("desk.alert.charlimit", 20));
					$(obj).children("span").attr("contenteditable", "true");
					$("#sortTabArea li.addBtn").show();
					return true;
				}
				if(categoryName.match(/[~!&#%\?\$\^\*\(\)<>'"]/g) != null){
					alert($.i18n("link.user.errorMessage"));
					$(obj).children("span").attr("contenteditable", "true");
					$("#sortTabArea li.addBtn").show();
					return true;
				}
				/*if(otherCategoryNamesLen > 0){
					for(var i = 0; i < otherCategoryNamesLen; i++){
						var categoryNameTmp = $("#sortTabArea").find(".text_overflow").find("span")[i];
						if($(categoryNameTmp).html() == categoryName){
							alert($.i18n("desk.alert.namerepeat"));
							$(obj).children("span").attr("contenteditable", "true");
							$("#sortTabArea li.addBtn").show();
							return true;
						}
					}
				}*/
				$(obj).children("span").text(categoryName);
				$(obj).children("input[name='categoryName']").val(categoryName);
				var cateObj = new Object();
				cateObj["cateId"] = $(obj).children("input[name='cateId']").val();
				cateObj["categoryName"] = categoryName;
				cateObj["categoryOrder"] = $(obj).children("input[name='categoryOrder']").val();
				deskMgr.saveDeskCate(cateObj,{
					success : function(cate){
						if(cate){
							$(obj).children("input[name='cateId']").val(cate.id);
							var size = $("#sortTabArea li:not(.addBtn)").size();
							if(size >=4){
 								$("#sortTabArea li.addBtn").hide();
							}
                            $(obj).trigger("click");
						}
					},
					error : function(request,settings,e){
					  alert(e);
					}
				});
				$(obj).removeClass("contenteditable").addClass("text_overflow").find("span").removeAttr("contenteditable");

			});
            $("#sortTabArea .close_area").remove();
        }
    });
    //添加功能
    $("#sortTabArea li.addBtn").click(function () {
        if($("#sortTabArea .contenteditable").size() > 0){
            var _editTxt = $("#sortTabArea .contenteditable :last").children("span").text(); 
            alert($.i18n("desk.alert.savetip",_editTxt));
            return;
        }
        var size = $("#sortTabArea li:not(.addBtn)").size();
		var order = $("#sortTabArea li").size();
        if (size < 4) {
        	if(size == 3){
				$("#sortTabArea li.addBtn").hide();
        	}
            var html = "";
            html += '<li class="newOne"><span>'+$.i18n("desk.alert.newcate")+'</span>';
			html += '<input type="hidden" name="cateId" value="">';
			html += '<input type="hidden" name="categoryName" value="">';
			html += '<input type="hidden" name="categoryOrder" value="'+order+'">';
			html += '</li>';
            $("#sortTabArea li:last").before(html);
            $("#sortTabArea li.newOne").trigger("click");
            $("#sortTabArea li.newOne").trigger("dblclick").removeClass("newOne");
        }
               
    });
    //删除功能
    $("#sortTabArea .close_btn").live("click", function () {
		var obj = $(this).parent(".close_area").prev();
		var cateId = $(obj).children("input[name='cateId']").val();
		if(cateId != null && "" != cateId){
			deskMgr.deleteDeskCate(cateId,{
				success : function(){
                  /*  $(this).parent(".close_area").prev().remove();
					$(this).parent(".close_area").remove();

				    var size = $("#sortTabArea li:not(.addBtn)").size();
					if(size < 4){
						$("#sortTabArea li.addBtn").show();
					}*/
				}
			});
		}
        //else{
			if($(this).parent(".close_area").next(".text_overflow").size()>0){
	            $(this).parent(".close_area").next(".text_overflow").trigger("click");
	        }else{
	            $(obj).prev(".text_overflow").trigger("click");
	        }
            $(obj).remove();
            $(this).parent(".close_area").remove();

			var size = $("#sortTabArea li:not(.addBtn)").size();
			if(size < 4){
				$("#sortTabArea li.addBtn").show();
			}
		//}
       
    });
}

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
//快捷-滚动类型
function scroll_shortcut(obj){
    var __this = $(obj).find(".shortcutBlock_scroll_img");
    var __height = $(__this).parent().height();
    var __n = $(__this).find("img").size();     //总共几张图片
    var __i = 0;    //显示第几个图片

    var ranTime = Math.floor(Math.random() * 15000) + 5000;
    var intval = setInterval(function () {
        __i++;
        if (__i == __n) {
            __i = 0;
        }
        $(__this).animate({ top: __i * __height * -1 }, 800, function () {
            $(__this).parent().find(".shortcutBlock_title").html('<span>' + $(__this).find("img[id='img_" + __i + "']").attr("alt")+'</span>');
        });
    },ranTime);
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

//设置横向滚动宽度
function resize_desktop_body_area() {
    var w = $(".toDoList").width() * 1 + ($(".metroShortcut").width() * 1 + 60) * $(".metroShortcut").size() + 60;
    if (w < $(window).width()) {
        w = $(window).width();
    }
    $("#desktop_body_area").width(w);

    $(window).resize(function () {
        resize_desktop_body_area();
    });
}

function toDoListIframeLoad (obj) {
    if (document.getElementsByClassName) {
        var _obj = obj.contentWindow.document.getElementsByClassName("scrollList");
    } else {
        var _obj = obj.contentWindow.document.getElementById("scrollList");
    }
    if (_obj) {
        if (_obj.length > 0) {
            for (var i = _obj.length - 1; i >= 0; i--) {
                _obj[i].style.overflow = "hidden";
            };
        };
    };
}

jQuery.extend({
	//创建换肤组件
	initSkinDesk:function(){
		var _skinSetHtmlString = "";
		_skinSetHtmlString+='<div id="skin_set" class="skin_set_contaner clearFlow">';

			_skinSetHtmlString+='<div class="skin_set_title">'+$.i18n("desk.skin.title")+'<em id="skin_set_close" class="btn_close"></em></div>';

            _skinSetHtmlString+='<div class="skin_content">';
                _skinSetHtmlString+='<a id="reDesktopSkin" href="javascript:void(0)" class="common_button common_button_gray right margin_t_20">' + $.i18n('portal.skin.recover') + '</a>';
				_skinSetHtmlString+='<div class="skin_content_title">'+$.i18n("desk.skin.bgimg")+'</div>';
				_skinSetHtmlString+='<div class="skinImage_list clearFlow">';
					_skinSetHtmlString+='<img bsrc="desktop_skin1_img.jpg" src="' + _ctxPath + '/main/skin/desktop/'+skinPathKey+'/skin/desktop_skin1.jpg">';
					_skinSetHtmlString+='<img bsrc="desktop_skin2_img.jpg" src="' + _ctxPath + '/main/skin/desktop/'+skinPathKey+'/skin/desktop_skin2.jpg">';
					_skinSetHtmlString+='<img bsrc="desktop_skin3_img.jpg" style="margin-right:0px;" src="' + _ctxPath + '/main/skin/desktop/'+skinPathKey+'/skin/desktop_skin3.jpg">';
					_skinSetHtmlString+='<img bsrc="desktop_skin4_img.jpg" src="' + _ctxPath + '/main/skin/desktop/'+skinPathKey+'/skin/desktop_skin4.jpg">';
					_skinSetHtmlString+='<img bsrc="desktop_skin5_img.jpg" src="' + _ctxPath + '/main/skin/desktop/'+skinPathKey+'/skin/desktop_skin5.jpg">';
					_skinSetHtmlString+='<img bsrc="desktop_skin6_img.jpg" style="margin-right:0px;" src="' + _ctxPath + '/main/skin/desktop/'+skinPathKey+'/skin/desktop_skin6.jpg">';
				_skinSetHtmlString+='</div>';
				_skinSetHtmlString+='<div class="skin_content_title">'+$.i18n("desk.skin.bgcolor")+'</div>';
				_skinSetHtmlString+='<div class="bg_color_skin">';
					_skinSetHtmlString+='<ul id="bgColorContainer" class="skinColor_list clearFlow"></ul>';
					_skinSetHtmlString+='<ul id="modelListContainer" class="model_list clearFlow"></ul>';
				_skinSetHtmlString+='</div>';
			_skinSetHtmlString+='</div>';
		_skinSetHtmlString+='</div>';
		$('body').prepend(_skinSetHtmlString);
		var desk_background_image = getCtpTop().desk_background_image;
		if(desk_background_image==undefined){
			desk_background_image=_ctxPath+"/main/skin/desktop/harmony/images/skin/desktop_default.jpg";
		};
		$("#skin_set .skinImage_list img").each(function(index, element) {
			var PageBgSrc = desk_background_image.split('/').slice( - 1).join("").split("_")[0] + "_" + desk_background_image.split('/').slice( - 1).join("").split("_")[1];
			var NowBgSrc = $(this).prop("src").split('/').slice( - 1).join("").split(".")[0];
			if (PageBgSrc == NowBgSrc) {
				$("#skin_set .skinImage_list img").eq(index).css("border", "solid 3px #00cf78");
			}
		});
		//图片面板
		$("#skin_set .skinImage_list img").click(function (argument) {
			$(this).css("border", "solid 3px #00cf78").siblings("img").css("border", "solid 3px #fff"); //当前选中图片加边框
			$('.ok').remove();
			var strDesktopBgImgSrc = $(this).attr("bsrc");
            skin_init("image", strDesktopBgImgSrc);
            if(strDesktopBgImgSrc){
                //异步保存背景图
                strDesktopBgImgSrc = strDesktopBgImgSrc;
                setCustomize("desk_background_image",strDesktopBgImgSrc);
                getCtpTop().desk_background_image = strDesktopBgImgSrc;
                setCustomize("desktop_background_color",null);
                getCtpTop().desktop_background_color = null;
            }
		});
        $("#reDesktopSkin").click(function() {
						$("#skin_set .skinImage_list img").css("border", "solid 3px #fff");
            setCustomize("desktop_background_color",null);
            setCustomize("desk_background_image",null);
            getCtpTop().desktop_background_color = null;
            getCtpTop().desk_background_image = null;
            skin_init("defalut");
        });
		// 颜色面板
		var _colorData = {'currentList':11,'currentColor':3,"list":[{
			'model':'#303030',
			'list':["#071111","#1f2627","#353c3d","#4b5354","#636b6c","#7c8485","#0a1011","#1e2223","#323637","#454b4c","#5c6162","#727878","#000000","#1d1d1d","#252525","#3c3c3c","#525252","#6b6b6b"]
		},{
			'model':'#777777',
			'list':["#1b1918","#363432","#474342","#575451","#696663","#7b7875","#0e0e0c","#1e1e1d","#312f2e","#434241","#565554","#6b6b6b","#000000","#1d1d1d","#252525","#3c3c3c","#525252","#6a6968"]
		},{
			'model':'#da0025',
			'list':["#6e0012","#8d0017","#ad001d","#cf0023","#f10025","#ff2c37","#54001d","#710025","#8e0032","#ad2a3f","#cd484a","#eb6360","#43001c","#5e1129","#792a38","#964449","#b45d59","#d17670"]
		},{
			'model':'#f01800',
			'list':["#4f0006","#6d0004","#8c0001","#ac0000","#cd0000","#ef0000","#380003","#510000","#6e0000","#8b1202","#a9331a","#c84e31","#290002","#3f0200","#591b0b","#733220","#8f4a37","#ac634e"]
		},{
			'model':'#ff4300',
			'list':["#660003","#850000","#a40000","#c50000","#e61f00","#ff4608","#500000","#6c0000","#891700","#a73511","#c65129","#e56b41","#3c0600","#561e0a","#703420","#8c4c36","#a8654d","#c57f65"]
		},{
			'model':'#fd6c05',
			'list':["#740000","#920000","#b22600","#d34500","#f26000","#ff7c1c","#5f1300","#7b2c00","#984512","#b65e2b","#d37742","#f2925c","#4f2307","#69391e","#845134","#a06a4c","#bc8363","#d99e7d"]
		},{
			'model':'#feab07',
			'list':["#713400","#8f4c00","#ad6500","#cb7e00","#eb9900","#ffb317","#4d2600","#683b00","#835300","#a06c13","#bc852f","#da9f49","#472900","#5f3f0b","#7a5723","#96703b","#b18952","#cea36c"]
		},{
			'model':'#ffc91e',
			'list':["#653d00","#825400","#a06d00","#bd8600","#dca000","#ffbf00","#452a00","#5f4000","#7a5800","#977008","#b38928","#d0a444","#412c00","#5a4206","#745a20","#8f7338","#aa8c50","#c7a669"]
		},{
			'model':'#93c900',
			'list':["#002800","#003c00","#005500","#1f6e00","#418700","#5ea200","#002300","#173800","#304f00","#496700","#638118","#7d9b34","#122000","#273503","#3d4b1b","#556332","#6f7d49","#889661"]
		},{
			'model':'#54c300',
			'list':["#003f00","#005700","#007200","#008c00","#30a700","#54c300","#003a00","#1d5100","#386a00","#52841b","#6c9e36","#87ba51","#1f3605","#354d1c","#4d6533","#667f4b","#7f9863","#9ab47c"]
		},{
			'model':'#00ab62',
			'list':["#002900","#004117","#00592c","#007443","#00905b","#00ab60","#00270e","#003c23","#005338","#006d4f","#248768","#44a177","#002215","#0a3829","#234e3f","#3b6756","#54816f","#6d9b83"]
		},{
			'model':'#00c3c4',
			'list':["#002a2f","#003f45","#00585c","#007275","#008d8f","#00a8a9","#002526","#003a3c","#005252","#006b6b","#258584","#449f9e","#002122","#0a3736","#244d4d","#3c6665","#557f7e","#6e9998"]
		},{
			'model':'#009bf0',
			'list':["#002568","#003981","#00509b","#0068b7","#0082d4","#009bf0","#002149","#003661","#004c7a","#1e6494","#407eaf","#5c97ca","#001f36","#12334d","#2b4964","#44627e","#5e7b98","#7794b3"]
		},{
			'model':'#006afe',
			'list':["#000079","#001b95","#002db0","#0041cb","#0058e9","#006aff","#00004a","#001963","#002d7c","#234296","#435ab2","#596cc7","#00002e","#091a45","#232e5c","#3b4475","#555b8f","#686ea3"]
		},{
			'model':'#3f00dd',
			'list':["#00006f","#000084","#1e0098","#3b0dad","#5424c3","#6c39d9","#0f003e","#180052","#2f1763","#422776","#56398a","#6b4b9f","#100025","#1d1035","#2e1f47","#3f2f59","#52416c","#655380"]
		},{
			'model':'#9025ff',
			'list':["#2a0075","#490090","#6700ab","#8500c7","#a400e4","#bf00ff","#260048","#3d0060","#57007a","#711993","#8d37af","#a74fc8","#20002d","#320543","#491d5b","#623373","#7c4c8e","#9462a6"]
		},{
			'model':'#ff3ec2',
			'list':["#7f0023","#9e0038","#bd004d","#dd0065","#ff007f","#ff3e98","#5f0023","#7c0039","#98204f","#b53e67","#d45b81","#f1759a","#4a0c24","#64263a","#7e3d50","#995668","#b77083","#d1899b"]
		},{
			'model':'#fe0b6b',
			'list':["#6f0036","#8d004d","#ab0064","#ca007e","#ea0098","#ff21b3","#55002d","#700043","#8c005a","#a92673","#c6468d","#e461a7","#430027","#5d0d3d","#762953","#92426c","#ae5c86","#ca75a0"]
		}]};
		var _recommend = "recommend1";
		var _currentList = _colorData.currentList;
		var _currentColor = _colorData.currentColor;
		var _currentMap;
		var _modelListContainerString = "";
		var sRgb = "";
		var ColorPanelIndex1 = ColorPanelIndex2 = "";
		var sRgb = getCtpTop().desktop_background_color;
		var _modelListContainer = $('#modelListContainer');
		if (sRgb==""||sRgb==undefined) {	//服务端未返回当前皮肤颜色时
			$(_colorData.list).each(function(index) {
				var _temp = _colorData.list[index];
				var _tempModel = _temp.model;
				_modelListContainerString += "<li index='" + index + "' style='border:1px solid " + (_currentList == index ? '#fff': _tempModel) + ";background:" + _tempModel + "' class='modelItem " + (_currentList == index ? 'currentMap': '') + "'></li>";
				if (index == _currentList) {
					_currentMap = _temp;
				}
			});
			_modelListContainer.append(_modelListContainerString);
		} else {	//服务端已存储了皮肤颜色时
			var sHexColor = rgb2hex(sRgb);
			for (var i = 0; i < _colorData.list.length; i++) {
				for (var j = 0; j < _colorData.list[i].list.length; j++) {
					if (_colorData.list[i].list[j] == sHexColor) {
						ColorPanelIndex1 = i;
						ColorPanelIndex2 = j;
						break;
					}
				}
				if (ColorPanelIndex1 != "" && ColorPanelIndex2 != "") break;
			};
			$(_colorData.list).each(function(index) {
				var _temp = _colorData.list[index];
				var _tempModel = _temp.model;
				_modelListContainerString += "<li index='" + index + "' style='border:1px solid " + (ColorPanelIndex1 == index ? '#fff': _tempModel) + ";background:" + _tempModel + "' class='modelItem " + (ColorPanelIndex1 == index ? 'currentMap': '') + "'></li>";
				if (index == ColorPanelIndex1) {
					_currentMap = _temp;
				}
			});
			_modelListContainer.append(_modelListContainerString);
		}
		
		//高亮当前皮肤颜色
		function createBgColorSkin(_currentMap) {
			var _bgColorContainer = $('#bgColorContainer');
			var _bgColorContainerString = "";
			_bgColorContainer.empty();
			var _tempList = _currentMap.list;
			$(_tempList).each(function(i) {
				_bgColorContainerString += "<li index='" + i + "' style='background:" + _tempList[i] + "' class='colorItem'"+"title='"+ _tempList[i]+"'>"+(i==ColorPanelIndex2?'<div class="ok"></div>':'')+"</li>";
			});
			_bgColorContainer.append(_bgColorContainerString);
			$('.colorItem').click(function() {
				$('.ok').remove();
				$("#skin_set .skinImage_list img").css("border", "solid 3px #fff");
				$(this).append("<div class='ok'></div>");
				var _bgc = $(this).css('background-color');
				skin_init("color", _bgc)

				//异步保存背景图
				setCustomize("desktop_background_color", _bgc);
				getCtpTop().desktop_background_color = _bgc;
			});
		}
		createBgColorSkin(_currentMap);
		$('.modelItem').mouseenter(function() {
			if ($(this).hasClass('currentMap')) return;
			$(this).css('border-color', "#ffffff");
		}).mouseleave(function() {
			if ($(this).hasClass('currentMap')) return;
			var _bgc = $(this).css('background-color');
			$(this).css('border-color', _bgc);
		}).click(function() {
			var _index = parseInt($(this).attr('index'));
			_currentMap = _colorData.list[_index];
			createBgColorSkin(_currentMap);
			var _ss = this;
			$('.modelItem').each(function() {
				if (this != _ss) {
					var _bgc = $(this).css('background-color');
					$(this).css('border-color', _bgc);
				}else{
					$('#bgColorContainer li').eq(ColorPanelIndex2).empty().append("<div class='ok'></div>");
				}
			});
			$('.modelItem').removeClass("currentMap");
			$(this).addClass("currentMap");
			$('#bgColorContainer li').find(".ok").remove();
		});
		// 关闭按钮
		$('#skin_set_close').click(function(){
			$('#skin_set_iframe').hide();
			$('#skin_set').hide('fast');
		});
	},
	//初始化换肤组件
	dragSkinDesk:function(){
		$('#skin').click(function(){
			if($('#skin_set').size()==0){
				$.initSkinDesk();
			}
			$('#skin_set').show('fast',function(){
				$('#skin_set_iframe').height($('#skin_set').height()).show();
			});
		});
	},
	//分类初始化
	initDeskCate : function (deskCateList){
		if(deskCateList!=null){
			var html = "";
			for(var i=0; i<deskCateList.length; i++){
				var deskCate = deskCateList[i];
				var _categoryName = $.i18n(deskCate.categoryName) || deskCate.categoryName;
				html += '<li class="text_overflow" title="'+_categoryName+'"><span>'+_categoryName+'</span>';
				html += '<input type="hidden" name="cateId" value="'+deskCate.id+'">';
				html += '<input type="hidden" name="categoryName" value="'+deskCate.categoryName+'">';
				html += '<input type="hidden" name="categoryOrder" value="'+deskCate.categoryOrder+'">';
				html += '</li>';
			}
			$("#sortTabArea li:last").before(html);
			$("#sortTabArea li:first").trigger("click");
			if(deskCateList.length >= 4){
                $(".addBtn").hide();
            }
		}
	},
	//初始化容器及栏目边框
	initMetroLayoutPortlet : function(layoutList){
		if(layoutList != null){
			var html = "";
			for(var i=0; i<layoutList.length; i++){
				var layout = layoutList[i];
				html += $.initMetroLayout(layout);
			}
			$(".metroShortcut").remove();
			$("#desktop_body_area").append(html);
		}
		//初始化Portlet内容数据
		$.initMetroPortlet();
	    //设置横向滚动宽度
		resize_desktop_body_area();
        //添加拖拽功能
        portletSortable();
	},
	initMetroLayout : function (layout) {
		var html = '';
		html += '<div id="metroShortcut_'+layout.id+'" class="metroShortcut">';
		html += '<div class="metroShortcut_box">';
			var portletList = layout.portletList;
			if(portletList!=null && portletList.length > 0){
				for(var j=0; j<portletList.length; j++){
					var portlet = portletList[j];
					if(portlet.portletSize == 1){
						portlet.portletSize += " shortcutBlock_scroll";
					}
					html += '<div id="portlet_' + portlet.id + '" class="shortcutBlock shortcutBlock_size'+portlet.portletSize +'">';
                    html += '<em class="close_btn ico24"></em>';
					html += '<div class="tip_number hidden"></div>';
					html += '<input type="hidden" name="pId" value="'+portlet.id+'">';
					html += '<input type="hidden" name="portletId" value="'+portlet.portletId+'">';
					html += '<input type="hidden" name="portletBeanId" value="'+portlet.portletBeanId+'">';
					html += '<input type="hidden" name="portletSize" value="'+portlet.portletSize+'">';
					html += '<input type="hidden" name="portletOrder" value="'+portlet.portletOrder+'">';
					html += '</div>';
				}
			}
		html += '</div>';
		html += '</div>';
		return html;
	},
	//初始化Portlet内容数据
	initMetroPortlet : function(option){
        if (option == undefined) {
            var option = {};
        };
		$("div[id^='portlet_']").each(function(i,obj){
			$.initPortlet(obj, option.shortcutScroll,option.isRefresh);
		});
        //追加快捷添加按钮
        var shortcutmoreHtml = '<div class="shortcutBlock shortcutBlock_size0 shortcutBlock_more"><p class="shortcutBlock_title">' + $.i18n('desk.btn.addshortcut') + '</p></div>';
        $(".metroShortcut_box").find(".shortcutBlock_more").remove();
        if($("div[id^='portlet_'] :last").size()>0){
            $("div[id^='portlet_'] :last").after(shortcutmoreHtml);
        }else{
            $(".metroShortcut_box:first").append(shortcutmoreHtml);
        }
        verification_shortcut();
	},
	//Portlet获取或更新数据
	initPortlet : function(obj, shortcutScroll,isRefresh){
		var portletBeanId = $(obj).find("input[name='portletBeanId']").val();
		var portletId = $(obj).find("input[name='portletId']").val();
        //标记是否对portlet进行刷新
        var needConnect = false;
        if(isRefresh){

           for(var i = 0; i < refreshPortletArray.length ; i++){
                if(portletId == refreshPortletArray[i]){
                    needConnect = true;
                    break;
                }
           }
        }else{
            needConnect = true;
        }
        if(needConnect){
    		var param = new Object();
    		param['portletBeanId'] = portletBeanId;
    		param['portletId']=portletId;
    		var portlet = new portletManager().getData(param);
    		//发文拟文,签报拟文不支持非IE浏览器
			if(!$.browser.msie && ( portletId == "edocSendNewPortlet" || portletId == "edocSignNewPortlet" )){
				$(obj).remove();
			}else{
				if(portlet){
					var imageLayouts = portlet.imageLayouts;
					if(imageLayouts != null && imageLayouts.length > 0){
						if(imageLayouts.length == 1){
						  var imageUrl = portlet.imageLayouts[0].imageUrl;
						  var isDefault= true;
						  if(imageUrl.indexOf("/")>=0){
							  imageUrl = _ctxPath+imageUrl;
							  isDefault= false;
						  }else{
							  imageUrl = _ctxPath+"/main/skin/desktop/"+getCtpTop().skinPathKey+"/portletImages/"+imageUrl;
						  }
						  if(portlet.size != 1){
							  if(isDefault){
								  $(obj).css("background","url("+imageUrl+") left -15px");
							  }else{
								  $(obj).remove("img").append("<img src='" +imageUrl+ "' width='135' height='155' border='0'>");
							  }
						  }
						  portlet.displayName = portlet.displayName.escapeHTML();
						  if(portlet.size == 1){
							  portlet.displayName = '<span title="'+portlet.displayName+'">' + portlet.displayName + '</span>';
						  }
						  $(obj).find(".shortcutBlock_title").remove();
						  if(portlet.size == 1){
							  $(obj).append('<div class="shortcutBlock_title"><span class="c text_overflow">' + portlet.displayName + '</span></div>');
						  }else{
							  $(obj).append('<div class="shortcutBlock_title"><span class="c text_overflow" title="'+portlet.displayName+'">' + portlet.displayName + '</span></div>');
						  }
						  if(portlet.size == 1){
							  $(obj).find(".shortcutBlock_title_bg").remove();
							  $(obj).append('<div class="shortcutBlock_title_bg">&nbsp;</div>');
						  };
						  if(portlet.size == 1){
							  $(obj).remove("img").append("<img src='" +imageUrl+ "' width='280' height='155' border='0'>");
						  }
						}else{
							$(obj).addClass("shortcutBlock_scroll");
							var html = '<div class="shortcutBlock_scroll_img">';
							for(var i=0; i < imageLayouts.length; i++){
                                var imageUrl = portlet.imageLayouts[i].imageUrl;
                                if(imageUrl.indexOf("/")>=0){
                                    imageUrl = _ctxPath+imageUrl;
                                }else{
                                    imageUrl = _ctxPath+"/main/skin/desktop/"+getCtpTop().skinPathKey+"/portletImages/"+imageUrl;
                                }
								html += '<img id="img_'+i+'" src="'+imageUrl+'" alt="'+imageLayouts[i].imageTitle.escapeHTML()+'" />';
							}
							html +=	 '</div>';
                            html +=  '<div class="shortcutBlock_title"><span class="c">' + imageLayouts[0].imageTitle.escapeHTML() + '</span></div>';
                    		html +=  '<div class="shortcutBlock_title_bg">&nbsp;</div>';
                            $(obj).find(".shortcutBlock_scroll_img").remove();
                            $(obj).find(".shortcutBlock_title").remove();
                            $(obj).find(".shortcutBlock_title_bg").remove();
                    		$(obj).append(html);
          					//初始化Portlet滚动内容
                            if (shortcutScroll != false) {
                                scroll_shortcut(obj);
                            };
						}
                        new portletManager().getDataCount(param,{
                            success : function(dataCount){
                                if(dataCount > 0){
                                    $(obj).find(".tip_number").removeClass("tip_number1 tip_number2 tip_number3").addClass("tip_number" + (dataCount + "").length).html((dataCount + "").length == 3? "99+":dataCount).show();
                                }
                                if (dateCount = 0) {
                                    $(obj).find(".tip_number").hide();
                                };
                            }
                        });
                        $(obj).data('clickFun',function(){
                            var id =$(this).attr('id');
                            openMetroShortcut(portlet); 
                        });
						$(obj).unbind("click").click(function(){
                            $(this).data('clickFun')();
						});
					}
				}else{
                    //TODO移除无数据的portlet
                    $(obj).remove();
                }
			}
        }
	},
	//初始化待办列表
	initDeskPending : function (pendingList){
        if(pendingList == null){
            pendingList = new deskCollaborationManager().getCollaborationList(dataCount);
        }
		var html = "";
		if(pendingList != null && pendingList.data.length > 0){
			var data = pendingList.data;
			for(var i=0 ; i < data.length; i++){
				var pending = data[i];
				var pendingId = pending.id;
				var pendingType = pending.moduleType;
				var pendingSender = pending.startMember;
				var pendingSenderUrl = pending.avatarImgUrl;
				var pendingSubject = pending.subject;
				var summaryId = pending.summaryId;
				var subApp = pending.subAppId;
				var rightId = pending.rightId;
				var objectId = pending.objectId;
				var subObjectId = pending.subObjectId;
				var templateId = pending.templateId;
				var content = $(pending.content).text();
				//去掉css
				content = content.replace(/\s*\S+\s*\{\s*\S+\s*:\s*\S+\s*(;\s*\S+\s*:\s*\S+\s*)*\}\s*/g, "");				
				if(content && content.length > 99){
					content = content.substring(0,99);
				}
				html += '<li>';
				html += '<div class="toDoList_pic" id="'+pendingId+'_'+pendingSender+'" ><img src="'+pendingSenderUrl+'"/>';
				html += '<div class="toDoList_pic_mask"></div>';
				html += '</div>';
				
                html += '<div class="toDoList_type"><em class="desktop_icon32 toDoList_type32_'+pendingType+'" /></em></div>';
                html += '<div class="toDoList_brief" id="pendingData_'+pendingId+'" onclick="$.initPendingData(this)">';
                html += '<input type="hidden" name="pendingId" value="'+pendingId+'">';
                html += '<input type="hidden" name="summaryId" value="'+summaryId+'">';
                html += '<input type="hidden" name="pendingType" value="'+pendingType+'">';
                html += '<input type="hidden" name="subApp" value="'+subApp+'">';
                html += '<input type="hidden" name="rightId" value="'+rightId+'">';
                html += '<input type="hidden" name="objectId" value="'+objectId+'">';
                html += '<input type="hidden" name="pendingSender" value="'+pendingSender+'">';
                html += '<input type="hidden" name="subObjectId" value="'+subObjectId+'">';
                html += '<input type="hidden" name="templateId" value="'+templateId+'">';
                html += '<span class="toDoList_arrow"><span>◆</span></span>';
                html += '<div class="t">'+ escapeStringToHTML(pendingSubject) +'</div>';
                html += '<div class="c">'+ (content == null ? "" : escapeStringToHTML(content)) +'</div>';
                html += '</div>';
				
				html += '</li>';
			}
			$(".chuli_area_num").text(pendingList.total);
			$(".toDoList_bg").css("background","");
            //###特殊处理###,IE7下$(".toDoList_bg").css("background",""),会把backgroud设置为none，而不是把style里面的设置清空
            if($.browser.msie) {
                if($.browser.version < 8) {
                    $(".toDoList_bg").attr("style","")
                }
            }
		}else{
			$(".chuli_area_num").text(0);
			$(".toDoList_bg").css("background","url(/seeyon/main/skin/desktop/harmony/images/toDoList_empty_bg.jpg) center bottom no-repeat");
		}       

		$("#pendingList").html(html);
		$(".toDoList_pic").each(function(i,obj){
            var _memberId = $(obj).attr("id").split("_")[1];
            $(obj).PeopleCardMini({memberId:_memberId});
        });
	},
	initPendingData : function(obj){
        var _width = $("body").width();
        var _height = $("body").height();
		$(obj).parent().addClass("currentPending");
		//待办标题
		var title = $(obj).find(".t").text();
		var attNum = null;
		var pendingId = $(obj).find("input[name='pendingId']").val();
		var summaryId = $(obj).find("input[name='summaryId']").val();
        var pendingType = $(obj).find("input[name='pendingType']").val();
        var subApp = $(obj).find("input[name='subApp']").val();
        var rightId = $(obj).find("input[name='rightId']").val();
        var objectId = $(obj).find("input[name='objectId']").val();
        var pendingSender = $(obj).find("input[name='pendingSender']").val();
        var subObjectId = $(obj).find("input[name='subObjectId']").val();
        var templateId = $(obj).find("input[name='templateId']").val();

        //提交前判断流程是否被撤销
        var result = checkAffair(pendingId,pendingType);
        if(!result){
            return;
        }

        //异步获取待处理数据
        var param = new Object();
        param["affairId"] = pendingId;
        param["summaryId"] = summaryId;
        param["app"] = pendingType;
        param["subApp"] = subApp;
        param["rightId"] = rightId;
        param["objectId"] = objectId;
        param["sender"] = pendingSender;
        param["subObjectId"] = subObjectId;
        param["templateId"] = templateId;
        new portletManager().getCollaboration(param,{
            success : function(collaborationInfo){
                if(collaborationInfo){
                    var clickUrl = _ctxPath + collaborationInfo.clickUrl;
                    var url = _ctxPath + collaborationInfo.contentUrl;
                    var showComment = collaborationInfo.showComment;
                    var comment = collaborationInfo.comment;
                    var attitudes = collaborationInfo.attitudes;
                    var _attitude = collaborationInfo.attitude;
                    var submitBtnText = collaborationInfo.submitBtnText == null ? $.i18n("desk.btn.submit") : collaborationInfo.submitBtnText;
                    var attNum = collaborationInfo.attSize;
                    var showSubmitBtn = collaborationInfo.showSubmitBtn;
                    var attdocNum = collaborationInfo.attDocSize;
                    
                    if(showComment == null || !showComment){
                        checkAndOpen(pendingId,clickUrl,"","",pendingType,this);
                        $(".toDoListDialog").hide();
                        return;
                    }

                    if(pendingType == "1"){//协同
                        _width = "560px";
                        _height = "268px";
                    }else if(pendingType == "6"){//会议通知
                    	_width = "560px";
                        _height = "268px";
                    }else if(pendingType == "7"){//公告
                    	_width = "560px";
                        _height = "268px";
                    }else if(pendingType == "8"){//新闻
                    	_width = "560px";
                        _height = "268px";
                    }else if(pendingType == "10"){//调查
                    	_width = "560px";
                        _height = "268px";
                    }else if(pendingType == "29"){//会议室
                    	_width = "560px";
                        _height = "268px";
                    }else if(pendingType == "19"||pendingType == "20"||pendingType == "21"){//发文，收文，签报
                    	_width = "560px";
                        _height = "268px";
                    }else if(pendingType == "24"){//收文登记
                    	_width = "560px";
                        _height = "368px";
                    }
                    
                    var html = '';
                    html += '<div class="stadic_layout">';
                    html += '<div class="stadic_layout_head stadic_head_height">';

                    html += '<span class="toDoListDialog_arrow"><span>◆</span></span>';
                    html += '<div class="toDoListDialog_title">';
                    html += '<div class="left">'+ escapeStringToHTML(title) +'</div>';
                    html += '<div class="right">';
                    html += '<span id="todoList_prev" class="todoList_prev_36"></span>';
                    html += '<span id="todoList_next" class="todoList_next_36 margin_l_10"></span>';
                    html += '</div>';
                    html += '</div>';
                    html += '<em class="dialogBtn_close"></em>';
                    html += '</div>';
                    html += '<div class="stadic_layout_body stadic_body_top_bottom">';
                    html += '<div class="toDoListDialog_content_mask"  id="toDoListDialogMask" ></div>';
                    html += '<div class="toDoListDialog_content" style="width:560px;height:268px;overflow:hidden" >';
                    //待办正文
                    html += '<iframe width="'+_width+'" height="'+_height+'" readonly="true" scrolling="no" frameborder="0" hsrc="'+url+'" onload="toDoListIframeLoad(this)"></iframe>';
                    html += '</div>';
                    
                    html += '<div class="attachment_area">';
                    if(attNum){
                        html += '<em class="ico16 affix_16"></em>('+attNum+')';
                    }
                    if(attdocNum){
                        html += '<span class="ico16 associated_document_16"></span>('+attdocNum+')';
                    }
                    html +='</div>';
                    
                    html += '</div>';
                    html += '<div class="stadic_layout_footer stadic_footer_height">';

                    //意见处理start
                    html += '<div class="toDoListDialog_deal">';
                    if(showComment&&showComment==true){
                        if(comment == null){
                            comment = "";
                        }
                        html += '<input id="comment" class="toDoListDialog_comment" type="text" value="'+comment+'" />';
                    }
                    
                    html += '<div class="clearFlow margin_t_10">';
                    html += '<div class="common_radio_box left margin_t_10">';
                    if(attitudes){
                        for(var i = 0; i < attitudes.length; i++){
                            var attitude = attitudes[i];
                            var checkedStr = "";
                            if(_attitude == null && i==0){
                                checkedStr = "checked = \"checked\"";
                            }
                            for(var key in attitude){
                            	if(_attitude != null && _attitude == key){
                            		checkedStr = "checked = \"checked\"";
                            	}
                                html += '<label for="radio'+i+'" class="margin_r_10 hand">';
                                html += '<input type="radio" value="'+key+'" id="radio'+i+'" name="attitude" class="radio_com" '+checkedStr+' >'+attitude[key]+'</label>';
                            }
                        }
                    }
                    
                  /*  html += '<label for="radio1" class="margin_r_10 hand">';
                    html += '<input type="radio" value="0" id="radio1" name="attitude" class="radio_com" checked="checked">已阅</label>';
                    html += '<label for="radio2" class="margin_r_10 hand">';
                    html += '<input type="radio" value="1" id="radio2" name="attitude" class="radio_com">同意</label>';
                    html += '<label for="radio3" class="margin_r_10 hand">';
                    html += '<input type="radio" value="2" id="radio3" name="attitude" class="radio_com">不同意</label>';*/
                    html += '</div>';
                    html += '<input type="hidden" id="affairId" value="'+pendingId+'">';
                    html += '<input type="hidden" id="summaryId" value="'+summaryId+'">';
                    html += '<input type="hidden" id="app" value="'+pendingType+'">';
                    html += '<input type="hidden" id="subApp" value="'+subApp+'">';
                    html += '<input type="hidden" id="objectId" value="'+objectId+'">';
                    html += '<input type="hidden" id="subObjectId" value="'+subObjectId+'">';
                    if(showSubmitBtn&&showSubmitBtn!=false){
                        html += '<span class="deal_btn right" id="dealColbtn">'+submitBtnText+'</span>';
                    }
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                    //意见处理end

                    html += '</div>';

                    var _frame = $(".toDoListDialog").find("iframe")[0];
                    if(_frame){
                        _frame.contentWindow.document.write('');
                        _frame.contentWindow.close();//避免iframe内存泄漏
                    }
                    $(".toDoListDialog").empty().html(html).show().animate({ 
                        width : '590',
                        height : '500',
                        left : '105',
                        top : '28'
                        },function(){
                            $(".toDoListDialog").css("overflow","visible");
                            var _objIframe = $(".toDoListDialog iframe");
                            _objIframe.attr("src", _objIframe.attr("hsrc"));

                        });
                    
                    //没有意见处理状态，样式修改
                    if(!showComment){
                        $(".toDoListDialog").find(".stadic_layout_body").css({bottom: 0})
                        .end().find(".toDoListDialog_content,iframe").css({height:"443px"})
                        .end().find(".stadic_layout_footer").hide();
                    }
                    //小箭头定位
                    var _top = $(obj).position().top * 1 + 25
                    var _toDoListDialog_arrow = $(".toDoListDialog .toDoListDialog_arrow span");
                    var _color = "#F2F3FD";
                    if (_top >= 35 && _top < 355) {
                        _color = "#FFFFFF";
                    }
                    _toDoListDialog_arrow.css({
                        top: _top,
                        color: _color
                    });

                    $("#toDoListDialogMask").click(function(){
                        checkAndOpen(pendingId,clickUrl,"","",pendingType,this);
                        $(".toDoListDialog").hide();
                    });
                    $("#dealColbtn").click(function(){
                        var affairId = $("#affairId").val();
                        var summaryId = $("#summaryId").val();
                        var app = $("#app").val();
                        var subApp = $("#subApp").val();
                        var objectId = $("#objectId").val();
                        var subObjectId = $("#subObjectId").val();
                        var attitude = $(":radio[name='attitude']:checked").val();
                        var comment = $("#comment").val();
                        var param = new Object();
                        param['affairId'] = affairId;
                        param['summaryId'] = summaryId;
                        param['app'] = app;
                        param['subApp'] = subApp;
                        param['objectId'] = objectId;
                        param['subObjectId'] = subObjectId;
                        if(comment){
                            param['comment'] = comment;
                        }
                        if(attitude){
                            param['attitude'] = attitude;
                        }
                        //提交前判断流程是否被撤销
                        var result = checkAffair(affairId,app);
                        if(!result){
                            return;
                        }
                        //前台提交
                        new portletManager().finishWorkitemQuick(param,{
                            success : function(){
                                //alert($.i18n("desk.alert.submitsuccess"));
                                $(".toDoListDialog").hide();
                                var _frame = $(".toDoListDialog").find("iframe")[0];
                                if(_frame){
                                    _frame.contentWindow.document.write('');
                                    _frame.contentWindow.close();//避免iframe内存泄漏
                                }
                                $(".toDoListDialog").html("");
                                var pendingList = new deskCollaborationManager().getCollaborationList(dataCount);
                                $.initDeskPending(pendingList);
                            },
                            error : function(msg){
                                if(msg && msg.responseText){
                                    var msgJson = $.parseJSON(msg.responseText);
                                    $.alert(msgJson.message);
                                }else{
                                    $.alert($.i18n("desk.alert.submiterror"));
                                }
                            }
                        });
                        

                    });
                }
            },
            error : function(){
                alert($.i18n("desk.alert.quickcontenterror"));
            }
        });
                              
	},
    initPrevAndNextClick : function(){
        //前一个待办
        $("#todoList_prev").live("click",function(){
            var prevPending = $("#pendingList .currentPending").prev().find(".toDoList_brief");
            if(prevPending.size()>0){
                $("#pendingList .currentPending").removeClass("currentPending");
                $(prevPending).parent().addClass("currentPending");
                 $.initPendingData(prevPending);
            }else{
                $("#pendingList .currentPending").removeClass("currentPending");
                $("#pendingList li:first").addClass("currentPending");
            }
        });
        
        //下一个待办
        $("#todoList_next").live("click",function(){
            var nextPending = $("#pendingList .currentPending").next().find(".toDoList_brief");
            if(nextPending.size()>0){
                $("#pendingList .currentPending").removeClass("currentPending");
                $(nextPending).parent().addClass("currentPending");
                 $.initPendingData(nextPending);
            }else{
                $("#pendingList .currentPending").removeClass("currentPending");
                $("#pendingList li:last").addClass("currentPending");
            }
        });
    },
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
                        if(addedPortletList[j] == portlet.portletId){
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
	         var isDefault= true;
           if(imageUrl.indexOf("/")>=0){
               imageUrl = _ctxPath+imageUrl;
               isDefault= false;
           }else{
               imageUrl = _ctxPath+"/main/skin/desktop/"+getCtpTop().skinPathKey+"/portletImages/"+imageUrl;
           }
           if (portlet.size == 1) {
               html += '<li class="item_size'+portlet.size + selected +'" onclick="$.addShortToLayout(this);" >';
               html += "<img src='" +imageUrl+ "' border='0' width='280' height='175' class='left' />";
           }else{
               if(isDefault){
                 html += '<li class="item_size'+portlet.size + selected +'" onclick="$.addShortToLayout(this);" style="background:url('+imageUrl+')" >';
               }else{
                 html += '<li class="item_size'+portlet.size + selected +'" onclick="$.addShortToLayout(this);">';
                 html += "<img src='" +imageUrl+ "' border='0' width='135' height='175' class='left' />";
               }
           }
           html += "<input type='hidden' name='portletBeanId' value='"+portlet.id+"'>";
           html += "<input type='hidden' name='portletId' value='"+portlet.portletId+"'>";
           html += "<input type='hidden' name='portletSize' value='"+portlet.size+"'>";
           html += '<p class="left '+active+'"';
           if(!isDefault){
             html += ' style="margin-top:-54px;"';
           }
           html += '><span title="'+portlet.displayName+'">';
           if(portlet.size == 1 || !isDefault){
              html += '<span style="text-align:left;">';
             }
           html += portlet.displayName;
           if(portlet.size == 1 || !isDefault){
             html += '</span>';
           }
           html +='</span><em class="ico32 '+ selectedCss +'"></em></p>';
           html += '</li>';
           html += '</li>';
				}
			}
			html += '</ul></div>';
		}
	    
	    obj.html(html);

        //判断是否edge浏览器，特殊处理zoom缩放问题
        if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
           $(".metroShortAddDialog_itemList li").css({"zoom":"1","marginLeft":"-30px","transform":"scale(0.77)","transform-origin":"top left"});
           $("ul.item_box").css({"paddingLeft":"30px"});
        }
        
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
                        if(addedPortletList[j] == portlet.portletId){
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
            $(this).addClass("selected_32");
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
        	var portletId = $(obj).find("input[name='portletId']").val();
        	var param = new Object();
        	param['portletId'] = portletId;
    		param['cateId'] = currentDeskCateId;
        	//已选择的再次点击进行删除
        	deskMgr.deletePortletByMultiParam(param,{
    			success : function () {
    				$("div[id^='portlet_']").each(function(i,op){
    					if($(op).find("input[name='portletId']").val() == portletId){
    						$(op).remove();
    					}
    				});
    				//$(obj).removeClass("selected");
    				$(obj).find("p em").removeClass("selected_32");
    				var timeout = setTimeout(function(){
                        verification_shortcut();
                    }, 2000);
    			}
    		});
            return;
        };
        $.addShortToLayout(obj);
    },
	//添加快捷到桌面
	addShortToLayout : function(obj){
       
		var portletBeanId = $(obj).find("input[name='portletBeanId']").val();
		var portletId = $(obj).find("input[name='portletId']").val();
		var layoutId = currentLayoutId;
		var portletSize = $(obj).find("input[name='portletSize']").val();
		var portletOrder = currentPortletOrder;
		var param = new Object();
		
		 //过滤已添加的
        if ($(obj).hasClass("selected")) {
        	param['portletId'] = portletId;
    		param['cateId'] = currentDeskCateId;
        	//已选择的再次点击进行删除
        	deskMgr.deletePortletByMultiParam(param,{
    			success : function () {
    				$("div[id^='portlet_']").each(function(i,op){
    					if($(op).find("input[name='portletId']").val() == portletId){
    						$(op).remove();
    					}
    				});
    				$(obj).removeClass("selected");
    				$(obj).find("p em").removeClass("selected_32");
    				var timeout = setTimeout(function(){
                        verification_shortcut();
                    }, 2000);
    			}
    		});
            return;
        };
		
		param['portletBeanId'] = portletBeanId;
		param['portletId'] = portletId;
		param['layoutId'] = layoutId;
		param['portletSize'] = portletSize;
		param['portletOrder'] = portletOrder;
		
		
		deskMgr.addPortletToLayout(param,{
			success : function(portlet){
				if(portlet){
                    //改变Portlet在快捷库的样式
					if($(obj).find("p em").hasClass("ico32")){
						$(obj).addClass("selected");
					}
                    $(obj).find("p em").addClass("selected_32");

					var html = '';
					var _portletCss = portlet.portletSize;
					if(portlet.portletSize == 1){
						_portletCss += " shortcutBlock_scroll";
					}
					html += '<div id="portlet_'+portlet.id+'"  class="shortcutBlock shortcutBlock_size' + _portletCss +'">';
					html += '<em class="close_btn ico24"></em>';
                    html += '<div class="tip_number hidden"></div>';
					html += '<input type="hidden" name="pId" value="'+portlet.id+'">';
					html += '<input type="hidden" name="portletBeanId" value="'+portlet.portletBeanId+'">';
					html += '<input type="hidden" name="portletId" value="'+portlet.portletId+'">';
					html += '<input type="hidden" name="portletSize" value="'+portlet.portletSize+'">';
					html += '<input type="hidden" name="portletOder" value="'+portlet.portletOder+'">';
					html += '</div>';
					$("#metroShortcut_"+portlet.layoutId).find(".shortcutBlock:last").before(html);
					var ob = $("#portlet_"+portlet.id);
					if(portletState == "edit"){
						$(ob).find(".close_btn").show();
					};
					$.initPortlet(ob);
                    var timeout = setTimeout(function(){
                        verification_shortcut();
                    }, 2000);
				}
			}
		});
		//$(".metroShortAddDialog_mask,.dialogCloseBtn").trigger("click");
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
            html += '<li class="clearFlow" id="'+p[i][0]+'" onclick="$.showCategoryPortlets(\''+p[i][0]+'\')"><em class="ico24" style="background:url(/seeyon/main/frames/desktop/images/shortcut_sort/'+imgName+') center no-repeat;"></em><span class="t" title="' + p[i][1]+'">'+p[i][1]+'</span></li>';
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
	desktop_showhide : function () {
		//工作桌面定位
		/*parent.$(".return_ioc").click(function(event) {
			if (initShowDeskTop == false) {
				initShowDeskTop = true;
				$(this).attr("show","true");
				desktop_show();
			} else {
				initShowDeskTop = false;
				$(this).attr("show","false");
				desktop_hide();
			}
		});*/
		
		//显示工作桌面
		function desktop_show () {
			$("#desktop_body_box").show();
			var _obj = $("#desktop_body");
			_obj.stop(true).animate({top: 0}, "fast");
		}
		//隐藏工作桌面
		function desktop_hide () {
			var _obj = $("#desktop_body");
			_obj.stop(true).animate({top: _obj.height() * -1}, "fast" ,function () {
				$("#desktop_body_box").hide();
			});
		}
		$(window).resize(function () {
			desktop_resize();
		});
		desktop_resize();
		//工作桌面随窗口大小改变
		function desktop_resize() {
			$("#desktop_body_box,#desktop_body").css({
				width: $(window).width(),
				height: ($(window).height() - 50)
			});
            $("#desktop_body_bg").css({
                width: $(window).width(),
                height: $(window).height()
            });
		}
	},
	//设为首页
	setHomepage : function () {
		if("default" == getCtpTop().defaultPortalTemplate){
			$("#setHomepage").text($.i18n("desk.txt.sethomepage"));
		}else{
			$("#setHomepage").text($.i18n("desk.txt.cancelhomepage"));
		}
		$("#setHomepage").click(function(){
			if("default" == getCtpTop().defaultPortalTemplate){
				getCtpTop().defaultPortalTemplate = "desktop";
				setCustomize("default_page","desktop");
				$(this).text($.i18n("desk.txt.cancelhomepage"));
			}else{
				getCtpTop().defaultPortalTemplate = "default";
				setCustomize("default_page","default");
				$(this).text($.i18n("desk.txt.sethomepage"));
			}
		});
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
function setCustomize(key,value){
	//异步后台记录用户操作
	  var param = new Object();
	  param[key] = value;
	  new portalManager().setCurrentUserCustomize(param,{
		  success : function(){
		  }
	  });
}
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

    //addedPortletList
    //获取已选择portlet数据
    addedPortletList = new Array();
    var layoutList = deskMgr.getDeskData(currentDeskCateId);
    if(layoutList){
        for(var i=0; i < layoutList.length; i++){
            var layout = layoutList[i];
            if(layout && layout.portletList){
                var portletList = layout.portletList;
                if(portletList && portletList.length > 0){
                    for(var k = 0; k < portletList.length ; k++){
                        var portlet = portletList[k];
                        addedPortletList.push(portlet.portletId);
                    }
                }
            }
        }
    }

    var allPortlets = deskMgr.getAllPortlets(param);
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
            if("space" == key){
                $.metroShortAddDialog_roundItemList(portlets);
                var _objRoundabout = $("#roundabout");
                var _size = _objRoundabout.find("li").size();
                _objRoundabout.width(260 * _size);
                        //jquery.roundabout.js插件 图片层叠旋转幻灯片
                // if($("#roundabout").data("init") != true){
                //     $('#roundabout').data("init",true);
                //     // $('#roundabout').roundabout({
                //     //     minOpacity: 1,
                //     //     reflect: true,//方向
                //     //     autoplay: true,
                //     //     autoplayDuration: 5000
                //     // });
                // }
            }else{
                otherPortlets[key] = portlets;
            }
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
//待办列表快速处理专用方法
function checkAndOpen(affairId,link,title,openType,app,thisobj){
    
    var result = checkAffair(affairId,app);
    if(!result){
        return;
    }
    if(app == "24" || app == "34"){
        getCtpTop().showMenu(link,null,null,"main");
        getCtpTop().$(".return_ioc2").click();
    }else{
    	openCtpWindow({url:link});
    }
}
function checkAffair(affairId,app){
    if($.trim(app) === '1' || $.trim(app) === '19' || $.trim(app) === '20' || $.trim(app) === '21'){
        var msg = isAffairValid(affairId);
        if(msg != "") {
            $.messageBox({
                'title' : $.i18n('system.prompt.js'), //系统提示
                'type': 0,
                'imgType':2,
                'msg': msg,
                ok_fn:function(){
                    $(".toDoListDialog").hide();
                    var _frame = $(".toDoListDialog").find("iframe")[0];
                    if(_frame){
                        _frame.contentWindow.document.write('');
                        _frame.contentWindow.close();//避免iframe内存泄漏
                    }
                    $(".toDoListDialog").html("");
                    var pendingList = new deskCollaborationManager().getCollaborationList(dataCount);
                    $.initDeskPending(pendingList);
               }
             });
            return false;  
        }
     }
    return true;
}
//ajax判断事项是否可用。
function isAffairValid(affairId){
  var cm = new colManager();
  var msg = cm.checkAffairValid(affairId);
  if($.trim(msg) !=''){
       return msg;
  }
  return "";
}

/*RGB颜色转换为16进制*/
function zero_fill_hex(num, digits) {
	var s = num.toString(16);
	while (s.length < digits) s = "0" + s;
	return s;
}
function rgb2hex(rgb) {
	if (rgb.charAt(0) == '#') return rgb;
	var ds = rgb.split(/\D+/);
	var decimal = Number(ds[1]) * 65536 + Number(ds[2]) * 256 + Number(ds[3]);
	return "#" + zero_fill_hex(decimal, 6);
}