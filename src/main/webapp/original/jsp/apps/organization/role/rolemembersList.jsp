<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE html>

<html>
<head>
<title>Insert title here</title>
<%@ include file="../../../common/common.jsp"%>
<script type="text/javascript">
$().ready(function() {
  var bond = '${ctp:escapeJavascript(bond)}';
  var isbhid;
  if (bond == '2') {
    isbhid = false;
  } else {
    isbhid = true;
  }
  var isGroupRole;
  if (bond == '0') {
    isGroupRole = true;
  } else {
    isGroupRole = false;
  }
  var mytable = $("#viewmembersmytable").ajaxgrid({
    colModel: [{
      display: "${ctp:i18n('org.member_form.name.label')}",
      name: 'name',
      sortable: true,
      width: '15%'
    },
    {
      display: "${ctp:i18n('member.list.find.login')}",
      name: 'loginName',
      sortable: true,
      width: '15%'
    },
    {
      display: "${ctp:i18n('org.dept.belong')}",
      name: 'deptname',
      sortable: true,
      width: '20%'
    },
    {
      display: "${ctp:i18n('role.dept.belong')}",
      name: 'deptrolename',
      sortable: true,
      width: '20%',
      hide: isbhid
    },
    {
      display: "${ctp:i18n('role.source')}",
      name: 'entitytype',
      sortable: true,
      width: '15%'
    },
    {
      display: "${ctp:i18n('org.account.belong')}",
      name: 'accountName',
      sortable: true,
      width: '20%',
      hide:!isGroupRole
    }],
    width: 'auto',
    parentId: 'center',
    managerName: "roleManager",
    managerMethod: "showMembers4Role"
  });
  var o = new Object();
  o.id = '${ctp:escapeJavascript(roleid)}';
  $("#viewmembersmytable").ajaxgridLoad(o);
});
</script>
</head>
<body id="body">
<div id='layout' class="comp" comp="type:'layout'">
<div class="layout_center over_hidden" layout="border:false" id="center">
<div id="viewmembers">
	<table id="viewmembersmytable" class="flexme3" border="0" cellspacing="0" cellpadding="0"></table>
</div>
</div>
</div>
</table>
</body>
</html>