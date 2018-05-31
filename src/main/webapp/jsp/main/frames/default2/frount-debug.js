/**
 * @author macj
 */
//新建菜单
jQuery.extend({
  initBackNavigation:function(menu){
    var _thirdArray = [];
    var _verticalStr = "vertical-align:-2px;";
	if ($.browser.msie) {
        if ($.browser.version == '6.0' || $.browser.version == '7.0') {
        	_verticalStr = "";
        }
    }
    $("#shortcut").empty();
      $('#shortcutbtn').text(menu.name);
      var _menuItems = menu.items;
      if(_menuItems != null){
        for(var o = 0; o<_menuItems.length;o++){
          var _cut = _menuItems[o];
          var _namestr = _cut.name;
          //if(_namestr.length>4){
          //  _namestr=_cut.name.substr(0,3)+'...';
          //}
          $("#shortcut").append('<a id="' + _cut.id + '" title="'+_cut.name+'" class="shortItem text_overflow"><em class="ico16 arrow_2_r "> </em><span class="margin_r_5" style="'+_verticalStr+'" onclick="showShortcut(\'' + _cut.url.escapeUrl() + '\',\''+_cut.id+'\')">' +
          _namestr +
          '</span></a>');
          $("#shortcut").append("<div class='frount_nav_seprater'></div>");
          var _cutItem = _cut.items;
          if(_cutItem && _cutItem.length>0){
            var _tempData = [];
            for(var dd = 0; dd<_cutItem.length;dd++){
              var __ttt = _cutItem[dd];
              _tempData.push({'idKey':__ttt.id,'nameKey':__ttt.name,'urlKey':__ttt.url});
            }
            _thirdArray.push({'idKey':_cut.id,'items':_tempData});
          }
          
        }
      }
    if(_thirdArray.length>0){
      for(var f = 0;f<_thirdArray.length;f++){
        var cutTemp = _thirdArray[f];
        $("#"+cutTemp.idKey).getMenu(cutTemp); //初始化新建菜单
      }
    }
    $.resizeShortCut();
  },
//在线人员状态
  initOnLine:function(){
    $('#vst_online_state').click(function(){
        $('#vst_state').css({
          'top':143
        }).show();
    });
    $('#vst_online').mouseleave(function(){
      $('#vst_state').hide();
    });
    $('#vst_state').mouseenter(function(){
      $(this).show();
    }).mouseleave(function(){
      $(this).hide();
    });
    
    var _onlineManager = new onlineManager();
    
    $('.vst_state_item').click(function(){
      var _id = this.id;
      $('#vst_online_state').html("<em class='ico16 " + _id + " margin_r_5'></em><em class='online_arrow'></em>");
      
      _onlineManager.updateOnlineSubState($(this).attr('value'), {
        success: function(result){
        }
	  });
	  
      //上边判断了是否含有uc插件，这个地方就不需要判断了，只有上边弹出，才会有点击事件
      try{
    	  pushOnlineState(_id);
      }catch(e){
    	  
      }
      $('#vst_state').hide();
    });
  },
	//ie 6 7 需要js初始化div高度
	autoInitDiv:function(){
	  //(Weblogic)IE8浏览器集团管理员登录，页面显示空白
	  $('html').addClass('h100b').addClass('over_hidden');
		if ($.browser.msie) {
            if ($.browser.version == '6.0' || $.browser.version == '7.0') {
                var _l = $('#stadic_layout');
                var _h = $('#stadic_layout_head');
                var _b = $('#stadic_layout_body');
                var body_h = _l.height() - _h.height();
                _b.height(body_h);
                var con_t = $('#content_layout_top').height();
                $('#content_layout_body').height(body_h - con_t);
                $('#content_layout_body_tab').height(body_h - con_t);
				if ($.browser.version == '6.0' || $.browser.version == '7.0') {
                  $('#mainFrameDiv').height(body_h - con_t);
                  $('#main').height(body_h - con_t);
                }
            }
        }
	},
	//初始化快捷菜单高度
	resizeShortCut:function(){
		//header + 头像 + 在线人员(31+1)+ 消息(10+36+10)  去掉了我的快捷(36+1) 
		var _body = $('body').height()-(74+114+32+56);
		if(_body>0){
			if($('#myShortcutArea').size()>0){
				$('#myShortcutArea').height(_body);
			}
			var _shortItem = $('.shortItem');
			if(_shortItem.size()>0){
				if(37*_shortItem.size()>_body){
					var _hhhh = _body = _body/_shortItem.size();	
			    if ($.browser.msie && $.browser.version == '6.0') {
	          var ddd = (_hhhh-16)/2;
	          if(ddd>0){
	            _hhhh = _hhhh - ddd*2;
	            _shortItem.css({'line-height':(_hhhh-1)+'px','padding-top':ddd+'px','padding-bottom':ddd+'px'}).height((_hhhh-1));  
	          }
			    }else{
			      _shortItem.css({'line-height':(_hhhh-1)+'px'}).height((_hhhh-1));	
			    }
				}
			}
		}
	},
	//初始化搜索
	initSearch:function(){
		  var searchIconNum = 1;
			var _areaDiv = $("<div class='searchArea hidden'></div>");
			var _areaDivA = $("<a  title='"+$.i18n('advance.search.label')+"' class='searchAreaA hand'>"+$.i18n('advance.search.label')+"</a>");
			var _areaDivInput = $("<input id='keyword' name='keyword' type='text' class='searchAreaInput'/>");
			var _areaDivSpan = $("<a class='hand'><em class='ico24 seach_icon_button'>"+$.i18n('index.search.button')+"</em></a>");
			
			_areaDivA.click(function(){
				advanced();
			});
			_areaDivSpan.click(function(e){
				search();
			});
			_areaDivInput.keyup(function(e){
			  if(e.keyCode == 13){
			    search();
			  }
			});
			_areaDiv.append(_areaDivA);
			_areaDiv.append(_areaDivInput);
			_areaDiv.append(_areaDivSpan);
			
			$('#area_r').append(_areaDiv);
	    if ($.browser.msie && $.browser.version == '6.0') {
	       $('#chanageLoginAccount').css('margin-top','3px');
	       $("#accountSelector").append("<iframe id='search_iframe' class='search_iframe hidden' src='about:blank' frameborder='0'></iframe>");
	    }
	    
			$('#searchIcon').click(function(){
	      if (searchIconNum == 1) {
	        searchIconNum = 2;
	  			var _offset = $(this).offset();
	  			_areaDiv.css({
	  				top:_offset.top-3
	  			}).show();
	  	    if ($.browser.msie && $.browser.version == '6.0') {
	  	      if($('#stadic_layout_head').height()<60){
	  	        $("#search_iframe").css('top','10px')
	  	      }else{
	  	        $("#search_iframe").css('top','27px')
	  	      }
	  	       $("#search_iframe").show();
	  	    }
	      }else{
	        //_areaDiv.mouseleave(function(){
	          searchIconNum = 1;
	          $(_areaDiv).hide();
	          if ($.browser.msie && $.browser.version == '6.0') {
	            $("#search_iframe").hide();
	          }
	        //});
	      }
			});
	    
		},
	//初始化主导航
  initNavigation: function(menus){
    var _mainheight = $('#content_layout_body_left_content').height();
    var _maxSize = parseInt(_mainheight/26);//下拉菜单显示最多多少个，如果超过就显示上移下移按钮
    var holeWidth = $('#menuDiv').innerWidth();
    var moreArray = [];
    var menu = menus;
	  var menuLength = menu.length;
	  var _default = 8;
	  var isMoreMenu = false;
	  var _maxLength = parseInt(parseInt(holeWidth-78-49)/78);
	      _default = _maxLength;
    var menuUL = $('#menuUL');
        menuUL.html('<li class="main_menu_separate_li"><em class="main_menu_separate"></em></li>');
		
     
		if(menuLength>_maxLength){
			_default = _maxLength-1;
			isMoreMenu = true;
		}
    for (var i = 0; i < menu.length; i++) {
        /*//没有子菜单和同时本身没链接的一级菜单将不显示
        if((!menu[i].items||menu[i].items.length<=0)&&!menu[i].url){
          menuUL.empty();
          continue;
        }*/
        if (i > _default) {
            moreArray.push(menu[i]);
            continue;
        }
        var _currentstr = '';
        if(_mainMenuId!='' && _mainMenuId == menu[i].id){
          _currentstr = 'main_menu_li_current'
        }
        var listr = '<li class="main_menu_li '+_currentstr+'" id="' + menu[i].id + '" >';
        if(menu[i].url){
          listr += '<a id="' + menu[i].id + '_a" class="main_menu_a" onclick="showMenu(\''+_ctxPath+menu[i].url.escapeUrl()+'\',\''+menu[i].id+'\',1,\''+menu[i].target+'\',\''+escapeStringToHTML(menu[i].name,false)+'\');">';
        }else{
          listr += '<a id="' + menu[i].id + '_a" class="main_menu_a" >';
        }
        if(menu[i].icon){
          listr += '<em class="main_menu_em" icon="icon" style="width:32px;height:32px;display:inline-block;background:url(main/menuIcon/'+menu[i].icon+'?V=5_0_5_23) no-repeat;background-position: 0 0;"></em>';
        }else{
          listr += '<em class="main_menu_em icon32"></em>';
        }
        listr += '<span class="main_menu_span">' + escapeStringToHTML(menu[i].name,false) + '</span></a></li>';
        menuUL.append($(listr));
        menuUL.append($('<li class="main_menu_separate_li"><em class="main_menu_separate"></em></li>'));
    }
		if(isMoreMenu){
		  var listr = '<li class="main_menu_li main_menu_li_more" id="menu_more"><a id="menumore_a" class="main_menu_a" ><em class="main_menu_em_more"></em><span class="main_menu_span">'+$.i18n('common_more_label')+'</span></a></li>';
			menuUL.append($(listr));
      menuUL.append($('<li class="main_menu_separate_li"><em class="main_menu_separate"></em></li>'));
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
		//初始化二级菜单
		function initSecondMenu(_id){
      var _menu = getMenuItem(_id);
      if(_menu && _menu.items && _menu.items.length>0){
        var _second_menu = $('#second_menu');
        _second_menu.removeClass("second_menu_contaner_shadow_more").addClass("second_menu_contaner_shadow");
        _second_menu.empty();
        _second_menu.append("<div class='secont_right_sub'></div><div class='upaction'></div>");
        var _second_menu_content = $("<ul id='second_menu_content' class='second_menu_content'></ul>");
        currentId = _id;
        for (var g=0; g<_menu.items.length; g++) {
          var _item = _menu.items[g];
          var _childItems = _item.items;
          
          var _onclickStr = "";
          if(_item.url){
            _onclickStr = "onclick=\"showMenu('"+_ctxPath+_item.url.escapeUrl()+"','"+_item.id+"',2,'"+_item.target+"','"+escapeStringToHTML(_item.name,false)+"','"+_item.resourceCode+"','"+currentId+"')\"";
          }
          var _htmlStr = $("<li title='"+escapeStringToHTML(_item.name,false)+"' id='"+_item.id+"' class='second_menu_item'><span "+_onclickStr+"  class='second_menu_item_name'>"+escapeStringToHTML(_item.name,false)+"</span></li>");
          if(_childItems!=undefined && _childItems.length>0){
            _htmlStr = $("<li title='"+escapeStringToHTML(_item.name,false)+"' id='"+_item.id+"' class='second_menu_item'><span "+_onclickStr+" class='second_menu_item_name_next'>"+escapeStringToHTML(_item.name,false)+"</span><em class='next_menu_icon'></em></li>");
            var _subMenu = $("<div class='third_menu_container third_four_menu_container_shadow'><div class='upaction'></div></div>");
            var third_menu_content = $("<ul id='third_menu_content' class='third_menu_content'></ul>");
            for (var t=0; t<_childItems.length; t++) {
              var __childItem = _childItems[t];
              var _childItemOnclickStr = "";
              if(__childItem.url){
                _childItemOnclickStr = "onclick=\"showMenu('"+_ctxPath+__childItem.url.escapeUrl()+"','"+__childItem.id+"',3,'"+__childItem.target+"','"+__childItem.name+"','"+__childItem.resourceCode+"','"+currentId+"')\"";
              }
              var _subMenuItem = $("<li title='"+escapeStringToHTML(__childItem.name,false)+"' id='"+__childItem.id+"' class='third_menu_item'><span "+_childItemOnclickStr+" class='third_menu_item_name'>"+escapeStringToHTML(__childItem.name,false)+"</span></li>");
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
      
      $('.second_menu_item').each(function(){
        $(this).mouseenter(function(){
          $(this).addClass('second_menu_item_hover');
          $(this).find('em').addClass('next_menu_icon_1');
          $(this).find('em').removeClass('next_menu_icon');
          var _third_menu = $(this).find('.third_menu_container');
          if(_third_menu.length>0){
            var _third_menu_item = $(this).find('.third_menu_item');
            var _offset = $(this).offset();
            var _top = _offset.top-parseInt($('#stadic_layout_body').css('top'))-$('#content_layout_top').height();
            if((_top+_third_menu_item.length*26)>_mainheight){
              _top = _mainheight-_third_menu_item.length*26-10;
            } 
            if(_third_menu_item.length>_maxSize){
              _top = 0;
            }
            _third_menu.css({
              left:155,
              top:_top
            }).show();
            $('#third_menu_iframe').css({
              'left':_offset.left+155,
              'top':_offset.top,
              'height':_third_menu.height()
            }).show();
            
            if($('#four_menu_iframe').length>0){$('#four_menu_iframe').hide();}
            if(_maxSize<_third_menu_item.length){
              initMoveMenu(_third_menu,_maxSize,_mainheight);
            }
          }
          
        }).mouseleave(function(){
          $(this).removeClass('second_menu_item_hover');
          $(this).find('em').addClass('next_menu_icon');
          $(this).find('em').removeClass('next_menu_icon_1');
          $(this).find('.third_menu_container').hide();
          $('#third_menu_iframe').hide();
        }).click(function(e){
          if(e.target.className=='second_menu_item_name' || e.target.className=='second_menu_item_name_next'){
            $('.main_menu_li').removeAttr('current').removeClass('main_menu_li_current');
            $('#'+currentId).removeClass('main_menu_li_hover').removeClass('main_menu_li_down').addClass('main_menu_li_current').attr('current',true);
            $('#second_menu').hide();
            $('#second_menu_iframe').hide();
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
          $('.main_menu_li').removeAttr('current').removeClass('main_menu_li_current');
          $('#'+currentId).removeClass('main_menu_li_hover').removeClass('main_menu_li_down').addClass('main_menu_li_current').attr('current',true);
          $(this).parent().parent().hide();
          $('#third_menu_iframe').hide();
        });
      });

      if ($('#' + _id).length < 1) {
    	  return;
      }
      var _offset =$('#'+_id).offset();
      var _height =$('#'+_id).height();
        $('#second_menu').css({
        'left':_offset.left-2,
        'top':_offset.top+_height
      }).show();
      $('#second_menu_iframe').css({
        'left':_offset.left-2,
        'top':_offset.top+_height,
        'height':$('#second_menu').height()
      }).show();
      if($('#third_menu_iframe').length>0){$('#third_menu_iframe').hide();}
      if($('#four_menu_iframe').length>0){$('#four_menu_iframe').hide();}
      if(_menu.items&&_maxSize<_menu.items.length){
        initMoveMenu($('#second_menu'),_maxSize,_mainheight);
      }
		}
	
		var currentId = null;
		var hideSecondMenu = true;
		//给一级菜单绑定事件
		function initMenuItem(obj){
      $(obj).mouseenter(function(){
        var _id = this.id;
        $(this).removeClass('main_menu_li_current').addClass("main_menu_li_hover");
        
        $(this).prev(".main_menu_separate_li").find('em').removeClass('main_menu_separate').addClass('main_menu_separate_l_hover');
        var _nextSperate = $(this).next(".main_menu_separate_li");
        _nextSperate.find('em').removeClass('main_menu_separate').addClass('main_menu_separate_r_hover');
        if(!menucolorset){
          _nextSperate.append("<span class='main_menu_li_r_shadow_box'><span class='main_menu_li_r_shadow'></span></span>");
        }
        setTimeout(function(){
          if(_id == 'menu_more'){
            initMoreMenu(moreArray);
          }else{
            initSecondMenu(_id);
          }
        },0.2);
      }).mouseleave(function(e){
        $(this).removeClass("main_menu_li_hover");
        if($(this).attr('current') == 'true'){
          $(this).addClass("main_menu_li_current");
        }
        $(this).prev(".main_menu_separate_li").find('em').removeClass('main_menu_separate_l_hover').removeClass('main_menu_separate_r_hover').addClass('main_menu_separate');
        var _nextSperate = $(this).next(".main_menu_separate_li");
        _nextSperate.find('em').removeClass('main_menu_separate_l_hover').removeClass('main_menu_separate_r_hover').addClass('main_menu_separate');
        _nextSperate.find('.main_menu_li_r_shadow_box').remove();
        
        setTimeout(function(){
          if(hideSecondMenu){
            $('#second_menu').empty().hide();
            $('#second_menu_iframe').hide();
          }
        },0.1);
      }).mousedown(function(){
        $(this).removeClass("main_menu_li_hover").addClass('main_menu_li_down');
        if($(this).find("em").eq(0).attr('icon') == 'icon'){
          $(this).find("em").css({
            'backgroundPosition':'0px -32px'
          });
        }
      }).mouseup(function(){
        $('.main_menu_li').removeClass("main_menu_li_hover").removeClass('main_menu_li_down');
        $(this).removeClass("main_menu_li_down").addClass('main_menu_li_hover');
        if($(this).find("em").eq(0).attr('icon') == 'icon'){
          $(this).find("em").css({
            'backgroundPosition':'0px 0px'
          });
        }
        
      });
		}
		$('.main_menu_li').each(function(){
			initMenuItem(this);
		});
		
    $('#second_menu').unbind().mouseenter(function(){
      hideSecondMenu = false;
      if(currentId!=null){
        var _mainMenuLi = $('#'+currentId);
        _mainMenuLi.addClass("main_menu_li_hover");
        _mainMenuLi.prev(".main_menu_separate_li").find('em').removeClass('main_menu_separate').addClass('main_menu_separate_l_hover');
        var _nextSperate = _mainMenuLi.next(".main_menu_separate_li");
        _nextSperate.find('em').removeClass('main_menu_separate').addClass('main_menu_separate_r_hover');
        _nextSperate.append("<span class='main_menu_li_r_shadow_box'><span class='main_menu_li_r_shadow'></span></span>");
      }
    }).mouseleave(function(){
      hideSecondMenu = true;
      $('#second_menu').empty().hide();
      $('#second_menu_iframe').hide();
      $('#third_menu_iframe').hide();
      $('#four_menu_iframe').hide();
      if(currentId!=null){
        var _mainMenuLi = $('#'+currentId);
        _mainMenuLi.removeClass("main_menu_li_hover");
        _mainMenuLi.prev(".main_menu_separate_li").find('em').removeClass('main_menu_separate_l_hover').removeClass('main_menu_separate_r_hover').addClass('main_menu_separate');
        var _nextSperate = _mainMenuLi.next(".main_menu_separate_li");
        _nextSperate.find('em').removeClass('main_menu_separate_l_hover').removeClass('main_menu_separate_r_hover').addClass('main_menu_separate');
        _nextSperate.find('.main_menu_li_r_shadow_box').remove();
        
      }
    });
    //初始化更多菜单
    function initMoreMenu (moreArrays){
      if(moreArrays.length>0){
        var _second_menu = $('#second_menu');
        _second_menu.removeClass("second_menu_contaner_shadow").addClass("second_menu_contaner_shadow_more");
        _second_menu.empty();
        _second_menu.append("<div class='secont_right_sub_more'></div><div class='upaction'></div>");
        currentId = 'menu_more';
        var _second_menu_content = $("<ul id='second_menu_content' class='second_menu_content'></ul>");
        for (var g=0; g<moreArrays.length; g++) {
          var _item = moreArrays[g];
          var _chiled1 = _item.items;
          var _onclickStr1 = "";
          if(_item.url){
            _onclickStr1 = "onclick=\"showMenu('"+_ctxPath+_item.url.escapeUrl()+"','"+_item.id+"',1,'"+_item.target+"','"+_item.name+"','"+_item.resourceCode+"')\"";
          }
          var _htmlStr = $("<li id='"+_item.id+"' class='second_menu_item'><span "+_onclickStr1+" class='second_menu_item_name'>"+escapeStringToHTML(_item.name,false)+"</span></li>");
          if(_chiled1 && _chiled1.length>0){
            _htmlStr = $("<li id='"+_item.id+"' class='second_menu_item'><span "+_onclickStr1+" class='second_menu_item_name_next'>"+escapeStringToHTML(_item.name,false)+"</span><em class='next_menu_icon'></em></li>");
            var _subMenu = $("<div class='third_menu_container third_four_menu_container_shadow_more'><div class='upaction'></div></div>");
            var third_menu_content = $("<ul id='third_menu_content' class='third_menu_content'></ul>");
            for (var t=0; t<_chiled1.length; t++) {
              var _childItem = _chiled1[t];
              var _onclickStr22 = "";
              
              if(_childItem.url){
                _onclickStr22 = "onclick=\"showMenu('"+_ctxPath+_childItem.url.escapeUrl()+"','"+_childItem.id+"',2,'"+_childItem.target+"','"+_childItem.name+"','"+_childItem.resourceCode+"')\"";
              }
              
              var _subMenuItem = $("<li id='"+_childItem.id+"' class='third_menu_item'><span "+_onclickStr22+"  class='third_menu_item_name'>"+escapeStringToHTML(_childItem.name,false)+"</span></li>");
              var _chiled4 = _childItem.items;
              if(_chiled4 && _chiled4.length>0){
                _subMenuItem = $("<li id='"+_childItem.id+"' class='third_menu_item'><span  "+_onclickStr22+"  class='third_menu_item_name_next'>"+escapeStringToHTML(_childItem.name,false)+"</span><em class='next_menu_icon'></em></li>");
               
                var _subMenu4 = $("<div class='four_menu_container third_four_menu_container_shadow_more'><div class='upaction'></div></div>");
                var four_menu_content = $("<ul id='four_menu_content' class='four_menu_content'></ul>");
                for (var h=0; h<_chiled4.length; h++) {
                  var _childItem4 = _chiled4[h];
                  var _onclickStr3 = "";
                  if(_childItem4.url){
                    _onclickStr3 = "onclick=\"showMenu('"+_ctxPath+_childItem4.url.escapeUrl()+"','"+_childItem4.id+"',3,'"+_childItem4.target+"','"+_childItem4.name+"','"+_childItem4.resourceCode+"')\"";
                  }
                  var _subMenuItem4 = $("<li id='"+_childItem4.id+"' class='four_menu_item'><span "+_onclickStr3+" class='four_menu_item_name'>"+escapeStringToHTML(_childItem4.name,false)+"</span></li>");
                  four_menu_content.append(_subMenuItem4);
                };
                _subMenu4.append(four_menu_content);
                _subMenu4.append("<div class='downaction'></div>");
                _subMenuItem.append(_subMenu4);
              }
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
        
        
        $('.second_menu_item').each(function(){
          $(this).mouseenter(function(){
            $(this).addClass('second_menu_item_hover');
            $(this).find('em').addClass('next_menu_icon_1');
            $(this).find('em').removeClass('next_menu_icon');
            var _third_menu = $(this).find('.third_menu_container');
            if(_third_menu.length>0){
              var _third_menu_item = $(this).find('.third_menu_item');
              var _offset = $(this).offset();
              var _top = _offset.top-parseInt($('#stadic_layout_body').css('top'))-$('#content_layout_top').height();
              if((_top+_third_menu_item.length*26)>_mainheight){
                _top = _mainheight-_third_menu_item.length*26-10;
              } 
              
              if(_third_menu_item.length>_maxSize){
                _top = 0;
              }
              
              _third_menu.css({
                left:-157,
                top:_top
              }).show(); 
              $('#third_menu_iframe').css({
                left:_offset.left-157,
                top:_top+parseInt($('#stadic_layout_body').css('top'))+$('#content_layout_top').height(),
                height:_third_menu.height()
              }).show();
              
              if(_maxSize<_third_menu_item.length){
                initMoveMenu(_third_menu,_maxSize,_mainheight);
              }
            }
            var _four_menu = $(this).find('.four_menu_container');
            if(_four_menu.length>0){
            	$(".third_menu_item").find('em').addClass('next_menu_icon');
                $(".third_menu_item").find('em').removeClass('next_menu_icon_1');
            }
          }).mouseleave(function(){
            $(this).removeClass('second_menu_item_hover');
            $(this).find('em').addClass('next_menu_icon');
            $(this).find('em').removeClass('next_menu_icon_1');
            $(this).find('.third_menu_container').hide();
            $('#third_menu_iframe').hide();
          }).click(function(e){
            if(e.target.className=='second_menu_item_name' || e.target.className=='second_menu_item_name_next'){
              $('.main_menu_li').removeAttr('current').removeClass('main_menu_li_current');
              $('#'+currentId).removeClass('main_menu_li_hover').removeClass('main_menu_li_down').addClass('main_menu_li_current').attr('current',true);
              $('#second_menu').hide();
              $('#second_menu_iframe').hide();
            }
          });
        });
        
        $('.third_menu_item').each(function(){
          $(this).mouseenter(function(){
            $(this).addClass('third_menu_item_hover');
            $(this).find('em').addClass('next_menu_icon_1');
            $(this).find('em').removeClass('next_menu_icon');
            var _four_menu = $(this).find('.four_menu_container');
            if(_four_menu.length>0){
              var _four_menu_item = $(this).find('.four_menu_item');
              var _offset = $(this).offset();
              var _top = _offset.top-parseInt($('#stadic_layout_body').css('top'))-$('#content_layout_top').height()-parseInt($(this).parent().parent().css('top'))-1;
              if((_top+_four_menu_item.length*26)>_mainheight){
                _top = (_mainheight-_four_menu_item.length*26)/2;
              } 
              
              if(_four_menu_item.length>_maxSize){
                _top = 0;
              }
              
              _four_menu.css({
                left:-157,
                top:_top
              }).show();  
              
              $('#four_menu_iframe').css({
                left:_offset.left-157,
                top:_offset.top,
                height:_four_menu.height()
              }).show();
              if(_maxSize<_four_menu_item.length){
                initMoveMenu(_four_menu,_maxSize,_mainheight);
              }
            }
          }).mouseleave(function(){
            $(this).removeClass('third_menu_item_hover');
            $(this).find('em').addClass('next_menu_icon');
            $(this).find('em').removeClass('next_menu_icon_1');
            var _four_menu = $(this).find('.four_menu_container');
            if(_four_menu.length>0){
              _four_menu.hide();  
              $('#four_menu_iframe').hide();
            }
          }).click(function(e){
            if (e.target.className == 'third_menu_item_name' || e.target.className == 'third_menu_item_name_next') {
              $('.main_menu_li').removeAttr('current').removeClass('main_menu_li_current');
              $('#'+currentId).removeClass('main_menu_li_hover').removeClass('main_menu_li_down').addClass('main_menu_li_current').attr('current',true);
              $('#second_menu').hide();
              $('#second_menu_iframe').hide();
            }
          });
        });
        $('.four_menu_item').each(function(){
          $(this).mouseenter(function(){
            $(this).addClass('four_menu_item_hover');
          }).mouseleave(function(){
            $(this).removeClass('four_menu_item_hover');
          }).click(function(){
            $('.main_menu_li').removeAttr('current').removeClass('main_menu_li_current');
            $('#'+currentId).removeClass('main_menu_li_hover').removeClass('main_menu_li_down').addClass('main_menu_li_current').attr('current',true);
            $('#second_menu').hide();
            $('#second_menu_iframe').hide();
          });
        });
        var _offset =$('#menu_more').offset();
        var _height =$('#menu_more').height();
        $('#second_menu').css({
          'left':_offset.left+$('#menu_more').width()-155,
          'top':_offset.top+_height
        }).show();
        $('#second_menu_iframe').css({
          'left':_offset.left+$('#menu_more').width()-155,
          'top':_offset.top+_height,
          'height':$('#second_menu').height()
        }).show();
        if(_maxSize<moreArrays.length){
          initMoveMenu($('#second_menu'),_maxSize,_mainheight);
        }
      }
    }
  }
});

function getItems(obj,items,id,flag,index){
    if (obj && items) {
        var _li = obj;
        var divstr = "";
        divstr += '<ul id="' + id + '_subMenuUl" style="float:left">';
        divstr += '<li class="subMenuItems_top">';
        divstr += '<div class="'+(index==0?'subMenuItems_top_right':'subMenuItems_all')+'"></div>';
        divstr += '</li>';
        divstr += '</ul>';
        _li.append($(divstr));
        var _ul = $('#' + id + '_subMenuUl');
        for (var j = 0; j < items.length; j++) {
            _ul.append($("<li class=\"subMenuItems\"><a id=\"" + items[j].id + "_menuItem\" href=\"javascript:showSpace('" + _ctxPath + items[j].url + "')\">" + items[j].name + "</a></li>"));
        }
    }
}
function getMoreItems(obj,moreArray,index){
	var morestr = "";
    morestr += '<ul id="main_menu_li_more_subMenuUl'+index+'" style="float:left">';
    morestr += '<li class="subMenuItems_top">';
    morestr += '<div class="'+(index==0?'subMenuItems_top_right':'subMenuItems_all')+'">';
    morestr += '</div>';
    morestr += '</li>';
    morestr += '</ul>';
	obj.append($(morestr));
	var main_menu_li_more_subMenuUl = $('#main_menu_li_more_subMenuUl'+index);
	var _maxLength = parseInt(($('body').height()-147)/34);
	if(moreArray.length>0){
	    for (var g = 0; g < moreArray.length; g++) {
	        main_menu_li_more_subMenuUl.append($('<li class="subMenuItems" index="'+index+'" id="' + moreArray[g].id + '"><a id="55_a" href="javascript:void(0)">' + moreArray[g].id + '</a><div id="' + moreArray[g].id + '_subMenuDiv" class="subMenuDiv subMenuDiv_top"></div><li>'));
	        var _subMenuDiv = $('#' + moreArray[g].id + '_subMenuDiv');
			var mitems = moreArray[g].items;
			if (mitems) {
				if(mitems.length<=_maxLength){
					getMoreSubItems(_subMenuDiv,mitems,moreArray[g].id,0);
				}else{
					var _length = parseInt(mitems.length/_maxLength)+1;
					for(var i = 0;i<_length;i++){
			            var itemsTemp = mitems.slice(i*_maxLength, i*_maxLength+_maxLength);
						getMoreSubItems(_subMenuDiv,itemsTemp,moreArray[g].id,i);
					}
					_subMenuDiv.css({
						'width':_subMenuDiv.width()*_length
					});
				}
			}
	    }
	}			
}
function getMoreSubItems(obj,items,id,index){
	obj.append($('<ul id="' + id + '_subMenuUl'+index+'" style="float:left"></ul>'));
	var _ul = $('#' + id + '_subMenuUl'+index);
    for (var j = 0; j < items.length; j++) {
        _ul.append($("<li class=\"subMenuItems\"><a id=\"" + items[j].id + "_menuItem\" href=\"javascript:showSpace('" + _ctxPath + items[j].url + "')\">" + items[j].name + "</a></li>"));
    }
}
/*
 @author 甄帅
 右侧空间更多显示
 */
jQuery.fn.showSpaceMore = function(options){
  var _btnID = $(this).selector;
  var _btnLeft = $(_btnID).offset().left;
  var _btnTop = $(_btnID).offset().top;
  var _areaWidth = 176;
  var _data = options.data;
  var _html = "";
  var maxlength = 6;
  var _mainheight = $('#content_layout_body_left_content').height();
  if(_mainheight>0){
    maxlength = parseInt(_mainheight/35);
    if(maxlength<0){
      maxlength = 6;
    }
  }
  
  var isShowFlag = true;
  
  //_html += "<div id='spaceMore_area' class='spaceMore_area'>";
  var iii = 0;
  $(_data).each(function(index){
      if (((index + maxlength) / maxlength).toString().split(".").length == 1) {
        iii++;  
        if(iii==1){
         _html += "<ul>";
        } else{
         _html += "<ul class='border_l'>";
        }
      }
      _html += "<li><a class='font_size12' href='###' title=\"" + escapeStringToHTML(_data[index][3],false) + "\" onclick=\"showSpace(\'"+index+3+"\',\'" +  _data[index][0] + "\',\'" +  _data[index][2] + "\',\'" +  _data[index][6] + "\',\'" +  _data[index][7] + "\')\">" + escapeStringToHTML(_data[index][3],false) + "</a></li>";
      if (((index + 1) / maxlength).toString().split(".").length == 1) {
          _html += "</ul>";
          //_html += "<div class='line'></div>";
      }
  });
  //_html += "</div>";
  $('#spaceMore_area').append($(_html));
  
  function setPosition(){
      //设置宽度
      if (_data.length > maxlength) {
          $("#spaceMore_area").css({
              width: _areaWidth * Math.ceil(_data.length / maxlength) + Math.ceil(_data.length / maxlength)
          });
      }
      //设置top值
      var _windowHeight = $(window).height();
      var _areaHeight = $("#spaceMore_area").height();
      if (_btnTop + _areaHeight > _windowHeight) {
          $("#spaceMore_area").css({
              top: "",
              bottom: 0
          });
		  $('#space_more_iframe').css({
              top: "",
              bottom: 0
      });
      }
      else {
          $("#spaceMore_area").css({
              bottom: "",
              top: _btnTop  - 1
          });//因为框架设置了定位,所以减去相应top和边框
		  $("#space_more_iframe").css({
              bottom: "",
              top: _btnTop - 1
          });//因为框架设置了定位,所以减去相应top和边框
      }
  }
  $("#space_area").unbind("mouseenter").unbind("mouseleave");
  $("#space_area").mouseenter(function(){
      isShowFlag = true;
      setTimeout(function(){
        if(isShowFlag){
          $("#spaceMore_area").show();
          setPosition();
          $(_btnID).addClass("clicked");
          $('#space_more_iframe').width($("#spaceMore_area").width()+1).height($("#spaceMore_area").height()+4).show();
        }
      },100);
    
  });
  $("#space_area").mouseleave(function(){
      isShowFlag = false;
      setTimeout(function(){
        if(isShowFlag == false){
          $("#spaceMore_area").hide();
          $(_btnID).removeClass("clicked");
          $('#space_more_iframe').hide();
        }
      },100);
  });
  $('#spaceMore_area').mouseenter(function(){
    isShowFlag = true;
  }).mouseleave(function(){
    isShowFlag = false;
    $("#spaceMore_area").hide();
    $(_btnID).removeClass("clicked");
    $('#space_more_iframe').hide();
  });
  
};
/*
 @author 谢小萍
 */
//新建菜单
jQuery.fn.getMenu = function(cut){
    var data = cut.items;
    var parentId = cut.idKey;
    var _html = $('#'+parentId).html();
    $('#'+parentId).html(_html+"<span class='shortMore'></span>");
    var menuObj = "<div id='newMore"+parentId+"' class='nav_sub display_none'><div id='menu_border_l"+parentId+"' class='menu_border_l absolute'></div>";
    $(data).each(function(i){
      //menuObj += "<div class='"+(i<data.length-1?'menu_sep':'')+"' id='" + data[i].menu_id + "'>";
        //$(data[i].menus_name).each(function(n){
            //menuObj += "<a href='javascript:showSpace(\""+data[i].menus_name[n].url+"\")' id='" + data[i].menus_name[n].id + "'>" + data[i].menus_name[n].menu_name + "</a>";
      menuObj += "<a onclick='showShortcut(\""+data[i].urlKey.escapeUrl()+"\",null,\""+data[i].target+"\")' id='" + data[i].idKey + "' class='hand' onmouseover=\"$('#" + parentId + "').css({'color':'black'});\" onmouseout=\"$('#" + parentId + "').css({'color':'white'});\" >" + data[i].nameKey + "</a>";
      //});
      // menuObj += "</div>";
    });
    menuObj += "</div>";
    $('body').prepend($(menuObj));
  $('#menu_border_l'+parentId).height($("#"+parentId).outerHeight());
  var hideNewMenuFlag = true;
    $("#"+parentId).mouseenter(function(){
        var _prev = $(this).prev();
        var _next = $(this).next();
        if(_prev.size() == 0){
          _prev = $('#myShortcut_seprater');
        }
        _prev.addClass('frount_nav_seprater_new');
        if(_next.size() > 0){
          _next.addClass('frount_nav_seprater_new');
        }
      
        $(this).css({'background-color':'#fff','background-image': 'none'});
        $(this).css({'color':'black'});
        var _offset = $("#"+parentId).offset();
        var _newMore = $("#newMore"+parentId).height();
        var _bheight = $('body').height();
        if(_offset.top+_newMore>_bheight){
          $("#newMore"+parentId).css({
            top:_offset.top-(_offset.top+_newMore-_bheight),
            left:_offset.left+$(this).outerWidth()
          }).show();
          $("#new_shortcut_iframe").css({
            top:_offset.top-(_offset.top+_newMore-_bheight),
            left:_offset.left+$(this).outerWidth()
          }).height($("#newMore"+parentId).height()).show();
          
          
          $('#menu_border_l'+parentId).css({
            top:_offset.top+_newMore-_bheight-2
          });
        }else{
          $("#newMore"+parentId).css({
            top:_offset.top-1,
            left:_offset.left+$(this).outerWidth()
          }).show();
          $("#new_shortcut_iframe").css({
            top:_offset.top-1,
            left:_offset.left+$(this).outerWidth()
          }).height($("#newMore"+parentId).height()).show();
        }
        
        hideNewMenuFlag = true;
    }).mouseleave(function(){
      setTimeout(function(){
          if(hideNewMenuFlag){
              
              $("#"+parentId).css({'background-color':'transparent','background-image': 'inherit'});
              $("#"+parentId).css({'color':'white'});
              $("#newMore"+parentId).hide();
              $("#new_shortcut_iframe").hide();
              
              var _prev = $("#"+parentId).prev();
              var _next = $("#"+parentId).next();
              if(_prev.size() == 0){
                _prev = $('#myShortcut_seprater');
              }
              _prev.removeClass('frount_nav_seprater_new');
              if(_next.size() > 0){
                _next.removeClass('frount_nav_seprater_new');
              }
              
        }
      },10);
    
  });
    $("#newMore"+parentId).mouseenter(function(){
        hideNewMenuFlag = false;
        $(this).show();
        $("#new_shortcut_iframe").show();
        
        
        var _prev = $("#"+parentId).prev();
        var _next = $("#"+parentId).next();
        if(_prev.size() == 0){
          _prev = $('#myShortcut_seprater');
        }
        _prev.addClass('frount_nav_seprater_new');
        if(_next.size() > 0){
          _next.addClass('frount_nav_seprater_new');
        }
        
    }).mouseleave(function(){
      hideNewMenuFlag = true;
      $("#"+parentId).css({'background-color':'transparent','background-image': 'inherit'});
      
      $(this).hide();
      $("#new_shortcut_iframe").hide();
      
      
      var _prev = $("#"+parentId).prev();
      var _next = $("#"+parentId).next();
      if(_prev.size() == 0){
        _prev = $('#myShortcut_seprater');
      }
      _prev.removeClass('frount_nav_seprater_new');
      if(_next.size() > 0){
        _next.removeClass('frount_nav_seprater_new');
      }
  });
};



function advanced(){
	getCtpTop().main.location  = '/seeyon/index/indexController.do?method=search';
}

function search(){
    var keyword = document.getElementById("keyword").value;
    keyword = keyword.trim();
	if(keyword == "" || keyword == null){
		alert(indexErr);
		return;
	}
	// kuanghs 限制最大长度
	var max_length = 40;
	if(keyword.length>max_length){
		keyword=keyword.substring(0,max_length);
	}
	getCtpTop().main.location  = '/seeyon/index/indexController.do?method=searchAll&keyword=' + encodeURIComponent(keyword);
}
function refreshAccountName(accountName,secondName){
  new portalManager().getPortalHospots($.ctx.template[0].id,{
    success : function(data){
      top.$.ctx.template = $.parseJSON(data);
      top.initHotspots();
    }
  });
}
