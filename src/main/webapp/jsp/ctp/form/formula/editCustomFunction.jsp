<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>函数自定义</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formCustomFunctionManager"></script>
</head>
<body scroll="no">
<div id="areaDiv" class="form_area  margin_5">
	<form id="tableForm" action="${path}/form/formula.do?method=saveOrUpdateCustomFunction">
    	<table id="customArea" border="0" cellspacing="0" cellpadding="0" width="100%" align="center" style="height:250px;overflow-x:hidden;overflow-y:auto;">
	        <tr>
	            <td nowrap="nowrap" class="padding_l_10 align_left" colspan="2">
	            <label class="margin_r_5" for="text">&nbsp;&nbsp;函数名称:</label>
	            <input id="functionName" class="common_txtbox_wrap w50b validate"  type="text" value="${customFunction.functionName}" name="functionName" validate="name:'函数名称',type:'string',avoidChar:'&&quot;&lt;&gt;',notNull:true,maxLength:30"/>
	            <input type="hidden" id="id" name = "id" value="">
	            <td colspan="2"></td>
	        </tr>
	        <tr>
	            <td nowrap="nowrap" class="padding_t_5 padding_l_10 align_left" colspan="2">
	            	<label class="margin_r_5" for="text">&nbsp;&nbsp;参数设置:</label>
	            	<input readonly="readonly" id="selectParam" name="selectParam" type="text" class="w50b validate common_txtbox_wrap" mytype="4" hideText="functionParam"/>
	            	<input id="functionParam" name="functionParam" value="" class="w100b" type="hidden">
	            	<a id="paramSet" class="common_button common_button_gray" href="javascript:void(0)">设置</a>
	            </div></td>
	            <td colspan="2"></td>
	        </tr> 
	        <tr>
	            <td nowrap="nowrap" class="padding_t_5 padding_l_10 align_left" colspan="2">
	            	<label class="margin_r_5" for="text">&nbsp;&nbsp;代码类型:</label>
	            	<select class="common_drop_down w55b"><option value="Groovy">Groovy</option></select>
	            </td>
	            <td colspan="2"></td>
	        </tr>
	        <tr>
	        	<td colspan="3" class="padding_t_5 padding_l_10 align_center"><div class="common_txtbox">
	        		<textarea style="width:380px;height:100px;" id="codeText" class="validate" validate="name:'代码内容',notNull:true,maxLength:4000" value=""></textarea>     		  		
	        		</div>
	        	</td>
	        	<td colspan="1" valign="bottom">
	        	&nbsp;&nbsp;<a id="codeUpload" class="common_button common_button_icon margin_r_5 margin_b_10" href="javascript:void(0)">上传代码文件</a>
	        	</td>
	        </tr>
	        <tr>
	        	<td colspan="2"><label class="padding_l_10 margin_t_5" for="text">&nbsp;&nbsp;返回值类型：
	        	<c:if test="${formulaType==0}">数字</c:if><c:if test="${formulaType==1}">文本</c:if></label>
	        	<input type="hidden" id="returnType" value="${formulaType}"/>
	        	</td>
	        	<td colspan="2" valign="right">
	        	<a id="save" class="common_button common_button_gray" href="javascript:void(0)">保存</a>
		        <a id="reset" class="common_button common_button_gray" href="javascript:void(0)">重置</a>
		        <a id="help" class="common_button common_button_gray" href="javascript:void(0)">帮助</a>
		        <input id="myfile" type="hidden" class="comp" comp="type:'fileupload',applicationCategory:'1',isEncrypt:false,extensions:'txt,groovy',quantity:1,firstSave:true">
	        	</td>
	        </tr>
	     </table>
		</form>
    </div>
</body>
<%@ include file="../common/common.js.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		$("#paramSet").click(function(){
			var customJson={DialogTitle:'参数设置',ShowTitle:'参数设置',LeftUpTitle:'表单数据域',LeftDownTitle:'系统数据域',RightTitle:'已选参数',IsShowLeftDown:true,IsShowSearch:true};
			selectChoose("selectParam","-1",$.parseJSON("{'byFilterSysState':true,'byInputType':'handwrite,attachment,document,image','byFieldName':'${fieldName}','isReName':false}"),customJson,function(valueObj){
	    		var key="";
	    		var value="";
	    		for ( var i = 0; i < valueObj.length; i++) {
	    			if(i==valueObj.length-1){
	    				key+=valueObj[i].key;
	    				value+=valueObj[i].value;
	    			}else{
	        			key+=valueObj[i].key+",";
	        			value+=valueObj[i].value+",";
	        		}
	    		}
	    		$("#selectParam").val(value);
	        });
	    });
		//重置清空
		$("#reset").click(function (){
			$("#functionName").val("");
			$("#selectParam").val("");
			$("#functionParam").val("");
			$("#codeText").val("");
		});
		$("#save").click(function (){
			save();
		});
		$("#codeUpload").click(function (){
			insertAttachment("importCodeCallBk");
		});
		$("#help").click(function (){
			var current_dialog = $.dialog({
				url: "${path}/form/formula.do?method=customFunctionHelp",
				title : "函数自定义说明",
				width:500,
				height:450,
				targetWindow:getCtpTop(),
				   buttons : [{
				     text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",
				     handler : function() {
				    	 current_dialog.close();
				     }
				   }]
				});
		});
		initView();
	});
	//初始化是否禁用按钮
	function initView(){
		if("${pageType}" == "browser"){
			$("#areaDiv").disable();
		}else{
			$("#areaDiv").enable();
		}
	}
	//保存方法
	function save(){
		if(parseInt(($("#selectParam").val().length)*3 + $("#functionParam").val().length) > 4000){
			$.alert("参数长度超过了数据库存储的最大值4000!请重新设置！");
			return;
		}
		if($("#customArea").validate()){
			var customManager = new formCustomFunctionManager();
			customManager.preGroovyCode($("#functionName").val(),$("#codeText").val(),{success:
    			function(msg){
    				if(msg == "success"){
    					customManager.checkFunctionName($("#id").val(),$("#functionName").val(),{success:
    		    			function(obj1){
    		    				if(!obj1){
    		    					$("#tableForm").jsonSubmit({callback : function() { 
    		    						$.infor({
    		    		    			    'msg': '${ctp:i18n("common.successfully.saved.label")}!',
    		    		    			     ok_fn: function () {
    		    		    			    	 parent.location.reload();
    		    		    			     }
    		    						});
    					    		}});
    		    				}else{
    		    					$.alert("函数名称已经存在!");
    		    					$("#functionName").focus();
    		    				}
    		    		}});
    				}else{
    				    $.messageBox({
    					    'type' : 5,
    					    'imgType' : 1,
    					    'title' : "${ctp:i18n('form.formula.engin.systeminfo.label')}",
    					    'msg' : "编写Groovy代码块发生错误，请查看！",
    					    'detail_fn':function(){
    				    		$.alert(msg);
    				  		},
    					    ok_fn : function() {
    					    }
    					});
    				}
    		}});
    	}
	}
	//上传代码文件回调方法
	function importCodeCallBk(filemsg,repeat){
		var fileId=filemsg.instance[0].fileUrl;
		//进行枚举或分类校验，校验枚举是否被引用
		var customManager = new formCustomFunctionManager();
		customManager.readCodeFromFile(fileId,{success:
			function(obj){
				if(obj.result == 'success'){
					$.infor({
			    		  'msg':"${ctp:i18n('formsection.import.success')}",
			    		  ok_fn:function (){
			    			  $("#codeText").val(obj.info);
			    		  }
			    	 });
				}else{
					$.alert(obj.result);
				}
			}
		});
	}
</script>
</html>