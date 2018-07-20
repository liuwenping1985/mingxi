<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
<%@ page %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../common/common.jsp"%>
<title>单据映射配置界面</title>
<script type="text/javascript" language="javascript">
$().ready(function(){
	if($.ctx.hasPlugin('easvoucher')){
		$("#form_reversal").show();
	}else{
		$("#form_reversal").hide();
	}
	$("#formName").click(function(){
		var dialog = getA8Top().$.dialog({
    		url:"${path}/voucher/documnentationMapperController.do?method=showFormList",
			    width: 800,
			    height: 500,
			    title: "${ctp:i18n('voucher.formmapper.form.select')}",
			    buttons: [{
			        text: "${ctp:i18n('common.button.ok.label')}", //确定
			        handler: function () {
			           var rv = dialog.getReturnValue();
			           if(rv!=false){
			        	   if($("#formId").val()!=rv.formId && $("#formId").val()!=""){
			        		   var confirm = $.confirm({
			        			    'msg': "${ctp:i18n('voucher.formmapper.formselect.confirm')}",
									ok_fn: function () {
										var id = $("#id").val();
					   	            	$("#addForm").clearform({clearHidden:true});
					   	            	$("select").val("1");
					   	            	$("select").trigger("change");
					   	            	$("#id").val(id);
					   	            	$("#formId").val(rv.formId);
						        	    $("#formName").val(rv.formName);
						        	    $("#formOwner").val(rv.formOwner);
						        	    $("#formUnit").val(rv.formUnit);
						        	    dialog.close();
									},         
									cancel_fn:function(){}     
							    });
			        	   }else{
			        		   $("#formId").val(rv.formId);
				        	    $("#formName").val(rv.formName);
				        	    $("#formOwner").val(rv.formOwner);
				        	    $("#formUnit").val(rv.formUnit);
				        	    dialog.close();
			        	   }
			           }
			        }
			    }, {
			        text: "${ctp:i18n('common.button.cancel.label')}", //取消
			        handler: function () {
			            dialog.close();
			        }
			    }]
    	});
	});
	$(":text").bind("click",textfn);
	$(":text").bind("mouseover",mousefn);
	
	
	$(".bindData").bind("click",bindfn);
	$(".recordName").bind("click",recordfn);
	$(".assist").bind("click",assistfn);
	$("select").bind("change",selectChange);
	$("#addImg").click(function(){
		var trId = $("#assist_id").val();
		var html = $("#"+trId).html();
		var tableId = $("#"+trId).parent().parent().attr("id");
		var last = $("#"+tableId+" tr:last").attr("id");
		var arr = last.split("_");
		arr[2] = parseInt(arr[2])+1;
		var assistId = ($("#"+last).find("input").attr("id"));
		var assistArr = assistId.split("_");
		var type = assistArr[0];
		var newNum = parseInt(assistArr[3])+1;
		html = "<td width='20.5%'><select class='w100b' id='"+type+"_7_bindType_"+newNum+"' name='${ctp:i18n('voucher.formmapper.bindType')}'>    <option selected='selected' value='1'>${ctp:i18n('voucher.formmapper.bindType.fixed')}</option><option value='2'>${ctp:i18n('voucher.formmapper.bindType.bindData')}</option></select></td>"+
			"<td width='20.5%'><div class='common_txtbox_wrap'><input type='hidden' id='"+type+"_7_tableName_"+newNum+"' name='"+type+"_tableName' value=''><input class='validate word_break_all  bindData' id='"+type+"_7_bindData_"+newNum+"' name='${ctp:i18n('voucher.formmapper.bindData')}' type='text' readonly='readonly' value='' disabled='disabled' validate='minLength:1,maxLength:255'></div></td>"+
			"<td width='23%'><div class='common_txtbox_wrap'><input id='"+type+"_7_recordId_"+newNum+"' name='"+type+"_7_recordId_"+newNum+"' type='hidden' value='-1'><input class='validate word_break_all recordName' id='"+type+"_7_recordName_"+newNum+"' name='${ctp:i18n('voucher.formmapper.record')}' type='text' readonly='readonly' value='' disabled='disabled' validate='minLength:1,maxLength:255'></div></td>"+
			"<td width='20.5%'><div class='common_txtbox_wrap'><input class='validate word_break_all' id='"+type+"_7_defaultValue_"+newNum+"' name='${ctp:i18n('voucher.formmapper.defaultValue')}' type='text' value='' validate='minLength:1,maxLength:255'></div></td>"+
			"<td width='15.5%'><div class='common_txtbox_wrap'><input class='validate word_break_all' id='"+type+"_7_remark_"+newNum+"' name='${ctp:i18n('voucher.formmapper.remark')}' type='text' value='' validate='minLength:1,maxLength:255'></div></td>";
	 
		$("#"+tableId).append("<tr class='assist' id='"+arr.join("_")+"'>"+html+"</tr>");
		$(":text").unbind("click",textfn).bind("click",textfn);
		$(":text").unbind("mouseover",mousefn).bind("mouseover",mousefn);
		$(".bindData").unbind("click",bindfn).bind("click",bindfn);
		$(".recordName").unbind("click",recordfn).bind("click",recordfn);
		$(".assist").unbind("click",assistfn).bind("click",assistfn);
		$("select").unbind("change",selectChange).bind("change",selectChange);
		$("#assist_id").val($("#"+trId).next("tr").attr("id"));
	});
	$("#delImg").click(function(){
		var trId = $("#assist_id").val();
		var prevTr = $("#"+trId).prev("tr");
		if(prevTr==null||prevTr.attr("id")==undefined){
			prevTr = $("#"+trId).next("tr");
			if(prevTr==null||prevTr.attr("id")==undefined){
				return;
			}else{
				var img = $("#img");
				var offset = img.offset();
				offset.top = offset.top+$("#"+trId).height()+2;
				img.offset(offset);
			}
		}
		$("#assist_id").val(prevTr.attr("id"));
		$("#"+trId).remove();
	});
	initInputStyle();
});

function initInputStyle(){
	var bindTypes = $("select[name='${ctp:i18n('voucher.formmapper.bindType')}']");
	var bindDatas = $("input[name='${ctp:i18n('voucher.formmapper.bindData')}']");
	var records = $("input[name='${ctp:i18n('voucher.formmapper.record')}']");
	for(var i=0; i<bindTypes.length; i++){
		var obj = $(bindTypes[i]);
		if(obj.val()==="1"){
			$(bindDatas[i]).val("");
			$(bindDatas[i]).prev("input").val("");
			$(bindDatas[i]).attr("disabled","disabled");
			$(records[i]).val("");
			$(records[i]).prev("input").val("");
			$(records[i]).attr("disabled","disabled");
		}
	}
}
 function OK() {
	 if(!($("#addForm").validate())){		
         return false;
       }
	 /*借方分录绑定表单字段所属表名*/
	 var debitTableArray = $("input[name='debit_tableName']");
	 if(!checkTalbeName(debitTableArray)){
		 $.alert("${ctp:i18n('voucher.formmapper.debit.error')}");
		 return false;
	 }
	 /*贷方分录绑定表单字段所属表名*/
	 var creditTableArray = $("input[name='credit_tableName']");
	 if(!checkTalbeName(creditTableArray)){
		 $.alert("${ctp:i18n('voucher.formmapper.credit.error')}");
		 return false;
	 }
	 /*冲销分录绑定表单字段所属表名*/
	 var reversalTableArray = $("input[name='reversal_tableName']");
	 if(!checkTalbeName(reversalTableArray)){
		 $.alert("${ctp:i18n('voucher.formmapper.reversal.error')}");
		 return false;
	 }
	 
	 if(!checkData()){
		 return  false;
	 }
	 return $("#addForm").formobj();
}
 /*
  *校验填写的数据是否合格,false:给出提示，不允许保存
  */
 function checkData(){
		var bindTypes = $("select[name='${ctp:i18n('voucher.formmapper.bindType')}']");
		var bindDatas = $("input[name='${ctp:i18n('voucher.formmapper.bindData')}']");
		//var records = $("input[name='${ctp:i18n('voucher.formmapper.record')}']");
		var dafaults = $("input[name='${ctp:i18n('voucher.formmapper.defaultValue')}']");
		for(var i=0; i<bindTypes.length; i++){
			var obj = $(bindTypes[i]);
			if(obj.val()!="1"){
				if($.trim($(bindDatas[i]).val())==="" && $.trim($(dafaults[i]).val())===""){
					$.alert("${ctp:i18n('voucher.formmapper.binddata.error')}");
					return false;
				}
			}
		}
		return true;
	}
 /*
  *检验数组中除了空字符外，其它元素是否相同,true:互同，false:有不同
  */
 function checkTalbeName(array){
	 var table = "";
	 for(var i=0; i<array.length; i++){
		 if($(array[i]).val()!="" && $(array[i]).val().indexOf("formmain_")==-1){
			 if(table===""){
				 table = $(array[i]).val();
			 }else if($(array[i]).val()!=table){
				 return false;
			 }
		 }
	 }
	 return true;
 }
 var textfn = function (){
		if("formName"!=$(this).attr("id")){
			if($("#formId").val()==""){
				$.alert("${ctp:i18n('voucher.formmapper.formselect')}");
			}
		}
	}
 var mousefn = function(){
		var o = $(this);
		o.attr("title",o.val());
	}
 var selectChange = function (){
	 var td = $(this).parent("td")[0];
	 var input1 = $(td).next("td").find("input");
	 var input2 = input1.next("input");
	 var input3 = $(td).next("td").next("td").find("input");
	 var input4 = input3.next("input");
	 if($(this).val()==="1"){
		 input1.val("");
		 input1.attr("disabled",true);
		 input2.val("");
		 input2.attr("disabled",true);
		 input3.val("");
		 input3.attr("disabled",true);
		 input4.val("");
		 input4.attr("disabled",true);
	 }else{
		 input1.attr("disabled",false);
		 input2.attr("disabled",false);
		 input3.attr("disabled",false);
		 input4.attr("disabled",false);
	 }
 }
 
 var bindfn = function(){
	 	var o = $(this);
	 	var id = o.attr("id");
	 	var isHead = false;
	 	if(id.split("_")[0]=="head"){
	 		isHead = true;
	 	}else{
	 		isHead = false;
	 	}
		if($("#formId").val()!=""){
			var dialog = getA8Top().$.dialog({
	    		url:"${path}/voucher/documnentationMapperController.do?method=showFormFieldList&formId="+$("#formId").val()+"&isHead="+isHead,
				    width: 800,
				    height: 500,
				    title: "${ctp:i18n('voucher.formmapper.choose.formfield')}",
				    buttons: [{
				        text: "${ctp:i18n('common.button.ok.label')}", //确定
				        handler: function () {
				           var rv = dialog.getReturnValue();
				           if(rv!=false){
				        	   o.prev("input").val(rv.tableName);
				        	   o.val(rv.fieldDisplay);
							   dialog.close();
				           }
				    	}
				    }, {
				        text: "${ctp:i18n('common.button.cancel.label')}", //取消
				        handler: function () {
				            dialog.close();
				        }
				    }]
	    	});
		}
	}
 var recordfn = function(){
	 var o = $(this);
	 if($("#formId").val()!=""){
			var dialog = getA8Top().$.dialog({
	    		url:"${path}/voucher/documnentationMapperController.do?method=showArchivesMappers",
				    width: 800,
				    height: 500,
				    title: "${ctp:i18n('voucher.formmapper.choose.formfield')}",
				    buttons: [{
				        text: "${ctp:i18n('common.button.ok.label')}", //确定
				        handler: function () {
				           var rv = dialog.getReturnValue();
				           if(rv!=false){
				        	   o.prev("input").val(rv.id);
				        	   o.val(rv.name);
							   dialog.close();
				           }
				    	}
				    }, {
				        text: "${ctp:i18n('common.button.cancel.label')}", //取消
				        handler: function () {
				            dialog.close();
				        }
				    }]
	    	});
		}
	}
 var assistfn = function(){
		addOrDelTr(this);
	}
 
function addOrDelTr(target){
			//$("#img").removeClass("hidden").css("visibility","visible");
			var imgDiv = $("#img");
		    if(imgDiv.length<=0){
		        return;
		    }
		    imgDiv.removeClass("hidden").css("visibility","visible");
		    //imgDiv.data("currentRow",getRowData(target));
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

/**
 *获取位置,返回位置对象，如：{left:23,top:32}
 */
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
        if(navigator.appName.toLowerCase()=="netscape"){//google
        	scrollTop = Math.max(scrollTop, document.body.scrollTop);
        	scrollLeft = Math.max(scrollLeft, document.body.scrollLeft);
        }
        return { left : box.left + scrollLeft, top : box.top + scrollTop };
    } else if (document.getBoxObjectFor) {// gecko
        box = document.getBoxObjectFor(el);
        var borderLeft = (el.style.borderLeftWidth) ? parseInt(el.style.borderLeftWidth) : 0;
        var borderTop = (el.style.borderTopWidth) ? parseInt(el.style.borderTopWidth) : 0;
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
        if (ua.indexOf('opera') != -1 || (ua.indexOf('safari') != -1 && el.style.position == 'absolute')) {
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
<style>
	td{
		text-align: left;
		padding: 6pt;
	}
</style>
</head>
<body>
	<form name="addForm" id="addForm" method="post" target="addFormDataMapper">
	<div class="form_area">
		<div class="one_row" style="width:70%;">
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="id" id="id" value="${mapper.id}" />
					<input type="hidden" name="formId" id="formId" value="${mapper.formId }" />
					<input type="hidden" name="assist_id" id="assist_id" value="" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.formName')}: </label></th>
						<td width="40%">
							<div class="common_txtbox_wrap">
								<input type="text" id="formName" class="validate word_break_all" readonly="readonly" value="${mapperVO.formName}"  name="${ctp:i18n('voucher.plugin.cfg.formName')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.formOwner')}: </label></th>
						<td width="25%">
							<div class="common_txtbox_wrap">
								<input type="text" id="formOwner" disabled="disabled" class="validate word_break_all" value="${mapperVO.formOwner}" name="formOwner"
									validate="minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.formUnit')}: </label></th>
						<td width="35%">
							<div class="common_txtbox_wrap">
								<input type="text" id="formUnit" disabled="disabled" class="validate word_break_all" value="${mapperVO.formUnit}" name="formUnit"
									validate="minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						
					</tr>
				</tbody>
			</table>
			<br>
				<fieldset id="form_head" style=" width: 100%;border: 1;">
					<legend>
						&nbsp;&nbsp;<font size="2"><b>${ctp:i18n('voucher.formmapper.headmapping')}</b></font>&nbsp;&nbsp;
					</legend>
					<div  style="width: 100%;border: 0px;" align="left">
				        <br>
				        <table id="mytable" class="flexme3" border="0" cellspacing="1" cellpadding="0" width="100%">
				        	<tr bgcolor="#B5DBEB">
				        		<td width="6%">${ctp:i18n('voucher.formmapper.number')}</td>
				        		<td width="15">${ctp:i18n('voucher.formmapper.voucher_head_item')}</td>
				        		<td width="18">${ctp:i18n('voucher.formmapper.bindType')}</td>
				        		<td width="20">${ctp:i18n('voucher.formmapper.bindData')}</td>
				        		<td width="23">${ctp:i18n('voucher.formmapper.record')}</td>
				        		<td width="18">${ctp:i18n('voucher.formmapper.defaultValue')}</td>
				        	</tr>
				        	<c:forEach	items="${mapper.headList}" var="headField">
				        		<tr>
				        		<td width="6%"><span>${headField.num}</span></td><td width="15">${ctp:i18n(headField.name)}</td>
				        		<td width="18%">
                                        <select id="head_${headField.num }_bindType" name="${ctp:i18n('voucher.formmapper.bindType')}" class="w100b">
                                        	<c:if test="${headField.bindType==1}">
                                        		<option value="1" selected="selected">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
                                            	<option value="2">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
                                        	</c:if>
                                        	<c:if test="${headField.bindType!=1}">
                                        		<option value="1">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
                                            	<option value="2" selected="selected">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
                                        	</c:if>
                                        </select>
                                   </td>
                                   <td width="20%"><div class="common_txtbox_wrap">
								<input type="text" id="head_${headField.num }_bindData" class="validate word_break_all bindData" readonly="readonly" value="${headField.bindData }" name="${ctp:i18n('voucher.formmapper.bindData')}"
									validate="minLength:1,maxLength:255">
								</div></td>
								<td width="23%"><div class="common_txtbox_wrap">
								<input type="hidden" id="head_${headField.num}_recordId" name="head_${headField.num}_recordId" value="${headField.recordId }">
								<input type="text" id="head_${headField.num}_recordName" class="validate word_break_all  recordName" readonly="readonly" value="${ctp:i18n(headField.recordName) }" name="${ctp:i18n('voucher.formmapper.record')}"
									validate="minLength:1,maxLength:255">
								</div></td>
								<td width="18%"><div class="common_txtbox_wrap" >
								<input type="text" id="head_${headField.num }_defaultValue" class="validate word_break_all" value="${ctp:toHTML(headField.defaultValue) }" name="${ctp:i18n('voucher.formmapper.defaultValue')}"
									validate="minLength:1,maxLength:255">
								</div></td>
				        	</tr>
				        	</c:forEach>
				        </table>
				    </div>
				</fieldset>
				<br>
				<br>
				<fieldset id="form_debit" style=" width: 100%;height: 300;border: 1;">
					<legend>
						&nbsp;&nbsp;<font size="2"><b>${ctp:i18n('voucher.formmapper.debitmapping')}</b></font>&nbsp;&nbsp;
					</legend>
					<div style="width: 100%;border: 0px;" align="center">
				        <br>
				        <table class="flexme3" border="0" cellspacing="1" cellpadding="0" width="100%">
				        	<tr bgcolor="#B5DBEB">
				        		<td width="6%">${ctp:i18n('voucher.formmapper.number')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.voucher_debit_item')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.bindType')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.bindData')}</td>
				        		<td width="18%">${ctp:i18n('voucher.formmapper.record')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.defaultValue')}</td>
				        		<td width="12%">${ctp:i18n('voucher.formmapper.remark')}</td>
				        	</tr>
				        	<c:forEach	items="${mapper.debitList}" var="debitField">
				        		<tr>
				        		<td width="6%">${debitField.num}</td><td width="16%">${ctp:i18n(debitField.name)}
				        		</td>
				        		<c:if test="${debitField.num!=7 }">
					        			<td width="16%">
	                                        <select id="debit_${debitField.num}_bindType" name="${ctp:i18n('voucher.formmapper.bindType')}" class="w100b">
	                                            <c:if test="${debitField.bindType==1 }">
	                                        		<option value="1" selected="selected">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
	                                            	<option value="2">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
	                                        	</c:if>
	                                        	<c:if test="${debitField.bindType!=1 }">
	                                        		<option value="1">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
	                                            	<option value="2" selected="selected">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
	                                        	</c:if>
	                                        </select>
	                                        
	                                   </td>
	                                   <td width="16%"><div class="common_txtbox_wrap">
	                                   <input type="hidden" id="debit_${debitField.num}_tableName" name="debit_tableName" value="${debitField.tableName}">
									<input type="text" id="debit_${debitField.num}_bindData" class="validate word_break_all bindData" readonly="readonly" value="${debitField.bindData }" name="${ctp:i18n('voucher.formmapper.bindData')}"
										validate="minLength:1,maxLength:255">
									</div></td>
									<td width="18%"><div class="common_txtbox_wrap">
									<input type="hidden" id="debit_${debitField.num}_recordId" name="debit_${debitField.num}_recordId" value="${debitField.recordId }">
									<input type="text" id="debit_${debitField.num}_recordName" class="validate word_break_all  recordName" readonly="readonly" value="${ctp:i18n(debitField.recordName) }" name="${ctp:i18n('voucher.formmapper.record')}"
										validate="minLength:1,maxLength:255">
									</div></td>
									<td width="16%"><div class="common_txtbox_wrap">
									<input type="text" id="debit_${debitField.num}_defaultValue" class="validate word_break_all" value="${ctp:toHTML(debitField.defaultValue) }" name="${ctp:i18n('voucher.formmapper.defaultValue')}"
										validate="minLength:1,maxLength:255">
									</div></td>
									<td width="12%"><div class="common_txtbox_wrap">
									<input type="text" id="debit_${debitField.num}_remark" class="validate word_break_all" value="${ctp:toHTML(debitField.remark) }" name="${ctp:i18n('voucher.formmapper.remark')}"
										validate="minLength:1,maxLength:255">
									</div></td>
				        		</c:if>
				        		<c:if test="${debitField.num==7}">
				        			<td colspan="5" style="padding: 0px;">
				        			<div style="width: 100%;border: 1px; margin: 0px; padding: 0px;" align="center">
				        				<table width="100%" id="debit_assist">
				        					<c:forEach items="${mapper.debitAssist}" var="assist">
				        						<tr class="assist" id="debit_assist_${assist.num}">
				        							<td width="20.5%"><select id="debit_${debitField.num}_bindType_${assist.num}" name="${ctp:i18n('voucher.formmapper.bindType')}" class="w100b">
			                                            <c:if test="${assist.bindType==1 }">
			                                        		<option value="1" selected="selected">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
			                                            	<option value="2">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
			                                        	</c:if>
			                                        	<c:if test="${assist.bindType!=1 }">
			                                        		<option value="1">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
			                                            	<option value="2" selected="selected">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
			                                        	</c:if></select>
			                                        </td>
					        						<td width="20.5%"><div class="common_txtbox_wrap">
					        							<input type="hidden" id="debit_${debitField.num}_tableName_${assist.num}" name="debit_tableName" value="${debitField.tableName}">
														<input type="text" id="debit_${debitField.num}_bindData_${assist.num}" class="validate word_break_all  bindData" readonly="readonly" value="${assist.bindData }" name="${ctp:i18n('voucher.formmapper.bindData')}"
															validate="minLength:1,maxLength:255"></div>
													</td>
													<td width="23%"><div class="common_txtbox_wrap">
														<input type="hidden" id="debit_${debitField.num}_recordId_${assist.num}" name="debit_${debitField.num}_recordId_${assist.num}" value="${assist.recordId }">
														<input type="text" id="debit_${debitField.num}_recordName_${assist.num}" class="validate word_break_all recordName" readonly="readonly" value="${ctp:i18n(assist.recordName) }" name="${ctp:i18n('voucher.formmapper.record')}"
															validate="minLength:1,maxLength:255"></div>
													</td>
													<td width="20.5%"><div class="common_txtbox_wrap">
														<input type="text" id="debit_${debitField.num}_defaultValue_${assist.num}" class="validate word_break_all" value="${ctp:toHTML(assist.defaultValue) }" name="${ctp:i18n('voucher.formmapper.defaultValue')}"
															validate="minLength:1,maxLength:255"></div>
													</td>
													<td width="15.5%"><div class="common_txtbox_wrap">
														<input type="text" id="debit_${debitField.num}_remark_${assist.num}" class="validate word_break_all" value="${ctp:toHTML(assist.remark) }" name="${ctp:i18n('voucher.formmapper.remark')}"
															validate="minLength:1,maxLength:255"></div>
													</td>
				        					</tr>
				        					</c:forEach>
				        				</table>
				        				</div>
				        			</td>
				        		</c:if>
				        	</tr>
				        	</c:forEach>
				        </table>
				    </div>
				</fieldset>
				<br>
				<br>
				<fieldset id="form_credit" style=" width: 100%;height: 300;border: 1;">
					<legend>
						&nbsp;&nbsp;<font size="2"><b>${ctp:i18n('voucher.formmapper.creditmapping')}</b></font>&nbsp;&nbsp;
					</legend>
					<div style="width: 100%;border: 0px;" align="center">
				        <br>
				        <table class="flexme3" border="0" cellspacing="1" cellpadding="0" width="100%">
				        	<tr bgcolor="#B5DBEB">
				        		<td width="6%">${ctp:i18n('voucher.formmapper.number')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.voucher_credit_item')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.bindType')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.bindData')}</td>
				        		<td width="18%">${ctp:i18n('voucher.formmapper.record')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.defaultValue')}</td>
				        		<td width="12%">${ctp:i18n('voucher.formmapper.remark')}</td>
				        	</tr>
				        	<c:forEach	items="${mapper.creditList}" var="creditField">
				        		<tr>
				        		<td width="6%">${creditField.num}</td><td width="16%">${ctp:i18n(creditField.name)}</td>
				        		<c:if test="${creditField.num!=7}">
				        				<td width="16%">
	                                        <select id="credit_${creditField.num}_bindType" name="${ctp:i18n('voucher.formmapper.bindType')}" class="w100b">
	                                            <c:if test="${creditField.bindType==1 }">
	                                        		<option value="1" selected="selected">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
	                                            	<option value="2">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
	                                        	</c:if>
	                                        	<c:if test="${creditField.bindType!=1 }">
	                                        		<option value="1">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
	                                            	<option value="2" selected="selected">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
	                                        	</c:if>
	                                        </select>
                                   		</td>
                                   		<td width="16%"><div class="common_txtbox_wrap">
                                   		<input type="hidden" id="credit_${creditField.num}_tableName" name="credit_tableName" value="${creditField.tableName}">
										<input type="text" id="credit_${creditField.num}_bindData" class="validate word_break_all  bindData" readonly="readonly" value="${creditField.bindData }" name="${ctp:i18n('voucher.formmapper.bindData')}"
											validate="minLength:1,maxLength:255">
										</div></td>
										<td width="18%"><div class="common_txtbox_wrap">
										<input type="hidden" id="credit_${creditField.num}_recordId" name="credit_${creditField.num}_recordId" value="${creditField.recordId }">
										<input type="text" id="credit_${creditField.num}_recordName" class="validate word_break_all recordName" readonly="readonly" value="${ctp:i18n(creditField.recordName) }" name="${ctp:i18n('voucher.formmapper.record')}"
											validate="minLength:1,maxLength:255">
										</div></td>
										<td width="16%"><div class="common_txtbox_wrap">
										<input type="text" id="credit_${creditField.num}_defaultValue" class="validate word_break_all" value="${ctp:toHTML(creditField.defaultValue) }" name="${ctp:i18n('voucher.formmapper.defaultValue')}"
											validate="minLength:1,maxLength:255">
										</div></td>
										<td width="12%"><div class="common_txtbox_wrap">
										<input type="text" id="credit_${creditField.num}_remark" class="validate word_break_all" value="${ctp:toHTML(creditField.remark) }" name="${ctp:i18n('voucher.formmapper.remark')}"
											validate="minLength:1,maxLength:255">
										</div></td>
				        		</c:if>
				        		<c:if test="${creditField.num==7}">
				        			<td colspan="5" style="padding: 0px;">
				        			<div style="width: 100%;border: 1px; margin: 0px; padding: 0px;" align="center">
				        				<table width="100%" id="credit_assist">
				        					<c:forEach items="${mapper.creditAssist}" var="assist">
				        						<tr class="assist" id="credit_assist_${assist.num}">
				        						<td width="20.5%"><select id="credit_${creditField.num}_bindType_${assist.num}" name="${ctp:i18n('voucher.formmapper.bindType')}" class="w100b">
		                                            <c:if test="${assist.bindType==1 }">
		                                        		<option value="1" selected="selected">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
		                                            	<option value="2">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
		                                        	</c:if>
		                                        	<c:if test="${assist.bindType!=1 }">
		                                        		<option value="1">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
		                                            	<option value="2" selected="selected">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
		                                        	</c:if></select>
		                                        </td>
				        						<td width="20.5%"><div class="common_txtbox_wrap">
				        							<input type="hidden" id="credit_${creditField.num}_tableName_${assist.num}" name="credit_tableName" value="${creditField.tableName}">
													<input type="text" id="credit_${creditField.num}_bindData_${assist.num}" class="validate word_break_all  bindData" readonly="readonly" value="${assist.bindData }" name="${ctp:i18n('voucher.formmapper.bindData')}"
														validate="minLength:1,maxLength:255"></div>
												</td>
												<td width="23%"><div class="common_txtbox_wrap">
													<input type="hidden" id="credit_${creditField.num}_recordId_${assist.num}" name="credit_${creditField.num}_recordId_${assist.num}" value="${assist.recordId }">
													<input type="text" id="credit_${creditField.num}_recordName_${assist.num}" class="validate word_break_all recordName" readonly="readonly" value="${ctp:i18n(assist.recordName) }" name="${ctp:i18n('voucher.formmapper.record')}"
													validate="minLength:1,maxLength:255"></div>
												</td>
												<td width="20.5%"><div class="common_txtbox_wrap">
													<input type="text" id="credit_${creditField.num}_defaultValue_${assist.num}" class="validate word_break_all" value="${ctp:toHTML(assist.defaultValue) }" name="${ctp:i18n('voucher.formmapper.defaultValue')}"
														validate="minLength:1,maxLength:255"></div>
												</td>
												<td width="15.5%"><div class="common_txtbox_wrap">
													<input type="text" id="credit_${creditField.num}_remark_${assist.num}" class="validate word_break_all" value="${ctp:toHTML(assist.remark) }" name="${ctp:i18n('voucher.formmapper.remark')}"
														validate="minLength:1,maxLength:255"></div>
												</td>
				        					</tr>
				        					</c:forEach>
				        				</table>
				        				</div>
				        			</td>
				        		</c:if>
				        	</tr>
				        	</c:forEach>
				        </table>
				    </div>
				</fieldset>	
				
				<!-- 冲销分录 -->
				<br>
				<br>
				<fieldset id="form_reversal" style=" width: 100%;height: 300;border: 1;">
					<legend>
						&nbsp;&nbsp;<font size="2"><b>${ctp:i18n('voucher.formmapper.reversalmapping')}</b></font>&nbsp;&nbsp;
					</legend>
					<div style="width: 100%;border: 0px;" align="center">
				        <br>
				        <table class="flexme3" border="0" cellspacing="1" cellpadding="0" width="100%">
				        	<tr bgcolor="#B5DBEB">
				        		<td width="6%">${ctp:i18n('voucher.formmapper.number')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.reversal.items') }</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.bindType')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.bindData')}</td>
				        		<td width="18%">${ctp:i18n('voucher.formmapper.record')}</td>
				        		<td width="16%">${ctp:i18n('voucher.formmapper.defaultValue')}</td>
				        		<td width="12%">${ctp:i18n('voucher.formmapper.remark')}</td>
				        	</tr>
				        	<c:forEach	items="${mapper.reversalList}" var="reversalField">
				        		<tr>
				        		<td width="6%">${reversalField.num}</td><td width="16%">${ctp:i18n(reversalField.name)}</td>
				        		<c:if test="${reversalField.num!=7}">
				        				<td width="16%">
	                                        <select id="reversal_${reversalField.num}_bindType" name="${ctp:i18n('voucher.formmapper.bindType')}" class="w100b">
	                                            <c:if test="${reversalField.bindType==1 }">
	                                        		<option value="1" selected="selected">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
	                                            	<option value="2">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
	                                        	</c:if>
	                                        	<c:if test="${reversalField.bindType!=1 }">
	                                        		<option value="1">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
	                                            	<option value="2" selected="selected">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
	                                        	</c:if>
	                                        </select>
                                   		</td>
                                   		<td width="16%"><div class="common_txtbox_wrap">
                                   		<input type="hidden" id="reversal_${reversalField.num}_tableName" name="reversal_tableName" value="${reversalField.tableName}">
										<input type="text" id="reversal_${reversalField.num}_bindData" class="validate word_break_all  bindData" readonly="readonly" value="${reversalField.bindData }" name="${ctp:i18n('voucher.formmapper.bindData')}"
											validate="minLength:1,maxLength:255">
										</div></td>
										<td width="18%"><div class="common_txtbox_wrap">
										<input type="hidden" id="reversal_${reversalField.num}_recordId" name="reversal_${reversalField.num}_recordId" value="${reversalField.recordId }">
										<input type="text" id="reversal_${reversalField.num}_recordName" class="validate word_break_all recordName" readonly="readonly" value="${ctp:i18n(reversalField.recordName) }" name="${ctp:i18n('voucher.formmapper.record')}"
											validate="minLength:1,maxLength:255">
										</div></td>
										<td width="16%"><div class="common_txtbox_wrap">
										<input type="text" id="reversal_${reversalField.num}_defaultValue" class="validate word_break_all" value="${ctp:toHTML(reversalField.defaultValue) }" name="${ctp:i18n('voucher.formmapper.defaultValue')}"
											validate="minLength:1,maxLength:255">
										</div></td>
										<td width="12%"><div class="common_txtbox_wrap">
										<input type="text" id="reversal_${reversalField.num}_remark" class="validate word_break_all" value="${ctp:toHTML(reversalField.remark) }" name="${ctp:i18n('voucher.formmapper.remark')}"
											validate="minLength:1,maxLength:255">
										</div></td>
				        		</c:if>
				        		<c:if test="${reversalField.num==7}">
				        			<td colspan="5" style="padding: 0px;">
				        			<div style="width: 100%;border: 1px; margin: 0px; padding: 0px;" align="center">
				        				<table width="100%" id="reversal_assist">
				        					<c:forEach items="${mapper.reversalAssist}" var="assist">
				        						<tr class="assist" id="reversal_assist_${assist.num}">
				        						<td width="20.5%"><select id="reversal_${reversalField.num}_bindType_${assist.num}" name="${ctp:i18n('voucher.formmapper.bindType')}" class="w100b">
		                                            <c:if test="${assist.bindType==1 }">
		                                        		<option value="1" selected="selected">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
		                                            	<option value="2">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
		                                        	</c:if>
		                                        	<c:if test="${assist.bindType!=1 }">
		                                        		<option value="1">${ctp:i18n('voucher.formmapper.bindType.fixed')}</option>
		                                            	<option value="2" selected="selected">${ctp:i18n('voucher.formmapper.bindType.bindData') }</option>
		                                        	</c:if></select>
		                                        </td>
				        						<td width="20.5%"><div class="common_txtbox_wrap">
				        							<input type="hidden" id="reversal_${reversalField.num}_tableName_${assist.num}" name="reversal_tableName" value="${reversalField.tableName}">
													<input type="text" id="reversal_${reversalField.num}_bindData_${assist.num}" class="validate word_break_all  bindData" readonly="readonly" value="${assist.bindData }" name="${ctp:i18n('voucher.formmapper.bindData')}"
														validate="minLength:1,maxLength:255"></div>
												</td>
												<td width="23%"><div class="common_txtbox_wrap">
													<input type="hidden" id="reversal_${reversalField.num}_recordId_${assist.num}" name="reversal_${reversalField.num}_recordId_${assist.num}" value="${assist.recordId }">
													<input type="text" id="reversal_${reversalField.num}_recordName_${assist.num}" class="validate word_break_all recordName" readonly="readonly" value="${ctp:i18n(assist.recordName) }" name="${ctp:i18n('voucher.formmapper.record')}"
													validate="minLength:1,maxLength:255"></div>
												</td>
												<td width="20.5%"><div class="common_txtbox_wrap">
													<input type="text" id="reversal_${reversalField.num}_defaultValue_${assist.num}" class="validate word_break_all" value="${ctp:toHTML(assist.defaultValue) }" name="${ctp:i18n('voucher.formmapper.defaultValue')}"
														validate="minLength:1,maxLength:255"></div>
												</td>
												<td width="15.5%"><div class="common_txtbox_wrap">
													<input type="text" id="reversal_${reversalField.num}_remark_${assist.num}" class="validate word_break_all" value="${ctp:toHTML(assist.remark) }" name="${ctp:i18n('voucher.formmapper.remark')}"
														validate="minLength:1,maxLength:255"></div>
												</td>
				        					</tr>
				        					</c:forEach>
				        				</table>
				        				</div>
				        			</td>
				        		</c:if>
				        	</tr>
				        	</c:forEach>
				        </table>
				    </div>
				</fieldset>
				<br>
		</div>
	</div>
			<div class="hidden"   id="img" style="width: 16px; height: 30px;  position: relative;float: right; border: 1px; " name="img">
				<div id="addDiv" style="height: auto;">
					<span title="增加空行" class="ico16 repeater_plus_16" id="addImg" style="display: block;"></span></div><div id="addEmptyDiv" style="height: auto;">
					<!-- <span title="增加空行" class="ico16 blank_plus_16" id="addEmptyImg" style="display: block;"></span></div><div id="delDiv" style="height: auto;"> -->
					<span title="删除此行" class="ico16 repeater_reduce_16" id="delImg" style="display: block;"></span>
				</div>
			</div>
	</form>
</body>
</html>