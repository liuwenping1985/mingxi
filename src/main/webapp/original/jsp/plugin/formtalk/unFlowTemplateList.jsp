<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formtalkMapperManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
    var grid = $("#formTable").ajaxgrid({
        colModel: [
                   {
                	   display : "id",
                     name : 'formId',
                     width : '5%',
                     type: 'radio',
                     align: 'center',
                     sortable: true
                 },
        {
            display : "${ctp:i18n('formtalk.module.form.name')}",
            name : 'formName',
            width : '20%'
        }, {
            display : "${ctp:i18n('formtalk.module.form.code')}",
            name : 'formCode',
            width : '10%'
        },	
        {
            display : "${ctp:i18n('formtalk.module.form.owner')}",
            name : 'formOwner',
            width : '20%'
        },
        {
            display : "${ctp:i18n('formtalk.module.form.owner.account')}",
            name : 'formAccountName',
            width : '30%'
        }
        ],
        managerName: "formtalkMapperManager",
        managerMethod: "viewUNFlowList",
        parentId: 'center',
        slideToggleBtn:false,
        vChangeParam: {
          overflow: "hidden",
          autoResize:true
      }
    });
    //加载表格
    var o1 = new Object();
    o1.formType="${param.formType}";
    $("#formTable").ajaxgridLoad(o1);

    var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      ssss.formType="${param.formType}";
      $("#formTable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'templateName',
      name: 'templateName',
      type: 'input',
      text: "${ctp:i18n('formtalk.module.form.name')}",
      value: 'templateName'
    },{
      id: 'templateCode',
      name: 'templateCode',
      type: 'input',
      text: "${ctp:i18n('formtalk.module.form.code')}",
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
            <table id="formTable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>