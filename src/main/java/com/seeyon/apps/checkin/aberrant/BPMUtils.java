package com.seeyon.apps.checkin.aberrant;

import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.seeyon.oainterface.common.PropertyList;
import com.seeyon.oainterface.exportData.form.FormExport;
import com.seeyon.oainterface.exportData.form.ValueExport;
import com.seeyon.apps.checkin.client.AuthorityServiceStub;
import com.seeyon.apps.checkin.client.BPMServiceStub;

public class BPMUtils {
	
	/**
	 * 将表单对象转换为xml的串
	 * @param export 表单对象
	 * @return xml类型的串
	 * @throws Exception
	 */
	public String toString(FormExport export) throws Exception{
		StringWriter writer = new StringWriter();
		PropertyList plist = export.saveToPropertyList();
		plist.saveXMLToStream(writer);
        return writer.toString();
	}
	
    public FormExport setValue2(FormExport export,String[] usermessage) throws Exception{
		
        //先为主表赋值
		List<ValueExport> list = new ArrayList<ValueExport>();
		ValueExport ve = new ValueExport();
		
		//姓名
		ve = new ValueExport();
		ve.setDisplayName("姓名");
		ve.setValue(usermessage[0]);
		list.add(ve);
		
		//考勤卡号（员工编号）
		ve = new ValueExport();
		ve.setDisplayName("考勤卡号");
		ve.setValue(usermessage[1]);
		list.add(ve);
		
		//单位
		ve = new ValueExport();
		ve.setDisplayName("单位");
		ve.setValue(usermessage[2]);
		list.add(ve);
		
		//考勤日期
		ve = new ValueExport();
		ve.setDisplayName("考勤日期");
		ve.setValue(usermessage[3]);
		list.add(ve);
		
		//上午上班
		ve = new ValueExport();
		ve.setDisplayName("上午上班");
		ve.setValue(usermessage[4]);
		list.add(ve);
		
		//下午下班
		ve = new ValueExport();
		ve.setDisplayName("下午下班");
		ve.setValue(usermessage[5]);
		list.add(ve);
		export.setValues(list);
		return export;
	}
	
    //将获得的表单模板的xml定义转换为表单对象(发起用)
	public FormExport xmlTOFormExport(String xml) throws Exception{
		FormExport export = new FormExport();
		PropertyList property = new PropertyList("FromExport",1);
		property.loadFromXml(xml);
		export.loadFromPropertyList(property);
		return export;
	}
	
    //将获得的表单模板的xml定义转换为表单对象(下载解析用)
	public FormExport xmlFromFormExport(String xml) throws Exception{
		FormExport export = new FormExport();
		PropertyList property = new PropertyList("FromExport",-1);
		property.loadFromXml(xml);
		export.loadFromPropertyList(property);
		return export;
	}
	
	//获取模板定义,传入的参数为表单模板ID
	public String getTemplateDefinition(String templateCode) throws Exception{
		BPMServiceStub.GetTemplateDefinition gt = new BPMServiceStub.GetTemplateDefinition();
		gt.setToken(this.getTokenId());
		gt.setTemplateCode(templateCode);
		
		BPMServiceStub stub = new BPMServiceStub();
		BPMServiceStub.GetTemplateDefinitionResponse res = stub.getTemplateDefinition(gt);
		//返回的String的数组包含两个内容，export[0]是流程部分，export[1]是表单部分
		String[] export = res.get_return();
		return export[1];
	}
	
	
	//取出tocken id，其中用户名为系统写死的service-admin,密码为123456，这个密码可以自定义，参见文档
	public String getTokenId() throws Exception{
		AuthorityServiceStub.Authenticate au =  new AuthorityServiceStub.Authenticate();
		
//		AuthorityService.authorityService au = new AuthorityService.authorityService();
//		AuthorityService.UserToken token = au.authenticate("service-admin","123456");
		
		au.setUserName("service-admin");
//		au.setPassword("123456");
		au.setPassword("dxyjyzs");
		
		
		AuthorityServiceStub stub = new AuthorityServiceStub();
		AuthorityServiceStub.AuthenticateResponse resp = stub.authenticate(au);
		AuthorityServiceStub.UserToken token = resp.get_return();
		return token.getId();
	}
	
	/**
	 * 发起表单协同
	 * @param token 身份验证tocken
	 * @param loginName 发起人的登录名
	 * @param tcode 表单模板编号
	 * @param data 表单的数据
	 * @param attachments 附件ID的数组
	 * @param param 参数决定是否自动发起
	 * @throws Exception
	 */
	public void lauchFormCollaboration(String token,String loginName,String tcode,String data,String param) throws Exception{
		BPMServiceStub.LaunchFormCollaboration bl = new BPMServiceStub.LaunchFormCollaboration();
		bl.setToken(token); //身份验证tocken
		bl.setAttachments(null); //附件ID的数组
		bl.setData(data); //要发起的表单的数据
		bl.setParam(param); //此参数决定是否自动发起
		bl.setSenderLoginName(loginName); //发起人的登录名
		bl.setSubject("考勤异常申请表单"+new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(new Date())); //表单的标题
		bl.setTemplateCode(tcode); //表单模板编号	
		
		bl.setAttachments(null);
		
		BPMServiceStub stub = new BPMServiceStub();
		BPMServiceStub.LaunchFormCollaborationResponse res = stub.launchFormCollaboration(bl);
		BPMServiceStub.ServiceResponse response = res.get_return();
	}

}
