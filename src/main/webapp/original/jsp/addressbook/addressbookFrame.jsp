<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>${ctp:i18n('system.menuname.Contacts')}</title>
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/common.css${v3x:resSuffix()}" />" />
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/index.css${v3x:resSuffix()}" />" />
    <script src="<c:url value="/apps_res/addressbook/js/index.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript" language="javascript">
	    /**点击导航也签更换内容**/
	    function init(){
			$(".navBar_ul").on("click","li",function(){
				var currentid = $(".current").attr("id");
				var selectid = $(this).attr("id");
				if(currentid == selectid){
					return;
				}
				
			    $("#rightFrame").attr("src","/seeyon/addressbook.do?method=home&addressbookType="+selectid);
			    
				$(this).addClass("current");
				$(this).siblings().removeClass("current");
				$(this).children("em").addClass("navEm");
				$(this).children("span").css("opacity",1);
				$(this).css("background"," #002238");
				$(this).siblings().children("em").removeClass("navEm");
				$(this).siblings().children("span").css("opacity",0.6);
				$(this).siblings().css("background","#002b46");
			});
	    }
	    
	</script>
    <style>
         .stadic_right{
                float:right;
                width:100%;
                height:100%;
                position:absolute;
                z-index:100;
                overflow:hidden;
            }
            .stadic_right .stadic_content{
                margin-left:97px;
                height:100%;
                overflow:hidden;
            }
            .stadic_left{
                width:97px; 
                float:left; 
                position:absolute;
                height:100%;
                z-index:300;
            }
    </style>
</head>
<body class="h100b over_hidden" onload="init();">
	       <div class="stadic_layout">
            <div class="stadic_right">
                <div class="stadic_content">
                    <!--右边区域，分别显示联系人，组织架构，私人，个人,系统组通讯录.默认显示联系人  -->
                    <iframe width="100%" height="100%" id="rightFrame" name="rightFrame" src="/seeyon/addressbook.do?method=home&addressbookType=1" frameborder="0"></iframe>
                </div>
            </div>
            <div class="stadic_left">
            <!-- 左边区域，通讯录菜单 -->
				<div class="container overflow">
					<div class="leftBar  left ">
						<div class="header  " >
							<a class="headerImg" href="#" onclick="$('#1').click();">
								<img src="<c:url value="/apps_res/addressbook/images/concatImg.png${v3x:resSuffix()}" />" width="41" height="43"/>
							</a>
						</div>
						<div class="navList ht">
							<ul class="navBar_ul">
								<li class="navLi cont_li "  id="0"><em ></em><span>
									<span style="height: auto;line-height: 20px;vertical-align: middle;">${ctp:i18n('online.addressBook.contact')}</span>
								</span></li>
								<li class="navLi  org_li current"  id="1"><em class="navEm"></em><span>
									<span style="height: auto;line-height: 20px;vertical-align: middle;">${ctp:i18n('online.addressBook.structure')}</span></span></li>
								<li class="navLi private_li"  id="2"><em ></em><span>
									<span style="height: auto;line-height: 20px;vertical-align: middle;">${ctp:i18n('online.addressBook.private2')}</span>
								</span></li>
								<li class="navLi personal_li"  id="4"><em ></em><span>
									<span style="height: auto;line-height: 20px;vertical-align: middle;">${ctp:i18n('addressbook.team.personal.label2')}</span>
								</span></li>
								<li class="navLi system_li"  id="3"><em></em><span>
									<span style="height: auto;line-height: 20px;vertical-align: middle;">${ctp:i18n('addressbook.team.system.label2')}</span></span></li>
							</ul>
						</div>
					</div>
				</div>
            </div>
        </div>
        
</body>
</html>