<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=ucGroupManager"></script>
<head>
<script type="text/javascript">
	var baseUrl = "/seeyon/uc/rong/config.do?method=";
	var mytable;
	$().ready(function(){
				mytable = $("#mytable").ajaxgrid({
					//click : clk,
					colModel : [{
						display : 'i',
						name : 'i',
						width : '10%',
						sortable : false,
						align : 'center',
						type : 'checkbox',
					}, {
						display : "${ctp:i18n('uc.config.rong.table.groupname.js')}",
						name :'n' ,
						sortable : true,
						width : '35%',
						align : 'center'
					}, {
						display : "${ctp:i18n('uc.config.rong.table.grouplord.js')}",
						name :'cn' ,
						sortable : true,
						width : '20%',
						align : 'center'
					}, {
						display : "${ctp:i18n('uc.config.rong.table.groupdate.js')}",
						name :'cd' ,
						sortable : true,
						width : '35%',
						align : 'center'
					}],
					width : 'auto',
					parentId : "layoutCenter",
					managerName : "ucGroupManager",
					managerMethod : "getALLUcGroupInfo",
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
					toolbar : [ {
						id : "displayMember",
						name : "${ctp:i18n('uc.config.rong.btn.lookgroupmember.js')}",
						className : "ico16 modify_text_16",
						click : function() {
							displayMember();
						}
					},{
						id : "refreshCache",
						name : "${ctp:i18n('uc.config.rong.js.syn.title46.js')}",
						className : "ico16 batch_edit_16",
						click : function() {
							refreshCache();
						}
					},{
						id : "refreshAllCache",
						name : "${ctp:i18n('uc.config.rong.js.syn.title17.js')}",
						className : "ico16 quantities_new_16",
						click : function() {
							refreshAllCache();
						}
					},{
						id : "back",
						name : "${ctp:i18n('uc.button.return.js')}",
						className : "ico16 return_16",
						click : function() {
							back();
						}
					}]
				});

				//搜素栏查询
				var searchobj;
				searchobj = $.searchCondition({
					top : 7,
					right : 10,
					searchHandler : function() {
						var result = searchobj.g.getReturnValue();
						if (result) {
							loadTable1(result.condition, result.value);
						}
					},
					conditions : [{
						id : 'creatorName',
						name : 'creatorName',
						type : 'input',
						text : "${ctp:i18n('uc.config.rong.js.syn.title40.js')}",
						value : 'creatorName'
					}, {
						id : 'name',
						name : 'name',
						type : 'input',
						text : "${ctp:i18n('uc.config.rong.js.syn.title41.js')}",
						value : 'name'
					}]
				});

				//查看群成员
				function displayMember() {
					var boxs = $(".mytable").formobj({
						gridFilter : function(data, row) {
							return $("input:checked", row)[0];
						}
					});
					if (boxs.length == 0 || boxs.length > 1) {
						$.alert("${ctp:i18n('uc.config.rong.js.syn.title42.js')}")
						return;
					}
					window.location.href = "/seeyon/uc/rong/config.do?method=displayUcGroupInfoByGroupId&id=" + boxs[0].i;
				}
				//更新群成员
				function refreshCache() {
					var boxs = $(".mytable").formobj({
						gridFilter : function(data, row) {
							return $("input:checked", row)[0];
						}
					});
					if (boxs.length == 0) {
						$.alert("${ctp:i18n('uc.config.rong.js.syn.title43.js')}")
						return;
					}
					var alertObj = $.alert({
						"msg": "${ctp:i18n('uc.config.rong.js.syn.title18.js')}",
						"type": 1,
						ok_fn: function() {
							var proce = $.progressBar();
							console.log(boxs)
							var arr = new Array();
							boxs.forEach(function(t) {
								arr.push(t.i);
							});

							var method = "syncUcGroup";
							var URL = baseUrl + method;

							console.log(arr)
							$.ajax({
					            type: "POST",
					            url: URL,
					            data: {
					            	"groupIds": arr,
					            	"isAll": false
					            },
					            traditional: true,
					            success: function(json){
					            	proce.close();
							    	var jso = eval(json);
							    	if(jso[0].res == "true"){
						        		$.alert("${ctp:i18n('uc.config.rong.js.syn.title20.js')}");//更新完成，感谢您的使用！
						        	}else{
						        		$.alert("${ctp:i18n('uc.config.rong.js.syn.title21.js')}");//更新失败，请联系管理员或开发人员！
						       	 	}
						       	 	reloadtab();
							    }
					            
					    	});
						}
					});
				}
				//更新全部
				function refreshAllCache () {
					var alertObj = $.alert({
						"msg": "${ctp:i18n('uc.config.rong.js.syn.title18.js')}",
						"type": 1,
						ok_fn: function() {
							var proce = $.progressBar();
							var method = "syncUcGroup";
							var URL = baseUrl + method;
							$.ajax({
					            type: "POST",
					            url: URL,
					            data: {
					            	"isAll": true
					            },
					            traditional: true,
					            success: function(json){
					            	proce.close();
							    	var jso = eval(json);
							    	if(jso[0].res == "true"){
						        		$.alert("${ctp:i18n('uc.config.rong.js.syn.title20.js')}");//更新完成，感谢您的使用！
						        	}else{
						        		$.alert("${ctp:i18n('uc.config.rong.js.syn.title21.js')}");//更新失败，请联系管理员或开发人员！
						       	 	}
						       	 	reloadtab();
							    }
					            
					    	});
						}
					});
				}

				//返回
				function back() {
					var method = "index";
					var URL = "/seeyon/uc/config.do?method=" + method;
					window.location.href = URL;
				}

				//加载列表
				function reloadtab() {
					var o = new Object();
					//o.locale = languageinfo;
					$("#mytable").ajaxgridLoad(o);
				}
			});

	//加载列表
	function loadTable1(condition, value) {
		var o = new Object();
		o.condition = condition;
		o.value = value;
		$("#mytable").ajaxgridLoad(o);
	}
</script>
<script type="text/javascript">
</script>
</head>
</html>
