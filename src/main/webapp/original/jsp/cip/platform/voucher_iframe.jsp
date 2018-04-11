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
			$("#tab1_iframe").attr("src","${path}/voucher/accountCfgController.do?method=showAccountCgrList&time="+Math.random());
		});
		$("#tab2iframe").click(function(){
			divHide();
			$("#tab2_iframe").attr("src","${path}/voucher/archivesMapperController.do?method=showArchivesMapperList&time="+Math.random());
		});
		$("#tab3iframe").click(function(){
			divHide();
			$("#tab3_iframe").attr("src","${path}/voucher/deptMapperController.do?method=showDeptMapperList&time="+Math.random());
		});
		$("#tab4iframe").click(function(){
			divHide();
			$("#tab4_iframe").attr("src","${path}/voucher/memberMapperController.do?method=showMemberMapperList&time="+Math.random());
		});	
		$("#tab5iframe").click(function(){
			divHide();
			$("#tab5_iframe").attr("src","${path}/voucher/documnentationMapperController.do?method=showDocumnentationMapperList&time="+Math.random());
		});	
		$("#tab6iframe").click(function(){
			divHide();
			$("#tab6_iframe").attr("src","${path}/voucher/subjectMapperController.do?method=showSubjectMapperList&time="+Math.random());
		});	
		function divHide(){//隐藏背景导图
			$("#bgimg").hide();
		}

		$("#bgimg").css({"height":$(window).height() - $("#tabs_head").height() + 'px'});
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
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li><a hidefocus="true" href="javascript:void(0)" 
					tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.vouchar.zt.map')}">${ctp:i18n('cip.vouchar.zt.map')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab3_iframe" id="tab3iframe"><span title="${ctp:i18n('cip.vouchar.dept.map')}">${ctp:i18n('cip.vouchar.dept.map')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab4_iframe" id="tab4iframe"><span title="${ctp:i18n('cip.vouchar.pers.map')}">${ctp:i18n('cip.vouchar.pers.map')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab6_iframe" id="tab6iframe"><span title="${ctp:i18n('cip.vouchar.km.map')}">${ctp:i18n('cip.vouchar.km.map')}</span></a></li>	
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="tab2iframe" ><span title="${ctp:i18n('cip.vouchar.file.map')}">${ctp:i18n('cip.vouchar.file.map')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab5_iframe" id="tab5iframe"><span title="${ctp:i18n('cip.vouchar.bills.map')}">${ctp:i18n('cip.vouchar.bills.map')}</span></a></li>
			</ul>
		</div>
		<div id="bgimg" style="margin-left:100px;overflow:auto;">
			 <div style="width: 200px;float: left;margin-top: 280px;">
				<div class="cip-block">
					<div class="content backColor1"  onclick="$('#tab1iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor1">
								<i class="icon02" style="background-position:-140px -140px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.intenet.plat.zt')}</span>
						</div>
					</div>
					<div class="operation backColor1" onclick="javascript:openD(101);">
						<div class="operation-block" >
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div style="width: 50px;float: left;margin-left:-30px;">
				<div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 350px 0 0 10px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
			</div>
			<div style="width: 200px;float: left;margin-top: 280px;">
				<div class="cip-block">
					<div class="content backColor2"  onclick="$('#tab2iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor2">
								<i class="icon12" style="background-position:-0px -168px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.vouchar.file.map')}</span>
						</div>
					</div>
					<div class="operation backColor2" onclick="javascript:openD(102);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div style="width: 50px;height:450px;float: left;position: relative;margin-left:-20px;">
				<div style="position: absolute;width: 1px;height: 450px;border-left: 1px solid #000;top: 100px;left: 25px;"></div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 100px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 220px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 380px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 550px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 0;top: 350px;">
					<img src="${path}/apps_res/cip/common/img/left.png" style="position: absolute;top: -6px;left: 0;z-index: 10;">
				</div>
			</div>
			<div style="width: 200px;float: left;margin-left:10px;">
				<div class="cip-block">
					<div class="content backColor3" onclick="$('#tab3iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor3">
								<i class="icon11" style="background-position:-56px -140px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.vouchar.dept.map')}</span>
						</div>
					</div>
					<div class="operation backColor3" onclick="javascript:openD(104);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 20px;">
					<div class="content backColor3"  onclick="$('#tab4iframe').trigger('click');">
						<div class="img-block">
							<div class="img backcColor3">
								<i class="icon12" style="background-position:-84px -140px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.vouchar.pers.map')}</span>
						</div>
					</div>
					<div class="operation backColor3" onclick="javascript:openD(106);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 20px;">
					<div class="content backColor3"  onclick="$('#tab5iframe').trigger('click');">
						<div class="img-block">
							<div class="img backcColor3">
								<i class="icon12" style="background-position:-112px -140px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.vouchar.bills.map')}</span>
						</div>
					</div>
					<div class="operation backColor3" onclick="javascript:openD(103);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 20px;">
					<div class="content backColor3"  onclick="$('#tab6iframe').trigger('click');">
						<div class="img-block">
							<div class="img backcColor3">
								<i class="icon12" style="background-position:-140px -168px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.vouchar.km.map')}</span>
						</div>
					</div>
					<div class="operation backColor3" onclick="javascript:openD(105);">
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
			<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no" src ="" border="0" 
				class="hidden"></iframe>
			<iframe id="tab2_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
				class="hidden"></iframe>
			<iframe id="tab3_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
				class="hidden"></iframe>
			<iframe id="tab4_iframe" width="100%" height="100%" frameborder="no" src="" border="0" 
				class="hidden"></iframe>
			<iframe id="tab5_iframe" width="100%" height="100%" frameborder="no" src="" border="0" 
				class="hidden"></iframe>
			<iframe id="tab6_iframe" width="100%" height="100%" frameborder="no" src="" border="0" 
				class="hidden"></iframe>		
		</div>
    </div>
	</div>
</body>
</html>