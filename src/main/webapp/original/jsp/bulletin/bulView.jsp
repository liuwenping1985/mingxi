<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="bulHeader.jsp"%>
<html>
    <head>
        <meta charset="utf-8">
        <title>${bean.title }</title>
        <link rel="stylesheet" type="text/css" href="${path}/skin/default/bulletin.css${v3x:resSuffix()}" />
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/common.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/index.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/bulView.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}"></script>
        <v3x:attachmentDefine attachments="${attachments}" />
        <script type="text/javascript">
       		var bulId = "${param.bulId}";
        	var bulStyle = parseInt("${bulStyle}");
            var dataFormat_Type = "${bean.dataFormat}";
            var bul_ext4 = ${bean.ext4=='form'};
            var _spaceType = '${param.spaceType}';
            var _spaceId = '${param.spaceId}';
            var editType = "4,0";
			window.onload = function(){
				if(typeof(officeParams)!="undefined"){
					officeParams.editType = editType;
				}
			}
            <c:if test="${bean.ext2 != '1' || !bean.type.printFlag}">
            //屏蔽鼠标右键
            window.document.oncontextmenu=function(){
                return false;
            }
            //禁止用户选择并复制数据
            window.document.onselectstart=function(){
                return false;
            }
            </c:if>

            //返回首页（集团和单位空间下的处于发布状态下的公告）
            function toIndex(){
                if(('${bean.spaceType}' =='2' || '${bean.spaceType}' =='3') && '${bean.state}' =='30' && '${param.from}' != 'pigeonhole'){
                    var url = '${path}/bulData.do?method=bulIndex';
                    window.location.href = url;
                }
            }
        </script>
        <style>
            #content{border:none;}
            #content:hover{border:none;}
        </style>
        <script type="text/javascript">
        //表单签章相关,hw.js中需要用到
            var hwVer = '<%=DBstep.iMsgServer2000.Version("iWebSignature")%>';
            var webRoot = _ctxPath;
            var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
            var htmOcxUserName = $.ctx.CurrentUser.name;
        </script>
        <SCRIPT language=javascript for=SignatureControl event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
              //作用：重新获取签章位置
              if(EventId = 4 ){
                CalculatePosition();
                SignatureControl.EventResult = true;
              }
        </SCRIPT>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="common/office/js/hw.js${v3x:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="common/isignaturehtml/js/isignaturehtml.js${v3x:resSuffix()}" />"></script>
    </head>
    <body>
        <input type="hidden" id="subject" name="subject" value="${ctp:toHTML(bean.title)}">
        <div id="${bulStyle}">
            <c:if test="${bulStyle==0 }">
                <%@include file="bulStyle_standard.jsp" %>
            </c:if>
            <c:if test="${bulStyle==3 }">
                <%@include file="bulStyle_standard1.jsp" %>
            </c:if>
            <c:if test="${bulStyle==1 }">
                <%@include file="bulStyle_formal_1.jsp" %>
            </c:if>
            <c:if test="${bulStyle==2 }">
                <%@include file="bulStyle_formal_2.jsp" %>
            </c:if>
        </div>
    </body>
    <script type="text/javascript">
        //页面大小改变的时候移动ISignatureHTML签章对象，让其到达正确的位置
        window.onresize = function (){
            moveISignatureOnResize();
        }   
        loadSignatures('${bean.id}',false,false,false,null,false);
    </script>
</html>