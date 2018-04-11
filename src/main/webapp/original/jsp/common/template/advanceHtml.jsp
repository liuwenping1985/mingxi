<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/template/collaborationTemplate_pub.js.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
  
  function checkTemNumber(value){
	    var txt = value.replace(/[ ]/g,"");
	    if(txt.length <=0){
	        return true;
	    }else if(txt.length > 20){
	        return true;
	    }else if(/^[_a-zA-Z0-9]{0,20}$/.test(txt)){
	        var sx = value.split(" ");
	        if(sx.length > 1){
	            //请填写20位以内的字母、数字或下划线组合!
	            $.alert($.i18n('template.systemNewTem.lable1'));
	            return false;
	        }
	        return true;
	    }
	    //请填写20位以内的字母、数字或下划线组合!
	    $.alert($.i18n('template.systemNewTem.lable1'));
	    return false;
	}
  
  
  function OK(){
	if(!checkTemNumber($("#main_iframe_div input[id='templeteNumber']").val())){
		return "false";
	}
    return $('#main_iframe_div select, #main_iframe_div input');
  }
  
  function canAnyMergeClk(ths){
  	var canAnyMerge = $(ths);
  	var canMergeDeal = $("#canMergeDeal");
  	if(canAnyMerge.is(":checked")){
  		canMergeDeal.attr({"disabled":true,"checked":true});
  	}else{
  		canMergeDeal.attr("disabled",false); 		
  	}
  }
</script>
</head>
<body>
  <div id="main_iframe_div"></div>
</body>
</html>