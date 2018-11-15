<%--
 $Author: dengcg $
 $Rev: 261 $
 $Date:: 2012-08-09 10:00:12#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html><head>
<style type="text/css">
.input-100{
	width: 100%;
	BORDER-TOP:1 Solid #86AFC7;
   	BORDER-LEFT:1 Solid #86AFC7;
   	BORDER-RIGHT:1 Solid #86AFC7;
   	BORDER-BOTTOM:1 Solid #86AFC7;  
}
.leftarea_showupdown{
    width: 250px;
}
.rightarea_showupdown{
    width: 250px;
}
</style>
</head>
<body class="over_hidden" onload="init();" style="bacground:#fafafa;padding:0px 20px;">
<table  width="570" height="100%" border="0" cellpadding="0"  cellspacing="0" class="font_size12 margin_t_5 margin_l_5">
  <tr>
    <td >
	   <table class="margin_t_5" border="0" cellpadding="0" width="570" cellspacing="0" align="center">	       
		 <tr>
		   <td class="leftarea_showupdown" valign="top">		   
		     <table class="leftarea_showupdown" cellSpacing=0 cellPadding=0  border=0 id=leftarea>
				<tr>
				    <td class="margin_t_5">
				  	     <span id=LeftUpTitle></span>
				  	     <span id=showsearch style="display: none;">: <input type="text" id="searchtext" style="width:40%;"/>
		       		         <span class="ico16 search_16" id="searchbtn" href="javascript:void(0)"></span> 
		       		     </span>
			         </td>				
			    </tr>
                <tr>
				    <td>
				        <select name="dataarea" id="leftupdataarea" size="16" multiple="multiple" class="input-100 margin_t_5" style="height: 275px;"></select>
				    </td>
			     </tr>
			     <tr><td id=LeftDownTitle class="padding_t_5" height="22"></td></tr>
			     <tr>
			         <td>
			             <select name="systemdataarea" id="leftdowndataarea" size="6" multiple="multiple" class="input-100 margin_t_5 hidden" style="height: 93px;">
			             </select>
			         </td>
			     </tr>
			 </table>
		  </td>
		   <td width="40" align="center" valign="middle">
		           <span id="add" class="ico16 select_selected"></span>
	               <br>
	               <br>
	               <span id="del" class="ico16 select_unselect"></span>
	      </td>
		   <td valign="top">
		       <table class="rightarea_showupdown" cellSpacing=0 cellPadding=0  border=0>
				<tr>
				  <td id=RightTitle class="margin_t_5" height="22">	 
				</td>				
			 </tr>
			 <tr>
				<td>				
		          <select name="dataarea" id="rightdataarea" multiple="multiple" class="input-100 margin_t_5" style="height: 400px;">
				 </select>
				</td>
			 </tr>
	        </table>	
		   </td>
		   <td id="UpAndDown"  width="40" align="center" valign="middle" style="display: none;">  
		      <div >
			      <span id="up"  class="ico16 sort_up"></span>
			     <br><br>
				 <span id="down"  class="ico16 sort_down"></span>
		      </div>
		   </td>
	     </tr>
      </table>
	</td>
  </tr>

  <tr id='readme' class="hidden">
                            <td colSpan=2>
                           <font color="green">${ctp:i18n('form.forminputchoose.reaseme')}<br>
                           ${ctp:i18n('form.forminputchoose.reasemedetail')}
                        </td>
                        </tr>
	<tr>
		<td colSpan=2 align="left" style="padding-left: 285px;padding-top:3px;">
			${ctp:i18n('form.fastmaking.showType.text')}：<select name="showTypeSelected" id="showTypeSelected" >
			<option value="0" inputtype="select" selected="selected">${ctp:i18n('form.fastmaking.showType.aloneshow')}</option>
			<option value="1" inputtype="select">${ctp:i18n('form.fastmaking.showType.comblockshow')}</option>
		</select>
		</td>
	</tr>
</table>
<%@ include file="forminputchoose.js.jsp"%>
</body>
</html>
