<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script>
var hasWorkflow = <c:out value='${hasWorkflow}' default='false' />;
/**
 * 下面这个方法废弃了  检查的代码直接放在了 保存内部
 */
function checkRepeatTempleteSubject(form1){
	var categoryIdObj = form1.elements['categoryId'];
	var categoryId = categoryIdObj == null ? "" : categoryIdObj.value;
	var subject = form1.elements['subject'].value;
	var id=$("#templateMainData #id").val();
	var isUpdate = (id != null) && (id != "");
	 //å®ä¾åSpring BSå¯¹è±¡
	var callerResponder = new CallerResponder();
    var temManager = new templateManager();
 	var ids =[];
 	ids[0] = categoryId;
 	ids[1] = subject;
 	var returnVal = temManager.checkNameRepeat(ids);
	var count = returnVal.length;

	if(count < 1) return '1';

	if(isUpdate == true && count == 1 && id == returnVal[0].id){ //update
		return '1';
	}else{
	    var confirm = "";
        confirm = $.confirm({
            'msg': "${ctp:i18n_1('collaboration.saveAsTemplate.isHaveTemplate','"+subject+"')}",  //模板 '+subject+'已经存在，是否将原模板覆盖?
            ok_fn: function () {
                return '2';
            },
            cancel_fn:function(){
                return '3';
            }
        });
	}
}

/**
 * 检查分类是否存在 
 */
function checkTemplateCategory(categoryId,categoryName){
	if(!categoryId)return true;
	var callerResponder = new CallerResponder();
    var temManager = new templateManager();
    var returnVal = temManager.getCtpTemplateCategory(categoryId);
    if(!returnVal){
        //模板分类不存在!
    	$.alert("${ctp:i18n('template.templatePub.templateTypeNotExist')}");
    	return false;
    }
    return true;
}

/*
***  å»é¤é¦å°¾ç©ºæ ¼ï¼åæ¬è±æç©ºæ ¼ãä¸­æç©ºæ ¼ãé¡µé¢è§£æåç&nbsp;
*/
function trim(str){
	return str.replace(/^[\s\u3000\xA0]+|[\s\u3000\xA0]+$/g,"");
}

function notSpecialChar(element){
	var value = element.value;
	var inputName = element.getAttribute("inputName");
	
	if(!validateSubjectNotEmpty(element)){
        return false;
    }
	
	if(/^[^\|\\"'<>]*$/.test(value)){
		return true;
	}else{
		//writeValidateInfo(element, v3x.getMessage("V3XLang.formValidate_specialCharacter", inputName));
		$.messageBox({
	        'type' : 0,
	        'title':"${ctp:i18n('system.prompt.js')}", //系统提示
	        'msg' : inputName+"${ctp:i18n('collaboration.newColl.tszf')}", //不能包含特殊字符（|\"'\<>），请重新输入！
	        'imgType':2,
	        ok_fn : function() {
	    		$(element).select();
	        }
	      });
		return false;
	}
} 

function validateSubjectNotEmpty(element){
  var value = element.value;
  var inputName = element.getAttribute("inputName");
  if("${ctp:i18n('common.default.subject.value')}" == value || $.trim(value) ==""){
      $.messageBox({
          'type' : 0,
          'title':"${ctp:i18n('system.prompt.js')}", //系统提示
          'msg' : "${ctp:i18n('collaboration.common.titleNotNull')}",//标题不能为空
          'imgType':2,
          ok_fn : function() {
              element.focus();
          }
        });
      return false;
  }
  return true;
}

function checkTemplateIsDelete(templateId){
	  var tm = new templateManager();
	  var result = tm.checkTemplateIsDelete(templateId);
	  if(result.isDel =='1'){
		  return true;
	  }else{
		  return false;
	  }
}


/**
 * 保存模板
 */
function saveCollaborationTemplate() {
	var theForm = document.getElementById('sendForm');
	if(!validateSubjectNotEmpty(theForm.subject)){
        return;
    }
    var templateType = $("#type").val();
    var categoryIdO = $("#categoryId");
    if(categoryIdO.val() == ""){
		$.messageBox({
	        'type' : 0,
	        'title':"${ctp:i18n('system.prompt.js')}", //系统提示
	        'msg' : "${ctp:i18n('collaboration.common.categoryNotNull')}",//模板分类不能为空
	        'imgType':2,
	        ok_fn : function() {}
	      });
		return false;
	}
	//var reValue = checkRepeatTempleteSubject(theForm);
	var categoryIdObj = theForm.elements['categoryId'];
	var categoryId = categoryIdObj == null ? "" : categoryIdObj.value;
	var subject = theForm.elements['subject'].value;
	var id=$("#templateMainData #id").val();
	var isUpdate = (id != null) && (id != "");
	var callerResponder = new CallerResponder();
    var temManager = new templateManager();
 	var ids =[];
 	ids[0] = categoryId;
 	ids[1] = subject;
 	var returnVal = temManager.checkNameRepeat(ids);
	var count = returnVal.length;
	if(count < 1){ 
		_callBackSave('1',categoryIdO,templateType);
		return;
	}
	if(isUpdate == true && count == 1 && id == returnVal[0].id){ //update
		_callBackSave('1',categoryIdO,templateType);
	}else{
	    var confirm = "";
        confirm = $.confirm({
            'msg': "${ctp:i18n_1('collaboration.saveAsTemplate.isHaveTemplate','"+escapeStringToHTML(subject)+"')}",  //模板 '+subject+'已经存在，是否将原模板覆盖?
            ok_fn: function () {
            	_callBackSave('2',categoryIdO,templateType);
            },
            cancel_fn:function(){
            	_callBackSave('3',categoryIdO,templateType);
            }
        });
	}
}

function _callBackSave(reValue,categoryIdO,templateType){
	if ( reValue !='3' && checkTemplateCategory(categoryIdO.val(),trim(categoryIdO.text()))) {
		 if(templateType != 'text'  && !checkSelectCollWF()){ //协同正文，不用流程
			return;
		}
	    //如果是2的话，多加一个参数用于是否是同目录下重复替换老模板的操作
	    if(reValue == '2'){
	    	var  changFlag = document.createElement("input");
	    	$(changFlag).attr("type",'hidden').attr('id','changeFlag').attr('name','changeFlag').attr('value','changeTrue');
	    	$('#templateMainData')[0].appendChild(changFlag);
	    }
	   	 $("#comment_deal #ctype").val(-1);
	   	isSubmitOperation = true;
	   	 //调用正文给的保存修改模板接口
	   	 var moduleId = $("#templateMainData #id").val();
	   	 setTemplateParam(moduleId,$("#subject"));
	   	 if($("#type").val() !='workflow'){
	   		$.content.getContentDomains(function(domains){
		        if (domains) {
		        	domains.push('advanceHTML');
		        	domains.push('templateMainData');
		            domains.push('comment_deal');
		            domains.push('superviseDiv');
		            $("#sendForm").jsonSubmit({
		              errorIcon : false,
		              errorAlert:true,
		              domains : domains,
		              debug : false,
		              callback:function(data){
		              }
		            });
		          }
		    });
	     }else{
	         var domains = [];
	         var contentDiv = getMainBodyDataDiv$();
	    	 $.content.getWorkflowDomains($("#moduleType", contentDiv).val(), domains);	
	    	 if (domains) {
		        	domains.push('advanceHTML');
		        	domains.push('templateMainData');
		            domains.push('comment_deal');
		            domains.push('superviseDiv');
		            $("#sendForm").jsonSubmit({
		              domains : domains,
		              debug : false,
		              callback:function(data){
		              }
		            });
		          }
	     }
		}
}

function checkSelectCollWF() {
	if($("#process_info").val() && !($("#process_info").val()=="${ctp:i18n('collaboration.template.click.forwf')}")){
		hasWorkflow = true;
	}else{
		hasWorkflow= false;
	}
    if (!hasWorkflow) {
        $.messageBox({
	        'type' : 0,
	        'title':"${ctp:i18n('system.prompt.js')}", //系统提示
	        'msg' : "${ctp:i18n('template.templatePub.selectFlow')}",//请选择流程
	        'imgType':2,
	        ok_fn : function() {
	    		$("#process_info").click();
	        }
	      });
        return false;
    }

    return true;
}

function checkDeadLine(){
	var deadline = document.getElementById('deadline');
	var remind = document.getElementById('advanceRemind');
	if(parseInt(deadline.value) <= parseInt(remind.value) && parseInt(remind.value) != 0){
        //未设置流程期限或者流程期限小于，等于提前提醒时间!
		$.alert("${ctp:i18n('template.templatePub.noSetFlow')}");
		remind.selectedIndex = 0;
	}
}

</script>