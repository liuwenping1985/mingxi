<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<HTML>
<HEAD>
<TITLE>${ctp:i18n('form.forminputchoose.orderconfig')}</TITLE>
<style type="text/css">
body, td, th, input, textarea, div, select, p {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;

}
body {
	margin: 0;
}
form{
	margin: 0px;
}
.width-100 {
	width: 100%;
}
.input-100per{
	width: 100%;
}
.input-70per{
	width: 70%;
}
.input-60per{
	width: 60%;
}
.input-80per{
	width: 80%;
}
.input-50per{
	width: 50%;
}
.input-40per{
	width: 40%;
}
.input-30per{
	width: 30%;
}
.input-25per{
	width: 25%;
}
.input-20per{
	width: 20%;
}
.input-250px{
    width:250px;
}
.input-300px{
    width:300px;
}
.cursor-hand {
	cursor: pointer;
}
.cursor-default {
	cursor: default;
}
.position_absolute{
	position: absolute;
}
.position_relative{
	position: relative;
}
.overflow-hidden{
	overflow:hidden
}
.scrollList{
	float: left;
	clear: left;
	height: 100%;
	width: 100%;
	overflow: auto;
	margin: 0px;
	padding: 0px;
}
.scrollList-alway{
	height: 100%;
	width: 100%;
	overflow: scroll;
	margin: 0px;
	padding: 0px;
	background-color: white;
}
.hidden{
	display: none;
}
.show{
	display: block;
}
.div-float{
	float: left;
}
.div-float-right{
	float: right;
}
.div-clear{
	clear: left;
}
.div-float-clear{
	float: left;
	clear: left;
}
.align_left{
	text-align: left;
}
.align_center{
	text-align: center;
}
.align_right{
	text-align: right;
}
.button-left-margin-10{
	margin-left: 10px !important;
}
.attachment-single {
	height: 22px;
	overflow: hidden;
}
.attachment-all-80 {
	height: 36px;
	overflow: auto;
}
.attachment-all-80 a{
	text-decoration: none;
}
#RTEEditorDiv{
	height: 100%;
}

.wordbreak{
	word-break: break-all;
}
.condition{
	width:105px;
	margin-right: 2px;
}
.textfield{
	width:120px;
	vertical-align:middle;
}
.textfield-search{
	width:100px;
}
.condition-search-div{
	height: 21px;

	vertical-align: middle;
}
.input-date {
  width: 70px;
}
.input-datetime {
  width: 120px;
}
.font-size-14{
	font-size: 14px;
}
.font-size-12{
	font-size: 12px;
}
.padding35{
	padding: 0 35px;
}
.padding355{ 
	padding: 35px 35px 35px 35px;
}
.padding0{
	padding: 0px;
}
.padding10{
	padding: 10px;
}
.margin0{
	margin: 0px;
}
.padding10{
	padding:10px 13px 10px 13px;
}
.margin5{
	margin-right: 5px;
}
.margin-auto{
	margin: auto;
}
.border-padding{
	padding: 5px;
}
.text-bold{
	font-weight: bold;
}
.text-italic{
	font-style: italic;
}
.text-decoration{
	text-decoration: underline;
}
.margin-auto{
	margin-left: auto;
	margin-right: auto;
}
.clearFloat{
	clear: both;
}
.center-layout{
	text-align: center;
}
.clearRight{
	clear: right;
}
.clearLeft{
	clear: left;
}
.break-all{
	word-break:break-all;
}
.keep-all{
	word-break:keep-all;
	white-space:nowrap; 
}
.padding-bottom50{
	padding-bottom: 50px;
}
.divwidth30{
	width: 30px;
}
.color6{
	color: #666666;
}
.padding-5px{
	padding: 5px;
}
.white-space{
	white-space:nowrap;
}
.inline-block{
	display: inline-block;
	margin-bottom:-4px;
}
.background-fff{
	background: #ffffff;
}
</style>
</HEAD>
<BODY onLoad="getparamer();" scroll=no>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 height="100%"> 
  <tr>
    <td class=bg-advance-middel>
	   <table  border="0" cellpadding="0" cellspacing="0">	       
		 <tr>
		   <td align="right">${ctp:i18n('form.forminputchoose.addorder')}：</td>
		   <td>		   
		      <label id="sortdataname"/></td>
		   <td>&nbsp;</td>
		 </tr>
		 <tr><td>&nbsp;</td></tr>
		 <tr>
		   <td align="right">${ctp:i18n('form.forminputchoose.ordertype')}：</td>
		   <td>
		   <label for="asc">
		     <input type="radio" name="sorttype" id="asc" checked="checked" value="0" />
			 ${ctp:i18n('form.query.order.label')}</label>
		   </td>
		   <td>
		   	<label for="desc">
		     <input type="radio" name="sorttype" id="desc" value="1" />
              ${ctp:i18n('form.query.reverseorder.label')}</label>
			  <input type="hidden" id="namespace" value=""/>
		   </td>
		 </tr>
      </table>
	</td>
  </tr>
 
</TABLE>
<%@ include file="forminputchoosesort.js.jsp"%>
</BODY>
</HTML>

