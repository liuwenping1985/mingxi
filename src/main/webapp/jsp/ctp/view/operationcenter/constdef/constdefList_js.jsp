<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=constDefManager"></script>
<script type="text/javascript">
	var constDefManager = new constDefManager();
	var msg = '${ctp:i18n("info.totally")}';
	$().ready(
			function() {
				;
				var mytable = $("#mytable").ajaxgrid({
					/* click : clk, */
					colModel : [ {
						display : 'id',
						name : 'id',
						width : '5%',
						sortable : false,
						align : 'center',
						type : 'checkbox'
					}, {
						display : "常量名",
						name : 'constKey',
						sortable : true,
						width : '10%'
					},

					{
						display : "常量定义",
						name : 'constDefine',
						sortable : true,
						width : '20%'
					},

					{
						display : "常量类型",
						name : 'constType',
						sortable : true,
						width : '10%',
					},

					{
						display : "常量值",
						name : 'constValue',
						sortable : true,
						width : '25%',
					},

					{
						display : "常量描述",
						name : 'constDescription',
						sortable : true,
						width : '30%',
					} ],
					width : 'auto',
					parentId : "roleList_stadic_body_top_bottom",
					//height:$("#layoutCenter").height()-65,
					managerName : "constDefManager",
					managerMethod : "listPage",
					vChangeParam : {
						overflow : "auto"
					},
					slideToggleBtn : true,
					showTableToggleBtn : true,
					vChange : true,
					callBackTotle : getCount

				});
				reloadtab();
				var searchobj;
				var ver = "";
				//搜素栏查询
				searchobj = $.searchCondition({
					top : 2,
					right : 10,
					searchHandler : function() {
						var result = searchobj.g.getReturnValue();
						if (result) {
							refreshTable(result.condition, result.value);
						}
					},
					conditions : [ {
						id : 'constkey',
						name : 'constkey',
						type : 'input',
						text : "常量名",
						value : 'constkey'
					} ]
				});
				// 工具栏
				var toolbar = $("#toolbar").toolbar({
					toolbar : [ {
						id : "create",
						name : "创建",
						className : "ico16",
						click : function() {
							newConstDef();
						}
					}, {
						id : "modify",
						name : "修改",
						className : "ico16 editor_16",
						click : function() {
							modifyConstDef();
						}
					}, {
						id : "delinfo",
						name : "删除",
						className : "ico16 search_16",
						click : function() {
							deleteConstDef();
						}
					} ]
				});

				//新建
				function newConstDef() {
					if (typeof opendialog != "undefined") {
						opendialog.getDialog();
						opendialog.autoMinfn();
						return;
					}
					var dialog = $.dialog({
						url : _ctxPath + '/constDef.do?method=newConstDefPage',
						width : 400,
						height : 340,
						isDrag : false,
						title : "创建",
						targetWindow : getCtpTop(),
						buttons : [
								{
									id : "btnok",
									text : "${ctp:i18n('common.button.ok.label')}",
									handler : function() {

										var def = dialog.getReturnValue();
										if (def == undefined) {
											return;
										}

										var constDef = new Object();

										constDef.constKey = def.constKey;
										constDef.constDefine = def.constDefine;
										constDef.constDescription = def.constDescription;
										constDef.constType = def.constType;

										$.ajax({
											type : "GET",
											url : _ctxPath + '/constDef.do?method=newConstDef&constKey=' + encodeURI(constDef.constKey)
													+ '&constDefine=' + encodeURI(constDef.constDefine) 
													+ '&constDescription=' + encodeURI(constDef.constDescription) 
													+ '&constType=' + encodeURI(constDef.constType) 
													,
											success : function(result) {

												if (result.error == 'ok') {
													// 手动加载表格数据
													reloadtab();
													dialog.close();
												} else {
													$.alert("创建常量异常:" + result.error);
												}
											}
										});
									}
								}, {
									id : "btncancel",
									text : "${ctp:i18n('systemswitch.cancel.lable')}",
									handler : function() {
										dialog.close();
									}
								} ]
					});
					opendialog = dialog;
				}

				//修改
				function modifyConstDef() {
					var boxs = $(".mytable").formobj({
						gridFilter : function(data, row) {
							return $("input:checkbox", row)[0].checked;
						}
					});
					if (boxs.length === 0) {
						$.alert("请勾选列表项");
						return;
					} else if (boxs.length > 1) {
						$.alert("只能选择一个编辑");
						return;
					}
					var id = boxs[0].id;
					var dialog = $.dialog({
						url : _ctxPath + '/constDef.do?method=modifyConstDefPage&id=' + id,
						width : 400,
						height : 340,
						isDrag : true,
						targetWindow : getCtpTop(),
						title : "修改",
						buttons : [
								{
									id : "btnok",
									text : "${ctp:i18n('common.button.ok.label')}",
									handler : function() {

										var def = dialog.getReturnValue();
										if (def == undefined) {
											return;
										}

										var constDef = new Object();

										constDef.constId = def.constId;
										constDef.constKey = def.constKey;
										constDef.constDefine = def.constDefine;
										constDef.constDescription = def.constDescription;
										constDef.constType = def.constType;

										$.ajax({
											type : "GET",
											url : _ctxPath + '/constDef.do?method=modifyConstDef&id=' + constDef.constId
													+ '&constKey=' + encodeURI(constDef.constKey) 
													+ '&constDefine=' + encodeURI(constDef.constDefine) 
													+ '&constDescription=' + encodeURI(constDef.constDescription) 
													+ '&constType=' + encodeURI(constDef.constType) 
													,
											success : function(result) {
												
												if (result.error == 'ok') {
													// 手动加载表格数据
													reloadtab();
													dialog.close();
												} else {
													$.alert("修改常量异常:" + result.error);
												}
											}
										});
										
									}
								}, {
									id : "btncancel",
									text : "${ctp:i18n('systemswitch.cancel.lable')}",
									handler : function() {
										dialog.close();
									}
								} ]

					});
				}

				//获取选中
				function getTableChecked() {
					return $(".mytable").formobj({
						gridFilter : function(data, row) {
							return $("input:checkbox", row)[0].checked;
						}
					});
				}

				//删除
				function deleteConstDef() {
					var constDef = [];
					var v = getTableChecked();
					if (v.length === 0) {
						$.alert("请勾选列表项");
						return;
					} else {
						var checkResult = true;
						$(v).each(function(index, domEle) {
							constDef.push(domEle.id);
						});
						if (!checkResult)
							return;
						$.confirm({
							'msg' : "确认删除?",
							ok_fn : function() {
								
								$.ajax({
									type : "GET",
									url : _ctxPath + '/constDef.do?method=deleteConstDef&id=' + constDef,
									success : function(result) {
										if (result.error == 'ok') {
											// 手动加载表格数据
											reloadtab();
										} else {
											$.alert("删除常量异常:" + result.error);
										}
									}
								});
							
							},
							cancel_fn : function() {
							}
						});
					}
				}

				//获取总条目数
				function getCount() {
					cnt = mytable.p.total;
					$("#count").get(0).innerHTML = msg.format(cnt);
				}

				//加载列表
				function reloadtab() {
					var o = new Object();
					$("#mytable").ajaxgridLoad(o);
				}

				//按条件加载列表
				function refreshTable(condition, value) {
					var o = new Object();
					if (condition) {
						if (condition == "constKey") {
							o.constKey = value;
						}
						/* else if (condition == "loginName") {
							o.loginName = value;
						} else if (condition == "enabled") {
							o.enabled = value;
						} */
					}
					$("#mytable").ajaxgridLoad(o);
				}
			});
</script>