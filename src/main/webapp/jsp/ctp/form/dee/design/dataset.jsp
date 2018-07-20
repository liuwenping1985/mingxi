<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<html>
<head>
<title>DEE</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/form/js/formquery/query_commselcondition.js"/>"></script>
<script type="text/javascript">
    function initSelectMy(){
    	var mys = document.getElementById("myselect");
    	var length = mys.options.length;
    	for(var i=0;i<length;i++){
    		mys.options[i].selected = false;
        } 
    }
    function initSystemList(){
    	var systemselect = document.getElementById("systemselect");
    	var length = systemselect.options.length;
    	for(var i=0;i<length;i++){
    		systemselect.options[i].selected=false;
        }
    }

    function selectArgs(obj,select){
    	var index=obj.selectedIndex; //序号，取当前选中选项的序号
    	
		if(index>=0){
			if("myselect" == select){
				initSystemList();
	        }else{
	        	initSelectMy();
	        }
			$("#selectValue").val($("select option:selected").attr("displayName"));
		}
    }

    function OK(){
    	var returnValue ="";
        var display = document.all.selectValue.value;
        var element;
		if(display.indexOf("}")>0){
			element = document.getElementById("systemselect");
		}else{
			element = document.getElementById("myselect");
		}
		var index = element.selectedIndex;
		if(index>=0){
			var value = element.options[index].value;
			returnValue += value;
		}
		returnValue +=",";
		returnValue += display;
		return returnValue;
    }
    function cancelButtonClick(){
    	window.close();
    }
	function init(){
		var value = "${param.showStr}";
		if(value != null||value != ""){
			var element;
			if(value.indexOf("}")>0){
				element = document.getElementById("systemselect");
				$("#system").removeClass("hidden");
				$("#data").addClass("hidden");
			}else{
				element = document.getElementById("myselect");
				$("#system").addClass("hidden");
				$("#data").removeClass("hidden");
			}
			element.value = value;
			$("#selectValue").val($("select option:selected").attr("displayName"));
		}
	} 
	
</script>
</head>

<body scroll="no" onload="init()">
<form name="form1" method="post">
<input type="hidden" readonly="readonly" id="selectValue" name="selectValue" value="">
<table width="98%" height="95%" border="0">
  <tr>
    <td class="bg-advance-middel">
                <div id="tabs2" class="comp" comp="type:'tab',width:510,height:300">
                    <div id="tabs2_head" class="common_tabs clearfix">
                        <ul class="left">
                            <li class="current"><a class="no_b_border" href="javascript:void(0)" tgt="data">						
							<!-- 表单数据域 -->
						  		${ctp:i18n('form.compute.formdata.label') }</a></li>
                            <li><a class="no_b_border last_tab" href="javascript:void(0)" tgt="system">
					  		<!-- 系统变量 -->
					     		${ctp:i18n('form.operhigh.systemvar.label')}</a></li>
                        </ul>
                    </div>
                    <div id="tabs2_body" class="common_tabs_body border_all">
                        <div id="data">
						<select  name="formdata" size="23" style="width:100%"
					  		id="myselect" onclick="selectArgs(this,'myselect');" ondblclick= "">
							<c:forEach items="${fieldList}" var="obj" varStatus="status">
						    	<option  displayName="${obj.display}" id="${obj.id}" value="${obj.name}" extend="${obj.extraMap.canExtend}" fieldType="${obj.fieldType}" inputType="${obj.inputType}">${obj.display}</option>
							</c:forEach> 
						</select>					
						</div>
                        <div id="system" class="hidden">
							<select name="systemset" size="23" style="width: 100%" id="systemselect" onclick="selectArgs(this,'systemselect');"
						ondblclick="">
							<c:forEach items="${sys}" var="obj" varStatus="status">
								<option value="{${obj.key}}" displayName="{${obj.value}}" inputType="" fieldType="" extend="true">${obj.value}</option>
							</c:forEach> 
							</select>					
						</div>
                    </div>
                </div>
	</td>
  </tr>
</table>
</form>
</body>
</html>
