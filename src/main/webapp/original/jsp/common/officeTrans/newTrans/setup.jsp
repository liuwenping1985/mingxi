<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.netpower.library.util.Setup,java.util.ArrayList,com.netpower.library.util.JArray" %>

<jsp:include page="../common/header.jsp"/>
	<div style="width:690px;clear:both;padding: 20px 10px 20px 10px;">
		<ul id="process" style="margin-bottom:10px;">
<%
switch (step){
	case 1:
%>
			<li class="first active"><span>Step 1: Recommended Components</span></li>
			<li class=""><span>Step 2: Configuration</span></li>
<%
		break;
	case 2:
	default:
%>
			<li class="first prevactive"><span>Step 1: Recommended Components</span></li>
			<li class="last active"><span>Step 2: Configuration</span></li>
<%
		break;
	}
%>
		</ul>
	</div>
	<div style="clear:both;background-color:#fff;padding: 20px 10px 20px 30px;border:0px;-webkit-box-shadow: rgba(0, 0, 0, 0.246094) 0px 4px 8px 0px;min-width:650px;float:left;width:650px;margin-left:10px;margin-bottom:50px;">
<%
switch (step) {
	case 1:
		boolean pdf2swf 	= conf.pdf2swfEnabled(path_to_pdf2swf + pdf2swf_exec);
		boolean pdf2json 	= conf.pdf2jsonEnabled(path_to_pdf2json + pdf2json_exec);
		String gdinfo 	= null;

		ArrayList<JArray> tests = new ArrayList<JArray>();
		JArray one = new JArray();
		one.add("desc", "SWFTools support");
	    one.add("test", String.valueOf(pdf2swf));
		one.add("failmsg",
				"Without SWFTools installed, documents will have to be published manually. Please see <a href='http://www.swftools.org'>swftools.org</a> on how to install SWFTools.<br/><br/>Have you installed SWFTools at a different location? Please enter the full path to your SWFTools installation below<br/><form class='devaldi'><div class='text' style='width:400px;float:left;'><input type='text' name='PDF2SWF_PATH' id='PDF2SWF_PATH' value='" +
				path_to_pdf2swf +
				"' onkeydown='updatepdf2swfpath()'/><div class='effects'></div><div class='loader'></div></div></form><br/>");
		JArray two = new JArray();
		two.add("desc", "PDF2JSON support");
		two.add("test", String.valueOf(pdf2json));
		two.add("failmsg",
				"Without PDF2JSON installed, FlexPaper won't be able to publish documents to HTML format. Please see its homepage on <a href='http://code.google.com/p/pdf2json/'>Google Code</a> on how to download and install PDF2JSON<br/><br/>Have you installed PDF2JSON at a different location? Please enter the full path to your PDF2JSON installation below<br/><form class='devaldi'><div class='text' style='width:400px;float:left;'><input type='text' name='PDF2JSON_PATH' id='PDF2JSON_PATH' value='" +
				path_to_pdf2json +
				"' onkeydown='updatepdf2jsonpath()'/><div class='effects'></div><div class='loader'></div></div></form><br/>");
		tests.add(one);
		tests.add(two);
		conf.exec_tests(tests);
%>
		<script type="text/javascript">
			function updatepdf2jsonpath(){
				$('#bttn_final').hide();
				$('#bttn_updatepath_pdf2json').show();
			}
			function updatepdf2swfpath(){
				$('#bttn_final').hide();
				$('#bttn_updatepath_pdf2swf').show();				
			}
		</script>
		<h3>FlexPaper Configuration: Recommended Components</h3>
		<table width="100%" cellspacing="0" cellpadding="0" class="sortable">
			<tr>
				<th class="title">Test</th>
				<th class="tr">Result</th>
			</tr>
			<%=conf.table_data%>
		</table>
<%
		if (conf.fatals > 0){
%>
		<h4 class="warn">FlexPaper will work on this server, but its features will be limited as described below.</h4>
		<ul class="list" style="margin-top:30px">
			<%=conf.fatal_msg%>
		</ul>			
<%
		}
%>
		<div style="margin-top:10px;float:right;display:block" id="bttn_final">
			<button class="tiny main n_button" type="submit" onclick="location.href='hello.jsp?step=2'"><span></span><em style="min-width:150px">final step &rarr;</em></button>&nbsp;<br/>
		</div>
		<div style="margin-top:10px;float:right;display:none;" id="bttn_updatepath_pdf2json">
			<button class="tiny main n_button" type="submit" onclick="location.href='index.jsp?step=1&PDF2JSON_PATH='+$('#PDF2JSON_PATH').val()"><span></span><em style="min-width:150px">retry<img src="../common/images/reload.png" style="margin-top:3px"/></em></button>&nbsp;<br/>
		</div>
		<div style="margin-top:10px;float:right;display:none;" id="bttn_updatepath_pdf2swf">
			<button class="tiny main n_button" type="submit" onclick="location.href='index.jsp?step=1&PDF2SWF_PATH='+$('#PDF2SWF_PATH').val()"><span></span><em style="min-width:150px">retry<img src="../common/images/reload.png" style="margin-top:3px"/></em></button>&nbsp;<br/>
		</div>
<%
		break;
	case 2:
	default:
%>
		<script type="text/javascript">
			function validateConfiguration(){
				if($('#ADMIN_USERNAME').val().length==0){
					$('#ADMIN_USERNAME_RESULT').html('Admin username needs to be set');
					$('#ADMIN_USERNAME').focus();
					return false;
				}
				if($('#ADMIN_PASSWORD').val().length==0){
					$('#ADMIN_PASSWORD_RESULT').html('Admin password needs to be set');
					$('#ADMIN_PASSWORD').focus();
					return false;
				}
				if($('#PDF_DIR').val().length==0 || $('#PDF_DIR_ERROR').html().length > 0){
					$('#PDF_DIR_ERROR').html('PDF storage directory needs to be valid path');
					$('#PDF_DIR').focus();
					return false;
				}
				if($('#PUBLISHED_PDF_DIR').val().length==0 || $('#PUBLISHED_PDF_DIR_ERROR').html().length > 0){
					$('#PUBLISHED_PDF_DIR_ERROR').html('Working directory needs to be valid path');
					$('#PUBLISHED_PDF_DIR').focus();
					return false;
				}
				if(	$("INPUT#SQL_PASSWORD, INPUT#SQL_USERNAME, INPUT#SQL_HOST, INPUT#SQL_DATABASE").val().length>0) {
					if($("#SQL_PASSWORD").val().length==0||$("#SQL_USERNAME").val().length==0||$("#SQL_HOST").val().length==0||$("#SQL_DATABASE").val().length==0){
						$('#SQL_CONNECT_RESULT').html('<font color="red">All fields need to be set to set up the sample database</font>');
						$('INPUT#SQL_HOST').focus();
						return false;
					}
					if($("#SQL_DATABASE_VERIFIED").val() != "true"){
						if($("#SQL_CONNECT_RESULT").html().length > 0){
							$('#SQL_CONNECT_RESULT').html('<font color="red">Invalid database.</font>');
							$('INPUT#SQL_HOST').focus();
						}else {
							$('#SQL_CONNECT_RESULT').html('<font color="red">Please wait a moment while checking database.</font>');
						}
						return false;
					}	
				}
			}
		</script>
		<h3>FlexPaper: Configuration</h3>
		<form class="devaldi" action="index.jsp" method="post" onsubmit="return validateConfiguration()">
			<input type="hidden" id="step" name="step" value="3" />
			<table width="100%" cellspacing="0" cellpadding="0" class="sortable">
				<tr>
					<td>Admin Username</td>
					<td>
						<div class="text" style="width:150px;float:left;">
							<input type="text" name="ADMIN_USERNAME" id="ADMIN_USERNAME" value="<%=conf.getConfig("username", "")%>"/>
							<div class="effects"></div><div class="loader"></div>
						</div>
						<div style="float:left;font-size:10px;padding-top:5px;">
							The admin username you want to use for the admin publishing interface.
						</div>
						<div id="ADMIN_USERNAME_RESULT" class="formError" style="float:right;"></div>
					</td>
				</tr>
				<tr>
					<td>Admin Password</td>
					<td>
						<div class="text" style="width:150px;float:left">
							<input type="text" name="ADMIN_PASSWORD" id="ADMIN_PASSWORD" value="<%=conf.getConfig("password", "")%>"/>
							<div class="effects"></div><div class="loader"></div>
						</div>
						<div style="float:left;font-size:10px;padding-top:5px;">
							The admin password you want to use for the admin publishing interface.
						</div>
						<div id="ADMIN_PASSWORD_RESULT" class="formError" style="float:right;"></div>
					</td>
				</tr>
				<tr>
					<td style="vertical-align:top;padding-top:12px;">PDF Storage Directory</td>
					<td style="vertical-align:top;">
						<div class="text">
							<input type="text" name="PDF_DIR" id="PDF_DIR" value="<%=path_pdf%>"/>
							<div class="effects"></div><div class="loader"></div>
						</div>
						<div style="float:left;font-size:10px;padding-top:5px;">
							This directory should reside outside of your web application root folder to protect your documents.
						</div>
						<div id="PDF_DIR_ERROR" class="formError" style="float:right;"></div>
					</td>
				</tr>
				<tr>
					<td>Working Directory</td>
					<td>
						<div class="text">
							<input type="text" name="PUBLISHED_PDF_DIR" id="PUBLISHED_PDF_DIR" value="<%=path_pdf_workingdir%>"/>
							<div class="effects"></div>
							<div class="loader"></div>
						</div>
						<div style="float:left;font-size:10px;padding-top:5px;">
							This directory should reside outside of your web application root folder to protect your documents.
						</div>
						<div id="PUBLISHED_PDF_DIR_ERROR" class="formError" style="float:right;"></div>
					</td>
				</tr>
				<tr>
					<td valign="top">
						Primary Format
					</td>
					<td>
						<div style="width:300px;float:left;">
							<select id="RenderingOrder_PRIM" name="RenderingOrder_PRIM" style="font-size:12pt;float:left;">
								<option value="flash" <% if("flash".equals(conf.getConfig("renderingorder.primary", ""))) { %>selected="selected"<% } %>>flash</option>
								<option value="html" <% if("html".equals(conf.getConfig("renderingorder.primary", ""))) { %>selected="selected"<% } %>>html</option>
								<option value="html5" <% if("html5".equals(conf.getConfig("renderingorder.primary", ""))) { %>selected="selected"<% } %>>html5</option>
							</select>
						</div>
						<div style="float:left;font-size:10px;padding-top:5px;">
							This decides what to use as primary media format to use for your visitors.
						</div>
					</td>
				</tr>
				<tr>
					<td valign="top">
						Secondary Format
					</td>
					<td>
						<div style="width:300px;float:left;">
							<select id="RenderingOrder_SEC" name="RenderingOrder_SEC" style="font-size:12pt;float:left;">
								<option value="flash" <% if("flash".equals(conf.getConfig("renderingorder.secondary", ""))) { %>selected="selected"<% } %>>flash</option>
								<option value="html" <% if("html".equals(conf.getConfig("renderingorder.secondary", ""))) { %>selected="selected"<% } %>>html</option>
								<option value="html5" <% if("html5".equals(conf.getConfig("renderingorder.secondary", ""))) { %>selected="selected"<% } %>>html5</option>
							</select>
						</div>	
						<div style="float:left;font-size:10px;padding-top:5px;">
							This decides what to use as secondary media format to use for your visitors.
						</div>
					</td>
				</tr>
				<tr>
					<td>Split mode publishing? </td>
					<td>
						<INPUT TYPE="radio" NAME="SPLITMODE" id="SPLITMODE1" VALUE="false" checked="checked" style="vertical-align: middle"> No
						<INPUT TYPE="radio" NAME="SPLITMODE" id="SPLITMODE2" VALUE="true" <% if("true".equals(conf.getConfig("splitmode", ""))) { %>checked="checked"<% } %> style="vertical-align: middle;margin-left:30px;"> Yes<BR>
						<div style="float:left;font-size:10px;padding-top:5px;">
							If you generally publish large PDF documents then running split mode is recommended.
						</div>
					</td>
				</tr>
				<tr>
					<td>License Key</td>
					<td>
						<div class="text" style="width:300px;float:left;">
							<input type="text" name="LICENSEKEY" id="LICENSEKEY" value=""/>
							<div class="effects"></div><div class="loader"></div>
						</div>
						<div style="float:left;font-size:10px;padding-top:5px;">
							If using the commercial version, this is the key you recieved from our commercial download area.
						</div>
						<div id="LICENSEKEY_ERROR" class="formError" style="float:right;"></div>
					</td>
				</tr>
			</table>
			<script type="text/javascript">
				$(document).ready(function(){
					$('#ADMIN_USERNAME').focus();
					$("input#PDF_DIR").keyup(initTimer);
					$("input#PDF_DIR").change(checkDirectoryChangePermissionsHandler);
					$("input#PUBLISHED_PDF_DIR").keyup(initTimer);
					$("input#PUBLISHED_PDF_DIR").change(checkDirectoryChangePermissionsHandler);
				});
				var currentTimeoutField;
				function initTimer(event) {
					currentTimeoutField = $(this);
				    if (window.globalTimeout) clearTimeout(window.globalTimeout);
				    window.globalTimeout = setTimeout(checkDirectoryPermissionsHandler, 1000);
				}
				function checkDirectoryPermissions(obj){
					var infield = obj;
					if(infield.val().length<3){return;}
					$.ajax({
						url: "../common/checkdirpermissions.jsp?dir="+infield.val(),
						context: document.body,
						success: function(data){
							if(data==0){
								$("#"+infield.attr("id")+"_ERROR").html("Cannot write to directory. Please verify path & permissions (needs to be writable).");
								return false;
							}else{
								$("#"+infield.attr("id")+"_ERROR").html("");
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
			<div style="margin-top:10px;float:right;">
				<button class="tiny main n_button" type="submit"><span></span><em style="min-width:150px">Save &amp; Complete Setup</em></button>&nbsp;<br/>
			</div>
		</form>
<%
		break;
	}
%>
	</div>
<jsp:include page="../common/footer.jsp"/>