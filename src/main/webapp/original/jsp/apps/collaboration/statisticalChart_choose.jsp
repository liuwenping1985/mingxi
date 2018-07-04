<%--
 $Author:  苗永锋$
 $Rev: 1697 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>选择统计图 </title>
    <style type="text/css">
        .stadic_head_height { height: 30px; }
        .stadic_body_top_bottom { bottom: 30px; top: 30px; }
        .stadic_footer_height { height: 36px; }
    </style>
    <script type="text/javascript">
        $(function(){
        	initChoosedData();
            //候选操作绑定双击事件
            $('#reserve').dblclick(function(){
                move($('#reserve'),$('#selected'));
            });
            //选中操作 绑定双击事件
            $('#selected').dblclick(function(){
                move($('#selected'),$('#reserve'));
            });
            //向左移动 绑定点击事件
            $('#toLeft').click(function(){
                move($('#selected'),$('#reserve'));
            });
            //向右移动 绑定点击事件
            $('#toRight').click(function(){
                move($('#reserve'),$('#selected'));
            });
            //向上移动绑定点击事件
            $('#toUp').click(function(){
                upDown($('#selected'),'up');
            });
            //向下移动绑定点击事件
            $('#toDown').click(function(){
                upDown($('#selected'),'down');
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
        //
        function initChoosedData() {
        	var hasAppEdoc="${ctp:hasPlugin('edoc')}";
        	var values = window.dialogArguments;
        	var selectedArr=[];
        	if(values){
        		selectedArr=values.split(',');
        		//重要程度
        		$("#reserve").append("<option value='importantLevel'>${ctp:i18n('collaboration.statisticalChart.importantLevel.label')}</option>");
	    		//是否超期
        		$("#reserve").append("<option value='overdue'>${ctp:i18n('collaboration.statisticalChart.overdue.label')}</option>");
	    		//办理状态
        		$("#reserve").append("<option value='handlingState'>${ctp:i18n('collaboration.statisticalChart.handlingState.label')}</option>");
        		//办理类型
        		$("#reserve").append("<option value='handleType'>${ctp:i18n('collaboration.statisticalChart.handleType.label')}</option>");
	    		//紧急程度（公文）
	    		if("true"==hasAppEdoc){
	        		$("#reserve").append("<option value='exigency'>${ctp:i18n('collaboration.statisticalChart.exigency.label')}</option>");
	    		}
        	}else{
	    		//重要程度
        		$("#selected").append("<option value='importantLevel'>${ctp:i18n('collaboration.statisticalChart.importantLevel.label')}</option>");
	    		//是否超期
        		$("#selected").append("<option value='overdue'>${ctp:i18n('collaboration.statisticalChart.overdue.label')}</option>");
	    		//办理状态
        		$("#selected").append("<option value='handlingState'>${ctp:i18n('collaboration.statisticalChart.handlingState.label')}</option>");
        		//办理类型
        		$("#selected").append("<option value='handleType'>${ctp:i18n('collaboration.statisticalChart.handleType.label')}</option>");
	    		//紧急程度（公文）
	    		if("true"==hasAppEdoc){
	        		$("#reserve").append("<option value='exigency'>${ctp:i18n('collaboration.statisticalChart.exigency.label')}</option>");
	    		}
        	}
        	for(var i=0;i<selectedArr.length;i++){
        		var optionValue=selectedArr[i];
	        	//办理类型
        		if(optionValue=='handleType'){
	        		$("#selected").append("<option value='handleType'>${ctp:i18n('collaboration.statisticalChart.handleType.label')}</option>");
        			$("#reserve option[value='handleType']").remove();  
        		}
	    		//重要程度
        		if(optionValue=='importantLevel'){
	        		$("#selected").append("<option value='importantLevel'>${ctp:i18n('collaboration.statisticalChart.importantLevel.label')}</option>");
	        		$("#reserve option[value='importantLevel']").remove();
        		}
	    		//是否超期
        		if(optionValue=='overdue'){
	        		$("#selected").append("<option value='overdue'>${ctp:i18n('collaboration.statisticalChart.overdue.label')}</option>");
	        		$("#reserve option[value='overdue']").remove();
        		}
	    		//紧急程度（公文）
        		if(optionValue=='exigency'&&"true"==hasAppEdoc){
	        		$("#selected").append("<option value='exigency'>${ctp:i18n('collaboration.statisticalChart.exigency.label')}</option>");
	        		$("#reserve option[value='exigency']").remove();
        		}
	    		//办理状态
        		if(optionValue=='handlingState'){
	        		$("#selected").append("<option value='handlingState'>${ctp:i18n('collaboration.statisticalChart.handlingState.label')}</option>");
	        		$("#reserve option[value='handlingState']").remove();
        		}
        	}
        }
        
        //上下节点移动,selObj 移动的对象，flag 标志位，up表示向上移动，down表示向下移动
        function upDown(selObj,flag){
            //向上移动
            if('up' === flag){
                var name = "";
                var value = "";
                selObj.find('option').each(function(i){
                    if(this.selected){
                        if(i!==0){
                            //当前选中节点不是第一个的时候，取前一个节点的数据
                            name = $(this).prev().text();
                            value = $(this).prev().val();
                            //去当前选中节点的值，并且与前一个节点的值进行互换
                            $(this).prev().text($(this).text());
                            $(this).prev().val($(this).val());
                            $(this).text(name);
                            $(this).val(value);
                            //将互转后的节点置为选中状态
                            $(this).prev().attr('selected',true);
                            $(this).attr('selected',false);
                            //终止循环
                            return false;
                        }
                    } 
                });
            }else if('down' === flag){
                var name = "";
                var value = "";
                selObj.find('option').each(function(i){
                    if(this.selected){
                        //取下一个节点的值，判断是否是最后一个节点，如果空值，则为最后一个节点
                        name = $(this).next().text();
                        if(name!==""){
                            //当前选中节点不是最后一个的时候，取下一个节点的数据
                            value = $(this).next().val();
                            //取当前选中节点的值，并且与下一个节点的值进行互换
                            $(this).next().text($(this).text());
                            $(this).next().val($(this).val());
                            $(this).text(name);
                            $(this).val(value);
                            //将互转后的节点置为选中状态
                            $(this).next().attr('selected',true);
                            $(this).attr('selected',false);
                            //终止循环
                            return false;
                        }
                    } 
                });
            }
        }
        //定义回调函数，返回节点栏中选中的数据,以json字符串形式返回
        function OK(){
            var objstr = [];
            var allValue = [];
            var resMap = new Properties();
            $('#selected').find('option').each(function(){
                resMap.put($(this).text(),$(this).val());
            });
            var keys = resMap.keys();
            var values=resMap.values();
        	for(var i = 0 ; i < keys.size();i++){
        		allValue[allValue.length] = values.get(i);
        	}
        	if(allValue.length != 0){
        		objstr[0] = allValue;
        	} else {
        		objstr[0] = [];//应对portal-common.js中的统一至少选择一项的提示判断，增加代码
        	}
            return objstr ;
        }
    </script>
</head>
<body class="h100b over_hidden page_color">
    <div class="stadic_layout">
        <div class="stadic_body_top_bottom">
            <table align="center" class="w100b margin_t_5">
                <tr height="28">
                    <td>${ctp:i18n('template.templateChooseM.options')}</td><!-- 可选项 -->
                    <td></td>
                    <td>${ctp:i18n('template.templateChooseM.hasOptions')}</td><!-- 已选项 -->
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <%--候选操作 --%>
                        <select id="reserve" name="reserve" multiple="multiple" class="margin_t_10" 
                            style="width: 160px; height: 230px;">
                            <c:forEach items="${leftList}" var="statisticalChart">
                                <option value="${statisticalChart.key}">${ctp:i18n(statisticalChart.label)}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <em class="ico16 select_selected" id="toRight"></em><br />
                        <em class="ico16 select_unselect" id="toLeft"></em>
                    </td>
                    <td>
                        <%--选中操作 --%>
                        <select id="selected" name="selected" multiple="multiple" class="margin_t_10" 
                            style="width: 160px; height: 230px;">
                            <c:forEach items="${existMetaData}" var="statisticalChart">
                                <option value="${statisticalChart.key}">${ctp:i18n(statisticalChart.label)}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <em class="ico16 sort_up" id="toUp"></em><br />
                        <em class="ico16 sort_down" id="toDown"></em>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
