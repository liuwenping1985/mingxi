/**
 * 执行打印事件的方法
 * @param printObj
 */
function doPrint(printObj){
	var contentType = "";
	if (printObj != null) {
		contentType = printObj.contentType;
		printObj.viewState = $("#viewState",getIFrameDOM("mainbodyFrame")).val();
		if (contentType == "10" || contentType == "20") {
			printObj.attsList = getAttAndAdoc();
			if (contentType == "20" && printObj.operaType == "edit") {
				getIFrameWindow("mainbodyFrame").preSubmitData(function() {
					printObj.content = getPlanPrintContent(contentType, printObj.operaType);
					planPrint(printObj);
				}, function() {
					return;
				}, false,false);
			} else {
				printObj.content = getPlanPrintContent(contentType, printObj.operaType);
				planPrint(printObj);
			}
		} else {
			var prePrintDialog = $.dialog({
				id: 'url',
				url: _ctxPath + "/collTemplate/collTemplate.do?method=showPrintSelector",
				width: 260,
				height: 120,
				title: $.i18n('collaboration.print.SelectType.label'),
				targetWindow:getCtpTop(),
				buttons: [{
					text: $.i18n('common.button.ok.label'),
					handler: function () {
					    var rv = prePrintDialog.getReturnValue();
					    if(rv){
						    if(rv == "mainpp"){
								if (contentType > 40 && contentType < 50) {
									if (getIFrameWindow("mainbodyFrame").officePrint) {
										//$("#officeTransIframe", getIFrameWindow("mainbodyFrame").document).remove();
										//$("#officeFrameDiv", getIFrameWindow("mainbodyFrame").document).show();
										getIFrameWindow("mainbodyFrame").officePrint();
									}
									prePrintDialog.close();
									return;
								}
							}else{
								printObj.printType = rv;
								planPrint(printObj);
								prePrintDialog.close();
							}
					    }
					}
				}, {
					text: $.i18n('common.button.cancel.label'),
					handler: function () {
					    prePrintDialog.close();
					}
				}]
			});
		}
	}
}

/**
 * 获取附件、图片和关联文档的HTML代码，表单编辑态附件等内容无法从后台获取
 * 这个地方获取后传到打印页面，在打印页面将对应的单元格替换
 */
function getAttAndAdoc() {
	var attsList = new Array();
	if (getIFrameWindow("mainbodyFrame").form) {// 还要将form对象传过去，用于寻找表单重复项的recordId
		attsList["formObj"] = getIFrameWindow("mainbodyFrame").form;
	}
	$("span[id$='_span']", $("#mainbodyDiv",getIFrameDOM("mainbodyFrame"))).each(function() {
		var inputSpan = $(this);
		var fieldVal = inputSpan.attr("fieldVal");
		if (fieldVal == undefined) {
			return true;
		} else {
			fieldVal = $.parseJSON(fieldVal);
		}
		if (fieldVal.inputType == 'attachment' || fieldVal.inputType == 'document' || fieldVal.inputType == 'image') {
			// 二维的重复项中的单元格idStr是一样的，所以使用recordId_idStr作为Key，如果不是重复项，recordId=0
			var idStr = inputSpan.attr("id").split("_")[0];
			attsList[getIFrameWindow("mainbodyFrame").getRecordIdByJqueryField(inputSpan) + "_" + idStr] = inputSpan.html();
		}
	});
	return attsList;
}
/**
 * 清楚html字符串中的A标签
 * @param str
 */
function cleanA(str) {
	var position = str.indexOf("<a>");
	if (position == -1) {
		return str;
	}
	var leftstr = str.substr(0, position - 1);
	var rightstr = str.substr(position);
	var nextposition = rightstr.indexOf("</a>");
	var laststr = rightstr.substr(nextposition + 4);
	return cleanSpecial(cleanA(leftstr + laststr));
}

function getFormContentPrint(operaType) {
	var planContent = '<div id="inputPosition" style="width: 3px; height: 0px; border:0px  solid;" ></div>';
	if(operaType == "view") {
		planContent = getIFrameWindow("mainbodyFrame").getFormPrintContent(planContent);
	} else {
		planContent = getIFrameWindow("mainbodyFrame").getFormPrintContent(planContent);
	}
	return planContent;
}

/**
 * 获取计划正文的打印信息
 * 
 * @param contentType
 */
function getPlanPrintContent(contentType, operaType) {
	var planContent = '<div id="inputPosition" style="width: 3px; height: 0px; border:0px  solid;" ></div>';
	if(contentType == 10) {
		planContent += "<div>";
		if ($("#fckedit",getIFrameDOM("mainbodyFrame")).attr("comp")) {
			planContent += getIFrameWindow("mainbodyFrame").$.content.getContent();
		} else {
			planContent += getIFrameWindow("mainbodyFrame").getMainBodyHTMLDiv$().html();
		}
		planContent += "<div class='clearfix'></div></div>";
	} else {
		if (contentType == 20) {
			planContent += getFormContentPrint(operaType);
		}
	}
	return planContent;
}

/**
 * 计划的打印信息组装
 * @param printObj
 */
function planPrint(printObj) {
	var printSubFrag = "";
	if (printObj == null) {
		return null;
	}
	//标题的打印信息
	try {
		var printSubject = $.i18n('plan.grid.label.title'); //标题
		var printsub = printObj.subject;
		printsub = "<center style='margin-top: 10px;'><span style='font-size:24px;line-height:24px;'>"
				+ printsub.escapeHTML() + "</span></center>";
		printSubFrag = new PrintFragment(printSubject, printsub);
	} catch (e){}
	//发起人的打印信息
	var printSenderFrag = "";
	try{
		var printSenderInfo = $.i18n('collaboration.newPrint.originatorInformation'); //发起者信息
		var printSender = "";
		printSender = printObj.creater + " (" +printObj.departName + " "+ printObj.postName + ") ";
		printSender += printObj.createDate;
		printSender = "<center><span style='font-size:12px;line-height:24px;'>"
					+ printSender + "</span></center>";
		printSenderFrag = new PrintFragment(printSenderInfo,
					printSender);
	} catch (e) {}
	//正文的打印信息
	var printContentFrag = "";
	try {
		var printContentTitle = $.i18n('collaboration.colPrint.mainBody');
		var printContent = "";
		if (printObj.content && printObj.content.length > 0) {
			printContent = cleanA(printObj.content);
			printContentFrag = new PrintFragment(printContentTitle, printContent);
		}
	} catch(e) {}
	//附件的打印信息
	var printAttachmentFrag = "";
	try {
		var printAttachment = $.i18n('common.attachment.label');
		var attNumber = 0;
		attNumber = printObj.attNumber;
		var planAttachment = "";
		if (attNumber != 0) {
			planAttachment = "<table class='margin_t_20'><tr><td valign='top' nowrap='nowrap'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"
				+ $.i18n('plan.detail.desc.attachment')
				+ " : ("
				+ attNumber
				+ ")</div></td><td valign='top'>"
				+ printObj.attNameHtml + "</td></tr></table>";
		}
		printAttachmentFrag = new PrintFragment(printAttachment, planAttachment);
	} catch (e) {}
	//关联文档的信息
	var printAssdocFrag = "";
	try {
		var printAssdoc = $.i18n('plan.toolbar.button.relatedoc');
		var assDocNumber = "";
		if (printObj.operaType == "view") {
		    assDocNumber = getFileAttachmentNumber(2, 'b');
		} else {
		    assDocNumber = getFileAttachmentNumber(2, 'position1');
		}
        var planMydocument = "";
        if (assDocNumber != 0) {
            planMydocument = "<table class='margin_t_20'><tr><td valign='top' nowrap='nowrap'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"
                    + printAssdoc 
                    + " : (" + assDocNumber + ")</div></td><td valign='top'>"
                    + getFileAttachmentName(2)+"</td></tr></table><br>";
            planMydocument = cleanSpecial(planMydocument);
            planMydocument = tempMethod(planMydocument);
        }
        printAssdocFrag = new PrintFragment(printAssdoc, planMydocument);
	} catch(e) {}
	//处理人意见的信息
	var printCommentFrag = "";
	try {
		var printComentTitle = $.i18n('collaboration.colPrint.handleOpinion');
		var printComment = "";
		if (printObj.opinionComment && printObj.opinionComment.length > 0) {
			printComment = cleanA(printObj.opinionComment);
		}
		printCommentFrag = new PrintFragment(printComentTitle, printComment);
	} catch(e) {}	
	//总结的信息
	var printSummaryFrag = "";
	try {
		var printSummaryTitle = $.i18n('plan.summary.tab.summary');
		var printSummary = "";
		if (printObj.summary && printObj.summary.length > 0) {
			printSummary = cleanA(printObj.summary);
			printSummaryFrag = new PrintFragment(printSummaryTitle, printSummary);
		}
	} catch(e) {}
	
	var cssList = new ArrayList();
	var pl = new ArrayList();
	pl.add(printSubFrag);
	pl.add(printSenderFrag);
	pl.add(printContentFrag);
	pl.add(printAttachmentFrag);
	pl.add(printAssdocFrag);
	pl.add(printCommentFrag);
	pl.add(printSummaryFrag);
	
	buildPrintList(pl,cssList,printObj);
}

function buildPrintList (plList, cssList, printObj) {
	var printDefaultSelect = new Array();//默认打印的部分的索引
	var notPrintDefaultSelect = new Array(); //默认不勾选的部分的索引列表
	var printContentFrag = null;
	var printCommentFrag = null;
	if (plList.size() > 0) {
		if(printObj.printType == "colPrint") {
			for (var i=0; i<plList.size(); i++) {
				if (i == 5) {
					printCommentFrag = plList.get(i);
					if (printCommentFrag != null && printCommentFrag != "undefined" && printCommentFrag != undefined) {
						printDefaultSelect.push(i);
					}
				} else {
					notPrintDefaultSelect.push(i);
				}
			}
		} else {
			for (var i=0; i<plList.size(); i++) {
				if (i == 2) {
					printContentFrag = plList.get(i);
					if (printContentFrag != null && printContentFrag != "undefined" && printContentFrag != undefined) {
						printDefaultSelect.push(i);
					}
				} else {
					notPrintDefaultSelect.push(i);
				}
			}
		}
	}
	
	printList(plList, cssList, printDefaultSelect, notPrintDefaultSelect, printObj.contentType, printObj.viewState, printObj.attsList);
}
//临时方法为了解决在新建计划，内容为表单类型时，插入关联文档，打印页面关联文档图标不显示问题
//其实是getFileAttachmentName(2)中工程路径没获取到
var path="src=\'"+ _ctxPath +"/common/images";
function tempMethod(colMydocument){
	if(colMydocument.indexOf("src=\'/common/images") >=0){
		colMydocument=colMydocument.replace("src=\'/common/images", path);
		colMydocument=tempMethod(colMydocument);
	}
	return colMydocument;
}