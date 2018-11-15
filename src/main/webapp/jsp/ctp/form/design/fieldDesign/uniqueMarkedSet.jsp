<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>唯一标识设置</title>
 <script type="text/javascript" src="${path}/ajax.do?managerName=formFieldDesignManager"></script>
 <script type="text/javascript" src="${path}/ajax.do?managerName=formDataManager"></script>
</head>
<script type="text/javascript">
var fieldNamesMap = new Properties();
// {filed0001,[主表]测试}，存放这类值，供加载已有数据是保持和新选择的值一致
var displayNameMap = new Properties();
var parentWin = window.dialogArguments;
var currentDiv;
function init(){
	var newInputTypeArray= new Array();
	var newFieldTypeArray= new Array();
	var newNameArray= new Array();
	var newFieldNameArray= new Array();
	var newTableArray= new Array();
	//var extendArray= new Array();
	var refParamsIdArray= new Array();
	var refInputAtthArray= new Array();
	var bindInputNameArray= new Array();
	var refInputTypeArray= new Array();//关联下拉列表的判断使用
	var formatTypeArray= new Array();//关联下拉列表的判断使用
	var subTableIndexArray = [];
	var fieldlstsize = parentWin.fieldListSize;
	var newOption = document.getElementById("optionarea") ;
	var parentDoc = parentWin.document;
	for(var i=0;i<fieldlstsize ;i++){
		var puttype = $("#inputType"+i,parentDoc).val();
		//var extend = $("#inputType"+i).val();
		var table = $("#fieldName"+i,parentDoc).attr("tableName");
		var name = $("#fieldName"+i,parentDoc).attr("display");
		var subTableIndex = $("#fieldName"+i,parentDoc).attr("subTableIndex");
		var fieldName = $("#fieldName"+i,parentDoc).attr("value");
		var fieldtype = $("#fieldType"+i,parentDoc).val();
		var relParamsId = $("#bindSetAttr"+i,parentDoc).attr("bindObjId");//关联表单ID
		var refInputAttr = $("#bindSetAttr"+i,parentDoc).attr("bindAttr");//关联的字段
		var bindInputName = $("#refInputName"+i,parentDoc).val();//绑定的字段
		var refInputTypeName = $("#bindSetAttr"+i,parentDoc).attr("relationAttrType");//关联下拉列表
		var formatTypeName = $("#formatType"+i,parentDoc).val();//关联下拉列表
		//extendArray[i]=extend;
		newNameArray[i]=name;
		newFieldNameArray[i]=fieldName;
		newTableArray[i]=table;
		newInputTypeArray[i]=puttype;
		newFieldTypeArray[i]=fieldtype;
		refParamsIdArray[i]=relParamsId;
		refInputAtthArray[i]=refInputAttr;
		bindInputNameArray[i]=bindInputName;
		refInputTypeArray[i]=refInputTypeName;
		formatTypeArray[i]=formatTypeName;
		subTableIndexArray[i]=subTableIndex;
		fieldNamesMap.put(name,fieldName);
	}
	newOption ="<select name='dataarea' id='formdataarea' multiple='multiple' style='width:250px;height:440px;'  ondblClick=\"selecttoright('up');\">";
    var mainTablePrefix = $.i18n('form.base.mastertable.label');
    var subTablePrefix=$.i18n('formoper.dupform.label');
	for(var i=0;i<fieldlstsize ;i++){
	      var displayName;
	      if(subTableIndexArray[i] && subTableIndexArray[i] != 'null'){
	          displayName = "["+subTablePrefix+subTableIndexArray[i]+"]"+newNameArray[i];
	      }else{
	          displayName = "["+mainTablePrefix+"]"+newNameArray[i];
	      }
        displayNameMap.put(newFieldNameArray[i],displayName);
        if(newFieldTypeArray[i]=="VARCHAR"||newFieldTypeArray[i]=="DECIMAL"||newFieldTypeArray[i]=="TIMESTAMP"||newFieldTypeArray[i]=="DATETIME"){
                if( newInputTypeArray[i]== "lable" || newInputTypeArray[i]=="text"  || newInputTypeArray[i]=="radio"|| newInputTypeArray[i]=="select" ||newInputTypeArray[i]=="textarea" || newInputTypeArray[i] == "externalwrite-ahead" || newInputTypeArray[i] == "exchangetask" || newInputTypeArray[i] == "querytask" || newInputTypeArray[i] == "customcontrol" )  {
                      newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i] +"' value='"+newFieldNameArray[i]+"' >"+displayName+"</option>";
                }else if (newInputTypeArray[i] == "outwrite"){

                  if (formatTypeArray[i] && (formatTypeArray[i].indexOf("multi") != -1 || formatTypeArray[i].indexOf("mapmarked") != -1 || formatTypeArray[i]=="attachment" || formatTypeArray[i]=="image" || formatTypeArray[i]=="document" || formatTypeArray[i]=="checkbox")){
                  } else {
                    newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i] +"' value='"+newFieldNameArray[i]+"' >"+displayName+"</option>";
                  }
                }else if(!(newInputTypeArray[i]=="attachment" || newInputTypeArray[i]=="image")){
                      if(newInputTypeArray[i]=="member"||newInputTypeArray[i]=="level"||newInputTypeArray[i]=="account" ||newInputTypeArray[i]=="department"||newInputTypeArray[i]=="post"||newInputTypeArray[i]== "date" ||newInputTypeArray[i]=="datetime"||newInputTypeArray[i]=="project" ){//关联的属性为空说明是扩展控件
                            newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i] +"' value='" + newFieldNameArray[i] +"' >"+displayName+"</option>";
                      }else if(newInputTypeArray[i]=="relationform"){
                          if (refInputAtthArray[i] == "flowName") {
                              newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i]  +"' value='" + newFieldNameArray[i] +"' >"+displayName+"</option>";
                          } else {
                              var finalInputType = toSearchFinalType(refParamsIdArray[i],refInputAtthArray[i]);
                              if(typeof (finalInputType)!="undefined"){
                                  var finalArray = finalInputType;//finalInputType.split(",");
                                  if(finalArray != null && (finalArray[0]== "lable" || finalArray[0]=="text"
                                          || finalArray[0]=="radio"|| finalArray[0]=="select" ||finalArray[0]=="textarea"
                                          ||finalArray[0]=="member"||finalArray[0]=="level" ||finalArray[0]=="account" ||finalArray[0]=="department"||finalArray[0]=="post"
                                          ||finalArray[0]== "date" ||finalArray[0]=="datetime"||finalArray[0]=="project" || finalArray[0] =="customcontrol"
                                          || (finalArray[0] == "outwrite"
                                          &&!(finalArray[2].indexOf("multi") != -1 || finalArray[2].indexOf("mapmarked") != -1 || finalArray[2]=="attachment" || finalArray[2]=="image" || finalArray[2]=="document" || finalArray[2]=="checkbox")))){
                                      newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i]  +"' value='" + newFieldNameArray[i] +"' >"+displayName+"</option>";
                                  }
                              }
                          }
                      }else if(newInputTypeArray[i]== "relation" ){
                        var relationFieldAttr = $("#refInputAttr"+i,parentDoc).val();
                          if(refInputTypeArray[i]== "1" || refInputTypeArray[i]== "3" || refInputTypeArray[i]== "8" || refInputTypeArray[i]== "6" || refInputTypeArray[i]== "7" || refInputTypeArray[i]== "9" ){//数据关联 关联人员 枚举 dee任务
                            //关联部门，暂时只需要显示部门代码
                            if(refInputTypeArray[i]== "7"){
                              if (relationFieldAttr == "depCode" || relationFieldAttr == "depMemberCount"
                                      || relationFieldAttr == "depParent" || relationFieldAttr == "depLevel"){
                                newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i]  +"' value='"+newFieldNameArray[i] +"' >"+displayName+"</option>";
                              }
                            } else if (refInputTypeArray[i]== "9"){//关联项目
                              if (relationFieldAttr == "project_number" || relationFieldAttr == "project_type" || relationFieldAttr == "project_status" || relationFieldAttr == "project_progress" || relationFieldAttr == "project_start_date" || relationFieldAttr == "project_end_date"){
                                newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i]  +"' value='"+newFieldNameArray[i] +"' >"+displayName+"</option>";
                              }
                            }else{
                        	  newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i]  +"' value='"+newFieldNameArray[i] +"' >"+displayName+"</option>";
                            }
                          }else{
                        	  //数据关联关联字段名字--这里的字段名字不是用关联表单的bindAttr,而是直接用关联属性
                              if (relationFieldAttr != "formContent") {
                                  var finalInputType = getFinalInputType(bindInputNameArray[i],relationFieldAttr,refParamsIdArray,newFieldNameArray);
                                  if( finalInputType!=null && typeof (finalInputType)!="undefined" && finalInputType != "NOT" ){
                                      var finalArray = finalInputType;//finalInputType.split(",");
                                      if((finalArray[0]== "lable" || finalArray[0]=="text"  || finalArray[0]=="radio"|| finalArray[0]=="select" ||finalArray[0]=="textarea"||finalArray[0]=="member"||finalArray[0]=="level"||finalArray[0]=="account" ||finalArray[0]=="department"||finalArray[0]=="post"||finalArray[0]== "date" ||finalArray[0]=="datetime"||finalArray[0]=="project"|| finalArray[0]=="customcontrol" )){
                                          newOption += " <option table='"+newTableArray[i]+"' fieldtype='"+newInputTypeArray[i]  +"' value='"+newFieldNameArray[i] +"' >"+displayName+"</option>";
                                      }
                                  }
                              }
                          }
                    }
                }
          }
    }
	newOption+="</select>";
	document.getElementById("optionarea").innerHTML = newOption;
	for(var i = 1; i <= ${subTableSize}; i++){
		$("#uniqueMarket" + i).addClass("table${subTableSize}").removeClass("hidden");
	}
    $("#rightSelect").css("height",$("#leftSelect").height());
    $("#serachbtn").click(function(){
        search();
    });
    $("#searchValue").keyup(function(event) {
        if (event.keyCode == 13) {
            search();
        }
    });
}

var allOptions;
function search() {
    var select = $("#formdataarea");
    var searchValue = $("#searchValue").val();
    if (!allOptions) {
        allOptions = select.find("option");
    }
    var leaveOptios = [];
    allOptions.each(function(){
        var text = this.text;
        if (text.indexOf(searchValue) != -1){
            leaveOptios[leaveOptios.length] = this;
        }
    });
    $("option",select).each(function(){
        $(this).remove();
    });
    for (var i=0; i < leaveOptios.length; i++) {
        var o = leaveOptios[i];
        select.append(o);
    }
}

function getFinalInputType(bindInputName,refInputAtth,refParamsIdArray,newNameArray){
	for(var i=0;i < newNameArray.length ;i++){
		if(bindInputName==newNameArray[i]){
			return  toSearchFinalType(refParamsIdArray[i],refInputAtth);
		}
	}
	return "NOT";
}

function toSearchFinalType(refParamsId,refInputAtth){
    if (refInputAtth == "formContent") {
        return;
    }
	var oo = new formFieldDesignManager();
	return refInputAtth ? oo.getFinalInputType(refParamsId, refInputAtth) : "NOT";
}
function changeCurrentDiv(obj){
  currentDiv = $(obj);
}
function setParent4CurrentDiv(obj){
  changeCurrentDiv($(obj).parents("[id^=uniqueMarket]"));
}
</script>
<style type="text/css">
    .table1 {
    height: 380px;
    }
    .table1 [type=select]{
    margin-top: 140px;
    }
    .table1 [type=selectdata]{
    }
    .table1 [type=selectdata] select{
    height: 360px;;
    }
    
    .table2{
    height: 190px;
    }
    .table2 [type=select]{
    margin-top: 70px;
    }
    .table2 [type=selectdata]{
    }
    .table2 [type=selectdata] select{
    height: 160px;;
    }
    
    .table3{
    height: 120px;
    }
    .table3 [type=select]{
    margin-top:35px;
    }
    .table3 [type=selectdata]{
    }
    .table3 [type=selectdata] select{
    height: 100px;;
    }
    
    .table4{
    height: 85px;;
    }
    .table4 [type=select]{
    margin-top: 15px;
    }
    .table4 [type=selectdata]{
    }
    .table4 [type=selectdata] select{
    height: 75px;;
    }
    .table6{
        height: 75px;
    }
    .table6 [type=select]{
        margin-top: 15px;
    }
    .table6 [type=selectdata]{
    }
    .table6 [type=selectdata] select{
        height: 65px;
    }
    .titleLabel{
        height: 25px;
        vertical-align: middle;
        line-height: 25px;
    }
</style>
<BODY scroll=no onload="init();show();" class="">
<form method="post" action="" >
    <div class = "margin_t_5 font_size12 clearfix">
        <div style="width: 250px;margin-left: 10px;" class="left margin_l_5 margin_t_5" id="leftSelect">
            <div id="fieldHead" class="clearfix" style="margin-bottom: 5px;">
                <div id="fieldLabel" class="left titleLabel" style="margin-right: 5px;">${ctp:i18n('form.compute.formdata.label')}:</div>
                <div id="searchArea" class="left">
                    <ul class="common_search">
                        <li id="inputBorder" class="common_search_input">
                            <input id="searchValue" class="search_input" type="text" style="width:100px;">
                        </li>
                        <li>
                            <a id="serachbtn" class="common_button search_buttonHand" href="javascript:void(0)">
                                <em></em>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div id="optionarea"></div>
        </div>
        <div style="width: 300px;overflow-y: auto;overflow-x: hidden;" class="left margin_l_5 margin_t_5" id="rightSelect">
            <div class="clearfix hidden" id="uniqueMarket1" style="width: 100%;" onclick="changeCurrentDiv(this)">
                <div type="select" class="left" style="width: 35px;">
                    <span class="ico16 select_selected" style="cursor:hand;"  onclick="setParent4CurrentDiv(this);selecttoright();"></span>
	               <br>
	               <span class="ico16 select_unselect" onclick="setParent4CurrentDiv(this);delOption();"  style="cursor:hand;"></span>
                </div>
                <div type="data" class="left" style="width: 240px;">
                    <div type = "title">${ctp:i18n('form.base.uniqueFlag.member') }1：</div>
                    <div type=selectdata>
                        <select name="dataarea1" id="uniquedataarea1" style="width: 240px;" multiple="multiple" ondblClick="setParent4CurrentDiv(this);delOption();" >
                        </select>
                    </div>
                </div>
            </div>
            <div class="clearfix hidden margin_t_10" id="uniqueMarket2" style="width: 100%;" onclick="changeCurrentDiv(this)">
                <div type="select" class="left" style="width: 35px;">
                    <span class="ico16 select_selected" style="cursor:hand;"  onclick="setParent4CurrentDiv(this);selecttoright();"></span>
                   <br>
                   <span class="ico16 select_unselect" onclick="setParent4CurrentDiv(this);delOption();"  style="cursor:hand;"></span>
                </div>
                <div type="data"  class="left" style="width: 240px;">
                    <div type = "title">${ctp:i18n('form.base.uniqueFlag.member') }2：</div>
                    <div type=selectdata>
                        <select name="dataarea2" id="uniquedataarea2" size="4" style="width: 240px;" multiple="multiple" ondblClick="setParent4CurrentDiv(this);delOption();" >
                        </select>
                    </div>
                </div>
            </div>
            <div class="clearfix hidden margin_t_10" id="uniqueMarket3" style="width: 100%;" onclick="changeCurrentDiv(this)">
                <div type="select" class="left" style="width: 35px;">
                    <span class="ico16 select_selected" style="cursor:hand;"  onclick="setParent4CurrentDiv(this);selecttoright();"></span>
                   <br>
                   <span class="ico16 select_unselect" onclick="setParent4CurrentDiv(this);delOption();"  style="cursor:hand;"></span>
                </div>
                <div type="data"  class="left" style="width: 240px;">
                    <div type = "title">${ctp:i18n('form.base.uniqueFlag.member') }3：</div>
                    <div type=selectdata>
                        <select name="dataarea3" id="uniquedataarea3" size="4" style="width: 240px;" multiple="multiple" ondblClick="setParent4CurrentDiv(this);delOption();" >
                        </select>
                    </div>
                </div>
            </div>
            <div class="clearfix hidden margin_t_10" id="uniqueMarket4" style="width: 100%" onclick="changeCurrentDiv(this)">
                <div type="select" class="left" style="width: 35px;">
                    <span class="ico16 select_selected" style="cursor:hand;"  onclick="setParent4CurrentDiv(this);selecttoright();"></span>
                   <br>
                   <span class="ico16 select_unselect" onclick="setParent4CurrentDiv(this);delOption();"  style="cursor:hand;"></span>
                </div>
                <div type="data"  class="left" style="width: 240px;">
                    <div type = "title">${ctp:i18n('form.base.uniqueFlag.member') }4：</div>
                    <div type=selectdata>
                        <select name="dataarea4" id="uniquedataarea4" size="4" style="width: 240px;" multiple="multiple" ondblClick="setParent4CurrentDiv(this);delOption();" >
                        </select>
                    </div>
                </div>
            </div>
            <div class="clearfix hidden margin_t_10" id="uniqueMarket5" style="width: 100%" onclick="changeCurrentDiv(this)">
                <div type="select" class="left" style="width: 35px;">
                    <span class="ico16 select_selected" style="cursor:hand;"  onclick="setParent4CurrentDiv(this);selecttoright();"></span>
                    <br>
                    <span class="ico16 select_unselect" onclick="setParent4CurrentDiv(this);delOption();"  style="cursor:hand;"></span>
                </div>
                <div type="data"  class="left" style="width: 240px;">
                    <div type = "title">${ctp:i18n('form.base.uniqueFlag.member') }5：</div>
                    <div type=selectdata>
                        <select name="dataarea5" id="uniquedataarea5" size="4" style="width: 240px;" multiple="multiple" ondblClick="setParent4CurrentDiv(this);delOption();" >
                        </select>
                    </div>
                </div>
            </div>
            <div class="clearfix hidden margin_t_10" id="uniqueMarket6" style="width: 100%" onclick="changeCurrentDiv(this)">
                <div type="select" class="left" style="width: 35px;">
                    <span class="ico16 select_selected" style="cursor:hand;"  onclick="setParent4CurrentDiv(this);selecttoright();"></span>
                    <br>
                    <span class="ico16 select_unselect" onclick="setParent4CurrentDiv(this);delOption();"  style="cursor:hand;"></span>
                </div>
                <div type="data"  class="left" style="width: 240px;">
                    <div type = "title">${ctp:i18n('form.base.uniqueFlag.member') }6：</div>
                    <div type=selectdata>
                        <select name="dataarea6" id="uniquedataarea6" size="4" style="width: 240px;" multiple="multiple" ondblClick="setParent4CurrentDiv(this);delOption();" >
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<%@ include file="uniqueMarkedSet.js.jsp" %>
</BODY>
</HTML>

