<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<html>
<head>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
try{
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
    showCtpLocation("F12_calendar");
}catch(e){
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="menu.tools.calendar" /></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/v3xmain/css/calendar.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/eternityCalendar.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<%--在A8下可以隐藏当前位置，在NC下从别的菜单切换到万年历，当前位置仍然存在--%>
try{
top.hiddenNavigationFrameset(1004);
}catch(e){
}
<%-- 这里改成getA8Top()引入V3X.JS会报错,以后需要更好的解决方法. --马志骋
top.hiddenNavigationFrameset(1004);
--%>
</script>
<script language="VBScript">
<!--
'===== 算世界时间
Function TimeAdd(UTC,T)
   Dim PlusMinus, DST, y,tSave
   If Left(T,1)="-" Then PlusMinus = -1 Else PlusMinus = 1
   UTC=Right(UTC,Len(UTC)-5)
   UTC=Left(UTC,Len(UTC)-4)
   y = Year(UTC)
   TimeAdd=DateAdd("n", (Cint(Mid(T,2,2))*60 + Cint(Mid(T,4,2))) * PlusMinus, UTC)
   '美国日光节约期间: 4月第一个星日00:00 至 10月最後一个星期日00:00
   If Mid(T,6,1)="*" And DateSerial(y,4,(9 - Weekday(DateSerial(y,4,1)) mod 7) ) <= TimeAdd And DateSerial(y,10,31 - Weekday(DateSerial(y,10,31))) >= TimeAdd Then
      TimeAdd=CStr(DateAdd("h", 1, TimeAdd)) & "<FONT STYLE='font-size:18pt;font-family:Wingdings; color:red'>R</FONT>"
   Else
   End If
   TimeAdd = CStr(TimeAdd)
End Function
'-->
</script>
<meta content="MSHTML 5.00.3315.2870" name=GENERATOR></head>
<body  onload=initial() topMargin=10 class="border_lr border-top">
<script language=JavaScript>
  if(v3x.isMSIE && parseInt(navigator.appVersion) < 4){
    document.write("<fmt:message key="menu.tools.calendar.nosupport" />");
  }

</script>

<script language=JavaScript>
lck=0;
function r(hval)
{
if ( lck == 0 ){document.bgColor=hval;}
}
</script>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" id="calendar-layout">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		       	 	<td width="45" class="page2-header-img"><div class="bulltenIndex"></div></td>
					<td class="page2-header-bg">&nbsp;<fmt:message key="menu.tools.calendar" /></td>
					<td class="page2-header-line padding-right" align="right">&nbsp;</td>
			    </tr>
			 </table>
		</td>
	</tr>
<tr>
<td valign="top">
<div id="detail"></div>
<center>
<form name=CLD>
<table align="center">
  <tbody>
  <tr>
    <td align=middle vAlign=top><br><font size=2 class="font9pt"><fmt:message key="menu.tools.calendar.localtime" />:</font><br><font color=#000080 face=Arial  class="font9pt"
      id=Clock size=4 align="center"></font>
      <p><!--时区 *表示自动调整为日光节约时间--><font size=2 class="font9pt"><select 
      name=TZ onchange=changeTZ() class="font9pt"> <option
        value="-1200 <fmt:message key="menu.tools.calendar.internationlchange.value" />"><fmt:message key="menu.tools.calendar.internationlchange" /><option value="-1100 <fmt:message key="menu.tools.calendar.samoyta.value" />"><fmt:message key="menu.tools.calendar.samoyta" /><option 
        value="-1000 <fmt:message key="menu.tools.calendar.xiaweiyi" />"><fmt:message key="menu.tools.calendar.xiaweiyi" /><option value=-0900*<fmt:message key="menu.tools.calendar.alasijia" />><fmt:message key="menu.tools.calendar.alasijia" /><option 
        value=-0800*<fmt:message key="menu.tools.calendar.taipingyang.value" />><fmt:message key="menu.tools.calendar.taipingyang" /><option value=-0700*<fmt:message key="menu.tools.calendar.meiguoshanqu.value" />><fmt:message key="menu.tools.calendar.meiguoshanqu" /><option 
        value=-0700*<fmt:message key="menu.tools.calendar.meijiashanqu.value" />><fmt:message key="menu.tools.calendar.meijiashanqu" /><option value=-0600*<fmt:message key="menu.tools.calendar.jianadazhong.value" />><fmt:message key="menu.tools.calendar.jianadazhong" /><option 
        value=-0600*<fmt:message key="menu.tools.calendar.moxige.value" />><fmt:message key="menu.tools.calendar.moxige" /><option value=-0600*<fmt:message key="menu.tools.calendar.meijiazhong" />><fmt:message key="menu.tools.calendar.meijiazhong" /><option 
        value=-0500*<fmt:message key="menu.tools.calendar.nanmeitaipingyang.value" />><fmt:message key="menu.tools.calendar.nanmeitaipingyang" /><option value=-0500*<fmt:message key="menu.tools.calendar.meijiadongbu" />><fmt:message key="menu.tools.calendar.meijiadongbu" /><option 
        value=-0500*<fmt:message key="menu.tools.calendar.meidong.value" />><fmt:message key="menu.tools.calendar.meidong" /><option value=-0400*<fmt:message key="menu.tools.calendar.nanmeizhouxibu.value" />><fmt:message key="menu.tools.calendar.nanmeizhouxibu" /><option 
        value="-0400*<fmt:message key="menu.tools.calendar.daxiyang.value" />"><fmt:message key="menu.tools.calendar.daxiyang" /><option value="-0330 <fmt:message key="menu.tools.calendar.niufenlan.value" />"><fmt:message key="menu.tools.calendar.niufenlan" /><option 
        value="-0300 <fmt:message key="menu.tools.calendar.dongnanmeizhou.value" />"><fmt:message key="menu.tools.calendar.dongnanmeizhou" /><option value="-0300 <fmt:message key="menu.tools.calendar.nanmeidongbu.value" />"><fmt:message key="menu.tools.calendar.nanmeidongbu" /><option 
        value=-0200*<fmt:message key="menu.tools.calendar.daxiyangzhongbu" />><fmt:message key="menu.tools.calendar.daxiyangzhongbu" /><option value=-0100*<fmt:message key="menu.tools.calendar.yasuer.value" />><fmt:message key="menu.tools.calendar.yasuer" /><option 
        value="+0000 <fmt:message key="menu.tools.calendar.yingguoxialing.value" />"><fmt:message key="menu.tools.calendar.yingguoxialing" /><option 
        value="+0000 <fmt:message key="menu.tools.calendar.gelinweizhibiaozhun.value" />"><fmt:message key="menu.tools.calendar.gelinweizhibiaozhun" /><option 
        value="+0100 <fmt:message key="menu.tools.calendar.luoma.value" />"><fmt:message key="menu.tools.calendar.luoma" /><option value="+0100 <fmt:message key="menu.tools.calendar.zhongou.value" />"><fmt:message key="menu.tools.calendar.zhongou" /><option 
        value="+0100 <fmt:message key="menu.tools.calendar.xiou.value" />"><fmt:message key="menu.tools.calendar.xiou" /><option 
        value="+0200 <fmt:message key="menu.tools.calendar.yisilie" />"><fmt:message key="menu.tools.calendar.yisilie" /><option value=+0200*<fmt:message key="menu.tools.calendar.dongou" />><fmt:message key="menu.tools.calendar.dongou" /><option 
        value=+0200*<fmt:message key="menu.tools.calendar.aiji.value" />><fmt:message key="menu.tools.calendar.aiji" /><option value=+0200*<fmt:message key="menu.tools.calendar.GFT.value" />>GFT<option 
        value=+0200*<fmt:message key="menu.tools.calendar.nanfei.value" />><fmt:message key="menu.tools.calendar.nanfei" /><option 
        value=+0300*<fmt:message key="menu.tools.calendar.shawudialabo.value" />><fmt:message key="menu.tools.calendar.shawudialabo" /><option 
        value=+0300*<fmt:message key="menu.tools.calendar.eluosi.value" />><fmt:message key="menu.tools.calendar.eluosi" /><option value=+0330*<fmt:message key="menu.tools.calendar.yilang.value" />><fmt:message key="menu.tools.calendar.yilang" /><option 
        value=+0400*<fmt:message key="menu.tools.calendar.alabo.value" />><fmt:message key="menu.tools.calendar.alabo" /><option 
        value=+0430*<fmt:message key="menu.tools.calendar.afuhan.value" />><fmt:message key="menu.tools.calendar.afuhan" /><option value="+0500 <fmt:message key="menu.tools.calendar.xiya.value" />"><fmt:message key="menu.tools.calendar.xiya" /><option 
        value="+0530 <fmt:message key="menu.tools.calendar.yindu.value" />"><fmt:message key="menu.tools.calendar.yindu" /><option 
        value="+0600 <fmt:message key="menu.tools.calendar.zhongya.value" />"><fmt:message key="menu.tools.calendar.zhongya" /><option value="+0700 <fmt:message key="menu.tools.calendar.mangu.value" />"><fmt:message key="menu.tools.calendar.mangu" /><option selected
        value="+0800 <fmt:message key="menu.tools.calendar.zhongguo.value" />"><fmt:message key="menu.tools.calendar.zhongguo" /><option value="+0800 <fmt:message key="menu.tools.calendar.taibei.value" />"><fmt:message key="menu.tools.calendar.taibei" /><option 
        value="+0900 <fmt:message key="menu.tools.calendar.dongjing.value" />"><fmt:message key="menu.tools.calendar.dongjing" /><option 
        value="+0930 <fmt:message key="menu.tools.calendar.aozhouzhongbu.value" />"><fmt:message key="menu.tools.calendar.aozhouzhongbu" /><option value="+1000 <fmt:message key="menu.tools.calendar.cideni.value" />"><fmt:message key="menu.tools.calendar.cideni" /><option 
        value="+1000 <fmt:message key="menu.tools.calendar.tasimeiniya.value" />"><fmt:message key="menu.tools.calendar.tasimeiniya" /><option value="+1000 <fmt:message key="menu.tools.calendar.xitaipingyang.value" />"><fmt:message key="menu.tools.calendar.xitaipingyang" /><option 
        value=+1100*<fmt:message key="menu.tools.calendar.taipingyangzhongbu.value" />><fmt:message key="menu.tools.calendar.taipingyangzhongbu" /><option 
        value="+1200 <fmt:message key="menu.tools.calendar.niuxilan.value" />"><fmt:message key="menu.tools.calendar.niuxilan" /><option 
      value="+1200 <fmt:message key="menu.tools.calendar.feiji.value" />"><fmt:message key="menu.tools.calendar.feiji" /></option></select><fmt:message key="menu.tools.calendar.time" /></font><br><font
      color=#000080 face=Arial id=Clock2 size=4 align="center" class="font9pt"></font><br><font
      style="color: green; font-family: Webdings; font-size: 120pt">û</font><br><font
      id=CITY 
      style="color: blue; font-family: '新细明体'; font-size: 9pt; width: 150px"></font></p>
      <p align=middle vAlign="top"></p></td>
    <td align="center">
      <div style="position: absolute; top: 80px; z-index: -1"><font id=YMBG 
      class="bgfont"> 0000<br> JUN</font> 
      </div>
      <table border=0>
        <tbody>
        <tr>
          <td class="titleBg" colSpan=7><font color=#ffffff size=2 
            style="font-size: 9pt"><fmt:message key="menu.tools.calendar.gongli" /><select name=SY onchange=changeCld() 
            style="font-size: 9pt"> 
              <script language=JavaScript><!--
            for(i=1900;i<=2050;i++) document.write('<option>'+i)
            //--></script>
            </select><fmt:message key="menu.tools.calendar.nian" /><select name=SM onchange=changeCld() 
            style="font-size: 9pt"> 
              <script language=JavaScript><!--
            for(i=1;i<13;i++) document.write('<option>'+i)
            //--></script>
            </select><fmt:message key="menu.tools.calendar.yue" /></font><font color=black face=标楷体 id=GZ 
            size=3></font><br></td></tr>
        <tr align="center" class="weekBg">
          <td width=54 height="24"><font color=red><b><fmt:message key="menu.tools.calendar.ri" /></b></font></td>
          <td width=54><b><fmt:message key="menu.tools.calendar.yi" /></b></td>
          <td width=54><b><fmt:message key="menu.tools.calendar.er" /></b></td>
          <td width=54><b><fmt:message key="menu.tools.calendar.san" /></b></td>
          <td width=54><b><fmt:message key="menu.tools.calendar.si" /></b></td>
          <td width=54><b><fmt:message key="menu.tools.calendar.wu" /></b></td>
          <td width=54><font color=green><b><fmt:message key="menu.tools.calendar.liu" /></b></font></td></tr>
        <script language=JavaScript><!--
            var gNum
            for(i=0;i<6;i++) {
               document.write('<tr align=center>')
               for(j=0;j<7;j++) {
                  gNum = i*7+j
                  document.write('<td id="GD' + gNum +'" onMouseOver="mOvr(' + gNum +')" onMouseOut="mOut()"><font id="SD' + gNum +'" size=3 face="Arial Black" ')
                  if(j == 0) document.write(' color=red')
                  if(j == 6)
                     if(i%2==1) document.write(' color=red')
                        else document.write(' color=green')
                  document.write(' TITLE=""> </font><br><font id="LD' + gNum + '"  class="font9pt"> </font></td>')
               }
               document.write('</tr>')
            }
            //--></script>
        </tbody></table></td>
    <td align="center" vAlign=top width=50><br><br><br><br><button  type="button"
      onclick="pushBtm('YU')" class="font9pt" style="width: auto;"><fmt:message key="menu.tools.calendar.nian" />↑</button><br><button type="button"
      onclick="pushBtm('YD')" style="width: auto;"><fmt:message key="menu.tools.calendar.nian" />↓</button> 
      <p><button type="button" onclick="pushBtm('MU')" 
      class="font9pt" style="width: auto;"><fmt:message key="menu.tools.calendar.yue" />↑</button><br><button  type="button" onclick="pushBtm('MD')" 
      class="font9pt" style="width: auto;"><fmt:message key="menu.tools.calendar.yue" />↓</button> 
      <p><button type="button" id="today" onclick="pushBtm('')" class="font9pt" style="width: auto;"><fmt:message key="menu.tools.calendar.today" /></button>
  </p></td></tr></tbody></table></form>
<p></p>
<hr class="colorGreen" noShade size=1 width="90%">
<div align="center">
<font face=ARIAL size=2 class="font9pt"><fmt:message key="menu.tools.calendar.yilizhong" /><font class="colorRed"><fmt:message key="menu.tools.calendar.red" /></font>/<font class="colorGreen"><fmt:message key="menu.tools.calendar.green" /></font><font class="colorBlack"><fmt:message key="menu.tools.calendar.jiejiari" /><font 
class="colorGreen"><fmt:message key="menu.tools.calendar.green" /></font><fmt:message key="menu.tools.calendar.24" /><font class="colorRed"><fmt:message key="menu.tools.calendar.red" /></font><fmt:message key="menu.tools.calendar.ct" /><font 
class="colorBlue"><fmt:message key="menu.tools.calendar.blue" /></font><fmt:message key="menu.tools.calendar.gzjjr" /><br></font></font>
</div>
</center>
</td>
</tr>
</table>
</body>
</html>
