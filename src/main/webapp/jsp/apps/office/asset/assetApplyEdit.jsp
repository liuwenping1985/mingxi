<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetApplyEdit.pbgsbsqbj.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetUse.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetPrompt.js"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetApplyEdit.js"></script>
<c:set var="isShowBtn" value="${param.operate eq 'add' or param.operate eq 'modify' or param.operate eq 'dLend' or ((param.operate eq 'lend' and state eq 5 )or (param.operate eq 'remind' and (state eq 10 or state eq 15)))}"/>
<style>
.stadic_body_top_bottom{
  top: 0px;
  bottom: ${isShowBtn?'50':'15'}px;
}
.stadic_footer_height{
  height:${isShowBtn?'35':'0'}px;
  _height:${isShowBtn?'65':'0'}px;
}
</style>
</head>
<body class="h100b over_hidden">
<div class="stadic_layout">
  <div class="stadic_body_top_bottom" style="overflow: auto;height:${(param.print eq 'true' || param.isOpenWin eq 'true') ? '560px' :(empty param.operate)?'510px':'460px'};" >
   <div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_center" layout="border:false">
      <div id="assetUseTab" class="form_area common_center w80b">
        <table id="assetApplyInfo" class="w100b margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout:fixed;">
          <tr>
            <th width="60" noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text" class="margin_r_5">${ctp:i18n('office.asset.apply.applyUser.js')}:</label></th>
            <td align="left">
             <div id="userDiv" class="common_txtbox_wrap">
                <input id="id" type="hidden">
                <input id="assetInfoId" type="hidden">
                <input id="applyUser" class="comp font_size12 validate w100b" validate="name:'${ctp:i18n('office.asset.apply.applyUser.js')}',notNull:true" comp="type:'selectPeople',panels:'Department,Team,Post,Level',selectType:'Member',maxSize:'1',callback:fnUserCallBack">
            </td>
            <th noWrap="nowrap" width="100" align="right"><span class="color_red">*</span><label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.applyDept.js')}:</label></th>
            <td align="left">
              <div id="depDiv" class="common_txtbox_wrap">
                <input id="applyDept" class="comp font_size12 validate"  validate="name:'${ctp:i18n('office.asset.apply.applyDept.js')}',notNull:true" comp="type:'selectPeople', panels:'Department',selectType:'Department',maxSize:'1'">
               </div>
            </td>
          </tr>
          
          <tr>
            <th  noWrap="nowrap" align="right"><span class="color_red">*</span><label  class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.useStartTime.js')}:</label></th>
            <td colspan="3">
              <table border="0" class="w100b" cellSpacing="0" cellPadding="0" style="table-layout:fixed;">
                <tr>
                  <td align="left">
                    <div class="common_txtbox_wrap left clearfix w90b">
                     <input id="useStartTime" class="comp font_size12 validate" value="${now}" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" validate="name:'${ctp:i18n('office.asset.apply.startTime.js')}',notNull:true" readonly>
                    </div>
                  </td>
                  <td width="22" align="left">
                    <span class="left">${ctp:i18n('office.asset.apply.to.js')}</span>
                  </td>
                  <td align="left">
                    <div id="useEndTimeDiv" class="common_txtbox_wrap clearfix w90b left">
                      <input id="useEndTime" class="comp validate font_size12" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" validate="name:'${ctp:i18n('office.asset.apply.endTime.js')}',notNull:true" readonly>
                    </div>
                  </td>
                  <td width="60" align="left">
                    <div class="common_checkbox_box margin_tb_5 clearfix">
                      <label class="hand margin_l_5" for="isOften">
                        <input id="isOften" onclick="fnIsOften(this);" class="radio_com" value="1" type="checkbox">${ctp:i18n('office.asset.apply.isOften.js')}</label>
                    </div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <tr>
            <th noWrap="nowrap" align="right"><span class="color_red">*</span><label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.assetNum.js')}:</label></th>
            <td><div class="common_txtbox_wrap ">
              <input id="assetNum" class="validate font_size12 w100b" onclick="fnSelectAsset();" maxlength="80" type="text" validate="type:'string',notNull:true,name:'${ctp:i18n('office.asset.apply.assetNum.js')}'" readonly="readonly">
              </div>
            </td>
            <th noWrap="nowrap" align="right"><label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.assetTypeName.js')}:</label></th>
            <td>
              <div class="common_txtbox_wrap">
                <input id="assetTypeName" class="font_size12" type="text" disabled="disabled">
              </div>
            </td>
          </tr>
          
          <tr>
            <th noWrap="nowrap" align="right"><label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.assetName.js')}:</label></th>
            <td>
              <div class="common_txtbox_wrap ">
              	<input id="assetName" class="font_size12 w100b" maxlength="80" type="text" disabled="disabled">
              </div>
            </td>
            <th noWrap="nowrap" align="right"><label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.assetBrand.js')}:</label></th>
            <td>
            	<div class="common_txtbox_wrap">
            	  <input id="assetBrand" class="font_size12" type="text" disabled="disabled">
              	</div>
            </td>
          </tr>
          
          <tr>
            <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.assetModel.js')}:</label></th>
            <td>
             <div class="common_txtbox_wrap ">
                <input id="assetModel" class="font_size12 w100b" type="text" disabled="disabled">
              </div>
            </td>
          </tr>
          
          <tr>
            <td noWrap="nowrap" align="right" valign="top">
              <label class="margin_r_5 margin_t_5"  for="text">${ctp:i18n('office.asset.apply.assetMemo.js')}:</label>
            </td>
            <td colspan="3" align="left">
                <div id="assetDesc" style="min-height:40px;" class="common_txtbox color_gray clearfix border_all padding_5 margin_tb_5"></div>
            </td>
          </tr>
          
          <tr>
            <th noWrap="nowrap" align="right"><label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.currentCount.js')}:</label></th>
            <td><div class="common_txtbox_wrap ">
              <input id="currentCount" class="font_size12 w100b"  disabled="disabled" type="text">
              </div>
            </td>
            <th noWrap="nowrap" align="right"><label class="margin_r_5 applyAmountClass"  for="text">${ctp:i18n('office.asset.apply.applyAmount.js')}:</label></th>
            <td><div class="common_txtbox_wrap applyAmountClass">
                  <input id="applyAmount" class="validate font_size12" value="1" onkeyup="fnAmountChange();" type="text" maxlength="9" validate="type:'number',notNull:true,name:'',regExp:'^[1-9][0-9]{0,8}$',errorMsg:'${ctp:i18n('office.asset.apply.applyAmount.js')}必须大于0！'">
                </div>
            </td>
          </tr>
          
          <tr id="applyDescTR">
            <td noWrap="nowrap" align="right" valign="top" class="font_size12">
              <span class="color_red">*</span><label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.applyDesc.js')}:</label>
            </td>
            <td colspan="3" align="left">
             <c:if test="${(param.operate eq 'add') or (param.operate eq 'modify') or (param.operate eq 'dLend')}">
                <div class="common_txtbox  clearfix">
                  <textarea id="applyDesc" style="width: 98%; height: 45px;" class="validate font_size12 padding_5 margin_r_5 margin_t_5" validate="type:'string',notNull:true,maxLength:600,name:'${ctp:i18n('office.asset.apply.applyDesc.js')}'"></textarea>
                </div>
              </c:if>
              <c:if test="${(param.operate ne 'add') and (param.operate ne 'modify') and (param.operate ne 'dLend')}">
                <div id="applyDescToHtml" style="min-height: 40px;" class="common_txtbox bg_color clearfix border_all padding_5 font_size12">
                </div>
              </c:if>
            </td>
          </tr>
          <tr style="height:5px;"><td>&nbsp;</td></tr>
          <tr id="auditContentTR">
            <td noWrap="nowrap" align="right" valign="top" class="font_size12">
              <label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.auditContent.js')}:</label>
            </td>
            <td colspan="3" align="left">
              <div id="auditContent" style="min-height:40px;" class="common_txtbox bg_color_white clearfix border_all padding_5 font_size12">
              </div>
            </td>
          </tr>
          <tr style="height:5px;"><td>&nbsp;</td></tr>
          <c:if test="${not empty workflowRule and (param.operate eq 'add' or param.operate eq 'modify')}">
            <tr>
              <td align="right" valign="top"><label class="margin_r_5"  for="text">${ctp:i18n('office.asset.apply.useDesc.js')}:</label></td>
              <td colspan="3" align="left">
                <div class="green">${ctp:toHTML(workflowRule)}</div>
              </td>
            </tr>
            <tr style="height:5px;"><td>&nbsp;</td></tr>
          </c:if>
        </table>
       </div>
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
    <c:if test="${(state eq 10 or state eq 15 or state eq 20 or state eq 30) 
    or (param.operate eq 'lend') or (param.operate eq 'remind') or (param.operate eq 'dLend')}"><!-- 删除，待审核，审核不通过，新建 -->
      <div id="assetHandleTabDiv" class="layout_south over_hidden" layout="height:${(param.operate eq 'remind' or param.operate eq 'lend')?'125':'110'},border:false,sprit:false">
         <table id="assetHandleTab" class="flexme3" style="display: none;"></table>
      </div>
    </c:if>
  </div>
  </div>
  <c:if test="${isShowBtn}">
   <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_10 align_right bg_color_black" style="z-index: 100">
      <c:if test="${param.operate eq 'add' or param.operate eq 'modify'}">
        <!--设备申请-->
        <a id="btnok" onclick="fnOK();" class="common_button common_button_emphasize" href="javascript:void(0);">${ctp:i18n('common.button.ok.label')}</a> 
        <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
      </c:if>
      <c:if test="${param.operate eq 'lend' and state eq 5}">
        <!--设备借出-->
        <a id="btnok" onclick="fnLend('agree');" class="common_button common_button_emphasize" href="javascript:void(0);">${ctp:i18n('office.asset.apply.lend.js')}</a> 
        <a id="btncancel" onclick="fnLend('notAgree');" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0);">${ctp:i18n('office.asset.apply.notLend.js')}</a>
      </c:if>
      <c:if test="${param.operate eq 'dLend'}">
        <!--设备借出-->
        <a id="btnok" onclick="fnOK('agree');" class="common_button common_button_emphasize" href="javascript:void(0);">${ctp:i18n('office.asset.apply.lend.js')}</a> 
        <a id="btncancel" onclick="fnDLend('notAgree');" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0);">${ctp:i18n('common.button.cancel.label')}</a>
      </c:if>
      <c:if test="${param.operate eq 'remind' and (state eq 10 or state eq 15)}">
        <!--设备归还-->
        <a id="btnok" onclick="fnRemind();" class="common_button common_button_emphasize" href="javascript:void(0);">${ctp:i18n('office.asset.apply.remind.js')}</a> 
        <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
      </c:if>
   </div>
  </c:if>
</div>
</body>
</html>
