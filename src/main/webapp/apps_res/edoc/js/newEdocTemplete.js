function edocFormDisplay(){
    		var xml = document.getElementById("xml");
			var xsl = document.getElementById("xslt");
						enableButton("save");	
			if(xml!=null && xml!="" && xsl!=null && xsl!=""){
			try{
			    
			  //设置修复字段宽度的传参
		        window.fixFormParam = {"isPrint" : false, "reLoadSpans" : true};
    			initSeeyonForm(xml.value,xsl.value);
    			if(document.getElementById("my:send_department") != null){
    				document.getElementById("my:send_department").value = "";
    			}
    			if(document.getElementById("my:send_department2") != null){
    				document.getElementById("my:send_department2").value = "";
    			}
			}catch(e){
				alert(_("edocLang.edoc_form_xml_error") +e);
				disableButton("save");
				window.location.href=window.location.href;
				return false;
			 }
			}
    		setObjEvent();
    		adjustDivHeight();
    		  initBodyType();
    		initContentTypeState();
    		//判断是否为firefox,如果是正文类型选中标准正文
    		if(navigator.userAgent.indexOf("Firefox")!=-1){
    		  bodyTypeSelector.disabled("menu_bodytype_HTML");
    		}
    		
    		substituteLogo(logoURL);
    		showEdocMark("newtemplete");
        	//调整模板类型选择的 显示字，在每个类型后面加一个空格(应该是上面的文单解析的时候，
            //          不知道什么地方将option中4个字的变为3个了，由于时间原因先这样改了，其他国际化时这样也正确的)
            adjustOptionText();
    		return false;
    	}
    	
function adjustOptionText(){
  var sel = document.getElementById("template_type");
  if(sel){
      for(var i=0;i<sel.length;i++){
          var text = sel.options[i].text;
          sel.options[i].text = text+" ";
      }
  }
}
function adjustDivHeight()
{  
  //var formDivObj=document.getElementById("formAreaDiv");
  //formDivObj.style.height=(screen.availHeight-288)+"px";  
}
//////////////////模版调用JS函数///////////////////////
function doAuth(elements){
	if(elements){
		document.getElementById("auth").value = getIdsString(elements);
	}
}
/**
 * 保存模板
 */
function saveTemplete(_type) {	
	var theForm = document.getElementsByName("sendForm")[0];
	
	var subObj=theForm.elements['templatename'];
    if(subObj==null)
    {
      alert(_('edocLang.edoc_title_notFound'));
      return;
    }
    if(compareTime()==false){return;}
	if(_type==null)
	{
	  var typeObj=document.getElementById("template_type");
	  _type=typeObj.options[typeObj.selectedIndex].value;	  
	}
    if(validFieldData_gov()==false){return;}//xiangfan 修改为 validFieldData_gov， 修复GOV-4955
    theForm.action=edocTemplateSaveUrl;    
    var subject=theForm.elements['templatename'].value;
    if(subject=="")
    {
      alert(_('edocLang.edoc_inputTemplateName'));
      theForm.elements['templatename'].focus();
      return;
    }
    var from = getParameter("from");
    if(from == "TM" && !theForm.categoryId.value){
    	alert(_('edocLang.templete_alertNoCategory'));
    	return;    	
    } 
    if(!checkEdocSubject(theForm)){return;}//xiangfan 添加  公文标题 特殊字符验证 修复GOV-4313

    var copies = document.getElementById("my:copies");
    if(!checkCopies(copies)){
   	 return;
    }
    
    if (checkForm(theForm) && checkRepeatTempleteSubject(theForm, true)) {
    	if(_type != 'text' && !checkSelectWF(1)){ //协同正文，不用流程
    		return;
    	}
    	if (_type != "workflow") { //流程模板，不保存office正文	    
            //保存office正文，包括pdf
            var bodyType = document.getElementById("bodyType");
            if(bodyType){
              if(bodyType.value == "Pdf" && !savePdf()){
                return;
              }else if(!saveOffice()){
                return;
              }
            }
        }
        
        //分枝 开始
        if(branchs){
			for(var i=0,j=keys.length;i<j;i++){
				var branch = branchs[keys[i]];
				if(branch!=null){
					var str = "<input type=\"hidden\" name=\"branchs\" value=\""+keys[i]+"↗"+branch.id
					+"↗"+branch.conditionType+"↗"+branch.formCondition+"↗"+branch.conditionTitle+"↗"+branch.isForce+"↗"+(branch.conditionDesc?branch.conditionDesc.escapeQuot():"")
					+"↗"+branch.conditionBase+"\">";
					branchDiv.innerHTML += str;
				}
			}
		}
		
		if(nodes != null && nodes.length>0){
        	var hidden;
        	for(var i=0;i<nodes.length;i++){
		        hidden = document.createElement('<INPUT TYPE="hidden" name="policys" value="' + policys[nodes[i]].name + '" />');
		        theForm.appendChild(hidden);
		        hidden = document.createElement('<INPUT TYPE="hidden" name="itemNames" value="' + policys[nodes[i]].value + '" />');
		        theForm.appendChild(hidden);
	        }
        }
        //分枝 结束


        //节点权限引用更新
		if(!isCheckNodePolicyFlag){
			var policyArr = new Array();
		    var itemNameArr = new Array();
		    if(nodes != null && nodes.length>0){
		    	for(var i=0;i<nodes.length;i++){
		    		var policyName = policys[nodes[i]].name;
		    		var itemName = policys[nodes[i]].value;
		    		policyArr.push(policyName);
		    		itemNameArr.push(itemName);
		    	}
		    }
		   
			/* try {
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "checkNodePolicy", false);
				requestCaller.addParameter(1, "String[]", policyArr);
				requestCaller.addParameter(2, "String[]", itemNameArr);
				requestCaller.addParameter(3, "String", theForm.loginAccountId.value);
				var rs = requestCaller.serviceRequest();
				if(rs == "1"){
					alert(_("collaborationLang.node_policy_not_existence"));
					return;
				}
			}
			catch (ex1) {
				alert("Exception : " + ex1);
				return;
			} */
		}
        saveAttachment();
        isSaveAction = true;
        isFormSumit=true;

        theForm.target = "_self";
        theForm.submit();

        //getA8Top().startProc('');
    }
}
/**
 * 检测模板标题是否重名
 */
function checkRepeatTempleteSubject(form1){
	var categoryIdObj = form1.elements['categoryId'];
	var categoryId = categoryIdObj == null ? "" : categoryIdObj.value;
	var subject=form1.elements['templatename'].value;
	var id = form1.elements['id'].value;
	var isUpdate = (id != null) && (id != "");
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "checkSubject4System", false);
		requestCaller.addParameter(1, "String", categoryId);
		requestCaller.addParameter(2, "String", subject);
		var idList = requestCaller.serviceRequest();
		
		if(!idList){
			return true;
		}
		
		var count = idList.length;
				
		if(count < 1) return true;
		
		if(isUpdate == true && count == 1 && id == idList[0]){ //修改，存在的数据就是它自己
			return true;
		}

		alert(_("edocLang.system_templete_alertRepeatSubject"));
		return false;
	}
	catch (ex1) {
		alert("Exception : " + ex1.message);
	}

	return true;
}
function alertChangeType(obj){
	
	var opt = obj.options[obj.selectedIndex];
	
    var copyFlowDis;
	//公文的流程模板、格式模板暂不支持授权给其他单使用[跨单位授权设计文档]--又被改了，现在可以授权
	
	if(opt.value == "text" || opt.value == "workflow"){
		//document.getElementById("auth").value = "";
		//onlyLoginAccount_auth = true;
		elements_auth = "";
		//showAccountPanel_auth = false;
		if(opt.value == "text"){
			copyFlowDis = true;
		}else{
			copyFlowDis = false;
		}
		
	}else if(opt.value == "templete"){
		//onlyLoginAccount_auth = false;
		elements_auth  = "";
		//showAccountPanel_auth = true;
		copyFlowDis = false;
	}
	var copyFlow = document.getElementById("copyFlow");
	if(copyFlow){
		copyFlow.disabled = copyFlowDis;
	}
	
	alert(_("edocLang.templete_alertChangeType_" + opt.value, opt.text));
}
function selectPeo(){
	  //OA-8532  拟文，填写了标题，没有写流程，发送，在提示后没有弹出选人界面  
	  createEdocWFPersonal();
	}

	function getPolicy(type){
	  var policy={};
	  if(type == 'sendEdoc' || type=='signReport'){
	     policy.name = v3x.getMessage("edocLang.edoc_approval");
	     policy.bianma = "shenpi";
	  }else{
	     policy.name = v3x.getMessage("edocLang.edoc_read");
	     policy.bianma = "yuedu";
	  }
	  return policy;
	}


	function createEdocWFPersonal(){
	  var wendanId=document.getElementById("edoctable").value;
	  var top2 = window.parent.parent;
	  var type ="";
	  if(categoryType == 19){
	      type = "sendEdoc";
	  }else if(categoryType == 20){
	      type = "recEdoc";   
	  }else{
	      type = "signReport";    
	  }
	  //OA-22557  新建收文模版，默认的节点权限不对，应该是阅读，不是审批  
	  var policy = getPolicy(type);
	  
	  //OA-15804  公文基础数据-模板管理，新建模板，编辑流程，弹出窗口只能在内容框架里。  
	  //'${appName}'需要传递recEdoc值，而不是传递公文4的类别，bug-OA-36091  test01修改新建的发文模版，点击某个节点属性，节点权限变成了知会，下拉框可选节点权限变成了签报的节点权限  
	   top2.createWFTemplate(
	      getA8Top(),
	      appName, 
	      '', 
	      '',
	      processTemplateId,
	      window,
	      policy.bianma,
	      currentUserId,
	      currentUserName,
	      currentUserAccountName,
	      currentUserAccountId,
	      '',
	      '',
	      policy.name,
	      wendanId
	      );
	}
	function openAuth(){
		  var type = $("#template_type").val();
		  if(type == "templete"){
		    selectPeopleFun_auth();
		  }
		  else{
		    selectPeopleFun_authNotAccount();
		  }
		}

		function selectSourceTemplate(){
			var top2 = window.parent.parent;
			var wendanId=document.getElementById("edoctable").value;
			top2.edocSelectTemplate(getA8Top(),window,paramTempleteId,categoryType,paramCategoryId,wendanId,appName,defaultPermName,defaultPerm);
		}
		function onbefore(){
			if(t_num == 0){
		    	setTimeout(function(){_t = setTimeout(onunloadcancel, 500)}, 0);
		    	t_num++;
		    	onbeforeunload();
			}
		}

		function onunloadcancel(){
		    clearTimeout(_t);
		    //如果点了取消离开当前页面，则将菜单设置回模板设置
		    parent.changeMenuTabBack();
		}
		$(function(){
			//更多按钮操作
		    var moreShow_st = 0;//更多状态
		    $("#show_more").click(function () {
		        if (moreShow_st==0) {
		            $(this).html('收起<span class="ico16 arrow_2_t"></span>');
		            $(".newinfo_more").show();
		            moreShow_st=1;
		        }else {
		            $(this).html('展开<span class="ico16 arrow_2_b"></span>');
		            $(".newinfo_more").hide();
		            moreShow_st=0;
		        }
		    });
		});