<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formTriggerDesignManager,formManager"></script>
</head>
<body style='overflow:hidden;width: 100%;'>
    <form action="" id="submitForm" name="submitForm" method="post">
        <div class="clearfix margin_t_5" >
            <div class="left" style="width: 340px;"><span class="align_right padding_l_10" id="struction"><a class="hand font_size12">[${ctp:i18n('formsection.config.operinstruction.label') }]</a></span></div>
            <div class="left" style="text-align: right;"><a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="addNewRelationForm">${ctp:i18n('form.new.relation.form')}</a></div>
        </div>
        <div id="newEchoSettingContainer" class="scrollList"  style="height:430px;overflow-y: auto;">
        <c:if test="${fn:length(fillBackSet)>0 }">
        <c:forEach var="echo" items="${fillBackSet }" varStatus="status">
        <div id="echoSetting" class="echoSetting">
        <div class="clearfix margin_t_5 margin_l_5" style="">
            <div class="left clearfix" style="width: 20px;min-height: 100px;vertical-align: bottom;line-height: 100px;">
                <div style="height: 50px;line-height: 25px;">
                    <span id="addRowButton" class="addRowButton ico16 repeater_plus_16"> </span>
                    <br/><br/>
                    <span id="delRowButton" class="delRowButton ico16 repeater_reduce_16"></span>
                </div>
            </div>
            <div>
                <fieldset style="width: 450px;padding: 0px;">
                    <legend>${ctp:i18n('form.echoSetting.label')}</legend>
                    <div style="width: 450px;">
                        <div class="clearfix" style="line-height: 20px;">
                            <div class="left" style="width: 150px;text-align: right;">${ctp:i18n('form.echoSetting.selectForm.label')}：</div>
                            <div class="left">
                                <div class="common_selectbox_wrap  showFormName" style="margin-left: 0px;">
                                 <c:set var="relationConditionId" value="${echo.conditions[0].formulaId }"></c:set>
                                 <c:choose>
                                     <c:when test='${echo.extraMap.systemRelationForm != null }'>
                                     ${echo.extraMap.systemRelationForm }
                                     </c:when>
                                     <c:otherwise>
                                     <select id="selectRelationForm" name="selectRelationForm" style="width: 150px;margin: 0px;height: 18px;" class="selectRelationForm">
                                         <c:forEach var="rel" items="${relation }">
                                         <option value="${rel[0] }.${rel[1] }" <c:if test="${relationConditionId eq rel[1] }">selected=true</c:if> conditionId="${rel[1] }" condition="${rel[7] }" formId="${rel[0] }" fromSubTableName="${rel[6] }" subTableName="${rel[4] }" conditionIsMaster="${rel[3] }">${rel[2] }</option>
                                         </c:forEach>
                                     </select>
                                 </c:otherwise>
                                 </c:choose>
                                 </div>
                                 <input type="hidden" id="conditionContainMaster" value="${echo.extraMap.conditionOnlyMasterFeild }">
                                 <input type="hidden" id="id" name="id" value="${echo.id }">
                                 <input type="hidden" id="formId" name="formId" value="${echo.conditions[0].param }">
                                 <input type="hidden" id="conditionId" name="conditionId" value="${relationConditionId }"/>
                                 <input type="hidden" id="condition" name="condition" value="${echo.extraMap.condition }"/>
                                 <input type="hidden" id="subTableName" name="subTableName" value="${echo.extraMap.subTableName }"/>
                                 <input type="hidden" id="fromSubTableName" name="fromSubTableName" value="${echo.extraMap.fromSubTableName }"/>
                                 <input type="hidden" id="fromConditionOnlyMasterFeild" name="fromConditionOnlyMasterFeild" value="${echo.extraMap.fromConditionOnlyMasterFeild }"/>
                            </div>
                            <div class="right" style="margin-right: 37px;">
                                <span id="relateButton" class="relateButton color_blue hand">[${ctp:i18n('form.echo.relatedform.view')}]</span>
                            </div>
                        </div>
                        <div id = "echoTiemDiv" class="clearfix margin_t_5" style="line-height: 20px;">
                            <div class="left" style="width: 150px;text-align: right;">${ctp:i18n('form.echoSetting.echoTime.label')}：</div>
                            <div class="left">
                                <input type="hidden" id="pointData" value="${echo.flowState }">
                                <label for="flow${status.index }"><input type="radio" id="flow${status.index }" class="radio_com flow"  name="echoTime${status.index }" value="1" <c:if test="${echo.flowState eq '1' }">checked="checked"</c:if>>${ctp:i18n('form.trigger.triggerSet.processEnd.label')}</label>
								<label for="approved${status.index }"><input type="radio" id="approved${status.index }"  class="radio_com approved" name="echoTime${status.index }" value="2" <c:if test="${echo.flowState eq '2' }">checked="checked"</c:if>>${ctp:i18n('form.trigger.triggerSet.approvedBy.label')}</label>
							</div>
                        </div>
                        <div class="clearfix margin_t_5" style="line-height: 20px;">
                            <div class="left" style="width: 150px;text-align: right;">${ctp:i18n('form.echoSetting.data.label')}：</div>
                        </div>
                        <div class="rowdatas" id="refColumTable">
                        <c:forEach var="refColum" items="${echo.actions[0].param.fillBack }">
                        <div class="clearfix margin_t_5 rowdata" style="line-height: 20px;">
                            <div class="left margin_l_5" style="width: 20px;">b.</div>
                            <div class="left" style="">
                                <select id="refColumNames" name="refColumNames" style="width:150px" class="refColumNames validate" validate="name:''${ctp:i18n('form.trigger.triggerSet.fillback.field') },type:'string',notNull:true">
                                    <option value=""></option>
                                    <c:forEach var="outField" items="${outWriteFields[status.index] }">
                                        <c:set var="optionValue" value="${outField.ownerTableName }.${outField.name }"></c:set>
                                        <option <c:if test="${optionValue eq refColum.key }">selected=true</c:if> value="${optionValue }" uniqueTableName='${outField.extraMap.uniqueTableName }' tableName='${outField.ownerTableName }' inputType='${outField.inputType }' fieldType='${outField.fieldType }' isMaster="${outField.masterField }">${outField.display }</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="left" style="width: 30px;text-align: center;">=<input type="hidden" id="fillType" value=${refColum.type }></div>
                            <div class="left" style="">
                                <input type="hidden" id="calcField" class="calcField" <c:if test="${refColum.type eq 'copy' }">value="${refColum.value }"</c:if><c:if test="${refColum.type eq 'formula' }">value="${refColum.value.formulaForDisplay }"</c:if>>
                                <input type="text" id="calcExpression" readonly="readonly" <c:if test="${refColum.type eq 'copy' }">value="${refColum.display }"</c:if><c:if test="${refColum.type eq 'formula' }">value="${refColum.value.formulaForDisplay }"</c:if> name="calcExpression" style="cursor: pointer;width:130px;" class="calcExpression validate" validate="name:'${ctp:i18n('form.trigger.triggerSet.fillback.fieldvalue') }'type:'string',notNull:true">
                            </div>
                            <div class="left margin_l_5" style="">
                                <span id="delButton" class="delButton ico16 repeater_reduce_16"></span>
                                 <span id="addButton" class="addButton ico16 repeater_plus_16"> </span>
                                 <input type="hidden" name="rowcondition" id="rowcondition" value="${refColum.rowcondition }">
                                 <span id="formulaButton" class="formulaButton hand color_blue">
                                    [${ctp:i18n('form.query.label.condition')}<span id="formulaButtonImg" class="ico16 gone_through_16" style="${fn:length(refColum.rowcondition) > 0 ? '' : 'display: none'}"></span>]
                                 </span>
                            </div>
                        </div>
                        </c:forEach>
                        </div>
                        <div class="clearfix margin_t_5 radiocheck" style="line-height: 20px;padding-left: 10px;">
                            <input id="withholding" type="hidden" value="${echo.actions[0].param.withholding }">
                            <input id="addSlaveRow" type="hidden" value="${echo.actions[0].param.addSlaveRow }">
                            <div class="common_checkbox_box clearfix ">
                                <label class="margin_r_10 hand" for="withholding${status.index }">
                                    <input name="withholding" class="radio_com withholding" id="withholding${status.index }" type="checkbox" <c:if test='${echo.actions[0].param.withholding eq "true" }'>checked='checked'</c:if> value="true">${ctp:i18n('form.create.withholding.label')}</label>
                                <label class="margin_r_10 hand" for="addSlaveRow${status.index }" style="margin-left: 30px;">
                                    <input name="addSlaveRow" class="radio_com addSlaveRow" id="addSlaveRow${status.index }" type="checkbox" <c:if test='${echo.actions[0].param.addSlaveRow eq "true" }'>checked='checked'</c:if> <c:if test='${echo.extraMap.conditionOnlyMasterFeild eq "0" }'>disabled</c:if> value="true">${ctp:i18n('form.trigger.triggerSet.fillback.add.repeat') }</label>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </div>
        </div>
        </div>
        </c:forEach>
        </c:if>
        </div>
    <div id="operInstructionDiv"  style="color:  green;font-size: 12px;display: none;">
        ${ctp:i18n("form.trigger.triggerSet.fillback.info") }
    </div>
</form>
<div id="cloneDiv" class="hidden" style="">
    <div id="echoSetting" class="echoSetting">
        <div class="clearfix margin_t_5 margin_l_5" style="">
            <div class="left clearfix" style="width: 20px;min-height: 100px;vertical-align: bottom;line-height: 100px;">
                <div style="height: 50px;line-height: 25px;">
                    <span id="addRowButton" class="addRowButton ico16 repeater_plus_16"> </span>
                    <br/><br/>
                    <span id="delRowButton" class="delRowButton ico16 repeater_reduce_16"></span>
                </div>
            </div>
            <div class="left">
                <fieldset style="width: 450px;padding: 0px;">
                    <legend>${ctp:i18n('form.echoSetting.label')}</legend>
                    <div style="width: 450px;">
                        <div class="clearfix" style="line-height: 20px;">
                            <div class="left" style="width: 150px;text-align: right;">${ctp:i18n('form.echoSetting.selectForm.label')}：</div>
                            <div class="left">
                                <div class="common_selectbox_wrap  showFormName" style="margin-left: 0px;">
                                     <select id="selectRelationForm" name="selectRelationForm" style="width: 150px;margin: 0px;height: 18px;" class="selectRelationForm">
                                         <c:forEach var="rel" items="${relation }">
                                         <option value="${rel[0] }.${rel[1] }"  conditionId="${rel[1] }" condition="${rel[7] }" formId="${rel[0] }" subTableName="${rel[4] }" conditionIsMaster="${rel[3] }" subTableName="${rel[4] }">${rel[2] }</option>
                                         </c:forEach>
                                     </select>
                                 </div>
                                 <input type="hidden" id="conditionContainMaster" value="0">
                                 <input type="hidden" id="id" name="id" value="">
                                 <input type="hidden" id="formId" name="formId" value="">
                                 <input type="hidden" id="conditionId" name="conditionId" value=""/>
                                 <input type="hidden" id="condition" name="condition" value=""/>
                                 <input type="hidden" id="subTableName" name="subTableName" value=""/>
                                 <input type="hidden" id="fromSubTableName" name="fromSubTableName" value=""/>
                                 <input type="hidden" id="fromConditionOnlyMasterFeild" name="fromConditionOnlyMasterFeild" value=""/>
                            </div>
                            <div class="right" style="margin-right: 37px;">
                                <span id="relateButton" class="relateButton color_blue hand hidden">[${ctp:i18n('form.echo.relatedform.view')}]</span>
                            </div>
                        </div>
                        <div id = "echoTiemDiv" class="clearfix margin_t_5" style="line-height: 20px;">
                            <div class="left" style="width: 150px;text-align: right;">${ctp:i18n('form.echoSetting.echoTime.label')}：</div>
                            <div class="left">
                                <input type="hidden" id="pointData" value="1">
                                <label for="flow"><input type="radio" id="flow" class="radio_com flow"  name="echoTime" value="1">${ctp:i18n('form.trigger.triggerSet.processEnd.label')}</label>
								<c:if test="${formBean.govDocFormType!=5&&formBean.govDocFormType!=6&&formBean.govDocFormType!=7}">
								<label for="approved"><input type="radio" id="approved" class="radio_com approved"  name="echoTime" value="2">${ctp:i18n('form.trigger.triggerSet.approvedBy.label')}</label>
                            	</c:if>
							</div>
                        </div>
                        <div class="clearfix margin_t_5" style="line-height: 20px;">
                            <div class="left" style="width: 150px;text-align: right;">${ctp:i18n('form.echoSetting.data.label')}：</div>
                        </div>
                        <div class="rowdatas" id="refColumTable">
	                        <div class="clearfix margin_t_5 rowdata" style="line-height: 20px;">
	                            <div class="left margin_l_5" style="width: 20px;">b.</div>
	                            <div class="left" style="">
	                                <select id="refColumNames" name="refColumNames" style="width:150px" class="refColumNames validate" validate="name:''${ctp:i18n('form.trigger.triggerSet.fillback.field') },type:'string',notNull:true">
	                                    <option value=""></option>
	                                </select>
	                            </div>
	                            <div class="left" style="width: 30px;text-align: center;">=<input type="hidden" id="fillType" value="copy"></div>
	                            <div class="left" style="">
	                                <input type="hidden" id="calcField" class="calcField"><input type="text" id="calcExpression" readonly="readonly" name="calcExpression" style="cursor: pointer;width:130px;" class="calcExpression validate" validate="name:'${ctp:i18n('form.trigger.triggerSet.fillback.fieldvalue') }'type:'string',notNull:true">
	                            </div>
	                            <div class="left margin_l_5" style="">
	                                <span id="delButton" class="delButton ico16 repeater_reduce_16"></span>
	                                 <span id="addButton" class="addButton ico16 repeater_plus_16"> </span>
	                                 <input type="hidden" name="rowcondition" id="rowcondition" value="">
	                                 <span id="formulaButton" class="formulaButton color_blue hand">[${ctp:i18n('form.query.label.condition')}<span id="formulaButtonImg" class="ico16 gone_through_16" style="display: none"></span>]</span>
	                            </div>
	                        </div>
                        </div>
                        <div class="clearfix margin_t_5 radiocheck" style="line-height: 20px;padding-left: 10px;">
                            <input id="withholding" type="hidden" value="false">
                            <input id="addSlaveRow" type="hidden" value="false">
                            <div class="common_checkbox_box clearfix ">
                                <label class="margin_r_10 hand" for="withholding1">
                                    <input name="withholding" class="radio_com withholding" id="withholding1" type="checkbox" value="true">${ctp:i18n('form.create.withholding.label')}</label>
                                <label class="margin_r_10 hand" for="addSlaveRow1" style="margin-left: 30px;">
                                    <input name="addSlaveRow" class="radio_com addSlaveRow" id="addSlaveRow1" type="checkbox" value="true">${ctp:i18n('form.trigger.triggerSet.fillback.add.repeat') }</label>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </div>
        </div>
    </div>
</div>
</body>
<%@ include file="../../common/common.js.jsp" %>
<script type="text/javascript">
var currentRow;
var currentEchoSet;
var newRowCount= new rowCountManager();
var rightData = {'DialogTitle':'${ctp:i18n('form.echoSetting.label')}','ShowTitle':'${ctp:i18n('form.echoSetting.choose.field')}','LeftUpTitle':'${ctp:i18n('form.echoSetting.form.field')}','RightTitle':'${ctp:i18n('form.echoSetting.selected')}','IsShowLeftDown':true,'IsShowSearch':false,'IsWriteBlak':false,'IsChooseSingel':true,'isEchoSetting':true};
var formulaObj = null;
var o = new formTriggerDesignManager();
$(document).ready(function(){
	if($.v3x.isMSIE7) {
		$("body").css("overflow","hidden");
	}
  $("#struction").tooltip({
    event:true,
    openAuto:false,
    width:400,
    htmlID:'operInstructionDiv',
    targetId:'struction'
  });
  $("#operInstructionDiv").show();
	$(".addRowButton").click(function(){
	  currentEchoSet = addEchoSet(currentEchoSet);
	  initOutWrite(currentEchoSet);
	});
	$(".delRowButton").click(function(){
	  setCurrentEchoSet(this);
	  delEchoSet();
	  currentEchoSet=null;
	});
	$(".echoSetting").mousedown(function(){
	  currentEchoSet =$(this);
	});
	$(".selectRelationForm").change(function(){
	  setCurrentEchoSet(this);
	  setFormId4Select(this,currentEchoSet);
	  initOutWrite(currentEchoSet);
	});
	$(".addButton").click(function(){
		var thisTr = $(this).parents(".rowdata");
		if($(".refColumNames",thisTr).val()==""){
			$.alert('${ctp:i18n('form.echoSetting.alert.msg1')}');
			  return;
		}
		currentRow = addRefOutWrite(thisTr);
	});
	$(".delButton").click(function(){
	  setCurrentRow(this);
	  if ($(".rowdata",currentEchoSet).length >1){
	    currentRow.remove();
	    currentRow = null;
	  }else{
	    initOutWrite(currentEchoSet);
	    $("#formulaButtonImg", currentRow).css("display", "none");
	  }
	});
	$(".refColumNames").change(function(){
	  setCurrentRow(this);
		var thisValue = $(this).val();
		if($(":selected[value='"+thisValue+"']",$(this).parents(".rowdatas")).length>1){
			$.alert('${ctp:i18n('form.echoSetting.alert.msg2')}');
			$(this).val("");
		}
		  var optionSelected = $(":selected:eq(0)",$(this));
		if($("#addSlaveRow",currentEchoSet).val()=="false"){
		  if (optionSelected.attr("isMaster")=="false"){ //重复表字段
		    if($("#subTableName",currentEchoSet).val()==""){ //关联条件不包含重复表字段
		      $.alert("${ctp:i18n('form.echoSetting.nosontable')}");
		      $(this).val("");return;
		    } else if ($("#subTableName",currentEchoSet).val() != optionSelected.attr("tableName")){ //关联条件包含重复表字段，但重复表和当前字段不是同一个重复表
		      $.alert($.i18n("form.echoSetting.nosomesontable",optionSelected.text()));
		      $(this).val("");return;
		    }
		  }
			setFillType($(this).parents(".rowdata"));
		}else{
			if($(":selected",$(this)).attr("isMaster")=="false"){
				fillBackCopy($(this).parents(".rowdata"));
			}else{
				setFillType($(this).parents(".rowdata"));
			}
		}
	});
	$("#addNewRelationForm").click(function(){
	    var obj = new Array();
	    obj[0] = "fromEchoSetting";
		var dialog = $.dialog({
			url:"${path}/form/fieldDesign.do?method=setRelationForm",
		    title : '${ctp:i18n('form.echoSetting.form.relative')}',
		    width:500,
	        height:350,
	        transParams:obj,
	        targetWindow:getCtpTop(),
		    buttons : [{
		      text : "${ctp:i18n('common.button.ok.label')}",
		      id:"sure",
		      handler : function() {
			      var ret = dialog.getReturnValue();
			      if(ret != "error"&& typeof(ret)=="object"){
				      var ech = $(".echoSetting","#newEchoSettingContainer");
				      if(ech.length==1){
					      var refColumns = $(".refColumNames",ech.eq(0));
				          setCurrentEchoSet(refColumns);
		                  if(refColumns.length==1&&refColumns.eq(0).val()==""){
		                    currentEchoSet.remove();
		                    currentEchoSet = null;
		                  }
				      }
				      currentEchoSet = addEchoSet(currentEchoSet);
				      $(".showFormName",currentEchoSet).html(ret.formName);
				      $("#formId",currentEchoSet).val(ret.formId);
				      $("#conditionId",currentEchoSet).val("");
				      $("#condition",currentEchoSet).val(ret.condition);
				      $("#conditionContainMaster",currentEchoSet).val(ret.isMasterField);
				      $("#subTableName",currentEchoSet).val(ret.subTableName);
				      $("#fromSubTableName",currentEchoSet).val(ret.fromSubTableName);
				      if(ret.isMasterField=="0"){//条件中只有主表字段
				  		$(".addSlaveRow",currentEchoSet).attr("disabled",true);
				  	  }else{
				  		$(".addSlaveRow",currentEchoSet).attr("disabled",false);
				  	  }
				      initOutWrite(currentEchoSet);
			    	  dialog.close();
			      }
		      }
		    }, {
		      text : "${ctp:i18n('common.button.cancel.label')}",
		      id:"exit",
		      handler : function() {
		        dialog.close();
		      }
		    }]
		  });
	});
	$(".calcExpression").click(function(){
	  setCurrentRow(this);
		var parentTr = $(this).parents(".rowdata");
		if($(".refColumNames",parentTr).val()!=""){
			var optionSelected = $(":selected:eq(0)",parentTr);
			if($("#addSlaveRow",currentEchoSet).val()=="false"){//不勾选添加重复表行才判断
				//是重复表字段，并且回写关联条件中没有包含重复表字段
				if(optionSelected.attr("isMaster")=="false"&&($("#subTableName",currentEchoSet).val()=="" || $("#subTableName",currentEchoSet).val() !=optionSelected.attr("tableName"))){
					$.alert($.i18n('form.echoSetting.tablenamenotsame',optionSelected.text()));
					  return;
				}
			}
			if($("#fillType",parentTr).val()=="formula"){
				formulaObj = $("#calcExpression",parentTr)[0];
				setEcho($("#formId",currentEchoSet).val(),currentRow);
			}else{
				var rData= new  Properties();
				if($("#calcField",parentTr).val()!=""){
					rData.put($("#calcField",parentTr).val(),$("#calcExpression",parentTr).val());
				}
				rightData.RightData = rData;
				rightData.IsWriteBlak = false;
				rightData.isEchoSetting = true;
				var selectedType = $(":selected",parentTr).attr('fieldType');
				rightData.fieldType = selectedType;
                rightData.IsShowLeftDown = true;
                if("varchar" != selectedType.toLowerCase()&&"longtext"!= selectedType.toLowerCase()){
                    rightData.IsShowLeftDown = false;
				}
				selectChoose("calcExpression",null,$.parseJSON("{'byTable':'wee','byInputType':'handwrite,attachment,document,image,relationFlow','fieldType':'"+selectedType+"'}"),rightData,function(re){
					if(re!=null){
						var calValue = "";
						var calExpre = "";
						if(re.length>0){
							calValue = re[0].key;
							calExpre = re[0].value;
						}
						if (!preCheckFormula(currentRow,calValue)){
						  return false;
						}
						$("#calcExpression",parentTr).val(calExpre);
						$("#calcField",parentTr).val(calValue);
					}
				});
			}
		}
	});
	$(".withholding").click(function(){
	  setCurrentEchoSet(this);
	  withHoldingClick(this);
	});
	$(".addSlaveRow").click(function(){
	  setCurrentEchoSet(this);
	  addSlaveRow(this);
	});
	$(".flow").click(function(){
	  setCurrentEchoSet(this);
	  $("#pointData",currentEchoSet).val("1");
	});
	$(".approved").click(function(){
	  setCurrentEchoSet(this);
	  $("#pointData",currentEchoSet).val("2");
	});
	$(".formulaButton").click(function(){
	  setCurrentRow(this);
	  var fieldTableName = "";
	  if ($("#fromSubTableName",currentEchoSet).val()){
	    fieldTableName = $("#fromSubTableName",currentEchoSet).val();
	  } else {
	    fieldTableName = getValueSubTable(currentRow,$("#calcField",currentRow).val());
	  }
	  setEchoCondition($("#formId",currentEchoSet).val(),currentRow,fieldTableName);
	});

	$(".relateButton").click(function(){
	    var formId = $("#formId", currentEchoSet).val();
	    if (!formId) {
	        return;
	    }

	    var tempFormManager = new formManager();
	    var contentJson = tempFormManager.getConditionJson($("#condition", currentEchoSet).val());
	    var obj = new Array();
	    obj[0] = "fromEchoSetting";
	    obj[1] = contentJson;
	    var dialog = $.dialog({
	        url: "${path}/form/fieldDesign.do?method=setRelationForm&formId=" + formId + "&isCanChange=false",
	        title: "${ctp:i18n('form.echoSetting.form.relative')}",
	        width: 500,
	        height: 350,
	        transParams: obj,
	        targetWindow: getCtpTop(),
	        buttons: [{
	            text: $.i18n("common.button.ok.label"),
	            id: "sure",
	            handler: function() {
	                dialog.close();
	            }
	        }, {
	            text: $.i18n("common.button.cancel.label"),
	            id: "exit",
	            handler: function() {
	                dialog.close();
	            }
	        }]
	    });
	});

	$("body").data("echoSet",$("#echoSetting","#cloneDiv").clone(true));
	//$("#echoSetting","#cloneDiv").remove();
	<c:if test="${fn:length(fillBackSet)== 0 }">
	currentEchoSet = addEchoSet();
	initOutWrite(currentEchoSet);
	</c:if>
})
function preCheckFormula(currentRow,formulStr){
  return preCheck(currentRow,formulStr,$("#rowcondition",currentRow).val());
}
function preCheckCondition(currentRow,conditionStr){
  return preCheck(currentRow,$("#calcField",currentRow).val(),conditionStr);
}
function getValueSubTable(currentRow,formulStr){
  var valueSubTable = "";
  if ($("#fillType",currentRow).val() == "copy"){
    valueSubTable = formulStr.substr(0,formulStr.indexOf("."));
    if (valueSubTable.indexOf("formson") == -1){
      valueSubTable = "";
    }
  } else {
    if (formulStr){
    valueSubTable = o.getSubTableNameFromCondition(formulStr,false);
    }
  }
  return valueSubTable;
}
function preCheck(currentRow,formulStr,conditionStr){
  if (!formulStr || !conditionStr){
    return true;
  }
  var relationSubTable = $("#fromSubTableName",currentEchoSet).val();
  var conditionSubTable = o.getSubTableNameFromCondition(conditionStr,false);
  var valueSubTable = getValueSubTable(currentRow,formulStr);
    //关联条件不含重复表，回写值或者条件值包含重复表时不过
    //if (!relationSubTable && (valueSubTable || conditionSubTable)) {
    //    $.alert("关联条件中没有设置重复表，但回写算式或者条件中有重复表，请检查！");
    //    return false;
    //}
  //关联条件不含重复表，回写值也不含重复表，但回写条件含有重复表，不过
  if (!relationSubTable && !valueSubTable && conditionSubTable){
    $.alert("${ctp:i18n('form.echoSetting.condition.error.msg1')}");
    return false;
  }
  //关联条件有重复表，回写条件也有重复表，不一致，不过
  if (relationSubTable && conditionSubTable && conditionSubTable != relationSubTable){
    $.alert("${ctp:i18n('form.echoSetting.condition.error.msg2')}");
    return false;
  }
  //回写值有重复表，回写条件有重复表，不一致，不过
  if (valueSubTable && conditionSubTable && conditionSubTable != valueSubTable){
    $.alert("${ctp:i18n('form.echoSetting.condition.error.msg3')}");
    return false;
  }
  currentRow.css("border","0px");
  return true;
}
function setCurrentRow(obj){
  setCurrentEchoSet(obj);
  currentRow = $(obj).parents(".rowdata");
}
function setCurrentEchoSet(obj){
  currentEchoSet = $(obj).parents(".echoSetting");
}
function conditionCallBack(formulaStr,currentRow){
  $("#rowcondition",currentRow).val(formulaStr);
  if (formulaStr){
    $("#formulaButtonImg",currentRow).css("display", "");
  } else {
    $("#formulaButtonImg",currentRow).css("display", "none");
  }
}
function withHoldingClick(obj){
	if($(obj).is(":checked")){
		$("#withholding",$(obj).parents(".radiocheck")).val("true");
		if($(".addSlaveRow",currentEchoSet).prop("checked")){
			$(".addSlaveRow",currentEchoSet).prop("checked",false);
			addSlaveRow($(".addSlaveRow",currentEchoSet));
		}
	}else{
		$("#withholding",$(obj).parents(".radiocheck")).val("false");
	}
}
function addSlaveRow(obj){
	var addSlaveObj = $(obj);
	$(".refColumNames",currentEchoSet).each(function(){
		if($(":selected",$(this)).attr("isMaster")=="false"){//重复表字段
			var parentTR = $(this).parents(".rowdata");
			if(addSlaveObj.is(":checked")){
				fillBackCopy(parentTR);
			}else{
				setFillType(parentTR);
			}
		}
	});
	if($(obj).is(":checked")){
		$("#addSlaveRow",currentEchoSet).val("true");
		$(".withholding",currentEchoSet).prop("checked",false);
		withHoldingClick($(".withholding",currentEchoSet));
	}else{
		$("#addSlaveRow",currentEchoSet).val("false");
	}
}
function fillBackCopy(objTr){
	$("#fillType",objTr).val("copy");
	$(".calcExpression",objTr).val("");
	$(".calcField",objTr).val("");
	$("#rowcondition",objTr).val("");
	$("#formulaButtonImg", objTr).css("display", "none");
}
function setContentValue(){
}
function rowCountManager(){
	var count = 1000;
	function add(){
		count += 1;
		return count;
	}
	return add;
}
function setFillType(objTr){
	if($(":selected",objTr).attr("fieldType")=="DECIMAL"){
		$("#fillType",objTr).val("formula");
	}else{
		$("#fillType",objTr).val("copy");
	}
	$(".calcExpression",objTr).val("");
	$(".calcField",objTr).val("");
	$("#rowcondition",objTr).val("");
	$("#formulaButton",objTr).removeClass("color_red");
	$("#formulaButton",objTr).addClass("color_blue");
	$("#formulaButtonImg", objTr).css("display", "none");
}
//取关联表单的外部写入字段
function getOutwriteField(formId){
	var manager = new formTriggerDesignManager();
	return manager.getOutwriteField(formId);
}
//改变系统关联表单时 显示外部写入下拉框
function initOutWrite(obj){
	initSetRefOutWriteList(obj);
	var list = getOutwriteField($("#formId",$(obj)).val());
	initOutWriteFieldShow($(".refColumNames",$(obj)),list);

	if ($("#formId", $(obj)).val() != "") {
	    $("#relateButton", $(obj)).show();
	}
}
//初始化的时候 把首先显示出来的系统关联表单的外部写入下拉框数据取出来
function initOutAll(){
	//var formId = $("#selectRelationForm").val();
	//setFormId4Select($("#selectRelationForm",currentRow),currentRow);
	//initOutWrite(currentRow);
}
//显示外部写入的字段下拉框
function initOutWriteFieldShow(obj,list){
	var str = "<option value=''></option>";
	var isMasterT = false;
	for(var i=0;i<list.length;i++){
		if(list[i].ownerTableName.indexOf("formmain_")>-1){
			isMasterT = true;
		}else{
			isMasterT = false;
		}
		str += "<option value='"+list[i].ownerTableName+"."+list[i].name+"' uniqueTableName='"+list[i].extraMap.uniqueTableName+"' tableName='"+list[i].ownerTableName+"' inputType='"+list[i].inputType+"' fieldType='"+list[i].fieldType+"' isMaster='"+isMasterT+"'>"+list[i].display+"</option>";
	}
	obj.empty();
	obj.html("");
	obj.append(str);
	//IE9 select克隆之后 会有这个问题
	if($.browser.msie){
		for(var i=0; i<obj[0].options.length; i++){
			obj[0].options[i].innerText = obj[0].options[i].text+"";
			obj[0].options[i].text = obj[0].options[i].text+"";
		}
	}
}
//初始化外部写入字段下拉框（清空）
function initSetRefOutWriteList(obj){
  $(obj).find(".rowdata").each(function(index){
    if (index==0){
      $(":input",$(this)).val("");
    } else {
      $(this).remove();
    }
  });
}
//添加回写的字段
function addRefOutWrite(obj){
	var temObj = obj.clone(true);
	$(":input",temObj).val("");
	$("#formulaButtonImg",temObj).css("display", "none");
	temObj.insertAfter(obj);
	return temObj;
}
//删除回写字段
function removeRefOutWrite(obj){
	obj.remove();
}

function addEchoSet(obj){
	var temObj = $("body").data("echoSet").clone(true);
	currentEchoSet = temObj;
	var count= newRowCount();
	var flow = "flow"+count;//;//.prop("id",)
	var approved = "approved"+count;//;
	var name = "echoTime"+count;
	var withholding = "withholding"+count;
	$("#flow",temObj).prop("id",flow).attr("name",name);
	$("#approved",temObj).prop("id",approved).attr("name",name);
	$("label[for='flow']",temObj).attr("for",flow);
	$("label[for='approved']",temObj).attr("for",approved);
	if($.v3x.isMSIE7) {
	  var html = "<div class=\"left\" style=\"width: 150px;text-align: right;\">${ctp:i18n('form.echoSetting.echoTime.label')}：</div><div class=\"left\"><input type=\"hidden\" id=\"pointData\" value=\"1\">"
	    + "<label for=\""+flow+"\"><input type=\"radio\" id=\""+flow+"\" class=\"radio_com flow\"  name=\""+name+"\" value=\"1\">${ctp:i18n('form.trigger.triggerSet.processEnd.label')}</label>"+
	    "<label for=\""+approved+"\"><input type=\"radio\" id=\""+approved+"\" class=\"radio_com approved\"  name=\""+name+"\" value=\"2\">${ctp:i18n('form.trigger.triggerSet.approvedBy.label')}</label></div>";
	  $("#echoTiemDiv",temObj).html(html);
	  $(":radio",temObj).bind("click",function(){
	    toRadioShow(temObj,true);
	  });
    }
	$("#withholding1",temObj).prop("id",withholding).prop("name",withholding);
	$("label[for='withholding1']",temObj).attr("for",withholding);
	var addSlaveRow = "addSlaveRow"+count;
	$("#addSlaveRow1",temObj).prop("id",addSlaveRow).prop("name",addSlaveRow);
	$("label[for='addSlaveRow1']",temObj).attr("for",addSlaveRow);
	 toRadioShow(temObj,false);
	if(obj){
		temObj.insertAfter($(obj));
	}else{
		$("#newEchoSettingContainer").append(temObj);
	}
	setFormId4Select($("#selectRelationForm",temObj),temObj);
	return temObj;
}
function delEchoSet(){
	if($(".echoSetting","#newEchoSettingContainer").length>1){
	  currentEchoSet.remove();
	}else{
	  currentEchoSet.remove();
	  currentEchoSet = addEchoSet();
	  initOutWrite(currentEchoSet);
	}
}
//状态radio转化为输入框值
//isRadio==true时表示 radio转化为input的值
function toRadioShow(row,isRadio){
	if(isRadio){
		$("#pointData",row).val($(":radio:checked",row).val());
	}else{
		$(":radio[value='"+$("#pointData",row).val()+"']",row).prop("checked",true);
	}
}
function setFormId4Select(obj,row){
	var selectedOption = $(":selected",$(obj));
	$("#formId",row).val(selectedOption.attr("formId"));
	$("#conditionContainMaster",row).val(selectedOption.attr("conditionIsMaster"));
	$("#conditionId",row).val(selectedOption.attr("conditionId"));
	$("#condition",row).val(selectedOption.attr("condition"));
	$("#subTableName",row).val(selectedOption.attr("subTableName"));
	if($("#conditionContainMaster",row).val()=="0"){//条件中含有重复表表字段
		$(".addSlaveRow",row).attr("disabled",true);
	}else{
		$(".addSlaveRow",row).removeAttr("disabled");
	}
	$(".addSlaveRow",row).prop("checked",false);
	$(".withholding",row).prop("checked",false);
	withHoldingClick($(".withholding",row)[0]);
	addSlaveRow($(".addSlaveRow",row)[0]);
}
function OK(d){
	if($(".echoSetting","#newEchoSettingContainer").length>1){
		if(!echosetValidate()){
			return "error";
		}
	}else{
		if($(".refColumNames","#newEchoSettingContainer").length>1){
			if(!echosetValidate()){
				return "error";
			}
		}else if($(".refColumNames","#newEchoSettingContainer").length==1){
			if($(".refColumNames","#newEchoSettingContainer").eq(0).val()!=""){
				if(!echosetValidate()){
					return "error";
				}
			}
		}
	}
	if(!checkAddSlaveData()){
		return "error";
	}
	if(!checkFormulaAndCondition()){
		return "error";
	}
	var param = $("#newEchoSettingContainer").formobj({domains:['echoSetting','refColumTable'],validate:false,matchClass:true,isGrid:true});
	var o = new formTriggerDesignManager();
	var errorMsg = o.saveOrUpdateFillBackSet(param);
	if(errorMsg){
	    $.alert(errorMsg);
	    return "error";
	}
	return "success";
}

function echosetValidate(){
	var result = true;
	$(".refColumNames","#newEchoSettingContainer").each(function(){
		if($(this).val()==""){
			$.alert("${ctp:i18n('form.echoSetting.need.field')}");
			result = false;
			return false;
		}
	});
	if(result == true){
		$(".calcExpression","#newEchoSettingContainer").each(function(){
			if($(this).val()==""){
				$.alert("${ctp:i18n('form.echoSetting.need.fieldvalue')}");
				result = false;
				return false;
			}
		});
	}
	return result;
}

function checkFormulaAndCondition(){
  var result = true;
  $(".echoSetting","#newEchoSettingContainer").each(function(){
    $("#rowcondition",$(this)).each(function(){
      setCurrentRow(this);
      if (!preCheck(currentRow,$("#calcField",currentRow).val(),$("#rowcondition",currentRow).val())){
        result = false;
        currentRow.css("border","1px solid red");
        return false;
      } else {
        currentRow.css("border","0px");
      }
    });
    if (!result){
      return false;
    }
  });
  return result;
}

function checkAddSlaveData(){
	var addSlaveError = "";
	$(".echoSetting","#newEchoSettingContainer").each(function(index){//判断选择添加重复表行的情况下 不允许回写两个不同重复表的字段，并且不允许没有重复表字段
		if($(".addSlaveRow",$(this)).is(":checked")){
			var slaveTableName = "";//回写的重表名称
			$(".refColumNames",$(this)).each(function(){
				var optionObj = $(":selected",$(this));
				if(optionObj.attr("isMaster")=="false"){
					if(slaveTableName!=optionObj.attr("tableName")){
						if(slaveTableName==""){
							slaveTableName=optionObj.attr("tableName");
						}else{
							addSlaveError = addSlaveError + $.i18n('form.echoSetting.repeat.msg1',index+1,optionObj.text());
							return false;
						}
					}
				}
			});
			if(slaveTableName == ""){
				addSlaveError = addSlaveError + $.i18n('form.echoSetting.repeat.msg2',index+1);
				return false;
			}
		}
	});
	if(addSlaveError!=""){
		$.alert(addSlaveError);
		return false;
	}
	return true;
}
</script>
</html>