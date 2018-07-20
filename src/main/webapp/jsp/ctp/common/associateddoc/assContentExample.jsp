<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
function deselectItem(fileUrl){
    $("input[value='"+fileUrl+"']").attr("checked", false);
}
</script>
</head>
<body>

    <table cellpadding="0" cellspacing="0" id="hTablepending">
        <thead class="table-header">
            <tr id="headIDpending">
                <th width="5%" align="center"><div style="text-align: center"
                        onclick="sortColumn(event, false, true)">&nbsp;</div></th>
                <th width="5%" align="center"><div style="text-align: center"
                        onclick="sortColumn(event, false, true)">&nbsp;</div></th>
                <th width="57%" type="String"><div style="text-align:" onclick="sortColumn(event, false, true)">标题</div></th>
                <th width="18%" type="String"><div style="text-align:" onclick="sortColumn(event, false, true)">发起人</div></th>
                <th width="20%" type="Date"><div style="text-align:" onclick="sortColumn(event, false, true)">发起时间</div></th>
            </tr>
        </thead>
    </table>


    <table border="0" cellpadding="0" cellspacing="0" id="bTablepending">
        <tbody id="bodyIDpending" class="table-body">
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-1270574996994961839" createDate="2012-11-16 09:08:57"
                            onclick="parent.quoteDocumentSelected(this, '紧急A8BUG_V3.20SP1_山东京博控股股份有限公司_ 凌晨4点再次宕机_20121116014189', 'collaboration', '-1270574996994961839')" />
                    </div></td>
                <td><div title="紧急A8BUG_V3.20SP1_山东京博控股股份有限公司_ 凌晨4点再次宕机_20121116014189"
                        class="sort" width="57%" style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-1270574996994961839&isQuote=true')"><span
                            class='inline-block importance_3'></span><span>紧急A8BUG_V3.20SP1_山东京博控股股份有限公司_&nbsp;凌晨4...</span><span
                            class='inline-block attachment_table_true'></span><span class='inline-block bodyType_FORM'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">刘晶莹</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-16
                        09:08</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="4742502652090794490" createDate="2012-11-20 09:57:26"
                            onclick="parent.quoteDocumentSelected(this, 'V5.0 进度爬行榜(周艳玲 2012-11-20 09:44)', 'collaboration', '4742502652090794490')" />
                    </div></td>
                <td><div title="V5.0 进度爬行榜(周艳玲 2012-11-20 09:44)" class="sort"
                        width="57%" style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=4742502652090794490&isQuote=true')">V5.0&nbsp;进度爬行榜(周艳玲&nbsp;2012-11-20&nbsp;09:44)</a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">周艳玲</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-20
                        09:57</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="65743738805831219" createDate="2012-11-20 09:33:25"
                            onclick="parent.quoteDocumentSelected(this, '2012年11月19日A8客户bug日报', 'collaboration', '65743738805831219')" />
                    </div></td>
                <td><div title="2012年11月19日A8客户bug日报" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=65743738805831219&isQuote=true')">2012年11月19日A8客户bug日报</a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">曾乐</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-20
                        09:33</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-7060370165182871714" createDate="2012-11-20 09:21:52"
                            onclick="parent.quoteDocumentSelected(this, '致以恒，境之远——市场中心9、10月份媒体传播战报', 'collaboration', '-7060370165182871714')" />
                    </div></td>
                <td><div title="致以恒，境之远——市场中心9、10月份媒体传播战报" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-7060370165182871714&isQuote=true')"><span>致以恒，境之远——市场中心9、10月份媒体传播战报</span><span
                            class='inline-block attachment_table_true'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">于巧稚</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-20
                        09:21</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-7502571161023002236" createDate="2012-11-19 16:07:26"
                            onclick="parent.quoteDocumentSelected(this, 'A8-m A6-m V5.0进度报告_Sprint4_2012-11-19', 'collaboration', '-7502571161023002236')" />
                    </div></td>
                <td><div title="A8-m A6-m V5.0进度报告_Sprint4_2012-11-19" class="sort"
                        width="57%" style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-7502571161023002236&isQuote=true')"><span>A8-m&nbsp;A6-m&nbsp;V5.0进度报告_Sprint4_2012-11-19</span><span
                            class='inline-block bodyType_FORM'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">高航</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-19
                        16:07</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="9196129785873907881" createDate="2012-11-19 16:05:49"
                            onclick="parent.quoteDocumentSelected(this, '致远M1V2.3.0产品发布', 'collaboration', '9196129785873907881')" />
                    </div></td>
                <td><div title="致远M1V2.3.0产品发布" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=9196129785873907881&isQuote=true')"><span
                            class='inline-block importance_2'></span><span>致远M1V2.3.0产品发布</span><span
                            class='inline-block attachment_table_true'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">隋国晶</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-19
                        16:05</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-723324767055492085" createDate="2012-11-19 09:45:36"
                            onclick="parent.quoteDocumentSelected(this, '2012年11月16日A8客户bug日报', 'collaboration', '-723324767055492085')" />
                    </div></td>
                <td><div title="2012年11月16日A8客户bug日报" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-723324767055492085&isQuote=true')">2012年11月16日A8客户bug日报</a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">曾乐</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-19
                        09:45</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="5203956397651218064" createDate="2012-11-16 16:20:40"
                            onclick="parent.quoteDocumentSelected(this, '【致远微学习】《微刊05期：高效能人士习惯 之 要事第一篇》发布！', 'collaboration', '5203956397651218064')" />
                    </div></td>
                <td><div title="【致远微学习】《微刊05期：高效能人士习惯 之 要事第一篇》发布！" class="sort"
                        width="57%" style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=5203956397651218064&isQuote=true')"><span
                            class='inline-block importance_2'></span><span>【致远微学习】《微刊05期：高效能人士习惯&nbsp;之&nbsp;要事第一篇...</span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">**王亮</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-16
                        16:20</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-92510569758767245" createDate="2012-11-16 09:15:03"
                            onclick="parent.quoteDocumentSelected(this, '山东京博宕机危机预警', 'collaboration', '-92510569758767245')" />
                    </div></td>
                <td><div title="山东京博宕机危机预警" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-92510569758767245&isQuote=true')"><span
                            class='inline-block importance_3'></span><span>山东京博宕机危机预警</span><span
                            class='inline-block attachment_table_true'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">刘晶莹</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-16
                        09:15</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-1604434048335395975" createDate="2012-11-16 09:08:57"
                            onclick="parent.quoteDocumentSelected(this, '紧急A8BUG_V3.20SP1_山东京博控股股份有限公司_ 凌晨4点再次宕机_20121116014189', 'collaboration', '-1604434048335395975')" />
                    </div></td>
                <td><div title="紧急A8BUG_V3.20SP1_山东京博控股股份有限公司_ 凌晨4点再次宕机_20121116014189"
                        class="sort" width="57%" style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-1604434048335395975&isQuote=true')"><span
                            class='inline-block importance_3'></span><span>紧急A8BUG_V3.20SP1_山东京博控股股份有限公司_&nbsp;凌晨4...</span><span
                            class='inline-block attachment_table_true'></span><span class='inline-block bodyType_FORM'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">刘晶莹</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-16
                        09:08</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="6414733665874692309" createDate="2012-11-16 09:28:40"
                            onclick="parent.quoteDocumentSelected(this, '2012年11月15日A8客户bug日报', 'collaboration', '6414733665874692309')" />
                    </div></td>
                <td><div title="2012年11月15日A8客户bug日报" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=6414733665874692309&isQuote=true')">2012年11月15日A8客户bug日报</a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">曾乐</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-16
                        09:28</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-2607257490051740169" createDate="2012-10-25 09:34:32"
                            onclick="parent.quoteDocumentSelected(this, '重要A8BUG_V3.20SP1_江苏双沟酒业股份有限公司 _a8服务宕掉，目前已经正常，需要研发查找原因，让后续不再发生此问题_20121025013724', 'collaboration', '-2607257490051740169')" />
                    </div></td>
                <td><div
                        title="重要A8BUG_V3.20SP1_江苏双沟酒业股份有限公司 _a8服务宕掉，目前已经正常，需要研发查找原因，让后续不再发生此问题_20121025013724"
                        class="sort" width="57%" style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-2607257490051740169&isQuote=true')"><span
                            class='inline-block importance_2'></span><span>重要A8BUG_V3.20SP1_江苏双沟酒业股份有限公司&nbsp;_a8服务...</span><span
                            class='inline-block attachment_table_true'></span><span class='inline-block bodyType_FORM'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">殷树亮</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-10-25
                        09:34</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-6763998158323367612" createDate="2012-11-12 11:08:47"
                            onclick="parent.quoteDocumentSelected(this, '重要A8BUG_V312SP1_冀东水泥（NC-OA）_系统在高峰时间自动宕机，无法访问_20121112014080', 'collaboration', '-6763998158323367612')" />
                    </div></td>
                <td><div
                        title="重要A8BUG_V312SP1_冀东水泥（NC-OA）_系统在高峰时间自动宕机，无法访问_20121112014080" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-6763998158323367612&isQuote=true')"><span
                            class='inline-block importance_2'></span><span>重要A8BUG_V312SP1_冀东水泥（NC-OA）_系统在高峰时间...</span><span
                            class='inline-block attachment_table_true'></span><span class='inline-block bodyType_FORM'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">魏真</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-12
                        11:08</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="2933560196500964747" createDate="2012-11-15 09:05:11"
                            onclick="parent.quoteDocumentSelected(this, '2012年11月14日A8客户bug日报', 'collaboration', '2933560196500964747')" />
                    </div></td>
                <td><div title="2012年11月14日A8客户bug日报" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=2933560196500964747&isQuote=true')">2012年11月14日A8客户bug日报</a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">曾乐</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-15
                        09:05</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="8958002034541940599" createDate="2012-11-13 17:52:54"
                            onclick="parent.quoteDocumentSelected(this, '重要A8BUG_V312SP1_深圳市日上光电有限公司_打上6月月度修复包，启动A8服务数据库进程CPU占用70%以上，服务器响应迟缓_20121113014125', 'collaboration', '8958002034541940599')" />
                    </div></td>
                <td><div
                        title="重要A8BUG_V312SP1_深圳市日上光电有限公司_打上6月月度修复包，启动A8服务数据库进程CPU占用70%以上，服务器响应迟缓_20121113014125"
                        class="sort" width="57%" style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=8958002034541940599&isQuote=true')"><span
                            class='inline-block importance_2'></span><span>重要A8BUG_V312SP1_深圳市日上光电有限公司_打上6月月...</span><span
                            class='inline-block attachment_table_true'></span><span class='inline-block bodyType_FORM'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">王成勇</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-13
                        17:52</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="5153524818014062987" createDate="2012-11-13 16:50:36"
                            onclick="parent.quoteDocumentSelected(this, 'Sprint4需要明确的规范及标准', 'collaboration', '5153524818014062987')" />
                    </div></td>
                <td><div title="Sprint4需要明确的规范及标准" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=5153524818014062987&isQuote=true')"><span>Sprint4需要明确的规范及标准</span><span
                            class='inline-block attachment_table_true'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">周艳玲</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-13
                        16:50</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="5798812227258632597" createDate="2012-11-14 09:09:16"
                            onclick="parent.quoteDocumentSelected(this, '2012年11月13日A8客户bug日报', 'collaboration', '5798812227258632597')" />
                    </div></td>
                <td><div title="2012年11月13日A8客户bug日报" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=5798812227258632597&isQuote=true')">2012年11月13日A8客户bug日报</a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">曾乐</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-14
                        09:09</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-1666815139818156637" createDate="2012-11-12 15:38:10"
                            onclick="parent.quoteDocumentSelected(this, '南方水泥问题处理结果跟踪', 'collaboration', '-1666815139818156637')" />
                    </div></td>
                <td><div title="南方水泥问题处理结果跟踪" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-1666815139818156637&isQuote=true')"><span>南方水泥问题处理结果跟踪</span><span
                            class='inline-block attachment_table_true'></span></a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">李强（实施）</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-12
                        15:38</div></td>
            </tr>
            <tr class="erow">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="-995782037318253435" createDate="2012-11-13 09:09:59"
                            onclick="parent.quoteDocumentSelected(this, '2012年11月12日A8客户bug日报', 'collaboration', '-995782037318253435')" />
                    </div></td>
                <td><div title="2012年11月12日A8客户bug日报" class="sort" width="57%"
                        style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=-995782037318253435&isQuote=true')">2012年11月12日A8客户bug日报</a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">曾乐</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-13
                        09:09</div></td>
            </tr>
            <tr class="">
                <td><div align="center" class="sort" width="5%"
                        style="text-align: center; width: 229px;">
                        <input type='checkbox' name='id' value="7795872749385042370" createDate="2012-11-13 08:37:47"
                            onclick="parent.quoteDocumentSelected(this, 'V5.0 进度爬行榜(周艳玲 2012-11-12 16:45)', 'collaboration', '7795872749385042370')" />
                    </div></td>
                <td><div title="V5.0 进度爬行榜(周艳玲 2012-11-12 16:45)" class="sort"
                        width="57%" style="text-align:; width: 229px;">
                        <a href="javascript:openDetail('', 'from=Done&affairId=7795872749385042370&isQuote=true')">V5.0&nbsp;进度爬行榜(周艳玲&nbsp;2012-11-12&nbsp;16:45)</a>
                    </div></td>
                <td><div class="sort" width="18%" style="text-align:; width: 229px;">周艳玲</div></td>
                <td><div class="sort" width="20%" style="text-align:; width: 229px;">2012-11-13
                        08:37</div></td>
            </tr>
        </tbody>
    </table>
</body>
</html>