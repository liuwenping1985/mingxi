package cn.com.cinda.taskclient.service;

import java.util.List;

/**
 * 新版任务中心webservice接口
 * 
 */
public interface TaskPubService {

	/**
	 * 根据用户ID和系统类型查询待办任务列表
	 * */
	public String[][] queryTaskListByFlag(String userId, String appType, String flag, int page,
			int rowPage);
	
	/**
	 * 根据用户ID和系统类型查询待办任务列表
	 * */
	public String[][] queryTaskList(String userId, String appType, int page,
			int rowPage);
	
	/**
	 * 根据用户ID查询公文阅文待办任务列表
	 * @param userId
	 * @param pageNo
	 * @param rowPage
	 * @return
	 */
	public String[][] queryYueWenTaskLis(String userId, int pageNo,int rowPage);
	
	/**
	 * 根据用户ID和系统类型查询待办任务数量
	 * */
	public String queryTaskCount(String userId, String appType);

	/**
	 * 获得指定状态的任务数量
	 * 
	 * @param userId
	 *            用户id
	 * @param appType
	 *            应用类型
	 * @param status
	 *            任务状态
	 * @return
	 */
	public String queryTaskCountByStatus(String userId, String appType,
			String status);

	/**
	 * 获得指定状态的任务
	 * 
	 * @param userId
	 *            用户id
	 * @param appType
	 *            应用类型
	 * @param status
	 *            任务状态
	 * @param page
	 *            第几页
	 * @param rowPage
	 *            没有显示记录数
	 * @return
	 */
	public String[][] queryTaskListByStatus(String userId, String appType,
			String status, int page, int rowPage);

	/**
	 * 根据应用类型查询用户任务数量（待办或者已办）
	 * 
	 * @param appType
	 *            应用类型
	 * @param userId
	 *            用户id
	* @param flag
	 *            任务类型标识
	 * @param status
	 *            任务状态（1：待办；3：已办）
	 * @return 数组{{应用1，数量1}，{应用2，数量2}，。。。}
	 */
	public String[][] queryTaskCountByFlag(String[] appType, String userId, String flag, 
			String status);
	
	/**
	 * 根据应用类型查询用户任务数量（待办或者已办）
	 * 
	 * @param appType
	 *            应用类型
	 * @param userId
	 *            用户id
	 * @param status
	 *            任务状态（1：待办；3：已办）
	 * @return 数组{{应用1，数量1}，{应用2，数量2}，。。。}
	 */
	public String[][] queryTaskCountByApp(String[] appType, String userId, 
			String status);
	
	/**
	 * 查询公文阅文的用户任务数量（待办或者已办）
	 * 
	 * @param userId
	 *            用户id
	 * @param status
	 *            任务状态（1：待办；3：已办）
	 * @return 数组{{应用1，数量1}，{应用2，数量2}，。。。}
	 */
	public String[] queryYueWenTaskCount(String userId, String status);

	/**
	 * 根据用户id和状态获得列表(已办)
	 * 
	 * @param userid
	 *            用户ID
	 * @param state
	 *            状态
	 * @param pageNO
	 *            当前页
	 * @param pageSize
	 *            每页显示记录数
	 * @return
	 */
	public String[][] queryTaskDoneListByStatus(String userId, String appSysCode,
			String state, int pageNo, int pageSize);
}
