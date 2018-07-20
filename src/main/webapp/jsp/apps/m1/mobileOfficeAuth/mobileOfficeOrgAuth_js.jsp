<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript">
$(function() {
	initToolbar();
	
	bindClickOKAndCance();
	initPage();
});
var toolbar = null;
var userNumber = 0;
/*==========================================toolbar============================================*/
/**
 * 初始化toolbar
 */
function initToolbar() {
	toolbar = $("#toolbar").toolbar({
		toolbar: [{
	     	id: "modify",
	      	name: "${ctp:i18n('common.button.modify.label')}",
	      	className: "ico16 editor_16",
	      	click: modifyAuthList
		}]
	});
};
function modifyAuthList(){
	$("input[name !='userdNumber']").attr("disabled",false);
	$("#button_area").show();
};

function initPage(){
	
	var success = '${success}';
	var error = '${error}';
	var updateSuccess = '${updateSuccess}';
	if(success == false || success =='false'){
		$.alert(error);
		$("#toolbar").hide();
	}
	if(updateSuccess){
		$.alert(updateSuccess);
	}
	$("#button_area").hide();
};
function bindClickOKAndCance(){
	$("#btnsubmit").click(function(){
		submit_form();	
	}); 
	$('#btncancel').click(function(){
		hidden_edit();
	});
};

function checkBeforeSubmit(){
	var result = true;
	//验证后没有非数字 //验证有没有已使用数小于授权数的
	$(".number").each(function() {
		var val = $(this).val();
		if(isNaN(val)){
			$.alert("${ctp:i18n('m1.mobileOfficeAuth.inputTypeOnlyNumber')}");
			result = false;
			return result;
		}
		var  userNumber = $(this).parent().parent().find("input[name ='userdNumber']").val();
		var orgName = $(this).parent().parent().find("span").text();
		if(parseInt(userNumber) > parseInt(val)){
			$.alert(orgName +"${ctp:i18n('m1.mobileOfficeAuth.outofNumber')}");
			result = false;
			return result;
		}
  	  });
	var max = $("#remainAuthNumberLabel").text();
	if(parseInt(max) <0){
		$.alert("${ctp:i18n('m1.mobileOfficeAuth.ALLOutOfNumber')}");
		result =  false;
	}
	return result;
};
function submit_form(){
	if(checkBeforeSubmit()==true){
		$("#auth_form").submit();
	}
	
};
function hidden_edit(){
	$("#button_area").hide();
	window.location = "<c:url value='/m1/mobileOfficeAuth.do'/>?method=mobileOfficeOrgAuth";
};
function inputCheck(obj) {
	/* var  userNumber = $(obj).parent().parent().find("input[name ='userdNumber']").val();
	var orgName = $(obj).parent().parent().find("span").text(); */
		var number = $(obj).val();
		 if(isNaN(number)){
			//$.alert("${ctp:i18n('m1.mobileOfficeAuth.inputTypeOnlyNumber')}");
			return;
		}
		 /*
		if(parseInt(userNumber) > parseInt(number)){
			$.alert(orgName +"${ctp:i18n('m1.mobileOfficeAuth.outofNumber')}");
		} */
		var checkNumber = 0;
		$(".number").each(function() {
			var value = $(this).val();
			 if(isNaN(value)){
				 
			 }
			checkNumber = parseInt(value) + checkNumber;
	    });

	$("#userdAuthNumberLabel").text(checkNumber);
	var max = $("#maxAuthNumberLabel").text();
	$("#remainAuthNumberLabel").text(max - checkNumber);
	checkNumber = 0;
}

</script>