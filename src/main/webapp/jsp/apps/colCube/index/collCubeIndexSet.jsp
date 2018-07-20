<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/colCube/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Insert title here</title>
<script type="text/javascript">
  $().ready(function() {
	$("#allCollCube").click(function(){
		if($("input[name='collCube']").attr("checked")){
			$("input[name='collCube']").attr("checked",true); 
		}else{
			$("input[name='collCube']").attr("checked",false);
		}
	});
	$("#allColl360").click(function(){
		if($("input[name='coll360']").attr("checked")){
			$("input[name='coll360']").attr("checked",true); 
		}else{
			$("input[name='coll360']").attr("checked",false);
		}
	});
    $("#btn1").click(function() {
    	window.location.href = url_colCube_collCubeAuth;
    });
    $("#btn2").click(function() {
    	window.location=url_collCubeIndex_collCubeIndex;
    });
    $("#indexSetSave").click(function() {
    	var isCubeChecked = false;
    	var is360Checked = false;
    	$("input[name='collCube']:not([id='allCollCube'])").each(function(){
    		if(this.checked){
    			isCubeChecked = true;
    			return false;
    		}
    	});
    	$("input[name='coll360']:not([id='allColl360'])").each(function(){
    		if(this.checked){
    			is360Checked = true;
    			return false;
    		}
    	});
    	var productId="${ctp:getSystemProperty('system.ProductId')}";
    	if(productId==="3"||productId==="4"){
    		//g6版本没有协同立方,不需要校验
    		isCubeChecked=true;
    	}
    	if(isCubeChecked && is360Checked){
    		var confirm = $.confirm({
    	        'msg' : "${ctp:i18n('colCube.index.set.save')}",
    	        cancel_fn : function() {
    	        },
    	        ok_fn : function(){
		    		$("#indexSet").submit();
    	        }
    	      });
    	}else{
    		if(productId==='3'||productId==='4'){
    			$.alert("${ctp:i18n('colCube.index.360.mustChoose')}");
    		}else{
    			$.alert("${ctp:i18n('colCube.index.set.mustChoose')}");
    			//alert("协同立方与协同360°的指标项都必须选择!");
    		}
    	}
    });
  });
</script>
</head>
<body class="h100b over_hidden page_color">
    <div class="stadic_layout ">
        <div class="stadic_layout_head stadic_head_height clearfix">
            <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F08_cubeAuth'"></div>
	         <div id="tabs2_head" class="common_tabs clearfix padding_t_5 padding_l_5">
		            <li><a id="btn1" class="no_b_border" href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n('colCube.common.crumbs.authSet')}</span></a></li>
		            <li class="current"><a id="btn3" href="javascript:void(0)" tgt="tab3_div"><span>${ctp:i18n('colCube.index.set')}</span></a></li>
		        <c:if test="${!isG6}">
		            <li><a id="btn2" class="last_tab no_b_border" href="javascript:void(0)" tgt="tab2_div" style="max-width: 100px;"><span>${ctp:i18n('colCube.common.crumbs.indexSet')}</span></a></li>
		        </c:if>
		        </ul>
		    </div>
       </div>
        <div class="stadic_layout_body stadic_body_top_bottom bg_color_white border_all" style="margin-top:1px">
        	
        	<form id="indexSet" method="post" action="${path}/colCube/collCubeIndex.do?method=updateIndexSet">
            	<div align="center">
            	<table frame="border" rules="all" cellSpacing="0" cellpadding="0" style="width:500px;margin-top: 30px">
				  <tr style="height: 30px">
				   <c:if test="${!isG6}">
				    <th align="left" style="padding-left: 10px"><label class="margin_t_5 hand display_block" for="Checkbox5">
				    	<input class="radio_com" type="checkbox" name="collCube" id="allCollCube"/>${ctp:i18n('colCube.index.set.cube')}</label></th>
				   </c:if>
				    <th align="left" style="padding-left: 10px"><label class="margin_t_5 hand display_block" for="Checkbox5">
				    	<input class="radio_com" type="checkbox" name="coll360" id="allColl360"/>${ctp:i18n('colCube.index.set.360')}</label></th>
				  </tr>
				  <tr>
				   <c:if test="${!isG6}">
				    <td align="left" style="padding-left: 10px">
				    	<div style="height: 305px">
				    	<table id ="cubeSetTable">
				    		<c:forEach  var="cubeIndexSet" items="${cubeIndexSetList}">
				    			<c:if test="${cubeIndexSet.type ==1 }">
				    				<c:choose>
										<c:when test="${cubeIndexSet.display ==1 }">
											<tr style="height: 28px"><td><label class="margin_t_5 hand display_block" for="Checkbox5">
												<input class="radio_com" type="checkbox" name="collCube" value="${cubeIndexSet.id}" checked="checked"/></label></td><td>${cubeIndexSet.description}</td></tr>
										</c:when>
										<c:otherwise>
											<tr style="height: 28px"><td><label class="margin_t_5 hand display_block" for="Checkbox5">
												<input class="radio_com" type="checkbox" name="collCube" value="${cubeIndexSet.id}"/></label></td><td>${cubeIndexSet.description}</td></tr>
										</c:otherwise>
									</c:choose>
				    			</c:if>
				    		</c:forEach>
				    	</table>
				    	</div>
				    </td>
				    </c:if>
				    <td align="left" style="padding-left: 10px">
				    	<div style="height: 305px">
				    	<table>
				    		<c:forEach  var="cubeIndexSet" items="${cubeIndexSetList}">
				    			<c:if test="${cubeIndexSet.type ==2 }">
				    				<c:choose>
										<c:when test="${cubeIndexSet.display ==1 }">
											<tr style="height: 28px"><td><label class="margin_t_5 hand display_block" for="Checkbox5">
												<input class="radio_com" type="checkbox" name="coll360" checked="checked" value="${cubeIndexSet.id}"/></label></td><td>${cubeIndexSet.description}</td></tr>
										</c:when>
										<c:otherwise>
											<tr style="height: 28px"><td><label class="margin_t_5 hand display_block" for="Checkbox5">
												<input class="radio_com" type="checkbox" name="coll360" value="${cubeIndexSet.id}"/></label></td><td>${cubeIndexSet.description}</td></tr>
										</c:otherwise>
									</c:choose>
				    			</c:if>
				    		</c:forEach>
				    	</table>
				    	</div>
				    </td>
				  </tr>
				</table>
				</div>
            </form>
            <div align="center" style="margin-top: 20px">
            	<c:if test="${isG6}">
	        		<p style="width: 480px;text-align: left" >${ctp:i18n('colCube.index.set.choose.g6')}</p>
	        	</c:if>
	        	<c:if test="${!isG6}">
	        		<p style="width: 480px;text-align: left" >${ctp:i18n('colCube.index.set.choose')}</p>
	        	</c:if>
	        </div>
        </div>
        <div class="stadic_layout_footer stadic_footer_height align_center">
        	<a id="indexSetSave" class="common_button common_button_gray" style="margin-top: 5px" href="javascript:void(0)">${ctp:i18n('colCube.indexSetup.button.save')}</a>
        </div>
    </div>  
</body>
</html>