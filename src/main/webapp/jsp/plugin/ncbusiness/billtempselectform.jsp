<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>BillTempForm</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=ncBusiBindManager"></script>
<script type="text/javascript" language="javascript">

//请勿轻易修改这个变量不仅批量关闭窗口用，角色回填也需要回传值
$().ready(function() {
    //列表
    var grid = $("#accountTempTable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            align: 'center',
            type: 'checkbox'
        },
        {
            display : "${ctp:i18n('ncbusinessplatform.business.band.templatecode')}",
            name : 'templateCode',
            width : '20%'
        }
        ,
        {
            display : "${ctp:i18n('ncbusinessplatform.business.band.billtempname')}",
            name : 'formName',
            width : '20%'
        }
        , 
        {
            display : "${ctp:i18n('ncbusinessplatform.business.band.formname')}",
            name : 'templateName',
            width : '20%'
        },
        
        {
            display : "${ctp:i18n('ncbusinessplatform.business.band.accountname')}",
            name : 'accountName',
            width : '20%'
        }
        ,
        {
            display : "${ctp:i18n('ncbusinessplatform.business.band.templatetitle')}",
            name : 'templateTitle',
            width : '20%'
        },
         {
            display : "${ctp:i18n('ncbusinessplatform.business.band.templateid')}",
            name : 'templateId',
            width : '10%',
           	hide : true
        },
        {
            display : "${ctp:i18n('ncbusinessplatform.business.band.formid')}",
            name : 'formId',
            width : '10%',
           	hide : true
        }
        ,
        {
            display : "${ctp:i18n('ncbusinessplatform.business.band.accountid')}",
            name : 'accountId',
            width : '10%',
           	hide : true
        }		
        	
        ],
        width: "auto",
        managerName: "ncBusiBindManager",
        managerMethod: "getBillTempList",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    $("#accountTempTable").ajaxgridLoad(o1);


    var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      $("#accountTempTable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_code',
      name: 'search_code',
      type: 'input',
      text: "${ctp:i18n('ncbusinessplatform.business.band.templatecode')}",
      value: 'templateCode'
    },{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('ncbusinessplatform.business.band.formname')}",
      value: 'templateName'
    }]
  });
   function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }
});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
	    var roles = new Array();
	    var boxs = $("#accountTempTable input:checked");
	    var v = $("#accountTempTable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    if (boxs.length >= 1) {
		    	boxs.each(function() {
	            var obj = new Array;
		        
			    obj[0]=v[0].formName;
			    obj[1]=v[0].templateCode;
			    obj[2]=v[0].templateName;
			    obj[3]=v[0].accountName;
			    obj[4]=v[0].templateId;
			    obj[5]=v[0].accountId;
			    obj[6]=v[0].formId;
			    roles.push(obj);
        	});
	    }

	    return roles;
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv"></div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="accountTempTable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>