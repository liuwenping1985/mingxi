function portletSortable(){
	$(".metroShortcut_box .shortcutBlock").off('mouseenter').on('mouseenter',function(e){
		$(this).unbind('click').click(function(){
			 $(this).data('clickFun') && $(this).data('clickFun')();
		});
	});
	$(".metroShortcut_box .shortcutBlock").off('mouseleave').on('mouseleave',function(e){
		$(this).unbind('click');
	});

	//为每个容器内的栏目添加拖拽功能
	$(".metroShortcut_box").sortable({
		cursor : 'move',//鼠标样式
		items : '.shortcutBlock:not(.shortcutBlock_more)',//可拖拽的栏目集合
		//cancel : '.shortcutBlock_more',//不可拖拽的栏目集合
		opacity : '0.6',//当前拖拽目标的透明度
		connectWith : '.metroShortcut_box',//允许多容器间互相拖拽，此为样式
		//placeholder : 'placeholder',//拖拽目的地的占位符
		tolerance : 'pointer',
		start : function(event, ui) {
			//ui.placeholder.html("<p>"+$.i18n("portal.sort.dragPortletHere")+"</p>");
			//ui.placeholder.height(ui.item.height());
		},
		out : function(event,ui){
			//容器内Item被拖拽为空时，添加占位符
			//var senderSize = ui.sender.children("div .portal-layout-cell").children("div .portal-layout-cell_head").length;
			//var senderBannerSize = ui.sender.children("div .portal-layout-cell").children("div .portal-layout-cell-banner").length;
			//if(senderSize <= 0 &&senderBannerSize<=0 && ui.item.parent().children(".placeholder").length<=0){
			/*if(ui.item.parent().children(".placeholder").length<=0){
				ui.sender.append("<div class='placeholder'><p>"+$.i18n("portal.sort.dragPortletHere")+"</p></div>");
				//ui.sender.children(".placeholder").height(ui.item.height());
			}*/
		},
		receive : function(event,ui){
 
			//容器被拖拽Item时，消除占位符
			//var receiverContainer =  ui.item.parent().children("div .portal-layout-cell");
			//var targetSize = receiverContainer.children("div .portal-layout-cell_head").length;
			//var targetBannerSize = receiverContainer.children("div .portal-layout-cell-banner").length;
			//if((targetSize >0 || targetBannerSize >0 )&&  ui.item.parent().children(".placeholder").length>0){
			/*var swidth = ui.item.parent().children(".fragment").attr("swidth");
			var y = ui.item.parent().children(".fragment").attr("y");
			var panelId = ui.item.children("input[id^='PanelId_']").val();
			var panel = sectionHandler.allSectionPanels[panelId];
			var nodeId = panel.nodeId;
			if(swidth&&panel&&nodeId){
				resizeSectionTitle(nodeId,swidth,y);
			}
			if(ui.item.parent().children(".placeholder").length>0){
				 ui.item.parent().children(".placeholder").remove();
			}
			ui.item.parent().append("<div class='placeholder'><p>"+$.i18n("portal.sort.dragPortletHere")+"</p></div>");*/
			
		},
		stop : function(event,ui){
			verification_shortcut();
			saveAllPortletSort();
			$.initMetroPortlet();
			$(ui.item).unbind("click") ;
			/*sortIndex();
			//拖动后添加频道按钮消失
			$("div[id^='add_section_div']").each(function(i,obj){
				$(obj).show();
			});
			//最小化每个栏目
			minSizeFragment();*/
		}
	});
}
function saveAllPortletSort(){
	var sortParam = new Array();
	//排序完成,存储坐标
	$(".metroShortcut").each(function(i,obj){
		var metroShortcutId = $(obj).attr("id");
		var layoutId = metroShortcutId.substring("metroShortcut_".length,metroShortcutId.length);

		$(obj).find(".metroShortcut_box").children("div[id^='portlet_']").each(function(j,portletObj){
			var param = {};
			var portletId = $(portletObj).find("input[name='pId']").val();
			var portletOrder = j;

			param["portletId"] = portletId;
			param["layoutId"] = layoutId;
			param["portletOrder"] = portletOrder;
			sortParam[sortParam.length] = param;
		});
	});
	//alert(sortParam);
	//alert($.toJSON(sortParam));
	deskMgr.savePortletSort($.toJSON(sortParam));
}