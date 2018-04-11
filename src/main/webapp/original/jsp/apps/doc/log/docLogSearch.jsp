<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<script type="text/javascript">
	function showTable() {
		var t2 = document.getElementById("t2");
		if ($("#t2").attr("style").indexOf("none") != -1) {
			t2.style.display = "block";
			$("#pic").removeClass("arrow_2_b");
			$("#pic").addClass("arrow_2_t");
			var iframeHeight = document.body.clientHeight - 333;
			if(v3x.isMSIE8 || v3x.isMSIE9 || v3x.isMSIE10){
				iframeHeight = document.documentElement.clientHeight - 339;
			}
			iframeHeight += "px";
			$("#docIframe").attr("height",iframeHeight);
		} else {
			t2.style.display = "none";
			$("#pic").removeClass("arrow_2_t");
			$("#pic").addClass("arrow_2_b");
			var iframeHeight = document.body.clientHeight - 157;
			if(v3x.isMSIE8 || v3x.isMSIE9 || v3x.isMSIE10){
				iframeHeight = document.documentElement.clientHeight - 158;
			}
			iframeHeight += "px";
			$("#docIframe").attr("height",iframeHeight);
		}
	}

	function checkbox_click(_this, _type, _cal) {
		if (_type == 1) {
			if ($(_this).hasClass("checked")) {
				$(_this).removeClass("checked")
				for (var i = 0; i < $("em[name='" + _cal + "']").length; i++) {
					if ($("em[name='" + _cal + "']").eq(i).hasClass("checked")) {
						$("em[name='" + _cal + "']").eq(i).removeClass(
								"checked");
					}
				}
			} else {
				$(_this).addClass("checked")
				for (var i = 0; i < $("em[name='" + _cal + "']").length; i++) {
					if (!($("em[name='" + _cal + "']").eq(i)
							.hasClass("checked"))) {
						$("em[name='" + _cal + "']").eq(i).addClass("checked");
					}
				}
			}
		} else {
			if ($(_this).hasClass("checked")) {
				$(_this).removeClass("checked");
				if ($("#" + _cal + "Main").hasClass("checked")) {
					$("#" + _cal + "Main").removeClass("checked");
				}
			} else {
				$(_this).addClass("checked");
				var count = 0;
				for (var i = 0; i < $("em[name='" + _cal + "']").length; i++) {
					if ($("em[name='" + _cal + "']").eq(i).hasClass("checked")) {
						count++;
					}
				}
				if (count == $("em[name='" + _cal + "']").length) {
					if (!($("#" + _cal + "Main").hasClass("checked"))) {
						$("#" + _cal + "Main").addClass("checked");
					}
				}
			}

		}
	}
</script>
<table style="border-spacing: 0px;">
	<tr>
		<td class="webfx-menu-bar" width="50%" height="100%">
			<form action="" name="searchForm" id="searchForm" method="post"
				onSubmit="return false" style="position: relative; margin: 0px">
				<div style="position: absolute; right: 30px; bottom: 0">
					<span id="pic" class="arrow_2_b" onclick="showTable();"></span>
				</div>
				<table width="100%">
					<tr>
						<td width="11%" align="right">
							<fmt:message key='doc.log.user' />:
						</td>
						<td width="22%" align="left">
							<input type="text" name="userName" id="userName" class="textfield" style="width: 154px" maxLength='20' />
						</td>
						<td width="11%" align="right">
							<fmt:message key='doc.knowledge.doc.title' />:
						</td>
						<td width="22%" align="left">
							<input type="text" name="title" id="title" class="textfield" style="width: 154px" maxLength='20' />
						</td>
						<td width="11%" align="right">
							<fmt:message key='doc.log.time' />:
						</td>
						<td width="22%" align="left">
							<input type="text" name="fromTime" id="fromTime" class="input-date"
							onclick="whenstart('${pageContext.request.contextPath}', this,575,140);" readonly> 
							- <input type="text" name="toTime" id="toTime" class="input-date"
							onpropertychange="setDate('enddate', 'beginTime2', 'endTime2')"
							onclick="whenstart('${pageContext.request.contextPath}', this, 675, 140);" readonly>
						</td>
					</tr>
					<tr>
						<td width="11%" align="right">
							<fmt:message key='doc.log.operation' />:
						</td>
					</tr>
					<tr><td colspan="6">
						<table style="margin-left: 98px;" width="100%">
							<tr>
								<td>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
										<em id="aMain" class="checkBox  " onclick="checkbox_click(this,1,'a')"></em> 
										<span><fmt:message key='doc.log.select.all' />:</span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.view" class="checkBox  " onclick="checkbox_click(this,2,'a')" name="a"></em> 
										<span><fmt:message key='doc.log.view' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.download" class="checkBox  " onclick="checkbox_click(this,2,'a')" name="a"></em> 
										<span><fmt:message key='doc.log.download' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.print" class="checkBox  " onclick="checkbox_click(this,2,'a')" name="a"></em> 
										<span><fmt:message key='doc.log.print' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.add.document" class="checkBox  " onclick="checkbox_click(this,2,'a')" name="a"></em> 
										<span><fmt:message key='doc.log.add.document' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.upload" class="checkBox  " onclick="checkbox_click(this,2,'a')" name="a"></em> 
										<span><fmt:message key='doc.log.upload' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.edit.document.body" class="checkBox  " onclick="checkbox_click(this,2,'a')" name="a"></em> 
										<span><fmt:message key='doc.log.update.content' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.lend" class="checkBox  " onclick="checkbox_click(this,2,'a')" name="a"></em> 
										<span><fmt:message key='doc.document.borrowing' /></span>
									</div>
								</td>
							</tr>
						</table>
						<table id="t2" style="margin-left: 98px; display: none">
							<tr>
								<td>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
										<em id="bMain" class="checkBox  " onclick="checkbox_click(this,1,'b')"></em> 
										<span><fmt:message key='doc.log.create.operate' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.add.lib" class="checkBox  " onclick="checkbox_click(this,2,'b')" name="b"></em> 
										<span><fmt:message key='doc.doclib.jsp.newlib' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.add.folder" class="checkBox  " onclick="checkbox_click(this,2,'b')" name="b"></em> 
										<span><fmt:message key='doc.log.add.folder' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.add.shortcut" class="checkBox  " onclick="checkbox_click(this,2,'b')" name="b"></em> 
										<span><fmt:message key='doc.log.add.shortcut' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.add.link" class="checkBox  " onclick="checkbox_click(this,2,'b')" name="b"></em> 
										<span><fmt:message key='doc.log.add.link' /></span>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
										<em id="cMain" class="checkBox  " onclick="checkbox_click(this,1,'c')"></em> 
										<span><fmt:message key='doc.log.update.operate' />:</span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.edit.lib" class="checkBox  " onclick="checkbox_click(this,2,'c')" name="c"></em> 
										<span><fmt:message key='doc.log.edit.lib' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.edit.lib.owner" class="checkBox  " onclick="checkbox_click(this,2,'c')" name="c"></em> 
										<span><fmt:message key='doc.log.edit.lib.owner' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.rename.folder" class="checkBox  " onclick="checkbox_click(this,2,'c')" name="c"></em> 
										<span><fmt:message key='doc.log.rename.folder' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.edit.folder" class="checkBox  " onclick="checkbox_click(this,2,'c')" name="c"></em> 
										<span><fmt:message key='doc.log.edit.folder' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.rename.document" class="checkBox  " onclick="checkbox_click(this,2,'c')" name="c"></em> 
										<span><fmt:message key='doc.log.rename.document' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.edit.document" class="checkBox  " onclick="checkbox_click(this,2,'c')" name="c"></em> 
										<span><fmt:message key='doc.log.edit.document' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.replace" class="checkBox  " onclick="checkbox_click(this,2,'c')" name="c"></em> 
										<span><fmt:message key='doc.log.replace' /></span>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
										<em id="dMain" class="checkBox  " onclick="checkbox_click(this,1,'d')"></em> 
										<span><fmt:message key='doc.log.delete.operate' />:</span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.remove.lib" class="checkBox  " onclick="checkbox_click(this,2,'d')" name="d"></em> 
										<span><fmt:message key='doc.log.remove.lib' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.remove.folder" class="checkBox  " onclick="checkbox_click(this,2,'d')" name="d"></em> 
										<span><fmt:message key='doc.log.remove.folder' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.remove.document" class="checkBox  " onclick="checkbox_click(this,2,'d')" name="d"></em> 
										<span><fmt:message key='doc.log.remove.document' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.delete.version" class="checkBox  " onclick="checkbox_click(this,2,'d')" name="d"></em> 
										<span><fmt:message key='doc.log.delete.version' /></span>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
										<em id="eMain" class="checkBox  " onclick="checkbox_click(this,1,'e')"></em> 
										<span><fmt:message key='doc.log.move.operate' />:</span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.move.folder.in" class="checkBox  " onclick="checkbox_click(this,2,'e')" name="e"></em> 
										<span><fmt:message key='doc.log.move.folder.in' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.move.folder.out" class="checkBox  " onclick="checkbox_click(this,2,'e')" name="e"></em> 
										<span><fmt:message key='doc.log.move.folder.out' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.move.document.in" class="checkBox  " onclick="checkbox_click(this,2,'e')" name="e"></em> 
										<span><fmt:message key='doc.log.move.document.in' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.move.document.out" class="checkBox  " onclick="checkbox_click(this,2,'e')" name="e"></em> 
										<span><fmt:message key='doc.log.move.document.out' /></span>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
										<em id="fMain" class="checkBox  " onclick="checkbox_click(this,1,'f')"></em> 
										<span><fmt:message key='doc.log.share.operate' />:</span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.forward" class="checkBox  " onclick="checkbox_click(this,2,'f')" name="f"></em> 
										<span><fmt:message key='doc.log.forward' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.publish" class="checkBox  " onclick="checkbox_click(this,2,'f')" name="f"></em> 
										<span><fmt:message key='doc.log.publish' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.share" class="checkBox  " onclick="checkbox_click(this,2,'f')" name="f"></em> 
										<span><fmt:message key='doc.log.share' /></span>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
										<em id="gMain" class="checkBox  " onclick="checkbox_click(this,1,'g')"></em> 
										<span><fmt:message key='doc.log.others' />:</span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.save" class="checkBox  " onclick="checkbox_click(this,2,'g')" name="g">
										</em> <span><fmt:message key='doc.log.save.document' /></span>
									</div>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.pigeonhole" class="checkBox  " onclick="checkbox_click(this,2,'g')" name="g"></em> 
										<span><fmt:message key='doc.log.pigeonhole' /></span>
									</div>
									<c:if test="${v3x:hasPlugin('doc') && v3x:getSystemProperty('doc.collectFlag') == 'true'} ">
										<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
											<em id="log.doc.favorite" class="checkBox  " onclick="checkbox_click(this,2,'g')" name="g"></em> 
											<span><fmt:message key='doc.collect' /></span>
										</div>
									</c:if>
									<div style="display: inline-block; width: 125px; line-height: 19px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-left: 30px;">
										<em id="log.doc.replace.version" class="checkBox  " onclick="checkbox_click(this,2,'g')" name="g"></em> 
										<span><fmt:message key='doc.log.replace.version' /></span>
									</div>
								</td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
				<table width="100%" style="background: #f0f0f0;">
					<tr>
						<td align="center"></td>
					</tr>
					<tr>
						<td nowrap="nowrap" align="center">
							<input type="button" id="logSearch" class="button-default_emphasize" onclick="searchDocLogs();"
							value="<fmt:message key='common.button.condition.search.label' bundle="${v3xCommonI18N}" />">&nbsp;
						</td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
</table>
