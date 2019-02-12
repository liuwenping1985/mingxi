package com.seeyon.apps.addressbook.manager;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.jsp.PageContext;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.addressbook.constants.AddressbookConstants;
import com.seeyon.apps.addressbook.dao.AddressBookMemberDao;
import com.seeyon.apps.addressbook.dao.AddressBookSetDao;
import com.seeyon.apps.addressbook.dao.AddressBookSetScopeDao;
import com.seeyon.apps.addressbook.dao.AddressBookTeamDao;
import com.seeyon.apps.addressbook.po.AddressBook;
import com.seeyon.apps.addressbook.po.AddressBookMember;
import com.seeyon.apps.addressbook.po.AddressBookSet;
import com.seeyon.apps.addressbook.po.AddressBookSetScope;
import com.seeyon.apps.addressbook.po.AddressBookTeam;
import com.seeyon.apps.addressbook.webmodel.WebWithPropV3xOrgMember;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.uc.api.UcApi;
import com.seeyon.ctp.common.AbstractSystemInitializer;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.metadata.bo.MetadataCategoryBO;
import com.seeyon.ctp.common.metadata.bo.MetadataColumnBO;
import com.seeyon.ctp.common.metadata.manager.MetadataCategoryManager;
import com.seeyon.ctp.common.metadata.manager.MetadataColumnManager;
import com.seeyon.ctp.organization.bo.CompareSortEntity;
import com.seeyon.ctp.organization.bo.MemberHelper;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.AccountManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OuterWorkerAuthUtil;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgAccount;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FileUtil;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.v3x.common.web.login.CurrentUser;

public class AddressBookManagerImpl extends AbstractSystemInitializer implements AddressBookManager {

    private static final Log               log                 = LogFactory.getLog(AddressBookManagerImpl.class);
    
    private static final String TABLE_ID = "4"; // ctp_metadata_table 表对应的 外单位扩展属性表的id

    private CacheMap<Long, AddressBookSet> AddressBookSetCache = null;

    private OrgManager                     orgManager;
    
    private AccountManager                 accountManager;

    private AddressBookSetDao              addressBookSetDao;

    private AddressBookSetScopeDao         addressBookSetScopeDao;

    private AddressBookMemberDao           addressBookMemberDao;

	private AddressBookTeamDao             addressBookTeamDao;
    
    private UcApi 					   ucApi;
    
    private MetadataColumnManager metadataColumnManager;
    private MetadataCategoryManager metadataCategoryManager;    
    private OrgCache orgCache;

    public void setUcApi(UcApi ucApi) {
        this.ucApi = ucApi;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setAddressBookSetDao(AddressBookSetDao addressBookSetDao) {
        this.addressBookSetDao = addressBookSetDao;
    }

    public void setAddressBookSetScopeDao(AddressBookSetScopeDao addressBookSetScopeDao) {
        this.addressBookSetScopeDao = addressBookSetScopeDao;
    }

    public void setAddressBookMemberDao(AddressBookMemberDao addressBookMemberDao) {
        this.addressBookMemberDao = addressBookMemberDao;
    }

    public void setAddressBookTeamDao(AddressBookTeamDao addressBookTeamDao) {
        this.addressBookTeamDao = addressBookTeamDao;
    }
    
    public void setMetadataColumnManager(MetadataColumnManager metadataColumnManager) {
		this.metadataColumnManager = metadataColumnManager;
	}

	public void setMetadataCategoryManager(
			MetadataCategoryManager metadataCategoryManager) {
		this.metadataCategoryManager = metadataCategoryManager;
	}
	
	
	public void setAccountManager(AccountManager accountManager) {
		this.accountManager = accountManager;
	}

	public void setOrgCache(OrgCache orgCache) {
        this.orgCache = orgCache;
    }

    public void initialize() {
        long start = System.currentTimeMillis();
        CacheAccessable factory = CacheFactory.getInstance(AddressBookManager.class);
        AddressBookSetCache = factory.createMap("AddressBookSetCache");

        List<AddressBookSet> addressBookSetList = addressBookSetDao.findAll();
        if (Strings.isNotEmpty(addressBookSetList)) {
            for (AddressBookSet addressBookSet : addressBookSetList) {
                List<AddressBookSetScope> scopes = addressBookSetScopeDao.findScopeByAddressBookSetId(addressBookSet.getId());
                this.setAddressBookSetScope(addressBookSet, scopes);
                if(addressBookSet.getDisplayColumn()!=null && addressBookSet.getDisplayColumn().indexOf("workLocal")==-1){
                	addressBookSet.setWorkLocal(false);
                }else{
                	addressBookSet.setWorkLocal(true);
                }
                AddressBookSetCache.put(addressBookSet.getAccountId(), addressBookSet);
            }
        }
        log.info("加载所有通讯录设置信息. 耗时: " + (System.currentTimeMillis() - start) + " MS");
    }

	/*
	 * （非 Javadoc）
	 * 
	 * @see com.seeyon.v3x.addressbook.manager.AddressBookManager#addMember(com.seeyon.v3x.addressbook.domain.AddressBookMember)
	 */
	public void addMember(AddressBookMember member) {
		member.setIdIfNew();
		addressBookMemberDao.save(member);
	}

	public void updateMember(AddressBookMember member) {
		addressBookMemberDao.update(member);
	}

	public AddressBookMember getMember(Long memberId) {
		return addressBookMemberDao.get(memberId);
	}

	/*
	 * （非 Javadoc）
	 * 
	 * @see com.seeyon.v3x.addressbook.manager.AddressBookManager#getMembersByCreatorId(java.lang.Long)
	 */
	public List<AddressBookMember> getMembersByCreatorId(Long creatorId) {
		return addressBookMemberDao.findMembersByCreatorId(creatorId);
	}

	public List<AddressBookMember> getMembersByTeamId(Long teamId) {
		// AddressBookTeam category = addressBookTeamDao.get(teamId);
		// Hibernate.initialize(category.getMembers());
		// List<AddressBookMember> members = new ArrayList<AddressBookMember>(
		// category.getMembers());
		List<AddressBookMember> members = this.addressBookMemberDao
				.findMembersByTeamId(teamId);
		return members;
	}

	public void removeCategoryMembersByIds(Long creatorId, List<Long> memberIds) {
		List<AddressBookTeam> categries = addressBookTeamDao
				.findTeamsByCreatorId(creatorId);
		/*
		 * if (null != categries) { for(AddressBookTeam category : categries) {
		 * Hibernate.initialize(category.getMembers()); if (null != memberIds) {
		 * for (Long memberId : memberIds) { AddressBookMember member =
		 * addressBookMemberDao.get(memberId);
		 * category.getMembers().remove(member); } }
		 * addressBookTeamDao.save(category); } }
		 */
	}

	public void removeMembersByIds(Long creatorId, List<Long> memberIds) {
		addressBookMemberDao.deleteMembersByIds(memberIds);
	}

	public List<AddressBookTeam> getTeamsByCreatorId(Long creatorId) {
		return addressBookTeamDao.findTeamsByCreatorId(creatorId);
	}

	public void addTeam(AddressBookTeam team) {
		team.setIdIfNew();
		addressBookTeamDao.save(team);
	}

	public AddressBookTeam getTeam(Long teamId) {
		return addressBookTeamDao.get(teamId);
	}

	public void updateTeam(AddressBookTeam team) {
		addressBookTeamDao.update(team);
	}
    
	public void removeTeamById(Long teamId) {
		AddressBookTeam category = addressBookTeamDao.get(teamId);
		List<AddressBookMember> members = this.getMembersByTeamId(teamId);
		List<Long> memberIds = new ArrayList<Long>();
		if (null != members && !members.isEmpty()) {
			for (AddressBookMember member : members)
				memberIds.add(member.getId());
			addressBookMemberDao.deleteMembersByIds(memberIds);
		}
		addressBookTeamDao.deleteObject(category);
	}

	public List getOrgMemByName(String name) {
		return this.addressBookMemberDao.findOrgMembersByName(name);
	}

	public List getMemberByName(String name) {
		return this.addressBookMemberDao.findMemberByName(name);
	}
	
	public List getMemberByTel(String tel) {
		return this.addressBookMemberDao.findMemberByTel(tel);
	}

	public List getOrgMemberByLevelName(String levelName) {
		return this.addressBookMemberDao.findOrgMemberByLevelName(levelName);
	}

	public List getMemberByLevelName(String levelName) {
		return this.addressBookMemberDao.findMemberByLevelName(levelName);
	}

	public boolean isExist(int type, String name, Long createId, Long accountId, String memberId) {
		if(type == TYPE_EMAIL){
			return addressBookMemberDao.hasSameMail(name, memberId);
		}else if(type == TYPE_CATEGORY){
			return addressBookTeamDao.hasSameCategory(name, createId);
		}else if(type == TYPE_OWNTEAM){
			return addressBookTeamDao.hasSameOwnTeam(name, createId, accountId);
		}else if(type == TYPE_DISCUSS){
			return addressBookTeamDao.hasSameDiscussTeam(name, createId, accountId);
		}
		return true;
	}

	public String doImport(File file, String categoryId, String memberId)
			throws Exception {

		if (null!= file && !Strings.isBlank(categoryId)) {
			//File file  = new File(FilenameUtils.separatorsToSystem(fileURL));
			//FileReader reader = new FileReader(file);
			//BufferedReader br = new BufferedReader(reader);
			
			String encoding = null;
			try {
                encoding = FileUtil.detectEncoding(file.getAbsolutePath());
            } catch (Exception e1) {

            }
            FileInputStream in = new FileInputStream(file);
            InputStreamReader reader;
            if(encoding!=null){
                reader = new InputStreamReader(in,encoding);
            }else{
                reader = new InputStreamReader(in);
            }
            BufferedReader br = new BufferedReader(reader); 
			String result = "";
			String s1 = null;
			while ((s1 = br.readLine()) != null) {
				result += s1 + "\r\n";
			}
			br.close();
			//reader.close();

			AddressBookMember ABmember = null;

			if (!Strings.isBlank(memberId) && !("null").equals(memberId)){
				ABmember = this.getMember(Long.valueOf(memberId));
			} else if (ABmember == null) {
				ABmember = new AddressBookMember();
				ABmember.setCategory(Long.valueOf(categoryId));
			}

			/*
			 * String[] labels = {"FN", "ORG", "TITLE", "TEL;WORK;VOICE",
			 * "TEL;WORK;VOICE", "TEL;HOME;VOICE", "TEL;CAR;VOICE", "TEL;VOICE",
			 * "TEL;PAGER;VOICE", "WORK;FAX", "TEL;HOME;FAX", "TEL;FAX",
			 * "TEL;HOME",
			 * "TEL;ISDN","TEL;PREF","X-MS-TEL;VOICE;ASSISTANT","X-MS-TEL;VOICE;COMPANY","X-MS-TEL;VOICE;CALLBACK","X-MS-TEL;VOICE;RADIO","X-MS-TEL;TTYTDD","ADR;WORK;PREF"};
			 * String label = ""; for(int i=0; i<labels.length; i++){
			 * if(result.contains(labels[i]) && i<labels.length){ result =
			 * result.substring(result.indexOf(labels[i], 1), result.length());
			 * label = result.substring(result.indexOf(":", 1),
			 * result.indexOf(labels[i+1],1)); } }
			 */

			try {
				// BufferedReader reader = new BufferedReader(new
				// InputStreamReader(in));
				// Document document = new DocumentImpl();
				// BufferedWriter writer = null;

				Pattern p = Pattern
						.compile("BEGIN:VCARD(\\r\\n)([\\s\\S\\r\\n\\.]*?)END:VCARD");// 分组，
				Matcher m = p.matcher(result.toString());
				while (m.find()) {
					String str = m.group(0);
					// 姓名
					String name = "";
					Pattern pn = Pattern
							.compile("FN;([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher mn = pn.matcher(m.group(0));
					while (mn.find()) {

						if (mn.group(1).indexOf("ENCODING=QUOTED-PRINTABLE") > -1) {
							name = mn.group(1).substring(
									mn.group(1).indexOf(
											"ENCODING=QUOTED-PRINTABLE:")
											+ "ENCODING=QUOTED-PRINTABLE:"
													.length());
							name = name.substring(name.indexOf(":") + 1);
							if (name.indexOf(";") > -1) {
								name = name.substring(0, name.indexOf(";"));

							}

						} else {
							Pattern pnn = Pattern
									.compile("CHARSET=([A-Za-z0-9-]*?):");
							Matcher mnn = pnn.matcher(mn.group(1));
							while (mnn.find()) {
								name = mn.group(1).substring(
										mn.group(1).indexOf(mnn.group(0))
												+ mnn.group(0).length());
							}
						}

					}

					Pattern pn2 = Pattern
							.compile("FN:([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher mn2 = pn2.matcher(m.group(0));
					while (mn2.find()) {

						if (mn2.group(1).indexOf("ENCODING=QUOTED-PRINTABLE") > -1) {
							name = mn2.group(1).substring(
									mn2.group(1).indexOf(
											"ENCODING=QUOTED-PRINTABLE:")
											+ "ENCODING=QUOTED-PRINTABLE:"
													.length());
							name = name.substring(name.indexOf(":") + 1);
							if (name.indexOf(";") > -1) {
								name = name.substring(0, name.indexOf(";"));

							}

						} else {
							name = mn2.group(1);
						}

					}

					ABmember.setName(name);

					String org = "";
					String companyName = "";
					String depName = "";
					Pattern pno = Pattern
							.compile("ORG;([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher mno = pno.matcher(m.group(0));
					while (mno.find()) {

						if (mno.group(1).indexOf("ENCODING=QUOTED-PRINTABLE") > -1) {
							org = mno.group(1).substring(
									mno.group(1).indexOf(
											"ENCODING=QUOTED-PRINTABLE:")
											+ "ENCODING=QUOTED-PRINTABLE:"
													.length());
							org = org.substring(org.indexOf(":") + 1);
							if (org.indexOf(";") > -1) {
								companyName = org
										.substring(0, org.indexOf(";"));
								depName = org.substring(org.indexOf(";") + 1,
										org.length());
							} else {
								companyName = org;
							}

						} else {
							Pattern pnn = Pattern
									.compile("CHARSET=([A-Za-z0-9-]*?):");
							Matcher mnn = pnn.matcher(mno.group(1));
							while (mnn.find()) {
								org = mno.group(1).substring(
										mno.group(1).indexOf(mnn.group(0))
												+ mnn.group(0).length());
								if (org.indexOf(";") > -1) {
									companyName = org.substring(0, org
											.indexOf(";"));
									depName = org.substring(
											org.indexOf(";") + 1, org.length());
								} else {
									companyName = org;
								}
							}
						}

					}

					Pattern pno2 = Pattern
							.compile("ORG:([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher mno2 = pno2.matcher(m.group(0));
					while (mno2.find()) {

						if (mno2.group(1).indexOf("ENCODING=QUOTED-PRINTABLE") > -1) {
							org = mno2.group(1).substring(
									mno2.group(1).indexOf(
											"ENCODING=QUOTED-PRINTABLE:")
											+ "ENCODING=QUOTED-PRINTABLE:"
													.length());
							org = org.substring(org.indexOf(":") + 1);
							if (org.indexOf(";") > -1) {
								companyName = org
										.substring(0, org.indexOf(";"));
								depName = org.substring(org.indexOf(";") + 1,
										org.length());
							} else {
								companyName = org;
							}

						} else {
							org = mno2.group(1);
							if (org.indexOf(";") > -1) {
								companyName = org
										.substring(0, org.indexOf(";"));
								depName = org.substring(org.indexOf(";") + 1,
										org.length());
							} else {
								companyName = org;
							}
						}
					}

					ABmember.setCompanyDept(depName);
					ABmember.setCompanyName(companyName);

					String title = "";
					Pattern pnt = Pattern
							.compile("TITLE;([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher mnt = pnt.matcher(m.group(0));
					while (mnt.find()) {

						if (mnt.group(1).indexOf("ENCODING=QUOTED-PRINTABLE") > -1) {
							title = mnt.group(1).substring(
									mnt.group(1).indexOf(
											"ENCODING=QUOTED-PRINTABLE:")
											+ "ENCODING=QUOTED-PRINTABLE:"
													.length());
							title = title.substring(title.indexOf(":") + 1);
							if (title.indexOf(";") > -1) {
								title = title.substring(0, title.indexOf(";"));
								ABmember.setCompanyLevel(title);
							} else {
								ABmember.setCompanyLevel(title);
							}

						} else {
							Pattern pnn = Pattern
									.compile("CHARSET=([A-Za-z0-9-]*?):");
							Matcher mnn = pnn.matcher(mnt.group(1));
							while (mnn.find()) {
								title = mnt.group(1).substring(
										mnt.group(1).indexOf(mnn.group(0))
												+ mnn.group(0).length());

							}
						}

					}

					Pattern pnt2 = Pattern
							.compile("TITLE:([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher mnt2 = pnt2.matcher(m.group(0));
					while (mnt2.find()) {

						if (mnt2.group(1).indexOf("ENCODING=QUOTED-PRINTABLE") > -1) {
							title = mnt2.group(1).substring(
									mnt2.group(1).indexOf(
											"ENCODING=QUOTED-PRINTABLE:")
											+ "ENCODING=QUOTED-PRINTABLE:"
													.length());
							title = title.substring(title.indexOf(":") + 1);
							if (title.indexOf(";") > -1) {
								title = title.substring(0, title.indexOf(";"));
							}

						} else {
							title = mnt2.group(1);
						}

					}

					ABmember.setCompanyLevel(title);

					String fax = "";
					Pattern p1 = Pattern.compile("TEL;WORK;FAX;([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher m1 = p1.matcher(str);
					while (m1.find()) {
						fax = m1.group(0).substring(
								m1.group(0).indexOf(":") + 1);
					}
					ABmember.setFax(fax);

					String work = "";
					Pattern p2 = Pattern.compile("TEL;WORK;([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher m2 = p2.matcher(str);
					while (m2.find()) {
						work = m2.group(0).substring(
								m2.group(0).indexOf(":") + 1);
					}
					ABmember.setCompanyPhone(work);

					String home = "";
					Pattern p3 = Pattern.compile("TEL;HOME;([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher m3 = p3.matcher(str);
					while (m3.find()) {
						home = m3.group(0).substring(
								m3.group(0).indexOf(":") + 1);
					}
					ABmember.setFamilyPhone(home);

					String mobile = "";
					Pattern mp3 = Pattern.compile("TEL;CELL;VOICE;([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher mb3 = mp3.matcher(str);
					while (mb3.find()) {
						mobile = mb3.group(0).substring(
								mb3.group(0).indexOf(":") + 1);
					}
					ABmember.setMobilePhone(mobile);

					String email = "";
					Pattern p4 = Pattern
							.compile("\\w+(\\.\\w+)*@\\w+(\\.\\w+)+");// 分组，
					Matcher m4 = p4.matcher(str);
					while (m4.find()) {
						email = m4.group(0);
					}
					ABmember.setEmail(email);

					String address = "";
					Pattern pna = Pattern
							.compile("ADR;HOME;([\\s\\S\\r\\n\\.]*?)([\\r\\n])");// 分组，
					Matcher mna = pna.matcher(m.group(0));
					while (mna.find()) {

						if (mna.group(1).indexOf("ENCODING=QUOTED-PRINTABLE") > -1) {
							address = mn.group(1).substring(
									mn.group(1).indexOf(
											"ENCODING=QUOTED-PRINTABLE:")
											+ "ENCODING=QUOTED-PRINTABLE:"
													.length());
							address = address
									.substring(address.indexOf(":") + 1);
							if (address.indexOf(";") > -1) {
								address = address.substring(0, address
										.indexOf(";"));
								ABmember.setName(address);
							} else {
								ABmember.setName(address);
							}

						} else {
							Pattern pnna = Pattern
									.compile("CHARSET=([A-Za-z0-9-]*?):");
							Matcher mnn = pnna.matcher(mna.group(1));
							while (mnn.find()) {
								address = mna.group(1).substring(
										mna.group(1).indexOf(mnn.group(0))
												+ mnn.group(0).length());
								String country = address
										.substring(
												address.lastIndexOf(";") + 1,
												address.length());
								address = address.substring(0, address
										.lastIndexOf(";"));
								String postcode = address
										.substring(
												address.lastIndexOf(";") + 1,
												address.length());
								ABmember.setAddress(country);
								ABmember.setPostcode(postcode);
							}
						}
					}

				}

			} catch (Exception e) {
				log.error("导入vcard文件异常 : " + e);
				return "";
			}
			User user = CurrentUser.get();
			ABmember.setCreatorId(user.getId());
			ABmember.setCreatorName(user.getName());
			ABmember.setCreatedTime(new Date());
			if(!Strings.isBlank(memberId) && !("null").equals(memberId)){
			    List list=addressBookMemberDao.findMemberByNameAndTeam(ABmember.getName(),ABmember.getCategory(),user.getId());
			    boolean flag=true;
			    if(list!=null&&!list.isEmpty())
		        {
    		        for (int i = 0; i < list.size(); i++) {
    		            AddressBookMember member=(AddressBookMember) list.get(i);
    		            if(!member.getId().toString().equals(memberId)){
    		                return "ExistSameName";
    		            }
                    }
		        }
			    if(flag){
			        this.updateMember(ABmember);
			    }else{
			        return "ExistSameName";
			    }
			}else{
			    if(!this.isExistSameUserName(ABmember,user.getId())){
	                this.addMember(ABmember);
	            }else{
	                return "ExistSameName";
	            }
			}
			

			/*
			 * AddressBookMember ABmember = new AddressBookMember();
			 * ABmember.setIdIfNew(); ABmember.setAddress(s1);
			 * ABmember.setBlog(s1); ABmember.setCategory(s1);
			 * ABmember.setCompanyDept(s1); ABmember.setCompanyDept(s1);
			 * ABmember.setCompanyLevel(s1); ABmember.setCompanyName(s1);
			 * ABmember.setCompanyPhone(s1); ABmember.setCompanyPost(s1);
			 * ABmember.setCreatedTime(s1); ABmember.setCreatorId(s1);
			 * ABmember.setCreatorName(s1); ABmember.setEmail(s1);
			 * ABmember.setFamilyPhone(s1); ABmember.setFax(s1);
			 * ABmember.setMemo(s1); ABmember.setMobilePhone(s1);
			 * ABmember.setModifiedTime(modifiedTime); ABmember.setMsn(s1);
			 * ABmember.setName(s1); ABmember.setPostcode(s1);
			 * ABmember.setQq(""); ABmember.setWebsite(s1);
			 */
		}
		return "OK";
	}

	private Map<String,List<String[]>> readCSVBySheets(File file, int... sheetpages)
			throws Exception {
		if (!file.exists()) {
			log.warn("导入的CSV文件不存在!");
			throw new FileNotFoundException("文件不存在");
		}
		if (sheetpages.length < 1) {
			log.warn("导入的CSV文件没有工作表!");
			throw new FileNotFoundException("CSV文件没有工作表");
		}
        String encoding = null;
        try {
            encoding = FileUtil.detectEncoding(file.getAbsolutePath());
        } catch (Exception e1) {

        }
        FileInputStream in = new FileInputStream(file);
        InputStreamReader reader;
        if(encoding!=null){
            reader = new InputStreamReader(in,encoding);
        }else{
            reader = new InputStreamReader(in);
        }		
		
		
		BufferedReader inr = new BufferedReader(reader);
		String s = null;
		StringBuilder sb = new StringBuilder();
		while((s=inr.readLine())!=null)
			sb.append(s+"\n");
		inr.close();
		
		String csvContent = sb.toString();
		List<String> titleIndex = new ArrayList<String>();
		List<String[]> titleList = new ArrayList<String[]>();
		List<String[]> dataList = new ArrayList<String[]>();
		
		if(csvContent!=null){
			String[] ss = csvContent.split("\n");
			if(ss!=null){
				String title = ss[0];
				String[] titleArray = title!=null?title.replace("\"", "").split(","):null;
				ArrayList<String> list = new ArrayList<String>();
				for (int i = 0; i < titleArray.length; i++) {
				    String str=titleArray[i];
                    if(i==0){
                        String str0=titleArray[0];
                        if(str0.length()>1)
                        str=String.valueOf(str0.toCharArray()[1]);
                    }
                    list.add(str);
                }
				String resource = "com.seeyon.v3x.addressbook.resource.i18n.AddressBookResources";
				//员工通讯录
				String titleContent = ResourceBundleUtil.getString(resource,"export.csv.title",1);
				//String titleContent = "名,姓,中文称谓,单位,部门,职务,住宅地址 街道,住宅地址 邮政编码,单位主要电话,移动电话,电子邮件地址,电子邮件类型,电子邮件显示名称,网页";
				String[] titleContentArray = titleContent.split(",");
				for(String mm : titleContentArray){
					if(Strings.isNotBlank(mm)&&list.contains(mm)){
						int i = list.indexOf(mm);
						titleIndex.add(String.valueOf(i));
					}
				}
				String[] array = {};
				titleList.add(titleIndex.toArray(array));
				for(int i=1;i<ss.length;i++){
					String[] record = ss[i].split(","); 
					dataList.add(record);
				}
			}
		}

		Map<String,List<String[]>> map = new HashMap<String,List<String[]>>();
		
		map.put("title",titleList);
		map.put("data", dataList);
		return map;
	}
	public String doCsvImport(File file, String categoryId,
			String memberId) throws Exception {
		
		if (null!= file && !Strings.isBlank(categoryId)) {
			User user = CurrentUser.get();
			//File file = new File(fileURL);
			if (null != file) {
				Map<String,List<String[]>> csvMap = this.readCSVBySheets(file, 0);
				List<String[]> titleIndex = csvMap.get("title");
				List<String[]> dataList = csvMap.get("data");
				boolean update = false;
				for(int i = 0; i< dataList.size(); i++){
					String[] s = dataList.get(i);
					String[] index = titleIndex!=null?titleIndex.get(0):null;
					AddressBookMember member = null;
					if(Strings.isNotBlank(memberId)){
						member = this.getMember(Long.valueOf(memberId));
						if (member.getName().equals((Integer.parseInt(index[1]) < s.length ? s[Integer.parseInt(index[1])].replace("\"", "") : "") + s[Integer.parseInt(index[0])].replace("\"", ""))) {
							update = true;
						} else {
							member = new AddressBookMember();
							member.setIdIfNew();
							member.setCreatorId(user.getId());
							member.setCreatorName(user.getName());
							member.setCreatedTime(new Date());
							update = false;
						}
					}else{
						member = new AddressBookMember();
						member.setIdIfNew();
						member.setCreatorId(user.getId());
						member.setCreatorName(user.getName());
						member.setCreatedTime(new Date());
						update = false;
					}
					member.setCategory(Long.valueOf(categoryId));
					member.setModifiedTime(new Date());
					if(index!=null){
						member.setName((Integer.parseInt(index[1]) < s.length ? s[Integer.parseInt(index[1])].replace("\"", "") : "") + s[Integer.parseInt(index[0])].replace("\"", ""));
						member.setCompanyName(Integer.parseInt(index[3]) < s.length ? s[Integer.parseInt(index[3])].replace("\"", "") : "");
						member.setCompanyDept(Integer.parseInt(index[4]) < s.length ? s[Integer.parseInt(index[4])].replace("\"", "") : "");
						//根据是否开启职位级别导出做个判断，因没有对应参数，只能判断长度
						if(index.length>13){
							member.setCompanyLevel(Integer.parseInt(index[5]) < s.length ? s[Integer.parseInt(index[5])].replace("\"", "") : "");
							member.setEmail(Integer.parseInt(index[10]) < s.length ? s[Integer.parseInt(index[10])].replace("\"", "") : "");
							member.setWebsite(Integer.parseInt(index[13]) < s.length ? s[Integer.parseInt(index[13])].replace("\"", "") : "");
							member.setCompanyPhone(Integer.parseInt(index[8]) < s.length ? s[Integer.parseInt(index[8])].replace("\"", "") : "");
							member.setMobilePhone(Integer.parseInt(index[9]) < s.length ? s[Integer.parseInt(index[9])].replace("\"", "") : "");
							member.setAddress(Integer.parseInt(index[6]) < s.length ? s[Integer.parseInt(index[6])].replace("\"", "") : "");
							member.setPostcode(Integer.parseInt(index[7]) < s.length ? s[Integer.parseInt(index[7])].replace("\"", "") : "");
						}else{
							member.setEmail(Integer.parseInt(index[9]) < s.length ? s[Integer.parseInt(index[9])].replace("\"", "") : "");
							member.setWebsite(Integer.parseInt(index[12]) < s.length ? s[Integer.parseInt(index[12])].replace("\"", "") : "");
							member.setCompanyPhone(Integer.parseInt(index[7]) < s.length ? s[Integer.parseInt(index[7])].replace("\"", "") : "");
							member.setMobilePhone(Integer.parseInt(index[8]) < s.length ? s[Integer.parseInt(index[8])].replace("\"", "") : "");
							member.setAddress(Integer.parseInt(index[5]) < s.length ? s[Integer.parseInt(index[5])].replace("\"", "") : "");
							member.setPostcode(Integer.parseInt(index[6]) < s.length ? s[Integer.parseInt(index[6])].replace("\"", "") : "");
						}
						Date operatingTime = new Date();
						member.setCreatedTime(Datetimes.addSecond(operatingTime, i));
						member.setModifiedTime(Datetimes.addSecond(operatingTime, i));
					}
					if(update){
						this.updateMember(member);
					}else{
	                    //在同一个组中姓名相同的不能添加
	                    if(!isExistSameUserName(member,user.getId()))
	                    {
	                        this.addMember(member);
	                    }
					}
				}
			}
			return "OK";
		}else{
			return "Fail";
		}
	}

    public boolean isExistSameUserName(AddressBookMember member,Long createrId)
    {
        List list=addressBookMemberDao.findMemberByNameAndTeam(member.getName(),member.getCategory(),createrId);
        if(list!=null&&!list.isEmpty())
        {
         return true;   
        }
        return false;
    }

    public AddressBookSet getAddressbookSetByAccountId(Long accountId) {
        return this.AddressBookSetCache.get(accountId);
    }

    public void saveAddressbookSet(AddressBookSet bean, boolean isNew) {
        Date now = new Date();
        if (isNew) {
            bean.setIdIfNew();
            bean.setCreateDate(now);
            addressBookSetDao.save(bean);
        } else {
            bean.setUpdateDate(now);
            addressBookSetDao.update(bean);
        }
        bean.setUpdateDate(now);

        List<AddressBookSetScope> scopes = addressBookSetScopeDao.saveScope(bean, isNew);
        this.setAddressBookSetScope(bean, scopes);
        this.AddressBookSetCache.put(bean.getAccountId(), bean);
        try {
            if (AppContext.hasPlugin("uc")) {
                ucApi.syncAddressBookSet(bean.getAccountId());
            }
        } catch (BusinessException e) {
            log.error("", e);
        }
        //更新组织模型时间戳
        orgCache.updateModifiedTimeStamp();
    }

    private void setAddressBookSetScope(AddressBookSet addressBookSet, List<AddressBookSetScope> scopes) {
        if (addressBookSet != null) {
            StringBuilder viewScopeIds = new StringBuilder();
            StringBuilder keyInfoIds = new StringBuilder();
            StringBuilder exportPrintIds = new StringBuilder();
            if (Strings.isNotEmpty(scopes)) {
                for (AddressBookSetScope scope : scopes) {
                    if (scope.getAddressbookSetType() == AddressbookConstants.ADDRESSBOOK_SETTYPE_VIEWSCOPE) {
                        viewScopeIds.append(scope.getUserType() + "|" + scope.getUserId() + ",");
                    } else if (scope.getAddressbookSetType() == AddressbookConstants.ADDRESSBOOK_SETTYPE_KEYINFO) {
                        keyInfoIds.append(scope.getUserType() + "|" + scope.getUserId() + ",");
                    } else if (scope.getAddressbookSetType() == AddressbookConstants.ADDRESSBOOK_SETTYPE_EXPORTPRINT) {
                        exportPrintIds.append(scope.getUserType() + "|" + scope.getUserId() + ",");
                    }
                }
            }

            PageContext pageContext = null;
            if (viewScopeIds.length() > 0) {
                addressBookSet.setViewScopeIds(viewScopeIds.substring(0, viewScopeIds.length() - 1));
                addressBookSet.setViewScopeNames(OrgHelper.showOrgEntities(viewScopeIds.substring(0, viewScopeIds.length() - 1), pageContext));
                addressBookSet.setViewScopeMemberSet(this.getMemberIdsByTypeAndIds(viewScopeIds.substring(0, viewScopeIds.length() - 1)));
            } else {
                addressBookSet.setViewScopeIds(null);
                addressBookSet.setViewScopeNames(null);
                addressBookSet.setViewScopeMemberSet(null);
            }
            if (keyInfoIds.length() > 0) {
                addressBookSet.setKeyInfoIds(keyInfoIds.substring(0, keyInfoIds.length() - 1));
                addressBookSet.setKeyInfoNames(OrgHelper.showOrgEntities(keyInfoIds.substring(0, keyInfoIds.length() - 1), pageContext));
                addressBookSet.setKeyInfoMemberSet(this.getMemberIdsByTypeAndIds(keyInfoIds.substring(0, keyInfoIds.length() - 1)));
            } else {
                addressBookSet.setKeyInfoIds(null);
                addressBookSet.setKeyInfoNames(null);
                addressBookSet.setKeyInfoMemberSet(null);
            }
            if (exportPrintIds.length() > 0) {
                addressBookSet.setExportPrintIds(exportPrintIds.substring(0, exportPrintIds.length() - 1));
                addressBookSet.setExportPrintNames(OrgHelper.showOrgEntities(exportPrintIds.substring(0, exportPrintIds.length() - 1), pageContext));
                addressBookSet.setExportPrintMemberSet(this.getMemberIdsByTypeAndIds(exportPrintIds.substring(0, exportPrintIds.length() - 1)));
            } else {
                addressBookSet.setExportPrintIds(null);
                addressBookSet.setExportPrintNames(null);
                addressBookSet.setExportPrintMemberSet(null);
            }
        }
    }

    private void updateAddressBookSetScope(AddressBookSet addressBookSet) {
        if (addressBookSet != null) {
            if (Strings.isNotBlank(addressBookSet.getViewScopeIds())) {
                addressBookSet.setViewScopeMemberSet(this.getMemberIdsByTypeAndIds(addressBookSet.getViewScopeIds()));
            } else {
                addressBookSet.setViewScopeMemberSet(null);
            }
            if (Strings.isNotBlank(addressBookSet.getKeyInfoIds())) {
                addressBookSet.setKeyInfoMemberSet(this.getMemberIdsByTypeAndIds(addressBookSet.getKeyInfoIds()));
            } else {
                addressBookSet.setKeyInfoMemberSet(null);
            }
            if (Strings.isNotBlank(addressBookSet.getExportPrintIds())) {
                addressBookSet.setExportPrintMemberSet(this.getMemberIdsByTypeAndIds(addressBookSet.getExportPrintIds()));
            } else {
                addressBookSet.setExportPrintMemberSet(null);
            }
        }
    }

    private Set<Long> getMemberIdsByTypeAndIds(String typeAndIds) {
        Set<Long> result = null;
        try {
            Set<V3xOrgMember> members = orgManager.getMembersByTypeAndIds(typeAndIds);
            if (Strings.isNotEmpty(members)) {
                result = new HashSet<Long>();
                for (V3xOrgMember member : members) {
                    if (member != null) {
                        result.add(member.getId());
                    }
                }
            }
        } catch (Exception e) {
            log.error("", e);
        }
        return result;
    }

    public boolean checkLevelScope(V3xOrgMember user, V3xOrgMember member, Long accountId, AddressBookSet addressBookSet) {
        return this.checkLevelScope(user, member, accountId, addressBookSet, null, null);
    }

    public boolean checkLevelScope(V3xOrgMember user, V3xOrgMember member, Long accountId, AddressBookSet addressBookSet, Map<Long, List<V3xOrgDepartment>> deptsMap, Map<Long, Set<Long>> deptIdsMap) {
        try {
            if (user.getId().equals(member.getId())) {
                return true;
            }

            if(deptsMap==null){
            	deptsMap = new HashMap<Long, List<V3xOrgDepartment>>();
            }
            if(deptIdsMap==null){
            	deptIdsMap = new HashMap<Long, Set<Long>>();
            }
            if (null != addressBookSet) {
                if (null != addressBookSet.getViewScope()) {
                    Set<Long> viewScopeMemberSet = addressBookSet.getViewScopeMemberSet();
                    if (addressBookSet.getViewScope() == AddressbookConstants.ADDRESSBOOK_VIEWSCOPE_1) {
                        if (Strings.isNotEmpty(viewScopeMemberSet) && viewScopeMemberSet.contains(member.getId())) {
                            return false;
                        }
                    } else if (addressBookSet.getViewScope() == AddressbookConstants.ADDRESSBOOK_VIEWSCOPE_2) {
                        if (Strings.isNotEmpty(viewScopeMemberSet) && viewScopeMemberSet.contains(user.getId())) {
                            return true;
                        }

                        if (!member.getIsInternal()) {
                            return true;
                        }

                        Set<Long> userDeptIds = new HashSet<Long>();
                        List<MemberPost> userPosts = orgManager.getMemberPosts(accountId, user.getId());
                        if (Strings.isNotEmpty(userPosts)) {
                            for (MemberPost userPost : userPosts) {
                                userDeptIds.add(userPost.getDepId());

                                List<V3xOrgDepartment> userDepts;
                                if (deptsMap.containsKey(userPost.getDepId())) {
                                    userDepts = deptsMap.get(userPost.getDepId());
                                } else {
                                    userDepts = orgManager.getChildDepartments(userPost.getDepId(), false, true);
                                    deptsMap.put(userPost.getDepId(), userDepts);
                                }

                                if (Strings.isNotEmpty(userDepts)) {
                                    for (V3xOrgDepartment userDept : userDepts) {
                                        userDeptIds.add(userDept.getId());
                                    }
                                }
                            }
                        }

                        Set<Long> memberDeptIds = new HashSet<Long>();
                        List<MemberPost> memberPosts = orgManager.getMemberPosts(accountId, member.getId());
                        if (Strings.isNotEmpty(memberPosts)) {
                            for (MemberPost memberPost : memberPosts) {
                                memberDeptIds.add(memberPost.getDepId());
                            }
                        }

                        return Strings.isNotEmpty(Strings.getIntersection(userDeptIds, memberDeptIds));
                    }
                }
            }

            int accountLevelScope = orgManager.getAccountById(accountId).getLevelScope();
            if (accountLevelScope >= 0) {
                return checkOrgLevelScope(user, member, accountId, deptIdsMap);
            }
        } catch (Exception e) {
            log.error("", e);
        }

        return true;
    }

    private boolean checkOrgLevelScope(V3xOrgMember user, V3xOrgMember member, Long accountId, Map<Long, Set<Long>> deptIdsMap) {
        Long userDepartmentId = user.getOrgDepartmentId();
        Long memberDepartmentId = member.getOrgDepartmentId();

        try {
            //相同的部门
            if (Strings.equals(userDepartmentId, memberDepartmentId) || orgManager.isInDepartmentPathOf(userDepartmentId, memberDepartmentId)) {
                return true;
            }

            //相同的职务级别
            if (user.getOrgLevelId().longValue() == member.getOrgLevelId().longValue()) {
                return true;
            }
            if (null == deptIdsMap) {
                deptIdsMap = new HashMap<Long, Set<Long>>();
            }
            Long memberDeptId = member.getOrgDepartmentId();
            Set<Long> deptids = deptIdsMap.get(memberDeptId);
            if (deptids == null) {
                deptids = OrgHelper.getChildD(member.getOrgDepartmentId());
                deptIdsMap.put(member.getOrgDepartmentId(), deptids);
            }

            // 副岗在这个部门的有权限
            if (MemberHelper.isSndPostContainDept(user, deptids)) {
                return true;
            }

            Long userDeptId = user.getOrgDepartmentId();
            Set<Long> deptids2 = deptIdsMap.get(userDeptId);
            if (deptids2 == null) {
                deptids2 = OrgHelper.getChildD(user.getOrgDepartmentId());
                deptIdsMap.put(user.getOrgDepartmentId(), deptids2);
            }
            if (MemberHelper.isSndPostContainDept(member, deptids2)) {
                return true;
            }

            //切换单位的工作范围
            int accountLevelScope = orgManager.getAccountById(accountId).getLevelScope();
            if (accountLevelScope < 0) {
                return true;
            }

            //映射集团职务级别
            int userLevelSortId = 0;
            int memberLevelSortId = 0;

            V3xOrgLevel memberLevel = orgManager.getLevelById(member.getOrgLevelId());
            if (memberLevel != null) {
                memberLevelSortId = memberLevel.getLevelId();
            }
            if (!Strings.equals(member.getOrgAccountId(), accountId)) {
                Map<Long, List<MemberPost>> concurrentPostMap = orgManager.getConcurentPostsByMemberId(accountId, member.getId());
                if (concurrentPostMap != null && !concurrentPostMap.isEmpty()) {
                    Iterator<List<MemberPost>> it = concurrentPostMap.values().iterator();
                    User u = AppContext.getCurrentUser();
                    while (it.hasNext()) {
                        boolean isExist = false;
                        List<MemberPost> cnPostList = it.next();
                        for (MemberPost cnPost : cnPostList) {
                            if (orgManager.isInDepartmentPathOf(u.getDepartmentId(), cnPost.getDepId())) {
                                return true;
                            }

                            if (cnPost.getLevelId() != null) {
                                memberLevelSortId = orgManager.getLevelById(cnPost.getLevelId()).getLevelId();
                                isExist = true;
                                break;
                            }
                        }
                        if(isExist){
                        	break;
                        }
                    }
                }
            }
            if (user.getOrgAccountId().equals(accountId)) {
                V3xOrgLevel userLevel = orgManager.getLevelById(user.getOrgLevelId());
                if (userLevel != null) {
                    userLevelSortId = userLevel.getLevelId();
                }
            } else {
                userLevelSortId = OrgHelper.mappingLevelSortId(member, accountId, user, AppContext.currentAccountId());
            }
            if (userLevelSortId - memberLevelSortId <= accountLevelScope) {
                return true;
            }
        } catch (Exception e) {
            log.error("", e);
        }

        return false;
    }

    public boolean checkLevel(Long userId, Long memberId, Long accountId) {
        AddressBookSet addressBookSet = this.getAddressbookSetByAccountId(accountId);
        return this.checkLevel(userId, memberId, accountId, addressBookSet);
    }

    public boolean checkLevel(Long userId, Long memberId, Long accountId, AddressBookSet addressBookSet) {
        return this.checkLevelOrPhone(userId, memberId, accountId, addressBookSet, "Level");
    }

    public boolean checkPhone(Long userId, Long memberId, Long accountId) {
        AddressBookSet addressBookSet = this.getAddressbookSetByAccountId(accountId);
        return this.checkPhone(userId, memberId, accountId, addressBookSet);
    }

    public boolean checkPhone(Long userId, Long memberId, Long accountId, AddressBookSet addressBookSet) {
        return this.checkLevelOrPhone(userId, memberId, accountId, addressBookSet, "Phone");
    }

    private boolean checkLevelOrPhone(Long userId, Long memberId, Long accountId, AddressBookSet addressBookSet, String type) {
        if (userId.equals(memberId)) {
            return true;
        }

        if (addressBookSet == null) {
            return true;
        }

        int filter = AddressbookConstants.ADDRESSBOOK_KEYINFOTYPE_1;
        if ("Level".equals(type)) {
            filter = AddressbookConstants.ADDRESSBOOK_KEYINFOTYPE_2;
        } else if ("Phone".equals(type)) {
            filter = AddressbookConstants.ADDRESSBOOK_KEYINFOTYPE_3;
        }

        if (null != addressBookSet.getKeyInfoType() && addressBookSet.getKeyInfoType() != filter) {
            if (addressBookSet.getKeyInfo() == AddressbookConstants.ADDRESSBOOK_KEYINFO_1) {
                return true;
            } else if (addressBookSet.getKeyInfo() == AddressbookConstants.ADDRESSBOOK_KEYINFO_2) {
                Set<Long> keyInfoMemberSet = addressBookSet.getKeyInfoMemberSet();
                if (Strings.isEmpty(keyInfoMemberSet)) {
                    return true;
                } else {
                    return !keyInfoMemberSet.contains(memberId);
                }
            } else if (addressBookSet.getKeyInfo() == AddressbookConstants.ADDRESSBOOK_KEYINFO_3) {
                Set<Long> keyInfoMemberSet = addressBookSet.getKeyInfoMemberSet();
                if (Strings.isEmpty(keyInfoMemberSet)) {
                    return false;
                } else {
                    return keyInfoMemberSet.contains(userId);
                }
            }
        } else {
            return true;
        }

        return false;
    }

    public List<V3xOrgMember> listDeptMembers(Long deptId, Long accountId, List<V3xOrgMember> members) throws Exception {
        User user = AppContext.getCurrentUser();
        V3xOrgMember curMem = orgManager.getMemberById(user.getId());
        V3xOrgDepartment dept = orgManager.getDepartmentById(deptId);
        List<V3xOrgMember> result = new ArrayList<V3xOrgMember>();
        if (!user.isInternal() || !dept.getIsInternal()) {//内部人员访问外部门、外部人员访问内部人员权限不用判断了，取之前已经判断了
            result = members;
        } else {
            if (CollectionUtils.isNotEmpty(members)) {
                AddressBookSet addressBookSet = this.getAddressbookSetByAccountId(accountId);
                Map<Long, List<V3xOrgDepartment>> deptsMap = new HashMap<Long, List<V3xOrgDepartment>>();
                Map<Long, Set<Long>> deptIdsMap = new HashMap<Long, Set<Long>>();
                for (V3xOrgMember member : members) {
                    if (!accountId.equals(member.getOrgAccountId())) {
                        Map<Long, List<MemberPost>> memberPosts = this.orgManager.getConcurentPostsByMemberId(accountId, member.getId());

                        if (!memberPosts.isEmpty()) {
                            List<MemberPost> conPostList = memberPosts.get(deptId);
                            if (CollectionUtils.isNotEmpty(conPostList)) {
                                MemberPost conPost = conPostList.get(0);
                                V3xOrgMember mem = this.orgManager.getMemberById(member.getId());
                                if (mem == null || !mem.isValid())
                                    continue;
                                member = new V3xOrgMember(mem);
                                if (conPost.getDepId() != null)
                                    member.setOrgDepartmentId(conPost.getDepId());
                                if (conPost.getLevelId() != null)
                                    member.setOrgLevelId(conPost.getLevelId());
                            }
                        }
                    }

                    boolean cls = this.checkLevelScope(curMem, member, accountId, addressBookSet, deptsMap, deptIdsMap);
                    if (cls)
                        result.add(member);
                }
            }
        }
        return result;
    }
    
    @Override
    public List<MetadataColumnBO> getCustomerAddressBookList() throws BusinessException{
    	//查看通讯录分类的id
    	Long categoryId=0L;
    	Map<String, Object> categoryParams =new HashMap<String, Object>();
    	categoryParams.put("moduleType", 14);
    	FlipInfo categoryFi = metadataCategoryManager.findMetadataCategoryList(new FlipInfo(), categoryParams);
    	List<MetadataCategoryBO> l=categoryFi.getData();
    	if(null!=l && l.size()>0){
    		 categoryId=l.get(0).getId();
    	}
    	
        //自定义通讯录字字段
        FlipInfo fi=new FlipInfo();
        fi.setSize(100);
        Map<String, Object> sqlParams =new HashMap<String, Object>();
        sqlParams.put("isEnable", 1);
        sqlParams.put("categoryId", categoryId);
        sqlParams.put("tableId", TABLE_ID);
        List<MetadataColumnBO> metadataColumnBOList =new ArrayList<MetadataColumnBO>();
        FlipInfo addressBookFlipInfo=metadataColumnManager.findCtpMetadataColumnList(fi, sqlParams);
        if(null!=addressBookFlipInfo){
        	metadataColumnBOList=addressBookFlipInfo.getData();
        }
        return metadataColumnBOList;
    }
    
	@Override
    public List<MetadataColumnBO> getCurrentAccountEnableCustomerFields(AddressBookSet addressbookSet) throws BusinessException {
    	//自定义通讯录字字段
		List<MetadataColumnBO> bean= new ArrayList<MetadataColumnBO>();
    	List<MetadataColumnBO> customerList = getCustomerAddressBookList();
		if (null!=customerList  && customerList.size()>0) {
			if(null!=addressbookSet){
				String displayColumn=addressbookSet.getDisplayColumn();
				if(null!=displayColumn && !"".equals(displayColumn)){
					for(MetadataColumnBO a : customerList){
						if(displayColumn.indexOf(","+a.getId())>0){
							bean.add(a);
						}
					}
				}
			}
		}
		
		return bean;
    }
	
	@Override
	public Method getGetMethod(String fieldName) {
		fieldName=fieldName.replace("EXT_ATTR_", "ExtAttr");
		String method="get"+fieldName;
		try {
			return AddressBook.class.getMethod(method);
		} catch (Exception e) {
		}
		return null;
	}
	
	/**
	 * 获取自定义通讯录对应字段的set方法
	 * @param fieldName
	 * @return
	 */
	@Override
	public Method getSetMethod(String fieldName) {
		fieldName=fieldName.replace("EXT_ATTR_", "extAttr");
		try {
			Class[] parameterTypes = new Class[1];    
			Field field = AddressBook.class.getDeclaredField(fieldName);       
			parameterTypes[0] = field.getType();       
			
			StringBuffer sb = new StringBuffer();       
			sb.append("set");       
			sb.append(fieldName.substring(0, 1).toUpperCase());       
			sb.append(fieldName.substring(1));       
			
			String method=sb.toString();
			return AddressBook.class.getMethod(method,parameterTypes);
		} catch (Exception e) {
		}
		return null;
	}
	
	/**
	 * 获取人员的关联人员信息
	 * @param memberId
	 * @param accountId
	 * @return
	 * @throws Exception
	 */
	@Override
	public HashMap getRelationInfoByMemberId(String memberId,String accountId) throws Exception  {
		HashMap map = new HashMap();
		V3xOrgMember member = orgManager.getMemberById(Long.valueOf(memberId));
        Long deptId = member.getOrgDepartmentId();
        if(String.valueOf(orgManager.getRootAccount().getId()).equals(accountId)){
        	accountId=String.valueOf(member.getOrgAccountId());
        }
        if(Strings.isNotBlank(accountId)){
        	List<MemberPost> result = orgManager.getMemberPosts(Long.valueOf(accountId), Long.valueOf(memberId));
        	if(null !=result && result.size()>0){
        		MemberPost memberPost = result.get(0);
        		deptId = memberPost.getDepId();
        	}
       }

		//TA的领导：所在部门部门主管+汇报人 
/*		String leadersStr="";
		List<V3xOrgMember> leaders = new ArrayList<V3xOrgMember>();
		if(null!=deptId){
			List<V3xOrgMember> depAdmins = orgManager.getMembersByDepartmentRole(deptId, OrgConstants.Role_NAME.DepManager.name());
			for(V3xOrgMember m : depAdmins){
				if(Long.valueOf(memberId).compareTo(m.getId())==0){
					continue;
				}
				String fileName = OrgHelper.getAvatarImageUrl(m.getId());
				//将头像信息放在备注中传入前台。
				m.setDescription(fileName);
				leaders.add(m);
				leadersStr+=m.getId();
			}
			
			Long reporterId = member.getReporter();//汇报人
			if(reporterId!=Long.valueOf(memberId) && reporterId!=-1 && leadersStr.indexOf(String.valueOf(reporterId))<0){
				V3xOrgMember reporter = orgManager.getMemberById(reporterId);
				reporter.setDescription(OrgHelper.getAvatarImageUrl(reporterId));
				leaders.add(reporter);
			}
		}
		map.put("leaders", leaders);*/
		
		//TA所属部门的成员：所属部门成员不包括自己
        
        AddressBookSet accountAddressBookSet = getAddressbookSetByAccountId(Long.valueOf(accountId));
		List<Map<String, Object>> colleagues = new ArrayList<Map<String, Object>>();
		if(null!=deptId){
			List<V3xOrgMember> memberList = orgManager.getMembersByDepartment(deptId, false);
			Map<Long, List<V3xOrgDepartment>> deptsMap = new HashMap<Long, List<V3xOrgDepartment>>();
            Map<Long, Set<Long>> deptIdsMap = new HashMap<Long, Set<Long>>();
			for(V3xOrgMember m : memberList){
				if(Long.valueOf(memberId).compareTo(m.getId())==0){
					continue;
				}
				if (!checkLevelScope(member, m, Long.valueOf(accountId), accountAddressBookSet, deptsMap, deptIdsMap) && AppContext.getCurrentUser().isInternal()) {
					continue;
				}
				
				String fileName = OrgHelper.getAvatarImageUrl(m.getId());
				
				Map<String, Object> memberMap = new HashMap<String, Object>();
				memberMap.put("id", m.getId());
				memberMap.put("name", m.getName());
				memberMap.put("description", fileName);
				colleagues.add(memberMap);
			}
		}
        map.put("colleagues", colleagues);
        
        return map;
        
	}
	
	@Override
	@AjaxAccess
	public List<WebV3xOrgAccount> getAccountTree(Map params) throws BusinessException{
        List<V3xOrgAccount> orgAccounts =  orgManager.accessableAccounts(AppContext.getCurrentUser().getId());
        Collections.sort(orgAccounts, CompareSortEntity.getInstance());
        List<WebV3xOrgAccount> treeResult = new ArrayList<WebV3xOrgAccount>();
        
        Map<String, V3xOrgAccount> path2AccountMap = new HashMap<String, V3xOrgAccount>();
        for (V3xOrgAccount a : orgAccounts) {
            path2AccountMap.put(a.getPath(), a);
        }
        
        Map<Long, Long> accId2parentAcc = new HashMap<Long, Long>();
        Set<Long> accHaschild = new HashSet<Long>();
        for (V3xOrgAccount a : orgAccounts) {
            String path = a.getPath();
            if(Strings.isNotBlank(path)) {
                if(path.length() > 4){
                    String parentpath = path.substring(0, path.length() - 4);
                    V3xOrgAccount t = path2AccountMap.get(parentpath);
                    if(t != null){
                        accId2parentAcc.put(a.getId(), t.getId());
                        accHaschild.add(t.getId());
                    }
                }
            }
        }
        
        for (V3xOrgAccount a : orgAccounts) {
            Long parentId = accId2parentAcc.get(a.getId())==null?Long.valueOf(-1):accId2parentAcc.get(a.getId());
            WebV3xOrgAccount treeAccount = new WebV3xOrgAccount(a.getId(), a.getName(), parentId);
            //treeAccount.setV3xOrgAccount(a);
            treeAccount.setLevel(new Long(a.getPath().length()/4));
            treeAccount.setShortName(a.getShortName());
            //处理zTree上的图标问题
            treeAccount.setIconSkin("account");
            if(accHaschild.contains(a.getId())) {
                treeAccount.setIconSkin("treeAccount");
            }
            treeResult.add(treeAccount);
        }
        return treeResult;
/*		List<WebV3xOrgAccount> result = accountManager.showAccountTree(params);
		List<WebV3xOrgAccount> accountTree = new ArrayList<WebV3xOrgAccount>();
		for(WebV3xOrgAccount w : result){
			if(w.getId().compareTo(-1L)==0){
				continue;
			}
			accountTree.add(w);
		}
		return accountTree;*/
	}
	
	@Override
	@AjaxAccess
	public String getContactsByAccountId(String accountId,String searchContent,String key) throws Exception{
    	User user = AppContext.getCurrentUser();
    	if(Strings.isBlank(accountId)){
    		accountId=V3xOrgEntity.VIRTUAL_ACCOUNT_ID.toString();
    	}
    	
    	V3xOrgMember currentMember = orgManager.getMemberById(user.getId());
    	
        List<V3xOrgMember> members = orgManager.getAllMembers(Long.valueOf(accountId));// 单位人员，包括兼职人员
       
        List<V3xOrgMember> outMembers = orgManager.getMemberWorkScopeForExternal(user.getId(), false);// 获取我能看的外部人员
		Map<String,List<WebWithPropV3xOrgMember>> map = new HashMap<String,List<WebWithPropV3xOrgMember>>();
		if(null == members && null == outMembers) {
			return "";
		}
        List<V3xOrgMember> resultList = new ArrayList<V3xOrgMember>();
        AddressBookSet accountAddressBookSet = getAddressbookSetByAccountId(Long.valueOf(accountId));
		if(user.isInternal()){
			if (Strings.isNotEmpty(members)) {
				for (V3xOrgMember member : members) {
					if (member.getOrgDepartmentId() == null) {
						continue;
					}
					resultList.add(member);
				}
			}
			List<V3xOrgMember> outList = new ArrayList<V3xOrgMember>();
			if (Strings.isNotEmpty(outMembers)) {
				for (V3xOrgMember member : outMembers) {
					if (member.getOrgAccountId().toString().equals(accountId)) {
						outList.add(member);
					}
				}
			}
			resultList.addAll(outList);
		}else{
			resultList = (List<V3xOrgMember>) OuterWorkerAuthUtil.getCanAccessMembers(AppContext.getCurrentUser().getId(), AppContext.getCurrentUser().getDepartmentId(), AppContext.currentAccountId(), orgManager);
		}

		List<String> keyList = new UniqueList<String>();
		Map<Long,List<V3xOrgDepartment>> deptsMap = new HashMap<Long,List<V3xOrgDepartment>>();
		Map<Long,Set<Long>> deptIdsMap = new HashMap<Long,Set<Long>>();
		//组装数据到map
		if(Strings.isNotBlank(searchContent)){
			searchContent = URLDecoder.decode(searchContent.toLowerCase(),"UTF-8")  ;
		}
		//start mwl 通讯录中领导的信息需要有权限才可以查看 
		String tongxunlu_minganjuese = (String) PropertiesUtils.getInstance().get("tongxunlu_minganjuese");
		for(V3xOrgMember vm : resultList){		
			 
			 Long memberId1 = vm.getId();
			 Long orgAccountId = vm.getOrgAccountId(); 
			 //敏感信息隐藏角色
			 boolean flag =orgManager.hasSpecificRole(memberId1, orgAccountId, tongxunlu_minganjuese);
			 vm.setIsLeader(flag);
			 //end mwl 通讯录中领导的信息需要有权限才可以查看 
			 
			WebWithPropV3xOrgMember m = new WebWithPropV3xOrgMember();
			m.setV3xOrgMember(vm);
			
			m.setMobilePhone(vm.getTelNumber());
			//start mwl 通讯录中领导的信息需要有权限才可以查看  联系人
 			User currentUser = AppContext.getCurrentUser();
			String tongxun_chakanminganjuese = (String) PropertiesUtils
					.getInstance().get("tongxun_chakanminganjuese");
			Boolean isLook = orgManager.hasSpecificRole(currentUser.getId(), currentUser
					.getAccountId(),tongxun_chakanminganjuese);
			log.info(vm.getIsLeader());
			if(vm.getIsLeader()){
				if(!isLook){
					m.setMobilePhone("***");
				}
			}
			//end mwl 通讯录中领导的信息需要有权限才可以查看 
			boolean canSearchNum = true;
            if (!checkPhone(AppContext.currentUserId(), vm.getId(), Long.valueOf(accountId), accountAddressBookSet)) {
            	m.setMobilePhone(AddressbookConstants.ADDRESSBOOK_INFO_REPLACE);
            	canSearchNum = false;
            }
			
			String name = vm.getName();
			String mobilePhone = (null == vm.getTelNumber())?"":vm.getTelNumber();
			if(Strings.isNotBlank(searchContent) && Strings.isNotBlank(name)){
				if(name.toLowerCase().indexOf(searchContent)<0 && (mobilePhone.toLowerCase().indexOf(searchContent)<0 || (mobilePhone.toLowerCase().indexOf(searchContent)>=0 &&!canSearchNum))){
					continue;
				}
			}
			
			if(Strings.isNotBlank(name)){
				char c = StringUtil.getPinYinHeadChar(name).toUpperCase().charAt(0);
				int x=(int)c;
				if(Strings.isNotBlank(key) && !(String.valueOf(c)).equalsIgnoreCase(key)){
					continue;
				}
				
				if (!checkLevelScope(currentMember, vm, Long.valueOf(accountId), accountAddressBookSet,deptsMap,deptIdsMap) && user.isInternal()) {
					continue;
				}
				
				//在A-Z之间,字母
				if (x>=65 && x<=90){
					List<WebWithPropV3xOrgMember> list = map.get(String.valueOf(c));
					if(null==list){
						keyList.add((String.valueOf(c)).toUpperCase());
						list =new UniqueList<WebWithPropV3xOrgMember>();
						list.add(m);
						map.put(String.valueOf(c), list);
					}else{
						if (!list.contains(m)){
							list .add(m);
						}
					}
				}else{
					keyList.add("|other");
					//其他字符
					List<WebWithPropV3xOrgMember> list = map.get("|other");
					if(null==list){
						list =new UniqueList<WebWithPropV3xOrgMember>();
						list.add(m);
						map.put("|other", list);
					}else{
						if (!list.contains(m)){
							list .add(m);
						}
					}
				}
				
			}
		}

		for (String headChar : map.keySet()) {
			List<WebWithPropV3xOrgMember> mList = map.get(headChar);
			sortMemberListResult(mList);
		}
		
		Collections.sort(keyList, new Comparator<String>() {
			public int compare(String key1, String key2) {
                  return key1.compareToIgnoreCase(key2);
			}
		});
		
		//map内list排序.排序规则 小写字母--大写字母--汉字
    	StringBuilder json = new StringBuilder();
    	json.append("[");
    	int i = 0;
		for(String k : keyList){
			List<WebWithPropV3xOrgMember> list = map.get(k);
			for(WebWithPropV3xOrgMember m : list){
				if(i++ > 0){
					json.append(",");
				}
				
				String mobilePhone = m.getMobilePhone();
				if((Strings.isBlank(mobilePhone) )|| (Strings.isNotBlank(mobilePhone) && "null".equals(mobilePhone))){
					mobilePhone = "";
				}
				
				json.append("{");
				json.append("\"I\":\""+m.getV3xOrgMember().getId()+"\",");
				json.append("\"N\":\""+Strings.escapeJavascript(m.getV3xOrgMember().getName())+"\",");
				
				json.append("\"M\":\""+Strings.escapeJavascript(mobilePhone)+"\",");
				json.append("\"K\":\""+k+"\"");
				json.append("}");
			}
			
		}
		json.append("]");
    	return json.toString();
    }
    
    //联系人信息排序
    private void sortMemberListResult(List<WebWithPropV3xOrgMember> mList)  throws Exception{
//    	System.setProperty("java.util.Arrays.useLegacyMergeSort", "true");  
		Collections.sort(mList, new Comparator<WebWithPropV3xOrgMember>() {
			public int compare(WebWithPropV3xOrgMember o1, WebWithPropV3xOrgMember o2) {
				if(null==o1 || null==o2) return 0;
				String name1=o1.getMemberName();
				String name2=o2.getMemberName();
				if(Strings.isBlank(name1) || Strings.isBlank(name2)) return 0;
                  return name1.compareToIgnoreCase(name2);
			}
		});
    }

}