<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>ErpPersonList</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formDataMapperManager"></script>
<script type="text/javascript" language="javascript">

$().ready(function() {
    //列表
    var grid = $("#mytable").ajaxgrid({
    	colModel: [{
            display: 'id',
            name: 'formId',
            width: '10%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
        	/*表单名称*/
            display: "${ctp:i18n('voucher.plugin.cfg.formName')}",
            sortable: true,
            name: 'formName',
            width: '40%'
        },
        {
        	/*表单所属单位*/
            display: "${ctp:i18n('voucher.plugin.cfg.formUnit')}",
            sortable: true,
            name: 'formUnit',
            width: '35%'
        },
        {
        	/*表单所属人*/
            display: "${ctp:i18n('voucher.plugin.cfg.formOwner')}",
            sortable: true,
            name: 'formOwner',
            width: '15%'
        }
        ],
        width: "auto",
        managerName: "formDataMapperManager",
        managerMethod: "showFormList",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    $("#mytable").ajaxgridLoad(o1);
    var searchobj = $.searchCondition({
        top: 2,
        right: 10,
        searchHandler: function() {
          ssss = searchobj.g.getReturnValue();
          $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
          id: 'search_formName',
          name: 'search_formName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.formName')}",
          value: 'formName'
        },{
          id: 'search_formOwner',
          name: 'search_formOwner',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.formOwner')}",
          value: 'formOwner'
        },{
          id: 'search_formUnit',
          name: 'search_formUnit',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.formUnit')}",
          value: 'formUnit'
        }]
      }); 
});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
	    var roles = new Array();
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
	    return {"formId":v[0].formId,"formName":v[0].formName,"formUnit":v[0].formUnit,"formOwner":v[0].formOwner};
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv"></div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="mytable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>