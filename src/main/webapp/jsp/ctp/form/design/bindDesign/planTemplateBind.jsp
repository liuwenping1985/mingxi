<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formBindDesignManager"></script>
    </head>
    <body>
    	<div id='layout'>
	        <div class="layout_north over_auto" id="north">
	        	<!--向导菜单-->
				<div class="step_menu clearfix border_b">
					<%@ include file="../top.jsp" %>
				</div>
				<!--向导菜单-->
	        </div>
	        <div class="layout_center bg_color_white" id="center">
				 <div class="form_area padding_5" id="form">
	                <table border="0" cellspacing="0" cellpadding="0">
	                  <tr>
	                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('form.base.formname.label')}:</label></th>
	                    <td width="400"><DIV class=common_txtbox_wrap><input readonly="readonly" type="text" id="formTitle" class="w100b" value="${formBean.formName }"/></DIV></td>
	                  </tr>
	                </table>
	             </div>
	             
	             <!--左右布局-->
				 <div class="layout clearfix code_list padding_5">
				  <form action="${path }/form/bindDesign.do?method=saveFlowTemplate" id="saveForm">
	            	<div class="col2" id="bindSet" style="float: left">
	                	<div class="common_txtbox clearfix margin_b_5">
							<label class="margin_r_10 left" for="text">${ctp:i18n('form.bind.set.label')}:</label>
							<a class="common_button common_button_gray" href="javascript:void(0)" id="newBind">${ctp:i18n('form.trigger.triggerSet.add.label')}</a>
						</div>
						<fieldset class="form_area padding_10" id="editArea">
							<legend>${ctp:i18n('form.pagesign.appbind.label')}</legend>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" id="templateNameSet">
									<tr height="30px">
										<td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red">*</font>${ctp:i18n('form.bind.plan.planName')}：</label></td>
										<td nowrap="nowrap" >
										    <DIV class=common_txtbox_wrap>
										    <input id="id" name="id" class="w100b" type="hidden">
                                            <input type="hidden" id="moduleType" name="moduleType" value="5">
										    <input readonly="readonly" id="subject" name="${ctp:i18n('form.bind.plan.planName')}" class="w100b validate" type="text" maxlength="60" validate="type:'string',notNull:true,maxLength:60,avoidChar:'&&quot;&lt;&gt;'">
										    </DIV>
										</td>
										<td width="155px">
										</td>
									</tr>
									<tr height="30px">
										<td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('common.toolbar.auth.label')}：</label></td>
										<td nowrap="nowrap" >
										    <div class=" common_txtbox_wrap" >
										    <input readonly="readonly" id="auth_txt" name="auth_txt" type="text" class="w100b">
										    <input readonly="readonly" id="auth" name="auth" type="hidden">
										    </div>
										</td>
										<td width="155px">
										<a class="common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="authSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
								</table>
						<div align="center" id="buttonDiv">
							<a class="common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="saveSet">${ctp:i18n('common.button.ok.label')}</a>
						</div>
                        <div align="center" id="descDetail">
                            ${ctp:i18n('plan.desc.plantemplatebind.binddesc')}
                        </div>
						</fieldset>
	                </div>
	                </form>
	                <div class="col2 margin_l_5 <c:if test="${formBean.formType==baseInfo }">hidden </c:if>" style="float: left">
	                	<div class="common_txtbox clearfix margin_b_5">
							<label class="margin_r_10 left" for="text">${ctp:i18n('form.bind.bindList')}:</label>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="updateTemplate">${ctp:i18n('common.button.modify.label')}</a>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="delTemplate">${ctp:i18n('common.button.delete.label')}</a>
						</div>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
		                    <thead>
		                        <tr>
		                            <th width="30px"><input type="checkbox" onclick="selectAll(this,'templateBody')"/></th>
		                            <th align="center">${ctp:i18n('plan.desc.plantemplatebind.planformatname')}</th>
		                        </tr>
		                    </thead>
		                    <tbody id="templateBody">
		                    	<c:forEach var="it" items="${formBean.bind.flowTemplateList }">
			                    		<tr>
		                            		<td id="selectBox"><input type="checkbox" value="${it.id }"/></td>
		                            		<td>${it.subject }</td>
		                        		</tr>
		                        		</c:forEach>
		                    </tbody>
		                 </table>
	                </div>
				</div>
	        </div>
	       	<div class="layout_south over_hidden" id="south">
		       	<div class="stadic_layout_footer page_color">
					<%@ include file="../bottom.jsp" %>
				</div>
			</div>
		</div>
	</body>
	<%@ include file="../../common/common.js.jsp" %>
	<script type="text/javascript">
	$(document).ready(function(){
        new MxtLayout({
            'id': 'layout',
            'northArea': {
                'id': 'north',
                'height':29,
                'sprit': false,
				'border': true
            },
            'southArea': {
                'id': 'south',
                'height': 30,
                'sprit': true,
				'border': false,
				'maxHeight': 30,
                'minHeight': 30
            },
            'centerArea': {
                'id': 'center',
                'border': true
            }
        });
        if(!${formBean.newForm }){
        	new ShowTop({'current':'bind','canClick':'true','module':'bind'});
        	new ShowBottom({'show':['doSaveAll','doReturn']});
        }else{
        	new ShowTop({'current':'bind','canClick':'false','module':'bind'});
        	new ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../report/reportDesign.do?method=index','nextStep':'../form/triggerDesign.do?method=index'}});
        }
        $("#archiveId").change(function(){
        	var options = $("option",$(this));
        	var ids = options.length==3?(options.eq(2).val()+"."+options.eq(2).text()):null;
            if($(this).val()=="1"){
            	var pige = pigeonhole(2, null, false, false,"");
            	if("cancel"!=pige&&""!=pige){
                	var p = pige.split(",");
                	if(ids!=null){
                		options.eq(2).remove();
                	}
                	$("<option selected value='"+p[0]+"'>"+p[1]+"</option>").appendTo($(this));
                	$("#authDetail").removeClass("hidden");
                	$(":checked","#authDetail").prop("checked",false);
            	}else{
                	if(ids!=null){
                		options.eq(2).prop("selected",true);
                	}else{
                		options.eq(0).prop("selected",true);
                    }
            	}
            }else if("" == $(this).val()){
            	if(ids!=null){
            		$("option:eq(2)",$(this)).remove();
            	}
            	$("#authDetail").removeClass("hidden").addClass("hidden");
            }else{
            	$("#authDetail").removeClass("hidden");
            }
            if($.browser.msie){//clone出来的选择框 在IE9的情况下 重新赋值后会有问题
        		for(var i=0; i<this.options.length; i++){
        			this.options[i].innerText = this.options[i].text+(i==0?" ":"");
        			this.options[i].text = this.options[i].text+(i==0?" ":"");
        		}
        	}
        });
		$("#relDocSet").click(function(){
			if($(this).hasClass("common_button_disable")){
                return false;
            }
			quoteDocument('rel_doc');
		});
        $("#newFlowSet").click(function(){
            if($(this).hasClass("common_button_disable")){
                return false;
            }
            $("#process_xml_clone").val($("#process_xml").val());
            $("#process_xml").val("");
        	createWFTemplate(window,"collaboration", "${formBean.id}", "${formBean.id}","");
        });
        $("#updateFlowSet").click(function(){
            if($(this).hasClass("common_button_disable")){
                return false;
            }
            if($("#process_xml").val()==""){
            	$("#process_xml").val($("#process_xml_clone").val());
            }
        	createWFTemplate(window,"collaboration", "${formBean.id}", "${formBean.id}",$("#process_id").val());
        });
        $("#newBind").click(function(){
        	setInitState();
        	editState();
        });
        $("#saveSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	if($("#process_xml").val()==""){
            	$("#process_xml").val($("#process_xml_clone").val());
            }
            /*if($("#process_info").val()==""||$("#process_info").val()=="undefined"||$("#process_info").val()=="null"){
                alert("流程不能为空!");
                return false;
            }
            if($("#subject").val()==""){
                alert("表单模板名称不能为空!");
                return false;
            }*/
            if($("#templateNameSet").validate({errorAlert:false})){
            	var bManager = new formBindDesignManager();
                var bindId= $("#id").val()==""?-1:$("#id").val();
                var ss = bManager.checkSameBindName(bindId,$("#subject").val());
                if("success" != ss){
                    $.alert("${ctp:i18n('form.query.isexites')}");
                    return;
                }
                changePageNoAlert = true;
            	$("#editArea").jsonSubmit({domains:['templateNameSet'],validate:false,action:$("#saveForm").prop('action')});
            }
        });
        $("#updateTemplate").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
            var templateChecked = $(":checked","#templateBody");
            if(templateChecked.length!=1){
            	$.alert("${ctp:i18n('form.bind.chooseOneToUpdate')}");
                return false;
            }
            setInitState();
            editState();
            initTemplateData(templateChecked.val());
        });
        $("#delTemplate").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
            var templateChecked = $(":checked","#templateBody");
            if(templateChecked.length<1){
            	$.alert("${ctp:i18n('form.query.querySet.chooseToDelete')}");
                return false;
            }
            $.alert({
			    'type' : 1,
			    'msg' : "${ctp:i18n('form.query.querySet.deleteConfirm')}",
			    ok_fn : function() {
	            	var tems = new Array();
	                templateChecked.each(function(){
	                    tems[tems.length] = $(this).val();
	                });
	                deleteTemplate(tems);
			    }
			 });
        });
        $("#uploadSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	insertAttachment();
        });
        $("#authSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	var par = new Object();
			par.value = $("#auth").val();
			par.text = $("#auth_txt").val();
        	$.selectPeople({
                panels: 'Account,Department,Team,Post,Level,Outworker',
                selectType: 'Account,Department,Team,Post,Level,Member',
                hiddenPostOfDepartment:true,
                isNeedCheckLevelScope:false,
                params : par,
                callback : function(ret) {
                  $("#auth").val(ret.value);
                  $("#auth_txt").val(ret.text);
                }
              });
        });

        $("body").data("cloneTable",$("#editArea").clone(true));
	});

	function initTemplateData(templateId){
		var manager = new formBindDesignManager();
		manager.editFlowTemplate(templateId, {
            success: function(obj){
			$("#editArea").fillform(obj);
			$("#fileArea").empty();
			if(obj.archive_Id!=null&&obj.archive_Id!=""){
				$("<option selected value='"+obj.archive_Id+"'>"+obj.archive_name+"</option>").appendTo($("#archiveId"));
				if($.browser.msie){//clone出来的选择框 在IE9的情况下 重新赋值后会有问题
					var archObj = $("#archiveId")[0];
	        		for(var i=0; i<archObj.options.length; i++){
	        			archObj.options[i].innerText = archObj.options[i].text+(i==0?" ":"");
	        			archObj.options[i].text = archObj.options[i].text+(i==0?" ":"");
	        		}
	        	}
				$("#authDetail").removeClass("hidden");
			}
			deleteAllAttachment(0);
			var uploadStr = "<input id=\"uploadFile\" name=\"uploadFile\" attsdata='@attsJson@' type=\"text\" class=\"comp\" comp=\"type:'fileupload',applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false\">";
			//alert(obj.fileJson);
            $("#fileArea").html(uploadStr.replace("@attsJson@",obj.fileJson));
            var docStr = "<div id=\"rel_doc\" class=\"comp\" attsdata='@attsJson@' comp=\"type:'assdoc',attachmentTrId:'rel_doc', modids:'1'\"></div>";
            $("#rel_doc_div").html(docStr.replace("@attsJson@",obj.fileJson));
            $("body").comp();
         }
     	});
	}
	function deleteTemplate(ids){
		var manager = new formBindDesignManager();
		manager.delFlowTemplate(ids, {
            success: function(obj){
				winReflesh("${path }/form/bindDesign.do?method=index");
         	}
     	});
	}
	function editState(){
		$("a","#editArea").removeClass("common_button_disable").removeClass("common_button").addClass("common_button");
		$("#subject").prop("readonly",false);
		$("#templateNumber").prop("readonly",false);
		$(":disabled","#editArea").prop("disabled",false);
	}
	function setInitState(){
		var bindTable = $("#editArea");
		bindTable.empty();
		bindTable.append($("body").data("cloneTable").clone(true).children());
		deleteAllAttachment(0);
	}
	function validateFormData(){
		if($("#subject").val()!=""&&!$("#subject").prop("readonly")){
			$.alert("${ctp:i18n('form.bind.saveBindInfo')}");
	    	return false;
		}
		return true;
	}
	</script>
</html>
