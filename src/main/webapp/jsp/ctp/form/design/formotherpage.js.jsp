<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=formFieldDesignManager"></script>
<script type="text/javascript">
// 在文本框中禁止 回车 键
  document.onkeydown   =   function()   
  {   
      var   e   =   window.event.srcElement;   
      var   k   =   window.event.keyCode;   
      if(k==13   &&   e.tagName=="INPUT"   &&   e.type=="text")   
      {   
          window.event.keyCode         =   0;   
          window.event.returnValue=   false;
      }   
  } 
  function cancel()
  {
	  window.close();
  }
  function OK(){
    var label = true;
    var bManager = new formBindDesignManager();
    var fdManager = new formFieldDesignManager();
    var returnStr = fdManager.validateFormName($("#formnewname").val());
    if(returnStr=="-4"){
        $.alert("${ctp:i18n('form.base.formname.label')}（"+$("#formnewname").val()+"${ctp:i18n('form.base.dataform.formname.error.label')}!");
        return null;
    }
    if("${formname}" == $.trim($("#formnewname").val()) && ${isPrepareForm eq false}){
        $.alert("${ctp:i18n('form.base.formname.label')}（"+$("#formnewname").val()+"${ctp:i18n('form.base.dataform.formname.error.label')}!");
        return null;
    }
    if ($("input[name^='newTemNames']").length > 0){
      $("input[name^='newTemNames']").each(function(){
        var tempName = $.trim($(this).val());
        var ss = bManager.checkSameBindName4OtherFormSave(tempName);
        if("success" != ss){
            $.alert($.i18n('form.bind.bindNameExist.label',tempName));
            label = false;
            return false;
        }
        var index = 0;
        if($("input[name^='newTemNames']",$("#template")).length >1){
          $("input[name^='newTemNames']",$("#template")).each(function(i){
            if($.trim($(this).val()) == tempName){
	            if($.trim($(this).val()) == tempName && index != 0){
	              $.alert($.i18n('form.bind.bindName.same.label',tempName));
	              label = false;
	              return false;
	            }else{
	              index = 1;
	            }
            }
          });
        }
        if (!label){
          return false;
        }
      });
      if (!label) {
          return null;
      }
    }
    if ($("input[name^='newQueryNames']").length > 0){
      $("input[name^='newQueryNames']").each(function(){
        var tempName = $.trim($(this).val());
        var index = 0;
        if($("input[name^='newQueryNames']",$("#query")).length >1){
          $("input[name^='newQueryNames']",$("#query")).each(function(i){
            if($.trim($(this).val()) == tempName){
	            if($.trim($(this).val()) == tempName && index != 0){
	              $.alert("${ctp:i18n('form.query.querySet.notAllowSameName')}");
	              label = false;
	              return false;
	            }else{
	              index = 1;
	            }
            }
          });
        }
        if (!label){
          return false;
        }
      });
      if (!label) {
          return null;
      }
    }
    if ($("input[name^='newReportNames']").length > 0){
      $("input[name^='newReportNames']").each(function(){
        var tempName = $.trim($(this).val());
        var index = 0;
        if($("input[name^='newReportNames']",$("#report")).length >1){
          $("input[name^='newReportNames']",$("#report")).each(function(i){
            if($.trim($(this).val()) == tempName){
	            if($.trim($(this).val()) == tempName && index != 0){
	              $.alert("${ctp:i18n('form.query.reportSet.notAllowSameName')}");
	              label = false;
	              return false;
	            }else{
	              index = 1;
	            }
            }
          });
        }
        if (!label){
          return false;
        }
      });
      if (!label) {
          return null;
      }
    }
    if($("#form1").validate()){
	  return $.toJSON($("#form1").formobj());
    } else {
      return null;
    }
  }
//Trim函数去掉一字符串两边的空格
function Trim(his)
{
   //找到字符串开始位置
   Pos_Start = -1;
   for(var i=0;i<his.length;i++)
   {
     if(his.charAt(i)!=" ")
      {
         Pos_Start = i;
         break;
      }
   }
   //找到字符串结束位置
   Pos_End = -1;
   for(var i=his.length-1;i>=0;i--)
   {
     if(his.charAt(i)!=" ")
      {
         Pos_End = i;
         break;
      }
   }
   //返回的字符串
   var Str_Return = ""
   if(Pos_Start!=-1 && Pos_End!=-1)
   {
		for(var i=Pos_Start;i<=Pos_End;i++)
		{
			   Str_Return = Str_Return + his.charAt(i);
		}
   }
   return Str_Return;
}
</script>