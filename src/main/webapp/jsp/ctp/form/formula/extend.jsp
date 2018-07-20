
<%--
 $Author: wangfeng $
 $Rev: 261 $
 $Date:: 2013-3-17 14:00:30#$:
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums"%>
<%@ page import="com.seeyon.ctp.form.bean.*"%>
<%@page import="com.seeyon.ctp.form.util.Enums.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>extend设置界面</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
<!--  设置了表单关联的外部写入字段并有千分号、百分位显示的设置可以使用extend，但是会报错，需要引入form.js中一系列该类型字段有关的方法 -->
<script type="text/javascript" src="${path}/common/content/form.js"></script>
<script type="text/javascript" src="${path}/apps_res/govdoc/js/govdoc_mark.js"></script>
  
<script type="text/javascript">
var enumSplitStr = "<%=FormFormulaBean.enumSplitStr%>";
function OK(){
	var str =  $("#field1Name").val() + " "+$("#operation").val();
  if($("#radio1").attr("checked")){
	  //普通复选框控件
	  if($("#valueDiv1").find("input[type=checkbox]").length==1){
		  //普通复选框，选中返回 1，没选中返回 0
		  var value = ($("#valueDiv1").find("input[type=checkbox]").prop("checked") ? 1 : 0 );
		  str = str+"'"+value+"'";
	  }//如果是多选状态    如审核状态、核定状态、流程状态 则返回or关系的多个条件如  “{流程状态} =0 or {流程状态} =1”
	  else if($("#valueDiv1").find("input[type=checkbox]").length>1){
		  var baseStr = str;
		  str = "";
		  $("#valueDiv1").find("input[type=checkbox]").each(function(){
					if($(this).prop('checked')){
						var tempStr = baseStr + $(this).val();
						if(str != ''){
							tempStr = " or "+tempStr;
						}
						str += tempStr;
					}
			  });
	  }else{
	      var isEnum = false;
		  var v ="";
		  var enumId = ${field.enumId};
		  var formatEnumId= ${field.formatEnumId};
		  var rformatEnumId= ${realField.formatEnumId}; 
		  var fieldName;
		  
		  if($("#valueDiv1").find("[mappingField=doc_mark]") && $("#valueDiv1").find("[mappingField=doc_mark]").attr("id")) {
			  fieldName = $("#valueDiv1").find("[mappingField=doc_mark]").attr("id");
			  
              v = $("#" + fieldName + "_txt").val();
		  } else if($("#valueDiv1").find("[mappingField=serial_no]") && $("#valueDiv1").find("[mappingField=serial_no]").attr("id")) {
			  fieldName = $("#valueDiv1").find("[mappingField=serial_no]").attr("id");
              
              v = $("#" + fieldName + "_txt").val();
              
              
		  } else {
			  if($("#valueDiv1").find("input[type=hidden]").attr("id")==null){
				  if($("#valueDiv1").find("input:radio").length > 0){//单选			  
					  var id = $("#valueDiv1").find("input:radio:checked").val();	
					  var name = $("#valueDiv1").find("input:radio:checked").parent().text();
					  v = id==null?null:(id+enumSplitStr+name+enumSplitStr);
					  isEnum = true;
				  }else if($("#valueDiv1").find("select").length > 0){//下拉	   
					  if($.trim($("#valueDiv1").find("select option:selected").text())==""){   	
				      	  v = null;
					  }else{
						  v = $("#valueDiv1").find("select").val()+enumSplitStr+$("#valueDiv1").find("select option:selected").text()+enumSplitStr;
					  }
					  isEnum = true;
				  }else if(((enumId&& enumId !=0) || (formatEnumId && formatEnumId != 0)||(rformatEnumId && rformatEnumId != 0)) && $("#valueDiv1").find("input[type=text]")){
				      if(!$("#valueDiv1").find("input[type=hidden]").val()){
				          v = null;
				      }else{
				          v = $("#valueDiv1").find("input[type=hidden]").val()+enumSplitStr+$("#valueDiv1").find("input[type=text]").val()+enumSplitStr;
				      }
				      isEnum = true;
				  }else if($("#valueDiv1").find("textarea").length > 0){//文本域  
					  v = $("#valueDiv1").find("textarea").val();
				  }else{
					  v = $("#valueDiv1").find("input").val();
				  }
			  }else{//如果有隐藏区域的，证明是ID单元格，需要取ID
				  v = $("#valueDiv1").find("input[type=hidden]").val();
				  fieldName = $("#valueDiv1").find("input[type=hidden]").attr("id");
				  
				  var fieldVal = $("#"+fieldName+"_span").attr("fieldVal");
				  fieldVal = $.parseJSON(fieldVal);
				  
	              var fieldType = fieldVal.inputType;
	              if(v.indexOf("|")>=0 && fieldType != ""){//如果是组织机构类的控件，值是用|分割开的
	            	  var orgId = v.substring(v.indexOf("|")+1);
	                  var vs = v.split(",");
	                  var orgName = $("#"+ fieldName+"_txt").val();
	                  var orgNames = orgName.split("、");
	                  var vstr="";
	                  for(var i=0;i < vs.length;i++){
	                  	 vstr += vs[i].substring(vs[i].indexOf("|")+1)+enumSplitStr+orgNames[i]+enumSplitStr;
						if(i != vs.length - 1){
							vstr =vstr+",";
						}
	                  }
	                  v = vstr;
	              } else if (fieldType == "project"){//关联项目也需要按照组织机构处理
					  if (v){
						  var projectName = $("#"+fieldName+"_txt").val();
						  v = v+enumSplitStr+projectName+enumSplitStr;
					  }
	              }
			  }
		  }
		  //判断是都需要将值转成字符串
		  if((isEnum || needToStr())&&v!=null){
			  v = " '"+v+"'";
		  }
		  v = getValue($("#field1Name"),v);
		  str = str + " "+v+"";
	  	  if (isEnum){
		  	  var strs = str.split(" ");
		  	  str = "compareEnumValue("+strs[0] + ","+strs[1]+"," +v+")";
	  	  }
	  	  if ($("#operation").val() == "include"){
		  	  if(v != null){
		  	    str = "include("+$("#field1Name").val() + "," +v+")";
		  	  }else{
		  	    str = $("#field1Name").val() + "=" +v;
		  	  }
	  	  }
	  }
  }else if($("#radio2").attr("checked")){
      var field = $("#valueDiv2").find("option:selected");
      var v = getValue(field, field.val());
	  str = str + " " + v + "";
	  
	  if ($("#operation").val() == "include"){
          if(v != null){
              str = "include(" + $("#field1Name").val() + "," + v + ")";
          }else{
              str = $("#field1Name").val() + "=" + v;
          }
      }
  }
  return str;
}
function isDocMark(obj){
	obj=$(obj);
	if(obj.attr("comp")){
		var compObj=eval("({"+obj.attr("comp")+"})");
		return compObj&&compObj.type=="chooseMark";
	}
}
//处理值
function getValue(field, v){
	var ret=v;
	if(ret==null||$.trim(ret)==""||$.trim(ret)=="''"){return null;}
	//日期时间的要做to_date函数处理
	if(field.attr("fieldType")=="<%=FieldType.TIMESTAMP.getKey()%>"||field.attr("fieldType")=="<%=FieldType.DATETIME.getKey()%>"){
		ret = "to_date("+v+")";
	}
	return ret;
}
//根据当前字段的类型，判断是否需要将返回的值专为字符串。
function needToStr(){
	//数字类型文本框    不需要
	if($("#field1Name").attr("fieldType")=="DECIMAL"&&$("#field1Name").attr("inputType")!="select"&&$("#field1Name").attr("inputType")!="radio"){
		return false;
	}
	return true;
}

function init(){
    var inputType = '${field.realInputType}'; 
    var formatEnumId= ${field.formatEnumId}; 
    var formatEnumIsFinalChild= ${field.formatEnumIsFinalChild}; 
    var rinputType = '${realField.realInputType}'; 
    var rformatEnumId= ${realField.formatEnumId}; 
    var rformatEnumIsFinalChild= ${realField.formatEnumIsFinalChild}; 
    if(inputType === 'select' || (inputType ==='outwrite' && (formatEnumId !=0 || formatEnumIsFinalChild==true))
            ||rinputType=== 'select' || (rinputType ==='outwrite' && (rformatEnumId !=0 || rformatEnumIsFinalChild==true))){
        $("#valueDiv1").find("input[type=text]").width($("#valueDiv1").width()-13);
    }
    
    var filterFields = "${param.filterFields}";
    if (filterFields) {
        $("#valueDiv2").find("option[name='" + filterFields + "']").remove();
    }
    
    $("#operation").focus();
    $("#valueDiv1").find("textarea").css("width","200px");
    
    formLoadCallback("extend");
}
//如果是关联项目类型 后台获取的HTML字符串中定义了使用回调函数，此处定义一个空函数作为回调。
function chooseProjectCallBack(){}
//外部写入显示格式是枚举,需要客户手工选择枚举后才能显示值
function selectEnums(rootEnumId,enumLevel){
	var obj = new Array();
	obj[0] = window;
	var isfinal = false;
	var urlStr = '';
	if(rootEnumId){
	    isfinal=0;
	    urlStr = "${path}/enum.do?method=bindEnum&isFinalChild=false&bindId=0&isBind=false&rootEnumId="+rootEnumId+"&enumLevel="+enumLevel+"&isfinal="+isfinal;
	}else{
	    urlStr = "${path}/enum.do?method=bindEnum&isFinalChild=false&bindId=0&isBind=false&isfinal="+isfinal;
	}
	var dialog = $.dialog({
			url:urlStr,
		    title : '${ctp:i18n("form.field.bindenum.title.label")}',
		    width:500,
		    height:520,
		    targetWindow:getCtpTop(),
		    transParams:obj,
		    buttons : [{
		      text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
		      id:"sure",
		      handler : function() {
			      var result = dialog.getReturnValue();
			      if(result){
			        if(rootEnumId){
			            var html = $("#valueDiv1").html();
                        html = html+"<input type='hidden'  value='"+result.enumId+"'>";
                        $("#valueDiv1").html(html);
			            $("#valueDiv1").find("input[type=text]").val(result.enumName);
			        }else{
			            var fMgr = new formManager();
	                    var html = fMgr.getFieldHTML4Select(result.enumId,result.isFinalChild==null?false:result.isFinalChild,result.nodeType);
	                    html = "<input type='text' style='width:50%' value='"+result.enumName+"' onclick='selectEnums()'>"+html;
	                    $("#valueDiv1").html(html);
	                    $("#field").css('width','50%');
			        }
			    	dialog.close();
			      }
		      }
		    }, {
		      text : "${ctp:i18n('form.query.cancel.label')}",
		      id:"exit",
		      handler : function() {
		    	  returnObj = false;
		          dialog.close();
		      }
		    }]
	});
}

function setDisabled(id){
  $(".fieldvalue").prop("disabled",true);
  $("#" + id).prop("disabled",false);
}
</script>
<style type="text/css">
.common_txtbox_wrap .radio_com{
	width:15px;
	height:15px;
	margin:3px;
}
</style>
</head>
<BODY scroll=yes onload="init()">
    <form name="formulaDateDiffer" method="post">
        <div class="form_area">
            <div class="clearfix margin_t_5">
                <div id = "field1Label" class="left" style="width: 110px;text-align: right;">${ctp:i18n('form.formula.engin.formdata.label')}：</div>
                <div class="left common_txtbox_wrap" style="width: 200px;">
                    <input id="field1Name" value="${fieldDisplay}" fieldType="${field.fieldType}" inputType="${field.inputType}" type="text" readOnly style="width: 200px;">
                </div>
            </div>
            <div class="clearfix margin_t_5">
                <div id = "operatorLabel" class="left" style="width: 110px;text-align: right;">${ctp:i18n('form.formula.engin.operator.label')}：</div>
                <div class="left" style="width: 212px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_selectbox_wrap">
                        	<select id=operation name="operation">
                        	    <c:if test="${field.fieldType eq 'TIMESTAMP' || field.fieldType eq 'DATETIME' || field.fieldType eq 'DECIMAL' && field.name ne 'start_member_id' && field.name ne 'modify_member_id' && field.name ne 'state' && field.name ne 'ratifyflag' && field.name ne 'finishedflag'}">
                        		<option value=">">&gt;</option>
                        		<option value=">=">&gt;=</option>
                        		<option value="<">&lt;</option>
                        		<option value="<=">&lt;=</option>
                        	    </c:if>	
                        		<option selected value="=">=</option>
                        		<c:if test="${field.name ne 'state' && field.name ne 'ratifyflag' && field.name ne 'finishedflag' }">
                        			<option value="<>">&lt;&gt;</option>
                        		</c:if>
                                <c:if test="${showInclude}">
                                    <option value="include">include</option>
                                </c:if>
                        	</select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clearfix margin_t_5">
                <div id = "operatorLabel" class="left hand" style="width: 110px;text-align: right;line-height:22px;">
                    <label class="right" for="radio1">${ctp:i18n('form.formula.engin.value.label')}： </label>
                    <input id="radio1" class="radio_com" name="inputType" value="1" type="radio" checked onclick="setDisabled('valueDiv1')">
                </div>
                <div class="left fieldvalue" id="valueDiv1">${html}</div>
            </div>
        </div>
        <c:if test="${otherForm ne null}">
        <div id="otherField_div" class="clearfix margin_t_5">
            <div class="left font_size12" style="width: 110px;text-align: right;">
                <label class="hand" for="radio2">
                    <input type="radio" id="radio2" name="inputType" class="radio_com" value="2" onclick="setDisabled('valueDiv2')">a.${ctp:i18n('form.formula.engin.formdata.label')}：
                </label>
            </div>
            <div class="left" style="width: 212px;">
                <select class="fieldvalue" id="valueDiv2" name="valueDiv2" style="width: 212px;" disabled>
                <c:forEach items="${fieldList}" var="obj" varStatus="status">
                    <option id="${obj['id']}" name="${obj['name']}" value="{<%=FormBean.M_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}]</c:if>${obj['display']}</option>
                </c:forEach>
                </select>
            </div>
        </div>
        </c:if>
     </form>
</BODY>
</HTML>