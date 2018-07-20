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
    var grid = $("#accountTable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.type')}",
            sortable: true,
            name: 'type',
            width: '30%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}",
            sortable: true,
            name: 'name',
            width: '30%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.code')}",
            sortable: true,
            name: 'code',
            width: '30%'
        }      
        ],
        width: "auto",
        managerName: "accountCfgManager",
        managerMethod: "showAccountCfgList",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    $("#accountTable").ajaxgridLoad(o1);
    var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      $("#accountTable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_type',
      name: 'search_type',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.type')}",
      value: 'type'
    },{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}",
      value: 'name'
    },{
        id: 'search_code',
        name: 'search_code',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.code')}",
        value: 'code'
      }]
  });
});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
	    var boxs = $("#accountTable input:checked");
	    if (boxs.length != 1) {
	    	$.alert("${ctp:i18n('voucher.plugin.cfg.chose.please')}");
	    	return false;
	    }
	    var v = $("#accountTable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    return {"accountId":v[0].id,"accountName":v[0].name,"isSupportBooks":v[0].isSupportBooks,"bookCode":v[0].bookCode,"bookName":v[0].bookName,"entityName":v[0].extAttr1,"type":v[0].type};
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv"></div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="accountTable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>