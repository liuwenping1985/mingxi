<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
		<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
		<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

		<script type="text/javascript">
		var planContent;
		var queryParams = {"projectId":'${projectId}',"phaseId":'${phaseId}'};
		function rend(txt,data,row,cell){
	    	  if(cell==0){
	    		  txt =  "<a href='javascript:openPlanDetail(\""+data.id+"\",\""+escapeStringToHTML(txt,true)+"\",\""+(data.createUserId==${sessionScope['com.seeyon.current_user'].id}?'summary':'reply')+"\")'>"+txt+data.viewTitle+"</a>";
	    	  }
	    	  return txt;
	      }
		function openPlanDetail(planId,ptitle,editType){
			var purl = '${path}/plan/plan.do?method=initPlanDetailFrame&dataSource=project&editType='+editType+'&planId='+planId;
			openCtpWindow({
				"url" : purl
			});
		}
		$(function(){
				planContent = $("#planContent").ajaxgrid({
				      colModel : [{
				        display : '${ctp:i18n('plan.projectplan.title')}',
				        name : 'title',
				        width : '58%'
				      }, {
				        display : '${ctp:i18n('plan.projectplan.create.people')}',
				        name : 'createUserName',
				        width : '15%'
				      }, {
					        display : '${ctp:i18n('plan.projectplan.create.time')}',
					        name : 'createTime',
					        width : '15%'
				      } , {
					        display : '${ctp:i18n('plan.projectplan.state')}',
					        name : 'planStatus',
					        width : '10%',
					        codecfg : "codeType:'java',codeId:'com.seeyon.apps.plan.enums.PlanStatusEnum'"
					      }  ],
				      managerName : "planManager",
				      managerMethod : "queryProjectPlan",
				      parentId: $('.layout_center').eq(0).attr('id'),
				      render:rend
				    });
				$("#planContent").ajaxgridLoad(queryParams);
				//初始化搜索框
				var searchobj = $.searchCondition({
						top:5,
						right:10,
	                   searchHandler: function(){
	                	    var con = searchobj.g.getReturnValue();
	                	    if(con == null){
	                	    	return;
	                	    }
	                	    queryParams = {"projectId":"${projectId}","phaseId":"${phaseId}"};
	                	    if(con.condition != ""){
	                	    	queryParams.condition = con.condition;
	                	    	if(queryParams.condition == "date_time"){
	                	    		queryParams.beginTime = con.value[0];
	                	    		queryParams.endTime = con.value[1];
	                	    	}else{
	                	    		queryParams[con.condition] = con.value;
	                	    	}
	                	    }
	                	  	$("#planContent").ajaxgridLoad(queryParams);
	                   },
	                   conditions: [{
	                       id: 'title',
	                       name: 'title',
	                       type: 'input',
	                       text: '${ctp:i18n('plan.projectplan.title')}',
	                       value: 'title'
	                   }, {
	                       id: 'author',
	                       name: 'author',
	                       type: 'input',
	                       text: '${ctp:i18n('plan.projectplan.create.people')}',
	                       value: 'author',
	                   }, {
	                       id: 'date_time',
	                       name: 'date_time',
	                       type: 'datemulti',
	                       text: '${ctp:i18n('plan.projectplan.create.time')}',
	                       value: 'date_time',
	                       ifFormat : "%Y-%m-%d",
	                       validate:true,
	                       dateTime : false
	                   } ]
	               });
			});
		</script>
	</head>
	<body style="height: 100%; overflow: hidden; padding: 0px; margin: 0px; border: 0px; cursor: default;">
		<div id="layout" class="comp page_color" comp="type:'layout'" >
			<div class="layout_north" layout="height:35,sprit:false,border:false">
               <span style="display: block;margin: 5px auto 5px 10px;">${ctp:i18n('plan.projectplan.sectionname')}</span>
             </div>
            <div class="layout_center page_color over_hidden" id="center">
				<%--计划的内容 --%>
	           <table id="planContent" class="flexme3" style="display: none"></table>
            </div>
		</div>
	</body>
</html>
