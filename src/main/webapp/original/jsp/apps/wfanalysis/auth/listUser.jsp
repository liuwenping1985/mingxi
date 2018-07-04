<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<title>${ctp:i18n('wfanalysis.auth.type.user')}</title>
</head>
<script type="text/javascript">
$(document).ready(function() {
  	// 定义页面表格上方的菜单项
 	$("#toolbar").toolbar({
	  toolbar : [ {
	      id : "add",
	      name : "${ctp:i18n('wfanalysis.auth.user.new')}",
	      className : "ico16",
	      click : add
	    }, {
	      id : "edit",
	      name : "${ctp:i18n('wfanalysis.auth.user.edit')}",
	      className : "ico16 editor_16",
	      click : edit
	    }, {
	      id : "delete",
	      name : "${ctp:i18n('wfanalysis.auth.user.delete')}",
	      className : "ico16 del_16",
	      click : remove
	    } ]
	});

  	// 定义表格数据
  	var userAuth = $("#userAuth").ajaxgrid({
	  	click: click,
  		colModel : [{
	        display : 'authId',
	        name : 'authId',
	        width : '5%',
	        align : 'center',
	        type : 'checkbox'
    	},{
		    display : "${ctp:i18n('wfanalysis.auth.user.label.orgentName')}",
		    name : 'orgentDisplayName',
		    width : '35%'
		},{
			display : "${ctp:i18n('wfanalysis.auth.user.label.templateName')}",
			name : 'templateNames',
			width : '55%'
		}],
    	managerName : "wfAnalysisAuthManager",
    	managerMethod : "findWfUserAuths",
    	showTableToggleBtn: false,
    	parentId: $('.layout_center').eq(0).attr('id'),
    	slideToggleBtn: true,
    	vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        }
  	});
  	loadGridData();
  	
  	//加载Grid数据
  	function loadGridData(option){
  		option = option || {};
  		$("#userAuth").ajaxgridLoad(option);
  	}
  	//单击事件
  	function click(data, r, c) {
  		$("#authDetail").attr("src", "${path}/wfanalysisAuth.do?method=userAuth&from=view&authId=" + data.authId);
  		userAuth.grid.resizeGridUpDown("middle");
  	}
  	//新增用户授权
  	function add() {
  		$("#authDetail").attr("src", "${path}/wfanalysisAuth.do?method=userAuth&from=add");
  		userAuth.grid.resizeGridUpDown("middle");
  	}
  	//编辑用户授权
  	function edit() {
  		var checkedRows = getCheckedData();
  	    if (checkedRows == undefined || checkedRows.length == 0) {
  	    	$.alert("${ctp:i18n('wfanalysis.auth.user.dialog.choseEdit')}");
  	    	return;
  	    } else if (checkedRows.length > 1) {
  	    	$.alert("${ctp:i18n('wfanalysis.auth.user.dialog.tooMuchEdit')}");
  	    	return;
  	    } else {
  	    	$("#authDetail").attr("src", "${path}/wfanalysisAuth.do?method=userAuth&from=edit&authId=" + checkedRows[0].authId);
  	  		userAuth.grid.resizeGridUpDown("middle");
  	    }
  	}
	//删除用户授权
	function remove() {
		var checkedRows = getCheckedData();
		if (checkedRows == undefined || checkedRows.length == 0) {
			$.alert("${ctp:i18n('wfanalysis.auth.user.dialog.choseDelete')}");
  	    	return;
		}
		var confirm = $.confirm({
			'msg': "${ctp:i18n('wfanalysis.auth.user.dialog.promptDelete')}",
			ok_fn: function(){
				var deleteAuthIds = [];
				for ( var i = 0; i < checkedRows.length; i++) {
					deleteAuthIds.push(checkedRows[i].authId);
		        }
				var proce = getCtpTop().$.progressBar({
			          text : "${ctp:i18n('wfanalysis.auth.user.dialog.deleting')}"
			    });
				var wf = new wfAnalysisAuthManager(); //ajax对象
				wf.deleteWfUserAuths(deleteAuthIds, {
					success: function(ret){
						if (ret) {
							loadGridData();
							proce.close();
							//OA-97735流程绩效授权设置，查看授权信息时，删除授权，下方的具体信息没有同时刷新
							userAuth.grid.resizeGridUpDown("down");
							$("#authDetail").attr("src", "${path}/wfanalysisAuth.do?method=userAuth&from=view");
						} else { //平台对于未登录的ajax操作返回竟然200
							proce.close();
							$.alert('删除失败，请检查OA登录是否正常！');
						}
					},
					error : function(request, settings, e){
						var responseText = request.responseText;
						if (responseText) {
							try{
								$.alert(JSON.parse(responseText).message);
							} catch(e1){ //已掉线
								$("body").append(request.responseText);
							}
						}
					}
				});
			}
		});
	}
	//获取记录
  	function getCheckedData() {
    	var checkedData = $("#userAuth").formobj({
    		gridFilter : function(data, row) {return $("input:checkbox", row)[0].checked;}
    	});
    	return checkedData;
  	}
});
</script>
<body class="h100b over_hidden page_color">
	<div id='layout' class="comp page_color" comp="type:'layout'">
		<%-- 工具栏 --%>
	    <div class="layout_north" layout="height:40,sprit:false,border:false">
	        <div id="toolbar"></div>
	    </div>
    	<div class="layout_center page_color " layout="border:false" style="overflow:hidden">
        	<%-- grid表格 --%>
        	<table id="userAuth" style="display: none;"></table>
	        <div id="grid_detail">
	        	<iframe id="authDetail" src="${path }/wfanalysisAuth.do?method=userAuth&from=view" width="100%" height="100%" frameborder="0"></iframe>
	        </div>
    	</div>
	</div>
</body>
</html>