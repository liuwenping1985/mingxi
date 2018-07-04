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
<%--订阅 --%>
<c:forEach items="${categories}" var="category">
    <ul id="div_ul_table_title" class="border_b green">
        <table class="w100b">
            <tr>
                <td><h3>${category.name}</h3>
                </td>
            </tr>
        </table>
    </ul>
    <c:forEach items="${channels}" var="channel" varStatus="info">
        <c:if test="${channel.categoryId == category.id}">
            <table class="w100b margin_t_10">
                <tr>
                    <td class="font_size12">${channel.name}</td>
                    <td class="align_right padding_r_10 font_size12"><a href="javascript:void(0)"
                        channelId="${channel.id}" id="tab_subscribe_channelId_${channel.id}"
                        categoryId="${channel.categoryId }" sid="${channel.id}" channelName="${channel.name }"> <%--订阅，取消订阅 --%>
                    </a>
                    </td>
                </tr>
            </table>
            <p class="margin_t_10 clearfix font_size12" id="p_describse_${item.channelItem.id}">
                <%-- 描述 --%>
                ${channel.description}
            </p>
            <p class="padding_tb_10 border_b_dashed font_size12" id="p_describse_${item.channelItem.id}">
                <%-- url --%>
                ${channel.url}
            </p>
        </c:if>
    </c:forEach>
</c:forEach>
<script>
    var _myChannels = eval('${myChannels}');
</script>