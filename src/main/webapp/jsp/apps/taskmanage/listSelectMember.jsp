<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2013-03-08 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>选择人员信息</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript">
    function OK(obj) {
        var str = "";
        str = getCheckedBox();
        return str;
    }
    
    /**
     * 获取选中的人员
     */
    function getCheckedBox(){
        var checked = "";
        $("input[name='chk_person_id']:checked").each(function(){ 
            checked = $(this).val();
        });
        return checked;
    }
    
    /**
     * 初始化搜索框
     */
    function initSearchDiv() {
        var searchobj = $.searchCondition({
            top:2,
            right:10,
            searchHandler: function(){
                var returnValue = searchobj.g.getReturnValue();
                if(returnValue.value && returnValue.value.length > 0) {
                    findPerson(returnValue.value);
                } else {
                    findPerson("");
                }
            },
            conditions: [{
                id: 'name',
                name: 'name',
                type: 'input',
                text: '名称',
                value: 'name'
            }]
        });
    }
    
    /**
     * 查询人员信息
     */
    function findPerson(name) {
        var selectId = "${param.memberId}";
        var taskAjax = new taskAjaxManager();
        taskAjax.selectPesonInfo(name, selectId, {
            success : function(ret) {
                $("#person_info").html(ret);
            },
            error : function(request, settings, e) {
                $.error("数据读取失败，服务器报错！");
            }
        });
    }
    
    /**
    * 初始化人员信息
    */
    function initPersonInfo() {
        var name = "";
        findPerson(name);
    }
    
    $(document).ready(function() {
        initSearchDiv();
        initPersonInfo();
    }); 
</script>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:30,sprit:false,border:false">   
        </div>
        <div id="center" class="layout_center bg_color_white over_hidden" layout="border:false">
            <div class="list_content relative h100b">
                <div class=" table_head relative">
                    <table class="only_table edit_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
                        <tbody>
                            <tr>
                                <th width="8%"></th>
                                <th width="40%">名称</th>
                                <th width="52%">部门</th>
                            </tr>
                        </tbody>
                   </table> 
                </div>
                <div class="table_body absolute" id="person_info">
                    <table class="only_table edit_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
                        <tbody>
                            <tr>
                                <td width="8%"></td>
                                <td width="40%"></td>
                                <td width="52%"></td>
                            </tr>
                        </tbody>
                    </table>    
                </div>
            </div>
        </div>
    </div>  
</body>
</html>
