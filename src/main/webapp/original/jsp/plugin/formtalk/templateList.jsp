<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formtalkMapperManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
    var grid = $("#templateTable").ajaxgrid({
        colModel: [{
        	 display : "id",
            name: 'templateId',
            width: '10%',
            align: 'center',
            type: 'radio',
            sortable: true
        }, 
        {
            display : "${ctp:i18n('formtalk.module.name')}",
            name : 'templateSubject',
            width : '20%',
            sortable: true
        },{
          display : "${ctp:i18n('formtalk.module.code')}",
          name : 'templateNumber',
          width : '10%',
          sortable: true
      },{
        display : "${ctp:i18n('formtalk.module.account')}",
        name : 'accountName',
        width : '30%',
        sortable: true
    }
        ],
        managerName: "formtalkMapperManager",
        managerMethod: "viewTemplateList",
        parentId: 'center',
        slideToggleBtn:false,
        vChangeParam: {
          overflow: "hidden",
          autoResize:true
      }
    });
    //加载表格
    var o1 = new Object();
    $("#templateTable").ajaxgridLoad(o1);

    var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      $("#templateTable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'templateName',
      name: 'templateName',
      type: 'input',
      text: "${ctp:i18n('formtalk.module.name')}",
      value: 'templateName'
    },{
      id: 'templateCode',
      name: 'templateCode',
      type: 'input',
      text: "${ctp:i18n('formtalk.module.code')}",
      value: 'templateCode'
    }]
  });
});
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv"></div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="templateTable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>