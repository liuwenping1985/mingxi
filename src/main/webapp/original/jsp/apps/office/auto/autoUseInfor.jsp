<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!--申请数据区域-->
<table id="autoUseTab"  class="w90b" border="0" cellSpacing="2" cellPadding="0" align="center" style="table-layout:fixed;font-size:12px;">
  <!-- 申请 -->
  <tr>
    <th width="80" noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.autoapply.user.js') }:</label></th>
    <td colspan="2" align="left">
      <div id="userDiv" class="common_txtbox_wrap">
        <input id="id" type="hidden">
        <c:set var="member" value=",value:'Member|${memberId}',text:'${memberName}'"/>
        <c:set var="memberval" value="${empty memberId ? '': member}"/>
        <input id="applyUser" class="comp font_size12 validate w100b" validate="name:'${ctp:i18n('office.auto.autoStcInfo.ycr.js')}',notNull:true" comp="type:'selectPeople',panels:'Department,Team,Post,Level',selectType:'Member',maxSize:'1',callback:applyUserCallBackPub${memberval}">
      </div>
    </td>
      
    <th width="100" noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.autoapply.dep.js') }:</label></th>
    <td colspan="2">
      <div id="depDiv" class="common_txtbox_wrap" align="left">
        <c:set var="dept" value=",value:'Department|${deptId}',text:'${deptName}'"/>
        <c:set var="deptval" value="${empty deptId ? '': dept}"/>
        <input id="applyDept" class="comp font_size12 validate"  validate="name:'${ctp:i18n('office.auto.autoStcInfoShow.ycbm.js')}',notNull:true" comp="type:'selectPeople', panels:'Department',selectType:'Department',maxSize:'1'${deptval}">
      </div>
    </td>
    <td width="30"></td>
  </tr>
  <input type="hidden" id="applyLevel" value="Level|${levelId}"/>
  
  <tr>
    <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.autoapply.uphone.js') }:</label></th>
    <td colspan="2" align="left">
      <div class="common_txtbox_wrap">
        <input id="applyUserPhone" class="font_size12 w100b" type="text" value="${memberTel}" maxlength="20">
       </div>
    </td>
    <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.autoapply.num.js')}:</label></th>
    <td colspan="2" align="left"><div class="common_txtbox_wrap">
          <input id="passengerNum" class="validate font_size12" maxlength="4" type="text" validate="name:'${ctp:i18n('office.auto.autoStcInfoShow.ccrs.js')}',regExp:'(1000)|(^[1-9][0-9]{0,2}$)',errorMsg:'${ctp:i18n('office.auto.ccrs.check.js')}'">
        </div>
    </td>
    <td></td>
  </tr>
  
  <tr>
      <th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.autoapply.passenger.js') }:</label></th>
      <td colspan="5" align="left">
        <div id="passengerDiv" class="common_txtbox_wrap">
        <input id="passenger" class="comp font_size12"  comp="type:'selectPeople',maxSize:'100', panels:'Department,Team,Post,Level',selectType:'Member'"></div>
      </td>
      <td></td>
  </tr>
  
  <tr>
      <td noWrap="nowrap" align="right" valign="top">
          <span class="color_red">*</span><label  for="text">${ctp:i18n('office.autoapply.origin.js') }:</label>
      </td>
      <td colspan="5" align="left">
          <div class="common_txtbox  clearfix">
              <textarea id="applyOrigin" style="width: 98%; height: 45px;" class="padding_5 margin_r_5 validate" validate="name:'${ctp:i18n('office.auto.autoStcInfoShow.ycsy.js')}',type:'string',maxLength:600,notNull:true"></textarea>
          </div>
      </td>
      <td></td>
  </tr>
  
  <tr nodePostion="send" nodeAcl="sendOut">
      <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.autoapply.udate.js') }:</label></th>
      <td align="left" colspan="2">
       <div class="common_txtbox_wrap ">
         <input id="applyOuttime" class="comp font_size12 validate w90b" style="width:98%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,clearBlank:false" validate="name:'${ctp:i18n('office.autoapply.udate.js')}',notNull:true" readonly>
      </div>
      </td>
      <td colspan="3" align="left">
        <span class="margin_r_5 margin_tb_5 left">${ctp:i18n('office.asset.apply.to.js') }</span>
        <div class="common_txtbox_wrap  w60b left">
          <input id="applyBacktime" class="comp validate font_size12" style="width:98%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,clearBlank:false" validate="name:'${ctp:i18n('office.autoapply.udate.js')}',notNull:true" readonly>
        </div>
      </td>
      <td></td>
  </tr>
  
  <tr>
      <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.autoapply.startplace.js')}:</label></th>
      <td colspan="2" align="left"><div class="common_txtbox_wrap ">
        <input id="applyDep" class="validate font_size12 w100b" maxlength="80"  type="text" validate="type:'string',name:'${ctp:i18n('office.autoapply.startplace.js')}'">
        </div>
      </td>
      <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.autoapply.endplace.js') }:</label></th>
      <td colspan="2" align="left"><div class="common_txtbox_wrap">
        <input id="applyDes" class="validate font_size12"  type="text" maxlength="80" validate="type:'string',name:'${ctp:i18n('office.auto.autoStcInfoShow.mdd.js')}'">
        </div>
      </td>
      <td></td>
  </tr>
  
  <tr>
      <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.autoapply.type.js') }:</label></th>
      <td colspan="2">
        <select id="applyDepartType" class="w100b font_size12">
          <c:forEach items="${enumItems}" var="item">
            <option value="${item.enumvalue}" enumId="${item.id}">${item.showvalue}</option>
          </c:forEach>
        </select>
      </td>
      <td></td><td colspan="2"></td>
      <td></td>
  </tr>
  
  <tr>
      <td noWrap="nowrap" align="right" valign="top">
          <label  for="text">${ctp:i18n('office.autoapply.memo.js') }:</label>
      </td>
      <td colspan="5" align="left">
          <div class="common_txtbox  clearfix">
              <textarea id="applyMemo" style="width: 98%; height: 45px;" class="validate padding_5 margin_r_5" validate="name:'${ctp:i18n('office.assetinfo.memo.js')}',type:'string',maxLength:600"></textarea>
          </div>
      </td>
      <td></td>
  </tr>
  
  <!-- 审批 -->
 <tr nodePostion="audit" id="auditContentTR">
    <td noWrap="nowrap" align="right" valign="top">
        <label  for="text">${ctp:i18n('office.autoapply.audit.js') }:</label>
    </td>
    <td colspan="5" align="left">
      <div id="auditContent" style="min-height: 40px;" class="common_txtbox color_gray clearfix border_all padding_5">
      </div>
    </td>
    <td></td>
  </tr>
  
  <!-- 派车 --> 
   <tr nodePostion="send" nodeAcl="sendOut">
    <th noWrap="nowrap" align="right"><span id="applyAutoSpan" class="color_red">*</span><label for="text">${ctp:i18n('office.autoapply.auto.js') }:</label></th>
    <td colspan="2" align="left">
      <div class="common_txtbox_wrap">
        <input id="applyAutoId" type="hidden">
        <input id="applyAutoPassengerNum" type="hidden">
        <!-- 派车 -->
        <c:if test="${(param.method ne 'sendEdit') and (param.method ne 'autoDSendEdit')}">
          <input id="applyAutoIdName" onclick="fnOpenAutoPub();" class="validate font_size12" validate="type:'string',name:'${ctp:i18n('office.app.auto.js')}'" type="text" readonly="readonly">
        </c:if>
        <!-- 出车、还车 -->
        <c:if test="${(param.method eq 'sendEdit') or (param.method eq 'autoDSendEdit')}">
          <input id="applyAutoIdName" onclick="fnOpenAutoPub('autoAdmin');" class="validate font_size12" validate="type:'string',notNull:true,name:'${ctp:i18n('office.app.auto.js')}'" type="text" readonly="readonly">
        </c:if>
      </div>
    </td>
    <td noWrap="nowrap" align="left" colspan="3">
      <div id="applySelf2Msg" class="common_checkbox_box margin_l_10 clearfix">
        <label class="hand" for="selfDriving">
          <input id="selfDriving" onclick="${param.method eq 'autoDSendEdit' ? 'fnSelfDriving':'fnSelfDrivingPub'}();" class="radio_com  margin_r_10" value="1" type="checkbox">${ctp:i18n('office.autoapply.self.js') }</label>
        <label class="hand margin_l_10" for="msgToPassenger">
          <input id="msgToPassenger" class="radio_com" value="1" checked="checked" type="checkbox">${ctp:i18n('office.autoapply.msg2p.js') }</label>
       </div>
    </td>
    <td></td>
  </tr>
  
  <tr nodePostion="send" nodeAcl="sendOut" id="applyDriverDiv">
    <th noWrap="nowrap" align="right"><span id="applyDriverSpan" class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.driver.js') }:</label></th>
    <td colspan="2" align="left">
      <div class="common_txtbox_wrap">
        <input id="applyDriverName" type="text" onclick="fnSelectPeoplePub({type:'driver'});" class="font_size12 validate" validate="type:'string',notNull:true,name:'${ctp:i18n('office.auto.autoStcInfo.jsy.js')}'" readonly="readonly">
        	<div class="display_none">
		        <input id="applyDriver" type="hidden">
		        <input id="shadowapplyDriver" type="hidden">
		        <input id="shadowapplyDriverName" type="hidden">
		        <input id="shadowapplyDriverPhone" type="hidden">
        	</div>
      </div>
    </td>
    <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.autoapply.dphone.js') }:</label></th>
    <td colspan="2" align="left">
      <div id="applyDriverPhoneDiv" class="common_txtbox_wrap">
        <input id="applyDriverPhone"  disabled="disabled" class="font_size12" maxlength="20" type="text" readonly="readonly">
      </div>
    </td>
    <td></td>
  </tr>
  
  <tr id="dispatchOpinionTR" nodePostion="send" nodeAcl="sendOut">
    <td noWrap="nowrap" align="right" valign="top">
        <label  for="text">${ctp:i18n('office.autoapply.sendoption.js') }:</label>
    </td>
    <td colspan="5" align="left">
        <div class="common_txtbox clearfix">
            <textarea id="dispatchOpinion" style="width: 98%; height: 45px;" class="validate font_size12 padding_5 margin_r_5" validate="type:'string',maxLength:600,name:'${ctp:i18n('office.autoapply.sendoption.js')}'"></textarea>
        </div>
    </td>
    <td></td>
  </tr>
  
  <!-- 出车  --> 
  <c:if test="${param.method ne 'autoApplyEdit'}">
    <tr nodePostion="autoOut" nodeAcl="sendOut">
      <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.autoapply.senddate.js') }:</label></th>
      <td colspan="2" align="left">
        <div class="common_txtbox_wrap">
            <input id="realOuttime" class="comp font_size12 validate" type="text" validate="type:'string',notNull:true,name:'${ctp:i18n('office.auto.autoStcInfoShow.ccsj.js')}'" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" readonly>
        </div>
      </td>
      <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.autoapply.outkm.js') }:</label></th>
      <td colspan="2" align="left">
        <div class="common_txtbox_wrap">
          <input id="outmileage" class="validate font_size12"  type="text" maxlength="9" validate="type:'number',name:'${ctp:i18n('office.autoapply.outkm.js')}',regExp:'^[0-9]{0,9}$',errorMsg:'${ctp:i18n('office.auto.out.car.check.js')}'">
         </div>
      </td>
      <td nowrap="nowrap" align="left">${ctp:i18n('office.auto.maintenance.js') }</td>
    </tr>
  </c:if>
  <c:if test="${not empty workflowRule and (param.operate eq 'new' or param.operate eq 'modfiy')}">
    <tr id="applyNote">
      <td align="right" valign="top"><label for="text">${ctp:i18n('office.autoapply.explain.js') }:</label></td>
      <td colspan="6" align="left">
          <div class="green">${ctp:toHTML(workflowRule)}</div>
      </td>
    </tr>
  </c:if>
</table>
<div id="workFlowDiv" class="display_none">
  <input type="hidden" id="readyObjectJSON" name="readyObjectJSON">
  <input type="hidden" id="workflow_newflow_input" name="workflow_newflow_input"/>
  <input type="hidden" id="workflow_node_peoples_input" name="workflow_node_peoples_input"/>
  <input type="hidden" id="workflow_node_condition_input" name="workflow_node_condition_input"/>
  <input type="hidden" id="process_rulecontent" name="process_rulecontent"/>
  <input type="hidden" id="process_message_data" name="process_message_data">
</div>