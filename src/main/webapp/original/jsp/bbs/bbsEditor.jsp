<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum"%>
<%@ page import="com.seeyon.ctp.common.constants.Constants"%>
<html style="height:100%">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../bbs/header.jsp"%>
<style type="">
.my_border {
  border-bottom: 0px solid #b6b6b6;
}
</style>
<script type="text/javascript">
  var editorStartupFocus = false;
</script>
</head>
<body style="height:100%;overflow:hidden;" class="bbs-bg">
  <form name="replyForm" id="replyForm" method="post">
    <table align="center" cellpadding="0" cellspacing="0" class="bbs-view-title-bar page2-list-border my_border" style="border-bottom: none;" width="100%" height="100%">
      <tr>
        <td>
          <div style="overflow: auto;">
            <v3x:editor htmlId="content" content="${content}" type="HTML" barType="Bbs" category="<%=ApplicationCategoryEnum.bbs.getKey()%>" />
          </div>
        </td>
      </tr>
    </table>
  </form>
</body>
</html>