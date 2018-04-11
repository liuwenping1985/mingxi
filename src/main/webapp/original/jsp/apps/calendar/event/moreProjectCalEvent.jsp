<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
		<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
		<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

		<script type="text/javascript">
		var calContent;
		var queryParams = {"projectId":'${projectId}',"phaseId":'${phaseId}'};
		function rend(txt,data,row,cell){
	    	  if(cell==0){
	    		  txt =  "<a href=\"javascript:void(0);\">" + escapeStringToHTML(data.subject,true) + "</a>";
	    	  }
	    	  return txt; 
	      }
		function openPlanDetail(calId,ptitle,canUpdate){
			var calurl = '${path}/calendar/calEvent.do?method=editCalEvent&flagV3x=objectFlag&appID=14&id='+calId;
			var calDialogTest = v3x.openDialog({
		            id: "calDialog",
		            title: ptitle,
		            url:calurl,
		            width:600,
		            height:550,
		            targetWindow : getA8Top(),
		            buttons:[{
		                id:'sure',
		                emphasize: true,
		                text: "${ctp:i18n('calendar.sure')}",
		                handler:function(){
		                  var rv = calDialogTest.getReturnValue();
		                  if(rv) {
		                     setTimeout(function(){calDialogTest.close();$("#calContent").ajaxgridLoad(queryParams);},500);
		                  }  
		                }
		              },{
		                id:'update',
		                text: "${ctp:i18n('calendar.update')}",
		                handler:function(){
		                  var rv = calDialogTest.getReturnValue();
		                }
		           },{
		              id:'Cancel',
		              text: "${ctp:i18n('calendar.close')}",
		              handler: function(){
		                     calDialogTest.close();
		                 }
		            }]
			  });
			if(canUpdate =="false" || !canUpdate ){
            	parent.parent.document.getElementById("update").style.display = "none";
            }
				parent.parent.document.getElementById("sure").style.display = "none";
				//不知道为啥  iframe没有铺满
				parent.parent.$(".mxt-window-body-iframe").width(600);
				parent.parent.$(".mxt-window-head").height(50);
		}
		$(function(){
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
                	  	$("#calContent").ajaxgridLoad(queryParams);
                   },
                   conditions: [{
                       id: 'title',
                       name: 'title',
                       type: 'input',
                       text: '${ctp:i18n('calendar.project.event.subject')}',
                       value: 'title'
                   }, {
                       id: 'author',
                       name: 'author',
                       type: 'input',
                       text: '${ctp:i18n('calendar.project.event.create.people')}',
                       value: 'author',
                   }, {
                       id: 'date_time',
                       name: 'date_time',
                       type: 'datemulti',
                       text: '${ctp:i18n('calendar.project.event.create.time')}',
                       value: 'date_time',
                       ifFormat : "%Y-%m-%d",
                       validate:true,
                       dateTime : false
                   } ]
               });
				calContent = $("#calContent").ajaxgrid({
					  click : function(data, r, c){
						  openPlanDetail(data.id,escapeStringToHTML(data.subject,true),data.canEdit);
					  },
				      colModel : [{
				        display : '${ctp:i18n('calendar.project.event.subject')}',
				        name : 'subject',
				        width : '58%',
				        cutsize : 23
				      },{
				        display : '${ctp:i18n('calendar.project.event.create.people')}',
				        name : 'createUserName',
				        width : '15%'
				      },{
					        display : '${ctp:i18n('calendar.project.event.create.time')}',
					        name : 'createDate',
					        width : '15%'
				      },{
					        display : '${ctp:i18n('calendar.project.event.state')}',
					        name : 'states',
					        width : '10%',
					        codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'"
					      }],
				      managerName : "calEventManager",
				      managerMethod : "queryProjectCalEventByCondition",
				      parentId: $('.layout_center').eq(0).attr('id'),
				      render:rend
				    });
				$("#calContent").ajaxgridLoad(queryParams);
				
			});
		</script>
	</head>
	<body style="height: 100%; overflow: hidden; padding: 0px; margin: 0px; border: 0px; cursor: default;">
		<div id="layout" class="comp page_color" comp="type:'layout'" >
			<div class="layout_north" layout="height:35,sprit:false,border:false">
               <span style="display: block;margin: 5px auto 5px 10px;">${ctp:i18n('calendar.share.event.project')}</span>
             </div>
            <div class="layout_center page_color over_hidden" id="center">
				<%--计划的内容 --%>
	           <table id="calContent" class="flexme3" style="display: none"></table>
            </div>
		</div>
	</body>
</html>
