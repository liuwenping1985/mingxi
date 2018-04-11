<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../common/common.jsp"%>
<title>${ctp:i18n('formtalk.mapper.set')}</title>
<style>
div.question-help {
	background: #b9b9b9;
	width: 16px;
	height: 16px;
	color: #ffffff;
	font-size: 14px !important;
	font-weight: normal !important;
	line-height: 16px;
	text-align: center;
	font-family: arial, verdana, sans-serif;
	display: inline-block;
	-webkit-border-radius: 10px;
	-moz-border-radius: 10px;
	border-radius: 10px;
	margin-left: 0px;
	cursor: default;
	position: relative;
	z-index: 300;
	top: 0;
	margin-top: 0;
}

div.question-help div.question-content {
	font-family: "Microsoft YaHei", Arial, Helvetica, sans-serif;
	background: #b7b7b7;
	padding: 5px 10px;
	width: 160px;
	min-height: 30px;
	font-size: 13px !important;
	font-weight: normal !important;
	line-height: 1.4;
	position: absolute;
	left: 26px;
	top: -6px;
	color: #ffffff;
	z-index: 9;
	-webkit-border-radius: 3px;
	-moz-border-radius: 3px;
	border-radius: 3px;
	text-align: left;
	white-space: normal;
	display: none;
}

div.question-help div.question-content div.question-wapper {
	width: 0;
	height: 0;
	border-top: 8px solid transparent;
	border-bottom: 8px solid transparent;
	border-right: 8px solid #b7b7b7;
	position: absolute;
	left: -8px;
	top: 7px;
}

div.question-help:hover div.question-content {
	display: block;
}

td {
	text-align: left;
	padding: 6pt;
}
.tdw
</style>
<%
	com.seeyon.apps.formtalk.vo.FormtalkMapperVO o = (com.seeyon.apps.formtalk.vo.FormtalkMapperVO) request
			.getAttribute("dataVO");
	if (o != null) {
		pageContext.setAttribute("dataMap", o.getDataMap());
	}
%>
<script type="text/javascript" language="javascript">
	$()
			.ready(
					function() {
						if ("${param.edit}" == "false") {
							$("#addForm").disable();
						}

						$("#transType").find(
								"option[value=" + "${dataVO.transType}" + "]")
								.attr("selected", true);
						$("#formtalkFormType").find(
								"option[value=" + "${dataVO.formtalkFormType}"
										+ "]").attr("selected", true);
						$("#formtalkVer")
								.find(
										"option[value="
												+ "${dataVO.formtalkVer}" + "]")
								.attr("selected", true);
						//debugger;
						$("#transType")
								.change(
										function() {
											var v = $(this).children(
													'option:selected').val();
											if (v == 2 || v == 3) {
												var flowrows = $("tr[id^='flowfield_']");
												flowrows
														.each(function(index,
																row) {
															var confield = $(
																	row)
																	.find(
																			"input[id^='flowfieldKeyColumn_']");
															confield
																	.unbind(
																			"dblclick")
																	.bind(
																			"dblclick",
																			function() {
																				openMasterData($(this));
																			});
															confield.attr(
																	"readonly",
																	"readonly");

														});
												setPanel(v);
											} else {
												var flowrows = $("tr[id^='flowfield_']");
												flowrows
														.each(function(index,
																row) {
															var confield = $(
																	row)
																	.find(
																			"input[id^='flowfieldKeyColumn_']");
															confield
																	.unbind("dblclick");
															confield
																	.removeAttr("readonly");
														});
												setPanel(v);

											}
										});

						//debugger;
						$("#formtalkFormType").change(
								function() {
									var formtalkFormType = document.getElementById("formtalkFormType").value;
									if ("1" == formtalkFormType) {
										$("#formtalkFlowIdDiv").show();
									} else {
										$("#formtalkFlowIdDiv").hide();
									}
									var formType = document.getElementById("formtalkFormType").value;
									dispMapper(formType=="2"?true:false);
								});
						$("#formtalkVer").change(
								function() {
									var transType = document
											.getElementById("transType").value;
									setPanel(transType);
									var formType = document.getElementById("formtalkFormType").value;
									dispMapper(formType=="2"?true:false);
								});

						var rows = $("tr[id^='confield_']");
						rows.each(function(index, row) {
							var confield = $(row).find(
									"input[id^='confieldOAColumn_']");
							confield.unbind("dblclick").bind("dblclick",
									function() {
										openMasterData($(this));
									});
						});// end each

						var flowrows = $("tr[id^='flowfield_']");
						flowrows.each(function(index, row) {
							var confield = $(row).find(
									"input[id^='flowfieldKeyColumn_']");
							var transType = "${dataVO.transType}";
							if (transType == 2 || transType == 3) {
								confield.unbind("dblclick").bind("dblclick",
										function() {
											openMasterData($(this));
										});
							}
						});

						var chooseStartMember = $("#startMember");
						$("#startType").find(
								"option[value="
										+ "${dataVO.startMemerMap.startType}"
										+ "]").attr("selected", true);
						var startType = $("#startType").children(
								'option:selected').val();
						if (startType == 1) {
							chooseStartMember.attr("readonly", "readonly");
							chooseStartMember.unbind("click").bind("click",
									function() {
										selectPeople();
									});
						}
						$('#startType')
								.change(
										function() {
											var v = $(this).children(
													'option:selected').val();
											if (v == 2) {
												chooseStartMember
														.removeAttr("readonly");
												chooseStartMember
														.unbind("click");
												chooseStartMember.val("");
												document
														.getElementById("startValue").value = "";
											} else {
												chooseStartMember.attr(
														"readonly", "readonly");
												chooseStartMember.val("");
												document
														.getElementById("startValue").value = "";
												chooseStartMember.unbind(
														"click").bind("click",
														function() {
															selectPeople();
														});
											}
										});

						$("#formName").disable();
						$("#formtalkId")
								.blur(
										function() {
											var formtalkMgr = new formtalkMapperManager();
											var formtalkId = document
													.getElementById("formtalkId").value;
											var idvalue = document
													.getElementById("id").value;

											var transType = document
													.getElementById("transType").value;
											var templateId = document
													.getElementById("templateId").value;
											var formId = document
													.getElementById("formId").value;

											var returnBooleanValue = formtalkMgr
													.checkIsExistFormtalk(
															idvalue, transType,
															formtalkId, formId,
															templateId);
											if (returnBooleanValue) {
												$
														.alert("${ctp:i18n('formtalk.event.error.tip.10')}");
												//document.getElementById("formtalkId").value = "";
												return;
											}
										});

						$(".assist").unbind("click").bind("click", assistfn);

						$("#addImg")
								.click(
										function() {
											var trId = $("#assist_id").val();
											var html = $("#" + trId).html();
											var tableId = $("#" + trId)
													.parent().parent().attr(
															"id");
											var last = $(
													"#" + tableId + " tr:last")
													.attr("id");
											var arr = last.split("_");
											arr[1] = parseInt(arr[1]) + 1;
											var assistId = ($("#" + last).find(
													"input").attr("id"));
											var assistArr = assistId.split("_");
											var type = assistArr[0];
											var newNum = parseInt(assistArr[1]) + 1;

											html = '';
											if (trId.indexOf('confield_') > -1) {
												html += "<td width=\"20%\"><input type=\"text\" id=\"confieldOAColumn_"+newNum+"\" name=\"confieldOAColumn_"+newNum+"\" readonly class=\"validate word_break_all bindData\" style=\"width: 200px;\"></td> ";
												html += "<td width=\"20%\"><input type=\"text\" id=\"confieldformtalkColumn_"+newNum+"\" name=\"confieldformtalkColumn_"+newNum+"\" class=\"validate word_break_all bindData\" style=\"width: 200px;\"></td>";

											} else {
												html += "<td width=\"20%\"><input type=\"text\" id=\"flowfieldKeyColumn_"+newNum+"\" name=\"flowfieldKeyColumn_"+newNum+"\" class=\"validate word_break_all bindData\" style=\"width: 200px;\"></td> ";
												html += "<td width=\"20%\"><input type=\"text\" id=\"flowfieldValueColumn_"+newNum+"\" name=\"flowfieldValueColumn_"+newNum+"\" class=\"validate word_break_all bindData\" style=\"width: 200px;\"></td>";
											}

											$("#" + tableId).append(
													"<tr class='assist' id='"
															+ arr.join("_")
															+ "'>" + html
															+ "</tr>");
											$(".assist").unbind("click",
													assistfn).bind("click",
													assistfn);
											$("#assist_id").val(
													$("#" + trId).next("tr")
															.attr("id"));

											if (trId.indexOf('confield_') > -1) {
												$("#confieldOAColumn_" + newNum)
														.unbind("dblclick")
														.bind(
																"dblclick",
																function() {
																	openMasterData($("#confieldOAColumn_"
																			+ newNum));
																});
											} else {
												var transType = document
														.getElementById("transType").value;
												if (transType == "2"
														|| transType == "3") {
													$(
															"#flowfieldKeyColumn_"
																	+ newNum)
															.unbind("dblclick")
															.bind(
																	"dblclick",
																	function() {
																		openMasterData($("#flowfieldKeyColumn_"
																				+ newNum));
																	});

													$(
															"#flowfieldKeyColumn_"
																	+ newNum)
															.attr("readonly",
																	"readonly");
													setPanel(transType);
												} else {
													$(
															"#flowfieldKeyColumn_"
																	+ newNum)
															.removeAttr(
																	"readonly");
													setPanel(transType);
												}

											}

										});
						$("#delImg")
								.click(
										function() {
											var trId = $("#assist_id").val();
											var prevTr = $("#" + trId).prev(
													"tr");
											if (prevTr == null
													|| prevTr.attr("id") == undefined) {
												prevTr = $("#" + trId).next(
														"tr");
												if (prevTr == null
														|| prevTr.attr("id") == undefined) {
													$("#" + trId)
															.find("input")
															.each(
																	function(
																			index,
																			row) {
																		$(row)
																				.val(
																						'');
																	});
													return;
												} else {
													var img = $("#img");
													var offset = img.offset();
													offset.top = offset.top
															+ $("#" + trId)
																	.height()
															+ 2;
													img.offset(offset);
												}
											}
											$("#assist_id").val(
													prevTr.attr("id"));
											$("#" + trId).remove();
										});

						$("#confieldOAColumn_0").unbind("dblclick").bind(
								"dblclick", function() {
									openMasterData($("#confieldOAColumn_0"));
								});
						var transType = "${dataVO.transType}";
						//debugger;
						if (transType == "2" || transType == "3") {
							$("#flowfieldKeyColumn_0")
									.unbind("dblclick")
									.bind(
											"dblclick",
											function() {
												openMasterData($("#flowfieldKeyColumn_0"));
											});
							$("#flowfieldKeyColumn_0").attr("readonly",
									"readonly");
							setPanel(transType);
						} else {
							$("#flowfieldKeyColumn_0").removeAttr("readonly");
							setPanel(transType);
						}
						if ("${param.edit}" == "false") {
							$("#addForm").disable();
						}
						
						$('#isBackFillTable').change(function(){
							var transType = document
							.getElementById("transType").value;
							setconfieldcheckbox(transType);
						});
						
					});

	function setPanel(type) {
		var datafield = $("#form_datafield");
		var memberfield = $("#form_member");
		var insertfield = $("#isConfInsertTable");
		var formtalkFormType = $("#formtalkFormType");
		var formtalkFormTypeDIV = $("#formtalkFormTypeDIV");
		var formtalkVerDIV = $("#formtalkVerDIV");
		var isBackFill=$("#isBackFillTable");

		if (type == "0") {//toun
			memberfield.hide();
			datafield.hide();
			insertfield.hide();
			formtalkFormTypeDIV.hide();
			formtalkVerDIV.hide();
		} else if (type == "1") {//toV5
			memberfield.show();
			datafield.show();
			insertfield.show();
			formtalkVerDIV.hide();
			formtalkFormTypeDIV.hide();
			
			isBackFill.hide();
			
			dispMapper(true);
		} else if (type == "2") {//toformtalk
			memberfield.hide();
			datafield.show();
			insertfield.hide();

			formtalkVerDIV.show();

			formtalkFormTypeDIV.show();
			
			var formType = document.getElementById("formtalkFormType").value;
			formtalkFormType.find("option[value='"+formType+"']").attr("selected", true);
			
			setFormtalkFormType(type,formtalkFormType);
			
			isBackFill.show();
			
			dispMapper(formType=="2"?true:false);
		} else if (type == "3") {//toqrcode
			memberfield.hide();
			datafield.hide();
			insertfield.hide();

			formtalkVerDIV.show();
			formtalkFormTypeDIV.show();
			
			formtalkFormType.removeAttr("disabled");
			
			setFormtalkFormType(type,formtalkFormType);
			
			isBackFill.hide();
			dispMapper(false);
		}

		var formtalkFormType = document.getElementById("formtalkFormType").value;
		if ("1" == formtalkFormType && !formtalkFormTypeDIV.is(":hidden")) {
			$("#formtalkFlowIdDiv").show();
		} else {
			$("#formtalkFlowIdDiv").hide();
		}
		setconfieldcheckbox(type);
		
		
		$("#addForm").resetValidate();
	}
	function setFormtalkFormType(transtype,formtalkFormType){
		var formtalkVer = document.getElementById("formtalkVer").value;
		var formType = document.getElementById("formtalkFormType").value;
		formtalkFormType.empty();
		if ("1" == formtalkVer) {
			formtalkFormType.append("<option value=\"0\">${ctp:i18n('formtalk.mapper.form')}</option>");
			if(transtype=="3")formtalkFormType.append("<option value=\"1\">${ctp:i18n('formtalk.mapper.flow')}</option>");
			formtalkFormType.append("<option value=\"2\">${ctp:i18n('formtalk.mapper.unflow')}</option>");
		} else {
			formtalkFormType.append("<option value=\"0\">${ctp:i18n('formtalk.mapper.form')}</option>");
		}
		
		formtalkFormType.find("option[value='"+formType+"']").attr("selected", true);
	}
	
	function setconfieldcheckbox(type){
		if(type=="2"){
			var isBackFill = document.getElementById("isBackFill").checked;
			if(!isBackFill){
				var rows = $("tr[id^='confield_']");
				rows.each(function(index, row) {
					var confield = $(row).find("input[id^='confieldOAColumn_']");
					confield.attr("validate","notNull:true,maxLength:80,name:'${ctp:i18n('formtalk.mapper.confield')}'");
				});// end each
			}else{
				var rows = $("tr[id^='confield_']");
				rows.each(function(index, row) {
					var confield = $(row).find(
							"input[id^='confieldOAColumn_']");
					confield.removeAttr("validate");
				});// end each
			}
		}else{
			var rows = $("tr[id^='confield_']");
			rows.each(function(index, row) {
				var confield = $(row).find(
						"input[id^='confieldOAColumn_']");
				confield.removeAttr("validate");
			});// end each
		}
	}
	function dispMapper(showOrHide){
		var trdata = document.getElementById("mytable").getElementsByTagName("tr");
		if(trdata)
		dispMapperFields(trdata,showOrHide,"");
		trdata = document.getElementById("tablecon").getElementsByTagName("tr");
		if(trdata)
		dispMapperFields(trdata,showOrHide,"confieldOAColumn_");
		
	}
	function dispMapperFields(trdata,showOrHide,fieldName){
		for (var i = 1; i < trdata.length; i++) {
			var key ="";
			if(""==fieldName){
				if(trdata[i].cells[1]){
					key=trdata[i].cells[1].innerText;
				}
			}else{
				if(trdata[i].cells[0] && trdata[i].cells[0].firstChild){
					key=trdata[i].cells[0].firstChild.value;
				}
			}
			if(""==key){continue;}
			if(key.split(".").length>1){
				if(showOrHide){
					$(trdata[i]).show();
				}else{
					$(trdata[i]).hide();
				}
			}
		}
	}
	
	function checkMapper(type,data){
		if(type=="3" || type=="0") return false;
		var checkfileds=[];
		for(var i=0;i<data.length;i++){
			var d=data[i];
			var oa=d.OAColumn?d.OAColumn:d.oaColumn;
			var ft=d.formtalkColumn;
			if(!oa){continue;}
			if(!ft){continue;}
			var oaIsSub=oa.split(".").length>1;
			var ftIsSub=ft.split(".").length>1;
			
			if(!oaIsSub&&!ftIsSub){continue;}
			
			if(type=="1"/*toV5*/){
				if(!oaIsSub && ftIsSub ){
					alert("${ctp:i18n('formtalk.exception.mustmastercon1')}");
					return true;
				}
			}else{
				if(!ftIsSub && oaIsSub ){
					alert("${ctp:i18n('formtalk.exception.mustmastercon2')}");
					return true;
				}
			}
			//上面已经按照传输类型校验了子主表对应关系
			if(!oaIsSub || !ftIsSub){continue;}
		
			var v5TableKey=oa.split(".")[0];
			var ftTableKey=ft.split(".")[0];
			for(var j=0;j<checkfileds.length;j++){
				var v5talbe=checkfileds[j][0];
				var fttable=checkfileds[j][1];
				if(v5TableKey==v5talbe && ftTableKey!=fttable
					|| ftTableKey==fttable && v5TableKey!=v5talbe){
					
					if(type=="1" && ftTableKey!=fttable && v5TableKey==v5talbe){
						alert("${ctp:i18n('formtalk.exception.mustmastercon1')}");
						return true;
					}else if(type=="2"){
						alert("${ctp:i18n('formtalk.exception.mustmastercon2')}");
						return true;
					}
				}
			}
			checkfileds.push([v5TableKey,ftTableKey]);
			
		}
		return false;
	}
	
	function checkConfield(type,data){
		if(type=="3" || type=="0") return false;
		if(!data || !data.length || data.length==0){return false;}
		var havMainCon=false;
		var havData=false;
		for(var i=0;i<data.length;i++){
			var d=data[i];
			var oa=d.OAColumn?d.OAColumn:d.oaColumn;
			var ft=d.formtalkColumn;
			if(!oa){continue;}
			if(!ft){continue;}
			var oaIsSub=oa.split(".").length>1;
			var ftIsSub=ft.split(".").length>1;
			havData=true;
			if(!oaIsSub&&!ftIsSub){havMainCon=true;continue;}
		}
		if(!havData){return false;}
		if(!havMainCon){alert("${ctp:i18n('formtalk.exception.mustmastercon')}"); return true;}
		
		return checkMapper(type,data);
	}
	function OK() {

		if (!($("#addForm").validate())) {
			setTimeout(function() {
				$(".error-title:first").get(0).scrollIntoView();
			}, 1000);
			return false;
		}

		var formtalkMgr = new formtalkMapperManager();
		var transType = document.getElementById("transType").value;
		var formtalkFormType = document.getElementById("formtalkFormType").value;
		var formtalkFlowId = document.getElementById("formtalkFlowId").value;
		var formtalkVer = document.getElementById("formtalkVer").value;
		var templateId = document.getElementById("templateId").value;
		var formId = document.getElementById("formId").value;
		var formtalkId = document.getElementById("formtalkId").value;
		var idvalue = document.getElementById("id").value;
		var returnBooleanValue = formtalkMgr.checkIsExistFormtalk(idvalue,
				transType, formtalkId, formId, templateId);
		if (returnBooleanValue) {
			$.alert("${ctp:i18n('formtalk.event.error.tip.10')}");
			return false;
		}

		var trdata = document.getElementById("mytable").getElementsByTagName(
				"tr");
		var data = [];
		for (var i = 1; i < trdata.length; i++) {
			var key = trdata[i].cells[1].innerText;
			var json = {
				"OAColumn" : key,
				"formtalkColumn" : document.getElementById("formtalkColumn"
						+ trdata[i].cells[0].innerText).value
			};
			data.push(json);
		}
		//debugger;
		if(checkMapper(transType,data)) {return false;}

		trdata = document.getElementById("tablecon").getElementsByTagName("tr");
		var confield = [];
		for (var i = 1; i < trdata.length; i++) {
			var v = trdata[i].id.split("_")[1];
			var json = {
				"rownum" : v,
				"oaColumn" : document.getElementById("confieldOAColumn_" + v).value,
				"formtalkColumn" : document
						.getElementById("confieldformtalkColumn_" + v).value
			};
			confield.push(json);
		}
		if(checkMapper(transType,confield)) {return false;}
		if(checkConfield(transType,confield)) {return false;}

		trdata = document.getElementById("tableflow")
				.getElementsByTagName("tr");
		var flowfield = [];
		for (var i = 1; i < trdata.length; i++) {
			var v = trdata[i].id.split("_")[1];

			var json = {
				"rownum" : v,
				"flowfieldKeyColumn" : document
						.getElementById("flowfieldKeyColumn_" + v).value,
				"flowfieldValueColumn" : document
						.getElementById("flowfieldValueColumn_" + v).value
			};
			flowfield.push(json);
		}

		var startType = $('#startType').children('option:selected').val();
		var formId = document.getElementById("formId").value;
		var transType = document.getElementById("transType").value;
		var formType = document.getElementById("formType").value;
		var templateId = document.getElementById("templateId").value;
		var startValue = document.getElementById("startValue").value;
		if ("2"== startType) {
			startValue = document.getElementById("startMember").value;
		}
		var isConfInsert = document.getElementById("isConfInsert").checked;
		var isBackFill = document.getElementById("isBackFill").checked;
		//alert(isConfInsert);
		var connectFormtalkName = document
				.getElementById("connectFormtalkName").value;
		return {
			"id" : idvalue,
			"templateId" : templateId,
			"connectFormtalkName" : connectFormtalkName,
			"formtalkId" : formtalkId,
			"formId" : formId,
			"formType" : formType,
			"dataList" : data,
			"transType" : transType,
			"isConfInsert" : isConfInsert,
			"startMemerMap" : {
				"startType" : startType,
				"startValue" : startValue
			},
			"confieldMap" : confield,
			"flowfieldMap" : flowfield,
			"formtalkFormType" : formtalkFormType,
			"formtalkFlowId" : formtalkFlowId,
			"formtalkVer" : formtalkVer,
			"isBackFill":isBackFill
		};
	}

	function selectPeople() {
		$.selectPeople({
			type : 'selectPeople',
			panels : 'Department,Post,Level,Outworker,Team,RelatePeople',
			selectType : 'Member',
			onlyLoginAccount : false,
			hiddenRootAccount : false,
			returnValueNeedType : false,
			maxSize : 1,
			text : $("#startMember").val(),
			params : {
				value : $("#startValue").val()
			},
			callback : function(ret) {
				$("#startMember").val(ret.text);
				$("#startValue").val(ret.value);
			}
		});
	}
	function openMasterData(opener) {
		var formId = document.getElementById("formId").value;
		var fieldId=  opener.eq(0).attr('id');//	"flowfieldKeyColumn_0"
		var transType = document.getElementById("transType").value;
		var needSubTable="";
		if((transType=="1" || transType=="2") && fieldId.indexOf("flowfieldKeyColumn_")<0) {needSubTable="true";}
		var dialog = getA8Top().$
				.dialog({
					url : "${path}/formtalkFormMapperController.do?method=viewMasterData&needSubTable="+ needSubTable +"&formId="
							+ formId,
					width : 560,
					height : 450,
					title : "${ctp:i18n('formtalk.title.master')}",
					buttons : [ {
						text : "${ctp:i18n('common.button.ok.label')}",
						isEmphasize : true,
						handler : function() {
							var rv = dialog.getReturnValue();
							if (rv) {

								opener.val(rv);
								dialog.close();
							}
						}
					}, {
						text : "${ctp:i18n('common.button.cancel.label')}",
						handler : function() {
							dialog.close();
						}
					} ]
				});
	}

	var assistfn = function() {
		addOrDelTr(this);
	}

	function addOrDelTr(target) {
		var imgDiv = $("#img");
		if (imgDiv.length <= 0) {
			return;
		}
		imgDiv.removeClass("hidden").css("visibility", "visible");
		$("#assist_id").val($(target).attr("id"));
		var addImg = $("#addImg");
		var delImg = $("#delImg");
		var pos = getElementPos(target);
		pos.left = pos.left - imgDiv.width();
		imgDiv.offset(pos);
		//允许添加
		addImg.css("display", "block");
		addImg[0].title = $.i18n("form.base.addRow.label");
		delImg.css("display", "block");
		delImg[0].title = $.i18n("form.base.delRow.label");
	}
	function getElementPos(el) {
		var ua = navigator.userAgent.toLowerCase();
		if (el.parentNode === null || el.style.display == 'none') {
			return false;
		}
		var parent = null;
		var pos = [];
		var box;
		if (el.getBoundingClientRect) {//IE，google
			box = el.getBoundingClientRect();
			var scrollTop = document.documentElement.scrollTop;
			var scrollLeft = document.documentElement.scrollLeft;
			if (navigator.appName.toLowerCase() == "netscape") {//google
				scrollTop = Math.max(scrollTop, document.body.scrollTop);
				scrollLeft = Math.max(scrollLeft, document.body.scrollLeft);
			}
			return {
				left : box.left + scrollLeft,
				top : box.top + scrollTop
			};
		} else if (document.getBoxObjectFor) {// gecko
			box = document.getBoxObjectFor(el);
			var borderLeft = (el.style.borderLeftWidth) ? parseInt(el.style.borderLeftWidth)
					: 0;
			var borderTop = (el.style.borderTopWidth) ? parseInt(el.style.borderTopWidth)
					: 0;
			pos = [ box.x - borderLeft, box.y - borderTop ];
		} else {// safari & opera
			pos = [ el.offsetLeft, el.offsetTop ];
			parent = el.offsetParent;
			if (parent != el) {
				while (parent) {
					pos[0] += parent.offsetLeft;
					pos[1] += parent.offsetTop;
					parent = parent.offsetParent;
				}
			}
			if (ua.indexOf('opera') != -1
					|| (ua.indexOf('safari') != -1 && el.style.position == 'absolute')) {
				pos[0] -= document.body.offsetLeft;
				pos[1] -= document.body.offsetTop;
			}
		}
		if (el.parentNode) {
			parent = el.parentNode;
		} else {
			parent = null;
		}
		while (parent && parent.tagName != 'BODY' && parent.tagName != 'HTML') { // account for any scrolled ancestors
			pos[0] -= parent.scrollLeft;
			pos[1] -= parent.scrollTop;
			if (parent.parentNode) {
				parent = parent.parentNode;
			} else {
				parent = null;
			}
		}
		return {
			left : pos[0],
			top : pos[1]
		};
	}
</script>
</head>
<body>
	<form name="addForm" id="addForm" method="post">
		<input type="hidden" id="id" name="id" value="${dataVO.id}"> <input
			type="hidden" id="formId" name="formId" value="${dataVO.formId}">
		<input type="hidden" id="formType" name="formType"
			value="${dataVO.formType}"> <input type="hidden"
			id="templateId" name="templateId" value="${dataVO.templateId}">
		<input type="hidden" id="assist_id" name="assist_id" value="">
		<input type="hidden" id="startValue" name="startValue"
			value="${dataVO.startMemerMap.startValue}">

		<div class="form_area">
			<div class="one_row" style="width: 70%;">
				<br>
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td style="width: 200px;" >${ctp:i18n('formtalk.column.transType')}
							<div style="width: 200px;">
								<select id="transType" name="transType" style="width: 200px;">
									<option value="0">${ctp:i18n('formtalk.mapper.send.toUnknown')}</option>
									<option value="1">${ctp:i18n('formtalk.mapper.send.toV5')}</option>
									<option value="2">${ctp:i18n('formtalk.mapper.send.toformtalk')}</option>
									<option value="3">${ctp:i18n('formtalk.mapper.send.toQRCode')}</option>
								</select>
							</div>
						</td>
						<td style="width: 200px;">${ctp:i18n('formtalk.oa.form.name')}
							<div class="common_txtbox_wrap">
								<input type="text" id="formName" name="formName"
									value="${dataVO.formName}">
							</div>
						</td>
						<td style="width: 200px;">${ctp:i18n('formtalk.column.formtalk.name')}
							<div class="common_txtbox_wrap">
								<input type="text" id="connectFormtalkName"
									validate="notNull:true,maxLength:80,name:'${ctp:i18n('formtalk.column.formtalk.name')}'"
									class="validate" name="connectFormtalkName"
									value="${ctp:toHTML(dataVO.connectFormtalkName)}">
							</div>
						</td>
						<td style="width: 200px;">${ctp:i18n('formtalk.column.formname')}<font
							color="red">*</font>
							<div class="common_txtbox_wrap">
								<input type="text"
									validate="notNull:true,maxLength:80,name:'${ctp:i18n('formtalk.column.formname')}'"
									class="validate" id="formtalkId" name="formtalkId"
									value="${ctp:toHTML(dataVO.formtalkId)}">
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div id="formtalkVerDIV" style="width: 200px">
								${ctp:i18n('formtalk.column.formtalkVer')}
								<div style="width: 200px;">
									<select id="formtalkVer" name="formtalkVer"
										style="width: 100px;">
										<option value="0">${ctp:i18n('formtalk.mapper.psn')}</option>
										<option value="1">${ctp:i18n('formtalk.mapper.pro')}</option>
									</select>
								</div>
							</div>
						</td>
						<td style="width: 200px;">
							<div id="formtalkFormTypeDIV" style="width: 200px">
								${ctp:i18n('formtalk.column.formtalkFormType')}
								<div style="width: 200px;">

									<select id="formtalkFormType" name="formtalkFormType"
										style="width: 100px;">
										<option value="0">${ctp:i18n('formtalk.mapper.form')}</option>
										<option value="1">${ctp:i18n('formtalk.mapper.flow')}</option>
										<option value="2">${ctp:i18n('formtalk.mapper.unflow')}</option>
									</select>
								</div>
							</div>
						</td>
						<td style="width: 600px;" colspan="2">
							<div id="formtalkFlowIdDiv">
								${ctp:i18n('formtalk.column.formtalkFlowId')}<font color="red">*</font>
								<div class="common_txtbox_wrap">
									<input type="text"
										validate="notNull:true,maxLength:80,name:'${ctp:i18n('formtalk.column.formtalkFlowId')}'"
										class="validate" id="formtalkFlowId" name="formtalkFlowId"
										value="${ctp:toHTML(dataVO.formtalkFlowId)}">
								</div>
							</div>
						</td>
					</tr>
				</table>
				<br>
				<fieldset id="form_head" style="width: 100%; border: 1;">
					<legend>
						<b>${ctp:i18n('formtalk.mapper.title')}</b>
						<div class="question-help">
							?
							<div class="question-content">
								<div class="question-wapper"></div>
								${ctp:i18n('formtalk.message.set')}
							</div>
						</div>
					</legend>
					<div style="width: 100%; border: 0px;" align="left">
						<table id="mytable" class="flexme3" border="0" cellspacing="1"
							cellpadding="0" width="100%">
							<tr bgcolor="#B5DBEB">
								<td width="6%">${ctp:i18n('formtalk.mapper.code')}</td>
								<td width="15%">${ctp:i18n('formtalk.mapper.data')}</td>
								<td width="18%">${ctp:i18n('formtalk.mapper.item.data')}</td>
							</tr>
							<c:forEach items="${dataMap}" var="data" varStatus="status">
								<tr id="column${status.count}">
									<td width="6%">${status.count}</td>
									<td width="15%">${data.key}</td>
									<td width="18%"><input type="text"
										id="formtalkColumn${status.count}"
										name="formtalkColumn${status.count}"
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.value)}"></td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</fieldset>
				<br>

				<!-- 流程条件 -->
				<fieldset id="form_head" style="width: 100%; border: 1;">
					<legend>
						<b>${ctp:i18n('formtalk.mapper.flowfield')}</b>
						<div class="question-help">
							?
							<div class="question-content">
								<div class="question-wapper"></div>
								${ctp:i18n('formtalk.message.flowfield')}
							</div>
						</div>
					</legend>
					<div style="width: 100%; border: 0px;" align="left">
						<table id="tableflow" class="flexme3" border="0" cellspacing="1"
							cellpadding="0" width="100%">
							<tr bgcolor="#B5DBEB">
								<td width="20%">${ctp:i18n('formtalk.mapper.sendKey')}</td>
								<td width="20%">${ctp:i18n('formtalk.mapper.sendValue')}</td>
							</tr>
							<c:if test="${empty dataVO.flowfieldMap}">
								<tr class="assist" id="flowfield_0">
									<td width="20%"><input type="text"
										id="flowfieldKeyColumn_0" name="flowfieldKeyColumn_0"
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.flowfieldKeyColumn)}"
										style="width: 200px;"></td>
									<td width="20%"><input type="text"
										id="flowfieldValueColumn_0" name="flowfieldValueColumn_0"
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.flowfieldValueColumn)}"
										style="width: 200px;"></td>
								</tr>

							</c:if>

							<c:forEach items="${dataVO.flowfieldMap}" var="data"
								varStatus="status">
								<tr class="assist" id="flowfield_${data.rownum}">
									<td width="20%"><input type="text"
										id="flowfieldKeyColumn_${data.rownum}"
										name="flowfieldKeyColumn_${data.rownum}"
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.flowfieldKeyColumn)}"
										style="width: 200px;"></td>
									<td width="20%"><input type="text"
										id="flowfieldValueColumn_${data.rownum}"
										name="flowfieldValueColumn_${data.rownum}"
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.flowfieldValueColumn)}"
										style="width: 200px;"></td>
								</tr>

							</c:forEach>

						</table>
					</div>
				</fieldset>
				<!-- 流程条件END -->


				<br>
				<!-- 数据条件 -->
				<fieldset id="form_datafield" style="width: 100%; border: 1;">
					<legend>
						<b>${ctp:i18n('formtalk.mapper.confield')}</b>

						<div class="question-help">
							?
							<div class="question-content">
								<div class="question-wapper"></div>
								${ctp:i18n('formtalk.message.confield')}
							</div>
						</div>
					</legend>
					<div style="width: 100%; border: 0px;" align="left">
						<table id="tablecon" class="flexme3" border="0" cellspacing="1"
							cellpadding="0" width="100%">
							<tr bgcolor="#B5DBEB">
								<td width="20%">${ctp:i18n('formtalk.mapper.data')}</td>
								<td width="20%">${ctp:i18n('formtalk.mapper.item.data')}</td>
							</tr>
							<c:if test="${empty dataVO.confieldMap}">
								<tr class="assist" id="confield_0">
									<td width="20%"><input type="text" id="confieldOAColumn_0"
										name="confieldOAColumn_0" readonly
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.oaColumn)}" style="width: 200px;"></td>
									<td width="20%"><input type="text"
										id="confieldformtalkColumn_0" name="confieldformtalkColumn_0"
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.formtalkColumn)}"
										style="width: 200px;"></td>
								</tr>

							</c:if>

							<c:forEach items="${dataVO.confieldMap}" var="data"
								varStatus="status">
								<tr class="assist" id="confield_${data.rownum}">
									<td width="20%"><input type="text"
										id="confieldOAColumn_${data.rownum}"
										name="confieldOAColumn_${data.rownum}" readonly
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.oaColumn)}" style="width: 200px;"></td>
									<td width="20%"><input type="text"
										id="confieldformtalkColumn_${data.rownum}"
										name="confieldformtalkColumn_${data.rownum}"
										class="validate word_break_all bindData"
										value="${ctp:toHTML(data.formtalkColumn)}"
										style="width: 200px;"></td>
								</tr>

							</c:forEach>

						</table>
						<table id="isConfInsertTable">
							<tr>
								<td>${ctp:i18n('formtalk.mapper.coninsert')}</td>
								<td><input type="checkbox" id="isConfInsert"
									name="isConfInsert"
									<c:if test="${fn:contains(dataVO.isConfInsert,'true')}">checked="checked"</c:if>>
								</td>
								
							</tr>
						</table>
						<table id="isBackFillTable">
						<tr>
						<td>${ctp:i18n('formtalk.mapper.isBackFill')}</td>
								<td><input type="checkbox" id="isBackFill"
									name="isBackFill"
									<c:if test="${not fn:contains(dataVO.isBackFill,'false')}">checked="checked"</c:if>>
								</td>
						</tr>
						</table>
					</div>
				</fieldset>
				<!-- 数据条件END -->

				<br>
				<fieldset id="form_member" style="width: 100%; border: 1;">
					<legend>
						<b>${ctp:i18n('formtalk.mapper.send.member')}</b>
						<div class="question-help">
							?
							<div class="question-content">
								<div class="question-wapper"></div>
								${ctp:i18n('formtalk.message.member')}
							</div>
						</div>
					</legend>
					<div style="width: 100%; border: 0px;" align="left">
						<table id="table3" class="flexme3" border="0" cellspacing="1"
							cellpadding="0" width="100%">
							<tr bgcolor="#B5DBEB">
								<td width="15%">${ctp:i18n('formtalk.column.type')}</td>
								<td width="20%">${ctp:i18n('formtalk.mapper.send.member')}</td>
							</tr>
							<tr>
								<td width="15%"><select id="startType" name="startType"
									style="width: 200px;">
										<option value="1">${ctp:i18n('formtalk.mapper.send.select.member')}</option>
										<option value="2">${ctp:i18n('formtalk.mapper.item.data')}</option>
								</select></td>
								<td width="20%"><font color="red">*</font><input
									type="text" id="startMember" name="startMember"
									validate="notNull:true,name:'${ctp:i18n('formtalk.mapper.send.member')}'"
									class="validate word_break_all bindData"
									value="${ctp:toHTML(dataVO.startMemerMap.startName)}"
									style="width: 200px;"></td>
							</tr>
						</table>
					</div>
				</fieldset>
				<br>
			</div>
		</div>

		<div class="hidden" id="img"
			style="width: 16px; height: 30px; position: relative; float: right; border: 1px;"
			name="img">
			<div id="addDiv" style="height: auto;">
				<span title="${ctp:i18n('formtalk.jsp.Addblankline')}"
					class="ico16 repeater_plus_16" id="addImg" style="display: block;"></span>
			</div>
			<div id="addEmptyDiv" style="height: auto;">
				<span title="${ctp:i18n('formtalk.jsp.Deletethisrow')}"
					class="ico16 repeater_reduce_16" id="delImg"
					style="display: block;"></span>
			</div>
		</div>
	</form>
</body>