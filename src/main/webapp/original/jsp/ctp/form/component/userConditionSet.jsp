<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="../common/common.js.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style>
	.stadic_head_height{
		height:35px;
	}
	.stadic_body_top_bottom{
		bottom: 0px;
 		top: 35px;
	}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=componentManager"></script>
</head>
<body class="h100b over_hidden">
<div class=" margin_t_5">
		<div class="stadic_layout_head stadic_head_height">
		<a class="common_button common_button common_button_gray margin_l_5" href="javascript:void(0)" id="add">${ctp:i18n('form.oper.add.label')}</a>
		<a class="common_button common_button common_button_gray margin_l_10" href="javascript:void(0)" id="update">${ctp:i18n('form.oper.update.label')}</a>
		<a class="common_button common_button common_button_gray margin_l_10" href="javascript:void(0)" id="del">${ctp:i18n('form.trigger.triggerSet.delete.label')}</a>
		</div>
		<div class="stadic_layout_body stadic_body_top_bottom " style="overflow-x: hidden">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
		                    <thead>
		                        <tr>
		                            <th width="20"><input type="checkbox" onclick="selectAll(this,'conditionBody');"/></th>
		                            <th width="27%" align="center">${ctp:i18n('form.query.conditionname.label')}</th>
		                            <th width="27%" align="center">${ctp:i18n('form.forminputchoose.title')}</th>
		                            <th width="23%"align="center">${ctp:i18n('form.query.user.custom.inputtype.label')}</th>
		                            <th width="20%"align="center">${ctp:i18n('form.query.defaultvalue.label')}</th>
		                        </tr>
		                    </thead>
		                    <tbody id="conditionBody">
		                    	<c:forEach var="query" items="${formBean.formQueryList }" varStatus="status">
			                    		<tr <c:if test="${(status.index % 2) == 1 }">class="erow"</c:if>>
		                            		<td id="selectBox"><input type="checkbox" value="${query.id }"  onclick="setInitState();initShowTitle();initShowTable();"/></td>
		                            		<td queryId="${query.id }" onclick="showQuery(this);11">${ctp:getLimitLengthString(query.name , 10, '...')}</td>
		                            		<c:set var="auth" value="${query.moduleAuthStr }"></c:set>
		                            		<td queryId="${query.id }" onclick="showQuery(this);"><input type="hidden" value="${auth[0] }" id="authCode${query.id }"/>
		                            		<input type="hidden" value="${auth[1] }" id="authName${query.id }"/>
		                            		${auth[1] }</td>
		                        		</tr>
		                        </c:forEach>
		                    </tbody>
		                 </table>
		</div>
	</div>	
</body>
<script type="text/javascript">
var data = new Array();
var dialogParam = window.dialogArguments;
var dataDom = dialogParam.data;
var formulaDom = dialogParam.formula;
var moduleType = dialogParam.moduleType;
if(!moduleType){
    moduleType = "";
}
var editFormulaFlag = false;
var formulaStr = formulaDom.val();
if(dataDom.val()!=""){
	var ss = $.parseJSON(dataDom.val());
	for(var i=0;i<ss.length;i++){
		data[i] = ss[i];
	}
}
//[{id:'',name:'www',title:'rrrr',inputTypeEnum:{text:'文本'},value:'222'},{id:'',name:'www2',title:'rrrr2',inputTypeName:'文本',value:'222'}]
function initDataList(){
	$("#conditionBody").empty();
	if(data.length>0){
		for(var i=0;i<data.length;i++){
			initDataShow(data[i],i);
		}
	}
}

function initDataShow(dt,s){
	var sb = '<tr'+(s%2 == 1?' class="erow">':'>');
	sb = sb + '<td><input type="checkbox" value="'+dt.name+'"/></td>';
	var name = dt.name;
	if (name.length > 12){
	  name = name.substr(0,12) + "...";
	}
	sb = sb + '<td title="'+dt.name+'">'+name+'</td>';
	var title = dt.title;
	  if (title.length > 12){
	    title = title.substr(0,12) + "...";
	  }
	sb = sb + '<td title="'+dt.title+'">'+title+'</td>';
	var typeName = dt.inputTypeName+(dt.enumName!=null&&dt.enumName!=''?('【'+dt.enumName+'】'):'');
	typeName = typeName.escapeHTML(true);
	var temp = typeName;
	if (typeName.length > 10){
	  typeName = typeName.substr(0,10) + "...";
	}
	sb = sb + '<td title="'+temp+'">'+typeName+'</td>';
	var showValue = (dt.showValue==null?'':dt.showValue);
	temp = showValue;
	if (showValue.length> 7){
	  showValue =showValue.substr(0,7) + "...";
	}
	sb = sb + '<td title="'+temp+'">'+showValue+'</td>';
	sb = sb + '</tr>';
	$("#conditionBody").append(sb);
}
var winObj = new Object();
winObj.win = window;
$(document).ready(function(){
	$("#add").click(function(){
		winObj.dat=null;
		var dialog = $.dialog({
            url:"${path}/form/component.do?method=userConditionSet",
            title : "${ctp:i18n('form.query.user.customCotion.set.label')}"+"${ctp:i18n('form.trigger.triggerSet.set.label')}",
            width:500,
            height:300,
            transParams:winObj,
            targetWindow:getCtpTop(),
            buttons : [{
                text : "${ctp:i18n('form.forminputchoose.enter')}",
                id:"sure",
				isEmphasize: true,
                handler : function() {
                    var ww = dialog.getReturnValue();

                	var result = createObj(ww);
                    if("error" == result){
                        return;
                    }
                    if(result){
                    	var ind = listContainName(data,result.name);
                    	if(ind>-1){
                        	$.error("${ctp:i18n_1('form.query.customcondition.exist.name.error','"+result.name+"')}");
                        	return;
                        }
                    	data[data.length] = result;
                    	initDataList();
                    }
                    dialog.close();
                }
              }, {
                text : "${ctp:i18n('form.forminputchoose.cancel')}",
                id:"exit",
                handler : function() {
                  dialog.close();
                }
              }]
            });
	});
	$("#update").click(function(){
		if($(":checked","#conditionBody").length!=1){
			$.alert("${ctp:i18n('form.query.customcondition.onlyone.toupdate.label')}");
			return;
		};
		winObj.dat = findByName($(":checked","#conditionBody").val());
		var dialog = $.dialog({
            url:"${path}/form/component.do?method=userConditionSet",
            title : "${ctp:i18n('form.query.user.customCotion.set.label')}"+"${ctp:i18n('form.trigger.triggerSet.set.label')}",
            width:500,
            height:300,
            transParams:winObj,
            targetWindow:getCtpTop(),
            buttons : [{
                text : "${ctp:i18n('form.forminputchoose.enter')}",
                id:"sure",
				isEmphasize: true,
                handler : function() {
            	 	var ww = dialog.getReturnValue();

             		var result = createObj(ww);
             		
                    if("error" == result){
                        return;
                    }
                    if(result){
                        var ind = listContainName(data,result.name);
                        if(ind>-1&&winObj.dat.name!=result.name){
                        	$.error("${ctp:i18n_1('form.query.customcondition.exist.name.error','"+result.name+"')}");
                        	return;
                        }
                        if(winObj.dat.name!=result.name){//改名字了
                        	formulaStr = formulaStr.replaceAll("\\["+winObj.dat.name+"\\]","["+result.name+"]");
                        	editFormulaFlag = true;
                        }
                        data[listContainName(data,$(":checked","#conditionBody").val())] = result;
                    	initDataList();
                    }
                    dialog.close();
                }
              }, {
                text : "${ctp:i18n('form.forminputchoose.cancel')}",
                id:"exit",
                handler : function() {
                  dialog.close();
                }
              }]
            });
	});
	$("#del").click(function(){
		if($(":checked","#conditionBody").length==0){
			$.error("${ctp:i18n('form.authDesign.chooseonetodelete')}");
			return;
		};
		var flag = true;
		$(":checked","#conditionBody").each(function(){
				if(formulaStr.indexOf("["+$(this).val()+"]")>-1){
					$.error($.i18n('form.query.customcondition.notcandel.toupdate.label',$(this).val()));
					flag = false;
					return false;
				}
			}
		);
		if(flag){
			$.confirm({
			    'msg' : "${ctp:i18n('form.query.customcondition.confirm.todel.select.label')}",
			    ok_fn : function() {
			    	$(":checked","#conditionBody").each(function(){
						var i = listContainName(data,$(this).val());
						data.splice(i,1);
					});
					initDataList();
			    }
			 });
		}
	});
	initDataList();
});

function listContainName(ary,name){
	for(var i=0;i<ary.length;i++){
		if(ary[i].name==name){
			return i;
		}
	}
	return -1;
}

function findByName(name){
	for(var i=0;i<data.length;i++){
		if(data[i].name==name){
			return data[i];
		}
	}
	return null;
}

function createObj(ww){
	if(ww=="error"){
		return ww;
	}
	var dat = $("body",ww.document).formobj();
	if(dat.inputType == "radio"){
		var sDom = $("#enumId",ww.document);
		if(sDom.val()==""){
			$.error("${ctp:i18n('form.query.customcondition.tosel.enumtype.label')}");
			return "error";
		}
		dat.enumName=$(":selected",sDom).text();
	}
	if(dat.inputType == "select"){
	    var sDom = $("#selectId",ww.document);
        if(sDom.val()==""){
            $.error("${ctp:i18n('form.query.customcondition.tosel.enumtype.label')}");
            return "error";
        }
        dat.enumId=sDom.val();
        dat.enumName=$("#selectName",ww.document).val();
	}
	if(dat.systemValue==null||""==dat.systemValue){
		dat.value = $("#handValue",ww.document).val();
		dat.showValue = dat.value;
	}else{
		dat.value = $("#systemValue",ww.document).val();
		dat.showValue = $(":selected",$("#systemValue",ww.document)).text();
	}
	//dat.inputTypeEnum =  new Object();
	dat.inputTypeName = $(":selected",$("#inputType",ww.document)).text();
	return dat;
}

function OK(){
    var dataJson = $.toJSON(data);
    var form = new componentManager();
    form.saveUserFieldsCache(moduleType,dataJson);
	dataDom.val(dataJson);
	if(editFormulaFlag){
		formulaDom.val(formulaStr);
	}
}
</script>
</html>