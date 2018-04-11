<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<script type="text/javascript">
//单据id
var formAppId = "";
//应用类型： 表单
var appName = "form";
var tableType = "main";
//当前选中的绑定框
var selectObj;
//隐藏的存放绑定表单id的框
var hiddenSelectObj;
//需要更新的对应人员的表单字段
var updateMemberField;
//默认选项，更新人员时没有必填项，也可以删除
var isGroupVer = false;
var codeMap = {};

$().ready(function(){
	isGroupVer = ${isGroupVer};
	codeMap['name']='text';
	codeMap['loginName']='text';
	codeMap['accountId']='account';
	codeMap['departmentId']='department';
	codeMap['postId']='post';
	codeMap['levelId']='level';
	
	codeMap['code']='text';
	codeMap['sortId']='decimal'; 
	codeMap['telNumber']='text'; 
	codeMap['birthday']='date'; 
	codeMap['officeNum']='text'; 
	codeMap['hiredate']='date'; 
	codeMap['reporter']='member'; 
	codeMap['description']='text,textarea,longtext'; 
	for(i=1;i<=10;i++){
		codeMap['EXT_ATTR_'+i]='text'; 
	}
	
	for(i=11;i<=20;i++){
		codeMap['EXT_ATTR_'+i]='decimal'; 
	}
	
	for(i=21;i<=30;i++){
		codeMap['EXT_ATTR_'+i]='date'; 
	}
	
	formAppId = "${formId}";
	var oldFillBackValue ="${oldFillBackValue}";
	updateMemberField ="${updateMemberField}"
	//用于复制的tr
 	var cacheTr = $("tr[class='clone']").clone(true);
	$("body").data("cloneMemberCondition",cacheTr);

	if(oldFillBackValue ==='' || oldFillBackValue == null){
	   reset();
	}else{
    	fillForm(oldFillBackValue);
    	initBtnClick();
	}
	
	
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
		//自定义的字段
		var mN = mId+"|";  //可选字段的select option 的值  ： code|
		
       if(codeMap.hasOwnProperty(mId)){
              type = codeMap[mId];
  		}
		
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
		 	var tr = $("body").data("cloneMemberCondition").clone(true);
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
	  alert("${ctp:i18n('form.trigger.triggerSet.member.nodelete')}");
	 }
}

/**
 *图标设置添加图标事项，添加一个重复项
 */
function addField(obj){
 	var tr = $("body").data("cloneMemberCondition").clone(true);
	$(obj).parents("tr:eq(0)").after(tr);
	initBtnClick();
}

/**
 * 重置按钮
 */
function reset(){
	//清空字段的值
 	$('input').val(""); 
	//删除可选字段
	$("tr[name='selectTr']").remove();		
    //添加默认的选项
     initField("name","text","name|");
     initField("loginName","text","loginName|");
     initField("accountId","account","accountId|");
     initField("departmentId","department","departmentId|");
     initField("postId","post","postId|");
     initField("levelId","level","levelId|");

     //添加默认的空行
    var tr = $("body").data("cloneMemberCondition").clone(true);
    $("#bottomTr").before(tr);
    initBtnClick();
}

function initField(mId,type,mN){
    var tr = $("body").data("cloneMemberCondition").clone(true);
    $("#bottomTr").before(tr);
    $(tr).find("input:eq(0)").val("");
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
    $(hiddenInput).val("");
    $(hiddenInput).attr("id",mId);
    initBtnClick();
}
	

/* 
*绑定元素
*/
function bindFormField(inputId,fieldType,obj){
	if(inputId==='') return;
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
			$.alert("${ctp:i18n('form.trigger.triggerSet.member.check.1')}");
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
    	var resultStr = "";
       	
     	var hiddenInputs =  $("input[name='hiddenInput']");
	 	for(j=0;j<hiddenInputs.length;j++){
	 		var obj=hiddenInputs[j];
	 		var id = obj.id;
			var value = obj.value;
		 	if(value!=''){
		 	  if(resultStr === ""){
		 	    resultStr = id+"|"+value;
		 	  }else{
		 	    resultStr = resultStr +","+id+"|"+value;
		 	  }
			};
	 	}
	 	//最后，把更新人员的表单控件属性也加进去  updateMember|field001|member|isUpdateField|姓名
	 	result[0]=resultStr+","+updateMemberField;
        return result;  
	}
 	return false;
    	
}
   
/**
 * 校验表单内容是否填写正确
 *1.是否选择的项都绑定了表单对象
 */
function validate(){
	var valid = true;
 	var hiddenInputs =  $("input[name='hiddenInput']");
 	for(i=0;i<hiddenInputs.length;i++){
 		var obj=hiddenInputs[i];
		var value = obj.value;
	 	if(value===''){
			$.alert("${ctp:i18n('form.trigger.triggerSet.member.check.2')}");
			valid = false;
			break;
		};
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
		<fieldset height="100%" ><legend >${ctp:i18n('form.trigger.triggerSet.member.copy')}</legend>
		<table width="90%" border=0 align="center"  style="border-bottom:solid 2px #333333;height: 10px;">
			<tr height="20">
				<td class="bg-gray" width="40%" nowrap="nowrap" align ="center">
					<label for="name"> ${ctp:i18n('form.trigger.triggerSet.member.personnelAttributes')}</label>							
				</td>
				<td class="bg-gray" width="60%" nowrap="nowrap" align ="center">
					<label for="name"> ${ctp:i18n('form.trigger.triggerSet.member.currentForm')}</label>							
				</td>
			</tr>		
		</table>
		<div style="height: 10px"></div>
		<!-- 默认字段 -->
		<div style="height: 350px;overflow-y:scroll">
		<table id="formTable" width="90%" id="fieldAreaContent"  cellspacing="0" cellpadding="0" align="center">
        <!--此处初始化页面的时候，动态添加默认选项  --> 
            
        <!--  -->
        
		  <tr height="10" name="selectTr" class="clone">
            <td class="new-column" width="50%" nowrap="nowrap" align ="left" >
				<div class="w100b">
					<select class="w100b" onchange="changeBindInput(this);" id="selectOption">
					  <option value="" displayName=""></option>
                        <option value="name|text" displayName="${ctp:i18n('form.trigger.triggerSet.member.name')}">${ctp:i18n('form.trigger.triggerSet.member.name')}</option>
                        <option value="loginName|text" displayName="${ctp:i18n('form.trigger.triggerSet.member.loginName')}">${ctp:i18n('form.trigger.triggerSet.member.loginName')}</option>
                        <c:if test="${isGroupVer == 'true' || isGroupVer == true}">
                           <option value="accountId|account" displayName="${ctp:i18n('form.trigger.triggerSet.member.subordinateUnit')}">${ctp:i18n('form.trigger.triggerSet.member.subordinateUnit')}</option>
                        </c:if>
                        <option value="departmentId|department" displayName="${ctp:i18n('form.trigger.triggerSet.member.subordinatedepartment')}">${ctp:i18n('form.trigger.triggerSet.member.subordinatedepartment')}</option>
                        <option value="postId|post" displayName="${ctp:i18n('form.trigger.triggerSet.member.primaryPost')}">${ctp:i18n('form.trigger.triggerSet.member.primaryPost')}</option>
                        <option value="levelId|level" displayName="${ctp:i18n('form.trigger.triggerSet.member.level')}">${ctp:i18n('form.trigger.triggerSet.member.level')}</option>
					  <option value="code|text" displayName="${ctp:i18n('form.trigger.triggerSet.member.code')}">${ctp:i18n('form.trigger.triggerSet.member.code')}</option>
					  <option value="sortId|decimal" displayName="${ctp:i18n('form.trigger.triggerSet.member.sortId')}">${ctp:i18n('form.trigger.triggerSet.member.sortId')}</option>
					  <option value="telNumber|text" displayName="${ctp:i18n('form.trigger.triggerSet.member.mobilePhone')}">${ctp:i18n('form.trigger.triggerSet.member.mobilePhone')}</option>
					  <option value="birthday|date" displayName="${ctp:i18n('form.trigger.triggerSet.member.birthday')}">${ctp:i18n('form.trigger.triggerSet.member.birthday')}</option>
					  <option value="officeNum|text" displayName="${ctp:i18n('form.trigger.triggerSet.member.officePhone')}">${ctp:i18n('form.trigger.triggerSet.member.officePhone')}</option>
					  <option value="hiredate|date" displayName="${ctp:i18n('form.trigger.triggerSet.member.inductionTime')}">${ctp:i18n('form.trigger.triggerSet.member.inductionTime')}</option>
					  <option value="reporter|member" displayName="${ctp:i18n('form.trigger.triggerSet.member.reporter')}">${ctp:i18n('form.trigger.triggerSet.member.reporter')}</option>
		              <c:forEach items="${customFieldList}" var="obj" varStatus="status">
					  		<option value="${obj.description}" displayName="${obj.label}">${obj.label}</option>
					  </c:forEach>  
					  <option value="description|text,textarea,longtext" displayName="${ctp:i18n('form.trigger.triggerSet.member.Remarks')}">${ctp:i18n('form.trigger.triggerSet.member.Remarks')}</option>
					  <option value="enable|radio,select" displayName="${ctp:i18n('form.trigger.triggerSet.member.AccountStatus')}">${ctp:i18n('form.trigger.triggerSet.member.AccountStatus')}</option>
					  <option value="agent|member" displayName="${ctp:i18n('form.trigger.triggerSet.member.todo')}">${ctp:i18n('form.trigger.triggerSet.member.todo')}</option>
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
		<a class="common_button common_button_gray margin_l_5" href="javascript:reset();" id="updateMember">${ctp:i18n('form.trigger.triggerSet.member.reset')}</a>
		</td>
	</tr>
</table>
</body>
</html>