package com.seeyon.apps.smsplugin;

import java.util.List;

import org.apache.axis2.databinding.types.URI;
import org.csapi.www.service.Cmcc_mas_wbsStub;
import org.csapi.www.service.Cmcc_mas_wbsStub.MessageFormat;
import org.csapi.www.service.Cmcc_mas_wbsStub.SendMethodType;
import org.csapi.www.service.Cmcc_mas_wbsStub.SendSmsRequest;
import org.csapi.www.service.Cmcc_mas_wbsStub.SendSmsResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.usermessage.pipeline.Message;
import com.seeyon.ctp.common.usermessage.pipeline.MessagePipeline;
import com.seeyon.ctp.organization.bo.V3xOrgMember;

public class SmsMessagePipeline implements MessagePipeline {

	private Logger logger = LoggerFactory.getLogger(SmsMessagePipeline.class);
	
	@Override
	public List<Integer> getAllowSettingCategory(User arg0) {
		return null;
	}

	@Override
	public String getName() {
		return "cindaSMS";
	}

	@Override
	public String getShowName() {
		return "cinda短信平台";
	}

	@Override
	public int getSortId() {
		return 4;
	}

	@Override
	public void invoke(Message[] arg0) {
		try {
			logger.info("进入中信达短信接口...");
			logger.info("arg0。。。 start");
			String msg = "";
			URI[] ary = new URI[arg0.length];
			for (int i = 0; i < arg0.length; i++) {
				logger.info("i : {}", i);
				V3xOrgMember v3xOrgMember =  arg0[i].getReceiverMember();
				if (v3xOrgMember != null) {
					logger.info("arg0[i].getReceiverMember.getTelNumber : {}", v3xOrgMember.getTelNumber());
					ary[i] = new URI(v3xOrgMember.getTelNumber());
				}
				logger.info("arg0[i].getContent : {}", arg0[i].getContent());
				msg = arg0[i].getContent();
			}
			logger.info("arg0。。。 end");
			Cmcc_mas_wbsStub cmcc_mas_wbsStub = new Cmcc_mas_wbsStub();
			SendSmsRequest smsRequest = new SendSmsRequest();
			String applicationId = AppContext.getSystemProperty("smsplugin.applicationId");
			logger.info("applicationId : {}", applicationId);
			smsRequest.setApplicationID(applicationId);
			smsRequest.setDeliveryResultRequest(Boolean.TRUE);
			smsRequest.setExtendCode("");
			smsRequest.setMessage(msg);
			smsRequest.setMessageFormat(MessageFormat.GB2312);
			smsRequest.setSendMethod(SendMethodType.Long);
			smsRequest.setDestinationAddresses(ary);

			logger.info("准备调用短信接口......");
			SendSmsResponse rep = cmcc_mas_wbsStub.sendSms(smsRequest);
			String requestIdentifier = rep.getRequestIdentifier();
			logger.info("调用短信接口完成.... requestIdentifier : {}", requestIdentifier);
		} catch (Exception e) {
			logger.info("调用接口异常Exception :", e);
		}
	}

	@Override
	public String isAllowSetting(User arg0) {
		return null;
	}

	@Override
	public boolean isAvailability() {
		return true;
	}

	@Override
	public boolean isDefaultSend() {
		return true;
	}

	@Override
	public boolean isShowSetting() {
		return true;
	}

}
