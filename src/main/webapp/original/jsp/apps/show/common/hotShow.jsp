<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 最热 --%>
<div class="showlistRdiv hottestList">
    <h3 class="showTitle">${ctp:i18n('show.showbar.side.hot') }</h3>
    <ul class="showPicList">
    	<c:forEach items="${hotList }" var="hot" varStatus="ss">
        <li class="${ss.index == 0 ? 'showPic clearfix':'' } ${ss.index >2 ? 'graySort' : '' } clearfix">
            <a href="${path }/show/show.do?method=showbar&from=hotlist&showbarId=${hot.id}" title="${ctp:toHTMLWithoutSpaceEscapeQuote(hot.showbarName) }">
                <img src="${path }/image.do?method=showImage&id=${hot.coverPicture}&size=custom&w=300&h=100&handler=show" width="300" height="100" />
                <h4>
                	<span class="fr hotshowuser" title="${ctp:toHTMLWithoutSpaceEscapeQuote(ctp:showMemberName(hot.createUserId)) }" >
                		${ctp:toHTMLWithoutSpaceEscapeQuote(ctp:getLimitLengthString(ctp:showMemberName(hot.createUserId),9,"...")) }
                	</span>
                	<span class="hotshownum">
	                	<strong >${ss.index + 1}</strong>
                	</span> 
                	<span title="${ctp:toHTMLWithoutSpaceEscapeQuote(hot.showbarName) }" class="hotshowtitle">${ctp:toHTMLWithoutSpaceEscapeQuote(hot.showbarName) }</span>
                </h4>
                <p><span class="hits_gray" title="${ctp:i18n('show.showbar.shoebarinfo.view') }"><span class="ico16 show_clickNumberGray"></span>${hot.viewNum}</span><span class="liked_gray" title="${ctp:i18n('show.showbar.shoebarinfo.like') }"><span class="ico16 show_likeGray" ></span>${hot.likeNum}</span></p>
            </a>
        </li>
    	</c:forEach>
    </ul>
</div>

<%-- 最新 --%>
<div class="showlistRdiv newestList">
    <h3 class="showTitle">${ctp:i18n('show.showbar.side.new') }</h3>
    <ul class="showPicList">
    	<c:forEach items="${newList }" var="hot" varStatus="ss">
        <li class="${ss.index == 0 ? 'showPic clearfix' : '' } ${ss.index >2 ? 'graySort' : '' }">
            <a href="${path }/show/show.do?method=showbar&from=hotlist&showbarId=${hot.id}" title="${ctp:toHTMLWithoutSpaceEscapeQuote(hot.showbarName) }">
                <img src="${path }/image.do?method=showImage&id=${hot.coverPicture}&size=custom&w=300&h=100&handler=show" width="300" height="100" />
                  <h4>
                	<span class="fr hotshowuser" title="${ctp:toHTMLWithoutSpaceEscapeQuote(ctp:showMemberName(hot.createUserId)) }" >
                		${ctp:toHTMLWithoutSpaceEscapeQuote(ctp:getLimitLengthString(ctp:showMemberName(hot.createUserId),9,"...")) }
                	</span>
                	<span class="hotshownum">
	                	<strong >${ss.index + 1}</strong>
                	</span>             
                	<span title="${ctp:toHTMLWithoutSpaceEscapeQuote(hot.showbarName) }" class="hotshowtitle">${ctp:toHTMLWithoutSpaceEscapeQuote(hot.showbarName) }</span>
                </h4>
                <p><span class="hits_gray" title="${ctp:i18n('show.showbar.shoebarinfo.view') }"><span class="ico16 show_clickNumberGray"></span>${hot.viewNum}</span><span class="liked_gray" title="${ctp:i18n('show.showbar.shoebarinfo.like') }"><span class="ico16 show_likeGray"></span>${hot.likeNum}</span></p>
            </a>
        </li>
    	</c:forEach>
    </ul>
</div>