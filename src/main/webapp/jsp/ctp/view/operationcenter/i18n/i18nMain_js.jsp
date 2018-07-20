<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=i18resourceManager"></script>
<script type="text/javascript">
	var i18resourceManager = new i18resourceManager();
	var msg = '${ctp:i18n("info.totally")}';
	var languageinfo = "zh_CN";
	var mytable;
	$().ready(
			function() {
				mytable = $("#mytable").ajaxgrid({
					/* click : clk, */
					colModel : [ {
						display : 'id',
						name : 'id',
						width : '5%',
						sortable : false,
						align : 'center',
						type : 'checkbox'
					}, {
						display : "${ctp:i18n('i18nresource.language.info')}",
						name : 'localeStr',
						sortable : true,
						width : '15%'
					}, {
						display : "${ctp:i18n('i18nresource.level.info')}",
						name : 'levelType',
						sortable : true,
						width : '15%'
					}, {
						display : "${ctp:i18n('i18nresource.keyinfo.info')}",
						name : 'key',
						sortable : true,
						width : '10%'
					}, {
						display : "${ctp:i18n('i18nresource.valueinfo.info')}",
						name : 'value',
						sortable : true,
						width : '25%',
					}, {
						display : "${ctp:i18n('i18nresource.relativepath.info')}",
						name : 'relativePath',
						sortable : true,
						width : '15%',
					}, {
						display : "${ctp:i18n('i18nresource.filepath.info')}",
						name : 'filePath',
						sortable : true,
						width : '15%',
					} ],
					width : 'auto',
					parentId : "roleList_stadic_body_top_bottom",
					managerName : "i18resourceManager",
					managerMethod : "findALLResource",
					vChangeParam : {
						overflow : "auto"
					},
					slideToggleBtn : true,
					showTableToggleBtn : true,
					vChange : true

				});
				reloadtab();

				// 工具栏
				var toolbar = $("#toolbar").toolbar({
					toolbar : [ {
						id : "modify",
						name : "${ctp:i18n('label.modify')}",
						className : "ico16 editor_16",
						click : function() {
							modifyres();
						}
					} ]
				});

				//搜素栏查询
				var searchobj;
				var ver = "${ctp:getSystemProperty('org.isGroupVer')}";
				searchobj = $.searchCondition({
					top : 35,
					right : 10,
					searchHandler : function() {
						var result = searchobj.g.getReturnValue();
						if (result) {
							loadTable1(result.condition, result.value);
						}
					},
					conditions : [ 

					{
						id : 'leveltype',
						name : 'leveltype',
						type : 'select',
						text : "${ctp:i18n('i18nresource.level.info')}",
						value : 'leveltype',
						items : [ {
							text : "自定义", // 优先级 0
							value : 'custom'
						}, {
							text : "产品", // 优先级 1
							value : 'product'
						}, {
							text : "公共", // 优先级 2
							value : 'common'
						}, {
							text : "插件", // 优先级 3
							value : 'plugin'
						}, {
							text : "默认", // 优先级 4
							value : ' default'
						} ]
						// codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'"
					},

					{
						id : 'keyinfo',
						name : 'keyinfo',
						type : 'input',
						text : "${ctp:i18n('i18nresource.keyinfo.info')}",
						value : 'keyinfo'
					}, {
						id : 'valueinfo',
						name : 'valueinfo',
						type : 'input',
						text : "${ctp:i18n('i18nresource.valueinfo.info')}",
						value : 'valueinfo'
					} ]
				});
				//修改
				function modifyres() {
					var boxs = $(".mytable").formobj({
						gridFilter : function(data, row) {
							return $("input:checkbox", row)[0].checked;
						}
					});
					if (boxs.length === 0) {
						$.alert("${ctp:i18n('i18nresource.checkpro.info')}");
						return;
					} else if (boxs.length > 1) {
						$.alert("${ctp:i18n('i18nresource.editorpro.info')}");
						return;
					}
					var key = boxs[0].key;

					var cnValue = $("#cnValue").val();
					var enValue = $("#enValue").val();
					var twValue = $("#twValue").val();
					var dialog = $.dialog({
						url : _ctxPath + '/i18NResource.do?method=getResourceModify&key=' + key,
						width : 400,
						height : 340,
						isDrag : true,
						targetWindow : getCtpTop(),
						title : "${ctp:i18n('i18nresource.editresources.info')}",
						buttons : [
								{
									id : "btnok",
									text : "${ctp:i18n('common.button.ok.label')}",
									handler : function() {
										var user = dialog.getReturnValue();
										if (user == undefined || user.valid) {
											return;
										}
										$.ajax({
											type : "GET",
											url : _ctxPath + '/i18NResource.do?method=saveResourceModify&key=' + user.key + '&cnValue='
													+ encodeURI(user.cnValue) + '&twValue=' + encodeURI(user.twValue) + '&enValue='
													+ user.enValue,
											success : function(result) {
												if (result != 0) {
													// 手动加载表格数据
													reloadtab();
													dialog.close();
												} else {
													$.alert("${ctp:i18n('usersystem.restUser.loginName.repeat')}");
												}
											}
										})

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

				//加载列表
				function reloadtab() {
					var o = new Object();
					o.locale = languageinfo;
					$("#mytable").ajaxgridLoad(o);
				}
			});

	var currentLocale;

	function tabrelaod(param) {
		languageinfo = param;

		$().ready(function() {
			mytable = $("#mytable").ajaxgrid({
				/* click : clk, */
				colModel : [ {
					display : 'id',
					name : 'id',
					width : '5%',
					sortable : false,
					align : 'center',
					type : 'checkbox'
				}, {
					display : "${ctp:i18n('i18nresource.language.info')}",
					name : 'localeStr',
					sortable : true,
					width : '15%'
				},

				{
					display : "${ctp:i18n('i18nresource.level.info')}",
					name : 'levelType',
					sortable : true,
					width : '15%'
				}, {
					display : "${ctp:i18n('i18nresource.keyinfo.info')}",
					name : 'key',
					sortable : true,
					width : '10%'
				}, {
					display : "${ctp:i18n('i18nresource.valueinfo.info')}",
					name : 'value',
					sortable : true,
					width : '25%',
				}, {
					display : "${ctp:i18n('i18nresource.relativepath.info')}",
					name : 'relativePath',
					sortable : true,
					width : '15%',
				}, {
					display : "${ctp:i18n('i18nresource.filepath.info')}",
					name : 'filePath',
					sortable : true,
					width : '15%',
				} ],
				width : 'auto',
				parentId : "roleList_stadic_body_top_bottom",
				managerName : "i18resourceManager",
				managerMethod : "findALLResource",
				vChangeParam : {
					overflow : "auto"
				},
				slideToggleBtn : true,
				showTableToggleBtn : true,
				vChange : true
			});
			reloadtab();
			currentclass();
			// 工具栏
			/* if ( $("#toolbar").innerHTML == '' ) {
				var toolbar = $("#toolbar").toolbar({
					toolbar : [ {
						id : "modify",
						name : "${ctp:i18n('label.modify')}",
						className : "ico16 editor_16",
						click : function() {
							modifyres();
						}
					} ]
				});
			} */

			//加载列表
			function reloadtab() {
				var o = new Object();
				o.locale = param;
				$("#mytable").ajaxgridLoad(o);
			}
			//取消当前选择样式
			function currentclass() {
				var classlist = [ "zh_CN", "en", "zh_TW", "custom" ];
				for (var i = 0; i < classlist.length; i++) {
					$("#" + classlist[i]).removeClass("current");
				}
				$("#" + param).addClass("current");
			}
		});
	}
	//加载列表
	function loadTable1(condition, value) {
		var o = new Object();
		o.condition = condition;
		o.value = value;
		o.locale = languageinfo;
		$("#mytable").ajaxgridLoad(o);
	}
</script>