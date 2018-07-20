<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
// JavaScript Document
var dialogParam =window.parentDialogObj["formInputChooseDialog"].getTransParams();;
var parentWin=dialogParam[0];
var splitObj=dialogParam[1];
var customJson=dialogParam[2];
var DialogTitle = "";// 对话框标题
var ShowTitle = "";// 主标题
var LeftUpTitle = "";// 左上区域的title
var LeftDownTitle = "";// 左下区域的title
var RightTitle = "";// 右区域的title
var LeftUpData = new Properties();// 左上区域的值,这里是一个Map对象
var LeftDownData = new Properties();// 左下区域的值,这里是一个Map对象
var RightData = new Properties();// 右边区域值,这里是一个Map对象
var IsShowLeftDown = false;// 是否显示左下区域
var IsShowSearch=true;//是否显示查询
var IsChooseSingel=false;//是否只能选择一个值
var IsWriteBlak=true;//是否将值回写到控件中
var IsShowUpAndDown=true;//是否显示上移和下移
var IsNeedReName = true;//是否需要显示重命名
var receiverId="${ctp:escapeJavascript(choose)}";//回显的text
var datafiledId=$("#"+receiverId,parentWin.document).attr("datafiledId");//相关联的text,在排序时有用到
var hideText=$("#"+receiverId,parentWin.document).attr("hideText");
//1==>自定义查询项, 2==>统计分组项,3==>统计项,4===>输出数据项(无流程表单),5==>排序设置,6===>日志设置,7==>其他特殊需求:和类型为5(排序设置取数据一样,但从左向右选时,没有排序设置)
var type=parseInt($("#"+receiverId,parentWin.document).attr("mytype")==null?"99":$("#"+receiverId,parentWin.document).attr("mytype"));
//byTable:过滤所属的表以此开头的field,可以为formmain,formson,这里忽略大小写
//byNeedTable:通过需要的表显示字段，如果是主表字段默认都需要显示，否则都需要以该表名一致。
//byInputType:过滤此种属性的field,可以为relationform等,以","隔开,这里忽略大小写
//byFieldName:过滤字段名称
//byFilterSysState过滤系统数据域中的状态
//isReName是否需要显示重命名
//var splitObj1='{"byTable":"formmain","byInputType":"relationform"}';
//是否是公文类型
$('#searchbtn').click(function() {
	search();
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
function init()
{
beforShow();
show();
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
	//公文显示的国际化名称
	if(typeof(govDocFormType) != "undefined" && (govDocFormType==5||govDocFormType==6||govDocFormType==7)){
		$("#LeftUpTitle").text("${ctp:i18n('form.compute.edocformdata.label')}");
	}else{
		$("#LeftUpTitle").text(LeftUpTitle);
	}

	$("#ShowTitle").text(ShowTitle);
	$("#RightTitle").text(RightTitle);
	// 如果需要显示左边底部
	if (IsShowLeftDown) {
		$("#leftdowndataarea").removeClass("hidden");
		$("#LeftDownTitle").text(LeftDownTitle);
		var leftdowndatakeys = LeftDownData.keys();// 取得左下区域所有的实际值
		var ldHeight = $("#leftdowndataarea").height();
		var ldStr = '';
		for ( var i = 0; i < leftdowndatakeys.size(); i++) {
			var key = leftdowndatakeys.get(i);// 取得实际的值
			var value = LeftDownData.get(key);// 取得显示的值
			ldStr += "<option value='"+key+"'>"+value+"</option>";
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
		loStr += "<option value='"+key+"'>"+value+"</option>";
	}
	$("#leftupdataarea").height(lHeight).append(loStr);
	
	// 显示右区域
	var rHeight = $("#rightdataarea").height();
	var rightdatakeys = RightData.keys();// 取得右区域所有的实际值
	var roStr = '';
	for ( var i = 0; i < rightdatakeys.size(); i++) {
		var key = rightdatakeys.get(i);
		var value = RightData.get(key);
		roStr += "<option value='"+key+"'>"+value+"</option>";
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
		selobj.remove(selobj.selectedIndex);
		RightData.remove(opt.value);//从右侧的数据Map中移除
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
	var otheropt = selectObj.options[selectObj.selectedIndex + nDir];
	var text = opt.text;
	var value = opt.value;
	opt.text = otheropt.text;
	opt.value = otheropt.value;
	otheropt.text = text;
	otheropt.value = value;
	selectObj.selectedIndex += nDir;
}
// 返回map,map中装的是右区域的值,key为实际值,value为显示值
//修改为直接塞值给父页面的同时,也返回值
function OK() {
	var tableName = "";
	var dataareaObj = document.getElementById("rightdataarea");
	 if(type==4){
		  //最多只能有一个从表
		  var temp='';
		  var table='';
		  var j=0;
		  for(var i = 0; i < dataareaObj.length; i++){
			  table=dataareaObj.options[i].value.split(".")[0];
			  if(table.indexOf('formson_')==0&&temp!=table){
				  temp=table;
				  j++;
			  }
		  }
		  if(j>1){
			  return 'false';
		  }
	 }
		//返回值
	var returnvalues = new Array();
	var key="";
	var value="";
	for ( var i = 0; i < dataareaObj.length; i++) {
		if(i===dataareaObj.length-1)
			{
			key+=dataareaObj.options[i].value;
			value+=dataareaObj.options[i].text;
			}
		else
			{
		key+=dataareaObj.options[i].value+",";
		value+=dataareaObj.options[i].text+",";
			}
		returnvalues[returnvalues.length] = {'key':dataareaObj.options[i].value,'value':dataareaObj.options[i].text};
		//returnvalues.add("{'key':'"+dataareaObj.options[i].value+"','value':'"+dataareaObj.options[i].text+"'}");
	}
	if(IsWriteBlak)
	{
	$("#"+hideText,parentWin.document).val(key);
	$("#"+receiverId,parentWin.document).val(value);
	}
	return returnvalues;//
}
// 右边选择框的双击事件
// 当为输出数据项,自定义查询统计项,统计分组项时重命名
// 当为排序字段,统计项时进行删除
function rightdbclick() {
	var selectObj = document.getElementById("rightdataarea");
    if (selectObj.selectedIndex < 0){
		return;
    }
    if(splitObj != null){
    	IsNeedReName = splitObj.isReName == null ? true : splitObj.isReName;
    }
	if((type===7||type===4||type===1||type===2||type===11) && IsNeedReName)
		{
		var obj=new Array();
		obj[0]=window;
		obj[1]=RightData;
		obj[2]=type;
		var url = '${path}/form/component.do?method=formInputChooseRename';
		  //window.showModalDialog(url,window,"DialogHeight=200px;DialogWidth=350px;status=no;");
			var dialog = $.dialog({
			    id:"formInputChooseRenameDialog",
				url: url,
			    title : "${ctp:i18n('form.forminputchoose.rename')}",
			    width:350,
				height:200,
				targetWindow:getCtpTop(),
				transParams:obj,
			    buttons : [{
			      text : "${ctp:i18n('form.forminputchoose.enter')}",
			      id:"sure",
			      handler : function() {
				      var result = dialog.getReturnValue();
				      if(result=='true'){
				    	   dialog.close();
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
		  }
	else
		{
		delOption();
		}
}
//添加值到右侧区域
function addToRightarea(opt)
{
	//是否只能单选
	if(IsChooseSingel&&RightData.keys().size()>0)
		{
		$.alert("${ctp:i18n('form.forminputchoose.canonlychooseone')}");
		return;
		}
	var key = opt.value;// 取得实际的值
	var value =opt.text;// 取得显示的值
	if(value){
	    value = value.substring(value.indexOf("]")+1);
	}
	//判断右侧区域是否有值
	if(RightData.containsKey(key))
		{
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
			      handler : function() {
				      value = dialog.getReturnValue();
				      if(value!='false'){
				    	    var oStr = "<option value='"+key+"'>"+value+"</option>";
				  		    $("#rightdataarea").append(oStr);
				  		    if($.v3x.isMSIE7){//ie7下宽度会变化
				  			    $("#rightdataarea").width(($("#rightdataarea").parent().width()));
				  		    }
						  	RightData.put(key,value);//从右侧的数据Map中添加此对象
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
	var oStr = "<option value='"+key+"'>"+value+"</option>";
	$("#rightdataarea").append(oStr);
	/* if($.v3x.isMSIE7){//ie7下宽度会变化
		$("#rightdataarea").width(($("#rightdataarea").parent().width()));
	} */
  	RightData.put(key,value);//从右侧的数据Map中添加此对象
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
		// 添加一列
		var option = document.createElement("option");
		who.options.add(option);
		option.value = getKeyByValue(map, leftupdata.get(i));
		option.text = leftupdata.get(i);
	}
}
// 清空区域
function clearArea(who) {
	try
	{
	who.options.length = 0;
	}
	catch(e)
	{

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
		if (values.get(i).indexOf(value) > -1) {
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
	if(type!=5 && type!==7||(type==99&&customJson.LeftUpData!=null)){
    //左上方数据
	 <c:forEach items="${fieldList}" var="field">
	 //固定过滤这些控件 取消管理项目 回写那边需要用到
	 if(type!==6&&("${field.fieldType}"=="LONGTEXT"||"${field.inputType}"=="handwrite"||"${field.inputType}"=="attachment"||"${field.inputType}"=="document"||"${field.inputType}"=="image")){
		 <c:if test = "${param.isEchoSetting eq '1' or param.isBathUpdate eq '1'}">
		 if(customJson.IsBathUpdate || (customJson.fieldType == 'VARCHAR' && ("${field.inputType}"=="attachment"||"${field.inputType}"=="document"||"${field.inputType}"=="image"))){
		     <c:if test="${field.masterField}">
		         LeftUpData.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('form.base.mastertable.label')}]"+"${field.display}");
		     </c:if>
		     <c:if test="${!field.masterField}">
		         LeftUpData.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('formoper.dupform.label')}${field.extraMap.subTableIndex }]"+"${field.display}");
		     </c:if>
		 }
		 </c:if>
	 }else if(type===6&&("${field.inputType}"=="handwrite"||"${field.inputType}"=="customplan")){
	 }else{
	 //没有过滤条件
	 if(splitObj===undefined){
	     <c:if test="${field.masterField}">
	          LeftUpData.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('form.base.mastertable.label')}]"+"${field.display}");
          </c:if>
          <c:if test="${!field.masterField}">
             LeftUpData.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('formoper.dupform.label')}${field.extraMap.subTableIndex }]"+"${field.display}");
         </c:if>
	 }else if(("${field.ownerTableName}".toUpperCase() === needTable || table === "" ||("${field.ownerTableName}".toUpperCase()).indexOf(table)===-1)&&inputType.indexOf(",${field.inputType},".toUpperCase())===-1)
	 {
		 if(fieldType !="" && fieldType.indexOf("${field.fieldType},".toUpperCase())<=-1){
		 }else if(fieldName != "" && fieldName == "${field.name}".toUpperCase()){
		 }else{
		     <c:if test="${field.masterField}">
                 LeftUpData.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('form.base.mastertable.label')}]"+"${field.display}");
             </c:if>
             <c:if test="${!field.masterField}">
                LeftUpData.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('formoper.dupform.label')}${field.extraMap.subTableIndex }]"+"${field.display}");
             </c:if>
		 }
	 }
	 }
	 </c:forEach>
	 //左下方数据
	 <c:forEach items="${systemVarList}" var="sys">
	 //自定义查询统计项  去掉状态选项
	 if((type==1 || type==11 || isFilterSysState == true)&&("state"=="${sys.key}"||"ratifyflag"=="${sys.key}"||"finishedflag"=="${sys.key}")){
	 }else{
	 	LeftDownData.put("${sys.key}","${sys.text}");
	 }
	 </c:forEach>
		}
	var textObj = parentWin.document.getElementById(receiverId);
	// 自定义查询项, 统计分组项,输出数据项
	if (type === 1 || type === 2 || type === 4||type===11) {
		if (type === 1) {
			DialogTitle = "${ctp:i18n('form.forminputchoose.userinputconditon')}";
			ShowTitle = "${ctp:i18n('form.forminputchoose.customersearchconfig')}";
			LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title
			LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";// 左下区域的title
			RightTitle = "${ctp:i18n('form.forminputchoose.customersear')}";// 右区域的title
			IsShowLeftDown = true;
		} else if (type === 2) {
			DialogTitle = "${ctp:i18n('form.forminputchoose.reportgroup')}";
			ShowTitle = "${ctp:i18n('form.forminputchoose.reportgroup')}";
			LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title
			RightTitle = "${ctp:i18n('form.forminputchoose.reportgroup')}";// 右区域的title
			IsShowLeftDown = false;
		}else if (type === 11) {
			DialogTitle = "${ctp:i18n('form.report.customfield.label')}";
			ShowTitle = "${ctp:i18n('form.forminputchoose.customersearchconfig')}";
			LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title
			LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";// 左下区域的title
			RightTitle = "${ctp:i18n('form.report.customfield.label')}";// 右区域的title
			IsShowLeftDown = true;
		} else {
			DialogTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";
			ShowTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";
			LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title
			LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";// 左下区域的title
			RightTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";// 右区域的title
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
						// 在左上无对应的值是,取左下
						if (titleStr === "") {
							titleStr = getKeyByValue(LeftDownData,
									dataareavalue);// 取得数库中列的定义
						}
						addMap(titleStr,testvalues[i],RightData);
					} else {
						var titleStr = getKeyByValue(LeftUpData, testvalues[i]);
						// 在左上无对应的值是,取左下
						if (titleStr === "") {
							titleStr = getKeyByValue(LeftDownData,
									testvalues[i]);// 取得数库中列的定义
						}
						addMap(titleStr,testvalues[i],RightData);
					}
				}
			} else {
				// 只有一项
				if (textObj.value.indexOf("(") > -1) {
					dataareavalue = textObj.value.substring(0, textObj.value
							.indexOf("("));
					var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义
					// 在左上无对应的值时,取左下
					if (titleStr === "") {
						titleStr = getKeyByValue(LeftDownData, dataareavalue);// 取得数库中列的定义
					}
					addMap(titleStr,textObj.value,RightData);
				} else {
					var titleStr = getKeyByValue(LeftUpData, textObj.value);
					// 在左上无对应的值是,取左下
					if (titleStr === "") {
						titleStr = getKeyByValue(LeftDownData, textObj.value);// 取得数库中列的定义
					}
					addMap(titleStr,textObj.value,RightData);
				}
			}
		}
	}
	//统计项,日志设置
	else if (type === 3||type===6) {
		if(type===3){
    		DialogTitle = "${ctp:i18n('form.forminputchoose.reportdata')}";
    		ShowTitle = "${ctp:i18n('form.forminputchoose.report')}";
    		LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title
    		RightTitle = "${ctp:i18n('form.forminputchoose.reportdataarea')}";// 右区域的title
        }else{
    		DialogTitle = "${ctp:i18n('form.forminputchoose.logconfig')}";
    		ShowTitle = "${ctp:i18n('form.forminputchoose.logdataconfig')}";
    		LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title
    		RightTitle = "${ctp:i18n('form.forminputchoose.logdata')}";// 右区域的title
		}
		IsShowLeftDown = false;
		var dataareavalue = "";
		if (textObj.value != "") {
			if (textObj.value.indexOf(',') > -1) {// 多项
				var testvalues = textObj.value.split(",");
				oldString = textObj.value.split(",");
				for ( var i = 0; i <= testvalues.length - 1; i++) {
					if (testvalues[i].indexOf(" ") > -1) {
						dataareavalue = testvalues[i].substring(0,testvalues[i].indexOf(" "));// 取得数据库中列的显示名称
						var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义
						// 在左上无对应的值是,取左下
						if (titleStr === "") {
							titleStr = getKeyByValue(LeftDownData,dataareavalue);// 取得数库中列的定义
						}
						addMap(titleStr,testvalues[i],RightData);
					} else {
						var titleStr = getKeyByValue(LeftUpData, testvalues[i]);
						// 在左上无对应的值是,取左下
						if (titleStr === "") {
							titleStr = getKeyByValue(LeftDownData,testvalues[i]);// 取得数库中列的定义
						}
						addMap(titleStr,testvalues[i],RightData);
					}
				}
			} else {
				// 只有一项
				if (textObj.value.indexOf(" ") > -1) {
					dataareavalue = textObj.value.substring(0, textObj.value.indexOf(" "));
					var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义
					// 在左上无对应的值时,取左下
					if (titleStr === "") {
						titleStr = getKeyByValue(LeftDownData, dataareavalue);// 取得数库中列的定义
					}
					addMap(titleStr,textObj.value,RightData);
				} else {
					var titleStr = getKeyByValue(LeftUpData, textObj.value);
					// 在左上无对应的值是,取左下
					if (titleStr === "") {
						titleStr = getKeyByValue(LeftDownData, textObj.value);// 取得数库中列的定义
					}
					addMap(titleStr,textObj.value,RightData);
				}
			}
		}
	}
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
                allfileds.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('formoper.dupform.label')}${field.extraMap.subTableIndex }]"+"${field.display}");
             </c:if>
		 </c:forEach>
		 <c:forEach items="${systemVarList}" var="sys">
		 allfileds.put("${sys.key}","${sys.text}");
		 sysFiled.put("${sys.key}","${sys.text}");
		 </c:forEach>
		DialogTitle = "${ctp:i18n('form.forminputchoose.orderconfig')}";
		ShowTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";
		LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title
		RightTitle = "${ctp:i18n('form.forminputchoose.order')}";// 右区域的title
		LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";
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
						if(sysFiled.containsKey(titleStr)){
						    LeftDownData.put(titleStr, datafieldvalues[i]);
						}else{
						    LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
						}
					} else {
						var titleStr = getKeyByValue(allfileds,datafieldvalues[i]);// 取得数库中列的定义
						if(sysFiled.containsKey(titleStr)){
						    LeftDownData.put(titleStr, datafieldvalues[i]);
                        }else{
                            LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
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
					if(!titleStr){
					    titleStr = getKeyByValue(LeftDownData, selectObjvalue);
					}
					addMap(titleStr,datavalues[i],RightData);
				}
			} else {
				selectObjvalue = data.value.substring(0, data.value.length - 1);
				var titleStr = getKeyByValue(allfileds, selectObjvalue);// 取得数库中列的定义
				if(!titleStr){
                    titleStr = getKeyByValue(LeftDownData, selectObjvalue);
                }
				addMap(titleStr,data.value,RightData);
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
                allfileds.put("${field.ownerTableName}.${field.name}","[${ctp:i18n('formoper.dupform.label')}${field.extraMap.subTableIndex }]"+"${field.display}");
             </c:if>
		 </c:forEach>
		 //先暂时不用
		 <c:forEach items="${systemVarList}" var="sys">
		 allfileds.put("${sys.key}","${sys.text}");
		 sysFiled.put("${sys.key}","${sys.text}");
		 </c:forEach>

		DialogTitle = "${ctp:i18n('form.forminputchoose.datachoose')}";
		ShowTitle = "${ctp:i18n('form.forminputchoose.outputdata')}";
		LeftUpTitle = "${ctp:i18n('form.forminputchoose.formdata')}";// 左上区域的title
		RightTitle = "${ctp:i18n('form.forminputchoose.chooseddata')}";// 右区域的title
		LeftDownTitle = "${ctp:i18n('form.forminputchoose.systemdata')}";// 左下区域的title
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
						if(sysFiled.containsKey(titleStr)){
                            LeftDownData.put(titleStr, datafieldvalues[i]);
                        }else{
                            LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
                        }
					} else {
						var titleStr = getKeyByValue(allfileds,datafieldvalues[i]);// 取得数库中列的定义
						if(sysFiled.containsKey(titleStr)){
                            LeftDownData.put(titleStr, datafieldvalues[i]);
                        }else{
                            LeftUpData.put(titleStr, allfileds.get(titleStr));// 将数据放入map中
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
						// 在左上无对应的值是,取左下
						if (titleStr === "") {
							titleStr = getKeyByValue(LeftDownData,dataareavalue);// 取得数库中列的定义
						}
						addMap(titleStr,testvalues[i],RightData);
				}
			} else {
				// 只有一项
				dataareavalue = getPrimaevalName(textObj.value);// 取得数据库中列的显示名称
				var titleStr = getKeyByValue(LeftUpData, dataareavalue);// 取得数库中列的定义
						// 在左上无对应的值是,取左下
				if (titleStr === "") {
					titleStr = getKeyByValue(LeftDownData,dataareavalue);// 取得数库中列的定义
				}
				addMap(titleStr,textObj.value,RightData);
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
	if(k!=null&&k!=""){
		m.put(k,v);
	}
}
</script>