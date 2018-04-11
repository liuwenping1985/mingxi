<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
    <head>
        <meta charset="utf-8">
        <title>${pageTitle }</title>
        <%--
        <%@ include file="platview_header.jsp" %>
        <%@ include file="platview_header.jsp" %>
        --%>
        <%@ include file="platview_header.jsp" %>
        <script type="text/javascript">
        var isA8geniusMsg = false;
        var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
        </script>
        <script type="text/javascript" src="${path}/common/js/message/onlinemessage.js${ctp:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/common/platview/platview_pc.js${ctp:resSuffix()}"></script>
		<link href="${path}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico${ctp:resSuffix()}" type="image/x-icon" rel="icon"/>
    </head>
    <body class="body_main">
    
        <div class="index_head">
            <div class="left">
			<c:if test="${ctp:getSystemProperty('portal.favicon')!='U8'}">
                <img src="${path}/common/platview/img/logo.png" class="logo">
                <span>
                    致远技术平台
                </span>
				</c:if>
            </div>
           
            <div class="right head_right">
                <div class="right set">
                    <!-- 
                    <span class="set_span change_skin">
                        <img src="${path}/common/platview/img/set.png">
                    </span>
                     -->
                    <span class="set_span" onclick="gotoMain();">
                        <img src="${path}/common/platview/img/admin_top_index.png">
                    </span>
                    <span class="exit_span" onclick="stepout();">
                        <img src="${path}/common/platview/img/exit.png">
                    </span>
                </div>
                 <div class="banner_line right"></div>
                <div class="user right">
                    <span class="opacity70" style="cursor:hand;" onclick="stepbackplatform();">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;退出平台首页
                    </span>
                </div>
                <div class="user right">
                    <img src="${path}/common/platview/img/user.png" class="margin_r_5">
                     在线人数：
                    <span id="onlineNum_adm" class="opacity70">
                       0
                    </span>
                </div>
                
                
            </div>
        </div>
        <iframe id="bodyIframe" src="${path}/platview.do?method=body" class="iframe_body" width="100%" scrolling="auto" frameborder="0"></iframe>
        <div class="index_foot">
              <span>北京致远协创软件有限公司   版权所有</span>
        </div>
    </body>
</html>
