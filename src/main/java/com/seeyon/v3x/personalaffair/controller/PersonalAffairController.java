package com.seeyon.v3x.personalaffair.controller;

import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.addressbook.manager.AddressBookCustomerFieldInfoManager;
import com.seeyon.apps.addressbook.manager.AddressBookManager;
import com.seeyon.apps.addressbook.po.AddressBook;
import com.seeyon.apps.mobile.api.MobileApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserCustomizeCache;
import com.seeyon.ctp.common.config.IConfigPublicKey;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.constants.CustomizeConstants;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.metadata.bo.MetadataColumnBO;
import com.seeyon.ctp.common.po.config.ConfigItem;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.customize.CtpCustomize;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.system.Constants;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.TimeZoneUtil;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.v3x.mobile.login.manager.MobileLoginManager;
import com.seeyon.v3x.mobile.message.manager.MobileMessageManager;

public class PersonalAffairController extends BaseController {

    private SystemConfig                        systemConfig;
    private OrgManager                          orgManager;
    private OrgManagerDirect                    orgManagerDirect;
    private CustomizeManager                    customizeManager;
    private MobileMessageManager                mobileMessageManager;
    private AppLogManager                       appLogManager;
    private ConfigManager                       configManager;
    private MobileApi                           mobileApi;
    private AddressBookManager                  addressBookManager;
    private AddressBookCustomerFieldInfoManager addressBookCustomerFieldInfoManager;
    private EnumManager enumManagerNew;
    private MobileLoginManager mobileLoginManager;

	public void setSystemConfig(SystemConfig systemConfig) {
        this.systemConfig = systemConfig;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    public void setCustomizeManager(CustomizeManager customizeManager) {
        this.customizeManager = customizeManager;
    }

    public void setMobileMessageManager(MobileMessageManager mobileMessageManager) {
        this.mobileMessageManager = mobileMessageManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setConfigManager(ConfigManager configManager) {
        this.configManager = configManager;
    }

    public void setMobileApi(MobileApi mobileApi) {
        this.mobileApi = mobileApi;
    }

    public void setAddressBookManager(AddressBookManager addressBookManager) {
        this.addressBookManager = addressBookManager;
    }

    public void setAddressBookCustomerFieldInfoManager(AddressBookCustomerFieldInfoManager addressBookCustomerFieldInfoManager) {
        this.addressBookCustomerFieldInfoManager = addressBookCustomerFieldInfoManager;
    }

	public EnumManager getEnumManagerNew() {
		return enumManagerNew;
	}

	public void setEnumManagerNew(EnumManager enumManagerNew) {
		this.enumManagerNew = enumManagerNew;
	}

	public void setMobileLoginManager(MobileLoginManager mobileLoginManager) {
		this.mobileLoginManager = mobileLoginManager;
	}
	
	/**
     * 个人信息设置 - 显示
     */
    public ModelAndView personalInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("personalAffair/person/personalInfo");
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        V3xOrgMember member = orgManager.getMemberById(memberId);
        modelAndView.addObject("member", member);
        Locale orgLocale = orgManagerDirect.getMemberLocaleById(memberId);
        modelAndView.addObject("orgLocale", orgLocale);
        String fileName = Functions.getAvatarImageUrl(memberId);
        modelAndView.addObject("fileName", fileName);
        String selfImage = customizeManager.getCustomizeValue(memberId, "avatar");
        if (selfImage != null) {
            modelAndView.addObject("selfImage", selfImage);
        } else {
            modelAndView.addObject("selfImage", "pic.gif");
        }
        //允许修改个人头像
        boolean isAllowUpdateAvatarEnable = true;
        String isAllowUpdateAvatar = this.systemConfig.get(IConfigPublicKey.ALLOW_UPDATE_AVATAR);
        if (isAllowUpdateAvatar != null && "disable".equals(isAllowUpdateAvatar)) {
            isAllowUpdateAvatarEnable = false;
        }
        modelAndView.addObject("isAllowUpdateAvatarEnable", isAllowUpdateAvatarEnable);
        String ctp2 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.MESSAGESOUNDENABLED);
        String ctp3 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.MESSAGEVIEWREMOVED);
        String ctp4 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.INDEXSHOW);
        String ctp5 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.HANDLE_EXPAND);
        String ctp6 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.TRACK_SEND);
        String ctp7 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.TRACK_PROCESS);
        String ctp10 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.SMS_LOGIN_ENABLED);
        String ctp20 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.BIND_PHONENUMBER);
        String ctp21 = customizeManager.getCustomizeValue(memberId, CustomizeConstants.BIND_EMAIL);

        String enableMsgSound = ctp2 == null ? "" : ctp2;// 启用消息声音提示
        String msgClosedEnable = ctp3 == null ? "" : ctp3;// 系统消息查看后从消息框移出
        String isShowIndexSummary = ctp4 == null ? "" : ctp4;//不显示全文检索摘要
        String extendConfig = ctp5 == null ? "" : ctp5;//处理界面默认自动展开
        String tracksend = ctp6 == null ? "" : ctp6;//发起页面默认跟踪
        String trackprocess = ctp7 == null ? "" : ctp7;//处理页面默认跟踪
        String smsLoginEnable = ctp10 == null ? "" : ctp10;// 启用短信验证码登录
        String bindphonenumberEnable = ctp20 == null ? "" : ctp20;// 绑定手机
        String bindemailEnable = ctp21 == null ? "" : ctp21;// 绑定邮箱
        
		// 个人短信登录验证:后台系统管理员可设置全部人员或者指定人员登录需短信验证
		if (Strings.isBlank(smsLoginEnable)) {
			smsLoginEnable = mobileLoginManager.isMobileLogin(memberId) ? "true" : "false";
		}

        modelAndView.addObject("enableMsgSound", enableMsgSound);
        modelAndView.addObject("msgClosedEnable", msgClosedEnable);
        modelAndView.addObject("isShowIndexSummary", isShowIndexSummary);
        modelAndView.addObject("extendConfig", extendConfig);
        modelAndView.addObject("tracksend", tracksend);
        modelAndView.addObject("trackprocess", trackprocess);
        modelAndView.addObject("smsLoginEnable", smsLoginEnable);
        modelAndView.addObject("bindphonenumberEnable", bindphonenumberEnable);
        modelAndView.addObject("bindemailEnable", bindemailEnable);

        //是否配置企业邮箱
        String emailSetEnable = "false";
        ConfigItem systemMailboxConfigItem = configManager.getConfigItem("System_Mailbox_Setting", "SystemMailAddress");
        if (null != systemMailboxConfigItem && Strings.isNotBlank(systemMailboxConfigItem.getExtConfigValue())) {
            emailSetEnable = "true";
        }
        modelAndView.addObject("emailSetEnable", emailSetEnable);

        //该人员所在单位是否有接收短信的权限
        String smsSetEnable = String.valueOf(mobileApi.isAccountOfCanUseSMS(member.getOrgAccountId()));
        modelAndView.addObject("smsSetEnable", smsSetEnable);

        // 启用消息声音提示
        boolean systemMsgSoundEnable = false;
        String enableMsgSoundConfig = this.systemConfig.get(IConfigPublicKey.MSG_HINT);
        if (enableMsgSoundConfig != null) {
            systemMsgSoundEnable = "enable".equals(enableMsgSoundConfig);
        }
        modelAndView.addObject("systemMsgSoundEnable", systemMsgSoundEnable);

        modelAndView.addObject("isCanUseSMS", mobileMessageManager.isAccountOfCanUseSMS(user.getAccountId()));
        
        //首选时区设置
    	Long enumId = enumManagerNew.getEnumIdByProCode(CustomizeConstants.TIMEZONE);
    	List<CtpEnumItem> timeZoneList = enumManagerNew.getEmumItemByEmumId(enumId);
    	modelAndView.addObject("timeZoneList", timeZoneList);
    	
    	CtpCustomize timeZone = customizeManager.getCustomizeInfo(memberId, CustomizeConstants.TIMEZONE);

    	Long currentTimeZone = null;
    	if(null!=timeZone){
    		currentTimeZone = Long.valueOf(timeZone.getCvalue());
    	}else{
			int currentRawOffset = TimeZone.getDefault().getRawOffset();
    		for(CtpEnumItem enumItem : timeZoneList){
				String timezoneOffset = enumItem.getEnumvalue();
    			int setRawOffset = TimeZone.getTimeZone(TimeZoneUtil.getTimeZoneId(timezoneOffset)).getRawOffset();
    			if(setRawOffset==currentRawOffset){
    				currentTimeZone = enumItem.getId();
    				break;
    			}
    		}
    	}
    	modelAndView.addObject("currentTimeZone", currentTimeZone);
    	modelAndView.addObject("timeZoneEnable", TimeZoneUtil.isEnable());

        //自定义的通讯录字段
        AddressBook addressBook = addressBookCustomerFieldInfoManager.getByMemberId(memberId);
        List<MetadataColumnBO> metadataColumnList = addressBookManager.getCustomerAddressBookList();
        List<MetadataColumnBO> showList = new ArrayList<MetadataColumnBO>();
        Map<String, String> map = new HashMap<String, String>();
        for (MetadataColumnBO metadataColumn : metadataColumnList) {
            if (metadataColumn.getIsShowinPersoninfo() == 1) {
                showList.add(metadataColumn);
                String key = metadataColumn.getId().toString();
                String columnName = metadataColumn.getColumnName();
                try {
                    Method method = addressBookManager.getGetMethod(columnName);
                    if (null == method) {
                        throw new BusinessException("自定义通讯录字段: " + metadataColumn.getLabel() + "不存在！");
                    }
                    if (null != addressBook) {
                        Object value = method.invoke(addressBook, new Object[] {});
                        if (metadataColumn.getType() == 0) {
                            String saveValue = null == value ? "" : String.valueOf(value);
                            map.put(key, saveValue);
                        }
                        if (metadataColumn.getType() == 1) {
                            String saveValue = "";
                            if (value != null) {
                                DecimalFormat df = new DecimalFormat();
                                df.setMinimumFractionDigits(0);
                                df.setMaximumFractionDigits(4);
                                saveValue = df.format(Double.valueOf(String.valueOf(value)));
                                saveValue = saveValue.replaceAll(",", "");
                            }
                            map.put(key, saveValue);

                        }
                        if (metadataColumn.getType() == 2) {
                            String saveValue = null == value ? "" : Datetimes.formatDate((Date) value);
                            map.put(key, saveValue);
                        }
                    } else {
                        map.put(key, "");
                    }
                } catch (Exception e) {
                    logger.error("查看人员通讯录信息失败！", e);
                }
            }
        }
        modelAndView.addObject("bean", showList);
        modelAndView.addObject("beanValue", map);

        return modelAndView;
    }

    /**
     * 个人信息设置 - 更新
     */
    public ModelAndView updatePersonalInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        V3xOrgMember member = orgManager.getMemberById(memberId);
        String imageName = request.getParameter("filename");
        String oldemailaddress = Strings.isBlank(member.getEmailAddress()) ? "" : member.getEmailAddress();
        String oldTelNumber = Strings.isBlank(member.getTelNumber()) ? "" : member.getTelNumber();

        if (AppContext.hasPlugin("i18n")) {
            member.setPrimaryLanguange(request.getParameter("primaryLanguange"));
        }
        
        Map<String, Object> memberMap = new HashMap<String, Object>();
        memberMap.put("officenumber", Strings.isBlank(request.getParameter("telephone")) ? "" : request.getParameter("telephone").toString().replace("\u00A0", " "));
        String telnumber = Strings.isBlank(request.getParameter("telNumber")) ? "" : request.getParameter("telNumber").toString().replace("\u00A0", " ");
        memberMap.put("telnumber", telnumber);
        memberMap.put("address", Strings.isBlank(request.getParameter("address")) ? "" : request.getParameter("address").toString().replace("\u00A0", " "));
        memberMap.put("postalcode", Strings.isBlank(request.getParameter("postalcode")) ? "" : request.getParameter("postalcode").toString().replace("\u00A0", " "));
        String emailaddress = Strings.isBlank(request.getParameter("email")) ? "" : request.getParameter("email").toString().replace("\u00A0", " ");
        memberMap.put("emailaddress", emailaddress);
        memberMap.put("postAddress", Strings.isBlank(request.getParameter("communication")) ? "" : request.getParameter("communication").toString().replace("\u00A0", " "));
        memberMap.put("weibo", Strings.isBlank(request.getParameter("wb")) ? "" : request.getParameter("wb").toString().replace("\u00A0", " "));
        memberMap.put("weixin", Strings.isBlank(request.getParameter("wx")) ? "" : request.getParameter("wx").toString().replace("\u00A0", " "));
        memberMap.put("website", Strings.isBlank(request.getParameter("website")) ? "" : request.getParameter("website").toString().replace("\u00A0", " "));
        memberMap.put("blog", Strings.isBlank(request.getParameter("blog")) ? "" : request.getParameter("blog").toString().replace("\u00A0", " "));
        //客开 赵辉  个人信息中 添加 身份证号
        memberMap.put("idnum", Strings.isBlank(request.getParameter("idNum")) ? "" : request.getParameter("idNum").toString().replace("\u00A0", " "));
        //没有改过手机号或电子邮件，不修改时间戳
        if (Strings.equals(member.getTelNumber(), telnumber) && Strings.equals(member.getEmailAddress(), emailaddress)) {
            OrgHelper.notUpdateModifyTimestampOfCurrentThread();
        }
        member.setProperties(memberMap);
        member.setDescription(Strings.isBlank(request.getParameter("comment")) ? "" : request.getParameter("comment").toString().replace("\u00A0", " "));

        OrganizationMessage returnMessage = orgManagerDirect.updateMember(member);
        try {
        	OrgHelper.throwBusinessExceptionTools(returnMessage);
		} catch (Exception e) {
			response.setContentType("text/html;charset=UTF-8");
	        PrintWriter out = response.getWriter();
	        out.println("<script type='text/javascript'>");
	        out.println("alert('" + e.getMessage() + "')");
	        out.println("</script>");
	        out.flush();
	        return super.redirectModelAndView("/personalAffair.do?method=personalInfo");
		}

        List<Map<String, String>> listCustomize = new ArrayList<Map<String, String>>();
        Map<String, String> map2 = new HashMap<String, String>();
        Map<String, String> map3 = new HashMap<String, String>();
        Map<String, String> map4 = new HashMap<String, String>();
        Map<String, String> map5 = new HashMap<String, String>();
        Map<String, String> map6 = new HashMap<String, String>();
        Map<String, String> map7 = new HashMap<String, String>();
        Map<String, String> map8 = new HashMap<String, String>();
        Map<String, String> map9 = new HashMap<String, String>();
        Map<String, String> map10 = new HashMap<String, String>();
        Map<String, String> map11 = new HashMap<String, String>();
        Map<String, String> mapSmsLoginEnable = new HashMap<String, String>();

        map2.put("Ckey", CustomizeConstants.MESSAGESOUNDENABLED);
        map2.put("Cvalue", Strings.isNotBlank(request.getParameter("enableMsgSound")) ? request.getParameter("enableMsgSound") : "");
        listCustomize.add(map2);

        map3.put("Ckey", CustomizeConstants.MESSAGEVIEWREMOVED);
        map3.put("Cvalue", Strings.isNotBlank(request.getParameter("msgClosedEnable")) ? "true" : "false");
        listCustomize.add(map3);

        map4.put("Ckey", CustomizeConstants.INDEXSHOW);
        map4.put("Cvalue", Strings.isNotBlank(request.getParameter("isShowIndexSummary")) ? "false" : "");
        listCustomize.add(map4);

        map5.put("Ckey", CustomizeConstants.HANDLE_EXPAND);
        map5.put("Cvalue", Strings.isNotBlank(request.getParameter("extendConfig")) ? "" : "false");
        listCustomize.add(map5);

        map6.put("Ckey", "avatar");
        map6.put("Cvalue", Strings.isNotBlank(imageName) ? imageName : "");
        listCustomize.add(map6);

        map7.put("Ckey", CustomizeConstants.TRACK_SEND);
        map7.put("Cvalue", Strings.isNotBlank(request.getParameter("tracksend")) ? "true" : "false");
        listCustomize.add(map7);

        map8.put("Ckey", CustomizeConstants.TRACK_PROCESS);
        map8.put("Cvalue", Strings.isNotBlank(request.getParameter("trackprocess")) ? "true" : "false");
        listCustomize.add(map8);
        //个人信息页面，如果电话或邮箱与修改前的不一样，解除绑定
        if (!emailaddress.equals(oldemailaddress)) {
            map9.put("Ckey", CustomizeConstants.BIND_EMAIL);
            map9.put("Cvalue", "false");
            listCustomize.add(map9);
        }
        if (!telnumber.equals(oldTelNumber)) {
            map10.put("Ckey", CustomizeConstants.BIND_PHONENUMBER);
            map10.put("Cvalue", "false");
            listCustomize.add(map10);
        }
        
        if(TimeZoneUtil.isEnable()){
        	Long enumId = Long.valueOf(request.getParameter("timezone"));
            map11.put("Ckey", CustomizeConstants.TIMEZONE);
            map11.put("Cvalue", String.valueOf(enumId));
            listCustomize.add(map11);
        }

        mapSmsLoginEnable.put("Ckey", CustomizeConstants.SMS_LOGIN_ENABLED);
        String smsLoginEnable = Strings.isNotBlank(request.getParameter("smsLoginEnable")) ? "true" : "false";
        String smsLoginEnableOld = customizeManager.getCustomizeValue(memberId, CustomizeConstants.SMS_LOGIN_ENABLED);
        if (smsLoginEnableOld == null || smsLoginEnableOld.trim().length() == 0) {
            smsLoginEnableOld = "false";
        }
        if (!smsLoginEnableOld.equals(smsLoginEnable)) {
            //如果当前要保存的值与数据库里不一致
            if ("true".equals(smsLoginEnable)) {
                appLogManager.insertLog(user, AppLogAction.SmsLogin_Enable);
            } else {
                appLogManager.insertLog(user, AppLogAction.SmsLogin_Disable);
            }
        }
        mapSmsLoginEnable.put("Cvalue", smsLoginEnable);
        listCustomize.add(mapSmsLoginEnable);

        saveOrUpdateCustomize(listCustomize);

        //自定义的通讯录字段
        AddressBook addressBook = addressBookCustomerFieldInfoManager.getByMemberId(memberId);
        boolean isExist = true;
        if (null == addressBook) {//如果沒有，新增
            addressBook = new AddressBook();
            addressBook.setId(UUIDLong.longUUID());
            addressBook.setMemberId(memberId);
            addressBook.setCreateDate(new Date());
            addressBook.setUpdateDate(new Date());
            isExist = false;
        } else {//更新
            addressBook.setUpdateDate(new Date());
        }
        List<MetadataColumnBO> metadataColumnList = addressBookManager.getCustomerAddressBookList();
        for (MetadataColumnBO metadataColumn : metadataColumnList) {
            if (metadataColumn.getIsShowinPersoninfo() == 1) {
                String columnName = metadataColumn.getColumnName();
                Method method = addressBookManager.getSetMethod(columnName);
                if (null == method) {
                    throw new BusinessException("自定义通讯录字段: " + metadataColumn.getLabel() + "不存在！");
                }
                Object value = request.getParameter(metadataColumn.getId().toString());
                try {
                    if (metadataColumn.getType() == 0) {
                        String saveValue = (null == value || value.equals("")) ? "" : String.valueOf(value);
                        method.invoke(addressBook, new Object[] { saveValue });
                    }
                    if (metadataColumn.getType() == 1) {
                        Double saveValue = (null == value || value.equals("")) ? null : Double.valueOf(String.valueOf(value));
                        method.invoke(addressBook, new Object[] { saveValue });
                    }
                    if (metadataColumn.getType() == 2) {
                        String saveValue = (null == value || value.equals("")) ? "" : String.valueOf(value);
                        method.invoke(addressBook, new Object[] { "".equals(saveValue) ? null : Datetimes.parse(saveValue, "yyyy-MM-dd") });
                    }
                } catch (Exception e) {
                }
            }
        }
        if (isExist) {
            addressBookCustomerFieldInfoManager.updateAddressBook(addressBook);
        } else {
            addressBookCustomerFieldInfoManager.addAddressBook(addressBook);
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + Constants.getString4CurrentUser("system.manager.ok") + "')");
        out.println("</script>");
        out.flush();
        return super.redirectModelAndView("/personalAffair.do?method=personalInfo");
    }

    public void saveOrUpdateCustomize(List<Map<String, String>> listCustomize) {
        if (Strings.isNotEmpty(listCustomize)) {
            for (int i = 0; i < listCustomize.size(); i++) {
                Map<String, String> mapCustomize = listCustomize.get(i);
                String Ckey = mapCustomize.get("Ckey");
                String Cvalue = mapCustomize.get("Cvalue");
                UserCustomizeCache.setCustomize(Ckey, Cvalue);
            }
        }
    }

}
