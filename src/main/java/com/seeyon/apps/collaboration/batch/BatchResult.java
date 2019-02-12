/**
 *
 */
package com.seeyon.apps.collaboration.batch;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.util.ObjectToXMLBase;

/**
 * @author dongyj
 * 批量处理结果信息
 */
public class BatchResult extends ObjectToXMLBase{

    private Long affairId;

    private Long summaryId;

    private String processId;

    private String subject;

    private int resultCode;

    private String[] message;

    private String conditionsOfNodes;

    public BatchResult(Long affairId,Long summaryId,int resultCode){
        this.affairId = affairId;
        this.summaryId = summaryId;
        this.resultCode = resultCode;
    }
    public BatchResult(Long affairId,Long summaryId){
        this.affairId = affairId;
        this.summaryId = summaryId;
    }
    public BatchResult(){

    }
    public Long getAffairId() {
        return affairId;
    }

    public void setAffairId(Long affairId) {
        this.affairId = affairId;
    }

    public int getResultCode() {
        return resultCode;
    }

    public void setResultCode(int resultCode) {
        this.resultCode = resultCode;
    }

    public Long getSummaryId() {
        return summaryId;
    }

    public void setSummaryId(Long summaryId) {
        this.summaryId = summaryId;
    }

    public String[] getMessage(){
        return this.message;
    }

    public String getConditionsOfNodes() {
        return conditionsOfNodes;
    }
    public void setConditionsOfNodes(String conditionsOfNodes) {
        this.conditionsOfNodes = conditionsOfNodes;
    }
    public void addMessage(String...str){
        if(str == null || str.length ==0)return;
        List<String> list = null;
        if(this.message == null){
            this.message = new String[0];
        }
        list = new ArrayList<String>();
        for(String m: this.message){
            if(m != null){
                list.add(Functions.toHTML(m));
            }
        }
        for(String m: str){
            if(m != null){
                list.add(Functions.toHTML(m));
            }
        }
        this.message = list.toArray(new String[0]);
    }

    public void addMessage(List<String> pas){
        if(pas != null){
            addMessage(pas.toArray(new String[0]));
        }
    }
    public String getSubject() {
        return subject;
    }
    public void setSubject(String subject) {
        this.subject = subject;
    }
    public String getProcessId() {
        return processId;
    }
    public void setProcessId(String processId) {
        this.processId = processId;
    }

    @Override
    public String toString() {
        return "BatchResult{" +
                "affairId=" + affairId +
                ", summaryId=" + summaryId +
                ", processId='" + processId + '\'' +
                ", subject='" + subject + '\'' +
                ", resultCode=" + resultCode +
                ", message=" + Arrays.toString(message) +
                ", conditionsOfNodes='" + conditionsOfNodes + '\'' +
                '}';
    }
}
