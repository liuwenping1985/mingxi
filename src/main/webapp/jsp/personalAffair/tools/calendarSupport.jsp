<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<link rel="stylesheet1" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet2" type="text/css" href="<c:url value="/apps_res/v3xmain/css/calendar.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/v3xmain/css/unical.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/unical.js${v3x:resSuffix()}" />"></script>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="menu.tools.calendar" /></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
try{
	var v3x = new V3X();
    v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
    showCtpLocation("F12_calendar");
}catch(e){
}
</script>
<style type="text/css">
.tdClass {
  color:  #919191;
  font-family: "黑体";
  padding-bottom: 5px;
  padding-left: 10px;
  padding-right: 10px;
  padding-top: 5px;
  font-size: 20px;
}

</style>
</head>
<body onload="initial()" scroll="no" class="border_lr">
<script language=JavaScript>
function returnBack(){
  top.contentFrame.topFrame.back();
}
</script>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" id="calendar-layout">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                <tr class="page2-header-line" style="background-color: rgb(250, 250, 250);">
                    <td width="45" class="page2-header-img"><div class="bulltenIndex"></div></td>
                    <td class="page2-header-bg tdClass">&nbsp;<fmt:message key="menu.tools.calendar" /></td>
                    <td class="page2-header-line padding-right" align="right">&nbsp;</td>
                </tr>
			 </table>
		</td>
	</tr>
<tr>
<td valign="top" align="center">
<div id="calenderDiv">
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
<td>
<div id="date">
	<p>公历
	<select onchange="changeCld()" id="sy"><option>1900</option>
<option>1901</option>
<option>1902</option>
<option>1903</option>
<option>1904</option>
<option>1905</option>
<option>1906</option>
<option>1907</option>
<option>1908</option>
<option>1909</option>
<option>1910</option>
<option>1911</option>
<option>1912</option>
<option>1913</option>
<option>1914</option>
<option>1915</option>
<option>1916</option>
<option>1917</option>
<option>1918</option>
<option>1919</option>
<option>1920</option>
<option>1921</option>
<option>1922</option>
<option>1923</option>
<option>1924</option>
<option>1925</option>
<option>1926</option>
<option>1927</option>
<option>1928</option>
<option>1929</option>
<option>1930</option>
<option>1931</option>
<option>1932</option>
<option>1933</option>
<option>1934</option>
<option>1935</option>
<option>1936</option>
<option>1937</option>
<option>1938</option>
<option>1939</option>
<option>1940</option>
<option>1941</option>
<option>1942</option>
<option>1943</option>
<option>1944</option>
<option>1945</option>
<option>1946</option>
<option>1947</option>
<option>1948</option>
<option>1949</option>
<option>1950</option>
<option>1951</option>
<option>1952</option>
<option>1953</option>
<option>1954</option>
<option>1955</option>
<option>1956</option>
<option>1957</option>
<option>1958</option>
<option>1959</option>
<option>1960</option>
<option>1961</option>
<option>1962</option>
<option>1963</option>
<option>1964</option>
<option>1965</option>
<option>1966</option>
<option>1967</option>
<option>1968</option>
<option>1969</option>
<option>1970</option>
<option>1971</option>
<option>1972</option>
<option>1973</option>
<option>1974</option>
<option>1975</option>
<option>1976</option>
<option>1977</option>
<option>1978</option>
<option>1979</option>
<option>1980</option>
<option>1981</option>
<option>1982</option>
<option>1983</option>
<option>1984</option>
<option>1985</option>
<option>1986</option>
<option>1987</option>
<option>1988</option>
<option>1989</option>
<option>1990</option>
<option>1991</option>
<option>1992</option>
<option>1993</option>
<option>1994</option>
<option>1995</option>
<option>1996</option>
<option>1997</option>
<option>1998</option>
<option>1999</option>
<option>2000</option>
<option>2001</option>
<option>2002</option>
<option>2003</option>
<option>2004</option>
<option>2005</option>
<option>2006</option>
<option>2007</option>
<option>2008</option>
<option>2009</option>
<option>2010</option>
<option>2011</option>
<option>2012</option>
<option>2013</option>
<option>2014</option>
<option>2015</option>
<option>2016</option>
<option>2017</option>
<option>2018</option>
<option>2019</option>
<option>2020</option>
<option>2021</option>
<option>2022</option>
<option>2023</option>
<option>2024</option>
<option>2025</option>
<option>2026</option>
<option>2027</option>
<option>2028</option>
<option>2029</option>
<option>2030</option>
<option>2031</option>
<option>2032</option>
<option>2033</option>
<option>2034</option>
<option>2035</option>
<option>2036</option>
<option>2037</option>
<option>2038</option>
<option>2039</option>
<option>2040</option>
<option>2041</option>
<option>2042</option>
<option>2043</option>
<option>2044</option>
<option>2045</option>
<option>2046</option>
<option>2047</option>
<option>2048</option>
<option>2049</option></select>
	年 
	<select onchange="changeCld()" id="sm"><option>1</option>
<option>2</option>
<option>3</option>
<option>4</option>
<option>5</option>
<option>6</option>
<option>7</option>
<option>8</option>
<option>9</option>
<option>10</option>
<option>11</option>
<option>12</option></select>
	月
	<span id="gz">&nbsp;</span></p>
</div>

</td>
</tr>
<tr>
<td>
<div id="calendar">
	<div id="detail"><div id="datedetail"></div><div id="festival"></div></div>
<table id="calendarhead">
	<tr> 
		<td>日</td>
		<td>一</td>
		<td>二</td>
		<td>三</td>
		<td>四</td>
		<td>五</td>
		<td>六</td>
	</tr>
</table>
<table id="week">
<tr class="tr1">
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(0)" id="sd0"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(1)" id="sd1"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(2)" id="sd2"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(3)" id="sd3"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(4)" id="sd4"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(5)" id="sd5"></td>
<td class="agreen" onmouseout="mOut()" onmouseover="mOvr(6)" id="sd6"></td>
</tr>
<tr class="tr2">
<td onmouseout="mOut()" onmouseover="mOvr(0)" id="ld0"></td>
<td onmouseout="mOut()" onmouseover="mOvr(1)" id="ld1"></td>
<td onmouseout="mOut()" onmouseover="mOvr(2)" id="ld2"></td>
<td onmouseout="mOut()" onmouseover="mOvr(3)" id="ld3"></td>
<td onmouseout="mOut()" onmouseover="mOvr(4)" id="ld4"></td>
<td onmouseout="mOut()" onmouseover="mOvr(5)" id="ld5"></td>
<td onmouseout="mOut()" onmouseover="mOvr(6)" id="ld6"></td>
</tr>
<tr class="tr1">
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(7)" id="sd7"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(8)" id="sd8"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(9)" id="sd9"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(10)" id="sd10"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(11)" id="sd11"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(12)" id="sd12"></td>
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(13)" id="sd13"></td>
</tr>
<tr class="tr2">
<td onmouseout="mOut()" onmouseover="mOvr(7)" id="ld7"></td>
<td onmouseout="mOut()" onmouseover="mOvr(8)" id="ld8"></td>
<td onmouseout="mOut()" onmouseover="mOvr(9)" id="ld9"></td>
<td onmouseout="mOut()" onmouseover="mOvr(10)" id="ld10"></td>
<td onmouseout="mOut()" onmouseover="mOvr(11)" id="ld11"></td>
<td onmouseout="mOut()" onmouseover="mOvr(12)" id="ld12"></td>
<td onmouseout="mOut()" onmouseover="mOvr(13)" id="ld13"></td>
</tr>
<tr class="tr1">
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(14)" id="sd14"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(15)" id="sd15"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(16)" id="sd16"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(17)" id="sd17"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(18)" id="sd18"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(19)" id="sd19"></td>
<td class="agreen" onmouseout="mOut()" onmouseover="mOvr(20)" id="sd20"></td>
</tr>
<tr class="tr2">
<td onmouseout="mOut()" onmouseover="mOvr(14)" id="ld14"></td>
<td onmouseout="mOut()" onmouseover="mOvr(15)" id="ld15"></td>
<td onmouseout="mOut()" onmouseover="mOvr(16)" id="ld16"></td>
<td onmouseout="mOut()" onmouseover="mOvr(17)" id="ld17"></td>
<td onmouseout="mOut()" onmouseover="mOvr(18)" id="ld18"></td>
<td onmouseout="mOut()" onmouseover="mOvr(19)" id="ld19"></td>
<td onmouseout="mOut()" onmouseover="mOvr(20)" id="ld20"></td>
</tr>
<tr class="tr1">
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(21)" id="sd21"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(22)" id="sd22"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(23)" id="sd23"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(24)" id="sd24"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(25)" id="sd25"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(26)" id="sd26"></td>
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(27)" id="sd27"></td>
</tr>
<tr class="tr2">
<td onmouseout="mOut()" onmouseover="mOvr(21)" id="ld21"></td>
<td onmouseout="mOut()" onmouseover="mOvr(22)" id="ld22"></td>
<td onmouseout="mOut()" onmouseover="mOvr(23)" id="ld23"></td>
<td onmouseout="mOut()" onmouseover="mOvr(24)" id="ld24"></td>
<td onmouseout="mOut()" onmouseover="mOvr(25)" id="ld25"></td>
<td onmouseout="mOut()" onmouseover="mOvr(26)" id="ld26"></td>
<td onmouseout="mOut()" onmouseover="mOvr(27)" id="ld27"></td>
</tr>
<tr class="tr1">
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(28)" id="sd28"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(29)" id="sd29"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(30)" id="sd30"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(31)" id="sd31"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(32)" id="sd32"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(33)" id="sd33"></td>
<td class="agreen" onmouseout="mOut()" onmouseover="mOvr(34)" id="sd34"></td>
</tr>
<tr class="tr2">
<td onmouseout="mOut()" onmouseover="mOvr(28)" id="ld28"></td>
<td onmouseout="mOut()" onmouseover="mOvr(29)" id="ld29"></td>
<td onmouseout="mOut()" onmouseover="mOvr(30)" id="ld30"></td>
<td onmouseout="mOut()" onmouseover="mOvr(31)" id="ld31"></td>
<td onmouseout="mOut()" onmouseover="mOvr(32)" id="ld32"></td>
<td onmouseout="mOut()" onmouseover="mOvr(33)" id="ld33"></td>
<td onmouseout="mOut()" onmouseover="mOvr(34)" id="ld34"></td>
</tr>
<tr class="tr1">
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(35)" id="sd35"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(36)" id="sd36"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(37)" id="sd37"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(38)" id="sd38"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(39)" id="sd39"></td>
<td class="one" onmouseout="mOut()" onmouseover="mOvr(40)" id="sd40"></td>
<td class="aorange" onmouseout="mOut()" onmouseover="mOvr(41)" id="sd41"></td>
</tr>
<tr class="tr2">
<td onmouseout="mOut()" onmouseover="mOvr(35)" id="ld35"></td>
<td onmouseout="mOut()" onmouseover="mOvr(36)" id="ld36"></td>
<td onmouseout="mOut()" onmouseover="mOvr(37)" id="ld37"></td>
<td onmouseout="mOut()" onmouseover="mOvr(38)" id="ld38"></td>
<td onmouseout="mOut()" onmouseover="mOvr(39)" id="ld39"></td>
<td onmouseout="mOut()" onmouseover="mOvr(40)" id="ld40"></td>
<td onmouseout="mOut()" onmouseover="mOvr(41)" id="ld41"></td>
</tr>
</table>
</div>
</td>
<td>
<div id="panel">
	<div onclick="pushBtm('YU')">上一年↑</div>
	<div onclick="pushBtm('YD')">下一年↓</div>
	<div onclick="pushBtm('MU')">上一月↑</div>
	<div onclick="pushBtm('MD')">下一月↓</div>
	<div onclick="pushBtm('')">当前月</div>
</div>
</td>
</tr>
</table>




</div>
</td>
</tr>
</table>
</body>
</html>
