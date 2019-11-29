package com.seeyon.apps.duban.po;

import com.seeyon.ctp.common.po.BasePO;

import java.util.Date;
import java.util.List;

/**
 * 督办任务主类
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTask extends BasePO {

    /**
     * 底表中的id
     */
    private String uuid;
    /**
     * 任务id
     */
    private String taskId;
    /**
     * 标题
     */
    private String name;
    /**
     * 上级任务id
     */
    private String pid;
    /**
     * 任务来源
     */
    private String taskSource;
    /**
     * 任务级别
     */
    private String taskLevel;
    /**
     * 任务状态
     */
    private String taskStatus;
    /**
     * 开始时间
     */
    private Date startDate;
    /**
     * 办理时限
     */
    private Date endDate;

    /**
     * 办结时间
     */
    private Date finishDate;

    /**
     * 领导意见
     */
    private String leaderOpinion;

    private String createUserId;
    /**
     * 督办周期
     */
    private String period;

    /**
     * 办理要求
     */
    private String requirement;
    /**
     * 进度
     */
    private String process;

    /**
     * 责任领导
     */
    private String mainLeader;
    /**
     * 可查看领导
     */
    private String viewLeaderName;
    /**
     * 督办员
     */
    private String supervisor;


    /**
     * 承办（主办）部门名称
     */
    private String mainDeptName;

    /**
     * 承办部门权重
     */
    private String mainWeight;
    /**
     * 承办部任务状态
     */
    private String mainTaskStatus;

    /**
     * 承办部门进度
     */
    private String mainProcess;

    /**
     * 承办部门完成时间
     */
    private Date mainTaskFinishDate;
    /**
     * 任务描述
     */
    private String taskDescription;
    /**
     * 附件列表
     */
    private String attListString;
    /**
     * 配合部门任务
     */
    private List<SlaveDubanTask> slaveDubanTaskList;

    public String getViewLeaderName() {
        return viewLeaderName;
    }

    public void setViewLeaderName(String viewLeaderName) {
        this.viewLeaderName = viewLeaderName;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getProcess() {
        return process;
    }

    public void setProcess(String process) {
        this.process = process;
    }

    public String getMainLeader() {
        return mainLeader;
    }

    public void setMainLeader(String mainLeader) {
        this.mainLeader = mainLeader;
    }

    public String getSupervisor() {
        return supervisor;
    }

    public void setSupervisor(String supervisor) {
        this.supervisor = supervisor;
    }


    public String getAttListString() {
        return attListString;
    }

    public void setAttListString(String attListString) {
        this.attListString = attListString;
    }

    public String getTaskDescription() {
        return taskDescription;
    }

    public void setTaskDescription(String taskDescription) {
        this.taskDescription = taskDescription;
    }

    public String getCreateUserId() {
        return createUserId;
    }

    public void setCreateUserId(String createUserId) {
        this.createUserId = createUserId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public List<SlaveDubanTask> getSlaveDubanTaskList() {
        return slaveDubanTaskList;
    }

    public void setSlaveDubanTaskList(List<SlaveDubanTask> slaveDubanTaskList) {
        this.slaveDubanTaskList = slaveDubanTaskList;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }

    public String getTaskStatus() {
        return taskStatus;
    }

    public void setTaskStatus(String taskStatus) {
        this.taskStatus = taskStatus;
    }

    public String getTaskSource() {
        return taskSource;
    }

    public void setTaskSource(String taskSource) {
        this.taskSource = taskSource;
    }

    public String getTaskLevel() {
        return taskLevel;
    }

    public void setTaskLevel(String taskLevel) {
        this.taskLevel = taskLevel;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {

        this.pid = pid;
    }

    public String getRequirement() {
        return requirement;
    }

    public void setRequirement(String requirement) {
        this.requirement = requirement;
    }

    public Date getFinishDate() {
        return finishDate;
    }

    public void setFinishDate(Date finishDate) {
        this.finishDate = finishDate;
    }

    public String getLeaderOpinion() {
        return leaderOpinion;
    }

    public void setLeaderOpinion(String leaderOpinion) {
        this.leaderOpinion = leaderOpinion;
    }

    public String getMainDeptName() {
        return mainDeptName;
    }

    public void setMainDeptName(String mainDeptName) {
        this.mainDeptName = mainDeptName;
    }

    public String getMainWeight() {
        return mainWeight;
    }

    public void setMainWeight(String mainWeight) {
        this.mainWeight = mainWeight;
    }

    public String getMainTaskStatus() {
        return mainTaskStatus;
    }

    public void setMainTaskStatus(String mainTaskStatus) {
        this.mainTaskStatus = mainTaskStatus;
    }

    public String getMainProcess() {
        return mainProcess;
    }

    public void setMainProcess(String mainProcess) {
        this.mainProcess = mainProcess;
    }

    public Date getMainTaskFinishDate() {
        return mainTaskFinishDate;
    }

    public void setMainTaskFinishDate(Date mainTaskFinishDate) {
        this.mainTaskFinishDate = mainTaskFinishDate;
    }
}
