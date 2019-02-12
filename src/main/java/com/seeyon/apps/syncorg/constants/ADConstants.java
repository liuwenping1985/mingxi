package com.seeyon.apps.syncorg.constants;



public abstract class ADConstants {
	public static final String DEFAULTTIME = "2000-01-01 00:00:00";
    public static final String SYN_ACCOUNT="com.seeyon.ctp.organization.bo.V3xOrgAccount";
    public static final String SYN_POST="com.seeyon.ctp.organization.bo.V3xOrgPost";
    public static final String SYN_LEVEL="com.seeyon.ctp.organization.bo.V3xOrgLevel";
    public static final String SYN_DEPARTMENT="com.seeyon.ctp.organization.bo.V3xOrgDepartment";
    public static final String SYN_MEMBER="com.seeyon.ctp.organization.bo.V3xOrgMember";
    public static final String USER_BINDIND_MAPPER="AD";
    public static final String SYN_Configuration = "com.seeyon.apps.ad.Configuration";   //AD配置类别
    public static final String ORG_SYNC_DATE = "ORG_SYNC_DATE";                        //组织模型同步日期
    public static final String ORG_SYNC_TIME = "ORG_SYNC_TIME";                        //组织模型同步时间
    public static final String TASK_REPEAT_TIME = "TASK_REPEATE_TIME";                     //任务列表同步时间
//    public static final String NCMsgConfigItem = "QueryNCMsgTimestamp";
//    public static final String NCPendingMsgConfigItem = "QueryNCPendingMsgTimestamp";
//    static final String MEMBER_SYNC_DEPARTMENT = "MEMBER_SYNC_DEPARTMENT";//人员同步的部门
//    
    public static final String AD_SYNCH_TIMESTAMP = "AD_SYNCH_TIMESTAMP";//NC同步时间戳
    public static final String AD_SYNMEMBER_TIMESTAMP = "AD_SYNMEMBER_TIMESTAMP";
    //tanglh
    public static final String CANAUTOORGSYNC="AUTOORGSYNC";
    
    public static final String ORG_SYNC_TYPE = "ORG_SYNC_TYPE";  
    public static final int ORG_SYNC_TYPE_AUTO = 0;
    
    public static final int ORG_SYNC_TYPE_HANDLE = 1;

    public static final int ORG_SYNC_TYPE_REQUIRE=2;
    
    static public final String NC_CORP_A8_SUF=".nc.corp";
    
    public static final String DATETIME_PARTTENHMS="yyyy-MM-dd HH:mm:ss";
    public static final String DATETIME_PARTTENHM="yyyy-MM-dd HH:mm";
    public static final String DATETIME_PARTTENH="yyyy-MM-dd HH";
    public static final String DATETIME_PARTTEN="yyyy-MM-dd";
    
    public static enum SynchOUType{
        synched("AD_SYNCH_OU","同步一级部门的OU"),
        disabled("AD_SYNCH_DISABLE_OU","停用的OU"),
        defaultLogin("LOGIN_BY_OA_PASSWORD","使用OA密码登录");
        private String key;
        private String text;
        public String key(){
        	return this.key;
        }
        public String text(){
        	return this.text;
        }
        public static SynchOUType get(String name){
        	SynchOUType[] ts=SynchOUType.values();
        	for (SynchOUType synchOUType : ts) {
				if(synchOUType.name().equals(name)){
					return synchOUType;
				}
			}
			return SynchOUType.synched;
        }
        private SynchOUType(String key,String text){
        	this.key = key;
        	this.text = text;
        }
    }
    //同步时间的类型 mazc
    public static enum SYNC_TIME_TYPE{
        setTime, //指定时间
        intervalTime //间隔时间
    }
    public static final String SYNC_TYPE = "SYNC_TYPE";
    public static final String INTERVAL_TIME = "INTERVAL_TIME";
    
//    static final String FILDER_ENABLE="1"; //默认0不启用，    1为启用
//    static final String FILDER_NOT_ENABLED="0"; //默认0不启用，1为启用
//    static final String FILDER_ENABLE_ITEM="filder_enable"; //对应configValue是启用过滤器的NC单位id
//    static final String FILDER_CATEGORY="v3x_plugin_nc_Configuration_filder";//配置类别
    
//    static final String FILDER_STATE_NOT="0";
//    static final String FILDER_STATE_ALL="1";
//    static final String FILDER_STATE_PART="2";
    
//    static final String FILDER_DEPT="v3x_plugin_nc_Configuration_filder_dept";
//    
//    static final String FILDER_DEPT_TYPE_ALL=FILDER_DEPT+"_"+FILDER_STATE_ALL;
//    static final String FILDER_DEPT_TYPE_PART=FILDER_DEPT+"_"+FILDER_STATE_PART;
//    static final String FILDER_DEPT_TYPE_PERSON=FILDER_DEPT+"_"+"person";
//    static final String ORG_SYNC_COMMUNICATION = "org_sync_communication";  
    /**
     * 职务级别来源。
     * @author wangwy
     *
     */
    public static  enum LevelSource
    {
        dutyname,// 职务名称
        dutyrank // 职务级别
    }
    /**
     *岗位来源。
     * @author wangwy
     *
     */    
    public static  enum PostSource
    {
        omjob,// 岗位
        jobrank// 岗位等级
    }
    /**
     * 人员同步通讯信息类别
     *
     */ 
    public static  enum CommunicationType
    {
        mobile,
        officePhone,
        eMail,
        isNewPerson,// 是否仅新增人员同步通讯内容，以后修改人员不同步通讯内容
    }
    
    //条件查询变量
    public static enum ConditionalInquiries{
        option,
        data,
        desc,
        action,
        memo,
    }
    public static enum MemberPropertiesKey{
        officenumber,
        telnumber,
        emailaddress,
        birthday,
        gender;
        public static MemberPropertiesKey getByName(String name){
        	for (MemberPropertiesKey propertie : MemberPropertiesKey.values()) {
				if(propertie.name().equals(name)){
					return propertie;
				}
			}
			return null;
        }
    }
    public static enum SynType{
        ORG_SYNC_TYPE_AUTO,
        /**
         * 手工同步同步标识
         */
        ORG_SYNC_TYPE_HANDLE,
        /**
         * 按需同步标识
         */
        ORG_SYNC_TYPE_REQUIRE,
    }
    public static enum OUAtt{
    	OU("ou","名称"),
    	Dn("distinguishedName","AD区别名"),
    	UpdataTime("whenChanged","更新时间"),
		Id("uSNCreated","创建ID"),
		Guid("objectGUID","objectGUID");
		private String key;
		private String noteText;
		public String key(){
			return this.key;
		}
		public String noteText(){
			return this.noteText;
		}
		private  OUAtt(String key ,String noteText){
			this.key =key;
			this.noteText = noteText;
		}
    }
	public static enum UserAttr{
		LoginName("sAMAccountName","用户登录名（Windows2000前）"),
		LoginName2("userPrincipalName","用户登录名"),
		Dn("distinguishedName","AD区别名"),
		FirstName("sn","姓"),				
		GivenName("givenName","名"),	
		Name("displayName","显示名称"),	
		Cn("cn","属性名"),				
		Initials("initials","英文缩写"),
		Title("title","职务"),
		Desc("description","描述"),
		PostalCode("postalCode","邮政编码"),
		Tel("telephoneNumber","电话号码"),
		TelOther("otherTelephone","其他电话号码"),
		Fac("facsimileTelephoneNumber","传真"),
		FacOther("otherFacsimileTelephoneNumber","传真"),
		IpPhone("ipPhone","IP电话"),
		IpPhoneOther("otherIpPhone","IP电话"),
		HomePhone("homePhone","家庭电话"),
		HomePhoneOther("otherHomePhone","家庭电话"),
		Mobile("mobile","移动电话"),
		MobileOther("otherMobile","移动电话"),
		Mail("mail","电子邮件"),
		Country("co","国家"),
		StateProvince("st","省"),
		City("l","市县"),
		Street("streetAddress","街道"),
		Company("company","公司"),
		Department("department","部门"),
		Office("physicalDeliveryOfficeName","办公室"),
		WhenChanged("whenChanged","更新时间"),
		Enable("userAccountControl","用户状态"),
		Id("uSNCreated","创建ID"),
		Guid("objectGUID","objectGUID");
		
		private String key;
		private String noteText;
		public String key(){
			return this.key;
		}
		public String noteText(){
			return this.noteText;
		}
		private  UserAttr(String key ,String noteText){
			this.key =key;
			this.noteText = noteText;
		}
		public static UserAttr getUserAttr(String key){
			UserAttr[] list = UserAttr.values();
			for (UserAttr attr : list) {
				if(attr.key().equalsIgnoreCase(key)){
					return attr;
				}
			}
			return null;
		}
		public static UserAttr getByNoteText(String noteText){
			UserAttr[] list = UserAttr.values();
			for (UserAttr attr : list) {
				if(attr.noteText().equals(noteText)){
					return attr;
				}
			}
			return null;
		}
		public static String[] getAllAttrList(){
			UserAttr[] list = UserAttr.values();
			String[] attrList = new String[list.length];
			for (int i=0;i<list.length;i++) {
				attrList[i] = list[i].key();
			}
			return attrList;
		}

	}
	public static final String uSNCreated="uSNCreated";
	public static final String uSNChanged="uSNChanged";
	public static final String OU="ou";
    /**
     * AD区别名（全AD域内唯一）
     */
    public static final String DN="distinguishedName";
    public static final String GUID="objectGUID";
	/**
	 * 修改时间
	 */
	public static final String WHENCHANGED = "whenChanged";
}
