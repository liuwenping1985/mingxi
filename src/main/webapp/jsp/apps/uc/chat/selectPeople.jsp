<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>${ctp:i18n('uc.title.js')}</title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/uc/chat/css/uc.css${ctp:resSuffix()}' />">
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/jquery.ztree.all-3.5.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/json2.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/shared.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_org.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_selectpeople.js${ctp:resSuffix()}" />"></script>
	<script type="text/javascript">
		var v3x = new V3X();
		v3x.init("${pageContext.request.contextPath}", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
		var connWin = getA8Top().window.opener;
		var cacheType = "selectPeople";
		var cacheJids = new Properties();
		var cacheNames = new Properties();

		var parentWindowData = window.parentDialogObj["UC_SelectPeople"].getTransParams();
	    var showCheck = parentWindowData["showCheck"] || false;
	    var showName = parentWindowData["showName"] || false;
	    var name = parentWindowData["name"] || "";
	    var data = parentWindowData["data"] || [];
        var isFromA8 = "${param.from}" == "a8";
	    var isGroupVer = "${isGroupVer}";
	    var accessableAccountIds = new Properties();
	    <c:if test="${isGroupVer == 'true'}">
		<c:forEach items="${accessableAccountIds}" var="accountId">
			accessableAccountIds.put("${accountId}", true);
		</c:forEach>
		</c:if>

		function OK() {
			var name = $('#Team_Name').text();
			if (showName) {
				if ($.trim(name) == '') {
					var random = $.messageBox({
						'title' : $.i18n('uc.config.title.message.js'),
						'type' : 0,
						'imgType': 2,
						'msg' : $.i18n('uc.group.name.check.js'),
						'ok_fn' : function (){
							$('#Team_Name').focus();
						},
						'close_fn' : function (){
							$('#Team_Name').focus();
						}
					});
					return null;
				}
				if ($.trim(name).length > 30) {
					var random = $.messageBox({
						'title' : $.i18n('uc.config.title.message.js'),
						'type' : 0,
						'imgType': 2,
						'msg' : $.i18n('uc.group.namelength.check.js'),
						'ok_fn' : function (){
							$('#Team_Name').focus();
							$('#Team_Name').text($('#Team_Name').text());
						},
						'close_fn' : function (){
							$('#Team_Name').focus();
							$('#Team_Name').text($('#Team_Name').text());
						}
					});
					return null;
				}
				
				if ($('#Selected_Member span').length < 1) {
					$.alert($.i18n('uc.group.personnel.check.js'));
					return null;
				}
			}
			
			var data = [];
			$('#Selected_Member span').each(function(i){
				if (typeof($(this).attr('source')) != 'undefined') {
					data[data.length] = {'type' : $(this).attr('type'), 'id' : $(this).attr('id'), 'source' : $(this).attr('source'), 'name' : $(this).text().getLimitLength(20, "...")};
				}
		    });
			return {'name' : name, 'data' : data, 'cacheJids' : cacheJids, 'cacheNames' : cacheNames};
		}

		//上一页响应
		function prevPage() {
			if (currentPage == 1) {
				return;
			}
			startProc('');
			currentPage = currentPage - 1;
			pageSearchMembers();
	    }

		//下一页响应
		function nextPage() {
			if (currentPage == totalPage) {
				return;
			}
			startProc('');
			currentPage = currentPage + 1;
			pageSearchMembers();
	    }

		$().ready(function() {
			$('.common_tabs a').click(function(){
				startProc('');
				getTabContent($(this).attr('id'), false);
			});
			
			$("#currentAccountId").width($('#select_input_div').width() - 18);

			if (isGroupVer == "true") {
                $(".select_input_div").click(function(){
                    try {
                    	getUnits();
                    } catch (e) {}
                });
            } else {
            	$(".select_input_div").hide();
            }

			$('#select_search_input').focus(function(){
		    	if ($(this).hasClass('color_gray')) {
            		$(this).removeClass('color_gray');
            		$(this).val('');
           		}
			}).blur(function(){
				var value = $.trim($(this).val());
          	  	if(value.length < 1) {
          			$(this).addClass('color_gray');
            		$(this).val($.i18n('uc.staff.name.js'));
          		}
			});
			
			//键盘监听事件
			$('#select_search_input').keyup(function(){
				if (event.keyCode == 13){
					$('#select_search_button').click();
				}	
			});

            //查询
			$('#select_search_button').click(function(){
				startProc('');
		    	S_SearchMembers = new ArrayList();
				
				var inputValue = $.trim($('#select_search_input').val());
				if (($('#select_search_input').hasClass('color_gray') && inputValue == $.i18n('uc.staff.name.js')) || inputValue == '') {
					S_SearchMembers = S_AllMembers;
           		} else {
		    		for(var i = 0; i < S_AllMembers.size(); i++){
		    			if(S_AllMembers.get(i).name.indexOf(inputValue) >= 0){
		    				S_SearchMembers.add(S_AllMembers.get(i));
		    			}
		    		}
               	}
           		
		    	cacheSearchMembers();
		    });

			//创建、修改群组
			if (showName) {
				$('#Team_Name_Div').show();

				//回显群组名称
				if (name) {
					$('#Team_Name').text(name);
				}
			}

			//回显已选人员
			if (data) {
	    		var html = '';
	    		for (var i = 0; i < data.length; i++) {
		    		html += '<span class="common_send_people_box font_size12" id="' + data[i].id + '" source="' + data[i].source + '" type="' + data[i].type + '">' + data[i].name + '<em class="ico16 affix_del_16"></em></span>';
		    	}
		    	
		    	$('#Selected_Member').html(html);

		    	$('#Selected_Member .common_send_people_box').click(function(){
			    	$('#' + $(this).attr('id') + 'State').removeClass('ico16 handled_16');
			    });

		    	$('.common_send_people_box').click(function(){
        			$(this).remove();
        		});
			}

			startProc();
			getCurrentUser();
		});
	</script>
</head>
<body class="h100b over_hidden">
<div class="bg_color_white display_none" id="Team_Name_Div">
	<div class="left margin_l_5 font_size12" style="height: 25px; line-height: 25px; vertical-align: middle;">${ctp:i18n('uc.group.name.js')}</div>
	<div class="margin_5 font_size12 border_all" id="Team_Name" style="overflow: auto; height: 25px; line-height: 25px; vertical-align: middle;" contenteditable='true'></div>
</div>

<div class="bg_color_white">
	<div class="left margin_l_5 font_size12" style="height: 45px; line-height: 45px; vertical-align: middle;">${ctp:i18n('uc.selected.personnel.js')}</div>
	<div class="margin_5 common_send_people" id="Selected_Member" style="height: 45px;"></div>
</div>

<div id="tabs" class="comp margin_l_5" comp="type:'tab',height:280,width:490">
    <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
            <li class="current"><a id="Dept" href="javascript:void(0)" tgt="Dept_div"><span>${ctp:i18n('uc.selectType.all.js')}</span></a></li>
            <li><a id="Team" href="javascript:void(0)" tgt="Team_div"><span>${ctp:i18n('uc.selectType.group.js')}</span></a></li>
            <li><a id="Post" href="javascript:void(0)" tgt="Post_div"><span>${ctp:i18n('uc.selectType.post.js')}</span></a></li>
            <li><a id="Relate" href="javascript:void(0)" tgt="Relate_div" class='last_tab'><span>${ctp:i18n('uc.selectType.relate.js')}</span></a></li>
        </ul>
    </div>
    
	<div class="clearfix border_t border_lr margin_r_5">
		<div class="left border_r" style="width:142px;">
			<div id="select_input_div" class="select_input_div margin_l_2 margin_tb_2" style="width: 141px;">
				<input name="currentAccountId" id="currentAccountId" type="text" class="select_input" readonly="readonly" value="" />
			</div>
		</div>
		<div class="right margin_r_2 margin_tb_2">
			<ul class="common_search">
				<li class="common_search_input"><input id="select_search_input" class="search_input" type="text" style="width:120px;" maxlength="25"/></li>
	    		<li><a class="common_button common_button_gray search_buttonHand" id="select_search_button"><em></em></a></li>
	    	</ul>
    	</div>
	</div>
    
    <div id='tabs_body' class="common_tabs_body border_all">
        <div id="Dept_div">
			<div id="Dept_SelectCenter">
				<div class="clearfix">
					<div class="left border_r" style="width: 140px; height: 280px overflow: hidden;">
						<ul class="ztree" id="Dept_SelectTree" style="border:none; _width: 190px; height: 275px;"></ul>
					</div>
					<div class="left clearfix padding_l_5" style="width: 330px; height: 280px;">
						<div class="P_SelectContent over_auto" id="Dept_SelectContent" style="height: 250px;margin-left: 20px;"></div>
						<div class="right common_over_page margin_r_2 margin_tb_2" style="height: 30px;">
							<a title="${ctp:i18n('uc.page.prev.js')}" class="common_over_page_btn" id="Dept_prevPage" onclick="prevPage()"><em class="pagePrev"></em></a>
							<span class="margin_l_10">${ctp:i18n('uc.page.current.js')}</span><span id="Dept_currentPage">1</span>/<span id="Dept_totalPage">1</span>${ctp:i18n('uc.page.total.js')}
							<a title="${ctp:i18n('uc.page.next.js')}" class="common_over_page_btn" id="Dept_nextPage" onclick="nextPage()"><em class="pageNext"></em></a>
						</div>
					</div>
				</div>
			</div>
        </div>
        <div id="Team_div" class="hidden">
			<div id="Team_SelectCenter">
				<div class="clearfix">
					<div class="left border_r" style="width: 140px; height: 280px overflow: hidden;">
						<ul class="ztree" id="Team_SelectTree" style="border:none; _width: 190px; height: 275px;"></ul>
					</div>
					<div class="left clearfix padding_l_5" style="width: 330px; height: 280px;">
						<div class="P_SelectContent over_auto" id="Team_SelectContent" style="height: 250px;margin-left: 20px;"></div>
						<div class="right common_over_page margin_r_2 margin_tb_2" style="height: 30px;">
							<a title="${ctp:i18n('uc.page.prev.js')}" class="common_over_page_btn" id="Team_prevPage" onclick="prevPage()"><em class="pagePrev"></em></a>
							<span class="margin_l_10">${ctp:i18n('uc.page.current.js')}</span><span id="Team_currentPage">1</span>/<span id="Team_totalPage">1</span>${ctp:i18n('uc.page.total.js')}
							<a title="${ctp:i18n('uc.page.next.js')}" class="common_over_page_btn" id="Team_nextPage" onclick="nextPage()"><em class="pageNext"></em></a>
						</div>
					</div>
				</div>
			</div>
		</div>
        <div id="Post_div" class="hidden">
			<div id="Post_SelectCenter">
				<div class="clearfix">
					<div class="left border_r" style="width: 140px; height: 280px overflow: hidden;">
						<ul class="ztree" id="Post_SelectTree" style="border:none; _width: 190px; height: 275px;"></ul>
					</div>
					<div class="left clearfix padding_l_5" style="width: 330px; height: 280px;">
						<div class="P_SelectContent over_auto" id="Post_SelectContent" style="height: 250px;margin-left: 20px;"></div>
						<div class="right common_over_page margin_r_2 margin_tb_2" style="height: 30px;">
							<a title="${ctp:i18n('uc.page.prev.js')}" class="common_over_page_btn" id="Post_prevPage" onclick="prevPage()"><em class="pagePrev"></em></a>
							<span class="margin_l_10">${ctp:i18n('uc.page.current.js')}</span><span id="Post_currentPage">1</span>/<span id="Post_totalPage">1</span>${ctp:i18n('uc.page.total.js')}
							<a title="${ctp:i18n('uc.page.next.js')}" class="common_over_page_btn" id="Post_nextPage" onclick="nextPage()"><em class="pageNext"></em></a>
						</div>
					</div>
				</div>
			</div>
		</div>
        <div id="Relate_div" class="hidden">
			<div id="Relate_SelectCenter">
				<div class="clearfix">
					<div class="left border_r" style="width: 140px; height: 280px overflow: hidden;">
						<ul class="ztree" id="Relate_SelectTree" style="border:none; _width: 190px; height: 275px;"></ul>
					</div>
					<div class="left clearfix padding_l_5" style="width: 330px; height: 280px;">
						<div class="P_SelectContent over_auto" id="Relate_SelectContent" style="height: 250px;margin-left: 20px;"></div>
						<div class="right common_over_page margin_r_2 margin_tb_2" style="height: 30px;">
							<a title="${ctp:i18n('uc.page.prev.js')}" class="common_over_page_btn" id="Relate_prevPage" onclick="prevPage()"><em class="pagePrev"></em></a>
							<span class="margin_l_10">${ctp:i18n('uc.page.current.js')}</span><span id="Relate_currentPage">1</span>/<span id="Relate_totalPage">1</span>${ctp:i18n('uc.page.total.js')}
							<a title="${ctp:i18n('uc.page.next.js')}" class="common_over_page_btn" id="Relate_nextPage" onclick="nextPage()"><em class="pageNext"></em></a>
						</div>
					</div>
				</div>
			</div>
        </div>
    </div>
</div>
<div id="accountListDiv" style="display:none; position:absolute; overflow:hidden; width:186px;"><ul id="accountList" class="ztree" style="height: 250px;"></ul></div>
</body>
</html>