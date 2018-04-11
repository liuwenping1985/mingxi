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
<title>Member2Role</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=xcmemberManager"></script>
<script type="text/javascript" language="javascript">
var isBat = window.dialogArguments;
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
        managerName: "xcmemberManager",
        managerMethod: "findRoles4ExtMember",
        onSuccess: function() {
            if((isBat != 'true' || isBat != 'false') && '' != isBat) {
                var temRoles = isBat.split(",");
                for(i=0;i<temRoles.length;i++) {
                    $("input[value='"+temRoles[i]+"']").attr("checked","checked");
                }
            }
        }
    });
    //加载表格
    var o1 = new Object();
    $("#accountRoleTable").ajaxgridLoad(o1);

    
});
function OK() {
    var roles = new Array();
    var boxs = $("#accountRoleTable input:checked");
    if (boxs.length >= 1) {
        boxs.each(function() {
            roles.push($(this).val());
        });
    }
    if('true' == isBat) {
        window.close();
    } else {
        window.parent.dialog4Role.close();
    }   
    return roles;
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