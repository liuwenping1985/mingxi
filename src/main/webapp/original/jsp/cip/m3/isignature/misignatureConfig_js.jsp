<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
var tempUrl = "";

$().ready(function(){
	
	$("#button_area").hide();
	$('#btnok').click(function(){
		confirm();
	});
	$('#btncancel').click(function(){
		$("#button_area").hide();
		cancel();
	});
	var toolbar = $("#toolbar").toolbar({
	    toolbar: [{
	    
	      id: "edit",
	      name: "${ctp:i18n('common.button.modify.label')}",
	      className: "ico16 editor_16",
	      click:function(){
	    	  $("#button_area").show();
	    	  $("#address").attr("disabled",false);
	    	  $("#checkUrl").show();
	      }
	    }]
	    });
	init(toolbar);
});
function init(toolbar) {
	  var address ="${iSignatureServerurl}";
	  tempUrl = address;
	  var error = "${message}";
	  var inits = "${init}";
	  var success = "${success}";
	  $("#address").attr("disabled",true);
	  $("#address").val(address); 
	  if(inits &&(inits == true || init =='true')) {
		  if(success ==false || success=='false'){
				$.alert(error);
				toolbar.disabledAll();
			  } else {
			 	toolbar.enabledAll();
			  }
	  } else {
		  if(success ==false || success=='false'){
				$.alert(error);
			  } 
	  }
	  
}
function confirm() {
	document.getElementById("form1").submit();
}
function cancel() {
	//window.location = "<c:url value='/m3/msignature.do'/>?method=setIsignatuerServer";
	 $("#address").val(tempUrl); 
	 $("#button_area").hide();
	 $("#address").attr("disabled",true);
	 $("#checkUrl").hide();
}

</script>
