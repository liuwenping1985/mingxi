<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>org bind num</title>

<script type="text/javascript">
$(document).ready(function(){
	init();
	
	
	$("#button_area").hide();
	$("#supplierS").attr("disabled",true);
	$('#btnok').click(function(){
		confirm(); 
	});
	$('#btncancel').click(function(){
		$("#button_area").hide();
		cancel();
	});
	$("#toolbar").toolbar({
	    toolbar: [{
	    
	      id: "edit",
	      name: "${ctp:i18n('common.button.modify.label')}",
	      className: "ico16 editor_16",
	      click:function(){
	    	  $("#button_area").show();
	    	  $("#supplierS").attr("disabled",false);
	      }
	    }]
	    });
});
function init() {
	var type ="${type}";
	$("#supplierS").attr("style","width:200px");
	if(type == 1) {
		$("#baidu").attr("selected","selected");
	} else if (type ==3){
		$("#google").attr("selected","selected");
	} else {
		$("#gaode").attr("selected","selected");
	}
}
function confirm() {
	document.getElementById("form1").submit();
}
function cancel() {
	window.location = "<c:url value='/m1/lbsSupplierController.do'/>?method=index";
}
</script>
<style type="text/css">
	#tableD { MARGIN-RIGHT: auto; MARGIN-LEFT: auto;MARGIN-TOP:20px;}

</style>
</head>

<body>
<div id='layout' class="comp" comp="type:'layout'">
 <div class="comp" comp="type:'breadcrumb',code:'M1_lbsSupplier'"></div> 
        <div class="layout_north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
    
	    <div id="center"  class="stadic_layout_body" layout="border:true">
		    <form id="form1" action="<c:url value='/m1/lbsSupplierController.do'/>?method=setSupplier" method="post">
				<input type="hidden" id="id" name="id" value="<c:out value='${entityId}'/>" />
					<div id ="seleteDiv">
					<table id = "tableD">
						<tr>
							<th>
								<font>${ctp:i18n('m1.lbs.supplier.supplierLabel')}:</font></th>
							<td>
								<select id="supplierS" name="supplierS" >
									<option id = "gaode" value="2">${ctp:i18n('m1.lbs.supplier.gaode')}</option>
									<option id = "baidu" value="1" >${ctp:i18n('m1.lbs.supplier.baidu')}</option>
									<option  id = "google" value="3" >${ctp:i18n('m1.lbs.supplier.google')}</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
			</form>
		</div>
		
		<div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix stadic_footer_height padding_t_5 border_t">
                           
						   
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
                </div>
		
	</div>
</body>
</html>