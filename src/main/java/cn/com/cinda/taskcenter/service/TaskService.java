package cn.com.cinda.taskcenter.service;

/**
 * 任务中心webservice接口
 * 
 * @author 周渊
 * 
 */
public interface TaskService {

	/**
	 * 创建任务
	 * 
	 * @param taskId,任务Id
	 * @param taskAppCode,应用系统编码
	 * @param taskTypeCode,任务类型编码
	 * @param taskSubject,任务主题
	 * @param flowId,流程Id
	 * @param stageId,环节Id
	 * @param stageName,环节名称
	 * @param creatorId,创建人Id
	 * @param creatorName,创建人姓名
	 * @param createOrgId,创建人机构Id
	 * @param creatorOrgName,创建人机构名称
	 * @param assignId,分配人Id
	 * @param assignName,分配人姓名
	 * @param assignOrgId,分配人机构Id
	 * @param assignOrgName,分配人机构名称
	 * @param comments,意见
	 * @param attachData,任务附加数据
	 * @param otherTypeCodes,任务其它联接编码
	 * @param otherTypeNames,任务其它联接的显示名称
	 * @return
	 */
	public boolean createTask(String taskId, String taskAppCode,
			String taskTypeCode, String taskSubject, String flowId,
			String stageId, String stageName, String creatorId,
			String creatorName, String createOrgId, String creatorOrgName,
			String assignId, String assignName, String assignOrgId,
			String assignOrgName, String comments, String attachData,
			String otherTypeCodes, String otherTypeNames);

	/**
	 * 执行任务
	 * 
	 * @param taskId
	 * @param taskStatus
	 * @param comments,意见
	 * @param attachData,任务附加数据
	 * @param otherTypeCodes,任务其它联接编码
	 * @param otherTypeNames,任务其它联接的显示名称
	 * @return
	 */
	public boolean executeTask(String taskId, int taskStatus, String comments,
			String attachData, String otherTypeCodes, String otherTypeNames);

	/**
	 * 查询任务
	 * 
	 * @param taskId,任务Id
	 * @return String[],0:任务Id,1:应用系统编码,2:任务类型编码,3:任务主题,4:流程Id,5:环节Id,6:环节名称,7:创建人Id,8:创建人姓名,9:创建人机构Id,10:创建人机构名称,11:分配人Id,12:分配人姓名,13:分配人机构Id,14:分配人机构名称,15:意见,16:任务附加数据,17:任务其它联接编码,18:任务其它联接的显示名称,19:任务状态,20:创建时间,21:申领时间,22:完成时间
	 */
	public String[] queryTask(String taskId);

	/**
	 * 删除任务
	 * 
	 * @param taskId,任务Id
	 * @return
	 */
	public boolean deleteTask(String taskId);

	/**
	 * 更新任务数据
	 * 
	 * @param taskId,任务Id
	 * @param attachData,任务附加数据
	 * @param otherTypeCodes,任务其它联接编码
	 * @param otherTypeNames,任务其它联接的显示名称
	 * @return
	 */
	public boolean updateTaskData(String taskId, String attachData,
			String otherTypeCodes, String otherTypeNames);
}
