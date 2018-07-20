<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">

$().ready(function() {
var frmobj = $("#myfrm").formobj();
var selectlog=frmobj.selectlogs;
var dellog=frmobj.dellogs;

$("#selectresult").val(selectlog);
$("#delresult").val(dellog);
if(selectlog.length==0){
	$("#selectrow").hide();
}else{
	$("#delrow").hide();
	
}

  });
</script>
