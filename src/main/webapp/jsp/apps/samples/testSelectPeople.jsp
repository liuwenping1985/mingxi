<%--
 $Author: wuym $
 $Rev: 282 $
 $Date:: 2012-07-31 18:06:42#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>选人测试</title>
<script type="text/javascript">
  $(function() {
    $("#btn1").click(function() {
      $.selectPeople({
        panels: 'Account,Department,Team,Post,Level,Role',
        selectType: 'Member',
        params : {
          text : '开发中心、人员1',
          value : 'Department | -884316703172445_1,Member | 1730833917365171641'
        },
        callback : function(ret) {
          alert(ret.value + ":" + ret.text);
        }
      });
    });
    $("#btn2").click(function() {
      var ret = $.selectPeople({
        panels: 'Account,Department,Team,Post,Level,Role',
        selectType: 'Member',
        params : {
          text : '开发中心、人员1',
          value : 'Department | -884316703172445_1,Member | 1730833917365171641'
        },
        mode : 'open'
      });
      alert(ret.value + ":" + ret.text);
    });
  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <div>
        <div class="common_txtbox_wrap1">
            <div>Div方式：</div>
            <input type="text" id="spc1" name="spc1" class="comp"
                comp="type:'selectPeople',value:'Department | -884316703172445_1,Member | 1730833917365171641',text:'开发中心、人员1',panels:'Account,Department,Team,Post,Level,Role',selectType:'Member'" />
        </div>
        <div class="common_txtbox_wrap1">
            <div>对话框方式：</div>
            <input type="text" id="spc1" name="spc1" class="comp"
                comp="type:'selectPeople',mode:'open',value:'Department | -884316703172445_1,Member | 1730833917365171641',text:'开发中心、人员2',panels:'Account,Department,Team,Post,Level,Role',selectType:'Member'" />
        </div>
        <div class="common_txtbox_wrap1">
            <div>自定义弹出Div：</div>
            <input type="button" id="btn1" value="选人" />
        </div>
        <div class="common_txtbox_wrap1">
            <div>自定义弹出对话框：</div>
            <input type="button" id="btn2" value="选人" />
        </div>
<input type="text" id="spc2" name="spc1" class="comp" comp="type:'selectPeople',mode:'open',panels:'Account,Department,Team,Post,Level,Role,Outworker',selectType:'Account,Department,Team,Post,Level,Role,Outworker,Member',showFlowTypeRadio: true"/>
        <hr />
        <div class="form_area">
            <div class="one_row">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr id="metacontainer">
                            <th nowrap="nowrap"><label class="margin_r_10" for="text">硬编码:</label></th>
                            <td><div class="common_txtbox_wrap">
                                    <input type="text" id="text" value="以下为元数据自动生成">
                                </div></td>
                        </tr>
                        <tr class="metadata" metadata="orgMemberTest.age"></tr>
                    </tbody>
                </table>

            </div>
            <div class="align_center">
                <a href="javascript:void(0)" id="btnValidate" class="common_button common_button_gray">校验</a> <a
                    href="javascript:void(0)" class="common_button common_button_gray">取消</a>
            </div>
        </div>
        <div>
            元数据定义：<br />
            <textarea cols="100" rows="30">
<table name="orgMemberTest" class="com.seeyon.ctp.organization.po.OrgMember">
	<column name="gender">
		<label>samples.ServerState.minute.label</label>
		<alias>g</alias>
		<sort>5</sort>
		<type>2</type>
		<datatype>2</datatype>
		<width>100</width>
		<rule>type:'string',maxLength:2,minLength:1</rule>
	</column>
	<column name="tel">
		<label>samples.ServerState.forecastTime.label</label>
		<sort>5</sort>
		<type>1</type>
		<component>codecfg</component>
		<rule>codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyEnums',defaultValue:4
		</rule>
	</column>
	<column name="level">
		<label>samples.ServerState.comment.label</label>
		<sort>3</sort>
		<type>2</type>
		<component>selectPeople</component>
		<rule>mode:'open'</rule>
	</column>
	<column name="age">
		<label>com.seeyon.ctp.organization.metadata.age</label>
		<alias>a</alias>
		<sort>5</sort>
		<type>2</type>
		<component>calendar</component>
		<rule>ifFormat:'%Y-%m-%d'</rule>
	</column>
	<column>
		<label>null name test</label>
		<sort>5</sort>
		<type>2</type>

	</column>
</table>	
		</textarea>
        </div>
    </div>
    <script type="text/javascript" src="${path}/metadata.do?tables=orgManagerTest"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=metadataManager"></script>
    <script>
          $.metadataForm('#metacontainer', 'orgMemberTest', {
            'columns' : [ 'age', 'gender', 'tel', 'level' ],
            position : 'after'
          });

          $('#btnValidate').click(function() {
            $("#metacontainer").validate();
          });
        </script>

</body>
</html>
