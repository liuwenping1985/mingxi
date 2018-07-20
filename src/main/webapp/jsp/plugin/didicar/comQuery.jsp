<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>滴滴企业用车高级查询</title>
    <head>
    <script type="text/javascript">
        function OK() {
            var o = new Object();
            o.userName = $('#userName').val();
            o.rule = $('#rule').val();
            o.phone = $('#phone').val();
            o.deptName=$('#deptName').val();
            o.createTime=$('#startDate').val()+"|"+$('#endDate').val();
            return o;
        }
       
    </script>
    </head>
    <body class="h100b over_hidden">
        <div class="form_area" id="combinedQueryDIV">
            <form style="height: 100%;" name="addQuery" id="addQuery" method="post" class="align_left">
                <table  style="height: 100%;width:94%;" border="0" cellSpacing="10" cellPadding="10">
                    <tr>
                        <td align="right" nowrap="nowrap" width="3%">${ctp:i18n('didicar.plugin.record.passenger')}：</td>
                        <td width="4%" align="left"><input id="userName"  type="text" name="userName"/></td>
                    </tr>
                    <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n('didicar.plugin.record.rule')}：</td>
                        <td  align="left" >
                            <select id="rule" name="rule" style="width: 50%">
                             <option value=""></option>
                             <option value="201">${ctp:i18n('didicar.plugin.information.mode.201')}</option>
                             <option value="301">${ctp:i18n('didicar.plugin.information.mode.301')}</option>
                            </select>
                        </td>
                    </tr>
                     <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n('didicar.plugin.record.mobile')}：</td>
                        <td align="left"><input id="phone" width="4%" type="text" name="phone"/></td>
                    </tr>
                     <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n('didicar.plugin.record.deptName')}：</td>
                        <td align="left"><input id="deptName" width="4%" type="text" name="deptName"/></td>
                    </tr>
                     <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n('didicar.plugin.record.boardingTime')}：</td>
                        <td align="left" nowrap="nowrap">
                            <input id="startDate"  class="comp" style="width: 45%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" readonly>
                            <span class="padding_lr_5">-</span>
                            <input id="endDate" class="comp"  style="width: 45%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" readonly>
                        </td>
                    </tr>
                     
                </table>
            </form>
        </div>
    </body>
</html>