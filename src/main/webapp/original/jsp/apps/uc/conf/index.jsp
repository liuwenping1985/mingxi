<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
${v3x:skin()}
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>uc配置</title>
<style>
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
#config2 dl{width:48em;}
#config2 dd{width:30em;}
.ConForm4 dl{width:620px;margin-left:100px;}
.ConForm4 dl dd{width:400px;}
.clear{clear:both;}
.redtip{color:red;clear:both;padding-top:30px;}
.mb8{margin-bottom:8px;}
.mb40{margin-bottom:40px;}
.halfwidth{width:50%;}
.normalweight{font-weight:normal;}
.ConFooter{width:100%;height:1.5em;overflow:hidden;position:fixed;bottom:0;left:0;background:#4d4d4d;padding:1em 0 1.3em 0;text-align:center;}
#ConContentD input{border:0px;background-color:transparent}
#ConContent1 input{border:0px;background-color:transparent}
#ConContent2 input{border:0px;background-color:transparent}
#ConContent3 input{border:0px;background-color:transparent}
#ConContent4 input{border:0px;background-color:transparent}
#ConContent6 input{border:0px;background-color:transparent}
#ConContentTop input{border:0px;background-color:transparent}
#ConContentTemp2 input{border:0px;background-color:transparent}
#ConContentD select{border:0px;background-color:transparent;overflow: hidden;}
.ConTitle0{color:#414141;font-weight:bold;float:center;font-size:15px;}
.ConTitle3{color:#414141;font-weight:bold;text-indent:2em;margin-top:15px;margin-bottom:-5px;float:left;font-size:14px;clear:both}
#ConContentD{padding-bottom:15px}
.SomeClass{background-color:transparent}
.DivSelect
{
     position: relative;
     background-color: transparent;
     width:  130px;
     height: 17px;
     overflow: hidden;
     border-width:0px;
     border-top-style: none;
     border-right-style: none;
     border-left-style: none;
     border-bottom-style: none;
}
 .SelectList
{
     position: relative;
     background-color: transparent;
     TOP:   0px;
     left:-2px;
     border-width: 0px;
     border-top-style: none;
     border-right-style: none;
     border-left-style: none;
     border-bottom-style: none;
     width:160px;
     display:block;
     height: 18px;
     overflow:hidden;
}

#config0{margin-left:2em;}
#config0 .ConTopArea{width:70em;margin:auto;}
#config0 .ConForm1{width:100%;height:auto;overflow:hidden;}
#config0 dl{height:2.2em;line-height: 1.8em;}
#config0 dl dt{height:2.2em;}
#config0 dl dd{height:2.2em;width:17em;color:#aaa;}
input.button-default-2, input.button-default_emphasize {
    min-width: 44px;
}
</style>
</head>
<html:link renderURL='/uc/s2s.do' var="s2sUrl" />
<html:link renderURL='/uc/config.do' var="ucconfigurl" />
<script type="text/javascript">
	var version = '12';
	var tiemOutTime = 120000;
	var chcheBean = null;
	var portMap = new Properties();
	var startorstop = "";
	var stopQqueryState = false;
	var isshowOptionPageFlag = false;
	var stopQueryStateTime = 120000;
	var queryStateTime = 10000;
	var synDile = null;
	var ucStus = '';
	function showOptionPage(){
		if(!isshowOptionPageFlag) {
			$('#optPage').show();
			$('#optPage1').show();
			isshowOptionPageFlag = true;
		} else {
			$('#optPage').hide();
			$('#optPage1').hide();
			isshowOptionPageFlag = false;
		}

	}
	//修改通道引擎
	function setChannel(){
		window.location.href = "${ucconfigurl}?method=setChannel";
	}
	function stopQueryState() {
		stopQqueryState = true;
	}

	function starten() {
		stopQqueryState = false;
		startorstop = "start";
		getCtpTop().startProc($.i18n('uc.config.title.starting.js'));
		var url = '${ucconfigurl}?method=start';
		var datas={type:1};
		$.ajax({
			type: "POST" ,
			url : url ,
			data: datas ,
			timeout : tiemOutTime,
			success : function (json) {
	              var jso=eval(json);
	              if(jso[0].res == '320' || jso[0].res == '500') {
		  				disabelInput();
						getCtpTop().endProc();
		                $.alert($.i18n('uc.config.title.connectionerror.js'));
	              } else {
	            	 	setTimeout("ajaxServerStatus()", queryStateTime);
	            	  	setTimeout("stopQueryState()", stopQueryStateTime);
	              }
			},
			error : function (json) {
				disabelInput();
				getCtpTop().endProc();
                $.alert($.i18n('uc.config.title.connectionerror.js'));
			}
		});
	}
	function stopen() {
		if(!confirm("确认要停止吗？")){
			return;
		}
     	stopQqueryState = false;
		startorstop = "stop";
		getCtpTop().startProc($.i18n('uc.config.title.stoping.js'));
		var url = '${ucconfigurl}?method=stop';
		var datas={type:1};
		$.ajax({
			type: "POST" ,
			url : url ,
			data: datas ,
			timeout : tiemOutTime,
			success : function (json) {
	              var jso=eval(json);
	              if(jso[0].res != '500' && jso[0].res != '320') {
	            	  setTimeout("ajaxServerStatus()", queryStateTime);
	            	  setTimeout("stopQueryState()", stopQueryStateTime);
	              } else {
		  				disabelInput();
						getCtpTop().endProc();
		                $.alert($.i18n('uc.config.title.connectionerror.js'));
	              }
			},
			error : function (json) {
				disabelInput();
				getCtpTop().endProc();
                $.alert($.i18n('uc.config.title.connectionerror.js'));
			}
		});
	}

	function ajaxServerStatus(){
		var url = '${ucconfigurl}?method=status';
		var datas={type:1};
		$.ajax({
			type: "POST" ,
			url : url ,
			data: datas ,
			timeout : tiemOutTime,
			success : function (json){
				var jso=eval(json);
	            var result = jso[0].res;
	            if(startorstop == "stop"){
	            	if(result == '3'){
	            		ucStus = '3';
	            		getCtpTop().endProc();
	            	  	$('#stateValue').text($.i18n('uc.config.title.ucstop.js'));
	            	  	var buthtml ="<input type='button' id='startOrStop' class='button-default-2' onclick='starten()' value='"+$.i18n('uc.config.title.start.js')+"'/>";
	            	  	$('#but').html(buthtml);
	            	}else{
	            		if(stopQqueryState){
	            			getCtpTop().endProc();
	            			$.alert($.i18n('uc.config.title.stopingerror.js'));
	                	  	$('#stateValue').text($.i18n('uc.config.title.ucrun.js'));
	            		}else{
	            			setTimeout("ajaxServerStatus()",queryStateTime);
	            		}
	            	}
	            }else{
	            	 if(result == '0'){
	            	 	ucStus = '0';
	            		setTimeout("getCtpTop().endProc()",5000);
	            	  	$('#stateValue').text($.i18n('uc.config.title.ucrun.js'));
	            	  	var buthtml ="<input type='button' id='startOrStop' class='button-default-2' onclick='stopen()' value='"+$.i18n('uc.config.title.stop.js')+"'/>";
	            	  	$('#but').html(buthtml);
	            	}else {
	            		if(stopQqueryState){
	            			getCtpTop().endProc();
	            			$.alert($.i18n('uc.config.title.startingerror.js'));
	                	  	$('#stateValue').text($.i18n('uc.config.title.ucstop.js'));
	            		}else{
	            			setTimeout("ajaxServerStatus()",queryStateTime);
	            		}
	            	}
	            }
			},
			error: function (xmlHttpRequest, error) {
				   disabelInput();
				   getCtpTop().endProc();
                $.alert($.i18n('uc.config.title.connectionerror.js'));
             }
		});
	}


	function checkA8optOrUcopt(){
		var opt = document.getElementsByName('optionModel');
		for (var i = 0 ; i < opt.length ; i ++) {
			if(opt[i].checked){
				if(opt[i].value == '1'){
					$('#ucOPt').hide();
				}else{
					$('#ucOPt').show();
				}
			}
		}
	}

	function checkMAX(value) {
		if (/^\d+$/.test(value) && parseInt(value,10) < 65535 && parseInt(value,10) > 0) {
			return true;
		} else {
			return false;
		}
	}

	function checkFileMAX(value){
		if (/^\d+$/.test(value) && parseInt(value) < 500) {
			return true;
		} else {
			return false;
		}
	}
	function checkNull(checkString){
		if(checkString == null || checkString == ''){
			getCtpTop().endProc();
			return false;
		}else{
			return true;
		}
	}
	/*
	*点击修改按钮，将所有输入框置为可编辑状态
	*/
	function showUpate(){
		document.getElementById('clane').removeAttribute('style');
		document.getElementById('clane').removeAttribute('disabled');
		var strHtml ="<input type='button' id='commButton' class='button-default-2' onclick='javaScript:saveConfigByConfirm()' value='"+$.i18n('uc.config.title.saveseting.js')+"'/>";
		$('#buttons').html(strHtml);
		 document.getElementById('ucServerIp').removeAttribute('disabled');
		 var inputs = document.getElementsByTagName("input");
	     for (var i = 1; i < inputs.length ; i++) {
	    	 var item = inputs[i];
	    	 if (item.type != 'button') {
		    	 item.disabled = '';
	    	 }
	     }
	     var selects = document.getElementsByTagName("select");
	     for (var j = 0 ; j < selects.length ; j ++) {
	    	 var item = selects[j];
	    	 item.removeAttribute('disabled');
	     }
	}

	var commonProgressbar = null;
	function startProc(title){
	    try {
	        var options = {
	            text: title
	        };
	        if (title == undefined) {
	            options = {};
	        }
	        if (commonProgressbar != null) {
	            commonProgressbar.start();
	        } else {
	            commonProgressbar = new MxtProgressBar(options);
	        }
	    } catch (e) {
	    }
	}
	//结束进度条
	function endProc(){
	    try {
	        if (commonProgressbar) {
	            commonProgressbar.close();
	        }
	        commonProgressbar = null;
	    } catch (e) {
	    }
	}
	var pathSize = '';
	//ajax检测文件路径是否合法
	function ajaxcheckFilePath(){
		getCtpTop().startProc($.i18n('uc.config.title.checkingpath.js'));
		//检测...
		var fileSavePath = document.getElementById('ucFileSavePath').value;
		pathSize = '';
        var url = '${ucconfigurl}?method=ajaxCheckFilePath';
        var datas={'path':fileSavePath};
        $.ajax({
            type: "POST" ,
            url : url ,
            data: datas ,
            timeout : tiemOutTime,
            async : true,
            success : function (json){
                var jso=eval(json);
                if (jso[0].res == '' || jso[0].res == 'error') {
                    disabelInput();
                    getCtpTop().endProc();
                    $.alert($.i18n('uc.config.title.connectionerror.js'));
                    return ;
                }
                pathSize = jso[0].res;
                if (pathSize == '' || pathSize == '0') {
                    $.alert($.i18n('uc.config.title.pathnotfound.js'));
                    getCtpTop().endProc();
                    return ;
                } else {
                    if (pathSize != ''){
                        var size = parseInt(pathSize);
                        if (size <= 1024) {
                            var random = $.messageBox({
                                'type': 3,
                                'msg': $.i18n('uc.config.title.path1.js'),
                                'imgType': 3,
                                'yes_fn' : function () {
                                	getCtpTop().endProc();
                                },
                                'no_fn' : function () {
                                	getCtpTop().endProc();
                                	nextPage(8);
                                },
                                'close_fn' : function () {
                                	getCtpTop().endProc();
                                	nextPage(8);
                                }
                            });
                        } else {
                            getCtpTop().endProc();
                            var showSize = parseInt(size/1024);
                            $.alert($.i18n('uc.config.title.pathsize.js') + showSize + 'G');
                            nextPage(8);
                            return;
                        }
                    }
                }
            },
            error: function (xmlHttpRequest, error) {
               disabelInput();
               getCtpTop().endProc();
               $.alert($.i18n('uc.config.title.connectionerror.js'));
            }
        });
	}




	/*
	* 取消设置将页面所有输入框设置为不可编辑状态
	*/
	function cancelConfig (flag){
		var confirm = $.confirm({
			'title':$.i18n('uc.config.title.message.js'),
	        'msg':$.i18n('uc.config.cancletitle.js'),
	         ok_fn: function () {
	         	var strHtml ="<input type='button' id='commButton' class='button-default-2' onclick='javaScript:showUpate()' value='"+$.i18n('uc.config.title.updateseting.js')+"'/>";
					$('#buttons').html(strHtml);
					var inputs = document.getElementsByTagName("input");
			    	 $('#ucServerIp').attr('disabled','disabled');
			     	for (var i = 1; i < inputs.length ; i++) {
			    	 	var item = inputs[i];
			    	 	if (item.type != 'button') {
				    	 	item.disabled = 'disabled';
			    	 	}
			     	}
			     	var selects = document.getElementsByTagName("select");
			     	for (var j = 0 ; j < selects.length ; j ++) {
			    	 	var item = selects[j];
			    	 	item.disabled = 'disabled';
					}
			     	//保存致信服务器的原始ip地址到A8的数据库
					returnSaveA8();
			     	var oldHref = window.location.href;
					window.location.href = oldHref;
					/* if (chcheBean != null) {
					//setValueByQuery(chcheBean);
					} */
	         }
	    });
	}

	function disabelInput (){
		 $("input[type=button]").each(function(){
			 $(this).attr('disabled','disabled');
		 })
		 $('#ucServerIp').attr('disabled','disabled');
		   var inputs = document.getElementsByTagName("input");
		     for (var i = 1; i < inputs.length ; i++) {
		    	 var item = inputs[i];
				 if (item.id != 'requery') {
					 item.disabled = 'disabled';
				 }
		     }
		     var selects = document.getElementsByTagName("select");
		     for (var j = 0 ; j < selects.length ; j ++) {
		    	 var item = selects[j];
		    	 item.disabled = 'disabled';
		     }
	}

	function ucsyn(){
		getCtpTop().startProc();
		var confirm = $.confirm({
			'title':$.i18n('uc.config.title.message.js'),
	    	'msg':$.i18n('uc.config.syntitle.js'),
	       	ok_fn: function () {
	       		var url = '${ucconfigurl}?method=status';
				var datas={type:1};
				$.ajax({
					type: "POST" ,
					url : url ,
					data: datas ,
					timeout : tiemOutTime,
					success : function (json){
						getCtpTop().endProc();
						var jso = eval(json);
						if (jso[0].res == '0') {
							$('#stateValue').text($.i18n('uc.config.title.ucrun.js'));
							var buthtml ="<input type='button' id='startOrStop' class='button-default-2' onclick='stopen()' value='"+$.i18n('uc.config.title.stop.js')+"'/>";
		            	  	$('#but').html(buthtml);
						}
						if (jso[0].res == '3') {
							$('#stateValue').text($.i18n('uc.config.title.ucstop.js'));
							var buthtml ="<input type='button' id='startOrStop' class='button-default-2' onclick='starten()' value='"+$.i18n('uc.config.title.start.js')+"'/>";
			            	$('#but').html(buthtml);
						}
						if (jso[0].res == '320') {
							 disabelInput();
			                 $.alert($.i18n('uc.config.title.connectionerror.js'));
			                 return ;
						}
						if (jso[0].res == '500') {
							 disabelInput();
			                 $.alert($.i18n('uc.config.title.connectionerror.js'));
			                 return ;
						}
						if (jso[0].res == '0') {
							 synDile = $.dialog({
							 	id : "sysDile",
								htmlId : "synHtml",
								title : "致信同步",
								url :"${pageContext.request.contextPath}/uc/s2s.do?method=synchronous",
								height:300,
								width:1000,
								targetWindow:top,
								transParams:"querySynTime",
								closeParam:{
									'show':true,
									'autoClose':false,
									 handler:function(isClose){
										 synDile.getClose("");
										 querySynTime();
										 synDile.close();
									}
								}
							});
						} else {
							$.alert($.i18n('uc.config.title.servernotstart.js'));
							return ;
						}
					},
					 error: function (xmlHttpRequest, error) {
						   disabelInput();
						   getCtpTop().endProc();
		                 $.alert($.i18n('uc.config.title.connectionerror.js'));
		             }
				});
	       	},
	       	cancel_fn:function (){
	       	 	getCtpTop().endProc();
	       	},
	       	close_fn:function (){
	       	 	getCtpTop().endProc();
	       	}
	    });
	}

	function checkPrt (checkPort){
		if (portMap.get(checkPort) == '1') {
			$.alert($.i18n('uc.config.protistrue.js',checkPort));
			return false;
		} else {
			portMap.put(checkPort,'1');
			return true;
		}
	}

	function isShowIpAndPort(obj){
		if (obj.checked) {
			$('#m1ServerIp').removeAttr('disabled');
	     	$('#m1MessagePort').removeAttr('disabled');
	    } else {
	    	$('#m1ServerIp').attr('disabled','disabled');
	     	$('#m1MessagePort').attr('disabled','disabled');
	    }
	}

	function querySynTime() {
		$.ajax({
            type: "POST" ,
            url : "${ucconfigurl}?method=querySynTime" ,
            timeout : tiemOutTime,
            success : function (json) {
                  var jso=eval(json);
                  if (jso[0].synTime != '') {
                	  $('#synTime').text(jso[0].synTime);
                	  $('#synTime').attr("title",jso[0].synTime);
                  } else {
                	  $('#synTime').text($.i18n('uc.config.nosyn.js'));
                	  $('#synTime').attr("title",$.i18n('uc.config.nosyn.js'));
                  }
            }
        });
	}
	/*测试获取同步时间*/
	function connectTest() {
		$.ajax({
            type: "POST" ,
            url : "${ucconfigurl}?method=connectS2STest" ,
            timeout : tiemOutTime,
            success : function (json) {
                  var jso=eval(json);
                  if (jso[0].synTime != '') {
                	  $("#ucTrafficStatus").val("S2S最后一次同步时间："+jso[0].synTime+" ,测试时间为："+jso[0].testTime);

                  } else {
                	  $("#ucTrafficStatus").val("通讯失败!");

                  }
            }
        });
	}
/* start */
function queryConfiy1(){
	getCtpTop().startProc("加载配置");
	$.ajax({
		   type: "POST",
		   url: "${ucconfigurl}?method=queryConfig",
		   timeout : tiemOutTime,
		   success: function(msg){
		    var jso = eval(msg);
			var bean = jso[0].res;
			var jsonbean = $.parseJSON(bean);
			chcheBean = jsonbean;
			//判断是否连接正常
			if(jsonbean.isReadingConfig == '0'){
				$.alert("服务器连接异常");
			}
			if (jsonbean.s2sIsRuning == "0") {
				$.alert("协同服务器S2S端口工作不正常(建议修改A8 S2S端口，重启A8后再试)，原因可能为：<br/> 1.A8S2S端口被其他程序占用!<br/>2.webapps下存在两个seeyon目录或者存在seeyon备份文件!");
			}
			setValueByQuery1(jsonbean);
			getCtpTop().endProc();
		   }
	});
}

function setValueByQuery1(jsonbean){
	$("#syn").removeAttr("disabled");
	$('#config9').hide();
	if (jsonbean.synTime != '' && jsonbean.synTime != null && jsonbean.synTime != 'null') {
		$('#synTime').text(jsonbean.synTime);
    	$('#synTime').attr("title",jsonbean.synTime);
	} else {
		$('#synTime').text($.i18n('uc.config.nosyn.js'));
    	$('#synTime').attr("title",$.i18n('uc.config.nosyn.js'));
	}
	if  (ucStus != '') {
		jsonbean.ucRuningState = ucStus;
	}
	if (jsonbean.ucRuningState == '3') {
		$('#stateValue').text($.i18n('uc.config.title.ucstop.js'));
		var buthtml ="<input type='button' id='startOrStop' class='button-default-2' onclick='starten()' value='"+$.i18n('uc.config.title.start.js')+"'/>";
	  	$('#but').html(buthtml);
	} else if (jsonbean.ucRuningState == '320') {
		$.alert($.i18n('uc.config.notquerystate.js'));
		$('#stateValue').text($.i18n('uc.config.title.queryStateerror.js'));
	   var buthtml ="<input type='button' id='startOrStop' disabled='disabled' class='button-default-2' onclick='stopen()' value='"+$.i18n('uc.config.title.stop.js')+"'/>";
	   $('#but').html(buthtml);
	   $("#syn").attr("disabled",true);
	} else if (jsonbean.ucRuningState == '500') {
		$.alert($.i18n('uc.config.querystateerror.js'));
		$('#stateValue').text($.i18n('uc.config.title.queryStateerror.js'));
	   var buthtml ="<input type='button' id='startOrStop' disabled='disabled' class='button-default-2' onclick='stopen()' value='"+$.i18n('uc.config.title.stop.js')+"'/>";
	   $('#but').html(buthtml);
	   $("#syn").attr("disabled",true);
	} else if (jsonbean.ucRuningState == '0') {
		$('#stateValue').text($.i18n('uc.config.title.ucrun.js'));
		var buthtml ="<input type='button' id='startOrStop' class='button-default-2' onclick='stopen()' value='"+$.i18n('uc.config.title.stop.js')+"'/>";
	  	$('#but').html(buthtml);
	} else {
		$('#stateValue').text($.i18n('uc.config.title.queryStateerror.js'));
		var buthtml ="<input type='button' id='startOrStop' class='button-default-2' onclick='stopen()' value='"+$.i18n('uc.config.title.stop.js')+"'/>";
	  	$('#but').html(buthtml);
	  	$("#syn").attr("disabled",true);
	}

	//首页数据展示的值
    /* $("input[name='deploymentModeI'][value='"+jsonbean.deploymentMode+"']").attr("checked",true); */
    if(jsonbean.deploymentMode == '0'){//0是集成，1是分离
        $("#deploymentModeI").val("集成");
    }else{
        $("#deploymentModeI").val("分离");
    }
    $("#seeyonnServerIpI").val(jsonbean.a8ServerIp);//a8 s2s ip
    $("#seeyonnServerPortI").val(jsonbean.a8S2sPort);//a8 s2s port
    $("#ucServerIpI").val(jsonbean.ucS2SIp);//uc s2s ip
    $("#ucServerPortI").val(jsonbean.ucS2sPort);//uc s2s port
    $("#ucServerLanIpI").val(jsonbean.szUCInIp);// uc内网ip
    $("#ucServerInternetIpI").val(jsonbean.szUCOuterIP);//uc外网ip
    $("#ucC2sPortI").val(jsonbean.ucC2sPort);//uc 客户端口
    $("#ucFileTransferPortI").val(jsonbean.ucFileTransferPort);//文件传输端口
    $("#ucWebPortI").val(jsonbean.ucWebPort);// web连接端口
    $("#ucFileSSLEncI").val(jsonbean.ucFileSSLEnc);//文件加密
    $("#ucFileSavePathI").val(jsonbean.ucFileSavePath);//文件保存路径

    var showFileEncryptGrade = $.i18n("uc.config.title.notencrypted.js");
    if (jsonbean.ucFileEncryptGrade == "low") {
    	showFileEncryptGrade = $.i18n("uc.config.title.moderateencryption.js");
    } else if (jsonbean.ucFileEncryptGrade == "high") {
    	showFileEncryptGrade = $.i18n("uc.config.title.depthencryption.js");
    }
    $("#ucFileEncryptGradeI").val(showFileEncryptGrade);//文件存储加密方式
    var showFileOut = $.i18n("uc.config.title.30days.js");
    if (jsonbean.ucFileOutTime == "60") {
    	showFileOut = $.i18n("uc.config.title.60days.js");
    } else if (jsonbean.ucFileOutTime == "90") {
    	showFileOut = $.i18n("uc.config.title.90days.js");
    } else if (jsonbean.ucFileOutTime == "182") {
    	showFileOut = $.i18n("uc.config.title.182days.js");
    } else if (jsonbean.ucFileOutTime == "365") {
    	showFileOut = $.i18n("uc.config.title.365days.js");
    } else if (jsonbean.ucFileOutTime == "0") {
    	showFileOut = $.i18n("uc.config.title.0days.js");
    }
    $("#ucFileOutTimeI").val(showFileOut);

    var showGroupOut = $.i18n("uc.config.title.30days.js");
    if (jsonbean.ncGroupOutTime == "60") {
        showGroupOut = $.i18n("uc.config.title.60days.js");
    } else if (jsonbean.ncGroupOutTime == "90") {
        showGroupOut = $.i18n("uc.config.title.90days.js");
    } else if (jsonbean.ncGroupOutTime == "182") {
        showGroupOut = $.i18n("uc.config.title.182days.js");
    } else if (jsonbean.ncGroupOutTime == "365") {
        showGroupOut = $.i18n("uc.config.title.365days.js");
    } else if (jsonbean.ncGroupOutTime == "0") {
        showGroupOut = $.i18n("uc.config.title.0days.js");
    }

    //群自动解散时间
    $("#ucGroupOutTimeI").val(showGroupOut);
    $("#a8ServerLanIpI").val(jsonbean.szInA8HttpIP);
    $("#a8ServerInternetIpI").val(jsonbean.szOutA8HttpIP);
    //A8内网访问方式
    if (jsonbean.szInA8HttpIP != "" && jsonbean.szInA8HttpIP != null && jsonbean.szInA8HttpIP.indexOf("https") > -1) {
        $("input[name='a8ServerLanStyle'][value='1']").attr("checked",true);
    } else {
        $("input[name='a8ServerLanStyle'][value='0']").attr("checked",true);
    }
    if (jsonbean.szOutA8HttpIP != "" && jsonbean.szOutA8HttpIP != null && jsonbean.szOutA8HttpIP.indexOf("https") > -1) {
        $("input[name='a8ServerInternetStyle'][value='1']").attr("checked",true);
    } else {
        $("input[name='a8ServerInternetStyle'][value='0']").attr("checked",true);
    }
    if (jsonbean.a8WebPort == null || jsonbean.a8WebPort == "" || jsonbean.a8WebPort == "null") {
        jsonbean.a8WebPort = "";
    }
    var inA8Port = getPortByUrl(jsonbean.szInA8HttpIP);
    var outA8Port = getPortByUrl(jsonbean.szOutA8HttpIP);
    if (inA8Port == "") {
    	inA8Port = jsonbean.a8WebPort;
    }
    if (outA8Port == "") {
    	outA8Port = jsonbean.a8WebPort;
    }
    //A8 内外网端口号
    $("#a8ServerInternetPort").val(outA8Port);
    $("#a8ServerLanPort").val(inA8Port);
    jsonbean.szInA8HttpIP = subUrl(jsonbean.szInA8HttpIP);
    jsonbean.szOutA8HttpIP = subUrl(jsonbean.szOutA8HttpIP);
    $("#a8WebPortV").val(jsonbean.a8WebPort);//保存下从后台取出的tomcat端口号
    //初始化下一步的值
    $("input[name='deploymentMode'][value='"+jsonbean.deploymentMode+"']").attr("checked",true);
    $("input[name='clientVisit'][value='"+jsonbean.nClientLinkStype+"']").attr("checked",true);
    if (jsonbean.nClientLinkStype == "1") {
    	$("#loginzx").html("客户端仅通过内网地址或VPN登录致信服务器");
    	$("#ucLan").show();
    	$("#ucOuter").hide();
    } else if (jsonbean.nClientLinkStype == "2") {
    	$("#loginzx").html("客户端仅通过外网地址登录致信服务器");
        $("#ucLan").hide();
        $("#ucOuter").attr("style","");
        $("#ucOuter").show();
    } else {
    	$("#loginzx").html("客户端可以通过内网地址或外网地址登录致信服务器");
        $("#ucLan").show();
        $("#ucOuter").attr("style","margin-left:-5em;");
        $("#ucOuter").show();
    }

    $("input[name='szClientPwdTest'][value='"+jsonbean.szClientPwdTest+"']").attr("checked",true);
    if (jsonbean.szClientPwdTest == "1") {
        $("#szClientPwdTestI").val("致信服务器验证");
    } else {
    	$("#szClientPwdTestI").val("协同服务器验证");
    }
    $("#seeyonnServerIp").val(jsonbean.a8ServerIp);
    $("#seeyonnServerPort").val(jsonbean.a8S2sPort);
    $("#ucServerIp").val(jsonbean.ucS2SIp);
    $("#ucServerPort").val(jsonbean.ucS2sPort);
    $("#ucServerLanIp").val(jsonbean.szUCInIp);
    $("#ucServerInternetIp").val(jsonbean.szUCOuterIP);
    $("#ucC2sPort").val(jsonbean.ucC2sPort);
    $("#ucFileTransferPort").val(jsonbean.ucFileTransferPort);
    $("#ucWebPort").val(jsonbean.ucWebPort);
    $("#ucFileSSLEnc").val(jsonbean.ucFileSSLEnc);
    $("#ucFileSavePath").val(jsonbean.ucFileSavePath);
    //m1 是否启用
    if(jsonbean.hashM1Plug == "1" && ${ctp:hasPlugin('m1')}) {
        $("#inputM1Host").show();
        $("#inputM1Port").show();
        $("#showM1Host").show();
        $("#showM1Port").show();
        $("#seeyonM1ServerIp").val(jsonbean.m1ServerIp);
        $("#seeyonM1ServerPort").val(jsonbean.m1MessagePort);
        var m1ServerIp = jsonbean.m1ServerIp;
        if ("${mxVersion}" == 'M1') {
        	if (m1ServerIp.indexOf("http://") == 0) {
        		m1ServerIp = jsonbean.m1ServerIp.substring(7);
        	} else if (m1ServerIp.indexOf("https://") == 0) {
        		m1ServerIp = jsonbean.m1ServerIp.substring(8);
        	}
		} 
        $("#seeyonM1ServerIpI").val(m1ServerIp);
        $("#seeyonM1ServerPortI").val(jsonbean.m1MessagePort);
    } else {
        $("#showM1Host").hide();
        $("#showM1Port").hide();
        $("#inputM1Host").hide();
        $("#inputM1Port").hide();
        $("#seeyonM1ServerIp").val("");
        $("#seeyonM1ServerPort").val("");
        $("#seeyonM1ServerIpI").val("");
        $("#seeyonM1ServerPortI").val("");
    }
    if (jsonbean.nFileSize == "" || jsonbean.nFileSize == null || jsonbean.nFileSize == "null") {
    	jsonbean.nFileSize = "50";
    }
    if (jsonbean.nFileSize == "-1") { //文件大小限制
        $("#ucFileTransferSizeLimitI").val("不限制");
    } else {
        $("#ucFileTransferSizeLimitI").val(jsonbean.nFileSize);//文件保存期限
    }
    if (jsonbean.nFileSize == "-1") {
    	$("#ucFileTransferSizeLimit").attr("disabled","disabled");
    	$("#unlimited").attr("checked",true);
    } else {
    	$("#ucFileTransferSizeLimit").val(jsonbean.nFileSize);
    	$("#ucFileTransferSizeLimit").removeAttr("disabled");
    	$("#unlimited").removeAttr("checked");
    }
    $("#ucFileEncryptGrade").val(jsonbean.ucFileEncryptGrade);
    $("#ucFileOutTime").val(jsonbean.ucFileOutTime);
    $("#ucGroupOutTime").val(jsonbean.ncGroupOutTime);
    $("#a8ServerLanIp").val(jsonbean.szInA8HttpIP);
    $("#a8ServerInternetIp").val(jsonbean.szOutA8HttpIP);
    $("input[name='clientVisitA8'][value='"+jsonbean.clientVisitA8+"']").attr("checked",true);

    if (jsonbean.clientVisitA8 == "1") {
        $("#loginA8").html("客户端仅通过内网地址或VPN访问协同服务器");
        $("#seeyonLan").show();
        $("#seeyonOuter").hide();
    } else if (jsonbean.clientVisitA8 == "2") {
        $("#loginA8").html("客户端仅通过外网地址访问协同服务器");
        $("#seeyonLan").hide();
        $("#seeyonOuter").attr("style","");
        $("#seeyonOuter").show();
    } else {
        $("#loginA8").html("客户端可以通过内网地址或外网地址访问协同服务器");
        $("#seeyonLan").show();
        $("#seeyonOuter").attr("style","margin-left:-5em;");
        $("#seeyonOuter").show();
    }
    $('#config0').show();
    $("#ConContentD :input").each(function () {  $(this).attr("disabled","disabled")  });
    $("#ConContent1 :input").each(function () {  $(this).attr("disabled","disabled")  });
    $("#ConContent2 :input").each(function () {  $(this).attr("disabled","disabled")  });
    $("#ConContent3 :input").each(function () {  $(this).attr("disabled","disabled")  });
    $("#ConContent4 :input").each(function () {  $(this).attr("disabled","disabled")  });
    $("#ConContent6 :input").each(function () {  $(this).attr("disabled","disabled")  });
    $("#ConContentTemp1 :input").each(function () {  $(this).attr("disabled","disabled")  });
    //$("#ConContentTop :input").each(function () {  $(this).attr("disabled","disabled")  });
    $("#config00 :input").each(function () {  $(this).removeAttr("disabled")  });

    if(jsonbean.firstTime == '1'){//第一次配置
        //显示配置页面
         var random = $.messageBox({
            'type': 0,
            'imgType' : 2,
            'msg': '检测到致信服务器未配置成功，请重新配置!',
            'ok_fn' : function () {
            	firstModul(jsonbean);
            },
            'close_fn' : function () {
            	firstModul(jsonbean);
            }
        });
    }
	if (jsonbean.firstTime != "1" && jsonbean.isReadingConfig != "0") {
	    if (!checkVersion(jsonbean)){
	        $("#config00 :input").each(function () {  $(this).attr("disabled","disabled")  });
	        return ;
	    }
	}
}

function firstModul (jsonbean) {
	$('#config0').hide();
    $('#config1').show();
    if(jsonbean.a8ServerIp == ''){
        $("#seeyonnServerIp").val("127.0.0.1");
    }else{
        $("#seeyonnServerIp").val(jsonbean.a8ServerIp);
    }
    if(jsonbean.ucServerIp == '' || jsonbean.ucServerIp == null){
        $("#ucServerIp").val("127.0.0.1");
    }else{
        $("#ucServerIp").val(jsonbean.ucServerIp);
    }
    $("#seeyonnServerIp").attr("disabled","disabled");
    $("#ucServerIp").attr("disabled","disabled");
    $("#deploymentMode").removeAttr("disabled");
    $("#seeyonnServerPort").removeAttr("disabled");
    $("#ucServerPort").removeAttr("disabled");
}
	function subUrl(url){
		var str = "";
		if (url.indexOf("//") > 0) {
			url = url.substring(url.indexOf("//") + 2, url.length);
		}
		if (url.indexOf(":") > 0) {
			url = url.substring(0,url.indexOf(":"));
		}
		return url
	}
    function getPortByUrl(url){
        var port = "";
        if (url.indexOf("//") > 0) {
            url = url.substring(url.indexOf("//") + 2, url.length);
        }
        if (url.indexOf(":") > 0) {
        	port = url.substring(url.indexOf(":") + 1, url.length);
        }
        return port
    }
	function loadConfig1(){
		$('#config0').hide();
		$('#config10').hide();
		$('#config1').show();
	}

	function selectClientVisit(flag){
		if(flag == '1'){
			selectClientVisit124();
		}else if(flag == '2'){
			selectClientVisit124();
		}else if(flag == '3'){
			$("#ucServerLanIp").val("");
			$("#ucServerLanIp").attr("disabled","disabled");
			$("#ucServerInternetIp").removeAttr("disabled");
		}else if(flag == '4'){
			selectClientVisit124();
		}else if(flag == '5'){
			$("#ucServerlanIp").removeAttr("disabled");
			$("#ucServerInternetIp").removeAttr("disabled");
		}
	}
	function selectClientVisit124(){
		$("#ucServerInternetIp").val("");
		$("#ucServerInternetIp").attr("disabled","disabled");
		//如果上一步选择的是集成
		if($("#deploymentModeV").val() == '0'){
			$("#ucServerLanIp").removeAttr("disabled");
		}else if($("#deploymentModeV").val() == '1'){//上一步选择了分离
			$("#ucServerLanIp").val($("#ucServerIpV").val());
			$("#ucServerLanIp").attr("disabled","disabled");
		}
	}
	function nextConfig(flag){
		if(flag == '1'){
			//保存本页的值到hidden
			//kygz 增加M1与致信的关系判断的存值 1表示在同一服务器上
			$("#isM1WithUCV").val($("input[name='isM1WithUC']").is(":checked")?1:0);
			$("#deploymentModeV").val($("input[name='deploymentMode']:checked").val());
			if($("#deploymentModeV").val() == '1'){//选择分离回填上次的ip值
				$("#seeyonnServerIp").removeAttr("disabled");
				/* $("#seeyonM1ServerIp").removeAttr("disabled"); */
				$("#ucServerIp").removeAttr("disabled");
				var m1ServerIp = chcheBean.m1ServerIp;
				var ucServerIp = chcheBean.ucS2SIp;
				var seeyonnServerIp = chcheBean.a8ServerIp;
				if ("1" != $("#seeyonM1ServerIp").attr("blurNum") || $("#seeyonM1ServerIp").val() == "http://127.0.0.1" || $("#seeyonM1ServerIp").val() == "https://127.0.0.1") {
					
					if ("http://127.0.0.1" != m1ServerIp&&"https://127.0.0.1" != m1ServerIp) {
						$("#seeyonM1ServerIp").val(m1ServerIp);
					} else {
						$("#seeyonM1ServerIp").val("");
					}
				}
				if ("1" != $("#seeyonnServerIp").attr("blurNum") || $("#seeyonnServerIp").val() == "127.0.0.1") {
					if ("127.0.0.1" != seeyonnServerIp) {
						$("#seeyonnServerIp").val(seeyonnServerIp);
					} else {
						$("#seeyonnServerIp").val("");
					}
				}
                if ("1" != $("#ucServerIp").attr("blurNum") || $("#ucServerIp").val() == "127.0.0.1") {
                	if ("127.0.0.1" != ucServerIp) {
                	   $("#ucServerIp").val(ucServerIp);
                	} else {
                	   $("#ucServerIp").val("");
                	}
                }
			}else if($("#deploymentModeV").val() == '0'){//选择集成的时候要记录分离的ip
				$("#ucServerIp").val("127.0.0.1");
				$("#seeyonnServerIp").val("127.0.0.1");

				$("#seeyonnServerIp").attr("disabled","disabled");
				$("#ucServerIp").attr("disabled","disabled");
				if($("#isM1WithUCV").val()!=1){//kygz 如果m1不与UC OA同在一服务器上 回填或
					var m1ServerIp = chcheBean.m1ServerIp;
               		if ("1" != $("#seeyonM1ServerIp").attr("blurNum") || $("#seeyonM1ServerIp").val() == "127.0.0.1") {
                	    $("#seeyonM1ServerIp").val(m1ServerIp);
               		}
               		/* $("#seeyonM1ServerIp").removeAttr("disabled"); */
                	$("#ucServerIp").removeAttr("disabled");
                	$("#seeyonnServerIp").removeAttr("disabled");
                	$("#ucServerIp").val("");
    				$("#seeyonnServerIp").val("");
    				$("#seeyonM1ServerIp").val("");
				}else{
					$("#seeyonM1ServerIp").val("http://127.0.0.1");
					/* $("#seeyonM1ServerIp").attr("disabled","disabled"); */
				}


			}
			//显示下一页
			nextPage(2);
		}else if(flag == '2'){
			//检测UCIP
			var ucServerIp = $("#ucServerIp").val();
			var seeyonnServerIp = $("#seeyonnServerIp").val();
			var seeyonnServerPort = $("#seeyonnServerPort").val();
			var ucServerPort = $("#ucServerPort").val();
			var seeyonM1ServerIp = $("#seeyonM1ServerIp").val();
			var seeyonM1ServerPort = $("#seeyonM1ServerPort").val();
			var hashM1Plug = chcheBean.hashM1Plug;
			if (ucServerIp == "") {
				$.alert("致信服务器地址不能为空");
				return ;
			}
			if (seeyonnServerIp == "") {
				$.alert("协同服务器IP地址不能为空");
				return ;
			}
			//检测致信服务器ip地址是否可用
            if(isLanIP(ucServerIp) == 'false'){
                $.alert("请正确填写致信服务器ip地址");
                return ;
            }
            if(isLanIP(seeyonnServerIp) == 'false'){
                $.alert("请正确填写协同服务器ip地址");
                return ;
            }
            //先检测填写是否合法
            if(!checkMAX($("#ucServerPort").val())){
                $.alert("致信服务器S2S端口请输入1~65535之间的数字");
                return;
            }
            if(!checkMAX($("#seeyonnServerPort").val())){
                $.alert("协同服务器S2S端口请输入1~65535之间的数字");
                return;
            }
            if (hashM1Plug == "1") {
    			if (seeyonM1ServerIp == "") {
    				$.alert("${mxVersion}服务器地址不能为空");
    				return ;
    			}
    			if($("#isM1WithUCV").val()!=1){//kygz 如果m1不与UC OA同在一服务器上
    				if(seeyonM1ServerIp=="http://127.0.0.1"||seeyonM1ServerIp=="https://127.0.0.1"){
						$.alert("${mxVersion}服务器地址不能为127.0.0.1，请填正确的IP");
                   		return ;
    				}
    				if(seeyonnServerIp=="127.0.0.1"){
						$.alert("协同服务器地址不能为127.0.0.1，请填正确的IP");
                   		return ;
    				}
    				if(ucServerIp=="127.0.0.1"){
						$.alert("UC服务器地址不能为127.0.0.1，请填正确的IP");
                   		return ;
    				}
    			}
              /*   if(isLanIP(seeyonM1ServerIp) == 'false'){
                    $.alert("请正确填写M1服务器ip地址");
                    return ;
                } */
                if(!checkMAX($("#seeyonM1ServerPort").val())){
                    $.alert("${mxVersion}服务器S2S端口请输入1~65535之间的数字");
                    return;
                }
            }
			//如果选择了分离
			if($("input[name='deploymentMode']:checked").val() == '1'){
				var ipUsable = seeyonnServerIp.indexOf("localhost") != -1 || seeyonnServerIp.indexOf("127") != -1 || ucServerIp.indexOf("localhost") != -1 || ucServerIp.indexOf("127") != -1;
				//两者的ip地址不能相同或是出现localhost或127
				if(seeyonnServerIp == ucServerIp || ipUsable){
					$.alert("协同和致信的服务器ip地址不能相同以及使用localhost和127");
					return;
				}
			}else{//如果选择了集成的话就要验证内网ip是否合法
				if(isLanIP(seeyonnServerIp) == 'false'){
					$.alert("协同服务器ip地址不正确");
					return ;
				}
				if(isLanIP(ucServerIp) == 'false'){
					$.alert("致信服务器ip地址不正确");
					return ;
				}
				if (hashM1Plug == "1") {
					if($("#isM1WithUCV").val()!=1){//kygz 如果m1不与UC OA同在一服务器上
    					if(seeyonM1ServerIp=="http://127.0.0.1"||seeyonM1ServerIp=="https://127.0.0.1"){
							$.alert("${mxVersion}服务器地址不能为127.0.0.1，请填内网ip");
                   			return ;
    					}
    				}
					if ($("#ucServerPort").val() == $("#seeyonnServerPort").val() || $("#seeyonM1ServerPort").val() == $("#seeyonnServerPort").val() || $("#seeyonM1ServerPort").val() ==$("#ucServerPort").val()) {
						$.alert("集成部署模式下致信服务器S2S端口与协同服务器S2S端口与M1服务器S2S端口不能相同");
						return ;
					}
				} else {
					if ($("#ucServerPort").val() == $("#seeyonnServerPort").val()) {
						$.alert("集成部署模式下致信服务器S2S端口不能与协同服务器S2S端口一致");
						return ;
					}
				}
			}

			//检测ip及端口号
			checkByUrlAsync("2",3);
		}else if(flag == '3'){
			//保存本页的值到hidden
			$("#clientVisitV").val($("input[name='clientVisit']:checked").val());
			if($("#clientVisitV").val() == '1'){
				//隐藏掉外网地址
				$('#serverIp1').show();
				$('#serverIp2').hide();
				//$("#ucServerInternetIp").val("")
				$("#inTip").show();
                $("#outTip").hide();
				//selectClientVisit124();
			}else if($("#clientVisitV").val() == '2'){
				//selectClientVisit124();
				//隐藏掉内网地址
				$('#serverIp1').hide();
				$('#serverIp2').show();
				//$("#ucServerLanIp").val("")
				$("#inTip").show();
				$("#outTip").show();
				//显示注释
				//$('#firewall3').show();
			}else if($("#clientVisitV").val() == '3'){
				$('#serverIp1').show();
				$('#serverIp2').show();
				//if ("1" != $("#ucServerLanIp").attr("blurNum")) {
					//$("#ucServerLanIp").val("");
				//}
				$("#ucServerLanIp").removeAttr("disabled");
				$("#ucServerInternetIp").removeAttr("disabled");
                $("#inTip").show();
                $("#outTip").show();
				//显示注释
				//$('#firewall3').show();
			}
			//给下一页赋值
			if($("#deploymentModeV").val() == '1'){//选择集成的时候要记录分离的ip
				if ("1" != $("#ucServerLanIp").attr("blurNum")) {
					$("#ucServerLanIp").val($("#ucServerIpV").val());
				}
			} else {
				if ("1" != $("#ucServerLanIp").attr("blurNum")) {
					$("#ucServerLanIp").val(chcheBean.szUCInIp);
				}
			}
			//显示下一页
			nextPage(4);
		}else if(flag == '4'){
			//检测内网及外网地址
			var checkArray = new Array();
			var _index = 0;
			var clientVisit = $("input[name='clientVisit']:checked").val();
			if (clientVisit == "1" || clientVisit == "3") {
			    if ($("#ucServerLanIp").val() == "") {
			    	$.alert("致信服务器IP地址（内网）不能为空");
			    	return ;
			    }
			    if ($("#ucServerLanIp").val() != chcheBean.szUCInIp) {
			    	checkArray[_index] = "ucServerLanIp";
	                _index ++;
			    }
			}
			if (clientVisit == "2" || clientVisit == "3") {
                if ($("#ucServerInternetIp").val() == "") {
                    $.alert("致信服务器IP地址（外网）不能为空");
                    return ;
                }
                if ($("#ucServerInternetIp").val() != chcheBean.szUCOuterIP) {
                	checkArray[_index] = "ucServerInternetIp";
                }
            }
			if($("#deploymentModeV").val() == '0' && (clientVisit == '1' || clientVisit == '3')){//上一步选择了集成
				if($("#ucServerLanIp").val().indexOf("localhost") == 0 || $("#ucServerLanIp").val().indexOf("127") == 0){
					$.alert("致信服务器内网IP地址不能输入localhost和127");
					return false;
				}
			}
			if($("#deploymentModeV").val() == '0' && (clientVisit == '2' || clientVisit == '3')){
				if($("#ucServerInternetIp").val().indexOf("localhost") == 0 || $("#ucServerInternetIp").val().indexOf("127") == 0){
					$.alert("致信服务器外网IP地址不能输入localhost和127");
					return false;
				}
			}
			checkSave(checkArray,0,"nextPage5");
		}else if(flag == '5'){
			var ucC2sPort = $("#ucC2sPort").val();
			var ucFileTransferPort = $("#ucFileTransferPort").val();
			var ucWebPort = $("#ucWebPort").val();
			//保存本页的值到hidden
			$("#ucC2sPortV").val($("#ucC2sPort").val());
			$("#ucFileTransferPortV").val($("#ucFileTransferPort").val());
			$("#ucWebPortV").val($("#ucWebPort").val());
	         //先检测填写是否合法
            if(!checkMAX($("#ucC2sPortV").val())){
                $.alert("客户端访问端口请输入1~65535之间的数字");
                return;
            }
            if(!checkMAX($("#ucFileTransferPortV").val())){
                $.alert("文件传输端口请输入1~65535之间的数字");
                return;
            }
            if(!checkMAX($("#ucWebPortV").val())){
                $.alert("WEB访问服务端口请输入1~65535之间的数字");
                return;
            }
            var portObj = null;
	         //检测端口号不能重复
	         //判断是分离还是集成
	        if($("#deploymentModeV").val() == '1'){
	        	portObj = new Array([$("#ucC2sPortV").val()],[$("#ucFileTransferPortV").val()],[$("#ucWebPortV").val()],[$("#ucServerPortV").val()]);
	        } else {
	            portObj = new Array([$("#ucC2sPortV").val()],[$("#ucFileTransferPortV").val()],[$("#ucWebPortV").val()],[$("#ucServerPortV").val()],[$("#seeyonnServerPortV").val()],[$("#seeyonM1ServerPortV").val()]);　//创建一个数组
	        }
            if(portCheck(portObj) == 'true'){
                return ;
            }
            //屏蔽选择验证方式默认致信验证，如果需要放开请修改
            //checkByUrlAsync("5",6);
            $("#szClientPwdTestV").val("1");
            checkByUrlAsync("5",7);
		}else if(flag == '6'){
			//检测致信客户端登陆验证方式
			var ucPort = 80;//------------------------------------------------------TODO
			$("#szClientPwdTestV").val($("input[name='szClientPwdTest']:checked").val());
			if($("input[name='szClientPwdTest']:checked").val() == '2'){//如果选择协同服务器验证
				checkByUrlAsync("6",7);
			} else {
				nextPage(7);
			}
		}else if(flag == '7'){
			//文件路径检测
			var fileSavePath = document.getElementById('ucFileSavePath').value;
			if(fileSavePath == ''){
			    $.alert($.i18n('uc.config.title.pathnotnull.js'));
			    return ;
			}
			var reg=/[\u4E00-\u9FA5]/g;
			if (reg.test(fileSavePath)) {
			    $.alert($.i18n('uc.config.filepathnotspaces.js'));
			    return ;
			}
			if (fileSavePath == ''|| fileSavePath.indexOf('\\') >= 0 || fileSavePath.indexOf('//') >= 0) {
			    $.alert($.i18n('uc.config.filepathnotspaces.js'));
			    return ;
			}
			var ucFileSavePath = $("#ucFileSavePath").val();
			var ucFileTransferSizeLimit = $("#ucFileTransferSizeLimit").val();
			var ucFileEncryptGrade = $("#ucFileEncryptGrade").val();
			var ucFileOutTime = $("#ucFileOutTime").val();
			//检测文件大小传输限制
			if ($("#unlimited").attr("checked") != "checked") {
				if (!checkFileMAX($("#ucFileTransferSizeLimit").val())) {
	                $.alert("您输入的文件大小不合法!");
	                return ;
	            }
				if(isNaN($('#ucFileTransferSizeLimit').val())){
					alert("请填写数字");
					return ;
				}
				$("#ucFileTransferSizeLimitV").val($("#ucFileTransferSizeLimit").val());
			}else{
				$("#ucFileTransferSizeLimitV").val("-1");
			}
			//保存本页的值到hidden
			$("#ucFileSavePathV").val($("#ucFileSavePath").val());
			$("#ucFileEncryptGradeV").val($("#ucFileEncryptGrade").val());
			$("#ucFileOutTimeV").val($("#ucFileOutTime").val());
			$("#ucGroupOutTimeV").val($("#ucGroupOutTime").val());
			//检测文件路径
			ajaxcheckFilePath();
		}else if(flag == '8'){
			//保存本页的值到hidden
			$("#clientVisitA8V").val($("input[name='clientVisitA8']:checked").val());
			if ($("#clientVisitA8V").val() == "1") {
				//内网
				$("#seeyonserverIp1").show();
				$("#seeyonserverIp2").hide();
			} else if ($("#clientVisitA8V").val() == "2") {
				$("#seeyonserverIp1").hide();
                $("#seeyonserverIp2").show();
			} else {
				$("#seeyonserverIp1").show();
                $("#seeyonserverIp2").show();
			}
			//给下一页赋值
			if($("#deploymentModeV").val() == '1'){//选择集成的时候要记录分离的ip
				if ("1" != $("#a8ServerLanIp").attr("blurNum")) {
					$("#a8ServerLanIp").val($("#seeyonnServerIp").val());
				}
			} else {
				//选择了集成部署把之前填写的uc的外网和内网ip映射过来
				//判断uc选择的是内网还是外网
				if ("1" != $("#a8ServerLanIp").attr("blurNum")) {
					var clientVisit = $("#clientVisitV").val();//客户端的链接类型
	                if (clientVisit == "1" || clientVisit == "3") {
	                    $("#a8ServerLanIp").val($("#ucServerLanIpV").val());
	                }
				}
				if ("1" != $("#a8ServerInternetIp").attr("blurNum")) {
	                if (clientVisit == "2" || clientVisit == "3") {
	                    $("#a8ServerInternetIp").val($("#ucServerInternetIpV").val());
	                }
				}
			}
			nextPage(9);
		}else if(flag == '9'){
			var selectFlag = $("input[name='clientVisitA8']:checked").val();
			var _index = 0;
			var checkArray = new Array();
			if (selectFlag == "1" || selectFlag == "3") {
			    if ($("#a8ServerLanIp").val() == "") {
			        $.alert("协同服务器的内网链接地址不能为空");
			        return ;
			    }
                if ($("#a8ServerLanPort").val() == "") {
                    $.alert("协同服务的内网端口不能为空");
                    return ;
                }
                if(!checkMAX($("#a8ServerLanPort").val())){
                    $.alert("协同服务的内网端口请输入1~65535之间的数字");
                    return;
                }
                if ($("#a8ServerLanIp").val() != chcheBean.szInA8HttpIP) {
                	checkArray[_index] = "a8ServerLanIp";
                    _index ++ ;
                }
			}
			if (selectFlag == "2" || selectFlag == "3") {
                if ($("#a8ServerInternetIp").val() == "") {
                    $.alert("协同服务器的外网链接地址");
                    return ;
                }
                if ($("#a8ServerInternetPort").val() == "") {
                    $.alert("协同服务的外网端口不能为空");
                    return ;
                }
                if(!checkMAX($("#a8ServerInternetPort").val())){
                    $.alert("协同服务的外网端口请输入1~65535之间的数字");
                    return;
                }
                if ($("#a8ServerInternetIp").val() != chcheBean.szOutA8HttpIP) {
                    checkArray[_index] = "a8ServerInternetIp";
                }
			}
			var oldPort = chcheBean.a8S2sPort;
            var seeyonnServerPort = $("#seeyonnServerPortV").val();
            var oldOaIp = chcheBean.a8ServerIp;
            var seeyonA8Ip = $("#seeyonnServerIpV").val();
            var oldUcIp = chcheBean.ucS2SIp;
            var seeyonUcIp = $("#ucServerIpV").val();
            var oldUcPort = chcheBean.ucS2sPort;
            var seeyonUcPort = $("#ucServerPortV").val();
			if (oldPort != seeyonnServerPort || oldUcPort != seeyonUcPort || oldUcIp != seeyonUcIp || oldOaIp != seeyonA8Ip) {
                var random = $.messageBox({
                    'type': 0,
                    'msg': '保存配置信息成功后必须重启协同服务方可正常使用',
                    'imgType' : 2,
                    'ok_fn' : function () {
                    	tipReStartUcSever(checkArray);
                     },
                     'close_fn' : function () {
                    	 tipReStartUcSever(checkArray);
                     }
                });
            } else {
            	tipReStartUcSever(checkArray);
            }
		}
	}

	function tipReStartUcSever (checkArray) {
		var random = $.messageBox({
            'type': 0,
            'msg': '保存配置完成后必须需重启致信服务方可生效,否则将导致致信无法正常工作！',
            'imgType' : 2,
            'ok_fn' : function () {
                checkSave(checkArray,0,"saveConfig");
             },
             'close_fn' : function () {
                checkSave(checkArray,0,"saveConfig");
             }
        });

	}

	function checkSave (checkArray,_index,callBack) {
		if (_index >= checkArray.length) {
			if (callBack == "saveConfig") {
				saveConfig();
			} else if (callBack == "nextPage5") {
                //保存本页的值到hidden
                var ucServerLanIp = $("#ucServerLanIp").val();
                var ucServerInternetIp = $("#ucServerInternetIp").val();
                $("#ucServerLanIpV").val(ucServerLanIp);
                $("#ucServerInternetIpV").val(ucServerInternetIp);
                //显示下一页
                nextPage(5);
			}
			return ;
		}
		var option = checkArray[_index];
		var checkIp = $("#a8ServerLanIp").val();
		var title = "您输入的协同服务器的内网链接地址不是有效IP地址,请确认是否是域名?";
		if (option == "a8ServerInternetIp") {
            checkIp = $("#a8ServerInternetIp").val();
            title = "您输入的协同服务器的外网链接地址不是有效IP地址,请确认是否是域名?";
        } else if (option == "ucServerLanIp") {
            checkIp = $("#ucServerLanIp").val();
            title = "您输入的协致信服务器IP地址（内网）地址不是有效IP地址,请确认是否是域名?";
        } else if (option == "ucServerInternetIp") {
        	checkIp = $("#ucServerInternetIp").val();
            title = "您输入的协致信服务器IP地址（外网）地址不是有效IP地址,请确认是否是域名?";
        }
		/*
		if (checkIp.indexOf(".") < 0) {
			if (option == "a8ServerInternetIp") {
				$.alert("您输入的协同服务器的外网链接地址无效!");
				return ;
 			} else if (option == "a8ServerLanIp") {
				$.alert("您输入的协同服务器的内网链接地址无效!");
				return ;
			} else if (option == "ucServerInternetIp") {
                $.alert("您输入的致信服务器IP地址（外网）地址无效!");
                return ;
			} else if (option == "ucServerLanIp") {
                $.alert("您输入的致信服务器IP地址（内网）地址无效!");
                return ;
			} 
		}
		*/

		if (isLanIP(checkIp) == 'false') {
            var random = $.messageBox({
                'type': 3,
                'msg': title,
                'imgType' : 3,
                'yes_fn' : function () {
                	_index ++ ;
                	checkSave(checkArray,_index,callBack);
                 }
            });
		} else {
			_index ++ ;
            checkSave(checkArray,_index,callBack);
		}
	}

	function saveConfig () {
		getCtpTop().startProc("正在保存配置信息");
        //保存本页的值到hidden
        $("#a8ServerLanIpV").val($("#a8ServerLanIp").val());
        $("#a8ServerInternetIpV").val($("#a8ServerInternetIp").val());

        //保存数据
        var theForm = document.getElementById("submitform");
        theForm.action = "${ucconfigurl}?method=saveConfig";
        var deploymentMode = $("#deploymentModeV").val();//协同和致信部署方式
        var seeyonnServerIp = $("#seeyonnServerIpV").val();//协同服务器IP地址
        var seeyonnServerPort = $("#seeyonnServerPortV").val();//协同服务器S2S端口

        var szUCInIp = $("#ucServerLanIpV").val();//致信服务器IP地址
        var ucServerIp = $("#ucServerIpV").val();
        var ucServerPort = $("#ucServerPortV").val();//致信服务器S2S端口
        var ucServerInternetIp = $("#ucServerInternetIpV").val();//致信服务器IP地址（外网）
        var ucC2sPort = $("#ucC2sPortV").val();//客户端访问端口
        var ucFileTransferPort = $("#ucFileTransferPortV").val();//文件传输端口
        var ucWebPort = $("#ucWebPortV").val();//HTTP服务端口
        var ucFileSavePath = $("#ucFileSavePathV").val();//文件存储路径
        var ucFileTransferSizeLimit = $("#ucFileTransferSizeLimitV").val();//文件大小传输限制（M）
        var ucFileEncryptGrade = $("#ucFileEncryptGradeV").val();//文件存储加密方式
        var ucFileOutTime = $("#ucFileOutTimeV").val();//个人文件保存期限
        var ncGroupOutTime  = $("#ucGroupOutTimeV").val();
        var a8ServerLanIp = $("#a8ServerLanIpV").val();//A8服务器IP地址（内网）
        var a8ServerInternetIp = $("#a8ServerInternetIpV").val();//A8服务器IP地址（外网）
        var seeyonM1ServerIp = $("#seeyonM1ServerIpV").val();
        var seeyonM1ServerPort = $("#seeyonM1ServerPortV").val();
        var hashM1Plug = chcheBean.hashM1Plug;
        if (hashM1Plug != "1") {
        	seeyonM1ServerIp = "";
        	seeyonM1ServerPort = "";
        }
        if(seeyonM1ServerIp.indexOf('http')==-1){
        		seeyonM1ServerIp="http://"+seeyonM1ServerIp;
        }
        if (ucFileOutTime == "" || ucFileOutTime == "-1") {
        	ucFileOutTime = "30";
        }
        if (ncGroupOutTime == "" || ncGroupOutTime == "-1") {
        	ucFileOutTime = "30";
        }
        //A8访问方式 http OR https
        var a8ServerLanStyle = $("input[name='a8ServerLanStyle']:checked").val();
        var a8ServerInternetStyle = $("input[name='a8ServerInternetStyle']:checked").val();
        if (a8ServerLanStyle == "1") {
        	a8ServerLanIp = "https://" + a8ServerLanIp;
        } else {
        	a8ServerLanIp = "http://" + a8ServerLanIp;
        }

        if (a8ServerInternetStyle == "1") {
        	a8ServerInternetIp = "https://" + a8ServerInternetIp;
        } else {
        	a8ServerInternetIp = "http://" + a8ServerInternetIp;
        }
        //A8 内外网端口号
        a8ServerLanIp = a8ServerLanIp + ":" + $("#a8ServerLanPort").val();
        a8ServerInternetIp = a8ServerInternetIp + ":" + $("#a8ServerInternetPort").val();
        var clientVisit = $("#clientVisitV").val();//客户端的链接类型
        if (clientVisit == "1") {
        	ucServerInternetIp = "";
        }
        if (clientVisit == "2") {
        	szUCInIp = "";
        }
        var szClientPwdTest = $("#szClientPwdTestV").val();//客户端验证方式
        var clientVisitA8 = $("#clientVisitA8V").val();//客户端访问协同服务器方式
        //把外网ip支撑空
        if (clientVisitA8 == "1") {
            a8ServerInternetIp = "";
        }
        //把内网ip支撑空
        if (clientVisitA8 == "2") {
            a8ServerLanIp = "";
        }
        if ($("#unlimited").attr("checked") == "checked") {
            ucFileTransferSizeLimit = "-1";
        }
        var url = '${ucconfigurl}?method=saveConfig';
        var datas=
        {
            "deploymentMode":deploymentMode,
            "a8ServerIp":seeyonnServerIp,
            "a8S2sPort":seeyonnServerPort,
            "szUCInIp":szUCInIp,
            "ucS2SIp":ucServerIp,
            "ucS2sPort":ucServerPort,
            "szUCOuterIP":ucServerInternetIp,
            "ucC2sPort":ucC2sPort,
            "ucFileTransferPort":ucFileTransferPort,
            "ucWebPort":ucWebPort,
            "m1ServerIp":seeyonM1ServerIp,
            "m1MessagePort":seeyonM1ServerPort,
            /* "ucFileSSLEnc":ucFileSSLEnc, */
            "ncGroupOutTime":ncGroupOutTime,
            "ucFileSavePath":ucFileSavePath,
            "nFileSize":ucFileTransferSizeLimit,
            "ucFileEncryptGrade":ucFileEncryptGrade,
            "ucFileOutTime":ucFileOutTime,
            "szInA8HttpIP":a8ServerLanIp,
            "szOutA8HttpIP":a8ServerInternetIp,
            "nClientLinkStype":clientVisit,
            "szClientPwdTest":szClientPwdTest,
            "clientVisitA8":clientVisitA8,
            "a8ServerStyle":a8ServerLanStyle
        };
        $.ajax({
            type: "POST" ,
            url : url ,
            data: datas ,
            timeout : tiemOutTime,
            success : function (json){
                getCtpTop().endProc();
                var jso=eval(json);
                if(jso[0].res == "true"){
                	queryConfiy1();
                }else{
                    $.alert($.i18n('uc.config.title.saveConfig.no.js'));
                }
            },
            error: function (xmlHttpRequest, error) {
                getCtpTop().endProc();
                //恢复A8数据库保存设计
                returnSaveA8();
                disabelInput();
                getCtpTop().endProc();
                $.alert($.i18n('uc.config.title.connectionerror.js'));
                return;
            }
        });

	}
	//下一步事件
	function nextPage (_index) {
		for (var i = 1 ; i < 10 ; i ++) {
			if (i == _index) {
				$('#config' + i).show();
			} else {
				$('#config' + i).hide();
			}
		}
	}
	//根据url和参数执行检测,returnFlag 为返回值错误标准
	function checkByUrl (url,param,returnFlag) {
		var returnValue = true;
		param = encodeURI(param);
		$.ajax({
	        type: "POST",
	        url:   url,
	        data: param,
	        async : false,
	        success: function(msg){
	        	if(msg == returnFlag){
	        		returnValue  = false;
	            }
	        }
	    });
		return returnValue;
	}

	//检测公用方法
	function checkByUrlAsync (nextIdex,callBack) {
		var array = new Array();
		if(nextIdex == '2'){
			var indx = 0;
			if ($("#ucServerIpI").val() != $("#ucServerIp").val() || chcheBean.firstTime == "1") {
	            array[indx] = "ucS2sIp";
	            indx ++;
			} else {
                $("#ucFileSavePath").val(chcheBean.ucFileSavePath);
            }
			if($("#ucServerPortI").val() != $("#ucServerPort").val()){//如果端口没有改变就不检测
				array[indx] = "ucS2sPort";
				indx ++;
			}
			if ($("#seeyonnServerPortI").val() != $("#seeyonnServerPort").val()) {
				array[indx] = "a8S2sPort";
				indx ++;
			}
			array[indx] = "saveUcIp";
		} else if (nextIdex == '5') {
			//客户端访问端口
			var indx = 0;
            if($("#ucC2sPortI").val() != $("#ucC2sPortV").val()){//如果端口没有改变就不检测
            	array[indx] = "ucC2sPort";
            	indx ++;
            }
            //文件传输端口
            if($("#ucFileTransferPortI").val() != $("#ucFileTransferPortV").val()){//如果端口没有改变就不检测
                array[indx] = "ucFileTransferPort";
                indx ++;
            }
            //HTTP服务端口
            if($("#ucWebPortI").val() != $("#ucWebPortV").val()){
            	array[indx] = "ucWebPort";
                indx ++;
            }
		} else if (nextIdex == '6') {
			array[0] = "seeyonnServerIp";
		}
		checkAjax(array,0,callBack);
	}

	function nextPageTwo() {
        //保存本页的值到hidden
        $("#seeyonnServerIpV").val($("#seeyonnServerIp").val());
        $("#ucServerIpV").val($("#ucServerIp").val());
        $("#seeyonnServerPortV").val($("#seeyonnServerPort").val());
        $("#ucServerPortV").val($("#ucServerPort").val());
        var hashM1Plug = chcheBean.hashM1Plug;
        if (hashM1Plug == "1") {
        	//有M1
        	$("#seeyonM1ServerIpV").val($("#seeyonM1ServerIp").val());
        	$("#seeyonM1ServerPortV").val($("#seeyonM1ServerPort").val());
        }
        //初始化下个页面
        //$("#ucServerInternetIp").attr("disabled","disabled");
        if($("#deploymentModeV").val() == '1'){//上一步选择了分离
        	$("#ucServerLanIp").val($("#ucServerIpV").val());
        } else {
        	$("#ucServerLanIp").val("");
        }
        getCtpTop().endProc();
        nextPage("3");
	}


	function checkAjax(array,_index,callBack) {
		if (_index >= array.length) {
			//显示下一页
			if (callBack == 3) {
				nextPageTwo();
			} else {
				getCtpTop().endProc();
				nextPage(callBack);
			}
			return ;
		}
		var option = array[_index];

		if(option == null || option == undefined){
			return;
		}
		if (option == 'ucS2sIp') { //检测致信服务器ip是否可用
			getCtpTop().startProc("正在检测致信服务器ip是否可用");
			url = "${ucconfigurl}?method=checkIpUrl&flag=UC";
			params = "&ucServerIp="+$("#ucServerIp").val();
		}else if(option == 'ucS2sPort'){//检测致信S2S端口是否可用
			getCtpTop().startProc("正在检测致信S2S端口是否可用");
			url = "${ucconfigurl}?method=ajaxCheckPort";
			params = "&port="+$("#ucServerPort").val()+"&from=uc&ucServerIp="+$("#ucServerIp").val();
		}else if(option == 'a8S2sPort'){//检测协同S2S端口是否可用
			getCtpTop().startProc("正在检测协同S2S端口是否可用");
			url = "${ucconfigurl}?method=ajaxCheckPort";
			params = "&port="+$("#seeyonnServerPort").val()+"&from=a8";
		}else if(option == 'saveUcIp'){//保存致信服务器的ip地址到A8的数据库
			url = "${ucconfigurl}?method=saveNextConfig1";
			params = encodeURI("&ucServerIp="+$("#ucServerIp").val()); 
			/* 初始化已经保存了，但是后来致信的服务端的端口被占用了。怎么办？
			getCtpTop().startProc("正在检测致信服务器ip是否可用");
			url = "${ucconfigurl}?method=checkIpUrl&flag=UC";
			params = "&ucServerIp="+$("#ucServerIp").val();*/
		} else if (option == "ucC2sPort") {
			//客户端端口
			getCtpTop().startProc("正在检测WEB访问服务端口是否可用");
			url = "${ucconfigurl}?method=ajaxCheckPort";
			params = "&port="+$("#ucC2sPortV").val()+"&from=uc";
		} else if (option == "ucFileTransferPort") {
			getCtpTop().startProc("正在检测文件传输端口是否可用");
			url = "${ucconfigurl}?method=ajaxCheckPort";
			params = "&port="+$("#ucFileTransferPortV").val()+"&from=uc";
		} else if (option == "ucWebPort") {
			getCtpTop().startProc("正在检测客户端访问端口是否可用");
			url = "${ucconfigurl}?method=ajaxCheckPort";
			params = "&port="+$("#ucWebPortV").val()+"&from=uc";
		} else if (option == "seeyonnServerIp") {
			getCtpTop().startProc("正在检测协同服务IP是否可用");
			url = "${ucconfigurl}?method=checkServerIpByUc&flag=UC";
			params = "&ip=http://"+$("#seeyonnServerIpV").val();
		}
		$.ajax({
			type: "POST",
	        url:   url,
	        data: params,
	        async : true,
			success : function (mas) {
				if (option == 'ucS2sIp') {
					var masArray = mas.split(",");
					if(masArray[0] == 1 || masArray[0] == "1"){
						$.alert("致信服务器IP不可用！原因可能如下：<br/>1.地址配置错误或主机没有启动<br/>2.SeeyonUcServer服务运行异常或未启动<br/>3.致信服务器(主机)启用了单机防火墙，40011端口没有开放");
						getCtpTop().endProc();
						return ;
					} else {
						var filePath = masArray[1];
						$("#ucFileSavePath").val(filePath);
						_index ++;
						getCtpTop().endProc();
						checkAjax(array,_index,callBack);
					}
				}else if (option == 'ucS2sPort') {
					mas = eval(mas)[0].res;
					if(mas == 1 || mas == "1"){
						$.alert("致信服务器S2S端口不可用");
						getCtpTop().endProc();
						return ;
					} else {
						_index ++;
						getCtpTop().endProc();
						checkAjax(array,_index,callBack);
					}
				}else if (option == 'a8S2sPort') {
					mas = eval(mas)[0].res;
					if(mas == 1 || mas == "1"){
						$.alert("协同服务器S2S端口不可用");
						getCtpTop().endProc();
						return ;
					} else {
						_index ++;
						getCtpTop().endProc();
						checkAjax(array,_index,callBack);
					}
				}else if (option == 'saveUcIp') {
					if(mas == 1 || mas == "1"){
						$.alert("保存致信服务器的ip地址到A8的数据库失败");
						getCtpTop().endProc();
						return ;
					} else {
						_index ++;
						getCtpTop().endProc();
						checkAjax(array,_index,callBack);

					}
				} else if (option == "ucC2sPort") {
                    mas = eval(mas)[0].res;
                    if(mas == 1 || mas == "1"){
                        $.alert("WEB访问服务端口不可用");
                        getCtpTop().endProc();
                        return ;
                    } else {
                        _index ++;
                        getCtpTop().endProc();
                        checkAjax(array,_index,callBack);
                    }
				} else if (option == "ucFileTransferPort") {
                    mas = eval(mas)[0].res;
                    if(mas == 1 || mas == "1"){
                        $.alert("文件传输端口不可用");
                        getCtpTop().endProc();
                        return ;
                    } else {
                        _index ++;
                        getCtpTop().endProc();
                        checkAjax(array,_index,callBack);
                    }
				} else if (option == "ucWebPort") {
                    mas = eval(mas)[0].res;
                    if(mas == 1 || mas == "1"){
                        $.alert("客户端访问端口不可用");
                        getCtpTop().endProc();
                        return ;
                    } else {
                        _index ++;
                        getCtpTop().endProc();
                        checkAjax(array,_index,callBack);
                    }
				} else if (option == "seeyonnServerIp") {
					getCtpTop().endProc();
					if (mas == 1 || mas == "1") {
						if($("#deploymentModeV").val() == '0') {
							$.alert("协同服务器验证用户名和密码是否正确接口测试失败：失败的原因：tomcat端口没有监听。");
						} else if ($("#deploymentModeV").val() == '1') {
							$.alert("1.协同服务器验证用户名和密码是否正确接口测试失败：失败的原因：tomcat端口没有监听。2.协同服务器上的单机防火墙80端口没有开放");
						}
						return ;
					} else {
                        _index ++;
                        checkAjax(array,_index,callBack);
					}
				}
			}
		})
	}

	function checkOaIpByUC (httpUrl) {
		var param = "&ip=http://"+httpUrl;
		var url = "${ucconfigurl}?method=checkServerIpByUc&flag=UC";
		return checkByUrl(url,param,"1");
	}

	function portCheck(portObj){
		var flag = "false";
		var portStr = portObj[0];
		for(var i = 1 ; i < portObj.length ; i ++){
			if(portStr.indexOf('#'+portObj[i])!=-1 && portObj[i] != ''){
			    if (portObj[i] != "") {
			    	$.alert("端口" + portObj[i] + "重复使用！");
			    } else {
			    	$.alert("请检测端口号是否有重复使用！");
			    }
				return flag = "true"
			}else{
				portStr =portStr+"#"+portObj[i];
			}
		}
		return flag;
	}
	function testPort () {
		var datas=
		{
			"from" : "uc",
			"port" : "3306"
		};
		$.ajax({
			type: "POST" ,
			url : "${ucconfigurl}?method=ajaxCheckPort",
			data: datas ,
			timeout : tiemOutTime,
			success : function (json){
				var jso=eval(json);
				alert(jso[0].res);

			},
			error: function (xmlHttpRequest, error) {
			   	disabelInput();
			   	getCtpTop().endProc();
               	$.alert($.i18n('uc.config.title.connectionerror.js'));
            }
		});
	}

	//上一步
	function backConfig(flag){
		var pageNumber = parseInt(flag);
		var backPage = pageNumber -1;
		if (backPage < 1) {
			backPage = 1;
		}
		nextPage(backPage);
	}

	function unlimitedF(){
	    if ($("#unlimited").attr("checked") == "checked") {
	    	$("#ucFileTransferSizeLimit").attr("oldVal",$("#ucFileTransferSizeLimit").val());
	    	$("#ucFileTransferSizeLimit").val("");
	    	$("#ucFileTransferSizeLimit").attr("disabled","disabled");
	    } else {
	    	var oldValu = $("#ucFileTransferSizeLimit").attr("oldVal");
	    	if (typeof(oldValu) != "undefined" && oldValu != "") {
	    		$("#ucFileTransferSizeLimit").val(oldValu);
	    	}
	    	$("#ucFileTransferSizeLimit").removeAttr('disabled');
	    }
	}

	function isLanIP(value)
	{
		var regexp = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
		var valid = regexp.test(value);
	    if(!valid){//首先必须 xxx.xxx.xxx.xxx 类型数字返false
	       return "false";
	    }
        return everyArray(value.split('.'));
	}

	function everyArray (array) {
		var returnFlag = "true";
		for (var i = 0 ; i < array.length ; i ++) {
			var num = array[i];
			if(num.length > 1 && num.charAt(0) === '0'){
				returnFlag =  'false';
				break;
			}else if(parseInt(num , 10) > 255){
				returnFlag =  'false';
				break;
            }
		}
		return returnFlag;
	}

	//检测版本号
	function checkVersion(jsonbean){
		var returnFlag = true;
		//检验版本
		if (jsonbean.optionModel.indexOf(version) != 0) {
			var versions = '';
			try{
				var ves = "V" + jsonbean.optionModel.substr(2,1) +"." + jsonbean.optionModel.substr(3,1);
				var sp = "";
				if (parseInt(jsonbean.optionModel.substr(4,2)) > 0) {
					sp = " SP" + parseInt(jsonbean.optionModel.substr(4,2));
				}
				var packages = parseInt(jsonbean.optionModel.substr(6,2));
				if (packages && packages > 0) {
					var titles = 'uc.config.title.pask' + packages +'.js';
					packages = " " + $.i18n(titles);
				} else {
					packages = " ";
				}
				versions = "<b> " + ves + sp + packages + "</b>";
			}catch(e){
				versions = '';
			}
			$.alert($.i18n('uc.config.title.version.js',versions,versions));
			var buthtml ="<input type='button' id='startOrStop' class='button-default-2' onclick='stopen()' value='"+$.i18n('uc.config.title.stop.js')+"'/>";
       	    $('#but').html(buthtml);
			disabelInput();
			returnFlag = false;
		}
		return returnFlag;
	}
	//恢复A8数据库保存
	function returnSaveA8(){
		//保存致信服务器的原始ip地址到A8的数据库
		var param = "&ucServerIp="+$("#ucServerIpI").val();
		param = encodeURI(param);
		$.ajax({
	        type: "POST",
	        url: "${ucconfigurl}?method=saveNextConfig1",
	        data: param,
	        async : false
	        });
	}
	var showTopConfigureC = 0;
	function showTopConfigure(){
		if(showTopConfigureC == 0){
			$('#ConContentTop').show();
		}else{
			$('#ConContentTop').hide();
		}
		showTopConfigureC == 0 ? showTopConfigureC = 1 : showTopConfigureC = 0;
	}
	function blurInput (obj) {
		$(obj).attr("blurNum","1");
	}

	function checkInternetSelectPort (innerType,type) {
		var taggerObj = null;
		if (innerType == "internet") {
			 taggerObj = $("#a8ServerInternetPort");
		} else {
			 taggerObj = $("#a8ServerLanPort");
		}
		if (taggerObj != null) {
	       if (type == 1) {
	    	  taggerObj.attr("oldHttpsValue",taggerObj.val());
	          var oldHttpValue = taggerObj.attr("oldHttpValue");
	          if (typeof(oldHttpValue) != 'undefined' && oldHttpValue != "" && oldHttpValue != null && oldHttpValue != 'null') {
	              taggerObj.val(oldHttpValue);
	          } else {
	        	  taggerObj.val("");
	          }
	       } else {
	    	  taggerObj.attr("oldHttpValue",taggerObj.val());
	          var oldHttpsValue = taggerObj.attr("oldHttpsValue");
	          if (typeof(oldHttpsValue) != 'undefined' && oldHttpsValue != "" && oldHttpsValue != null && oldHttpsValue != 'null') {
	        	  taggerObj.val(oldHttpsValue);
	          } else {
	        	  taggerObj.val("443");
	          }
	       }
		}

	}
	/* end */
</script>
<body scroll="auto" onload="queryConfiy1()">
<div class="comp" comp="type:'breadcrumb',code:'F16_UCcenter'"></div>
<c:set value="${ctp:hasPlugin('m1') == true ? '' : 'hidden'}" var="isShowM1server"/>
<c:set value="${bean.isupdate eq 'show' ? 'disabled' : ''}" var="isDisabled" />
<c:set value="${bean.isupdate eq 'show' ? 'true' : 'false'}" var="isonlyread"></c:set>
<form id="submitform" name="submitform" method="post" target="hiddenIframe">
<!-- config1 -->
<input  type="hidden" name="deploymentModeV" id="deploymentModeV" value=""/>
<input  type="hidden" name="isM1WithUCV" id="isM1WithUCV" value=""/><!-- kygz 增加M1与致信的关系判断的存值点-->
<input  type="hidden" name="seeyonnServerIpV" id="seeyonnServerIpV" value=""/>
<input  type="hidden" name="ucServerIpV" id="ucServerIpV" value=""/>
<input  type="hidden" name="seeyonnServerPortV" id="seeyonnServerPortV" value=""/>
<input  type="hidden" name="ucServerPortV" id="ucServerPortV" value=""/>
<input  type="hidden" name="seeyonM1ServerPortV" id="seeyonM1ServerPortV" value=""/>
<input  type="hidden" name="seeyonM1ServerIpV" id="seeyonM1ServerIpV" value=""/>
<!-- config2 -->
<input  type="hidden" name="clientVisitV" id="clientVisitV" value=""/>
<input  type="hidden" name="ucServerLanIpV" id="ucServerLanIpV" value=""/>
<input  type="hidden" name="ucServerInternetIpV" id="ucServerInternetIpV" value=""/>
<!-- config3 -->
<input  type="hidden" name="ucC2sPortV" id="ucC2sPortV" value=""/>
<input  type="hidden" name="ucFileTransferPortV" id="ucFileTransferPortV" value=""/>
<input  type="hidden" name="ucWebPortV" id="ucWebPortV" value=""/>
<!-- config4 -->
<!-- <input  type="hidden" name="ucFileSSLEncV" id="ucFileSSLEncV" value=""/> -->
<!-- config5 -->
<input  type="hidden" name="ucFileSavePathV" id="ucFileSavePathV" value=""/>
<input  type="hidden" name="ucFileTransferSizeLimitV" id="ucFileTransferSizeLimitV" value=""/>
<input  type="hidden" name="ucFileEncryptGradeV" id="ucFileEncryptGradeV" value=""/>
<input  type="hidden" name="ucFileOutTimeV" id="ucFileOutTimeV" value=""/>
<input  type="hidden" name="ucGroupOutTimeV" id="ucGroupOutTimeV" value=""/>
<!-- config6 -->
<input  type="hidden" name="a8ServerLanIpV" id="a8ServerLanIpV" value=""/>
<input  type="hidden" name="a8ServerInternetIpV" id="a8ServerInternetIpV" value=""/>

<input  type="hidden" name="szClientPwdTestV" id="szClientPwdTestV" value=""/>
<input  type="hidden" name="a8WebPortV" id="a8WebPortV" value=""/>
<input  type="hidden" name="clientVisitA8V" id="clientVisitA8V" value=""/>
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

			<!--第一页配置 开始-->
				<div class="ConfigPage" id="config0" style="display:none">
					<!--上部内容 开始-->
					<div class="ConTopArea">
						<div class="ConTitle1">${ctp:i18n('uc.config.title.ucstarttools.js') }</div>
						<div class="ConContent mb8">
							<div class="ConForm1">
								<dl style="height: 30px;line-height: 30px;">
									<dt><label>${ctp:i18n('uc.config.title.ucstate.js') }</label></dt>
									<dd style="height: 30px;line-height: 28px;">
                                        <span id="stateValue" style="max-width: 120px; overflow: hidden; vertical-align: middle; display: inline-block; white-space: nowrap; text-overflow: ellipsis;"> </span>&nbsp;&nbsp;
                                        <span id="but">
                                        <INPUT class="hidden" id="loading" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; FONT-WEIGHT: bolder; PADDING-BOTTOM: 0px; COLOR: #0066ff; BORDER-TOP-style: none; PADDING-TOP: 0px; FONT-FAMILY: Arial; BORDER-RIGHT-style: none; BORDER-LEFT-style: none; BACKGROUND-COLOR: white; BORDER-BOTTOM-style: none" size=46 name=chart>
                                        </span>
                                        </dd>

								</dl>
								<!-- <dl style="height: 30px;line-height: 30px; margin-left: -5em;">
									<dt><label>${ctp:i18n('uc.config.syntiemtitle.js') }</label></dt>
									<dd style="height: 30px;line-height: 28px;"><span id="synTime" style="max-width: 125px; overflow: hidden; vertical-align: middle; display: inline-block; white-space: nowrap; text-overflow: ellipsis;"></span>&nbsp;&nbsp;<input type="button" id="syn" class="button-default_emphasize" value="${ctp:i18n('uc.config.title.synchronization.button.js') }" onclick="ucsyn()"/></dd>
								</dl> -->
							</div>
						</div>
						<div class="ConTitle1">致信配置参数:</div>
						<div class="ConTitle3" id="ConContent3">协同和致信服务器部署方式：<label for="radio1" class="margin_r_10 hand">
														<input id="deploymentModeI" name="deploymentModeI" type="text" value=""/></label></div>
						<div class="ConContent" id="ConContentD">
							<div class="ConForm1">
								<dl>
									<dt><label>致信服务器IP地址：</label></dt>
									<dd><input type="text"  name="ucServerIpI" id="ucServerIpI" value="${ucServerIp}"/></dd>
								</dl>
								<dl style="margin-left:-5em;">
									<dt><label>致信服务器S2S端口：</label></dt>
									<dd><input type="text"  name="ucServerPortI" id="ucServerPortI" value="${ucServerPort}"/></dd>
								</dl>
								<dl>
									<dt><label>协同服务器IP地址：</label></dt>
									<dd><input type="text"  name="seeyonnServerIpI" id="seeyonnServerIpI" value="${seeyonnServerIp}"/></dd>
								</dl>
								<dl style="margin-left:-5em;">
									<dt><label>协同服务器S2S端口：</label></dt>
									<dd><input type="text"  name="seeyonnServerPortI" id="seeyonnServerPortI" value="${seeyonnServerPort}"/></dd>
								</dl>
								<dl id="showM1Host">
									<dt><label>${mxVersion}服务器IP地址：</label></dt>
									<dd><input type="text"  name="seeyonM1ServerIpI" id="seeyonM1ServerIpI" value="${seeyonnServerIp}"/></dd>
								</dl>
								<dl style="margin-left:-5em;" id="showM1Port">
									<dt><label>${mxVersion}服务器S2S端口(离线消息推送)：</label></dt>
									<dd><input type="text"  name="seeyonM1ServerPortI" id="seeyonM1ServerPortI" value="${seeyonnServerPort}"/></dd>
								</dl>
							</div>
						</div>

						<div class="ConTitle2">客户端登录致信服务器的方式：<span class="normalweight" id="loginzx">通过内网和外网同时访问模式</span></div>
							<div class="ConContent" id="ConContent1">
								<div class="ConForm1">
								<dl id="ucLan">
									<dt><label>致信服务器链接地址（内网）：</label></dt>
									<dd><input type="text"  name="ucServerLanIpI" id="ucServerLanIpI" value=''/></dd>
								</dl>
								<dl id="ucOuter" style="margin-left:-5em;">
									<dt><label>致信服务器链接地址（外网）：</label></dt>
									<dd><input type="text"  name="ucServerInternetIpI" id="ucServerInternetIpI" value=''/></dd>
								</dl>
								</div>
						</div>

						<div class="ConTitle2">客户端访问协同服务器的方式：<span class="normalweight" id="loginA8">通过内网和外网同时访问模式</span></div>
							<div class="ConContent" id="ConContent2">
								<div class="ConForm1">
								<dl id="seeyonLan">
									<dt><label>协同服务器链接地址（内网）：</label></dt>
									<dd><input type="text" style="width:200px;"  name="a8ServerLanIpI" id="a8ServerLanIpI" value=''/></dd>
								</dl>
								<dl id="seeyonOuter" style="margin-left:-5em;">
									<dt><label>协同服务器链接地址（外网）：</label></dt>
									<dd><input type="text" style="width:200px;"  name="a8ServerInternetIpI" id="a8ServerInternetIpI" value=''/></dd>
								</dl>
								</div>
						</div>

						<div class="ConTitle2" id="ConContent4">致信服务器文件存储路径：<span class="normalweight"><input type="text"  style="width: 400px;" name="ucFileSavePathI" id="ucFileSavePathI" value=''/></span></div>
						<div class="ConTitle2" id="ConContent6" style="margin-top:5px; display: none;">客户端登录致信服务器的验证方式：<span class="normalweight"><input type="text"  style="width: 400px;" name="szClientPwdTestI" id="szClientPwdTestI" value=''/></span></div>
						<div class="ConContent">
								<div class="ConForm1">

								</div>
						</div>
						<!--
						<div class="ConTitle2" id="ConContentTemp1">测试服务通讯状态：<a href="javascript:connectTest();">点击测试</a></div>
						<div class="ConContent">
								<div class="ConForm1">
								<dl style="width:100%">
									<dd id="ConContentTemp2" style="width:800px;"><input type="text" style="display:block;width:600px;margin-left:27px;color: red;"  name="ucTrafficStatus" id="ucTrafficStatus" value=''/> </dd>
								</dl>

								</div>
						</div>
						  -->
						<div class="ConTitle2" style="margin-bottom: 0px;margin-top: 5px;">高级配置:<a href="javascript:showTopConfigure();">点击查看</a></div>
							<div class="ConContent" id="ConContentTop" style="display:none">
								<div class="ConForm1">
									<dl>
									<dt><label>个人文件保存期限：</label></dt>
									<dd>
                                        <input type="text" id="ucFileOutTimeI" name="ucFileOutTimeI" disabled="disabled"  class="SomeClass" value=""/>
									</dd>
								</dl>
								<dl style="margin-left:-5em;">
											<dt><label>客户端访问端口：</label></dt>
											<dd><input type="text"  name="ucC2sPortI" id="ucC2sPortI" disabled="disabled" class="SomeClass" value=''/></dd>
										</dl>
								<dl>
									<dt><label>文件大小传输限制（M）：</label></dt>
									<dd><input type="text"  name="ucFileTransferSizeLimitI" disabled="disabled" class="SomeClass" id="ucFileTransferSizeLimitI" value=''/></dd>
								</dl>
										<dl style="margin-left:-5em;">
											<dt><label>WEB端访问端口：</label></dt>
											<dd><input type="text"  name="ucWebPortI" disabled="disabled" class="SomeClass" id="ucWebPortI" value=''/></dd>
										</dl>
										<dl>
									<dt><label>文件存储加密方式：</label></dt>
									<dd>
                                        <input  name="ucFileEncryptGradeI" id="ucFileEncryptGradeI" class="SomeClass" disabled="disabled" value=""/>
									</dd>
								</dl>
										<dl style="margin-left:-5em;">
											<dt><label>文件传输端口：</label></dt>
											<dd><input type="text"  name="ucFileTransferPortI" disabled="disabled" class="SomeClass" id="ucFileTransferPortI" value=''/></dd>
										</dl>
                                        <dl >
                                            <dt><label>群组自动解散时间：</label></dt>
                                            <dd><input type="text"  name="ucGroupOutTimeI" disabled="disabled" class="SomeClass" id="ucGroupOutTimeI" value=''/></dd>
                                        </dl>
								</div>
						</div>
					</div>
					<!--上部内容 结束-->
					<!--底部黑色区域 开始-->
					<div id ="config00" class="ConFooter">
					<!-- <button type="button" id="config00_update" class="button-default_emphasize" style="margin-top:-1.5px" onclick="setChannel();">修改通道</button>&nbsp;&nbsp;&nbsp;&nbsp; -->
					<button type="button" id="config00_update" class="button-default_emphasize" style="margin-top:-1.5px" onclick="loadConfig1();">修改配置</button></div>
					<!--底部黑色区域 结束-->
				</div>
				<!--第一页配置 结束-->

			 <div class="ConfigPage" id="config1" style="display:none">
					<div class="ConTopArea">
						<div class="ConTitle1 mb8">请选择协同服务和致信服务的部署方式：</div>
						<div class="ConContent">
							<div class="ConForm2">
								<dl>
									<dt>
										<div class="common_radio_box clearfix">
												<label for="radio1" class="margin_r_10 hand"><input name="deploymentMode" type="radio" value="0" checked="checked" />集成部署</label>
										</div>
									</dt>
									<dd>协同和致信服务部署在同一台服务器上。 </dd>
								</dl>
								<dl class="clear">
									<dt>
										<div class="common_radio_box clearfix">
												<label for="radio1" class="margin_r_10 hand"><input name="deploymentMode" type="radio" value="1" />分离部署</label>
										</div>
									</dt>
									<dd>协同和致信服务分别部署在不同服务器上。</dd>
								</dl>
							</div>
						</div>
						<div id="seeyonM1Relation">
						<!-- kygz 增加M1与致信的关系判断 -->
							<div class="ConTitle1 mb8">${mxVersion}服务的布署方式:</div>
							<div class="ConContent">
								<div class="ConForm2">
									<dl>
										<dt>
											<div class="common_radio_box clearfix">
													<label for="radio1" class="margin_r_10 hand"><input name="isM1WithUC" type="checkbox" value="" /></label>
											</div>
										</dt>
										<dd>${mxVersion}和致信服务部署在同一台服务器上。</dd>
									</dl>

								</div>
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="nextConfig('1');">下一步</button>&nbsp;&nbsp;<button type="button" class="button-default-2 button_class" onclick="cancelConfig('1');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>

			  <div class="ConfigPage" id="config2" style="display:none">
					<div class="ConTopArea">
						<div class="ConTitle1">请设置部署协同服务和致信服务的服务器的IP地址以及两服务器间相互访问（S2S)所使用的端口：</div>
						<div class="ConContent mb8">
							<div class="ConForm3">
								<dl>
									<dt><label>致信服务器IP地址：</label></dt>
									<dd><input type="text" onblur="blurInput(this)"  name="ucServerIp" id="ucServerIp" value="${ucServerIp}"/>(ip地址只能配置成*.*.*.*格式，不能配域名)</dd>
								</dl>
								<dl>
									<dt><label>致信服务器S2S端口：</label></dt>
									<dd><input type="text"  name="ucServerPort" id="ucServerPort" value="${ucServerPort}"/>(请输入1~65535之间的数字)</dd>
								</dl>
								<dl>
									<dt><label>协同服务器IP地址：</label></dt>
									<dd>
											<input type="text"  onblur="blurInput(this)" name="seeyonnServerIp" id="seeyonnServerIp" value="${seeyonnServerIp}"/>(ip地址只能配置成*.*.*.*格式，不能配域名)
									</dd>
								</dl>
								<dl>
									<dt><label>协同服务器S2S端口：</label></dt>
									<dd><input type="text"  name="seeyonnServerPort" id="seeyonnServerPort" value="${seeyonnServerPort}"/>(请输入1~65535之间的数字)</dd>
								</dl>
								<dl id="inputM1Host">
									<dt><label>${mxVersion}服务器IP地址：</label></dt>
									<dd>
											<input type="text"  onblur="blurInput(this)" name="seeyonM1ServerIp" id="seeyonM1ServerIp" value=""/>(ip地址只能配置成*.*.*.*格式，不能配域名)
									</dd>
								</dl>
								<dl id="inputM1Port">
									<dt><label>${mxVersion}服务器S2S端口：</label></dt>
									<dd><input type="text"  name="seeyonM1ServerPort" id="seeyonM1ServerPort" value=""/>(请输入1~65535之间的数字)</dd>
								</dl>
							</div>
							<div class="redtip">
								<p align=left>1：如果选择了“集成部署”，那么两个服务器的IP地址自动默认设置成127.0.0.1
								<br/>2：如果选择了”集成部署“，那么两个服务器的S2S端口不能相同
								<br/>3：如果选择了“分离部署”，服务器的IP地址均不能设置成为localhost或以127开头
								<br/>4：如果选择了“分离部署”，那么两个服务器的IP地址必须要能够相互访问
								<br/>5：如果选择了“分离部署”，协同服务器上如果启用了单机防火墙，请确认协同服务器的S2S端口是否开放
								<br/>6：如果选择了”分离部署“，致信服务器上如果启动了单机防火墙，请确认40011和致信服务器的S2S端口是否开放
								</p>
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="backConfig('2');">上一步</button>&nbsp;&nbsp;<button type="button" class="button-default_emphasize" onclick="nextConfig('2');">下一步</button>&nbsp;&nbsp;<button type="button" class=" button_class button-default-2" onclick="cancelConfig('2');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>

			  <div class="ConfigPage" id="config3" style="display:none;">
					<div class="ConTopArea">
						<div class="ConTitle1 mb8">请选择客户端登录致信服务器方式：</div>
						<div class="ConContent">
							<div class="ConForm2">
								<dl>
									<dt>
										<div class="common_radio_box clearfix">
												<input name="clientVisit" type="radio" value="1" checked="checked" /></label>
										</div>
									</dt>
									<dd>客户端仅通过内网地址或VPN登录致信服务器。</dd>
								</dl>
								<dl class="clear">
									<dt>
										<div class="common_radio_box clearfix">
											<input name="clientVisit" type="radio" value="2" /></label>
										</div>
									</dt>
									<dd>客户端仅通过外网地址登录致信服务器。</dd>
								</dl>
								<dl class="clear">
									<dt>
										<div class="common_radio_box clearfix">
												<input name="clientVisit" type="radio" value="3" /></label>
										</div>
									</dt>
									<dd>客户端可以通过内网地址或外网地址登录致信服务器。</dd>
								</dl>
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="backConfig('3');">上一步</button>&nbsp;&nbsp;<button type="button" class="button-default_emphasize" onclick="nextConfig('3');">下一步</button>&nbsp;&nbsp;<button class="button_class button-default-2" type="button" onclick="cancelConfig('3');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>

			  <div class="ConfigPage" id="config4" style="display:none">
					<div class="ConTopArea">
						<div class="ConTitle1">请设置客户端登录致信服务器的IP地址：</div>
						<div class="ConContent mb8">
							<div class="ConForm3">
							<div id="serverIp1" style="display:none;">
								<dl style="margin-top:10px;margin-left:80px;">
									<dt><label>致信服务器链接地址（内网）：</label></dt>
									<dd>
											<input type="text" onblur="blurInput(this)"  name="ucServerLanIp" id="ucServerLanIp" value=''/>
									</dd>
								</dl>
								</div>
								<div id="serverIp2" style="display:none;">
								<dl style="margin-top:10px;margin-left:80px;">
									<dt><label>致信服务器链接地址（外网）：</label></dt>
									<dd><input type="text" onblur="blurInput(this)"  name="ucServerInternetIp" id="ucServerInternetIp" value=''/></dd>
								</dl>
								</div>
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="backConfig('4');">上一步</button>&nbsp;&nbsp;<button type="button" class="button-default_emphasize" onclick="nextConfig('4');">下一步</button>&nbsp;&nbsp;<button class="button-default-2 button_class" type="button" onclick="cancelConfig('4');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>

			  <div class="ConfigPage" id="config5" style="display:none">
					<div class="ConTopArea">
						<div class="ConTitle1" style="margin-left:110px">请设置致信服务器的服务端口：</div>
						<div class="ConContent mb8">
							<div class="ConForm3">
								<dl>
									<dt><label>WEB访问服务端口：</label></dt>
									<dd><input type="text"  name="ucWebPort" id="ucWebPort" value=''/></dd>
								</dl>
								<dl>
									<dt><label>客户端访问端口：</label></dt>
									<dd>
											<input type="text"  name="ucC2sPort" id="ucC2sPort" value=''/>
									</dd>
								</dl>
								<dl>
									<dt><label>文件传输端口：</label></dt>
									<dd><input type="text"  name="ucFileTransferPort" id="ucFileTransferPort" value=''/></dd>
								</dl>
							</div>
							<div class="redtip" id="firewall3" >
								<p id="inTip">注：如果服务器上启用了单机防火墙，请开放上述端口。</p>
                                <p id="outTip">注：如果企业内部启用了网络防火墙，请开放上述端口。</p>
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="backConfig('5');">上一步</button>&nbsp;&nbsp;<button type="button" class="button-default_emphasize" onclick="nextConfig('5');">下一步</button>&nbsp;&nbsp;<button class="button-default-2 button_class" type="button" onclick="cancelConfig('5');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>

			  <div class="ConfigPage" id="config6" style="display:none">
					<div class="ConTopArea">
						<div class="ConTitle1 mb8">请设置客户端登录致信服务器的验证方式：</div>
						<div class="ConContent">
							<div class="ConForm2">
								<dl>
									<dt>
										<div class="common_radio_box clearfix">
												<label for="radio1" class="margin_r_10 hand"><input name="szClientPwdTest" type="radio" value="1" checked="checked" /></label>
										</div>
									</dt>
									<dd>致信服务器验证（推荐使用此模式）</dd>
								</dl>
								<dl class="clear">
									<dt>
										<div class="common_radio_box clearfix">
												<label for="radio1" class="margin_r_10 hand"><input name="szClientPwdTest" type="radio" value="2" /></label>
										</div>
									</dt>
									<dd>协同服务器验证</dd>
								</dl>
							</div>
							<div class="redtip">
								<p align=left>1：选择致信服务器验证模式，只验证用户名和密码<br/>2：如果选择协同服务器验证模式，需要验证协同服务器设置的所有登录方式（例如：身份验证狗、CA、域验证等）</p>
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="backConfig('6');">上一步</button>&nbsp;&nbsp;<button type="button" class="button-default_emphasize" onclick="nextConfig('6');">下一步</button>&nbsp;&nbsp;<button type="button" class="button-default-2 button_class" onclick="cancelConfig('6');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>

			  <div class="ConfigPage" id="config7" style="display:none">
					<div class="ConTopArea">
						<div class="ConTitle1">请设置致信服务器的文件管理参数：</div>
						<div class="ConContent">
							<div class="ConForm4">
								<dl>
									<dt><label>文件存储路径：</label></dt>
									<dd>
											<input type="text"  name="ucFileSavePath" id="ucFileSavePath" value=''/><font color="red">如:windows(D:/upload),linux(/upload)</font>
									</dd>
								</dl>
								<dl>
									<dt><label>文件大小传输限制</label></dt>
									<dd><input type="text"  name="ucFileTransferSizeLimit" id="ucFileTransferSizeLimit" value=''/>（1-500M）
										<div class="common_checkbox_box display_inline-block align_right">
											<label for="Checkbox1">
												<input name="unlimited" id="unlimited" type="checkbox" onchange="unlimitedF()" />不限制大小</label>
											</div>
									</dd>
								</dl>
								<dl>
									<dt><label>文件存储加密方式：</label></dt>
									<dd>
										<div class="halfwidth">
											<div class="common_selectbox_wrap">
												<select name="ucFileEncryptGrade" id="ucFileEncryptGrade">
							<option value="none">${ctp:i18n('uc.config.title.notencrypted.js') }</option>
							<option value="low">${ctp:i18n('uc.config.title.moderateencryption.js') }</option>
							<option value="high">${ctp:i18n('uc.config.title.depthencryption.js') }</option>
						</select>
											</div>
										</div>
									</dd>
								</dl>
								<dl>
									<dt><label>个人文件保存期限：</label></dt>
									<dd>
										<div class="halfwidth">
											<div class="common_selectbox_wrap">
												<select id="ucFileOutTime" name="ucFileOutTime">
				    		<option value="30" selected="selected" >${ctp:i18n('uc.config.title.30days.js')}</option>
				    		<option value="60" >${ctp:i18n('uc.config.title.60days.js') }</option>
				    		<option value="90" >${ctp:i18n('uc.config.title.90days.js') }</option>
				    		<option value="182">${ctp:i18n('uc.config.title.182days.js') }</option>
				    		<option value="365">${ctp:i18n('uc.config.title.365days.js') }</option>
				    		<option value="0"  >${ctp:i18n('uc.config.title.0days.js') }</option>
			    		</select>
											</div>
										</div>
									</dd>
								</dl>
                                <dl>
                                    <dt><label>群组自动解散时间：</label></dt>
                                    <dd>
                                        <div class="halfwidth">
                                            <div class="common_selectbox_wrap">
                                                <select id="ucGroupOutTime" name="ucGroupOutTime">
                            <option value="30" selected="selected" >${ctp:i18n('uc.config.title.30days.js')}</option>
                            <option value="60" >${ctp:i18n('uc.config.title.60days.js') }</option>
                            <option value="90" >${ctp:i18n('uc.config.title.90days.js') }</option>
                            <option value="182">${ctp:i18n('uc.config.title.182days.js') }</option>
                            <option value="365">${ctp:i18n('uc.config.title.365days.js') }</option>
                            <option value="0"  >${ctp:i18n('uc.config.title.0days.js') }</option>
                        </select>
                                            </div>
                                        </div>
                                    </dd>
                                </dl>
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="backConfig('6');">上一步</button>&nbsp;&nbsp;<button type="button"  class="button-default_emphasize" onclick="nextConfig('7');">下一步</button>&nbsp;&nbsp;<button  class="button-default-2" type="button" onclick="cancelConfig('7');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>



			  <div class="ConfigPage" id="config8" style="display:none;">
					<div class="ConTopArea">
						<div class="ConTitle1 mb8">请选择客户端访问协同服务器方式：</div>
						<div class="ConContent">
							<div class="ConForm2">
								<dl>
									<dt>
										<div class="common_radio_box clearfix">
												<input name="clientVisitA8" type="radio" value="1" checked="checked" /></label>
										</div>
									</dt>
									<dd>客户端仅通过内网地址或VPN访问协同服务器。</dd>
								</dl>
								<dl class="clear">
									<dt>
										<div class="common_radio_box clearfix">
												<input name="clientVisitA8" type="radio" value="2" /></label>
										</div>
									</dt>
									<dd>客户端仅通过外网地址访问协同服务器。</dd>
								</dl>
								<dl class="clear">
									<dt>
										<div class="common_radio_box clearfix">
												<input name="clientVisitA8" type="radio" value="3" /></label>
										</div>
									</dt>
									<dd>客户端可以通过内网地址或外网地址访问协同服务器。</dd>
								</dl>
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="backConfig('8');">上一步</button>&nbsp;&nbsp;<button type="button" class="button-default_emphasize" onclick="nextConfig('8');">下一步</button>&nbsp;&nbsp;<button class="button_class button-default-2" type="button" onclick="cancelConfig('8');">取&nbsp;&nbsp;&nbsp;消</button></div>
				</div>
			  <div class="ConfigPage" id="config9" style="display:none">
					<div class="ConTopArea">
						<div class="ConTitle1">请配置客户端访问协同服务器的链接地址：</div>
						<div class="ConContent mb8">
							<div class="ConForm3">
                                <div id="seeyonserverIp1" style="display:none;">
                                <dl style="margin-top: 10px;margin-left: 80px">
                                    <dt><label>协同服务内网访问方式：</label></dt>
                                    <dd><input type="radio"  name="a8ServerLanStyle" onclick="checkInternetSelectPort('lan',1)" value='0' checked="checked"/>&nbsp;<label>http</label> <input type="radio"  name="a8ServerLanStyle" onclick="checkInternetSelectPort('lan',2)" value='1'/>&nbsp;<label>https</label></dd>
                                </dl>
								<dl style="margin-top: 10px;margin-left: 80px">
									<dt><label>协同服务器的内网链接地址：</label></dt>
									<dd>
									    <input type="text"  name="a8ServerLanIp" onblur="blurInput(this)" id="a8ServerLanIp" value=''/>
									</dd>
								</dl>
                                <dl style="margin-top: 10px;margin-left: 80px">
                                    <dt><label>协同服务的内网端口：</label></dt>
                                    <dd>
                                       <input type="text"  name="a8ServerLanPort" id="a8ServerLanPort" value=''/>
                                    </dd>
                                </dl>
                                </div >
                                <div id="seeyonserverIp2" style="display:none;">
                                <dl style="margin-top: 10px;margin-left: 80px">
                                    <dt><label>协同服务外网访问方式：</label></dt>
                                    <dd><input type="radio"  name="a8ServerInternetStyle" onclick="checkInternetSelectPort('internet',1)" value='0' checked="checked"/>&nbsp;<label>http</label> <input type="radio"  onclick="checkInternetSelectPort('internet',2)" name="a8ServerInternetStyle" value='1'/>&nbsp;<label>https</label></dd>
                                </dl>
								<dl style="margin-top: 10px;margin-left: 80px">
									<dt><label>协同服务器的外网链接地址：</label></dt>
									<dd><input type="text"  name="a8ServerInternetIp" onblur="blurInput(this)" id="a8ServerInternetIp" value=''/> </dd>
								</dl>
                                <dl style="margin-top: 10px;margin-left: 80px">
                                    <dt><label>协同服务的外网端口：</label></dt>
                                    <dd><input type="text"  name="a8ServerInternetPort" id="a8ServerInternetPort" value=''/> </dd>
                                </dl>
                                </div>
							</div>
							<div class="redtip">
							</div>
						</div>
					</div>
					<div class="ConFooter"><button type="button" class="button-default_emphasize" onclick="backConfig('9');">上一步</button> &nbsp;&nbsp;<button type="button" class="button-default_emphasize" onclick="nextConfig('9');">保存设置</button>&nbsp;&nbsp;<button class="button-default-2" type="button" onclick="cancelConfig('9');">取&nbsp;&nbsp;&nbsp;消</button></div>
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