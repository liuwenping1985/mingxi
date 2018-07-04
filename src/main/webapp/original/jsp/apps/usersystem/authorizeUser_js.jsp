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
<script type="text/javascript" src="${path}/ajax.do?managerName=resourceGroupManager"></script>
<script type="text/javascript">
function OK() {
  //在资源组表中groupType字段为数字类型，即为资源组合中从左至右第几位值 例如01000 该选中资源组groupType为2.
    var checkboxList = $("input:checkbox");//获取所有checkbox
    var checkbox = new Array(); 
    for(var num=0;num<checkboxList.length;num++){
      if(checkboxList[num].checked){
        checkbox[checkboxList[num].value-1]=1; //选中数组中添加1
      }else{
        checkbox[checkboxList[num].value-1]=0; //未选中数组中添加0
      }
    }
    checkbox = checkbox.join("");//将数组转换为字符串
    $("#resourceId").val(checkbox);
    var frmobj = $("#myfrm").formobj();
    var valid = $._isInValid(frmobj);
    frmobj.valid = valid;
    return frmobj;
	}
  $().ready(function() {
     var callType = $("#callType").val();//判断访问方式 1为查看资源 0为赋权
     if(callType==1){
       show();
     }else{
       oper();
     }
     $("#all").click(function(){
    		 if($("#all").attr("checked")){
    			$("#all").attr("checked","checked");
    		   	for(var i=0;i<$("#resourceGroup input").length;i++){
    		   		$("#resourceGroup input").eq(i).attr("checked","checked");
    		   	 }
    		   }else{
    		   	$("#all").removeAttr("checked");
    		   	for(var i=0;i<$("#resourceGroup input").length;i++){
    		   		$("#resourceGroup input").eq(i).removeAttr("checked");
    		   	}
    		   }
     });
     //赋权
     function oper(){
       var id = $("#id").val();
       var manager = new resourceGroupManager();
       var resourceGroup = new Array();
       var resourceId = $("#resourceId").val();
       var resource = resourceId.split("");      //将字符串转换成数组
       var check = "";
       resourceGroup =  manager.findResourceGroup();
       for(var num =0;num < resourceGroup.length;num++){
            if(resourceGroup[num].groupType<=resource.length){   
             //根据资源组的在资源组合中的位数获取是否选中，用于显示checkb的选中与否
               if(resource[resourceGroup[num].groupType-1]==1){   
                  check = "checked='true'";
               }else{
                  check = "";
               }
            }else{
            	check = "";
            }
            //回写资源组信息
            $("#resourceGroup").append("<label for='Checkbox1' class='margin_t_5 hand display_block'><input type='checkbox' value='"+resourceGroup[num].groupType+"' id='option"+resourceGroup[num].groupType+"' name='option' "+check+" class='radio_com'>"+resourceGroup[num].groupName+"</label>");
        }
      }
     //查看资源
      function show(){
         var id = $("#id").val();
         var manager = new resourceGroupManager();
         var resourceGroup = new Array();
         var resourceId = $("#resourceId").val();
         var resource = resourceId.split("");      //将字符串转换成数组
         var check = "";
         resourceGroup =  manager.findResourceGroup();
         for(var num =0;num < resourceGroup.length;num++){
            if(resourceGroup[num].groupType<=resource.length){   
             //根据资源组的在资源组合中的位数获取是否选中，用于显示checkb的选中与否
               if(resource[resourceGroup[num].groupType-1]==1){   
                  check = "checked='true'";
               }else{
                  check = "";
               }
            }else{
            	check = "";
            }
            //回写资源组信息
            $("#resourceGroup").append("<label for='Checkbox1' class='margin_t_5 hand display_block'><input type='checkbox' value='"+resourceGroup[num].groupType+"' id='option"+resourceGroup[num].groupType+"' name='option' "+check+" class='radio_com' disabled='true'>"+resourceGroup[num].groupName+"</label>");
        }
      }
   })
</script> 
