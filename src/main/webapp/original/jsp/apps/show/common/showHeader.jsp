<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="header" id="header">
  <div class="headerIn">
   	<h1 class="fl logo"><a href="${path}/show/show.do?method=showIndex"><img src="${path}/apps_res/show/images/common/logo.png" width="173" height="33" /></a></h1>
    <ul class="header_right">
    <c:if test="${isSettingShowbar == true}">
    	<li class="adminSetting">
    		<a href="javascript:void(0);">${ctp:i18n('show.showauth.adminsetting')}</a>
    	</li>
    </c:if>
    
    <c:if test="${isCreateShowbar == true}">
    	<li class="creatShow">
    		<a href="${path}/show/show.do?method=showbarEdit">${ctp:i18n('show.showedit.create.title')}</a>
    		<%-- <div class="more_new"> ${ctp:i18n("show.showbar.showpost.new") }
    			<span class="reply_item1"></span>
    			<span class="reply_item2"></span>
				<a class="head_new_post newshowpost" href="javascript:void(0)">${ctp:i18n("show.showbar.showpost.newpost") }</a><br>
				<a  href="${path}/show/show.do?method=showbarEdit">${ctp:i18n('show.showedit.create.title')}</a>
   			</div>--%>
    	</li>
    </c:if>
    	
    	<li class="myShow"><span class="userpic"><img src="${ctp:avatarImageUrl(ctp:currentUser().id) }" /></span><a href="${path}/show/show.do?method=myShow">${ctp:i18n('show.showIndex.showbar.header.myShowbar')}</a></li>
    	
    </ul>
    
    <c:choose>
   	<c:when test="${isSettingShowbar == true}">
   		<%-- 如果按钮过多，需要用另一个样式以减小搜索框宽度 --%>
    	<c:set var="searchBoxin" value="adminsearchBoxin"/>
   	</c:when>
   	<c:otherwise>
     	<c:set var="searchBoxin" value="searchBoxin"/>
   	</c:otherwise>
	</c:choose>
	
	<div class="searchBox">
     	<div class="${searchBoxin}"><input id="search_input" name="search_input" type="text" placeholder="${ctp:i18n('show.showIndex.showbar.header.search')}" class="searchInput" value="${ctp:toHTML(param.searchCondtion)}"/><input type="button" class="searchBtn hand" value="  " id="search_btn" /></div>
    </div>
    </div>
</div>
<%-- 新建随意秀 --%>
<div  class="hand anyshow-area head_new_post hidden" title="${ctp:i18n("show.showbar.showpost.newpost") }">
	<div class="add-ico">
		<img alt="${ctp:i18n("show.showbar.showpost.newpost") }" src="${path }/apps_res/show/images/common/add.png">
	</div>
	<div class="sep-line"></div>
	<div class="add-text add-<%=AppContext.getLocale() %>-text">${ctp:i18n("show.showbar.showpost.newpost") }</div>
</div>

<%-- 管理员权限设置页面 --%>
<div id="adminSettingDialog" style="display:none;">
	<h4>${ctp:i18n("show.showauth.div.title")}</h4>
	<ul class="radio_group">
		<li scope="0"><strong><span class="radio_span radio_checked"></span>${ctp:i18n('show.showedit.placeholder.allpeople')}</strong>(${ctp:i18n('show.showedit.placeholder.allpeople1')})</li>
		<li scope="1"><strong><span class="radio_span radio_default"></span>${ctp:i18n('show.showedit.placeholder.allpeople')}</strong>(${ctp:i18n('show.showedit.placeholder.allpeople2')}))</li>
		<li scope="2"><strong><span class="radio_span radio_default"></span>${ctp:i18n('show.showauth.scope.part')}</strong></li>
		<div class="doSelectedPeople">
			<textarea class="doSelectedPeopleTextarea" name="" cols="" rows="" placeholder="${ctp:i18n('show.showedit.placeholder.clickpeople')}" title="" style="border-color: rgb(204, 204, 204);"></textarea>
		</div>
	</ul>
</div>