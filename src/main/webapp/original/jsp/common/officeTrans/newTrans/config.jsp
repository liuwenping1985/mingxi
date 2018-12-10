<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.netpower.library.util.Common,com.netpower.library.util.JArray" %>
<%
	Common com = new Common();
	String sconfig = request.getParameter("SAVE_CONFIG");
	if(sconfig != null){
		JArray ht = com.getConfigs();
		ht.set("path.pdf", request.getParameter("PDF_Directory"));
		ht.set("path.swf", request.getParameter("SWF_Directory"));
		ht.set("licensekey", request.getParameter("LICENSEKEY"));
		ht.set("splitmode", request.getParameter("SPLITMODE"));
		ht.set("renderingorder.primary", request.getParameter("RenderingOrder_PRIM"));
		ht.set("renderingorder.secondary", request.getParameter("RenderingOrder_SEC"));

		com.mkdir(ht.get("path.pdf"));
		com.mkdir(ht.get("path.swf"));
		if(com.saveConfig(ht))
	com.DeleteFiles(com.getConfig("path.swf", ""));
		response.sendRedirect("../admin/configMain.jsp?msg=Configuration%20saved");
	}

	String flexAuth = (String) session.getAttribute("FLEXPAPER_AUTH");
	if(flexAuth == null) {
		response.sendRedirect("../configMain.jsp");
	}
%>
<jsp:include page="header.jsp"/>
<script type="text/javascript">
	var globalTimeout;
	var currentTimeoutField;

	function initTimer(event) {
		currentTimeoutField = $(this);
	    if (globalTimeout) clearTimeout(globalTimeout);
	    globalTimeout = setTimeout(checkDirectoryPermissionsHandler, 1000);
	}

	$(document).ready(function(){
		$("input#PDF_Directory").keyup(initTimer);
		$("input#PDF_Directory").change(checkDirectoryChangePermissionsHandler);
		
		$("input#SWF_Directory").keyup(initTimer);
		$("input#SWF_Directory").change(checkDirectoryChangePermissionsHandler);
	});

	function checkDirectoryPermissions(obj){
		var infield = obj;
		if(infield.val().length<3){return;}
		$.ajax({
			url: "checkdirpermissions.jsp?dir="+infield.val(),
			context: document.body,
			success: function(data){
				console.log(data);
				if(data==0){
					$('#'+infield.attr("id")+'_ERROR').html('Cannot write to directory. Please verify path & permissions (needs to be writable).');
					return false;
				}else{
					$('#'+infield.attr("id")+'_ERROR').html('');
					return true;
				}
		  	}
		});
	}

	function checkDirectoryChangePermissionsHandler(event){
		var infield = $(this);
		checkDirectoryPermissions(infield);
	}
	
	function checkDirectoryPermissionsHandler(event){
		var infield = currentTimeoutField;
		checkDirectoryPermissions(infield);
	}
</script>
<div style="position:relative;left:10px;top:10px;background-color:#fff;padding: 20px 10px 20px 30px;border:0px;-webkit-box-shadow: rgba(0, 0, 0, 0.246094) 0px 4px 8px 0px;min-width:400px;float:left;margin-left:10px;margin-bottom:50px;margin-top:20px">
	<h3>FlexPaper Configuration</h3>
	<form class="devaldi" method="post" action="change_config.jsp" style="padding-bottom:30px;width:650px;"> 
	<table>
		<tr>
			<td style="border:0px;" valign="top">
				<label>
					<nobr>Publishing Mode</nobr>
				</label>
			</td>
			<td style="border:0px">
				<font style="font-size:13px">
					<INPUT TYPE=RADIO NAME="SPLITMODE" id="SPLITMODE1" VALUE="false" checked="checked" style="vertical-align: middle"> one file<BR>
					<INPUT TYPE=RADIO NAME="SPLITMODE" id="SPLITMODE2" VALUE="true" <%if("true".equals(com.getConfig("splitmode", ""))) {%>checked="checked"<%} %> style="vertical-align: middle"> split mode<BR>
				</font>
			</td>
		</tr>
		<tr>
			<td style="border:0px" valign="top">
				<label><nobr>PDF Directory</nobr></label>
			</td>
			<td style="border:0px">
				<div class="text">
					<input type="text" NAME="PDF_Directory" id="PDF_Directory" value="<%=com.getConfig("path.pdf", "") %>" size="80"/>
					<div class="effects"></div>
					<div class="loader"></div>
				</div>
				<div style="float:left;font-size:10px;padding-top:5px;">
					This directory should reside outside of your web application root folder to protect your documents.
				</div>
				<div id="PDF_Directory_ERROR" class="formError" style="float:left;"></div>
			</td>
		</tr>
		<tr>
			<td style="border:0px" valign="top">
				<label><nobr>Working Directory</nobr></label>
			</td>
			<td style="border:0px">
				<div class="text">
					<input type="text" NAME="SWF_Directory" id="SWF_Directory" value="<%=com.getConfig("path.swf", "") %>" size="80"/>
					<div class="effects"></div><div class="loader"></div>
				</div>
				<div style="float:left;font-size:10px;padding-top:5px;">
					This directory should reside outside of your web application root folder to protect your documents.
				</div>
				<div id="SWF_Directory_ERROR" class="formError" style="float:right;"></div>
			</td>
		</tr>
		<tr>
			<td style="border:0px" valign="top">
				<label><nobr>Primary Format</nobr></label>
			</td>
			<td style="border:0px">
				<select id="RenderingOrder_PRIM" name="RenderingOrder_PRIM" style="font-size:12pt;">
					<option value="flash" <%if("flash".equals(com.getConfig("renderingorder.primary", ""))) { %>selected="selected"<%} %>>flash</option>
					<option value="html" <% if("html".equals(com.getConfig("renderingorder.primary", ""))) { %>selected="selected"<%} %>>html</option>
					<option value="html5" <%if("html5".equals(com.getConfig("renderingorder.primary", ""))) { %>selected="selected"<%} %>>html5</option>
				</select>
				<br/>
				<div style="float:left;font-size:10px;padding-top:5px;">
					This decides what to use as primary media format to use for your visitors.
				</div>
			</td>
		</tr>
		<tr>
			<td style="border:0px" valign="top">
				<label><nobr>Secondary Format</nobr></label>
			</td>
			<td style="border:0px">
				<select id="RenderingOrder_SEC" name="RenderingOrder_SEC" style="font-size:12pt;">
					<option value="flash" <% if("flash".equals(com.getConfig("renderingorder.secondary", ""))) { %>selected="selected"<%} %>>flash</option>
					<option value="html" <% if("html".equals(com.getConfig("renderingorder.secondary", ""))) { %>selected="selected"<%} %>>html</option>
					<option value="html5" <% if("html5".equals(com.getConfig("renderingorder.secondary", ""))) { %>selected="selected"<%} %>>html5</option>
				</select><br/>
				<div style="float:left;font-size:10px;padding-top:5px;">
					This decides what to use as secondary media format to use for your visitors.
				</div>
			</td>
		</tr>
		<tr>
			<td style="border:0px">
				<label><nobr>License Key</nobr></label>
			</td>
			<td style="border:0px">
				<div class='text' style="width:300px">
					<input type="text" NAME="LICENSEKEY" id="LICENSEKEY" value="<%=com.getConfig("licensekey","")%>"/>
					<div class="effects"></div><div class="loader"></div>
				</div>
			</td>
		</tr>
	</table>
	<div style="padding-top:30px">
		<div style="float:left;padding-left:10px;">
			<button class="tiny main n_button" type="submit"><span></span><em style="min-width:75px;">Save</em></button>
			&nbsp;<br/>
		</div>
		<div style="float:left;padding-left:10px;">
			<button class="tiny main n_button" type="submit" onclick="window.location='../index.jsp'; return false;"><span></span><em style="min-width:75px;">Cancel</em></button>
			&nbsp;<br/>
		</div>
	</div>
	<input type="hidden" value="1" id="SAVE_CONFIG" name="SAVE_CONFIG" />
	</form>
</div>
<jsp:include page="footer.jsp"/>