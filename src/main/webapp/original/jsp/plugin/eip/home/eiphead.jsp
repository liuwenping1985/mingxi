<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<c:if test="${fn:contains(columnCodes, 'pl_login')}">
<div class="head-t">
	<div class="h-t w">
		<div class="h-tl fl"><span>${departMentName}</span><a href="#">${userName}</a>欢迎您 <!--<a href="#" class="h-t-msg">[10]</a>--> <span id="portal_datetime"></span> <!-- <span>星期三</span> <span>下午 5:30</span> --></div>
		<div class="h-tr fr"><a href="#" class="h-tr-btn h-tr-set"></a> <a href="#" class="h-tr-btn h-tr-user"></a> <a href="#" id="portal_logout" class="h-tr-btn h-tr-logout"></a> <!--<a href="#" class="h-tr-sign">[注销]</a>--></div>
		<div class="clear"></div>

		<!----  导航设置  ---->
		<script>
			$(function(){
				$('.h-tr-set').click(function(event){
				 $('.h-sigin').toggle(); 
                  event.stopPropagation();
				})
				 $("body").bind("click", function(){
            $(".h-sigin").hide();
            })
			})
		</script>
		<div class="h-sigin">
			<div class="hsg-ts"></div>
			<ul>
				<li class="hsg-l1"><a href="javascript:void(0)" id="portal_updatePw">门户密码设置</a></li>
				<li class="hsg-l3"><a href="javascript:void(0)" id="portal_updateUserInfo">个人信息设置</a></li>
				<li class="hsg-l3"><a href="javascript:void(0)" id="portal_updateUserCustomSort">个性化设置</a></li>
			</ul>
		</div>
		<!----   end  ---->

	</div>
</div>
</c:if>