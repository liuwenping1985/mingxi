package com.seeyon.apps.duban.stat;

import com.seeyon.apps.duban.po.DubanConfigItem;
import com.seeyon.apps.duban.service.DataSetService;
import com.seeyon.apps.duban.util.CommonUtils;

//分解单个的任务体
public class SplitDubanTask {
    private String taskId;
    private String deptName;
    private int isMainRole=0;
    private double kgScore=0.0;
    private int finishScore=0;
    private float weight;
    private String taskLevel="";
    private String taskSource="";
    private int isFinish;

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }

    public void calKgScore() {
        DataSetService dss = DataSetService.getInstance();

        String scoreMain = "100";
        DubanConfigItem sourceItem = dss.getDubanConfigItem(taskSource);
        if (sourceItem != null) {
            scoreMain = sourceItem.getItemValue();
        }
        String levelMain = "1";
        DubanConfigItem levelItem = dss.getDubanConfigItem(taskLevel);
        if (levelItem != null) {
            levelMain = levelItem.getItemValue();
        }
        String xishu ="1";
        if (isMainRole == 1) {
            xishu = dss.getDubanConfigItem("99999999").getItemValue();
        } else {
            xishu = dss.getDubanConfigItem("99999998").getItemValue();
        }
        kgScore= CommonUtils.getDouble(scoreMain) * (CommonUtils.getDouble(weight) / 100d) * CommonUtils.getDouble(levelMain) * CommonUtils.getDouble(xishu);
    }




    public String getDeptName() {
        return deptName;
    }

    public int getIsMainRole() {
        return isMainRole;
    }

    public double getKgScore() {
        return kgScore;
    }

    public int getFinishScore() {
        return finishScore;
    }

    public String getTaskLevel() {
        return taskLevel;
    }

    public String getTaskSource() {
        return taskSource;
    }

    public void setTaskLevel(String taskLevel) {
        this.taskLevel = taskLevel;
    }

    public float getWeight() {
        return weight;
    }

    public void setWeight(float weight) {
        this.weight = weight;
    }

    public void setTaskSource(String taskSource) {
        this.taskSource = taskSource;
    }

    public int getIsFinish() {
        return isFinish;
    }



    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public void setIsMainRole(int isMainRole) {
        this.isMainRole = isMainRole;
    }

    public void setKgScore(int kgScore) {
        this.kgScore = kgScore;
    }

    public void setFinishScore(int finishScore) {
        this.finishScore = finishScore;
    }



    public void setIsFinish(int isFinish) {
        this.isFinish = isFinish;
    }
}
