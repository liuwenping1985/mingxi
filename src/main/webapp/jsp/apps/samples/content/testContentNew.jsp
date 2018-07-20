<%--
 $Author: wuym $
 $Rev: 1041 $
 $Date:: 2012-09-22 13:57:29#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<html>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<head>
<title>内容新建页面</title>
<script>
  $(function() {
    function saveCol() {
      $.content.getContentDomains(function(domains) {
        $("#colDomain").jsonSubmit({
          action : _ctxPath + '/samples/testcontent.do?method=testContentSave',
          domains : domains,
          debug : true
        });
      });
    }

    function saveColAs() {
      var domains = [];
      domains = $.content.getSaveAsContentDomains(5, domains);
      if (domains) {
        $("#colDomain").jsonSubmit({
          url : _ctxPath + '/samples/testcontent.do?method=testContentSave',
          domains : domains,
          debug : true
        });
      }
    }

    $("#colToolbar")
        .toolbar(
            {
              toolbar : [
                  {
                    name : "保存待发",
                    className : "ico16 save_up_16",
                    click : saveCol
                  },
                  {
                    name : "存为草稿",
                    className : "ico16 save_traft_16",
                    click : saveColAs
                  },
                  {
                    name : "存为模板",
                    className : "ico16 save_template_16",
                    click : function() {
                      alert("存为模板");
                    }
                  },
                  {
                    name : "调用模板",
                    className : "ico16 call_template_16",
                    click : function() {
                      var dialog = $
                          .dialog({
                            url : _ctxPath
                                + '/samples/testcontent.do?method=testFormTemplateList',
                            width : 500,
                            height : 400,
                            title : '选择表单模板',
                            //transParams : options.params,
                            buttons : [
                                {
                                  text : "确定",
                                  handler : function() {
                                    var retv = dialog.getReturnValue();
                                    dialog.close();
                                    if (retv) {
                                      window.location.href = _ctxPath
                                          //+ '/samples/testcontent.do?method=testContentNew&rightId=3923702095628291555&contentType=20&contentId='
                                          + '/samples/testcontent.do?method=testContentNew&rightId=-271875634122962803&contentType=20&contentId='
                                          + retv.id;
                                    }
                                  }
                                }, {
                                  text : "取消",
                                  handler : function() {
                                    dialog.close();
                                  }
                                } ]
                          });
                    }
                  },
                  {
                    name : "插入",
                    className : "ico16 affix_16",
                    subMenu : [ {
                      name : "本地文件",
                      click : function() {
                        alert("本地文件");
                      }
                    }, {
                      name : "关联文档",
                      click : function() {
                        alert("关联文档");
                      }
                    } ]
                  },
                  {
                    name : "正文类型",
                    className : "ico16 text_type_16",
                    subMenu : [
                        {
                          name : "标准正文",
                          click : function() {
                            window.location.href = _ctxPath
                                + '/samples/testcontent.do?method=testContentNew';
                          }
                        }, {
                          name : "Office文档",
                          click : function() {
                            alert("Office文档");
                          }
                        } ]
                  }, {
                    name : "打印",
                    className : "ico16 print_16",
                    click : function() {
                      alert("打印");
                    }
                  } ]
            });

    new inputChange($("#title"), "点击此处填写标题");
    new inputChange($("#process"), "点击新建流程");
    showHide($("#show_more"), $(".newinfo_more"));
    $("#adtional_ico").click(function() {
      $("#adtional_area").toggleClass("adtional");
      $(".editadt_title,.editadt_box").toggleClass("hidden");
      $(this).find("em").toggleClass("arrow_2_l arrow_2_r");
    });
  })
</script>
<style>
.stadic_layout {
    height: 99.5%;
    _height: 100%;
}
/*固定宽度的样式*/
.fixed_width {
    width: 170px;
    _width: 180px;
}
/*自适应宽度的样式*/
.adapt_width {
    overflow: hidden;
    margin: auto;
}

.adtional {
    width: 30px;
}
</style>
</head>
<body class="h100b over_hidden page_color border_l border_r">
    <table id="colDomain" width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td height="50" valign="top">
                <div class="common_crumbs border_b padding_l_10">
                    <span class="margin_r_10">当前位置:</span><a href="#">协同工作</a><span
                        class="common_crumbs_next margin_lr_5">-</span><a href="#">新建协同</a>
                </div>
                <div class="border_t_white border_b">
                    <div id="colToolbar"></div>
                </div>
                <div class="form_area new_page border_t_white">
                    <div>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td rowspan="2" valign="middle" width="1%" nowrap="nowrap"><a
                                    href="javascript:void(0)"
                                    class="margin_lr_5 display_inline-block align_center new_btn"> 发送</a>&nbsp;</td>
                                <th nowrap="nowrap" width="1%"><label for="text">&nbsp;&nbsp;标题：</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input class="w100b" type="text" id="title" />
                                    </div></td>
                                <td width="5%">
                                    <div class="common_selectbox_wrap padding_l_5">
                                        <select class="w100b">
                                            <option>普通</option>
                                            <option>重要</option>
                                            <option>非常重要</option>
                                        </select>
                                    </div>
                                </td>
                                <th nowrap="nowrap" width="1%">&nbsp;<label class="margin_l_10" for="text">关联项目：</label></th>
                                <td width="20%"><div class="common_selectbox_wrap">
                                        <select class="w100b"><option>无</option></select>
                                    </div></td>
                                <th nowrap="nowrap" width="1%"><label for="text">&nbsp;&nbsp;流程期限：</label></th>
                                <td width="20%"><div class="common_selectbox_wrap">
                                        <select class="w100b"><option>无</option></select>
                                    </div></td>
                            </tr>

                            <tr>
                                <th nowrap="nowrap" width="1%"><label for="text">流程：</label></th>
                                <td><div class="common_txtbox_wrap">
                                        <input class="w100b" type="text" id="process" />
                                    </div></td>
                                <td>
                                    <div class="margin_l_5">
                                        <a comp="type:'workflowEdit',moduleType:'${contentContext.moduleTypeName}'"
                                            class="common_button common_button_icon comp" href="javascript:void(0)"><em
                                            class="ico16 process_16"> </em>编辑流程</a>

                                    </div>
                                </td>
                                <th nowrap="nowrap" width="1%">&nbsp;<label class="margin_l_10" for="text">预归档到：</label></th>
                                <td width="20%"><div class="common_selectbox_wrap">
                                        <select class="w100b"><option>无</option></select>
                                    </div></td>
                                <th nowrap="nowrap" width="1%"><label class="margin_l_10" for="text">提醒：</label></th>
                                <td width="20%"><div class="common_selectbox_wrap">
                                        <select class="w100b"><option>无</option></select>
                                    </div></td>
                                <td valign="middle" width="40" nowrap="nowrap" align="center"><a
                                    href="javascript:void(0);" id="show_more" class="display_inline-block margin_l_5 ">更多</a></td>
                            </tr>
                            <!--更多-->
                            <tr class="newinfo_more hidden">
                                <th nowrap="nowrap" width="1%" colspan="2">
                                    <div class="common_checkbox_box clearfix ">
                                        <label class="hand" for="radio1"><input id="checkbox1" name="option"
                                            value="0" class="radio_com" type="checkbox">跟踪：</label>
                                    </div>
                                </th>
                                <td colspan="2">
                                    <div class="common_checkbox_box clearfix ">
                                        <label class="margin_r_10 hand" for="radio1"><input id="radio1"
                                            name="option" value="0" type="radio" class="radio_com">全部人员</label> <label
                                            class="margin_r_10 hand" for="radio1"><input id="radio2"
                                            name="option" value="0" type="radio" class="radio_com">指定人员</label>
                                </td>
                                <th nowrap="nowrap" width="1%">&nbsp;<label class="margin_l_10" for="text">督办人员：</label></th>
                                <td width="20%"><div class="common_txtbox_wrap">
                                        <input class="w100b" type="text">
                                    </div></td>
                                <th nowrap="nowrap" rowspan="2" width="1%" valign="top">&nbsp;<label
                                    class="margin_t_5" for="text">督办主题：</label></th>
                                <td width="20%" rowspan="2"><div class="">
                                        <textarea rows="3" class="w100b"></textarea></td>
                                <td rowspan="2" colspan="2"></td>
                            </tr>
                            <tr class="newinfo_more hidden">
                                <th nowrap="nowrap" align="right" colspan="2"><label for="text">允许操作：</label></th>
                                <td colspan="2">
                                    <div class="common_checkbox_box clearfix ">
                                        <label class="margin_r_10 hand" for="radio1"><input id="checkbox1"
                                            value="0" class="radio_com" type="checkbox">转发</label> <label
                                            class="margin_r_10 hand" for="radio1"><input id="checkbox2"
                                            value="0" class="radio_com" type="checkbox">改变流程</label> <label
                                            class="margin_r_10 hand" for="radio1"><input id="checkbox3"
                                            value="0" class="radio_com" type="checkbox">修改正文</label> <label
                                            class="margin_r_10 hand" for="radio1"><input id="checkbox4"
                                            value="0" class="radio_com" type="checkbox">修改附件</label> <label
                                            class="margin_r_10 hand" for="radio1"><input id="checkbox4"
                                            value="0" class="radio_com" type="checkbox">归档</label>
                                </td>
                                <th nowrap="nowrap" width="1%">&nbsp;<label class="margin_l_10" for="text">督办期限：</label></th>
                                <td width="20%"><div class="common_txtbox_wrap">
                                        <input class="w100b" type="text">
                                    </div></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <div class="stadic_layout h100b w100b">
                    <div class="fixed_width right h100b border_all margin_l_5 padding_lr_5 adtional" id="adtional_area">
                        <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td height="20" class="padding_t_5">
                                    <div class="adtional_ico" id="adtional_ico">
                                        <em class="ico16 arrow_2_r"> </em>
                                    </div> <span class="adtional_text">附&nbsp;言</span>
                                    <div class="editadt_title margin_tb_5 hidden">附言(500字以内)</div>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" class="editadt_box hidden">
                                    <div class="absolute">
                                        <textarea class="h100b "></textarea>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="adapt_width h100b border_all" style="background: #fff;">
                        <jsp:include page="/WEB-INF/jsp/common/content/content.jsp" /></div>
                </div>
            </td>
        </tr>
    </table>
</body>
</html>
