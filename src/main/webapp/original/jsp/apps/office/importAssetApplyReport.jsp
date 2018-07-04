<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b w100b">
<head>
<title></title>
<style type="text/css">
  .stadic_head_height{
      height:50px;
  }
  .stadic_body_top_bottom{
      top: 50px;
      bottom: 5px;
  }
  .stadic_layout_body{
    overflow: ${isImport ? 'hidden':'auto'};
  }
</style>
<script type="text/javascript">
  function fnLoadErrorData(){
  	var errorJsonData = "${errorDataJSON}";
  	$("#errorDataList").val(errorJsonData);
  	document.getElementById("errorDataForm").submit();
  }
</script>
</head>
<body class="h100b w100b" bgColor="#f6f6f6">
<div class="stadic_layout">
    <div class="stadic_layout_head stadic_head_height">
        <table  border="0" align="left" width="100%" class="font_size12">
        <tr>
          <td colspan="4">
            <table  border="0" align="left" width="100%" class="font_size12"><tr>
              <td height="20" style="padding-left: 5px" width="70" align="left">${ctp:i18n('import.filename')}:</td>
              <td colspan="3" align="left" title="${impURL}">${v3x:getLimitLengthString(impURL,52,"...")}</td>
              </tr>
            </table>
          </td>
        </tr>
          <tr>
            <c:if test="${isImport}">
              <td style="padding-left:5px" colspan="3" align="left" nowrap="nowrap">${ctp:i18n_3('office.asset.exp.report.js',total,successNum,failNum)}</td>
            </c:if>
            <c:if test="${not isImport}">
                <td style="padding-left:5px" colspan="3" align="left">${ctp:i18n('office.asset.imp.format.error.js')}</td>
            </c:if>
            <td align="right" style="padding-right:5px" nowrap="nowrap">&nbsp;
              <c:if test = "${failNum gt 0 and isImport }">
                <a href="javascript:fnLoadErrorData();">${ctp:i18n('office.asset.exp.error.js')}</a>
              </c:if>
          </td>
          </tr>
      </table>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom">
        <div class="relative" style="height:99%;">
          
            <div class=" table_head relative"><!--表头-->
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
                    <tbody>
                        <tr>
                            <th width="42" nowrap="nowrap">${ctp:i18n('office.asset.target.row.js')}</th>
                            <th width="60" nowrap="nowrap">${ctp:i18n('office.stock.result.report.js')}</th>
                            <th>${ctp:i18n('office.asset.fail.desc.js')}</th>
                        </tr>
                    </tbody>
                    </table> 
            </div>
            <div class="table_body absolute"><!--表身-->
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
                    <tbody>
                      <c:if test="${isImport}">
                        <c:forEach var="msg" items="${errorMsgs}">
                          <tr class="border_t">
                            <td width="43" nowrap="nowrap">${ctp:i18n_1('office.asset.target.row2.js',msg.rowIndex)}</td>
                            <td width="62" nowrap="nowrap">${ctp:i18n('office.asset.imp.error.js')}</td>
                            <td>${msg.errorContent}</td>
                          </tr>
                       </c:forEach>
                      </c:if>
                      <c:if test="${not isImport}">
                        <c:forEach var="msg" items="${errorMsgs}">
                            <td width="43" nowrap="nowrap"></td>
                            <td width="62" nowrap="nowrap"></td>
                            <td>${msg.errorContentTitle}</td>
                        </c:forEach>
                      </c:if>
                    </tbody>
                </table>    
            </div>
      </div>
    </div>
</div>
<div class="hidden">
  <form id="errorDataForm" action="${path}/office/assetUse.do?method=exportAssetTemplete&dow=dowloadTemplete" target="emptyIFrame" method="post">
    <input id="errorDataList" name="errorDataList">
  </form>
  <iframe id="emptyIFrame" name="emptyIFrame" frameborder="0" marginheight="0" marginwidth="0" ></iframe>
</div>
</body>
</html>