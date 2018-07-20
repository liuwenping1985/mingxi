<%--
 $Author: wuym $
 $Rev: 1942 $
 $Date:: 2012-11-06 13:57:41#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>Ajax测试</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=testBS"></script>
<script type="text/javascript" language="javascript">
  
	$().ready(
			function() {
				var callerResponder = new CallerResponder();
				//实例化Spring BS对象
				var tesBS = new testBS();

				$("#btn").click(
						function() {
							/** 异步调用 */
							var ajaxTestBean = new Object();
							ajaxTestBean["str1"] = "111";
							ajaxTestBean["str2"] = ["222", "333"];
							tesBS.testAjaxBean2(ajaxTestBean, {
								success : function(ajaxTestBean){
									alert("ajaxTestBean.str1: " + ajaxTestBean.str1);
									alert("ajaxTestBean.str2[0]: " + ajaxTestBean.str2[0]);
									alert("ajaxTestBean.str2[1]: " + ajaxTestBean.str2[1]);
								}, 
								error : function(request, settings, e){
									alert(e);
								}
							});
							
							/** 同步调用 */
							var ajaxTestBean2 = tesBS.testAjaxBean2(ajaxTestBean);
							alert("ajaxTestBean2.str1: " + ajaxTestBean2.str1);
							alert("ajaxTestBean2.str2[0]: " + ajaxTestBean2.str2[0]);
							alert("ajaxTestBean2.str2[1]: " + ajaxTestBean2.str2[1]);
							
							/* var ajaxTestBean3 = new testBS2().testAjaxBean(ajaxTestBean);
							alert("ajaxTestBean3.str1: " + ajaxTestBean3.str1);
							alert("ajaxTestBean3.str2[0]: " + ajaxTestBean3.str2[0]);
							alert("ajaxTestBean3.str2[1]: " + ajaxTestBean3.str2[1]); */
							
							//AjaxDataLoader
							AjaxDataLoader.load("http://127.0.0.1:8080/ctp_core/ajax.do?managerName=testBS", null, function(str){
								alert(str);
							});
						});
				$("#fillbtn").click(function() {
					//Bean返回值并回填表单
					callerResponder.success = function(jsonObj) {
						$("#form1").fillform(jsonObj);
					};
					tesBS.testAjaxBean(callerResponder);
				});
				$("#ajaxsubmit").click(function() {
					var frmobj = $("#ajaxfrm").formobj();
					alert($.toJSON(frmobj));
					callerResponder.success = function(jsonObj) {
						alert("返回信息：" + jsonObj);
					};
					callerResponder.sendHandler = function(b, d, c) {
						if (confirm('是否提交？')) {
							b.send(d, c);
						}
					}

					//表单局部提交
					tesBS.testAjaxFormSubmit(frmobj, callerResponder);
				});
			});
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <form id="form1">
        <table border=1>
            <tr>
                <td>Ajax测试</td>
                <td><input type="text" id="customerId" value="fivefish" /> <input id="btn" type="button"
                    value="Ajax测试" /></td>
            </tr>
            <tr>
                <td>Ajax表单信息回填</td>
                <td><input name="aac201" id="aac201"> <input name="aaa103" id="aaa103"><input
                    id="fillbtn" type="button" value="Ajax回填" /></td>
            </tr>
            <tr>
                <td>Ajax表单提交</td>
                <td id="ajaxfrm">aac201:<input name="aac201" id="aac201" value="aac201的值" validate="required:true"><br>
                    aaa103:<input name="aaa103" id="aaa103" value="aaa103的值" validate="required:true"><input
                    id="ajaxsubmit" type="button" value="Ajax提交" /></td>
            </tr>
        </table>
    </form>
</body>
</html>
