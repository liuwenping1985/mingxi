<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-11
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="over_hidden h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>参考设置</title>
</head>

<body class="h100b over_hidden">
	<div class="stadic_layout margin_t_5">
        <div class=" stadic_body_top_bottom">
        	<fieldset class="margin_10" title="主机位置是由填写了以下配置之后自动生成">
				<legend>配置远程服务器</legend>
				<table width="400" height="240"  align="center">
            	<tr>
            		<td width="80" align="right">主机位置：</td>
            		<td>
            			<div class="common_txtbox_wrap">
                    		<input type="text" readonly="readonly" value="http://127.0.0.1:8080/seeyon/ReportServer">
                		</div>
            			
            		</td>
            	</tr>
            	<tr>
            		<td align="right">主机名/IP：</td>
            		<td>
            			<div class="common_txtbox_wrap">
                    		<input type="text" readonly="readonly" value="127.0.0.1"/>
                		</div>
            		</td>
            	</tr>
            	<tr>
            		<td align="right">端口：</td>
            		<td>
            			<div class="common_txtbox_wrap">
                    		<input type="text" readonly="readonly" value="8080"/>
                		</div>
            		</td>
            	</tr>
            	<tr>
            		<td align="right">WEB应用：</td>
            		<td>
            			<div class="common_txtbox_wrap">
                    		<input type="text" readonly="readonly" value="seeyon"/>
                		</div>
            		</td>
            	</tr>
            	<tr>
            		<td align="right">Servlet：</td>
            		<td>
            			<div class="common_txtbox_wrap">
                    		<input type="text" readonly="readonly" value="ReportServer"/>
                		</div>
            		</td>
            	</tr>
            	<tr>
            		<td align="right">用户名：</td>
            		<td>
            			<div class="common_txtbox_wrap">
                    		<input type="text" readonly="readonly" value="admin"/>
                		</div>
            		</td>
            	</tr>
            	<tr>
            		<td align="right">密码：</td>
            		<td>
            			<div class="common_txtbox_wrap">
                    		<input type="text" readonly="readonly" value="123456"/>
                		</div>
            			
            		</td>
            	</tr>
            </table>
    
			</fieldset>
            
        </div>
    </div>
	
    
</body>
</html>