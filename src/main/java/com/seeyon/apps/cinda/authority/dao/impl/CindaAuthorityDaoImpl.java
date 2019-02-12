package com.seeyon.apps.cinda.authority.dao.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.support.CTPHibernateDaoSupport;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.cinda.authority.dao.CindaAuthorityDao;
import com.seeyon.apps.cinda.authority.domain.UmAuthority;
import com.seeyon.apps.cinda.authority.domain.UmGroupRoleAuthority;
import com.seeyon.apps.cinda.authority.domain.UmOrganization;
import com.seeyon.apps.cinda.authority.domain.UmUser;
import com.seeyon.apps.cinda.authority.domain.UmUserGroupRole;
import com.seeyon.apps.cinda.authority.util.CZDBAgent;
import com.seeyon.ctp.util.Strings;

public class CindaAuthorityDaoImpl extends CTPHibernateDaoSupport implements CindaAuthorityDao {
	private static final Log log = LogFactory.getLog(CindaAuthorityDaoImpl.class);
	public void init(){
		CZDBAgent.init(this);
	}
	@Override
	public  List<UmAuthority> getUmAuthoritysByRootCode(String rootCode) {
		StringBuffer hql =new StringBuffer();
		hql.append("select ua from "+UmAuthority.class.getSimpleName()+" ua where ua.authoritycode like :startcode");
		hql.append(" order by ua.sequence,ua.authoritycode");//length(ua.authoritycode),
		Map<String ,Object> params = new HashMap<String, Object>();
		params.put("startcode", rootCode+"%");
		List<UmAuthority> list = CZDBAgent.find(hql.toString(), params);
		if(list!=null){
			return list;
		}
		return new ArrayList();
	}
	@Override
	public   UmUser getUmUserByLoginName(String loginName) {
		StringBuffer hql =new StringBuffer();
		hql.append("from "+UmUser.class.getSimpleName()+" uu where uu.loginname =:loginName");
		Map<String ,Object> params = new HashMap<String, Object>();
		params.put("loginName", loginName);
		List<UmUser> list = CZDBAgent.find(hql.toString(), params);
		if(list!=null && list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@Override
	  public LinkedHashMap<String,UmAuthority> getAuthListByRootcodeAndLoginName(String authorityCode, String loginName)
			    throws Exception
			  {
	    LinkedHashMap authHt = new LinkedHashMap();
	    Connection conn = null;
	    Statement stmt = null;
	    ResultSet rs = null;
	    try
	    {
	      conn = this.currentConnection();
	      stmt = conn.createStatement();
	      String sql = "select AUTHORITYID from cinda_user.UM_AUTHORITY where AUTHORITYCODE like '" + authorityCode + "%'";
	      rs = stmt.executeQuery(sql);
	      String Ids = "";
	      while (rs.next()) {
	        if ("".equals(Ids)) {
	          Ids = "'" + rs.getString("AUTHORITYID") + "'";
	        } else {
	          Ids = Ids + ",'" + rs.getString("AUTHORITYID") + "'";
	        }
	      }
	      if (!"".equals(Ids))
	      {
	        sql = "select ENTITYCODE,ENTITYKIND from cinda_user.UM_GROUP_ROLE_AUTHORITY where AUTHORITYID in (" + Ids + ")";
	        rs = stmt.executeQuery(sql);
	        Set<String> orgids = new HashSet<String>();
	        while (rs.next())
	        {
	          int kind = rs.getInt("ENTITYKIND");
	          if (2 == kind) {
	        	  orgids.add(rs.getString("ENTITYCODE"));
	          }
	        }
	        sql = "select orgId,userId from cinda_user.UM_USER where loginName='" + loginName + "'";
	        rs = stmt.executeQuery(sql);
	        String orgId = "";
	        String orgCode = "";
	        String userId = "";
	        while (rs.next())
	        {
	          orgId = rs.getString("orgId");
	          userId = rs.getString("userId");
	        }
	        Hashtable ht = new Hashtable();
	        String haveAuthOrgId = "";
	        if (orgids.size()>0)
	        {
	        	String[] indis = orgids.toArray(new String[orgids.size()]);
	        	StringBuffer in = new StringBuffer();
	        	for (int i = 0; i < indis.length; i++) {
					in.append("'"+indis[i]+"',");
				}
	        	sql = "select id,code from  cinda_user.um_organization  where id='" + orgId + "' or id in (" + in.toString().substring(0, in.toString().length()-1) + ")";
	          rs = stmt.executeQuery(sql);
	          while (rs.next()) {
	            if (orgId.equals(rs.getString("id"))) {
	              orgCode = rs.getString("code");
	            } else {
	              ht.put(rs.getString("code"), rs.getString("id"));
	            }
	          }
	          for (Iterator it = ht.keySet().iterator(); it.hasNext();)
	          {
	            String code = (String)it.next();
	            if ((orgCode.length() >= code.length()) && 
	              (orgCode.substring(0, code.length()).equals(code))) {
	              if ("".equals(haveAuthOrgId)) {
	                haveAuthOrgId = "'" + (String)ht.get(code) + "'";
	              } else {
	                haveAuthOrgId = haveAuthOrgId + ",'" + (String)ht.get(code) + "'";
	              }
	            }
	          }
	        }
	        if ("".equals(haveAuthOrgId)) {
	          sql = "select * from cinda_user.UM_AUTHORITY where AUTHORITYID in (select AUTHORITYID from cinda_user.UM_GROUP_ROLE_AUTHORITY where AUTHORITYID in (" + Ids + ") and ENTITYCODE in (select ENTITYCODE from cinda_user.UM_USER_GROUP_ROLE where userid='" + userId + "' and ENTITYKIND=" + 0 + "))";
	        } else {
	          sql = "select * from cinda_user.UM_AUTHORITY where AUTHORITYID in (select AUTHORITYID from cinda_user.UM_GROUP_ROLE_AUTHORITY where AUTHORITYID  in (" + Ids + ") and (ENTITYCODE in (select ENTITYCODE from cinda_user.UM_USER_GROUP_ROLE where userid='" + userId + "' and ENTITYKIND=" + 0 + ") or ENTITYCODE in (" + haveAuthOrgId + ")))";
	        }
	        sql = sql + " order by length(AUTHORITYCODE),sequence,AUTHORITYCODE";
	        rs = stmt.executeQuery(sql);

			        while (rs.next())
			        {
			        UmAuthority vo = new UmAuthority();
			          vo.setAuthorityid(rs.getString("AUTHORITYID"));
			          vo.setAuthorityname(rs.getString("AUTHORITYNAME"));
			          if (rs.getString("AUTHORITYTYPE") != null) {
			            vo.setAuthoritytype(new Integer(rs.getInt("AUTHORITYTYPE")));
			          }
			          vo.setUrl(rs.getString("url"));
			          vo.setAuthorityattribute(rs.getString("AUTHORITYATTRIBUTE"));
			          vo.setAuthoritycode(rs.getString("AUTHORITYCODE"));
			          if (rs.getString("APPSYSTEM") != null) {
			            vo.setAppsystem(new Integer(rs.getInt("APPSYSTEM")));
			          }
			          vo.setSequence(rs.getString("SEQUENCE"));
			          vo.setSimplename(rs.getString("SIMPLENAME"));
			          vo.setUrltype(rs.getString("urlType"));
			          authHt.put(rs.getString("AUTHORITYCODE"), vo);
			        }
			      }
			    }
			    catch (SQLException e)
			    {
			      log.error(e);
			      throw new Exception(e);
			    }
			    finally
			    {
			      try
			      {
			        rs.close();
			        stmt.close();
			        conn.close();
			      }
			      catch (SQLException ex)
			      {
			        log.error(ex);
			        throw new Exception(ex);
			      }
			    }
			    return authHt;
			  }
	@Override
	public  List<String>  listUmGroupRoleAuthority(String loginName ) {
		UmUser user = this.getUmUserByLoginName(loginName);
		UmOrganization org = this.getUmOrganizationById(user.getOrgid());
		List<UmOrganization> listorg = this.getUmOrganizationPartentList(org);
		listorg.add(org);
		List<String>  ids = new ArrayList<String>();
		for (UmOrganization orgi : listorg) {
			ids.add(orgi.getId());
		}
		StringBuffer hql =new StringBuffer();
		hql.append("select ug.authorityid from "
		+UmGroupRoleAuthority.class.getSimpleName()+" ug,"
		+UmUserGroupRole.class.getSimpleName()+" ur ");
		hql.append(" where 1=1 ");
//		hql.append(" and (ur.enddate is null or ur.enddate > :dateNow) ");
		hql.append(" and (" );
		hql.append(" 	(ug.entitykind=0 and ug.entitycode =ur.entitycode) ");
		hql.append(" or (ug.entitykind=2 and ug.entitycode in( :ids)) ");
		hql.append(" or (ug.entitykind=0 and ug.entitycode = ur.userid)");
		hql.append(" ) ");
		hql.append(" and ur.userid =:userId ");
		hql.append(" group by ug.authorityid ");
		Map<String ,Object> params = new HashMap<String, Object>();
		params.put("userId", user.getUserid());
		params.put("ids", ids);
		List list = CZDBAgent.find(hql.toString(), params);
		if(list!=null){
			return list;
		}
		return new ArrayList();
	}


	@Override
	public UmOrganization getUmOrganizationByCode(String code) {
		String hql = " from cinda_user."+UmOrganization.class.getSimpleName() +" org where org.code = :code ";
		Map<String ,Object> params = new HashMap<String, Object>();
		params.put("code", code);
		List<UmOrganization> list = CZDBAgent.find(hql.toString(), params);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}
		return null;
	}
	@Override
	public UmOrganization getUmOrganizationById(String id) {

		return CZDBAgent.get(UmOrganization.class, id);
	}
	@Override
	public List<UmOrganization> getUmOrganizationPartentList(UmOrganization org) {
		if(org!=null && Strings.isNotBlank(org.getCode())){
			String hql = " from cinda_user."+UmOrganization.class.getSimpleName() +" org where org.code in (:codes ) order by org.code";
			Map<String ,Object> params = new HashMap<String, Object>();
			List<String> codes = new ArrayList<String>();
			String code = org.getCode().trim();
			while(Strings.isNotBlank(code) && code.length()>2){
				code = code.substring(0, code.length()-2);
				codes.add(code);
			}
			params.put("codes", codes);
			return  CZDBAgent.find(hql.toString(), params);
		}
		return null;
	}
	public static void main(String[] args) {
		String code = "0102030407";
		List<String> codes = new ArrayList<String>();
		while(Strings.isNotBlank(code) && code.length()>2){
			code = code.substring(0, code.length()-2);
			codes.add(code);
		}
		System.out.println(JSONObject.toJSONString(codes));
	}
}
