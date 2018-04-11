<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<style type="text/css" media="screen">
    #editor { 
		height:230px;width:400px
    }
</style>
<script type="text/javascript" src="${path}/common/ace/ace.js${ctp:resSuffix()}"/>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=formulaManager${ctp:resSuffix()}"></script>
<script type="text/javascript">
var gridObj;
var whichPage=0;//当前打开哪个页面 0啥也不是,1.变量,2.公式
var fManager=new formulaManager();
$().ready(function() {
    	$("#formulaform").hide();
    	$("#variableForm").hide();
    	$("#button").hide();
    	$(".assist").bind("click",assistfn);
    	//初始化toolbar
	    $("#toolbar").toolbar({
	    	toolbar : [{name : "${ctp:i18n('common.toolbar.new.label')}",className : "ico16 add",subMenu:[{name:"${ctp:i18n('ctp.formulas.newvariable')}",click:addVariable},{name:"${ctp:i18n('ctp.formulas.newformula')}",click:addFormula}]},
		    	{name : "${ctp:i18n('common.toolbar.edit.label')}",click : edit,className : "ico16 editor_16"}//,
		      	//{name : "${ctp:i18n('common.button.delete.label')}",className : "ico16 del_16",click : del}
		    	]
        });
		//查询事件绑定
	 	setSearch();
    	//初始化表格
        gridObj=$("#formulaTable").ajaxgrid({
        searchHTML : 'condition_box',
        colModel : [ {display : 'id',name : 'id',width : '5%',sortable : false,type : 'checkbox',isToggleHideShow:false},
        	{display : "${ctp:i18n('ctp.formulas.formulaName')}",name : 'formulaName',width : '10%',sortable : true,}, 
            {display : "${ctp:i18n('ctp.formulas.formulaAlias')}",name : 'formulaAlias',width : '10%',sortable : true}, 
            {display : "${ctp:i18n('ctp.formulas.description')}",name : 'description',width : '15%',sortable : false}, 
            {display : "${ctp:i18n('ctp.formulas.formulaType')}",name : 'formulaType',width : '10%',sortable : true,codecfg : "codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.FormulaType'"} , 
            {display : "${ctp:i18n('ctp.formulas.dataType')}",name : 'dataType',width : '10%',sortable : true, codecfg : "codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.DataType'"}, 
            {display : "${ctp:i18n('ctp.formulas.creator')}",name : 'creator',width : '10%',sortable : true},
            {display : "${ctp:i18n('ctp.formulas.category')}",name : 'category',width : '10%',sortable : true,codecfg : "codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.CATEGORY'"},
           // {display : "${ctp:i18n('ctp.formulas.templateNum')}",name : 'templateNum',width : '10%',sortable : false},
            {display : "${ctp:i18n('ctp.formulas.createTime')}",name : 'createTime',width : '10%',sortable : true}],
		managerName : "formulaManager",managerMethod : "showFormulaList",
        click :clk,
        dblclick :edit,
		parentId:"center",
	    vChange :true,
	    vChangeParam: {
	      	overflow: "hidden",
	        autoResize:true
	     },
		 slideToggleBtn: true
      });    
	    //加载表格
      var o = new Object();
      $("#formulaTable").ajaxgridLoad(o);

	  $("#btnok").click(function() {
		if(whichPage==1){
			if (!($("#addForm").validate())) {
				return;
			}
			
			if (getCtpTop() && getCtpTop().startProc) {
				getCtpTop().startProc();
			}
			fManager.saveFormula($("#addForm").formobj(), {
				success: function(v) {
					try {
						if (getCtpTop() && getCtpTop().endProc) {
							 getCtpTop().endProc();
						}
						location.reload();
					} catch(e) {};
				},
				error: function(v){
					try {
						if (getCtpTop() && getCtpTop().endProc) {
							 getCtpTop().endProc();
						}
						var responseText = JSON.parse(v.responseText);
						$.alert(responseText.message);
					} catch(e) {};
				}
			});
		}else{
			var editor = ace.edit("editor");
		 	$('#addFormulaForm #formulaExpression').val(editor.getValue());
			if (!($("#addFormulaForm").validate())) {
				return;
			}
		    if(null == $("#addFormulaForm #formulaName").val() || "" == $("#addFormulaForm #formulaName").val()){
	        	$.alert("${ctp:i18n('ctp.formulas.fnamenotnull')}");
	    		return;
	        }
		    if(null == $("#addFormulaForm #returnType").val() || "" == $("#addFormulaForm #returnType").val()){
	        	$.alert("${ctp:i18n('ctp.formulas.rTypenotnull')}");
	    		return;
	        }
		    if(null == $("#addFormulaForm #category").val() || "" == $("#addFormulaForm #category").val()){
	        	$.alert("${ctp:i18n('ctp.formulas.categorynotnull')}");
	    		return;
	        }
		    if(null == $("#addFormulaForm #formulaExpression").val() || "" == $("#addFormulaForm #formulaExpression").val()){
	        	$.alert("${ctp:i18n('ctp.formulas.formulaExpressionnotnull')}");
	    		return;
	        }
		    if(null == $("#addFormulaForm #sample").val() || "" == $("#addFormulaForm #sample").val()){
	        	$.alert("${ctp:i18n('ctp.formulas.formulaSamplenotnull')}");
	    		return;
	        }
		    if (getCtpTop() && getCtpTop().startProc) {
				getCtpTop().startProc();
			}
		    var paramJson = "";
		    var trList = $("#mobody").children("tr")
			for (var i=0;i<trList.length;i++) {
				  var tdArr = trList.eq(i).find("td");
		          var paramName = tdArr.eq(0).find("input").val();//参数名称
		          var paramType = tdArr.eq(1).find("select").val();//参数类型
		          var paramDescription = tdArr.eq(2).find("input").val();//参数描述
		          
		          if(null != paramName && null != paramType && "" != paramName && "" != paramType ){
		        	  if(i== trList.length -1){
		            	  paramJson+='{\"name\"' +":"+'\"'+paramName+'\"'+","+'\"type\"' +":"+'\"'+paramType+'\"'+","+'\"description\"' +":"+'\"'+paramDescription+'\"}';
		              }else{
		            	  paramJson+='{\"name\"' +":"+'\"'+paramName+'\"'+","+'\"type\"' +":"+'\"'+paramType+'\"'+","+'\"description\"' +":"+'\"'+paramDescription+'\"},';
		              }		  
		          }
			 }
		    $("#paramsJson").val('{\"paramsJson\"'+":["+paramJson+"]}");
		    var  jsonValid = validJsons($("#paramsJson").val());
		    if(jsonValid==false){
		    	$.alert("参数配置不正确请检查");
		    	return;
		    }
		    $("#addFormulaForm #dataType").val( $("#returnType").val());
			fManager.saveFormula($("#addFormulaForm").formobj(), {
				success: function(v) {
					try {
						if (getCtpTop() && getCtpTop().endProc) {
							 getCtpTop().endProc();
				        }
						location.reload();
					} catch(e) {};
				},
				error: function(v){
					try {
						if (getCtpTop() && getCtpTop().endProc) {
							 getCtpTop().endProc();
				        }
						var responseText = JSON.parse(v.responseText);
						if(responseText.message==null||""==responseText.message){
							$.alert("${ctp:i18n('ocx.alert.savefail.label')}");
						}else{
							$.alert(responseText.message);
						}
					} catch(e) {};
				}
			});
		}
	 });
	 $("#btncancel").click(function() {
		location.reload();
	 });
	 $("#check").click(function() {
		fManager.validate($("#addForm").formobj(),false, {
				success: function(v) {
					if(v==false){
						$("#formulaType").val(1);
					}else{
						$("#formulaType").val(0);
					}
					alert("${ctp:i18n('ctp.formulas.checksucess.true')}");
				},
				error: function(v){
						var responseText = JSON.parse(v.responseText);
						$.alert("${ctp:i18n('ctp.formulas.checksucess.false')}"+"<br/>"+responseText.message);
				
				}
			});
	 });
	 
	 $("#checkFormula").click(function() {
		 var editor = ace.edit("editor");
		 $('#addFormulaForm #formulaExpression').val(editor.getValue());	
		 var simple = $("#sample").val();	 
		 var formulaName =$("#addFormulaForm #formulaName").val();
	     if(null == $("#addFormulaForm #formulaExpression").val() || "" == $("#addFormulaForm #formulaExpression").val()){
        	$.alert("${ctp:i18n('ctp.formulas.formulaExpressionnotnull')}");
    		return;
         }
	     if(null == $("#addFormulaForm #sample").val() || "" == $("#addFormulaForm #sample").val()){
        	$.alert("${ctp:i18n('ctp.formulas.formulaSamplenotnull')}");
    		return;
         }
	     if(formulaName !== simple.substr(0,formulaName.length)){
			 alert("${ctp:i18n('ctp.formulas.simpleisnotup')}");
			 return;
		 }
		 var paramJson = "";
		 var trList = $("#mobody").children("tr")
	     for (var i=0;i<trList.length;i++) {
			  var tdArr = trList.eq(i).find("td");
	          var paramName = tdArr.eq(0).find("input").val();//参数名称
	          var paramType = tdArr.eq(1).find("select").val();//参数类型
	          var paramDescription = tdArr.eq(2).find("input").val();//参数描述
	          
	          if(null != paramName && null != paramType && "" != paramName && "" != paramType ){
	        	  if(i== trList.length -1){
	            	  paramJson+='{\"name\"' +":"+'\"'+paramName+'\"'+","+'\"type\"' +":"+'\"'+paramType+'\"'+","+'\"description\"' +":"+'\"'+paramDescription+'\"}';
	              }else{
	            	  paramJson+='{\"name\"' +":"+'\"'+paramName+'\"'+","+'\"type\"' +":"+'\"'+paramType+'\"'+","+'\"description\"' +":"+'\"'+paramDescription+'\"},';
	              }		  
	          }
		 }
		 $("#paramsJson").val('{\"paramsJson\"'+":["+paramJson+"]}");
		 var  jsonValid = validJsons($("#paramsJson").val());
		 if(jsonValid==false){
		    	$.alert("参数配置不正确请检查");
		    	return;
		 }
		$("#addFormulaForm #dataType").val( $("#returnType").val());
		fManager.validate($("#addFormulaForm").formobj(),false,{
			success: function(v) {
				if(v==true){
					alert("${ctp:i18n('ctp.formulas.simplechecksuccess')}");
				}
			},
			error:function(v){
				var responseText=JSON.parse(v.responseText);
				if(responseText.message!=null&&""!=responseText.message){
					$.alert("${ctp:i18n('ctp.formulas.simplecheckfailed')}"+"<br/>"+responseText.message);
				}else{
					$.alert("${ctp:i18n('ctp.formulas.simplecheckfailed')}");
				}
			}
			
		});
	 });
/*     $("#category").change(function () {  
        var value = $("#category  option:selected").val();  
        if(value == 4){
             $("#templatesTr").show();
             $("#templates").enable();
        }else{
        	$("#templatesTr").hide();
        	$("#templatesTr").disable();
        }
    }); */
	  //添加行事件
      $("#addImg").click(function(){
      	createTrfn();
      });
      //删除行事件
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
        $("#addImg").css("display", "none");
        $("#delImg").css("display", "none");
      });
});
//新建变量
function addVariable(){
	whichPage=1;
	$("#formulaform").disable();
	$("#variableForm").enable();
	gridObj.grid.resizeGridUpDown('middle');
	$("#variableForm").show();
	$("#variableForm #id").val('');
	var formulaName = $("#variableForm #formulaName").val();
	if( formulaName != ''){
		$("#variableForm #formulaName").val(formulaName + '_1');
	}
	
	$("#formulaform").hide();
	$("#check").show();
	$("#checkFormula").hide();
	$("#button").show();
}
//新建公式
function addFormula(){
	var isCopy = false;
	whichPage=2;
	$("#variableForm").hide();
	$("#variableForm").disable();
	$("#formulaform").enable();
	$("#formulaform #id").val('');
	var formulaName = $("#formulaform #formulaName").val();
	var sample = $("#formulaform #sample").val();
	if( formulaName != ''){
		isCopy = true;
		$("#formulaform #formulaName").val('COPY_1_'+formulaName);
		$("#formulaform #sample").val('COPY_1_'+sample);
	}	
	//$("#formulaform").clearform({clearHidden:true});
	initEditor($("#formulaform #formulaExpression").val()).setReadOnly(false);
	$("#templatesTr").hide();
	$("#formulaform").show();
	$("#button").show();
    $("#south").show();
    $("#lconti").show();
    $("#conti").attr("checked",'checked'); 
  	$("#tr1").show();
  	$("#paramTable").show();
  	$("#assist_id").val(1);
  	$("#check").hide();
  	$("#checkFormula").show();
  	$("#addFormulaForm #formulaType").val(whichPage);
	if(!isCopy){
		var trList = $("#mobody").children("tr");
		for(var i = 1;i<trList.length;i++){
			if (!!window.ActiveXObject || "ActiveXObject" in window){
				var parentNode = trList[i].parentNode;
				parentNode.removeChild(trList[i]);
			}else{
				trList[i].remove()
			}
		}
	}
	$(".assist").bind("click",assistfn);
    gridObj.grid.resizeGridUpDown('middle');
}

function validJsons(jsonStr) {  
    try {  
    	JSON.parse(jsonStr);  
    } catch (e) {  
        return false;  
    }  
    return true;  
}  

function initEditor(script){
	var editor = ace.edit("editor");
	editor.setTheme("ace/theme/monokai");
	editor.getSession().setMode("ace/mode/groovy");	
	editor.getSession().setUseWrapMode(true);
	editor.setValue(script);
	return editor;
}
//toolbar修改 表格双击
function edit() {
	 var v = $("#formulaTable").formobj({
        gridFilter : function(data, row) {
          return $("input:checkbox", row)[0].checked;
        }
      });
	  if(v.length < 1){
		 $.alert("${ctp:i18n('common.choose.atleastone.message')}");
		 return;
	  }
	  if (v.length > 1) {
        $.alert("${ctp:i18n('common.choose.one.record.label')}");
        return;
      }
	  if("-" == v[0].creator){
        $.alert("${ctp:i18n('ctp.formulas.preset.noEdit')}");
        return; 
	  }
	var detail=  fManager.getFormula(v[0].id);
	if(detail.formulaType==0||detail.formulaType==1){
		whichPage=1;
		gridObj.grid.resizeGridUpDown('up');
		$("#variableForm").clearform({clearHidden:true});
		$("#variableForm").fillform(detail);
		$("#variableForm").enable();
		$("#variableForm").show();
		$("#formulaform").hide();
		$("#formulaform").disable();
		$("#check").show();
		$("#checkFormula").hide();
		$("#button").show();
	}else{
		whichPage=2;
		$("#formulaform").clearform({clearHidden:true});
		gridObj.grid.resizeGridUpDown('up');
		detail.category=detail.category+"";
		$("#formulaform").fillform(detail);
		initEditor(detail.formulaExpression).setReadOnly(false);
		if(null != detail.paramsJson && "" != detail.paramsJson ){
			var jsons = JSON.parse(detail.paramsJson);
			var params = jsons.paramsJson;
			if(params.length>0){
				var trList = $("#mobody").children("tr");
				for(var i = 1;i<trList.length;i++){
					 if (!!window.ActiveXObject || "ActiveXObject" in window){
						 var parentNode = trList[i].parentNode;
						 parentNode.removeChild(trList[i]);
					 }else{
						 trList[i].remove()
					 }
					  
				}
				var trList = $("#mobody").children("tr");
		       	if(trList.length < params.length){
		       		for(var i = 0 ;i < params.length-trList.length; i++){
		           		createTrfn(); 
		           	} 
		       	}
				var trList = $("#mobody").children("tr");
				for(var i=0;i<trList.length;i++){
					 var tdArr = trList.eq(i).find("td");
		             tdArr.eq(0).find("input").val(params[i].name);//参数名称
		             tdArr.eq(1).find("select").val(params[i].type);//参数类型
		             tdArr.eq(2).find("input").val(params[i].description);//参数描述
				}
			}
		}
		$("#returnType").val(detail.dataType);
		/* if(detail.category == 4){
			 $("#templatesTr").show();
		}else{
			 $("#templatesTr").hide();
			 $("#templates").val("");
		} */
		$("#variableForm").hide();
		$("#assist_id").val(1);
		$(".assist").bind("click",assistfn);
		$("#variableForm").disable();
	  	$("#check").hide();
	  	$("#checkFormula").show();
		$("#formulaform").enable();
		$("#formulaform").show();
		$("#button").show();
	}
}

//toolbar删除
function del() {
}

//------------------------------------表格相关事件----------------------------------------//
//表格单击
function clk() {
	 var v = $("#formulaTable").formobj({
	        gridFilter : function(data, row) {
	          return $("input:checkbox", row)[0].checked;
	        }
	      });
		var detail=  fManager.getFormula(v[0].id);
		if(detail.formulaType==0||detail.formulaType==1){
			whichPage=1;
			gridObj.grid.resizeGridUpDown('middle');
			$("#variableForm").clearform({clearHidden:true});
			$("#variableForm").fillform(detail);
			$("#variableForm").show();
			$("#formulaform").hide();
			$("#button").hide();
		}else{
			whichPage=2;
			$("#formulaform").clearform({clearHidden:true});
			gridObj.grid.resizeGridUpDown('middle');
			detail.category=detail.category+"";
			$("#formulaform").fillform(detail);
			initEditor(detail.formulaExpression).setReadOnly(true);
			if(null != detail.paramsJson && "" != detail.paramsJson ){
				var jsons = JSON.parse(detail.paramsJson);
				var params = jsons.paramsJson;
				var trList = $("#mobody").children("tr");
				for(var i = 1;i<trList.length;i++){
					if (!window.ActiveXObject || "ActiveXObject" in window){
						 var parentNode = trList[i].parentNode;
						 parentNode.removeChild(trList[i]);
					 }else{
						 trList[i].remove()
					 }
				}
				var trList = $("#mobody").children("tr");
		       	if(trList.length < params.length){
		       		for(var i = 0 ;i < params.length-trList.length; i++){
		           		createTrfn(); 
		           	} 
		       	}
				if(params.length>0){
					var trList = $("#mobody").children("tr");
					for(var i=0;i<trList.length;i++){
						 var tdArr = trList.eq(i).find("td");
						 if("undefined" != params[i] && null != params[i]){
							 tdArr.eq(0).find("input").val(params[i].name);//参数名称
				             tdArr.eq(1).find("select").val(params[i].type);//参数类型
				             tdArr.eq(2).find("input").val(params[i].description);//参数描述
						 }
					}
				}
			}
			$("#returnType").val(detail.dataType);
			/* if(detail.category == 4){
				 $("#templatesTr").show();
			}else{
				 $("#templatesTr").hide();
			} */
			$(".assist").unbind("click",assistfn);
			$("#assist_id").val(1);
			$("#variableForm").hide();
			$("#formulaform").show();
			$("#button").hide();
		}
		$("#formulaform").disable();
		$("#variableForm").disable();
}

//查询组件事件
function setSearch() {
	var searchobj = $.searchCondition({
		top : 7,
		right : 10,
		searchHandler : function() {
			var ssss = searchobj.g.getReturnValue();
			var o = new Object();
			o[ssss.condition] = ssss.value;
			$("#formulaTable").ajaxgridLoad(o);
		},
		conditions : [ {id : 'formulaName',name : 'formulaName',type : 'input',text : "${ctp:i18n('ctp.formulas.formulaName')}",value : 'formulaName'}, 
			{id : 'formulaAlias',name : 'formulaAlias',type : 'input',text : "${ctp:i18n('ctp.formulas.formulaAlias')}",value : 'formulaAlias'},
			{id : 'formulaType',name : 'formulaType',type : 'select',text : "${ctp:i18n('ctp.formulas.formulaType')}",value : 'formulaType',codecfg : "codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.FormulaType'"},
			{id : 'dataType1',name : 'dataType',type : 'select',text : "${ctp:i18n('ctp.formulas.dataType')}",value : 'dataType',codecfg : "codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.DataType'"}]
	});
	searchobj.g.setCondition('name', '');
}
function checkVariableExpression(){
	var exp=$("#formulaExpression").val();
	var typ=$("#dataType").val();
	var len=exp.length;
	if(len==0)return;
	if(typ==1){
		if(exp.charAt(0)!="\""){
			exp="\""+exp;
		}
		if(exp.charAt(len-1)!="\""){
			exp=exp+"\"";
		}
		if(exp!=$("#formulaExpression").val()){
			$("#formulaExpression").val(exp)
		}
	}
}

function createTrfn(){
	var trId = "1";
	var html = $("#"+trId).html();
	var tableId = $("#"+trId).parent().parent().attr("id");
	var last = $("#"+tableId+" tr:last").attr("id");
	var assistId = ($("#"+last).find("input").attr("id"));
	var newNum = parseInt(last)+1; 
	html = "<td>"+
        	"<div class='common_txtbox_wrap'>"+
        	"<input type='text' id='fname"+newNum+"' name='name"+newNum+"' class='validate word_break_all' validate='maxLength:100'>"+
		  " </div>"+
		 " </td>"+
		 "<td>"+
			"<div class='common_selectbox_wrap '>"+
			    "<select id='fdType"+newNum+"' name='dType"+newNum+"' class='codecfg'>"+
			    "<option value=''>${ctp:i18n('ctp.formulas.please.select')}</option>"+
			    "<option value='1'>${ctp:i18n('ctp.formulas.text')}</option>"+
			    "<option value='2'>${ctp:i18n('ctp.formulas.numeric')}</option>"+
			    "<option value='3'>${ctp:i18n('ctp.formulas.date')}</option>"+
			    "<option value='4'>${ctp:i18n('ctp.formulas.boolean')}</option>"+
			    //"<option value='11'>${ctp:i18n('ctp.formulas.personnel')}</option>"+
			    //"<option value='12'>${ctp:i18n('ctp.formulas.department')}</option>"+
			    //"<option value='13'>${ctp:i18n('ctp.formulas.post')}</option>"+
			    //"<option value='14'>${ctp:i18n('ctp.formulas.positionlevel')}</option>"+
			    //"<option value='15'>${ctp:i18n('ctp.formulas.account')}</option>"+
			   // "<option value='16'>${ctp:i18n('ctp.formulas.role')}</option>"+
			    "<option value='17'>${ctp:i18n('ctp.formulas.object')}</option>"+
				" </select>"+
			"</div>"+
		"</td>"+
		"<td>"+
		"<div class='common_txtbox_wrap '>"+
			"<input type='text' id='fdescription"+newNum+"' name='description"+newNum+"' class='validate word_break_all' validate='maxLength:100'>"+
		"</div>"+
		"</td>";
	$("#paramTable").append("<tr class='assist' id='"+newNum+"'>"+html+"</tr>");
	$(".assist").unbind("click",assistfn).bind("click",assistfn);
	$("#assist_id").val($("#"+trId).next("tr").attr("id"));
	$("select").unbind("change",selectChange).bind("change",selectChange);
}

var selectChange = function (){
	 var value = $(this).children('option:selected').val();;
	 var trList = $("#mobody").children("tr")
     for (var i=0;i<trList.length;i++) {
       var tdArr = trList.eq(i).find("td");
       var selectValue = tdArr.eq(0).find("select").val();
       if(selectValue == value ){
    	   return;
       }
     }
}

var assistfn = function(){
	addOrDelTr(this);
}

var mousefn = function(){
	var o = $(this);
	o.attr("title",o.val());
}
function addOrDelTr(target){
		var imgDiv = $("#img");
	    if(imgDiv.length<=0){
	        return;
	    }
	    imgDiv.removeClass("hidden").css("visibility","visible");
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
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="comp"
			comp="type:'breadcrumb',comptype:'location',code:'T1_FormulaManager'"></div>
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="searchDiv"></div>
			<div id="toolbar"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:false"
			id="center">
			<table id="formulaTable" class="flexme3" border="0" cellspacing="0"
				cellpadding="0"></table>
			<div id="grid_detail" class="relative">
				<div class="stadic_layout">
					<div class="stadic_layout_head stadic_head_height"></div>
					<div class="stadic_layout_body stadic_body_top_bottom">
						<div id="variableForm" class="form_area">
							<%@include file="variableForm.jsp"%>
						</div>
						<div id="formulaform" class="form_area">
							<%@include file="formulaForm.jsp"%>
						</div>
					</div>
					<div class="stadic_layout_footer stadic_footer_height">
						<div id="button" align="center"
							class="page_color button_container">
							<div
								class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
								<a id="check" href="javascript:void(0)"class="common_button common_button_gray margin_r_10">${ctp:i18n('ctp.formulas.check')}</a> 
								<a id="checkFormula" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('ctp.formulas.check')}</a> 
								<a id="btnok"href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
								<a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>