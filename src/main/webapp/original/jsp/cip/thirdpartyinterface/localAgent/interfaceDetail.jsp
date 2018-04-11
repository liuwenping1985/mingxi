<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<style type="text/css"></style>
</head>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=interfaceRegisterManager"></script>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=extendedResourceManager"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var irm = new interfaceRegisterManager();
	    var data = irm.rMInterfaceById(${id}.key);
	    $("#masterId").val(data.iD);
	    $("#product_flag").val(data.product_flag);
	    $("#typeName").val(data.vALUE0);
	    $("#Category_id").val(data.category_id);
	    $("#Interface_name").val(data.interface_name);
	    $("#Interface_des").val(data.interface_des);
	    $("#System_constraint").val(data.system_constraint);
	    $("#business_constraint").val(data.business_constraint);
	    $("#Call_des").val(data.call_des);
	    var erm = new extendedResourceManager();
		var codes = erm.findResourceCodesByIds(data.resourcePackage);
	    $("#resourcePackage").val(codes);
	    $("#resourcePackageIds").val(data.resourcePackage);
	    var trId = $("#appTable tr:last").attr("id");
	    for(var i = 1; i <= trId; i++){
	    	if(i == 1){
	    		$("#sceneNo" + i).val("");
	    		$("#sceneDe" + i).val("");
	    		$("#tab" + i).html("");
				$("#fileName" + i).val("");
				$("#fileId" + i).val("");
	    	}else{
	        	$("#" + i).remove();
	    	}
	    }
	    if(data.scene_des != null){
	    	for(var i = 1; i <= data.scene_des.length; i++){
		    	var newNum = i; 
		    	var scene = data.scene_des[i - 1];
		    	if(i == 1){
		    		$("#sceneNo" + i).val(scene.no);
		    		$("#sceneDe" + i).val(scene.des);
		    		$("#tab" + i).attr("title",scene.name);
		    		if(scene.name.length > 7){
						$("#tab" + i).html(""+scene.name.substring(0,7) + "...");
					}else{
						$("#tab" + i).html(""+scene.name);
					}
					$("#fileName" + i).val(scene.name);
					$("#fileId" + i).val(scene.id);
		    	}else{
		        	html = getHtml(newNum, scene);
		        	$("#appTable").append("<tr class='autorow' id='"+newNum+"'>"+html+"</tr>");
		    	}
		    }
			for(var i = 1; i <= data.scene_des.length; i++){
				$("#d"+i+" a").attr("disabled","disabled");
			}
	    }
		$("#addForm").disable();
	});
	function getHtml(newNum, scene){
		var name = "";
		if(scene.name.length > 7){
			name = scene.name.substring(0,7) + "...";
		}else{
			name = scene.name;
		}
		html = "<td><div class=\"common_txtbox_wrap\"><input type=\"text\" id=\"sceneNo"+newNum 
			+"\" class=\"validate word_break_all\" validate=\"type:'string',maxLength:50,"+
			"name:'${ctp:i18n('cip.base.interface.detail.no')}',notNull:false,regExp:'^[0-9]+$',"+
			"maxLength:10\" value=\""+scene.no+"\" disabled=\"disabled\"></div></td><td><div class=\"common_txtbox_wrap"+
			" \"><input type=\"text\" id=\"sceneDe"+newNum +"\" class=\"validate word_break_all\" "+
			"validate=\"type:'string',name:'${ctp:i18n('cip.base.interface.detail.scedes')}',"+
			"maxLength:85\" value=\""+scene.des+"\" disabled=\"disabled\"></div></td><td><div class=\"common_txtbox_wrap\">"+
			"<span id =\"tab"+newNum+"\" title=\""+scene.name+"\">"+name+"</span><div style=\"float:right;\" id =\"d"+newNum+"\">"+
			"<div class=\"comp\" comp=\"type:'fileupload',applicationCategory:'39',quantity:1,"+
			"maxSize:2097152,firstSave:true,canDeleteOriginalAtts:false,originalAttsNeedClone:"+
			"false,callMethod:'fillUpCallBk'\"></div><a href=\"javascript:void(0)\" onclick=\""+
			"downFile()\" class=\"common_button common_button_gray margin_r_3"+
			"\">${ctp:i18n('cip.base.interface.register.upfile')}</a><a href=\"javascript:void(0)"+
			"\" onclick=\"downFile()\" class=\"common_button common_button_gray\">"+
			"${ctp:i18n('cip.base.interface.register.downfile')}</a><input type=\"hidden\" "+
			"id=\"fileName"+newNum+"\" value=\""+scene.name+"\" disabled=\"disabled\"><input type=\"hidden\" "+
			"id=\"fileId"+newNum+"\" value=\""+scene.id+"\" disabled=\"disabled\"></div></div></td>";
		return html;
	}
	function downFile(){
		
	}
	function OK() {
		return "";
	}
</script>
<body>
	<form name="addForm" id="addForm" method="post" target=""
		class="validate">
		<div class="form_area" id="interForm">
			<div class="one_row" style="width: 70%;">
				<input type="hidden" id="count_id" name="count_id"> <input
					type="hidden" id="current_id" name="current_id"> <input
					type="hidden" id="id" name="id" value="-1"> <input
					type="hidden" id="productItemList" name="productItemList">
				<input type="hidden" id="sonNeed"> <input type="hidden"
					id="objectId"> <input type="hidden" id="Category_id" /> <input
					type="hidden" id="masterId" /> <input type="hidden" id="productId" />
				<input type="hidden" id="resourcePackageIds" />
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.detail.product')}:</label></th>
						<td width="100%"><input type="text" id="product_flag"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.base.form.product.code')}'"
							disabled="disabled"></input></td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.detail.type')}:</label></th>
						<td width="100%"><input type="text" id="typeName"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.type')}'"
							disabled="disabled" /></td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.detail.name')}:</label></th>
						<td width="100%"><input type="text" id="Interface_name" disabled="disabled"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.name')}',notNull:true,maxLength:50,regExp:'^[0-9a-zA-Z_]+$'" />
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.detail.des')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<input type="text" id="Interface_des" class="w100b validate" disabled="disabled"
									validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.des')}',notNull:true,maxLength:80" />
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.base.interface.detail.syscon')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<textarea id="System_constraint" cols='2' class="validate" disabled="disabled"
									style="width: 100%; height: 80px;"
									validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.syscon')}',maxLength:80"></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.base.interface.detail.sencon')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<textarea id="business_constraint" cols='2' class="validate" disabled="disabled"
									style="width: 100%; height: 80px;"
									validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.sencon')}',maxLength:80"></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.detail.usedes')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<textarea id="Call_des" cols='2' class="validate" disabled="disabled"
									style="width: 100%; height: 80px;"
									validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.usedes')}',notNull:true,maxLength:300"></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap" id="appText"><label class="margin_r_10">${ctp:i18n('cip.base.interface.detail.scenedes')}:</label></th>
						<td width="100%">
							<table id="appTable" class="only_table" border="0" width="100%">
								<thead>
									<tr>
										<th width="20%">${ctp:i18n('cip.base.interface.detail.no')}</th>
										<th width="30%">${ctp:i18n('cip.base.interface.detail.scedes')}</th>
										<th width="50%">${ctp:i18n('cip.base.interface.detail.sceexe')}</th>
									</tr>
								</thead>
								<tbody id="mobody">
									<tr class="autorow" id="1">
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="sceneNo1" disabled="disabled"
													class="validate word_break_all"
													validate="type:'string',maxLength:50,name:'${ctp:i18n('cip.base.interface.detail.no')}',notNull:false,regExp:'^[0-9]+$',maxLength:10">
											</div>
										</td>
										<td>
											<div class="common_txtbox_wrap ">
												<input type="text" id="sceneDe1" disabled="disabled"
													class="validate word_break_all"
													validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.scedes')}',maxLength:85">
											</div>
										</td>
										<td>
											<div class="common_txtbox_wrap">
												<span id="tab1"></span>
												<div style="float: right;" id="d1">
													<div class="comp"
														comp="type:'fileupload',applicationCategory:'39',quantity:1,maxSize:2097152,firstSave:true,canDeleteOriginalAtts:false,originalAttsNeedClone:false,callMethod:'fillUpCallBk'"></div>
													<a href="javascript:void(0)"
														onclick="downFile()"
														class="common_button common_button_gray">${ctp:i18n('cip.base.interface.register.upfile')}</a>
													<a href="javascript:void(0)" onclick="downFile();"
														class="common_button common_button_gray">${ctp:i18n('cip.base.interface.register.downfile')}</a>
													<input type="hidden" id="fileName1"> <input
														type="hidden" id="fileId1">
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.base.interface.detail.friend')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<input onclick="showResource();" type="text"
									id="resourcePackage" class="w100b validate" disabled="disabled"
									validate="name:'${ctp:i18n('cip.base.interface.detail.friend')}',notNull:false,maxLength:400">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</body>
</html>