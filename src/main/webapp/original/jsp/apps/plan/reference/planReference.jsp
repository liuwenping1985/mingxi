<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>listhome</title>
</head>
<script type="text/javascript" src="${path}/ajax.do?managerName=planRefRelationManager"></script>
<script type="text/javascript">
function refItem(id,name,type,sourceid,tablename,masterDataId,sourceCreator,formId){
	this.id=id;//重复项的id(对应表单的recordid)
	this.name=name;//名称(对应事项描述)
	this.type=type;//参照计划还是参照任务
	this.sourceid=sourceid;//planid(计划参照时有用)
	this.tablename=tablename;//重复项表名
	this.masterDataId=masterDataId;//主表id
	this.sourceCreator = sourceCreator;//源计划或者任务创建者
	this.formId = formId;
}
var selectdList = new Array();

function OK(){
  return $.toJSON(selectdList);
}

function deleteItem(id,type){
	removeFromList(id,type);
}
function addItem2Div(item){
	if(item==null){return;}
	var classIcon="plan_16";
	if(item.type=="myTask"){
		classIcon = "personal_tasks_16";
	}
	if(item.type=="form"){
		classIcon = "form_16";
	}
	if(item.name!=""){
		var itemName = item.name;
		itemName = itemName.replace(new RegExp("<br/>","gm")," ");
	    var str = "<div class='valign_m left' id='"+item.type+"_"+item.id+"' title='"+itemName+"' style='width:140px;'>"
        +"<span class='ico16 "+classIcon+"' style='width:16px;'></span>"
        +"<span style='width:85px;' class='h100b valign_m'>"+escapeStringToHTML(cutString(escapeHTMLToString(itemName, true),10,true))+"</span>"
        +"<span class='ico16 affix_del_16' onclick='deleteItem(\""+""+item.id+"\",\""+item.type+"\")'></span>"
        +"</div>";
        $("#selectItems").append(str);
	}
	
}

/**
 * 将HTML代码转换成字符串
 */
function escapeHTMLToString(str, isEscapeSpace, isEscapeBr){
	if(!str){
		return "";
	}
	
	str = str.replace(/&amp;/gi, "&");
	str = str.replace(/&lt;/gi, "<");
	str = str.replace(/&gt;/gi, ">");
	str = str.replace("", "\r"); 
	if(typeof(isEscapeBr) == 'undefined' || (isEscapeBr == true || isEscapeBr == "true")){
	  str = str.replace(/<br>/gi, "\n");
  	}
	str = str.replace(/&#039;/gi, "\'");
	str = str.replace(/&#034;/gi, "\"");
	
	if(typeof(isEscapeSpace) != 'undefined' && (isEscapeSpace == true || isEscapeSpace == "true")){
		str = str.replace(/&nbsp;/gi, " ");
	}
	
	return str;
}
function cutString(str, len, hasDot) {
  var newLength = 0;
  var newStr = "";
  var chineseRegex = /[^\x00-\xff]/g;
  var singleChar = "";
  var strLength = str.replace(chineseRegex, "**").length;
  for (var i = 0; i < strLength; i++) {
    singleChar = str.charAt(i).toString();
    if (singleChar.match(chineseRegex) != null) {
      newLength += 2;
    } else {
      newLength++;
    }
    if (newLength > len) {
      break;
    }
    newStr += singleChar;
  }

  if (hasDot && strLength > len) {
    newStr += "...";
  }
  return newStr;
}

function formatWord(str){
	if(str==null){str = "";};
	if(str.length>8){
		str = str.substring(0,7)+"...";
	}
	return str;
}

function getIFrameDOM(id){
  return document.getElementById(id).contentDocument || document.frames[id].document;
}

function removeFromList(id,type){
	if(selectdList.length==0){
		return;
	}else{
		var tempList = selectdList;
		var tempList2 = new Array();
		for(var i=0;i<tempList.length;i++){
			var temp = tempList[i];
			if(type == "myPlanForReferMe"){
			  temp.type = "myPlanForReferMe";
			}
			if(id=="all"){
				if(temp.type==type){
					 continue;
				}else{
					if(type == "myPlanForReferMe"){
						  temp.type = "myPlan";
					}
					tempList2.push(temp);
				}
			}else {
				if(temp.id==id&&temp.type==type){
					 continue;				 
				}else{
					if(type == "myPlanForReferMe"){
						  temp.type = "myPlan";
					}
					tempList2.push(temp);
				}
			}
		}
		if(id=="all"){
			 $("div[id^='"+type+"']").each(function(){
				 $(this).remove();
			 });
		}else{
			var dom = document;
			var dom2 = document;
			if(type=="myPlan"){
				try{
					dom = $("#tab_iframe_1").contents().find("#planContentFrame").contents().find("#mainbodyFrame").contents();
				}catch(e){
				}
				dom2 = getIFrameDOM('tab_iframe_0');
			}else if(type=="othersPlan"){
				dom= getIFrameDOM('tab_iframe_2');
			}else if(type=="myTask"){
				dom= getIFrameDOM('tab_iframe_3');
			} else if(type == "myMeeting") {
                dom= getIFrameDOM('tab_iframe_4');
            } else if(type=="myPlanForReferMe"){
                dom= getIFrameDOM('tab_iframe_0');
            }
			if(type == "myPlanForReferMe"){
			   $("#myPlan_"+id).remove();
			} else {
			   $("#"+type+"_"+id).remove();
			}
			if($("input[value='"+id+"']",dom)[0]!=undefined){
			  $("input[value='"+id+"']",dom)[0].checked = false;
			}
			if($("input[value='"+id+"']",dom2)[0]!=undefined){
              $("input[value='"+id+"']",dom2)[0].checked = false;
            }
		}
		selectdList=tempList2;
		tempList2=tempList=null;
	}
}

function init(){
  if("${planRefRelationBO}"!=undefined && "${planRefRelationBO}" != ""){
    var refType = "myPlan";
    if("${planRefRelationBO.sourceType}"==30){
      //如果是参照的计划，则关联关系是任务
      refType = "myTask";
    }else if ("${planRefRelationBO.sourceType}"==6){
      refType = "myMeeting";
    }
    var item = new refItem("${planRefRelationBO.sourceDataId}","${ctp:toHTML(planRefRelationBO.sourceTitle)}",refType,"${planRefRelationBO.sourceId}","","","${planRefRelationBO.sourceCreator}");
    selectdList.push(item);
    addItem2Div(item);
  }
}
</script>
<body scroll="no" onload="init()" class="h100b over_hidden page_color bg_color">
    <div id="tabs" class="comp margin_t_5" comp="type:'tab',height:410" >
        <div id="tabs_head" class="common_tabs clearfix">
            <ul class="left margin_l_5">
                <li class="current"><a id="referMe" href="javascript:void(0)" tgt="tab_iframe_0"><span>${ctp:i18n('plan.referMe')}</span></a></li>
                <li><a id="myPlan" href="javascript:void(0)" tgt="tab_iframe_1"><span>${ctp:i18n('plan.label.reference.referplan')}</span></a></li>
                <c:if test="${ctp:hasPlugin('taskmanage')}">
                <li><a id="myTask" href="javascript:void(0)" tgt="tab_iframe_3"><span>${ctp:i18n('plan.label.reference.refertask')}</span></a></li>
                </c:if>
                <c:if test="${ctp:hasPlugin('meeting')}">
                <li><a id="myMeeting" hideFocus="true" class="last_tab" href="javascript:void(0)" tgt="tab_iframe_4"><span>${ctp:i18n('plan.referMeeting')}</span></a></li>
                </c:if>
            </ul>
        </div>
        <div id="tabs_body" class="common_tabs_body" style="overflow:hidden;">
            <%--提及到我的 --%>
            <iframe id="tab_iframe_0" border="0" hSrc="plan.do?method=planReferTome&curPlanId=${empty param.curPlanId ? -1 : param.curPlanId}&formId=${param.formId}&subTableName=${ctp:encodeURI(param.subTableName)}&needDisplayNames=${ctp:encodeURI(param.needDisplayNames)}" frameBorder="no" width="100%" class="hidden"></iframe>
            <%--参照计划 --%>
            <iframe id="tab_iframe_1" border="0" hSrc="plan.do?method=getPlanRefers&curPlanId=${empty param.curPlanId ? -1 : param.curPlanId}" frameBorder="no" width="100%" class="hidden"></iframe>
            <%--参照任务 --%>
            <c:if test="${ctp:hasPlugin('taskmanage')}">
            <iframe id="tab_iframe_3" border="0" hSrc="plan.do?method=getMyTaskList" frameBorder="no" width="100%" class="hidden"></iframe>
            </c:if>
            <%--参照会议 --%>
            <c:if test="${ctp:hasPlugin('meeting')}">
            <iframe id="tab_iframe_4" border="0" hSrc="plan.do?method=getMeetingList" frameBorder="no" width="100%" class="hidden"></iframe>
            </c:if>
        </div>
    </div>
     <div id="selectedDiv" class="font_size12 margin_t_5" style="height:20px;">
        	<span class='valign_m left padding_5'>${ctp:i18n('plan.label.reference.hasselect')}：</span><div id="selectItems" style="padding: 5px;height: 31px;overflow: auto;"></div>
     </div>
</body>
</html>