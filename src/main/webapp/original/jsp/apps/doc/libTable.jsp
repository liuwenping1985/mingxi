<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<c:set value="${v3x:currentUser().loginAccount}" var="loginAccountId" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script language="javascript">
	var pageSize = 10;
	var start = 0;
	$(function(){
		//适配大分辨率的分页问题
		if($(window).width() > 1600){
			pageSize = 22;
		}
		$(window).resize(function(){
		 	setWidth();
		 	setbDiv();
		})
		initNewData();
		setWidth();
		//iconList 页面图标选中效果
		$(".mainDoc.iconList .docList_li").click(function(){
			$(this).toggleClass("current");
		});
		$(".mainDoc.iconList .docList_li").mouseover(function(){
			$(this).children(".choose").addClass("spanChoose");
		});

		$(".mainDoc.iconList .docList_li").mouseout(function(){
			if(!$(this).hasClass("current")){
				$(this).children(".choose").removeClass("spanChoose");
			}
		});
		showOpear();

	})
	function setWidth(){
		var height=$(window).height()-30;
		$(".container").css("height",height);
		var width=$(".container").width();//
		var length=$(".docList").length;
		for(var i =length;i>0;i--){
			var width_lis=i*231;
			var margin=(width-width_lis)/(i+1);
			if(width_lis < width && margin>10){
				$(".docList").css("margin-left",margin);
				break;
			}else{
				continue;
			}
		}
		var ulWidth=$(".docList_ALL").width();
		var liNum=Math.floor(ulWidth/139);
		var liMargin=(ulWidth-liNum*135)/(liNum);

		$(".docList_li").css({
			"margin":" 10px  " +liMargin/2+"px"
		});
		$(".discuss_right").css("height",(height-10)+"px");
	}


	function showOpear(){
		$(".clickTool,.div-float-right").click(function(e){
			e.stopPropagation();
			$(".docToolBar").addClass("show");
			$(".docToolBar").removeClass("hide");
			var divTop=$(this).offset().top+15;
			var divLeft=$(this).offset().left+15;

			var isNewView = $("input[name='isNewView']").val();
			var containerWidth;
			var containerHeight;
			if(isNewView=="true"){
				containerWidth=$(".container ").width();
				containerHeight=$(".container ").height();
			}else{
				containerWidth=$(".center_div_row2 ").width();
				containerHeight=$(".center_div_row2 ").height()-30;
			}
			if(divLeft+170>containerWidth){
				if(divTop+210>containerHeight){
					$(".docToolBar").css({
						"top":divTop-210,
						"left":divLeft-170
					});
				}else{
					$(".docToolBar").css({
						"top":divTop,
						"left":divLeft-170
					});
				}
			}else{
				if(divTop+210>containerHeight){
					$(".docToolBar").css({
						"top":divTop-210,
						"left":divLeft
					});
				}else{
					$(".docToolBar").css({
						"top":divTop,
						"left":divLeft
					});
				}
			}
		});

		$(document).click(function(e){
			e.stopPropagation();
			$(".docToolBar").addClass("hide");
			$(".docToolBar").removeClass("show");
		});
	}


	function initNewData(){
		var end = start+pageSize;
		var html = appandNewData(start,end);
		$("#newView").append(html);
		setWidth();
	}

	//数据拼接html
	function appandNewData(start,end){
		var res_html = "";
		start = parseInt(start);
		end = parseInt(end);
		<c:forEach items="${allLibVos}" var="vo" varStatus="vo_number">
		var  index = "${vo_number.count}";

		<c:choose>
			<c:when test="${(vo.doclib.type==0 || vo.doclib.type==2 || vo.doclib.type==3) && vo.doclib.domainId != loginAccountId }" >
				<c:set value="(${v3x:getAccount(vo.doclib.domainId).shortName})" var="otherAccountShortName" />
			</c:when>
			<c:otherwise>
				<c:set value="" var="otherAccountShortName" />
			</c:otherwise>
		</c:choose>
		<c:set value="OnMouseUp('${vo.root.docResource.id}','${vo.doclib.createUserId}','${sessionScope['com.seeyon.current_user'].id}','${vo.doclib.id}','${vo.doclib.type}','${vo.doclib.columnEditable}','${vo.root.allAcl}','${vo.root.editAcl}','${vo.root.addAcl}','${vo.root.readOnlyAcl}','${vo.root.browseAcl}','${vo.root.listAcl}','${vo.isOwner}','${vo.root.docResource.frName}','${vo.noShare}','${vo.doclib.isDefault}', '${vo.doclib.searchConditionEditable}', '${vo.doclib.isSearchConditionDefault}','${vo.vForProperties}','${vo.vForShare}')" var="newEvent" />
		if(parseInt(index)>=parseInt(start+1) && parseInt(index)<=parseInt(end)){
			<c:set value="${v3x:_(pageContext, vo.doclib.name)}${otherAccountShortName}" var ="docName"/>
			var li_head = "<li class='docList left'><h2>"+
				"<div title=\"${docName}\"><a style='font-size: 18px' class='font-12px defaulttitlecss'"+
				"href=\"javascript:folderOpenFunHomepage('${vo.root.docResource.id}','${vo.root.docResource.frType}','${vo.root.allAcl}','${vo.root.editAcl}','${vo.root.addAcl}','${vo.root.readOnlyAcl}','${vo.root.browseAcl}','${vo.root.listAcl}','false','${vo.doclib.id}','${vo.doclib.type}','${vo.v}')\">"+
				"${v3x:getLimitLengthString(docName, 15,'...')}</a></h2></div>";
			var div_doc = "<div class='docManager'><div><span><fmt:message key='common.type.label' bundle='${v3xCommonI18N}'/>:</span><span><fmt:message key='${vo.docLibType}'/></span>"+
						  "</div><div title=\"${vo.managerName}\"><span><fmt:message key='doc.jsp.properties.common.lib.admin' bundle='${v3xCommonI18N}'/>:</span><span>${v3x:getLimitLengthString(v3x:_(pageContext, vo.managerName), 15,'...')}</span>"+
						  "</div><div><span><fmt:message key='doc.metadata.def.lastupdate' bundle='${v3xCommonI18N}'/>:</span><span><fmt:formatDate value='${vo.doclib.lastUpdate}'	pattern='${datetimePattern}'/></span></div></div>";
			var  ht = "";
				if(${vo.doclib.type}==1){
					ht = "<div class='docBottom greenBg1' tilte=\"${v3x:_(pageContext, vo.doclib.name)}\"><h2>${v3x:getLimitLengthString(v3x:_(pageContext, vo.doclib.name), 15,'...')}</h2></div></li>";
				}else if(${vo.doclib.type}==2){
					ht = "<div class='docBottom redBg' tilte=\"${v3x:_(pageContext, vo.doclib.name)}\"><h2>${v3x:getLimitLengthString(v3x:_(pageContext, vo.doclib.name), 15,'...')}</h2><span class='clickTool' id=\"_${vo.doclib.id}\" onclick=\"${newEvent}\"></span></div></li>";
				}else if(${vo.doclib.type}==3){
					ht = "<div class='docBottom purpleBg' tilte=\"${v3x:_(pageContext, vo.doclib.name)}\"><h2>${v3x:getLimitLengthString(v3x:_(pageContext, vo.doclib.name), 15,'...')}</h2><span class='clickTool' id=\"_${vo.doclib.id}\" onclick=\"${newEvent}\"></span></div></li>";
				}else if(${vo.doclib.type}==4){
					ht = "<div class='docBottom blueBg' tilte=\"${v3x:_(pageContext, vo.doclib.name)}\"><h2>${v3x:getLimitLengthString(v3x:_(pageContext, vo.doclib.name), 15,'...')}</h2><span class='clickTool' id=\"_${vo.doclib.id}\" onclick=\"${newEvent}\"></span></div></li>";
				}else if(${vo.doclib.type}==5){
					ht = "<div class='docBottom praseBg' tilte=\"${v3x:_(pageContext, vo.doclib.name)}\"><h2>${v3x:getLimitLengthString(v3x:_(pageContext, vo.doclib.name), 15,'...')}</h2><span class='clickTool' id=\"_${vo.doclib.id}\" onclick=\"${newEvent}\"></span></div></li>";
				}else{
					ht = "<div class='docBottom yellowBg' tilte=\"${v3x:_(pageContext, vo.doclib.name)}\"><h2>${v3x:getLimitLengthString(v3x:_(pageContext, vo.doclib.name), 15,'...')}</h2><span class='clickTool' id=\"_${vo.doclib.id}\" onclick=\"${newEvent}\"></span></div></li>";
				}
				res_html += li_head+div_doc+ht;
		}

		</c:forEach>
		start = parseInt(pageSize)+parseInt(start) ;
		$("#startNumber").val(start);
		return res_html;
	}

	//滚鼠加载数据
	var totalheight = 0;
	function mousewheel(){
		totalheight = $(window).height() + $(".discuss_right").scrollTop();
		if ($(".mainDoc").height() <= totalheight+30){
		    start = $("#startNumber").val();
		    var end = parseInt(start)+parseInt(pageSize);
		    var html = appandNewData(start,end);
		    $("#newView").append(html);
		    setWidth();
		    showOpear();
		}
	}

</script>
	<input type="hidden" name="isNewView" value="true">
	<input type="hidden" id="startNumber" value="">
<div class="container overflow" style="height: 100%;">
	<div class="discuss_right left" style="overflow: auto;" onmousewheel="mousewheel();">
		<div class="mainDoc">
			<ul class="overflow" id="newView">
			</ul>
		</div>
	</div>
</div>
<script language="javascript">
setbDiv();
function setbDiv(){
	var bDiv = $(".bDiv").height()-30;
	$(".bDiv").height(bDiv);
}
</script>