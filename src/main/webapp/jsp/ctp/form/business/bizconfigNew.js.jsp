<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var sSelectTrIndex = -1;
$(document).ready(function() {
	$("#shareScope").click(function(){
		var param = new Object();
		param.text = $("#shareScope").val();
		param.value = $("#shareScopeIds").val();
		param.elements = [];
		$.selectPeople({
	        panels: 'Account,Department,Team,Post,Level,Outworker,JoinOrganization,JoinPost',
	        selectType: 'Account,Department,Team,Post,Level,Member',
	        params:param,
	        showFlowTypeRadio : false,
	        isNeedCheckLevelScope:false,
	        hiddenPostOfDepartment:true,
            showAllOuterDepartment:true,
	        minSize:0,
	        callback : function(ret) {
	        	$("#shareScope").val(ret.text);
	            $("#shareScopeIds").val(ret.value);
	        }
	      });
	});
	//所属人单击事件
	$("#ownerName").click(function(){
		var dialog = $.dialog({
			url:_ctxPath + "/form/fieldDesign.do?method=setOwner",
			title : $.i18n('form.base.setbizaffiliatedperson.label'),//设置表单所属人
			width:600,
			height:400,
			targetWindow:getCtpTop(),
			transParams:window,
			buttons : [{
				text : $.i18n('form.trigger.triggerSet.confirm.label'),//确定
				id:"sure",
				isEmphasize: true,
				handler : function() {
					var isOK = dialog.getReturnValue();
					if(isOK) dialog.close();
				}
			}, {
				text : $.i18n('form.query.cancel.label'),
				id:"exit",
				handler : function() {
					dialog.close();
				}
			}]
		});
	});
	$("#sureBut").click(function(){
		saveV3xBizConfig(true);
	});
	$("#setMobileHome").click(function(){
		setMobileHomeFun();
	});
	if ($("#bizImageUrl").val()==""){
	  setDefalutImage();
	} else {
	  showImage($("#bizImageUrl").val());
	}
	changedTagType("business.do?method=listbizdatatree&type=formApp");

	new inputChange($("#bizMergeName"), "${ctp:i18n('bizconfig.flowtemplate.list.merge1')}", "color_gray");
	checkBizMerge();
});

function setMobileHomeFun(){
	if(checkSecMenuDuplicate()){
		return false;
	}
	if(!$("#domain2").validate({errorAlert:true})){
		return;
	}
	var args;
	var isMerge = false;
	var bizMergeName = "";
	var bizConfigName = $("#bizConfigName").val();
	if($("#bizMerge",$("#domain3")).attr("checked")){
		isMerge = true;
	}
	if(isMerge){
		bizMergeName = $("#bizMergeName",$("#domain3")).val();
		if(bizMergeName && bizMergeName == "${ctp:i18n('bizconfig.flowtemplate.list.merge1')}"){
			$.alert("请录入合并流程列表的菜单名称！");
			return false;
		}
	}
	var domain3 = {bizMerge:isMerge?1:0,bizMergeName:bizMergeName};
	var map = [];
	//$("#domain2").formobj();
	$("div[id^='tr']","#domain2").each(function(){
		var menu = {};
		menu.title = $("div[id^='title']",this).attr("title");
		menu.sourceType = $("#sourceType",this).val();
		menu.menuName = $("#menuName",this).val();
		menu.menuId = $("#menuId",this).val();
		var flowMenuTypeName = $("#flowMenuTypeName",this).val();
		var flowMenuType = 0;
		var radio = $("input[name='"+flowMenuTypeName+"']:checked").val();
		if(radio){
			flowMenuType = radio;
		}
		menu.flowMenuType = flowMenuType;
		menu.sourceId = $("#sourceId",this).val();
		menu.formAppmainId = $("#formAppmainId",this).val();
		map.push(menu);
	});
	var mobileConfig = $("#mobileConfig").val();
	args = {win:window,domain2:map,domain3:domain3,mobileConfig:mobileConfig,bizConfigName:bizConfigName};
	var dialog = $.dialog({
		url:_ctxPath + "/form/business.do?method=setMobileHome",
		title : $.i18n('bizconfig.business.mobile.home.set.title.label'),
		width:700,
		height:533,
		targetWindow:getCtpTop(),
		transParams:args,
		buttons : [{
			text : $.i18n('form.trigger.triggerSet.confirm.label'),//确定
			id:"sure",
			isEmphasize: true,
			handler : function() {
				var result = dialog.getReturnValue();
				if(result&&result.success){
				    if(result.needTips){
                        $.alert({msg:"${ctp:i18n('form.mobile.business.three.tips')}",imgType:"2",close_show:false,ok_fn:function(){
                            dialog.close();
                        }
                        });
                    }
					$("#mobileConfig").val(result.mobileConfig);
					var icon = $("em",$("#setMobileHome"));
					if(icon.hasClass("toGray")){
						icon.removeClass("toGray").addClass("formPhone_16");
					}
                    if(!result.needTips){
                        dialog.close();
                    }
				}
			}
		},
		{text : $.i18n('form.datamatch.del.label'),
			id:"delete",
			handler : function() {
				var confirm = $.confirm({
					'msg': '${ctp:i18n("bizconfig.business.mobile.delete.confirm.label")}',
					ok_fn: function () {
						$("#mobileConfig").val("");
						var icon = $("em",$("#setMobileHome"));
						icon.removeClass("formPhone_16").addClass("toGray");
						confirm.close();
						dialog.close();
					},
					cancel_fn:function(){
						confirm.close();
					}
				});
			}
		},
		{text : $.i18n('form.query.cancel.label'),
		id:"exit",
		handler : function() {
			dialog.close();
		}
		}]
	});
}
function setDefalutImage(){
  $("#bizImageUrl").val('');
  $("#viewImageIframe").html($("#defalutImage").clone().show());
}

function OK(jsonParam){
	return saveV3xBizConfig(jsonParam.isAdd);
}

function showImage(fileId){
  var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileId + '&type=image';
  var path = _ctxServer;
  var url = " ";
  url = url + path + url1;
  $("#bizImageUrl").val(fileId);
  var imgStr = "<img src='" + url + "' width='32px' height='32px'>";
  $("#viewImageIframe").html(imgStr);
}

function imageUpload(){
  dymcCreateFileUpload("dyncid", "1", "gif,jpg,jpeg,png,bmp", "1", false, 'imageCallback', null, true, true, null, true, false, '102400');
  insertAttachment();
}

function imageCallback(id) {
  //隐藏图片下面的垃圾回收站的图标
  $("#attachmentArea").hide();
  var fileUrl = id.get(0).fileUrl;
  var createDate = id.get(0).createDate;
  showImage(fileUrl);
}

/**
 * 向具体位置中增加附件
*/
	function addAttachmentPoi(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone, description, extension, icon, poi, reference, category, onlineView, width, embedInput,hasSaved,isCanTransform,v,canFavourite, isShowImg) {
		$("#attachmentAreabizimage1").html("");
		$("#bizImageUrl").val(fileUrl);
  canDelete = false;
  needClone = needClone == null ? false : needClone;
  description = description ==null ? "" : description;
  if(attachDelete != null) canDelete = attachDelete;
  if(fileUrl == null){
      fileUrl=filename;
  }
  var attachment = new Attachment('',reference, poi, category, type, filename, mimeType, createDate, size, fileUrl, description, needClone,extension,icon, false,isCanTransform,v);
  attachment.showArea=poi;
  attachment.embedInput=embedInput;
  attachment.hasSaved =hasSaved;
  if(canFavourite != null) attachment.canFavourite=canFavourite;
  if(isShowImg != null) attachment.isShowImg=isShowImg;
  if(fileUploadAttachment != null){
    if(fileUploadAttachment.containsKey(fileUrl)){
      return;
    }
    fileUploadAttachment.put(fileUrl, attachment);
  }else{
    if(fileUploadAttachments.containsKey(fileUrl)){
    if(!fileUploadAttachments.containsKey(fileUrl+poi)){ // 允许添加重复的关联文档这种需求有待商榷，目前尚未定论，暂时按测试的要求进行修改
        fileUrl+=poi;  
    }else{
        return;
    }
    }
    fileUploadAttachments.put(fileUrl, attachment);
  }
  showAtachmentObject(attachment, canDelete, null);
  if(attachment.isShowImg){
      //自适应图片的宽度和高度
      var hiddenInput = $("#"+attachment.embedInput).eq(0);
      hiddenInput.parent("div").css("display","block");
      hiddenInput.css("display","block");
      var inpHeight = hiddenInput.height();
      var inpWidth = hiddenInput.width();
      inpHeight=(inpHeight==0?100:inpHeight);
      inpWidth=(inpWidth==0?100:inpWidth);
      var displayDiv = $('#attachmentDiv_' + attachment.fileUrl);
      var delSpanWidth=displayDiv.find(".ico16").width()+2;
      displayDiv.width(inpWidth).height(inpHeight);
      displayDiv.find("img").width(inpWidth-delSpanWidth).height(inpHeight);
      hiddenInput.css("display","none");
      hiddenInput.parent("div").css("display","none");
  }
  //更新附件、关联文档隐藏域
  var file=attachment;
  if($("#"+file.embedInput).size()>0){
      $("#attachmentArea"+file.showArea).prev().children("#"+file.embedInput).attr("value", poi);//附件
      $("#attachment2Area"+file.showArea).prev().children("#"+file.embedInput).attr("value", poi);//关联文档
  }
  showAtachmentTR(type,'',poi);
  
  if(attachCount)
    showAttachmentNumber(type,attachment);
  if(typeof(addScrollForDocument) =="function"){
    addScrollForDocument();
  }
}

//切换表单数据域与系统变量
function changedTagType(url){
	  	document.getElementById("formapp").src =url;
}
/*
* 从左边向右边移动
*/
var tempsNodeArray = new Array();
function selectToCreateMenu(){
 	var n1=$("#formapp");
	var n2=$("#formquery");
	var n3=$("#formreport");
	var n4=$("#documentCenter");
	var n5=$("#infomation");
	var n6=$("#catg");
	var n7 = $("#seeyonreport");
	$("#tabs").tabCurrent();
	var oSelected = null;
	if(n1.hasClass("show")){
		oSelected = formapp.getSelectedNodes();
	}else if(n2.hasClass("show")){
		oSelected = formquery.getSelectedNodes();
	}else if(n3.hasClass("show")){
		oSelected = formreport.getSelectedNodes();
	}else if(n4.hasClass("show")){
		oSelected = documentCenter.getSelectedNodes();
	}else if(n5.hasClass("show")){
		oSelected = infomation.getSelectedNodes();
	}else if(n6.hasClass("show")){
	    oSelected = catg.getSelectedNodes();
	}else if(n7.hasClass("show")){
		oSelected = seeyonreport.getSelectedNodes();
	}
	if(oSelected!=null) {
		var sourceType = oSelected.data.sourceType;
		if(sourceType == -1){
			return;
		}
		var oSelectNode = $('#domain2');
		if(!oSelected.children){
			if(sourceType == 0){
				return;
			}
			if(!isExistItem(oSelected)){
			  tempsNodeArray[tempsNodeArray.length] = oSelected;
			  if(sourceType == 1 && !isExistItem(oSelected,true)){
				tempsNodeArray[tempsNodeArray.length] = oSelected;
			  }
			}else{
				alertMsg('${ctp:i18n("bizconfig.create.menu.exist")}');
				return;
			}
		}else{
			 getAllItems(oSelected);
		}

		if(tempsNodeArray.length>0) {
			for(var i=0;i<tempsNodeArray.length;i++) {
				oSelectNode.append(getTrString(tempsNodeArray[i]));
			}
		}else{
			alertMsg('${ctp:i18n("bizconfig.create.menu.exist")}');
			return;
		}
		tempsNodeArray.length = 0;
		
		checkBizMerge();
	}
}

function getAllItems(oSelected) {
	var oChildNodes = oSelected.children;
	if(!oChildNodes){
		return;
	}
	for(var i=0;i<oChildNodes.length;i++) {
		var child = oChildNodes[i];
		if(!child.children && child.data.sourceType != 0){
			if(!isExistItem(child)){
				tempsNodeArray[tempsNodeArray.length] = child;
				if (child.data.sourceType == 1  && !isExistItem(child,true)){
			        tempsNodeArray[tempsNodeArray.length] = child;
				}
			}
		} else {
			getAllItems(child);
		}
	}
}

function isExistItem(templeteNode,isflow) {
	var sourceIdAry = document.getElementsByName('sourceId');
	if(sourceIdAry){
		for(var i=0; i<sourceIdAry.length; i++) {
			if(templeteNode.data.sourceType==1){
				var isExist1 = false;
				var isExist2 = false;
				if(isExistFlowMenu(templeteNode.data.sourceValue,"1")){
					isExist1 = true;
				}
				if(isExistFlowMenu(templeteNode.data.sourceValue,"2")){
					isExist2 = true;
				}
				if (isflow && (isExist1 || isExist2)){
					return true;
				}
				if(isExist1 && isExist2){
					return true;
				}else{
				    return false;
				}
			}else{
				if(sourceIdAry[i].value==templeteNode.data.sourceValue && $(sourceIdAry[i]).parent().find("#sourceType").val() == (templeteNode.data.sourceType+"") ){
					return true;
				}
			}
		}
	}
	return false;
}

function isExistFlowMenu(id,type){
	var flowMenuTypeNameAry = document.getElementsByName('flowMenuTypeName');
	for(var m=0; m<flowMenuTypeNameAry.length; m++) {
		if(flowMenuTypeNameAry[m].getAttribute("businessId")==id){
			var value = flowMenuTypeNameAry[m].value;
			var flowMenuTypeRadioAry = document.getElementsByName(value);
			for(var n=0; n<flowMenuTypeRadioAry.length; n++) {
				if(flowMenuTypeRadioAry[n].type=="radio" && flowMenuTypeRadioAry[n].checked && flowMenuTypeRadioAry[n].value==type)
				 return true;
			}
		}
	}
	return false;
}

/*
* 获取列名
*/
function getTrString(obj1) {
	var oTr = document.createElement('div');
	oTr.id = 'tr'+obj1.id;
	oTr.className = "font_size12";
	var sourceType = obj1.data.sourceType;
	oTr.onclick = function(){
		selectTrObj(this);
	};
	oTr.ondblclick = function(){
	  removeTrObj(this);
	};
	//根据传过来的id进行解析获得菜单的名称
	var oTitle = getModelName(obj1);
	var formName = (typeof obj1.title != "undefined" && obj1.title != null) ? (obj1.title.indexOf("(") > -1 && obj1.title.indexOf(")") > -1 ? obj1.title.substring(obj1.title.lastIndexOf("(") + 1,obj1.title.lastIndexOf(")")) : "") : "";//obj1.title
	var _title = formName == "" ? obj1.name : "${ctp:i18n('form.business.menuname.label')} : " + obj1.name + "&#13;${ctp:i18n('form.business.formname.label')} : " + formName + "&#13;${ctp:i18n('form.business.creator.label')} : " + obj1.data.formCreator;
	_title = _title.replace(/\'/g,"&apos;");
	obj1.name=obj1.name.replace(/\'/g,"&apos;");
	var odiv = $("<div id='title"+obj1.id+"' title='" + _title + "' class='clearfix' style='line-height: 20px;margin: 3px;'></div>");
	$(oTr).append(odiv);
	odiv.append("<div class='left'>"+oTitle+"</div>");
	var oTd2 = $("<div class='padding_l_5 left'><div>");
	$(odiv).append(oTd2);
	oTd2.append("<div class='left' style='width: 160px;'><div class='font_size12 common_txtbox_wrap' style='width: 150px;text-align: left;'><input class='validate' type='text' id='menuName' name='menuName' businessId='" + obj1.data.sourceValue + "' value='" + obj1.name + "' inputName='"+oTitle+"' validate=\"avoidChar:'\\/|<>:*?;\\'&%$#&#34;',name:'${ctp:i18n('form.menu.menuname.label')}',notNull:true,isWord:true,maxLength:25\"></div></div>");
	var flowMenuTypeName = "flowMenuType"+random();
	if(sourceType==1){
        var isCreateType = 1;
	    $("#domain2").find("input[name='sourceId'][value='" + obj1.data.sourceValue + "']").each(function(){
	        var temp = $(this).parent().find("input[type='radio']:checked");
	        if (temp.val() == 1 || temp.val() == "1"){
	            isCreateType = 2;
	        }
	    });
	    
	    var menuTypediv = $("<div class=\"left\"></div>")
		var ftLabel1 = $("<label for='"+flowMenuTypeName+"1' />");
		if(isCreateType==1){
			ftLabel1.append($("<input class='margin_l_5' type='radio' id='"+flowMenuTypeName+"' name='"+flowMenuTypeName+"' value='1'  checked='checked' />"));
			oTr.id = oTr.id+'1';
		}else{
			ftLabel1.append($("<input class='margin_l_5' type='radio' id='"+flowMenuTypeName+"' name='"+flowMenuTypeName+"' value='1'  />"));
		}
		ftLabel1.append("${ctp:i18n('common.toolbar.new.label')}");
		menuTypediv.append(ftLabel1);
		var ftLabel2 = $("<label for='"+flowMenuTypeName+"2' />");
		if(isCreateType==2){
			ftLabel2.append($("<input class='margin_l_5' type='radio' id='"+flowMenuTypeName+"' name='"+flowMenuTypeName+"' value='2' checked='checked' />"));
			var menuName = $("#menuName",oTd2).val();
			$("#menuName",oTd2).val(menuName + "(${ctp:i18n('imagenews.list.label') })");
			oTr.id = oTr.id+'2';
		}else{
			ftLabel2.append($("<input class='margin_l_5' type='radio' id='"+flowMenuTypeName+"' name='"+flowMenuTypeName+"' value='2' />"));
		}
		ftLabel2.append("${ctp:i18n('imagenews.list.label') }");
		menuTypediv.append(ftLabel2);
		oTd2.append(menuTypediv);
		$("#"+flowMenuTypeName,oTd2).disable(true);
	}else{
		oTd2.append($("<input type='hidden' id='"+flowMenuTypeName+"' name='"+flowMenuTypeName+"' value='0' />"));
	}
	oTd2.append("<input type='hidden' id='flowMenuTypeName' sourceType='"+ sourceType +"' businessId='"+ obj1.data.sourceValue +"' name='flowMenuTypeName' value='"+ flowMenuTypeName +"' />");
	oTd2.append("<input type='hidden' id='sourceType' name='sourceType' value='" + sourceType + "'/>");
	oTd2.append("<input type='hidden' id='sourceId' name='sourceId' value='" + obj1.data.sourceValue + "'/>");
	oTd2.append("<input type='hidden' id='menuId' name='menuId' value='" + random() + "'/>");
	oTd2.append("<input type='hidden' id='formAppmainId' name='formAppmainId' value='" + obj1.data.formAppmainId + "'/>");
	return oTr;
}

/**
 * 选择右侧菜单已选项
 */
function selectTrObj(trObj){
  $("#domain2").find("div[id^='tr']").each(function(i){
    if(this.id == trObj.id){
      sSelectTrIndex = i;
      $(this).css("background","highlight");
      $(this).css("color","highlighttext");
    }else{
      $(this).css("background","");
      $(this).css("color","");
    }
  });
}

/**
 * 删除右侧菜单已选项
 */
function removeMenu(){
  var obj;
  $("#domain2").find("div[id^='tr']").each(function(i){
    if(i==sSelectTrIndex){
      obj = this;
    }
  });
  if(obj){
    removeTrObj(obj);
  }
}

/**
 * 双击明细选项删除右侧菜单已选项
 */
function removeTrObj(trObj){
    /*var menu = getListOrNewMenu(trObj);
    if(menu){
      menu.remove();
    }*/
    $(trObj).remove();
	sSelectTrIndex = -1;
	
	checkBizMerge();
}

function checkBizMerge() {
  var mergeLength = 0;
  $("#domain2").find("input[name='sourceType'][value='1']").each(function(){
    var temp = $(this).parent().find("input[type='radio']:checked");
    if (temp.val() == 2 || temp.val() == "2"){
      mergeLength ++;
    }
  });
  
  if (mergeLength > 1) {
    $("#bizMerge").attr("disabled", false);
    if ($("#bizMerge")[0].checked) {
      $("#bizMergeName").attr("disabled", false);
    } else {
      $("#bizMergeName").attr("disabled", true);
    }
  } else {
    $("#bizMerge").attr("disabled", true);
    $("#bizMergeName").attr("disabled", true);
    $("#bizMerge").attr("checked", false);
    $("#bizMergeName").addClass("color_gray").val($("#bizMergeName").attr("defaultValue"));  
  }
}

function selectBizMerge() {
  if ($("#bizMerge")[0].checked) {
    $("#bizMergeName").attr("disabled", false);
  } else {
    $("#bizMergeName").attr("disabled", true);
    $("#bizMergeName").addClass("color_gray").val($("#bizMergeName").attr("defaultValue"));  
  }
}

/**
 * 菜单已选项上下排序
 */
function moveMenu(direction){
  $("#bizForm").resetValidate();
  var temp = null;
  var temp1 = false;
  var menuName = null;
  $("#domain2").find("div[id^='tr']").each(function(i){
    if(i == sSelectTrIndex){
      var sourceType = $(this).find("#sourceType")[0].value;
      var menuType;
      menuName = $("#menuName",$(this)).val();
      if(sourceType === "1"){
        menuType = $(this).find("input[type = 'radio']:checked")[0].value;
      }
      if(direction == "up"){
        if(sSelectTrIndex==0 || sSelectTrIndex==-1) {
          return;
        }
        temp = $(this).prev();
        if(temp.attr("id")){
          temp.before(this.outerHTML);
          $(this).remove();
          temp1 = true;
	        temp = $(temp).prev();
        }
      }else if(direction == "down") {
        if(sSelectTrIndex==-1) {
          return;
        }
        temp = $(this).next();
        if(temp.attr("id")){
          temp.after(this.outerHTML);
          $(this).remove();
          temp1 = true;
	        temp = $(temp).next();
       }
      }
      if(sourceType === "1" && menuType){
        $(temp).find("input[type = 'radio']").each(function(){
          if($(this).val() == menuType){
            $(this).attr("checked",true);
          }
        });
      }
    }
  });
  if (temp != null){
	  temp.unbind("click").bind("click",function(){
	    selectTrObj(this);
	  });
	  temp.unbind("dblclick").bind("dblclick",function(){
	    removeTrObj(this);
	  });
	  $("#menuName",temp).val(menuName);
  }
  if(temp1){
    if(direction == "up"){
          sSelectTrIndex--;
    }else if(direction == "down") {
          sSelectTrIndex++;
    }
  }
}
/**
 * 响应在选中菜单可选项后，使用上下方向键进行上下排序
 */
function moveMenuByKey(view) {
	if(view == 'true')
		return;
	if(event.keyCode==38)
		moveMenu('up');
	if(event.keyCode==40)
		moveMenu('down');
}

function getModelName(oSelected){
	return "[" + oSelected.data.sourctTypeName + "]";
}


function random() {
	var random = getUUID();
	return random;
}

var isSave = false;
function saveV3xBizConfig(isAdd) {
  if (isSave){
    return false;
  } else {
    isSave = true;
  }
	var bizForm = $("#bizForm");
	var bizConfigName = $("#bizConfigName").val();
	var bizConfigId = $("#bizConfigId").val();
	if(checkSecMenuDuplicate()) {
	  isSave = false;
		return false;
	}
	var currentAccountId;
	var flag = checkBizConfigName(bizConfigName.trim(), currentAccountId, bizConfigId);
	if(flag == "true" || flag == true){
	  alertMsg('${ctp:i18n("bizconfig.create.menu.samename")}');
	  isSave = false;
		return false;
	}
    	bizForm.attr("action","${path}/form/business.do?method=newSaveBusiness");

   	/*if(!validateHaveNewMenu()){
   	  isSave = false;
   	  return false;
   	}*/
    if(!validateMenuAndSetSubmitInfo()){
      isSave = false;
    	return false;
    }
   	if($("#bizMerge")[0].checked && ($("#bizMergeName").val().trim() == "" || $("#bizMergeName").val() == $("#bizMergeName").attr("defaultValue"))){
      alertMsg('${ctp:i18n("bizconfig.flowtemplate.list.merge3")}');
   	  isSave = false;
      return false;
   	}
    var obj = {domains:['domain1','domain2','domain3']};
    obj.targetWindow=getCtpTop().main;
     obj.callback=function(){
		 try{
		 getCtpTop().refreshMenus();
		 getCtpTop().showMenu("${path}/form/business.do?method=listBusiness");
		 } catch(e){
		 }
		 if(window.parentDialogObj['createBiz']){
             window.parentDialogObj['createBiz'].close();
         }
     };
    if($("#bizForm").validate({errorAlert:false})){
    new MxtProgressBar({text: "${ctp:i18n('bizconfig.create.saveing')}"});
    $("#bizForm").jsonSubmit(obj);
    } else {
      isSave = false;
      return false;
    }
    return true;
}

/**
 * 校验是否包含流程表单的新建菜单，如果有新建菜单就必须存在对应的列表菜单
 */
function validateHaveNewMenu(){
  var result = true;
  var msg = "";
  $("#domain2").find("input[name='sourceType'][value='1']").each(function(){
    var temp = $("#domain2").find("input[name='sourceId'][value='"+$(this).parent().find("#sourceId").val()+"']");
    var temp1 = $(this).parent().find("input[type='radio']:checked");
    var temp2 = $(this).parent().find("#menuName");
    if(temp.length == 1){
      if (temp1.val() == 1 || temp1.val() == "1"){
        result = false;
        msg += ($.i18n('bizconfig.create.menu.template.needlist',temp2.val(),temp2.val()) + "\r\n");
      }
    }
  });
  if(msg != ""){
	  alertMsg(msg);
  }
  return result;
}
/**
 * 根据已有菜单，获取对应的新建或者列表菜单，针对流程表单
 */
function getListOrNewMenu(obj){
  if ($("#sourceType",obj).val() == 1){
    var temp;
    var flowtype = $(obj).find("input[type='radio']:checked");
    if (flowtype.val() == "1"){
      return false;
    }
    var menu;
    $("#domain2").find("input[name='sourceId'][value='"+$("#sourceId",obj).val()+"']").each(function(){
      var temp1 = $(this).parent().find("input[type='radio']:checked");
      if (temp1.val() != flowtype.val()){
        menu = $(this).parents("[id^='tr']");
      }
    });
    return menu;
  }
  return false;
}

function validateMenuAndSetSubmitInfo(){
	var sC = document.getElementsByName("menuName");
	if(sC==null || sC.length==0){
	  alertMsg('${ctp:i18n("bizconfig.create.menu.must")}');
   		return false;
   	}
	return true;
}

function checkBizConfigName(name, accountId, bizConfigId){
  var bizManager = new businessManager();
  var result = bizManager.checkBizConfigName(name,bizConfigId);
	return result;
}

function checkSecMenuDuplicate(){

	var menuMap = new Properties();
	var menuAry = document.getElementsByName('menuName');
	markDivToRed(menuAry);
	for(var k=0; k<menuAry.length; k++) {
	  if(menuAry[k].value==""){
	    continue;
	  }
		if(menuMap.containsKey(menuAry[k].value)){
		  alertMsg("${ctp:i18n('bizconfig.create.menu.son')}");
			return true;
		}else{
			menuMap.put(menuAry[k].value,menuAry[k].value);
		}
	}
	return false;
}

/**
* 有同名时除了提醒，文本框也要标红
* @param menuAry
* @param menuMap
 */
function markDivToRed(menuAry){
	var menuColorMap = new Properties();
	for(var k=0; k<menuAry.length; k++) {
		if (menuAry[k].value == "") {
			continue;
		}
		if (menuColorMap.containsKey(menuAry[k].value)) {
			$("[name=menuName]").eq(k).parent().css("border", "1px solid #ff0000");
		}else{
			$("[name=menuName]").eq(k).parent().css("border","1px solid #ccc");
			menuColorMap.put(menuAry[k].value,menuAry[k].value);
		}
	}
}
function alertMsg(msg){
  $.alert(msg);
}
</script>