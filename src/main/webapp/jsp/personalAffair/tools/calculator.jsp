<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/v3xmain/css/calculator.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script language=javascript> 
<!-- 
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
	v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
	v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
//TODO yangwulin 2012-11-27 getA8Top().hiddenNavigationFrameset(1002);
showCtpLocation("F12_calculator");
//-->
</script> 
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/calculator.js${v3x:resSuffix()}" />"></script>
<title>Insert title here</title>
</head>
<body scroll="no"> 
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="border_lr border-top">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="bulltenIndex"></div></td>
				<td class="page2-header-bg"><fmt:message key="calculator.title"/></td>
				<td class="page2-header-line padding-right" align="right">&nbsp;</td>
			    </tr>
			 </table>
		</td>
	</tr>
<tr>
<td valign="top" class="paddingTop20">
<div align=center> 
    <form name=calc> 
    <table class="calanderBorder"> 
      <tbody> 
      <tr> 
         <td class="calanderTop"> 
                  <table width=100%> 
                    <tr> 
                      <td width=100%> 
                        <div align=center><input readOnly  size=80  value=0 name=display></div>
                        </td>
                      </tr>
                   </table>
             </td>
      </tr>
      <tr> 
          <td>
              <table width=100%> 
                 <tr> 
                    <td width=65%>
                      <label for="carry1">
                      <input onclick=inputChangCarry(16) type=radio id=carry1 name=carry> <fmt:message key="calculator.hex.label"/>  
                      </label>
                      <label for="carry2">
                      <input onclick=inputChangCarry(10) type=radio id=carry2 checked name=carry> <fmt:message key="calculator.decimalist.label"/> 
                      </label>
                      <label for="carry3">
                      <input onclick=inputChangCarry(8)  type=radio id=carry3 name=carry> <fmt:message key="calculator.octal.label"/> 
                      </label>
                      <label for="carry4">
                      <input onclick=inputChangCarry(2) type=radio id=carry4 name=carry> <fmt:message key="calculator.binary.label"/>
                      </label>
                     </td> 
                     <td width=35% align="right" style="padding-right:5px;">
                      <label for="angle1">
                      <input onclick="inputChangAngle('d')" type=radio checked value=d id=angle1 name=angle> <fmt:message key="calculator.angle.label"/> 
                      </label>
                      <label for="angle2">
                      <input onclick="inputChangAngle('r')" type=radio value=r id=angle2 name=angle> <fmt:message key="calculator.radian.label"/> 
                      </label>
                     </td>
                   </tr>
                 </table>
        
                 <table width=100%>  
                    <tr> 
                      <td width="35%">
                      	  <label for="shiftf">
                          <input onclick="inputshift()" type=checkbox value="ON" id=shiftf name=shiftf> <fmt:message key="calculator.crackajack.label"/>
                          </label>
                          <label for="hypf">
                          <input onclick="inputshift()" type=checkbox value="ON" id=hypf name=hypf> <fmt:message key="calculator.hyperbola.label"/>
                          </label>
                      </td> 
                      <td width="30%">
                          <input class="lightgrey" readOnly size=1 name=bracket>&nbsp;&nbsp;
                          <input class="lightgrey" readOnly size=1 name=memory>&nbsp;&nbsp;
                          <input class="lightgrey" readOnly size=1 name=operator>
                      </td> 
                      <td width="35%" align="right" class="paddingRight5">
                          <input class="button colorRed" onclick=backspace() type=button value=" <fmt:message key='calculator.backspace.label'/> ">&nbsp;&nbsp;
						  <input onclick="document.calc.display.value = 0 " type=button  class="button colorRed" value=" <fmt:message key='calculator.clear.label'/> ">&nbsp;&nbsp;
						  <input onclick="clearall()" type=button  class="button colorRed" value=" <fmt:message key='calculator.clearAll.label'/> ">  
                        </td>
                    </tr>
                  </table> 
        
                  <table width=100%> 
                    <tbody> 
                    <tr> 
                      <td> 
                        <table> 
                          <tbody> 
                          <tr align=middle> 
                            <td><input class="button colorBlue" onclick="inputfunction('pi','pi')" type=button value=" PI " name=pi>  
                              </td> 
                            <td><input class="button colorBlue" onclick="inputfunction('e','e')" type=button value=" E  " name=e>  
                              </td> 
                            <td><input class="button colorPink" onclick="inputfunction('dms','deg')" type=button value=d.ms name=bt>  
                              </td></tr> 
                          <tr align=middle> 
                            <td><input class="button colorPink" onclick=addbracket() type=button value=" (  ">  
                              </td> 
                            <td><input class="button colorPink" onclick=disbracket() type=button value=" )  ">  
                              </td> 
                            <td><input class="button colorPink" onclick="inputfunction('ln','exp')" type=button value=" ln " name=ln>  
                              </td></TR> 
                          <tr align=middle> 
                            <td><input class="button colorPink" onclick="inputtrig('sin','arcsin','hypsin','ahypsin')" type=button value="sin " name=sin>  
                              </td> 
                            <td><input class="button colorPink" onclick="operation('^',7)" type=button value="x^y ">  
                              </td> 
                            <td><input class="button colorPink" onclick="inputfunction('log','expdec')" type=button value="log " name=log>  
                              </td></tr> 
                          <tr align=middle> 
                            <td><input class="button colorPink" onclick="inputtrig('cos','arccos','hypcos','ahypcos')" type=button value="cos " name=cos>  
                              </td> 
                            <td><input class="button colorPink" onclick="inputfunction('cube','cubt')" type=button value="x^3 " name=cube>  
                              </td> 
                            <td><input class="button colorPink" onclick="inputfunction('!','!')" type=button value=" n! ">  
                              </td></tr> 
                          <tr align=middle> 
                            <td><input class="button colorPink" onclick="inputtrig('tan','arctan','hyptan','ahyptan')" type=button value="tan " name=tan>  
                              </td> 
                            <td><input class="button colorPink" onclick="inputfunction('sqr','sqrt')" type=button value="x^2 " name=sqr>  
                              </td> 
                            <td><input class="button colorPink" onclick="inputfunction('recip','recip')" type=button value="1/x ">  
                              </td></tr></tbody></table></td> 
                      <td width=30></td> 
                      <td> 
                        <table> 
                          <tbody> 
                          <tr> 
                            <td><input class="button colorRed" onclick=putmemory() type=button value=" <fmt:message key='calculator.store.label'/> ">  
                              </td></tr> 
                          <tr> 
                            <td><input class="button colorRed" onclick=getmemory() type=button value=" <fmt:message key='calculator.getStore.label'/> ">  
                              </td></tr> 
                          <tr> 
                            <td><input class="button colorRed" onclick=addmemory() type=button value=" <fmt:message key='calculator.addStore.label'/> ">  
                              </td></tr>
                          <tr> 
                            <td><input class="button colorRed" onclick=multimemory() type=button value=" <fmt:message key='calculator.cumulationStore.label'/> ">  
                              </td></tr> 
                          <tr> 
                            <td height=33><input class="button colorRed" onclick=clearmemory() type=button value=" <fmt:message key='calculator.clearStore.label'/> ">  
                              </td></tr></tbody></table></td> 
                      <td width=30></td> 
                      <td> 
                        <table> 
                          <tbody> 
                          <tr align=middle> 
                            <td><input class="button colorBlue" onclick="inputkey('7')" type=button value=" 7 " name=k7>  
                              </td> 
                            <td><input class="button colorBlue" onclick="inputkey('8')" type=button value=" 8 " name=k8>  
                              </td> 
                            <td><input class="button colorBlue" onclick="inputkey('9')" type=button value=" 9 " name=k9>  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('/',6)" type=button value=" / ">  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('%',6)" type=button value=" <fmt:message key='calculator.getResidual.label'/> ">  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('&',3)" type=button value=" <fmt:message key='calculator.and.label'/> ">  
                              </td></tr>
                          <tr align=middle> 
                            <td><input class="button colorBlue" onclick="inputkey('4')" type=button value=" 4 " name=k4>  
                              </td> 
                            <td><input class="button colorBlue" onclick="inputkey('5')" type=button value=" 5 " name=k5>  
                              </td> 
                            <td><input class="button colorBlue" onclick="inputkey('6')" type=button value=" 6 " name=k6>  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('*',6)" type=button value=" * ">  
                              </td> 
                            <td><input class="button colorRed" onclick="inputfunction('floor','deci')" type=button value=" <fmt:message key='calculator.getInteger.label'/> " name=floor>  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('|',1)" type=button value=" <fmt:message key='calculator.or.label'/> ">  
                              </td></tr>
                          <tr align=middle> 
                            <td><input class="button colorBlue" onclick="inputkey('1')" type=button value=" 1 ">  
                              </td> 
                            <td><input class="button colorBlue" onclick="inputkey('2')" type=button value=" 2 " name=k2>  
                              </td> 
                            <td><input class="button colorBlue" onclick="inputkey('3')" type=button value=" 3 " name=k3>  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('-',5)" type=button value=" - ">  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('<',4)" type=button value=" <fmt:message key='calculator.moveToLeft.label'/> ">  
                              </td> 
                            <td><input class="button colorRed" onclick="inputfunction('~','~')" type=button value=" <fmt:message key='calculator.not.label'/> ">  
                              </td></tr>
                          <tr align=middle> 
                            <td><input class="button colorBlue" onclick="inputkey('0')" type=button value=" 0 ">  
                              </td> 
                            <td><input class="button colorBlue" onclick=changeSign() type=button value=+/->  
                              </td> 
                            <td><input class="button colorBlue" onclick="inputkey('.')" type=button value=" . " name=kp>  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('+',5)" type=button value=" + ">  
                              </td> 
                            <td><input class="button colorRed" onclick=result() type=button value=" ＝ ">  
                              </td> 
                            <td><input class="button colorRed" onclick="operation('x',2)" type=button value=" <fmt:message key='calculator.notSame.label'/> ">  
                              </td></tr>
                          <tr align=middle> 
                            <td><input class="button colorBlue" disabled onclick="inputkey('a')" type=button value=" A " name=ka>  
                              </td> 
                            <td><input class="button colorBlue" disabled onclick="inputkey('b')" type=button value=" B " name=kb>  
                              </td> 
                            <td><input class="button colorBlue" disabled onclick="inputkey('c')" type=button value=" C " name=kc>  
                              </td> 
                            <td><input class="button colorBlue" disabled onclick="inputkey('d')" type=button value=" D " name=kd>  
                              </td> 
                            <td><input class="button colorBlue" disabled onclick="inputkey('e')" type=button value=" E　" name=ke>  
                              </td> 
                            <td><input class="button colorBlue" disabled onclick="inputkey('f')" type=button value=" F　" name=kf>  
                              </td></tr>
                              </tbody>
                           </table>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      </div>
      </td>
      </tr>
      </table>
</body>
</html>