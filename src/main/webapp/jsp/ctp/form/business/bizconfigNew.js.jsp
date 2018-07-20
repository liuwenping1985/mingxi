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
	        panels: 'Account,Department,Team,Post,Level,Outworker',
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
	$("#sureBut").click(function(){
		saveV3xBizConfig(true);
	});
	if ($("#bizImageUrl").val()==""){
	  setDefalutImage();
	} else {
	  showImage($("#bizImageUrl").val());
	}
	changedTagType("business.do?method=listbizdatatree&type=formApp");
	
	new inputChange($("#bizMergeName"), "${ctp:i18n('bizconfig.flowtemplate.list.merge1')}", "color_gray");
	new inputChange($("#bizEdocMergeName"), "${ctp:i18n('bizconfig.flowtemplate.list.merge1')}", "color_gray");
	checkBizMerge();
	checkEdocBizMerge();
});

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
  dymcCreateFileUpload("dyncid", "11", "gif,jpg,jpeg,png,bmp", "11", false, 'imageCallback', null, true, true, null, true, false, '512000');
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
			  if((sourceType == 1 ||sourceType == 401 ||sourceType == 402 ||sourceType == 403 ||sourceType == 404) && !isExistItem(oSelected,true)){
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
		checkEdocBizMerge();
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
	var odiv = $("<div class='clearfix' style='line-height: 20px;margin: 3px;'></div>");
	$(oTr).append(odiv);
	odiv.append("<div class='left'>"+oTitle+"</div>");
	var oTd2 = $("<div class='padding_l_5 left'><div>");
	$(odiv).append(oTd2);
	oTd2.append("<div class='left' style='width: 160px;'><div class='font_size12 common_txtbox_wrap' style='width: 150px;text-align: left;'><input class='validate' type='text' id='menuName' name='menuName' businessId='" + obj1.data.sourceValue + "' value='" + obj1.name + "' inputName='"+oTitle+"' validate=\"name:'菜单名称',notNull:true,isWord:true,maxLength:15\"></div></div>");
	var flowMenuTypeName = "flowMenuType"+random();
	if(sourceType==1 || sourceType==401 || sourceType==402 || sourceType==403 ||sourceType == 404){
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
	checkEdocBizMerge();
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

function checkEdocBizMerge() {
  var mergeLength = 0;
  $("#domain2").find("input[name='sourceType'][value='401']").each(function(){
    var temp = $(this).parent().find("input[type='radio']:checked");
    if (temp.val() == 2 || temp.val() == "2"){
      mergeLength ++;
    }
  });  
  $("#domain2").find("input[name='sourceType'][value='402']").each(function(){
    var temp = $(this).parent().find("input[type='radio']:checked");
    if (temp.val() == 2 || temp.val() == "2"){
      mergeLength ++;
    }
  });  
  $("#domain2").find("input[name='sourceType'][value='403']").each(function(){
    var temp = $(this).parent().find("input[type='radio']:checked");
    if (temp.val() == 2 || temp.val() == "2"){
      mergeLength ++;
    }
  });  
  $("#domain2").find("input[name='sourceType'][value='404']").each(function(){
    var temp = $(this).parent().find("input[type='radio']:checked");
    if (temp.val() == 2 || temp.val() == "2"){
      mergeLength ++;
    }
  });  
  if (mergeLength > 1) {
    $("#bizEdocMerge").attr("disabled", false);
    if ($("#bizEdocMerge")[0].checked) {
      $("#bizEdocMergeName").attr("disabled", false);
    } else {
      $("#bizEdocMergeName").attr("disabled", true);
    }
  } else {
    $("#bizEdocMerge").attr("disabled", true);
    $("#bizEdocMergeName").attr("disabled", true);
    $("#bizEdocMerge").attr("checked", false);
    $("#bizEdocMergeName").addClass("color_gray").val($("#bizEdocMergeName").attr("defaultValue"));  
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

function selectEdocBizMerge() {
  if ($("#bizEdocMerge")[0].checked) {
    $("#bizEdocMergeName").attr("disabled", false);
  } else {
    $("#bizEdocMergeName").attr("disabled", true);
    $("#bizEdocMergeName").addClass("color_gray").val($("#bizEdocMergeName").attr("defaultValue"));  
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
      if(sourceType === "1" || sourceType === "401" || sourceType === "402" || sourceType === "403" || sourceType === "404"){
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
      if((sourceType === "1" || sourceType === "401" || sourceType === "402" || sourceType === "403" || sourceType === "404") && menuType){
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
	var bizConfigName = $("#bizConfigName").val();
	var bizConfigId = $("#bizConfigId").val();
	if(checkSecMenuDuplicate()) {
	  isSave = false;
		return false;
	}
	var currentAccountId;
	var flag = checkBizConfigName(bizConfigName.trim(), currentAccountId, bizConfigId);
	if(flag == "true" || flag == true){
		var memo = $("#memo").val();
		var meg="当前单位已经存在相同业务名称,是否继续？";
		if(memo.trim() == ""){
			var meg="当前单位已经存在相同业务名称,可填写备注以示区分,是否继续？";
		}
	    $.confirm({
	        'msg': meg,
	         ok_fn: function () {
	         	return  saveBiz();
	         },
	        cancel_fn:function(){ 
	        	isSave = false;
				return false;
			}
	    });
	}else{
		return  saveBiz();
	}
}

function saveBiz(){
		var bizForm = $("#bizForm");
		bizForm.attr("action","${path}/form/business.do?method=newSaveBusiness");
	    if(!validateMenuAndSetSubmitInfo()){
	      isSave = false;
	    	return false;
	    }
	   	if($("#bizMerge")[0].checked && ($("#bizMergeName").val().trim() == "" || $("#bizMergeName").val() == $("#bizMergeName").attr("defaultValue"))){
	      alertMsg("合并表单文菜单名称不能为空！");
	   	  isSave = false;
	      return false;
	   	}
	   	if($("#bizEdocMerge")[0].checked && ($("#bizEdocMergeName").val().trim() == "" || $("#bizEdocMergeName").val() == $("#bizEdocMergeName").attr("defaultValue"))){
	      alertMsg("合并公文菜单名称不能为空！");
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
			 window.parentDialogObj['createBiz'].close();
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