package cn.com.cinda.taskclient.service;

/**
 * 新版用户管理webservice接口
 * 
 */
public interface UserPubService {

	/**
	 * 获得用户可以登录的机构
	 * 
	 * @param account
	 *            account 用户帐号
	 * @return {{用户ID，机构路径1，机构ID1，上次登录机构ID、用户密码、用户状态},{用户ID，机构路径2，机构ID2，...}}
	 * @throws Exception
	 */
	public String[][] getLoginOrgs(String account) throws Exception;

}
