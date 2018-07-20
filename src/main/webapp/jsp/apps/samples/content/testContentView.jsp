<%--
 $Author: wuym $
 $Rev: 1041 $
 $Date:: 2012-09-22 13:57:29#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>内容处理页面</title>
<style>
.stadic_head_height {
    height: 145px;
}

.stadic_body_top_bottom {
    bottom: 0px;
    top: 145px;
}
</style>
<script type="text/javascript">
  $(function() {
    $.content.callback = {
      dealSubmit : function() {
        $.content.getContentDomains(function(domains) {
          $.content.getContentDealDomains(domains);
          $("#layout").jsonSubmit(
              {
                action : _ctxPath
                    + '/samples/testcontent.do?method=testContentSave',
                domains : domains,
                debug : true
              });
        });
      }
    };
    $("#add_new").click(function() {
      $(".textarea").removeClass("display_none");
    });
    $("#cancel").click(function() {
      $(".textarea").addClass("display_none");
    });

    var layout = new MxtLayout({
      'id' : 'layout',
      'eastArea' : {
        'id' : 'east',
        'width' : 350,
        'sprit' : true,
        'minWidth' : 350,
        'maxWidth' : 500,
        'border' : true,
        spiretBar : {
          show : true,
          handler : function() {
            if ($("#east").outerWidth() == 40) {
              layout.setEast(348);
            } else {
              layout.setEast(38);
            }
            $(".deal_area").toggle();
            $("#deal_area_show").toggle();
          }
        }
      },
      'centerArea' : {
        'id' : 'center',
        'border' : true,
        'minHeight' : 20
      }
    });
    $("#deal_area_show").click(function() {
      $(".deal_area").toggle();
      $("#deal_area_show").toggle();
      layout.setEast(348);
    });
    $(".deal_area .hidden_side").click(function() {
      if ($("#east").outerWidth() == 350) {
        layout.setEast(window.document.body.clientWidth / 2);
      } else {
        layout.setEast(348);
      }
    });

    $("#cyy").comLanguage(
        {
          textboxID : "cyy_textbox",
          data : [ "已阅", "顶", "恭喜", "哈喽哈222喽2222啊22哈喽2", "哈喽哈喽啊哈喽",
              "哈喽哈222喽2222啊22哈喽2", "哈喽哈喽啊哈喽", "哈喽哈222喽2222啊22哈喽2", "哈喽哈喽啊哈喽",
              "哈喽哈222喽2222啊22哈喽2", "哈喽哈喽啊哈喽", "哈喽哈222喽2222啊22哈喽2", "哈喽哈喽啊哈喽",
              "哈喽哈222喽2222啊22哈喽2", "哈喽哈喽啊哈喽" ],
          newBtnHandler : function() {
            new MxtDialog({
              id : 'html',
              htmlId : 'htmlId',
              title : '常用语'
            });
          }
        });
  });
</script>
</head>

<body class="h100b over_hidden page_color">
    <div id='layout'>
        <div class="layout_east" id="east">
            <!--处理区域-->
            <div id="deal_area_show" class="font_size12 align_center h100b hidden hand">
                <span class="ico16 arrow_2_l"></span> <br /> 处<br /> 理<br /> 意<br /> 见
            </div>
            <jsp:include page="/WEB-INF/jsp/common/content/contentDeal.jsp" />
        </div>
        <div class="layout_center over_hidden h100b" id="center">
            <!--查看区域-->
            <div class="h100b stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                    <!--标题+附件区域-->
                    <div class="newinfo_area title_view">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td width="66">
                                    <div class="title_area">标&nbsp;&nbsp;题:</div>
                                </td>
                                <td><b>测测测</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="title_area">发起人:</div>
                                </td>
                                <td><a href="javascript:void(0)">杨佰元</a>(2012-07-16 17:25)</td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="title_area">附&nbsp;&nbsp;件:</div>
                                </td>
                                <td>
                                    <div class="content_area">
                                        (1)<span><em class="ico16 affix_16"></em><a href="javascript:void(0)">本品在传统健美食疗方的基础上优化配比，采用黄精、山药等7种天然纯食疗植物草本配方，利用现代生物提取技术精炼而成，从根本上改善胃肠机能，增强脾胃消化功能，达到健身增肌的效果，让瘦弱的男士变胖、变强键，拥有健康健硕美。</a></span><abbr>(300k)</abbr>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="title_area">关联文档:</div>
                                </td>
                                <td>
                                    <div class="content_area">
                                        (2)<span><em class="ico16 associated_document_16"> </em><a
                                            href="javascript:void(0)">本品在传统健美食疗方的基础上优化配比，采用黄精、山药等7种天然纯食疗植物草本配方，利用现代生物提取技术精炼而成，从根本上改善胃肠机能，增强脾胃消化功能，达到健身增肌的效果，让瘦弱的男士变胖、变强键，拥有健康健硕美。</a></span>
                                        <span><em class="ico16 associated_document_16"></em><a
                                            href="javascript:void(0)">本品在传统健美食疗方的基础上优化配比，采用黄精、山药等7种天然纯食疗植物草本配方，利用现代生物提取技术精炼而成，从根本上改善胃肠机能，增强脾胃消化功能，达到健身增肌的效果，让瘦弱的男士变胖、变强键，拥有健康健硕美。</a></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!--命令按钮区域-->
                    <div class="orderBt right margin_r_10">
                        <span class="ico16 del" title="查找处理人回复"></span> <span class="ico16 print_16" title="打印"></span>
                        <span class="ico16 view_log_16" title="查看明细日志"></span> <span class="ico16 affix"
                            title="查看属性状态设置"></span> <span class="ico16 affix" title="新建会议"></span> <span
                            class="ico16 affix" title="及时交流"></span>
                    </div>
                    <!--视图切换区域-->
                    <div class="common_tabs clearfix">
                        <ul class="left">
                            <li class="current"><a href="javascript:void(0)" class="border_b">正文</a></li>
                            <li><a href="javascript:void(0)" class="last_tab">流程</a></li>
                        </ul>
                    </div>
                    <div class="stadic_layout_body stadic_body_top_bottom content_view processing_view align_center">
                        <ul class="view_ul align_left">
                            <li class="view_li content_text margin_b_10"><jsp:include
                                    page="/WEB-INF/jsp/common/content/content.jsp" /></li>
                            <!--附言区域-->
                            <li class="view_li margin_b_10 padding_b_10"><span class="title">发起人附言</span> <span
                                id="add_new" class="add_new"><a href="javascript:void(0)">新增附言</a></span>
                                <div class="content">
                                    <ul>
                                        <li>2012-07-14 10:23 测试附言测试附言测试附言测试附言</li>
                                        <li>2012-07-14 10:23 测试附言测试附言测试附言测试附言</li>
                                        <li><span class="font_bold">附件：(2)</span> <span><em
                                                class="ico16 affix_16"></em><a href="javascript:void(0)">本品在传统键，拥有健康健硕美。</a><a
                                                href="javascript:void(0)">[查看]</a><em class="em em3"> </em></span> <span><em
                                                class="ico16 affix_16"></em><a href="javascript:void(0)">本品在传统键，拥有健康健硕美。</a><a
                                                href="javascript:void(0)">[查看]</a><em class="em em3"> </em></span></li>
                                        <li><span class="font_bold">关联文档：(2)</span><span><em
                                                class="ico16 associated_document_16"> </em><a href="javascript:void(0)">本品在传统键，拥有健康健硕美。</a></span><span><em
                                                class="ico16 associated_document_16"> </em><a href="javascript:void(0)">本品在传统键，拥有健康健硕美。</a></span>
                                        </li>
                                        <li class="textarea display_none"><textarea cols="20" rows="5"> </textarea>
                                            <span class="green">500个字以内</span> <span class="bt"><a
                                                href="javascript:void(0)">插入附件</a>&nbsp;&nbsp;<a
                                                href="javascript:void(0)">关联文档</a>&nbsp;&nbsp;消息推送：<input value=""
                                                type="text">&nbsp;&nbsp;<a
                                                class="common_button common_button_gray" href="javascript:void(0)">提交</a>
                                                <a id="cancel" class="common_button common_button_gray"
                                                href="javascript:void(0)">取消</a> </span></li>

                                    </ul>
                                </div></li>
                            <jsp:include page="/WEB-INF/jsp/common/content/comment.jsp" />
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
