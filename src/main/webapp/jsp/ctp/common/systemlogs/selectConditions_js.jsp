<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
var logstype = transParams.logstype;
function OK() {
var fromdate=$("#fromdate").val();//开始时间：默认显示当前时间
var todate=$("#todate").val();
var log_type_info=$("#log_type_info").val();
var log_index=$("#log_index").val();//如果是一天多日志，如：ctp.log.2015-03-20.1.log
var linktype=$("#linktype").val();

   if(check(fromdate,todate,log_type_info,log_index,linktype) ==false){
	   $.alert("${ctp:i18n('systemlogsmanage.slectcondition.info')}");
      return;
   }
    var frmobj = $("#myfrm").formobj();
    var valid = $._isInValid(frmobj);
    frmobj.valid = valid;
    return frmobj;
  }
  //校验
  function check(formdate,todate,logtype,indexinfo,linktype){
	  if(typeof(linktype)!="undefined"){
		  if(typeof(formdate)!="undefined"&&typeof(logtype)!="undefined"&&typeof(indexinfo.length)!="undefined"){
			  return true;
		  }
	  }else{
		  if(typeof(formdate)!="undefined"&&typeof(logtype)!="undefined"&&typeof(indexinfo.length)!="undefined"&&typeof(todate)!="undefined"){
			  return true;
		  }
	  }
   return false;
 }
 
$().ready(function() {
    var linkType=$("#linktype").val();
    var selecthide=$("#log_type_info");
	var date=new Date();
	var fromDate=date.print("%Y-%m-%d");
	toDate=date.getTime();//结束时间：默认显示当前时间加30分钟

	$("#fromdate").val(fromDate);//开始时间：默认显示当前时间
	if(linkType.length>0){
		$("#todatetr").hide();
		$("#log_type_info").children('option[value="all"]').wrap('<span>').hide();

	}else{
	$("#todate").val(new Date(toDate).print("%Y-%m-%d"));
	}
	
	
	$("#log_index").val(1);//如果是一天多日志，如：ctp.log.2015-03-20.1.log
	
	
  });
</script>
