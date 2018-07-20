<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript">
$(function() {
	initToolbar();
	bindSelectPeople();
	bindClickOKAndCance();
	initPage();
});
var toolbar = null;
/*==========================================toolbarç¸å³å¤ç============================================*/
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
	$("#authlist").attr("disabled",false);
	$("#button_area").show();
};
function bindSelectPeople(){
	$("#authlist").click(function(){
		$.selectPeople({
		      type: 'selectPeople',
		      text:$("#authlist").val(),
		      panels: 'Department,Outworker',
		      selectType: 'Member',
		      minSize:0,
		      maxSize:$("#maxAuthNumber").val(),
		      params: {value:$("#entityIDs").val()},
		      showConcurrentMember:true,
		      onlyLoginAccount: true,
		      returnValueNeedType: true,
		      callback: function(ret) {
		    	  $("#authlist").val(ret.text);
		    	  checkPeople(ret.value);
		    	 
		    }
		});
	});
	
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
function submit_form(){
	$("#auth_form").submit();
};
function hidden_edit(){
	$("#button_area").hide();
	window.location = "<c:url value='/m1/mobileOfficeAuth.do'/>?method=index";
};
function updateRemainAuthNumber(userdnumber,max,flag){
	$("#userdAuthNumberLabel").text(userdnumber);
	$("#remainAuthNumberLabel").text(max -userdnumber);
}
function checkPeople(entityIDs){
	var number = $("#maxAuthNumber").val();
	
	var  array = 0;
	var len = 0;
	if(entityIDs !=""){
		array = entityIDs.split(",");
		len = array.length;
	}
	
	 $("#entityIDs").val(entityIDs);
	if(len>number){
		
		updateRemainAuthNumber(len,number,false);
		$("#btnsubmit").attr("disabled",true);
		$.alert("超过最大授权数!");
		
	}else {
		updateRemainAuthNumber(len,number,true);
		$("#btnsubmit").attr("disabled",false);
	}
	
};
</script>