<%--
 $Author: muyx $
 $Rev: 1.0 $
 $Date:: 2012-9-12 下午6:44:33#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<ul id="div_ul_table_title" class="border_b green">
    <table class="w100b margin_t_10">
        <tr>
            <td colspan="2" class="align_center"><c:if
                    test="${channelInfo.imageUrl != '' && channelInfo.imageUrl != null}">
                    <a href="${channelInfo.imageLink}" target="_blank"><img src="${channelInfo.imageUrl}"
                        alt="${channelInfo.imageTitle}" border="0"> </a>
                </c:if>&nbsp;<a href="${channelInfo.imageLink}" target="_blank">${channelInfo.imageTitle}</a></td>
        </tr>
        <tr>
            <td><a href="${channelInfo.link}" class="green font_bold" target="_blank">${channelInfo.title}(${count})</a>
            </td>
            <td class="align_right padding_r_10 font_size12"><a href="javascript:void(0)"
                channelId="${categoryChannel.id}" id="tab_subscribe_channelId_${categoryChannel.id}"
                categoryId="${categoryChannel.categoryId }" sid="${categoryChannel.id}"
                channelName="${categoryChannel.name }"> <%--订阅，取消订阅 --%> </a></td>
        </tr>
    </table>
</ul>
<div class="set_search">
    <ul class="search_all_result padding_0 margin_lr_0 margin_t_0">
        <c:forEach items="${channelInfos}" var="item" varStatus="info">
            <li class="padding_10 border_b_dashed">
                <table class="w100b">
                    <tr>
                        <td><a href="javascript:void(0)" class="search_title margin_r_10 padding_b_5"
                            id="href_title_${item.channelItem.id}" sid="${item.channelItem.id}"
                            channelItemId="${item.channelItem.id }" channelId="${item.channelItem.categoryChannelId}"
                            itemLink="${item.channelItem.link }"> <span class="ico16 arrow_2_r"></span>
                                ${item.channelItem.title } </a> <span id="div_img_redflag_${item.channelItem.id }"> <%-- 红旗 --%>
                        </span> <a href="javascript:void(0)" id="href_img_redflag_${item.channelItem.id }" class="font_size12"
                            sid="${item.channelItem.id }" channelId="${item.channelItem.categoryChannelId}"
                            isReadFlag="${item.isReaded}">[${ctp:i18n('rss.button.markasread.label')}] <%-- 标记为已读 --%>
                        </a></td>
                        <td class="align_right padding_r_10 font_size12"><span class="color_gray">${item.distanceTime}</span> <a
                            href="javascript:void(0)" id="href_expand_${item.channelItem.id}"
                            sid="${item.channelItem.id}"> <%-- 展开[折叠] --%> </a></td>
                    </tr>
                </table>
                <div id="p_describse_${item.channelItem.id}" class="margin_t_10">
                    <%-- 内容 --%>
                    ${item.channelItem.describse}
                </div></li>
        </c:forEach>
    </ul>
</div>
<script>
    var _myChannels = eval(${myChannels});
</script>