<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>ErpPersonList</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=registerManager"></script>
<script type="text/javascript" language="javascript">

$().ready(function() {
    //列表
    var mytable = $("#mytable").ajaxgrid({
        /* click: gridclk,       
        dblclick:griddbclick,   */   
        render : rend,
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        colModel: [
       {
    	 display:"id",
         name: 'id',
         width: '5%',
         sortable: true,
         type: 'checkbox'
       }, 
       {
         display: "${ctp:i18n('cip.base.instance.code')}",
         name: 'appCode',
         width: '20%',
         sortable: true
       }, 
         {
             display: "${ctp:i18n('cip.base.register.product')}",
             name: 'productCode',
             width: '20%',
             sortable: true
            }, 
            {
                display: "${ctp:i18n('cip.base.form.product.version')}",
                sortable: true,
                name: 'versionNO',
                width: '10%'
            },
        {
            display: "${ctp:i18n('cip.base.instance.introduce')}",
            sortable: true,
            name: 'introduction',
            width: '15%'
        },
        {
            display: "${ctp:i18n('cip.base.instance.addr')}",
            sortable: true,
            name: 'addr',
            width: '20%'
        }
        ],
        managerName: "registerManager",
        managerMethod: "listRegister",
        parentId:'center',
    });
    function rend(txt, data, r, c) {
	
	if (data.addr!=null&& c == 5) {
				return escapeStringToHTML(unescape(txt));
			} else {
				return txt;
			}
		}
		var o = new Object();
		$("#mytable").ajaxgridLoad(o);
		var searchobj = $.searchCondition({
			top : 2,
			right : 10,
			searchHandler : function() {
				ssss = searchobj.g.getReturnValue();
				$("#mytable").ajaxgridLoad(ssss);
			},
			conditions : [ {
				id : 'productCodes',
				name : 'product_code',
				type : 'input',
				text : "${ctp:i18n('cip.base.register.product')}",
				value : 'product_code'
			}, {
				id : 'systemCodes',
				name : 'app_code',
				type : 'input',
				text : "${ctp:i18n('cip.base.instance.code')}",
				value : 'app_code'
			}, {
				id : 'introduction',
				name : 'introduction',
				type : 'input',
				text : "${ctp:i18n('cip.base.instance.introduce')}",
				value : 'introduction'
			} ]
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
	    return {"sysId":v[0].id,"systemCode":v[0].appCode,"productCode":v[0].productCode,"productVersion":v[0].versionNO};
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