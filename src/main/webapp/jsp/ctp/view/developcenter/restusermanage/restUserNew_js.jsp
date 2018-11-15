<%--
 $Author: jiahl$
 $Rev:  $
 $Date:: 2014-01-21#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=restUserManager"></script>
<script type="text/javascript">
function OK() {
   var ip="";
   var time = 0;
   var flag = true;
    $("input[name='ip']").each(function(){   
               var v = $(this).val(); 
               if(""!=v){
                 var exp=/^(([0-9]|[1-9][0-9]|1\d\d|2[0-4]\d|25[0-5])|\*)\.(([0-9]|[1-9][0-9]|1\d\d|2[0-4]\d|25[0-5])|\*)\.(([0-9]|[1-9][0-9]|1\d\d|2[0-4]\d|25[0-5])|\*)\.(([0-9]|[1-9][0-9]|1\d\d|2[0-4]\d|25[0-5])|\*)$/;
               var reg = v.match(exp);  //判断IP格式
               if(reg==null){
                  $.alert("${ctp:i18n('usersystem.restUser.error.ip')}");
                  flag = false;
                  return false;
               }
                if(time!=0){
                    v="|"+v;
                }
                ip=ip+v;
                time++;
               }
             });
   if(flag ==false){
      return;
   }
   if(check(ip)==false){
      return;
    };
    if($("#checkip").is(':checked')){
    	$("#validationip").val(1); 
    }else{
    	$("#validationip").val(0); 
    }
    $("#loginIp").val(ip); 
    var frmobj = $("#myfrm").formobj();
    var valid = $._isInValid(frmobj);
    frmobj.valid = valid;
    return frmobj;
  }
  //校验IP是否重复
  function check(ip){
    var allip = ip.split("|");
    for(var i=0;i<allip.length-1;i++){
      for(var j=i+1;j<allip.length;j++){
        if(checkTwo(allip[i],allip[j])==false){
            $.alert("${ctp:i18n('usersystem.restUser.error.sameip')}");
            return false;
        }
     }
   }
   return true;
 }
 //校验IP是否重复具体实现
  function checkTwo(ip1,ip2){
      var ip1s = ip1.split(".");
      var ip2s = ip2.split(".");
      var count = 0;
      for(var i=0;i<ip1s.length;i++){
          if(ip1s[i]=="*"||ip2s[i]=="*"||ip1s[i]==ip2s[i]){   //验证IP是否重复，分四段验证
          count++;
          }
      }
      if(count==4){
         return false;
      }else{
         return true;
      }
}

$().ready(function() {
  //设置密码，用于显示
  $("#passWord").val("~`@%^*#?");
  $("#passWord2").val("~`@%^*#?");
  //根据callType请求的类型显示IP信息 1修改 0创建
  if("1"==$("#callType").val()){ 
  showIp();
}
  //IP校验初始化1 勾选 0不勾选
  if("0"==$("#validationip").val()){
	  $("#checkip").attr('checked',false);
  }else{
      $("#checkip").attr('checked',true);
  }
  //添加一行<tr> 
    $("#add").click(function(){ 
    //创建三个元素
        var $txt = $("<input type='text' value='' size='20'  name='ip' />");
        var $btn = $("<a href='javascript:void(0)' class='common_button common_button_gray'>${ctp:i18n('usersystem.restUser.deleteUser')}</a>"); 
        var $br = $("<br/>");  
        $btn.click( //设置删除按钮的onclick事件
          function (){
            $txt.remove();
            $btn.remove();
            $br.remove();
          })
        $("#ipinput").append($txt).append($btn).append($br);
       });

    //修改用户登录信息清空密码
      $("#loginName").click(function (){
      if("1"==$("#callType").val() && $("#passWord").val()!="" && $("#passWord2").val()!=""){ 
        $.confirm({
             'msg': '${ctp:i18n("usersystem.restUser.info.login")}',
             ok_fn: function () { 
              $("#passWord").val("");
              $("#passWord2").val("");
              $("#loginName").focus();
            },
             cancel_fn:function(){$("#loginName").focus();}
         });
         
      }else{
        $("#loginName").focus(); //将焦点设置给登录名
         }
        }
      );
    //修改用户信息回写IP
    function showIp(){
       var allip = $("#loginIp").val();
       var ip = allip.split("|");
       for(var i=0;i<ip.length;i++){
        if(i==0){
           $("#ip").val(ip[i]);
        }else{
         addIp(ip[i]);
         }
       }
    }
    //修改用户信息回写IP追加方法
    function addIp(ip){
        var $txt = $("<input type='text' size='20'  name='ip' value='"+ip+"'/>");
        var $btn = $("<a href='javascript:void(0)' class='common_button common_button_gray'>${ctp:i18n('usersystem.restUser.deleteUser')}</a>"); 
        var $br = $("<br/>");  
        $btn.click( //设置删除按钮的onclick事件
          function (){
            $txt.remove();
            $btn.remove();
            $br.remove();
          })
        $("#ipinput").append($txt).append($btn).append($br);//追加IP输入文本框
    }
  });
</script>
