<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="/apps_res/info/js/common/jquery-1.8.3.min.js${ctp:resSuffix()}"></script>
<link rel="stylesheet" href="${path}/apps_res/info/css/gov_style/${skinPathKey}${ctp:resSuffix()}" />
<script type="text/javascript">
        //JavaScript Document

        var listType = '${listType}';

        $(document).ready(function() {
	        $(".info_box_title").click(function(){
	          if($(this).next(".info_box_display").css("display")=="none"){
	          	 $(this).next(".info_box_display").show();
	          	$(this).find("span").eq(2).removeClass("info_box_title_hook_2");
	          }else{
	          	$(this).next(".info_box_display").hide();
	          	$(this).find("span").eq(2).addClass("info_box_title_hook_2");
	          }
	        });
            initInfoLeftLocation();
            initInfoBoxDisplay();
            initUrl();
        });

        function initInfoBoxDisplay() {
            $(".info_left_nav").find(".info_box_title").each(function() {
            	if($(this).parents(".info_box")) {
            		if($(this).parents(".info_box").find(".info_content_active").size()==0) {
                        $(this).attr("utype", "none");
                        $(this).parent().find(".info_box_display").attr("style", "display:none");
                    } else {
                        $(this).attr("utype", "block");
                        $(this).parent().find(".info_box_display").attr("style", "display:block");
                    }	
            	}
            });
        }

        function initInfoLeftLocation(listType2) {
            $(".info_left_nav a").each(function(obj) {
                var listId = $(this).attr("listType");
                if(listType2) {
                    listType = listType2;
                }
                if(listId == listType || $(this).attr("subListType") == listType) {
                	$(".info_left_nav a").removeClass("info_content_active");
                    $(this).addClass("info_content_active");
                }
                $(this).click(function() {
                	$(".info_left_nav a").removeClass("info_content_active");
                    $(this).addClass("info_content_active");
                });
            });
            $("div[resCode='F18_infoDatabase']").find(".info_box_title").click(function() {
            	$(".info_left_nav a").removeClass("info_content_active");
            });
        }
        function leftClickEvent(listType) {
            $(".info_left_nav").find("a[listType='"+listType+"']").trigger("click");
        }
        function initUrl() {
        	
        	$("div[resCode='F18_infoReport']").find("a[listType='listCreateInfo']").eq(0).click(function() {//新建列表
                var url = "infocreate.do?method=createInfo&action=create&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=infoReport");
        	
            $("div[resCode='F18_infoReport']").find("a[listType='listInfoDraft']").eq(0).click(function() {//待发列表
                var url = "infoList.do?method=listInfoDraft&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=infoReport");
            $("div[resCode='F18_infoReport']").find("a[listType='listInfoReported']").eq(0).click(function() {//已发列表
                var url = "infoList.do?method=listInfoSend&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=infoReport");
            $("div[resCode='F18_infoAudit']").find("a").eq(0).click(function() {//待审核列表
                var url = "infoList.do?method=listInfoPending&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=infoAudit");
            $("div[resCode='F18_infoAudit']").find("a").eq(1).click(function() {//已审核列表
                var url = "infoList.do?method=listInfoDone&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=infoAudit");
            $("div[resCode='F18_magazine']").find("a").eq(0).click(function() {//期刊管理
                var url = "magazinelist.do?method=listMagazineManager&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=magazineAudit");
            $("span[resCode='F18_magazineAudit']").find("a").eq(0).click(function() {//待审核期刊
                var url = "magazinelist.do?method=listMagazineAuditPending&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=magazineAudit");
            $("span[resCode='F18_magazineAudit']").find("a").eq(1).click(function() {//已审核期刊
                var url = "magazinelist.do?method=listMagazineAuditDone&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=magazineAudit");
            $("span[resCode='F18_magazinePublish']").find("a").eq(0).click(function() {//待发布期刊
                var url = "magazinelist.do?method=listMagazinePublishPending&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=magazineAudit");
            $("span[resCode='F18_magazinePublish']").find("a").eq(1).click(function() {//已发布期刊
                var url = "magazinelist.do?method=listMagazinePublishDone&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=magazineAudit");
            $("span[resCode='F18_magazineCheck']").find("a").eq(0).click(function() {//信息积分
                var url = "publishscore.do?method=listInfoPublishScoreDetail&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=magazineAudit");

            $("div[resCode='F18_infoDatabase']").find("div").eq(0).click(function() {//应用设置
                var url = "infomain.do?method=dataBaseIndex&listType=listTemplate";
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=infoDataBase");

            $("span[resCode='F18_infoStat']").find("a").eq(0).click(function() {//信息统计
                var url = "infoStat.do?method=listInfoStat&listType="+$(this).attr("listType");
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=infoQueryAndStat");

            $("span[resCode='F18_infoQuery']").find("a").eq(0).click(function() {//信息查询
                var url = "infoSearch.do?method=infoQuery";
                changeCurrentLocation(this);
                $("#tab_iframe").attr("src", url);
            }).attr("_selfUrl", "/seeyon/info/infomain.do?method=infoQueryAndStat");

        }
        
        /**
         * 修改当前定位信息
         */
        function changeCurrentLocation(obj) {
        	if ($(obj).attr("listType") == "infoDatabase") {// 应用设置
        		// /titleName = $(obj).children("span:first-child").text();
        		// url = $(obj).attr("_selfUrl");
        	} else {
        		var titleName = $(obj).parent().parent().prev().find("span[class='info_box_title_font']").eq(0).text();
        		var url = $(obj).parent().children("a:first-child").attr("_selfUrl");
        		var pWin = window.parent;
        		var nowLocationEl = pWin.document.getElementById("nowLocation");
        		var lEl = nowLocationEl.lastChild.lastChild;
        		lEl.innerText = titleName;
        		lEl.onclick = function() {
        			pWin.showMenu(url);
        		};
        	}
        }
        
    </script>
</head>
<body>
<div class="info_left_nav">

	<c:if test="${hasInfoReportRole } ">
		<c:if test="${ctp:hasResourceCode('F18_infoReport') == true}">
		    <div class="info_box resCode">
		        <div class="info_box_title">
		            <span class="info_report"></span>
		            <span class="info_box_title_font">${ctp:i18n("infosend.label.infoReport")}</span>
		            <span class="info_box_title_hook"></span>
		        </div>
		        <div class="info_box_display">
		            <c:if test="${hasInfoCreate}">
						<span class="resCode">
		               	    <a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listCreateInfo">
			                    <span>${ctp:i18n("infosend.draft.newInfo")}</span>
			                </a>
		            	</span>            
		            </c:if>
			        <span class="resCode">
			            <a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listInfoDraft" parentListType="">
			                <span>${ctp:i18n("infosend.label.reportPending")}</span>
			            </a>
		            </span>
		            <span class="resCode">
			            <a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listInfoReported" parentListType="">
			                <span>${ctp:i18n("infosend.label.reportSent")}</span>
			            </a>
		            </span>
		        </div>
		    </div>
	    </c:if>
    </c:if>

	<c:if test="${hasInfoAuditRole }">
		<c:if test="${ctp:hasResourceCode('F18_infoAudit') == true}">
		    <div class="info_box resCode">
		        <div class="info_box_title">
		            <span class="info_audit"></span>
		            <span class="info_box_title_font">${ctp:i18n("infosend.label.audit")}</span>
		            <span class="info_box_title_hook"></span>
		        </div>
		        <div class="info_box_display">
		        <span class="resCode">
		            <a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listInfoPending">
		                <span>${ctp:i18n("infosend.label.waitAudit")}</span>
		            </a>
		            </span>
		            <span class="resCode">
		            <a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listInfoDone">
		                <span>${ctp:i18n("infosend.label.Audited")}</span>
		            </a>
		            </span>
		        </div>
		    </div>
	    </c:if>
    </c:if>
	
	<c:if test="${ctp:hasResourceCode('F18_magazine') == true}">
    <div class="info_box resCode">
        <div class="info_box_title">
            <span class="info_journal"></span>
            <span class="info_box_title_font">${ctp:i18n("infosend.label.magazine")}</span>
            <span class="info_box_title_hook"></span>
        </div>
        <div class="info_box_display">
			<c:if test="${hasMagazineManagerRole  and ctp:hasResourceCode('F18_magazineManager') == true}">
         	<span class="resCode">
	        	<a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listMagazineManager">
                   <span>${ctp:i18n("infosend.label.magazineManager")}</span>
                </a>
            </span>
			</c:if>

			<c:if test="${hasMagazineAuditRole }">
				<c:if test="${ctp:hasResourceCode('F18_magazineAudit') == true}">
		        	<span class="resCode">
			        	<a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listMagazineAuditPending">
		                   <span>${ctp:i18n("infosend.label.magazineWaitAudit")}</span>
		                </a>
		            </span>
	            </c:if>
	            <c:if test="${ctp:hasResourceCode('F18_magazineAudit') == true}">
		            <span class="resCode">
			            <a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listMagazineAuditDone">
		                   <span>${ctp:i18n("infosend.label.magazineAudited")}</span>
		                </a>
		            </span>
	            </c:if>
			</c:if>
			
			<c:if test="${hasMagazinePublishRole and ctp:hasResourceCode('F18_magazinePublish') == true}">
	            <span class="resCode" >
					<a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listMagazinePublishPending">
	                    <span>${ctp:i18n("infosend.label.magazineWaitPublish")}</span>
	                </a>
	        	</span>
	
	        	<span class="resCode" >
					<a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listMagazinePublishDone">
	                   <span>${ctp:i18n("infosend.label.magazinePublished")}</span>
	                </a>
	            </span>
            </c:if>


			<c:if test="${hasInfoCheckRole and ctp:hasResourceCode('F18_magazineCheck') == true}">
	            <span class="resCode" >
		            <a href="javascript:void(0);" target="_infoIndexTempFrame" listType="listInfoPublishScoreDetail">
	                    <span>${ctp:i18n("infosend.label.infoScore")}</span>
	                </a>
	            </span>
            </c:if>
        </div>
    </div>
    </c:if>

	<c:if test="${hasInfoQueryAndStatRole and ctp:hasResourceCode('F18_infoQueryAndStat') == true}">
	    <div class="info_box resCode" >
	        <div class="info_box_title">
	            <span class="info_inquiry"></span>
	            <span class="info_box_title_font">${ctp:i18n("infosend.label.searchAndStat")}</span>
	            <span class="info_box_title_hook"></span>
	        </div>
	        <div class="info_box_display">
	        	<c:if test="${hasInfoQueryRole and ctp:hasResourceCode('F18_infoQuery') == true}">
		        	<span class="resCode">
			        	<a href="javascript:void(0);" target="_infoIndexTempFrame" listType="infoQuery">
		                    <span>${ctp:i18n("infosend.label.infoQuery")}</span>
		                </a>
		           	</span>
	           	</c:if>
	           	
	           	<c:if test="${hasInfoStatRole and ctp:hasResourceCode('F18_infoStat') == true}">
		            <span class="resCode">
			            <a href="javascript:void(0);" target="_infoIndexTempFrame" listType="infoStat">
		                    <span>${ctp:i18n("infosend.label.statInfo")}</span>
		                </a>
		            </span>
	            </c:if>
	        </div>
	    </div>
    </c:if>
    
    <%-- 应用设置 --%>
    <c:if test="${isInfoAdmin and ctp:hasResourceCode('F18_infoDatabase') == true}">
	    <div class="info_box resCode" >
	    	<div class="info_box_title">
	            <span class="info_apply"></span>
	            <span class="info_box_title_font">${ctp:i18n("infosend.label.settings")}</span>
	            <span class="info_box_title_hook info_box_title_no_hook"></span>
	        </div>
	    </div>
	    <!-- 
	   	<span class="info_box resCode" resCode="F18_infoDatabase">
	        <div class="info_box_title">
	        	<a href="javascript:;" listType="infoDatabase">
	            	<span class="info_box_title_font">${ctp:i18n("infosend.label.settings")}</span>
	 		   </a>
	        </div>
	     </span> -->
	</c:if>
</div>
<!-- 用于本页面的a标签的连接，新建期刊和消息上报时两次提示离开页面 -->
<iframe src="" id="_infoIndexTempFrame" name="_infoIndexTempFrame" style="display: none;"></iframe>
</body>
</html>
