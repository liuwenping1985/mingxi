<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<style>
	tr{
		height:40px;
	}
</style>
<script type="text/javascript">
	showCtpLocation('F13_VJoinSet');
</script>
</head>
<body>
  <div>
    <div style="margin: auto;width:400px;margin-top:10px">
          <form id="myfrm" name="myfrm" method="post">
          <div class="form_area" id='form_area'>
            <input type="hidden" id="id" value="${user.id}" />
            <input type="hidden" id="loginIp" value="${user.loginIp}"/>
            <input type="hidden" id="type" value="${user.type}"/>
            <input type="hidden" id="createTime" value="${user.createTime}">
            <input type="hidden" id="validationip" value="${user.validationip}">
			<input type="hidden" id="isCreate" value="${isCreate}">
            <table border="0" cellspacing="0" cellpadding="0" class="margin_lr_10 margin_t_10" align="center" width="330">
              <tr>
                <th width="70px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.userName')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="userName" class="validate" value="${user.userName}"
                      validate="type:'string',name:'${ctp:i18n('usersystem.restUser.userName')}',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.loginName')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="loginName" class="validate" value="${user.loginName}" validate="type:'string',name:'${ctp:i18n('usersystem.restUser.loginName')}',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.passWord')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="password" id="passWord" name="passWord" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.restUser.passWord')}',notNull:true,minLength:6,maxLength:50"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('usersystem.newpassword.validate')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="password" id="passWord2" name="passWord2" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.newpassword.validate')}',notNull:true,minLength:6,maxLength:50"/>
                  </div>
                </td>
              </tr>
 
              <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.enable')}</label></th>
                <td>
                  <div class="common_txtbox clearfix">
					<c:if test="${isCreate==true}">
						<input type="radio" id="enable" name="enable" value="1" checked="true">${ctp:i18n('usersystem.restUser.enabled')} <input type="radio" id="enable"
                      		name="enable" value="0">${ctp:i18n('usersystem.restUser.unenabled')}
					</c:if>
					<c:if test="${isCreate==false}">
						<input type="radio" id="enable" name="enable" value="1" ${user.enabled == 1 ? 'checked' : ''} >${ctp:i18n('usersystem.restUser.enabled')} <input type="radio" id="enable" value="0"
						  name="enable" ${user.enabled == 0 ? 'checked' : ''}>${ctp:i18n('usersystem.restUser.unenabled')}
					</c:if>
                  </div>
                </td>
              </tr>
              <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.loginIp')}</label></th>
                <td>
                  <div class="text_overflow noClick">
					<input type="checkbox" id="checkip" name="checkip" /> ${ctp:i18n('usersystem.restUser.description')}
                  </div>
                </td>
              </tr> 
			  <tr>
                <th valign="top" width="70"><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.bindip')}</label></th>
                <td>
                  <div class="common_txtbox clearfix" id="ipinput">
                     <input type="text" id="ip" name="ip" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.restUser.loginIp')}',maxLength:30"/><a id="add" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('usersystem.restUser.add')} </a><br/>
                  </div>
                </td>
              </tr>
			  <c:if test="${isGroupVer}">
					<tr>
					<th valign="top" width="70px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('vjoin.setting.quasi.unit')}</label></th>
					<td>
					  <div>
						<input type="hidden" id="oldAccountId" name="oldAccountId" value="${accountId}">
						<input type="hidden" id="accountId" name="accountId" value="${accountId}">
						<textarea style="font-size: 12px;width:100%" id="accountName" name="accountName" class="validate" onclick="selectOrgAccount();"
						  validate="type:'string',name:'指定单位',notNull:true" readonly="readonly">${ctp:showOrgEntitiesOfTypeAndId(accountId, pageContext)}</textarea>
					  </div>
					</td>
				  </tr>
			  </c:if>
			  <tr>
				<th valign="top" width="70px"><label class="margin_r_10" for="text">${ctp:i18n('vjoin.setting.quasi.application')}</label></th>
				<td style="text-align: left">
					<div>
					<b style="font-size: 12px;">${ctp:i18n('vjoin.setting.quasi.application.content')}</b>
					</div>
				</td>
			</tr>
			<tr>
				<th valign="top" width="70px"><label class="margin_r_10" for="text">${ctp:i18n('vjoin.setting.explain')}</label></th>
				<td style="text-align: left">
					<div>
					<b style="font-size: 12px;color: green;">${ctp:i18n('vjoin.setting.explain.content')}</b>
					</div>
				</td>
			</tr>
			  <tr>
                <td style="text-align:center" colspan=2>
					<a href="javascript:void(0)" onclick="OK();" class="common_button common_button_emphasize hand">${ctp:i18n('news.issue.dialog.ok')}</a>
					<a href="javascript:void(0)" onclick="window.location.reload();"class="common_button common_button_gray hand">${ctp:i18n('news.issue.dialog.cancel')}</a>
                </td>
              </tr> 
            </table> 
            </div> 
        </form>
    </div>  
  </div>
</body>
<script type="text/javascript">
	$().ready(function() {
		//设置密码，用于显示
		var ipNum = 1;
		var isCreate = $("#isCreate").val();
		$("#passWord").val("~`@%^*#?");
		$("#passWord2").val("~`@%^*#?");
		if (isCreate == "false") {
			showIp();
		}
		//IP校验初始化1 勾选 0不勾选
		if ("0" == $("#validationip").val()) {
			$("#checkip").attr('checked', false);
		} else {
			$("#checkip").attr('checked', true);
		}
		//修改用户登录信息清空密码
		$("#loginName").click(function() {
			if (isCreate == "false"&& $("#passWord").val() != ""&& $("#passWord2").val() != "") {
				$.confirm({'msg' : '${ctp:i18n("usersystem.restUser.info.login")}',ok_fn : function() {
						$("#passWord").val("");
						$("#passWord2").val("");
						$("#loginName").focus();
					},
					cancel_fn : function() {
						$("#userName").focus();
					}
				});
			} else {
				$("#loginName").focus(); //将焦点设置给登录名
			}
		});
		//修改用户信息回写IP
		function showIp() {
			var allip = $("#loginIp").val();
			var ip = allip.split("|");
			for (var i = 0; i < ip.length; i++) {
				if (i == 0) {
					$("#ip").val(ip[i]);
				} else {
					addIp(ip[i], i);
				}
			}
		}
		//修改用户信息回写IP追加方法
		function addIp(ip, i) {
			var $txt = $("<input type='text' size='20'  name='ip"+i+"' value='"+ip+"'/>");
			var $btn = $("<a href='javascript:void(0)' class='common_button common_button_gray'>${ctp:i18n('usersystem.restUser.deleteUser')}</a>");
			var $br = $("<br/>");
			$btn.click( //设置删除按钮的onclick事件
			function() {
				$txt.remove();
				$btn.remove();
				$br.remove();
			})
			$("#ipinput").append($txt).append($btn).append($br);//追加IP输入文本框
			ipNum += i;
		}

		//添加一行<tr> 
		$("#add").click(function() {
			//创建三个元素
			var ipName = "ip" + ipNum;
			var $txt = $("<input type='text' value='' size='20'  name='"+ipName+"' />");
			var $btn = $("<a href='javascript:void(0)' class='common_button common_button_gray'>${ctp:i18n('usersystem.restUser.deleteUser')}</a>");
			var $br = $("<br/>");
			ipNum++;
			$btn.click( //设置删除按钮的onclick事件
			function() {
				$txt.remove();
				$btn.remove();
				$br.remove();
			})
			$("#ipinput").append($txt).append($btn).append($br);

		});
	});

	function selectOrgAccount() {
		$.selectPeople({
			type : 'selectPeople',
			panels : 'Account',
			selectType : "Account",
			isCanSelectGroupAccount : false,
			maxSize : 1,
			onlyLoginAccount : true,
			params : {
				value : $("#accountId").val()
			},
			callback : function(ret) {
				$("#accountId").val(ret.value);
				$("#accountName").val(ret.text);
			}
		});
	}
	
	function OK() {
		var ip = "";
		var time = 0;
		var flag = true;

		if ($("#passWord").val() != $("#passWord2").val()) {
			$.alert("${ctp:i18n('usersystem.newpassword.again.not.consistent')}");
			return;
		}
		$("input[name^='ip']").each(function() {
			var v = $(this).val();
			if ("" != v) {
				var exp = /^(([0-9]|[1-9][0-9]|1\d\d|2[0-4]\d|25[0-5])|\*)\.(([0-9]|[1-9][0-9]|1\d\d|2[0-4]\d|25[0-5])|\*)\.(([0-9]|[1-9][0-9]|1\d\d|2[0-4]\d|25[0-5])|\*)\.(([0-9]|[1-9][0-9]|1\d\d|2[0-4]\d|25[0-5])|\*)$/;
				var reg = v.match(exp); //判断IP格式
				if (reg == null) {
					$.alert("${ctp:i18n('usersystem.restUser.error.ip')}");
					flag = false;
					return false;
				}
				if (time != 0) {
					v = "|" + v;
				}
				ip = ip + v;
				time++;
			}
		});
		if (flag == false) {
			return;
		};
		if (check(ip) == false) {
			return;
		};
		if ($("#checkip").is(':checked')) {
			$("#validationip").val(1);
		} else {
			$("#validationip").val(0);
		}
		$("#loginIp").val(ip);
		var frmobj = $("#myfrm").formobj();
		var valid = $._isInValid(frmobj);
		if (valid) {
			return;
		}
		
		if (frmobj.oldAccountId!="" && frmobj.oldAccountId != frmobj.accountId) {
		    $.confirm({
	            'msg': "${ctp:i18n('vjoin.setting.confirm')}",
	            'width': 400,
	            'height': 200,
	            ok_fn: function () {
	                submitForm(frmobj);
	            }
	        });
		} else {
			submitForm(frmobj);
		}
		
	}
	
	function submitForm(frmobj){
	    var ajax_sysSetting = new joinSettingManager();

		var data = {};
		var user = new Object();
		var acc = {};
		user.passWord = frmobj.passWord;
		user.userName = frmobj.userName;
		user.loginName = frmobj.loginName;
		user.id = frmobj.id;
		user.ip = frmobj.ip;
		user.type = frmobj.type;
		user.resourceAuthority = frmobj.resourceAuthority;
		user.enabled = frmobj.enable;
		user.validationip = frmobj.validationip;
		user.loginIp = frmobj.loginIp;
		user.createTime = frmobj.createTime;

		acc.accountId = frmobj.accountId;
		acc.oldAccountId = frmobj.oldAccountId;
		acc.accountName = frmobj.accountName;
		data.user = user;
		data.acc = acc;
		var isCreate = $("#isCreate").val();
		if (isCreate == "false") {
			ajax_sysSetting.updateSysSeting(data, {
				success : function(result) {
				    if (result.success) {
                        ctpAlert("保存成功",0);
                    } else {
                        ctpAlert(result.msg,1);
                    }
                }
            });
        } else {
            ajax_sysSetting.saveSysSeting(data, {
                success : function(result) {
    				if (result.success) {
                        ctpAlert("保存成功",0);
                    } else {
                        ctpAlert(result.msg,1);
                    }
                }
            });
        }
    }
    //校验IP是否重复
    function check(ip) {
        var allip = ip.split("|");
        for (var i = 0; i < allip.length - 1; i++) {
            for (var j = i + 1; j < allip.length; j++) {
                if (checkTwo(allip[i], allip[j]) == false) {
                    $.alert("${ctp:i18n('usersystem.restUser.error.sameip')}");
                    return false;
                }
            }
        }
        return true;
    }
    //校验IP是否重复具体实现
    function checkTwo(ip1, ip2) {
        var ip1s = ip1.split(".");
        var ip2s = ip2.split(".");
        var count = 0;
        for (var i = 0; i < ip1s.length; i++) {
            if (ip1s[i] == "*" || ip2s[i] == "*" || ip1s[i] == ip2s[i]) { //验证IP是否重复，分四段验证
                count++;
            }
        }
        if (count == 4) {
            return false;
        } else {
            return true;
        }
    }

    function ctpAlert(msg,type) {
        $.messageBox({
            'type' : 100,
            'imgType' : type,
            'msg' : msg,
            buttons : [ {
                id : 'btn1',
                text : "确定",
                handler : function() {
                    location.reload();
                }
            } ]
        });
    }
</script>
</html>