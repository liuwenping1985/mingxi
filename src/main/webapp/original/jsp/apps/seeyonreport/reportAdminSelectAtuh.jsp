<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-06-06
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="over_hidden h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	$(function(){
		//候选操作绑定双击事件
        $('#unselected').dblclick(function(){
            move($('#unselected'),$('#selected'));
        });
        //选中操作 绑定双击事件
        $('#selected').dblclick(function(){
            move($('#selected'),$('#unselected'));
        });
        //向左移动 绑定点击事件
        $('#toLeft').click(function(){
            move($('#selected'),$('#unselected'));
        });
        //向右移动 绑定点击事件
        $('#toRight').click(function(){
            move($('#unselected'),$('#selected'));
        });
	});
	
    //左右两侧节点栏内数据相互移动
    function move(fObj,tObj){
		fObj.find('option').each(function(){
		    if(this.selected){
		  	    //节点 移动
		        tObj.append("<option value='"+$(this).val()+"'>"+$(this).text()+"</option>");
		        //将当前选中节点从左侧删除
		        $(this).remove();
		    }
		});
    }
    
    function OK(){
    	var memberIds = new Array();
    	$('#selected').find('option').each(function(){
    		memberIds.push($(this).val());
		});
    	return memberIds;
    }
</script>

</head>

<body class="h100b over_hidden">
    <div class="margin_tb_10">
           <table align="center" style="table-layout:fixed" class="margin_0">
            	<tr align="center" class="font_size14" height="27px">
            		<!-- 候选报表管理员 -->
            		<td>${ctp:i18n('seeyonreport.report.admin.unselect.label')}</td>
            		<td></td>
            		<!-- 选中报表管理员 -->
            		<td>${ctp:i18n('seeyonreport.report.admin.select.label')}</td>
            	</tr>
                <tr>
                    <td style="width: 180px; height: 250px;" valign="top" class=" border_all bg_color_white">
                    	<div class="over_auto" style="width: 180px; height: 250px;">
                    		<select id="unselected" name="unselected" multiple="multiple"
                            style="width: 180px; height: 250px;">
                            <c:forEach items="${reportAdmin}" var="admin">
                                <option value="${admin.id}">${admin.name}(${admin.loginName})</option>
                            </c:forEach>
                        </select>
                    	</div>
                    </td>
                    <td>
                    	<!-- 添加 -->
                        <em class="ico16 select_selected" id="toRight" title="${ctp:i18n('seeyonreport.report.template.cptfile.add.label')}"></em><br/><br/>
                        <!-- 刪除 -->
                        <em class="ico16 select_unselect" id="toLeft" title="${ctp:i18n('seeyonreport.report.template.cptfile.delete.label')}"></em>
                    </td>
                    <td style="width: 180px; height: 250px;" valign="top" class=" border_all bg_color_white">
                        <select id="selected" name="selected" multiple="multiple"
                            style="width: 180px; height: 250px;">
                            <c:forEach items="${authMember}" var="member">
                                <option value="${member.key}">${member.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    
                </tr>
            </table>
        </div>
</body>
</html>