<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/template/collaborationTemplate_pub.js.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript">
  $(function() {
    var result = window.dialogArguments;
    $("#main_iframe_div")[0].innerHTML = result[0][0].innerHTML;
    //
    $(result[1]).each(function(index, elem){
      var elemName = $(elem).attr("name");
      var elemValue = $(elem).val();
      $("#" + elemName).val(elemValue);
      if($(elem).attr("type") == "checkbox"){
        $("#" + elemName)[0].checked = $(elem)[0].checked;
        $("#" + elemName)[0].disabled = $(elem)[0].disabled;
      }
    });
  });
  
  function OK(){
    return $('#main_iframe_div select, #main_iframe_div input');
  }
</script>
</head>
<body>
  <div id="main_iframe_div"></div>
</body>
</html>