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
<title>AllRoles</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=memberManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
    var grid = $("#accountRoleTable").ajaxgrid({
        colModel: [
        {
            display : "${ctp:i18n('role.name')}",
            name : 'showName',
            width : '50%'
        },{
            display : "${ctp:i18n('role.type.bond')}",
            name : "bond",
            width : "20%"
        },{
          display : "${ctp:i18n('role.source')}",
          name : 'source',
          sortable : true,
          width : '30%'
        }],
        parentId: "center",
        slideToggleBtn: false,
        showTableToggleBtn: false,
        resizable: false,
        striped:true,
        usepager: false,
        width: "auto",
        managerName:"memberManager",
        managerMethod:"showMemberAllRoles"
    });
    //加载表格
    var o1 = new Object();
    o1.memberId = "${ctp:escapeJavascript(memberId)}";
    $("#accountRoleTable").ajaxgridLoad(o1);
});
function OK() {
    window.parent.dialog4Role.close();
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