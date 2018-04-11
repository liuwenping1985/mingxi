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
        //获取父窗口参数
        var parentPara = window.dialogArguments;
		var sortColumnVal=parentPara.sortColumnVal.split(",");
		var sortColumnTitle=parentPara.sortColumnTitle.split(",");
		var staticType="",dataListTitle="",dataListVal="";
		var sortCrossColumnTitle=parentPara.sortCrossColumnTitle;
		var sortCrossColumnVal=parentPara.sortCrossColumnVal;
		var sortCrossColumnDataType=parentPara.sortCrossColumnDataType;
		var sumDataField=parentPara.sumDataField;
		var columntype=parentPara.columntype;
		var classifyValue=parentPara.classifyValue;
		if(sortColumnVal.length<=1){
			staticType=parentPara.staticType.split(",");
			dataListTitle=parentPara.dataListTitle.split(",");
			dataListVal=parentPara.dataListVal.split(",");
			columntype=columntype.split(",");
		}
		var from = "${ctp:escapeJavascript(from)}";
        var setReportHead = "setReportHead";
        var showDataList = "setShowDataList";
        var setCrossColumn = "setCrossColumn";
        $(function () {
        	$("#unselect").click(function() {
        		//OA-54884_ie8下设置不成功
        		//$("#columnUnselect").find("option:selected").attr("selected",false);
        		var selected = $("#columnUnselect").find("option:selected");
        		if(!$.isNull(selected)){
        			selected.before(selected.clone());
        			selected.remove();
        		}
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
        	
            //定义左右选择面板
            var set = setBordFun(true, "", "", 200);

            $("#select_ico").click(function () {
            		var unSelectItem=$("#unselect").find("option:selected");
            		var hasSelectedNum=$("#selected").find("option");
            		//统计分组项的个数
            		var sortReportHeadNum=$("#unselect").find("option[dataType='fieldData']");
            		//交叉项个数
            		var sortReportCrossNum=$("#unselect").find("option[dataType='crossData']")
                    if(unSelectItem.hasClass("hasSelected")){
                     	//$.alert("${ctp:i18n('report.reportDesign.set.chooseRepeat')}");
                     	return false;
                    }
            		if((sortReportHeadNum.length+sortReportCrossNum.length)==1){
            			if(hasSelectedNum.length>0){
            				$.alert("${ctp:i18n('report.reportDesign.sort.selectOne')}");
            				return false;
            			}
            		}
            		if(classifyValue!=""&&"dataList"==unSelectItem.attr("dataType")){
            			$.alert("${ctp:i18n('report.reportDesign.sort.sumData.error')}");
            			return false;
            		}
                    if(unSelectItem.length==0){
                    	$.alert("${ctp:i18n('report.reportDesign.sort.seledata')}");
                    	return false;
                    }
            		var selectSortItem=$("#unselect").find("option:selected");
            		var selectSortVal=selectSortItem.val();
            		var selectSortTitle=selectSortItem.html();
            		var staticType=selectSortItem.attr("staticType");
            		var columntype=selectSortItem.attr("type");
            		if((staticType==undefined||staticType.trim()=="")&&columntype.trim()!=""){
            			//如果是计算列,staticType值为column
            			staticType=columntype;
            		}
                	sortDialog(selectSortVal,selectSortTitle,"",staticType);	
            });
            $("#unselect_ico").click(function () {
            		var selectItems=$("#selected").find("option:selected");
            		for(var i=0;i<selectItems.length;i++){
            			var selectId=$(selectItems[i]).attr("id");
            			$("#unselect").find("option[value='"+selectId+"']").removeClass("hasSelected");
            		}
                	set.remove();
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
            /**
             * 按enter键搜索 
             */
            $("#searchField").keyup(function(event) {
                if (event.keyCode == 13) {
                	searchField();
                }
            });
            //初始化表单数据域
            appendField();
            //初始化已选择项
            initSelectedFields();
            //初始化双击事件
            initDbClick(set);
            //初始化单击事件（目前只有交叉列需要）
            //initClick();
        });
        
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
        //排序选择框
        function sortDialog(selectSortVal,selectSortTitle,selectSortType,staticType){
        	var sortDg=$.dialog({
               			id:"sortDialog",
               			url:"${path}/report/reportDesign.do?method=goSortColumnInfo",
               			title:"${ctp:i18n('form.forminputchoose.order')}",
               			width:350,
               			height:200,
               			targetWindow:getCtpTop(),
               			transParams:{
               				selectSortVal:selectSortVal,
               				selectSortTitle:selectSortTitle,
               				selectSortType:selectSortType
               			},
               			buttons: [{
                 			text: "${ctp:i18n('report.reportDesign.button.confirm')}",
                 			isEmphasize: true,
                			handler: function () {
                     			var returnObj = sortDg.getReturnValue();
                     			var rSelect=$("#selected").find("option[id='"+returnObj.selectSortVal+"']");
                     			var dataType=$("#unselect").find("option[value='"+returnObj.selectSortVal+"']").attr("dataType");
                     			if(rSelect.length==0){
                     				var title = returnObj.selectSortTitle;
                     				title = title.substring(title.indexOf("]")+1)
                     				$("#selected").append("<option id='"+returnObj.selectSortVal+
                     				"' title='"+title+" "+returnObj.sortName+
                     				"' value='"+returnObj.sortType+
                     				"' staticType='"+staticType+
                     				"'>"+title+" "+returnObj.sortName+"</option>");
                     				//置灰
                     				$("#unselect").find("option[value='"+returnObj.selectSortVal+"']").addClass("hasSelected");
                     			}else{
                     				$("#selected").find("option:selected").val(returnObj.sortType);
                     				var title=returnObj.selectSortTitle.split(" ");
                     				$("#selected").find("option:selected").html(title[0]+" "+returnObj.sortName);
                     				$("#selected").find("option:selected").attr("title",title[0]+" "+returnObj.sortName);
                     			}
                     			$("#selected").find("option[id='"+returnObj.selectSortVal+"']").attr("dataType",dataType);
                     			sortDg.close();
                 			}
             			}, {
                 			text: "${ctp:i18n('report.reportDesign.button.cancel')}",
                 			handler: function () {
                     			sortDg.close();
                 			}	
             			}]
               		})
        }
        //初始化selected/unselect双击事件
        function initDbClick(set) {
            $("#selected").dblclick(function () {
            		var selectId=$("#selected").find("option:selected").attr("id");
            		$("#unselect").find("option[value='"+selectId+"']").removeClass("hasSelected");
                	set.remove();
            });
            $("#unselect").dblclick(function () {
            		var unSelectItem=$("#unselect").find("option:selected");
            		var hasSelectedNum=$("#selected").find("option");
            		//统计分组项的个数
            		var sortReportHeadNum=$("#unselect").find("option[dataType='fieldData']");
                  	//交叉项个数
            		var sortReportCrossNum=$("#unselect").find("option[dataType='crossData']")
                    if(unSelectItem.hasClass("hasSelected")){
                     	//$.alert("${ctp:i18n('report.reportDesign.set.chooseRepeat')}");
                     	return false;
                    }
            		if((sortReportHeadNum.length+sortReportCrossNum.length)==1){
            			if(hasSelectedNum.length>0){
            				$.alert("${ctp:i18n('report.reportDesign.sort.selectOne')}");
            				return false;
            			}
            		}
            		if(classifyValue!=""&&"dataList"==unSelectItem.attr("dataType")){
            			$.alert("${ctp:i18n('report.reportDesign.sort.sumData.error')}");
            			return false;
            		}
                    if(unSelectItem.length==0){
                    	$.alert("${ctp:i18n('report.reportDesign.sort.seledata')}");
                    	return false;
                    }
            	   var selectSortItem=$("#unselect").find("option:selected");
            	   var selectSortVal=selectSortItem.val();
            	   var selectSortTitle=selectSortItem.html();
            	   var staticType=selectSortItem.attr("staticType");
            	   var columntype=selectSortItem.attr("type");
            		if((staticType==undefined||staticType.trim()=="")&&columntype.trim()!=""){
            			//如果是计算列,staticType值为column
            			staticType=columntype;
            		}
                   sortDialog(selectSortVal,selectSortTitle,"",staticType);
            });
        }
        //回调函数，填值
        function getReturnValue(formulastr,headTitle,formattype){
        	var opt = "";
        	if(isFormulaAdd){
        		opt = $("#columnUnselect").find("option:selected").clone(true);
        	}else{
        		opt = $("#selected").find("option:selected");
        		parentPara.chartData = changeChartField(parentPara.chartData,opt.attr("title"),headTitle);
        	}
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
        	if(isFormulaAdd){
        		$("#selected").append(opt);	
        	}
        }
        //检查值是否符合要求
        function checkReturnValue(formulastr,headTitle,formattype){
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
            		$.error("标题不能包含!,@#$%^&*()'<>特殊字符");
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
                    if (fieldType != "" && fieldType != null && fieldType.toUpperCase() == "TIMESTAMP") {
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
                if(!$.isNull(obj.attr("enumchange")) && obj.attr("enumchange") != "0" && (parentPara.formType == "3" || parentPara.formType == "2")){
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
                        //列汇总和公式显示格式
                        var formattype = "";
                        
                        var enumchange1 =  dialog.targetWindow.$("#enumchange1 option:selected");
                        var enumchange2 =  dialog.targetWindow.$("#enumchange2 option:selected");
                        if(from === showDataList){
                            modifyInput = dialog.targetWindow.$("#showDataListNameModify");
                            input = dialog.targetWindow.$("input[name='calcOperator']:checked");
                            
                            if(obj.attr("type") == "column"){
                            	modifyInput = dialog.targetWindow.$("#countColumnName");
                            	formattype = dialog.targetWindow.$("#formattype").val();
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
                            if (!checkRepeat(obj, modifyInput.val())) {
                            	if(from != setCrossColumn && $.isNull($.trim(modifyInput.val()))){
                            		$.error("${ctp:i18n('report.reportDesign.dialog.staticsitem.noTitleEmpty')}");
                            		return ;
                            	}
                                dialog.close({ isFormItem: true });
                                //列汇总
                                if(obj.attr("type") == "column"){
                                	parentPara.chartData = changeChartField(parentPara.chartData,obj.attr("title"),modifyInput.val());
                                	var title = obj.text()
                                	if(title.indexOf("(") != -1){
                                		title = title.substring(0, title.indexOf("(")); 
                                	}
                                	if(title == modifyInput.val()){
                                		obj.text(title);
                                	}else{
                                		obj.text(title+"("+modifyInput.val()+")");
                                	}
                                	changeformulastr(obj.attr("title"),modifyInput.val());
                                	obj.attr("title",modifyInput.val());
                                	obj.attr("formattype",formattype);
                                }else{
									//原始标题
									var oldTitle = fields.get(obj.val()).display;
									//修改后显示的标题 
									var temp = "";
									if (from === setReportHead) {
										parentPara.chartHead = changeChartField(parentPara.chartHead,obj.attr("newShowTitle"),modifyInput.val());
										obj.attr("newShowTitle", modifyInput.val());
										//设置修改后的标题
										temp = (oldTitle != modifyInput.val()) ? oldTitle + "(" + modifyInput.val() + ")" : oldTitle;
										var fieldType = fields.get(obj.val()).fieldType;
										//日期控件统计类型枚举key
										var dateType = input.val();
										//日期控件统计类型年、月、日、季
										if (fieldType.toUpperCase() == "TIMESTAMP") {
											//日期控件统计类型枚举value
											//黄奎修改 协同V5OA-114797 表单统计项设置，统计方式求和、计数、平均值等等信息没有显示出来
											var parents = input.parents("label");
											if(!parents || parents.length === 0){
												parents = $("input[name='calcOperator']:checked").parent();
											}
											var dateText = parents.text();
											temp = (oldTitle != modifyInput.val()) ? (oldTitle + "(" + modifyInput.val() + ")" + " " + dateText) : (oldTitle + " " + dateText);
										}
										obj.attr("dateType", dateType);
									} else if (from === showDataList) {
										parentPara.chartData = changeChartField(parentPara.chartData,obj.attr("newShowTitle"),modifyInput.val());
										changeformulastr(obj.attr("newShowTitle"),modifyInput.val());
										obj.attr("newShowTitle", modifyInput.val());
										//统计类型枚举key
										var staticsType = input.val();
										//统计类型枚举value
										//黄奎修改 协同V5OA-114797 表单统计项设置，统计方式求和、计数、平均值等等信息没有显示出来
										var parents = input.parents("label");
										if(!parents || parents.length === 0){
											parents = $("input[name='calcOperator']:checked").parent();
										}
										var staticsText = parents.text();
										//设置修改后的标题
										temp = (oldTitle != modifyInput.val()) ? (oldTitle + "(" + modifyInput.val() + ")" + " " + staticsText) : (oldTitle + " " + staticsText);
										var enumchange = obj.attr("enumchange").split("&")[0];
										var initEnumchange = enumchange;
										if(staticsType == "change"){
											temp = temp + " 从\"" + enumchange1.text() + "\"变到\"" + enumchange2.text() + "\"";
											enumchange =enumchange +"&"+ enumchange1.val() + "&" + enumchange2.val() ;
										}
										obj.attr("enumchange", enumchange);
										$("#unselect").find("option[selected][type='unselect']").attr("enumchange",initEnumchange);
										obj.attr("staticsType", staticsType);
									} else if (from === setCrossColumn) {
										//日期控件统计类型枚举value
										//黄奎修改 协同V5OA-114797 表单统计项设置，统计方式求和、计数、平均值等等信息没有显示出来
										var parents = input.parents("label");
										if(!parents || parents.length === 0){
											parents = $("input[name='calcOperator']:checked").parent();
										}
										var dateText = parents.text();
										//日期控件统计类型枚举key
										var dateType = input.val();
										temp = oldTitle + " " + dateText;
										obj.attr("dateType", dateType);
									}
									obj.text(temp);
                                }
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
                	if($.isNull(name)){
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
				$("#enumchange1").attr("disabled","disabled");
                $("#enumchange2").attr("disabled","disabled");
			}
			$("#enumchange1").append("<option selected='selected' value=' '></option>");
        	for (var i = 0; i < result.length; i++) {
				var value1 = result[i].id + "_" + result[i].showvalue;
				if(value1 == enumval[0]){
					$("#enumchange1").append("<option selected='selected' value='" + value1 +"'>" + result[i].showvalue + "</option>");
				}else{
					$("#enumchange1").append("<option value='" + value1 +"'>" + result[i].showvalue + "</option>");
				}
            }
            $("#enumchange2").empty();
            $("#enumchange2").append("<option selected='selected' value=' '></option>");
        	for (var i = 0; i < result.length; i++) {
             	var value2 = result[i].id + "_" + result[i].showvalue;
				if(value2 == enumval[1]){
					$("#enumchange2").append("<option selected='selected' value='" + value2 +"'>" + result[i].showvalue + "</option>");
				}else{
					$("#enumchange2").append("<option value='" + value2 +"'>" + result[i].showvalue + "</option>");
				}
            }
        }
        function getBeforName(resultMap,field){
        	var ret = "";
        	for (var i = 0; i < resultMap.length; i++) {
        		if(field == resultMap[i].name){
        			if((resultMap[i].ownerTableName.indexOf("formson") != -1)){
        				ret = "["+"${ctp:i18n('formoper.dupform.label')}"+resultMap[i].ownerTableIndex+"]";
        			}else{
        				ret = "["+"${ctp:i18n('form.base.mastertable.label')}"+"]";
        			}
        			return ret;
        		}
        	}
        	return ret;
        }
        // 向Select中填写数据
        function appendField() {
            $("#unselect").empty(); // 填写之前先清空最初的数据
            
            var formReportDesignManager_ = new formReportDesignManager();
            var resultMap = formReportDesignManager_.findFormFields("setShowDataList");
            
            for (var i = 0; i < sortColumnVal.length; i++) {
            	//统计分组项
            	if(sortColumnVal[i]!=""){
                    var beforName = getBeforName(resultMap,sortColumnVal[i]);
            		
                	$("#unselect").append(
                        "<option value='"+ sortColumnVal[i] +
                        "' title='" + sortColumnTitle[i] +
                        "' dataType='fieldData" +
                        "' type='unselect'>"+beforName+sortColumnTitle[i]+
                        "</option>");
                 }
                //fields.put(field.name, field);
            }
            if(sortCrossColumnVal!=""){
            	//交叉项
            	var beforName = getBeforName(resultMap,sortCrossColumnVal);
            		$("#unselect").append(
                        "<option value='"+ sortCrossColumnVal +
                        "' title='" + sortCrossColumnTitle +
                        "' dataType='crossData" +
                        "' type='unselect'>"+beforName+sortCrossColumnTitle+
                        "</option>");
            }
            var unselectNum=$("#unselect").find("option");
            if(unselectNum.length<=1){
            	if(dataListVal!=""&&(sortColumnVal!=""||sortCrossColumnVal!="")){
            	//统计项
            	for (var i = 0; i < dataListVal.length; i++) {
            		var beforName = getBeforName(resultMap,dataListVal[i]);
            		if(dataListVal[i]!=""){
            			$("#unselect").append(
                        	"<option value='"+ dataListVal[i] +
                        	"' title='" + dataListTitle[i] +
                        	"' dataType='dataList" +
                        	"' staticType='" +staticType[i]+
                        	"' type='" +columntype[i]+
                        	"' type='unselect'>"+beforName+dataListTitle[i]+
                        	"</option>");
                		}
                	}
            	}
            }
            //已选项过虑
            var set = setBordFun(true, "", "", 200);
            set.refreash();
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
            if (!$.isNull(parentPara.selectSortVal)) {
                var sortVal=parentPara.selectSortVal.split(",");
                var sortTitle=parentPara.selectSortTitle.split(",");
                for(var i=0;i<sortTitle.length;i++){
                	var val=sortVal[i].split("|");
              	  	$("#selected").append("<option id='"+val[0]+
                	"' title='"+sortTitle[i]+
                	"' value='"+val[1]+
                	"'>"+sortTitle[i]+"</option>");
                	$("#selected").find("option[id='"+val[0]+"']").attr("dataType",val[2]);
                	if(val.length>3){
                		$("#selected").find("option[id='"+val[0]+"']").attr("staticType",val[3]);
                	}
                	$("#unselect").find("option[value='"+val[0]+"']").addClass("hasSelected");
                }
            }
        }

        /*
         *父子界面交互方法，return值能在父页面获得
         */
        function OK() {
           var retValue=new Array();
           $.each( $("#selected option"),function(i,item){
           		var obj=new Object();
           		obj.sortId=$(item).attr("id");
           		obj.sortTitle=$(item).attr("title");
           		obj.sortType=$(item).val();
           		obj.sortName=(obj.sortType=="desc")?"↓":"↑";
           		obj.dataType=$(item).attr("dataType");
           		obj.staticType=$(item).attr("staticType");
           		retValue[i]=obj;
           })
           return retValue;
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
                        $(this).wrap("<span style='display:none'></span>");
                    });
                }
            	$(filed).removeAttr("selected");
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
                    <span class="left">${ctp:i18n('form.forminputchoose.formdata')}:
                    <input class="comp" id="searchField" name="name" value="" type="text" comp="type:'search',fun:'searchField',title:'查询数据项'" style="width: 180px;" /></span>
                </p>
            </td>
            <td></td>
            <td colspan="2">
	            <c:if test="${from == 'setReportHead'}">
	                <p class="font_size12 margin_b_5 margin_t_10">${ctp:i18n('report.reportDesign.dialog.groupingitem.title')}:</p><!--统计分组项 -->
	            </c:if>
	            <c:if test="${from == 'setSortColumn'}">
	                <p class="font_size12 margin_b_5 margin_t_10">${ctp:i18n('form.forminputchoose.order')}:</p>
	            </c:if>
            </td>
        </tr>
        <tr>
            <td valign="top" width="260">
                <select class="font_size12" style="width:260px; height: 340px;" id="unselect" size="20" <c:if test="${from == 'setReportHead'}">multiple</c:if>>
                </select>
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
            </td>
            <c:if test="${from != 'setCrossColumn'}">
            <td valign="middle" align="center" class="padding_lr_5">
	            <span class="select_selected hand" id="select_ico"></span><br><br>
	            <span class="select_unselect hand" id="unselect_ico"></span>
            </td>
            <td align="top">
	                <select class="font_size12"style="width:230px; height: 340px; " multiple size="20" id="selected"></select>
            </td>
            </c:if>
        </tr>
    </table>

    <!-- 分组统计项 修改名字 -->
    <div id="reportHeadRenameDiv" class="hidden">
        <div class="align_center form_area" layout="border:false">
            <table>
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
                            <font color="red">*</font>${ctp:i18n('report.reportDesign.dialog.title')}：
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
            <table>
                <tr class="margin_5">
                    <td class="align_right" nowrap>${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}：</td>
                    <td class="align_left" nowrap><span id="showDataListName"></span>
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
                            <input class="validate font_size12 left" type="text" id="showDataListNameModify" value="" validate="type:'string',name:'${ctp:i18n('report.reportDesign.dialog.title')}',notNull:true,maxLength:85,avoidChar:'\&#39;&quot;&lt;&gt;!,@#$%&*()'" />
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
            <table>
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
                            <input class="validate font_size12 left" type="text" id="countColumnName" value="" validate="type:'string',name:'${ctp:i18n('report.reportDesign.dialog.title')}',notNull:true,maxLength:85,avoidChar:'!,@#$%^:&*()\\\/\'&quot;?<>'" />
                        </div>
                    </td>
                </tr>
                <tr class="margin_5">
                    <td nowrap><span class="font_size12 font_bold">${ctp:i18n('report.reportDesign.set.displayFormat')}：</span></td>
                    <td class="align_left">
                    	<select class="font_size12 margin_t_5" style="width:80px;" id="formattype">
            				<option value=""></option>
							<option value="#">${ctp:i18n('report.reportDesign.micrometer')}</option>
							<option value="%">${ctp:i18n('report.reportDesign.percent')}</option>
            			</select>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 交叉列 修改名字 -->
    <div id="crossColumnDiv" class="hidden">
        <div class="align_center form_area" layout="border:false">
            <table>
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
