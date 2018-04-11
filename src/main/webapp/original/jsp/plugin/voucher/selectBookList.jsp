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
    var grid = $("#accountBookTable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            align: 'center',
            type: 'checkbox'
        },
        {
            display : "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.name')}",
            name : 'name',
            width : '30%'
        }
        ,
        {
            display : "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.code')}",
            name : 'code',
            width : '30%'
        }
        , 
        {
            display : "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.entityName')}",
            name : 'entityName',
            width : '30%'
        }
        ,
        {
            display : "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.entityCode')}",
            name : 'entityCode',
            width : '10%',
           	hide : true
        }		
        	
        ],
        width: "auto",
        managerName: "accountCfgManager",
        managerMethod: "showBookList",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    o1.id=$("#accountId").val();
    o1.dbDrive=$("#dbDrive").val();
    o1.dbURL=$("#dbURL").val();
    o1.dbUser=$("#dbUser").val();
    o1.dbPwd=$("#dbPwd").val();
    o1.type=$("#type").val();
    $("#accountBookTable").ajaxgridLoad(o1);
    var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      ssss.id=$("#accountId").val();
      ssss.dbDrive=$("#dbDrive").val();
      ssss.dbURL=$("#dbURL").val();
      ssss.dbUser=$("#dbUser").val();
      ssss.dbPwd=$("#dbPwd").val();
      ssss.type=$("#type").val();
      $("#accountBookTable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.name')}",
      value: 'name'
    },{
      id: 'search_code',
      name: 'search_code',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.code')}",
      value: 'code'
    },{
        id: 'search_entityName',
        name: 'search_entityName',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.entityName')}",
        value: 'entityName'
      }]
  });
});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
	    var boxs = $("#accountBookTable input:checked");
	    var v = $("#accountBookTable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    
	    if (boxs.length <= 0) {
	    	$.alert("${ctp:i18n('voucher.plugin.cfg.accountCfg.book.selectone')}");
	    	return false;
	    }else if(boxs.length > 1){
	    	$.alert("${ctp:i18n('voucher.plugin.cfg.accountCfg.book.selectmustone')}");
	    	return false;
	    }else{
	    	return {"name":v[0].name,"code":v[0].code,"entityName":v[0].entityName};
	    }
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv">
	        <input type="hidden" id="accountId" name="accountId" value="${accountId}">
	        <input type="hidden" id="dbDrive" name="dbDrive" value="${dbDrive}">
            <input type="hidden" id="dbURL" name="dbURL" value="${dbURL}">
            <input type="hidden" id="dbUser" name="dbUser" value="${dbUser}">
            <input type="hidden" id="dbPwd" name="dbPwd" value="${dbPwd}">
            <input type="hidden" id="type" name="type" value="${type}">
	        </div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="accountBookTable" class="flexme3" style="display: none">
            </table>
        </div>
    </div>
</body>
</html>