<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script>
	//打印
	//新建事项中打印映射
	function newDoPrint(printFrom){
		/* html(10,"标准格式正文HTML"),
		form(20,"表单格式正文"),
		txt(30,"text正文"),
		officeWord(41,"officeWord正文"),
		officeExcel(42,"officeExcel正文"),
		wpsWord(43,"wpsWord正文"),
		wpsExcel(44,"wpsExcel正文"); */
		var type="";
		if(printFrom.indexOf("summary")!=-1){
	    	type = bodyType;
		}
		
		if(printFrom=="newCol"){
			var fnx;
	        if($.browser.mozilla){
	            fnx = document.getElementById("zwIframe").contentWindow;
	        }else{
	            fnx = document.zwIframe;
	        }
			var contentDiv = fnx.getMainBodyDataDiv$();
		    type = $("#contentType",contentDiv).val();
		}
		var isHTML = false;
		var isForm = false;
		var preBodyFragArr="";
		var afterBodyFragArr="";
		if(type=="10"){ isHTML = true;}
		if(type=="20"){ isForm = true;}         
		if(isHTML){
			var pl=newColPrint(printFrom);
			printCallWay(pl.get(0),pl.get(1),"",printFrom);
		}else{
			if(isForm){//打印表单
				if(printFrom=="newCol"){//新建页面打印
					var isOffice = $("#zwOfficeIframe").css("display");
				}else{
				 	var isOffice = $("#componentDiv").contents().find("#zwOfficeIframe").css("display");
				}
				 if(isOffice=="block"){//如果是表单的office正文 
					var prePrintDialog = $.dialog({
						id: 'url',
						url: "${path}/collTemplate/collTemplate.do?method=showPrintSelector&isForm=false",
						width: 260,
						height: 150,
						title: "${ctp:i18n('collaboration.print.SelectType.label')}",
						targetWindow:getCtpTop(),
						buttons: [{
						    text: "${ctp:i18n('permission.confirm')}",
						    handler: function () {
						       var rv = prePrintDialog.getReturnValue();
						       if(rv){
							       if(rv == "mainpp"){//打印office 
							    	   if(printFrom=="newCol"){
							    		   window.frames["zwOfficeIframe"].window.officePrint();
							    	   }else{
							    	   	   window.frames["componentDiv"].frames["zwOfficeIframe"].window.officePrint();
							    	   }
									}else{//打印意见
									   var pl=newColPrint(printFrom);
									   printCallWay(pl.get(0),pl.get(1),"colPrint",printFrom);
									}
						       }
						       prePrintDialog.close();
						   }
						}, {
						    text: "${ctp:i18n('permission.cancel')}",
						    handler: function () {
						        prePrintDialog.close();
						    }
						}]
					});
					$("#zwIframe").css("visibility","visible");
				}else{
 				    var pl=newFormMainPrint(printFrom);
				    printCallWay(pl.get(0),pl.get(1),"",printFrom); 
				}
			}else{
				var prePrintDialog = $.dialog({
					id: 'url',
					url: "${path}/collTemplate/collTemplate.do?method=showPrintSelector&isForm="+isForm,
					width: 260,
					height: 120,
					title: "${ctp:i18n('collaboration.print.SelectType.label')}",
					targetWindow:getCtpTop(),
					buttons: [{
					    text: "${ctp:i18n('permission.confirm')}",
					    handler: function () {
					       var rv = prePrintDialog.getReturnValue();
					       if(rv){
						       if(rv == "mainpp"){
						    	    printCallWay(preBodyFragArr,afterBodyFragArr,"mainpp",printFrom);
								}else{
									var pl=newColPrint(printFrom);
									printCallWay(pl.get(0),pl.get(1),"colPrint",printFrom);
								}
					       }
					       prePrintDialog.close();
					   }
					}, {
					    text: "${ctp:i18n('permission.cancel')}",
					    handler: function () {
					        prePrintDialog.close();
					    }
					}]
				});
			}
		}
	}
	function printCallWay(preBodyFragArr,afterBodyFragArr,printType,printFrom){
		if(printFrom.indexOf("summary")!=-1){
			if($.browser.mozilla){
    			//fnx  =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
    			componentDiv.document.getElementById("zwIframe").contentWindow.$.content.print(preBodyFragArr,afterBodyFragArr,printType,printFrom);
    		}else{
    			//fnx =$(window.componentDiv)[0].document.zwIframe;
    			componentDiv.document.zwIframe.$.content.print(preBodyFragArr,afterBodyFragArr,printType,printFrom);
    		}
		}else{
			var fnx;
	        if($.browser.mozilla){
	            fnx = document.getElementById("zwIframe").contentWindow;
	        }else{
	            fnx = document.zwIframe;
	        }
	        fnx.$.content.print(preBodyFragArr,afterBodyFragArr,printType,printFrom);
		}
	}
	//新建事项中打印 
	var printSubFrag = "";
	function newColPrint(printFrom){
		//标题
		try {
			var printSubject = "${ctp:i18n('collaboration.newcoll.subject')}"; //标题
			var printsub = $("#subject").val();
			printsub = "<center style='margin-top: 10px;'><span style='font-size:24px;line-height:24px;'>"
					+ printsub.escapeHTML() + "</span></center>";
			//标题文字样式与查时不一样. 
			printSubFrag = new PrintFragment(printSubject, printsub);
		} catch (e) {}
		//发起者信息
		var printSenderFrag = "";
		try {
			var printSenderInfo = "${ctp:i18n('collaboration.newPrint.originatorInformation')}"; //发起者信息
			var printSender="";
		    if(printFrom==="summary"){
                printSender = $("#panleStart").html() +" (${ctp:toHTML(ctp:getDepartment(summaryVO.startMemberDepartmentId).name)}"+' '+'${ctp:toHTML(summaryVO.startMemberPostName)}) ';
            }else if(printFrom==="newCol"){
               printSender = '${currentUserName}' + "(${ctp:toHTML(departName)} ${ctp:toHTML(postName)}) "; 
            }
			printSender+= $("#createDate").val();
			printSender = "<center><span style='font-size:12px;line-height:24px;'>"
					+ printSender + "</span></center>";
			printSenderFrag = new PrintFragment(printSenderInfo,
					printSender);
		} catch (e) {}
		var colAttachment1Frag ="";
		try {
		    var printAttachment = "${ctp:i18n('common.attachment.label')}"; //附件
		    var attNumber = "";
		    if (printFrom==="summary") {
		        attNumber = getFileAttachmentNumber(0, "showAttFile");
		    } else {
		        attNumber = getFileAttachmentNumber(0, "Att");
		    }
			var colAttachment = "";
			if (attNumber != 0) {
				colAttachment = "<table class='margin_t_20'><tr><td valign='top' nowrap='nowrap'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"
				        + "${ctp:i18n('collaboration.summary.attachment')}"
						+ " : ("
						+ attNumber
						+ ")</div></td><td valign='top'>"
						+ getFileAttachmentName(0) + "</td></tr></table>";
				colAttachment = cleanSpecial(colAttachment);
				colAttachment = tempMethod(colAttachment);
			}
			colAttachment1Frag = new PrintFragment(printAttachment,
					colAttachment);
		} catch (e) {
		}
		
		//关联文件和附件
        var colAttachment2Frag ="";
        try {
            var printColMydocument = "${ctp:i18n('collaboration.sender.postscript.correlationDocument')}"; //关联文档
            var att2Number = getFileAttachmentNumber(2, 'Doc1');
            var colMydocument = "";
            if (att2Number != 0) {
                colMydocument = "<table class='margin_t_20'><tr><td valign='top' nowrap='nowrap'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"
                        + printColMydocument 
                        + " : (" + att2Number + ")</div></td><td valign='top'>"
                        + getFileAttachmentName(2)+"</td></tr></table><br>";
                colMydocument = cleanSpecial(colMydocument);
                colMydocument = tempMethod(colMydocument);
            }
            colAttachment2Frag = new PrintFragment(printColMydocument,
                    colMydocument);
        } catch (e) {
        }

		//附言
		var sendOpinionFrag='';
		if(printFrom!=="summary"){//在查看协同详细页面 意见中已经包含附言
			try {
			    var content = $("#fuyan #content_coll").val();
			    var defaultValue = $.i18n("collaboration.newcoll.fywbzyl");
			    if (content == defaultValue) {
			        content = "";
			    } else if ($("#fuyan #content_coll").val() != ""){
			        content = $("#fuyan #content_coll").val().escapeHTML();
			    }
			    var printColOpinion = "${ctp:i18n('collaboration.sender.postscript')}"; //附言
			    var colOpinion = "<br/><div class='div-float body-detail-su' style='font-size: 12px; font-weight: bolder;'>"
	                 + printColOpinion + " :</div></br>"
	                 +"<div style='line-height: 20px; margin-bottom: 5px;'>" + content+"</div></br>";
				colOpinion = cleanSpecial(colOpinion);
				sendOpinionFrag = new PrintFragment(printColOpinion, colOpinion);
			} catch (e) {
			}
		}
		var pl1 = new ArrayList();
		var pl2 = new ArrayList();
		pl1.add(printSubFrag);
		pl1.add(printSenderFrag);
        pl2.add(colAttachment1Frag);
		pl2.add(colAttachment2Frag);
		if(printFrom!=="summary"){
			pl2.add(sendOpinionFrag);
		}
		
		var pl = new ArrayList();
		pl.add(pl1);
		pl.add(pl2);
		return pl;
	}
	//新建事项中表单打印
	function newFormMainPrint(printFrom){              
		try {
			//var printSubject = _("collaborationLang.print_subject");
			//var printsub = document.getElementById("subject").value;
			var printSubject = "${ctp:i18n('collaboration.newcoll.subject')}"; //标题
			var printsub = $("#subject").val();
			printsub = "<center style='margin-top: 10px;'><span style='font-size:24px;line-height:24px;'>"
                + printsub.escapeHTML() + "</span></center>";
			//标题文字样式与查时不一样. 
			var printSubFrag = new PrintFragment(printSubject, printsub);
		} catch (e) {
		}
		try {
			var printSenderInfo = "${ctp:i18n('collaboration.newPrint.originatorInformation')}"; //发起者信息
			var printSender="";
			if(printFrom==="summary"){
                printSender = $("#panleStart").html() +" (${ctp:toHTML(ctp:getDepartment(summaryVO.startMemberDepartmentId).name)}"+' '+'${ctp:toHTML(summaryVO.startMemberPostName)}) ';
            }else if(printFrom==="newCol"){
                printSender = '${currentUserName}' + "(${ctp:toHTML(departName)} ${ctp:toHTML(postName)}) "; 
            }
            printSender+= $("#createDate").val();
            printSender = "<center><span style='font-size:12px;line-height:24px;'>"
                    + printSender + "</span></center>";
			var printSenderFrag = new PrintFragment(printSenderInfo, printSender);
		} catch (e) {
		}
		try {		
			//var printColOpinion = _("collaborationLang.print_senderNote");
			var printColOpinion = "${ctp:i18n('collaboration.sender.postscript')}"; //附言
            //发起人附言
			var content = $("#fuyan #content_coll").val();
            var defaultValue = $.i18n("collaboration.newcoll.fywbzyl");
            if (content == defaultValue) {
                content = "";
            } else if ($("#fuyan #content_coll").val() != ""){
                content = $("#fuyan #content_coll").val().escapeHTML();
            }
             var colOpinion = "<br/><div class='div-float body-detail-su' style='font-size: 12px; font-weight: bolder;'>"
                 + printColOpinion + " :</div><br />"
                 + "<div style='line-height: 20px; margin-bottom: 5px;'>" + content+"</div></br>";
            colOpinion = cleanSpecial(colOpinion);
			var sendOpinionFrag = new PrintFragment(printColOpinion, colOpinion);
		} catch (e) {
		}
		
		try {
			//var printAttachment = _("collaborationLang.print_attachment");
			var printAttachment = "${ctp:i18n('common.attachment.label')}"; //附件
			if (printFrom==="summary") {
                attNumber = getFileAttachmentNumber(0, "showAttFile");
            } else {
                attNumber = getFileAttachmentNumber(0, "Att");
            }
			var colAttachment = "";
            if (attNumber != 0) {
                colAttachment = "<table class='margin_t_20'><tr><td valign='top' nowrap='nowrap'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"
                        + "${ctp:i18n('collaboration.summary.attachment')}"
                        + " : ("
                        + attNumber
                        + ")</div></td><td valign='top'>"
                        + getFileAttachmentName(0) + "</td></tr></table>";
                colAttachment = cleanSpecial(colAttachment);
                colAttachment = tempMethod(colAttachment);
            }
            
			var colAttachment1Frag = new PrintFragment(printAttachment,
					colAttachment);
		} catch (e) {
		}
		try {
            var printColMydocument = "${ctp:i18n('collaboration.sender.postscript.correlationDocument')}"; //关联文档
            var att2Number = getFileAttachmentNumber(2, 'Doc1');
            var colMydocument = "";
            if (att2Number != 0) {
                colMydocument = "<table class='margin_t_20'><tr><td valign='top' nowrap='nowrap'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"
                        + printColMydocument 
                        + " : (" + att2Number + ")</div></td><td valign='top'>"
                        + getFileAttachmentName(2)+"</td></tr></table><br>";
                colMydocument = cleanSpecial(colMydocument);
                colMydocument = tempMethod(colMydocument);
            }
            var colAttachment2Frag = new PrintFragment(printColMydocument,colMydocument);
        } catch (e) {
        }
		
		var pl1 = new ArrayList();
		var pl2 = new ArrayList();
		pl1.add(printSubFrag);
		pl1.add(printSenderFrag);
        pl2.add(colAttachment1Frag);
		pl2.add(colAttachment2Frag);
		pl2.add(sendOpinionFrag);
		
		var pl = new ArrayList();
		pl.add(pl1);
		pl.add(pl2);
		return pl;
	}
	//临时方法为了解决在新建协同，内容为表单类型时，插入关联文档，打印页面关联文档图标不显示问题
	//其实是getFileAttachmentName(2)中工程路径没获取到
	var path="src=\'${path}/common/images";
	function tempMethod(colMydocument){
		if(colMydocument.indexOf("src=\'/common/images") >=0){
			colMydocument=colMydocument.replace("src=\'/common/images", path);
			colMydocument=tempMethod(colMydocument);
		}
		return colMydocument;
	}
</script>