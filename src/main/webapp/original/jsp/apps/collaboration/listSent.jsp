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
<%@ include file="/WEB-INF/jsp/common/commonColList.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>已发事项</title>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/listSent.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
    	var pTemp = {"nodePolicy":'${newColNodePolicy}'};
    	//全局的一个放置指定跟踪人字符串的信息
        var _paramTemplateIds = "${paramMap.templeteIds}";
        var paramMethod = "${param.method}";  
        //是否安装了表单高级插件
        var isFormAdvanced = "${ctp:hasPlugin('formAdvanced')}";
       //ouyp a6s邮件过滤
       var emailShow = ${v3x:hasPlugin('webmail')};
       var hasBarCode = "${ctp:hasPlugin('barCode')}";
       var hasDoc = "${ctp:hasPlugin('doc')}";
       //是否存在转出数据
       var hasDumpData = "${hasDumpData}";
       var isHaveNewColl = "${isHaveNewColl}";
       var isV5Member = ${CurrentUser.externalType == 0};
    </script>
</head>
<body>
    <div id='layout'>
        <div class="layout_north f0f0f0" id="north">
            <!-- 如果是业务生成器创建的一个列表菜单，则不显示面包屑 -->
            <c:if test="${param.srcFrom ne 'bizconfig' }">
                <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_listSent'"></div>
            </c:if>
            <input type='hidden' id='frombizconfigIds' value="${param.textfield}"/>
            <input type='hidden' id='bisnissMap' value="${param.textfield}"/>
            <div id="toolbars"> </div>  
            <form id="editFlowForm" name="editFlowForm">
            	<input type="hidden" id="processId" name="processId" />
            	<input type="hidden" id="deadline" name="deadline" />
            	<input type="hidden" id="advanceRemind" name="advanceRemind" />
            	<input type="hidden" id="process_desc_by" name="process_desc_by" />
            	<input type="hidden" id="process_xml" name="process_xml" />
            	<input type="hidden" id="process_info" name="process_info" />
            </form>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listSent"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" name='summaryF' width="100%" height="100%" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
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
                    <!-- 全部 -->
                    <input type="radio" value="0" id="radio1" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.all')}</label>
                <label for="radio4" class="margin_r_10 hand">
                    <!-- 指定人 -->
                    <input type="radio" value="0" id="radio4" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.designee')}</label>
            </div>
        </div>
    </div>
    </div>
    <ctp:webBarCode readerId="PDF417Reader" readerCallBack="codeCallback" decodeParamFunction="precodeCallback" decodeType="codeflowurl"/>
</body>
</html>
