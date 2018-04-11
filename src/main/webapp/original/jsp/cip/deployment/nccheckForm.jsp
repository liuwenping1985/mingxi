<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>

<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 37px;
        top: 0px;
    }
    .stadic_footer_height{
        height:37px;
    }
    .background{
     background-color:#777;  
    }
</style>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=ncCheckManager"></script>
<script type="text/javascript">
$().ready(function() {
  var tt = $("#toolbar").toolbar({
            toolbar: [{
                id: "transmit",
                name: "${ctp:i18n('cip.deployment.check')}",
                className: "ico16",//设置图标
                click:function(){
                //alert("1111");
                      mytable11()
                    }
            }]
        });
	});
    
</script>
<script type="text/javascript">
var mytable11=function(){
//加载表单 
	var mytable = $("#mytable").ajaxgrid(
		
		{	
		
		render: rend,
		colModel : [
					{	display : "${ctp:i18n('cip.deployment.code')}",
						sortable : true,
						name : 'code',
						width : '10%'
					},
					{	display : "${ctp:i18n('cip.deployment.IntegratedType')}",
						sortable : true,
						name : 'IntegratedType',
						width : '15%'
					},
					{	display : "${ctp:i18n('cip.deployment.checkType')}",
						sortable : true,
						name : 'checkType',
						width : '15%'
					} ,
					{	display : "${ctp:i18n('cip.deployment.ItemName')}",
						sortable : true,
						name : 'ItemName',
						width : '15%'
					},
					{	display : "${ctp:i18n('cip.deployment.ErrorDescription')}",
						sortable : true,
						name : 'ErrorDescription',
						width : '15%'
					},
					{	display : "${ctp:i18n('cip.deployment.Result')}",
						sortable : true,
						name : 'Result',
						width : '15%'
					},
					{	display : "${ctp:i18n('cip.deployment.CheckDate')}",
						sortable : true,
						name : 'CheckDate',
						width : '15%'
					}],
			managerName : "ncCheckManager",
			managerMethod : "listCheckItem",
			usepager:false,
			resizable:false,
			parentId : 'center',
			vChangeParam : {
				overflow : 'hidden',
				position : 'relative'
			},
			vChange : true
		});
		var o = new Object();
		 $("#mytable").ajaxgridLoad(o);

}

function rend(txt, data, r, c) {
			if (c == 5) {
				if(txt=="通过"){
				return   "<font color='green'>" +txt+'</font>'
			} else{
				return   "<font color='red'>" +txt+'</font>'
		  }
		  } else return txt;
		  }

</script>

</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" layout="height:48,sprit:false,border:false">      
			<div id="toolbar"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:false"
			id="center">
			<table id="mytable" class="flexme3" border="0" cellspacing="0"
				cellpadding="0"></table>
		</div>
	</div>
</body>


</html>