<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<script type="text/javascript">
//单据id
var formAppId = "";
//应用类型： 表单
var appName = "form";
//当前选中的绑定框
var selectObj;
//隐藏的存放绑定表单id的框
var hiddenSelectObj;
//必填项
var orgStr = "createUser,title,emceeId,beginDate,endDate,conferees";
var isGroupVer = false;
var codeMap = {};
var orgArray = new Array();

$().ready(function(){

	orgArray = orgStr.split(",");
	
	codeMap['meetingPlace']='text';
	codeMap['recorderId']='member'; 
	codeMap['impart']='member,multimember,department,multidepartment,account,multiaccount,post,multipost,level,multilevel'; 
	codeMap['projectId']='project'; 
	codeMap['isHasAtt']='attachment';
	codeMap['content'] ='text';
	codeMap['mtTitle']='text'; 
	codeMap['leader']='member,multimember'; 
	codeMap['attender']='text'; 
	codeMap['tel']='text'; 
	codeMap['notice']='text'; 
	codeMap['plan']='text'; 
	
	formAppId = "${formId}";
	var oldFillBackValue ="${oldFillBackValue}";
 	var cacheTr = $("tr[name='selectTr']").clone(true);
	$("body").data("cloneMeetingCondition",cacheTr);
	fillForm(oldFillBackValue);
	initBtnClick();
	
});

/**
 * 回填数据
 */
function fillForm(oldFillBackValue){
	var oldFillBackValueArr = oldFillBackValue.split(',');
	var j=0;
	for(i=0;i<oldFillBackValueArr.length;i++){
		var o = oldFillBackValueArr[i].split('|');
		var mId = o[0];    //人员属性字段  name                      
		if(!isGroupVer && mId=='accountId'){continue;}
		
		var fbId = o[1];   //表单字段名称  field001
		var type = o[2];   //表单字段类型  text
		var display = o[3];//表单字段对应的显示名称
		if(orgStr.indexOf(mId)>=0){
			//必填字段
			var hiddenInput = $("#"+mId);
			$(hiddenInput).val(fbId);
			var input_ = eval("$(\"input[name='"+mId+"']\")");
			$(input_).val(display);
		}else{
			//自定义的字段
			var mN = mId+"|";  //可选字段的select option 的值  ： code|
			
		     if(codeMap.hasOwnProperty(mId)){
		            type = codeMap[mId];
				}
			
			//可选字段
			//第一个可选属性，数据直接回填到表单
			if(j==0){
				var tr = $("tr[name='selectTr']");
			 	$(tr).find("input:eq(0)").val(display);
			 	$(tr).find("input:eq(0)").unbind('click');
			 	
			  (function(arg,arg0){
			 	$(tr).find("input:eq(0)").unbind('click').click(function(){
					bindFormField(arg,arg0,this);
	   	    	})}(mId,type));  
	   	    
			 	$(tr).find("#selectOption option").each(function(){
			        $this = $(this).val();
			        if($this.indexOf(mN)==0){
			           $(this).attr('selected',true);
			        }
			     });

			 	var hiddenInput=$(tr).find("input:eq(1)");
			 	$(hiddenInput).val(fbId);
			 	$(hiddenInput).attr("id",mId);
			 	j++;
			}else{
				//从第二个可选属性开始，先添加tr，再赋值
			 	var tr = $("body").data("cloneMeetingCondition").clone(true);
				$("#bottomTr").before(tr);
			 	$(tr).find("input:eq(0)").val(display);
			 	$(tr).find("input:eq(0)").unbind('click');
			    
				  (function(arg,arg0){
					 	$(tr).find("input:eq(0)").unbind('click').click(function(){
							bindFormField(arg,arg0,this);
			   	    	})}(mId,type));  
			    
			 	$(tr).find("#selectOption option").each(function(){
			        $this = $(this).val();
			        if($this.indexOf(mN)==0){
			           $(this).attr('selected',true);
			        }
			     });

			 	var hiddenInput=$(tr).find("input:eq(1)");
			 	$(hiddenInput).val(fbId);
			 	$(hiddenInput).attr("id",mId);
				initBtnClick();
			}
			
		}
	}
	
}

//初始化图表设置的2个按钮
function initBtnClick(){
  //图标设置重复项删除图标
  $("span[name='delField']").unbind('click').click(function(){
      delField($(this));
  });
  //图标设置重复项添加图标
  $("span[name='addField']").unbind('click').click(function(){
      addField($(this));
  });
}
  
/**
 *图标设置删除图标事项，删除一个重复项
 */
function delField(obj){
	 var trs =  $("tr[name='selectTr']");
	 if(trs.length>1){
		 obj.parents("tr:eq(0)").remove();
	 }else{
	  alert("${ctp:i18n('mt.cm.label.cantdel')}");
	 }
}

/**
 *图标设置添加图标事项，添加一个重复项
 */
function addField(obj){
 	var tr = $("body").data("cloneMeetingCondition").clone(true);
	$(obj).parents("tr:eq(0)").after(tr);
	initBtnClick();
}

/**
 * 重置按钮
 */
function reset(){
	//清空字段的值
 	$('input').val(""); 
	
	//删除所有可选字段
	$("tr[name='selectTr']").remove();		
    var tr = $("body").data("cloneMeetingCondition").clone(true);
	$("#lastTr").after(tr);
	initBtnClick();
}
	

/* 
*绑定元素
*/
function bindFormField(inputId,fieldType,obj){
	if(inputId==='') return;
	var tableType = "main";
  	$.selectStructuredDocFileds({'appName':appName,'formAppId':formAppId,'fieldType':fieldType,'tableType':tableType,'onOk':onOk});
  	selectObj = obj;
  	hiddenSelectObj = $("#"+inputId);
}
   
/**
 * 绑定元素后的返回方法
 */
function onOk(v){
	if(v && v.fieldDbName && v.fieldDisplayName){
		var fieldDbName = v.fieldDbName;
		var fieldDisplayName = v.fieldDisplayName;
		selectObj.value=fieldDisplayName;
		hiddenSelectObj.val(fieldDbName);
	}
}
    
/**
 * 重新选择人员属性后
 */
function changeBindInput(obj){
	//删掉绑定事件和绑定内容
	//展示的名称
	var input = $(obj).parents("tr:eq(0)").find("input:eq(0)");
	input.unbind('click');
	input.val("");
	//隐藏的表单filedId
	var hiddenInput = $(obj).parents("tr:eq(0)").find("input:eq(1)");
	hiddenInput.val("");
	hiddenInput.attr("id","");
	//重新添加绑定事件
	var inputInfo = obj.value;
	if(inputInfo ==='') return;
	var inputInfos = inputInfo.split("|");
	var inputId = inputInfos[0];
	var fieldType = inputInfos[1];
	
	 /* 校验是否有重复选择的项 */
 	var hiddenInputs =  $("input[name='hiddenInput']");
 	for(i=0;i<hiddenInputs.length;i++){
 		var o=hiddenInputs[i];
		var id = o.id;
		if(id==='') continue;
		if(id==inputId){
			$.alert("${ctp:i18n('mt.cm.label.already')}");
			obj.value="";
			return;
		}
 	}
 	
	hiddenInput.attr("id",inputId);
	input.unbind('click').click(function(){
		bindFormField(inputId,fieldType,this);
    });
}
    
/**
 *返回事件
 */
function OK(){
 	if(validate()){
        var result = new Array();
    	//固定字段
    	var i=0;
    	var resultStr = "";
       	for(i=0;i<orgArray.length;i++){
    		var id = orgArray[i];
    		var fieldDbName = $("#"+id).val();
    		if(i==0){
    			resultStr = id+"|"+fieldDbName;
    		}else{
    			resultStr = resultStr +","+id+"|"+fieldDbName;
    		}
    	}
       	
     	var hiddenInputs =  $("input[name='hiddenInput']");
	 	for(j=0;j<hiddenInputs.length;j++){
	 		var obj=hiddenInputs[j];
	 		var id = obj.id;
			var value = obj.value;
		 	if(value!=''){
		 		resultStr = resultStr +","+id+"|"+value;
			};
	 	}
	 	result[0]=resultStr;
        return result;  
	}
 	return false;
    	
}
   
/**
 * 校验表单内容是否填写正确
 *1.是否选择的项都绑定了表单对象
 */
function validate(){
	//固定字段
   	for(i=0;i<orgArray.length;i++){
		var id = orgArray[i];
		if($("#"+id).val()===''){
			$.alert("${ctp:i18n('mt.cm.label.cantnull')}");
			return false;
		}
	}   
  	
	//可选字段  
	var valid = true;
 	var hiddenInputs =  $("input[name='hiddenInput']");
	if(hiddenInputs.length==1){
		var selectOption = $("#selectOption");
		var selectValue = selectOption.val();
		if(selectValue!=''){
			if(hiddenInputs[0].value===''){
				$.alert("${ctp:i18n('mt.cm.label.cantnull')}");
				return false;
			}
		}
	}else{
	 	for(i=0;i<hiddenInputs.length;i++){
	 		var obj=hiddenInputs[i];
			var value = obj.value;
		 	if(value===''){
		 		$.alert("${ctp:i18n('mt.cm.label.cantnull')}");
				valid = false;
				break;
			};
	 	}
	}
	return valid;
}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body class="over_hidden font_size12">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr>
		<td valign="top">
		<fieldset height="100%" ><legend >${ctp:i18n('mt.cm.label.copy')}</legend>
		<table width="90%" border=0 align="center"  style="border-bottom:solid 2px #333333;height: 10px;">
			<tr height="20">
				<td class="bg-gray" width="40%" nowrap="nowrap" align ="center">
					<label for="name"> ${ctp:i18n('mt.cm.label.mtAttr')}</label>							
				</td>
				<td class="bg-gray" width="60%" nowrap="nowrap" align ="center">
					<label for="name"> ${ctp:i18n('mt.cm.label.ctForm')}</label>							
				</td>
			</tr>		
		</table>
		<div style="height: 10px"></div>
		<!-- 固定字段 -->
		<div style="height: 350px;overflow-y:scroll">
		<table id="formTable" width="90%" id="fieldAreaContent"  cellspacing="0" cellpadding="0" align="center">
			<tr height="10" >
				<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
					<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
						<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('mt.cm.label.csp')}</label>	
					</div>
				</td>
				<td class="new-column" width="270px" align ="left" colspan="3" >
					<input onclick="bindFormField('createUser','member',this);" readonly="readonly" name="createUser" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per"/>
					<input id="createUser" type="hidden" value=""/>
				</td>
			</tr>
			<tr height="10" >
				<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
					<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
						<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('mt.cm.label.mtname')}</label>	
					</div>
				</td>
				<td class="new-column" width="270px" align ="left" colspan="3" >
					<input onclick="bindFormField('title','text',this);" readonly="readonly" name="title" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per"/>
					<input id="title" type="hidden" value=""/>
				</td>
			</tr>
			<tr height="10" >
				<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
					<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
						<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('mt.cm.label.emcee')}</label>	
					</div>
				</td>
				<td class="new-column" width="270px" align ="left" colspan="3" >
					<input onclick="bindFormField('emceeId','member',this);" readonly="readonly" name="emceeId" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per"/>
					<input id ="emceeId" type="hidden" value=""/>
				</td>
			</tr>	
			
				<tr height="10" >
					<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
						<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
							<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('mt.cm.label.mtbgdate')}</label>	
						</div>
					</td>
					<td class="new-column" width="270px" align ="left" colspan="3" >
						<input onclick="bindFormField('beginDate','datetime',this);" readonly="readonly" name="beginDate" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per"/>
						<input id="beginDate" type="hidden" value=""/>
					</td>
				</tr>	
			
			<tr height="10" >
				<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
					<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
						<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('mt.cm.label.mteddate')}</label>	
					</div>
				</td>
				<td class="new-column" width="270px" align ="left" colspan="3" >
					<input onclick="bindFormField('endDate','datetime',this);" readonly="readonly"  name="endDate" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per"/>
					<input id="endDate" type="hidden" value=""/>
				</td>
			</tr>	
			<tr height="10" id="lastTr">
				<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
					<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
						<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('mt.cm.label.attendees')}</label>	
					</div>
				</td>
				<td class="new-column" width="270px" align ="left" colspan="3" >
					<input onclick="bindFormField('conferees','member,multimember,department,multidepartment,account,multiaccount,post,multipost,level,multilevel',this);" readonly="readonly"  name="conferees" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per"/>
					<input id="conferees" type="hidden" value=""/>
				</td>
			</tr>		

			<!--可选字段 -->		
			  <tr height="10" name="selectTr">
	            <td class="new-column" width="50%" nowrap="nowrap" align ="left" >
					<div class="w100b">
						<select class="w100b" onchange="changeBindInput(this);" id="selectOption">
						  <option value="" displayName=""></option>
						  <option value="meetingPlace|text" displayName="会议地点">${ctp:i18n('mt.cm.label.mtplace')}</option>
						  <option value="recorderId|member" displayName="记录人">${ctp:i18n('mt.cm.label.nottaker')}</option>
						  <option value="impart|member,multimember,department,multidepartment,account,multiaccount,post,multipost,level,multilevel" displayName="告知人员">${ctp:i18n('mt.cm.label.inform')}</option>
						  <c:if test="${ctp:hasPlugin('project')}">
							  <option value="projectId|project" displayName="所属项目">${ctp:i18n('mt.cm.label.project')}</option>
						  </c:if>
						  <option value="isHasAtt|attachment" displayName="附件">${ctp:i18n('mt.cm.label.attachment')}</option>
						  <option value="content|text,textarea" displayName="正文">${ctp:i18n('mt.cm.label.content')}</option>
						  <option value="mtTitle|text" displayName="会议主题">${ctp:i18n('mt.cm.label.theme')}</option>
						  <option value="leader|member,multimember" displayName="参会领导">${ctp:i18n('mt.cm.label.leader')}</option>
						  <option value="attender|text" displayName="参会嘉宾">${ctp:i18n('mt.cm.label.part')}</option>
						  <option value="tel|text" displayName="联系电话">${ctp:i18n('mt.cm.label.phone')}</option>
						  <option value="plan|text" displayName="会议议程">${ctp:i18n('mt.cm.label.agenda')}</option>
						  <option value="notice|text" displayName="注意事项">${ctp:i18n('mt.cm.label.notice')}</option>
						</select>
					</div>
				</td>
				<td class="new-column" align ="left">
					<input readonly="readonly" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per"/>
					<input type="hidden" value="" name="hiddenInput"/>
				</td>
				<td>
					<span class='ico16 repeater_reduce_16' name="delField"></span>
	         	</td>
	         	<td>
		            <span class='ico16 repeater_plus_16' name="addField"></span>
	         	</td>
         	</tr>	
         	<tr hidden="true" id="bottomTr"></tr>

	    </table>
		</div>
		</fieldset>	
		</td>
	</tr>
	<tr id="reset">
		<td height="42" align="left" class="bg-advance-bottom" >
		<a class="common_button common_button_gray margin_l_5" href="javascript:reset();" id="createMember">${ctp:i18n('mt.cm.label.reset')}</a>
		</td>
	</tr>
</table>
</body>
</html>