<<<<<<< HEAD
package com.seeyon.apps.duban.stat;

import java.util.ArrayList;
import java.util.List;

public class StatBarBo {
    private String deptName;
    private double workload=0.0;//工作量
    private int taskNum=0;//任务数
    private double completionRate =0.0;//完成率
    private int completionNum=0;//完成数
    private int completionScore=0;//完成分
    private int level_A=0;
    private int level_B=0;
    private int level_C=0;
    private int level_D=0;
    private int level_E=0;
    private int level_X=0;

    private List<SplitDubanTask> splitDubanTasks = new ArrayList();

    public double getCompletionRate() {
        return completionRate;
    }

    public void add(SplitDubanTask splitDubanTask)
    {
        this.deptName = splitDubanTask.getDeptName();
        this.workload = this.workload+splitDubanTask.getKgScore();
        taskNum++;
        if (splitDubanTask.getIsFinish()==1) {
            completionNum++;
        }
        completionRate = completionNum/taskNum*100;
        completionScore = completionScore+splitDubanTask.getFinishScore();

        if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELA)) {
            level_A++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELB)) {
            level_B++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELC)) {
            level_C++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELD)) {
            level_D++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELE)) {
            level_E++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELF)) {
            level_F++;
        }
//            case "A":
//                level_A++;
//                break;
//            case "B":
//                level_B++;
//                break;
//            case "C":
//                level_C++;
//                break;
//            case "D":
//                level_D++;
//                break;
//            case "E":
//                level_E++;
//                break;
//            case "F":
//                level_F++;
//                break;
//            default:
//                level_X++;
//                break;
//        }
        splitDubanTasks.add(splitDubanTask);
    }

    public String getDeptName() {
        return deptName;
    }

    public double getWorkload() {
        return workload;
    }

    public int getTaskNum() {
        return taskNum;
    }

    public int getCompletionNum() {
        return completionNum;
    }

    public int getCompletionScore() {
        return completionScore;
    }

    public int getLevel_A() {
        return level_A;
    }

    public int getLevel_B() {
        return level_B;
    }

    public int getLevel_C() {
        return level_C;
    }

    public int getLevel_D() {
        return level_D;
    }

    public int getLevel_E() {
        return level_E;
    }

    public int getLevel_F() {
        return level_F;
    }



    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }



    public void setWorkload(int workload) {
        this.workload = workload;
    }

    public void setTaskNum(int taskNum) {
        this.taskNum = taskNum;
    }

    public void setCompletionRate(int completionRate) {
        this.completionRate = completionRate;
    }

    public void setCompletionScore(int completionScore) {
        this.completionScore = completionScore;
    }

    public void setLevel_A(int level_A) {
        this.level_A = level_A;
    }

    public void setLevel_B(int level_B) {
        this.level_B = level_B;
    }

    public void setLevel_C(int level_C) {
        this.level_C = level_C;
    }

    public void setLevel_D(int level_D) {
        this.level_D = level_D;
    }

    public void setLevel_E(int level_E) {
        this.level_E = level_E;
    }

    public void setLevel_F(int level_F) {
        this.level_F = level_F;
    }

    private int level_F;
}
=======
package com.seeyon.apps.duban.stat;

import java.util.ArrayList;
import java.util.List;

public class StatBarBo {
    private String deptName;
    private double workload=0.0;//工作量
    private int taskNum=0;//任务数
    private double completionRate =0.0;//完成率
    private int completionNum=0;//完成数
    private int completionScore=0;//完成分
    private int level_A=0;
    private int level_B=0;
    private int level_C=0;
    private int level_D=0;
    private int level_E=0;
    private int level_X=0;

    private List<SplitDubanTask> splitDubanTasks = new ArrayList();

    public double getCompletionRate() {
        return completionRate;
    }

    public void add(SplitDubanTask splitDubanTask)
    {
        this.deptName = splitDubanTask.getDeptName();
        this.workload = this.workload+splitDubanTask.getKgScore();
        taskNum++;
        if (splitDubanTask.getIsFinish()==1) {
            completionNum++;
        }
        completionRate = completionNum/taskNum*100;
        completionScore = completionScore+splitDubanTask.getFinishScore();

        if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELA)) {
            level_A++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELB)) {
            level_B++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELC)) {
            level_C++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELD)) {
            level_D++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELE)) {
            level_E++;
        }
        else if (splitDubanTask.getTaskLevel().equalsIgnoreCase(Constance.LEVELF)) {
            level_F++;
        }
//            case "A":
//                level_A++;
//                break;
//            case "B":
//                level_B++;
//                break;
//            case "C":
//                level_C++;
//                break;
//            case "D":
//                level_D++;
//                break;
//            case "E":
//                level_E++;
//                break;
//            case "F":
//                level_F++;
//                break;
//            default:
//                level_X++;
//                break;
//        }
        splitDubanTasks.add(splitDubanTask);
    }

    public String getDeptName() {
        return deptName;
    }

    public double getWorkload() {
        return workload;
    }

    public int getTaskNum() {
        return taskNum;
    }

    public int getCompletionNum() {
        return completionNum;
    }

    public int getCompletionScore() {
        return completionScore;
    }

    public int getLevel_A() {
        return level_A;
    }

    public int getLevel_B() {
        return level_B;
    }

    public int getLevel_C() {
        return level_C;
    }

    public int getLevel_D() {
        return level_D;
    }

    public int getLevel_E() {
        return level_E;
    }

    public int getLevel_F() {
        return level_F;
    }



    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }



    public void setWorkload(int workload) {
        this.workload = workload;
    }

    public void setTaskNum(int taskNum) {
        this.taskNum = taskNum;
    }

    public void setCompletionRate(int completionRate) {
        this.completionRate = completionRate;
    }

    public void setCompletionScore(int completionScore) {
        this.completionScore = completionScore;
    }

    public void setLevel_A(int level_A) {
        this.level_A = level_A;
    }

    public void setLevel_B(int level_B) {
        this.level_B = level_B;
    }

    public void setLevel_C(int level_C) {
        this.level_C = level_C;
    }

    public void setLevel_D(int level_D) {
        this.level_D = level_D;
    }

    public void setLevel_E(int level_E) {
        this.level_E = level_E;
    }

    public void setLevel_F(int level_F) {
        this.level_F = level_F;
    }

    private int level_F;
}
>>>>>>> 63ad5d083d5a37ffc7d3ef8c9ec5cd4624c76cc4
