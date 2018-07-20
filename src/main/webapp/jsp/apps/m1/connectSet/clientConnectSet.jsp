<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../../common/common.jsp"%>
<title>Insert title here</title>
<script type="text/javascript">
$(document).ready(function() {
	setTitle();
	init();
	$("#btnok").bind("click",function(){
		submit();
	});
	$("#btncancel").bind("click",function(){
		cancel();
	});
	$("#toolbar").toolbar({
	    toolbar: [{
	    
	      id: "edit",
	      name: "${ctp:i18n('common.button.modify.label')}",
	      className: "ico16 editor_16",
	      click:function(){
	    	  $("#button_area").show();
	    	  $("#http").attr("disabled",false);
	    	  $("#https").attr("disabled",false);
	      }
	    }]
	    });
	
});
function init(){
	 $("#button_area").hide();
	 $("#http").attr("disabled",true);
	  $("#https").attr("disabled",true);
	var set = "${set}";
	var success = "${success}";
	if(set ==0 || set =='0') {
		$("#https").attr("checked","checked");
		$("#http").attr("checked","checked");
	} else if (set == 1 || set =='1') {
		$("#http").attr("checked","checked");
	} else if (set == 2 || set =='2' ) {
		$("#https").attr("checked","checked");
	}
	if(success !='') {
		//$.alert(success);
	}
	
}
function cancel() {
	window.location = "<c:url value='/m1/mConnectSet.do'/>?method=index";
}
/**
 * 设置菜单栏
 */
function setTitle(){
	
	//showCtpLocation("M01_mobileLoginType");
	
}
function submit(){
	
	var http = $("#http").attr("checked");
	var https = $("#https").attr("checked");
	var httpnotice =" ${ctp:i18n('m1.connectType.httpnotice')}";
	var httpsnotice = "${ctp:i18n('m1.connectType.httpsnotice')}";
	if(http =='checked' && https =='checked') {
		$("#form1").submit();
	} else if (http =='checked') {
		$.confirm({
            'title': "${ctp:i18n('common.prompt')}",
            'msg': httpnotice,
            ok_fn: function() {
            	$("#form1").submit();
            },
            cancel_fn: function() {location.reload();}
          });
	} else if ( https =='checked'){
		$.confirm({
            'title': "${ctp:i18n('common.prompt')}",
            'msg': httpsnotice,
            ok_fn: function() {
            	$("#form1").submit();
            },
            cancel_fn: function() {location.reload();}
          });
	} else {
		$.alert("${ctp:i18n('m1.connectType.noselect')}");
	}
	
}
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" comp="type:'breadcrumb',code:'M01_mobileLoginType'"></div>
   <div class="layout_north" layout="height:30,sprit:false,border:false">
       <div id="toolbar"></div>
   </div>
    
    <div id="center"  class="layout_center" layout="border:true">
	    <div >
	    <form id="form1" action="<c:url value='/m1/mConnectSet.do'/>?method=update" method="post">
			<fieldset style="width: 60%;margin: 10px auto;">
			<legend></legend>
			<div align="center" style="margin-top: 30px;">
				<table>
					<tr>
					<td><font style="font-size: 30px;"><input type="checkbox" id ="http" name="http" value="1"  style="width:30px;">${ctp:i18n('m1.connectType.http')}</font></td>
					<td></td>
					<td><font style="font-size: 30px;"><input type="checkbox" id = "https" name="https" value="2"  style="width:30px;">${ctp:i18n('m1.connectType.https')}</font></td>
					</tr>
				</table>
			</div>
			</fieldset>
		</form>
		</div>
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