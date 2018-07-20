<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html>
<%@page import="com.seeyon.ctp.common.flag.*"%>
<%
if(BrowserEnum.valueOf(request) == BrowserEnum.IE11){
%>
    <META http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
<%
} else {
%>
      <meta http-equiv="X-UA-Compatible" content="IE=EDGE"/>
<%
}
%>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common_footer_forH5.jsp"%>
