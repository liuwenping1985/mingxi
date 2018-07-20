<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@include file="./orgBindNum.js.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>org bind num</title>

<script type="text/javascript">
$(document).ready(function(){
		init();
		$("#button_area").hide();
		$("#btnok").click(function(){
			confirm();
		});
		$("#btncancel").click(function(){
			$("#button_area").hide();
			$("#orgbindNum").attr("disabled",true);
			cancel();
		});
		$("#toolbar").toolbar({
		    toolbar: [{
		    
		      id: "edit",
		      name: "${ctp:i18n('common.button.modify.label')}",
		      className: "ico16 editor_16",
		      click:function(){
		    	  $("#button_area").show();
		    	  $("#orgbindNum").attr("disabled",false);
		      }
		    }]
		    });
});
</script>
<style type="text/css">
	span{margin:0 auto;}
	#info{width: 100%;text-align:center;padding-top: 42px}
</style>
</head>

<body>
<div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" ></div>
        <div class="layout_north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
    
	    <div id="center"  class="layout_center" layout="border:true">
		    <form id="form1" action="<c:url value='/m1/mClientBindController.do'/>?method=setBindNum" method="post">
				<div id="info">
				<span id="bindnum">
					<fmt:message key="label.mm.orgbindnum.bindnum" bundle="${mobileManageBundle}"/>: 
					<input type="text" id="orgbindNum" name="bindNum" value="${bindNum}" size="5" disabled="disabled" maxlength="2">&nbsp;&nbsp;&nbsp;&nbsp;
					<i><font color="red">*</font><fmt:message key="label.mm.orgbindnum.bindmax" bundle="${mobileManageBundle}"/></i>
				</span>
				</div>
			</form>
			<div id="btnArea" class="stadic_layout_footer">
                 <div id="button_area" align="center" class="page_color button_container border_t padding_t_5" style="height:35px;">
                     <table  >
                         <tbody>
                             <tr>
                                 <td >
                                     <a href="javascript:void(0)" id="btnok"
                                         class="common_button common_button_gray">${ctp:i18n('common.button.ok.label')}</a>&nbsp;&nbsp;
                                     <a href="javascript:void(0)" id="btncancel"
                                         class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                                 </td>
                             </tr>
                         </tbody>
                     </table>
                 </div>
			 </div>
		</div>
	</div>
</body>
</html>