<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
${v3x:skin()}
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>致信服务配置</title>
<style type="text/css">
.ConfigPage{width:100%;height:auto;overflow:hidden;font-size:12px;margin:25px 0 60px;font-family:"Microsoft YaHei";}
.ConTopArea{width:60em;margin:auto;}
.ConTitle1{color:#414141;font-weight:bold;float:left;font-size:15px;}
.ConTitle2{color:#414141;font-weight:bold;text-indent:2em;margin-bottom:-4px;float:left;font-size:14px;}
.ConContent{width:100%;margin:auto;}
.ConForm1,.ConForm2,.ConForm3,.ConForm4{width:100%;height:auto;overflow:hidden;}
.ConContent dl{width:50%;height:2em;margin:3px 0;line-height:2em;float:left;overflow:hidden;}
.ConContent dl dt{width:16em;height:2em;text-align:right;margin-right:18px;color:#414141;float:left;overflow:hidden;}
.ConContent dl dd{width:12em;height:2em;text-align:left;color:#757575;float:left;overflow:hidden;}
.ConContent dl dd::after{width:10px;height:10px;font-size:0;display:block;clear:both;overflow:hidden;background:red;}
.ConForm2 dl{width:540px;margin-left:180px}
.ConForm2 dl dt{width:8em;margin-right:0;}
.ConForm2 dl dd{width:30em;}
.ConForm3 dl{margin-left:10px;}
.ConFooter{width:100%;height:1.5em;overflow:hidden;position:fixed;bottom:0;left:0;background:#4d4d4d;padding:1em 0 1.3em 0;text-align:center;}
</style>
</head>

<html:link renderURL='/uc/config.do' var="ucconfigurl" />
<script type="text/javascript">
var tiemOutTime = 120000;

	function saveConfig () {
		
		var channelRadio = document.getElementsByName("deploymentChannel");
		var channelStr="local";
		for (i=0; i<channelRadio.length; i++) {
			if (channelRadio[i].checked) {
				channelStr=channelRadio[i].value;
			}
		}
		var datas={"ucDeploymentChannel":channelStr};
		getCtpTop().startProc("正在保存引擎设置");
		 $.ajax({
	            type: "POST" ,
	            url : "${ucconfigurl}?method=saveChannel" ,
	            data: datas ,
	            timeout : tiemOutTime,
	            success : function (json){
	                getCtpTop().endProc();
	                var jso=eval(json);
	                if(jso[0].res == "true"){
	                	window.location.href = "${ucconfigurl}?method=index";
	                }else{
	                    $.alert($.i18n('uc.config.title.saveConfig.no.js'));
	                }
	            },
	            error: function (xmlHttpRequest, error) {
	                getCtpTop().endProc();
	      
	                $.alert($.i18n('uc.config.title.connectionerror.js'));
	                return;
	            }
	        });
	}

	/* end */
</script>
<body>
<div class="comp" comp="type:'breadcrumb',code:'F16_UCcenter'"></div>

<form id="submitform" name="submitform" method="post" target="hiddenIframe">


<TABLE width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" class="">
	<tr id="table_head" class="page2-header-line">
		<td width="100%" height="41" valign="top" class="border_b">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="systemOpenSpace"></div></td>
			        <td class="page2-header-bg">${ctp:i18n('uc.config.title.ucconfig.js')}</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	<td align="center" valign="top" height="100%">
	<div class="scrollList" style="height: 100%">
			<table border="0" width="100%" cellpadding="0" cellspacing="0" >
			<tr>
			<td>
			 <div class="ConfigPage" id="config1">
					<div class="ConTopArea">
						<div class="ConTitle1 mb8">请选择致信服务：</div>
						<div class="ConContent">
							<div class="ConForm2">
								<dl>
									<dt>
										<div class="common_radio_box clearfix">
												<label for="radio1" class="margin_r_10 hand"><input name="deploymentChannel" type="radio" value="local" />本地通讯引擎</label>
										</div>
									</dt>
									<dd>致远自主开发的服务 </dd>
								</dl>
								<dl class="clear">
									<dt>
										<div class="common_radio_box clearfix">
												<label for="radio1" class="margin_r_10 hand"><input name="deploymentChannel" type="radio" value="rong"  checked="checked" />融云通讯引擎</label>
										</div>
									</dt>
									<dd>第三方合作融云服务。</dd>
								</dl>
							</div>
						</div>
						
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="saveConfig();">确&nbsp;&nbsp;&nbsp;定</button>&nbsp;&nbsp;<button type="button" class="button-default-2 button_class" onclick="cancelConfig('1');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>

			 
			
			</td></tr>
			</table>
	 </div>
	</td>
  </tr>

</table>
</form>
<iframe name="hiddenIframe" frameborder="0" height="0" width="0"></iframe>
</body>
</html>