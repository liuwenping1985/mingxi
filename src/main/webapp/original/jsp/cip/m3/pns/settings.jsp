<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b">
<head>
  <title>移动M3消息推送服务器设置</title>
  <link rel="stylesheet" type="text/css" href="${path}/apps_res/m3/css/pnsSetting.css"/>
  <style type="text/css">
  	.m3-label {
  		font-size: 12px;
  	}
	
	.set_table_cont{width: 400px;font-size: 14px;color: #333333;}
	.set_table_cont tr{line-height: 35px;}
	.set_table_cont input{height: 30px;line-height: 30px;}
	.set_table_cont input.common_button.common_button_gray{background-color: #5191D1;height: 30px;padding: 0 20px;}

	.set_txt_content *{padding: 0;}

	.set_txt_content{width: 90%;margin: auto;background-color: #f7f7f7;padding:30px;}
	.set_txt_content .set_tel{width: 100%;text-align: center;font-size: 18px;color: #ff0000;font-weight: bold;}
	.set_txt_content .tel_info{font-size: 16px;font-weight: bold;color: #333333;padding-top: 20px;}
	.set_txt_content .txt_in{font-size: 14px;color: #666666;padding-top: 10px;}
	.set_txt_content .txt_in p{margin: 7px 0;}
	.set_txt_content .set_list p{margin: 7px 0;}
	.set_txt_content .set_list.one{ }
	.set_txt_content .set_list .bod{font-size: 14px;color: #333333;font-weight: bold;}


	.set_txt_content .set_box{overflow: hidden;}
	.set_txt_content .set_box .item{float: left;background-color: #fff;font-size: 14px;color: #333333;height: 108px;width: 48%;}
	.set_txt_content .set_box .item div{padding: 0 10px;}
	.set_txt_content .set_box .item p{margin-bottom: 5px;margin-top: 20px;}
	.set_txt_content .set_box .set_box_right{margin-left: 15px;}
	
  </style>
</head>
<body class="h100b">
<div class="comp" comp="type:'breadcrumb',code:'m3_pushConfig'"></div>

<form method="post" action="${path}/m3/pnsMsgSettingController.do?method=savePnsServerSettings" onsubmit="javascript: return isSubmit();">
<%-- <input type="hidden" name="pnsServerType" value="${pnsServerType}"> --%>
<input type="hidden" name="pnsServerNamespase" value="${pnsServerNamespase}">
<input type="hidden" name="pnsServerApiSend" value="${pnsServerApiSend}">
<br/>
	 
	  <table class="set_table_cont" align="center" border="0">
        <colgroup>
            <col width="20%"/>
            <col width="80%"/>
        </colgroup>
        <tbody>
        <tr>
            <td><label class="m3-label"><font color="red">*</font>${ctp:i18n('cip.service.pns.server.connectType')}:</label></td>
            <td><%-- <input type="text" style="width: 99%" name="pnsServerIp" value="${pnsServerIp}"/> --%>
                <select name="pnsServerType" style="width: 99%;">
                    <option value="http" ${pnsServerType == 'http' ? 'selected' : ''}>HTTP(${ctp:i18n('cip.service.pns.server.connectType.general')})</option>
                    <!-- 修改BUG [OA-110735] 屏蔽HTTPS协议-->
                    <option value="https" ${pnsServerType == 'https' ? 'selected' : ''}>HTTPS(${ctp:i18n('cip.service.pns.server.connectType.secure')})</option>
                </select>
            </td>
        </tr>
        <tr>
            <td><label class="m3-label"><font color="red">*</font>${ctp:i18n('cip.service.pns.server.ip')}:</label></td>
            <td><input id="pnsServerIp" type="text" style="width: 99%" name="pnsServerIp" value="${pnsServerIp}"/></td>
        </tr>
        <tr>
            <td><label class="m3-label"><font color="red">*</font>${ctp:i18n('cip.service.pns.server.port')}:</label></td>
            <td><input id="pnsServerPort" type="text" style="width: 99%" name="pnsServerPort" value="${pnsServerPort}"/></td>
        </tr>
        <tr style="display: ${isConnect != true ? 'block' : 'none'}">
            <td colspan="2" style="text-align: center; color:red;">${ctp:i18n('m3.pns.server.not.connect')}</td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center;">
                <input type="submit" value="${ctp:i18n('cip.service.pns.server.save')}" class="common_button common_button_gray"/>
            </td>
        </tr>

        </tbody>
    </table>
    
    <div class="set_txt_content" style="display: ${pnsHttpsAvailable != true ? 'block' : 'none'}">
        <div class="set_tel">
            <font color="red">HTTPS(安全连接)加密算法不可用，请按照下面说明进行修改</font>
        </div>

        <div class="tel_info">消息推送HTTPS协议配置说明</div>
        <div class="txt_in">
            <p>说明：</p>
            <span>因JAVA官方在1.6以后的版本中针对网络请求中的安全协议进行了修改，移除了部分认为不安全的加密算法如：MD2，RSA keySize < 1024等。
                因此，使用HTTPS（安全连接）的时候服务器会对当前服务器的JAVA环境进行检查，检查结果如下：</span>
        </div>
        <div class="set_list one">
            <p><span class="bod">当前使用的Java版本：</span><font color="blue"><b><u>${javaVersion}</u></b></font></p>
            <p><span class="bod">当前使用的Java安装路径：</span><font color="blue"><u>${javaHome}</u></font></p>
            <p><span class="bod">Java安全配置文件路径：</span><font color="blue"><u>${javaSecurityPath}</u></font></p>
            <p><span class="bod">当前Java Https协议加密算法配置：</span><font color="blue"><u>${javaSecurityConfig}</u></font></p>
        </div>
        <div class="txt_in">
            请按照以下方式修改：
        </div>
        <div class="set_list">
            <p class="bod">1)找到Java安装目录</p>
            <p class="bod">2)找到Java安装目录中的安全配置文件java.security</p>
            <p class="bod">3)使用文档编辑工具打开java.security文件，找到jdk.certpath.disabledAlgorithms配置项</p>
            <p class="bod">4)将jdk.certpath.disabledAlgorithms配置中的值改为：MD5, EC keySize &lt; 224</p>
            <p class="bod">5)保存文件，重启OA服务器</p>
        </div>

        <div class="set_box">
            <div class="item set_box_left">
                <div class="">
                    <p>修改前：</p>
                    <span>jdk.certpath.disabledAlgorithms=MD2, MD5, RSA keySize < 1024, \DSA keySize < 1024, EC keySize < 224</span>
                </div>
              </div>
            <div class="item set_box_right">
                <div class="">
                    <p>修改后：</p>
                    <span>jdk.certpath.disabledAlgorithms=MD5, EC keySize < 224</span>
                </div>
            </div>
        </div>

        <div class="txt_in">
            <p>附：</p>
			<span>
			额外提供已修改的配置文件，<a href="${path}/apps_res/m3/res/java.security">点击下载</a>(如不能正常下载请点击鼠标右键另存为)
			并将其拷贝到Java安全配置文件目录覆盖并替换“java.security”文件。拷贝前请先备份原文件。
			</span>
        </div>


    </div>
 
	 
	<br>
</form>
<script type="text/javascript">
	function isSubmit () {
		var pnsServerIp = document.getElementById("pnsServerIp").value;
		var pnsServerPort = document.getElementById("pnsServerPort").value;
		
		var re =  /^([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])$/;
		
		if (pnsServerIp == "" && pnsServerPort == "") {
			return confirm("${ctp:i18n('cip.service.pns.server.null')}")
		}
		
		if(!re.test(pnsServerIp)){
		    alert("${ctp:i18n('cip.service.pns.server.ip.error')}");
		    return false;
		}
		
		if (pnsServerPort == "") {
			alert("${ctp:i18n('cip.service.pns.server.port.null')}");
		    return false;
		}
		// 1-65535
		var port = parseInt(pnsServerPort);
		if (port < 1 || port > 65535) {
			alert("${ctp:i18n('m3.pns.server.port.range')}");
		    return false;
		}
		return confirm("${ctp:i18n('cip.service.pns.server.submit.msg')}");
	}
</script>
</body>
</html>