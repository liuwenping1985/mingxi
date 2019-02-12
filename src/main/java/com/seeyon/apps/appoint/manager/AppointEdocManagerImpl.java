package com.seeyon.apps.appoint.manager;

import java.lang.reflect.Field;
import java.sql.Timestamp;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.tools.ant.util.ReflectUtil;

import com.seeyon.apps.appoint.dao.AppointEdocPushInfoDao;
import com.seeyon.apps.appoint.po.AppoinEdocPushInfo;
import com.seeyon.apps.cindahr.client.FileNumberWebServiceServiceStub;
import com.seeyon.apps.cindahr.client.FileNumberWebServiceServiceStub.SyncFileNumberInfo;
import com.seeyon.apps.cindahr.client.FileNumberWebServiceServiceStub.SyncFileNumberInfoE;
import com.seeyon.apps.cindahr.client.FileNumberWebServiceServiceStub.SyncFileNumberInfoResponseE;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.edoc.domain.EdocForm;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.exception.EdocException;
import com.seeyon.v3x.edoc.manager.EdocFormManager;
import com.seeyon.v3x.edoc.manager.EdocManager;

public class AppointEdocManagerImpl implements AppointEdocManager {
	
	private static final Log log = LogFactory.getLog(AppointEdocManagerImpl.class);
	private static String hrurl = SystemProperties.getInstance().getProperty("appoint.wsdluri");

	public AppointEdocPushInfoDao appointEdocPushInfoDao;
	private EdocManager edocManager;
	private EdocFormManager edocFormManager;
	
	
	public void setEdocFormManager(EdocFormManager edocFormManager) {
		this.edocFormManager = edocFormManager;
	}

	public void setEdocManager(EdocManager edocManager) {
		this.edocManager = edocManager;
	}

	public void setAppointEdocPushInfoDao(
			AppointEdocPushInfoDao appointEdocPushInfoDao) {
		this.appointEdocPushInfoDao = appointEdocPushInfoDao;
	}
	/**
	 * 流程id，文号，签发日期 
	 * @param pram1
	 * @param pram2
	 * @param pram3
	 * @return
	 */
	private boolean pushEdoc2HrBySaop(String pram1,String pram2,String pram3){
		try {
			FileNumberWebServiceServiceStub stub = new FileNumberWebServiceServiceStub(hrurl);
			SyncFileNumberInfo info  = new SyncFileNumberInfo();
			info.setArg0(pram1);
			info.setArg1(pram2);
			info.setArg2(pram3);
			SyncFileNumberInfoE infoe = new SyncFileNumberInfoE();
			infoe.setSyncFileNumberInfo(info);
			SyncFileNumberInfoResponseE resp = stub.syncFileNumberInfo(infoe);
			String rsult = resp.getSyncFileNumberInfoResponse().get_return();
			log.info("参数为：param1="+pram1+",param2==" +pram2+", param3=="+pram3+",返回信息="+rsult);
			if(rsult.equals("ok")){
				return true;
			}
		} catch (Exception e) {
			log.error("hr推送出错",e);
		}
		return false;
	}
	private EnumManager enumManager = AppContext.getBeansOfType(EnumManager.class).get(EnumManager.class);
	public String getEnumValue(String value) throws Exception{
		List<CtpEnumItem> metaItem = null;
		CtpEnumItem metaDataItem = null;
		 String name="";
             CtpEnumItem newItem = enumManager.getEnumItem(EnumNameEnum.edoc_doc_type, value);
             if (null != newItem) {
               name = ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource", newItem.getLabel(), new Object[0]);

            }
           
		return name;
		
	}
	private String getEdocSummaryValue(EdocSummary summary ,String paramName){
		Field[] fields = summary.getClass().getDeclaredFields();
		for (Field field : fields) {
			if(field.getName().equalsIgnoreCase(paramName)){
				Object val =  ReflectUtil.getField(summary, field.getName());
				if(val instanceof Timestamp){
					return Datetimes.format((Timestamp)val, "yyyy-MM-dd");
				}else if(val instanceof java.sql.Date){
					return Datetimes.format((java.sql.Date)val, "yyyy-MM-dd");
				}else if(val instanceof Long){
					try {
						String temp = this.getEnumValue(String.valueOf(val));
						if(Strings.isNotBlank(temp)){
							return temp;
						}
					} catch (Exception e) {
						log.error("",e);
					}
					try {
						V3xOrgEntity en = OrgHelper.getOrgManager().getEntityAnyType(Long.parseLong(String.valueOf(val)));
						return en.getName();
					} catch (Exception e) {
						log.error("",e);
					}
				}
				return String.valueOf(val);
			}
		}
		return null;
	}
	/**
	 * 流程id，文号，签发日期 
	 * @param info
	 */
	private void push(AppoinEdocPushInfo info){
		
//		具体字段同步 （发文日期 职位岗位、文号）
		EdocSummary summary = (EdocSummary) info.getInfo();
		EdocForm form =  edocFormManager.getEdocForm(summary.getFormId());
		String param1 = info.getInfoId();
		String param2 = Strings.isBlank(summary.getDocMark())?summary.getDocMark2():summary.getDocMark();
		String param3 = Datetimes.format(summary.getCreateTime(), "yyyy-MM-dd");
		try {
			boolean result = pushEdoc2HrBySaop(param1, param2, param3);
			if(result){
				info.pushTransLogSuccess();
			}
		} catch (Exception e) {
			log.error("",e);
		}
		
	}
	@Override
	public Boolean push(EdocSummary summary) {
		List<AppoinEdocPushInfo> list = appointEdocPushInfoDao.getLogListBySummaryId(summary.getId());
		AppoinEdocPushInfo info = null;
		if(list!=null&&list.size()>0){
			info = list.get(0);
			info.setInfo(summary);
			this.push(info);
			this.appointEdocPushInfoDao.saveOrUpdate(info);
		}
		return info==null?true :info.isSuccessflag();
	}

	@Override
	public void rePushAllUnSuccess() {
		List<AppoinEdocPushInfo> list = this.appointEdocPushInfoDao.getUnSuccessLog();
		if(list!=null && list.size()>0){
			for (AppoinEdocPushInfo info : list) {
				try {
					EdocSummary summary = edocManager.getEdocSummaryById(info.getSummaryId(), true);
					if(summary!=null){
						Boolean ok =  this.push(summary);
						if(ok){
							info.setSuccessflag(true);
							this.appointEdocPushInfoDao.saveOrUpdate(info);
						}
					}
				} catch (EdocException e) {
					log.error("",e);
				}
			}
		}
		
	}

}
