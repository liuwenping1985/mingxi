<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>showArchivesMappers</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=archivesMapperManager"></script>
<script type="text/javascript" language="javascript">

$().ready(function() {
    //列表
    var mytable = $("#mytable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.name')}",
            sortable: true,
            name: 'name',
            width: '15%'
        },
        {
            display:  "${ctp:i18n('voucher.plugin.cfg.archivesMapper.formName')}",
            sortable: true,
            name: 'formName',
            width: '20%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.tableName')}",
            sortable: true,
            name: 'tableName',
            width: '20%'
        },
        {
            display:  "${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemMapped')}",
            sortable: true,
            name: 'dataItemMapped',
            width: '20%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemTarget')}",
            sortable: true,
            name: 'dataItemTarget',
            width: '15%'          
        }
        ],
        managerName: "archivesMapperManager",
        managerMethod: "showArchivesMapperList",
        parentId:'center',        
        slideToggleBtn: true,
        vChange: true       
    });
    //加载表格
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    var searchobj = $.searchCondition({
        top: 2,
        right: 10,
        searchHandler: function() {
          s = searchobj.g.getReturnValue();        
          $("#mytable").ajaxgridLoad(s);       
        },
        conditions: [{
            id: 'search_name',
            name: 'search_name',
            type: 'input',
            text: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.name')}",
            value: 'name',
            maxLength:100
          },
        {
          id: 'search_formName',
          name: 'search_formName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.archivesMapper.formName')}",
          value: 'formName',
          maxLength:100
        }
       ]
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
	    return {"name":v[0].name,"id":v[0].id};
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