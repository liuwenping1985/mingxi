<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="projectHeader.jsp"%>
<script type="text/javascript" charset="UTF-8"
  src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key="project.toolbar.comment.label" /></title>
<style type="text/css">
</style>
</head>

<body scroll="no">
  <table width="100%" class="popupTitleRight" height="100%" border="0"
    cellspacing="0" cellpadding="0">
    <tr>
      <td height="20" class="PopupTitle"><fmt:message
          key="project.toolbar.comment.label" /></td>
    </tr>
    <tr>
      <td class="bg-advance-middel">
        <table width="100%" align="center" height="100%" border="0"
          cellspacing="0" cellpadding="0">
          <tr>
            <td height="60%">
              <div class="scrollList" style="border: solid 1px #666666;">
                <table class="sort" width="100%" border="0" cellspacing="0"
                  cellpadding="0" onClick="">
                  <tr>
                    <td class="bg-advance-middel" id="div1"><table
                        width="100%">
                        <tr>
                          <td style="border: solid 1px #666666;"><div
                              style="line-height: 20px;">
                              【<fmt:message key="project.body.responsibleorsist.label" />】:<br />
                              <div style="text-indent: 2em;">
                                <fmt:message key="project.body.responsible.des.label" /></div>
                            </div></td>
                        </tr>


                        <tr>
                          <td style="border: solid 1px #666666;"><div
                              style="line-height: 20px;">
                              【<fmt:message key="project.body.members.label" />】: <br />
                              <div style="text-indent: 2em;"><fmt:message key="project.body.member.des.label" /></div>
                            </div></td>
                        </tr>
                        <tr>
                          <td style="border: solid 1px #666666;"><div
                              style="line-height: 20px;">
                              【<fmt:message key="project.body.manger.label" />】: <br />
                              <div style="text-indent: 2em;"><fmt:message key="project.body.manager.des.label" /></div>
                            </div></td>
                        </tr>
                        <tr>
                          <td style="border: solid 1px #666666;"><div
                              style="line-height: 20px;">
                              【<fmt:message key="project.body.related.label" />】: <br />
                              <div style="text-indent: 2em;"><fmt:message key="project.body.other.des.label" /></div>
                            </div></td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%--
    <tr>
      <td height="42" align="right" class="bg-advance-bottom"><input
        type="button" onclick="window.close()"
        value="<fmt:message key='common.button.close.label' bundle="${v3xCommonI18N}" />"
        class="button-default-2"></td>
    </tr>
     --%>
  </table>

</body>
</html>