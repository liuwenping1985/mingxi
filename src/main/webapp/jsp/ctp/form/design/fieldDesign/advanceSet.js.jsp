<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<script type="text/javascript">
	String.prototype.replaceAll = function(s1,s2) { 
	    return this.replace(new RegExp(s1,"gm"),s2); 
	}
	var fieldType  = "${ctp:escapeJavascript(fieldType)}";
	var receiverId = "${ctp:escapeJavascript(receiverId)}";
	var formId = "${ctp:escapeJavascript(formId)}";
	var fieldindex = receiverId.substring(7,receiverId.length);
    var parentWin = window.dialogArguments[0].window;
	var parentWinDocument = parentWin.document;
	var currentfieldTypeArray = parentWin.currentfieldTypeArray;
	var currentInputTypeArray = parentWin.currentInputTypeArray;
	$().ready(function (){
		init();	
		adapterFooter();
	});
	//增加行
	function addRow(obj){
		if($(obj).parent().parent().parent().find("tr").length > 40){
			$.alert("${ctp:i18n('form.field.formula.max.message')}");
			return;
		}
		var randomNum = $(obj).parent().parent().parent().find("tr").length;
		var ifName="ifFormField" + randomNum;
		var resName = "resultFormField" + randomNum;
		var currentRow = $(obj).parents("tr").clone(true);
		currentRow.insertAfter($(obj).parents("tr"));
		$($(obj).parents("tr").next().find("textarea")[0]).attr("id",ifName);
		$($(obj).parents("tr").next().find("textarea")[1]).attr("id",resName);
		$($(obj).parents("tr").next().find("textarea")[0]).val("");
		$($(obj).parents("tr").next().find("textarea")[1]).val("");
		adapterFooter();
	}
	//删除行
	function delRow(obj){
		var trNum = $("#setArea tr").length;
		if(trNum == 2){
		    //$.alert("${ctp:i18n('form.base.delRow.alert')}！");
			/*var textareas = $(obj).parents("tr").find("textarea");
			 $(textareas[0]).val("");
			 $(textareas[1]).val("");*/
			$("#setArea tr").find("textarea").each(function(){
				$(this).val("");
			});
		}else{
			$(obj).parents("tr").remove();
		}
		adapterFooter();
	}
	//调整重置按钮区域的高度
	function adapterFooter(){
		if($("#headerDiv").height() > 500){
			$("#bottomDiv").removeClass("stadic_layout_footer");
		}else{
			if(!$("#bottomDiv").hasClass("stadic_layout_footer")){
				$("#bottomDiv").addClass("stadic_layout_footer");
			}
		}
	}
	//初始化
	function init(){
		$("#digitNormalSet").click(function (){
			changeNormalSet();
		});
		$("#modelSetText").click(function (){
			changeNormalSet();
		});
		//重置事件
		$("#abandon").click(function (index){
			var length = $("#setArea tr").length;
			$("#lastresultFormField").val("");
			$("#setArea tr").each(function (index){
				if(index===0){
				    $($(this).find("textarea")[0]).val("");
                    $($(this).find("textarea")[1]).val("");
					return true;
				}else if(index=== length-1){
				    return true;
				}else{
					$(this).remove();
				}
			});
			//initData();
			adapterFooter();
		});
		var index = receiverId.substring(7,receiverId.length);
		var fieldType = $("#fieldType"+index,parentWinDocument).val();
		if(fieldType == "VARCHAR"){
			$("#modelSetText").text("${ctp:i18n('form.field.formula.dynamic.normal.set')}");
			$("#advancedSetText").text("${ctp:i18n('form.field.formula.dynamic.advance.set')}");
		}
		initData();
	}
	//切换普通设置
	function changeNormalSet(){
		try{
			var obj = {'formId':formId,'index':fieldindex,'fieldType':fieldType};
			if(($("#ifFormField").val() != "" && $("#resultFormField").val()!=null) || ($("#resultFormField").val() != "" && $("#resultFormField").val()!=null) || $("#lastresultFormField").val() != ""){
				var dialog = $.confirm({
				    'msg': '${ctp:i18n("form.baseinfo.formula.change.error.label")}',
				    ok_fn: function () { 
				    	window.dialogArguments[0].window.changeDialog(window.dialogArguments[0].window.current_dialog,obj,0);
					},
					cancel_fn:function(){$("#digitAdvancedSet").attr("checked",true);dialog.close();}
				});
			}else{
		    	window.dialogArguments[0].window.changeDialog(window.dialogArguments[0].window.current_dialog,obj,0);
			}
		}catch(e){
			
		}
	}
	//初始化高级设置界面
	function initData(){
		var index = receiverId.substring(7,receiverId.length);
		var dataValue = $("#formulaData"+index,parentWinDocument).val();
		if(dataValue != "" && dataValue.indexOf("{") != -1){
			var dataObj = eval("("+dataValue+")");
			if(dataObj){
				var dataArray = dataObj.data;
				var value;
				if(dataArray && dataArray.length > 1){
					for(var i = 0;i < dataArray.length;i++){
						value = dataArray[i];
						if(value.sort == 0 && value.keyword == "if"){
							$("#ifFormField").val(value.condition);
							$("#resultFormField").val(value.result);
						}else if(value.sort == dataArray.length-1 && value.keyword == "else"){
							$("#lastresultFormField").val(value.result);
						}else{
							var randomNum = i;
							var ifName="ifFormField" + randomNum;
							var resName = "resultFormField" + randomNum;
							var k = i-1;
							var currentRow =$("#setArea tr").eq(0).clone(true);
							currentRow.insertAfter($("#setArea tr").eq(k));
							$($("#setArea tr").eq(k).next().find("textarea")[0]).attr("id",ifName);
							$($("#setArea tr").eq(k).next().find("textarea")[1]).attr("id",resName);
							$("#"+ifName).val(value.condition);
							$("#"+resName).val(value.result);
						}
					}
				}
			}
		}
	}
	//点击确定返回方法
	function OK(){
		//如果只有两行并且两行都是空的则可以保存。并且不提示。
		if(receiverId.startsWith("formula") && !($("#setArea").find("tr").length == 2 && $($("#setArea").find("tr").eq(0).find("textarea")[0]).val() === "" 
			&& $($("#setArea").find("tr").eq(0).find("textarea")[1]).val() === "" && $($("#setArea").find("tr").eq(1).find("textarea")[1]).val() === "")){
			var index1 = receiverId.substring(7,receiverId.length);
			var dataObj = $("#formulaData"+index1,parentWinDocument);
			var advanceObj =  $("#advance"+index1,parentWinDocument);
			//计算公式中含有日期差函数，设置显示格式
			var setFormat = false;
			if(dataObj){
				var dataStart = "{\"data\":[";
				var data="";
				var condition = "";
				var result = "";
				var isnull = false;
				var nullObj = null;
				$("#setArea").find("tr").each(function (index){
					condition = $($(this).find("textarea")[0]).val();
					result = $($(this).find("textarea")[1]).val();
					condition = condition.replaceAll("\"","'").replaceAll("\n","");
					result = result.replaceAll("\"","'").replaceAll("\n","");
					if((condition == "" || result == "") && index != $("#setArea").find("tr").length-1){
						nullObj = $(this).find("textarea")[0];
						isnull = true;
						return false;
					}
					if(index === 0){
						data = data + "{\"keyword\":\"if\",\"condition\":\""+condition+"\",\"result\":\""+result+"\",\"sort\":\""+index+"\"},";
					}else if(index === $("#setArea").find("tr").length-1){
						if(result == ""){
							nullObj = $(this).find("textarea")[1];
							isnull = true;
							return false;
						}
						data = data + "{\"keyword\":\"else\",\"condition\":\""+condition+"\",\"result\":\""+result+"\",\"sort\":\""+index+"\"},";
					}else{
						data = data + "{\"keyword\":\"else if\",\"condition\":\""+condition+"\",\"result\":\""+result+"\",\"sort\":\""+index+"\"},";
					}
                    setFormat = setDateFormat(setFormat,index1,result);
				});
				if(isnull && nullObj != null){
						$(nullObj).focus();
						$.alert("${ctp:i18n('form.field.formula.advance.notnull')}");
						return;
				}
				if(data != ""){
					//截取最后一个字符
					var lastChar = data.substring(data.length-1,data.length);
					if(lastChar == ","){
						data = data.substring(0,data.length-1);
					}
				}
				var dataEnd = "]}";
				var dataArray = dataStart + data + dataEnd;
				$(dataObj).attr("value",dataArray);
			}
            $("#formula"+index1,parentWinDocument).attr("isAdvance","1");
			if(advanceObj){
				$(advanceObj).show();
				$("#"+receiverId,parentWinDocument).val("${ctp:i18n('form.formula.advance.hasset.laebl')}");
                parentWin.setEnumImageFormat(fieldindex,data);
			}
		}else{
			$("#formulaData"+fieldindex,parentWinDocument).val("");
			//$("#isAdvance"+fieldindex,parentWinDocument).attr("value",0);
			//OA-85558  表单字段设置高级计算，重置后，切换字段类型为数字，此时高级计算标记又出来了，且点击显示为空
			$("#formula"+fieldindex,parentWinDocument).attr("isAdvance","0");
			$("#advance"+fieldindex,parentWinDocument).hide();
			$("#"+receiverId,parentWinDocument).val("");
			if($("#fieldType"+fieldindex,parentWinDocument).val() == "DECIMAL"){
				$($("#formatType"+fieldindex,parentWinDocument).find("option")[3]).prop("value","<%=FormConstant.DateTime%>");
				$($("#formatType"+fieldindex,parentWinDocument).find("option")[4]).prop("value","<%=FormConstant.Day%>");
				//$("#formatType"+fieldindex,parentWinDocument).val("");
				$("#digitNum"+fieldindex,parentWinDocument).val($("#digitNum"+fieldindex,parentWinDocument).val());
			}
		}
		return true;
	}
	//设置普通计算式
	function setCondition(obj){
		setFieldHighCondition(obj,fieldindex,parentWinDocument);
	}
	//设置结果计算式
	function setResult(obj){
		setFieldHighFormula(obj,fieldindex,parentWinDocument);
	}
	//展示按钮
	function showButton(obj){
		$(obj).find("#add").show();
		$(obj).find("#del").show(); 
	}
	//隐藏按钮
	function hiddenButton(obj){
		$(obj).find("#add").hide();
		$(obj).find("#del").hide(); 
	}
	//获得随机数
	function getRandom(n){
		return getUUID();
	}

    function setDateFormat(setFormat,index1,result){
        //判断公式中含有日期差函数
        if(!setFormat && $("#fieldType"+index1,parentWinDocument).val() == "DECIMAL"){
            var setDigitNum = $("#digitNum"+index1,parentWinDocument).val() == "" ? 5 : $("#digitNum"+index1,parentWinDocument).val();
            if(result.indexOf("differDateByWorkDay(") != -1){
                $($("#formatType"+index1,parentWinDocument).find("option")[4]).prop("value","<%=FormConstant.WorkDay%>");
                $("#formatType"+index1,parentWinDocument).val("<%=FormConstant.WorkDay%>");
                $("#digitNum"+index1,parentWinDocument).val(setDigitNum);
                if(setDigitNum === 5)$("#fieldLength"+index1,parentWinDocument).val(20);
                setFormat = true;
            }else if(result.indexOf("differDateTimeByWorkDay(") != -1){
                $($("#formatType"+index1,parentWinDocument).find("option")[3]).prop("value","<%=FormConstant.WorkDateTime%>");
                $("#formatType"+index1,parentWinDocument).val("<%=FormConstant.WorkDateTime%>");
                $("#digitNum"+index1,parentWinDocument).val(setDigitNum);
                if(setDigitNum === 5)$("#fieldLength"+index1,parentWinDocument).val(20);
                setFormat = true;
            }else if(result.indexOf("differDateTime(") != -1){
                $($("#formatType"+index1,parentWinDocument).find("option")[3]).prop("value","<%=FormConstant.DateTime%>");
                $("#formatType"+index1,parentWinDocument).val("<%=FormConstant.DateTime%>");
                $("#digitNum"+index1,parentWinDocument).val(setDigitNum);
                if(setDigitNum === 5)$("#fieldLength"+index1,parentWinDocument).val(20);
                setFormat = true;
            }else if(result.indexOf("differDate(") != -1){
                $($("#formatType"+index1,parentWinDocument).find("option")[4]).prop("value","<%=FormConstant.Day%>");
                $("#formatType"+index1,parentWinDocument).val("<%=FormConstant.Day%>");
                $("#digitNum"+index1,parentWinDocument).val(setDigitNum);
                if(setDigitNum === 5)$("#fieldLength"+index1,parentWinDocument).val(20);
                setFormat = true;
            }else{
                $($("#formatType"+index1,parentWinDocument).find("option")[3]).prop("value","<%=FormConstant.DateTime%>");
                $($("#formatType"+index1,parentWinDocument).find("option")[4]).prop("value","<%=FormConstant.Day%>");
                if($("#formatType"+index1,parentWinDocument).val() != "<%=FormConstant.WorkDateTime%>" && $("#formatType"+index1,parentWinDocument).val() != "<%=FormConstant.WorkDay%>"
                        && $("#formatType"+index1,parentWinDocument).val() != "<%=FormConstant.DateTime%>" && $("#formatType"+index1,parentWinDocument).val() != "<%=FormConstant.Day%>"){
                    $("#formatType"+index1,parentWinDocument).val($("#formatType"+index1,parentWinDocument).val());
                }else{
                    //$("#formatType"+index1,parentWinDocument).val("");
                }
                $("#digitNum"+index1,parentWinDocument).val($("#digitNum"+index1,parentWinDocument).val());
            }
        }
        return setFormat;
    }
</script>