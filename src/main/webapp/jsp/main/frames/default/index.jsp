<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
 <!DOCTYPE html>
<%@page import="com.seeyon.ctp.common.flag.*"%>
<html class="h100b over_hidden">
<head>
<%
if(BrowserEnum.valueOf(request) == BrowserEnum.IE11){
%>
	<META http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
<%
    } else {
%>
		<meta http-equiv="X-UA-Compatible" content="IE=EDGE"/>
<%
    }
%>



	<%@ include file="/main/common/frame_header.jsp" %>
	<c:if test="${ctp:hasPlugin('uc') && !CurrentUser.admin}">
	<%@ include file="/WEB-INF/jsp/apps/uc/uc_connection.jsp" %>
	</c:if>
	
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>${pageTitle}</title>
    <script type="text/javascript"  src="${path}/main/frames/default/frount-debug.js${ctp:resSuffix()}"></script>
    <link rel="stylesheet" type="text/css" href="${path}/main/frames/default/frount.css${ctp:resSuffix()}" />
    <c:set value="${ctp:currentUser().userSSOFrom}" var="topFrameName" />
    <script type="text/javascript">
    var ajaxCalEventBean = new calEventManager();
    var ajaxTimeLineBean = new timeLineManager();
    var timeLineObj;
    var curUserID = "${CurrentUser.id}";
    var menucolorset = false;
    var timeLineDate = null;
    var _mainMenuId = "${mainMenuId}";
    var _clickMenuId = "${clickMenuId}";
    var _shortCutId = "${shortCutId}";//刷新页面不出总导图
    var sectionTabColor = null;
    var sectionTabTextColor = null;
        $(document).ready(function () {
          //人员头像
          $("#avatar > img").attr("src",memberImageUrl);
          //登出
          $("#logout").click(function(){
	          logout();
          });
          //前进
          $("#historyForward").click(function(){
            historyForward();
          });
          //后退
          $("#historyBack").click(function(){
            historyBack();
          });
          //左导航控制
          $("#closeopenleft").click(function(){
        	  if($(this).attr("class")=="openLeft"){
        		  showLeftNavigation();
        	  }else{
	            hideLeftNavigation();
        	  }
            //$("#main").attr("src",$("#main").attr("src"));
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
          
          //兼职单位切换
          var concurrentAccount = $.ctx.concurrentAccount;
          if(concurrentAccount!=null&&concurrentAccount.length>1){
            
            var selectHtml = "<select id='chanageLoginAccount' style='width:180px;height:24px;' onchange=\"chanageLoginAccount(this.value)\">";
            for(var i=0; i<concurrentAccount.length; i++){
              selectHtml +="<option value=\""+concurrentAccount[i].id+"\"";
              if(concurrentAccount[i].id == $.ctx.CurrentUser.loginAccount){
                selectHtml += " selected ";
              }
              selectHtml +=">"+concurrentAccount[i].shortName+"</option>";
            }
            selectHtml +="</select>";
            $("#accountSelector").append(selectHtml);
            
          }else{
            $("#accountSelector").hide();
          }
          
          
            $.autoInitDiv();
            
            $.initSearch();
            
            
            //我的快捷
            initShortcuts($.ctx.shortcut);
            
            $("#my_set").click(function(){
              showShortcut('/portal/portalController.do?method=personalInfo');
            });
            $("#my_agent").click(function(){
            	showShortcut('/collaboration/pending.do?method=morePending&from=Agent');
            });
            if("${CurrentUser.admin}" != "true"){
            	try {
            	  ajaxTimeLineBean.getTimeLineResetDate("",{
                  success : function (lineDate){
                        timeLineDate = lineDate;
                        timeLineObj = initTimeLineDate();
                  }
                });
            	
        		} catch (e) {
        			// TODO: handle exception
        		} 
            }
            //空间显示-兼容NC的applet刷新
            if(!currentSpaceForNC){
              initSpaceNavigation($.ctx.space);
            }else{
              refreshNavigation(currentSpaceForNC);
              currentSpaceForNC = null;
            }
            
            //显示系统菜单
            showMenus(menu);
          
            //代理提醒
            if(_shortCutId==""){
            agentAlert();
            }
            //显示产品导航
            if("false" == isAdmin&&"A8" == productVersion){
              $(".handle_icons").css({"width":"200px"});
              $(".searchArea").css({"right":"210px"});
              $("#productView_btn").show();
              if("false" != productView_check){
            	if(!(_shortCutId!="" || isProductViewRefresh == "true")){
	                showProductView();
            	}
              }
            }else{
              $("#productView_btn").hide();
            }
            
            //检测密码超期
            if(checkStrengthValidation()==0){
      			checkPwdIsExpired();
  			}
            //banner折叠
            $("#collapse_banner").toggle(
              function () {
                $('.searchArea').hide();
                $('#search_iframe').hide();
                $(this).removeClass('unfold_icon').addClass("collapse_icon");
				$(this).attr("title","${ctp:i18n('seeyon.top.unfold.alt')}");
                $('#logo').css({
                    'height':37,
					'width':59
                });
                $('#accountNameDiv').css({
                    'marginTop':8
                });
                $('#accountSecondNameDiv').hide();
                $('#area_l').css({
                    'height':37
                });
                $('#area_r').css({
                    height:32,
                    'paddingTop':5
                });
                $('#stadic_layout_head').height(47);
                if ($.browser.msie && $.browser.version == '6.0') {
                  $('#stadic_layout_head').height(42);
                }
                $('#stadic_layout_body').css({
                    'top':47
                });
                if(timeLineObj){
	                timeLineObj.reset({
	                    autoHeight:-30
	                });
                }
                $.autoInitDiv();
              },
              function () {
                $('.searchArea').hide();
                $('#search_iframe').hide();
                $(this).removeClass("collapse_icon").addClass('unfold_icon');
                $(this).attr("title","${ctp:i18n('seeyon.top.collapse.alt')}");
                $('#logo').css({
                    'width':'auto',
                    'height':64
                });
                $('#accountNameDiv').css({
                    'marginTop':15
                });
                $('#accountSecondNameDiv').show();
                $('#area_l').css({
                    'height':64
                });
                $('#area_r').css({
                    'height':40,
                    'paddingTop':20
                });
                $('#stadic_layout_head').height(74);
                $('#stadic_layout_body').css({
                    'top':74
                });
                if(timeLineObj){
	                timeLineObj.reset({
	                    autoHeight:0
	                });
                }
                $.autoInitDiv();
              }
            );
            
            $.initOnLine();
            
            //在线消息
            initMessage("${ctp:getSystemProperty('message.interval.second')}");
            if("${CurrentUser.admin}" == "true"){
              $("#main").attr("src",_ctxPath+"/portal/portalController.do?method=showSystemNavigation");
              if(menu && menu.length>0){
                var _menu0 = menu[0];
                $.initBackNavigation(_menu0);
                $('#main_layout_right').width(5);
                $('#content_layout_body_right').hide();
                $('#content_layout_body_left_content').css('marginRight',10);
              }
              $('#homeIcon').click(function(){
                $("#main").attr("src",_ctxPath+"/portal/portalController.do?method=showSystemNavigation");
              });
              $('#helpIcon').click(function(){
                showHelp();
              });
            }
            $("#remind_msg").click(function(){
                $("#main").attr("src", _ctxPath+"/message.do?method=showMessages&showType=0&readType=notRead");
            });
            if("${topFrameName!=null}"=="true"){
      	     hideLogo();
      	     hideLogoutButton();
      	     $("#collapse_banner").click();
            }

            //热点
            initHotspots();

            //精灵跳转我的文档
            if ("${param.geniusRedirect}" == "doc") {
            	$("#main").attr("src", _ctxPath + "/doc.do?method=docIndex&openLibType=1");
            }
            if(_mainMenuId!=""){
              var _currentMenuJson  = getMainMenuObj($.ctx.menu,_mainMenuId,_clickMenuId);
                if(_currentMenuJson != null){
                  //alert(_currentMenuJson.menuObj.url+"==="+_currentMenuJson.menuObj.name+"==="+_currentMenuJson.step)
                  showMenu(_ctxPath+_currentMenuJson.menuObj.url,_currentMenuJson.menuObj.id,_currentMenuJson.step,_currentMenuJson.menuObj.target,_currentMenuJson.menuObj.name,_currentMenuJson.menuObj.resourceCode)
                }
            }

            //在线列表、UC中心
            if ("${CurrentUser.admin}" == "true") {
            	$("#vst_online").click(function(){
        			onlineMember();
                });
            } else {
            	if("${ctp:hasPlugin('uc')}" == "true"){
            		$("#avatar").unbind("click").click(function(){
                    	openWinUC("a8", "msg");
                    });
                    
                    $("#online_uc").unbind("click").click(function(){
                    	openWinUC("a8", "org");
                    });
                } else {
                	$("#avatar").unbind("click").click(function(){
            			onlineMember();
                    });
                    
                    $("#online_uc").unbind("click").click(function(){
                    	onlineMember();
                    });
                }
            }
        });
        var sccolor = "";
        var sbcolor = "";
        function initHotspots(){
          var templates = $.ctx.template;
          //集团外文名称
          var groupSecondName =  new portalManager().getGroupSecondName();
          //当前单位外文名称
          var accountSecondName = new portalManager().getAccountSecondName();
          //产品id
          var productId = new portalManager().getProductId();
          if(templates.length>0){
            var template = templates[0];
            var hotspots = template.portalHotspots;
            var logoImg = "";
            var logoImgtiling = 1;
            var accountName = "";
            var secondName = "";
            var kbcolor = "";
            var kccolor = "";
            var defkbcolor = "#e6e6e6";
            for(var i = 0;i < hotspots.length;i++){
              var hotspot = hotspots[i];
              var key = hotspot.hotspotkey;
              var value = hotspot.hotspotvalue;
              if(${CurrentUser.groupAdmin || CurrentUser.superAdmin}){
                //如果是集团管理员或超级管理员
                if(key == "groupName"){
                  if(hotspot.display == 1){
                    accountName = value;
                    if(productId == 2){
                      secondName = groupSecondName;
                    } else {
                      secondName = accountSecondName;
                    }
                  } else {
                    accountName = "";
                    secondName = "";
                  }
                }                
                if(key == "groupLogo"){
                  if(hotspot.display == 1){
                    logoImg = "${path}/main/frames/" + value + "?expand=" + hotspot.tiling;
                    logoImgtiling = hotspot.tiling;
                  } else {
                    logoImg = "";
                  }
                }
              } else if(${CurrentUser.systemAdmin || CurrentUser.auditAdmin}){
                //系统管理员、审计管理员
                if("A8" == productVersion){
	                accountName = "";
    	            secondName = "";
                }else{
                    if(key == "accountName") {
                       if(hotspot.display == 1){
                         if(accountName == ""){
                           accountName = value;
                         } else {
                           if(productId == 2){
                             accountName = accountName + "&nbsp;&nbsp;&nbsp;&nbsp;" + value;
                           } else {
                             accountName = value;
                           }
                         }
                         secondName = accountSecondName;
                       } else {
                         secondName = "";
                       }
                     }                	
                }
                if(key == "accountLogo"){
                  if(hotspot.display == 1){
                    logoImg = "${path}/main/frames/" + value + "?expand=" + hotspot.tiling;
                    logoImgtiling = hotspot.tiling;
                  } else {
                    logoImg = "";
                  }
                }

              } else {
                //单位管理员,普通人员
                if(key == "groupName"){
                  if(hotspot.display == 1){
                    accountName = value;
                  } else {
                    accountName = "";
                  }
                }
                if(key == "accountName") {
                  if(hotspot.display == 1){
                    if(accountName == ""){
                      accountName = value;
                    } else {
                      if(productId == 2){
                        accountName = accountName + "&nbsp;&nbsp;&nbsp;&nbsp;" + value;
                      } else {
                        accountName = value;
                      }
                    }
                    secondName = accountSecondName;
                  } else {
                    secondName = "";
                  }
                }
                if(key == "accountLogo"){
                  if(hotspot.display == 1){
                    logoImg = "${path}/main/frames/" + value + "?expand=" + hotspot.tiling;
                    logoImgtiling = hotspot.tiling;
                  } else {
                    logoImg = "";
                  }
                }
              }
              if(key == "hbackpic"){
                var hbackpic = "${path}/main/frames/" + value + "?expand=" + hotspot.tiling;
                $("#head_banner").css("background-image","url("+hbackpic+")");
                if(hotspot.tiling==1){
                  $("#head_banner").css({ "background-repeat": "repeat" });
                }else{
                  $("#head_banner").css({ "background-repeat": "no-repeat" });
                }
              }
              if(key == "kbcolor"){
                //左面板背景颜色
                $("#main_layout_left").css({"background":value});
                $("#remind_msga").css({"background":value}); 
                if(value == defkbcolor){
                  $("#main_layout_left").attr("style", "");
                }
                kbcolor = value;
              }
              if(key == "kccolor"){
                //左面板信息块选中颜色
                $("head").append("<style>.frount_nav .shortItem:hover{background:"+value+"}</style>");
                kccolor = value;
              }
              if(key == "mccolor"){
                //一级菜单选中颜色
                $("head").append("<style>.main_menu_li_hover{background:"+value+"}</style>");
                if(value!="#f2f2f2"){
                  menucolorset = true;
                }
              }
              if(key == "backpic"){
                //背景图
                var backpic = "${path}/main/frames/" + value + "?expand=" + hotspot.tiling;
                $("#stadic_layout").css("background-image","url("+backpic+")");
                if(hotspot.tiling==1){
                  $("#stadic_layout").css({ "background-repeat": "inherit" });
                 }else{
                  $("#stadic_layout").css({ "background-repeat": "no-repeat" });
                 }
              }
              if(key == "sbcolor"){
                //空间也签背景颜色
                $("#space li").css({"background":value});
                $("#space li.selected").css({"background-color":"none"});
                $("#space li.selected").attr("style", "");
                $("#spaceMoreBtn").css({"background":value});
                sbcolor = value;
              }
              if(key == "sccolor"){
                //空间页签选中颜色
                sccolor=value;
              }
              if(key == "cbcolor"){
                //工作区背景颜色
                $("#content_layout").css({"background":value}); 
              }
              if(key == "sectionTabTextColor"){
                sectionTabTextColor = value;
              }
              if(key == "sectionTabColor"){
                sectionTabColor = value;
              }
            }
            if(logoImg!=""){
              $("#logo").attr("src",logoImg);
              if(logoImgtiling==1){
                $("#logo").css({ "background-repeat": "inherit" });
              }else{
                $("#logo").css({ "background-repeat": "no-repeat" });
              }
              $("#comDiv").css({"margin-left":"0px"});
              $("#logo").show();
            } else {
              $("#comDiv").css({"margin-left":"30px"});
              $("#logo").hide();
            }
            if(sccolor!=""){
              $("#space .selected").css({"background":sccolor});
            }
            $("#accountNameDiv").html(accountName);
            $("#accountSecondNameDiv").html(escapeStringToHTML(secondName,false));
            if(secondName == null || $.trim(secondName) == ""){
              $("#accountNameDiv").css("margin-top", "24px");
            } else {
              $("#accountNameDiv").css("margin-top", "13px");
            }
            $("#remind_msga").mouseout(function(){
              if(kbcolor!=""){
                $("#remind_msga").css({"background":kbcolor});
              }
            });
            $("#remind_msga").mouseover(function(){
              if(kccolor!=""){
                $("#remind_msga").css({"background":kccolor});
              }
            }); 
          }
        }

        //显示空间导航
        function initSpaceNavigation(space,isBackToHome,redirectSpaceId,notShowSpace){
          $("#space").html("");
          var defaultSpace = 3;
          var _spaceArray = [];
          $(".spaceMore_area").empty();
          if(space&&space.length>0){
              var hasShowSpace = false;
              for (var i = 0; i < space.length; i++) {
                 if(!hasShowSpace&&!notShowSpace){
	                  if(redirectSpaceId && (space[i][0] == redirectSpaceId || space[i][1] == redirectSpaceId)){
	                     showSpace(i,space[i][0],space[i][2],space[i][6],space[i][7]);
	                     hasShowSpace = true;
	                  }else if(isBackToHome && currentSpaceId && (space[i][0] == currentSpaceId || space[i][1] == currentSpaceId)){
	                    showSpace(i,space[i][0],space[i][2],space[i][6],space[i][7]);
	                    hasShowSpace = true;
	                  }else if(!redirectSpaceId&&!isBackToHome&&i==0){
	                     showSpace(i,space[i][0],space[i][2],space[i][6],space[i][7]);
	                     hasShowSpace == true;
	                  }
                }
                  //NCPortal集成A8,隐藏A8集成的ERP空间
                  if("${topFrameName!=null}"=="true" && space[i][0]=="101"){
                      continue;
                  }
                  
                  if (i > defaultSpace) {
                      _spaceArray.push(space[i]);
                      continue;
                  }
                  
                  var _curSpaceName = space[i][3].length < 5 ? space[i][3] : space[i][3].substring(0,5);
                  _curSpaceName = replaceSpaceName(_curSpaceName);
                  if (currentSpaceId == space[i][0]) {
                      $("#space").append('<li title=\"' + escapeStringToHTML(space[i][3],false) + '\" class="selected" id="space_'+i+'" onclick="showSpace(\''+i+'\',\'' + space[i][0] + '\',\'' + space[i][2] + '\',\'' + space[i][6] + '\',\'' + space[i][7] + '\',\'true\')"><span>' +
                      escapeStringToHTML(_curSpaceName,false) +
                      '</span></li>');
                      
                  }
                  else {
                      $("#space").append('<li title=\"' + escapeStringToHTML(space[i][3],false) + '\" id="space_'+i+'" onclick="showSpace(\''+i+'\',\'' + space[i][0] + '\',\'' + space[i][2] + '\',\'' + space[i][6] + '\',\'' + space[i][7] + '\',\'true\')"><span>' +
                      escapeStringToHTML(_curSpaceName,false) +
                      '</span></li>');
                      
                  }
                  if(!$.browser.msie){
                	  if(/.*[\u4e00-\u9fa5]+.*$/.test(_curSpaceName)) 
                      { 
                        //alert("内容中含有汉字！"); 
                      //return false; 
                      } 
                      else{
                        $("#space li span:eq("+i+")").css("width","90px").css("-webkit-transform","rotate(90deg) translate(30px,40px)").css("-moz-transform","rotate(90deg) translate(30px,40px)").css("-ms-transform","rotate(90deg) translate(30px,40px)");
                      }
                  }
              }
              //IE下含有英文数字会旋转90度， 除IE外浏览器只有 不含中文字符才会旋转90度。
              if($.browser.msie){
                $("#space li span").css("writing-mode","tb-rl").css("letter-spacing","3px").css("line-height","130%").css("width","13px");
              }
          }
          if (_spaceArray.length > 0) {
              $("#spaceMoreBtn").show();
              $("#spaceMoreBtn").showSpaceMore({
                  data: _spaceArray
              });
          }else{
              $("#spaceMoreBtn").hide();
          }
        }
        //空间点击
        function showSpace(i,spaceId,path,type,openType,reloadFlag){
        	/**
          //reloadFlag 点击空间第一个 刷新页面 默认第一次不传reloadFlag
          if(i == 0 && reloadFlag == 'true'){
        	  if ($.browser.msie) {
       		    //if ($.browser.version == '6.0' || $.browser.version == '7.0') {
	        	  spaceReloadPage("","",reloadFlag);
	              return;
       		    //}
        	  }
          }**/
          
          var changeSpace = false;
          if(!(currentSpaceId&&currentSpaceId==spaceId)){
            changeSpace = true;
          }
            currentSpaceId = spaceId;
            $.each($("#space").children("li"),function(j,obj){
                if($(obj).attr("id")=="space_"+i){
                  $(obj).attr("class","selected");
                  $(obj).attr("style", "");
                  if(sccolor!=""){
                    $(obj).css({"background":sccolor});
                  }
                }else{
                  $(obj).attr("class","");
                  if(sbcolor!=""){
                    $(obj).css({"background":sbcolor});
                  }
                }
            });
            new portalManager().getSpaceMenusForPortal(spaceId,{
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
                    }else{
                      //不存在关联菜单
                      if(ownerMenu){
                        //存在自有菜单，拷贝默认菜单，并把自有菜单加到最前面
                        var defMenu = $.ctx.menu.slice(0);
                        defMenu.unshift(ownerMenu);
                        showMenus(defMenu);
                      } else {
                        //不存在自有菜单，仅显示默认菜单
                        showMenus($.ctx.menu);
                      }
                    }
              }
            });
          //变量，控制显示空间自有菜单,单位、自定义单位、集团、自定义集团空间隐藏左面板
            /* setTimeout(function(){
              if(type == "2" || type == "3" || type == "17" || type == "18"){
                  hideLeftNavigation();
              }else{
                  showLeftNavigation();
              }
            },1000); */
            //个人类型空间判断  type== "0" || type == "5" || type == "10" || type == "15" || type == "16"
            if(type== "0" || type == "5" || type == "9" || type == "10" || type == "14" || type == "15" || type == "16"){
              showTimeLine();
            }else{
              hideTimeLine();
	        }
            //$("#main").attr("src", "about:blank");
            if(spaceId == "101"){
               //判断浏览器版本，目前仅支持IE
 			   var bro=$.browser;
 			   if(!bro.msie){
 				    $.messageBox({
 						'type' : 0,
 						'title':"${ctp:i18n('doc.system.message')}",
 						'msg' :"${ctp:i18n('nc.space.browser.error')}",
 						ok_fn : function() {
 						}
 					  });
 					  return;
 			   }	
              //获取缓存信息
              var cookieInf;
			  try{
					cookieInf =relPage();
					 if(cookieInf != '' && cookieInf != undefined){
						path = path+"&extendParam=" +encodeURIComponent(cookieInf);
					}
					destroy();
			  }catch(e){
			  }

              hideLeftNavigation();
              hideTimeLine();
              hideMainMenu();
              hideLocation();
			  $('#closeopenleft').hide();
			  if(openType == "1"){
			    //window.open(_ctxPath + path, "newWindow");
			    openCtpWindow({'url':path});
			  } else {
			    $("#main").attr("src", _ctxPath+path+"&width="+$("#main").width()+"&height="+$("#main").height());
			  }
            }else{
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
                //window.open(path, "newWindow");
                openCtpWindow({'url':path});
              } else {
                  $("#main").attr("src", path);
              }
            }
          
        }
        //显示快捷方式
        function initShortcuts(shortcut){
           $("#shortcut").html("");
           if (shortcut) {
                var shortcutArray = shortcut, cut;
                for (var i = 0; i < shortcutArray.length; i++) {
                    cut = shortcutArray[i];
                    var _namestr = cut.nameKey;
                    //if(_namestr.length>4){
                     //   _namestr=cut.nameKey.substr(0,3)+'...';
                    //}
                    $("#shortcut").append('<a id="' + cut.idKey + '" title="'+cut.nameKey+'" class="shortItem" onclick="showShortcut(\'' + cut.urlKey.escapeHTML() + '\',null,\''+cut.target+'\')">'+
                      '<em style="width:16px;height:16px;display:inline-block;vertical-align:middle;background:url(main/menuIcon/'+cut.iconKey+') no-repeat;background-position: 0 0;"></em>'+
                      '<span class="margin_l_5 v_aling">' +_namestr +'</span></a>');
                    if(i < shortcutArray.length -1){
                      $("#shortcut").append("<div class='frount_nav_seprater'></div>");
                    }
                }
            }else{
			$("#shortcut").hide();
			}
            $.resizeShortCut();
            //新建二级
            if(shortcut){
               var shortcutArray = shortcut, cut;
               for (var i = 0; i < shortcutArray.length; i++) {
                   cut = shortcutArray[i];
                   if(cut.items&&cut.items.length>0){
                     $("#"+cut.idKey).getMenu(cut); //初始化新建菜单
                   }else{
               	     if(!cut.urlKey || cut.urlKey == ''){
                         $("#"+cut.idKey).hide();
                     }
                   }
               }
            }
        }
        //快捷方式点击
        function showShortcut(url,id,target){
          if($.trim(url).length == 0){
            return;
          }
          //隐藏时间轴
          hideTimeLine();
          showMainMenu();
          showLocation();
          if("newWindow"==target){
        	  openCtpWindow({'url':_ctxPath+url});
          }else{
	          $("#main").attr("src", _ctxPath+url);
          }
          setCurrentShortCut(id);
       }
        
        var openWindowFlag = null;
        function showMenu(url,id,step,target,tarName,resourceCode,currentId){
        	//新建协同页面跳转到别的二级菜单页面，弹出提示，一级菜单定位不准OA-38216 
            $('.main_menu_li').removeAttr('current').removeClass('main_menu_li_current');
            $('#'+currentId).removeClass('main_menu_li_hover').removeClass('main_menu_li_down').addClass('main_menu_li_current').attr('current',true);
            reloadPage(id,currentId);
            showLeftNavigation();
            //隐藏时间轴
            hideTimeLine();
            showMainMenu();
            //公文应用设置在非IE下不允许进入
            
            if (!$.browser.msie&&url==_ctxPath+"/edocController.do?method=sysCompanyMain"&&navigator.userAgent.toLowerCase().indexOf("edge")==-1) {
            	$.alert("公文应用设置页面不支持此浏览器！");
            	return;
            	
           }
            if(resourceCode) {
              if(url.indexOf('?') == -1)
                url += "?";
              else
                url +="&";
              url+="_resourceCode="+resourceCode;
            }
            if("newWindow"==target){
                if(url.indexOf('showAbout') > 0) {
                	showAbout();
                } else if(url.indexOf('showHelp') > 0) {
                	showHelp();
                } else {
					//window.open(url,"newWindow");
					openCtpWindow({'url':url});
                }
            }else {
            	showLocation();
                if(url.indexOf("linkConnectForMenu") != -1){
                  url = url + "&target=mainFrame";
                  getCtpTop().showLocation("");
                }
            	$("#main").attr("src", url);
			}
            if("${CurrentUser.admin}" == "true"){
              var _menuobj = getMenuObj(id,step);
              if(_menuobj!=null){
                  $.initBackNavigation(_menuobj);
                  setCurrentShortCut(id);
              }
            }
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
                if (_item && _item.length > 0) {
                    for (var f = 0; f < _item.length; f++) {
                        var _temp = _item[f];
                        if (_temp.id == id) {
                            return _menuTemp;
                        }
                        var _tempItem = _temp.items;
                        if (_tempItem && _tempItem.length) {
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
          }else{
        	menu = $.ctx.menu;                
          }
          if(menu){
            $.initNavigation(menu);
          }
        }
        var LoginOpenWindow = <%=BrowserFlag.LoginOpenWindow.getFlag(request)%>;
    </script>
</head>
<body class="h100b over_hidden frount">
    <div id="second_menu" class="second_menu_contaner clearfix"></div>
    <iframe id="second_menu_iframe" class="menu_iframe" src="about:blank" frameborder="0"></iframe>
    <iframe id="third_menu_iframe" class="menu_iframe" src="about:blank" frameborder="0"></iframe>
    <iframe id="four_menu_iframe" class="menu_iframe" src="about:blank" frameborder="0"></iframe>
    <div id='spaceMore_area' class='spaceMore_area'></div>
	<iframe id="space_more_iframe" class="space_more_iframe" frameborder="0"></iframe>
    <iframe id="new_shortcut_iframe" class="new_shortcut_iframe" frameborder="0"></iframe>
    
    <div id="stadic_layout">
        <div id="stadic_layout_head">
            <div class="area">
                <div class="banner clearfix" id="head_banner">
                    <div class="area_l clearfix" id="area_l">
                        <div class="left logoDiv">
                            <img src="" id="logo" height="64"  border="0" />
                        </div>
                        <div id="comDiv" class="left comDiv">
                            <div id="accountNameDiv" class="companyLabel">
                                
                            </div>
                            <div id="accountSecondNameDiv" class="companyLabel2">
                                
                            </div>
                        </div>
                    </div>
                    <div class="area_r" id="area_r">
                        <div class="handle_icons">
                            <a   class="right" id="logout"><em class="ico24 close_icon" title="${ctp:i18n('seeyon.top.close.alt')}"></em></a>
                            <a   class="right"><em id="collapse_banner" class="ico24 unfold_icon" title="${ctp:i18n('seeyon.top.collapse.alt')}"></em></a>
                            <c:if test="${(CurrentUser.admin) == true}">
                            <a   class="right" id="helpIcon"><em class="ico24 help_icon" title="${ctp:i18n('seeyon.top.help.alt')}"></em></a>
                            <a   class="right" id="homeIcon"><em class="ico24 home_icon" title="${ctp:i18n('seeyon.top.default.alt')}"></em></a>
                            </c:if>
                            <c:if test="${!CurrentUser.admin}">
	                            <a onclick="startA8genius();" class="right" id="top-a8" title="${ctp:i18n('menu.tools.about')}">
	                            	<em class="ico24 minimize_icon${ctp:getSystemProperty('system.ProductId')}"></em>
	                            </a>
                            </c:if>
                            <a   class="right" id="productView_btn"><em class="ico24 productview_icon" title="${ctp:i18n('seeyon.top.productview.alt')}"></em></a>
                            <a   class="right" id="refreshPage"><em class="ico24 refresh_icon" title="${ctp:i18n('seeyon.top.reload.alt')}"></em></a>
                            <a   class="right" id="historyForward"><em class="ico24 back_icon" title="${ctp:i18n('seeyon.top.forward.alt')}"></em></a>
                            <a   class="right" id="historyBack"><em class="ico24 front_icon" title="${ctp:i18n('common.toolbar.back.label')}"></em></a>
                            <c:if test="${(CurrentUser.admin) != true && ctp:hasPlugin('index')}">
                            <a   class="right" id="searchIcon" ><em class="ico24 seach_icon" title="${ctp:i18n('seeyon.top.search.alt')}"></em></a>
                            </c:if>
                        </div>
                        <div class="right" ><!-- id="accountSelector" -->
                           <c:if test="${(CurrentUser.admin) != true}">
                            <div  id="accountSelector"></div>
                           </c:if> 
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="stadic_layout_body">
            <div id="main_layout">
                <div id="main_layout_left" class="relative clearfix over_hidden">
                    <c:choose>
                        <c:when test="${(CurrentUser.admin) == true}">
                            <div id="frount_nav_div" class="frount_nav h100b left">
                                <div class="vst_online hand" id="vst_online">
                                		<span class="margin_l_5 margin_t_5 display_inline-block font_bold"></span>
											<span id="onlineNum_adm" name="onlineNum_adm">${onlineNumber}</span>${ctp:i18n('portal.onlineNum.label')}
                                </div>
                                <div class="frount_nav_seprater_line"></div>
                                <div id="shortcutbtn" class="short_cut color_gray ">${ctp:i18n('portal.organization.manage.label')}</div>
                                <div class="frount_nav_seprater"></div>
                                <div class="short_cut_content" id="shortcut"></div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div id="frount_nav_div" class="frount_nav h100b left">
                                <div class="vst" id="avatar" style="cursor:pointer;">
                                    <img src="" width="104" height="104">
                                </div>
                                
                                <div class="vst_online" id="vst_online">
                                
                                    <span id="vst_online_state">
                                        <em class="ico16 online1 margin_r_5"></em><em class=" online_arrow"></em>
                                    </span>
                                    
                                    <span id="vst_online_state_text" class="margin_l_5 display_inline-block"></span>
                                    <span id="online_uc" style="cursor:pointer;" class="font_bold"><span id="onlineNum" name="onlineNum">${onlineNumber}</span>${ctp:i18n('portal.onlineNum.label')}</span>
                                    <c:if test="${isCanSendSMS}">
                                    <span class="ico16 send_sms_16" onclick="sendSMSV3X()"></span>
                                    </c:if>
                                    <div class="vst_state" id="vst_state">
                                    	<div style="position: absolute;width:25px; height:104px; top:2px; left:2px; background:#e6eaed; z-index:1;"></div>
                                        <a href="javascript:void(0)" id="online1" value="0" class="vst_state_item" style="position: relative;z-index:2;"><em class="ico16 online1 margin_lr_5"></em>&nbsp;${ctp:i18n('portal.onlineState.label1')}</a>
                                        <a href="javascript:void(0)" id="online2" value="1" class="vst_state_item" style="position: relative;z-index:2;"><em class="ico16 online2 margin_lr_5"></em>&nbsp;${ctp:i18n('portal.onlineState.label2')}</a>
                                        <a href="javascript:void(0)" id="online3" value="2" class="vst_state_item" style="position: relative;z-index:2;"><em class="ico16 online3 margin_lr_5"></em>&nbsp;${ctp:i18n('portal.onlineState.label3')}</a>
                                        <a href="javascript:void(0)" id="online4" value="3" class="vst_state_item" style="position: relative;z-index:2;"><em class="ico16 online4 margin_lr_5"></em>&nbsp;${ctp:i18n('portal.onlineState.label4')}</a>
                                    </div>
                                </div>
                                <div class="frount_nav_seprater_line"></div>

								<div id="myShortcutArea">
                                <%--
									<div id="myShortcut" class="short_cut color_gray">${ctp:i18n('common.my.shortcut')}</div>
									<div id='myShortcut_seprater' class="frount_nav_seprater"></div>
                                --%>

									<div class="short_cut_content" id="shortcut"></div>
									<c:if test="${hasAgent == true}">
					                <div class="frount_nav_seprater_line"></div>
					                    <a id="my_agent" class="shortItem">
					                        <em class="dailishixiang "></em><span class="margin_l_5 v_aling">${ctp:i18n('menu.personal.agent.label')}</span>
					                    </a>
					                </c:if>
					                <div class="frount_nav_seprater_line"></div>
	                                    <a id="my_set" class="shortItem">
						                      <em class="gerenshezhi "></em><span class="margin_l_5 v_aling">${ctp:i18n('menu.personal.affair')}</span>
						                </a>
                                    <div class="frount_nav_seprater_line"></div>
								</div>

                                <div id="remind_msg" class="remind_msg">
                                    <a id="remind_msga"><em class="ico24 email_24 msg_24 margin_l_10 margin_r_5"></em>${ctp:i18n('menu.personal.msg.label')}</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
					<div class="frount_nav_close h100b ">
						<div id="closeopenleft" class="closeLeft"></div>
					</div>
                </div>
                <div id="main_layout_right" class='clearfix'>
                    <div class="area">
                        <ul class="list" id="space">
                        </ul>
                        <div id="space_area">
                            <div id="spaceMoreBtn" class="spaceMoreBtn" title="${ctp:i18n('common.more.label')}">
                                 <span class="spaceMoreBtn_span"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="content_layout">
                    <div id="content_layout_top">
                        <div class="clearfix" id="menuDiv">
                            <ul class="main_menu clearfix" id="menuUL">
                            </ul>
                        </div>
                    </div>
                    <div id="content_layout_body">
                        <div id="content_layout_body_left">
                            <div id="content_layout_body_left_content" class="bg_color_white relative ">
                                <div id="nowLocationDiv" class="bg_color border_b hidden" style="height:19px;">
                                    <span id="nowLocation" class="common_crumbs "></span>
                                </div>
                               <div class="absolute w100b" id="main_div" class="page_color" style="top:25px;bottom:0;left:0;">
                                    <iframe src="" id="main" name="main" frameborder="0"  onload="setonbeforeunload()"  class="w100b h100b absolute"></iframe>
                                </div>
                            </div>
                        </div>
                        <div id="content_layout_body_right">
                            
                        </div>  
                    </div>
                </div>
            </div>
        </div>
    </div>
	<%-- 右下角A8消息弹出窗口start --%>
	<iframe id="DivShim4MsgWindow" scrolling="no" frameborder="0" style="position:absolute; right:0px; bottom:0px; display:none; z-index:103;width:280px;"></iframe>
	
	<div id="msgWindowDIV" style="width:280px; position:absolute; right:0px; bottom:0px; display:none; z-index:104;" class="page_color border_all">
		<table id="helperTable" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="32" class="title-background-1">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="84%" class="msgTitle">${ctp:i18n('portal.msgTitle.label')}</td>
							<td width="8%" title="${ctp:i18n('message.header.mini.alt')}" onclick="changeMessageWindow('a8')" class="hand"><span  class="dialog_min right"></span></td>
							<td width="8%" title="${ctp:i18n('message.header.close.alt')}" onclick="destroyMessageWindow('true', 'a8')" class="hand"><span  class="dialog_close right"></span></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr id="PerMsgContainerTR" style="display: none;"><td id="PerMsgContainer" align="right"></td></tr>
			<tr id="SysMsgContainerTR" style="display: none;"><td id="SysMsgContainer" align="right"></td></tr>
			<c:choose>
				<c:when test="${!CurrentUser.admin}">
					<tr align='right' valign="middle">
						<td class='bottom-background-1' style="padding: 0 5px;">
							<span class="hand like-a div-float" onclick="showMessageSet('/seeyon/message.do?method=showMessageSetting&fromModel=top')">${ctp:i18n('message.header.more.set')}</span>						
							<span class='hand like-a div-float-right' onclick='showMoreMessage("${path}/message.do?method=showMessages&showType=0&readType=notRead")'>[${ctp:i18n('message.header.more.alt')}]</span>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr align='center' valign='bottom'><td class='bottom-background-1'>&nbsp;</td></tr>
				</c:otherwise>
			</c:choose>
		</table>
	</div>
	
	<div id="msgWindowMaxDIV" style="position:absolute; right:1px; bottom:1px; display:none; z-index:105;" class="td-background-sys_max_${ctp:getSystemProperty('system.ProductId')} hand border_all padding_5" onclick="changeMessageWindow('a8')"></div>
	<%-- 右下角A8消息弹出窗口end --%>
	
	<iframe id="playSoundHelper" class="hidden" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
<script>

</script>
</html>
<!--加载NC Applet-->
<%
	if(AppContext.hasPlugin("nc")){
%>
<jsp:include page="/main/common/ncAppletLoading.jsp" flush="true"/> 
<%
}
%>