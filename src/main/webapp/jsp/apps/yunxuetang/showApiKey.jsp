<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body scroll="no">
  <table id = "apiTable" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="font_size12 margin_t_10">
    <tr>
      <td>
        <table border="0" cellspacing="0" cellpadding="0" width="95%">
          <tr height="40">
            <td width="10" class="padding_t_10">&nbsp;</td>
            <td align="right" width="90" class="padding_t_10">${ctp:i18n('yunxuetang.getApiKey.form.1.js')}</td>
              <td width="300" class="padding_t_10">
                <c:if test='${param.type=="view"}'>
                  <c:if test="${not empty domain}">
                    <a href="http://${domain}.yunxuetang.cn" target="_blank">http://${domain}.yunxuetang.cn</a>
                  </c:if>
                </c:if> 
                <c:if test='${param.type=="edit"}'>
                  <div class="left margin_r_5">http://</div>
                  <div class="common_txtbox_wrap left" style="width: 165px;">
                    <input type="text" id="yxtOrgName" name="yxtOrgName" value="" class="validate" validate="type:'string',name:'机构域名',notNull:true,notNullWithoutTrim:'true'" />
                  </div>
                  <div class="left margin_r_5">.yunxuetang.cn</div>
                </c:if>
              </td>
            <td width="10" class="padding_t_10">&nbsp;</td>
          </tr>
          <tr height="40">
            <td width="10" class="padding_t_10">&nbsp;</td>
            <td align="right" width="90" class="padding_t_10">${ctp:i18n('yunxuetang.showApiKey.apikey.js')}</td>
            <c:if test='${param.type=="view"}'>
              <td width="300" class="padding_t_10">${apikey}</td>
            </c:if>
            <c:if test='${param.type=="edit"}'>
              <td width="300" class="padding_t_10">
                <div class="common_txtbox_wrap">
                  <input type="text" id="apikey" name="apikey" value="" class="validate" validate="type:'string',name:'apikey',notNull:true,notNullWithoutTrim:'true'" />
                </div>
              </td>
            </c:if>
            <td width="10" class="padding_t_10">&nbsp;</td>
          </tr>

          <tr height="40">
            <td width="10" class="padding_t_10">&nbsp;</td>
            <td align="right" width="90" class="padding_t_10">${ctp:i18n('yunxuetang.showApiKey.signature.js')}</td>
            <c:if test='${param.type=="view"}'>
              <td width="300" class="padding_t_10">${signature}</td>
            </c:if>
            <c:if test='${param.type=="edit"}'>
              <td width="300" class="padding_t_10">
                <div class="common_txtbox_wrap">
                  <input type="text" id="signature" name="signature" value="" class="validate" validate="type:'string',name:'signature',notNull:true,notNullWithoutTrim:'true'" />
                </div>
              </td>
            </c:if>
            <td width="10" class="padding_t_10">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
<c:if test='${param.type=="edit"}'>
  <script type="text/javascript">
    function OK(){
      var validate = $("#apiTable").validate();
      if (!validate) {
          return false;
      }
      
      var obj={};
      obj.yxtOrgName = $("#yxtOrgName").val();
      obj.apikey = $("#apikey").val();
      obj.signature = $("#signature").val();
      return obj;
    }
  </script>
</c:if>
</html>