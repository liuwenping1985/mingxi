<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=ucRongManager"></script>
<head>
<script type="text/javascript">
	var baseUrl = "/seeyon/uc/rong/config.do?method=";
	var mytable;
	$().ready(function(){
				mytable = $("#mytable").ajaxgrid({
					//click : clk,
					colModel : [{
						display : 'id',
						name : 'id',
						width : '20%',
						sortable : false,
						align : 'center',
						type : 'checkbox',
					}, {
						display : "${ctp:i18n('uc.config.rong.table.membername.js')}",
						name :'name' ,
						sortable : true,
						width : '80%',
						align : 'center'
					}],
					width : 'auto',
					parentId : "layoutCenter",
					managerName : "ucRongManager",
					managerMethod : "getALLUcToken",
					vChangeParam : {
						overflow : "auto"
					},
					slideToggleBtn : true,
					showTableToggleBtn : true,
					vChange : true,
					resizable:true,
					slideToggleBtn:"bool"
				});

				reloadtab();

				// 工具栏
				var toolbar = $("#toolbar").toolbar({
					toolbar : [{
						id : "back",
						name : "${ctp:i18n('uc.button.return.js')}",
						className : "ico16 return_16",
						click : function() {
							back();
						}
					}]
				});

				//返回
				function back() {
					var method = "displayUcGroupInfoList";
					var URL = baseUrl + method;
					window.location.href = URL;
				}

				//加载列表
				function reloadtab() {
					var o = new Object();
					o.memberId = "${memberId}";
					//o.locale = languageinfo;
					$("#mytable").ajaxgridLoad(o);
				}
			});

</script>
<script type="text/javascript">
</script>
</head>
</html>
