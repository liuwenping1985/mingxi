<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>分配角色</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=memberManager"></script>
<script type="text/javascript" language="javascript">
var memberIds = "${memberIds}";//人员id
var roleIds = "${roleIds}";//权限id
var orgAccountId = "${orgAccountId}";
//请勿轻易修改这个变量不仅批量关闭窗口用，角色回填也需要回传值
$().ready(function() {
    //列表
    var grid = $("#accountRoleTable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '15%',
            align: 'center',
            type: 'checkbox'
        },
        {
            display : "${ctp:i18n('role.name')}",
            name : 'showName',
            width : '80%'
        }],
        parentId: $(".layout_center").eq(0).attr("id"),
        slideToggleBtn: false,
        showTableToggleBtn: false,
        resizable: false,
        striped:true,
        usepager: false,
        width: "auto",
        managerName: "memberManager",
        managerMethod: "getAllRoleNotSecretAdmin",
        onSuccess: function() {
			  var temRoles = roleIds.split(",");
			  //$("input[value='"+puTongRenYuanId+"']").attr("checked","checked");//默认为普通权限
              for(i=0;i<temRoles.length;i++) {
                  $("input[value='"+temRoles[i]+"']").attr("checked","checked");
              }
        }
    });
    var o1 = new Object();
    var loginAccountId = $.ctx.CurrentUser.loginAccount;
    o1.orgAccountId = orgAccountId;//loginAccountId;    //Fix OA-9486 要显示部门角色
    o1.temRoles = roleIds;
    $("#accountRoleTable").ajaxgridLoad(o1);

});
function OK() {
	var v = $("#accountRoleTable").formobj({
	       gridFilter : function(data, row) {
	         return $("input:checkbox", row)[0].checked;
	       }
	});

	if(v.length==0){
		alert($.i18n('secret.choose.role'));
		return;
	}
	var fileIds="";//传递的是人员id
	if(v[0].name != "GeneralStaff" && v[0].name != "ExternalStaff" && v[0].name !="普通人员权限"){//根据之前的业务逻辑，不能随便修改
		alert("普通人员权限为必选项!");
		return false;
		}
	 for(var i=0;i<v.length;i++){
		 if(i===v.length-1){
			 fileIds+=v[i].id;
      }else{
     	 fileIds+=(v[i].id+",");
      }
	 }
	 return memberIds+"&"+fileIds;
	 /**
	 var url= "/seeyon/secret/secretSetController.do?method=distributeRole&memberIds="+memberIds+"&fileIds="+fileIds;
		$.ajax({
	  		url : url,
	  	});
    window.close();*/
}
function quxiao(){
	window.close();
}
</script>
</head>
<body>

    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="accountRoleTable" class="flexme3" style="display: none"></table>
        </div>
    </div>

</body>
</html>