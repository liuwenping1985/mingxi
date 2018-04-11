<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/common/systemlogs/selectConditions_js.jsp"%>
<html>
<head>
<title></title>
</head>
<body>
  <div>
    <div>
          <form id="myfrm" name="myfrm" method="post">
          <div class="form_area" id='form_area'>
            <input type="hidden" id="createTime" />
            <input type="hidden" id="linktype" value="${linktype}"/>
            <table border="0" cellspacing="0" cellpadding="0" class="margin_lr_10 margin_t_10" align="center" width="330">
            <%--
              <tr>
                <th width="70px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('systemlogsmanage.logtype.info')}</label></th>
                <td>
                  <div class="common_txtbox_wrap" style="padding-right:0px;padding-left:0px">
                            <select name="log_type_info" id="log_type_info" style="width:260px" onchange="">
                                <option value='ctp' >${ctp:i18n('systemlogsmanage.ctplog.info')}</option>
                                <option value='capability' >${ctp:i18n('systemlogsmanage.capabilitylog.info')}</option>
                                <option value='ajax' >${ctp:i18n('systemlogsmanage.ajaxlog.info')}</option>
                                <option value='cluster' >${ctp:i18n('systemlogsmanage.clusterlog.info')}</option>
                                <option value='form' >${ctp:i18n('systemlogsmanage.formlog.info')}</option>
                                <option value='quartz' >${ctp:i18n('systemlogsmanage.quartzlog.info')}</option>
                                <option value='uc' >${ctp:i18n('systemlogsmanage.uclog.info')}</option>
                                <option value='workflow' >${ctp:i18n('systemlogsmanage.workflowlog.info')}</option>
                                <option value='all'>${ctp:i18n('systemlogsmanage.alllog.info')}</option>
                            </select>
                  </div>
                </td>
              </tr>
              --%>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('systemlogsmanage.startime.info')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">         
                      <input id="fromdate" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',cache:false"/>
                      <input id="log_type_info" name="log_type_info" type="hidden"  value="${logstype }"/>
                  </div>
                </td>
              </tr>
               <tr id="todatetr">
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('systemlogsmanage.endtime.info')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                       <input id="todate" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',cache:false"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('systemlogsmanage.lognumber.info')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                      <input type="text" id="log_index" class="validate"
                      validate="type:'string',name:'lognumber',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
            </table> 
            </div> 
             </form>
    </div>  
  </div>
</body>
</html>