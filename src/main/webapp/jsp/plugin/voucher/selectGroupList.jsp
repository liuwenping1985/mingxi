<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<title>选择账簿</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=accountCfgManager"></script>
<script type="text/javascript" language="javascript">

//请勿轻易修改这个变量不仅批量关闭窗口用，角色回填也需要回传值
$().ready(function() {
    //列表
    var grid = $("#mytable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'pkGroup',
            width: '10%',
            align: 'center',
            type: 'checkbox'
        },
        {
            display : "${ctp:i18n('voucher.plugin.group.name')}",
            name : 'groupName',
            width : '50%'
        }
        ,
        {
            display : "${ctp:i18n('voucher.plugin.group.code')}",
            name : 'groupCode',
            width : '40%'
        }
        ],
        width: "auto",
        managerName: "accountCfgManager",
        managerMethod: "showGroupList",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    o1.accountId=$("#accountId").val();
    $("#mytable").ajaxgridLoad(o1);
    var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      s = searchobj.g.getReturnValue();
      s.accountId=$("#accountId").val();
      $("#mytable").ajaxgridLoad(s);
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.group.name')}",
      value: 'groupName'
    },{
      id: 'search_code',
      name: 'search_code',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.group.code')}",
      value: 'groupCode'
    }]
  });
});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
     var boxs = $("#mytable input:checked");
	 if (boxs.length != 1) {
	    $.alert("${ctp:i18n('voucher.plugin.cfg.chose.please')}");
	    return false;
	 }
	 var v = $("#mytable").formobj({
	    gridFilter: function(data, row) {
	        return $("input:checkbox", row)[0].checked;
	    }
	 });
	 return v[0];
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv">
	        </div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="mytable" class="flexme3" style="display: none">
            </table>
            <input type="hidden" id="accountId" name="accountId" value="${accountId}">
        </div>
    </div>
</body>
</html>