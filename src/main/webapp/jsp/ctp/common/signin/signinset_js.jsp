<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=signInManager"></script>
<script type="text/javascript">
function OK() {
var sortval=$('input:radio[name="OpenTypeOk"]:checked').val();
if(sortval==null){
	$("#sort").val(0)
}else{
	$("#sort").val(1)
}
    if(check()){
    var frmobj = $("#myfrm").formobj();
    var valid = $._isInValid(frmobj);
    frmobj.valid = valid;
    return frmobj;
    }else{
    	return;
    }
    
  }
  //校验数据
  function check(){
	  if($("#name_signin").val()==""){
		  $.alert("${ctp:i18n('signinmanage.application.remind')}");
		  return  false;
	  }else if($("#param_signin").val()==""){
		  $.alert("${ctp:i18n('signinmanage.application.remind')}");
		  return  false;
	  }else if($("#urlcheck_signin").val()==""){
		  $.alert("${ctp:i18n('signinmanage.application.remind')}");
		  return  false;
	  }else if($("#targetUrl_signin").val()==""){
		  $.alert("${ctp:i18n('signinmanage.application.remind')}");
		  return false ;
	  }else{
		  return true;
	  }
 }


$().ready(function() {
 
  //根据sort 设置单点登录弹出设置
  setSort();

    //修改用户信息回写IP
    function setSort(){
       var sort = $("#sort").val();
        if(sort==0){
           $("#OpenTypeNo").attr("checked","checked");
           $("#OpenTypeOk").removeAttr("checked");
        }
    }

  });
</script>
