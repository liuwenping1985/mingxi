<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@include file="./officeAuth_js.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>office auth</title>

<script type="text/javascript">

</script>
<style>
	table td.input{
		padding-left:10px;
	}
	table td.input>input{
		border:1px solid #5191d1;
		height:24px!important;
		width:330px;
		padding-left:10px;
	}
	div.div_des>p{
		/*height:30px;*/
		line-height:26px;
	}

	div.div_des{
		padding-left:15px;
	}
	#form1{
		text-align:center;
	}
	#form1 table{
		display:inline-block;
		position:relative;
		right:75px;
	}
	.title{
		background-color:#ccedfc;
		height:36px;
		line-height:36px;
		color:#666;
		font-size:14px;
	
		padding-left:10px;
	}
	.float_left{
		float:left;
		
	}
	.float_right{
		float:right;
		margin-right:30px;
	}
	.div_des{
		font-size:14px;
		color:#333;
		padding-top:10px;
	}
	p.zhu{
		color:#ed5555;
		margin-top:20px
	}
	.content{
		height:320px;
		width:600px;
		over-flow:hidden;
		
		border:1px solid #eee;
	}
	#layout{
		overflow-y: scroll!important;
	}
	#center{
		border:none!important;
	}
</style>
</head>

<body>
<div id='layout' class="comp" comp="type:'layout'">

	<div class="comp" comp="type:'breadcrumb',code:'m3_mobileOfficeGuide'"></div>
	<div id="center"  class="layout_center" layout="border:true">
		<form id="form1" action="<c:url value='/m3/mobileOfficeGuide.do'/>?method=saveOfficeAuthInfo" method="post">
			<input type="hidden" id="entityId" name="entityId" value="<c:out value='${entityId}'/>" />
			</br>
			</br>
			<table>
					<tr>
						<td style="text-align:right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n("m3.mobileOfficeAuth.seriesNumber")} :</td>
						<td class="input" >
							<input id="key" name="key" value="<c:out value='${key}'/>" />
						</td>
					</tr>
					<tr style="height:46px;">
						<td style="text-align:right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n("m3.mobileOfficeAuth.members")} :</td>
						<td class="input">
							<input id="highSafeList" name="highSafeList" style="overflow-y:auto" value="<c:out value='${entityName}'/>" />
						</td>
					</tr>
			</table>
			<div style="text-align:center;padding-top:5px;">
				<a href="javascript:void(0)" id="btnok"
                         class="common_button common_button_emphasize">${ctp:i18n('common.button.ok.label')}</a>&nbsp;&nbsp;
                <a href="javascript:void(0)" id="btncancel"
                   class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
            </div>
		</form>
	</div>
	
	<div style="margin-top:203px;overflow:hidden;padding-bottom:30px" id="body">
		<div  style= "margin-left:30px;" class="float_left content">
			<div  class="title title1"><p class="p1">&nbsp;${ctp:i18n('m3.mobileOfficeAuth.use.process')}</p></div>
			<div class="div_des">
					<p class="p1">1.${ctp:i18n('m3.mobileOfficeAuth.process.explain.left.1')}</p> 
					<p class="p2">2.${ctp:i18n('m3.mobileOfficeAuth.process.explain.left.2')}</p> 
					<p class="p2">3.${ctp:i18n('m3.mobileOfficeAuth.process.explain.left.3')}</p> 
					<p class="p2">4.${ctp:i18n('m3.mobileOfficeAuth.process.explain.left.4')}</p> 
					<p class="p2 zhu">${ctp:i18n('m3.mobileOfficeAuth.process.explain.notes')}</p> 
					<p class="p2">1.${ctp:i18n('m3.mobileOfficeAuth.process.explain.notes.left.1')}</p> 
					<p class="p2">2.${ctp:i18n('m3.mobileOfficeAuth.process.explain.notes.left.2')}  </p> 
			</div>
		</div>
			<div  class="float_right content">
				<div class="title title2"><p class="p1">&nbsp;${ctp:i18n('m3.mobileOfficeAuth.pay.process')}</p></div>
				<div class="div_des">
				<p class="p2">1.${ctp:i18n('m3.mobileOfficeAuth.process.explain.right.1')} </p> 
				<p class="p2">2.${ctp:i18n('m3.mobileOfficeAuth.process.explain.right.2')}</p> 
				<p class="p2">3.${ctp:i18n('m3.mobileOfficeAuth.process.explain.right.3')}</p> 
				<p class="p2 zhu">${ctp:i18n('m3.mobileOfficeAuth.process.explain.notes')}</p> 
				<p class="p2">1.${ctp:i18n('m3.mobileOfficeAuth.process.explain.notes.right.1')}</p> 
				<p class="p2">2.${ctp:i18n('m3.mobileOfficeAuth.process.explain.notes.right.2')}</p> 
				</div>
			</div>
	</div>
</div>
	<script>
		$(".content").width((parseFloat($("#body").css("width"))-100)/2);
	
	</script>
</body>
</html>