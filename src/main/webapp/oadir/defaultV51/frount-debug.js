/**
 * @author machuanjia
 *  harmony  -- 和谐之美
 *  peaceful -- 宁静之韵
 *  wisdom   -- 智慧之美
 */

//登录后当前人员的热点
$.ctx.hotspots = {
    //集团名称（前端是否显示）
    groupName : null,
    //单位名称（前端是否显示）
    accountName : null,
    //logo
    logoImg : null,
    //头部背景图（横幅图片）
    topBgImg : null,
    //头部颜色
    topBgColor : null,
    //左侧导航颜色
    lBgColor : null,
    //栏目头部颜色
    cBgColor : null,
    //工作区背景色
    mainBgColor : null,
    //body上的大背景图
    mainBgImg : null,
    //面包屑导航字体颜色
    breadFontColor : null,
    //栏目内容区颜色
    sectionContentColor : null
};
refreshCtxHotSpotsData();
//系统消息总条数和未读条数
$.ctx.sysMsgTotalCount1 = 0;
$.ctx.sysMsgTotalCount2 = 0;
var frountSpace = {}
jQuery.extend({
	deeLayout:function(isLocation){
		switch(isLocation){
			case 0:
	        $('.layout_content_main').css('margin-left',162);
			$('.layout_content_main_content').css('top',64);
			$('.nowLocation').show();
			break;
			case 1:
            $('.layout_content_main').css('margin-left',141);
			$('.layout_content_main_content').css('top',0);
			$('.nowLocation').hide();
			break;
			case 11:
            $('.layout_content_main').css('margin-left',60);
			$('.layout_content_main_content').css('top',0);
			$('.nowLocation').hide();
			break;
		}
		$.initLayout();
	},
	//布局--ie6 7 初始化高度
	initLayout:function(){
        var _w = $('.warp').height();
        var _h = $('.layout_header').height();
		if ($.browser.msie) {
            if ($.browser.version == '6.0' || $.browser.version == '7.0') {
				var _l = $('.layout_location');
				$('.layout_content').height(_w-_h);
				$('.layout_content_main_content').height(_w-_h-64);
				$('#main').height(_w-_h-64);
            }
        }
		var _line = $('.line').height();
		var _navPager = 47;
		var _shortCut = 50;
		var _agentHeight = 0;
		if("true" == hasAgent){
			_agentHeight = $('#agentNav').height()+1;
		}
		if("false" == isAdmin){
			$('.nav').height(_w-_h-_line-_navPager-_shortCut-_agentHeight);
		}else{
			var lineAdmin = $('.lineAdmin').height();
			$('.nav').height(_w-_h-lineAdmin-_navPager);
		}
		if(getCtpTop().systemProductId == 7){
			$('.lineAdmin').css("background-color","transparent")
		}
	},
	pageMenu:function(menus){
		if(menus == null || menus.length == 0){return;}
		var menu = menus;//菜单
		var _itemHeight = 50;//单个菜单高度
		var _maxLength = parseInt($('.nav').height()/(_itemHeight + 2));//该处可以在初始化菜单区域高度是计算
		var _isPage = menus.length>_maxLength?true:false;//菜单是否需要分页
		var _pager = parseInt($('.nav').attr('pager'));
		var totlePage = menus.length%_maxLength == 0?menus.length/_maxLength:parseInt(menus.length/_maxLength)+1;
		var _fromPage = (_pager-1)*_maxLength;
		var _toPage = _pager*_maxLength;
		if(_isPage){
			$('.navPager').css({
				"display":"block"
			});
			$('.navPager').show();
			$('#navPager_border').show();
			$('#nav_pre').click(function(){
				if(_pager == 1){
					_pager = 1;
				}else{
					_pager--;
				}
				$('.nav').attr('pager',_pager);
				$.initNavigation(menus.slice((_pager-1)*_maxLength,_pager*_maxLength));
				if ($(".layout_left").width() == 142){
				  $(".nav_title").show();
				  $(".nav_item").mouseenter(function(){
					  $(this).find(".nav_box_color").css("width","48px");
				  }).mouseleave(function(){
				  	if(getCtpTop().systemProductId != 7){
							$(this).find(".nav_box_color").css("width","4px");
						}else{
							$(this).find(".nav_box_color").css("width","0");
						}
				  });
				  $(".nav_icon").css({
						'margin-left': 15,
						'margin-top':0	
					});
				}else{
				  $(".nav_title").hide(); 
				  $(".nav_item").mouseenter(function(){
					  $(this).find(".nav_box_color").css("width","60px");
				  }).mouseleave(function(){
					  if(getCtpTop().systemProductId != 7){
							$(this).find(".nav_box_color").css("width","4px");
						}else{
							$(this).find(".nav_box_color").css("width","0");
						}
				  });
				  $(".nav_icon").css({
						'margin-left': 20,
						'margin-top':15	
					});
				}
			});
			$('#nav_next').click(function(){
				if(_pager == totlePage){
					_pager = totlePage;
				}else{
					_pager++;
				}
				$('.nav').attr('pager',_pager);
				$.initNavigation(menus.slice((_pager-1)*_maxLength,_pager*_maxLength));
				if ($(".layout_left").width() == 142){
				  $(".nav_title").show();
				  $(".nav_item").mouseenter(function(){
					  $(this).find(".nav_box_color").css("width","48px");
				  }).mouseleave(function(){
					  $(this).find(".nav_box_color").css("width","4px");
				  });
				  $(".nav_icon").css({
						'margin-left': 15,
						'margin-top':0	
					});
				}else{
				  $(".nav_title").hide(); 
				  $(".nav_item").mouseenter(function(){
					  $(this).find(".nav_box_color").css("width","60px");
				  }).mouseleave(function(){
					  $(this).find(".nav_box_color").css("width","4px");
				  });
				  $(".nav_icon").css({
						'margin-left': 20,
						'margin-top':15	
					});
				}
			});
			$(".navPager").mouseenter(function(){
				$("#nav_pre").show();
				$("#nav_next").show();
			}).mouseleave(function(){
				$("#nav_pre").hide();
				$("#nav_next").hide();
			});
		}else{
			$('.navPager').hide();
			$('#navPager_border').hide();
		}
		$.initNavigation(menus.slice(_fromPage,_toPage));
		
	},
	setOffice:function(flag){
		//visible hidden
		try{
			if(isOffice && officeObj && officeObj.length>0){
	    		for(var i = 0; i<officeObj.length;i++){
	    			var _temp = officeObj[i];
	    			if(_temp && _temp.style){
	    				_temp.style.visibility = flag
	    			}
	    		}
	    	}
		}catch(e){}
	},
	//初始化主菜单
	initNavigation:function(menusArray){
		
		if(skinPathKey=="GOV_red" || skinPathKey=="GOV_blue"){
			var  menusColor = ["#000000","#000000","#000000","#000000","#000000","#000000","#000000","#000000","#000000","#000000"];
			if("true" == hasAgent){
				menusColor = ["#000000","#000000","#000000","#000000","#000000","#000000","#000000","#000000","#000000","#000000"];
			}
			
		}else{
			var  menusColor = ["#e70012","#f27d00","#f1b500","#8fc320","#45b6ce","#ce8df1","#bf0081","#e70012","#f29700"];
			if("true" == hasAgent){
				menusColor = ["#f27d00","#f1b500","#8fc320","#45b6ce","#ce8df1","#bf0081","#e70012","#f29700","#e70012"];
			}
		}
		
		var _mainheight = $('.layout_content').height();
		var _submmh = 39;
    	var _maxSize = parseInt(_mainheight/_submmh);//二级/三级菜单显示最多多少个，如果超过就显示上移下移按钮
		var menu = menusArray;//菜单
		var currentId;//当前选择一级菜单
		var hideSecondMenu = true;//是否隐藏二级菜单


		var htmlStr = "";
		/**
		 * 单个菜单
		 */
		$(menu).each(function(index){
			//var imagesrc = _ctxPath + "/main/skin/frame/"+skinPathKey+"/menuIcon/icon.png";
			var imageHtml = null;
			if(this.icon){
				if(this.icon.indexOf("fileUpload.do")>0){
					imageHtml = "<img width='24px' height='24px' src='" + _ctxPath + this.icon + "' />";
					//imagesrc = _ctxPath + this.icon;
				}else{
					var iconClass = this.icon.split(".")[0];
					if(iconClass.indexOf("spacehover/") == -1){
						imageHtml = "<span class='portal_menu_icon menu_one_" + iconClass + "' style='display:inline-block;'></span>";
					} else {
						var indexNum = iconClass.lastIndexOf("/") + 1;						
						iconClass = iconClass.substr(indexNum);
						imageHtml = "<span class='portal_menu_icon menu_one_spacehover_" + iconClass + "' style='display:inline-block;'></span>";
					}
					//imagesrc = _ctxPath + "/main/skin/frame/"+skinPathKey+"/menuIcon/"+this.icon;
				}
			}
			//console.log(this.name+"---"+this.icon);
			if(skinPathKey!="GOV_red"){
				if(getCtpTop().systemProductId != 7){
					htmlStr+="<div class='nav_border'></div>";
					htmlStr+="<div class='nav_item' index='"+index+"' id='"+this.id+"' title='"+escapeStringToHTML(this.name,false)+"'>";
					htmlStr+="<div class='nav_box_bgcolor'></div>";
					htmlStr+="<div class='nav_box_color'></div>";
					htmlStr+="<span class='nav_icon'>" + imageHtml + "</span>";
					htmlStr+="<span class='nav_title'>"+escapeStringToHTML(this.name,false)+"</span>";
					htmlStr+="</div>";
				}else{	//A6S
					htmlStr+="<div class='nav_border' style='background-image:url("+_ctxPath+"/main/skin/frame/"+skinPathKey+"/images/a6s_nav_border.png)'>"+"</div>";
					htmlStr+="<div class='nav_item' index='"+index+"' id='"+this.id+"' title='"+escapeStringToHTML(this.name,false)+"'>";
					htmlStr+="<div class='nav_box_bgcolor'></div>";
					htmlStr+="<span class='nav_icon'>" + imageHtml + "</span>";
					htmlStr+="<span class='nav_title'>"+escapeStringToHTML(this.name,false)+"</span>";
					htmlStr+="</div>";
				}
			}else{
				htmlStr+="<div class='nav_border'></div>";
				htmlStr+="<div class='nav_item' index='"+index+"' id='"+this.id+"' title='"+escapeStringToHTML(this.name,false)+"'>";
				htmlStr+="<div class='nav_box_bgcolor'></div>";
				htmlStr+="<span class='nav_icon'>" + imageHtml + "</span>";
				htmlStr+="<span class='nav_title'>"+escapeStringToHTML(this.name,false)+"</span>";
				htmlStr+="</div>";
			}
				
		});
		if(getCtpTop().systemProductId != 7){
			htmlStr+="<div class='nav_border'></div>";
		};
		$('.nav').empty();
		$('.nav').append($(htmlStr));
		
		
		//添加颜色
		var navItemNum = $(".nav_item").length;
		var _mixNum = menusColor.length;
		for(var i = 0; i < navItemNum;i++){
			var _menusColor = menusColor[i%_mixNum];
			$(".nav_item:eq("+ i +")").find(".nav_box_bgcolor").css("background",_menusColor);
			$(".nav_item:eq("+ i +")").find(".nav_box_color").css("background",_menusColor);
		}
		
		//上下移动菜单
		function initMoveMenu(obj,maxSize,mainheight){
		  if(obj.length>0){
		    var _upobj = obj.find('.upaction').first();
		    var _downobj = obj.find('.downaction').last();
		    var _moveObj = obj.find('ul').first();
		    _upobj.show();
		    _downobj.show();
		    _moveObj.height(mainheight - 24).css('overflow','hidden');
		    _downobj.click(function(){
		      var _top = parseInt(_moveObj.scrollTop())+50;
		      _moveObj.scrollTop(_top);
		    });
		    _upobj.click(function(){
		      var _top = parseInt(_moveObj.scrollTop())-50;
		      //console.log(_top);
		      _moveObj.scrollTop(_top);
		    });
		  }
		}
		//根据id获取menu对象
		function getMenuItem(id){
			var _menu;
			for (var j=0; j<menu.length; j++) {
				var _temp = menu[j];
				if(_temp.id == id){
					_menu = _temp;
					break; 
				}
			};
			return _menu;
		}
		//初始化二级菜单
		function initSecondMenu(_id){
			var _menu = getMenuItem(_id);
			var _oneheight = 0;
			var _secondMenuLength = 5;
			var _thirdMenuLength = 5;
			if (_menu && _menu.items && _menu.items.length > 0) {
				if(_menu.items.length == 1)	{
					_oneheight = 50;
				}
		        var _second_menu = $('#second_menu');
		        _second_menu.empty();
		        _second_menu.append("<div class='secont_right_sub'></div><div class='upaction'></div>");
		        var _second_menu_content = $("<ul id='second_menu_content' class='second_menu_content'></ul>");
		        currentId = _id;
		     
		        for (var g=0; g<_menu.items.length; g++) {
		          var _item = _menu.items[g];
		          var _childItems = _item.items;
		          //屏蔽无子菜单也没有url的二级菜单
		          if(_childItems == null && _item.url == null){
		        	  continue;
		          }
		          
		          var _onclickStr = "";
		          if(_item.url){
		            _onclickStr = "onclick=\"showMenu('" + _ctxPath +_item.url.escapeUrl()+"','"+_item.id+"',2,'"+_item.target+"','"+escapeStringToHTML(_item.name,false)+"','"+_item.resourceCode+"','"+currentId+"')\"";
		          }
		          var imagesrc = _ctxPath + "/main/skin/frame/"+skinPathKey+"/menuIcon/nav_second_ico.png";
				  if(_item.icon){
					//组织机构设置特殊处理
				  	if(_item.icon == "unitmanagement.png"){
				  		imagesrc = _ctxPath + "/main/skin/frame/"+skinPathKey+"/menuIcon/unitmanagement_b.png";
				  	}else{
				  		if(_item.icon.indexOf("fileUpload.do")>0){
							imagesrc = _ctxPath + _item.icon;
						}else{
							imagesrc = _ctxPath + "/main/skin/frame/"+skinPathKey+"/menuIcon/"+_item.icon;
						}
				  	}
				  }
				  //console.log(_item.name+"---"+_item.icon);
				  //修改单个二级菜单的高度。
				  var _item_css = _oneheight >0 ? "height:48px;line-height:48px;" : "height:39px;";
				  var _item_span_css = _oneheight >0 ? "height:34px;" : "height:24px;";
				 // var _admin_css = "width:115px;padding-left:20px;";
				  //var _user_css = "width:115px;padding-left:20px;";
				  
				  if(_item.name.length>_secondMenuLength){
					  _secondMenuLength = _item.name.length;
				  }
				  if("true" == isAdmin){
				  	var _htmlStr = $("<li title='" + _item.name.escapeHTML() + "' id='"+_item.id+"' "+_onclickStr+"  class='second_menu_item' style="+_item_css+"><span class='second_menu_item_name' style='width:115px;'>"+_item.name.escapeHTML()+"</span></li>");
				  }else{
				  	var _htmlStr = $("<li title='" + _item.name.escapeHTML() + "' id='"+_item.id+"' "+_onclickStr+"  class='second_menu_item' style="+_item_css+"><span class='second_menuIco' style="+_item_span_css+"><img width='24' height='24' src='" + imagesrc +"'></span><span class='second_menu_item_name'>"+_item.name.escapeHTML()+"</span></li>");
				  }
		          
		          if(_childItems!=undefined && _childItems.length>0){
		            _htmlStr = $("<li title='" + _item.name.escapeHTML() + "' id='"+_item.id+"' class='second_menu_item'><span class='second_menuIco_next'><img src='" + imagesrc +"'></span><span "+_onclickStr+" class='second_menu_item_name_next'>"+_item.name.escapeHTML()+"</span><em class='next_menu_icon'></em></li>");
		            var _subMenu = $("<div class='third_menu_container'><div class='upaction'></div></div>");
		            var third_menu_content = $("<ul id='third_menu_content' class='third_menu_content'></ul>");
		            for (var t=0; t<_childItems.length; t++) {
		              var __childItem = _childItems[t];
		              var _childItemOnclickStr = "";
		              if(__childItem.url){
		                _childItemOnclickStr = "onclick=\"showMenu('"+_ctxPath+__childItem.url.escapeUrl()+"','"+__childItem.id+"',3,'"+__childItem.target+"','"+__childItem.name.escapeHTML()+"','"+__childItem.resourceCode+"','"+currentId+"')\"";
		              }
		              if(__childItem.name.length>_thirdMenuLength){
		            	  _thirdMenuLength = __childItem.name.length;
					  }
		              var _subMenuItem = $("<li title='" + __childItem.name.escapeHTML() + "' id='"+__childItem.id+"' "+_childItemOnclickStr+"  class='third_menu_item'><span class='third_menu_item_name'>"+__childItem.name.escapeHTML()+"</span></li>");
		              third_menu_content.append(_subMenuItem);
		            };
		            _subMenu.append(third_menu_content);
		            _subMenu.append("<div class='downaction'></div>");
		            _htmlStr.append(_subMenu);
		          }
		          _second_menu_content.append(_htmlStr);
		       
		        };
				_second_menu.append(_second_menu_content);
        	    _second_menu.append("<div class='downaction'></div>");
			}
			
			$('#second_menu_content').attr('maxLength',_secondMenuLength);
			$('#second_menu_content #third_menu_content').attr('maxLength',_thirdMenuLength);
			
			$('.second_menu_item').each(function(){
				$(this).mouseenter(function(){
					if("true" == isAdmin){
						$(this).addClass('second_menu_item_admin_hover');
					}else{
						
						$(this).addClass('second_menu_item_hover');
					}
				  
				  $(this).find('em').addClass('next_menu_icon_1');
          		  $(this).find('em').removeClass('next_menu_icon');
				  var _third_menu = $(this).find('.third_menu_container');
				  if(_third_menu.length>0){
					var _maxThlength = parseInt($(this).find('#third_menu_content').attr('maxLength'));
				    var _third_menu_item = $(this).find('.third_menu_item');
				    var _offset = $(this).offset();
					var _sd = $('#second_menu').offset();
					//console.log(_offset.top+"====="+_sd.top);
				    var _top = _offset.top-_sd.top;
					var _hole = $('.warp').height();
					//alert(_third_menu_item.length+"==="+_maxSize)
				    if(_third_menu_item.length>_maxSize){
							var _fff = (_offset.top+_third_menu_item.length*_submmh)-_hole;
							_top = 0-_sd.top+$('.layout_header').height();
				    }else{
						//alert((_offset.top+_third_menu_item.length*26)+"==="+_hole)
					    if((_offset.top+_third_menu_item.length*_submmh)>_hole){
							var _fff = (_offset.top+_third_menu_item.length*_submmh)-_hole;
							_top = _top-_fff;
					    } 
					}
					if(_maxThlength>6 || _secondMenuLength>6){
				    	$('.third_menu_item').css({
				    		'width':198
				    	});
				    	$('.third_menu_item').find('.third_menu_item_name').css({
				    		'width':198
				    	});
					    _third_menu.css({
					      'width':210,
					      left:$('#second_menu').width()-8,
					      top:_top-2
					    }).show();
						var _topIframe = _top+_sd.top;
					    $('#third_menu_iframe').css({
					       'width':210,
					      'left':_offset.left+$('#second_menu').width()-10,
					      'top':_topIframe,
					      'height':_third_menu.height()
					    }).show();
				     }else{
			    	    $('.third_menu_item').css({
				    		'width':125+15
				    	});
				    	$('.third_menu_item').find('.third_menu_item_name').css({
				    		'width':90+15
				    	});
					    _third_menu.css({
					    	'width':137+15,
					      left:135+15,
					      top:_top-2
					    }).show();
						var _topIframe = _top+_sd.top;
					    $('#third_menu_iframe').css({
					    	'width':137+15,
					      'left':_offset.left+136+15,
					      'top':_topIframe,
					      'height':_third_menu.height()
					    }).show();
				     }
				    
				    if(_maxSize<_third_menu_item.length){
				      initMoveMenu(_third_menu,_maxSize,_mainheight);
				    }
				  }
				  
				}).mouseleave(function(){
					if("true" == isAdmin){
						$(this).removeClass('second_menu_item_admin_hover');
					}else{
						$(this).removeClass('second_menu_item_hover');
					}
				  $(this).find('em').addClass('next_menu_icon');
          		  $(this).find('em').removeClass('next_menu_icon_1');
				  $(this).find('.third_menu_container').hide();
				  $('#third_menu_iframe').hide();
				}).click(function(e){
				  if(e.target.className=='second_menu_item_name' || e.target.className=='second_menu_item_name_next'){
					$('.current_flag').removeClass('current_flag');
			        $('#'+currentId).addClass("current_flag");
				    $('#second_menu').hide();
				    $('#second_menu_iframe').hide();
				    $.setOffice('visible');
				  }
				});
			});
			$('.third_menu_item').each(function(){
				$(this).mouseenter(function(){
				  $(this).addClass('third_menu_item_hover');
				  $(this).find('em').addClass('next_menu_icon_1');
				  $(this).find('em').removeClass('next_menu_icon');
				}).mouseleave(function(){
				  $(this).removeClass('third_menu_item_hover');
				  $(this).find('em').addClass('next_menu_icon');
				  $(this).find('em').removeClass('next_menu_icon_1');
				}).click(function(){
				  $('.current_flag').removeClass('current_flag');
		          $('#'+currentId).addClass("current_flag");
				  $(this).parent().parent().hide();
				  $('#third_menu_iframe').hide();
				});
			});
			
		    if ($('#' + _id).length < 1) {
	    	  return;
	        }
	        var _offset =$('#'+_id).offset();
	        var _height =$('#'+_id).height();
			var _top = _offset.top;
			var _hole = $('.warp').height();
			//console.log(_top+"===**************=="+_maxSize+"&&&&&&&&&&&&&&&&"+_menu.items.length);
		    if(_menu.items.length>_maxSize){
		      _top = $('.layout_header').height();
		    }else{
			    if((_top+_menu.items.length*_submmh)>_hole){
					var _fff = (_top+_menu.items.length*_submmh)-_hole;
					_top = _top-_fff-5;
			    } 
			}
		    if(_secondMenuLength>6){
		    	$('.second_menu_item').css({
		    		'width':198
		    	});
		    	$('.second_menu_item').find('.second_menu_item_name').css({
		    		'width':153
		    	});
		    	$('#second_menu').css({
		    		'width':210
		    	});
		    	$('#second_menu_iframe').css({
			         'width':210
			    });
		    }else{
		    	$('.second_menu_item').css({
		    		'width':125+15
		    	});
		    	$('.second_menu_item').find('.second_menu_item_name').css({
		    		'width':90+15
		    	});
		    	$('#second_menu').css({
		    		'width':137+15
		    	});
		    	$('#second_menu_iframe').css({
			         'width':137+15
			    });
		    }
	        $('#second_menu').css({
	          'top':_top
	        }).show();
	        $('#second_menu_iframe').css({
	          'top':_top-1,
	          'height':$('#second_menu').height()
	        }).show();
			if(_menu.items&&_maxSize<_menu.items.length){
				initMoveMenu($('#second_menu'),_maxSize,_mainheight);
			}
		}
		
		$('.nav_item').each(function(){
			$(this).mouseenter(function(e){
				$(this).addClass('current_item');
				var _id = this.id;
				$.setOffice('hidden');
		        setTimeout(function(){
		          initSecondMenu(_id);
		        },0.2);
				
			}).mouseleave(function(e){
				$(this).removeClass('current_item');
		        setTimeout(function(){
		          if(hideSecondMenu){
		            $('#second_menu').empty().hide();
		            $('#second_menu_iframe').hide();
		            $.setOffice('visible');
		          }
		        },0.1);
			});
		});
	    $('#second_menu').unbind().mouseenter(function(){
	      hideSecondMenu = false;
	      if(currentId!=null){
	        var _mainMenuLi = $('#'+currentId);
	        _mainMenuLi.addClass("current_item");
	      }
	    }).mouseleave(function(){
	      hideSecondMenu = true;
	      $('#second_menu').empty().hide();
	      $('#second_menu_iframe').hide();
	      $.setOffice('visible');
	      $('#third_menu_iframe').hide();
	      if(currentId!=null){
	        var _mainMenuLi = $('#'+currentId);
	        _mainMenuLi.removeClass("current_item");
	      }
	    });
		//$('.nav').height($(".nav_item").length*(50 + 2));
		//重新设置菜单后，验证左侧宽度并分别设置对应样式
		if ($(".layout_left").width() == 142){
				$(".nav_title").show();
				$(".nav_item").mouseenter(function(){
					$(this).find(".nav_box_color").css("width","48px");
				}).mouseleave(function(){
					$(this).find(".nav_box_color").css("width","4px");
				});
				$(".nav_icon").css({
					'margin-left': 15,
					'margin-top':0	
				});
			}else{
				$(".nav_title").hide(); 
				$(".nav_item").mouseenter(function(){
					$(this).find(".nav_box_color").css("width","60px");
				}).mouseleave(function(){
					$(this).find(".nav_box_color").css("width","4px");
				});
				$(".nav_icon").css({
					'margin-left': 20,
					'margin-top':15	
				});
			}
	},
	//下拉组件

	initPullDown:function(_top,_right,_pulldownLiWidth){
		$('.pulldown ul li').css('width',_pulldownLiWidth+'px').unbind().mouseenter(function (event){
			$(this).css('background','#42b3e5').css('color','#fff');
			 event.stopPropagation();
		}).mouseleave(function(event){
			$(this).css('background','#fff').css('color','#000');
			event.stopPropagation();
		});	
		if ($.browser.msie) {
            if ($.browser.version == '6.0') {
				_right = _right + 10;
            }
        }
		var _iframeWidth = $('.pulldown').width();
		var _iframeHeight =  $('.pulldown').height();
		$('.pulldown').css({
			'top':_top,
			'right':_right
		}).show();
		$('.pulldownIframe').css({
			'top':_top,
			'right':_right,
			'width':_iframeWidth,
			'height':_iframeHeight
		}).show();	
	},
	//大家work
	initDaJiaWork:function(daJiaWorks){},
	//UC消息
	initUCMsg:function(){
    if(hasEveryBody){
      initEBAndUCMsg();
      return;
    }
		$('.uc_container').prepend('<div class="space_item2">◆</div><div class="space_item1">◆</div><ul></ul>');
		var _uc = $(".msg_ioc");
		var _offset = _uc.offset();
		var _top = 50; 
		var _right = 24;
		var _pulldownLiWidth = 285;
		function initMESG(){
			$('.uc_container ul').empty();
			//******读取UC消息******
			var msgInstanceKeys = msgProperties.keys();
			var msgFromCount = msgInstanceKeys.size();// 聊天对象个数
			if(msgFromCount == 0){$('#ucMsg_point').hide();}
			for (var i = 0; i < msgFromCount; i++) {
			    var key = msgInstanceKeys.get(i);
			    var msg = msgProperties.get(key);
			    var msgCount = msg.size();// 当前聊天对象的消息个数
			    var latestMsg = msg.getLast();
			    var tName = latestMsg.name.escapeHTML();
			    var senderName = "";
			    var photo = _PhotoMap.get(latestMsg.jid);
			    if (latestMsg.type == 'system') {
			    	photo = _ctxPath + "/apps_res/uc/chat/image/Group1.jpg";
			    }
			    if (latestMsg.jid.indexOf('@group') > -1) {
			        senderName = latestMsg.username.escapeHTML() + ":";
			        photo = _ctxPath + "/apps_res/uc/chat/image/Group1.jpg";
			    }
			    
			    var msgContent = "";
			    if (latestMsg.atts.size() > 0) {
			        msgContent = senderName + "给您发送了文件";
			    } else if (latestMsg.microtalk != null) {
			        msgContent = senderName + "给您发送了语音";
			    } else if (latestMsg.vcard != null) {
			        msgContent = senderName + "给您发送了名片";
			    } else {
			        msgContent = getMsgLimitLength(senderName + latestMsg.content, 80);
			        msgContent = msgContent.escapeHTML();
			        for ( var j = 0; j < face_texts_replace.length; j++) {
			            msgContent = msgContent.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' />");
			        }
			    }
			    photo = encodeURI(photo);
			    var showHtml = ""
				showHtml += '<li class="pushdown_second" key="' + key + '" type="' + latestMsg.type + '" name="' + tName + '" jid="' + latestMsg.jid + '">' ;
				showHtml += "  <div class='nav_uc_ico left'><img src=" + photo + " width='32' height='32' /></div>";
				if (latestMsg.type != 'system') {
					showHtml += '  <div class="nav_uc_right left">';
					showHtml += '    <div class="nav_uc_right_title">' + tName + '</div>';
					showHtml += '    <div class="nav_uc_right_main">' + msgContent + '</div>';
					showHtml += '  </div>';
					showHtml += '  <span class="nav_uc_num">' + msgCount + '</span>';
				} else {
					showHtml += '  <div class="nav_uc_right left">';
					showHtml += '    <div class="nav_uc_right_main " style="margin-top:15px;">' + msgContent + '</div>';		
					showHtml += '  </div>';
				}
				showHtml += '  <div class="uc_msg_ico_1"></div><div class="uc_msg_ico_2" title="'+$.i18n("portal.message.ignoreall")+'" key="' + key + '"></div>';
				showHtml += '</li>';
			    $('.uc_container ul').append(showHtml);
			}
			//******读取UC消息******
			
			$('.uc_container ul li').css('width',_pulldownLiWidth+'px').mouseenter(function (event){
				$(this).css("background","#fcf0c1").css('color','#fff');
				$(this).find(".nav_uc_num").hide();
				$(this).find(".uc_msg_ico_1").show();
				//event.stopPropagation();
			}).mouseleave(function(event){
				$(this).css('background','#fff').css('color','#000');
				$(this).find(".nav_uc_num").show();
				$(this).find(".uc_msg_ico_1").hide();
				$(this).find(".uc_msg_ico_2").hide();
				//event.stopPropagation();
			}).click(function(event){
				if ($(event.target).hasClass("uc_msg_ico_2")) {
					return;
				}
				if ($(this).attr('type') == 'system') {
					ignoreOne($(this).attr('key'));
				} else {
					viewOne($(this).attr('key'), $(this).attr('name'), $(this).attr('jid'));
				}
			});	
			
			/**添加数据、传参**/
			// 底部设置
	        var _bottom_uc = '<li class="msg_setting_ucMsg" style="width:'+_pulldownLiWidth+'px;padding-left:5px;height:38px;">' + 
	            '<div class="msg_setting_uc msg_setting_open">'+$.i18n("uc.openExchangeCenter.js")+'</div>' + 
	            '<div class="msg_setting_uc msg_setting_all">'+$.i18n("portal.message.ignoreall")+'</div>' + 
	            '<div class="msg_setting_uc msg_setting_see">'+$.i18n("portal.message.seeall")+'</div>' + 
	            '</li>';
	        $('.uc_container ul').append(_bottom_uc);
	        $(".msg_setting_open").click(function(){
                openExchangeCenter();
            });
	        if($(".uc_container li").size()==1){
	        	$(".msg_setting_all").css({
	        		"color":"#d1d1d1",
	        		"cursor":"default"
	        	});
	        	$(".msg_setting_see").css({
	        		"color":"#d1d1d1",
	        		"cursor":"default"
	        	});
	        }else{
	        	$(".msg_setting_all").css({
	        		"color":"#787878",
	        		"cursor":"hand"
	        	}).click(function(){
	        		ignoreAll();
                }); 
	        	$(".msg_setting_see").css({
	        		"color":"#787878",
	        		"cursor":"hand"
	        	}).click(function(){
                    viewAll();
                }); 
	        }
	        
			var _iframeWidth = $('.uc_container').width();
			var _iframeHeight =  $('.uc_container').height();
			$('.uc_container').css({
				'top':_top,
				'right':_right
			});
			$('.uc_iframe').css({
				'top':_top,
				'right':_right,
				'width':_iframeWidth,
				'height':_iframeHeight
			});	
			
			
			
			$('.uc_container ul li').css("line-height","12px");
			$('.uc_container ul li.pushdown_second').css("padding-left","5px").css("height","auto");
			$(".uc_msg_ico_1").mouseenter(function(){
				$(this).hide();
				$(this).parent().find(".uc_msg_ico_2").show();
			});
			$(".uc_msg_ico_2").mouseleave(function(){
				$(this).hide();
				$(this).parent().find(".uc_msg_ico_1").show();
			}).click(function(){
				ignoreOne($(this).attr("key"));
			});
		}
        initMESG();
        
		var _ff = true;
		$('.msg_ioc').mouseenter(function(){
			$('.djwk_container').hide();
			$('.djwk_iframe').hide();
			$('.person_container').hide();
			$('.person_iframe').hide();
			$('.person_container').hide();
			$('.searchArea').hide();
			$('.searchAreaIframe').hide();
			setTimeout(function(){
                if(msgProperties.size() == 0){
                	return;
                }
				initMESG();
				var _uc = $(".msg_ioc");
				var _uc_offset = _uc.offset();
				var _pulldownPoint = $(window).width()-(_uc_offset.left)-45;
			//	console.log(_pulldownPoint);
				$('.uc_container  .space_item2').css("right", _pulldownPoint+"px");
				$('.uc_container  .space_item1').css("right", _pulldownPoint+"px");
				$(".uc_container").css("padding-bottom","0px");
				$('.uc_container').show();
				$('.uc_iframe').width($('.uc_container')[0].clientWidth).height($('.uc_container')[0].clientHeight).show();
				$(".msg_setting_ucMsg").css({
					"line-height":"150%"
				});
				//$(".msg_setting_ucMsg").parent().parent().css("padding-bottom","0");
			},200);
		}).mouseleave(function(){
			//setTimeout(function(){
				if(_ff){
					//$(".msg_setting_ucMsg").parent().parent().css("padding-bottom","18px");
					$('.uc_container').hide();
					$('.uc_iframe').hide();
				}
			//},200);
		});
		$('.uc_container').mouseenter(function(e){
			$('.djwk_container').hide();
			$('.djwk_iframe').hide();
			$('.person_container').hide();
			$('.person_iframe').hide();
			$('.person_container').hide();
			$('.searchArea').hide();
			$('.searchAreaIframe').hide();
			_ff = false;
			$(".msg_setting_ucMsg").css({
				"line-height":"150%"
			});
			//$(".msg_setting_ucMsg").parent().parent().css("padding-bottom","0");
			$(this).show();
			$('.uc_iframe').show();
			$(".searchArea").hide();
			$('.searchAreaIframe').hide();
		}).mouseleave(function(e){
			if(e.target.className == 'space_item2' || e.target.className == 'space_item1'){return}
			_ff = true;
			$('.uc_iframe').hide();
			$(this).hide();
			//$(".msg_setting_ucMsg").parent().parent().css("padding-bottom","18px");
		});
	},
	//左侧导航 （展开、收起）
	initChangeLeftNav:function(){
		
		$(".change_nav_left").mouseenter(function(){
			$(".change_nav_left span").addClass("change_nav_left_current");
		}).mouseleave(function(){
			$(".change_nav_left span").removeClass("change_nav_left_current");
		}).click(function(){
		  
		  if( _judgeNum == "1"){ //收起
			  $.hideLeftNavigation();
			  $(".send_sms_16").hide();
			  $("#onlineCard").hide();
		  }else{ //展开
			  $.showLeftNavigation();
			  $(".send_sms_16").show();
			  $("#onlineCard").show();
		  }
		  
		  //异步后台记录用户操作
		  var param = new Object();
          param['left_panel_set'] = _judgeNum;
		  new portalManager().setCurrentUserCustomize(param,{
			  success : function(){
			  }
		  });
		  //工作区空间重新刷新栏目
		  setTimeout(function(){
			  refreshAllSection();
		  },200);
		});
		if( _judgeNum == "1"){//展开
			$.showLeftNavigation();
		    $(".head_msg_16").show();
		    if(!$.ctx.CurrentUser.isInternal){
		      $("#onlineCard").hide();
		    }else{
		      $("#onlineCard").show();
		    }
		}else{ //收起
			$.hideLeftNavigation();
		    $(".head_msg_16").hide();
		    $("#onlineCard").hide();
		}
	},
	
	//收起左面板
	hideLeftNavigation : function(){
		    var _ChangeWidth = 60; //导航展开宽度
			var _navBoxColor = 60;
			var _photoIco = [
				["94","91"],
				["36","36"]
			];
			_judgeNum = "2";
			$(".vst_online span:eq(1)").hide();
			$("#online_uc").hide();
			$("#vst_state").css({
				'top':74,	
				'left':5
			});
			$(".nav_title").hide();
			$(".avatar").css("left","10px");//人员头像
			$(".change_nav_left span").addClass("expansionIco");
			$(".change_nav_left span").removeClass("collapseIco");
			$("#nav_pre").removeClass("nav_left").addClass("nav_left_1");
			$("#nav_next").removeClass("nav_right").addClass("nav_right_1");
			$(".nav_moreIco").css("right","15px");//三个点
			$(".avatar").css("top","13px");
			$(".line").css("height","78px");
			$(".shortcut_pop").css("top","130px");
			$('.shortcut_iframe').css('left','60px').css("top","130px");
			$(".lineBg").css({
				'width': 60,
				'height': 78	
			});
			$(".nav_icon").css({
				'margin-left': 20,
				'margin-top':15	
			});
			$(".change_nav_left").css({
				'top':0,
				'right':0
		  	});
			$(".avatar").css({
				'width':36,
				'height':36	
			});
			$(".line_addIco").css({
				'right':18,
				'top':65
			});
			$(".avatar img").attr("width","36").attr("height","36");
			$(".layout_right .layout_content_main").css("margin-left","82px");
			$.initLayout();//主要目的是初始化菜单区域高度
			$(".layout_left").css("width",_ChangeWidth+"px");
			$('.nav_box_bgcolor').css("width",60);
			$(".line").css("width",_ChangeWidth+"px");
			$(".space").css("width",_ChangeWidth+"px");
			$(".nav").css("width",_ChangeWidth+"px");
			$('.mynav_box_bgcolor').css("width",_ChangeWidth+"px");
			$(".second_menu_contaner").css("left",_ChangeWidth+"px");
			$("#second_menu_iframe").css("left",_ChangeWidth+"px");
			$(".navPager").css("width",_ChangeWidth+"px");
			$(".current_item .nav_box_color").css("width",_navBoxColor+"px");
			$(".nav_item").mouseenter(function(){
			$(".current_item .nav_box_color").css("width",_navBoxColor+"px");
			}).mouseleave(function(){
			 $(".nav_box_color").css("width","4px"); 
			});
			
            if($("#main").attr("src").indexOf("ViewPage=plugin/nc/A8")!= -1){
				//$.deeLayout(11);
			}
	  },
	  //展开左面板
	  showLeftNavigation : function(){
		    var _ChangeWidth = 142; //导航展开宽度
			var _navBoxColor = 48;
			var _photoIco = [
				["94","91"],
				["36","36"]
			];
			_judgeNum = "1";
			$(".vst_online span:eq(1)").show();
			//$(".space span:eq(1)").show();
			//$(".space span:eq(2)").show();
			$(".avatar").css("top","10px");
			$("#online_uc").show();
			$(".nav_title").show();
			$(".avatar").css("left","16px");
			$(".change_nav_left span").addClass("collapseIco");
			$(".change_nav_left span").removeClass("expansionIco");
			$("#nav_pre").removeClass("nav_left_1").addClass("nav_left");
			$("#nav_next").removeClass("nav_right_1").addClass("nav_right");
			$(".nav_moreIco").css("right","59px");
			$(".line").css("height","130px");
			$(".shortcut_pop").css("top","181px");
			$('.shortcut_iframe').css('left',_ChangeWidth).css("top","181px");
			$("#vst_state").css({
				'top':126,	
				'left':25
			});
			$(".nav_icon").css({
				'margin-left': 15,
				'margin-top':0	
			});
			$(".lineBg").css({
				'width': 142,
				'height': 130	
			});
			$(".change_nav_left").css({
				'top':11,
				'right':0
		  	});
			$(".avatar").css({
				'width':94,
				'height':91
			});
			$(".line_addIco").css({
				'right':4,
				'top':70
			});
			$(".avatar img").attr("width","94").attr("height","91");
			$(".layout_right .layout_content_main").css("margin-left","162px");
			$.initLayout();
			$('.mynav_box_bgcolor').css("width",_ChangeWidth+"px");
			$(".layout_left").css("width",_ChangeWidth+"px");
			$('.nav_box_bgcolor').css("width",142);
		    $(".line").css("width",_ChangeWidth+"px");
			$(".space").css("width",_ChangeWidth+"px");
			$(".nav").css("width",_ChangeWidth+"px");
			$(".second_menu_contaner").css("left",_ChangeWidth+"px");
			$("#second_menu_iframe").css("left",_ChangeWidth+"px");
			$(".navPager").css("width",_ChangeWidth+"px");
			$(".current_item .nav_box_color").css("width",_navBoxColor+"px");
			$(".nav_item").mouseenter(function(){
			$(".current_item .nav_box_color").css("width",_navBoxColor+"px");
			}).mouseleave(function(){
			 $(".nav_box_color").css("width","4px"); 
			});
			
            if($("#main").attr("src").indexOf("ViewPage=plugin/nc/A8")!= -1){
				//$.deeLayout(1);
			}
			 
			
	  },
	//初始化我的快捷
	initMyShortcut:function(myShortcuts){
		var _shortcutPop = $('.shortcut_pop');
		var _shortcutIframe = $('.shortcut_iframe');
		//快捷绑定事件
		$('#myShortcutDiv').mouseenter(function (){
			if($(".layout_left").width() == 60){
				$(this).find(".mynav_box_color").css("width","60px");
				$(this).find(".mynav_box_bgcolor").css("width","60px");
				_shortcutPop.css("left",60);
				_shortcutIframe.css("left",60);
			}else{
				$(this).find(".mynav_box_color").css("width","48px");
				$(this).find(".mynav_box_bgcolor").css("width","142px");
				_shortcutPop.css("left",142);
				_shortcutIframe.css("left",142);
			}
			$(this).addClass("current_item");
			if(_shortcutPop.attr('length') == 'null'){return;}
			_shortcutPop.show();
			_shortcutIframe.show();
			//我的快捷下属子菜单，鼠标移上去后我的快捷变色
			_shortcutPop.mouseenter(function(e) {
				$('#myShortcutDiv').addClass("current_item");
			}).mouseleave(function(e) {
				$('#myShortcutDiv').removeClass("current_item");
			});
			//我的快捷子菜单
			$('.shortcut_list ul li').mouseenter(function (){
				if(skinPathKey=="GOV_red"){
					$(this).css('background','#fcd8cb').css('color','#111');
					
				}else{
					$(this).css('background','#a1daf4').css('color','#111111');
				}
				$('.shortcut_list ul li').removeClass("spaceCurrent");
				$(this).addClass("spaceCurrent");	
			}).mouseleave(function(){
				$(this).css('background','#fff').css('color','#4f4f4f');
				$('.shortcut_list ul li').removeClass("spaceCurrent");
			}).unbind("click").click(function(){
				  $('.shortcut_title').css('color','#ffffff');
				  $('.current_flag').removeClass('current_flag');
				  $('#myShortcutDiv').addClass("current_flag");
				_shortcutPop.hide();
				_shortcutIframe.hide();
			});		
		}).mouseleave(function (){
			$('.shortcut_title').css('color','#ffffff');
			_shortcutPop.hide();
			_shortcutIframe.hide();
			$(this).removeClass("current_item");
			if(getCtpTop().systemProductId != 7){
				$(".mynav_box_color").css("width","4px");
			}else{
				$(".mynav_box_color").css("width","0px");
			}
					
		});

		_shortcutPop.mouseenter(function (){
			$(this).show();
			_shortcutIframe.show();
		}).mouseleave(function (){
			$(this).hide();
			_shortcutIframe.hide();
		});
		//代理事项绑定事件
		if("true" == hasAgent){
			$('#agentNav').mouseenter(function (){
				if($(".layout_left").width() == 60){
					$(this).find(".mynav_box_color").css("width","60px");
					$(this).find(".mynav_box_bgcolor").css("width","60px");
				}else{
					$(this).find(".mynav_box_color").css("width","48px");
					$(this).find(".mynav_box_bgcolor").css("width","142px");
				}
				$(this).addClass("current_item");
			}).mouseleave(function (){
				$(this).find('.shortcut_title').css('color','#ffffff');
				$(this).removeClass("current_item");
				if(getCtpTop().systemProductId != 7){
					$(".mynav_box_color").css("width","4px");
				}else{
					$(".mynav_box_color").css("width","0px");
				}
			}).click(function(){
				$('.current_flag').removeClass('current_flag');
				$('#agentNav').addClass("current_flag");
				showShortcut('/collaboration/pending.do?method=morePending&from=Agent','mainfrm');
			});
		}
		//快捷插入数据	
/*		$('.shortcut_pop').empty().append('<div id="shortcut_list1" class="shortcut_list"><ul></ul></div>');
		if(myShortcuts == null){$('.shortcut_pop').attr('length','null'); return;}else{$('.shortcut_pop').removeAttr('length');}
		var _shortcutNum = myShortcuts.length;
		var num = 1;
		//分列
		for(var i = 0; i < _shortcutNum; i++)
		{
			var shortcutIcon;
			if(myShortcuts[i].iconKey){
				shortcutIcon = _ctxPath + '/main/skin/frame/'+skinPathKey+'/menuIcon/'+myShortcuts[i].iconKey;
			}else{
				shortcutIcon = _ctxPath + '/main/skin/frame/'+skinPathKey+'/images/space_ico.png';
			}
			
			if(i%6 == 0){
				num = num + 1;
				$('.shortcut_pop').append('<div id="shortcut_list'+ num +'" class="shortcut_list"><ul></ul></div>');
				$('#shortcut_list'+ num +' ul').append('<li title="' + myShortcuts[i].nameKey + '" onclick="showShortcut(\'' + myShortcuts[i].urlKey.escapeHTML() + '\',\''+myShortcuts[i].target+'\')"><span class="shortcut_ico"><img src=' + shortcutIcon + ' ></span><span class="shortcut_text">' + myShortcuts[i].nameKey +'</span></li>');
			}
			else{
				$('#shortcut_list'+ num +' ul').append('<li title="' + myShortcuts[i].nameKey + '" onclick="showShortcut(\'' + myShortcuts[i].urlKey.escapeHTML() + '\',\''+myShortcuts[i].target+'\')"><span class="shortcut_ico"><img src=' + shortcutIcon + ' ></span><span class="shortcut_text">' + myShortcuts[i].nameKey +'</span></li>');	
			}
		}*/
		$('.shortcut_pop').empty().append('<div id="shortcut_list1" class="shortcut_list"><ul></ul></div>');
		if(myShortcuts == null){$('.shortcut_pop').attr('length','null'); return;}else{$('.shortcut_pop').removeAttr('length');}
		var shortcut_lists = new Array();
		var items = new Array();
		shortcut_lists.push(items);
		
		var _shortcutNum = myShortcuts.length;
		//分列
		for(var i = 0; i < _shortcutNum; i++)
		{
			var iconClass = "";
			var imageUrl = "";
			//var shortcutIcon;
			if(myShortcuts[i].iconKey){
				iconClass = "class=\"portal_menu_icon menu_shortcut_" + myShortcuts[i].iconKey.split(".")[0] + "\"";
				//shortcutIcon = _ctxPath + '/main/skin/frame/'+skinPathKey+'/menuIcon/'+myShortcuts[i].iconKey;
			}else{
				imageUrl = "background-image:url('" + _ctxPath + "/main/skin/frame/" + skinPathKey + "/images/space_ico.png')";
				//shortcutIcon = _ctxPath + '/main/skin/frame/'+skinPathKey+'/images/space_ico.png';
			}
			
			var li = '<li title="' + myShortcuts[i].nameKey + '" onclick="showShortcut(\'' + myShortcuts[i].urlKey.escapeHTML() + '\',\''+myShortcuts[i].target+'\')"><span class="shortcut_ico"><span ' + iconClass + ' style="display: inline-block;' + imageUrl + '"></span></span><span class="shortcut_text">' + myShortcuts[i].nameKey +'</span></li>';
			if(i%6 == 0){

				items = new Array();
				shortcut_lists.push(items);
			}
			items.push(li);
		}
		var html = new Array();
		for (var i = 0; i < shortcut_lists.length; i++) {
			html.push('<div id="shortcut_list'+(i+1)+'" class="shortcut_list"><ul>'+shortcut_lists[i].join('')+'</ul></div>');
		};
		$('.shortcut_pop').empty().append(html.join(''));
		if(myShortcuts == null){$('.shortcut_pop').attr('length','null'); return;}else{$('.shortcut_pop').removeAttr('length');}

		var _shortPopWidth = _shortcutPop.width()+5;
		var _shortPopHeight = _shortcutPop.height()+5;
		_shortcutIframe.css({
			'width':_shortPopWidth,
			'height':_shortPopHeight,
			'left':142
		});	
		if(getCtpTop().systemProductId == 7){
			$("#myShortcutDiv").find(".mynav_box_color").css("width","0")
		}
	},
	//个人信息设置--退出
	initPulldownInfor:function(pullDownInfors,_top,_right,_pulldownLiWidth){
		var _pullDownInforsLength = pullDownInfors.length;//数据
		var _top = 50; 
		var _right = 10;
		var _pulldownLiWidth = 100;
		if ($.browser.msie) {
			if ($.browser.version == '6.0') {
				_right = _right + 10;
			}
		}
		$('.person_container').append('<div class="space_item2">◆</div><div class="space_item1">◆</div><ul></ul>');
		for(var i = 0; i < _pullDownInforsLength; i++){
			$('.person_container ul').append('<li id="'+ pullDownInfors[i][2] +'" class="pushdown_second"><span class="pushdown_second_name">'+ pullDownInfors[i][0] +'</span></li>');
		}
		
		
		var _iframeWidth = $('.person_container').width();
		var _iframeHeight =  $('.person_container').height();
		$('.person_container').css({
			'top':_top,
			'right':_right
		});
		$('.person_iframe').css({
			'top':_top,
			'right':_right,
			'width':_iframeWidth-15,
			'height':_iframeHeight
		});	
		$('.person_container ul li').css('width',_pulldownLiWidth+'px').mouseenter(function (event){
			if(skinPathKey=="GOV_red"){
				$(this).css('background','#306fc4').css('color','#fff');
			}else{
				$(this).css('background','#42b3e5').css('color','#fff');
			}
		}).mouseleave(function(event){
			$(this).css('background','#fff').css('color','#000');
		}).click(function(){
			$('.person_container').hide();
			$('.person_iframe').hide();
		});	
		
		//换肤
		$.initSkin();
		//登出
		$("#logout").click(function(){
		  logout();
		});
		$(".admin_exit_ico").click(function(){
			logout();
		});
		//个人事务
		$("#mySet").click(function(){
		  var url = "/portal/portalController.do?method=personalInfo";
	      var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'/></span>";
	      html += "<span class='nowLocation_content'>";
	      html += "<a class=\"hand\" onclick=\"showMenu('"+_ctxPath+"/portal/portalController.do?method=personalInfo')\">" + $.i18n("menu.personal.affair") + "</a>";
	      html += "</span>";
	      getCtpTop().showLocation(html);
	      getCtpTop().showMenu(_ctxPath + url);
	      gotoDefaultPortal();
	      //gotoDefaultPortal();
	      //showShortcut('/portal/portalController.do?method=personalInfo','mainfrm');
		});
		//个人信息
		$("#personalInfo").click(function(){
	      var url = "/personalAffair.do?method=personalInfo";
          var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'/></span>";
          html += "<span class='nowLocation_content'>";
          html += "<a class=\"hand\" onclick=\"showMenu('"+_ctxPath+"/portal/portalController.do?method=personalInfo')\">" + $.i18n("menu.personal.affair") + "</a>";
          html += " &gt; <a class=\"hand\" onclick=\"showMenu('" + _ctxPath+ "/portal/portalController.do?method=personalInfoFrame&path="+url + "')\">" + $.i18n("personal.message.label") + "</a>";
          html += "</span>";
          getCtpTop().showLocation(html);
          getCtpTop().showMenu(_ctxPath + "/portal/portalController.do?method=personalInfoFrame&path="+url);
          gotoDefaultPortal();
		});
		//薪资查看
		$("#viewSalary").click(function(){
		  var url = "/hrViewSalary.do?method=viewSalary";
		  var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'/></span>";
	      html += "<span class='nowLocation_content'>";
	      html += "<a class=\"hand\" onclick=\"showMenu('"+_ctxPath+"/portal/portalController.do?method=personalInfo')\">" + $.i18n("menu.personal.affair") + "</a>";
	      html += " &gt; <a class=\"hand\" onclick=\"showMenu('" + _ctxPath+ "/portal/portalController.do?method=personalInfoFrame&path="+url + "')\">" + $.i18n("menu.hr.salary.show") + "</a>";
	      html += "</span>";
	      getCtpTop().showLocation(html);
	      getCtpTop().showMenu(_ctxPath + "/portal/portalController.do?method=personalInfoFrame&path="+url);
	      gotoDefaultPortal();
		});
		//菜单设置
		$("#menuSetting").click(function(){
          var url = "/portal/portalController.do?method=showMenuSetting";
          var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'/></span>";
          html += "<span class='nowLocation_content'>";
          html += "<a class=\"hand\" onclick=\"showMenu('"+_ctxPath+"/portal/portalController.do?method=personalInfo')\">" + $.i18n("menu.personal.affair") + "</a>";
          html += " &gt; <a class=\"hand\" onclick=\"showMenu('" + _ctxPath+ "/portal/portalController.do?method=personalInfoFrame&path="+url + "')\">" + $.i18n("personalSetting.menu.label") + "</a>";
          html += "</span>";
	      getCtpTop().showLocation(html);
	      getCtpTop().showMenu(_ctxPath + "/portal/portalController.do?method=personalInfoFrame&path="+url);
	      gotoDefaultPortal();
		});
		//快捷设置
		$("#shortcutSet").click(function(){
	      var url = "/portal/portalController.do?method=showShortcutSet";
	      var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'/></span>";
          html += "<span class='nowLocation_content'>";
          html += "<a class=\"hand\" onclick=\"showMenu('"+_ctxPath+"/portal/portalController.do?method=personalInfo')\">" + $.i18n("menu.personal.affair") + "</a>";
          html += " &gt; <a class=\"hand\" onclick=\"showMenu('" + _ctxPath+ "/portal/portalController.do?method=personalInfoFrame&path="+url + "')\">" + $.i18n("personalSetting.shortcut.label") + "</a>";
          html += "</span>";
          getCtpTop().showLocation(html);
          getCtpTop().showMenu(_ctxPath + "/portal/portalController.do?method=personalInfoFrame&path="+url);
          gotoDefaultPortal();
		});
		//if("false" == isAdmin){
			//$('.setting_ico').click(function(){
				//个人事务
				//showShortcut('/portal/portalController.do?method=personalInfo','mainfrm');
			//});
		//}
		var _ff = true;
		$('.setting_ico').mouseenter(function(){
			$('.uc_container').hide();
			$('.uc_iframe').hide();
			$('.djwk_container').hide();
			$('.djwk_iframe').hide();
			$('.person_container').hide();
			$('.searchArea').hide();
			$('.searchAreaIframe').hide();
			setTimeout(function(){
				if("desktop" == currentPortalTemplate){
					$('#skin').hide();
				}else{
					$('#skin').show();
				}
				$('.person_container  .space_item2').css("right", "10px");
				$('.person_container  .space_item1').css("right", "10px");			
				$.setOffice('hidden');
				$('.person_container').show();
				$('.person_iframe').width(parseInt($('.person_container')[0].clientWidth)).height(parseInt($('.person_container')[0].clientHeight)+5).show();
			},200);
		}).mouseleave(function(){
			setTimeout(function(){
				if(_ff){
					if("default" == currentPortalTemplate)$('#skin').show();
					$('.person_container').hide();
					$('.person_iframe').hide();
					$.setOffice('visible');
				}
			},200);
		});
		$('.person_container').mouseenter(function(){
			_ff = false;
			$(this).show();
			$('.person_iframe').show();
			$.setOffice('hidden');
		}).mouseleave(function(e){
			if(e.target.className == 'space_item2' || e.target.className == 'space_item1'){return}
			_ff = true;
			$('.person_iframe').hide();
			$(this).hide();
			$.setOffice('visible');
		});		
		
	},
	//初始化搜索
	initSearch:function(searchRuValue,_top,_right,_pulldownLiWidth){
		//搜索结果类型
		var _searchRuValue = searchRuValue.length;
		var textVal;//输入框内容
		var _top;
		var _right;
		var _pulldownLiWidth;
		$('.searchButton').attr('qq','1');
		$('.searchButton').click(function(){
			var _qq  = $('.searchButton').attr('qq');
			if(_qq == '1'){
				var _searchButton = $(".searchButton");
				var _offset = _searchButton.offset();
				var _pulldownPoint = $(window).width()-(_offset.left)-53;
				$('.uc_container').hide();
				$('.uc_iframe').hide();
				$('.djwk_container').hide();
				$('.djwk_iframe').hide();
				$('.person_container').hide();
				$('.person_iframe').hide();
				$('.person_container').hide();
				$('.space_pop').hide();
				
				$('.searchArea  .search_them2').css("right", _pulldownPoint+"px");
				$('.searchArea  .search_them1').css("right", _pulldownPoint+"px");
				$(".searchArea").show();
				$(".searchAreaIframe").show();
				$(".searchAreaInput").focus();
				$(".searchAreaInput").val('');
				textVal = $(".searchAreaInput").val();
				$('.pulldown').hide();
				$('.pulldownIframe').hide();
				$('.searchButton').attr('qq','0');
			}else{
				$(".searchArea").hide();
				$(".searchAreaIframe").hide();
				$('.pulldown').hide();
				$('.pulldownIframe').hide();
				$('.searchButton').attr('qq','1');
			}
		});
		$('.search_close').click(function(){
			$(".searchArea").hide();
			$(".searchAreaIframe").hide();
			$('.pulldown').hide();
			$('.pulldownIframe').hide();
			$('.searchButton').attr('qq','1');
		});
		
		
		$(".searchAreaInput").focus(function(){
			var textVala = $(".searchAreaInput").val();
			if(textVala == ''){
				$('.pulldown').hide();
				$('.pulldownIframe').hide();
			}else{
				addendSearchRuVal();//插入数据
				$.initPullDown(_top,_right,_pulldownLiWidth);//显示下拉列表
			}
		});
		
		//插入搜索下拉数据
		function addendSearchRuVal(){
			_top = 111; 
			_right = 286;
			_pulldownLiWidth = 269;
			$('.pulldown ul').remove();
			$('.pulldown').attr('target',"pullSearch");
			$('.pulldown').append('<ul></ul>');
			var txt = escapeStringToHTML(textVal);
			for(var i = 0; i < _searchRuValue; i++){
				$('.pulldown ul').append('<li style="color:#747373;font-size:14px;"><span style="width:65px;display: inline-block;">'+ searchRuValue[i]+ '</span><span>' + txt + '</span></li>');
			}
			//对应所属应用分类
            var searchRuKey = ['all','1','4','6','7','3','accessories'];
			$('.pulldown ul li:eq(0)').css('background','#42b3e5').css('color','#fff');
			$('.pulldown ul li').live("click",function(){
				//$(".searchArea").hide();
				$('.pulldown').hide();
				$('.pulldownIframe').hide();
				//searchButtonVal = 1;
				gotoDefaultPortal();
				var _index = $(this).index();
                var _appCategory = searchRuKey[_index];
                gotoDefaultPortal();
                indexSearch(_appCategory);
                $("#searchClose").click();
			});
		}
		
		$(".searchAreaInput").keyup(function(){
			textVal = $(".searchAreaInput").val();
			if(textVal != ''){
				addendSearchRuVal();
				$.initPullDown(_top,_right,_pulldownLiWidth);
				$('.pulldown ul li').unbind().mouseenter(function (){
				$(this).css({
					'background':'#42b3e5',
					'color':'#fff',
					'font-size':'14px'
				});	
			}).mouseleave(function(){
				$(this).css({
					'background':'#fff',
					'color':'#747373',
					'font-size':'14px'
				});
			});
			}else{
				$('.pulldown').hide();
				$('.pulldownIframe').hide();
				$(".searchAreaInput").val('');
			}
			targetVal = $('.pulldown').attr('target');
			
			if(targetVal == 'pullSearch'){
				$('.searchArea').unbind().mouseenter(function (){
					$.initPullDown(_top,_right,_pulldownLiWidth);
					$(".searchArea").show();
					$('.searchAreaIframe').show();
					textVal = $(".searchAreaInput").val();
					if(textVal == ''){
						$('.pulldown').hide();
						$('.pulldownIframe').hide();
					}else{
						$('.pulldown').show();
						$('.pulldownIframe').show();
					}
				}).mouseleave(function(){
					//$(".searchArea").hide();
					$('.pulldown').hide();
					$('.pulldownIframe').hide();
				});
				$('.pulldown').unbind().mouseenter(function (){
					$(".searchArea").show();
					$('.searchAreaIframe').show();
					$('.pulldown').show();
					$('.pulldownIframe').show();
				}).mouseleave(function(){
					//$(".searchArea").hide();
					$('.pulldown').hide();
					$('.pulldownIframe').hide();
				});
			}
		});
	},
	initSpaceObj:function(spaces,isBackToHome,redirectSpaceId,notShowSpace,_spacePop,_spaceIframe){
		var _attrFlag = $('.space_pop').attr('OK');
		if(_attrFlag == 'true'){
			return;
		}else{
			$('.space_pop').attr('OK','true')
		}
		var listArray = spaces.slice(3);
		if(listArray.length > 0){
			var _listLiNum = $('.space_list ul li').length;
			var _listDivApp = '<div class="space_list"><ul></ul></div>';
			_spacePop.empty().append('<div id="space_list1" class="space_list"><ul></ul></div>');
			
			var num = 1;
			//下拉空间
			var iconClass = "";
			for(var j = 0; j < listArray.length; j++){
				var _listSubSpaceName = listArray[j][3].length > 10 ? listArray[j][3].substring(0,10):listArray[j][3];
				iconClass = "portal_menu_icon b_" + listArray[j][8].split(".")[0];
				if(j%10 == 0){ 
					num = num + 1;
					_spacePop.append('<div id="space_list'+ num +'" class="space_list"><ul></ul></div>');
					$('#space_list'+ num +' ul').append('<li id="'+listArray[j][0]+'_li" title="'+escapeStringToHTML(listArray[j][3],false)+'" onclick="showSpace(\''+j+'\',\'' + listArray[j][0] + '\',\'' + listArray[j][2] + '\',\'' + listArray[j][6] + '\',\'' + listArray[j][7] + '\',\'true\')">' + '<span class="space_ico" style="margin-right:10px"><span class="' + iconClass + '" style="display: inline-block;"></span></span>' + escapeStringToHTML(_listSubSpaceName,false) +'</li>');
				}
				else{
					$('#space_list'+ num +' ul').append('<li id="'+listArray[j][0]+'_li" title="'+escapeStringToHTML(listArray[j][3],false)+'" onclick="showSpace(\''+j+'\',\'' + listArray[j][0] + '\',\'' + listArray[j][2] + '\',\'' + listArray[j][6] + '\',\'' + listArray[j][7] + '\',\'true\')">'+ '<span class="space_ico" style="margin-right:10px"><span class="' + iconClass + '" style="display: inline-block;"></span></span>' + escapeStringToHTML(_listSubSpaceName,false) +'</li>');	
				}
			}
			_spacePop.append('<div class="space_item2">◆</div><div class="space_item1">◆</div>');
			$("#space_list"+num+" ul li").css("margin-right","0px");
			var _spacePopWidth = _spacePop.width();
			var _spacePopHeight = _spacePop.height();
			var _nav_more_upico = $('.nav_center_more').offset();
			var _spaceItemLeft = (_spacePopWidth / 2)-6;//三角位置
			var _llll = (_nav_more_upico.left-_spacePopWidth/2)+$('.nav_center_more').width()/2;
			frountSpace.bodyWidth = parseInt(document.documentElement.clientWidth);
			if((_llll+_spacePopWidth)>frountSpace.bodyWidth){
				_llll = frountSpace.bodyWidth - _spacePopWidth;
				_spaceItemLeft = _spacePopWidth - (frountSpace.bodyWidth - _nav_more_upico.left)
			}
			$(".space_list").siblings(".space_item1").css("left", _spaceItemLeft);
      $(".space_list").siblings(".space_item2").css("left", _spaceItemLeft);
			_spacePop.width(_spacePopWidth).css("left", _llll);
			_spaceIframe.css("left", _llll);
			_spaceIframe.css('width',_spacePopWidth+8).css('height', _spacePopHeight+13);	
		}
		
		$('.space_list ul li').mouseenter(function (){
			//$(this).css('color','#fff');
			$('.space_list ul li').removeClass("spaceCurrent");	
			$(this).addClass("spaceCurrent");	
		}).mouseleave(function(){
			$('.space_list ul li').removeClass("spaceCurrent");
		}).click(function(){
			_spacePop.hide();
			_spaceIframe.hide();
			var _nn = $('.nav_center_current').attr('iconName');
			$('.nav_center_current').find('img').attr('src',_ctxPath+'/main/skin/frame56/'+skinPathKey+'/menuIcon/'+_nn);
			$(".nav_center").removeClass("nav_center_current").removeClass("nav_top_current");
			$(".nav_center_more").removeClass("nav_top_style");
			$(".nav_center_more").addClass("nav_top_style");
		});
		_spacePop.mouseenter(function (){
			$('.searchButton').attr('qq','0');
			$(this).show();
			_spaceIframe.show();
			$(".nav_center_more").addClass("nav_top_current");
		}).mouseleave(function (e){
			if(e.target.className == "space_item2" || e.target.className == "space_item1"){return}
			$('.searchButton').attr('qq','1');
			$(this).hide();
			_spaceIframe.hide();
			$(".nav_center_more").removeClass("nav_top_current");
		});
	},
	//初始化空间
	initSpace:function(spaces,isBackToHome,redirectSpaceId,notShowSpace){
		if(spaces && spaces.length > 0){
			var _spacePop = $('.space_pop');
			var _spaceIframe = $('.space_iframe');
			var spaceHtml = "";
			var hasShowSpace = false;
			var defaultspaceLen = 3;
			//插入默认展开3个空间
			for(var i = 0; i < spaces.length ; i++){
				if(!hasShowSpace&&!notShowSpace){
			        if(redirectSpaceId && (spaces[i][0] == redirectSpaceId || spaces[i][1] == redirectSpaceId)){
			          showSpace(i,spaces[i][0],spaces[i][2],spaces[i][6],spaces[i][7],true);
			          hasShowSpace = true;
			        } else if(isBackToHome && currentSpaceId && (spaces[i][0] == currentSpaceId || spaces[i][1] == currentSpaceId)){
			          showSpace(i,spaces[i][0],spaces[i][2],spaces[i][6],spaces[i][7],true);
			          hasShowSpace = true;
			        }else if(!redirectSpaceId&&!isBackToHome&&i==0){
			          showSpace(i,spaces[i][0],spaces[i][2],spaces[i][6],spaces[i][7],true);
			          hasShowSpace = true;
			        }
			    }
			    //NCPortal集成A8,隐藏A8集成的ERP空间
		        if("${topFrameName!=null}"=="true" && (spaces[i][0]).indexOf("101") !=-1){
		            continue;
		        }
		        var currentSpaceClass = "";
		        var currentSpaceImg="";
		        if(currentSpaceId == spaces[i][0]) {
		        	/**
		        	 * TODO:如果currentSpaceId匹配上，显示选中效果
		        	 */
		        	 currentSpaceClass = "nav_center_current";
		        	 currentSpaceImg = "spacehover/";
		        }

				if(i < defaultspaceLen){
					var _subSpaceName = spaces[i][3].length > 6 ? spaces[i][3].substring(0,6):spaces[i][3];
					spaceHtml += '<div class="nav_center '+currentSpaceClass+'" iconName="'+spaces[i][8]+'" title="'+escapeStringToHTML(spaces[i][3],false)+'" onclick="showSpace(\''+i+'\',\'' + spaces[i][0] + '\',\'' + spaces[i][2] + '\',\'' + spaces[i][6] + '\',\'' + spaces[i][7] + '\',\'true\')"><span class="nav_center_title">' + escapeStringToHTML(_subSpaceName,false) +'</span><div class="nav_center_currentIco" id="_currentIco_'+spaces[i][0]+'">&nbsp;</div></div>';	
				}
			}
			$('.area_r_icon').empty().append(spaceHtml);
			
			if(spaces.length > 3){
				$('.area_r_icon').append('<div class="nav_center_more"><span class="nav_more_upico"></span></div>');
			}
			$(".nav_center").click(function (){
				var _nn = $('.nav_center_current').attr('iconName');
				$('.nav_center_current img').attr('src',_ctxPath+'/main/skin/frame56/'+skinPathKey+'/menuIcon/'+_nn);
				$(".nav_center").removeClass("nav_center_current").removeClass("nav_top_current");
				$(".space_list ul li").removeClass("spaceStyle");
				$(this).addClass("nav_center_current").addClass("nav_top_current");	
				var _n = $(this).attr('iconName');
				$(this).find('img').attr('src',_ctxPath+'/main/skin/frame56/'+skinPathKey+'/menuIcon/spacehover/'+_n);
				$(".nav_center_more").removeClass("nav_top_style");
				_spacePop.hide();
				_spaceIframe.hide();
			}).mouseenter(function(){
				if($(this).hasClass('nav_center_current')) return;
				var _n = $(this).attr('iconName');
				$(this).addClass("nav_top_current");	
				$(this).find('img').attr('src',_ctxPath+'/main/skin/frame56/'+skinPathKey+'/menuIcon/spacehover/'+_n);
			}).mouseleave(function(){
				if($(this).hasClass('nav_center_current')) return;
				var _n = $(this).attr('iconName');
				$(this).removeClass("nav_top_current");	
				$(this).find('img').attr('src',_ctxPath+'/main/skin/frame56/'+skinPathKey+'/menuIcon/'+_n);
			});
			$('.nav_more_upico').mouseenter(function(){
				$(this).removeClass('nav_more_upico').addClass("nav_more_upico_hover");
			}).mouseleave(function(){
				$(this).removeClass('nav_more_upico_hover').addClass("nav_more_upico");
			});
			
			
			//绑定更多空间按钮事件
			$('.nav_center_more').attr('qq','1');
			$('.nav_center_more').mouseenter(function (){
				$('.uc_container').hide();
				$('.uc_iframe').hide();
				$('.djwk_container').hide();
				$('.djwk_iframe').hide();
				$('.person_container').hide();
				$('.person_iframe').hide();
				$('.person_container').hide();
				$('.searchArea').hide();
				$('.searchAreaIframe').hide();
				setTimeout(function(){
					$.initSpaceObj(spaces,isBackToHome,redirectSpaceId,notShowSpace,_spacePop,_spaceIframe);
					_spacePop.show();
					_spaceIframe.show();
					$('.nav_center_more').addClass("nav_top_current");
					$('.spaceStyle').removeClass('spaceStyle');
					$('#'+currentSpaceId+'_li').addClass("spaceStyle");
				},200);
			}).mouseleave(function (){
				setTimeout(function(){
					if($('.searchButton').attr('qq') == '1'){
						_spacePop.hide();
						_spaceIframe.hide();
						$('.nav_center_more').removeClass("nav_top_current");	
					}
				},200);
				
		
			});
		}
		
	},
	//初始化在线状态
	initOnLine:function(){
		$('#vst_online_state').click(function(){
			$('#vst_state').show();
		});
		$('#vst_online').mouseleave(function(){
			$('#vst_state').hide();
		});
		$('#vst_state').mouseenter(function(){
			$(this).show();
		}).mouseleave(function(){
			$(this).hide();
		});

		$('.vst_state_item').click(function(){
			var _id = this.id;
			var _val = $(this).attr("value");
			$('#vst_online_state').html("<em class='skin_ico16 " + _id + "'></em><span class='padding_l_5'></span>");
			$('#vst_state').hide();
			try{
				pushOnlineState(_id);
			}catch(e){
				  
			}
			try{
				var onLine = new onlineManager();
				onLine.updateOnlineSubState(_val,{
					success : function (ret) {
					}
				});
			}catch(e) {
			}
		});
		$('#vst_online').css({
			"color":"#fff",
			"font-weight":"normal"
		});
	},
	//初始化时间轴
	initTimeLine : function(){
	  //拉动事件
	  $( "#dragSkin" ).draggable({ revert: true }).bind('dragstart', function(event, ui){
	    $(".noneDiv").show();
	  }).bind('dragstop', function(event, ui){
		$(this).css('top','50');
	    $(".noneDiv").hide();
	    $(this).hide();
	    //调用时初始化
		$.initTimeLineObj();
	    timeLineObjReset(timeLineObj);
	    timeLineObj.timeShow();
	  }).click(function(){
		  //$(".noneDiv").show();
		  $(this).hide();
		  //调用时初始化
		  $.initTimeLineObj();
		  timeLineObjReset(timeLineObj);
		  timeLineObj.timeShow();
	  }).show();
	},
  initTimeLineObj : function(){
	  if(timeLineObj){
	  	return;
	  }
	  if(isCurrentUserAdmin != "true"){
	      try {
	        timeLineDate = ajaxTimeLineBean.getTimeLineResetDate("");
	      } catch (e) {
	        // TODO: handle exception
	      }
	    }
		  timeLineObj = new CtpTimeLine({
		    id : 'timeLine',
		    height : 500,
		    render : 'line',
		    date : timeLineDate[2],
				timeStep : timeLineDate[0],
				searchClick : function(){
				  timeLineObjReset(timeLineObj);
				},
				editClick:function(){
				  timeLineDialog = $.dialog({
		        url : _ctxPath + '/calendar/calEvent.do?method=editTimeLine',
		        width : 425,
		        height : 190,
		        targetWindow : getCtpTop(),
		        transParams : {
		          searchFunc : timeLineObjReset,
		          diaClose : timeLineObjDialogClose,
		          timeLineObjResetParam : timeLineObj
		        },
		        title : $.i18n('calendar.editTimeLine.title'),
		        buttons : [ {
		          id : "sure",
		          text : $.i18n('calendar.sure'),
		          handler : function() {
		            timeLineDialog.getReturnValue();      
		          }
		        }, {
		          id : "cancel",
		          text : $.i18n('calendar.cancel'),
		          handler : function() {
		            timeLineDialog.close();
		          }
		        } ]
		      });
				},
				maxClick:function(){
				  $("#timeline_close").click();
				  gotoDefaultPortal();
				  var url = _ctxPath + "/calendar/calEvent.do?method=arrangeTime&type=day";
				  var curDayArr = getCurDayStr();
				  var curDayStr = curDayArr[0] + "-" + curDayArr[1] + "-" + curDayArr[2];
				  url = url + "&selectedDate=" + curDayStr;
				  url = url + "&curDay=" + curDayStr;
				  $("#main").attr("src",url);
				},
				action : 'timeLineAction'
			});
		  timeLineObj.reset({items : timeLineDate[1]});  
  },
	//换肤，修改热点数据
  saveHotSpots : function(callback,data){
  	if(data){
  		var hotspots = $.ctx.hotspots;
  		if(isCurrentUserAdmin == "true") {
  	  		hotspots.logoImg.hotspotvalue = data.logoImg;
  		}
  		hotspots.topBgImg.hotspotvalue = data.topBgImg;
  		hotspots.topBgColor.hotspotvalue = data.topBgColor.color;
  		hotspots.topBgColor.ext5 = data.topBgColor.colorOpacity;
  		hotspots.topBgColor.ext7 = data.topBgColor.colorList;
  		hotspots.topBgColor.ext8 = data.topBgColor.colorIndex;
  		hotspots.lBgColor.hotspotvalue = data.lBgColor.color;
  		hotspots.lBgColor.ext5 = data.lBgColor.colorOpacity;
  		hotspots.lBgColor.ext7 = data.lBgColor.colorList;
  		hotspots.lBgColor.ext8 = data.lBgColor.colorIndex;
  		hotspots.cBgColor.hotspotvalue = data.cBgColor.color;
  		hotspots.cBgColor.ext5 = data.cBgColor.colorOpacity;
  		hotspots.cBgColor.ext7 = data.cBgColor.colorList;
  		hotspots.cBgColor.ext8 = data.cBgColor.colorIndex;
  		if(data.mainBgColor != null){
  			hotspots.mainBgColor.hotspotvalue = data.mainBgColor.color;
  			hotspots.mainBgColor.ext5 = data.mainBgColor.colorOpacity;
  	  		hotspots.mainBgColor.ext7 = data.mainBgColor.colorList;
  	  		hotspots.mainBgColor.ext8 = data.mainBgColor.colorIndex;
  		}
  		if(data.mainBgImg != null){
  			hotspots.mainBgImg.hotspotvalue = data.mainBgImg;
  		}
  		if(data.breadFontColor != null){
  			hotspots.breadFontColor.hotspotvalue = data.breadFontColor.color;
  			hotspots.breadFontColor.ext5 = data.breadFontColor.colorOpacity;
  	  		hotspots.breadFontColor.ext7 = data.breadFontColor.colorList;
  	  		hotspots.breadFontColor.ext8 = data.breadFontColor.colorIndex;
  		}
  		if(data.sectionContentColor != null){
  			hotspots.sectionContentColor.hotspotvalue = data.sectionContentColor.color;
  			hotspots.sectionContentColor.ext5 = data.sectionContentColor.colorOpacity;
  	  		hotspots.sectionContentColor.ext7 = data.sectionContentColor.colorList;
  	  		hotspots.sectionContentColor.ext8 = data.sectionContentColor.colorIndex;
  		}
  	}else{
  		//无更改直接退出
  		return false;
  	}
    var hotSpotsArray = new Array();
    if(getCtpTop().systemProductId == 2 || getCtpTop().systemProductId == 4 || getCtpTop().systemProductId == 5){
      if($.ctx.hotspots.groupName != null){
        hotSpotsArray.push($.ctx.hotspots.groupName);
      }
    }
    hotSpotsArray.push($.ctx.hotspots.accountName);
    hotSpotsArray.push($.ctx.hotspots.logoImg);
    hotSpotsArray.push($.ctx.hotspots.topBgImg);
    hotSpotsArray.push($.ctx.hotspots.topBgColor);
    hotSpotsArray.push($.ctx.hotspots.lBgColor);
    hotSpotsArray.push($.ctx.hotspots.cBgColor);
    hotSpotsArray.push($.ctx.hotspots.mainBgColor);
    hotSpotsArray.push($.ctx.hotspots.mainBgImg);
    hotSpotsArray.push($.ctx.hotspots.breadFontColor);
    hotSpotsArray.push($.ctx.hotspots.sectionContentColor);
    portalTemplateManagerObject.transSaveHotSpots(hotSpotsArray);
    if(typeof callback == "function"){
    	callback();
    } else {
        //$.alert($.i18n("common.successfully.saved.label"));
    	portalTemplateManagerObject.getCurrentPortalTemplateAndHotSpots({
		    success : function(data){
		      getCtpTop().$.ctx.template = $.parseJSON(data);
		      getCtpTop().refreshCtxHotSpotsData();
		      getCtpTop().$.initHotspots();
		    }
    	});
    }
  	return true;
  },
  	//获取切换布局设置
    getSwitchPortalTemplate : function(showSkinchooseTmp, isPortalTemplateSwitchingTmp){
    	//获取当前人员是否被上一层级允许切换布局,以及当前人员对下一层级的设置
    	var allowTemplateChooseSetting = portalTemplateManagerObject.getAllowPortalTemplateChoose();
    	if(allowTemplateChooseSetting == null){
    		return null;
    	}
		var parentAllowTemplateChoose = allowTemplateChooseSetting.parentAllowChoose;
		var parentChoosedTemplateId = allowTemplateChooseSetting.parentChoosedTemplateId;
		var selfPortalTemplateId = allowTemplateChooseSetting.selfPortalTemplateId;
		var templateId = null;
		var needChange = false;
		if(parentAllowTemplateChoose == "0" && parentChoosedTemplateId != $.ctx.template[0].id){
			templateId = parentChoosedTemplateId;
			needChange = true;
		}
		if(parentAllowTemplateChoose == "1" && isPortalTemplateSwitchingTmp != "true" && selfPortalTemplateId == "-1" && parentChoosedTemplateId != $.ctx.template[0].id){
			templateId = parentChoosedTemplateId;
			needChange = true;
		}
		if(parentAllowTemplateChoose == "1" && isPortalTemplateSwitchingTmp != "true" && selfPortalTemplateId != "-1" && selfPortalTemplateId != $.ctx.template[0].id){
			templateId = selfPortalTemplateId;
			needChange = true;
		}
		if(needChange){
			getCtpTop().onbeforunloadFlag = false;
		    getCtpTop().isOpenCloseWindow = false;
		    getCtpTop().isDirectClose = false;
		    var url = _ctxPath + "/main.do?method=changeLoginAccount&login.accountId=" + $.ctx.CurrentUser.loginAccount;
		    if(showSkinchooseTmp == "true"){
		    	url = url + "&showSkinchoose=true";
		    }
		    try{
				getCtpTop().location.href = url;
			}catch(e){}
			return null;
		}
		return allowTemplateChooseSetting;
    },
	//初始化换肤组件
	initSkin:function(){
		$('#skin').click(function(){
		  var allowTemplateChooseSetting = $.getSwitchPortalTemplate("true", isPortalTemplateSwitching);
		  if(allowTemplateChooseSetting == null){
			  return;
		  }
		  isPortalTemplateSwitching = false;
		  portalTemplateManagerObject.getCurrentPortalTemplateAndHotSpots({
		    success : function(data){
		      getCtpTop().$.ctx.template = $.parseJSON(data);
		      getCtpTop().refreshCtxHotSpotsData();
		      getCtpTop().$.initHotspots();
		      
		      if($('#skin_set').size()==0){
		        $('body').append('<div id="skin_set" class="skin_set_contaner clearfix '+(document.documentMode<9?'border_all':'')+'"></div><iframe id="skin_set_iframe" class="skin_set_iframe" src="about:blank" frameborder="0"></iframe>');
		      }
		      $("#skin_set").html("");
		      $("#skin_set_iframe").attr("src", "about:blank");
		      //获取当前人员是否被上一层级允许选择风格,以及当前人员对下一层级的设置
		      var setting5 = portalTemplateManagerObject.getAllowSkinStyleChoose(getCtpTop().$.ctx.template[0].id);
		      var parentAllowChoose = setting5.parentAllowChoose;
		      //获取当前人员是否被上一层级允许自定义热点,以及当前人员对下一层级的设置
		      var setting6 = portalTemplateManagerObject.getAllowHotSpotCustomize(getCtpTop().$.ctx.template[0].id);
		      var parentAllowCustomize = setting6.parentAllowCustomize;
		      var skinData = eval(portalTemplateManagerObject.getSkinDatas(getCtpTop().$.ctx.template[0].id));
		      portalskinChange = new CtpSkinChange({
		        id:'frountSkin',
		        render : 'skin_set',
		        skinId : $.ctx.hotspots.topBgImg.ext10,
		        templateId : getCtpTop().$.ctx.template[0].id,
		        allowTemplateSwitch : allowTemplateChooseSetting.parentAllowChoose,
		        topBgImg : $.ctx.hotspots.topBgImg.hotspotvalue,
		        mainBgImg : $.ctx.hotspots.mainBgImg.hotspotvalue,
		        topBgColor : {color : $.ctx.hotspots.topBgColor.hotspotvalue, colorOpacity : $.ctx.hotspots.topBgColor.ext5, colorList : $.ctx.hotspots.topBgColor.ext7, colorIndex : $.ctx.hotspots.topBgColor.ext8},
		        lBgColor : {color : $.ctx.hotspots.lBgColor.hotspotvalue, colorOpacity : $.ctx.hotspots.lBgColor.ext5, colorList : $.ctx.hotspots.lBgColor.ext7, colorIndex : $.ctx.hotspots.lBgColor.ext8},
		        cBgColor : {color : $.ctx.hotspots.cBgColor.hotspotvalue, colorOpacity : $.ctx.hotspots.cBgColor.ext5, colorList : $.ctx.hotspots.cBgColor.ext7, colorIndex : $.ctx.hotspots.cBgColor.ext8},
		        mainBgColor : {color : $.ctx.hotspots.mainBgColor.hotspotvalue, colorOpacity : $.ctx.hotspots.mainBgColor.ext5, colorList : $.ctx.hotspots.mainBgColor.ext7, colorIndex : $.ctx.hotspots.mainBgColor.ext8},
		        breadFontColor : {color : $.ctx.hotspots.breadFontColor.hotspotvalue, colorOpacity : $.ctx.hotspots.breadFontColor.ext5, colorList : $.ctx.hotspots.breadFontColor.ext7, colorIndex : $.ctx.hotspots.breadFontColor.ext8},
		        sectionContentColor : {color : $.ctx.hotspots.sectionContentColor.hotspotvalue, colorOpacity : $.ctx.hotspots.sectionContentColor.ext5, colorList : $.ctx.hotspots.sectionContentColor.ext7, colorIndex : $.ctx.hotspots.sectionContentColor.ext8},
		        changeSkin : parentAllowChoose == "1"? true : false,
		        changeBg : parentAllowCustomize == "1"? true : false,
		        onClose : function(){
		          $('#skin_set_iframe').hide('fast',function(){
		            $('#skin_set').hide('fast');
		          });
		        },
		        onChange : function(){
		      	  var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("true", "true");
		      	  if(allowTemplateChooseSetting == null){
		      		  return;
		      	  }
	      		  var setting6 = portalTemplateManagerObject.getAllowHotSpotCustomize(portalskinChange.p.templateId);
	      		  if(setting6.parentAllowCustomize == "0"){
	            	  $('#skin').click();
	            	  return;
	      		  } else {
			          getCtpTop().$.saveHotSpots(null, this);
	      		  }
		        },
		        onChooseSkinStyle : function(){
		          //选择风格
			      var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("true", "true");
			      if(allowTemplateChooseSetting == null){
			    	  return;
			      }
	      		  var setting5 = portalTemplateManagerObject.getAllowSkinStyleChoose(portalskinChange.p.templateId);
	      		  if(setting5.parentAllowChoose == "0"){
	            	  $('#skin').click();
	            	  return;
	      		  } else {
	      			  portalTemplateManagerObject.transSwitchSkinStyle(portalskinChange.p.templateId, portalskinChange.p.skinId, {
				          success : function(portalTemplateId) {
				              portalTemplateManagerObject.getCurrentPortalTemplateAndHotSpots({
				            	  success : function(data){
				            		  getCtpTop().$.ctx.template = $.parseJSON(data);
				            		  getCtpTop().refreshCtxHotSpotsData();
				            		  getCtpTop().$.initHotspots();
				            		  if($.ctx.hotspots.topBgImg.hotspotvalue != ""){
				            			  $(".skin_head_img_remove[templateId='" + portalskinChange.p.templateId + "']").show();
				            		  } else {
				            			  $(".skin_head_img_remove[templateId='" + portalskinChange.p.templateId + "']").hide();
				            		  }
				            		  if($.ctx.hotspots.mainBgImg.hotspotvalue != ""){
				            			  $(".skin_mainBody_img_remove[templateId='" + portalskinChange.p.templateId + "']").show();
				            		  } else {
				            			  $(".skin_mainBody_img_remove[templateId='" + portalskinChange.p.templateId + "']").hide();
				            		  }
				            	  }
				              });
				          }
				      });
	      		  }
		        },
		        data : skinData,
		        onSuccess : function(){
		          //加载完后把是否允许用户选择，是否允许用户自定义等加上
		          var allowTemplateChooseChecked = allowTemplateChooseSetting.parentAllowChoose == "1"? "checked='checked'" : "";
		          var allowHotSpotChooseChecked = parentAllowChoose == "1"? "checked='checked'" : "";
		          var allowHotSpotCustomizeChecked = parentAllowCustomize == "1"? "checked='checked'" : "";
		          if(parentAllowChoose == "0" && parentAllowCustomize == "0"){
		            $("#reDefaultBtn").hide();
		          }
		          
		          if(parentAllowChoose != '1'){
		        	  //多图
		        	  $('.hoverFlag').addClass('to_gray');
		          }
		          if(parentAllowCustomize != '1'){
		        	  //自定义
		        	  $('.skin_template').addClass('to_gray');
		          }
		          
		          /*
		          var html = '<div class="common_checkbox_box clearfix ">';
		          html += '<label class="margin_t_5 hand display_block" style="color:#b1b1b1" for="allowTemplateChoose">';
		          html += '<input class="radio_com" id="allowTemplateChoose" type="checkbox" ' + allowTemplateChooseChecked + ' disabled="disabled" />' + $.i18n('portal.skin.allowuser.choose') +'布局</label>';
		          html += '<label class="margin_t_5 hand display_block" style="color:#b1b1b1" for="allowHotSpotChoose">';
		          html += '<input class="radio_com" id="allowHotSpotChoose" type="checkbox" ' + allowHotSpotChooseChecked + ' disabled="disabled" />' + $.i18n('portal.skin.allowuser.choose') +'</label>';
		          html += '<label class="margin_t_5 hand display_block" style="color:#b1b1b1" for="allowHotSpotCustomize">';
		          html += '<input class="radio_com" id="allowHotSpotCustomize" type="checkbox" ' + allowHotSpotCustomizeChecked + ' disabled="disabled" />' + $.i18n('portal.skin.allowuser.customize') +'</label>';
		          html += '</div>';
		          $(".skin_content").append(html);
		          */
		          // 头部背景图（logo+横幅）可以自定义上传，在这里绑定上传事件
		          dymcCreateFileUpload("hiddenTopBgImg",1,"jpg,jpeg,gif,bmp,png",1,false,"topBgImgUploadCallBack", "poiTopBgImg",true,true,null,false,true,512000);
		          $(".skin_head_img").click(function(){
		            if(portalskinChange.p.changeBg){
		              insertAttachmentPoi("poiTopBgImg");
		            }
		          });
		          // 大背景图可以自定义上传，在这里绑定上传事件
		          dymcCreateFileUpload("hiddenMainBgImg",1,"jpg,jpeg,gif,bmp,png",1,false,"mainBgImgUploadCallBack", "poiMainBgImg",true,true,null,false,true,2048000);
		          $(".skin_mainBody_img").click(function(){
		            if(portalskinChange.p.changeBg){
		              insertAttachmentPoi("poiMainBgImg");
		            }
		          });
		          // 恢复默认
		          $("#reDefaultBtn").click(function(){
		            $.confirm({
		              'msg': getCtpTop().i18n_toDefault,
		              ok_fn: function () {
		                portalTemplateManagerObject.transReSetToDefault(portalskinChange.p.templateId, portalskinChange.p.skinId,{
		                  success : function(){
		                	$('#skin').click();
		                  }
		                });
		              }
		            });
		          });
		          $(".skin_content_tabs li a").click(function(){
		        	  if($(this).hasClass("skinSwitchDisabled")){
		        		  return;
		        	  }
		        	  var templateId = $(this).attr("templateId");
		        	  if(templateId != null && templateId == getCtpTop().$.ctx.template[0].id){
		        		  return;
		        	  }
		        	  var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("true", "true");
		        	  if(allowTemplateChooseSetting == null){
		        		  return;
		        	  }
		        	  portalTemplateManagerObject.transSwitchPortalTemplate(templateId, {
		                  success : function(data){
		                   	  getCtpTop().onbeforunloadFlag = false;
		                      getCtpTop().isOpenCloseWindow = false;
		                      getCtpTop().isDirectClose = false;
		                      var url = _ctxPath + "/main.do?method=changeLoginAccount&login.accountId=" + $.ctx.CurrentUser.loginAccount + "&showSkinchoose=true&isPortalTemplateSwitching=true";
		                      if(defaultPortalTemplate != currentPortalTemplate){
		                    	  url = url + "&portal_default_page=default";
		                      }
		                      getCtpTop().location.href = url;
		                  }
		              });
		          });
		        }
		      });
		     	setTimeout(function() {
				    $('#skin_set').show('fast',function(){
				        $('#skin_set_iframe').height($('#skin_set').height()).show();
				    });
		      	}, 50);
		    }
		  });			
		});
	},
	//消息提醒(右下角消息盒子)
	initSysMessage:function(){	
		//最小化消息
		$('body').append("<div id='message'><span class='msg_remind' style='display:none'></span></div><iframe id='messageIframe' allowtransparency='true' src='about:blank' frameborder='0' scrolling='no'></iframe>");
		//初始化消息框
		var _strHtml = '';
		//消息弹出框
		_strHtml += '<div class="pop_msg bottom_msg">';
			//弹出框顶部
			_strHtml += '<div class="pop_msg_top">';
				_strHtml += '<span class="pop_top_title systemMsg margin_l_5">' + $.i18n('message.header.system.label') + '（<label id="sysMsgTotalCount1">0</label>）</span>';
				_strHtml += '<div class="pop_msg_top_sm"><span></span></div>';
				_strHtml += '<div class="msg_pop_titlecurrent" style="'+($.browser.safari?'top:35px;font-size:20px;':'')+'">◆</div>';
			_strHtml += '</div>';
			//系统消息内容
			_strHtml += '<div id="msg_system_box" class="msg_system_box">';
				
				_strHtml += '<div class="msg_main_box">';
					//msg_remove删除
					/**
					_strHtml += '<div class="msg_remove">';
						_strHtml += '<div class="msg_system_box_main">';
							_strHtml += '<div class="msg_system_ico"></div>';
							_strHtml += '<div class="msg_system_main_right">';
								_strHtml += '<div class="msg_system_main_right_main">任美静 发起 会议<br />《V5.1产品经理与徐总沟通记录》<br />[已阅] 各位产品经理：非常与大家这此开放性的沟通，看到了大家的思考和成大三大四的啊打算打算';
									_strHtml += '<div class="msg_ico_1"></div><div class="msg_ico_2"></div>';
								_strHtml += '</div>';
								_strHtml += '<div class="msg_system_main_right_info"><div class="left">任美静</div><div class="msg_date right">01-15  11:15</div></div>';
							_strHtml += '</div>';
							
							_strHtml += '<div class="clear"></div>';
						_strHtml += '</div>';
						_strHtml += '<div class="msg_line"></div>';
					_strHtml += '</div>';
				
					_strHtml += '<div class="msg_remove">';
						_strHtml += '<div class="msg_system_box_main">';
							_strHtml += '<div class="msg_system_ico"></div>';
							_strHtml += '<div class="msg_system_main_right">';
								_strHtml += '<div class="msg_system_main_right_main">任美静 发起 会议<br />《V5.1产品经理与徐总沟通记录》<br />[已阅] 各位产品经理：非常与大家这此开放性的沟通，看到了大家的思考和成大三大四的啊打算打算';
									_strHtml += '<div class="msg_ico_1"></div><div class="msg_ico_2"></div>';
								_strHtml += '</div>';
								_strHtml += '<div class="msg_system_main_right_info"><div class="left">任美静</div><div class="msg_date right">01-15  11:15</div></div>';
							_strHtml += '</div>';
							
							_strHtml += '<div class="clear"></div>';
						_strHtml += '</div>';
						_strHtml += '<div class="msg_line"></div>';
					_strHtml += '</div>';
					
					_strHtml += '<div class="msg_remove">';
						_strHtml += '<div class="msg_system_box_main">';
							_strHtml += '<div class="msg_system_ico"></div>';
							_strHtml += '<div class="msg_system_main_right">';
								_strHtml += '<div class="msg_system_main_right_main">任美静 发起 会议<br />《V5.1产品经理与徐总沟通记录》<br />[已阅] 各位产品经理：非常与大家这此开放性的沟通，看到了大家的思考和成大三大四的啊打算打算';
									_strHtml += '<div class="msg_ico_1"></div><div class="msg_ico_2"></div>';
								_strHtml += '</div>';
								_strHtml += '<div class="msg_system_main_right_info"><div class="left">任美静</div><div class="msg_date right">01-15  11:15</div></div>';
							_strHtml += '</div>';
							
							_strHtml += '<div class="clear"></div>';
						_strHtml += '</div>';
						_strHtml += '<div class="msg_line"></div>';
					_strHtml += '</div>';
				*/
				_strHtml += '</div>';
			
				//未读消息
				_strHtml += '<div class="msg_expansion">';
				var msgUnitlabel = "&nbsp;";
				if(_locale != "en") msgUnitlabel = $.i18n('message.header.unit.label');
					_strHtml += '<span class="msg_expansion_font"><label id="sysMsgTotalCount2">0</label>' + msgUnitlabel + $.i18n('message.header.system.label') + "&nbsp;" + $.i18n('common.not.read.label') + '</span>';
					_strHtml += '<span class="ico16 arrow_2_t msg_expansionIco margin_ico"></span>';
				_strHtml += '</div>';
				
				//未读消息（展开、收起）
				_strHtml += '<div class="msg_expansion_box">';
				/*
					_strHtml += '<div class="msg_expansion_box_main">协同<span>1</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>2</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>3</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>4</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>5</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>6</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>6</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>6</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>6</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
					_strHtml += '<div class="msg_expansion_box_main">协同<span>6</span>条未读<div class="msg_ico_3"></div><div class="msg_ico_4"></div></div>';
				*/
				_strHtml += '</div>';

				//底部设置
				_strHtml += '<div class="msg_setting">';
					_strHtml += '<div title="' + $.i18n("message.header.more.set") + '" class="msg_setting_ico" onclick="showMessageSet(\'' + _ctxPath + '/message.do?method=showMessageSetting&fromModel=top\')"></div>';
					_strHtml += '<div class="msg_setting_font msg_setting_ignore">' + $.i18n('portal.message.ignoreall') + '</div>';
					_strHtml += '<div class="msg_setting_font msg_setting_look" onclick="showMoreMessage(\'' + _ctxPath + '/message.do?method=showMessages&showType=0&readType=notRead\')">' + $.i18n('portal.message.seeall') + '</div>';
				_strHtml += '</div>';
				
			_strHtml += '</div>';
		_strHtml += '</div>';
		_strHtml += '<iframe id="pop_msg_iframe" src="about:blank" frameborder="0"></iframe>';
		$('body').append(_strHtml);
		//去掉最后一条分割线
		var msgLineNum = $(".msg_line").length;
		$(".msg_line:eq("+ (msgLineNum-1) +")").removeClass();
		
    var _msgMainNum = $(".msg_remove").length;
    for(var m = 0; m < _msgMainNum; m++) {
      if ($.browser.msie) {
        if ($.browser.version == '6.0') {
        	//内容区域是否显示滚动条
          var _msgRightHeight = $(".msg_remove:eq("+ m +")").find(".msg_system_main_right_main").height();
          if(_msgRightHeight > 65){
            $(".msg_remove:eq("+ m +")").find(".msg_system_main_right_main").css("height","65px");
          }
        }
      }
    }
    //消息框 - 小 （拖拽） noneDiv：在iframe添加的透明层方便拖拽
    $("#message").draggable({ 
    	revert: false,
    	containment:"html",
    	scroll:false,
    	iframeFix: true 
    }).bind('dragstart', function(event, ui){
        $(".noneDiv").show();
        $("#messageIframe").hide();
        $("#message").css('z-index','2000');
        $("#messageIframe").css('z-index','1999');    
    }).bind('dragstop', function(event, ui){
      var _messageIframeAttr = $("#message").attr("style");
      $("#messageIframe").attr("style", _messageIframeAttr).show();
      $(".noneDiv").hide();
      $("#message").css('z-index','2000');
      $("#messageIframe").css('z-index','1999');
    }).click(function(){
      $(".pop_msg").show();
      $("#pop_msg_iframe").show();
      $("#message").hide();
      $("#messageIframe").hide();
      var _messageIframeAttr = $(".pop_msg").attr("style");
      var _messageIframeHeight = $(".pop_msg").height();
      $("#pop_msg_iframe").attr("style", _messageIframeAttr);
      $("#pop_msg_iframe").css("height",_messageIframeHeight + "px");
    });
    $("#message").css('z-index','2000');
    $("#messageIframe").css('z-index','1999');
    /*//消息框 - 大 （拖拽）
    $(".pop_msg").draggable({ revert: false}).bind('dragstart', function(event, ui){
      $(".pop_msg").removeClass("bottom_msg");
        $(".noneDiv").show();
      var _messageIframeAttr = $(".pop_msg").attr("style");
      var _messageIframeHeight = $(".pop_msg").height();
      $("#pop_msg_iframe").attr("style", _messageIframeAttr);
      $("#pop_msg_iframe").css("height",_messageIframeHeight + "px");
    }).bind('drag', function(event, ui) {
      var _messageIframeAttr = $(".pop_msg").attr("style");
      var _messageIframeHeight = $(".pop_msg").height();
      $("#pop_msg_iframe").attr("style", _messageIframeAttr);
      $("#pop_msg_iframe").css("height",_messageIframeHeight + "px");
    }).bind('dragstop', function(event, ui){
      var _messageIframeAttr = $(".pop_msg").attr("style");
      var _messageIframeHeight = $(".pop_msg").height();
      $("#pop_msg_iframe").attr("style", _messageIframeAttr);
      $("#pop_msg_iframe").css("height",_messageIframeHeight + "px");
      $(".noneDiv").hide();
    });*/
    
    //最小化事件处理
    $(".pop_msg_top_sm").click(function(){
      $(".pop_msg").hide();
      $("#pop_msg_iframe").hide();
      $("#message").show();
      $("#messageIframe").show();
      $.showOrHideSysMsgRemind();
    });
    
    //忽略全部
    $(".msg_setting_ignore").click(function(){
      var msgs = $(".msg_remove");
      var msglen = msgs.length;
      if(msglen && msglen > 0){
      	 getCtpTop().updateSystemMessageStateByUser();
      }
      $(".pop_msg").hide();
      $("#pop_msg_iframe").hide();
      $("#message").show();
      $("#messageIframe").show();
      $(".msg_remind").hide();
      $.ctx.sysMsgTotalCount1 = 0;
      $.ctx.sysMsgTotalCount2 = 0;
      $("#sysMsgTotalCount1").html($.ctx.sysMsgTotalCount1 + "");
      $("#sysMsgTotalCount2").html($.ctx.sysMsgTotalCount2 + "");
      $(".msg_remove").remove();
      $(".msg_expansion_box_main").remove();
      $(".msg_expansion_box").hide();
      getCtpTop().standardTitleFun();
    });
    
    //展开、收起未读消息
    $(".msg_expansion").click(function(){
      if($(".msg_expansion_box_main").length > 0){
        $(".msg_expansion_box").toggle();
        if($(".msg_expansion_box").css("display")=="block"){
        	$(".msg_system_box").children(".msg_expansion").find("span").eq(1).removeClass("arrow_2_t").addClass("arrow_2_b");
        }else{
        	$(".msg_system_box").children(".msg_expansion").find("span").eq(1).removeClass("arrow_2_b").addClass("arrow_2_t");
        
        }
      }
      var _pop_msg = $('.pop_msg')[0]
      $('#pop_msg_iframe').height(_pop_msg.clientHeight);
    });
	},
	//右下角系统消息绑定事件
  sysMessageEventBind : function(){
    //鼠标移动到每条消息上
    $(".msg_system_box_main").unbind("mouseenter").mouseenter(function(){
      $(this).css("background","#fcf0c1");
      $(this).find(".msg_ico_1").show();
    }).unbind("mouseleave").mouseleave(function(){
      $(this).css("background","#fff");
      $(this).find(".msg_ico_1").hide();  
      $(this).find(".msg_ico_2").hide();  
    });
    
    $(".msg_expansion_box_main").unbind("mouseenter").mouseenter(function(){
      $(this).css("background","#fcf0c1");  
      $(this).find(".msg_ico_3").show();
    }).unbind("mouseleave").mouseleave(function(){
      $(this).css("background","#fff");
      $(".msg_ico_3").hide();
      $(".msg_ico_4").hide();
    }).unbind("click").click(function (){
      var msgCategory = $(this).attr("msgCategory");
      if(msgCategory && msgCategory != ""){
        showMoreMessage(_ctxPath + "/message.do?method=showMessages&showType=0&readType=notRead&condition=messageCategory&textfield1=" + msgCategory.split("|")[0]);
      }
    });
    
    $(".msg_ico_1").unbind("mouseenter").mouseenter(function(){
      $(this).hide(); 
      $(this).parent().find(".msg_ico_2").show();
    });
    $(".msg_ico_2").unbind("mouseleave").mouseleave(function(){
      $(this).hide(); 
      $(this).parent().find(".msg_ico_1").show();
    }).unbind("click").click(function (event){
      //忽略单条消息
      var msg_remove = $(this).parent().parent().parent().parent();
      var userHistoryMessageId = $(msg_remove).attr("userHistoryMessageId");
      $.ignoreSysMsg(userHistoryMessageId);
	    event.stopPropagation();
    });
    $(".msg_ico_3").unbind("mouseenter").mouseenter(function(){
      $(this).hide(); 
      $(this).parent().find(".msg_ico_4").show();
    });
    $(".msg_ico_4").unbind("mouseleave").mouseleave(function(){
      $(this).hide(); 
      $(this).parent().find(".msg_ico_3").show();
    }).unbind("click").click(function (e){
        if(e.target.className == 'msg_ico_4'){
      	  //忽略某类型消息
      	  var msgCategoryValue = $(this).parent().attr("msgCategory");
      	  var msgs = $(".msg_remove[msgCategory='" + msgCategoryValue + "']");
      	  var len = msgs.length;
      	  if(len && len > 0){
      		  getCtpTop().updateSystemMessageStateByCategory(msgCategoryValue);
      	  }
      	  msgs.remove();

      	  //###特殊处理###，ie9下，msgs.remove()后，$(".msg_main_box")会莫名其妙的超级高
      	  if ($(".msg_main_box").height() * 1 > 10000) {
      	  	$(".msg_main_box").height(0);
      	  	$(".msg_main_box").height("auto");
      	  };
      	  
      	  $("#pop_msg_iframe").height($(".pop_msg")[0].clientHeight);
      	  $.updateSysMessageNum(-len, -len);
      	  $(this).parent().remove();
      	  if($(".msg_expansion_box_main").size() == 0){
      		  $(".msg_expansion_box").hide();
      		  $("#pop_msg_iframe").height($(".pop_msg")[0].clientHeight);
      	  }
        }
    });
  },
  //点击管理员切换皮肤风格的消息，自动切换单位及皮肤风格
  switchAccount : function(portalTemplateId){
	  $("#skin_set_close").click();
	  var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("false", "false");
	  if(allowTemplateChooseSetting == null){
		  return;
	  }
	  portalTemplateManagerObject.getCurrentPortalTemplateAndHotSpots({
		  success : function(data){
		      getCtpTop().$.ctx.template = $.parseJSON(data);
		      getCtpTop().refreshCtxHotSpotsData();
		      getCtpTop().$.initHotspots();
		  }
	  });
  },
  //忽略一条消息
  ignoreSysMsg : function(userHistoryMessageId){
    var msg_remove = $("#sysMsgDiv" + userHistoryMessageId);
    var msgCategory = $(msg_remove).attr("msgCategory");
    var userHistoryMessageId = $(msg_remove).attr("userHistoryMessageId");
    getCtpTop().updateMessageState(userHistoryMessageId, this, "a8");
    var readed = $(msg_remove).attr("readed");
    if(!readed){
      $.showMsgByUnreadCategory(msgCategory, -1);
      $.updateSysMessageNum(-1, -1);
    } else {
      $.updateSysMessageNum(-1, 0);
    }
    $(msg_remove).remove();
    msgLineNum = $(".msg_line").length;
    $(".msg_line:eq("+ (msgLineNum-1) +")").removeClass();
    $("#pop_msg_iframe").height($(".pop_msg").height());
  },
  //追加新到来的消息
  prependNewSysMsg : function(content){
    $(".msg_main_box").prepend(content);
    //去掉最后一条分割线
    var msgLineNum = $(".msg_line").length;
    $(".msg_line:eq("+ (msgLineNum-1) +")").removeClass();
  },
  //把消息标记为已读
  markSysMsgReaded : function(userHistoryMessageId){
    var msgCategoryValue = $("#sysMsgDiv" + userHistoryMessageId).attr("msgCategory");
    var readed = $("#sysMsgDiv" + userHistoryMessageId).attr("readed");
    if(!readed){
      $("#sysMsgDiv" + userHistoryMessageId).attr("readed", "true");
      var curCount = $("#msgCategory" + msgCategoryValue + "Count").html();
      curCount = parseInt(curCount);
      var resultCount = curCount - 1;
      if(resultCount <= 0){
        $("#msgCategory" + msgCategoryValue + "Count").parent().remove();
      } else {
        $("#msgCategory" + msgCategoryValue + "Count").html(resultCount);
      }
      $.updateSysMessageNum(0, -1);
    }
    $("#sysMsgDiv" + userHistoryMessageId).find(".msg_system_main_right").css("color", "#666666");
  },
  //分类显示消息条数,msgCategory:消息应用分类,num:增加或减少的数量
  showMsgByUnreadCategory : function(msgCategory, num){
    if(msgCategory && msgCategory != ""){
      var splitedArray = msgCategory.split("|");
      var msgCategoryValue = splitedArray[0];
      var msgCategoryName = splitedArray[1];
      var len = $("#msgCategory" + msgCategoryValue + "Count").length;
      if(len == 0){
      	 if (msgCategoryName.length > 4) { 
      		 msgCategoryName = msgCategoryName .substring(0,4)+"...";
         }
        var html = "<div class='msg_expansion_box_main' msgCategory='" + msgCategoryValue + "'>" + msgCategoryName + "<span id='msgCategory" + msgCategoryValue + "Count'>" + num + "</span>条<div class='msg_ico_3'></div><div title='" + $.i18n("portal.message.ignore") + "' class='msg_ico_4'></div></div>";
        $(".msg_expansion_box").append(html);
      } else {
        var curCount = $("#msgCategory" + msgCategoryValue + "Count").html();
        curCount = parseInt(curCount);
        var resultCount = curCount + num;
        if(resultCount <= 0){
          $("#msgCategory" + msgCategoryValue + "Count").parent().remove();
        } else {
          $("#msgCategory" + msgCategoryValue + "Count").html(resultCount);
        }
      }
    }
  },
  //更新系统消息条数
  updateSysMessageNum : function(msgTotalCount, unreadMsgCount){
    //得到当前条数
    $.ctx.sysMsgTotalCount1 = $.ctx.sysMsgTotalCount1 + parseInt(msgTotalCount);
    $.ctx.sysMsgTotalCount2 = $.ctx.sysMsgTotalCount2 + parseInt(unreadMsgCount);
    if($.ctx.sysMsgTotalCount1 <= 0){
      $.ctx.sysMsgTotalCount1 = 0;
    }
    if($.ctx.sysMsgTotalCount2 <= 0){
      $.ctx.sysMsgTotalCount2 = 0;
      getCtpTop().standardTitleFun();
    }
    //更新条数
    $("#sysMsgTotalCount1").html($.ctx.sysMsgTotalCount1 + "");
    $("#sysMsgTotalCount2").html($.ctx.sysMsgTotalCount2 + "");
    $.showOrHideSysMsgRemind();
  },
  //缩小的消息盒子是否显示小圆点
  showOrHideSysMsgRemind : function(){
    if($.ctx.sysMsgTotalCount2 > 0){
      $(".msg_remind").show();
    } else {
      $(".msg_remind").hide();
    }    
  },
  //刷新集团/单位名称
  refreshGroupAndAccountNameInfo : function(){
    var returnObj= new portalManager().getGroupAndAccountNameInfo();
    if(!returnObj){
      return;
    }
    var groupAndAccountNameInfo = eval(returnObj);
	  //集团简称
	  var groupShortName =  groupAndAccountNameInfo.groupShortName;
	  //集团外文名称
	  var groupSecondName =  groupAndAccountNameInfo.groupSecondName;
	  if(groupSecondName == null) groupSecondName = "";
	  //当前单位名称
	  var accountName = groupAndAccountNameInfo.accountName;
	  //当前单位外文名称
	  var accountSecondName = groupAndAccountNameInfo.accountSecondName;
	  if(accountSecondName == null) accountSecondName = "";
	  if(isCurrentUserGroupAdmin == "true"){
		  // 如果是集团管理员\
		  if($.ctx.hotspots.groupName && $.ctx.hotspots.groupName.display == 1){
	        // 要显示groupName
	        $(".comdiv_cn").html(groupShortName);
	        $(".comdiv_cn").attr("title",groupShortName);
	        $(".comdiv_en").html(escapeStringToHTML(groupSecondName + "", false));
	        if($.trim(groupSecondName) == ""){
	          $(".comdiv_cn").css("font-size", "16px");
	          $(".comdiv_cn").css("margin-top", "6px");
	          $(".comdiv_cn").css("height", "20px");
	        } else {
	          $(".comdiv_cn").css("font-size", "14px");
	          $(".comdiv_cn").css("margin-top", "0px");
	        }
	      } else {
	        // 不显示groupName
	        $(".comdiv_cn").html("");
	        $(".comdiv_en").html("");
	      }
	  } else if(isCurrentUserSystemAdmin == "true" || isCurrentUserSuperAdmin == "true" || isCurrentUserAuditAdmin == "true"){
	      // 如果是系统管理员或超级管理员或审计管理员
	      if(getCtpTop().systemProductId == 2 || getCtpTop().systemProductId == 4 || getCtpTop().systemProductId == 5){
	        if($.ctx.hotspots.groupName){
	          if($.ctx.hotspots.groupName.display == 1){
	            // 要显示groupName
	            $(".comdiv_cn").html(groupShortName);
	            $(".comdiv_cn").attr("title",groupShortName);
	            $(".comdiv_en").html(escapeStringToHTML(groupSecondName + "", false));
	            if($.trim(groupSecondName) == ""){
	              $(".comdiv_cn").css("font-size", "16px");
	              $(".comdiv_cn").css("margin-top", "6px");
	              $(".comdiv_cn").css("height", "20px");
	            } else {
	              $(".comdiv_cn").css("font-size", "14px");
	              $(".comdiv_cn").css("margin-top", "0px");
	            }
	          } else {// 不显示groupName
	            $(".comdiv_cn").html("");
	            $(".comdiv_en").html("");
	          }
	        }
	      } else if($.ctx.hotspots.accountName && $.ctx.hotspots.accountName.display == 1){
	        $(".comdiv_cn").html(accountName);
	        $(".comdiv_cn").attr("title",accountName);
	        $(".comdiv_en").html(escapeStringToHTML(accountSecondName + "", false));
	        if($.trim(accountSecondName) == ""){
	          $(".comdiv_cn").css("font-size", "16px");
	          $(".comdiv_cn").css("margin-top", "6px");
	          $(".comdiv_cn").css("height", "20px");
	        } else {
	          $(".comdiv_cn").css("font-size", "14px");
	          $(".comdiv_cn").css("margin-top", "0px");
	        }
	      } else {
	        // 不显示groupName
	        $(".comdiv_cn").html("");
	        $(".comdiv_en").html("");
	      }
	  } else {
	      // 单位管理员,普通人员
	      var cnName = "";
	      var enName = "";
	      var cTitle = "";
	      if(getCtpTop().systemProductId == 2 || getCtpTop().systemProductId == 4 || getCtpTop().systemProductId == 5){
	        if($.ctx.hotspots.groupName && $.ctx.hotspots.groupName.display == 1){
	          if($.ctx.hotspots.accountName.display == 1){
	            cnName = groupShortName + "&nbsp;&nbsp;&nbsp;&nbsp;" + accountName;
	            cTitle = groupShortName + "    " + accountName;
	            enName = accountSecondName;
	          } else {
	            cnName = groupShortName;
	            cTitle = groupShortName;
	          }
	        } else {
	          if($.ctx.hotspots.accountName && $.ctx.hotspots.accountName.display == 1){
	            cnName = accountName;
	            cTitle = accountName;
	            enName = accountSecondName;
	          } else {
	            cnName = "";
	            cTitle = "";
	          }
	        }
	      } else {
	        if($.ctx.hotspots.accountName && $.ctx.hotspots.accountName.display == 1){
	          cnName = accountName;
	          cTitle = accountName;
	          enName = accountSecondName;
	        } else {
	          cnName = "";
	          cTitle = "";
	        }
	      }
	      $(".comdiv_cn").html(cnName);
	      $(".comdiv_cn").attr("title",cTitle);
	      $(".comdiv_en").html(escapeStringToHTML(enName + "", false));
	      if($.trim(enName) == ""){
	        $(".comdiv_cn").css("font-size", "16px");
	        $(".comdiv_cn").css("margin-top", "6px");
	        $(".comdiv_cn").css("height", "20px");
	      } else {
	    	$(".comdiv_cn").css("font-size", "14px");
	        $(".comdiv_cn").css("margin-top", "0px");
	      }
	  }  
  },
  //根据$.ctx.hotspots热点值刷新显示效果
  initHotspots : function(){
	$.refreshGroupAndAccountNameInfo();
    //logo
    if($.ctx.hotspots.logoImg && $.ctx.hotspots.logoImg.display == 1){
      //要显示logo
      $("#logo").show().attr("src", _ctxPath + "/" + $.ctx.hotspots.logoImg.hotspotvalue);
      //$(".logodiv").css("background-repeat", "no-repeat");
    } else {
      $("#logo").hide();
    }
   
	  
	  var agent =  navigator.userAgent.toLowerCase();
	  if(agent.indexOf("msie") != -1 || (agent.indexOf("nt 10.0")!=-1&&agent.indexOf("trident")!=-1)){
		  var logoInterval = setInterval(function(){
			  if($("#logo").width() != 0){
				  var logoWidth= $("#logo").width();
			  //无兼职单位，图标距左边界20,考虑logo宽度有小数点的多减1
			  var CompanyNameWidth = $(".logodiv").parent().width()-logoWidth-20-5-1;
			  var concurrentAccount = $.ctx.concurrentAccount;
			  //有兼职单位，图标距左边距为30,考虑logo宽度有小数点的多减1
			  if(concurrentAccount!=null && concurrentAccount.length>1){
				 CompanyNameWidth = $(".logodiv").parent().width()-logoWidth-30-5-1;
			  }
			  $("#accountNameDiv .comdiv_cn").css({
				  "white-space": "nowrap",
				  "overflow": "hidden",
				  "text-overflow": "ellipsis",
				  "width":CompanyNameWidth
				});
				window.clearInterval(logoInterval);
			  }
		  },50);
	  }else{
		  //图片加载完成后，设置名称超长自动省略样式
		    $("#logo").load(function(){
				  var logoWidth= $("#logo").width();
				  //无兼职单位，图标距左边界20,考虑logo有小数点的多减1
			      var CompanyNameWidth = $(".logodiv").parent().width()-logoWidth-20-5-1;
				  var concurrentAccount = $.ctx.concurrentAccount;
				  //有兼职单位，图标距左边距为30,考虑logo有小数点的多减1
				  if(concurrentAccount!=null && concurrentAccount.length>1){
					 CompanyNameWidth = $(".logodiv").parent().width()-logoWidth-30-5-1;
			      }
			      $("#accountNameDiv .comdiv_cn").css({
			          "white-space": "nowrap",
			          "overflow": "hidden",
			          "text-overflow": "ellipsis",
			          "width":CompanyNameWidth
			        });
			  });
	  }
    //头部背景图
    if(getCtpTop().systemProductId != 7){
	    if($.ctx.hotspots.topBgImg){
	        if($.ctx.hotspots.topBgImg.hotspotvalue == ""){
	      	  $(".area").css("background-image", "none");
	        } else {
	      	  $(".area").css("background-image", "url(\'" + _ctxPath + "/" + $.ctx.hotspots.topBgImg.hotspotvalue + "\')");
	        }
	    }
    }else{
    	$(".area").css({
    		"background-image": "url(\'" + _ctxPath + "/main/skin/frame/"+ skinPathKey + "/images/a6s_layout_header1.jpg" + "\')",
    		"background-repeat":"repeat-x",
    		"background-size":"100% 100%"
    	});
    }
    //头部颜色
    if($.ctx.hotspots.topBgColor){
    	setTopBgColor($.ctx.hotspots.topBgColor.hotspotvalue, $.ctx.hotspots.topBgColor.ext5);
    }
    $(".layout_header").show();
    //左侧导航背景色
    if($.ctx.hotspots.lBgColor){
    	setNavMenuColor($.ctx.hotspots.lBgColor.hotspotvalue, $.ctx.hotspots.lBgColor.ext5, $.ctx.hotspots.lBgColor.ext10);
    }
    $(".layout_left").show();
    //栏目头部颜色
    if($.ctx.hotspots.cBgColor){
    	resetSectionTabColor($.ctx.hotspots.cBgColor.hotspotvalue, $.ctx.hotspots.cBgColor.ext5 / 100);
    }
    //栏目内容区颜色 (框架加载完毕之后设置)
    if($.ctx.hotspots.sectionContentColor){
    	$("#main").load(function(){
    		try{
        		setContentAreabgc($.ctx.hotspots.sectionContentColor.hotspotvalue, $.ctx.hotspots.sectionContentColor.ext5);
    		}catch(e){}
    	});
    	try{
    		setContentAreabgc($.ctx.hotspots.sectionContentColor.hotspotvalue, $.ctx.hotspots.sectionContentColor.ext5);
		}catch(e){}
    }
    //工作区背景色
    if($.ctx.hotspots.mainBgColor){
    	setMainBgColor($.ctx.hotspots.mainBgColor.hotspotvalue, $.ctx.hotspots.mainBgColor.ext5);
    }
    //大背景图
    if($.ctx.hotspots.mainBgImg){
    	if($.ctx.hotspots.mainBgImg.hotspotvalue == ""){
        	getCtpTop().$(".warp").css("background-image", "none");
    	} else {
    		if(getCtpTop().systemProductId != 7){
    			getCtpTop().$(".warp").css("background-image", "url(\'" + _ctxPath + "/" + $.ctx.hotspots.mainBgImg.hotspotvalue + "\')");
    		}else{
    			getCtpTop().$(".warp").css({
    				"background-image":"url(\'" + _ctxPath + "/main/skin/frame/"+ skinPathKey + "/images/a6s_layout_main1.jpg" + "\')",
    				"background-size":"100% 100%",
    				"background-repeat":"no-repeat"
    			});
    		}
    	}
    }
    //面包屑导航字体颜色
    if($.ctx.hotspots.breadFontColor){
    	getCtpTop().$(".nowLocation_content, .nowLocation_content a").css({"color" : $.ctx.hotspots.breadFontColor.hotspotvalue});
    }
    if($.ctx.hotspots.topBgImg){
      var oldHref = $("#skinFrameCSS").attr("href");
      if(oldHref != _ctxPath + "/main/skin/frame/" + $.ctx.hotspots.topBgImg.ext10 + "/default.css"+resSuffix){
        getCtpTop().skinPathKey = $.ctx.hotspots.topBgImg.ext10;
        $("#skinFrameCSS").attr("href", _ctxPath + "/main/skin/frame/" + $.ctx.hotspots.topBgImg.ext10 + "/default.css"+resSuffix);
      }
    }
  }
});
//时间线对象
var timeLineObj;
//时间对象
var timeLineDate;

function getCurDayStr(){
  var timeSure = timeLineObj.getSetDate();
  var curDayArr = new Array();
  if(timeSure.year == "" || timeSure.mounth == "" || timeSure.day == ""){
    var _ymd = new Date();
    timeSure.year = _ymd.getFullYear();
    timeSure.mounth = _ymd.getMonth()+1;
    timeSure.day = _ymd.getDate();
  }
  curDayArr[0] = timeSure.year;
  curDayArr[1] = timeSure.mounth;
  curDayArr[2] = timeSure.day;
  return curDayArr;
}

/**
 * 时间线局部刷新的方法
 * 
 * @param timeLineObj
 */
function timeLineObjReset(timeLineObj) {
  if(timeLineObj != null && typeof(timeLineObj) != "undefined"){
    var curDayArr = getCurDayStr();
    var curDayStr = curDayArr[0] + "-" + curDayArr[1] + "-" + curDayArr[2];
    var timeLineBean = new timeLineManager();
    timeLineBean.getTimeLineResetDate(curDayStr,{
      success : function(listDate){
        timeLineObj.reset({
          date : curDayArr,
          timeStep : listDate[0],
          items : listDate[1]
        });
      }
    });
    
  }
}

/**
 * 时间线执行查看数据的时候调用
 * 
 * @param id 当前数据的ID
 * @param type 六个模块的类型
 */
function timeLineAction(id, type) {
  var calEvent = timeLineObj.getDataObj(id);
  showDate(calEvent,refleshTimeLinePage);
}

/**
 * 六个模块点击查看详细信息
 */
function showDate(calEvent,refleshPage){
  var type = calEvent.type;
  if (type == "event") {
    calEvent.curUserID = curUserID;
    dynamicUpdateCalEventDailog(calEvent,refleshPage);
  } else if (type == "task") {
      viewTaskInfo4Event(calEvent.id,refleshPage);
  } else if (type == "plan") {
    openPlan(calEvent.id,refleshPage);
  } else if (type == "meeting") {
    if(calEvent.canView) {
      if(typeof(curNextDate)=="object") {
        curNextDate = curNextDate.format("yyyy-MM-dd");
      }
      openMeeting(calEvent.id, refleshPage);  
    }
  } else if (type == "collaboration") {
    showSummayDialog(calEvent.id,calEvent.subject,refleshPage);
  } else if (type == "edoc") {
    openEdocByStatus(calEvent.id, calEvent.states,_ctxPath,refleshPage);
  }
}

/**
 * 打开计划
 * 
 * @param planId 计划ID
 * @param actionAfterClose 刷新方法名
 * @return
 */
function openPlan(planId, actionAfterClose) {
  var toSrc = _ctxPath + "/plan/plan.do?method=initPlanDetailFrame&planId=" + planId;
  var ajaxCalEventBean = new calEventManager();
  var res = ajaxCalEventBean.isHasDeleteByType(planId, "plan");
  res = res.toString();
  if(res == "true"){
    var planViewdialog = $.dialog({
      id : 'showPlan',
      url : toSrc,
      width : $(getCtpTop().document).width() - 100,
      height : $(getCtpTop().document).height() - 100,
      title : $.i18n('plan.dialog.showPlanTitle'),
      targetWindow : getCtpTop(),
      buttons : [ {
        text : $.i18n('plan.dialog.close'),
        handler : function() {
          planViewdialog.close();
          if (actionAfterClose instanceof Function) {
            actionAfterClose();
          }
        }
      } ]
    });
  } else {
    var msg;
    if (res == "false") {
      msg = $.i18n('plan.alert.nopotent');
    } else if (res == "absence") {
      msg = $.i18n('plan.alert.deleted');
    }
    $.error({
      'msg' : msg,
      ok_fn : function() {
        if (actionAfterClose instanceof Function) {
          actionAfterClose();
        }
      }
    });
  }
}

/**
 * 查看任务详细信息页面
 * 
 * @param id 任务编号
 */
function viewTaskInfo4Event(id, actionAfterClose,category) {
  var ajaxCalEventBean = new calEventManager();
  var res = ajaxCalEventBean.isHasDeleteByType(id, "task");
  if (res != null && res != "") {
    $.error({
      'msg' : res,
      ok_fn : function() {
        if (actionAfterClose instanceof Function) {
          actionAfterClose();
        }
      }
    });
  } else {
	  var detailUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&category="+category+"&isTimeLine=1&taskId="+id;
	 var contentUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskContentPage&taskId="+id;
	 var taskDetailTreeManager = RemoteJsonService.extend({
		jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=taskDetailTreeManager",
		checkTaskTree: function() {
			return this.ajaxCall(arguments, "checkTaskTree");
		}
	});
	 var taskDetailTreeManager_=new taskDetailTreeManager();
	var exitTree=taskDetailTreeManager_.checkTaskTree(id);
	var treeUrl="";
	var hideBtnC = true;
	treeUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskTreePage&taskId="+id;
	if(exitTree){
		hideBtnC = false;
	}
	new projectTaskDetailDialog({"url1":detailUrl,"url2":contentUrl,"url3":treeUrl,"openB":true,"hideBtnC":hideBtnC,"animate":false});
  }
}

/**
 * 打开正文内容
 * 
 * affairId 待办事项的id title dialog的标题，用affair的subject值 actionAfterClose
 * 协同处理完成后需要执行的方法，比如刷新
 */
function showSummayDialog(affairId, title, actionAfterClose) {
  var url = _ctxPath
      + "/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId="
      + affairId + "&isTimeLine=1";
  var width = $(getCtpTop().document).width() - 100;
  var height = $(getCtpTop().document).height() - 50;
  $.dialog({
    url : url,
    width : width,
    height : height,
    title : title,
    id : 'dialogDealColl',
    transParams : {
      callbackOfEvent : actionAfterClose,
      window : window
    },
    targetWindow : getCtpTop()
  });
}

/**
 * 查看会议接口 
 * @param id 会议id
 */
var dialogDealColl;
function openMeeting(meetingId, actionAfterClose) {
  var url = _ctxPath + "/mtMeeting.do?method=myDetailFrame&id=" + meetingId;
  var width = $(getCtpTop().document).width() - 100;
  var height = $(getCtpTop().document).height() - 50;
  dialogDealColl = $.dialog({
    url : url,
    width : width,
    height : height,
    title : '会议',
    targetWindow : getCtpTop(),
    transParams : {
      diaClose : actionAfterClose,
      window : window
    }
  });
}

/**
 * 5.0对外接口--时间安排，查询某个公文的详细，根据状态判断显示待办还是已办
 * 新增参数 actionAfterClose 又外面传的 刷新方法名
 */
function openEdocByStatus(affairId, state, contextPath, actionAfterClose) {
  if (state == '3') { // 待办
    openDetail_edoc('listPending', 'from=Pending&affairId=' + affairId
     + '&from=Pending', contextPath, actionAfterClose);
  } else if ((state == '4')) { // 已办
    openDetail_edoc('', 'from=Done&affairId=' + affairId, contextPath, actionAfterClose);
  } else {
    
  }
}

function openDetail_edoc(subject, _url, contextPath, actionAfterClose) {
  // 'subject'判断是否是交换公文
	var rv;
  if (subject == 'exchange') {
    _url = _url;
  } else {
    _url = contextPath + "/edocController.do" + "?method=detailIFrame&" + _url;
    if ("listPending" == subject || "listReading" == subject || "" == subject) {
       rv = v3x.openWindow({
        url : _url,
        FullScrean : 'yes',
        //dialogType : 'open'
        dialogType: v3x.getBrowserFlag('pageBreak') == true ? 'modal' : '1'
      });
    } else {
      rv = v3x.openWindow({
        url : _url,
        FullScrean : 'yes',
        dialogType : v3x.getBrowserFlag('pageBreak') == true ? 'modal' : '1'
      });
    }
  }
    if (actionAfterClose instanceof Function) {
      actionAfterClose();
    }
}

/**
 * 查看事件
 * 
 * @param data 事件对象
 */
var calEventDialogUpdate;
function dynamicUpdateCalEventDailog(data, timeLineObjReset) {
  var res = accessManagerData(data.id ,"event");
  var ajaxTestBean = new calEventManager();
  var isReceiveMember = false;
  isReceiveMember = ajaxTestBean.isReceiveMember('${CurrentUser.id}',data.id);
  if (res != null && res != "") {
    $.alert({
      'msg' : res,
      ok_fn : function() {
        if(res == "${ctp:i18n('calendar.event.create.had.delete')}"){
          if (timeLineObjReset instanceof Function) {
            timeLineObjReset();
          }
        }
      }
    });
  } else {
    var height = 600;
    if (data.shareType == 1 && data.receiveMemberId == null) {
      height = 500;
    }
    calEventDialogUpdate = $.dialog({
      id : "calEventUpdate",
      url : _ctxPath + '/calendar/calEvent.do?method=editCalEvent&id='
          + data.id,
      width : 600,
      height : height,
      targetWindow : getCtpTop(),
      checkMax : true,
      transParams : {
        diaClose : dialogClose,
        showButton : showBtn,
        isview : "true",
        refleshMethod : timeLineObjReset
      },
      title : $.i18n('calendar.event.search.title'),
      buttons : [ {
        id : "sure",
        text : $.i18n('calendar.sure'),
        handler : function() {
          calEventDialogUpdate.getReturnValue();
        }
      }, {
        id : "update",
        text : $.i18n('calendar.update'),
        handler : function() {
          calEventDialogUpdate.getReturnValue("update");
        }
      }, {
        id : "cancel",
        text : $.i18n('calendar.cancel'),
        handler : function() {
          calEventDialogUpdate.close();
        }
      }, {
        id : "btnClose",
        text : $.i18n('calendar.close'),
        handler : function() {
          calEventDialogUpdate.close();
        }
      } ]
    });
    calEventDialogUpdate.hideBtn("sure");
    calEventDialogUpdate.hideBtn("btnClose");
    calEventDialogUpdate.hideBtn("update");
    calEventDialogUpdate.hideBtn("cancel");
    if (data.createUserId != data.curUserID&&isReceiveMember=="false") {
      calEventDialogUpdate.showBtn("btnClose");
    } else {
      calEventDialogUpdate.showBtn("update");
      calEventDialogUpdate.showBtn("cancel");
    }
    
  }
}

/**
 * 访问后台看看数据被删掉了没有
 * 
 * @param id 数据IE
 */
function accessManagerData(id ,eventObj) {
  var ajaxCalEventBean = new calEventManager();
  return ajaxCalEventBean.isHasDeleteByType(id, eventObj);
}

/**
 * 时间线编辑的时候关闭的方法
 */
function timeLineObjDialogClose() {
  timeLineDialog.close();
}

/**
 * 由于时间线的局部刷新方法timeLineObjReset有参数timeLineObj，而每个模块
 * 调用回来执行这个刷新的时候都报timeLineObj这个参数不存在，所以，另外封装了一 层一个不带任何参数的方法代替执行的刷新方法
 */
function refleshTimeLinePage() {
  timeLineObjReset(timeLineObj);
}

function dialogClose(id, reloadDate, timeLineObjReset) {
  calEventDialogUpdate.close();
  if (reloadDate == 'true') {
    if (timeLineObjReset instanceof Function) {
      timeLineObjReset();
    }
  }
}

function showBtn() {
  calEventDialogUpdate.showBtn("sure");
  calEventDialogUpdate.hideBtn("update");
}

function indexSearch(_appCategory){
    var keyword = document.getElementById("searchAreaInput").value;
    keyword = keyword.trim();
    if(keyword == "" || keyword == null){
      alert(indexErr);
      return;
      }
    var max_length = 40;
    if(keyword.length>max_length){
      keyword=keyword.substring(0,max_length);
    }
    if (_appCategory == 'accessories') {
      getCtpTop().main.location  = '/seeyon/index/indexController.do?method=search&keyword=&accessoryName=' + encodeURIComponent(keyword) + '&appCategory=' + _appCategory;
    } else {
      getCtpTop().main.location  = '/seeyon/index/indexController.do?method=search&keyword=' + encodeURIComponent(keyword) + '&accessoryName=&appCategory=' + _appCategory;
    }
    
  }


function refreshCtxHotSpotsData() {
  if($.ctx.template[0].portalHotspots && $.ctx.template[0].portalHotspots.length > 0){
    for(var i = 0; i < $.ctx.template[0].portalHotspots.length; i++){
      var hotspot = $.ctx.template[0].portalHotspots[i];
      if(hotspot.hotspotkey == "groupName"){
        $.ctx.hotspots.groupName = hotspot;
      } else if(hotspot.hotspotkey == "accountName"){
        $.ctx.hotspots.accountName = hotspot;
      } else if(hotspot.hotspotkey == "logoImg"){
        $.ctx.hotspots.logoImg = hotspot;
      } else if(hotspot.hotspotkey == "topBgImg"){
        $.ctx.hotspots.topBgImg = hotspot;
      } else if(hotspot.hotspotkey == "topBgColor"){
        $.ctx.hotspots.topBgColor = hotspot;
      } else if(hotspot.hotspotkey == "lBgColor"){
        $.ctx.hotspots.lBgColor = hotspot;
      } else if(hotspot.hotspotkey == "cBgColor"){
        $.ctx.hotspots.cBgColor = hotspot;
      } else if(hotspot.hotspotkey == "mainBgColor"){
        $.ctx.hotspots.mainBgColor = hotspot;
      } else if(hotspot.hotspotkey == "mainBgImg"){
        $.ctx.hotspots.mainBgImg = hotspot;
      } else if(hotspot.hotspotkey == "breadFontColor"){
        $.ctx.hotspots.breadFontColor = hotspot;
      } else if(hotspot.hotspotkey == "sectionContentColor"){
        $.ctx.hotspots.sectionContentColor = hotspot;
      }
    }
  }
}

//16进制颜色值转为rgb
function colorHexToRgb(sColor){
	var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
	if(sColor && reg.test(sColor)){
		if(sColor.length === 4){
			var sColorNew = "#";
			for(var i=1; i<4; i+=1){
				sColorNew += sColor.slice(i,i+1).concat(sColor.slice(i,i+1));	
			}
			sColor = sColorNew;
		}
		//处理六位的颜色值
		var sColorChange = [];
		for(var i=1; i<7; i+=2){
			sColorChange.push(parseInt("0x"+sColor.slice(i,i+2)));	
		}
		return "rgb(" + sColorChange.join(",") + ")";
	}else{
		return sColor;	
	}
}

//首页更改头部背景色
function setTopBgColor(colorValue, colorOpacity){
	var rgbValue = colorHexToRgb(colorValue);
	if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
		//rgbValue = colorValue;
	} else {
		rgbValue = rgbValue.replace("rgb", "rgba").replace(")", ", " + colorOpacity / 100 + ")");
	}
    getCtpTop().$(".layout_header").css("background-color", rgbValue);
}

//首页更改导航菜单颜色
function setNavMenuColor(colorValue, colorOpacity, ext10){
	var rgbValue = colorHexToRgb(colorValue);
	if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
		if(colorValue == "#000000" && ext10 == "harmony"){
			rgbValue = "#022c55";
		} else if(colorValue == "#000000" && ext10 == "peaceful"){
			rgbValue = "#0a3829";
		} else if(colorValue == "#000000" && ext10 == "tint"){
			rgbValue = "#002149";
		} else if(colorValue == "#000000" && ext10 == "wisdom"){
			rgbValue = "#412845";
		} else if(colorValue == "#000000" && ext10 == "morning"){
			rgbValue = "#4b5354";
		} else if(colorValue == "#000000" && ext10 == "material"){
			rgbValue = "#472900";
		}
		if(colorValue == "#000000" && ext10 == "GOV_red3"){
			rgbValue = "#6c2c13";
		} else if(colorValue == "#000000" && ext10 == "GOV_red2"){
			rgbValue = "#55250b";
		} else if(colorValue == "#000000" && ext10 == "GOV_blue2"){
			rgbValue = "#032649";
		} else if(colorValue == "#000000" && ext10 == "GOV_red"){
			rgbValue = "#6c2c13";
		} else if(colorValue == "#000000" && ext10 == "GOV_blue3"){
			rgbValue = "#2c3e50";
		} else if(colorValue == "#000000" && ext10 == "GOV_blue"){
			rgbValue = "#45484a";
		}
	} else {
		rgbValue = rgbValue.replace("rgb", "rgba").replace(")", ", " + colorOpacity / 100 + ")");
	}
	if(getCtpTop().systemProductId != 7){
    	getCtpTop().$(".layout_left").css("background-color", rgbValue);
   }else{
   	getCtpTop().$(".layout_left").css({
   		"background-image": "url(\'" + _ctxPath + "/main/skin/frame/"+ skinPathKey + "/images/a6s_layout_left.jpg" + "\')",
   		"background-repeat":"repeat-x",
   		"background-color":"#64a0d2"
   	});
   	getCtpTop().$(".lineBg").css("background", "transparent");
   	getCtpTop().$(".avatar").css("border","solid 3px transparent");
   	getCtpTop().$(".nav_border").css("background-image","url(\'" + _ctxPath + "/main/skin/frame/"+ skinPathKey + "/images/a6s_nav_border.png" + "\')")
   }
}

//首页工作区背景颜色
function setMainBgColor(colorValue, colorOpacity){
	var rgbValue = colorHexToRgb(colorValue);
	if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
		//rgbValue = colorValue;
	} else {
		rgbValue = rgbValue.replace("rgb", "rgba").replace(")", ", " + colorOpacity / 100 + ")");
	}
    getCtpTop().$(".layout_right").css("background-color", rgbValue);
}

//首页更改栏目头部颜色
function resetSectionTabColor(sb, colorOpacity){
  if(getCtpTop().isCurrentUserAdmin != "true"){
    sectionTabColor = sb;
    sectionTabTextColor = sectionTabColor == 'transparent' ? sectionTabColor : getOpacityRgb(sectionTabColor, 0.2);
    rgbaOpacity = "rgba(255,255,255,"+colorOpacity+")";
    var mainSrc = $("#main").attr("src");
    if(mainSrc.indexOf(".psml")>0){
      var spaceWindow = $("#main")[0].contentWindow;
      if(spaceWindow && spaceWindow.$){
        spaceWindow.$(".index_tabs ul li").css("border-bottom-color",sectionTabColor);
        spaceWindow.$(".content_area_head_bg").css("background", sectionTabTextColor);
        if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
        	// do nothing
        } else {
        	if(getCtpTop().systemProductId != 7){
        		spaceWindow.$(".content_area_head").css("background",rgbaOpacity);
        	}else{
        		spaceWindow.$(".content_area_head").css("background","#5198cf");
        	}
        }
      }
    }
  }
}

//首页更改栏目内容区颜色、透明度
function setContentAreabgc(areabgc, areaOpacity){
	var content_area_bgcOpacity = (areaOpacity / 100);
	var newColorValue = colorHexToRgb(areabgc);
	if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
		
	} else {
		newColorValue = newColorValue.replace("rgb", "rgba").replace(")", ", "+content_area_bgcOpacity+")");
	}
	if($("#main").contents().find(".content_area_body:first").length == 0){
		$("#main").contents().find(".portal-header-bg").closest(".portal-layout-cell-banner").css("background-color",newColorValue);
		return;
	}
	if(getCtpTop().systemProductId != 7){
		$("#main").contents().find(".content_area_body").addClass("body_transparent").css("background-color",newColorValue);
	}else{
		$("#main").contents().find(".content_area_body").addClass("body_transparent").css({
			"background-color":newColorValue,
			"border-right":"solid 1px #ced0d3",
			"border-bottom":"solid 1px #ced0d3",
			"border-left":"solid 1px #ced0d3"
		});
		$("#main").contents().find(".content_area_head").find("a,span").css("color","#fff");
	}
	$("#main").contents().find(".portal-header-bg").closest(".portal-layout-cell-banner").css("background-color",newColorValue);
}

$(document).ready(function () {
	$("#layout_header_bg").css({
		width: $(window).width(),
		height: $(window).height()
	});

	if(!$.ctx.CurrentUser.isInternal){
		$("#onlineCard").hide();
	}
  //var menusObj = $.ctx.menu;
	var searchRuValue = ['全部','协同','公文','会议','公告','文档','附件名'];
	var pullDownInfors = [];
	if("true" == isAdmin){
		pullDownInfors.push([$.i18n("seeyon.top.close.alt"),"6","logout"]);
	}else{
	  pullDownInfors.push([$.i18n("personal.message.label"),"0","personalInfo"]);
	  if(getCtpTop().systemProductId != 7){
	    pullDownInfors.push([$.i18n("portal.changeSkin.lable"),"1","skin"]);
	  }
		//薪资查看
		if(true == $.ctx.CurrentUser.isInternal && "true" == isShowHr && isShowSalary == "true"){
			pullDownInfors.push([$.i18n("menu.hr.salary.show"),"2","viewSalary"]);
		}
		//菜单设置
		pullDownInfors.push([$.i18n("personalSetting.menu.label"),"3","menuSetting"]);
		//快捷设置
	    pullDownInfors.push([$.i18n("personalSetting.shortcut.label"),"4","shortcutSet"]);
		//更多-个人事务
	    pullDownInfors.push([$.i18n("menu.personal.affair"),"5","mySet"]);
	    if(getCtpTop().systemProductId != 3 && getCtpTop().systemProductId != 4 && getCtpTop().systemProductId != 0 && getCtpTop().systemProductId != 7){
	    //显示产品导航
	    pullDownInfors.push([$.i18n("menu.productNavigation.label"),"6","productView_btn"]);
	    }
		//退出
		pullDownInfors.push([$.i18n("seeyon.top.close.alt"),"7","logout"]);
	}
	$.initLayout();
	//初始化菜单
	$.pageMenu($.ctx.menu);
	$.initPulldownInfor(pullDownInfors);
	if("false" == isAdmin){
		$.initOnLine();
		$.initSearch(searchRuValue);
		//$.initSpace($.ctx.space);
	    //空间显示-兼容NC的applet刷新
		if(!currentSpaceForNC){
		   $.initSpace($.ctx.space);
		} else {
		   refreshNavigation(currentSpaceForNC);
		   currentSpaceForNC = null;
		}

		//初始化首页切换
		if("default" != currentPortalTemplate && currentPortalTemplate == defaultPortalTemplate){
			//关闭换肤对话框
	 		currentPortalTemplate = "desktop";
	 		$(".return_ioc2").show();
	 		$(".return_ioc").hide();
			//清空空间导航
			$(".area_r_icon").hide();
			$(".nav_center_more").hide();
			$(".banner_line").hide();
			
			var _src = $('#desktopIframe').attr('src');
			if(_src==''){
				$("#desktopIframe").attr('src',_ctxPath+"/portal/deskTopController.do?method=desktopIndex&skinPathKey="+skinPathKey);
			}
			$("#desktopIframe").show();
			$(".return_ioc").css("background","");
		}
		
		$.initChangeLeftNav();
		$.initTimeLine();
		$.initMyShortcut($.ctx.shortcut);
		$.initSysMessage();
		$.sysMessageEventBind();
		$.initUCMsg();
	}else if("true" == isCurrentUserGroupAdmin || ("2" != systemProductId && "4" != systemProductId && "true" == isCurrentUserAdministrator)){
		//管理员显示消息框，不显示设置和查看全部
		$.initSysMessage();
		$(".msg_setting_ico").hide();
		$(".msg_setting_look").hide();
		$(".msg_setting_ignore").css({"float":"right","padding-right":"10px"});
	}
	$.initHotspots();
	//在线打卡
	$("#onlineCard").click(function(){
		showMenu(_ctxPath+"/hrRecord.do?method=initRecord");
	});
	if(_locale == 'en'){
		$('#shortCutTitle').attr('title',$('#shortCutTitle').text());
		$('#agentNavTitle').attr('title',$('#agentNavTitle').text());
	}
	
	//在换肤组件中切换模版以后，弹出换肤组件
	if("true" == showSkinchoose){
		$("#skin").click();
	}

  
  $(".return_ioc").click(function(){
    //关闭换肤对话框
    $("#skin_set").html("").hide();
    $("#skin_set_iframe").attr("src", "about:blank");
    $("#skin_set_iframe").hide();
    currentPortalTemplate = "desktop";
    $(this).hide();
    $(".return_ioc2").show();
    //清空空间导航
    $(".area_r_icon").hide();
    $(".nav_center_more").hide();
    $(".banner_line").hide();
    
    var _src = $('#desktopIframe').attr('src');
    if(_src==''){
      $("#desktopIframe").attr('src', _ctxPath + "/portal/deskTopController.do?method=desktopIndex&skinPathKey="+skinPathKey);
    }
    $("#desktopIframe").show();
    $(this).css("background","");
  });
  
  $(".return_ioc2").click(function(){
    currentPortalTemplate = "default";
    $(this).hide();
    $(".return_ioc").show();
    $(".return_ioc").removeAttr("style");
    $("#desktopIframe").hide();
    $("#desktopIframe").attr('src',"");
    $("#layout_header_bg, #layout_header_bg_mask").hide();
    //显示空间导航
    $(".area_r_icon").show();
    if($.ctx.space.length>=4){
      $(".nav_center_more").show();
    }
    $(".banner_line").show();
    //刷新所有栏目
    refreshAllSection();
  });
  
  //高级按钮
  $("#searchAreaAButton").click(function(){
    gotoDefaultPortal();
    advanced();
    $("#searchClose").click();
  });
  
  //回车搜索
  $("#searchAreaInput").keyup(function(e){
    if(e.keyCode == 13){
      gotoDefaultPortal();
      indexSearch('all');
      $("#searchClose").click();
    }
  });
  
  //搜索按钮
  $("#seachIconButton").click(function(){
    gotoDefaultPortal();
    indexSearch('all');
    $("#searchClose").click();
  });
  
  //人员头像
  $(".avatar > img").attr("src",memberImageUrl);
  $(".avatar").click(function(){
    $("#personalInfo").click();
  });
  //前进
  $("#forwardPage").click(function(){
	  historyForward();
  });
  //后退
  $("#backPage").click(function(){
	  historyBack();
  });
  //刷新
  $("#refreshPage").click(function(){
    reFlesh();
  });
  
  //产品导图
  $("#productView_btn").click(function(){
    isProductViewRefresh = false;
    showProductView();
  });
  
  var concurrentAccount = $.ctx.concurrentAccount;
  //兼职单位切换--start
  var _accountContainerW,_accountContainerH;
  if(concurrentAccount!=null && concurrentAccount.length>1){
	  if(concurrentAccount.length<=30){
		  if(concurrentAccount.length>10){
			  _accountContainerH  = 390;
			  if(concurrentAccount.length%10>0){
				  _accountContainerW = (parseInt(concurrentAccount.length/10)+1);
			  }else{
				  _accountContainerW = parseInt(concurrentAccount.length/10);
			  }
		  }else{
			  _accountContainerW = 1;
		  }
		  for(var o=0;o<_accountContainerW;o++){
			  if(o == _accountContainerW-1){
				  $('#account_container').append("<ul id='account_container_ul"+o+"' class='account_container_ul' style='margin-right:0px;'></ul>");
			  }else{
				  $('#account_container').append("<ul id='account_container_ul"+o+"' class='account_container_ul'></ul>");
			  }
		  }
		  for(var i=0;i<concurrentAccount.length;i++){
			  var selectHtml="";
			  selectHtml +="<li onclick='chanageLoginAccount(\""+concurrentAccount[i].id+"\")'";
			  if(concurrentAccount[i].id == $.ctx.CurrentUser.loginAccount){
				  selectHtml += " class='currentAccount' ";
			  }
			  selectHtml +=">"+concurrentAccount[i].shortName+"</li>";
			  $('#account_container_ul'+parseInt(i/10)).append(selectHtml);
		  }
		  $('#account_container').width(_accountContainerW*180+(_accountContainerW-1)*5).height(_accountContainerH);
		  var accountFlag = true;
		  $('#accountSelector').mouseenter(function(){
			  $('.account_container').show();
			  $('.account_iframe').width($('.account_container').width()).height($('.account_container').height());
		  }).mouseout(function(){
			  setTimeout(function(){
				  if(accountFlag){
					  $('#accountSelector').removeClass('account_current');
					  $('.account_container').hide();
					  $('.account_iframe').hide();
				  }
			  },200);
		  });
		  $('#account_container').mouseenter(function(e){
			  accountFlag = false;
			  $('#accountSelector').addClass('account_current');
			  if(e.target.id == "account_container" || e.target.className == "account_container_ul" || e.target.className == "currentAccount"){
				  $('.account_container').show();
				  $('.account_iframe').width($('.account_container').width()).height($('.account_container').height());
			  }
		  }).mouseout(function(e){
			  if(e.target.id == "account_container"){
				  $('#accountSelector').removeClass('account_current');
				  $('.account_container').hide();
				  $('.account_iframe').hide();
				  accountFlag = true;
			  }else{
				  $('#accountSelector').addClass('account_current');
				  $('.account_container').show();
				  $('.account_iframe').width($('.account_container').width()).height($('.account_container').height());
			  }
		  });
	  }else{
		  //特殊情况处理 
		   $('#account_container').append('<span style="position:absolute;top:0px;right:0px" class="dialog_close" id="account_li_close"></span>').append("<ul id='asd' class='account_container_ul' style='width:740px;height:500px;float:none;overflow:auto;display:block'></ul>");
		    var selectHtml="";
		    for(var i=0;i<concurrentAccount.length;i++){
			      selectHtml +="<li onclick='chanageLoginAccount(\""+concurrentAccount[i].id+"\")'";
			      if(concurrentAccount[i].id == $.ctx.CurrentUser.loginAccount){
			        selectHtml += " class='currentAccount' ";
			      }
			      selectHtml +=">"+concurrentAccount[i].shortName+"</li>";
			}
	      $('#asd').append(selectHtml);
	      $('#accountSelector').mouseenter(function(){
	    	    $(this).addClass('account_current');
		    	$('.account_container').css({'width':'740','height':'500'}).show();
		    	$('.account_iframe').css({'width':'740','height':'500'});
		  })
		  $('#account_li_close').click(function(){
			    $('#accountSelector').removeClass('account_current');
		    	$('.account_container').hide();
		    	$('.account_iframe').hide();
		  });
	  }
    $('#accountSelector').css("display", "block");
    $('.logodiv').css('margin-left',30);
  }
  //兼职单位切换--end
  
  //点击logo区域回到首页  
  $('.logodiv').bind("click",function(){
    logoDivClick();
  }).addClass("hand");
  $("#accountNameDiv").bind("click",function(){
    logoDivClick();
  }).addClass("hand");
  function logoDivClick(){
    if(isCurrentUserAdmin == "true"){
      $('#homeIcon').click();
    }else{
      if(currentPortalTemplate == "desktop" && defaultPortalTemplate == "default"){
        $(".return_ioc2").click();
          refreshNavigation();
      }else if(currentPortalTemplate == "default" && defaultPortalTemplate == "default"){
        refreshNavigation();
      }else if(currentPortalTemplate  == "default" && defaultPortalTemplate == "desktop"){
        $(".return_ioc").click();
      } 
    }
  }
  
  $("#my_agent").click(function(){
    showShortcut('/collaboration/pending.do?method=morePending&from=Agent');
  });
  

  //代理提醒
  if(_shortCutId=="" && showSkinchoose != "true"){
    agentAlert();
  }
  
  //显示产品导航
  if("false" == isAdmin && "A8" == productVersion && (systemProductId != "3" && systemProductId != "4")){
    $(".handle_icons").css({"width":"200px"});
    //$(".searchArea").css({"right":"286px"});
    $("#productView_btn").show();
    if("false" != productView_check){
      if(!(_shortCutId!="" || isProductViewRefresh == "true")){
        showProductView();
      }
    }
  } else {
    $("#productView_btn").hide();
  }
  
  //检测密码超期
  if(checkStrengthValidation()==0){
      checkPwdIsExpired();
  }
  //显示工作桌面入口图标
//  if($.ctx.customize.workDesktopEnabled && $.ctx.customize.workDesktopEnabled == "true"){
//	  $(".return_ioc").show();
//  } else {
//	  $(".return_ioc").hide();
//  }
  
  //在线消息定时任务开始
  initMessage(messageIntervalSecond);
  
  if(isCurrentUserAdmin == "true"){
	if("true" == showSkinchoose){
		$("#main").attr("src", _ctxPath + "/portal/portalTemplateController.do?method=portalTemplateMainV51");
	} else {
		$("#main").attr("src",_ctxPath + "/portal/portalController.do?method=showSystemNavigation");
	}
    if(menu && menu.length>0){
      $.pageMenu(menu)
      var _menu0 = menu[0];
      //$.initBackNavigation(_menu0);
      $('#main_layout_right').width(5);
      $('#content_layout_body_right').hide();
      $('#content_layout_body_left_content').css('marginRight',10);
    }
    $('#homeIcon').click(function(){
      hideLocation();
      $("#main").attr("src", _ctxPath + "/portal/portalController.do?method=showSystemNavigation");
    });
    $('#helpIcon').click(function(){
      showHelp();
    });
  }
  
  $("#remind_msg").click(function(){
    $("#main").attr("src", _ctxPath + "/message.do?method=showMessages&showType=0&readType=notRead");
  });
  
  if(isTopFrameNameNotNull == "true"){
    hideLogo();
    hideLogoutButton();
    $("#collapse_banner").click();
  }

  //精灵跳转我的文档
  if(geniusRedirect == "doc") {
    $("#main").attr("src", _ctxPath + "/doc.do?method=docIndex&openLibType=1");
  }
  
  if(_mainMenuId!=""){
    var _currentMenuJson  = getMainMenuObj($.ctx.menu,_mainMenuId,_clickMenuId);
    if(_currentMenuJson != null){
      //alert(_currentMenuJson.menuObj.url+"==="+_currentMenuJson.menuObj.name+"==="+_currentMenuJson.step)
      showMenu(_ctxPath+_currentMenuJson.menuObj.url,_currentMenuJson.menuObj.id,_currentMenuJson.step,_currentMenuJson.menuObj.target,_currentMenuJson.menuObj.name,_currentMenuJson.menuObj.resourceCode);
    }
  }
  
  //在线列表、UC中心
  if (isCurrentUserAdmin == "true") {
    $("#vst_online").click(function(){
      onlineMember();
    });
  } else {
    if(hasPluginUC == "true"){
      if(!hasEveryBody){//没有大家work
        $("#ucMsg").unbind("click").click(function(){
          openWinUC("a8", "msg");
        });
      }
      $("#online_uc").unbind("click").click(function(){
        openWinUC("a8", "org");
      });
    } else {
      $("#online_uc").unbind("click").click(function(){
        onlineMember();
      });
    }
  }
  //加载精灵
  setTimeout(initGenius, 1000);
  
  //大家社区消息
  getEBMessage();

  $(".uc_tabs_span").click(function(){
    $(this).removeClass("normal").addClass("current");
    $(this).siblings(".uc_tabs_span").addClass("normal").removeClass("current");
    if($(this).index()==1){
      $(".uc_container .space_item1").css("color","#0484be");
      $(".uc_tabs .space_item01").css("right","73px");
      $(".uc_tabs .space_item02").css("right","73px");
      $(".uc_list").removeClass("hidden");
      $(".dajia_list").addClass("hidden");
    }else{
      $(".uc_container .space_item1").css("color","#C6E8F7");
      $(".uc_tabs .space_item01").css("right","236px");
      $(".uc_tabs .space_item02").css("right","236px");
      $(".uc_list").addClass("hidden");
      $(".dajia_list").removeClass("hidden");
    }
    $(".uc_tabs .space_item01").css("color","#fff");
  });
});


function openBlank(link,workSpaceType){
  var openArgs = {};
  openArgs["url"] = link;
  openArgs["dialogType"] = "open";
  openArgs["resizable"] = "yes";
  openArgs[workSpaceType] = "yes";
  if(link.indexOf("linkSystemController") != -1){
    openArgs["closePrevious"] = "no";
  }
  var rv = v3x.openWindow(openArgs);
}

//空间点击
function showSpace(i,spaceId,path,type,openType,reloadFlag){
  //用来显示当前位置的图标
  if(type == "8"){//第三方系统空间
    currentSpaceType = "thridpartyspace";
  }else if(type == "11"){//关联系统
    currentSpaceType = "linksystem";
  }else if(type == "12"){//关联项目
    currentSpaceType = "relateproject";
  }  
  var changeSpace = false;
  if(!(currentSpaceId&&currentSpaceId==spaceId)){
    changeSpace = true;
  }
  currentSpaceId = spaceId;
  $.each($("#space").children("li"), function(j,obj){
    if($(obj).attr("id")=="space_"+i){
      $(obj).attr("class","selected");
      $(obj).attr("style", "");
      if(sccolor!=""){
        $(obj).css({"background":sccolor});
      }
    } else {
      $(obj).attr("class","");
      if(sbcolor!=""){
        $(obj).css({"background":sbcolor});
      }
    }
  });
  //个人类型空间判断  type== "0" || type == "5" || type == "10" || type == "15" || type == "16"
  if(reloadFlag ||(type!= "0" && type != "5" && type != "10" && type != "15" && type != "16")){
	  new portalManager().getSpaceMenusForPortal(spaceId, {
	    success : function(map){
	      var menus = map.menus;
	      var ownerMenu = map.ownerMenu;
	      //用户可以访问的菜单组总集合，不考虑个性化定制
	      if(map.memberMenus){
	        memberMenus =  map.memberMenus;
	        if(ownerMenu){
	          //也存在自有菜单
	          memberMenus.unshift(ownerMenu);
	        }
	      }
	      if(ownerMenu){
	        $.removeData(document.body,"resourceMenuCache");
	      }
	      if(menus){
	        //存在关联菜单
	        if(ownerMenu){
	          //也存在自有菜单
	          menus.unshift(ownerMenu);
	        }
	        showMenus(menus);
	      } else {
	        //不存在关联菜单
	        if(ownerMenu){
	          //存在自有菜单，拷贝默认菜单，并把自有菜单加到最前面
	          if($.ctx.menu){
	            var defMenu = $.ctx.menu.slice(0);
	            defMenu.unshift(ownerMenu);
	            showMenus(defMenu);
	          }
	        } else {
	          //不存在自有菜单，仅显示默认菜单
	          showMenus($.ctx.menu);
	        }
	      }
	    }
	  });
  }
  //去除我的快捷的选中效果
  $("#myShortcutDiv").removeClass('current_flag');
  $("#agentNav").removeClass('current_flag');
  //变量，控制显示空间自有菜单,单位、自定义单位、集团、自定义集团空间隐藏左面板
  /* setTimeout(function(){
    if(type == "2" || type == "3" || type == "17" || type == "18"){
      hideLeftNavigation();
    }else{
      showLeftNavigation();
    }
  },1000); */
  //个人类型空间判断  type== "0" || type == "5" || type == "10" || type == "15" || type == "16"
 
  if(path.indexOf("ViewPage=plugin/nc/A8")!= -1){
    //NC插件专用逻辑
    //获取缓存信息
    var cookieInf="";
    try {
      cookieInf =relPage(spaceId);
      if(cookieInf != '' && cookieInf != undefined){
        path = path+"&extendParam=" +encodeURIComponent(cookieInf);
      }
      destroy(spaceId);
    }catch(e){}
    var html = '<span class="nowLocation_ico"><img src="'+_ctxPath+'/main/skin/frame/'+skinPathKey+'/menuIcon/'+currentSpaceType+'.png"></span>';
    html += '<span class="nowLocation_content">';
    html += '<a style="color:#888;">NC</a>';
    html += '</span>';
    showLocation(html);
      
    $('#closeopenleft').hide();
    if(openType == "1"){
      //window.open(_ctxPath + path, "newWindow");
      openCtpWindow({'url': _ctxPath+path});
    } else {
      $("#main").attr("src", _ctxPath+path+"&width="+$("#main").width()+"&height="+$("#main").height());
    }
  } else {
    showMainMenu();
    if(path.indexOf("/project.do") != -1||path.indexOf("/thirdpartyController.do")!= -1){
      path = _ctxPath + path;
    } else {
      if(path.indexOf("?") == -1){
        path = path + "?showState=show";
      } else {
        path = path + "&showState=show";
      }
    }
    if(openType == "1"){
      if(path.indexOf("linkSystemController") != -1){
        openBlank(path,'workSpaceRight');
      } else {
        openCtpWindow({'url':path});
      }
    } else {
      $("#main").attr("src", path);
    }
    getCtpTop().refreshSpaceCurrentClass(spaceId);
  }
}

//显示快捷方式
function initShortcuts(shortcut){
  $("#shortcut").html("");
  if (shortcut) {
    var shortcutArray = shortcut, cut;
    for(var i = 0; i < shortcutArray.length; i++) {
      cut = shortcutArray[i];
      var _namestr = cut.nameKey;
      //if(_namestr.length>4){
        //   _namestr=cut.nameKey.substr(0,3)+'...';
      //}
      $("#shortcut").append('<a id="' + cut.idKey + '" title="'+cut.nameKey+'"  class="shortItem" onclick="showShortcut(\'' + cut.urlKey.escapeHTML() + '\')">'+
              '<em style="width:16px;height:16px;display:inline-block;vertical-align:middle;background:url(main/menuIcon/'+cut.iconKey+') no-repeat;background-position: 0 0;"></em>'+
              '<span class="margin_l_5 v_aling">' +_namestr +'</span></a>');
      if(i < shortcutArray.length -1){
        $("#shortcut").append("<div class='frount_nav_seprater'></div>");
      }
    }
  } else {
    $("#shortcut").hide();
  }
  //$.resizeShortCut();
  //新建二级
  if(shortcut){
    var shortcutArray = shortcut, cut;
    for (var i = 0; i < shortcutArray.length; i++) {
      cut = shortcutArray[i];
      if(cut.items&&cut.items.length>0){
        $("#"+cut.idKey).getMenu(cut); //初始化新建菜单
      } else {
        if(!cut.urlKey || cut.urlKey == ''){
          $("#"+cut.idKey).hide();
        }
      }
    }
  }
}

//快捷方式点击
function showShortcut(url,target){
  if($.trim(url).length == 0){
    return;
  }
  
  showMainMenu();
  showLocation();
  if("newWindow"==target){
	  if(url.indexOf("newPlan")!=-1){
		 openCtpWindow({'url':_ctxPath+url,'id':$.ctx.CurrentUser.id});
	  	}else{
	   	 openCtpWindow({'url':_ctxPath+url});
	  }
  }else{
     $("#main").attr("src", _ctxPath+url);
  }
  //setCurrentShortCut(id);
}

var openWindowFlag = null;

function showMenu(url,id,step,target,tarName,resourceCode,currentId){
	showMask();
  // 新建协同页面跳转到别的二级菜单页面，弹出提示，一级菜单定位不准OA-38216
  $('.main_menu_li').removeAttr('current').removeClass('main_menu_li_current');
  $('#'+currentId).removeClass('main_menu_li_hover').removeClass('main_menu_li_down').addClass('main_menu_li_current').attr('current',true);
  reloadPage(id,currentId);
  showLeftNavigation();
  
  showMainMenu();
  // 公文应用设置在非IE下不允许进入
  if (!$.browser.msie&&url==_ctxPath+"/edocController.do?method=sysCompanyMain"&&navigator.userAgent.toLowerCase().indexOf("edge")==-1) {
    $.alert("公文应用设置页面不支持此浏览器！");
    hideMask();
    return;
  }
  // 业务生成器菜单用于显示当前位置的特殊逻辑
  // 增加rescode的判断，用于同步新建协同窗口的url，避免可以同时打开两个
  if(resourceCode) {
    if(url.indexOf("_resourceCode") == -1){
      if(url.indexOf('?') == -1){
        url += "?";
      }else{
        url +="&";
      }
      url+="_resourceCode="+resourceCode;
    }
  }
  if("newWindow"==target){
    if(url.indexOf('showAbout') > 0) {
      showAbout();
    } else if(url.indexOf('showHelp') > 0) {
      showHelp();
    } else {
      // window.open(url,"newWindow");
      openCtpWindow({'url':url});
    }
  } else {
    showLocation();
    if(url.indexOf("linkConnectForMenu") != -1){
      url = url + "&target=mainFrame";
      getCtpTop().showLocation("");
    }
    $("#main").attr("src", url);
  }
  hideMask();
}

function setCurrentShortCut(id){
  $('.shortItem').removeClass('shortItem_over');
  $('#'+id).addClass('shortItem_over');
}

function getMenuObj(id, step){
  for (var i = 0; i < menu.length; i++) {
    var _menuTemp = menu[i];
    if (_menuTemp.id == id) {
      return _menuTemp;
    }
    var _item = _menuTemp.items;
    if(_item && _item.length > 0) {
      for (var f = 0; f < _item.length; f++) {
        var _temp = _item[f];
        if (_temp.id == id) {
          return _menuTemp;
        }
        var _tempItem = _temp.items;
        if(_tempItem && _tempItem.length) {
          for (var w = 0; w < _tempItem.length; w++) {
            if (_tempItem[w].id == id) {
              return _menuTemp;
            }
          }
        }
      }
    }
  }
}

function showMenus(menus){
  if(menus){
    menu = menus;
  } else {
    menu = $.ctx.menu;
  }
  if(menu){
  // $.initLayout();
  $('.nav').attr('pager',1)
    $.pageMenu(menu);
  }
  if( _judgeNum == "1"){ // 收起
    $.showLeftNavigation();
    $(".head_msg_16").show();
    if(!$.ctx.CurrentUser.isInternal){
      $("#onlineCard").hide();
    }else{
      $("#onlineCard").show();
    }
  }else{ // 展开
      $.hideLeftNavigation();
    $(".head_msg_16").hide();
    $("#onlineCard").hide();
  }
}

function advanced(){
  getCtpTop().main.location  = _ctxPath + '/index/indexController.do?method=search';
}

function search(){
  var keyword = document.getElementById("searchAreaInput").value;
  keyword = keyword.trim();
  if(keyword == "" || keyword == null){
    alert(indexErr);
    return;
  }
  // kuanghs 限制最大长度
  var max_length = 40;
  if(keyword.length>max_length){
    keyword=keyword.substring(0, max_length);
  }
  getCtpTop().main.location  = _ctxPath + '/index/indexController.do?method=searchAll&keyword=' + encodeURIComponent(keyword);
}

var EBMessageProperty = [];
function getEBMessage(){
    if(hasEveryBody){
        var msgUrl = _ctxPath + "/portal/everybodyWork.do?method=message";
        __getEBMessage(msgUrl);
        window.setInterval(function(){
            __getEBMessage(msgUrl);
        },60*2*1000);
    }
}
function __getEBMessage(msgUrl){
    $.ajax({
        url:msgUrl
        ,cache:false
        ,success:function(data){
            if(data!=null){
                try{
                    var temp = $.parseJSON(data);
                    if(temp.success && temp.datas!=null){
                        EBMessageProperty = temp.datas;
                    }
                    setEBMessageToArea(temp.datas);
                }catch(e){}
            }
        }
    });
}

function hasEBMessage(){
    try{
        if(EBMessageProperty!=null && EBMessageProperty.length>0){
            return true;
        }
        return false;
    }catch(e){
        return false;
    }
}
function hasUCMessage(){
    try{
        var msgFromCount = msgInstanceKeys.size();// 聊天对象个数
        if(msgFromCount>0){
            return true;
        }
        return false;
    }catch(e){
        return false;
    }
}
//打开大家社区
function openEBCenter(){
    $('.uc_container').hide();
    $('.uc_iframe').hide();
    getCtpTop().open(_ctxPath + "/portal/everybodyWork.do");
    //var height = window.screen.availHeight - 40;
    //var left = (window.screen.availWidth - 850 - 20) / 2;
    //window.open(_ctxPath + "/portal/everybodyWork.do", "", "left=" + left + ",top=0,width=850,height=" + height + ",location=no,menubar=no,resizable=no,scrollbars=no,titlebar=no,toolbar=no,status=no,depended=yes,alwaysRaised=yes");
}
//打开大家社区的通知列表
function openEBMsgList(companyID){
    companyID = companyID || "";
    $('.uc_container').hide();
    $('.uc_iframe').hide();
    getCtpTop().open(_ctxPath + "/portal/everybodyWork.do?method=openEBMsgList&companyID="+companyID);
    //var height = window.screen.availHeight - 40;
    //var left = (window.screen.availWidth - 850 - 20) / 2;
    //window.open(_ctxPath + "/portal/everybodyWork.do?method=openEBMsgList&companyID="+companyID, "", "left=" + left + ",top=0,width=850,height=" + height + ",location=no,menubar=no,resizable=no,scrollbars=no,titlebar=no,toolbar=no,status=no,depended=yes,alwaysRaised=yes");
}
//忽略大家社区的通知
function ignoreEBAllMsg(companyID){
    if(companyID!=null){
        $.ajax({
            url : _ctxPath + "/portal/everybodyWork.do?method=ignoreEBAllMsg&companyID="+companyID
            ,cache : false
            ,success:function(data){
                if(data!=null){
                    try{
                        var temp = $.parseJSON(data);
                        if(temp.success && temp.datas!=null){
                            EBMessageProperty = temp.datas;
                        }
                        if(temp.success){
                            EBMessageProperty = null;
                            setEBMessageToArea();
                        }
                    }catch(e){
            EBMessageProperty = null;
                        setEBMessageToArea();
          }
                }
            }
        });
    }
}

function setEBMessageToArea(){
    var datas = EBMessageProperty;
    var ebMsgArea = $(".uc_container ul.dajia_list");
    if(ebMsgArea.size()>0){
    ebMsgArea.empty();
        var tempArray = [];
    var _bottom_eb = "";
    var firstCompanyId= "";
        if(datas!=null && datas.length>0){
            var len=datas.length;
            if(len>5){
                len = 5;
            }
            for(var i=0; i<len; i++){
                var tempd = datas[i];
                var temps = "";
                var photo = tempd.photo || "";
                var tempContent = tempd.content;
                if(tempContent.length>20){
                    tempContent = tempContent.substr(0,17)+"...";
                }
                if(firstCompanyId==""){
                  firstCompanyId= tempd.companyID+"";
                }
                var msgSendName= "";
                if(tempd.publishName){
                  msgSendName= tempd.publishName+":";
                }
                temps += '<li class="pushdown_second" companyID="' + tempd.companyID + '" style="width:300px;" >';
                temps += '  <div class="nav_uc_msg_sender left">';
                temps += '    <div class="nav_uc_left_main " style="margin-top:15px;">'+msgSendName+'</div>';
                temps += '  </div>';
                temps += '  <div class="nav_uc_right left eb_content">';
                temps += '    <div class="nav_uc_right_main " style="margin-top:15px;">' + tempContent + '</div>';        
                temps += '  </div>';
                temps += '</li>';
                tempArray.push(temps);
            }
            _bottom_eb+= '<li class="msg_setting_ucMsg" style="width: 300px;height: 38px; line-height: 150%;">';
        }else{//没同时考虑致信和大家work
          _bottom_eb+= '<li class="msg_setting_ucMsg" style="width: 300px;height: 38px; line-height: 150%; border-top:none;">';
        }
        _bottom_eb += '<div class="msg_setting_uc eb_open" onclick="openEBCenter();">'+$.i18n("portal.open.dajiawork.js")+'</div>'+
       '<div class="msg_setting_uc eb_ignore" onclick="ignoreEBAllMsg(\''+firstCompanyId+'\')" style="color: rgb(120, 120, 120);">'+$.i18n("portal.message.ignoreall")+'</div>'+
       '<div class="msg_setting_uc eb_all" onclick="openEBMsgList();" style="color: rgb(120, 120, 120);">'+$.i18n("portal.message.seeall")+'</div>'+
    '</li>';
        
        var tempLis = $(tempArray.join(""));
        tempLis.mouseenter(function (event){
            var tempThis = $(this);
            if(!tempThis.hasClass("msg_setting_ucMsg")){
                tempThis.css("background","#fcf0c1").css('color','#fff');
            }
            tempThis = null;
            //event.stopPropagation();
        }).mouseleave(function(event){
            var tempThis = $(this);
            if(!tempThis.hasClass("msg_setting_ucMsg")){
                $(this).css('background','#fff').css('color','#000');
            }
            tempThis = null;
            //event.stopPropagation();
        });
        tempLis.find("div.eb_content").click(function(){
            var liobj = $(this).closest("li");
            openEBMsgList(liobj.attr("companyID"));
            liobj = null;
        });
        
    var tempArrayBottom = [];
    tempArrayBottom.push(_bottom_eb);
    var tempLis1 = $(tempArrayBottom.join(""));
        ebMsgArea.append(tempLis);
    ebMsgArea.append(tempLis1);
        tempLis = null;
    }
    ebMsgArea = null;
    if(datas!=null && datas.length>0){
      return datas.length;
    }else{
      return 0;
    }
}

function initEBAndUCMsg(){
    if(!hasUC && !hasEveryBody){
        return;
    }
    var containerHtml = "";
    var hasEBMsg = hasEBMessage(), hasUCMsg = hasUCMessage();
    containerHtml = '<div class="space_item2">◆</div>'+
  '<div class="space_item1">◆</div>'+

  <!-- 新增的html  start -->
  '<div class="uc_tabs">'+
    '<span class="uc_tabs_span normal"><span class="normal_span">'+$.i18n("portal.message.dajia.js")+'</span></span>'+
    '<span class="uc_tabs_span current"><span  class="normal_span">'+$.i18n("portal.message.zhixin.js")+'</span></span>'+
    '<div class="space_item02">◆</div>'+
    '<div class="space_item01">◆</div>'+
  '</div>';


  containerHtml += '<ul class="uc_list">';
    /**'<li class="pushdown_second" key="5271165032368195691" type="chat" name="桂彬" jid="5271165032368195691@localhost" style="width: 271px; line-height: 12px; background-color: rgb(255, 255, 255); color: rgb(0, 0, 0); background-position: initial initial; background-repeat: initial initial;">'+
      '<div class="nav_uc_ico left">'+
        '<img src="fileUpload.jpg" width="32" height="32">'+
      '</div>'+
      '<div class="nav_uc_right left">'+    
      '<div class="nav_uc_right_title">桂彬</div>'+    
      '<div class="nav_uc_right_main">够不</div>'+  
      '</div>'+  
      '<span class="nav_uc_num" style="display: block;">5</span>'+ 
       '<div class="uc_msg_ico_1" style="display: none;"></div>'+
       '<div class="uc_msg_ico_2" title="忽略" key="5271165032368195691" style="display: none;"></div>'+
    '</li>'+*/
    
  containerHtml += '</ul>'+
   '<ul class="dajia_list hidden">';
  containerHtml += '</ul>';
    $('.uc_container').prepend(containerHtml);
    var _uc = $(".msg_ioc");
    var _offset = _uc.offset();
    var _top = 50; 
    var _right = 24;
    function initMESG(){
        $('.uc_container ul.uc_list').empty();
        //******读取UC消息******
        var msgInstanceKeys = msgProperties.keys();
        var msgFromCount = msgInstanceKeys.size();// 聊天对象个数
        for (var i = 0; i < msgFromCount; i++) {
            var key = msgInstanceKeys.get(i);
            var msg = msgProperties.get(key);
            var msgCount = msg.size();// 当前聊天对象的消息个数
            var latestMsg = msg.getLast();
            var tName = latestMsg.name.escapeHTML();
            var senderName = "";
            var photo = _PhotoMap.get(latestMsg.jid);
            if (latestMsg.type == 'system') {
                photo = _ctxPath + "/apps_res/uc/chat/image/Group1.jpg";
            }
            if (latestMsg.jid.indexOf('@group') > -1) {
                senderName = latestMsg.username.escapeHTML() + ":";
                photo = _ctxPath + "/apps_res/uc/chat/image/Group1.jpg";
            }
            
            var msgContent = "";
            if (latestMsg.atts.size() > 0) {
                msgContent = senderName + "给您发送了文件";
            } else if (latestMsg.microtalk != null) {
                msgContent = senderName + "给您发送了语音";
            } else if (latestMsg.vcard != null) {
                msgContent = senderName + "给您发送了名片";
            } else {
                msgContent = getMsgLimitLength(senderName + latestMsg.content, 80);
                msgContent = msgContent.escapeHTML();
                for ( var j = 0; j < face_texts_replace.length; j++) {
                    msgContent = msgContent.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' />");
                }
            }
            photo = encodeURI(photo);
            var showHtml = ""
            showHtml += '<li class="pushdown_second" style="width:300px;" key="' + key + '" type="' + latestMsg.type + '" name="' + tName + '" jid="' + latestMsg.jid + '">' ;
            showHtml += "  <div class='nav_uc_ico left'><img src=" + photo + " width='32' height='32' /></div>";
            if (latestMsg.type != 'system') {
                showHtml += '  <div class="nav_uc_right left">';
                showHtml += '    <div class="nav_uc_right_title">' + tName + '</div>';
                showHtml += '    <div class="nav_uc_right_main">' + msgContent + '</div>';
                showHtml += '  </div>';
                showHtml += '  <span class="nav_uc_num">' + msgCount + '</span>';
            } else {
                showHtml += '  <div class="nav_uc_right left">';
                showHtml += '    <div class="nav_uc_right_main " style="margin-top:15px;">' + msgContent + '</div>';        
                showHtml += '  </div>';
            }
            showHtml += '  <div class="uc_msg_ico_1"></div><div class="uc_msg_ico_2" title="'+$.i18n("portal.message.ignoreall")+'" key="' + key + '"></div>';
            showHtml += '</li>';
            $('.uc_container ul.uc_list').append(showHtml);
        }
        //大家社区初始化
        var dajiaWrokMsgCount= setEBMessageToArea();
        if(msgFromCount>0){
          $('#ucMsg_point').show();
          $(".uc_tabs_span")[1].click();
        }else if(dajiaWrokMsgCount>0){
          $('#ucMsg_point').show();
          $(".uc_tabs_span")[0].click();
        }else{
          $(".uc_tabs_span")[1].click();
          $('#ucMsg_point').hide();
        }
    
        $('.uc_container ul.uc_list li').mouseenter(function (event){
            $(this).css("background","#fcf0c1").css('color','#fff');
            $(this).find(".nav_uc_num").hide();
            $(this).find(".uc_msg_ico_1").show();
            //event.stopPropagation();
        }).mouseleave(function(event){
            $(this).css('background','#fff').css('color','#000');
            $(this).find(".nav_uc_num").show();
            $(this).find(".uc_msg_ico_1").hide();
            $(this).find(".uc_msg_ico_2").hide();
            //event.stopPropagation();
        }).click(function(event){
          if ($(event.target).hasClass("uc_msg_ico_2")) {
            return;
          }
          if ($(this).attr('type') == 'system') {
            ignoreOne($(this).attr('key'));
          } else {
            viewOne($(this).attr('key'), $(this).attr('name'), $(this).attr('jid'));
          }
        });
    
    var _bottom_uc= "";
    if(hasUCMsg){
      _bottom_uc += '<li class="msg_setting_ucMsg" style="width: 300px;height: 38px; line-height: 150%;">';
    }else{
      _bottom_uc += '<li class="msg_setting_ucMsg" style="width: 300px;height: 38px; line-height: 150%; border-top:none;">';
    }
     _bottom_uc += '<div class="msg_setting_uc msg_setting_open" onclick="openExchangeCenter();">'+$.i18n("uc.openExchangeCenter.js")+'</div>'+
       '<div class="msg_setting_uc msg_setting_all" oncick="ignoreAll();"  style="color: rgb(120, 120, 120);">'+$.i18n("portal.message.ignoreall")+'</div>'+
       '<div class="msg_setting_uc msg_setting_see" onclick="viewAll();" style="color: rgb(120, 120, 120);">'+$.i18n("portal.message.seeall")+'</div>'+
    '</li>';

    $('.uc_container ul.uc_list').append(_bottom_uc);
        
        var _iframeWidth = $('.uc_container').width();
        var _iframeHeight =  $('.uc_container').height();
        $('.uc_container').css({
            'top':_top,
            'right':_right
        });
        $('.uc_iframe').css({
            'top':_top,
            'right':_right,
            'width':_iframeWidth,
            'height':_iframeHeight
        }); 
        
        $('.uc_container ul li.pushdown_second').css("line-height","12px");
        $('.uc_container ul li.pushdown_second').css("height","auto");
        $(".uc_msg_ico_1").mouseenter(function(){
            $(this).hide();
            $(this).parent().find(".uc_msg_ico_2").show();
        });
        $(".uc_msg_ico_2").mouseleave(function(){
            $(this).hide();
            $(this).parent().find(".uc_msg_ico_1").show();
        }).click(function(){
            ignoreOne($(this).attr("key"));
        });
    }
    initMESG();
    
    var _ff = true;
    $('.msg_ioc').mouseenter(function(){
        $('.djwk_container').hide();
        $('.djwk_iframe').hide();
        $('.person_container').hide();
        $('.person_iframe').hide();
        $('.person_container').hide();
        $('.searchArea').hide();
        $('.searchAreaIframe').hide();
        setTimeout(function(){
            initMESG();
            var _uc = $(".msg_ioc");
            var _uc_offset = _uc.offset();
            var _pulldownPoint = $(window).width()-(_uc_offset.left)-45;
        //  console.log(_pulldownPoint);
            $('.uc_container  .space_item2').css("right", _pulldownPoint+"px");
            $('.uc_container  .space_item1').css("right", _pulldownPoint+"px");
            $(".uc_container").css("padding-bottom","0px");
            $('.uc_container').show();
            $('.uc_iframe').width($('.uc_container')[0].clientWidth).height($('.uc_container')[0].clientHeight).show();
            /*$(".msg_setting_ucMsg").css({
                "line-height":"150%"
            });*/
            //$(".msg_setting_ucMsg").parent().parent().css("padding-bottom","0");
        },200);
    }).mouseleave(function(){
        //setTimeout(function(){
            if(_ff){
                //$(".msg_setting_ucMsg").parent().parent().css("padding-bottom","18px");
                $('.uc_container').hide();
                $('.uc_iframe').hide();
            }
        //},200);
    });
    $('.uc_container').mouseenter(function(e){
        $('.djwk_container').hide();
        $('.djwk_iframe').hide();
        $('.person_container').hide();
        $('.person_iframe').hide();
        $('.person_container').hide();
        $('.searchArea').hide();
        $('.searchAreaIframe').hide();
        _ff = false;
        /*$(".msg_setting_ucMsg").css({
            "line-height":"150%"
        });*/
        //$(".msg_setting_ucMsg").parent().parent().css("padding-bottom","0");
        $(this).show();
        $('.uc_iframe').hide();
        $(".searchArea").hide();
        $('.searchAreaIframe').hide();
    }).mouseleave(function(e){
        if(e.target.className == 'space_item2' || e.target.className == 'space_item1'){return}
        _ff = true;
        $('.uc_iframe').hide();
        $(this).hide();
        //$(".msg_setting_ucMsg").parent().parent().css("padding-bottom","18px");
    });
}