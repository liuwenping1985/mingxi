package cn.com.cinda.taskclient.service;

/**
 * 新版用户管理webservice接口
 * 
 */
public interface OrgPubService {

	/**
	 * 获得指定机构的上级机构
	 * 
	 * @param depId  机构ID
	 *        account 用户帐号
	 * @return {机构ID，机构名称，机构简称，联系电话、传真号码、机构地址，机构邮编，机构机箱}
	 * @throws Exception
	 */
	public String[] getParentDepartment(String depId,String account) throws Exception;

}
