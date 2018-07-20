<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>统计标签页面</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">

   var defualtTag = "${tagCode}"

    $(function() {
        if(!defualtTag){
            defualtTag = "rec_send_stat";
        }
        _setTagSelect(defualtTag);
        
        _initUrlBound();//绑定事件
    });

    /**
     * URL绑定
     */
    function _initUrlBound() {
        $("._tag_item").each(function(){
            $(this).click(function(){
                _setTagSelect($(this).attr("tagCode"));
            });
        })
    }
    
    /**
     *切换默认tag标签
     */
    function _setTagSelect(tagCode){
        $("._tag_item").each(function(){
            
            var $tempTag = $(this);
            $tempTag.removeClass("current");
            var tempTagCode = $tempTag.attr("tagCode");
            if(tagCode == tempTagCode){
                $tempTag.addClass("current");
                var bindURL = $tempTag.attr("_bindURl");
                $("#tab_iframe").attr("src", bindURL); 
            }
        });
    }
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout',border:false">
		<div class="layout_north page_color" layout="height:33,sprit:false,border:false">
 			<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F20_stat'"></div>
			<div class="common_tabs clearfix">
				<ul class="left">
<%-- 					<li tagCode="rec_send_serarch" class="current _tag_item" _bindURl="${path}/edocStat.do?method=initRecSendSearch">
					    <a hidefocus="true" href="javascript:void(0)">${ctp:i18n('edoc.stat.query.label.title')}</a>收发查询
					</li> --%>
					<li tagCode="rec_send_stat" class="current _tag_item" _bindURl="${path}/edocStatNew.do?method=edocStat&isSignReport=false">
					    <a hidefocus="true" href="javascript:void(0)">${ctp:i18n('edoc.stat.label.title')}</a><%-- 收发统计 --%>
					</li>
					<li tagCode="send_register" class="_tag_item" _bindURl="${path}/edocController.do?method=listSendEdocSearchReultByDocManager&listType=stat&isSignReport=false">
					    <a hidefocus="true" href="javascript:void(0)">${ctp:i18n('edoc.send.register')}</a><%-- 发文登记薄 --%>
					</li>
					<li tagCode="rec_register" class="_tag_item" _bindURl="${path}/edocController.do?method=listRecEdocSearchReultByDocManager&listType=stat&isSignReport=false">
					    <a hidefocus="true" href="javascript:void(0)">${ctp:i18n('edoc.rec.register')}</a><%-- 收文登记簿 --%>
					</li>
					<li tagCode="sign_register" class="_tag_item" _bindURl="${path}/edocController.do?method=listSendEdocSearchReultByDocManager&listType=stat&isSignReport=true">
					    <a hidefocus="true" href="javascript:void(0)">${ctp:i18n('edoc.signandreport.register')}</a><%-- 签报登记薄 --%>
					</li>
				    <li tagCode="sign_count" class="_tag_item" _bindURl="${path}/edocStatNew.do?method=govdocStat&statType=v3x_edoc_sign_count">
					    <a hidefocus="true" href="javascript:void(0)">签收统计</a><%-- 签收统计 --%>
					</li>
					 <li tagCode="work_count" class="_tag_item" _bindURl="${path}/edocStatNew.do?method=govdocStat&statType=work_count">
					    <a hidefocus="true" href="javascript:void(0)">工作统计</a><%-- 工作统计 --%>
					</li>
				</ul>
			</div>
		</div>
		<div class="layout_center" id="center" style="overflow: hidden;" layout="border:false">
			<iframe id="tab_iframe" width="100%" height="100%" frameborder="0"></iframe>
		</div>
	</div>
</body>
</html>