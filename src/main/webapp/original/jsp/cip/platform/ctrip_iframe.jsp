<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/common.css"/>
</head>
<script type="text/javascript">
	$().ready(function(){
		$("ul li:first-child").removeClass("current");
		$("#tab1iframe").click(function(){
			divHide();
			$("iframe").hide();
			$("ul li").removeClass("current");
			$("ul li:eq(0)").addClass("current");
			$("#tab1_iframe").show();
			$("#tab1_iframe").attr("src","${path}/xc/xcController.do?method=setXCParameter&time="+Math.random());
		});
		$("#tab2iframe").click(function(){
			divHide();
			$("iframe").hide();
			$("ul li").removeClass("current");
			$("ul li:eq(1)").addClass("current");
			$("#tab2_iframe").show();
			$("#tab2_iframe").attr("src","${path}/xc/xcController.do?method=index&time="+Math.random());
		});
		$("#tab3iframe").click(function(){
			divHide();
			$("iframe").hide();
			$("ul li").removeClass("current");
			$("ul li:eq(2)").addClass("current");
			$("#tab3_iframe").show();
			$("#tab3_iframe").attr("src","${path}/xc/xcController.do?method=synRecord&time="+Math.random());
		});
		$("#tab4iframe").click(function(){
			divHide();
			$("iframe").hide();
			$("ul li").removeClass("current");
			$("ul li:eq(3)").addClass("current");
			$("#tab4_iframe").show();
			$("#tab4_iframe").attr("src","${path}/xc/xcController.do?method=child_num&time="+Math.random());
		});
		$("#tab5iframe").click(function(){
			divHide();
			$("iframe").hide();
			$("ul li").removeClass("current");
			$("ul li:eq(4)").addClass("current");
			$("#tab5_iframe").show();
			$("#tab5_iframe").attr("src","${path}/xc/member.do?method=syn_listByAccount&time="+Math.random());
		});
		function divHide(){//隐藏背景导图
			$("#bgimg").hide();
		}
	}); 
	function openD(enumKey){
		var dialog = getCtpTop().$.dialog({
            url:"${path}/cip/appIntegrationController.do?method=showExample&enumKey="+enumKey,
            width: 900,
            height: 500,
            title: "${ctp:i18n('cip.intenet.plat.sample')}",//示例查看
            buttons: [{
                text: "${ctp:i18n('common.button.cancel.label')}", //取消
                handler: function () {
                    dialog.close();
                }
            }]
    	});
	}
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
        <div id="tabs" style="height: 100%"  class="comp common_tabs"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<c:if test="${isGroupVer == true  && adminVer == false }">
					<li class="current"><a hidefocus="true" href="javascript:void(0)" 
						tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.xc.menu.100101')}">${ctp:i18n('cip.xc.menu.100101')}</span></a></li>
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab2_iframe" id="tab2iframe" ><span title="${ctp:i18n('cip.xc.persion.syn')}">${ctp:i18n('cip.xc.persion.syn')}</span></a></li>
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab3_iframe" id="tab3iframe"><span title="${ctp:i18n('cip.sync.param.config.log')}">${ctp:i18n('cip.sync.param.config.log')}</span></a></li>
				</c:if>
				<c:if test="${isGroupVer == true  && adminVer == true }">
					<li class="current"><a hidefocus="true" href="javascript:void(0)" 
						tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.xc.menu.100101')}">${ctp:i18n('cip.xc.menu.100101')}</span></a></li>
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab4_iframe" id="tab4iframe" ><span title="${ctp:i18n('cip.xc.zacc.ope')}">${ctp:i18n('cip.xc.zacc.ope')}</span></a></li>
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab5_iframe" id="tab5iframe"><span title="${ctp:i18n('cip.xc.authacc.ope')}">${ctp:i18n('cip.xc.authacc.ope')}</span></a></li>
				</c:if>
				
				<c:if test="${isGroupVer != true }">
					<li class="current"><a hidefocus="true" href="javascript:void(0)" 
						tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.xc.menu.100101')}">${ctp:i18n('cip.xc.menu.100101')}</span></a></li>
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab2_iframe" id="tab2iframe" ><span title="${ctp:i18n('cip.xc.persion.syn')}">${ctp:i18n('cip.xc.persion.syn')}</span></a></li>
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab3_iframe" id="tab3iframe"><span title="${ctp:i18n('cip.sync.param.config.log')}">${ctp:i18n('cip.sync.param.config.log')}</span></a></li>
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab4_iframe" id="tab4iframe" ><span title="${ctp:i18n('cip.xc.zacc.ope')}">${ctp:i18n('cip.xc.zacc.ope')}</span></a></li>
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab5_iframe" id="tab5iframe"><span title="${ctp:i18n('cip.xc.authacc.ope')}">${ctp:i18n('cip.xc.authacc.ope')}</span></a></li>
				</c:if>
			</ul>
		</div>
		<div id="bgimg" style="margin-top:10px;margin-left:80px;">
			 <div style="width: 170px;float: left;">
		        <div class="cip-block">
		            <div class="content backColor1" style ="cursor:auto;">
		                <div class="img-block">
		                    <div class="img backColor1"  style ="cursor:auto;">
		                        <i class="icon01"></i>
		                    </div>
		                </div>
		                <div class="name">
		                    <span>${ctp:i18n('cip.xc.tcp.ope')}</span>
		                </div>
		            </div>
		            <div class="operation backColor1"  onclick="javascript:openD(801);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div style="position: relative;width: 1px;height: 30px;border-left: 1px solid #000;margin: 18px auto;">
		            <img src="${path}/apps_res/cip/common/img/down.png" style="position: absolute;left: -6px;bottom: 0;z-index: 10;">
		        </div>
		        <div class="cip-block" style="margin-top:-12px;">
		            <div class="content backColor1"  onclick="$('#tab1iframe').trigger('click');">
		                <div class="img-block">
		                    <div class="img backColor1">
		                        <i class="icon02"></i>
		                    </div>
		                </div>
		                <div class="name">
		                    <span>${ctp:i18n('cip.xc.zacc.ope')}</span>
		                </div>
		            </div>
		            <div class="operation backColor1" onclick="javascript:openD(802);">
		                <div class="operation-block" >
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div style="position: relative;width: 1px;height: 30px;border-left: 1px solid #000;margin: 18px auto;">
		            <img src="${path}/apps_res/cip/common/img/down.png" style="position: absolute;left: -6px;bottom: 0;z-index: 10;">
		        </div>
		        <div class="cip-block" style="margin-top:-12px;">
		            <c:if test="${isGroupVer != true }">
						<div class="content backColor1" onclick="$('#tab4iframe').trigger('click');">
							<div class="img-block">
								<div class="img backColor1">
									<i class="icon03"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.xc.zacc.ope')}</span>
							</div>
						</div>
					</c:if>
					<c:if test="${isGroupVer == true }">
						<div class="content backColor1"  style ="cursor:auto;">
							<div class="img-block">
								<div class="img backColor1"  style ="cursor:auto;">
									<i class="icon03"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.xc.zacc.ope')}</span>
							</div>
						</div>
					</c:if>
		            <div class="operation backColor1" onclick="javascript:openD(803);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		    </div>
		    <div style="width: 50px;float: left;">
		        <div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 265px 0 0 10px;">
		            <img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
		        </div>
		        <div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 185px 0 0 10px;">
		            <img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
		        </div>
		    </div>
		    <div style="width: 170px;float: left;">
		        <div class="cip-block">
		            <div class="content backColor2" style ="cursor:auto;">
		                <div class="img-block">
		                    <div class="img backColor2" style ="cursor:auto;">
		                        <i class="icon11"  style="background-position:-56px -56px;"></i>
		                    </div>
		                </div>
		                <div class="name">
		                    <span>${ctp:i18n('cip.xc.syn.ope')}</span>
		                </div>
		            </div>
		            <div class="operation backColor2"  onclick="javascript:openD(804);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div style="position: relative;width: 1px;height: 30px;border-left: 1px solid #000;margin: 18px auto;">
		            <img src="${path}/apps_res/cip/common/img/down.png" style="position: absolute;left: -6px;bottom: 0;z-index: 10;">
		        </div>
		        <div class="cip-block" style="margin-top:-12px;">
		            <div class="content backColor2" onclick="$('#tab2iframe').trigger('click');">
		                <div class="img-block">
		                    <div class="img backColor2">
		                        <i class="icon12"></i>
		                    </div>
		                </div>
		                <div class="name">
		                    <span>${ctp:i18n('cip.xc.persion.syn')}</span>
		                </div>
		            </div>
		            <div class="operation backColor2"  onclick="javascript:openD(805);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div class="cip-block" style="margin-top: 55px;">
					<c:if test="${isGroupVer != true }">
						<div class="content backColor2"  onclick="$('#tab5iframe').trigger('click');">
							<div class="img-block">
								<div class="img backColor2">
									<i class="icon13"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.xc.authacc.ope')}</span>
							</div>
						</div>
					</c:if>
					<c:if test="${isGroupVer == true }">
						<div class="content backColor2" style ="cursor:auto;">
							<div class="img-block">
								<div class="img backColor2" style ="cursor:auto;">
									<i class="icon13"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.xc.authacc.ope')}</span>
							</div>
						</div>
					</c:if>
		            <div class="operation backColor2" onclick="javascript:openD(806);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		    </div>
		    <div style="width: 50px;float: left;margin-left:10px;">
		        <div style="position: relative;width: 10px;height: 1px;border-top: 1px solid #000;margin: 300px 0 0 10px;"></div>
		        <div style="position: relative;width: 1px;height: 100px;border-left: 1px solid #000;margin: -100px 0 0 20px;"></div>
		        <div style="position: relative;width: 10px;height: 1px;border-top: 1px solid #000;margin: -100px 0 0 20px;">
		            <img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
		        </div>
		    </div>
		    <div style="width: 170px;float: left;padding-top: 100px;">
		        <div class="cip-block">
		            <div class="content backColor3" style ="cursor:auto;">
		                <div class="img-block">
		                    <div class="img backColor3" style ="cursor:auto;">
		                        <i class="icon11" style="background-position:-56px -112px;"></i>
		                    </div>
		                </div>
		                <div class="name">
		                    <span>${ctp:i18n('cip.xc.auth.ope')}</span>
		                </div>
		            </div>
		            <div class="operation backColor3" onclick="javascript:openD(807);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div style="position: relative;width: 1px;height: 30px;border-left: 1px solid #000;margin: 18px auto;">
		            <img src="${path}/apps_res/cip/common/img/down.png" style="position: absolute;left: -6px;bottom: 0;z-index: 10;">
		        </div>
		        <div class="cip-block" style="margin-top:-12px;">
		            <div class="content backColor3" style ="cursor:auto;">
		                <div class="img-block">
		                    <div class="img backcColor3" style ="cursor:auto;">
		                        <i class="icon12"  style="background-position:-112px -28px;"></i>
		                    </div>
		                </div>
		                <div class="name">
		                    <span>${ctp:i18n('cip.xc.control.ope')}</span>
		                </div>
		            </div>
		            <div class="operation backColor3" onclick="javascript:openD(808);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		    </div>
		    <div style="width: 50px;float: left;margin-left:10px;">
		        <div style="position: relative;width: 10px;height: 1px;border-top: 1px solid #000;margin: 400px 0 0 10px;"></div>
		        <div style="position: relative;width: 1px;height: 200px;border-left: 1px solid #000;margin: -200px 0 0 20px;"></div>
		        <div style="position: relative;width: 10px;height: 1px;border-top: 1px solid #000;margin: -200px 0 0 20px;">
		            <img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
		        </div>
		    </div>
		    <div style="width: 170px;float: left;padding-top: 100px;">
		        <div class="cip-block">
		            <div class="content backColor4" style ="cursor:auto;">
		                <div class="img-block">
		                    <div class="img backColor4" style ="cursor:auto;">
		                        <i class="icon11"  style="background-position:-112px -112px;"></i>
		                    </div>
		                </div>
		                <div class="name">
		                    <span>${ctp:i18n('cip.xc.travel.req')}</span>
		                </div>
		            </div>
		            <div class="operation backColor4"  onclick="javascript:openD(810);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div style="position: relative;width: 1px;height: 30px;border-left: 1px solid #000;margin: 18px auto;">
		            <img src="${path}/apps_res/cip/common/img/down.png" style="position: absolute;left: -6px;bottom: 0;z-index: 10;">
		        </div>
		        <div class="cip-block" style="margin-top:-12px;">
		            <div class="content backColor4" style ="cursor:auto;">
		                <div class="img-block">
		                    <div class="img backColor4" style ="cursor:auto;">
		                        <i class="icon12" style="background-position:-140px 0px;"></i>
		                    </div>
		                </div>
		                <div class="name">
		                    <span>${ctp:i18n('cip.xc.travel.order')}</span>
		                </div>
		            </div>
		            <div class="operation backColor4" onclick="javascript:openD(809);">
		                <div class="operation-block">
		                    <div class="button">
		                        <span>${ctp:i18n('cip.intenet.set.case')}</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		    </div>

		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<c:if test="${isGroupVer == true  && adminVer == false }">
				<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no" src ="" border="0" 
					class="hidden"></iframe>
				<iframe id="tab2_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
					class="hidden"></iframe>
				<iframe id="tab3_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
					class="hidden"></iframe>
			</c:if>	
			<c:if test="${isGroupVer == true  && adminVer == true }">
				<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no" src ="" border="0" 
					class="hidden"></iframe>
				<iframe id="tab4_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
					class="hidden"></iframe>
				<iframe id="tab5_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
					class="hidden"></iframe>
			</c:if>	
			
			<c:if test="${isGroupVer != true }">	
				<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no" src ="" border="0" 
					class="hidden"></iframe>
				<iframe id="tab2_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
					class="hidden"></iframe>
				<iframe id="tab3_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
					class="hidden"></iframe>
				<iframe id="tab4_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
					class="hidden"></iframe>
				<iframe id="tab5_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
					class="hidden"></iframe>
			</c:if>		
		</div>
    </div>
	</div>
</body>
</html>