<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="header.jsp"%>
<%@include file="pageCustom_ipad.js.jsp"%>

<html>
<head>

<script type="text/javascript">
 $(document).ready(function(){
    
    $('#cansleupload').click(function(){
        cansleImage();
    });
    $('#ulogo').click(function(){
        changeImage(2);
    });
    $('#ubg').click(function(){
        changeImage(1);
    });
    //
    $('#d3').click(function(){
        changeImage(1);
    });
    $('#d3').mousemove(function(){
        this.style.filter="alpha(opacity=30)";
    });
    $('#d3').mouseout(function(){
        this.style.filter="alpha(opacity=70)";
    });
    //
    $('#d4').click(function(){
        changeImage(2);
    });
    $('#d4').mousemove(function(){
        this.style.filter="alpha(opacity=30)";
    });
    $('#d4').mouseout(function(){
        this.style.filter="alpha(opacity=70)";
    });
    //
    $('#showImage').click(function(){
        showimg();
    });
    $('#saveChangeImg').click(function(){
        sub();
    });
    $('#restoreDefault').click(function(){
        restore_default();
    });
    //
    
});
</script>
</head>

<body  id="pageCustomBody" onbeforeunload="return tix();">
<form id="form1" action="<c:url value='/m1/changeImgController.do'/>?method=uploadImg" method="post">
<input type="hidden" name="fileId1" value="-1">
<input type="hidden" name="fileId2" value="-1">
<input type="hidden" name="fileCreateDate1" value="-1">
<input type="hidden" name="fileCreateDate2" value="-1">
<input type="hidden" name="bgpath" value="${bgpath}">
<input type="hidden" name="logopath" value="${logopath}">
<input type="hidden" name="filepath" value="">
<table  width="70%" align="left" border="0"  height="90%">
    
    <tr><td width="5%"></td><td>
        <table  width="100%"  border="0"  height="100%">
    
    <tr><td align="right">Logo:</td><td align="left">
        <input type="text" id="logoname" value=""/> 
        <input type="button" id="ulogo" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />"  class="button-default-2"/>
        <fmt:message key='m1.skin.ipad.log' bundle='${mobileManageBundle}'/></td></tr><tr><td align="right">
        <fmt:message key='m1.skin.background.label' bundle='${mobileManageBundle}'/>:</td><td align="left">
        <input type="text" id="bgname" value=""> <input type="button" id="ubg" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />"  class="button-default-2"/>
        <fmt:message key='m1.skin.background.ipad.label' bundle='${mobileManageBundle}'/></td></tr>
		<tr><td align="right">
	</td><td align="left">
	<input type="button" value="<fmt:message key='button.mm.restore_default' bundle='${mobileManageBundle}' />" id="restoreDefault" class="button-default-2"/>
	</td></tr>
		</table>
</td>
    </tr>
    <tr><td width="5%"></td><td align="left"  valign="middle" width="36%" height="80%">
    
    </br><div id="d1">
        <img id="bgv" src="${bgvpath}" />
        <div id="d3" >
            <img id="hengp" src="${bgpath}"/>
            
    </div>
        <div id="d4" >
            <img id="plogo" src="${logopath}"/>
        </div>
    </div>
    </td>
    
    </tr>
    <tr><td width="5%"></td><td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" value="<fmt:message key='button.mm.preview' bundle='${mobileManageBundle}' />" id="showImage"   class="button-default-2"/>&nbsp;
        <input type="button" value="<fmt:message key='button.mm.save' bundle='${mobileManageBundle}' />" id ="saveChangeImg"  class="button-default-2 button-default_emphasize"/>&nbsp;
        <input type="button" value="<fmt:message key='button.mm.cansle' bundle='${mobileManageBundle}' />" id="cansleupload" class="button-default-2"/>
    </td>
    </tr>
    
</table>
    
</form>
</body>
</html>