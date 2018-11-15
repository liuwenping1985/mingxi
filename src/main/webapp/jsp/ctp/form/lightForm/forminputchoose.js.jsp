<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
// JavaScript Document
var dialogParam =window.parentDialogObj["formInputChooseDialog"].getTransParams();;
var parentWin=dialogParam[0];
var splitObj=dialogParam[1];
var customJson=dialogParam[2];
var DialogTitle ="${ctp:i18n('form.fastmaking.dialogTitle')}";// 对话框标题
var ShowTitle = "${ctp:i18n('form.fastmaking.dialogTitle')}";// 主标题
var LeftUpTitle = "${ctp:i18n('form.fastmaking.leftUpTitle')}";// 左上区域的title
var LeftDownTitle = "${ctp:i18n('form.fastmaking.leftDownTitle')}";// 左下区域的title
var RightTitle = "${ctp:i18n('form.fastmaking.rightTitle')}";// 右区域的title
var LeftUpData = new Properties();// 左上区域的值,这里是一个Map对象
var LeftDownData = new Properties();// 左下区域的值,这里是一个Map对象
var RightData = new Properties();// 右边区域值,这里是一个Map对象
var IsShowLeftDown = true;// 是否显示左下区域
var IsShowSearch=true;//是否显示查询
var IsChooseSingel=false;//是否只能选择一个值
var IsWriteBlak=true;//是否将值回写到控件中
var IsShowUpAndDown=true;//是否显示上移和下移
var IsNeedReName = true;//是否需要显示重命名
var receiverId="${ctp:escapeJavascript(choose)}";//回显的text
var datafiledId=$("#"+receiverId,parentWin.document).attr("datafiledId");//相关联的text,在排序时有用到
var hideText=$("#"+receiverId,parentWin.document).attr("hideText");
//1==>自定义查询项, 2==>统计分组项,3==>统计项,4===>输出数据项(无流程表单),5==>排序设置,6===>日志设置,7==>其他特殊需求:和类型为5(排序设置取数据一样,但从左向右选时,没有排序设置)
var type = parseInt($("#"+receiverId,parentWin.document).attr("mytype")==null?"99":$("#"+receiverId,parentWin.document).attr("mytype"));
//byTable:过滤所属的表以此开头的field,可以为formmain,formson,这里忽略大小写
//byNeedTable:通过需要的表显示字段，如果是主表字段默认都需要显示，否则都需要以该表名一致。
//byInputType:过滤此种属性的field,可以为relationform等,以","隔开,这里忽略大小写
//byFieldName:过滤字段名称
//byFilterSysState过滤系统数据域中的状态
//isReName是否需要显示重命名
//var splitObj1='{"byTable":"formmain","byInputType":"relationform"}';
$('#searchbtn').click(function() {
	search();
});
$("#searchtext").keyup(function(event) {
    if (event.keyCode == 13) {
        search();
    }
});
$('#leftupdataarea').dblclick(function() {
	leftupdbclick();
});
$('#leftdowndataarea').dblclick(function() {
	leftdowndbclick();
});
$('#leftupdataarea').click(function() {
	leftupclick();
});
$('#leftdowndataarea').click(function() {
	leftdownclick();
});
$('#add').click(function() {
	middleAddclick();
});
$('#del').click(function() {
	delOption();
});
$('#rightdataarea').dblclick(function() {
	rightdbclick();
});
$('#up').click(function() {
	upordown(-1);
});
$('#down').click(function() {
	upordown(1);
});
$('#enter').click(function() {
	enterclick();
});
$('#cancel').click(function() {
	cancelButtonClick();
});
<%--var rightDatas = "${rightDatas}";--%>
function init()
{
	
	beforShow();
	show();
	<c:forEach items="${rightDatas}" var="rightData">
		$('#leftupdataarea option').each(function () {
			var optionobj = $(this);
			var value = optionobj.val();
			//获取分组最后一个selectedIndex
			if(value=="${rightData}"){
				addToRightarea(this);
			}
		});
	</c:forEach>
}

// 显示title及数据
function show() {
	if(type==6){
		$("#readme").removeClass("hidden");
		IsShowUpAndDown = false;
	}
	// 初始化显示所有要显示的标题
	//document.title = DialogTitle;// 设置title
	//有bug,屏蔽
	//parentWin.forminputdialog.setTitle(DialogTitle);
	$("#ShowTitle").text(ShowTitle);
	$("#LeftUpTitle").text(LeftUpTitle);
	$("#ShowTitle").text(ShowTitle);
	$("#RightTitle").text(RightTitle);
	// 如果需要显示左边底部
	if (IsShowLeftDown) {
		$("#leftdowndataarea").removeClass("hidden");
		$("#LeftDownTitle").text(LeftDownTitle);
		<c:forEach items="${otherFields}" var="otherField">
			var leftUpValObj = new Object();
			leftUpValObj.inputType = "${otherField.inputType}";
			leftUpValObj.showVal = "${otherField.fieldTitle}";
			LeftDownData.put("${otherField.inputType}",leftUpValObj);
		</c:forEach>
		var leftdowndatakeys = LeftDownData.keys();// 取得左下区域所有的实际值
		var ldHeight = $("#leftdowndataarea").height();
		var ldStr = '';
		for ( var i = 0; i < leftdowndatakeys.size(); i++) {
			var key = leftdowndatakeys.get(i);// 取得实际的值
			var value = LeftDownData.get(key);// 取得显示的值
			//ldStr += "<option value='"+key+"'>"+value+"</option>";
			if(typeof(value) == 'string'){
				ldStr += "<option value='"+key+"'>"+value+"</option>";
			}else{
				ldStr += "<option value='"+key+"' inputType='"+value.inputType+"'>"+value.showVal+"</option>";
			}
		}
		$("#leftdowndataarea").height(ldHeight).append(ldStr);
		
	} else {
		$("#LeftDownTitle").remove();
		$("#leftupdataarea").attr("size",24);
		$("#leftupdataarea").height($("#rightdataarea").height());
	}
	//是否显示查询
	if(IsShowSearch==null||IsShowSearch)
		{
		$("#showsearch").show();
		}
	else
		{
		$("#showsearch").remove();
		}
	//是否显示上移和下称
	if(IsShowUpAndDown==null||IsShowUpAndDown)
	{
		$("#UpAndDown").show();
	}
   else
	{
	    $("#UpAndDown").remove();
	    $("#leftupdataarea").width(260);
	    $("#leftdowndataarea").width(260);
	    $("#rightdataarea").width(265);
	}

	// 显示左上区域
	var lHeight = $("#leftupdataarea").height();
	var leftupdatakeys = LeftUpData.keys();// 取得左上区域所有的实际值
	var loStr = '';
	for ( var i = 0; i < leftupdatakeys.size(); i++) {
		var key = leftupdatakeys.get(i);
		var value = LeftUpData.get(key);
		if(typeof(value) == 'string'){
			loStr += "<option value='"+key+"'>"+value+"</option>";
		}else{
			loStr += "<option value='"+key+"' inputType='"+value.inputType+"'>"+value.showVal+"</option>";
		}
	}
	$("#leftupdataarea").height(lHeight).append(loStr);

	// 显示右区域
	var rHeight = $("#rightdataarea").height();
	var rightdatakeys = RightData.keys();// 取得右区域所有的实际值
	var roStr = '';
	if(type == 1){
		var resultJSON = $("#"+hideText,parentWin.document).val();
		var resultObj = ""
		if($.trim(resultJSON) != ""){
			resultObj = $.parseJSON(resultJSON);
		}
		for ( var i = 0; i < rightdatakeys.size(); i++) {
			var key = rightdatakeys.get(i);
			var value = RightData.get(key);
			var renameJSON = "";
			if($.trim(resultObj) != ""){
				for(var j = 0; j < resultObj.length; j++){
					var resObj = resultObj[j];
					if(key === resObj.key){
						renameJSON = $.toJSON(resObj);
						break;
					}
				}
			}
			roStr += "<option value='"+key+"' inputType='"+value.inputType+"' renameJSON='"+renameJSON+"'>"+value.title+"</option>";
		}
	}else{
		for ( var i = 0; i < rightdatakeys.size(); i++) {
			var key = rightdatakeys.get(i);
			var value = RightData.get(key);
			roStr += "<option value='"+key+"'>"+value.title+"</option>";
		}
	}
	$("#rightdataarea").height(rHeight).append(roStr);
}
// 添加选择的数据到右区域
function selecttoright(src) {

}
// 移除选择的数据
function removeOption(selobj) {
	if (selobj.selectedIndex > -1) {
		var opt = selobj.options[selobj.selectedIndex];//将要移除的列
		var value = opt.text;// 取得显示的值
		var nameSplit={};
		if(value){
			nameSplit[0] = value.substring(0,value.indexOf("]")+1);
			nameSplit[1] = value.substring(value.indexOf("]")+1,value.length);
		}
		//选择的是重复表的表头，删除所有以重复表头开头的option
		if(opt.value.split(".").length==1){
			$('#rightdataarea option').each(function () {
				var optionObj = $(this);
				var delKey = optionObj.val();
				//获取分组最后一个selectedIndex
				if(delKey.split(".")[0]==opt.value){
					$("#rightdataarea option[value='"+delKey+"']").remove();
					RightData.remove(delKey);
				}
			});
			return;
		}else if(nameSplit[0]!="[${ctp:i18n('form.base.mastertable.label')}]"){
			//所选字段上一个元素是重复表表头
			if(selobj.options[selobj.selectedIndex-1].value.split(".").length==1){
				//存在下一元素且下一元素不是相同重复表元素，删除所选元素和表头
				if(selobj.options[selobj.selectedIndex+1]&&selobj.options[selobj.selectedIndex+1].value.split(".")[0]==opt.value.split(".")[0]){
						RightData.remove(selobj.options[selobj.selectedIndex].value);//从右侧的数据Map中移除
						selobj.remove(selobj.selectedIndex);
				}else{
					RightData.remove(selobj.options[selobj.selectedIndex-1].value);//从右侧的数据Map中移除
					selobj.remove(selobj.selectedIndex-1);
					RightData.remove(selobj.options[selobj.selectedIndex].value);//从右侧的数据Map中移除
					selobj.remove(selobj.selectedIndex);
				}
			}else{
				RightData.remove(selobj.options[selobj.selectedIndex].value);//从右侧的数据Map中移除
				selobj.remove(selobj.selectedIndex);
			}
		}else{
			selobj.remove(selobj.selectedIndex);
			RightData.remove(opt.value);//从右侧的数据Map中移除
		}
		removeOption(selobj);
	}
}
// 移除选择的数据
function delOption() {
	var selectObj = document.getElementById("rightdataarea");
	removeOption(selectObj);
}
// 上下排序
function upordown(nDir) {
	var selectObj = document.getElementById("rightdataarea");
	if (selectObj.selectedIndex < 0)
		return;
	if (nDir < 0) {
		if (selectObj.selectedIndex == 0)
			return;
	} else {
		if (selectObj.selectedIndex == selectObj.options.length - 1)
			return;
	}
	var opt = selectObj.options[selectObj.selectedIndex];
	var inputType = $(opt).attr("inputtype");
	var otheropt = selectObj.options[selectObj.selectedIndex + nDir];
	var other_inputType = $(otheropt).attr("inputtype");
	var opt_isMaster,otheropt_isMaster;
	if(opt.text.substring(0,opt.text.indexOf("]")+1)!="[${ctp:i18n('form.base.mastertable.label')}]"){
		opt_isMaster = false;
	}else{
		opt_isMaster = true;
	}
	if(otheropt.text.substring(0,otheropt.text.indexOf("]")+1)!="[${ctp:i18n('form.base.mastertable.label')}]"){
		otheropt_isMaster = false;
	}else{
		otheropt_isMaster = true;
	}
	//移动元素为重复表字段(非重复表表头),只能在重复表字段间移动。
	if((otheropt_isMaster||otheropt.value.split(".").length==1||inputType==="textnotes"||inputType==="linespace")&&(!opt_isMaster&&opt.value.split(".").length==2))
	{
		return;
	}
	//移动元素为主表字段，间隔行，文字备注的，且被移动的元素是重复表的，直接移动到整个重复表的上或下
	if(!otheropt_isMaster&&(opt_isMaster||inputType==="textnotes"||inputType==="linespace"))
	{
		//分组重复表排序
		var lastOpt = null;
		var firstOpt=null;
		$('#rightdataarea option').each(function () {
			var optionobj = $(this);
			var value = optionobj.val();
			//获取分组最后一个selectedIndex
			if(value.split(".")[0]==otheropt.value.split(".")[0]){
				if(firstOpt==null){
					firstOpt = this;
				}
				lastOpt = this;
			}
		});
		$("#rightdataarea option[value='"+opt.value+"']").remove();
		if(nDir<0){
			$(firstOpt).before(opt);
		}else{
			$(lastOpt).after(opt);
		}
		return;
	}
	//移动元素为重复表表头字段处理逻辑
	if(opt.value.split(".").length==1&&inputType!="textnotes"&&inputType!="linespace")
	{
		//分组重复表排序
		var other_options = new Array();
		var opt_firestIndex,opt_lastIndex,opt_indexObj,opt_lastObj;
		//重复表放入集合
		$('#rightdataarea option').each(function () {
			var optionobj = $(this);
			var value = optionobj.val();
			if(value.split(".")[0]==opt.value){
				if(opt_firestIndex==null){
					opt_firestIndex = optionobj.index();
					opt_indexObj = this;
				}else{
					opt_lastIndex = optionobj.index();
					opt_lastObj = this;
				}
			}
		});

		//重定义上下元素
		if(nDir<0){
			if(opt_firestIndex-1<0){
				otheropt =  selectObj.options[0];
			}else{
				otheropt =  selectObj.options[opt_firestIndex-1];
			}
		}else{
			if(opt_lastIndex+1==selectObj.options.length){return;}
			otheropt =  selectObj.options[opt_lastIndex+1];
		}
		if(otheropt.text.substring(0,otheropt.text.indexOf("]")+1)!="[${ctp:i18n('form.base.mastertable.label')}]"&&other_inputType!="textnotes"&&other_inputType!="linespace"){
			otheropt_isMaster = false;
			$('#rightdataarea option').each(function () {
				var optionobj = $(this);
				var value = optionobj.val();
				//上下元素为重复表的，放入集合
				if(!otheropt_isMaster){
					if(value.split(".")[0]==otheropt.value.split(".")[0]){
						other_options.push(this);
					}
				}
			});
		}else{
			otheropt_isMaster = true;
		}
		//上下元素为主表字段
		if(otheropt_isMaster||other_inputType==="textnotes"||other_inputType==="linespace"){
			$("#rightdataarea option[value='"+otheropt.value+"']").remove();
			if(nDir<0){
				$(opt_lastObj).after(otheropt);
			}else{
				$(opt_indexObj).before(otheropt);
			}
		}else{
			//上下元素为重复表字段
			for(var i=0;i<other_options.length;i++){
				$("#rightdataarea option["+i+"]").remove();
				if(nDir<0){
					//上移
					$(opt_lastObj).after(other_options[other_options.length-i-1]);
				}else{
					//下移
					$(opt_indexObj).before(other_options[i]);
				}
			}
		}
		return;
	}
	$("#rightdataarea option[value='"+otheropt.value+"']").remove();
	if(nDir<0){
		$(opt).after(otheropt);
	}else{
		$(opt).before(otheropt);
	}
//	var text = opt.text;
//	var value = opt.value;
//	opt.text = otheropt.text;
//	opt.value = otheropt.value;
//	otheropt.text = text;
//	otheropt.value = value;
	//OA-120767【原型客户验证】-深圳利亚德光电：快速制单右选待选项后，全选已选项点击向下排序，有些问题
	selectObj.selectedIndex = $(opt).index();
}
// 返回map,map中装的是右区域的值,key为实际值,value为显示值
//修改为直接塞值给父页面的同时,也返回值
function OK() {
	var tableName = "";
	var dataareaObj = document.getElementById("rightdataarea");
	var returnvalues = new Array();
	var key="";
	var value="";
	for ( var i = 0; i < dataareaObj.length; i++) {
		var optionObj = dataareaObj.options[i];
		if(i === dataareaObj.length-1){
			key += optionObj.value;
			value += optionObj.text;
		}else{
			key += optionObj.value+",";
			value += optionObj.text+",";
		}
		var defObj = new Object();
		defObj.key = optionObj.value;
		defObj.text = optionObj.text;
		defObj.inputType = $(optionObj).attr('inputtype');
		var renameJson = $(optionObj).attr("renameJSON");
		if($.trim(renameJson) != ""){
			var renameObj = $.parseJSON(renameJson);
			defObj.title = $.trim(renameObj.title);
			defObj.defaultType = $.trim(renameObj.defaultType);
			defObj.defaultVal = $.trim(renameObj.defaultVal);
			defObj.inputType = $.trim(renameObj.inputType);
			if($.trim(renameObj.inputType) == 'checkbox'){
				defObj.frontlabelVal = $.trim(renameObj.frontlabelVal);
			}
			//判断是否为组织控件
			var isOrgType = $.trim(renameObj.inputType) == 'member' || $.trim(renameObj.inputType) == 'multimember'  
					||$.trim(renameObj.inputType) == 'department' || $.trim(renameObj.inputType) == 'multidepartment' 
					|| $.trim(renameObj.inputType) == 'account' || $.trim(renameObj.inputType) == 'multiaccount';
			
			if(isOrgType){
				if($.trim(renameObj.defaultType) == 'text'){
					defObj.handOrgIds = $.trim(renameObj.handOrgIds);
				}
				if($.trim(renameObj.inputType) == 'department' || $.trim(renameObj.inputType) == 'multidepartment'){
					defObj.treeShow = $.trim(renameObj.treeShow);
				}
			}
			defObj.isSettingDefaultVal = $.trim(renameObj.isSettingDefaultVal);
			//文字备注
			//OA-116661 快速制单，文字备注重命名后进入高级设置，提示不存在
			if(defObj.inputType == 'textnotes'){
				defObj.value = optionObj.text.substring(optionObj.text.indexOf("(")+1,optionObj.text.length-1);
				defObj.text = defObj.value;
			}
		}

		//returnvalues[returnvalues.length] = {'key':optionObj.value,'value':optionObj.text};
		returnvalues[returnvalues.length] = defObj;
	}
	
	
	if(IsWriteBlak){ 
		if(type == 1){
			//自定义查询项
			$("#"+hideText,parentWin.document).val($.toJSON(returnvalues));
		}else{
			$("#"+hideText,parentWin.document).val(key);
		}
		$("#"+receiverId,parentWin.document).val(value);
	}
	var returnobj = new Object();
	returnobj.showTypeSelected = $("#showTypeSelected option:selected").val();
	returnobj.returnvalues=returnvalues;
	return returnobj;
}
// 右边选择框的双击事件
// 当为输出数据项,自定义查询统计项,统计分组项时重命名
// 当为排序字段,统计项时进行删除
function rightdbclick() {
	var selectObj = document.getElementById("rightdataarea");
    if (selectObj.selectedIndex < 0||$(selectObj).find("option:selected").attr('inputtype')==="linespace"){
		return;
    }
    if(splitObj != null){
    	IsNeedReName = splitObj.isReName == null ? true : splitObj.isReName;
    }
	IsNeedReName =true;
	type = 4;
	if((type===7||type===4||type===1||type===2||type===11) && IsNeedReName){
		var obj=new Array();
		obj[0]=window;
		obj[1]=RightData;
		obj[2]=type;
		//选中的值
		var _selectedVal = $(selectObj).find("option:selected").val();
		var _fieldName = "";
		if($.trim(_selectedVal) != ""){
			var selArray = _selectedVal.split(".");
			if(selArray.length > 1){
				_fieldName = selArray[1];
			}
		}
		var url = '${path}/form/lightForm.do?method=formInputChooseRename&fieldName=' + _fieldName;
		  //window.showModalDialog(url,window,"DialogHeight=200px;DialogWidth=350px;status=no;");
			var dialog = $.dialog({
			    id:"formInputChooseRenameDialog",
				url: url,
			    title : "${ctp:i18n('form.forminputchoose.rename')}",
			    width:450,
				height:300,
				targetWindow:getCtpTop(),
				transParams:obj,
			    buttons : [{
			      text : "${ctp:i18n('form.forminputchoose.enter')}",
			      id:"sure",
				  isEmphasize: true,
			      handler : function() {
				      var result = dialog.getReturnValue();
				      if(result=='true'){
				    	   dialog.close();
                          //OA-110752表单查询设置，双击某一个字段，修改输出数据项标题并确定保存后，无法再双击其它字段修改了。只有ie10 下有这个问题
                          if($.browser.msie && $.browser.version=="10.0"){
                              var oStr = "<option value=''></option>";
                              $("#rightdataarea").append(oStr);
                              $("#rightdataarea option:last").remove();
                          }
                      }else if(result=='false'){
				      }else{
				    	  $.alert(result);
				      }
			      }
			    }, {
			      text : "${ctp:i18n('form.query.cancel.label')}",
			      id:"exit",
			      handler : function() {
			      	dialog.close();
			      }
			    }]
			  });
			return dialog;
	} else {
		delOption();
	}
}

var lastIndex_line = 0;
var lastIndex_text = 0;
//添加值到右侧区域
function addToRightarea(opt)
{
	//是否只能单选
	if(IsChooseSingel&&RightData.keys().size()>0){
		$.alert("${ctp:i18n('form.forminputchoose.canonlychooseone')}");
		return;
	}
	var key = opt.value;// 取得实际的值
	var value = opt.text;// 取得显示的值
	var inputType = $.trim($(opt).attr("inputType"));
	var nameSplit={};
	if(value){
		nameSplit[0] = value.substring(0,value.indexOf("]")+1);
		nameSplit[1] = value.substring(value.indexOf("]")+1,value.length);
	}
	//判断右侧区域是否有值
	if(RightData.containsKey(key)&&inputType!="textnotes"&&inputType!="linespace"){
		//OA-14954 应用检查：自定义查询设置时选择了表单数据域到右边后，又选择系统数据域，点击向右箭头时，会逐一字段弹出此提示对话框
		//$.alert(value+"${ctp:i18n('form.forminputchoose.cantrechoose')}");
		return;
	}
	//设置排序
	if(type==5){
		var url = '${path}/form/component.do?method=formInputChooseSort';
		  //value=window.showModalDialog(url,value,"DialogHeight=200px;DialogWidth=350px;status=no;");
		  var dialog = $.dialog({
		        id:"formInputChooseSortDialog",
				url: url,
			    title : "${ctp:i18n('form.forminputchoose.order')}",
			    width:350,
				height:200,
				targetWindow:getCtpTop(),
				transParams:value,
			    buttons : [{
			      text : "${ctp:i18n('form.forminputchoose.enter')}",
			      id:"sure",
				  isEmphasize: true,
			      handler : function() {
				      value = dialog.getReturnValue();
				      if(value!='false'&&value!=null&&value!="null"){
				    	    var oStr = "<option value='"+key+"'>"+value+"</option>";
				  		    $("#rightdataarea").append(oStr);
				  		    if($.v3x.isMSIE7){//ie7下宽度会变化
				  			    $("#rightdataarea").width(($("#rightdataarea").parent().width()));
				  		    }
						  	//RightData.put(key,value);//从右侧的数据Map中添加此对象
						  	var rightObj = new Object();
							rightObj.title = value;
						  	RightData.put(key,rightObj);//从右侧的数据Map中添加此对象
						    dialog.close();
				      }
			      }
			    }, {
			      text : "${ctp:i18n('form.forminputchoose.cancel')}",
			      id:"exit",
			      handler : function() {
			      	dialog.close();
			      }
			    }]
			  });
			return dialog;
		  }
	if(value==null||"null"==value){
		return;
	}
	var rightObj = new Object();
	var oStr;
	var isAddDetailForm = true;
	var inputType = $.trim($(opt).attr("inputType"));
	//重复表分组
	if(nameSplit[0]!="[${ctp:i18n('form.base.mastertable.label')}]"&&inputType!="textnotes"&&inputType!="linespace"){
		var reghtKeyList = RightData.keys();
		for(var k=0;k<reghtKeyList.size();k++){
			var rightkey = reghtKeyList.get(k);
			if(rightkey.split(".")[0]==key.split(".")[0]){
				isAddDetailForm = false;
				break;
			}
		}
		//第一次添加重复表，增加重复表选项和选中重复表字段选项
		if(isAddDetailForm){
			oStr="<option value='"+key.split(".")[0]+"' style='text-align: center; background-color: #bac1c7' inputType='detailform'>"+nameSplit[0]+"</option>";
			$("#rightdataarea").append(oStr);
			oStr = "<option value='"+key+"' inputType='"+inputType+"'>"+value+"</option>";
			$("#rightdataarea").append(oStr);
		}else{
			var addTag,selectObj;
			//分组重复表排序
			var selectCtrl = $('#rightdataarea');
			var lastOpt = null;
			$('#rightdataarea option').each(function () {
				var optionobj = $(this);
				var value = optionobj.val();
				//获取分组最后一个selectedIndex
				if(value.split(".")[0]==key.split(".")[0]){
					lastOpt = this;
				}
			});
			oStr = "<option value='"+key+"' inputType='"+inputType+"'>"+value+"</option>";
			if (lastOpt){
				$(lastOpt).after($(oStr)[0]);
			}
		}
	}else{
		if(inputType=="textnotes"||inputType=="linespace"){
			var textnotesIndex = 0;
			var linespaceIndex = 0;
			$('#rightdataarea option').each(function () {
				var optionobj = $(this);
				var value = optionobj.val();
				//获取分组最后一个selectedIndex
				if($(optionobj).attr("inputType")=="textnotes"){
					textnotesIndex++;
				}
				if($(optionobj).attr("inputType")=="linespace"){
					linespaceIndex++;
				}
			});
			if(inputType=="textnotes"&&textnotesIndex>0){
				if(lastIndex_text<textnotesIndex){
					lastIndex_text = textnotesIndex;
				}else{
					lastIndex_text++;
				}
				key += lastIndex_text;
				value += lastIndex_text;
			}
			if(inputType=="linespace"&&linespaceIndex>0){
				if(lastIndex_line<linespaceIndex){
					lastIndex_line = linespaceIndex;
				}else{
					lastIndex_line++;
				}
				key += lastIndex_line;
				value += lastIndex_line;
			}
		}
		oStr = "<option value='"+key+"' inputType='"+inputType+"'>"+value+"</option>";
		$("#rightdataarea").append(oStr);
	}
	if($.v3x.isMSIE7){//ie7下宽度会变化
		$("#rightdataarea").width(($("#rightdataarea").parent().width()));
	}
  	RightData.put(key,rightObj);//从右侧的数据Map中添加此对象
}
// 左上边选择框的双击事件
function leftupdbclick() {
	var objSelect=$("#leftupdataarea")[0];
	var length = objSelect.options.length;
	var isReturn = false;
    for(var i =0; i <length; i++){
        if(objSelect[i].selected == true){
        	if(IsChooseSingel&&RightData.keys().size()>0){
        		$.alert("${ctp:i18n('form.forminputchoose.canonlychooseone')}");
        		isReturn = true;
        		break;
        	}
        	addToRightarea(objSelect.options[i]);
        }
    }
    if(isReturn == true) return;
	selecttoright('leftup');

}
// 左下边选择框的双击事件
function leftdowndbclick() {
var objSelect=$("#leftdowndataarea")[0];
var length = objSelect.options.length;
for(var i =0; i <length; i++){
        if(objSelect[i].selected == true){
        	addToRightarea(objSelect.options[i]);
        }
    }
	selecttoright('leftdown');
}
// 中间选择事件
function middleAddclick() {
	//判断上下区域是否有选中
	var selobj1=$("#leftupdataarea")[0];
	var selobj2=$("#leftdowndataarea")[0];
	if(type ==5){
	    var count = 0;
	    if(selobj1.selectedIndex!==-1)
	    {
	        count++;
	    }
	    if(selobj2.selectedIndex!==-1)
	    {
	        count++;
	    }
	    if(count >1){
	        $.alert("${ctp:i18n('form.forminputchoose.canonlychooseone')}");
	        return ;
	    }
	}
	if(selobj1.selectedIndex!==-1)
	{
	    leftupdbclick();
	}
	if(selobj2.selectedIndex!==-1)
	{
		leftdowndbclick()
	}
	selecttoright('middle');
}
// 查询事件
function search() {
	var value =$("#searchtext").val();
	serchArea($("#leftupdataarea")[0], LeftUpData, value);
	if($("#leftdowndataarea").length>0){//系统数据域有时候不存在
		serchArea($("#leftdowndataarea")[0], LeftDownData, value);
	}
}
// 查询某区域,有值则显示值,无值则显示空白
function serchArea(who, map, value) {
	clearArea(who);
	var leftupdata = isContainsValue(map, value);
	for ( var i = 0; i < leftupdata.size(); i++) {
		var leftdata = leftupdata.get(i);
		// 添加一列
		var option = document.createElement("option");
		if(typeof(leftdata) == 'string'){
			option.value = getKeyByValue(map, leftdata);
			option.text = leftdata;
		}else{
			option.value = getKeyByValue(map, leftupdata.get(i).showVal);
			option.text = leftupdata.get(i).showVal;
			option.setAttribute('inputType',leftupdata.get(i).inputType);
		}
		who.options.add(option);
		
	}
}
// 清空区域
function clearArea(who) {
	try{
		who.options.length = 0;
	}catch(e){

	}
}
// 判断是否存在值,选取时使用,有则返回true,无则返回false
function isSelectExitItem(objSelect, objItemValue) {
	var isExit = false;
	for ( var i = 0; i < objSelect.options.length; i++) {
		if (objSelect.options[i].value == objItemValue) {
			isExit = true;
			break;
		}
	}
	return isExit;
}
// 判断是否存在值,查询时使用,返回精确值的List
function isContainsValue(map, value) {
	var list = new ArrayList();
	var values = map.values();
	for ( var i = 0; i < values.size(); i++) {
		var obj = values.get(i);
		var showVal = "";
		if(typeof(obj) == 'string'){
			showVal = obj;
		}else{
			showVal = obj.showVal;
		}
		if (showVal.indexOf(value) > -1) {
			list.add(values.get(i));
		}
	}
	return list;
}
function cancelButtonClick() {
	window.close();
}
function beforShow() {
	var table="";
	var inputType="";
	var fieldType = "";//只显示这个数据类型的字段
	var needTable = "";
	var fieldName = "" ;
	var isFilterSysState = false;//是否过滤系统数据域的状态选项
	if(splitObj!=null){
		table = splitObj.byTable == null ? "" : splitObj.byTable.toUpperCase();
		needTable = splitObj.byNeedTable == null ? "" : splitObj.byNeedTable.toUpperCase();
		inputType = (","+splitObj.byInputType == null ? "" : splitObj.byInputType.toUpperCase()+",");
		fieldType = (splitObj.fieldType== null ? "" : splitObj.fieldType.toUpperCase()+",");
		fieldName = splitObj.byFieldName == null ? "" : splitObj.byFieldName.toUpperCase();
		isFilterSysState = splitObj.byFilterSysState == null ? false : splitObj.byFilterSysState;
	}
	if(type != 13 && type != 12 && type!=5 && type!==7||(type==99&&customJson.LeftUpData!=null)){
	    //左上方数据
		 <c:forEach items="${fieldList}" var="field">
				 var leftUpValObj = new Object();
		     	 leftUpValObj.inputType = "${field.inputType}";
				 //没有过滤条件
				 if(splitObj===undefined){
				     <c:if test="${field.masterField}">
				     	 leftUpValObj.showVal = "[${ctp:i18n('form.base.mastertable.label')}]"+"${field.display}";
				         LeftUpData.put("${field.ownerTableName}.${field.name}",leftUpValObj);
			         </c:if>
			         <c:if test="${!field.masterField}">
			         	 leftUpValObj.showVal = "[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex }]"+"${field.display}";
			             LeftUpData.put("${field.ownerTableName}.${field.name}",leftUpValObj);
			         </c:if>
				 }
				 else if(("${field.ownerTableName}".toUpperCase() === needTable || table === ""
						 ||("${field.ownerTableName}".toUpperCase()).indexOf(table)===-1)
						 &&inputType.indexOf(",${field.inputType},".toUpperCase())===-1){
					 if(fieldType !="" && fieldType.indexOf("${field.fieldType},".toUpperCase())<=-1){

					 }else if(fieldName != "" && fieldName == "${field.name}".toUpperCase()){

					 }else{
					     <c:if test="${field.masterField}">
					     	 leftUpValObj.showVal = "[${ctp:i18n('form.base.mastertable.label')}]"+"${field.display}";
			                 LeftUpData.put("${field.ownerTableName}.${field.name}",leftUpValObj);
			             </c:if>
			             <c:if test="${!field.masterField}">
			             	 leftUpValObj.showVal = "[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex }]"+"${field.display}";
			                 LeftUpData.put("${field.ownerTableName}.${field.name}",leftUpValObj);
			             </c:if>
					 }
				 }
		 </c:forEach>
	} else if (type == 12) {
		<c:forEach items="${fieldList}" var="field">
			<c:if test="${!field.masterField}">
			 	var leftUpValObj = new Object();
	     	 	leftUpValObj.inputType = "${field.inputType}";
	     	 	leftUpValObj.showVal = "[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex }]"+"${field.display}";
				LeftUpData.put("${field.ownerTableName}.${field.name}",leftUpValObj);
			</c:if>
		</c:forEach>
	} else if (type == 13) {
		<c:forEach items="${fieldList}" var="field">
		//OA-95559应用检查：主表设置计算公式时，选择重复表行取值函数时，重复表行序号也出现在了设置行条件的可选项，行号在这里参与条件没有任何意义
			if('${field.ownerTableIndex}' == customJson.ownerTableIndex && '${field.name}' != customJson.fieldName && '${field.inputType}' != 'linenumber') {
				<c:if test="${!field.masterField}">
					var leftUpValObj = new Object();
	     	 		leftUpValObj.inputType = "${field.inputType}";
	     	 		leftUpValObj.showVal = "[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex }]"+"${field.display}";
					LeftUpData.put("${field.ownerTableName}.${field.name}",leftUpValObj);
				</c:if>
			}
		</c:forEach>
	}
	var textObj = parentWin.document.getElementById(receiverId);
	// 自定义查询项, 统计分组项,输出数据项
	if (type === 1 || type === 2 || type === 4||type===11 || type == 12 || type == 13) {
		if (type === 1) {
			<%--DialogTitle = "${ctp:i18n('form.forminputchoose.userinputconditon')}";--%>
			<%--ShowTitle = "${ctp:i18n('form.forminputchoose.customersearchconfig')}";--%>
			<%--LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title--%>
			<%--LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";// 左下区域的title--%>
			<%--RightTitle = "${ctp:i18n('form.forminputchoose.customersear')}";// 右区域的title--%>
			IsShowLeftDown = true;
		} else if (type === 2) {
			<%--DialogTitle = "${ctp:i18n('form.forminputchoose.reportgroup')}";--%>
			<%--ShowTitle = "${ctp:i18n('form.forminputchoose.reportgroup')}";--%>
			<%--LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title--%>
			<%--RightTitle = "${ctp:i18n('form.forminputchoose.reportgroup')}";// 右区域的title--%>
			IsShowLeftDown = false;
		}else if (type === 11) {
			<%--DialogTitle = "${ctp:i18n('form.report.customfield.label')}";--%>
			<%--ShowTitle = "${ctp:i18n('form.forminputchoose.customersearchconfig')}";--%>
			<%--LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title--%>
			<%--LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";// 左下区域的title--%>
			<%--RightTitle = "${ctp:i18n('form.report.customfield.label')}";// 右区域的title--%>
			IsShowLeftDown = true;
		}else if(type == 12){
			<%--DialogTitle = "${ctp:i18n('form.trigger.automatic.selectsamevalue.label')}";--%>
			<%--LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";--%>
			IsShowLeftDown = false;
		} else if(type == 13){
			<%--DialogTitle = "${ctp:i18n('form.formula.engin.function.preRow.set.rowCondition.title')}";--%>
			<%--LeftUpTitle = "${ctp:i18n('form.compute.formdata.label')}";--%>
			<%--RightTitle = "${ctp:i18n('form.formula.engin.function.preRow.set.sameValue.label')} :";--%>
			IsShowLeftDown = false;
		}else {
			<%--DialogTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";--%>
			<%--ShowTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";--%>
			<%--LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title--%>
			<%--LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";// 左下区域的title--%>
			<%--RightTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";// 右区域的title--%>
			IsShowLeftDown = true;
		}

		var dataareavalue = "";
		if (textObj.value != "") {
			if (textObj.value.indexOf(',') > -1) {// 多项
				var testvalues = textObj.value.split(",");
				oldString = textObj.value.split(",");
				for ( var i = 0; i <= testvalues.length - 1; i++) {
					if (testvalues[i].indexOf("(") > -1) {
						dataareavalue = testvalues[i].substring(0,
								testvalues[i].indexOf("("));// 取得数据库中列的显示名称
						var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义
						var fieldInputType = getInputTypeByValue(LeftUpData, dataareavalue);
						// 在左上无对应的值是,取左下
						if (titleStr === "") {
							titleStr = getKeyByValue(LeftDownData,dataareavalue);// 取得数库中列的定义
							fieldInputType = getInputTypeByValue(LeftDownData, dataareavalue);;
						}
						var valObj = new Object();
						valObj.title = testvalues[i];
						if($.trim(fieldInputType) !=""){
							valObj.inputType=fieldInputType;
						}
						//addMap(titleStr,testvalues[i],RightData);
						addMap(titleStr,valObj,RightData);
					} else {
						var titleStr = getKeyByValue(LeftUpData, testvalues[i]);
						var fieldInputType = getInputTypeByValue(LeftUpData, testvalues[i]);
						// 在左上无对应的值是,取左下
						if (titleStr === "") {
							titleStr = getKeyByValue(LeftDownData,
									testvalues[i]);// 取得数库中列的定义
							fieldInputType = getInputTypeByValue(LeftDownData, testvalues[i]);
						}
						var valObj = new Object();
						valObj.title = testvalues[i];
						
						if($.trim(fieldInputType) !=""){
							valObj.inputType=fieldInputType;
						}
						//addMap(titleStr,testvalues[i],RightData);
						addMap(titleStr,valObj,RightData);
					}
				}
			} else {
				// 只有一项
				if (textObj.value.indexOf("(") > -1) {
					dataareavalue = textObj.value.substring(0, textObj.value
							.indexOf("("));
					var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义
					var fieldInputType = getInputTypeByValue(LeftUpData, dataareavalue);
					// 在左上无对应的值时,取左下
					if (titleStr === "") {
						titleStr = getKeyByValue(LeftDownData, dataareavalue);// 取得数库中列的定义
						fieldInputType = getInputTypeByValue(LeftDownData, dataareavalue);
					}
					var valObj = new Object();
					valObj.title = textObj.value;
					
					if($.trim(fieldInputType) !=""){
						valObj.inputType=fieldInputType;
					}
					//addMap(titleStr,textObj.value,RightData);
					addMap(titleStr,valObj,RightData);
				} else {
					var titleStr = getKeyByValue(LeftUpData, textObj.value);
					var fieldInputType = getInputTypeByValue(LeftUpData, textObj.value);
					// 在左上无对应的值是,取左下
					if (titleStr === "") {
						titleStr = getKeyByValue(LeftDownData, textObj.value);// 取得数库中列的定义
						fieldInputType = getInputTypeByValue(LeftDownData, textObj.value);
					}
					var valObj = new Object();
					valObj.title = textObj.value;
					
					if($.trim(fieldInputType) !=""){
						valObj.inputType=fieldInputType;
					}
					//addMap(titleStr,textObj.value,RightData);
					addMap(titleStr,valObj,RightData);
				}
			}
		}
	}
	<%--//统计项,日志设置--%>
	<%--else if (type === 3||type===6) {--%>
		<%--if(type===3){--%>
    		<%--&lt;%&ndash;DialogTitle = "${ctp:i18n('form.forminputchoose.reportdata')}";&ndash;%&gt;--%>
    		<%--&lt;%&ndash;ShowTitle = "${ctp:i18n('form.forminputchoose.report')}";&ndash;%&gt;--%>
    		<%--&lt;%&ndash;LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title&ndash;%&gt;--%>
    		<%--RightTitle = "${ctp:i18n('form.forminputchoose.reportdataarea')}";// 右区域的title--%>
        <%--}else{--%>
    		<%--&lt;%&ndash;DialogTitle = "${ctp:i18n('form.forminputchoose.logconfig')}";&ndash;%&gt;--%>
    		<%--&lt;%&ndash;ShowTitle = "${ctp:i18n('form.forminputchoose.logdataconfig')}";&ndash;%&gt;--%>
    		<%--&lt;%&ndash;LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title&ndash;%&gt;--%>
    		<%--&lt;%&ndash;RightTitle = "${ctp:i18n('form.forminputchoose.logdata')}";// 右区域的title&ndash;%&gt;--%>
		<%--}--%>
		<%--IsShowLeftDown = false;--%>
		<%--var dataareavalue = "";--%>
		<%--if (textObj.value != "") {--%>
			<%--if (textObj.value.indexOf(',') > -1) {// 多项--%>
				<%--var testvalues = textObj.value.split(",");--%>
				<%--oldString = textObj.value.split(",");--%>
				<%--for ( var i = 0; i <= testvalues.length - 1; i++) {--%>
					<%--if (testvalues[i].indexOf(" ") > -1) {--%>
						<%--dataareavalue = testvalues[i].substring(0,testvalues[i].indexOf(" "));// 取得数据库中列的显示名称--%>
						<%--var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义--%>
						<%--var fieldInputType = getInputTypeByValue(LeftUpData, dataareavalue);--%>
						<%--// 在左上无对应的值是,取左下--%>
						<%--if (titleStr === "") {--%>
							<%--titleStr = getKeyByValue(LeftDownData,dataareavalue);// 取得数库中列的定义--%>
							<%--fieldInputType = getInputTypeByValue(LeftDownData, dataareavalue);--%>
						<%--}--%>
						<%--var valObj = new Object();--%>
						<%--valObj.title = testvalues[i];--%>
						<%----%>
						<%--if($.trim(fieldInputType) !=""){--%>
							<%--valObj.inputType=fieldInputType;--%>
						<%--}--%>
						<%--//addMap(titleStr,testvalues[i],RightData);--%>
						<%--addMap(titleStr,valObj,RightData);--%>
					<%--} else {--%>
						<%--var titleStr = getKeyByValue(LeftUpData, testvalues[i]);--%>
						<%--var fieldInputType = getInputTypeByValue(LeftUpData, testvalues[i]);--%>
						<%--// 在左上无对应的值是,取左下--%>
						<%--if (titleStr === "") {--%>
							<%--titleStr = getKeyByValue(LeftDownData,testvalues[i]);// 取得数库中列的定义--%>
							<%--fieldInputType = getInputTypeByValue(LeftDownData, testvalues[i]);--%>
						<%--}--%>
						<%--var valObj = new Object();--%>
						<%--valObj.title = testvalues[i];--%>
						<%----%>
						<%--if($.trim(fieldInputType) !=""){--%>
							<%--valObj.inputType=fieldInputType;--%>
						<%--}--%>
						<%--//addMap(titleStr,testvalues[i],RightData);--%>
						<%--addMap(titleStr,valObj,RightData);--%>
					<%--}--%>
				<%--}--%>
			<%--} else {--%>
				<%--// 只有一项--%>
				<%--if (textObj.value.indexOf(" ") > -1) {--%>
					<%--dataareavalue = textObj.value.substring(0, textObj.value.indexOf(" "));--%>
					<%--var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义--%>
					<%--var fieldInputType = getInputTypeByValue(LeftUpData, dataareavalue);--%>
					<%--// 在左上无对应的值时,取左下--%>
					<%--if (titleStr === "") {--%>
						<%--titleStr = getKeyByValue(LeftDownData, dataareavalue);// 取得数库中列的定义--%>
						<%--fieldInputType = getInputTypeByValue(LeftDownData, dataareavalue);--%>
					<%--}--%>
					<%--var valObj = new Object();--%>
					<%--valObj.title = textObj.value;--%>
					<%----%>
					<%--if($.trim(fieldInputType) !=""){--%>
						<%--valObj.inputType=fieldInputType;--%>
					<%--}--%>
					<%--//addMap(titleStr,textObj.value,RightData);--%>
					<%--addMap(titleStr,valObj,RightData);--%>
				<%--} else {--%>
					<%--var titleStr = getKeyByValue(LeftUpData, textObj.value);--%>
					<%--var fieldInputType = getInputTypeByValue(LeftUpData, textObj.value);--%>
					<%--// 在左上无对应的值是,取左下--%>
					<%--if (titleStr === "") {--%>
						<%--titleStr = getKeyByValue(LeftDownData, textObj.value);// 取得数库中列的定义--%>
						<%--fieldInputType = getInputTypeByValue(LeftDownData,textObj.value);--%>
					<%--}--%>
					<%--var valObj = new Object();--%>
					<%--valObj.title = textObj.value;--%>
					<%----%>
					<%--if($.trim(fieldInputType) !=""){--%>
						<%--valObj.inputType=fieldInputType;--%>
					<%--}--%>
					<%--//addMap(titleStr,textObj.value,RightData);--%>
					<%--addMap(titleStr,valObj,RightData);--%>
				<%--}--%>
			<%--}--%>
		<%--}--%>
	<%--}--%>
	// 排序设置
	else if (type === 5) {
		//只能单选
		$("#leftupdataarea").attr("multiple",false);
		$("#leftdowndataarea").attr("multiple",false);
		var allfileds = new Properties();// 所有此表单所有的列
		var sysFiled = new Properties();

		 <c:forEach items="${fieldList}" var="field">
    		 <c:if test="${field.masterField}">
    		     allfileds.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('form.base.mastertable.label')}]"+"${field.display}");
             </c:if>
             <c:if test="${!field.masterField}">
                allfileds.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex }]"+"${field.display}");
             </c:if>
		 </c:forEach>
		 <%--<c:forEach items="${systemVarList}" var="sys">--%>
		 	<%--allfileds.put("${sys.key}","${sys.text}");--%>
		 	<%--sysFiled.put("${sys.key}","${sys.text}");--%>
		 <%--</c:forEach>--%>
		<c:forEach items="${otherFields}" var="otherField">
			sysFiled.put("${otherField.key}","${otherField.value}");
		</c:forEach>
		<%--DialogTitle = "${ctp:i18n('form.forminputchoose.orderconfig')}";--%>
		<%--ShowTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";--%>
		<%--LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title--%>
		<%--RightTitle = "${ctp:i18n('form.forminputchoose.order')}";// 右区域的title--%>
		<%--LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";--%>
		IsShowLeftDown = true;
		// 左上区域的值
		var datafield = parentWin.document.getElementById(datafiledId);// 关联的输入框的值
		var dataareavalue;
		if (datafield.value != "") {
			if (datafield.value.indexOf(',') > -1) {
				var datafieldvalues = datafield.value.split(",");
				for ( var i = 0; i <= datafieldvalues.length - 1; i++) {
					if (datafieldvalues[i].indexOf("(") > -1) {
						dataareavalue = datafieldvalues[i].substring(0,datafieldvalues[i].indexOf("("));
						var titleStr = getKeyByValue(allfileds, dataareavalue);// 取得数库中列的定义
                        if (titleStr) {
                            if(sysFiled.containsKey(titleStr)){
                                LeftDownData.put(titleStr, datafieldvalues[i]);
                            }else{
                                LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
                            }
                        }
					} else {
						var titleStr = getKeyByValue(allfileds,datafieldvalues[i]);// 取得数库中列的定义
                        if (titleStr) {
                            if(sysFiled.containsKey(titleStr)){
                                LeftDownData.put(titleStr, datafieldvalues[i]);
                            }else{
                                if(allfileds.get(titleStr)) {
                                    LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
                                }
                            }
                        }
					}
				}
			} else {
				var titleStr = getKeyByValue(allfileds, datafield.value);// 取得数库中列的定义
				if(sysFiled.containsKey(titleStr)){
                    LeftDownData.put(titleStr, datafield.value);
                }else{
                    LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
                }
			}
		}
		// 右区域的值
		var data = parentWin.document.getElementById(receiverId);
		if (data.value != "") {
			if (data.value.indexOf(',') > -1) {
				var datavalues = data.value.split(",");
				for ( var i = 0; i <= datavalues.length - 1; i++) {
					selectObjvalue = datavalues[i].substring(0,
							datavalues[i].length - 1);
					var titleStr = getKeyByValue(LeftUpData, selectObjvalue);// 取得数库中列的定义
					var fieldInputType = getInputTypeByValue(LeftUpData, selectObjvalue);
					if(!titleStr){
					    titleStr = getKeyByValue(LeftDownData, selectObjvalue);
					    fieldInputType = getInputTypeByValue(LeftDownData, selectObjvalue);
					}
					var valObj = new Object();
					valObj.title = datavalues[i];
					
					if($.trim(fieldInputType) !=""){
						valObj.inputType=fieldInputType;
					}
					//addMap(titleStr,datavalues[i],RightData);
					addMap(titleStr,valObj,RightData);
				}
			} else {
				selectObjvalue = data.value.substring(0, data.value.length - 1);
				var titleStr = getKeyByValue(allfileds, selectObjvalue);// 取得数库中列的定义
				var fieldInputType = getInputTypeByValue(allfileds, selectObjvalue);
				if(!titleStr){
                    titleStr = getKeyByValue(LeftDownData, selectObjvalue);
                    fieldInputType = getInputTypeByValue(LeftDownData, selectObjvalue);
                }
				var valObj = new Object();
				valObj.title = data.value;
				
				if($.trim(fieldInputType) !=""){
					valObj.inputType=fieldInputType;
				}
				//addMap(titleStr,data.value,RightData);
				addMap(titleStr,valObj,RightData);
			}
		}
	}
	//其他特殊需求(查询前端的显示)
	else if(type===7){
		var allfileds = new Properties();// 所有此表单所有的列
		var sysFiled = new Properties();
		 <c:forEach items="${fieldList}" var="field">
             <c:if test="${field.masterField}">
                 allfileds.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('form.base.mastertable.label')}]"+"${field.display}");
             </c:if>
             <c:if test="${!field.masterField}">
                allfileds.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex }]"+"${field.display}");
             </c:if>
		 </c:forEach>
		<c:forEach items="${otherFields}" var="otherField">
			sysFiled.put("${otherField.key}","${otherField.value}");
		</c:forEach>
		IsShowLeftDown = true;

		// 左上区域的值
		var datafield = parentWin.document.getElementById(datafiledId);// 关联的输入框的值
		var dataareavalue;
		if (datafield.value != "") {
			if (datafield.value.indexOf(',') > -1) {
				var datafieldvalues = datafield.value.split(",");
				for ( var i = 0; i <= datafieldvalues.length - 1; i++) {
					if (datafieldvalues[i].indexOf("(") > -1) {
						dataareavalue = datafieldvalues[i].substring(0,datafieldvalues[i].indexOf("("));
						var titleStr = getKeyByValue(allfileds, dataareavalue);// 取得数库中列的定义
                        if (titleStr) {
                            if(sysFiled.containsKey(titleStr)){
                                LeftDownData.put(titleStr, datafieldvalues[i]);
                            }else{
                                LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
                            }
                        }
					} else {
						var titleStr = getKeyByValue(allfileds,datafieldvalues[i]);// 取得数库中列的定义
                        if (titleStr) {
                            if(sysFiled.containsKey(titleStr)){
                                LeftDownData.put(titleStr, datafieldvalues[i]);
                            }else{
                                LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
                            }
                        }
					}
				}
			} else {
				var titleStr = getKeyByValue(allfileds, datafield.value);// 取得数库中列的定义
				if(sysFiled.containsKey(titleStr)){
                    LeftDownData.put(titleStr, datafield.value);
                }else{
                    LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
                }
			}
		}
		// 右区域的值
		var data = parentWin.document.getElementById(receiverId);
		if (data.value != "") {
			if (textObj.value.indexOf(',') > -1) {// 多项
				var testvalues = textObj.value.split(",");
				oldString = textObj.value.split(",");
				for ( var i = 0; i <= testvalues.length - 1; i++) {
						dataareavalue = getPrimaevalName(testvalues[i]);// 取得数据库中列的显示名称
						var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义
						var fieldInputType = getInputTypeByValue(LeftUpData, dataareavalue);
						// 在左上无对应的值是,取左下
						if (titleStr === "") {
							titleStr = getKeyByValue(LeftDownData,dataareavalue);// 取得数库中列的定义
							fieldInputType = getInputTypeByValue(LeftDownData, dataareavalue);
						}
						var valObj = new Object();
						valObj.title = testvalues[i];
						
						if($.trim(fieldInputType) !=""){
							valObj.inputType=fieldInputType;
						}
						//addMap(titleStr,testvalues[i],RightData);
						addMap(titleStr,valObj,RightData);
				}
			} else {
				// 只有一项
				dataareavalue = getPrimaevalName(textObj.value);// 取得数据库中列的显示名称
				var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义
				var fieldInputType = getInputTypeByValue(LeftUpData, dataareavalue);
				// 在左上无对应的值是,取左下
				if (titleStr === "") {
					titleStr = getKeyByValue(LeftDownData,dataareavalue);// 取得数库中列的定义
					fieldInputType = getInputTypeByValue(LeftDownData, dataareavalue);
				}
				var valObj = new Object();
				valObj.title = textObj.value;
				
				if($.trim(fieldInputType) !=""){
					valObj.inputType=fieldInputType;
				}
				//addMap(titleStr,textObj.value,RightData);
				addMap(titleStr,valObj,RightData);
			}
		}

		}
	//用户自定义类型
	//else if(type==99)
	if(customJson!=null){
		//增加防护
		try
		{
			DialogTitle = customJson.DialogTitle||DialogTitle;
			ShowTitle = customJson.ShowTitle||ShowTitle;
			LeftUpTitle =customJson.LeftUpTitle||LeftUpTitle;// 左上区域的title
			LeftDownTitle =customJson.LeftDownTitle||LeftDownTitle;// 左下区域的title
			RightTitle =customJson.RightTitle||RightTitle;// 右区域的title
			IsShowLeftDown =customJson.IsShowLeftDown||IsShowLeftDown;// 是否显示左下区域
			IsShowSearch=customJson.IsShowSearch||IsShowSearch;// 是否可以查询
		    IsChooseSingel=customJson.IsChooseSingel||IsChooseSingel;
		    IsWriteBlak=customJson.IsWriteBlak==null?IsWriteBlak:customJson.IsWriteBlak;
		    IsShowUpAndDown=customJson.IsShowUpAndDown == false ? customJson.IsShowUpAndDown : (customJson.IsShowUpAndDown||IsShowUpAndDown);
		    if(customJson.LeftUpData!=null){
		    LeftUpData=customJson.LeftUpData;
		    }
		    if(customJson.RightData!=null){
		    RightData=customJson.RightData;
		    }
		}
		catch(e)
		{
			$.alert("${ctp:i18n('form.forminputchoose.checkdata')}");
		}
	}

}
function leftupclick(){
	if($("#leftdowndataarea")!=null){
	    $("#leftdowndataarea").find("option:selected").attr("selected",false);
	}
}
function leftdownclick(){
	$("#leftupdataarea").find("option:selected").attr("selected",false);
}
// 根据value取key,没有则返回""
function getKeyByValue(map, value) {
    var key = "";
    var list = map.keys();
    for ( var k = 0; k < list.size(); k++) {
        key = list.get(k);
        var result = map.get(key);
        if(typeof(result) == 'object'){
        	result = result.showVal;
        }
        if (result.indexOf("(") > -1){
          result = result.substring(0, result.indexOf("("));
        }
        if (value == result){//带有[重复表]
            return key;
        }
        if(result.indexOf("[") > -1&& result.indexOf("]") > -1){
            result = result.substring(result.lastIndexOf("]")+1);
        }
        if (value == result){
            return key;
        }
    }
    return "";
}

//获取原始的displayName
function getPrimaevalName(v){
	if (v.indexOf("(") > -1) {
		v = v.substring(0,v.indexOf("("));
	}
	return v;
}
//过滤掉空k的值
function addMap(k,v,m){
	if(k != null && k != ""){
		//var valObj = new Object();
		//valObj.title = v;
		m.put(k,v);
	}
}

//根据value取表单字段类型,没有则返回""
function getInputTypeByValue(map, value) {
    var key = "";
    var list = map.keys();
    for ( var k = 0; k < list.size(); k++) {
        key = list.get(k);
        var result = map.get(key);
        var showVal = "";
        if(typeof(result) == 'object'){
        	showVal = result.showVal;
        }else{
        	
        }
        if (showVal.indexOf("(") > -1){
        	showVal = showVal.substring(0, showVal.indexOf("("));
        }
        if (value == showVal){//带有[重复表]
            return result.inputType;
        }
        if(showVal.indexOf("[") > -1&& showVal.indexOf("]") > -1){
        	showVal = showVal.substring(showVal.lastIndexOf("]")+1);
        }
        if (value == showVal){
            return result.inputType;
        }
    }
    return "";
}

</script>