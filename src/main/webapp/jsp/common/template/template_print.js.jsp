<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script>
	//模板打印
	function doPrint(printFrom){
		/* html(10,"标准格式正文HTML"),
		form(20,"表单格式正文"),
		txt(30,"text正文"),
		officeWord(41,"officeWord正文"),
		officeExcel(42,"officeExcel正文"),
		wpsWord(43,"wpsWord正文"),
		wpsExcel(44,"wpsExcel正文"); */
		var type="0";
		var contentDiv = getMainBodyDataDiv$();
		type = $("#contentType",contentDiv).val();
		var isHTML = false;
		var isForm = false;
		var preBodyFragArr="";
		var afterBodyFragArr="";
		if(type=="10"){ isHTML = true;} 
		if(type=="20"){ isForm = true;}
		if (type == undefined){
		    isHTML = true;
		}
		if(isHTML || isForm){
			var pl=prePrint(printFrom);
			$.content.print(pl.get(0),pl.get(1),"",printFrom);
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
						    	   $.content.print(preBodyFragArr,afterBodyFragArr,"mainpp",printFrom);
								}else{
									var pl=prePrint(printFrom);
									$.content.print(pl.get(0),pl.get(1),"colPrint",printFrom);
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

	//打印 
	function prePrint(printFrom){		
		//标题
		try {
			var printSubject = "${ctp:i18n('collaboration.newcoll.subject')}"; //标题
			var printsub = $("#subject").html();
			printsub = "<center><span style='font-size:24px;line-height:24px;'>"
					+ printsub.escapeHTML() + "</span></center>";
			//标题文字样式与查时不一样. 
			var printSubFrag = new PrintFragment(printSubject, printsub);
		} catch (e) {}
		//创建人
		try {
			var printSenderInfo = "${ctp:i18n('template.temPrint.createMember')}"; //创建人
			var printSender = $("#senderInfo").html();
			printSender = "<table><tr><td valign='top'><div class='div-float margin_b_10' style='font-size: 16px;line-height:16px;'>"
                + printSenderInfo //创建人
                + " : "
                + printSender
                + "</div></td></tr></table>";	
			var printSenderFrag = new PrintFragment("",
					printSender);
		} catch (e) {}
		try {
			//var printAttachment =  _("collaborationLang.print_attachment");                
			var printAttachment = "${ctp:i18n('common.attachment.label')}"; //附件
			var attNumber = getFileAttachmentNumber(0, "22");
			var colAttachment = "";
			if (attNumber != 0) {
				//colAttachment = "<table><tr><td valign='top'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"+_("collaborationLang.print_attachment")+" : ("+attNumber+")</div></td><td valign='top'>"+getFileAttachmentName(0) + "</td></tr></table>"; 
				colAttachment = "<table><tr><td valign='top'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"
						+ printAttachment //附件
						+ " : ("
						+ attNumber
						+ ")</div></td><td valign='top'>"
						+ getFileAttachmentName(0) + "</td></tr></table>";
				colAttachment = "<br>" + colAttachment + "<br>";
				colAttachment = cleanSpecial(colAttachment);
			}
			var colAttachment1Frag = new PrintFragment(printAttachment,
					colAttachment);
		} catch (e) {
		}

		var pl1 = new ArrayList();
		var pl2 = new ArrayList();
		pl1.add(printSubFrag);
		pl2.add(printSenderFrag);
		pl2.add(colAttachment1Frag);
		
		var pl = new ArrayList();
		pl.add(pl1);
		pl.add(pl2);
		return pl;
	}
</script>