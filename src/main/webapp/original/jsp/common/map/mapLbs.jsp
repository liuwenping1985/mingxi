<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@include file = "../../common/common.jsp" %>
<%@include file = "./mapLbsBase.jsp" %>
<%@include file = "./mapLbs_js.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>


<script type="text/javascript">

</script> 
</head>
  <body >
		<div id = "northDiv" >
  			<table >
  				<tr>
  					<td>
  					<div class="common_txtbox_wrap">
                        <input id="searchText" type="text" style="width:100px" >
                    </div>
  					</td>
  					<td>
  					<a class="common_button common_button_gray" href="javascript:void(0)" id = "fixedPosition">${ctp:i18n('cmp.lbs.fixedPosition')}</a>
					<a class="common_button common_button_gray" href="javascript:void(0)" id = "removeMarker">${ctp:i18n('cmp.lbs.removeMarker')}</a>
					</td>
  				</tr>
  			</table>
			
		</div>
		<div id = "iCenter" style = "width:695px;height:487px;"></div> 

 
  </body>
</html>