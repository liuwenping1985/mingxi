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
            name: 'id',
            width: '10%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
        	/*主重表*/
            display: "${ctp:i18n('voucher.formmapper.maintable')}",
            sortable: true,
            name: 'fieldType',
            width: '20%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.voucher.util.MainTable',query:'true'"
        },
        {
        	/*字段名称*/
            display: "${ctp:i18n('voucher.formmapper.fielddisplay')}",
            sortable: true,
            name: 'fieldDisplay',
            width: '40%'
        },
        {
        	/*字段所属表*/
            display: "${ctp:i18n('voucher.formmapper.tableName')}",
            sortable: true,
            name: 'tableName',
            width: '30%'
        }
        ],
        width: "auto",
        managerName: "formDataMapperManager",
        managerMethod: "showFormFieldList",
        parentId: 'center'
    });
    //加载表格
    var o = new Object();
    o.formId = $("#formId").val();
    o.isHead = $("#isHead").val();
    $("#mytable").ajaxgridLoad(o);
    var searchobj = $.searchCondition({
        top: 2,
        right: 10,
        searchHandler: function() {
          s = searchobj.g.getReturnValue();
          s.formId = $("#formId").val();
          s.isHead = $("#isHead").val();
          $("#mytable").ajaxgridLoad(s);
        },
        conditions: [{
          id: 'search_fieldType',
          name: 'search_fieldType',
          type: 'select',
          text: "${ctp:i18n('voucher.formmapper.maintable')}",
          value: 'fieldType',
          codecfg: "codeType:'java',codeId:'com.seeyon.apps.voucher.util.MainTable'"
        },{
          id: 'search_fieldDisplay',
          name: 'search_fieldDisplay',
          type: 'input',
          text: "${ctp:i18n('voucher.formmapper.fielddisplay')}",
          value: 'fieldDisplay'
        },{
          id: 'search_tableName',
          name: 'search_tableName',
          type: 'input',
          text: "${ctp:i18n('voucher.formmapper.tableName')}",
          value: 'tableName'
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
	    return {"fieldDisplay":v[0].fieldDisplay,"tableName":v[0].tableName};
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
            <input type="hidden" id="formId" name="formId" value="${ctp:toHTML(formId)}"/>
            <input type="hidden" id="isHead" name="isHead" value="${ctp:toHTML(isHead)}"/>
        </div>
    </div>
</body>
</html>