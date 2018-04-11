
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
function OK() {
    var frmobj = $("#myfrm").formobj();
    var valid = $._isInValid(frmobj);
    frmobj.valid = valid;
    return frmobj;
  }

$().ready(function() {
  });
</script>
