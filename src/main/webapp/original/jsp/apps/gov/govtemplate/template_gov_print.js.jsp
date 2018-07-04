<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script>

var GovPrinter = {

	// 临时方法为了解决在新建协同，内容为表单类型时，插入关联文档，打印页面关联文档图标不显示问题
	// 其实是getFileAttachmentName(2)中工程路径没获取到
	path : "src=\'/seeyon/common/images",
	tempMethod : function(colMydocument) {
		if (colMydocument.indexOf("src=\'/common/images") >= 0) {
			colMydocument = colMydocument.replace("src=\'/common/images", this.path);
			colMydocument = tempMethod(colMydocument);
		}
		return colMydocument;
	},

	getFileAttachmentName : function(type) {
		var atts = fileUploadAttachments.values();
		if (!atts) {
			return "";
		}
		var str = "";
		for ( var i = 0; i < atts.size(); i++) {
			var att = atts.get(i);
			if (att.type == type) {
				str += "<div id='attachmentDiv_"
						+ att.fileUrl
						+ "' style='float: left;px; line-height: 14px;' noWrap>"; // 支持超长文件名显示，原先使用上面值
				str += "<img src='"
						+ v3x.baseURL
						+ "/common/images/attachmentICON/"
						+ att.icon
						+ "' border='0' height='16' width='16'                                                    align='absmiddle' style='margin-right: 3px;'/>";
				str += att.filename;
				str += "&nbsp;</div>";
			}
		}
		return str;
	},

	/**
	 * 文件附件的数量
	 */
	getFileAttachmentNumber : function(type) {
		var number = 0;

		var files = fileUploadAttachments.values();
		if (!files) {
			return number;
		}

		for ( var i = 0; i < files.size(); i++) {
			if (files.get(i).type == type) {
				number++;
			}
		}

		return number;
	},

	cleanSpecial : function(str) {
		var position = str.indexOf("<DIV>");
		if (position == -1) {
			return str;
		}
		var leftstr = str.substr(0, position - 1);
		var rightstr = str.substr(position);
		var nextposition = rightstr.indexOf("</DIV>");
		var laststr = rightstr.substr(nextposition + 6);
		return cleanSpecial(leftstr + laststr);
	},
	
	formartTextField : function(result){
		//将input,select和textArea的边框去掉
		var inputReget = /<input([\s\S]*?)style[ ]*?=(['"]{1})(.*?)['"]{1}([\s\S]*?)>/ig;
		result = result.replace(inputReget, "<input$1style=$2$3;border:0;$2$4>");
		var arearReget = /<textarea([\s\S]*?)style[ ]*?=(['"]{1})(.*?)['"]{1}([\s\S]*?)>/ig;
		result = result.replace(arearReget, "<textarea$1style=$2$3;border:0;white-space:normal;$2$4>");
		var selectReget = /<select([\s\S]*?)style[ ]*?=(['"]{1})(.*?)['"]{1}([\s\S]*?)>/ig;
		result = result.replace(selectReget, "<select$1style=$2$3;border:0;$2$4>");
		
		return result;
	},

	infoFormPrint : function() {

		var cssList = new ArrayList();
		var pl = new ArrayList();

		// 消息报送单内容打印
		try {
			var printEdocBody = "${ctp:i18n('govform.label.print.subject')}";//公文单
			var selectList = [];
			
			//修改正文框的高度
			var contentEl = document.getElementById("my:content");
			var oldContentHeight = 0;
			if(contentEl){
				oldContentHeight = contentEl.style.height;
	            //var newContentHeight = document.getElementById("my:content").scrollHeight;
	            contentEl.style.height = "auto";
			}
			
			//打印组件，select没有选项时报错，新增一条空的选项，后续再移除
            var selectEls = document.getElementsByTagName("select");
            if(selectEls && selectEls.length > 0){
                for(var i = 0; i < selectEls.length; i++){
                    var selectEl = selectEls[i];
                    if(selectEl.options && selectEl.options.length < 1){
                        var varItem = new Option("","");
                        selectEl.options.add(varItem);
                        selectList.push(selectEl);
                    }
                }
            }
			
			var infoBody = document.getElementById('govFormData').outerHTML;
			infoBody = infoBody.replace('id="govFormData"', 'id="govFormData" class="processing_view align_left"');
			infoBody = infoBody.replace('id="my:report_date" class="comp input_date"', 'id="my:report_date" class="xdTextBox"');//上报时间打印时居中
			
			
			//还原高度设置
			if(contentEl){
				contentEl.style.height = oldContentHeight;
            }
			
			//移除select新增的选项
            for(var i = 0; i < selectList.length; i++){
                var selectEl = selectList[i];
                selectEl.options.length = 0;
            }

			// 去掉审批框的按钮
			var notPrintDiv = document.getElementById("notPrint");
			if (notPrintDiv) {
				var notPrintDivHTML = notPrintDiv.innerHTML;
				// 获取选中的
				infoBody = infoBody.replace(notPrintDivHTML, "");
			}
			
			// 是否为IE11
			if (navigator.userAgent.indexOf("rv:11") > -1) {
				infoBody = "<br>" + infoBody;
			}
			
			var re = /disabled/g;
			infoBody = infoBody.replace(re, " READONLY=\"READONLY\"");
			
			//去掉script
			re = /<script([\s\S]*?)<\/script>/ig;
			infoBody = infoBody.replace(re, "");

			re = /<INPUT([\s\S]*?)>/ig;
			infoBody = infoBody.replace(re, "<INPUT $1 style=\"border:0\">");

			var a = infoBody.split("</SELECT>");
			var result = "";
			for ( var i = 0; i < a.length; i++) {
				var aa = a[i];
				re = /<SELECT([\s\S]*?)>/ig;
				var n = aa.replace(re, "<SELECT $1 style=\"border:0;\">");
				result += n;
			}

			// 替换多行文本的回车,以及空格符号，让打印预览的页面的多行文本也有回车换行及空格的效果
			var textAreas = result.split(/<\/textarea>/gi);
			for ( var i = 0; i < textAreas.length; i++) {
				var index = textAreas[i].indexOf("<textarea");
				var index_2 = textAreas[i].indexOf("<TEXTAREA"); // indexOf不能用正则，所以分开大小写
				if (index != -1) {
					var textArea = textAreas[i].substring(index);
					var ind = textArea.indexOf(">");
					var textAreaInnerHtml = textArea.substring(ind);
					if (textAreaInnerHtml != ">") {
						var textAreaResult = textAreaInnerHtml.replace(
								/\r\n|\n/gm, '<br/>').replace(/\s/gm, '&nbsp;');
						var alignValue = "";
						if (textArea.indexOf("text-align") == -1) {
							alignValue = alignValue + " align=\"left\" ";
						}
						if (textArea.indexOf("class=") == -1) {
							alignValue = alignValue + " class=\"xdTextBox\" ";
						}
						
						//增加边框样式
						if(textArea.indexOf("style") == -1 && textArea.indexOf("STYLE") == -1){
							alignValue = alignValue + " style=\"border:0\" ";
						}
						
						result = result.replace(textAreaInnerHtml, alignValue
								+ textAreaResult);
					}

				} else if (index_2 != -1) {
					var textArea = textAreas[i].substring(index_2);
					var ind = textArea.indexOf(">");
					var textAreaInnerHtml = textArea.substring(ind);
					if (textAreaInnerHtml != ">") {
						var textAreaResult = textAreaInnerHtml.replace(
								/\r\n|\n/gm, '<br/>').replace(/\s/gm, '&nbsp;');
						var alignValue = "";
						if (textArea.indexOf("text-align") == -1) {
							alignValue = alignValue + " align=\"left\" ";
						}
						if (textArea.indexOf("class=") == -1) {
							alignValue = alignValue + " class=\"xdTextBox\" ";
						}
						

						//增加边框样式
						if(textArea.indexOf("style") == -1 && textArea.indexOf("STYLE") == -1){
							alignValue = alignValue + " style=\"border:0\" ";
						}
						
						result = result.replace(textAreaInnerHtml, alignValue
								+ textAreaResult);
					}

				}
			}

			var styleStr = result.split("style=\"");
			var newResult = styleStr[0];
			for ( var i = 1; i < styleStr.length; i++) {
				var a = styleStr[i];
				var inde = a.indexOf("\"");
				var style = a.substring(0, inde);
				if (style.indexOf("COLOR") == -1 && style.length > 20) {
					a = "COLOR:BLACK;" + a;
				}

				a = "style=\"" + a;
				if (a.indexOf("name") != -1) {
					a = "align=\"left\" " + a;
				}

				newResult += a;
			}
			result = newResult;
			
			//将input,select和textArea的边框去掉
			result = this.formartTextField(result);
			
			// textarea改成div
			result = result.replace(/<textarea([\s\S]*?)>/ig, "<div$1>").replace(/<\/textarea>/ig, "</div>");
			
			// 39413 打印出来的控件内的内容为黑色。
			result = result.replace(/link-blue/gm, '');
			$('.AAAAAA').each(function() {
				$(this)[0].style.display = "none";
			});
			// 32718 处理意见过长，公文单打印异常。
			var a = result;
			while (a.indexOf("<SPAN") != -1) {
				a = a.substring(a.indexOf("<SPAN") + 1);
				var span = a.substring(0, a.indexOf(">"));
				var aft = "";
				if (span.indexOf("shenpi") != -1 || span.indexOf("niwen") != -1
						|| span.indexOf("shenhe") != -1
						|| span.indexOf("fuhe") != -1
						|| span.indexOf("fengfa") != -1
						|| span.indexOf("huiqian") != -1
						|| span.indexOf("qianfa") != -1
						|| span.indexOf("zhihui") != -1
						|| span.indexOf("yuedu") != -1
						|| span.indexOf("banli") != -1
						|| span.indexOf("dengji") != -1
						|| span.indexOf("niban") != -1
						|| span.indexOf("keyword") != -1
						|| span.indexOf("wenshuguanli") != -1
						|| span.indexOf("chengban") != -1
						|| span.indexOf("otherOpinion") != -1
						|| span.indexOf("opinion") != -1) {

					var spanAll = a.substring(0, a.indexOf("</SPAN>") + 7);
					if (spanAll.indexOf("showV3XMemberCard") != -1) {
						var oldSpan = a.substring(0, a.indexOf("</SPAN>") + 7);
						var spanObj = spanAll.substring(spanAll
								.indexOf("<SPAN"));
						var spanObj1 = spanObj.substring(0, spanObj
								.indexOf(">") + 1);
						spanAll = spanAll.replace(spanObj1, "");
						spanAll = spanAll.replace(/<\/SPAN>/g, "");
						spanAll = spanAll.replace("SPAN", "div");
						result = result.replace(oldSpan, spanAll);

					} else {
						aft = span.replace("SPAN", "div");
						result = result.replace(span, aft);
					}
				}
			}

			// 去掉ie9下黑框
            var tempRegExp = /class="xdLayout"/ig;
            result=result.replace(tempRegExp,"class=\"xdLayout xdLayout2\"");

			// 修改select框样式
			result = result.replace(/class=\"xdComboBox xdBehavior_Select\"/g,
					"class=\"xdTextBox\"");

			var infoBodyFrag = new PrintFragment(printEdocBody, result);
			pl.add(infoBodyFrag);
		} catch (e) {

		}
		
		// 附件内容
        try {
            var printAttachment = "${ctp:i18n('common.attachment.label')}"; // 附件
            attNumber = this.getFileAttachmentNumber(0, "showAttFile");
            var colAttachment = "";
            if (attNumber != 0) {
                colAttachment = "<table class='margin_t_20' style='width:95%' align='center'><tr><td valign='top' nowrap='nowrap' style='width:100px;'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"
                        + "${ctp:i18n('govform.label.summary.attachment')}"
                        + " : ("
                        + attNumber
                        + ")</div></td><td valign='top'>"
                        + this.getFileAttachmentName(0) + "</td></tr></table>";
                colAttachment = this.cleanSpecial(colAttachment);
                colAttachment = this.tempMethod(colAttachment);
            }

            var colAttachment1Frag = new PrintFragment(printAttachment,
                    colAttachment);
            pl.add(colAttachment1Frag);

        } catch (e) {
        }

		var setHidden = false;
		var hiddenReplay = false;

		try {

			// 增加发起人意见,处理意见打印
			var sendOpinionTitleObj = document
					.getElementById('sendOpinionTitle');
			var repDiv = document.getElementById("noteOpinion");
			if (repDiv != null && repDiv.style.display == "block") {
				repDiv.style.display = "none";
				hiddenReplay = true;
			}

			if (document.getElementById("addSenderOpinionDiv") != null) {
				setHidden = true;
				document.getElementById("addSenderOpinionDiv").style.visibility = "hidden";
			}

			if (sendOpinionTitleObj != null) {
				var sendOpinionTitleFrag = new PrintFragment(
						sendOpinionTitleObj.innerHTML,
						document.getElementById("printSenderOpinionsTable").outerHTML);
				pl.add(sendOpinionTitleFrag);
			}

			// 审核意见
			// var dealOpinionTitleObj = document
			// .getElementById("dealOpinionTitle");
			//
			// if (sendOpinionTitleObj != null) {
			// var printOtherOp = document
			// .getElementById("printOtherOpinionsTable").outerHTML;
			// var dealOpinionTitleFrag = new PrintFragment(
			// dealOpinionTitleObj.innerHTML, printOtherOp);
			// pl.add(dealOpinionTitleFrag);
			// }

		} catch (e) {
		}

		// 打印组件引入两个样式，保证文单打印效果
		cssList.add(_ctxPath + "/apps_res/gov/govform/css/gov_print.css");
		cssList.add(_ctxPath + "/common/all-min.css");
		cssList.add(_ctxPath + "/common/RTE/editor/css/fck_editorarea4Show.css");
		cssList.add(_ctxPath + "/common/css/default.css");
		cssList.add(_ctxPath + "/skin/default/skin.css");
		cssList.add(_ctxPath + "/apps_res/gov/govform/css/formview.css");
        cssList.add(_ctxPath + "/apps_res/gov/govform/css/formview_extends.css");
		printList(pl, cssList);

		try {
			if (setHidden) {
				document.getElementById("addSenderOpinionDiv").style.visibility = "inherit";
			}
			if (hiddenReplay) {
				document.getElementById("noteOpinion").style.display = "block";
			}
		} catch (e) {
		}
	}
};

</script>