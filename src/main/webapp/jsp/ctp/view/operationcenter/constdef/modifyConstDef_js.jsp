
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
	var constType = '<%=request.getAttribute("constType")%>';
	if(constType == '数值'){
		$('.constType1').attr('checked', 'checked');
	} else if (constType == '字符'){
		$('.constType2').attr('checked', 'checked');
	} else if (constType == '表达式'){
		$('.constType3').attr('checked', 'checked');
	} else if (constType == '宏替换'){
		$('.constType4').attr('checked', 'checked');
	}
  });
</script>
