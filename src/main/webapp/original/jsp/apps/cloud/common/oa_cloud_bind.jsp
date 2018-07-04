<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        <input type="hidden" value="${res}" id="isBind"/>
        <input type="hidden" value="${path}" id="mallpath"/>
        <input type="hidden" value="${adopt}" id="adopt"/>
        <input type="hidden" value="${state}" id="state"/>
        <input type="hidden" value="${isAdmin}" id="isAdmin"/>
        <input type="hidden" value="${orgName}" id="orgName"/>
        <input type="hidden" value="no" id="imgpass"/>
        
        <!--验证填出层-->
        <div class="validate_dialog none">
            <div class="m_dialog1">
                <div class="picture"><img src="${imageUrl}" class="img" id="myimg"></div>
                <div class="formline">
                <input type="text" class="input" placeholder="手机号" id="telNum_id" value="${telNumber}"/>
                    <div class="warn" id='mobilemsg'></div>
                </div>
                <div class="formline">
                    <input type="text" class="input short" placeholder="图形验证码" id="imgcode" maxlength="4"/>
                    <img src="" class="img_code" id="validateCodeImg">
                    <div class="warn" id="imgmsg"></div>
                </div>
                <div class="formline">
                    <input type="text" class="input short disabled" placeholder="短信验证码" disabled="disabled" id="randcode"/>
                    <button class="m_blueBgbnt disabled" id="invcode" disabled="disabled">发送验证码</button> <!--不可用class上加disabled-->
                    <div class="warn" id="randcodemsg"></div>
                </div>
                <div class="company none" id="company"><img src="${path}/apps_res/cloud/images/icon/lamp.png" class="img" id="bindcompanyimg"><label id="company_id"></label></div>
                <p class="p1 none" id="bindcompanyid"><i class="" id="bindcompany"></i>单位不一致，将影响服务进度查询和商品导入</p>
                <p class="p1"><i class="c_checkbox checked" id="cloudselec"></i>授权应用中心</p>
                <button class="m_blueBgbnt mt25 disabled" id="bindsubmit" disabled="disabled">完成</button>
            </div>
        </div>
