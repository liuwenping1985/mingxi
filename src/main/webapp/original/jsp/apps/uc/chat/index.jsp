<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>${ctp:i18n('uc.title.js')}</title>
        <link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/uc/chat/css/uc.css${ctp:resSuffix()}' />">
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/shared.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc.message-debug.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript">
        	var connWin = getA8Top().window.opener;
        	
        	function clickAll(type) {
            	try {
	        		if (type == "msg") {
	        			document.getElementById('ucmain').contentWindow.$("#Uc_Msg").trigger("click");
	                } else if (type == "org") {
	                	document.getElementById('ucmain').contentWindow.$("#Uc_Org").trigger("click");
	                }
                } catch (e) {}
            }
            
            $(document).ready(function(){
                if ($.browser.msie) {
                    if ($.browser.version == '6.0' || $.browser.version == '7.0' || document.documentMode<8) {
                        var _l = $('#stadic_layout');
                        var _h = $('#stadic_layout_head');
                        var _b = $('#stadic_layout_body');
                        var body_h = _l.height() - _h.height();
                        _b.height(body_h);
                    }
                }

                /*$('#uc_online').click(function(){
                    if ($('#msgWindowMaxCount').attr('count') != '0') {
                        $(this).hide();
                        $('#uc_online_messages').show();
                    }
                });
                
                $('#uc_online_messages_close').click(function(){
                    $('#uc_online_messages').hide();
                    $('#uc_online').show();
                });*/

                window.onfocus = function() {
                	endUCActionTitle();
                }

                /*try {
	                var keys = connWin.noticeProperties.keys();
	            	for(var i = 0; i < keys.size(); i++){
	            		var key = keys.get(i);
	            		var notice = connWin.noticeProperties.get(key);
	            		showNotice(key, notice);
	            	}
	                connWin.noticeProperties.clear();
	
	                showMessage();
                } catch (e) {}*/
            });
        </script>
    </head>
    <body class="h100b over_hidden frount">

      <iframe src="/seeyon/uc/chat.do?method=main&from=${v3x:urlEncoder(param.from)}&showtype=${v3x:urlEncoder(param.showtype)}" id="ucmain" name="ucmain" frameborder="0" class="w100b h100b"></iframe>

        <%-- UC 消息盒子5.1版本去掉
        <div id="uc_online" class="uc_online clearfix hand fixed border_all hidden">
            <em class="uc_online_enable_ico margin_lr_10" id="msgWindowMaxImg"></em>
            <span class="uc_online_name">${ctp:i18n('uc.msgBox.js')}</span>
            <span class="uc_online_name margin_lr_10" id="msgWindowMaxCount" count="0"></span>
        </div>
        <div id="uc_online_messages" class="uc_online_messages clearfix fixed hidden">
            <div class="uc_online clearfix hand border_b">
                <em class="uc_online_enable_ico margin_lr_10"></em>
                <span class="uc_online_name">${ctp:i18n('uc.msgBox.js')}</span>
                <span class="uc_online_name margin_lr_10" id="msgWindowCount"></span>
            </div>
            <div id="uc_online_messages_items" class="uc_online_messages_items clearfix"></div>
            <div id='uc_online_messages_close' class="uc_online clearfix hand border_t align_center">
                <span class="ico16 arrow_2_b"></span>
            </div>
        </div>
        --%>
    </body>
</html>