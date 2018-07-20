<%--
 $Author:
 $Rev: 
 $Date:: 
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@page import="java.util.*"%>
<html>
<head>
<title></title>
<script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js?V=V5_0_product.build.date"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
<%@ include file="/WEB-INF/jsp/apps/doc/js/docUtil.js"%>
var jsURL = "/seeyon/doc.do";
var currentUserId = "${CurrentUser.id}";
	$(function() {
		$(".tab_iframe li:odd").css({
			background : "#F7F7F7"
		});
		//==========平分式页签================
		$(".common_tabs2").each(function(index) {
			var _this = $(this);
			_this.find(".common_tabs_head a").click(function() {
				_this.find(".common_tabs_head a").removeClass("current");
				$(this).addClass("current");
				_this.find(".tab_iframe").hide();
				_this.find("." + $(this).attr("tgt")).show();
			});
		});
		var result;
		var obj = new Object();
		//查询条件对象
		var searchobj = $('#searchDiv').searchCondition({
			searchHandler : function() {
				var cdtion = searchobj.g.getReturnValue();
				obj.condition = cdtion.condition;
				obj.value = cdtion.value;
				$('#ajaxgridbar').ajaxgridbarLoad(obj);
			},
			conditions : [{
				id : 'title',
				name : 'title',
				type : 'input',
				text : "${ctp:i18n('doc.column.name')}",
// 				value: 'name'
				value : 'drp_frName_String_like'
			},{
				id : 'importent',
				name : 'importent',
				type : 'select',
				text : "${ctp:i18n('doc.doclib.jsp.contenttype')}",
				value : 'drp_frType_Long_equal',
				codecfg : "codeType:'java',codeId:'com.seeyon.apps.doc.manager.DocSearchContentTypeEnumImpl'",
			},{
				id : 'spender',
				name : 'spender',
				type : 'input',
				text : "${ctp:i18n('doc.jsp.knowledge.query.key')}",
				value : 'drp_keyWords_String_like'
			},{
				id : 'spc',
				name : 'spc',
				type : 'selectPeople',
				text : "${ctp:i18n('doc.jsp.knowledge.query.createUser')}",
				value : 'drp_createUserId_LinkedList_equal',
	            comp:"type:'selectPeople',mode:'open',panels:'Department,Team',selectType:'Member',maxSize:'1',showMe:'true'"
			},{
				id : 'datetime',
				name : 'datetime',
				type : 'datemulti',
				text : "${ctp:i18n('doc.metadata.def.lastupdate')}",
				value : 'drp_lastUpdate_Date_between',
				ifFormat:'%Y-%m-%d'
			}]
		});
		//=====搜索=========
		// 排序方式（默认降序）
		obj.sortOrder = "desc";
	    //=====排序=========
	    $("#span_icon_order").click(function(){
	        if(obj.sortOrder == 'desc'){
	        	obj.sortOrder = 'asc';
	        } else {
	        	obj.sortOrder = 'desc';
	        }
	        $('#ajaxgridbar').ajaxgridbarLoad(obj);
	    });

		//=====分页=========
		$('#ajaxgridbar').ajaxgridbar({
			managerName : 'knowledgePageManager',
			managerMethod : 'getCollects',
			callback : function(fpi) {
		    	var strHtml = "";
		    	for ( var i = 0; i < fpi.data.length; i++) {
		    		var d = fpi.data;
		    		var o = d[i];
		    		var strDate = fnEvalTimeInterval(o.docResourcePO.createTime);
		    		var cuId = o.docResourcePO.createUserId;
		    		strHtml +=
		    		"<li class='padding_10 border_t_gray'><img id='panle'  valueId= "+o.docResourcePO.createUserId+
		    		" class='left margin_l_10 margin_b_10 margin_r_20 hand' src=\"${v3x:avatarImageUrl(o.docResourcePO.createUserId)}\" "+
		    		" width='42' height='42'  onclick=\"getPeopleCardBig('"+o.docResourcePO.createUserId+"')\" />"+
		    			"<div class='over_auto_hiddenY'>"+
		    				"<div class='clearfix'>"+
		    					"<span class='left'>${ctp:i18n('doc.jsp.knowledge.my.collection.label')}<a id='panle' href=\"javascript:getPeopleCardBig('"+o.docResourcePO.createUserId+"')\" pcardattr='' valueId='"+o.docResourcePO.createUserId+ 
	    						"' class='margin_r_5'>"+o.userName+"</a>${ctp:i18n('doc.jsp.knowledge.my.collection.of')}<span"+
		    						"class='margin_r_5'>"+o.frTypeName+"</span><span"+
		    						"class='ico16 xls_16 margin_r_5'></span><a href=\"javascript:fnOpenKnowledge('"+o.docResourcePO.id+"')\"  "+
		    						"class='margin_r_5'>《"+o.docResourcePO.frName+"》</a><span><span class='stars4_5'></span></span> <span"+
		    						" class='color_gray right'>"+strDate+"</span>"+
		    				"</div>"+
		    				"<div class='margin_t_5'>"+
		    				"	${ctp:i18n('doc.file.path')}:" + o.pathString +
		    				"</div>"+
		    				"<div class='right clearfix margin_t_10'>"+
		    				"	<span class='left margin_r_10 color_gray'>${ctp:i18n('doc.contenttype.shoucang')}("+o.docResourcePO.collectCount+")</span> <span"+
		    				"		class='left margin_r_10 color_gray'>${ctp:i18n('doc.menu.download.label')}("+o.docResourcePO.downloadCount+")</span> <span"+
		    				"		class='left margin_r_10 color_gray'>${ctp:i18n('doc.jsp.comment')}("+o.docResourcePO.commentCount+")</span> <span"+
		    				"		class='left margin_r_10 color_gray'><a"+
		    				"		href='javascript:void(0);' onclick=\"_favoriteInCS('"+o.docResourcePO.id+"','"+o.docResourcePO.hasAttachments+"',2);\" >${ctp:i18n('doc.jsp.knowledge.recommend')}("+o.docResourcePO.recommendCount+")</a></span>"+
		    				"</div>"+
		    			"</div>"+
		    		"</li>"
		    	}
		      	$("#ulfpi").html(strHtml);
		      	getPeopleMiniCard();
			}
		});
		$('#ajaxgridbar').ajaxgridbarLoad(obj);
	});
	
	function getPeopleCardBig(id){
        $.PeopleCard({memberId:id});
     }
	
	function getPeopleMiniCard(){
		$("img").each(function(){
			var id = $(this).attr("valueId");
			$(this).PeopleCardMini({memberId:id});
		});
		
		$("[pcardattr]").each(function(){
			var id = $(this).attr("valueId");
			$(this).PeopleCardMini({memberId:id});
		});
	}
	
	function _favoriteInCS(docResourcesId,hasAttr,flag){
		if(flag=='1'){
			favorite('3', docResourcesId, hasAttr, '3');	
		}else if(flag=='2'){
			doc_recommend(docResourcesId);
		}
		
	}
</script>
</head>
<body>
	<div class="page_color stadic_layout ">
		<div class="over_auto padding_b_10">
			<div class="clearfix padding_lr_10 padding_tb_5 border_t border_r bg_color_gray">
				<div class="left color_gray margin_t_5">${ctp:i18n('doc.jsp.home.more.favorite.sort')}:
				    <span class="color_black margin_l_5">${ctp:i18n('doc.jsp.knowledge.query.collectTime')}</span>
				    <span id='span_icon_order' class="ico16 arrow_4_b"></span>
				</div>
				<div id="searchDiv" class="right"></div>
			</div>
			<ul id="ulfpi" class="bg_color_white border_r border_b clearfix" >
			</ul>
			<!-- 分页条  -->
			<%@ include file="/WEB-INF/jsp/apps/doc/flipInfoBar.jsp"%>
		
		</div>
	</div>
</body>
</html>

