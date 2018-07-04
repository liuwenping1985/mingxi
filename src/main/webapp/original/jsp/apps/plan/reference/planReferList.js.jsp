<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
  var table;
  //查看计划
  var showPlan = function(data, r, c) {
	  var contentFrame = document.getElementById("planContentFrame");
	  var toSrc = "plan.do?method=initPlanDetailFrame&isRef=true&planId="+data.id+"&isFromRefer="+true;
	  contentFrame.src = toSrc;
	  var layout = $("#layout").layout();
	  layout.setSouth(40);
  }
  
  var rend = function(txt, data, r, c,col) {
	  if(col.name=='title'){
	        txt = txt+data.viewTitle;
			if(data.hasAttatchment==true){
			  txt = txt+"<span class='ico16 affix_16'></span>";
			}
			return txt;
	  }
	if(col.name=='finishRatio'){
		return txt.toString()+"%";
	}
	if(col.name=='process'){
		if(txt==1){
			return "${ctp:i18n('plan.desc.replydetail.replyed')}";
		}
		if(txt==0){
			return "${ctp:i18n('plan.desc.replydetail.unreplyed')}";
		}
	}
	if(col.name=='type'){
		if(txt==1){
			return "${ctp:i18n('plan.type.dayplan')}";
		}
		if(txt==2){
			return "${ctp:i18n('plan.type.weekplan')}";
		}
		if(txt==3){
			return "${ctp:i18n('plan.type.monthplan')}";
		}
		if(txt==4){
			return "${ctp:i18n('plan.type.anyscopeplan')}";
		}
	}
	if(col.name=="isMentioned"){
        if(txt=="1"){
            txt = "<span class='ico16 remind_me_16'></span>"
        }else{
            txt = "";
        }
        return txt;
    }
    return txt;
  }


  function refrenceCondition(userIds,dayPlanCount,weekPlanCount,monthPlanCount,anyScopePlanCount) {
    this.userIds = userIds;
    this.dayPlanCount = dayPlanCount;
    this.weekPlanCount=weekPlanCount;
    this.monthPlanCount = monthPlanCount;
    this.anyScopePlanCount = anyScopePlanCount;
  }
  
  var refrenceCondition;
  
  var initTable = function(userIds,isall) {
	  refrenceCondition.userIds = userIds;
	  //$.alert($.toJSON(refrenceCondition));
	  refrenceCondition.isall = isall;
	  refrenceCondition.curPlanId = "${param.curPlanId}";
	  $("#myPlanList").ajaxgridLoad(refrenceCondition);
  }
  
  
  /**
   * 对标题默认值的切换
   * @param isShowBlack 去掉为默认值，显示空白，用在onFocus
   */
  function checkDefSubject(obj, isShowBlack) {
    var dv = getDefaultValue(obj);
    if (isShowBlack && obj.value == dv) {
            obj.value = "";
    }
    else if (!obj.value) {
            obj.value = dv;
    }
}

/**
 * 从input中读取属性为defaultValue的值
 */
function getDefaultValue(obj){
    if(!obj){
        return null;
    }
    var def = obj.attributes.getNamedItem("defaultValue");
    if(!def){
        def = obj.attributes.getNamedItem("deaultValue"); //兼容以前错误的写法
    }
    
    if(def){
        return def.nodeValue;
    }
    
    return null;
}

function afterSuccess(){
	DisabledSomeData();
	bindCheckBoxEvent();
}

function DisabledSomeData(){
	if($("#myPlanList")[0]){
		$("#myPlanList").formobj({
            gridFilter : function(data, row) {
            	if(data.contentType!=20){
	                if($("input:checkbox", row).val() == data.id){
	                    $("input:checkbox", row).prop('disabled', true);
	                }
            	}
            }
        });
	}
}


function bindCheckBoxEvent(){
	$("#taskInfoList tbody tr").unbind("click");	//取消tr上的click事件
	$("#meetingList tbody tr").unbind("click");
	$("#repeatList tbody tr").unbind("click");
	var id = $(".flexigrid").attr("id")+"_classtag";
	$("#center input:checkbox").each(   //只为任务列表中的checkbox绑定事件。tasklist页面的list部分的ID为center
			function(){
				$(this).bind("click",changeThis);
			}
	);
}

//列表全选事件
function gridSelectAllPersonalFunction(flag){
  var type;
  var grid;
  if($("#myPlanList")[0]){
      grid = $("#myPlanList")[0].grid;
      type="myPlan";
  }else if($("#meetingList")[0]){
    grid = $("#meetingList")[0].grid;
    type="myMeeting";
  }else if($("#repeatList")[0]){
    grid = $("#repeatList")[0].grid;
    type="myPlanForReferMe";
  }else{
      grid = $("#taskInfoList")[0].grid;
      type="myTask";
  }
  if(type=="myTask"|| type=="myMeeting" || type=="myPlanForReferMe"){
    if(flag){
      var selectList = grid.getSelectRows();
      var thisData;
      for(var i=0;i<selectList.length;i++){
        var temp = selectList[i];
        updateSelectesList(temp,this.checked,type);
      }
    }else{
      var pageList = grid.getPageRows();
      for(var i=0;i<pageList.length;i++){
          var item = pageList[i];
          if(parent.deleteItem){
              parent.deleteItem(item.id,type);
          }
      }
    }
  }
}

function changeThis(){
	var type;
	var grid;
	if($("#myPlanList")[0]){
		grid = $("#myPlanList")[0].grid;
		type="myPlan";
	}else if ($("#taskInfoList")[0]){
		grid = $("#taskInfoList")[0].grid;
		type="myTask";
	}else if($("#meetingList")[0]){
	  grid = $("#meetingList")[0].grid;
      type="myMeeting";
	}else{
		grid = $("#repeatList")[0].grid;
        type="myPlanForReferMe";
	}
	
	if(this.checked){
		var selectList = grid.getSelectRows();
		var thisData;
		if(this.value=="on"){  //全选
			for(var i=0;i<selectList.length;i++){
				var temp = selectList[i];
				updateSelectesList(temp,this.checked,type);
			}
		}else { //单选
			for(var i=0;i<selectList.length;i++){
				var temp = selectList[i];
				if(temp.id==this.value){
			 		thisData=temp;
			 		updateSelectesList(thisData,this.checked,type);
			 		break;
				}
			}
		}
		
	}else{
		if(this.value=="on"){
			var pageList = grid.getPageRows();
			for(var i=0;i<pageList.length;i++){
				var item = pageList[i];
				if(parent.deleteItem){
				    parent.deleteItem(item.id,type);
				}
			}
		}else{
		    if(parent.deleteItem) {
		        try{
		            parent.deleteItem(this.value,type);
		        } catch(e){  
		        }       
		    }
		}
	}
	
}

function updateSelectesList(item,checked,type){
	var name,creatorId;
	if(type=="myTask"){
		name = item.subject;
		creatorId = item.createUser;
	}else if(type=="myPlanForReferMe"){
		name = item.planTitle;
		creatorId = item.senderId;
	}else{
		name = item.title;
		creatorId = item.createUserId;
	}
	if(parent.refItem) {
    	var newItem = new parent.refItem(item.id,name,type);
    	newItem.sourceCreator = creatorId;
    	if(type=="myTask"){
    	  //任务要加上这几个字段用于回显
        	newItem.plannedStartTime = item.plannedStartTime;//任务开始时间
        	newItem.plannedEndTime = item.plannedEndTime;//任务结束时间
        	newItem.managers =  item.managers;//任务责任人
        	newItem.participators = item.participators;//参与人
        	newItem.inspectors = item.inspectors;//检查人
        	newItem.importantLevel = item.importantLevel;//重要程度
        } else if(type == "myMeeting") {
            newItem.plannedStartTime = item.beginDateStr;//会议开始时间
            newItem.plannedEndTime = item.endDateStr;//会议结束时间
            newItem.managers =  item.createUserId;//会议发起人
        }else if(type == "myPlanForReferMe") {
            newItem.formId=item.formId;
            newItem.id=item.id;
            newItem.masterDataId=item.formmainId;
            newItem.name = item.planTitle+"："+item.discription;//标题+事项描述
            newItem.sourceCreator=item.senderId;
            newItem.sourceid=item.planId;
            newItem.tablename=item.subTableName;
            //newItem.discripname=item.discription;
            newItem.type="myPlan";
        }
    	newItem.name = escapeStringToHTML(newItem.name, true, false);
    	addToList(newItem);
	}
}

function addToList(item){
    if(parent.selectdList.length==0){
        parent.selectdList.push(item);
        parent.addItem2Div(item);
    }else{
        var tempList = parent.selectdList;
        for(var i=0;i<tempList.length;i++){
            var temp = tempList[i];
            if(temp.id==item.id&&temp.name==item.name&&temp.type==item.type){
                    return;
            }
            if(item.type == "myPlan") {
              if(temp.id==item.id && temp.type==item.type){
                return;
              }
            }
        }
        tempList==null;
        parent.selectdList.push(item);
        parent.addItem2Div(item);
    }
}
</script>