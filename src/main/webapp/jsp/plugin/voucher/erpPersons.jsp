<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>ErpPersonList</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=memberMapperManager"></script>
<script type="text/javascript" language="javascript">

$().ready(function() {
    //列表
    var grid = $("#erpPersonTable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            align: 'center',
            sortable: false,
            type: 'checkbox'
        },
        {
            display : "${ctp:i18n('voucher.plugin.cfg.unitname.label')}",
            name : 'erpUnitName',
            width : '30%',
            sortable : true
        }
        ,
        {
            display : "${ctp:i18n('voucher.plugin.cfg.deptname.label')}",
            name : 'erpDeptName',
            width : '20%',
            sortable : true
        }
        , 
        {
            display : "${ctp:i18n('voucher.plugin.cfg.empname.label')}",
            name : 'erpPersonName',
            width : '20%',
            sortable : true
        },
        {
            display : "${ctp:i18n('voucher.plugin.cfg.empcode.label')}",
            name : 'erpPersonCode',
            width : '20%',
            sortable : true
        }],
        width: "auto",
        usepager:"true",
        managerName: "memberMapperManager",
        managerMethod: "getErpPersonList",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    o1.accountId = $("#accountId").val();
    $("#erpPersonTable").ajaxgridLoad(o1);
    var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      ssss.accountId = $("#accountId").val();
      $("#erpPersonTable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_unitname',
      name: 'search_unitname',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.unitname.label')}",
      value: 'erpUnitName'
    },{
      id: 'search_deptname',
      name: 'search_deptname',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.deptname.label')}",
      value: 'erpDeptName'
    },{
      id: 'search_empname',
      name: 'search_empname',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.empname.label')}",
      value: 'erpPersonName'
    },{
      id: 'search_empcode',
      name: 'search_empcode',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.empcode.label')}",
      value: 'erpPersonCode'
    }]
  });
   /* function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  } */
});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
	    var roles = new Array();
	    var boxs = $("#erpPersonTable input:checked");
	    if (boxs.length != 1) {
	    	$.alert("${ctp:i18n('voucher.plugin.cfg.chose.please')}");
	    	return false;
	    }
	    var v = $("#erpPersonTable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    return {"erpPersonId":v[0].id,"erpUnitName":v[0].erpUnitName,"erpDeptName":v[0].erpDeptName,"erpPersonName":v[0].erpPersonName,"erpPersonCode":v[0].erpPersonCode};
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv"></div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="erpPersonTable" class="flexme3" style="display: none"></table>
            <input type="hidden" id="accountId" name="accountId" value="${ctp:toHTML(accountId)}">
        </div>
    </div>
</body>
</html>