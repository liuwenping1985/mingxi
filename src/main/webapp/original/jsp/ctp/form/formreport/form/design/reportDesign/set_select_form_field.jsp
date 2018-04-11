<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/common/formulaCommon.js.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" src="${url_ajax_reportDesignManager}"></script>
    <title>选择表单字段</title>
    <script type="text/javascript">
        var formReportDesignManager_ = new formReportDesignManager();
        //获取父窗口参数
        var parentPara = window.dialogArguments;
        var from = "${ctp:escapeJavascript(from)}";
        var setReportHead = "setReportHead";
        var showDataList = "setShowDataList";
        var setCrossColumn = "setCrossColumn";
        //存放所有的表单数据域
        var fields = new Properties();
        //判断公式列是修改还是添加
        var isFormulaAdd = true;

        $(function () {
        	$("#unselect").click(function() {
        		//OA-54884_ie8下设置不成功
        		//$("#columnUnselect").find("option:selected").attr("selected",false);
        		var selected = $("#columnUnselect").find("option:selected");
        		if(!$.isNull(selected)){
        			selected.before(selected.clone());
        			selected.remove();
        		}
        		var columnDataUnselect = $("#columnDataUnselect").find("option:selected").removeAttr("selected");
        		//if(!$.isNull(columnDataUnselect)){
        		//	columnDataUnselect.before(columnDataUnselect.clone());
        		//	columnDataUnselect.remove();
        		//}
			});
        	$("#columnUnselect").click(function() {
        		//OA-54884_ie8下设置不成功
        		//$("#unselect").find("option:selected").attr("selected",false);
        		var selected = $("#unselect").find("option:selected");
        		if(!$.isNull(selected)){
        			selected.before(selected.clone());
        			selected.remove();
        		}
			});
        	$("#columnDataUnselect").click(function(){
        		$("#unselect").find("option:selected").attr("selected",false);
        	})
            //定义左右选择面板
            var set = setBordFun(true, "", "", 200);

            $("#select_ico").click(function () {
                var returnValue = false;
                //汇总列和公式列
            	var selectColumn = $("#columnUnselect").find("option:selected");//汇总列
            	var columnDataUnselect=$("#columnDataUnselect").find("option:selected");//系统数据域
            	if($("#selected option").length == 200){
            		$.alert("最多只能选择200条");
            	}else if(selectColumn.length > 0){
            		if(hasShowDataList()){
						//公式列
						if($(selectColumn[0]).val() == "formula"){
							//有计算列设置成交叉后就不能设置公司列
							if($("#selected").find("option[crossType='cross']").length > 0){
								$.alert("${ctp:i18n('report.reportDesign.crossSet.msg')}");
								return;
							}
							
							var dataArray=new Array();
							var num = 0;
							$("#selected").find("option").each(function(){
								var showName = "";
								if($(this).attr("type") == "column"){
									if($(this).val() != "formula" && "cross" != $(this).attr("crossType")){//计算列交叉 不能参与公司列计算
										showName = $(this).attr("title");
										dataArray[num]={"name":showName};
										num++;
									}
								}else{
									showName = $(this).attr("newShowTitle");
									dataArray[num]={"name":showName};
									num++;
								}
							});
							isFormulaAdd = true;
							setFormula4Static(getReturnValue,0,"",selectColumn.attr("title"),"",dataArray,checkReturnValue);
						}else{
							//汇总列只能选择一次
							if(!$("#columnUnselect").find($(selectColumn[0])).hasClass("color_gray")){
								$("#selected option").attr("selected", false);
								var selectObj = $(selectColumn[0]).clone(true);
								selectObj.attr("selected", true);
								$("#selected").append(selectObj);
								$("#selected").trigger("dblclick");
								$(selectColumn[0]).addClass("color_gray");
							}else{
								$.alert("${ctp:i18n('report.reportDesign.set.chooseRepeat')}");
							}
						}
            		}
            	}else if(columnDataUnselect.length>0){
            		$("#selected option").attr("selected", false);
            		for(var i=0;i<columnDataUnselect.length;i++){
            			var selectObj = $(columnDataUnselect[i]).clone(true);
            			if(!selectObj.hasClass("color_gray")){
							selectObj.attr("selected", true);
							selectObj.attr("isDataFiled",true);
							selectObj.attr("newShowTitle",selectObj.attr("title"));
							$("#selected").append(selectObj);
							$(columnDataUnselect[i]).addClass("color_gray");
            			}else{
            				$.alert("${ctp:i18n('report.reportDesign.set.chooseRepeat')}");
            				return "";
            			}
            		}
					
            	}else{
            		returnValue = set.add();
            	}
            	
                if (returnValue) {
                    var unselectObj = $("#unselect").find("option:selected");
                    $("#columnDataUnselect option").attr("selected",false);
                    unselectObj.each(function () {
                        var value = $(this).val();
                        var selectedObj = $("#selected option[value='" + value + "']:last");
                        selectedObj.text(subName(selectedObj.text()));
                        if (from === setReportHead) {
                            var fieldType = fields.get(value).fieldType;
                            if (fieldType.toUpperCase() == "TIMESTAMP"||fieldType.toUpperCase()=="DATETIME") {
                                selectedObj.attr("dateType", "day");
                                var text = selectedObj.text();
                                selectedObj.text(selectedObj.text() + " " +"${ctp:i18n('report.reportDesign.groupDay')}");
                            }
                        } else if (from === showDataList) {
                            $("#selected option").attr("selected", false);
                            try{
                            	selectedObj.attr("selected", true);
                            	var changeold =  selectedObj.attr("enumchangeold");
                            	selectedObj.attr("enumchange",changeold);
                            }catch(e){}
                            $("#selected").trigger("dblclick");
                        }
                    });
                }
            });
            $("#unselect_ico").click(function () {
            	var selectDataId=$("#selected").find("option:selected").attr("isDataFiled");
            	var hasNoError = true;
            	var chartChoiceData = "${ctp:escapeJavascript(chartChoiceData)}";
            	if(from === showDataList){
            		if(checkColumn()){
            			set.removeObj.find("option:selected").each(function(){
            				var text = $(this).val();
            				var title = $(this).attr("newshowtitle");//点击取消的时候 为空，是可以去掉这个字段的
            				var hasChartSet = checkChartSet(chartChoiceData,title);
            				if(chartChoiceData != "" && hasChartSet && hasNoError){
		                        hasNoError = false;
            				}
            			});
            			if(hasNoError){
            				set.removeObj.find("option:selected").each(function(){
            				    var obj = $(this);
            					$("#columnUnselect").find("option").each(function(){
            						if(obj.val() == $(this).val()){
            							$(this).removeClass("color_gray");
            						}
            					});
            				});
            				set.remove();
            			}else{
            				$.error("${ctp:i18n('report.reportDesign.error.alert')}");
            			}
            		}
            	}else{
            		$("#selected").find("option:selected").each(function(){
            			var text = $(this).val();
            			var title = $(this).attr("newshowtitle");//点击取消的时候 为空，是可以去掉这个字段的
            			var hasChartSet = checkChartSet(chartChoiceData,title);
            			if(chartChoiceData !="" && hasChartSet && hasNoError){
		                    hasNoError = false;
            			}
            		});
            		if(hasNoError){
            			$("#selected").find("option:selected").each(function(){
	            			var obj = $(this);
	            			$("#columnDataUnselect").find("option").each(function(){
	            				if(obj.val() == $(this).val()){
	            					$(this).removeClass("color_gray");
	            				}
	            			});
            			});
            			set.remove();
            		}else{
            			$.error("${ctp:i18n('report.reportDesign.error.alert.fenzu')}");
            		}
            	}
            });
            $("#sort_up").click(function () {
                set.moveT(set.removeObj);
            });
            $("#sort_down").click(function () {
                moveDown(set,set.removeObj);
            });
            //初始化选项高度
            if(from === showDataList && ( ${ctp:getSystemProperty('system.ProductId')} != 0 && ${ctp:getSystemProperty('system.ProductId')} != 7)){
            	$("#unselect").height(220);
            }
            //初始化高度
            if(from === setReportHead){
            	$("#unselect").height(220);
            }
            /**
             * 按enter键搜索 
             */
            $("#searchField").keyup(function(event) {
                if (event.keyCode == 13) {
                	searchField();
                }
            });
            //初始化表单数据域
            ajaxFindFieldsById();
            //初始化已选择项
            initSelectedFields();
            //初始化双击事件
            initDbClick();
            //初始化单击事件（目前只有交叉列需要）
            initClick();
        });
        //截取字段名称前面的主表重表
        function subName(text){
            return text.substring(text.indexOf("]")+1);
        }
        
        //判断图是否设置了选中字段
        function checkChartSet(chartChoiceData,title){
        	var chartSetArr = chartChoiceData.split(",");
        	for(var i=0;i<chartSetArr.length;i++){
        		if(title == chartSetArr[i]){
        			return true;
        		}
        	}
        	return false;
        }
        //下移
        function moveDown(set,obj){
			var moveList=set.base(obj);
			var moveLength=moveList.length;//需要下移的项
			var objLength=obj.find("option").length;//所有已选中的项数
			for(var i=0;i<moveList.length;i++){
				var option=$(moveList[moveLength-i-1]);
				var ele=obj.find("option").eq(objLength-i-1);
				var temp=option.next("option");
				option.before(temp);
			}
		}
		//判断移除后还有统计项和公式列没有
		function checkColumn(){
			var hasUnselect = false;
			var hasColumnUnselect = false;
			var canRemove = true;
			$("#selected option:not(:selected)").each(function(){
				if($(this).attr("type") == "unselect"){
					hasUnselect = true;
				}else{
					hasColumnUnselect = true;
					if($(this).val() == "formula"){
						var formulastr = $(this).attr("formulastr");
						$("#selected").find("option:selected").each(function(){
							var index = formulastr.indexOf("["+$(this).attr("newShowTitle")+"]");
							//OA-71761
							if("column" == $(this).attr("type")){
								index = formulastr.indexOf("["+$(this).attr("title")+"]");
							}
							if(index != -1){
								canRemove = false;
							}
						});
						
					}
				}
			});
			//移除的统计项，设置在公式列的公式里面，不能移除
			if(!canRemove){
				$.alert("${ctp:i18n('report.reportDesign.set.canNotRemove')}");
				return false;
			}
			//在有列汇总公式列，而没有统计项的时候是不允许移除的
			if(hasColumnUnselect && !hasUnselect){
				$.alert("${ctp:i18n('report.reportDesign.set.canNotCovarianceItem')}");
				return false;
			}
				return true;
		}
		//判断是否有统计项
		function hasShowDataList(){
			if($("#selected option").length <= 0){
				$.alert("${ctp:i18n('report.reportDesign.set.selectCovarianceItem')}");
				return false;
			}
			return true;
		}
        //初始化selected/unselect双击事件
        function initDbClick() {
            $("#selected").dblclick(function () {
                var _self = $(this).find("option:selected");
                if (_self.length == 1 && _self.attr("type") != "column") {
                    var text = _self.text();
                    var value = _self.val();
                    //记录field原始标题
                    var oldShowTitle = $("#unselect option[value='" + value + "']").text();
                    if(oldShowTitle==""){
                    	oldShowTitle=$("#columnDataUnselect option[value='"+value+"']").text();
                    }
                    oldShowTitle = subName(oldShowTitle)
                    //记录field修改后的标题，如果没有修改过标题，即和原始标题一样
                    var newShowTitle = _self.attr("newShowTitle");
                    newShowTitle = (newShowTitle == "" || newShowTitle == null || newShowTitle == "undefined") ? oldShowTitle : newShowTitle;
                    //字段类型
                    var fieldType = $("#unselect option[value='" + value + "']").attr("fieldType");
                    if(fieldType==undefined){
                    	fieldType=$("#columnDataUnselect option[value='"+value+"']").attr("fieldType");
                    }
                    if (from == setReportHead) {
                        $("#reportHeadName").text(oldShowTitle);
                        $("#reportHeadNameModify").attr("value", newShowTitle);
                        $("#reportHeadNameModify").attr("title", newShowTitle);
                        $("input[name='dateType']").removeAttr("checked");
                        //日期控件统计类型年、月、日、季，默认按日统计
                        if (fieldType.toUpperCase() == "TIMESTAMP"||fieldType.toUpperCase() == "DATETIME") {
                            $("#dateTypeTr").removeClass("hidden");
                            var dateType = _self.attr("dateType");
                            dateType = (dateType == "" || dateType == null) ? "day" : dateType;
                            $("input[name='dateType'][value='" + dateType + "']").attr("checked", true);
                        } else {
                            $("#dateTypeTr").addClass("hidden");
                        }
                    } else if (from == showDataList) {
                        $("#showDataListName").text(oldShowTitle);
                        $("#showDataListNameModify").attr("value", newShowTitle);
                        $("#showDataListNameModify").attr("title", newShowTitle);
                        //数字型字段默认为求和，所有选项可选；非数字型字段默认是计数，且其他选项不可选
                        $("input[name='calcOperator']").removeAttr("checked")
                        if (fieldType.toUpperCase() == "DECIMAL") {
                            var staticsType = _self.attr("staticsType");
                            staticsType = (staticsType == "" || staticsType == null) ? "sum" : staticsType;
                            $("input[name='calcOperator']").removeAttr("disabled");
                            $("input[name='calcOperator'][value='" + staticsType + "']").attr("checked", true);
                        } else {
                            $("input[name='calcOperator'][value!='count']").attr("disabled", true);
                            $("input[name='calcOperator'][value='count']").attr("checked", true);
                        }
                    }
                    showSelectedModifyDialog(_self);
                }else if(_self.length == 1 && _self.val() == "formula"){
                	var formId= 0;
                	var formulastr = _self.attr("formulastr") == " " ? "":_self.attr("formulastr");
                	var title = _self.attr("title");
                	var formattype = _self.attr("formattype")=="#" ? "##,###,###0" : _self.attr("formattype");
                	var dataArray=new Array();
					var num = 0;
					$("#selected").find("option").each(function(){
						var showName = "";
						if($(this).attr("type") == "column"){
							if($(this).val() != "formula"){
								showName = $(this).attr("title");
								dataArray[num]={"name":showName};
								num++;
							}
						}else{
							showName = $(this).attr("newShowTitle");
							dataArray[num]={"name":showName};
							num++;
						}
					});
					isFormulaAdd = false;
                	setFormula4Static(getReturnValue,formId,formulastr,title,formattype,dataArray,checkReturnValue);
                }else if(_self.length == 1){//列汇总
                	var colText = _self.text();
                	if(colText.indexOf("(") != -1){
                		colText = colText.substring(0, colText.indexOf("("));
                	}
                	 $("#countColumn").text(colText);
                	 $("#countColumnName").attr("value",_self.attr("title"));
                	 showSelectedModifyDialog(_self);
                }
            });
            $("#unselect,#columnDataUnselect").dblclick(function () {
                if (from === setCrossColumn) {
                    var _self = $(this).find("option:selected");
                    // 系统数据域 交叉项双击没有反应 因为系统数据域不能通过 表单field获取，单独判断
                    if("start_member_id" == _self.val() || "start_date" == _self.val() || "modify_date" == _self.val()){
                    	parent.$(".dialog_main_footer .common_button").eq(0).trigger("click");
                    	return; 
                    }
                    var field = fields.get(_self.val());
                    var fieldType = null; //协同V5.0 OA-19141
                    try {
                        fieldType = field.fieldType;
                    } catch (e) { return; }
                    //交叉列日期类型修改
                    if (fieldType != "" && fieldType != null && (fieldType.toUpperCase() == "TIMESTAMP"||fieldType.toUpperCase() == "DATETIME")) {
                    	var dateType = _self.attr("dateType");
                        $("#crossColumnName").text(field.display);
                        $("input[name='crossColumnDateType']").attr("checked", false);
                        dateType = (dateType == "" || dateType == null) ? "day" : dateType;
                        $("input[name='crossColumnDateType'][value='" + dateType + "']").attr("checked", true);
                        showSelectedModifyDialog(_self);
                    } else {
                        parent.$(".dialog_main_footer .common_button").eq(0).trigger("click");
                    }
                } else {
                    $("#select_ico").trigger("click");
                }
            });
            $("#columnUnselect").dblclick(function () {
        		$("#select_ico").trigger("click");
        	});
        }
        //回调函数，填值
        function getReturnValue(formulastr,headTitle,formattype){
        	headTitle =	$.trim(headTitle);
        	var opt = "";
        	if(isFormulaAdd){
        		//OA-72716 ie7 下不能使用clone的option 因为修改title属性的时候会将克隆的几个title属性全部修改掉
        		var text = "${ctp:i18n('report.reportDesign.formula')}";
        		if(text != headTitle){
            		text = text+"("+headTitle+")";
            	}
            	var formattypeNew = formattype;
            	if(formattype == "##,###,###0"){//千分位标识
					formattypeNew = "#";
				}
        		opt = "<option title=\""+headTitle+"\" formulastr=\""+formulastr+"\" formattype=\""+formattypeNew+"\" type=\"column\" value=\"formula\">"+text+"</option>";
        		$("#selected").append(opt);
        	}else{
        		opt = $("#selected").find("option:selected");
        		parentPara.chartData = changeChartField(parentPara.chartData,opt.attr("title"),headTitle);
        		if(formulastr == ""){
					opt.attr("formulastr"," ");
				}else{
					opt.attr("formulastr",formulastr);
				}
				var text = opt.text();
				if(text.indexOf("(") != -1){
					text = text.substring(0, text.indexOf("("));
				}
				if(text != headTitle){
					text = text+"("+headTitle+")";
				}
				opt.text(text);
				opt.attr("title",headTitle);
				
				if(formattype == "##,###,###0"){
					opt.attr("formattype","#");
				}else{
					opt.attr("formattype",formattype);
				}
        	}
        }
        //检查值是否符合要求
        function checkReturnValue(formulastr,headTitle,formattype){
        	headTitle =	$.trim(headTitle);
        	//选择项
        	var obj = "";
        	if(isFormulaAdd){
        		obj = $("#selected option");
        	}else{
        		obj = $("#selected option:not(:selected)");
        	}
            //统计分组项或者统计项的标题
            var parentNewTitleOther = parentPara.selectedNewShowTitleOther.split(",");
			//列汇总公式列
            //交叉列标题
            var parentNewTitleCross = parentPara.selectedNewShowTitleCross;
            if($.isNull(headTitle)){
            	$.error("${ctp:i18n('report.reportDesign.dialog.staticsitem.noTitleEmpty')}");
            	return false;
            }
            if($.isNull(formulastr)){
            	$.error("${ctp:i18n('report.reportDesign.set.noFormulaEmpty')}");
            	return false;
            }
            //特殊字符判断
            for(var i=0;i<headTitle.length;i++){
            	if("!,@/#$%^:&*()\'\"><".indexOf(headTitle[i]) != -1){
            		$.error("${ctp:i18n('report.reportDesign.dialog.prompt.titleInput')}");
            		return false;
            	}
            }
            for (var i = 0; i < obj.length; i++) {
                if (headTitle === $(obj[i]).attr("newShowTitle") || headTitle === $(obj[i]).attr("title") ) {
                    $.error("${ctp:i18n('report.reportDesign.set.errorFormulastr')}");
                    return false;
                }
            }
        	for(var i = 0;i < parentNewTitleOther.length; i++){
                if(headTitle === parentNewTitleOther[i]){
                	$.error("${ctp:i18n('report.reportDesign.set.errorRepetition')}");
                    return false;
                }
            }
        	if(headTitle === parentNewTitleCross){
                $.error("${ctp:i18n('report.reportDesign.set.errorRepetition')}");
                return false;
            }
			return true;
		}
        //初始化单击事件
        function initClick() {
            if (from === setCrossColumn) {
                $("#unselect").click(function () {
                    var fieldType = $(this).find("option:selected").attr("fieldType");
                    if (!$.isNull(fieldType) && (fieldType.toUpperCase() == "TIMESTAMP" || fieldType.toUpperCase() =="DATETIME")) {
                    	//日期或者日期时间类型需要添加单击事件
                        $("#unselect").trigger("dblclick");
                    }
                });
            }
        }

        //分组统计项、统计项 双击已选择字段时触发弹出框操作
        function showSelectedModifyDialog(obj) {
            var dialogId = 'reportHeadRenameDialog';
            var dialogHtmlId = 'reportHeadRenameDiv';
            var dialogHtml = $("#reportHeadRenameDiv").html();
            var dialogTitle = "${ctp:i18n('report.reportDesign.dialog.groupingitem.title')}";
            var height = 200;
            if (from === showDataList) {
                $("#enumchange").hide();
                var objChange = obj.attr("enumchange");
                if(((!$.isNull(obj.attr("enumchangeold")) && obj.attr("enumchangeold") != "0" ) || ( !$.isNull(objChange) && !$.isNull(objChange.trim()) && objChange != "0" ))
                	&& obj.attr("repeat") == "true" && (parentPara.formType == "3" || parentPara.formType == "2")){
                	$("#unselect").find("option:selected").removeClass("color_gray");
                	$("#enumchange").show();
                	height = 250;
                	$("#calcOperator1").removeAttr("disabled");
					if(obj.attr("staticstype") == "change"){
                		$("#calcOperator1").attr("checked",'true');
                	}
					ajaxFindEnums(obj);
                }
                dialogId = 'showDataListDialog';
                dialogHtmlId = 'showDataListDiv';
                dialogHtml = $("#showDataListDiv").html();
                //dialogTitle = "${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}";
                dialogTitle = "${ctp:i18n('report.reportDesign.set.outputData')}";
                if(obj.attr("type") == "column"){
                	//计算列和公式列显示格式
                	$("#formattype").empty();
					var formatOption = "<option value=''></option>";
					if("#" == obj.attr("formattype")){
						formatOption = formatOption + "<option value='#' selected='selected'>"+ "${ctp:i18n('report.reportDesign.micrometer')}"
							+ "</option><option value='%'>" + "${ctp:i18n('report.reportDesign.percent')}" +"</option>";
					}else if("%" == obj.attr("formattype")){
						formatOption = formatOption + "<option value='#'>"+ "${ctp:i18n('report.reportDesign.micrometer')}"
							+ "</option><option value='%' selected='selected'>" + "${ctp:i18n('report.reportDesign.percent')}" +"</option>";
					}else{
						formatOption = formatOption + "<option value='#'>"+ "${ctp:i18n('report.reportDesign.micrometer')}"
							+ "</option><option value='%'>" + "${ctp:i18n('report.reportDesign.percent')}" +"</option>";
					}
					$("#formattype").append(formatOption);
                	//计算列 交叉 设置
                	if("true" == parentPara.isCross){
                		$("#crossType").empty();
                		var crossTypeOption = "";
                		if("cross" == obj.attr("crossType")){
							crossTypeOption = "<option value=''>" + "${ctp:i18n('report.reportDesign.crossSet.ordinary')}" 
                				+ "</option><option value='cross' selected='selected'>" + "${ctp:i18n('report.reportDesign.crossSet.cross')}" +"</option>";
						}else{//缺省值是普通
							crossTypeOption = "<option value=''>" + "${ctp:i18n('report.reportDesign.crossSet.ordinary')}" 
                				+ "</option><option value='cross'>" + "${ctp:i18n('report.reportDesign.crossSet.cross')}" +"</option>";
						}
                		$("#crossType").append(crossTypeOption);
                	}else{
                		$("#crossTypeTr").remove();
                	}
                	dialogHtml = $("#summarycolumn").html();
                }
            } else if (from === setCrossColumn) {
                dialogId = 'crossColumnDialog';
                dialogHtmlId = 'crossColumnDiv';
                dialogHtml = $("#crossColumnDiv").html();
                dialogTitle = "${ctp:i18n('report.reportDesign.dialog.acrossreportSet.title')}";
            }
            var dialog = $.dialog({
                id: dialogId,
                html: dialogHtml,
                title: dialogTitle,
                targetWindow: window.parent,
                width: 350,
                height: height,
                closeParam :{'show':true,
                			handler:function(){
                				if (from == showDataList) {
                            		var flag = $("#selected").find("option:selected").attr("staticsType");
                            		var flag1 = $("#selected").find("option:selected").attr("formattype");
                            		if ((flag == null || flag == "undefined" || flag == "") && obj.attr("type") == "unselect") {
                                		$("#unselect_ico").trigger("click");
                            		}else if((flag1 == null || flag1 == "undefined") && obj.attr("type") == "column"){
                            			$("#unselect_ico").trigger("click");
                            		}
                        		}else if(from == "setCrossColumn"){
                        			var dateType = $("#unselect").find("option:selected").attr("dateType");
                        			if(dateType == undefined){
                        				var text = $("#unselect").find("option:selected").text();
                        				$("#unselect").find("option:selected").text(text+" " +"${ctp:i18n('report.reportDesign.groupDay')}");
                        				$("#unselect").find("option:selected").attr("dateType","day");
                        			}
                        		}
                        		dialog.close();
                				}
                			},
                buttons: [{
                    text: "${ctp:i18n('report.reportDesign.button.confirm')}",
                    isEmphasize: true,
                    handler: function () {
                        var modifyInput = dialog.targetWindow.$("#reportHeadNameModify");
                        var input = dialog.targetWindow.$("input[name='dateType']:checked");
                        var formattype = "";//列汇总和公式显示格式
                        var crossType = "";//计算列交叉 设置
                        
                        var enumchange1 =  dialog.targetWindow.$("#enumchange1 option:selected");
                        var enumchange2 =  dialog.targetWindow.$("#enumchange2 option:selected");
                        if(from === showDataList){
                            modifyInput = dialog.targetWindow.$("#showDataListNameModify");
                            input = dialog.targetWindow.$("input[name='calcOperator']:checked");
                            
                            if(obj.attr("type") == "column"){
                            	modifyInput = dialog.targetWindow.$("#countColumnName");
                            	formattype = dialog.targetWindow.$("#formattype").val();
                            	//计算列 交叉统计设置
                            	if("true" == parentPara.isCross){
									crossType = dialog.targetWindow.$("#crossType").val();
									try {// 由于在each中return 是无法跳出整个方法的 所以这里跑出了一个异常 
										$("#selected").find("option[type='column']").each(function() {
											var thisCrossType = $.isNull($(this).attr("crossType")) ? "":$(this).attr("crossType");
											if(obj.val() != $(this).val() && crossType != thisCrossType){
												throw "${ctp:i18n('report.reportDesign.crossSet.msg')}";
											}
										});
									}catch (e) {
										$.alert(e);
										return;
									}
                            	}
                            }
                        }else if(from === setCrossColumn){
                            modifyInput = dialog.targetWindow.$("#crossColumnNameShow");
                            input = dialog.targetWindow.$("input[name='crossColumnDateType']:checked");
                        }
                         var checkInp=false;
                        checkInp=dialog.targetWindow.MxtCheckInput(modifyInput);
                        //特殊字符判断 
                        if (checkInp) {
                            //重名判断
                            var modifyName = $.trim(modifyInput.val());
                          	if(from != setCrossColumn && $.isNull(modifyName)){
                          		$.error("${ctp:i18n('report.reportDesign.dialog.staticsitem.noTitleEmpty')}");
                          		return ;
                          	}
                            if (from == setCrossColumn || !checkRepeat(obj, modifyName)) {
                                //列汇总
                                if(obj.attr("type") == "column"){
                                	parentPara.chartData = changeChartField(parentPara.chartData,obj.attr("title"),modifyName);
                                	var title = obj.text()
                                	if(title.indexOf("(") != -1){
                                		title = title.substring(0, title.indexOf("(")); 
                                	}
                                	if(title == modifyName){
                                		obj.text(title);
                                	}else{
                                		obj.text(title+"("+modifyName+")");
                                	}
                                	changeformulastr(obj.attr("title"),modifyName);
                                	obj.attr("title",modifyName);
                                	obj.attr("formattype",formattype);
                                	obj.attr("crossType",crossType);
                                }else{
									//原始标题
									var oldTitle="";
									if(fields.get(obj.val())!=undefined){
										oldTitle = fields.get(obj.val()).display;
									}else{
										oldTitle=$("#columnDataUnselect option[value='"+obj.val()+"']").attr("title");
									}
									//修改后显示的标题 
									var temp = "";
									if (from === setReportHead) {
										parentPara.chartHead = changeChartField(parentPara.chartHead,obj.attr("newShowTitle"),modifyName);
										obj.attr("newShowTitle", modifyName);
										//设置修改后的标题
										temp = (oldTitle != modifyName) ? oldTitle + "(" + modifyName + ")" : oldTitle;
										var fieldType="";
										if(fields.get(obj.val())!=undefined){
											fieldType = fields.get(obj.val()).fieldType;
										}else{
											fieldType=$("#columnDataUnselect option[value='"+obj.val()+"']").attr("fieldType");
										}
										//日期控件统计类型枚举key
										var dateType = input.val();
										//日期控件统计类型年、月、日、季
										if (fieldType.toUpperCase() == "TIMESTAMP"||fieldType.toUpperCase()=="DATETIME") {
											//日期控件统计类型枚举value
											var dateText = input.parents("label").text();
											temp = (oldTitle != modifyName) ? (oldTitle + "(" + modifyName + ")" + " " + dateText) : (oldTitle + " " + dateText);
										}
										obj.attr("dateType", dateType);
									} else if (from === showDataList) {
										parentPara.chartData = changeChartField(parentPara.chartData,obj.attr("newShowTitle"),modifyName);
										changeformulastr(obj.attr("newShowTitle"),modifyName);
										obj.attr("newShowTitle", modifyName);
										//统计类型枚举key
										var staticsType = input.val();
										//统计类型枚举value
										var staticsText = input.parents("label").text();
										//设置修改后的标题
										temp = (oldTitle != modifyName) ? (oldTitle + "(" + modifyName + ")" + " " + staticsText) : (oldTitle + " " + staticsText);
										var enumchange = obj.attr("enumchange").split("&")[0];
										var initEnumchange = enumchange;
										if(staticsType == "change"){
											temp = temp + " 从\"" + enumchange1.attr("display") + "\"变到\"" + enumchange2.attr("display") + "\"";
											enumchange =enumchange +"&"+ enumchange1.val() + "&" + enumchange2.val() ;
										}
										obj.attr("enumchange", enumchange);
										obj.attr("staticsType", staticsType);
									} else if (from === setCrossColumn) {
										//日期控件统计类型枚举value
										var dateText = input.parents("label").text();
										//日期控件统计类型枚举key
										var dateType = input.val();
										var t = obj.text();
										temp =t.substring(0,t.indexOf("]")+1) + oldTitle + " " + dateText;
										obj.attr("dateType", dateType);
									}
									obj.text(temp);
                                }
								dialog.close({ isFormItem: true });
                            }
                        }
                    }
                }, {
                    text: "${ctp:i18n('report.reportDesign.button.cancel')}",
                    handler: function () {
                        if (from == showDataList) {
                            var flag = $("#selected").find("option:selected").attr("staticsType");
                            var flag1 = $("#selected").find("option:selected").attr("formattype");
                            if ((flag == null || flag == "undefined" || flag == "") && obj.attr("type") == "unselect") {
                                $("#unselect_ico").trigger("click");
                            }else if((flag1 == null || flag1 == "undefined") && obj.attr("type") == "column"){
                            	$("#unselect_ico").trigger("click");
                            }
                        }else if(from == "setCrossColumn"){
                        	var dateType = $("#unselect").find("option:selected").attr("dateType");
                        	if(dateType == undefined){
                        		var text = $("#unselect").find("option:selected").text();
                        		$("#unselect").find("option:selected").text(text+" " +"${ctp:i18n('report.reportDesign.groupDay')}");
                        		$("#unselect").find("option:selected").attr("dateType","day");
                        	}
                        }
                        dialog.close();
                    }
                }]
            });
        }
        //修改公式列里面的公式
        function changeformulastr(oldField,newField){
        	$("#selected").find("option[value^='formula']").each(function(){
        		var formulastr = $(this).attr("formulastr");
        		var oldField1 = "["+oldField+"]";
        		while(checkField(oldField1,formulastr) && oldField != newField){
        			formulastr = formulastr.replace(oldField1,"["+newField+"]");
        		}
        		$(this).attr("formulastr",formulastr);
        	});
        }
        function checkField(oldField1,formulastr){
        	if(formulastr.indexOf(oldField1) == -1){
        		return false;
        	}
        	return true;
        }
        //在图里面设置了字段，在修改别名时，图的名字也需要修改
        function changeChartField(chartFieldArr,fieldTitle,newTitle){
        	for(var i=0;i<chartFieldArr.length;i++){
        		var chartFields = chartFieldArr[i].split(",");
        		var chartField = "";
        		for(var j=0;j<chartFields.length;j++){
        			if(fieldTitle == chartFields[j]){
        				chartField = union(chartField,newTitle);
        			}else{
        				chartField = union(chartField,chartFields[j]);
        			}
        		}
        		chartFieldArr[i] = chartField;
        	}
        	return chartFieldArr;
        }
        //判断修改的标题是否重名
        function checkRepeat(selfObj, name) {
            var obj = $("#selected option");
            var value = selfObj.val();
            var len = obj.length;
            //统计分组项或者统计项的标题
            var parentNewTitleOther = parentPara.selectedNewShowTitleOther.split(",");
            //交叉列标题
            var parentNewTitleCross = parentPara.selectedNewShowTitleCross;
            try {
                for (var i = 0; i < len; i++) {
                	if($.isNull(name) || name === 'null'){
                		$.error("${ctp:i18n('report.reportDesign.dialog.staticsitem.noTitleEmpty')}");
                		return true;
                	}
                	//unselect是字段、column是列汇总,对自己点开，不修改名字
                	if(selfObj.attr("type") == "unselect"  && name === selfObj.attr("newShowTitle")){
                		continue;
                	}else if(selfObj.attr("type") == "column" && name === selfObj.attr("title")){
                		continue;
                	}
                	
                	var hasRepeat = false;
                	if(selfObj.attr("type") == "unselect"){
                		//黄奎修改，第一次设置重复标题名称会出问题
                		//协同V5 OA-114197表单统计分组项重名了没有提示；
                		if(($(obj[i]).attr("newShowTitle") && name === $(obj[i]).attr("newShowTitle"))
                			 || ($(obj[i]).attr("type") !== "unselect" && len > 1 && !$(obj[i]).attr("newShowTitle") && name === $(obj[i]).text())){
                			hasRepeat = true;
                		}
                	}else{
                		if(name === $(obj[i]).attr("title") && i != len-1 && i!=selfObj[0].index){
                			hasRepeat = true;
                		}
                	}
                	if(hasRepeat){
                		$.error("${ctp:i18n('report.reportDesign.set.errorRepetition')}");
                        return true;
                	}
                }
                for(var i = 0;i < parentNewTitleOther.length; i++){
                	if(name === parentNewTitleOther[i]){
                		$.error("${ctp:i18n('report.reportDesign.set.errorRepetition')}");
                        return true;
                	}
                }
                if(name === parentNewTitleCross){
                	$.error("${ctp:i18n('report.reportDesign.set.errorRepetition')}");
                    return true;
                }
                var baseArray = new Array();
				if(from == showDataList){
					baseArray = baseArray.concat(parent.$("#reportHeadNewTitleHidden").val().split(","));
				}else if(from == setReportHead){
					baseArray = baseArray.concat(parent.$("#showDataListNewTitleHidden").val().split(","));
				}
                for (var i = 0; i < baseArray.length; i++) {
                    if (name === baseArray[i]) {
                        $.error("${ctp:i18n('report.reportDesign.set.errorRepetition')}");
                        return true;
                    }
                } 
                var crossColumnValue = parent.$("#crossColumnHidden").val();
                var crossColumn = parent.$("#crossColumn").val();
                if (crossColumnValue != "") {
                    if (fields.get(crossColumnValue).display == name) {
                        $.error("${ctp:i18n('report.reportDesign.set.errorRepetitionAcross')}");
                        return true;
                    };
                }
            } catch (e) {

            }
            return false;

        }
        // AJAX取枚举值
		function ajaxFindEnums(obj) {
			var url = "${path }/report/reportDesign.do?method=findEnums&fieldName="+obj.val();
			$.ajax({
				type:"GET",
				url:url,
				async: false,
				success:function(result){
					 appendEnums(eval(result),obj);
				}
			});
        }
        function appendEnums(result,obj) {
        	$("#enumchange1").empty();
			var enumval = new Array();
			if(obj.attr("enumchange").split("&").length > 1){
				enumval[0] = obj.attr("enumchange").split("&")[1];
				enumval[1] = obj.attr("enumchange").split("&")[2];
				$("#enumchange1").removeAttr("disabled");
                $("#enumchange2").removeAttr("disabled");
			}else{
				enumval[0] = "";
				enumval[1] = "";
			}
			$("#enumchange1").append("<option selected='selected' display='' value=' '></option>");
        	for (var i = 0; i < result.length; i++) {
        		var showvalue = escapeStringToHTML(result[i].showvalue);
				var value1 = result[i].id + "_" + showvalue;
				if(value1 == enumval[0]){
					$("#enumchange1").append("<option selected='selected' display='"+showvalue+"' value='" + value1 +"'>" + showvalue + "</option>");
				}else{
					$("#enumchange1").append("<option display='"+showvalue+"' value='" + value1 +"'>" + showvalue + "</option>");
				}
            }
            $("#enumchange2").empty();
            $("#enumchange2").append("<option selected='selected' display='' value=' '></option>");
        	for (var i = 0; i < result.length; i++) {
        		var showvalue = escapeStringToHTML(result[i].showvalue);
             	var value2 = result[i].id + "_" + showvalue;
				if(value2 == enumval[1]){
					$("#enumchange2").append("<option selected='selected' display='"+showvalue+"' value='" + value2 +"'>" + showvalue + "</option>");
				}else{
					$("#enumchange2").append("<option display='"+showvalue+"' value='" + value2 +"'>" + showvalue + "</option>");
				}
            }
            if(obj.attr("staticsType") != "change"){
            	$("#enumchange1").attr("disabled","disabled");
                $("#enumchange2").attr("disabled","disabled");
            }
        }
        // AJAX根据表单ID获取表单的所有字段
        function ajaxFindFieldsById(formId) {
            formReportDesignManager_.findFormFields(from,{
                success: function (result) {
                    appendField(result);
                }
            });
        }
        // 向Select中填写数据
        function appendField(result) {
            $("#unselect").empty(); // 填写之前先清空最初的数据
            for (var i = 0; i < result.length; i++) {
                var field = result[i];
                var repeatField = "true";
                var beforName = "${ctp:i18n('form.base.mastertable.label')}";
                if(field.ownerTableName.indexOf("formson") != -1){
                	repeatField = "false";//重复表字段
                	beforName = "${ctp:i18n('formoper.dupform.label')}"+field.ownerTableIndex;
                }
                
                $("#unselect").append(
                        "<option value='" + field.name +
                        "' title='" + field.display +
                        "' fieldType='" + field.fieldType +
                        "' enumchangeold='" + field.enumId +
                        "' repeat='" + repeatField +
                        "' type='unselect'>" +"["+beforName+"]"+ field.display +
                        "</option>");//枚举的格式是 enumId
                fields.put(field.name, field);
            }
            if(from=="setCrossColumn"){
            	var dataField="<option value=start_member_id"+
                        " title=${ctp:i18n('report.reportDesign.field.creator')}" +
                        " fieldType=VARCHAR"+
                        " enumchange="+
                        " type='unselect'>${ctp:i18n('report.reportDesign.field.creator')}"+
                        "</option>"+
                         "<option value=start_date"+
                        " title=${ctp:i18n('report.reportDesign.field.creatDate')}" +
                        " fieldType=VARCHAR"+
                        " enumchange="+
                        " type='unselect'>${ctp:i18n('report.reportDesign.field.creatDate')}"+
                        "</option>"+
                        "<option value=modify_date"+
                        " title=${ctp:i18n('report.reportDesign.field.modifyDate')}" +
                        " fieldType=VARCHAR"+
                        " enumchange="+
                        " type='unselect'>${ctp:i18n('report.reportDesign.field.modifyDate')}"+
                        "</option>";
           		$("#unselect").append(dataField);
            }
            //已选项过虑
            var set = setBordFun(true, "", "", 200);
            set.refreash();
            //枚举但不能是重复项，在统计项中可以多次选择设置
            if(from === showDataList){
            	$("#unselect option").each(function(){
            		if("0" != $(this).attr("enumchangeold")){
            			$(this).removeClass("color_gray");
            		}
            	});
            }
            $("#unselect option[enumchange!='0'][repeat!='false']").each(function(){
            	var value = $(this).attr("value");
            	//在已经设置的枚举里面添加重复字段判断  true -主表字段
            	$("#selected option[value='"+value+"']").attr("repeat","true");
            });
            //删除系统数据域的 color_gray 样式
			var parentValue = parentPara.selectedValue.split(",");
			for(var i=0;i<parentValue.length;i++){
				$("#columnDataUnselect").find("option").each(function(){
					if(parentValue[i] == $(this).val()){
						$(this).addClass("color_gray");
					}
				});
			}
            if (from === setCrossColumn) {
                if (!$.isNull(parentPara.selectedValue)) {
                    var obj = $("#unselect option[value='" + parentPara.selectedValue + "']");
                    try{
                    	obj.attr("selected", true);
                    }catch(e){}
                    var t = obj.text();
					t =t.substring(0,t.indexOf("]")+1) + parentPara.selectedShowTitle;
                    obj.text(t);
                    if (!$.isNull(parentPara.dateType)) {
                        obj.attr("dateType", parentPara.dateType);
                    }
                }
            }
        }

        /**
         *isKeep    boolean 是否在备选中保留已选项
         *unselect  string  备选项ID
         *selected  string  已选项ID
         *maxLength number  最多选择个数
         */
        function setBordFun(isKeep, unselect, selected, maxLength) {
            var bord_ = new setBord({
                maxLength: maxLength,
                isKeep: isKeep,
                addObj: $("#unselect"),
                removeObj: $("#selected")
            });

            return bord_;
        }

        /*
         *进入页面，先判断父页面是否有数据,如果有则初始化选择列表
         */
        function initSelectedFields() {
            if (!$.isNull(parentPara.selectedValue)) {
                if (from !== setCrossColumn) {
                    var parentValue = parentPara.selectedValue.split(",");
                    var parentText = parentPara.selectedShowTitle.split(",");
                    var parentNewTitle = parentPara.selectedNewShowTitle.split(",");
                    var staticsType = parentPara.staticsType.split(",");
                    var dateType = parentPara.dateType.split(",");
                    var columntype = parentPara.columntype.split(",");
                    var formattype = parentPara.formattype.split(",");
                    var formulastr = parentPara.formulastr.split(",");
					var enumchange = parentPara.enumchange.split(",");
					var crossTypes = parentPara.crossTypes.split(",");//计算列交叉设置
                    if (parentValue != undefined && parentValue.length > 0) {
                        for (var i = 0; i < parentValue.length; i++) {
                            var temp = "";
                            if (from === showDataList) {
                                if(columntype[i] == "column"){
                                	temp = "' type='" + columntype[i] +
                                	"' formattype='" + formattype[i] + "' formulastr='" + formulastr[i] + 
                                	"' title='" + parentNewTitle[i] ;
                                	if("true" == parentPara.isCross &&　from == showDataList){
                                		var crossVal = $.isNull(crossTypes[i]) ? "":crossTypes[i];
                                		temp = temp + "' crossType='" + crossVal;
									}
                                	$("#columnUnselect").find("option").each(function(){
            							if($(this).val() != "formula" && $(this).val() == parentValue[i]){
            								$(this).addClass("color_gray");
            							}
            						});
                                }else if(!$.isNull(enumchange[i])){
                                	temp = "' staticsType='" + staticsType[i] + "' title='" + parentText[i] +
                                    "' newShowTitle='" + parentNewTitle[i]+"' enumchange='" + enumchange[i];
                                }else{
									temp = "' staticsType='" + staticsType[i] + "' title='" + parentText[i] +
                                    "' newShowTitle='" + parentNewTitle[i];
								}
                            } else if (from === setReportHead) {
                                temp = "' dateType='" + dateType[i] +"' title='" + parentText[i] +
                                    "' newShowTitle='" + parentNewTitle[i];
                            }
                            $("#selected").append(
                                    "<option value='" + parentValue[i] +
                                     temp +
                                    "' type='unselect'>" + parentText[i] +
                                    "</option>");
                        }
                    }
                }
            }
        }

        /*
         *父子界面交互方法，return值能在父页面获得
         */
        function OK(parms) {
            var returnObj = new Object();
            var texts = "";
            var values = "";
            var value = "";
            var newTitle = "";
            var staticsType = "";
            var dateType = "";
            //列汇总和公式列 、枚举 、交叉
            var columntype = "";
            var formattype = "";
            var formulastr = "";
            var enumchange = "";
            var crossTypes = "";//计算列交叉类型 
            //交叉列只能单选
            if (from === setCrossColumn) {
                texts = $("#unselect").find("option:selected").text();
                values = $("#unselect").find("option:selected").val();
                dateType = $("#unselect").find("option:selected").attr("dateType");
            } else {
                $("#selected option").each(function () {
                    value = $(this).val();
					texts = union(texts, $(this).text());
					values = union(values, value);
					//记录field原始标题
					var oldShowTitle = $("#unselect option[value='" + value + "']").text();
					oldShowTitle = subName(oldShowTitle);
					//记录field修改后的标题，如果没有修改过标题，即和原始标题一样
					var newShowTitle = $(this).attr("newShowTitle");
					newShowTitle = (newShowTitle == "" || newShowTitle == null || newShowTitle == "undefined") ? oldShowTitle : newShowTitle;
					
					if (from === showDataList) {
						if(!$.isNull($(this).attr("enumchange"))){
							enumchange = union(enumchange, $(this).attr("enumchange"));
						}else{
							enumchange = union(enumchange, " ");
						}
						staticsType = union(staticsType, checkBlank($(this).attr("staticsType")));
                    	if($(this).attr("type") == "column"){
                    		newTitle = union(newTitle, $(this).attr("title"));
                    		columntype = union(columntype,"column");
                    		formattype = union(formattype, checkBlank($(this).attr("formattype")));
                    		if(value == "formula"){
                    			formulastr = union(formulastr, checkBlank($(this).attr("formulastr")));
                    		}else{
                    			formulastr = union(formulastr," ");
                    		}
                    	}else{
                    		newTitle = union(newTitle, newShowTitle);
                    		columntype = union(columntype," ");
                    		formattype = union(formattype," ");
                    		formulastr = union(formulastr," ");
                    	}
                    	if("true" == parentPara.isCross){
                    		var crossType = $.isNull($(this).attr("crossType")) ? " ":$(this).attr("crossType");
							crossTypes = union(crossTypes,crossType);
                    	}
					} else if (from === setReportHead) {
						newTitle = union(newTitle, newShowTitle);
						dateType = union(dateType, checkBlank($(this).attr("dateType")));
					}
                });
            }
            
            var checkValue = chooseCheck(values);
            if (checkValue[0]) {
                returnObj.texts = texts;
                returnObj.values = values == null ? "" : values;
                returnObj.newTitle = newTitle;
                returnObj.staticsType = staticsType;
                returnObj.dateType = dateType;
                returnObj.ownerTableName = checkValue[1];
                returnObj.displayName = checkValue[2];
                returnObj.columntype = columntype;
                returnObj.formattype = formattype;
                returnObj.formulastr = formulastr;
                returnObj.chartData = parentPara.chartData;
                returnObj.chartHead = parentPara.chartHead;
                returnObj.enumchange = enumchange;
                returnObj.crossTypes = crossTypes;
                return returnObj;
            }
        }
        //返回“ ”占一个位置
        function checkBlank(val){
        	if(val == null || val == "undefined" || val == ""){
        		return " ";
        	}
        	return val;
        }
        //返回值拼接，以“,”隔开的字符串
        function union(_self, _new) {
            (_self == "") ? (_self = _new) : (_self = _self + "," + _new);
            return _self;
        }
        /**检查选择项是否合法：不能同时选择2个重复项中的字段
          *返回个数组【检查是否通过，子表名称（如果只有主表字段，这个为空字符串）,字段名】*/
        function chooseCheck(values) {
            var ownerTableName = "";
            var type = true;
            var displayName = "";
            
            if (values != null && values != "") {
                var value = values.split(",");
                for (var i = 0 ; i < value.length ; i++) {
                    var fieldObj1 = fields.get(value[i]);
                    //汇总列公式司列的时候是undefined
                    if(fieldObj1 != undefined){
                    //一个统计（统计项、交叉项，分组项）至多包含  1个子表        的字段
                    	if (fieldObj1.ownerTableName.indexOf("formmain_") == -1) {
							if (ownerTableName == "") {
								ownerTableName = fieldObj1.ownerTableName;
								displayName = fieldObj1.display;
							} else {
								if (ownerTableName != fieldObj1.ownerTableName) {
									$.error("${ctp:i18n('report.reportDesign.set.errorNotInOneTable')}");
									type = false;
									break;
								}
							}
						}
                    }
                }
            }
            var baseArray = [type,ownerTableName,displayName];
            return baseArray;
        }
        function isInSameMasterTable(baseArray, fieldObj, name) {
            for (var j = 0 ; j < baseArray.length ; j++) {
                if (baseArray[j] != "") {
                    var fieldObj2 = fields.get(baseArray[j]);
                    //是子表字段
                    if (!fieldObj2.masterField) {
                        if (fieldObj2.ownerTableName != fieldObj.ownerTableName) {
                            $.error($.i18n('report.reportDesign.set.errorFieldNotInOneTable', fieldObj.display, name));
                            //$.error("\"" + fieldObj.display + "\"与 "+name+"的字段不在同一个重复表中！");
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        /**
         *根据输入条件搜寻字段
         */
        function searchField() {
            var searchValue = $("#searchField").val();
            var formFileds = $("#unselect option");
            var len = formFileds.length;
            $("#unselect").children("span").each(function () {
                $(this).children().clone().replaceAll($(this));
            });
            for (var i = 0; i < len; i++) {
                var filed = formFileds[i];
                if ($(filed).text().indexOf(searchValue) === -1) {
                    $("#unselect option").eq(i).each(function () {
                    	//查询是隐藏不在查询范围内的 字段，但是需要去掉选中。OA-71312
                    	$(this).removeAttr("selected");
                        $(this).wrap("<span style='display:none'></span>");
                    });
                }
            }
            if(from === setReportHead){//统计分组项 的系统数据域
            	$("#columnDataUnselect").children("span").each(function () {
                	$(this).children().clone().replaceAll($(this));
            	});
            	var columnDataFileds = $("#columnDataUnselect option");
            	for (var i = 0; i < columnDataFileds.length; i++) {
                	var filed = columnDataFileds[i];
                	if ($(filed).text().indexOf(searchValue) === -1) {
                    	$("#columnDataUnselect option").eq(i).each(function () {
                    		$(this).removeAttr("selected");
                        	$(this).wrap("<span style='display:none'></span>");
                    	});
                	}
            	}
            }else if(from === showDataList){//统计项的计算列
            	$("#columnUnselect").children("span").each(function () {
                	$(this).children().clone().replaceAll($(this));
            	});
            	var columnCountFileds = $("#columnUnselect option");
            	for (var i = 0; i < columnCountFileds.length; i++) {
                	var filed = columnCountFileds[i];
                	if ($(filed).text().indexOf(searchValue) === -1) {
                    	$("#columnUnselect option").eq(i).each(function () {
                    		$(this).removeAttr("selected");
                        	$(this).wrap("<span style='display:none'></span>");
                    	});
                	}
            	}
            }
            
            
        }
    </script>
</head>
<body class="over_auto h100b">
    <input id="fieldNameHidden" type="hidden" value="${fieldNameHidden}" />
    <c:choose>
	    <c:when test="${from != 'setCrossColumn'}">
	        <div id="div_selectField" class="align_left" style="width:568px; margin:0 auto;">
	    </c:when>
	    <c:otherwise>
	        <!-- 交叉列宽度要短点 -->
	        <div id="div1" class="align_left" style="width:320px; margin:0 auto;">
	    </c:otherwise>
	</c:choose>
    <table border="0" cellpadding="0" cellspacing="0" align="center" class="font_size12">
        <tr>
            <td class="margin_t_5>
                <p class="font_size12 margin_b_5 margin_t_10">
                    <span class="left">${ctp:i18n('report.reportDesign.dialog.formdatadomain')}:
                    <input class="comp" id="searchField" name="name" value="" type="text" comp="type:'search',fun:'searchField',title:'查询数据域'" style="width: 180px;" /></span>
                </p>
            </td>
            <td></td>
            <td colspan="2">
	            <c:if test="${from == 'setReportHead'}">
	                <p class="font_size12 margin_b_5 margin_t_10">${ctp:i18n('report.reportDesign.dialog.groupingitem.title')}:</p><!--统计分组项 -->
	            </c:if>
	            <c:if test="${from == 'setShowDataList'}">
	                <p class="font_size12 margin_b_5 margin_t_10">${ctp:i18n('report.reportDesign.set.outputData')}:</p>
	            </c:if>
            </td>
        </tr>
        <tr>
            <td valign="top" width="260">
                <select class="font_size12" style="width:260px; height: 340px;" id="unselect" size="20" <c:if test="${from == 'setReportHead'}">multiple</c:if>></select>
            	<c:if test="${from == 'setShowDataList' and (ctp:getSystemProperty('system.ProductId') != 0 and ctp:getSystemProperty('system.ProductId') != 7)}">
            		<span class="left margin_b_5 margin_t_5">${ctp:i18n('report.reportDesign.calculatedColumn')}:</span>
            		<select class="font_size12" style="width:260px; height: 90px;" id="columnUnselect" size="7">
            			<option title="${ctp:i18n('report.reportDesign.columnSum')}" type="column" value="sum">${ctp:i18n('report.reportDesign.columnSum')}</option>
						<option title="${ctp:i18n('report.reportDesign.columnCount')}" type="column" value="count">${ctp:i18n('report.reportDesign.columnCount')}</option>
						<option title="${ctp:i18n('report.reportDesign.columnAvg')}" type="column" value="avg">${ctp:i18n('report.reportDesign.columnAvg')}</option>
						<option title="${ctp:i18n('report.reportDesign.columnMax')}" type="column" value="max">${ctp:i18n('report.reportDesign.columnMax')}</option>
						<option title="${ctp:i18n('report.reportDesign.columnMin')}" type="column" value="min">${ctp:i18n('report.reportDesign.columnMin')}</option>
						<option title="${ctp:i18n('report.reportDesign.formula')}" type="column" value="formula">${ctp:i18n('report.reportDesign.formula')}</option>
            		</select>
            	</c:if>
            	<c:if test="${from == 'setReportHead'}">
            		<span class="left margin_b_5 margin_t_5">${ctp:i18n('form.forminputchoose.systemdata')}:</span>
            		<select class="font_size12" style="width:260px; height: 90px;" id="columnDataUnselect" size="3" multiple>
            			<option title="${ctp:i18n('report.reportDesign.field.creator')}"  value="start_member_id" fieldType="VARCHAR">${ctp:i18n('report.reportDesign.field.creator')}</option>
						<option title="${ctp:i18n('report.reportDesign.field.creatDate')}"  value="start_date" fieldType="VARCHAR">${ctp:i18n('report.reportDesign.field.creatDate')}</option>
						<option title="${ctp:i18n('report.reportDesign.field.modifyDate')}"  value="modify_date" fieldType="VARCHAR">${ctp:i18n('report.reportDesign.field.modifyDate')}</option>
            		</select>
            	</c:if>
            </td>
            <c:if test="${from != 'setCrossColumn'}">
            <td valign="middle" align="center" class="padding_lr_5">
	            <span class="select_selected hand" id="select_ico"></span><br><br>
	            <span class="select_unselect hand" id="unselect_ico"></span>
            </td>
            <td align="top">
	                <select class="font_size12"style="width:230px; height: 340px; " multiple size="20" id="selected"></select>
            </td>
            <td valign="middle" align="center" class="padding_l_5">
	            <span class="sort_up hand" id="sort_up"></span><br><br>
				<span class="sort_down hand" id="sort_down"></span>
            </td>
            </c:if>
        </tr>
    </table>

    <!-- 分组统计项 修改名字 -->
    <div id="reportHeadRenameDiv" class="hidden">
        <div class="align_center form_area" layout="border:false">
            <table   style="font-size: 12px">
                <tr class="margin_5">
                    <td class="align_right" nowrap>${ctp:i18n('report.reportDesign.dialog.groupingitem.title')}：</td>
                    <!--统计分组项 -->
                    <td class="align_left"><span id="reportHeadName"></span>
                        <br />
                    </td>
                </tr>
                <tr class="margin_5">
                    <td class="align_right" nowrap>
                        <label class="margin_l_10" for="text">
                            <font color="red">*</font>${ctp:i18n('form.forminputchoose.rename')}：
                        </label>
                    </td>
                    <td width="100%">
                        <div class="common_txtbox_wrap">
                            <input class="validate font_size12 left" type="text" id="reportHeadNameModify" name="reportHeadNameModify" value="" validate="type:'string',name:'${ctp:i18n('report.reportDesign.dialog.title')}',notNull:true,maxLength:85,avoidChar:'!,@#$%^:&*()\\\/\'&quot;?<>'" />
                        </div>
                    </td>
                </tr>
                <tr class="margin_5">
                    <td></td>
                    <td class="align_left"><span class="required" style="color:#888">
                        <pre>${ctp:i18n('report.reportDesign.dialog.prompt.titleInput')}</pre>
                    </span></td>
                </tr>
                <tr class="margin_5 hidden" id="dateTypeTr">
                    <td class="align_right" nowrap></td>
                    <td class="align_left">
                        <!-- 开发使用枚举 -->
                        <div class="codecfg" id="dateType" codecfg="codeType:'java',render:'radiov',codeId:'com.seeyon.ctp.report.design.enums.DateTypeEnum'"></div>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 统计项 设置 -->
    <div id="showDataListDiv" class="hidden">
        <div class="align_center form_area" layout="border:false">
            <table   style="font-size: 12px">
                <tr class="margin_5">
                    <td class="align_right" nowrap>${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}：</td>
                    <td class="align_left" nowrap><span id="showDataListName"></span>
                        <br />
                    </td>
                </tr>
                <tr class="margin_5">
                    <td class="align_right" nowrap>
                        <label class="margin_l_10" for="text">
                            <font color="red">*</font>${ctp:i18n('form.forminputchoose.rename')}：
                        </label>
                    </td>
                    <td width="100%">
                        <div class="common_txtbox_wrap">
                            <input class="validate font_size12 left" type="text" id="showDataListNameModify" value="" validate="type:'string',name:'${ctp:i18n('report.reportDesign.dialog.title')}',notNull:true,maxLength:85,avoidChar:'!,@#$%^:&*()\\\/\'&quot;?<>'" />
                        </div>
                    </td>
                </tr>
                <tr class="margin_5">
                    <td></td>
                    <td class="align_left"><span class="required" style="color:#888">
                        <pre>${ctp:i18n('report.reportDesign.dialog.prompt.titleInput')}</pre>
                    </span></td>
                </tr>
                <tr class="margin_5">
                    <td class="align_right" nowrap>${ctp:i18n('report.reportDesign.set.statisticalMethods')}：</td>
                    <td class="align_left">
                        <!-- 开发使用枚举 -->
                        <div class="codecfg" id="calcOperator" codecfg="codeType:'java',render:'radiov',codeId:'com.seeyon.ctp.report.design.enums.CalcOperatorEnum'"></div>
                        <!-- 枚举的变化次数 -->
                        <div id="enumchange" class="hidden"><label class="margin_r_10 hand display_block"><input class="radio_com" name="calcOperator"  id="calcOperator1" type="radio" value="change">${ctp:i18n('report.reportDesign.change')}</input></label>
                        	<script>
                        	$(function () {
                        		$("input[name='calcOperator']").change(function() { 
									if($("#calcOperator1").attr("checked") == "checked"){
										$("#enumchange1").removeAttr("disabled");
                        				$("#enumchange2").removeAttr("disabled");
									}else{
										$("#enumchange1").attr("disabled","disabled");
                        				$("#enumchange2").attr("disabled","disabled");
									}
								}); 
                        	});
                        	</script>
                        	<table><tr>
                        		<td><label class="hand">${ctp:i18n('report.reportDesign.from')}</label></td>
                        		<td><select class="hand" style="width:100px;" id="enumchange1" disabled="disabled"></select></td>
                        		<td><label class="hand">${ctp:i18n('report.reportDesign.changeto')}</label></td>
                        		<td><select class="hand" style="width:100px;" id="enumchange2" disabled="disabled"></select></td>
                        	</tr></table>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 汇总列 -->
    <div id="summarycolumn" class="hidden">
        <div class="align_center form_area" layout="border:false">
            <table  style="font-size: 12px">
                <tr class="margin_5">
                    <td class="align_right" nowrap>${ctp:i18n('report.reportDesign.set.computedColumns')}：</td>
                    <td class="align_left" nowrap><span id="countColumn"></span>
                        <br />
                    </td>
                </tr>
                <tr class="margin_5">
                    <td class="align_right" nowrap>
                        <label class="margin_l_10" for="text">
                            <font color="red">*</font>${ctp:i18n('report.reportDesign.dialog.title')}：
                        </label>
                    </td>
                    <td width="100%">
                        <div class="common_txtbox_wrap">
                            <input class="validate font_size12 left" type="text" id="countColumnName" value="" validate="type:'string',name:'${ctp:i18n('report.reportDesign.dialog.title')}',notNull:true,maxLength:85,avoidChar:'\&#39;&quot;&lt;&gt;!,@#$%&*()'" />
                        </div>
                    </td>
                </tr>
                <tr class="margin_5">
                    <td nowrap><span class="font_size12 font_bold">${ctp:i18n('report.reportDesign.set.displayFormat')}：</span></td>
                    <td class="align_left">
                    	<!-- 计算列和公式列 显示格式  初始默认情况  有修改就动态添加-->
                    	<select class="font_size12 margin_t_5" style="width:80px;" id="formattype">
            			</select>
                    </td>
                </tr>
                <tr class="margin_5" id="crossTypeTr">
                    <td nowrap><span class="font_size12 font_bold">${ctp:i18n('report.reportDesign.crossSet.calculation')}：</span></td>
                    <td class="align_left">
                    	<!-- 交叉统计设置  初始默认情况  有修改就动态添加-->
                    	<select class="font_size12 margin_t_5" style="width:80px;" id="crossType">
            			</select>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 交叉列 修改名字 -->
    <div id="crossColumnDiv" class="hidden">
        <div class="align_center form_area" layout="border:false">
            <table  style="font-size: 12px">
                <tr class="margin_5">
                    <td class="align_right" nowrap>${ctp:i18n('report.reportDesign.dialog.acrossreportColumn.title')}：</td>
                    <!--交叉列 -->
                    <td class="align_left"><span id="crossColumnName"></span>
                        <br />
                    </td>
                </tr>
                <tr class="margin_5">
                    <td class="align_right" nowrap></td>
                    <td class="align_left">
                        <!-- 开发使用枚举 -->
                        <br>
                        <div class="codecfg margin_5" id="crossColumnDateType" codecfg="codeType:'java',render:'radiov',codeId:'com.seeyon.ctp.report.design.enums.DateTypeEnum'"></div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
