<!DOCTYPE html>
<html style="height:100%;">
<head>
	<%@ page contentType="text/html; charset=UTF-8"%>
	<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!-- 督办设置 -->
	<title>${ctp:i18n('collaboration.common.flag.showSuperviseSetting')}</title>
	<script>
    var supervisorNamesDefaultValue = '${ctp:i18n("collaboration.common.common.supervise.clickThisSelect")}'; //<点击此处选择人员>
   // var forShow="";
   function parseIds4Panles(){
	   var panlesValue = "";
       var ids = $("#supervisorIds").val().split(',');
       if(ids[0] != ""){
           for(var i = 0;i < ids.length;i++){
               if(i == ids.length -1){
               		panlesValue = panlesValue + 'Member|' + ids[i] ;
               }else {
               		panlesValue = panlesValue + 'Member|' + ids[i] +",";
               }
           }
       }
       return panlesValue;
    }
    $(document).ready(function(){
    	//设置样式(流程表单制作)
    	if("${isTemplate}" == 'true'){
    		$('#title').css('height','140px');
    	}
    	
    //    forShow = $('#forShow').val();
    	//督办人员输入框添加点击事件
        $("#supervisorNames").bind('click',function(){
        	var panlesValue = parseIds4Panles();
       	    $.selectPeople({
    	        type:'selectPeople',
    	        panels:"Department",
    	        selectType:'Member',
    	        text:"${ctp:i18n('common.default.selectPeople.value')}",
    	        maxSize:10,
    	        minSize:0,
    	        onlyLoginAccount: true,
    	        returnValueNeedType: false,
    	        isNeedCheckLevelScope: false,
    	        params:{
    	           value: panlesValue
    	        },
    	        targetWindow:getCtpTop(),
    	        callback : function(res){
    	        	var uncancel = $("#unCancelledVisor").val();
    	        	var uncancelA=[];
    	        	if(uncancel == ""){
						uncancelA=[];
            	    }else{
            	    	uncancelA = uncancel.split(",");
                 	}
    	        	var xuanze  = res.value;
    	        	var xuanzeA = xuanze.split(",");
    	        	var flagCan = true;
					for(var b = 0 ; b < uncancelA.length; b ++){
						flagCan =  in_array(uncancelA[b],xuanzeA);
						if(flagCan == false){
							//模板自带督办人员不允许删除!
                            $.alert("${ctp:i18n('collaboration.newCollaboration.templatePersonnelNoDel')}");
							return;
						}
					}
    	            $("#supervisorNames").val(res.text);
    	            $("#supervisorIds").val(res.value);
    	            //$('#forShow').val(forShow);
    	        }
    	    });
        });
    	var names = $("#supervisorNames");
        if(names.val() == ""){
            names.val(supervisorNamesDefaultValue);
        }
        //IE67设置宽度
        if($.browser.msie && ($.browser.version=='6.0'||$.browser.version=='7.0')){
        	$("#title").css("width","99%");
        }
     });

    /*
    *   判断在数组中是否含有给定的一个变量值
    *   参数：
    *   needle：需要查询的值
    *   haystack：被查询的数组
    *   在haystack中查询needle是否存在，如果找到返回true，否则返回false。
    *   此函数只能对字符和数字有效
    */
    function in_array(needle,haystack){
		for(var i in haystack){
			if(haystack[i] == needle){
				return true;
			}
		}
		return false;
    }

	
    //定义回调函数,以json字符串形式返回
    function OK(){
        //是否模板管理进行督办设置
        var isTemplate=$('#isTemplate').val();
    	//表单验证
		var mId = $.trim($("#supervisorIds").val());
		var number = mId.split(",");
		if(number.length > 10){
		    //最多只允许10个人督办,请重新选择督办人!
            $.alert("${ctp:i18n('collaboration.newColl.alert.select10Supervision')}");
			return false;
		}
		var superviseTitle = $.trim($("#title").val());
		//superviseTitle = superviseTitle.replace(/\r*\n+/g,'');//去换行符号
		//不允许输入特殊字符，因为特殊字符影响到了内容的截取 
		var rule = /^[^\|\\"'<>]*$/;
		if(!(rule.test(superviseTitle))) {
            //督办主题包含特殊字符(\|\"<>')请重新录入!
			$.alert("${ctp:escapeJavascript(ctp:i18n('collaboration.common.common.supervise.specialCharacters'))}");
			return false;
		}
		if(superviseTitle != "" && superviseTitle.length>85){
		    //督办主题长度不能超过200字
            $.alert("${ctp:i18n('collaboration.newColl.alert.supervisionLong85')}");
            return false;
		}
		superviseTitle = escapeStringToHTML(superviseTitle);
		var sDate = $.trim($("#superviseDate").val());
		if(mId != "" && sDate == ""){
		    //请选择督办期限
            $.alert("${ctp:i18n('collaboration.newColl.alert.selectSupervisionPeriod')}");
            return false;
		}
		/**督办角色开始**/
		var haveRole = false;
		var role = "";
		var sender = document.getElementById("sender");
		var senderDepManager = document.getElementById("senderDepManager");
		var roleNames = "";
		if(sender && sender.checked){
			role += "sender,";
			haveRole = true;
			roleNames = "${ctp:i18n('collaboration.common.common.supervise.initiator')}"; //发起者
		}
		if(senderDepManager && senderDepManager.checked){
			role += "senderDepManager,";
			roleNames += (haveRole?"、":"") + "${ctp:i18n('collaboration.common.common.supervise.initiatorManager')}";  //发起者部门主管
			haveRole = true;
		}
		if(haveRole){
			role = role.substring(0,role.length-1);
		}
		/**督办角色结束**/
	    //返回到父页面  1督办人员ID串  2名字显示串  3角色串 4角色名字显示串  5督办日期 6督办主题 
        var supervisorIds = mId;
        var supervisorNames = $("#supervisorNames").val();
        if(supervisorNames == '${ctp:i18n("collaboration.common.common.supervise.clickThisSelect")}'){
        	supervisorNames ="";
        }
        supervisorNames = supervisorNames == supervisorNamesDefaultValue ? "" : escape(supervisorNames);
        //supervisorNames = supervisorNames == supervisorNamesDefaultValue ? "" : escapeStringToHTML(supervisorNames);
        var superviseDate = $("#superviseDate").val();
        var detailId = $('#detailId').val();
        //应用类型(如 协同 为1)
        var superviseType = $('#superviseType').val();
        //应用id
        var entityId = $('#moduleId').val();
        //是否需要在点击确定的时候将数据直接提交保存数据库，还是返回表单值到父页面
        var isSubmit=$('#isSubmit').val(); 
        var returnValue = "";

		if("true" == isSubmit){
		    //如果需要提交时，走该流程，例如已发列表处理页面的督办设置
		    returnValue = "{\"supervisorIds\":\""+supervisorIds+"\",\"supervisorNames\":\""+supervisorNames+"\",\"awakeDate\":\""+superviseDate+"\",\"title\":\""+superviseTitle +
		        "\",\"detailId\":\""+detailId+"\",\"isSubmit\":\""+isSubmit+"\",\"appKey\":\""+superviseType+"\",\"entityId\":\""+entityId+"\"}";
		    return returnValue;
		}else{
			//协同V5.0 OA-40837 处理待办系统模板协同时，第二次执行督办设置时，系统模板自带督办人员未回显 多传回一个forshow
			if(isTemplate && "true" == isTemplate){
				returnValue = "{\"supervisorIds\":\""+supervisorIds+"\",\"supervisorNames\":\""+supervisorNames
		        +"\",\"templateDateTerminal\":\""+superviseDate+"\",\"title\":\""+superviseTitle+"\",\"role\":\""+role+"\",\"roleNames\":\""+roleNames+"\"}";
			}else{
			    returnValue = "{\"supervisorIds\":\""+supervisorIds+"\",\"supervisorNames\":\""+supervisorNames
		        +"\",\"awakeDate\":\""+superviseDate+"\",\"title\":\""+superviseTitle+"\",\"role\":\""+role+"\",\"roleNames\":\""+roleNames+"\"}";
			}
	        return returnValue ;
		}
        
    }
    function getTime(){
        var sDate = $.trim($('#superviseDate').val());
        //获取催办日期，用来比较
        var o_awakeDate = "${awakeDate}";
        //获得当前系统时间
        var nowDate = getCurrentTime();
        if(compareDate(sDate,nowDate)){
            var confirm = $.confirm({
                'msg': '${ctp:i18n("collaboration.common.supervise.thisTimeXYouset")}', //您设置的督办日期小于当前日期,是否继续?
                ok_fn: function () {
                    $('#superviseDate').val(sDate);
                },
                cancel_fn:function(){
                    $('#superviseDate').val(o_awakeDate);
                }
            });
        }
    }
    //比较日期大小
    function compareDate(start,end){
        var startDates = start.substring(0,10).split('-');
        var startYear = startDates[0];
        var startMonth = startDates[1];
        var startDay = startDates[2];
        var startTime = start.substring(10, 19).split(':');
        var startHour = startTime[0];
        var startMin = startTime[1];
        var endDates = end.substring(0,10).split('-');
        var endYear = endDates[0];
        var endMonth = endDates[1];
        var endDay = endDates[2];
        var endTime = end.substring(10, 19).split(':');
        var endHour = endTime[0];
        var endMin = endTime[1];
        var beginTime = new Date(startYear + "/" + startMonth + "/" + startDay + " " + startHour + ":" + startMin);
        var endTime = new Date(endYear + "/" + endMonth + "/" + endDay + " " + endHour + ":" + endMin);
        return beginTime < endTime;
    }
    //获得当前日期时间
    function getCurrentTime(){
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth()+1; 
        if(month < 10) {
            month = '0'+ month;
        }
        var day = date.getDate();
        if(day < 10) {
            day = '0'+ day;
        }
        var hour = date.getHours();
        if(hour < 10) {
            hour = '0'+ hour;
        }
        var min = date.getMinutes();
        if(hour < 10) {
            min = '0'+ min;
        }
        var time = year+"-"+month+"-"+day+" "+hour+":"+min;
        return time;
    }
	</script>
</head>
<body scroll="no" style="overflow: hidden;height:100%;background:#fafafa;">
<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" name="superviseType" id="superviseType" value="${superviseType}">
	<input type="hidden" name="isSubmit" id="isSubmit" value="${isSubmit}">
	<input type="hidden" name="moduleId" id="moduleId" value="${moduleId}">
	<input type="hidden" name="isTemplate" id = "isTemplate" value="${isTemplate}"/>
	
	<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${unCancelledVisor}">
	<input type="hidden" name="detailId" id="detailId" value="${detailId}" />
	<input type="hidden" name="supervisorIds" id="supervisorIds" value="${supervisorsId}" />
	<!-- 用该js文件中的隐藏域 -->
	<table border="0" cellspacing="0" cellpadding="0" class="font_size12" align="center" style="margin:0px 20px;">
	    <tr>
	        <td valign="middle" width="17%" nowrap="nowrap" align="right" class="padding_r_5 padding_t_10">${ctp:i18n('collaboration.common.supervise.supervisionOfStaff')}:</td><!-- 督办人员 -->
	        <td class="padding_t_10">
	        	<div class=common_txtbox_wrap>
	        		<input type="text" id="supervisorNames" <c:if test='${cantSetSupervise}'>disabled</c:if> name="supervisorNames" value="<c:out value='${supervisors}'  escapeXml='true'></c:out>"  readonly="true">
	        	</div>
	        </td>
	    </tr>
	    <c:if test="${isTemplate}">
	    <tr>
	        <td>&nbsp;</td>
	        <td class="padding_t_10">
	        	<div class="common_checkbox_box clearfix ">
                          <label for="sender" class="margin_r_10 hand">
                              <input type="checkbox" class="radio_com" id="sender" name="sender" <c:if test="${sender!='' && sender!=null}" > checked </c:if> >${ctp:i18n('collaboration.common.common.supervise.initiator')}</label>
                          <label for="senderDepManager" class="margin_r_10 hand">
                              <input type="checkbox" class="radio_com" id="senderDepManager" name="senderDepManager" <c:if test="${senderDepManager!='' && senderDepManager!=null}" > checked </c:if>>${ctp:i18n('collaboration.common.common.supervise.initiatorManager')}</label>
                      </div>
	        </td>
	    </tr>
	    </c:if>
	    <tr>
	        <td align="right" nowrap="nowrap" class="padding_r_5 padding_t_10">${ctp:i18n("supervise.col.deadline")}:</td><!-- 督办期限 -->
	        <td class="padding_t_10">
	        <c:choose>
	          <c:when test="${isTemplate}">
	          <select id="superviseDate" name="superviseDate">
	        	<option value="1" <c:if test="${templateDateTerminal == '1'}">selected</c:if> >${ctp:i18n('collaboration.deadline.one.day')}</option><!-- 1天 -->
	        	<option value="2" <c:if test="${templateDateTerminal == '2'}">selected</c:if> >${ctp:i18n('collaboration.deadline.two.day')}</option><!-- 2天 -->
	        	<option value="3" <c:if test="${templateDateTerminal == '3'}">selected</c:if> >${ctp:i18n('collaboration.deadline.three.day')}</option><!-- 3天 -->
	        	<option value="4" <c:if test="${templateDateTerminal == '4'}">selected</c:if> >${ctp:i18n('collaboration.deadline.four.day')}</option><!-- 4天 -->
	        	<option value="5" <c:if test="${templateDateTerminal == '5'}">selected</c:if> >${ctp:i18n('collaboration.deadline.five.day')}</option><!-- 5天 -->
	        	<option value="6" <c:if test="${templateDateTerminal == '6'}">selected</c:if> >${ctp:i18n('collaboration.deadline.six.day')}</option><!-- 6天 -->			        	
	        	<option value="7" <c:if test="${templateDateTerminal == '7'}">selected</c:if> >${ctp:i18n('collaboration.deadline.one.week')}</option><!-- 1周 -->
	        	<option value="14" <c:if test="${templateDateTerminal == '14'}">selected</c:if> >${ctp:i18n('collaboration.deadline.two.week')}</option><!-- 2周 -->
	        	<option value="21" <c:if test="${templateDateTerminal == '21'}">selected</c:if> >${ctp:i18n('collaboration.deadline.three.week')}</option><!-- 3周 -->
	        	<option value="30" <c:if test="${templateDateTerminal == '30'}">selected</c:if> >${ctp:i18n('collaboration.deadline.one.month')}</option><!-- 1个月 -->
	        	<option value="60" <c:if test="${templateDateTerminal == '60'}">selected</c:if> >${ctp:i18n('collaboration.deadline.two.month')}</option><!-- 2个月 -->
	        	<option value="90" <c:if test="${templateDateTerminal == '90'}">selected</c:if> >${ctp:i18n('collaboration.deadline.three.month')}</option><!-- 3个月 -->	        				        	
	          </select>
                    
	          </c:when>
	          <c:otherwise>
	          <div class="common_txtbox_wrap">
	            <input name="superviseDate" id="superviseDate"  <c:if test='${cantSetSupervise}'>disabled</c:if> readonly value="${awakeDate}" class="comp"  type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:getTime">
	          </div>
	          </c:otherwise>
	        </c:choose>
	        </td>
	    </tr>
	    <tr>
	    	<td valign="top" align="right" nowrap="nowrap" class="padding_r_5 padding_t_10">${ctp:i18n('supervise.col.title')}:</td><!-- 督办主题 -->
	    	<td class="padding_t_10">
                <div class="common_txtbox clearfix"><textarea name="title"  <c:if test='${cantSetSupervise}'>disabled</c:if> id="title" style="width:100%;height:180px;">${superviseTitle}</textarea></div>
	    	</td>
	    </tr>  
	</table>
</form>
</body>
</html>