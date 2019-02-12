package com.seeyon.apps.cinda.authority.domain;

import java.math.BigDecimal;
import java.util.Date;

/**
 * UmUser entity. @author MyEclipse Persistence Tools
 */

public class UmUser implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 710824948617140251L;
	private String userid;
	private String loginname;
	private String username;
	private String englishname;
	private BigDecimal sex;
	private String nationality;
	private String country;
	private String province;
	private String city;
	private String unit;
	private String organizationcode;
	private String employeecard;
	private Date registerdate;
	private BigDecimal employeekind;
	private String dutyid;
	private String titleid;
	private String rolecode;
	private String workscope;
	private String telephone;
	private String mobile;
	private String email1;
	private String email2;
	private BigDecimal userkind;
	private String kindsupplement;
	private String idcard;
	private Date startdate;
	private BigDecimal status;
	private String memo;
	private Date enddate;
	private BigDecimal age;
	private String validtime;
	private String applicationid;
	private String department;
	private String dn;
	private String temp;
	private String picture;
	private String idphoto;
	private String useEmail;
	private String useInternet;
	private String useFtp;
	private String useDigitkey;
	private String useWireless;
	private String emailgroup1;
	private String emailgroup2;
	private String emailgroup3;
	private String emailgroup4;
	private String emailgroup5;
	private String emailgroup6;
	private String emailgroup7;
	private String emailgroup8;
	private String vpnUser;
	private String vpnAddr;
	private String emailCn;
	private String groupid;
	private Date modifydate;
	private BigDecimal education;
	private String speciality;
	private String workexperience;
	private String orgid;
	private BigDecimal orders;
	private Date birthday;
	private String birthplace;
	private String nativeplace;
	private String nation;
	private BigDecimal polity;
	private Date politydate;
	private Date startworkdate;
	private String technicalposition;
	private Date technicaldate;
	private Date educationdate;
	private BigDecimal degree;
	private Date degreedate;
	private String qualification;
	private Date qualificationdate;
	private String position;
	private Date positiondate;
	private String post;
	private Date postdate;
	private String domicileplace;
	private String archivesstore;
	private String homeaddress;
	private BigDecimal healthcondition;
	private BigDecimal maritalstatus;
	private String graduateschool;
	private Date sameleveldate;
	private String secretary;
	private String appsystem;
	private String persontype;
	private String personid;
	private String poststatus;
	private String oldname;
	private Date installationdate;
	private Date dimissiondate;
	private String partyposition;
	private Date partypositiondate;
	private String loginnametype;
	private BigDecimal employeeproperty;
	private BigDecimal lockflag;
	private String tmp;
	private String taskid;
	private String persontaskid;

	// Constructors

	/** default constructor */
	public UmUser() {
	}

	/** minimal constructor */
	public UmUser(String userid) {
		this.userid = userid;
	}

	/** full constructor */
	public UmUser(String userid, String loginname, String username,
			String englishname, BigDecimal sex, String nationality,
			String country, String province, String city, String unit,
			String organizationcode, String employeecard, Date registerdate,
			BigDecimal employeekind, String dutyid, String titleid,
			String rolecode, String workscope, String telephone, String mobile,
			String email1, String email2, BigDecimal userkind,
			String kindsupplement, String idcard, Date startdate,
			BigDecimal status, String memo, Date enddate, BigDecimal age,
			String validtime, String applicationid, String department,
			String dn, String temp, String picture, String idphoto,
			String useEmail, String useInternet, String useFtp,
			String useDigitkey, String useWireless, String emailgroup1,
			String emailgroup2, String emailgroup3, String emailgroup4,
			String emailgroup5, String emailgroup6, String emailgroup7,
			String emailgroup8, String vpnUser, String vpnAddr, String emailCn,
			String groupid, Date modifydate, BigDecimal education,
			String speciality, String workexperience, String orgid,
			BigDecimal orders, Date birthday, String birthplace,
			String nativeplace, String nation, BigDecimal polity,
			Date politydate, Date startworkdate, String technicalposition,
			Date technicaldate, Date educationdate, BigDecimal degree,
			Date degreedate, String qualification, Date qualificationdate,
			String position, Date positiondate, String post, Date postdate,
			String domicileplace, String archivesstore, String homeaddress,
			BigDecimal healthcondition, BigDecimal maritalstatus,
			String graduateschool, Date sameleveldate, String secretary,
			String appsystem, String persontype, String personid,
			String poststatus, String oldname, Date installationdate,
			Date dimissiondate, String partyposition, Date partypositiondate,
			String loginnametype, BigDecimal employeeproperty,
			BigDecimal lockflag, String tmp, String taskid, String persontaskid) {
		this.userid = userid;
		this.loginname = loginname;
		this.username = username;
		this.englishname = englishname;
		this.sex = sex;
		this.nationality = nationality;
		this.country = country;
		this.province = province;
		this.city = city;
		this.unit = unit;
		this.organizationcode = organizationcode;
		this.employeecard = employeecard;
		this.registerdate = registerdate;
		this.employeekind = employeekind;
		this.dutyid = dutyid;
		this.titleid = titleid;
		this.rolecode = rolecode;
		this.workscope = workscope;
		this.telephone = telephone;
		this.mobile = mobile;
		this.email1 = email1;
		this.email2 = email2;
		this.userkind = userkind;
		this.kindsupplement = kindsupplement;
		this.idcard = idcard;
		this.startdate = startdate;
		this.status = status;
		this.memo = memo;
		this.enddate = enddate;
		this.age = age;
		this.validtime = validtime;
		this.applicationid = applicationid;
		this.department = department;
		this.dn = dn;
		this.temp = temp;
		this.picture = picture;
		this.idphoto = idphoto;
		this.useEmail = useEmail;
		this.useInternet = useInternet;
		this.useFtp = useFtp;
		this.useDigitkey = useDigitkey;
		this.useWireless = useWireless;
		this.emailgroup1 = emailgroup1;
		this.emailgroup2 = emailgroup2;
		this.emailgroup3 = emailgroup3;
		this.emailgroup4 = emailgroup4;
		this.emailgroup5 = emailgroup5;
		this.emailgroup6 = emailgroup6;
		this.emailgroup7 = emailgroup7;
		this.emailgroup8 = emailgroup8;
		this.vpnUser = vpnUser;
		this.vpnAddr = vpnAddr;
		this.emailCn = emailCn;
		this.groupid = groupid;
		this.modifydate = modifydate;
		this.education = education;
		this.speciality = speciality;
		this.workexperience = workexperience;
		this.orgid = orgid;
		this.orders = orders;
		this.birthday = birthday;
		this.birthplace = birthplace;
		this.nativeplace = nativeplace;
		this.nation = nation;
		this.polity = polity;
		this.politydate = politydate;
		this.startworkdate = startworkdate;
		this.technicalposition = technicalposition;
		this.technicaldate = technicaldate;
		this.educationdate = educationdate;
		this.degree = degree;
		this.degreedate = degreedate;
		this.qualification = qualification;
		this.qualificationdate = qualificationdate;
		this.position = position;
		this.positiondate = positiondate;
		this.post = post;
		this.postdate = postdate;
		this.domicileplace = domicileplace;
		this.archivesstore = archivesstore;
		this.homeaddress = homeaddress;
		this.healthcondition = healthcondition;
		this.maritalstatus = maritalstatus;
		this.graduateschool = graduateschool;
		this.sameleveldate = sameleveldate;
		this.secretary = secretary;
		this.appsystem = appsystem;
		this.persontype = persontype;
		this.personid = personid;
		this.poststatus = poststatus;
		this.oldname = oldname;
		this.installationdate = installationdate;
		this.dimissiondate = dimissiondate;
		this.partyposition = partyposition;
		this.partypositiondate = partypositiondate;
		this.loginnametype = loginnametype;
		this.employeeproperty = employeeproperty;
		this.lockflag = lockflag;
		this.tmp = tmp;
		this.taskid = taskid;
		this.persontaskid = persontaskid;
	}

	// Property accessors

	public String getUserid() {
		return this.userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getLoginname() {
		return this.loginname;
	}

	public void setLoginname(String loginname) {
		this.loginname = loginname;
	}

	public String getUsername() {
		return this.username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEnglishname() {
		return this.englishname;
	}

	public void setEnglishname(String englishname) {
		this.englishname = englishname;
	}

	public BigDecimal getSex() {
		return this.sex;
	}

	public void setSex(BigDecimal sex) {
		this.sex = sex;
	}

	public String getNationality() {
		return this.nationality;
	}

	public void setNationality(String nationality) {
		this.nationality = nationality;
	}

	public String getCountry() {
		return this.country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getProvince() {
		return this.province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getCity() {
		return this.city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getUnit() {
		return this.unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getOrganizationcode() {
		return this.organizationcode;
	}

	public void setOrganizationcode(String organizationcode) {
		this.organizationcode = organizationcode;
	}

	public String getEmployeecard() {
		return this.employeecard;
	}

	public void setEmployeecard(String employeecard) {
		this.employeecard = employeecard;
	}

	public Date getRegisterdate() {
		return this.registerdate;
	}

	public void setRegisterdate(Date registerdate) {
		this.registerdate = registerdate;
	}

	public BigDecimal getEmployeekind() {
		return this.employeekind;
	}

	public void setEmployeekind(BigDecimal employeekind) {
		this.employeekind = employeekind;
	}

	public String getDutyid() {
		return this.dutyid;
	}

	public void setDutyid(String dutyid) {
		this.dutyid = dutyid;
	}

	public String getTitleid() {
		return this.titleid;
	}

	public void setTitleid(String titleid) {
		this.titleid = titleid;
	}

	public String getRolecode() {
		return this.rolecode;
	}

	public void setRolecode(String rolecode) {
		this.rolecode = rolecode;
	}

	public String getWorkscope() {
		return this.workscope;
	}

	public void setWorkscope(String workscope) {
		this.workscope = workscope;
	}

	public String getTelephone() {
		return this.telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getMobile() {
		return this.mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getEmail1() {
		return this.email1;
	}

	public void setEmail1(String email1) {
		this.email1 = email1;
	}

	public String getEmail2() {
		return this.email2;
	}

	public void setEmail2(String email2) {
		this.email2 = email2;
	}

	public BigDecimal getUserkind() {
		return this.userkind;
	}

	public void setUserkind(BigDecimal userkind) {
		this.userkind = userkind;
	}

	public String getKindsupplement() {
		return this.kindsupplement;
	}

	public void setKindsupplement(String kindsupplement) {
		this.kindsupplement = kindsupplement;
	}

	public String getIdcard() {
		return this.idcard;
	}

	public void setIdcard(String idcard) {
		this.idcard = idcard;
	}

	public Date getStartdate() {
		return this.startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}

	public BigDecimal getStatus() {
		return this.status;
	}

	public void setStatus(BigDecimal status) {
		this.status = status;
	}

	public String getMemo() {
		return this.memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public Date getEnddate() {
		return this.enddate;
	}

	public void setEnddate(Date enddate) {
		this.enddate = enddate;
	}

	public BigDecimal getAge() {
		return this.age;
	}

	public void setAge(BigDecimal age) {
		this.age = age;
	}

	public String getValidtime() {
		return this.validtime;
	}

	public void setValidtime(String validtime) {
		this.validtime = validtime;
	}

	public String getApplicationid() {
		return this.applicationid;
	}

	public void setApplicationid(String applicationid) {
		this.applicationid = applicationid;
	}

	public String getDepartment() {
		return this.department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getDn() {
		return this.dn;
	}

	public void setDn(String dn) {
		this.dn = dn;
	}

	public String getTemp() {
		return this.temp;
	}

	public void setTemp(String temp) {
		this.temp = temp;
	}

	public String getPicture() {
		return this.picture;
	}

	public void setPicture(String picture) {
		this.picture = picture;
	}

	public String getIdphoto() {
		return this.idphoto;
	}

	public void setIdphoto(String idphoto) {
		this.idphoto = idphoto;
	}

	public String getUseEmail() {
		return this.useEmail;
	}

	public void setUseEmail(String useEmail) {
		this.useEmail = useEmail;
	}

	public String getUseInternet() {
		return this.useInternet;
	}

	public void setUseInternet(String useInternet) {
		this.useInternet = useInternet;
	}

	public String getUseFtp() {
		return this.useFtp;
	}

	public void setUseFtp(String useFtp) {
		this.useFtp = useFtp;
	}

	public String getUseDigitkey() {
		return this.useDigitkey;
	}

	public void setUseDigitkey(String useDigitkey) {
		this.useDigitkey = useDigitkey;
	}

	public String getUseWireless() {
		return this.useWireless;
	}

	public void setUseWireless(String useWireless) {
		this.useWireless = useWireless;
	}

	public String getEmailgroup1() {
		return this.emailgroup1;
	}

	public void setEmailgroup1(String emailgroup1) {
		this.emailgroup1 = emailgroup1;
	}

	public String getEmailgroup2() {
		return this.emailgroup2;
	}

	public void setEmailgroup2(String emailgroup2) {
		this.emailgroup2 = emailgroup2;
	}

	public String getEmailgroup3() {
		return this.emailgroup3;
	}

	public void setEmailgroup3(String emailgroup3) {
		this.emailgroup3 = emailgroup3;
	}

	public String getEmailgroup4() {
		return this.emailgroup4;
	}

	public void setEmailgroup4(String emailgroup4) {
		this.emailgroup4 = emailgroup4;
	}

	public String getEmailgroup5() {
		return this.emailgroup5;
	}

	public void setEmailgroup5(String emailgroup5) {
		this.emailgroup5 = emailgroup5;
	}

	public String getEmailgroup6() {
		return this.emailgroup6;
	}

	public void setEmailgroup6(String emailgroup6) {
		this.emailgroup6 = emailgroup6;
	}

	public String getEmailgroup7() {
		return this.emailgroup7;
	}

	public void setEmailgroup7(String emailgroup7) {
		this.emailgroup7 = emailgroup7;
	}

	public String getEmailgroup8() {
		return this.emailgroup8;
	}

	public void setEmailgroup8(String emailgroup8) {
		this.emailgroup8 = emailgroup8;
	}

	public String getVpnUser() {
		return this.vpnUser;
	}

	public void setVpnUser(String vpnUser) {
		this.vpnUser = vpnUser;
	}

	public String getVpnAddr() {
		return this.vpnAddr;
	}

	public void setVpnAddr(String vpnAddr) {
		this.vpnAddr = vpnAddr;
	}

	public String getEmailCn() {
		return this.emailCn;
	}

	public void setEmailCn(String emailCn) {
		this.emailCn = emailCn;
	}

	public String getGroupid() {
		return this.groupid;
	}

	public void setGroupid(String groupid) {
		this.groupid = groupid;
	}

	public Date getModifydate() {
		return this.modifydate;
	}

	public void setModifydate(Date modifydate) {
		this.modifydate = modifydate;
	}

	public BigDecimal getEducation() {
		return this.education;
	}

	public void setEducation(BigDecimal education) {
		this.education = education;
	}

	public String getSpeciality() {
		return this.speciality;
	}

	public void setSpeciality(String speciality) {
		this.speciality = speciality;
	}

	public String getWorkexperience() {
		return this.workexperience;
	}

	public void setWorkexperience(String workexperience) {
		this.workexperience = workexperience;
	}

	public String getOrgid() {
		return this.orgid;
	}

	public void setOrgid(String orgid) {
		this.orgid = orgid;
	}

	public BigDecimal getOrders() {
		return this.orders;
	}

	public void setOrders(BigDecimal orders) {
		this.orders = orders;
	}

	public Date getBirthday() {
		return this.birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	public String getBirthplace() {
		return this.birthplace;
	}

	public void setBirthplace(String birthplace) {
		this.birthplace = birthplace;
	}

	public String getNativeplace() {
		return this.nativeplace;
	}

	public void setNativeplace(String nativeplace) {
		this.nativeplace = nativeplace;
	}

	public String getNation() {
		return this.nation;
	}

	public void setNation(String nation) {
		this.nation = nation;
	}

	public BigDecimal getPolity() {
		return this.polity;
	}

	public void setPolity(BigDecimal polity) {
		this.polity = polity;
	}

	public Date getPolitydate() {
		return this.politydate;
	}

	public void setPolitydate(Date politydate) {
		this.politydate = politydate;
	}

	public Date getStartworkdate() {
		return this.startworkdate;
	}

	public void setStartworkdate(Date startworkdate) {
		this.startworkdate = startworkdate;
	}

	public String getTechnicalposition() {
		return this.technicalposition;
	}

	public void setTechnicalposition(String technicalposition) {
		this.technicalposition = technicalposition;
	}

	public Date getTechnicaldate() {
		return this.technicaldate;
	}

	public void setTechnicaldate(Date technicaldate) {
		this.technicaldate = technicaldate;
	}

	public Date getEducationdate() {
		return this.educationdate;
	}

	public void setEducationdate(Date educationdate) {
		this.educationdate = educationdate;
	}

	public BigDecimal getDegree() {
		return this.degree;
	}

	public void setDegree(BigDecimal degree) {
		this.degree = degree;
	}

	public Date getDegreedate() {
		return this.degreedate;
	}

	public void setDegreedate(Date degreedate) {
		this.degreedate = degreedate;
	}

	public String getQualification() {
		return this.qualification;
	}

	public void setQualification(String qualification) {
		this.qualification = qualification;
	}

	public Date getQualificationdate() {
		return this.qualificationdate;
	}

	public void setQualificationdate(Date qualificationdate) {
		this.qualificationdate = qualificationdate;
	}

	public String getPosition() {
		return this.position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public Date getPositiondate() {
		return this.positiondate;
	}

	public void setPositiondate(Date positiondate) {
		this.positiondate = positiondate;
	}

	public String getPost() {
		return this.post;
	}

	public void setPost(String post) {
		this.post = post;
	}

	public Date getPostdate() {
		return this.postdate;
	}

	public void setPostdate(Date postdate) {
		this.postdate = postdate;
	}

	public String getDomicileplace() {
		return this.domicileplace;
	}

	public void setDomicileplace(String domicileplace) {
		this.domicileplace = domicileplace;
	}

	public String getArchivesstore() {
		return this.archivesstore;
	}

	public void setArchivesstore(String archivesstore) {
		this.archivesstore = archivesstore;
	}

	public String getHomeaddress() {
		return this.homeaddress;
	}

	public void setHomeaddress(String homeaddress) {
		this.homeaddress = homeaddress;
	}

	public BigDecimal getHealthcondition() {
		return this.healthcondition;
	}

	public void setHealthcondition(BigDecimal healthcondition) {
		this.healthcondition = healthcondition;
	}

	public BigDecimal getMaritalstatus() {
		return this.maritalstatus;
	}

	public void setMaritalstatus(BigDecimal maritalstatus) {
		this.maritalstatus = maritalstatus;
	}

	public String getGraduateschool() {
		return this.graduateschool;
	}

	public void setGraduateschool(String graduateschool) {
		this.graduateschool = graduateschool;
	}

	public Date getSameleveldate() {
		return this.sameleveldate;
	}

	public void setSameleveldate(Date sameleveldate) {
		this.sameleveldate = sameleveldate;
	}

	public String getSecretary() {
		return this.secretary;
	}

	public void setSecretary(String secretary) {
		this.secretary = secretary;
	}

	public String getAppsystem() {
		return this.appsystem;
	}

	public void setAppsystem(String appsystem) {
		this.appsystem = appsystem;
	}

	public String getPersontype() {
		return this.persontype;
	}

	public void setPersontype(String persontype) {
		this.persontype = persontype;
	}

	public String getPersonid() {
		return this.personid;
	}

	public void setPersonid(String personid) {
		this.personid = personid;
	}

	public String getPoststatus() {
		return this.poststatus;
	}

	public void setPoststatus(String poststatus) {
		this.poststatus = poststatus;
	}

	public String getOldname() {
		return this.oldname;
	}

	public void setOldname(String oldname) {
		this.oldname = oldname;
	}

	public Date getInstallationdate() {
		return this.installationdate;
	}

	public void setInstallationdate(Date installationdate) {
		this.installationdate = installationdate;
	}

	public Date getDimissiondate() {
		return this.dimissiondate;
	}

	public void setDimissiondate(Date dimissiondate) {
		this.dimissiondate = dimissiondate;
	}

	public String getPartyposition() {
		return this.partyposition;
	}

	public void setPartyposition(String partyposition) {
		this.partyposition = partyposition;
	}

	public Date getPartypositiondate() {
		return this.partypositiondate;
	}

	public void setPartypositiondate(Date partypositiondate) {
		this.partypositiondate = partypositiondate;
	}

	public String getLoginnametype() {
		return this.loginnametype;
	}

	public void setLoginnametype(String loginnametype) {
		this.loginnametype = loginnametype;
	}

	public BigDecimal getEmployeeproperty() {
		return this.employeeproperty;
	}

	public void setEmployeeproperty(BigDecimal employeeproperty) {
		this.employeeproperty = employeeproperty;
	}

	public BigDecimal getLockflag() {
		return this.lockflag;
	}

	public void setLockflag(BigDecimal lockflag) {
		this.lockflag = lockflag;
	}

	public String getTmp() {
		return this.tmp;
	}

	public void setTmp(String tmp) {
		this.tmp = tmp;
	}

	public String getTaskid() {
		return this.taskid;
	}

	public void setTaskid(String taskid) {
		this.taskid = taskid;
	}

	public String getPersontaskid() {
		return this.persontaskid;
	}

	public void setPersontaskid(String persontaskid) {
		this.persontaskid = persontaskid;
	}

}