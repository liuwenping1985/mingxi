package com.seeyon.apps.syncorg.czdomain;

import java.util.Date;

import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.util.CzOrgCheckUtil;
import com.seeyon.apps.syncorg.util.CzXmlUtil;
import com.seeyon.apps.syncorg.util.MapperUtil;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.util.Strings;
import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamImplicit;
import com.thoughtworks.xstream.annotations.XStreamOmitField;
@XStreamAlias("Level")
public class CzLevel {
	
	public V3xOrgLevel toV3xOrgLevel(boolean isNew) throws CzOrgException{
		V3xOrgLevel level = MapperUtil.getLevelByMapperBingId(getThirdId()+ "_" + accountId);
		if(level==null){
			this.setIsnew(true);
			level = new V3xOrgLevel();
			level.setCode(this.getCode());
			level.setName(name);
			level.setDescription(Strings.isBlank(discription)? name: discription);
			level.setCreateTime(new Date());
			level.setEnabled(true);
			level.setIsDeleted(false);
			level.setStatus(1);
			level.setUpdateTime(new Date());
			level.setIdIfNew();
			level.setLevelId(Strings.isBlank(levelId)?1:Integer.valueOf(levelId));
			level.setOrgAccountId(Long.valueOf(accountId));
		}
		return level;
	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	public String getAccountCode() {
		return accountCode;
	}
	public void setAccountCode(String accountCode) {
		this.accountCode = accountCode;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getLevelId() {
		return levelId;
	}
	public void setLevelId(String levelId) {
		this.levelId = levelId;
	}
	public String getParentLevelCode() {
		return parentLevelCode;
	}
	public void setParentLevelCode(String parentLevelCode) {
		this.parentLevelCode = parentLevelCode;
	}
	public String getDiscription() {
		return discription;
	}
	public void setDiscription(String discription) {
		this.discription = discription;
	}
	
	
	public String getThirdId() {
		//当thirdId==null时返回thirdcode
		
		this.thirdId = Strings.isBlank(this.thirdId)?this.getCode():this.thirdId;
		return this.thirdId;
	}
	public void setThirdId(String thirdId) {
		this.thirdId = thirdId;
	}
	
	public boolean isIsnew() {
		return isnew;
	}

	public void setIsnew(boolean isnew) {
		this.isnew = isnew;
	}

	@XStreamOmitField
	private boolean isnew = false;
	private String accountCode;
	private String accountId;  //  只是为了OA 处理的时候， 临时存储一下单位的信息
	private String name;
	private String code;
	private String thirdId;  // 第三方系统的职务级别ID
	private String levelId;  // 职务级别高低的标志， 级别越高， 序号越小， 默认为 1
	private String parentLevelCode;
	private String discription;
	// 客户需求， 在修改岗位的时候， 要判断出修改了职务级别的那些属性
	// 下面这个属性用来定义， 哪些属性从 HR 系统中进行同步
	private static String syncFileds = "accountCode,name,levelId,parentLevelCode,discription"; 
	
	
	public static CzLevel createTestData(){
		CzLevel level = new CzLevel();
		level.setAccountCode("company");
		level.setCode("level002");
		level.setDiscription("第一职务级别描述_修改后22");
		level.setLevelId("1");
		level.setName("第一职务界别_修改后22");
		level.setParentLevelCode("");
		
		return level;
	}
	public static void main(String [] args){
		CzLevel level = createTestData();
		System.out.println(CzXmlUtil.toXml(level));
		System.out.println(level.getThirdId());
	}
	
}
