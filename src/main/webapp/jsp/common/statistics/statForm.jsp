<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<form id="memberForm" name="memberForm" method="post" action="">
    <div class="left" style="width:60%;" >
        <p class="align_right">&nbsp;</p>
        <table width="90%" border="0" cellspacing="0" cellpadding="0" class="margin_l_10">
            <input type="hidden" id="id" value="-1">
            <input type="hidden" id="deptIds" value="-1">   
            <input type="hidden" id="parentId" value="-1">
            <input type="hidden" id="initState" value="0"> 
            <input type="hidden" id="recNode" value=""> 
            <input type="hidden" id="sendNode" value="">
            <!--name-->
            <tr>
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('addressbook.team_form.name.label')}:</label>
                </th>
                <td width="100%"><div class="common_txtbox_wrap">
                        <input type="text" id="name" name="name" class="validate" validate="type:'string',name:'${ctp:i18n('addressbook.team_form.name.label')}',notNull:true,maxLength:100,avoidChar:'><\'|,&quot'" />
                    </div>
                </td>
            </tr>
            <!--orderNo-->
            <tr>
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('hr.nameList.number.label')}:</label>
                </th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="orderNo" name="orderNo" value="" class="validate" validate="isInteger:true,name:'${ctp:i18n('hr.nameList.number.label')}',notNullWithoutTrim:true,minValue:0,maxLength:4,max:127" />
                    </div>
                </td>
            </tr>
         
            <tr class="forInter">
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text" id="dpetLable">${ctp:i18n('org.member_form.deptName.label')}:</label></th>
                <td><div class="common_txtbox clearfix word_break_all">
                        <textarea id="deptNames" rows="4" class="validate w100b" validate="type:'string', name:'${ctp:i18n('org.member_form.deptName.label')}', notNullWithoutTrim:true,maxLength:400" readonly="true"></textarea>
                    </div>
                </td>
            </tr>
           
            <tr style="margin-top: 10px;margin-bottom: 10px" id="twoAuth">
            	<td colspan="2">
            	<fieldset style="margin-top:10px;margin-bottom:10px;border:1px solid #ccc;">          	
			    	<legend>
			    		<font color="red">*</font>统计条件:
			    	</legend>
			    	
			    	<table>
		           		<tr id="sendAuth">
			                <th nowrap="nowrap"><label class="margin_r_10" for="text">发文权限:</label></th>
			                <td width="100%">
			                	<div class="common_txtbox_wrap">
			                        <input type="text" id="statNodePolicy" name="statNodePolicy" readonly="true" class="validate"/>
			                    </div>
			                </td>				             				                               
			            </tr> 				            
			            <tr id="recAuth">
			                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">收文权限:</label></th>
			                <td width="100%">
			                	<div class="common_txtbox_wrap">
			                        <input type="text" id="recNodePolicy" name="recNodePolicy"  class="validate" validate="type:'string',name:'收文权限',notNullWithoutTrim:true,maxLength:200" readonly="true"/>
			                    </div>
			                </td>
			            </tr>
           			</table>
           				
			    </fieldset>
            	</td>
            	            	
                <td style="vertical-align:top;padding-top:18px;" id="explain">
               		&nbsp<a style="display:inline-block;color:#000; border:1px solid #111;background-color:#f7f7f7; height:20px;width:30px; text-align:center; line-height:22px"  href="javascript:void(0)" id="showInstruction" onclick="showInstruction();">说明</a>
                </td>
            </tr>
           
            <tr>
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('mt.mtSummaryTemplate.usedFlag')}:</label>
                </th>
                <td>
                    <div class="common_radio_box clearfix">
                        <label class="margin_r_10 hand">
                            <input type="radio" value="0"  name="state"
                            class="radio_com m_enable">${ctp:i18n('common.state.normal.label')}
                        </label>
                        <label class="margin_r_10 hand">
                            <input type="radio" value="1"  name="state"
                            class="radio_com m_enable">${ctp:i18n('common.state.invalidation.label')}
                        </label>
                    </div>
                </td>
            </tr>
             <!--descprition-->
            <tr class="forInter">
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('addressbook.category_form.memo.label')}:</label></th>
                <td><div class="common_txtbox clearfix word_break_all">
                        <textarea id="comments" rows="4" class="validate w100b" validate="type:'string', name:'${ctp:i18n('addressbook.category_form.memo.label')}',maxLength:200"></textarea>
                    </div>
                </td>
            </tr>
            <tr class="forInter" id="timeSection">
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">时间段:</label></th>
                <td><div class="common_txtbox clearfix word_break_all">
					 <input type="checkbox" name="timeType1" value="1" />2个工作日
					 <input type="checkbox" name="timeType2" value="2" />3至5个工作日
					 <input type="checkbox" name="timeType3" value="3" />5个工作日后
					 <input type="checkbox" name="timeType4" value="4" />仍未签收
                    </div>
                </td>
            </tr>
            <tr class="forInter" id="sendCateory">
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('addressbook.account_form.category.label')}:</label></th>
                <td><div class="common_txtbox clearfix word_break_all" id="sendDiv">
					 <input type="checkbox" name="govType1" value="1" />发文:
					 <input type="checkbox" name="govType2" value="2" />发文数
					 <input type="checkbox" name="govType3" value="3" />字数
					 <input type="checkbox" name="govType4" value="4" />已办结	
					 <input type="checkbox" name="govType5" value="5" />办理中
					 <input type="checkbox" name="govType6" value="6" />办结率
					 <input type="checkbox" name="govType7" value="7" />超期件数
					 <input type="checkbox" name="govType8" value="8" />超期率
                    </div>
                </td>
            </tr>
            <tr class="forInter" id="recCateory">
                <th nowrap="nowrap"></th>
                <td><div class="common_txtbox clearfix word_break_all" id="recDiv">
					 <input type="checkbox" name="govType9"  value="9" />收文:
					 <input type="checkbox" name="govType10"  value="10" />收文数
					 <input type="checkbox" name="govType11"  value="11" />已办结
					 <input type="checkbox" name="govType12"  value="12" />办理中
					 <input type="checkbox" name="govType13"  value="13" />办结率
					 <input type="checkbox" name="govType14"  value="14" />超期件数
					 <input type="checkbox" name="govType15"  value="15" />超期率
                    </div>
                </td>
            </tr>
            <tr class="forInter" id="countCateory">
                <th nowrap="nowrap"></th>
                <td><div class="common_txtbox clearfix word_break_all" id="allDiv">
					 <input type="checkbox" name="govType16"  value="16" />总计:
					 <input type="checkbox" name="govType17"  value="17" />总计
					 <input type="checkbox" name="govType18"  value="18" />已办结
					 <input type="checkbox" name="govType19"  value="19" />办理中
					 <input type="checkbox" name="govType20"  value="20" />办结率
					 <input type="checkbox" name="govType21"  value="21" />超期件数
					 <input type="checkbox" name="govType22"  value="22" />超期率
                    </div>
                </td>
            </tr>
        </table>
    </div>
</form>