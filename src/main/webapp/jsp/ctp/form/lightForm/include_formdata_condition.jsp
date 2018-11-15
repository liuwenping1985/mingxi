<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
       <c:if test="${not empty conditionList}">
        <div data-role="navbar" class="form_nav_bar form_nav_bar_2 form_tab_none">
            <ul class="model_header_tabs">
                <c:forEach var="conditionObj" items="${conditionList}" varStatus="status">
                    <c:if test="${conditionObj.inputType eq 'text' }">
                        <li><!-- 文本 -->
                            <a href="#" tgt="inquiry_two${status.index}">
                                <span backTgt="single_text${status.index}" startValue="${conditionObj.display}">${conditionObj.display}</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if>
                    <c:if test="${conditionObj.inputType eq 'select' }">
                        <li><!-- 下拉 -->
                            <a href="#" class="ui-btn-active1" tgt="inquiry_com_list${status.index}">
                                <span backTgt="inquiry_store${status.index}" startValue="${conditionObj.display}">${conditionObj.display}</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if>
                    <c:if test="${conditionObj.inputType eq 'relation' }">
                        <li><!-- 关联下拉 -->
                            <a href="#" class="ui-btn-active1" tgt="inquiry_com_list${status.index}">
                                <span backTgt="inquiry_store${status.index}" startValue="${conditionObj.display}" id="${conditionObj.name}">${conditionObj.display}</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index} enumParent=${conditionObj.enumParent} class="relationInput">
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if>
                     <c:if test="${conditionObj.inputType eq 'aloneDate' }">
                        <li><!-- 单独的年下拉 -->
                            <a href="#" class="ui-btn-active1" tgt="alone_year${status.index}">
                                <span backTgt="inquiry_store${status.index}" startValue="${conditionObj.display}">年</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                        <li><!-- 单独的月下拉 -->
                            <a href="#" class="ui-btn-active1" tgt="alone_month${status.index}">
                                <span backTgt="inquiry_store2${status.index}" startValue="月" id="month_control_value">月</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                        <li><!-- 单独的日下拉 -->
                            <a href="#" class="ui-btn-active1" tgt="alone_day${status.index}">
                                <span backTgt="inquiry_store3${status.index}" startValue="日" id="day_control_value">日</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if>
                    <c:if test="${conditionObj.inputType eq 'date' }">
                        <li><!-- 日期-->
                            <a href="#" tgt="inquiry_four${status.index}">
                                <span backTgt="local_time${status.index}" startValue="${conditionObj.display}">${conditionObj.display}</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if>
                    <c:if test="${conditionObj.inputType eq 'datetime' }">
                        <li><!-- 日期时间-->
                            <a href="#" tgt="inquiry_four${status.index}">
                                <span backTgt="local_time${status.index}" startValue="${conditionObj.display}">${conditionObj.display}</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if>
                    <c:if test="${conditionObj.inputType eq 'checkbox' }">
                        <li><!-- 开关 -->
                            <a href="#" tgt="inquiry_three${status.index}">
                                <span backTgt="imitate_radio${status.index}" startValue="${conditionObj.display}">${conditionObj.display}</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index} val=${conditionObj.checkBoxValue}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if>
                    <c:if test="${conditionObj.inputType eq 'member' }">
                        <li><!-- 选人 -->
                            <a href="#" tgt="">
                                <span>${conditionObj.display}</span>
                                <input type="hidden" fieldName=${conditionObj.name} operation=${conditionObj.operation} inputType=${conditionObj.inputType} index=${status.index}>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if> 
                    <%-- <c:if test="${conditionObj.inputType eq 'city' }">
                        <li><!-- 目前暂无城市控件 -->
                            <a href="#" tgt="inquiry_city">
                                <span>${conditionObj.display }</span>
                                <span class="iphone16 arrow_b_16"></span>
                                <p></p>
                            </a>
                        </li>
                    </c:if> --%>
                </c:forEach>
            </ul>
        </div>
        </c:if>
         <!-- 控件class start-->
        <c:if test="${not empty conditionList}">
        <div class="tabs_body display_none inquiry_content_check">
            <c:forEach var="conditionObj" items="${conditionList}" varStatus="status">
                <c:if test="${conditionObj.inputType eq 'select' }">
                <!-- 下拉框 -->
                <div id="inquiry_com_list${status.index}" class="h100b common_inquiry comp" comp="type:'tabInquiry',ensureBtn:'com_inquiry_list p',
                    cancelBtn:'inquiry_cancel_btn',hideLayerClose:true,backFillTgt:'inquiry_store${status.index}',
                    tabBorderClass:'form_tab_none',changeParentId:'form_list_content',callBack:formReportSelectControl">
                    <div class="wrapper inquiry_text_content" id="inquiry_text_content">
                        <div class="scroller com_inquiry_list">
                            <p value="0">全部</p>
                            <c:forEach var="selectvalue" items="${conditionObj.selectValue}" >
                                <p value="${selectvalue[0]}">${selectvalue[1]}</p>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="border_top inquiry_text_bottom">
                        <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                    </div>
                </div>
                </c:if>
                <c:if test="${conditionObj.inputType eq 'relation' }">
                <!-- 关联下拉框 -->
                <div id="inquiry_com_list${status.index}" class="h100b common_inquiry comp" comp="type:'tabInquiry',ensureBtn:'com_inquiry_list p',
                    cancelBtn:'inquiry_cancel_btn',hideLayerClose:true,backFillTgt:'inquiry_store${status.index}',
                    tabBorderClass:'form_tab_none',changeParentId:'form_list_content',callBack:relationSelectReport">
                    <div class="wrapper inquiry_text_content" id="select_relation${status.index}">
                        <div class="scroller com_inquiry_list" selectValName=${conditionObj.name}>
                            <!-- <p value="-1">请先选择上级关联</p> -->
                        </div>
                    </div>
                    <div class="border_top inquiry_text_bottom">
                        <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                    </div>
                </div>
                </c:if>
                <c:if test="${conditionObj.inputType eq 'aloneDate' }">
                <!-- 单独的年月日下拉框 -->
                <!-- 年下拉框的值 -->
                <div id="alone_year${status.index}" class="h100b common_inquiry comp" comp="type:'tabInquiry',ensureBtn:'com_inquiry_list p',
                    cancelBtn:'inquiry_cancel_btn',hideLayerClose:true,backFillTgt:'inquiry_store${status.index}',
                    tabBorderClass:'form_tab_none',changeParentId:'form_list_content',callBack:formReportYearControl">
                    <div class="wrapper inquiry_text_content" id="year_refresh">
                        <div class="scroller com_inquiry_list">
                            <p value="0">全部</p>
                            <c:forEach var="selectvalue" items="${yearLst}" >
                                <p value="${selectvalue}">${selectvalue}年</p>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="border_top inquiry_text_bottom">
                        <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                    </div>
                </div>
               
                  <!-- 月下拉框的值 -->
                <div id="alone_month${status.index}" class="h100b common_inquiry comp" comp="type:'tabInquiry',ensureBtn:'com_inquiry_list p',
                    cancelBtn:'inquiry_cancel_btn',hideLayerClose:true,backFillTgt:'inquiry_store2${status.index}',
                    tabBorderClass:'form_tab_none',changeParentId:'form_list_content',callBack:formReportMonthControl">
                    <div class="wrapper inquiry_text_content" id="month_refresh">
                        <div class="scroller com_inquiry_list" id="month_select_val">
                            <p value="-1">请先选择年</p>
                            <%-- <p value="0">全部</p>
                            <c:forEach var="x" begin="1"end="12" step="1">
                                <p value="${x}">${x}月</p>
                            </c:forEach> --%>
                        </div>
                    </div>
                    <div class="border_top inquiry_text_bottom">
                        <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                    </div>
                </div>
                <!-- 日下拉框的值 -->
                <div id="alone_day${status.index}" class="h100b common_inquiry comp" comp="type:'tabInquiry',ensureBtn:'com_inquiry_list p',
                    cancelBtn:'inquiry_cancel_btn',hideLayerClose:true,backFillTgt:'inquiry_store3${status.index}',
                    tabBorderClass:'form_tab_none',changeParentId:'form_list_content',callBack:formReportDayControl">
                    <div class="wrapper inquiry_text_content form_query_day_del" id="form_query_day_refresh">
                        <div class="scroller com_inquiry_list" id="day_select_val">
                            <p value="-1">请先选择年月</p>
                            <%-- <c:forEach var="x" begin="1"end="31" step="1">
                                <p value="${x}">${x}日</p>
                            </c:forEach> --%>
                        </div>
                    </div>
                    <div class="border_top inquiry_text_bottom">
                        <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                    </div>
                </div>
                </c:if>
                <c:if test="${conditionObj.inputType eq 'text' }">
                <!-- 文本框 -->
                <div id="inquiry_two${status.index}" class="display_none common_inquiry clearFix comp"
                     comp="type:'tabInquiry',ensureBtn:'inquiry_ensure_btn',cancelBtn:'inquiry_cancel_btn',hideLayerClose:true,
                     backFillTgt:'single_text${status.index}',tabBorderClass:'form_tab_none',changeParentId:'form_list_content',callBack:formReportTextControl">
                    <div class="user_search_bg inquiry_text">
                        <input type="text" data-type="search" id="user_search${status.index}" placeholder="请输入查询值"/>
                    </div>
                    <button class="blue_btn_inline right inquiry_ensure_btn">确定</button>
                    <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                </div>
                </c:if>
            
                <c:if test="${conditionObj.inputType eq 'checkbox' }">
                <!-- 开关控件 -->
                <div id="inquiry_three${status.index}" class="display_none common_inquiry clearFix comp"
                     comp="type:'tabInquiry',ensureBtn:'inquiry_ensure_btn',cancelBtn:'inquiry_cancel_btn',
                     radioDefault:'single_check_40',radioChecked:'single_checked_40',
                     hideLayerClose:true,backFillTgt:'imitate_radio${status.index}',tabBorderClass:'form_tab_none',
                     changeParentId:'form_list_content',callBack:formReportCheckBoxControl">
                    <div class="border_bottom inquiry_radio padding_10 margin_b_5 comp seeworkCheckbox"
                         comp="type:'radio',radioDefault:'single_check_40',radioChecked:'single_checked_40',
                         changeParentId:'form_list_content',backFillTgt:'imitate_radio${status.index}'">
                        <p textValue="勾选">
                            <span class="iphone40 single_check_40"></span>
                            <span>勾选</span>
                        </p>
                        <p class="margin_l_30" textValue="未勾选">
                            <span class="iphone40 single_check_40"></span>
                            <span>未勾选</span>
                        </p>
                    </div>
                    <button class="blue_btn_inline right inquiry_ensure_btn">确定</button>
                    <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                </div>
                </c:if>
                <c:if test="${conditionObj.inputType eq 'date' }">
                <!-- 日期控件 -->
                <div id="inquiry_four${status.index}" class="display_none common_inquiry clearFix padding_t_10 comp"
                     comp="type:'tabInquiry',ensureBtn:'inquiry_ensure_btn',cancelBtn:'inquiry_cancel_btn',hideLayerClose:true,
                    backFillTgt:'local_time${status.index}',tabBorderClass:'form_tab_none',changeParentId:'form_list_content',callBack:formReportDateControl">
                    <div class="user_defind_date inquiry_text margin_b_5 margin_lr_10">
                        <span class="user_defind_date_hint">请选择日期</span>
                        <input type="text" class="form_query_data_class" data-role="none" id="dateInput${status.index}"/>
                        <span class="iphone40 calendar_40 user_defind_date_btn"></span>
                    </div>
                    <button objid="sdsad" class="blue_btn_inline right inquiry_ensure_btn">确定</button>
                    <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                </div>
                </c:if>
                <c:if test="${conditionObj.inputType eq 'datetime' }">
                <!-- 日期时间控件 -->
                <div id="inquiry_four${status.index}" class="display_none common_inquiry clearFix padding_t_10 comp"
                     comp="type:'tabInquiry',ensureBtn:'inquiry_ensure_btn',cancelBtn:'inquiry_cancel_btn',hideLayerClose:true,
                    backFillTgt:'local_time${status.index}',tabBorderClass:'form_tab_none',changeParentId:'form_list_content',callBack:formReportDateControl">
                    <div class="user_defind_date inquiry_text margin_b_5 margin_lr_10">
                        <span class="user_defind_date_hint">请选择日期</span>
                        <input type="text" class="form_query_datatime_class" data-role="none" id="dateInput${status.index}"/>
                        <span class="iphone40 calendar_40 user_defind_date_btn"></span>
                    </div>
                    <button objid="sdsad" class="blue_btn_inline right inquiry_ensure_btn">确定</button>
                    <button class="white_btn_inline right inquiry_cancel_btn">清空</button>
                </div>
                </c:if>
            </c:forEach>
        </div>
        </c:if>