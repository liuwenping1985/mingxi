<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<%@ page import="java.util.*,java.io.File" %>
<%@ page import="com.seeyon.ctp.common.config.manager.*,com.seeyon.ctp.common.filemanager.manager.*" %>
<jsp:useBean id="perfCfg" class="com.seeyon.ctp.monitor.perfmon.PerfLogConfig"/>

<!DOCTYPE html>
<html class="over_hidden h100b">
<head>
    <title></title>
</head>

<body class="over_hidden h100b">

<div class="comp" comp="type:'breadcrumb',code:'T01_earlyWarnin'"></div>

    <fieldset class="margin_5">
        <legend>系统配置预警</legend>
        <div class="form_area align_center relative padding_b_15">
            <table class="only_table  no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
                <thead>
                    <tr>
                        <th width="100">分类 </th>
                        <th>预警描述</th>
                        <th>建议方案</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="erow">
                        <td>系统开关</td>
                        <td>附件加密：${attachEncrypt }</td>
                        <td>${attachEncryptText }</td>
                    </tr>
                    
                    
                      <tr class="erow">
                        <td>系统开关</td>
                        <td>性能跟踪开关：${performanceFlag }</td>
                        <td>${performanceText }</td>
                    </tr>
                                      
                    <tr class="erow">
                        <td>系统开关</td>
                        <td>重建索引设置：${rebuildIndexStatus }
                        ${rebuildIndexText }
                        </td>
                        <td>
                        ${rebuildIndexWarn }
                        </td>
                    </tr>
                    
                </tbody>
            </table>            

        </div>
    </fieldset>

<!--     <fieldset class="margin_5">
        <legend>系统配置预警</legend>
        <div class="form_area align_center relative padding_b_15">
            <table class="only_table  no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
                <thead>
                    <tr>
                        <th width="100">分类 </th>
                        <th>预警描述</th>
                        <th>建议方案</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="erow">
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>            

        </div>
    </fieldset> -->

    <fieldset class="margin_5">
        <legend>容量预警</legend>
        <div class="form_area align_center relative padding_b_15">
            <table class="only_table  no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
                <thead>
                    <tr>
                        <th width="100">分类 </th>
                        <th>预警描述</th>
                        <th>建议方案</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${attmsglist }" var="attmsg">
                    <tr class="erow">
                        <td>${attmsg[0] }</td>
                        <td>${attmsg[1] }</td>
                        <td>${attmsg[2] }</td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>            

        </div>
    </fieldset>
</body>
</html>
