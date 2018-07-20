<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/common/systemlogs/systemlogsinfo_js.jsp"%>
<html>
<head>
<title></title>
</head>
<body>
  <div>
    <div>
          <form id="myfrm" name="myfrm" method="post">
          <div class="form_area" id='form_area'>
          <input type="hidden" id="selectlogs" />
          <input type="hidden" id="dellogs" />
            <table border="0" cellspacing="0" cellpadding="0" class="margin_lr_10 margin_t_10" align="center" width="330">
              <tr id="selectrow">
                <th width="100px"><label class="margin_r_10" for="text">${ctp:i18n('systemlogsmanage.selectresult.info')}:</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                     <input type="text" id="selectresult"  readonly/>
                  </div>
                </td>
              </tr>
              <tr id="delrow">
                <th><label class="margin_r_10" for="text">${ctp:i18n('systemlogsmanage.delresult.info')}:</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="delresult" class="sort" readonly/>
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