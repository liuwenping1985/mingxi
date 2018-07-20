<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>办公用品-申请编辑</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/stock/stockUse.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/stock/stockApplyEdit.js"></script>
<style>
.stadic_footer_height{
  height:30px;
  _height:50px;
}
</style>
</head>
<body class="h100b over_hidden">
<c:set var="isAddOrModify" value="${param.operate eq 'add' or  param.operate eq 'modify'}"></c:set>
<div id='layout' class="comp" comp="type:'layout'">
  <div class="layout_north" layout="height:${isAddOrModify ? 100:70 },border:false,sprit:false">
    <div id="stockDiv" class="form_area common_center w80b">
      <table id="stockApplyInfo" class="w100b margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout:fixed;">
        <!-- 申请 -->
        <tr>
          <th width="60" noWrap="nowrap" align="right"><label class="margin_r_5 font_size12"  for="text">${ctp:i18n('office.stock.use.user.js')}:</label></th>
          <td align="left">
           <div id="userDiv" class="common_txtbox_wrap">
              <input id="applyUser" class="comp font_size12 validate w100b" validate="name:'${ctp:i18n('office.stock.use.user.js')}',notNull:true" comp="type:'selectPeople',panels:'Department,Team,Post,Level',selectType:'Member',maxSize:'1'">
            </div>
          </td>
          <td></td> 
          <th width="60" noWrap="nowrap" align="right"><label class="margin_r_5 font_size12"  for="text">${ctp:i18n('office.stock.use.applydate.js')}:</label></th>
          <td align="left">
           <div class="common_txtbox_wrap clearfix" style="height: 20px;">
             <input id="applyDate" class="comp font_size12 validate w100b" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" validate="name:'${ctp:i18n('office.stock.use.applydate.js')}',notNull:true" readonly>
          </div>
          </td>
        </tr>
        
        <tr>
          <th noWrap="nowrap" align="right"><label class="margin_r_5 font_size12"  for="text">${ctp:i18n('office.stock.use.dep.js')}:</label></th>
          <td align="left">
            <div id="depDiv" class="common_txtbox_wrap">
              <input id="applyDept" class="comp font_size12 validate w100b"  validate="name:'${ctp:i18n('office.stock.use.dep.js')}',notNull:true" comp="type:'selectPeople', panels:'Department',selectType:'Department',maxSize:'1'">
             </div>
          </td>
        </tr>
      </table>
     </div>
     <c:if test="${isAddOrModify}">
      <div class="border_t"></div>
      <a id="selectStockHref" class="common_button common_button_emphasize margin_t_5 margin_b_5 margin_l_5" href="javascript:void(0);">${ctp:i18n('office.stock.select.js')}</a>
     </c:if>
  </div>
  <div class="layout_center over_hidden" layout="border:false">
    <table id="stockApplyEditTab" class="flexme3" style="display: none;"></table>
  </div>
 <div class="layout_south" layout="height:${height},border:false,sprit:false">
 <div id="stockUseTab" class="form_area">
   <table class="w90b margin_tb_5 font_size12" border="0" cellSpacing="0" cellPadding="" align="center" style="table-layout:fixed;">
      <tr id="countTr">
        <td width="80"></td>
        <th colspan="6" noWrap="nowrap" align="right"><label for="text" class="margin_r_5">${ctp:i18n('office.stock.bill.hj.js')}:</label></th>
        <td align="left" class="clearfix">
          <div id="depDiv" style="height: 20px;margin-top: 1px;" class="common_txtbox_wrap clearfix">
            <div id="applyTotalDiv" style="height: 20px;" class="right color_gray2"></div>
          </div>
        </td>
        <td nowrap="nowrap" width="20" align="left"><span class="margin_l_5">${ctp:i18n('office.auto.element.js')}</span></td>
      </tr>
      
      <tr>
        <td noWrap="nowrap" align="right" valign="top">
          <label for="text" class="margin_r_5">${ctp:i18n('office.stock.use.applydesc.js')}:</label>
        </td>
        <td id="applyDescTR" colspan="8" align="left">
          <div class="common_txtbox clearfix">
           <input id="id" type="hidden">
           <c:if test="${param.operate eq 'modify' or param.operate eq 'add'}">
            	<textarea id="applyDesc" style="width: 98%; height: 45px;" class="validate padding_5 margin_r_5" validate="name:'${ctp:i18n('office.stock.use.applydesc.js')}',type:'string',maxLength:600"></textarea>
           </c:if>
           <c:if test="${param.operate ne 'modify' and param.operate ne 'add'}">
            	<div id="applyDesc" style="width: 98%; min-height: 45px;_height:45px;" class="common_txtbox color_gray border_all padding_5 margin_r_5">&nbsp;</div>
           </c:if>
          </div>
        </td>
      </tr>
      
      <c:if test="${not empty workflowRule and (param.operate eq 'add' or param.operate eq 'modify')}">
        <tr style="height:5px;"><td>&nbsp;</td></tr>
        <tr>
          <td align="right" valign="top"><labelclass="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.useDesc.js')}:</label></td>
          <td colspan="3" align="left">
            <div class="green">${ctp:toHTML(workflowRule)}</div>
          </td>
        </tr>
      </c:if>
      
      <c:if test="${param.operate ne 'modify'}">
        <tr style="height:5px;"><td>&nbsp;</td></tr>
        <tr id="auditContentTR">
          <td noWrap="nowrap" align="right" valign="top">
            <label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.auditContent.js')}:</label>
          </td>
          <td colspan="8" align="left">
            <div class="common_txtbox clearfix">
              <div id="auditContent" style="width: 98%; min-height: 45px;_height:45px;" class="common_txtbox color_gray border_all padding_5 margin_r_5">&nbsp;</div>
            </div>
          </td>
        </tr>
        <tr style="height:5px;"><td>&nbsp;</td></tr>
        <tr id="grantOpinionTR">
          <td noWrap="nowrap" align="right" valign="top">
            <label class="margin_r_5"  for="text">${ctp:i18n('office.stock.grant.sure.js')}:</label>
          </td>
          <td colspan="8" align="left">
            <div class="common_txtbox clearfix">
              <c:if test="${param.operate eq 'grant'}">
                <textarea id="grantOpinion" style="width: 98%; height: 45px;" class="validate padding_5 margin_r_5" validate="name:'${ctp:i18n('office.stock.grant.sure.js')}',type:'string',maxLength:600"></textarea>
              </c:if>
              <c:if test="${param.operate ne 'grant'}">
                <div id="grantOpinion" style="width: 98%; min-height: 45px;_height:45px;" class="common_txtbox color_gray border_all padding_5 margin_r_5">&nbsp;</div>
              </c:if>
            </div>
          </td>
        </tr>
      </c:if>
    </table>
    <div style="min-height: 50px;_min-height: 50px;" class="border">&nbsp;</div>
   </div>
   <!-- 工作流相关数据 -->
   <div id="workFlowDiv" class="display_none">
    <input type="hidden" id="readyObjectJSON" name="readyObjectJSON">
    <input type="hidden" id="workflow_newflow_input" name="workflow_newflow_input"/>
    <input type="hidden" id="workflow_node_peoples_input" name="workflow_node_peoples_input"/>
    <input type="hidden" id="workflow_node_condition_input" name="workflow_node_condition_input"/>
    <input type="hidden" id="process_rulecontent" name="process_rulecontent"/>
    <input type="hidden" id="process_message_data" name="process_message_data">
  </div>
 </div>
 <c:if test="${param.operate eq 'add' or param.operate eq 'modify' or (param.operate eq 'grant' and state eq 5)}">
   <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_10 align_right bg_color_black" style="z-index: 2;">
      <c:if test="${param.operate eq 'add' or param.operate eq 'modify'}">
        <!--用品申请-->
        <a id="btnok" onclick="fnOK('apply');" class="common_button common_button_emphasize" href="javascript:void(0);">${ctp:i18n('office.submit.js')}</a> 
        <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('office.auto.cancel.js')}</a>
      </c:if>
      <c:if test="${param.operate eq 'grant' and state eq 5}">
        <!--用品发放-->
        <a id="btnok" onclick="fnOK('grant');" class="common_button common_button_emphasize" href="javascript:void(0);">${ctp:i18n('office.stock.grant.title.js')}</a> 
        <a id="btncancel" onclick="fnNotGrant('notGrant');" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0);">${ctp:i18n('office.stock.not.agree.title.js')}</a>
      </c:if>
   </div>
 </c:if>
</div>  
</body>
</html>