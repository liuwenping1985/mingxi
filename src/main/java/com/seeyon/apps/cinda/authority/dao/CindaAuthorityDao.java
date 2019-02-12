package com.seeyon.apps.cinda.authority.dao;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.cinda.authority.domain.UmAuthority;
import com.seeyon.apps.cinda.authority.domain.UmOrganization;
import com.seeyon.apps.cinda.authority.domain.UmRole;
import com.seeyon.apps.cinda.authority.domain.UmUser;

public interface CindaAuthorityDao {
	public void init();

	/**
	 * 获得所有某类资源链接
	 * @param loginName
	 * @param startcode 01，02，03，04，05，06，07（左侧树），08（右侧树）……
	 * @return
	 */
	public List<UmAuthority> getUmAuthoritysByRootCode(String rootCode);
	/**
	 * @param loginName
	 * @return
	 */
	public UmUser getUmUserByLoginName(String loginName);
	
	public UmOrganization getUmOrganizationByCode(String code);
	
	public UmOrganization getUmOrganizationById(String id);
	
	public List<UmOrganization> getUmOrganizationPartentList(UmOrganization org);
	
	public List<String> listUmGroupRoleAuthority(String loginName);

	public LinkedHashMap<String, UmAuthority> getAuthListByRootcodeAndLoginName(
			String authorityCode, String loginName) throws Exception;


	



	
}
