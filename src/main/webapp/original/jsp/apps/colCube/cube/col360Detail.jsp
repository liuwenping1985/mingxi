<%--
 $Author:  xiaol$
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%-- <%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %> --%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>协同立方查询</title>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=collCubeManager"></script>
    <script type="text/javascript">
    	var ext1=$("#news").attr("name");
        $(document).ready(function () {
        $("#news").click(function(){
           		$(this).parent().attr('class','current');
           		$("#notes").parent().removeAttr('class');
           		$("#discuss").parent().removeAttr('class');
           		$("#survey").parent().removeAttr('class');
            	ext1=$(this).attr('name');
            	$("#collShow").attr("src","${path}/colCube/colCube.do?method=coll360Show&user_Id=${user_Id}&dateType=${dateType}&event_type=${event_type}&ext1="+ext1);
            })
            	
           $("#notes").click(function(){
           		$(this).parent().attr('class','current');
           		$("#news").parent().removeAttr('class');
           		$("#discuss").parent().removeAttr('class');
           		$("#survey").parent().removeAttr('class');
            	ext1=$(this).attr('name');
            	$("#collShow").attr("src","${path}/colCube/colCube.do?method=coll360Show&user_Id=${user_Id}&dateType=${dateType}&event_type=${event_type}&ext1="+ext1);
           })
           
           $("#discuss").click(function(){
           		$(this).parent().attr('class','current');
           		$("#notes").parent().removeAttr('class');
           		$("#news").parent().removeAttr('class');
           		$("#survey").parent().removeAttr('class');           		
            	ext1=$(this).attr('name');
				$("#collShow").attr("src","${path}/colCube/colCube.do?method=coll360Show&user_Id=${user_Id}&dateType=${dateType}&event_type=${event_type}&ext1="+ext1);
            })
            	
           $("#survey").click(function(){
           		$(this).parent().attr('class','current');
           		$("#notes").parent().removeAttr('class');
           		$("#discuss").parent().removeAttr('class');
           		$("#news").parent().removeAttr('class');
            	ext1=$(this).attr('name');
            	$("#collShow").attr("src","${path}/colCube/colCube.do?method=coll360Show&user_Id=${user_Id}&dateType=${dateType}&event_type=${event_type}&ext1="+ext1);
           })
            new MxtLayout({
                'id': 'layout',
                'northArea': {
                    'id': 'north',
                    'height': 30,
                    'sprit': false,
                    'border': false
                },
                'centerArea': {
                    'id': 'center',
                    'border': false,
                    'minHeight': 20
                }
            });
        if("${event_type}"=='7'){
        	$("#collShow").attr("src","${path}/colCube/colCube.do?method=coll360Show&user_Id=${user_Id}&dateType=${dateType}&event_type=${event_type}&ext1=newsData");
        }else{
        	$("#collShow").attr("src","${path}/colCube/colCube.do?method=coll360Show&user_Id=${user_Id}&dateType=${dateType}&event_type=${event_type}");
        }
        })
    </script>
</head>
<body style="width:100%;height:100%">
	<c:choose>
	<c:when test="${event_type eq 7}">
	<div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,maxHeight:30,minHeight:30">
             <div id="tabs2_head" class="common_tabs clearfix">
                    <ul class=left>
						<li class=current><a class=no_b_border id='news' name='newsData' href="javascript:void(0)"  tgt="tab1_div"><span>${ctp:i18n('colCube.index.penetrate.news')}</span></a></li>
						<li><a class=no_b_border id='notes' name='bulData' href="javascript:void(0)" tgt="tab2_div" ><span>${ctp:i18n('colCube.index.penetrate.announcement')}</span></a></li>
						<li><a class=no_b_border id='discuss' name='bbs' href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n('colCube.index.penetrate.discuss')}</span></a></li>
						<li><a class=no_b_border id='survey' name='inquiry' href="javascript:void(0)" tgt="tab2_div"><span>${ctp:i18n('colCube.index.penetrate.survey')}</span></a></li>
					</ul>
              </div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
             	<iframe id="collShow" src='' width="100%" height="100%" frameborder="0"  style="overflow-y:hidden"></iframe>
        </div>
    </div>
    </c:when>
    <c:otherwise>
    	<div style="width:100%;height:100%">
    		<iframe id="collShow" width="100%" height="100%" frameborder="0"></iframe>
    	</div>
    </c:otherwise>
    </c:choose>
</body>
</html>
