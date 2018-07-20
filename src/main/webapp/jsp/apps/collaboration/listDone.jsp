<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>已办事项</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager"></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}" />'></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/listDone.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
    
        var _paramTemplateIds = "${paramMap.templeteIds}";
        
        var paramMethod = "${param.method}"; 
      	//ouyp a6s邮件过滤
		var emailNotShow = ${v3x:getSysFlag('email_notShow')};
        //取回
    </script>
</head>
<body>
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <!-- 如果是业务生成器创建的一个列表菜单，则不显示面包屑 -->
            <c:if test="${param.srcFrom ne 'bizconfig' }">
                <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_listDone'"></div>
            </c:if>
            <input type='hidden' id='frombizconfigIds' value="${param.textfield}"/>
            <input type='hidden' id='bisnissMap' value="${param.textfield}"/>
              <table width="100%" border="0" cellpadding="0">
            	<tr>
            		<td><div id="toolbars"></div></td>
            		<td width="100" align="right" valign="center" class="bg_color_gray">
            		     <a id="combinedQuery"  class="font_size14" onclick="openQueryViews('listDone');" >${ctp:i18n("collaboration.advanced.lable") }</a>
            		</td>
            	</tr>
             </table>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listDone"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary"  width="100%" height="100%" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
        </div>
         <input type="hidden" id="zdgzry" name="zdgzry" />
         <div id="htmlID" class="hidden">
        <div class="padding_tb_10 padding_l_10">
            <!-- 跟踪 -->
            <span class="valign_m">${ctp:i18n('collaboration.forward.page.label4')}:</span>
            <select id="gz" class="valign_m">
                <option value="1">${ctp:i18n('message.yes.js')}</option>
                <option value="0">${ctp:i18n('message.no.js')}</option>
            </select>
            <div id="gz_ren" class="common_radio_box clearfix margin_t_10">
                <label for="radio1" class="margin_r_10 hand">
                    <input type="radio" value="0" id="radio1" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.all')}</label><!-- 全部 -->
                <label for="radio4" class="margin_r_10 hand">
                    <!-- 指定人 -->
                    <input type="radio" value="0" id="radio4" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.designee')}</label>
            </div>
        </div>
    </div>
    </div>
</body>
</html>
