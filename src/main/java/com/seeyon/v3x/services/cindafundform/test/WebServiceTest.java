package com.seeyon.v3x.services.cindafundform.test;

import com.seeyon.client.FfsServiceStub;

public class WebServiceTest {
	public static void main(String[] args) throws Exception {

		FfsServiceStub stub = new FfsServiceStub("http://127.0.0.1/seeyon/services/ffsService?wsdl");
		FfsServiceStub.GetFFS requst = new FfsServiceStub.GetFFS();
		requst.setXml("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
				+"<fundformInformation>"
				+"<item>"
				+"<amountCount>1200</amountCount>"
				+"<businessDepartment>资金部</businessDepartment>"
				+"<projectName>高铁建设投资</projectName>"
				+"<businessPromise>总公司</businessPromise>"
				+"<approvalAmount>1200</approvalAmount>"
				+"<contractAmount>1300</contractAmount>"
				+"<businessType>投资</businessType>"
				+"<decisionApprovalNum>00001</decisionApprovalNum>"
				+"<approvalDate>2017-07-01</approvalDate>"
				+"<signDate>2017-07-02</signDate>"
				+"<applyAmount>1600</applyAmount>"
				+"<currency>CNY</currency>"
				+"<prepaidDate>2017-07-04</prepaidDate>"
				+"<userTime>36</userTime>"
				+"<isornot>是</isornot>"
				+"<bdOpinion>同意</bdOpinion>"
				+"<baOpinion>按流程办</baOpinion>"
				+"<cmdaOpinion>直接走流程</cmdaOpinion>"
				+"<cmdaLeadOpinion>按意见走</cmdaLeadOpinion>"
				+"<cmdabLeadOpinion>直接走流程</cmdabLeadOpinion>"
				+"<companyLead>好的</companyLead>"
				+"<declarationNum>Test000001</declarationNum>"
				+"<oaApprovaler>马承宇</oaApprovaler>"
				+"<oaSender>刘震</oaSender>"
				+"<subject>资金流程表单测试20170705</subject>"
				+"<projectRecoveries>"
				+"<projectRecovery>"
				+"<ptrDate>2017-07-05</ptrDate>"
				+"<ptrAmount>1500</ptrAmount>"
				+ "</projectRecovery>"
				+"<projectRecovery>"
				+"<ptrDate>2017-07-07</ptrDate>"
				+"<ptrAmount>1600</ptrAmount>"
				+ "</projectRecovery>"
				+ "</projectRecoveries>"
				+"<files>"
				+"<file>"
				+"<fileName>1</fileName>"
				+"<submitDate>2017-07-06</submitDate>"
				+"<filePath>/seeyon/upload/test.txt</filePath>"
				+ "</file>"
				+"<file>"
				+"<fileName>1</fileName>"
				+"<submitDate>2017-07-07</submitDate>"
				+"<filePath>/seeyon/upload/test2.txt</filePath>"
				+ "</file>"
				+ "</files>"
				+"</item>"
				+"</fundformInformation>");
		FfsServiceStub.GetFFSResponse response = stub.getFFS(requst);
		String get_return = (String) response.get_return();
		System.out.println(get_return);
	}

}
