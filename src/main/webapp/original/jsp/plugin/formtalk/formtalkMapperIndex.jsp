<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=formtalkMapperManager"></script>
<script type="text/javascript">
	$()
			.ready(
					function() {
						var searchobj = $
								.searchCondition({
									top : 2,
									right : 10,
									searchHandler : function() {
										ssss = searchobj.g.getReturnValue();
										$("#mytable").ajaxgridLoad(ssss);
									},
									conditions : [
											{
												id : 'transType',
												name : 'transType',
												type : 'select',
												codecfg : "codeType:'java',codeId:'com.seeyon.apps.formtalk.util.FormtalkTransTypeEnum'",
												text : "${ctp:i18n('formtalk.column.transType')}",
												value : 'transType'
											},
											{
												id : 'connectFormtalkName',
												name : 'connectFormtalkName',
												type : 'input',
												text : "${ctp:i18n('formtalk.column.formtalk.name')}",
												value : 'connectFormtalkName'
											},
											{
												id : 'formtalkId',
												name : 'formtalkId',
												type : 'input',
												text : "${ctp:i18n('formtalk.column.formname')}",
												value : 'formtalkId'
											},
											{
												id : 'formType',
												name : 'formType',
												type : 'select',
												codecfg : "codeType:'java',codeId:'com.seeyon.apps.formtalk.util.FormtalkMapperEnum'",
												text : "${ctp:i18n('formtalk.column.type')}",
												value : 'formType'
											},
											{
												id : 'createTime',
												name : 'createTime',
												type : 'datemulti',
												text : "${ctp:i18n('formtalk.createdate')}",
												value : 'createTime',
												ifFormat : '%Y-%m-%d',
												dateTime : false
											} ]
								});
						$("#toolbar")
								.toolbar(
										{
											toolbar : [
													{
														id : "add",
														name : "${ctp:i18n('common.toolbar.new.label')}",
														className : "ico16",
														click : function() {
															var dialog = getA8Top().$
																	.dialog({
																		url : "${path}/genericController.do?ViewPage=plugin/formtalk/templateIndex",
																		width : 800,
																		height : 450,
																		title : "${ctp:i18n('formtalk.column.select.module')}",
																		buttons : [
																				{
																					text : "${ctp:i18n('common.button.ok.label')}",
																					handler : function() {
																						var template = dialog
																								.getReturnValue();
																						dialog
																								.close();
																						if (template == false) {
																							$
																									.alert("${ctp:i18n('formtalk.alert.tip.one')}");
																							return;
																						}
																						var dialog1 = getA8Top().$
																								.dialog({
																									url : "${path}/formtalkFormMapperController.do?method=mapper&templateId="
																											+ template.templateId
																											+ "&formType="
																											+ template.formType,
																									width : 1000,
																									height : 600,
																									title : "${ctp:i18n('formtalk.mapper.title')}",
																									buttons : [
																											{
																												text : "${ctp:i18n('common.button.ok.label')}",
																												handler : function() {
																													var rv = dialog1
																															.getReturnValue();
																													if (rv != false) {

																														var formtalkMgr = new formtalkMapperManager();
																														formtalkMgr
																																.saveMapper(
																																		rv,
																																		{
																																			success : function() {
																																				$(
																																						"#mytable")
																																						.ajaxgridLoad(
																																								o);
																																				dialog1
																																						.close();
																																			}
																																		});
																													}
																												}
																											},
																											{
																												text : "${ctp:i18n('common.button.cancel.label')}",
																												handler : function() {
																													dialog1
																															.close();
																												}
																											} ]
																								});

																					}
																				},
																				{
																					text : "${ctp:i18n('common.button.cancel.label')}", //取消
																					handler : function() {
																						dialog
																								.close();
																					}
																				} ]
																	});
														}
													},
													{
														id : "modify",
														name : "${ctp:i18n('common.button.modify.label')}",
														className : "ico16 editor_16",
														click : modify
													},
													{
														id : "delete",
														name : "${ctp:i18n('common.button.delete.label')}",
														className : "ico16 del_16",
														click : function() {
															var v = $(
																	"#mytable")
																	.formobj(
																			{
																				gridFilter : function(
																						data,
																						row) {
																					return $(
																							"input:checkbox",
																							row)[0].checked;
																				}
																			});
															if (v.length < 1) {
																$
																		.alert("${ctp:i18n('level.delete')}");
															} else {
																$
																		.confirm({
																			'msg' : "${ctp:i18n('common.isdelete.label')}",
																			ok_fn : function() {
																				var formtalkMgr = new formtalkMapperManager();
																				formtalkMgr
																						.deleteMapperPO(
																								v,
																								{
																									success : function() {
																										$(
																												"#mytable")
																												.ajaxgridLoad(
																														o);
																									}
																								});
																			}
																		});
															}

														}
													},
													{
														id : "copy",
														name : "${ctp:i18n('formtalk.toolbar.copy.label')}",
														className : "ico16 filing_16",
														click : function() {
															var v = $(
																	"#mytable")
																	.formobj(
																			{
																				gridFilter : function(
																						data,
																						row) {
																					return $(
																							"input:checkbox",
																							row)[0].checked;
																				}
																			});
															if (v.length < 1) {
																$
																		.alert("${ctp:i18n('formtalk.alert.copy.error')}");
															} else {
																$
																		.confirm({
																			'msg' : "${ctp:i18n('formtalk.alert.copy.yesno')}",
																			ok_fn : function() {
																				var formtalkMgr = new formtalkMapperManager();
																				formtalkMgr
																						.copyMapperPO(
																								v,
																								{
																									success : function() {
																										$(
																												"#mytable")
																												.ajaxgridLoad(
																														o);
																									}
																								});
																			}
																		});
															}

														}
													} ]
										});

						var mytable = $("#mytable")
								.ajaxgrid(
										{
											dblclick : griddbclick,
											vChange : true,
											vChangeParam : {
												overflow : "hidden",
												autoResize : true
											},
											isHaveIframe : true,
											slideToggleBtn : true,
											colModel : [
													{
														display : "id",
														name : 'id',
														width : '5%',
														sortable : true,
														type : 'checkbox'
													},
													{
														display : "${ctp:i18n('formtalk.column.formtalk.name')}",
														name : 'connectFormtalkName',
														width : '25%',
														sortable : true
													},
													{
														display : "${ctp:i18n('formtalk.column.transType')}",
														sortable : true,
														name : 'transType',
														width : '10%',
														codecfg : "codeType:'java',codeId:'com.seeyon.apps.formtalk.util.FormtalkTransTypeEnum'"
													},
													{
														display : "${ctp:i18n('formtalk.oa.form.name')}",
														sortable : true,
														name : 'formName',
														width : '25%'
													},
													{
														display : "${ctp:i18n('formtalk.column.formname')}",
														sortable : true,
														name : 'formtalkId',
														width : '25%'
													},
													{
														display : "${ctp:i18n('formtalk.module.name')}",
														sortable : true,
														name : 'templateName',
														width : '25%'
													},
													{
														display : "${ctp:i18n('formtalk.column.type')}",
														sortable : true,
														name : 'formType',
														width : '10%',
														codecfg : "codeType:'java',codeId:'com.seeyon.apps.formtalk.util.FormtalkMapperEnum'"
													},
													{
														display : "${ctp:i18n('formtalk.createdate')}",
														sortable : true,
														name : 'creatTime',
														width : '15%'
													} ],
											width : "auto",
											managerName : "formtalkMapperManager",
											managerMethod : "showMapperList",
											parentId : 'center'
										});
						var o = new Object();
						$("#mytable").ajaxgridLoad(o);
						function griddbclick(data, r, c) {
							var dialog = getA8Top().$
									.dialog({
										url : "${path}/formtalkFormMapperController.do?method=viewVO&formtalkMapperId="
												+ data.id + "&edit=false",
										width : 1000,
										height : 600,
										title : "${ctp:i18n('formtalk.mapper.title')}",
										buttons : [
												{
													text : "${ctp:i18n('common.button.ok.label')}",
													isEmphasize : true,
													handler : function() {
														var rv = dialog
																.getReturnValue();
														if (rv != false) {
															dialog.close();
															var formtalkMgr = new formtalkMapperManager();
															formtalkMgr
																	.saveMapper(
																			rv,
																			{
																				success : function() {
																					$(
																							"#mytable")
																							.ajaxgridLoad(
																									o);
																				}
																			});
														}
													}
												},
												{
													text : "${ctp:i18n('common.button.cancel.label')}",
													handler : function() {
														dialog.close();
													}
												} ]
									});

						}
						function modify() {
							var v = $("#mytable").formobj({
								gridFilter : function(data, row) {
									return $("input:checkbox", row)[0].checked;
								}
							});
							if (v.length < 1) {
								$
										.alert("${ctp:i18n('formtalk.alert.tip.one')}");
								return;
							}
							if (v.length > 1) {
								$
										.alert("${ctp:i18n('formtalk.alert.tip.maxone')}");
								return;
							}
							var dialog = getA8Top().$
									.dialog({
										url : "${path}/formtalkFormMapperController.do?method=viewVO&formtalkMapperId="
												+ v[0]["id"],
										width : 1000,
										height : 600,
										title : "${ctp:i18n('formtalk.mapper.title')}",
										buttons : [
												{
													text : "${ctp:i18n('common.button.ok.label')}",
													isEmphasize : true,
													handler : function() {
														var rv = dialog
																.getReturnValue();
														if (rv != false) {
															dialog.close();
															var formtalkMgr = new formtalkMapperManager();
															formtalkMgr
																	.saveMapper(
																			rv,
																			{
																				success : function() {
																					$(
																							"#mytable")
																							.ajaxgridLoad(
																									o);
																				}
																			});
														}
													}
												},
												{
													text : "${ctp:i18n('common.button.cancel.label')}",
													handler : function() {
														dialog.close();
													}
												} ]
									});
						}
					});
</script>

</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">

		<div class="comp"
			comp="type:'breadcrumb',comptype:'location',code:'F21_formtalk_mapper'"></div>
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbar"></div>
			<div id="searchDiv"></div>
		</div>
		
		<div class="layout_center over_hidden" id="center">
			<div class="common_toolbar_box toolbar_l menu_span" style="height:20px;">
				${ctp:i18n('formtalk.updatetip')}
			</div>
			<table id="mytable" class="flexme3"></table>
			<div id="grid_detail" class="h100b">
				<iframe id="customDetail" name='customDetail' width="100%"
					height="100%" frameborder="0" class='calendar_show_iframe'
					style="overflow-y: hidden"></iframe>
			</div>
		</div>
		<iframe class="hidden" id="delIframe" src=""></iframe>
		
	</div>
</body>
</html>