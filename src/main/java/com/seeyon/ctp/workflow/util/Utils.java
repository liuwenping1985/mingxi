//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.workflow.util;

import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.po.ProcessTemplete;
import com.seeyon.ctp.workflow.po.SubProcessSetting;
import com.seeyon.ctp.workflow.vo.TemplateIEMessageVO;
import com.seeyon.v3x.util.Strings;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.joinwork.bpm.definition.BPMAbstractNode;
import net.joinwork.bpm.definition.BPMActivity;
import net.joinwork.bpm.definition.BPMActor;
import net.joinwork.bpm.definition.BPMAndRouter;
import net.joinwork.bpm.definition.BPMEnd;
import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.definition.BPMParticipant;
import net.joinwork.bpm.definition.BPMProcess;
import net.joinwork.bpm.definition.BPMSeeyonPolicy;
import net.joinwork.bpm.definition.BPMStart;
import net.joinwork.bpm.definition.BPMTransition;
import net.joinwork.bpm.definition.ObjectName;
import net.joinwork.bpm.definition.BPMAbstractNode.NodeType;
import net.joinwork.bpm.engine.execute.BPMCase;
import net.joinwork.bpm.engine.log.BPMCaseLog;
import net.joinwork.bpm.engine.wapi.CaseDetailLog;
import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Attribute;
import org.dom4j.Element;

public class Utils {
    private static final String informActivityPolicy;
    private static final String edocInformActivityPolicy;
    public static final String xmlSpecialChar_angleBrackets = "><";
    public static final String regExp_angleBrackets = ">\\s+?<";
    public static final String xmlSpecialChar_Tab = "&#x09;";
    public static final String regExp_Tab = "\t";
    public static final String xmlSpecialChar_Enter = "&#x0D;";
    public static final String regExp_Enter = "\r";
    public static final String xmlSpecialChar_Newline = "&#x0A;";
    public static final String regExp_Newline = "\n";

    static {
        informActivityPolicy = BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getId();
        edocInformActivityPolicy = BPMSeeyonPolicy.EDOC_POLICY_ZHIHUI.getId();
    }

    public Utils() {
    }

    public static boolean isThisState(BPMCase theCase, String currentNodeId, int... states) {
        int state = getNodeState(theCase, currentNodeId);
        int[] var7 = states;
        int var6 = states.length;

        for(int var5 = 0; var5 < var6; ++var5) {
            int s = var7[var5];
            if (s == state) {
                return true;
            }
        }

        return false;
    }

    public static boolean isThisStateInform(BPMCase theCase, BPMAbstractNode from, int... states) {
        String currentNodeId = from.getId();
        int state = getNodeState(theCase, currentNodeId);
        if (state == 0 || from.getNodeType().equals(NodeType.join)) {
            Map<String, BPMAbstractNode> findedMaps = new HashMap();
            List<Integer> preStates = new ArrayList();
            List<Integer> preInformStates = new ArrayList();
            findPreviousNodeState(theCase, from, findedMaps, preStates, preInformStates);
            if (preInformStates.size() > 0 && preStates.size() == 0) {
                state = 2;
            } else if (preStates.size() > 0) {
                state = 0;
            }
        }

        int[] var8 = states;
        int var11 = states.length;

        for(int var10 = 0; var10 < var11; ++var10) {
            int s = var8[var10];
            if (s == state) {
                return true;
            }
        }

        return false;
    }

    private static void findPreviousNodeState(BPMCase theCase, BPMAbstractNode from, Map<String, BPMAbstractNode> findedMaps, List<Integer> preStates, List<Integer> preInformStates) {
        if (findedMaps.get(from.getId()) == null) {
            findedMaps.put(from.getId(), from);
            List<BPMTransition> ups = from.getUpTransitions();
            Iterator var7 = ups.iterator();

            while(var7.hasNext()) {
                BPMTransition bpmTransition = (BPMTransition)var7.next();
                BPMAbstractNode from1 = bpmTransition.getFrom();
                String policy1 = from1.getSeeyonPolicy().getId();
                String isDelete = getNodeConditionFromCase(theCase, from1, "isDelete");
                if (!"true".equalsIgnoreCase(isDelete)) {
                    if (from1.getNodeType().equals(NodeType.start)) {
                        preStates.add(0);
                        break;
                    }

                    if (from1.getNodeType().equals(NodeType.join)) {
                        findPreviousNodeState(theCase, from1, findedMaps, preStates, preInformStates);
                    } else if (from1.getNodeType().equals(NodeType.split)) {
                        findPreviousNodeState(theCase, from1, findedMaps, preStates, preInformStates);
                    } else if (from1.getNodeType().equals(NodeType.humen)) {
                        int state1;
                        if (!BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getId().equalsIgnoreCase(policy1) && !BPMSeeyonPolicy.EDOC_POLICY_ZHIHUI.getId().equalsIgnoreCase(policy1)) {
                            state1 = getNodeState(theCase, from1.getId());
                            if (state1 == 0 || state1 == 2 || state1 == 7 || state1 == 8) {
                                preStates.add(0);
                                break;
                            }
                        } else {
                            state1 = getNodeState(theCase, from1.getId());
                            if (state1 == 0) {
                                findPreviousNodeState(theCase, from1, findedMaps, preStates, preInformStates);
                            } else if (state1 == 2 || state1 == 7 || state1 == 8) {
                                preInformStates.add(2);
                            }
                        }
                    }
                }
            }

        }
    }

    public static int getNodeState(BPMCase theCase, String currentNodeId) {
        int state = 0;
        List<BPMCaseLog> caseLogs = theCase.getCaseLogList();
        Iterator var5 = caseLogs.iterator();

        label44:
        while(true) {
            List frames;
            do {
                if (!var5.hasNext()) {
                    return state;
                }

                BPMCaseLog step = (BPMCaseLog)var5.next();
                frames = step.getDetailLogList();
            } while(frames == null);

            Iterator var8 = frames.iterator();

            while(true) {
                CaseDetailLog frame;
                do {
                    String nodeId;
                    do {
                        if (!var8.hasNext()) {
                            continue label44;
                        }

                        frame = (CaseDetailLog)var8.next();
                        nodeId = frame.nodeId;
                    } while(!nodeId.equals(currentNodeId));

                    if (state != 6 || frame.getState() == 2) {
                        state = frame.getState();
                    }
                } while(state == 6 && frame.getState() != 2);

                state = frame.getState();
            }
        }
    }

    public static Map<String, String> getNodeAttributes(Element node) {
        Map<String, String> r = new HashMap<String, String>() {
            private static final long serialVersionUID = -3476377988348094388L;

            public String get(Object key) {
                String v = (String)super.get(key);
                return v == null ? "" : v;
            }
        };
        List atts = node.attributes();
        if (atts != null) {
            for(int i = 0; i < atts.size(); ++i) {
                Attribute a = (Attribute)atts.get(i);
                r.put(a.getName(), a.getValue());
            }
        }

        return r;
    }

    public static Map<String, Object> isAllHumenNodeValid(BPMActivity currBackNode, BPMCase theCase) {
        Map<String, Object> resultMap = new HashMap();
        Map<String, String> normalNodesMap = new HashMap();
        BPMTransition currBackNodeUpLinks = (BPMTransition)currBackNode.getUpTransitions().get(0);
        BPMAbstractNode fromNodeOfcurrBackNode = currBackNodeUpLinks.getFrom();
        if (!fromNodeOfcurrBackNode.getNodeType().equals(NodeType.humen)) {
            Map tempMap;
            if (fromNodeOfcurrBackNode.getNodeType().equals(NodeType.join)) {
                tempMap = isWithdrawActivityOfJoinValid((BPMActivity)fromNodeOfcurrBackNode, (BPMActivity)fromNodeOfcurrBackNode, theCase);
                Map<String, BPMActivity> subDesNodeSetTmp = (Map)tempMap.get("subDesNodeSet");
                Map var10000 = (Map)tempMap.get("subRelationInfoSplitMap");
                if (subDesNodeSetTmp.size() == 1) {
                    Iterator<String> iter = subDesNodeSetTmp.keySet().iterator();
                    String key = (String)iter.next();
                    BPMActivity desSplitNode = (BPMActivity)subDesNodeSetTmp.get(key);
                    if (desSplitNode.getNodeType().equals(NodeType.split)) {
                        Map<String, Object> tempMap1 = isWithdrawActivityOfSplitValid(desSplitNode, theCase);
                        if (tempMap1.get("normal_nodes") != null) {
                            normalNodesMap.putAll((Map)tempMap1.get("normal_nodes"));
                        }

                        resultMap.put("result", tempMap1.get("result"));
                        resultMap.put("normal_nodes", normalNodesMap);
                        return resultMap;
                    } else {
                        if (tempMap.get("normal_nodes") != null) {
                            normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                        }

                        resultMap.put("normal_nodes", normalNodesMap);
                        resultMap.put("result", tempMap.get("result"));
                        return resultMap;
                    }
                } else {
                    if (tempMap.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                    }

                    resultMap.put("normal_nodes", normalNodesMap);
                    resultMap.put("result", tempMap.get("result"));
                    return resultMap;
                }
            } else if (fromNodeOfcurrBackNode.getNodeType().equals(NodeType.split)) {
                tempMap = isWithdrawActivityOfSplitValid(fromNodeOfcurrBackNode, theCase);
                if (tempMap.get("normal_nodes") != null) {
                    normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                }

                resultMap.put("normal_nodes", normalNodesMap);
                resultMap.put("result", tempMap.get("result"));
                return resultMap;
            } else if (fromNodeOfcurrBackNode.getNodeType().equals(NodeType.start)) {
                normalNodesMap.put(fromNodeOfcurrBackNode.getId(), fromNodeOfcurrBackNode.getId());
                resultMap.put("normal_nodes", normalNodesMap);
                resultMap.put("result", "1");
                return resultMap;
            } else {
                resultMap.put("normal_nodes", normalNodesMap);
                resultMap.put("result", "0");
                return resultMap;
            }
        } else {
            BPMHumenActivity fromHumenNodeOfcurrBackNode = (BPMHumenActivity)fromNodeOfcurrBackNode;
            String currFromHumenNodePolicy = fromHumenNodeOfcurrBackNode.getSeeyonPolicy().getId();
            boolean currFromHumenNodeIsInformNode = currFromHumenNodePolicy.equals(informActivityPolicy) || currFromHumenNodePolicy.equals(edocInformActivityPolicy);
            boolean isAutoSkip = isAutoSkip(theCase, fromHumenNodeOfcurrBackNode);
            if (!currFromHumenNodeIsInformNode && !isAutoSkip) {
                normalNodesMap.put(fromNodeOfcurrBackNode.getId(), fromNodeOfcurrBackNode.getId());
                resultMap.put("normal_nodes", normalNodesMap);
                resultMap.put("result", "0");
                return resultMap;
            } else {
                Map<String, Object> tempResultMap = isAllHumenNodeValid(fromHumenNodeOfcurrBackNode, theCase);
                if (tempResultMap.get("normal_nodes") != null) {
                    normalNodesMap.putAll((Map)tempResultMap.get("normal_nodes"));
                }

                resultMap.put("normal_nodes", normalNodesMap);
                resultMap.put("result", tempResultMap.get("result"));
                return resultMap;
            }
        }
    }

    public static boolean isAutoSkip(BPMCase theCase, BPMAbstractNode node) {
        String normalNodeId = node.getId();
        BPMSeeyonPolicy normalPolicy = node.getSeeyonPolicy();
        Map<String, String> nodeAdditionMap = null;
        Map<String, Map<String, String>> nodeConditionChangeInfoMap = null;
        Object result1 = null;
        if (theCase != null) {
            result1 = theCase.getData("wf_node_addition_key");
        }

        nodeAdditionMap = result1 == null ? new HashMap() : (Map)result1;
        Object result2 = null;
        if (theCase != null) {
            result2 = theCase.getData("wf_node_condition_change_key");
        }

        nodeConditionChangeInfoMap = result2 == null ? new HashMap() : (Map)result2;
        Map<String, String> nodeConditionMap = (Map)((Map)nodeConditionChangeInfoMap).get(normalNodeId);
        String isDelete = "false";
        if (nodeConditionMap != null) {
            isDelete = (String)nodeConditionMap.get("isDelete");
        }

        return "2".equals(normalPolicy.getNa()) && "false".equals(isDelete) && (((Map)nodeAdditionMap).get(normalNodeId) == null || Strings.isBlank((String)((Map)nodeAdditionMap).get(normalNodeId)));
    }

    private static Map<String, Object> isWithdrawActivityOfSplitValid(BPMAbstractNode fromNodeOfcurrBackNode, BPMCase theCase) {
        Map<String, Object> resultMap = new HashMap();
        Map<String, String> normalNodesMap = new HashMap();
        String informActivityPolicy = BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getId();
        String edocInformActivityPolicy = BPMSeeyonPolicy.EDOC_POLICY_ZHIHUI.getId();
        BPMTransition fromNodeOfcurrBackNodeUpLinks = (BPMTransition)fromNodeOfcurrBackNode.getUpTransitions().get(0);
        BPMAbstractNode fromNodeOfcurrSplitNode = fromNodeOfcurrBackNodeUpLinks.getFrom();
        if (!fromNodeOfcurrSplitNode.getNodeType().equals(NodeType.humen)) {
            Map tempMap;
            if (fromNodeOfcurrSplitNode.getNodeType().equals(NodeType.split)) {
                tempMap = isWithdrawActivityOfSplitValid(fromNodeOfcurrSplitNode, theCase);
                resultMap.put("result", tempMap.get("result"));
                if (tempMap.get("normal_nodes") != null) {
                    normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                }

                resultMap.put("normal_nodes", normalNodesMap);
                return resultMap;
            } else if (fromNodeOfcurrSplitNode.getNodeType().equals(NodeType.join)) {
                tempMap = isWithdrawActivityOfJoinValid((BPMActivity)fromNodeOfcurrSplitNode, (BPMActivity)fromNodeOfcurrSplitNode, theCase);
                Map<String, BPMActivity> subDesNodeSetTmp = (Map)tempMap.get("subDesNodeSet");
                Map var10000 = (Map)tempMap.get("subRelationInfoSplitMap");
                if (subDesNodeSetTmp.size() == 1) {
                    Iterator<String> iter = subDesNodeSetTmp.keySet().iterator();
                    String key = (String)iter.next();
                    BPMActivity desSplitNode = (BPMActivity)subDesNodeSetTmp.get(key);
                    if (desSplitNode.getNodeType().equals(NodeType.split)) {
                        Map tempMap1 = isWithdrawActivityOfSplitValid(desSplitNode, theCase);
                        resultMap.put("result", tempMap1.get("result"));
                        if (tempMap1.get("normal_nodes") != null) {
                            normalNodesMap.putAll((Map)tempMap1.get("normal_nodes"));
                        }

                        resultMap.put("normal_nodes", normalNodesMap);
                        return resultMap;
                    } else {
                        resultMap.put("result", tempMap.get("result"));
                        if (tempMap.get("normal_nodes") != null) {
                            normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                        }

                        resultMap.put("normal_nodes", normalNodesMap);
                        return resultMap;
                    }
                } else {
                    resultMap.put("result", tempMap.get("result"));
                    if (tempMap.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                    }

                    resultMap.put("normal_nodes", normalNodesMap);
                    return resultMap;
                }
            } else if (fromNodeOfcurrSplitNode.getNodeType().equals(NodeType.start)) {
                normalNodesMap.put(fromNodeOfcurrSplitNode.getId(), fromNodeOfcurrSplitNode.getId());
                resultMap.put("result", "1");
                resultMap.put("normal_nodes", normalNodesMap);
                return resultMap;
            } else {
                resultMap.put("result", "0");
                resultMap.put("normal_nodes", normalNodesMap);
                return resultMap;
            }
        } else {
            BPMHumenActivity fromHumenNodeOfSplitNode = (BPMHumenActivity)fromNodeOfcurrSplitNode;
            String currFromHumenNodePolicy = fromHumenNodeOfSplitNode.getSeeyonPolicy().getId();
            boolean currFromHumenNodeIsInformNode = currFromHumenNodePolicy.equals(informActivityPolicy) || currFromHumenNodePolicy.equals(edocInformActivityPolicy);
            boolean isAutoSkip = isAutoSkip(theCase, fromHumenNodeOfSplitNode);
            if (!currFromHumenNodeIsInformNode && !isAutoSkip) {
                normalNodesMap.put(fromHumenNodeOfSplitNode.getId(), fromHumenNodeOfSplitNode.getId());
                resultMap.put("normal_nodes", normalNodesMap);
                resultMap.put("result", "0");
                return resultMap;
            } else {
                Map<String, Object> tempMap = isWithdrawActivityOfSplitValid(fromHumenNodeOfSplitNode, theCase);
                resultMap.put("result", tempMap.get("result"));
                if (tempMap.get("normal_nodes") != null) {
                    normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                }

                resultMap.put("normal_nodes", normalNodesMap);
                return resultMap;
            }
        }
    }

    private static Map<String, Object> isWithdrawActivityOfJoinValid(BPMActivity firstJoinNode, BPMActivity currentJoinNode, BPMCase theCase) {
        Map<String, BPMActivity> subDesNodeSet = new HashMap();
        Map<String, List<BPMActivity>> subRelationInfoSplitMap = new HashMap();
        Map<String, String> normalNodesMap = new HashMap();
        int result = 0;
        String informActivityPolicy = BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getId();
        String edocInformActivityPolicy = BPMSeeyonPolicy.EDOC_POLICY_ZHIHUI.getId();
        List links_ba = currentJoinNode.getUpTransitions();
        Iterator iter = links_ba.iterator();

        while(true) {
            BPMAbstractNode fromNode;
            String fromNodeIsDelete;
            String splitIdTmp;
            do {
                if (!iter.hasNext()) {
                    if (currentJoinNode.getNodeType().equals(NodeType.join) && result != -1 && !firstJoinNode.getId().equals(currentJoinNode.getId())) {
                        if (subDesNodeSet.size() == 1) {
                            iter = subDesNodeSet.keySet().iterator();
                            String key = (String)iter.next();
                            BPMActivity desSplitNode = (BPMActivity)subDesNodeSet.get(key);
                            if (desSplitNode.getNodeType().equals(NodeType.split)) {
                                subDesNodeSet.remove(key);
                                subRelationInfoSplitMap.remove(key);
                                Map tempMap = isWithdrawActivityOfJoinValid(firstJoinNode, desSplitNode, theCase);
                                Map subRelationInfoSplitMapTmp;
                                if (tempMap.get("subDesNodeSet") != null) {
                                    subRelationInfoSplitMapTmp = (Map)tempMap.get("subDesNodeSet");
                                    subDesNodeSet.putAll(subRelationInfoSplitMapTmp);
                                }

                                if (tempMap.get("subRelationInfoSplitMap") != null) {
                                    subRelationInfoSplitMapTmp = (Map)tempMap.get("subRelationInfoSplitMap");
                                    if (subRelationInfoSplitMapTmp.size() > 0) {
                                        Iterator iterSplitTmp = subRelationInfoSplitMapTmp.keySet().iterator();

                                        while(iterSplitTmp.hasNext()) {
                                            splitIdTmp = (String)iterSplitTmp.next();
                                            List<BPMActivity> lastInfoList = (List)subRelationInfoSplitMap.get(splitIdTmp);
                                            if (lastInfoList != null) {
                                                lastInfoList.addAll((Collection)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                            } else {
                                                subRelationInfoSplitMap.put(splitIdTmp, (List)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                            }
                                        }
                                    }
                                }

                                if (tempMap.get("normal_nodes") != null) {
                                    normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                                }
                            }
                        } else {
                            subRelationInfoSplitMap.clear();
                        }
                    }

                    Map tempMap = new HashMap();
                    tempMap.put("subDesNodeSet", subDesNodeSet);
                    tempMap.put("subRelationInfoSplitMap", subRelationInfoSplitMap);
                    tempMap.put("result", String.valueOf(result));
                    tempMap.put("normal_nodes", normalNodesMap);
                    return tempMap;
                }

                BPMTransition upLink = (BPMTransition)iter.next();
                fromNode = upLink.getFrom();
                fromNodeIsDelete = getNodeConditionFromCase(theCase, fromNode, "isDelete");
            } while(!"false".equals(fromNodeIsDelete));

            NodeType fromNodeType = fromNode.getNodeType();
            if (fromNodeType.equals(NodeType.join)) {
                Map tempMap = isWithdrawActivityOfJoinValid(firstJoinNode, (BPMActivity)fromNode, theCase);
                Map subRelationInfoSplitMapTmp;
                if (tempMap.get("subDesNodeSet") != null) {
                    subRelationInfoSplitMapTmp = (Map)tempMap.get("subDesNodeSet");
                    subDesNodeSet.putAll(subRelationInfoSplitMapTmp);
                }

                if (tempMap.get("subRelationInfoSplitMap") != null) {
                    subRelationInfoSplitMapTmp = (Map)tempMap.get("subRelationInfoSplitMap");
                    if (subRelationInfoSplitMapTmp.size() > 0) {
                        Iterator iterSplitTmp = subRelationInfoSplitMapTmp.keySet().iterator();

                        while(iterSplitTmp.hasNext()) {
                             splitIdTmp = (String)iterSplitTmp.next();
                            List<BPMActivity> lastInfoList = (List)subRelationInfoSplitMap.get(splitIdTmp);
                            if (lastInfoList != null) {
                                lastInfoList.addAll((Collection)subRelationInfoSplitMapTmp.get(splitIdTmp));
                            } else {
                                subRelationInfoSplitMap.put(splitIdTmp, (List)subRelationInfoSplitMapTmp.get(splitIdTmp));
                            }
                        }
                    }
                }

                if (tempMap.get("normal_nodes") != null) {
                    normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                }
            }

            if (fromNodeType.equals(NodeType.humen)) {
                BPMHumenActivity fromNodeOfJoinNode = (BPMHumenActivity)fromNode;
                splitIdTmp = fromNode.getSeeyonPolicy().getId();
                boolean currFromHumenNodeIsInformNode = splitIdTmp.equals(informActivityPolicy) || splitIdTmp.equals(edocInformActivityPolicy);
                boolean isAutoSkip = isAutoSkip(theCase, fromNode);
                if (!currFromHumenNodeIsInformNode && !isAutoSkip) {
                    normalNodesMap.put(fromNode.getId(), fromNode.getId());
                    subDesNodeSet.put(fromNodeOfJoinNode.getId(), fromNodeOfJoinNode);
                } else {
                    Map tempMap = isWithdrawActivityOfJoinValid(firstJoinNode, fromNodeOfJoinNode, theCase);
                    Map subRelationInfoSplitMapTmp;
                    if (tempMap.get("subDesNodeSet") != null) {
                        subRelationInfoSplitMapTmp = (Map)tempMap.get("subDesNodeSet");
                        subDesNodeSet.putAll(subRelationInfoSplitMapTmp);
                    }

                    if (tempMap.get("subRelationInfoSplitMap") != null) {
                        subRelationInfoSplitMapTmp = (Map)tempMap.get("subRelationInfoSplitMap");
                        if (subRelationInfoSplitMapTmp.size() > 0) {
                            Iterator iterSplitTmp = subRelationInfoSplitMapTmp.keySet().iterator();

                            while(iterSplitTmp.hasNext()) {
                                 splitIdTmp = (String)iterSplitTmp.next();
                                List<BPMActivity> lastInfoList = (List)subRelationInfoSplitMap.get(splitIdTmp);
                                if (lastInfoList != null) {
                                    lastInfoList.addAll((Collection)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                } else {
                                    subRelationInfoSplitMap.put(splitIdTmp, (List)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                }
                            }
                        }
                    }

                    if (tempMap.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                    }
                }
            }

            if (fromNodeType.equals(NodeType.split)) {
                subDesNodeSet.put(fromNode.getId(), (BPMActivity)fromNode);
                List<BPMActivity> lastInfoList = (List)subRelationInfoSplitMap.get(fromNode.getId());
                if (lastInfoList == null) {
                    lastInfoList = new ArrayList();
                }

                ((List)lastInfoList).add(currentJoinNode);
                subRelationInfoSplitMap.put(fromNode.getId(), lastInfoList);
            }

            if (fromNodeType.equals(NodeType.start)) {
                normalNodesMap.put(fromNode.getId(), fromNode.getId());
                result = 1;
            }
        }
    }

    public static List<String> getAllNFNodes(Map normalNodes, BPMProcess process, BPMCase theCase) {
        List<String> returnList = new ArrayList();
        Iterator iter = normalNodes.keySet().iterator();
        HashMap passedNodes = new HashMap();

        while(iter.hasNext()) {
            String activityId = (String)iter.next();
            if (activityId != null) {
                if ("start".equals(activityId)) {
                    BPMAbstractNode activity = process.getStart();
                    getAllNFNodesByActivityNode(activity, returnList, theCase, passedNodes);
                } else {
                    BPMActivity activity = process.getActivityById(activityId);
                    if (activity != null) {
                        getAllNFNodesByActivityNode(activity, returnList, theCase, passedNodes);
                    }
                }
            }
        }

        return returnList;
    }

    private static void getAllNFNodesByActivityNode(BPMAbstractNode activity, List<String> returnList, BPMCase theCase, Map<String, String> passedNodes) {
        if (!activity.getNodeType().equals(NodeType.end)) {
            if (passedNodes.get(activity.getId()) == null) {
                passedNodes.put(activity.getId(), activity.getId());
                String isDelete = getNodeConditionFromCase(theCase, activity, "isDelete");
                if ("false".equals(isDelete)) {
                    if (activity.getNodeType().equals(NodeType.humen)) {
                        BPMHumenActivity humenActivity = (BPMHumenActivity)activity;
                        String seeyonPolicyId = humenActivity.getSeeyonPolicy().getId();
                        boolean isInformNode = seeyonPolicyId.equals(informActivityPolicy) || seeyonPolicyId.equals(edocInformActivityPolicy);
                        List downs;
                        BPMAbstractNode toNode;
                        if (!isInformNode) {
                            if ("1".equals(humenActivity.getSeeyonPolicy().getNF()) && !returnList.contains(activity.getId())) {
                                returnList.add(activity.getId());
                            }

                            downs = activity.getDownTransitions();
                            toNode = ((BPMTransition)downs.get(0)).getTo();
                            getAllNFNodesByActivityNode(toNode, returnList, theCase, passedNodes);
                        } else {
                            downs = activity.getDownTransitions();
                            toNode = ((BPMTransition)downs.get(0)).getTo();
                            getAllNFNodesByActivityNode(toNode, returnList, theCase, passedNodes);
                        }
                    } else {
                        List downs;
                        BPMAbstractNode toNode;
                        if (activity.getNodeType().equals(NodeType.join)) {
                            downs = activity.getDownTransitions();
                            toNode = ((BPMTransition)downs.get(0)).getTo();
                            getAllNFNodesByActivityNode(toNode, returnList, theCase, passedNodes);
                        } else if (activity.getNodeType().equals(NodeType.split)) {
                            downs = activity.getDownTransitions();
                            Iterator iterator = downs.iterator();

                            while(iterator.hasNext()) {
                                BPMTransition down = (BPMTransition)iterator.next();
                                 toNode = down.getTo();
                                getAllNFNodesByActivityNode(toNode, returnList, theCase, passedNodes);
                            }
                        } else if (activity.getNodeType().equals(NodeType.start)) {
                            downs = activity.getDownTransitions();
                            toNode = ((BPMTransition)downs.get(0)).getTo();
                            getAllNFNodesByActivityNode(toNode, returnList, theCase, passedNodes);
                        }
                    }
                }

            }
        }
    }

    public static boolean userInString(String userId, String str) {
        if (userId != null && !userId.equals("") && str != null && !str.equals("")) {
            String[] ret = str.split(";");

            for(int i = 0; i < ret.length; ++i) {
                if (userId.equalsIgnoreCase(ret[i])) {
                    return true;
                }
            }

            return false;
        } else {
            return false;
        }
    }

    public static Map<String, Object> isCanNotStepOfGivenPolicy(BPMActivity currBackNode, String givenPolicyId, boolean isConsiderHumenValid, BPMCase theCase) {
        Map<String, Object> resultMap = new HashMap();
        Map<String, String> normalNodesMap = new HashMap();
        if (currBackNode == null) {
            resultMap.put("normal_nodes", normalNodesMap);
            resultMap.put("result", "-1");
            return resultMap;
        } else {
            BPMTransition currBackNodeUpLinks = (BPMTransition)currBackNode.getUpTransitions().get(0);
            BPMAbstractNode fromNodeOfcurrBackNode = currBackNodeUpLinks.getFrom();
            if (fromNodeOfcurrBackNode.getNodeType().equals(NodeType.humen)) {
                BPMHumenActivity fromHumenNodeOfcurrBackNode = (BPMHumenActivity)fromNodeOfcurrBackNode;
                if (isConsiderHumenValid) {
                    BPMActor actor = (BPMActor)fromHumenNodeOfcurrBackNode.getActorList().get(0);
                    BPMParticipant party = actor.getParty();
                    String partyTypeId = party.getType().id;
                    if (!"normal".equals(fromHumenNodeOfcurrBackNode.isValid()) && "user".equals(partyTypeId)) {
                        resultMap.put("result", "-1");
                        return resultMap;
                    }
                }

                String currFromHumenNodePolicy = fromHumenNodeOfcurrBackNode.getSeeyonPolicy().getId();
                boolean currFromHumenNodeIsInformNode = currFromHumenNodePolicy.equals(informActivityPolicy) || currFromHumenNodePolicy.equals(edocInformActivityPolicy);
                if (currFromHumenNodeIsInformNode) {
                    Map<String, Object> tempResultMap = isCanNotStepOfGivenPolicy(fromHumenNodeOfcurrBackNode, givenPolicyId, isConsiderHumenValid, theCase);
                    if (tempResultMap.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)tempResultMap.get("normal_nodes"));
                    }

                    resultMap.put("normal_nodes", normalNodesMap);
                    resultMap.put("result", tempResultMap.get("result"));
                    return resultMap;
                } else if (givenPolicyId != null && !"".equals(givenPolicyId.trim()) && currFromHumenNodePolicy.trim().equals(givenPolicyId.trim())) {
                    normalNodesMap.put(fromNodeOfcurrBackNode.getId(), fromNodeOfcurrBackNode.getId());
                    resultMap.put("normal_nodes", normalNodesMap);
                    resultMap.put("result", "-1");
                    return resultMap;
                } else {
                    normalNodesMap.put(fromNodeOfcurrBackNode.getId(), fromNodeOfcurrBackNode.getId());
                    resultMap.put("normal_nodes", normalNodesMap);
                    resultMap.put("result", "0");
                    return resultMap;
                }
            } else {
                Map tempMap;
                if (fromNodeOfcurrBackNode.getNodeType().equals(NodeType.join)) {
                    tempMap = isCanNotStepOfGivenPolicyForJoin((BPMActivity)fromNodeOfcurrBackNode, (BPMActivity)fromNodeOfcurrBackNode, givenPolicyId, isConsiderHumenValid, theCase);
                    Map<String, BPMActivity> subDesNodeSetTmp = (Map)tempMap.get("subDesNodeSet");
                    Map var10000 = (Map)tempMap.get("subRelationInfoSplitMap");
                    String result_str = String.valueOf(tempMap.get("result"));
                    if (result_str.equals("-1")) {
                        resultMap.put("result", "-1");
                        return resultMap;
                    } else if (subDesNodeSetTmp.size() == 1) {
                        Iterator<String> iter = subDesNodeSetTmp.keySet().iterator();
                        String key = (String)iter.next();
                        BPMActivity desSplitNode = (BPMActivity)subDesNodeSetTmp.get(key);
                        if (desSplitNode.getNodeType().equals(NodeType.split)) {
                            Map<String, Object> tempMap1 = isCanNotStepOfGivenPolicyForSplit(desSplitNode, givenPolicyId, isConsiderHumenValid, theCase);
                            if (tempMap1.get("normal_nodes") != null) {
                                normalNodesMap.putAll((Map)tempMap1.get("normal_nodes"));
                            }

                            resultMap.put("result", tempMap1.get("result"));
                            resultMap.put("normal_nodes", normalNodesMap);
                            return resultMap;
                        } else {
                            if (tempMap.get("normal_nodes") != null) {
                                normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                            }

                            resultMap.put("normal_nodes", normalNodesMap);
                            resultMap.put("result", tempMap.get("result"));
                            return resultMap;
                        }
                    } else {
                        if (tempMap.get("normal_nodes") != null) {
                            normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                        }

                        resultMap.put("normal_nodes", normalNodesMap);
                        resultMap.put("result", tempMap.get("result"));
                        return resultMap;
                    }
                } else if (fromNodeOfcurrBackNode.getNodeType().equals(NodeType.split)) {
                    tempMap = isCanNotStepOfGivenPolicyForSplit(fromNodeOfcurrBackNode, givenPolicyId, isConsiderHumenValid, theCase);
                    if (tempMap.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                    }

                    resultMap.put("normal_nodes", normalNodesMap);
                    resultMap.put("result", tempMap.get("result"));
                    return resultMap;
                } else if (fromNodeOfcurrBackNode.getNodeType().equals(NodeType.start)) {
                    normalNodesMap.put(fromNodeOfcurrBackNode.getId(), fromNodeOfcurrBackNode.getId());
                    resultMap.put("normal_nodes", normalNodesMap);
                    resultMap.put("result", "1");
                    return resultMap;
                } else {
                    resultMap.put("normal_nodes", normalNodesMap);
                    resultMap.put("result", "0");
                    return resultMap;
                }
            }
        }
    }

    private static Map<String, Object> isCanNotStepOfGivenPolicyForSplit(BPMAbstractNode fromNodeOfcurrBackNode, String givenPolicyId, boolean isConsiderHumenValid, BPMCase theCase) {
        Map<String, Object> resultMap = new HashMap();
        Map<String, String> normalNodesMap = new HashMap();
        String informActivityPolicy = BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getId();
        String edocInformActivityPolicy = BPMSeeyonPolicy.EDOC_POLICY_ZHIHUI.getId();
        BPMTransition fromNodeOfcurrBackNodeUpLinks = (BPMTransition)fromNodeOfcurrBackNode.getUpTransitions().get(0);
        BPMAbstractNode fromNodeOfcurrSplitNode = fromNodeOfcurrBackNodeUpLinks.getFrom();
        String key;
        String currFromHumenNodePolicy;
        if (fromNodeOfcurrSplitNode.getNodeType().equals(NodeType.humen)) {
            BPMHumenActivity fromHumenNodeOfSplitNode = (BPMHumenActivity)fromNodeOfcurrSplitNode;
            if (isConsiderHumenValid) {
                BPMActor actor = (BPMActor)fromHumenNodeOfSplitNode.getActorList().get(0);
                BPMParticipant party = actor.getParty();
                String partyTypeId = party.getType().id;
                if (!"normal".equals(fromHumenNodeOfSplitNode.isValid()) && "user".equals(partyTypeId)) {
                    resultMap.put("result", "-1");
                    return resultMap;
                }
            }

            currFromHumenNodePolicy = fromHumenNodeOfSplitNode.getSeeyonPolicy().getId();
            boolean currFromHumenNodeIsInformNode = currFromHumenNodePolicy.equals(informActivityPolicy) || currFromHumenNodePolicy.equals(edocInformActivityPolicy);
            if (currFromHumenNodeIsInformNode) {
                Map<String, Object> tempMap = isCanNotStepOfGivenPolicyForSplit(fromHumenNodeOfSplitNode, givenPolicyId, isConsiderHumenValid, theCase);
                key = String.valueOf(tempMap.get("result"));
                if (key.equals("-1")) {
                    resultMap.put("result", "-1");
                    return resultMap;
                } else {
                    resultMap.put("result", tempMap.get("result"));
                    if (tempMap.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                    }

                    resultMap.put("normal_nodes", normalNodesMap);
                    return resultMap;
                }
            } else if (givenPolicyId != null && !"".equals(givenPolicyId.trim()) && currFromHumenNodePolicy.trim().equals(givenPolicyId.trim())) {
                normalNodesMap.put(fromHumenNodeOfSplitNode.getId(), fromHumenNodeOfSplitNode.getId());
                resultMap.put("normal_nodes", normalNodesMap);
                resultMap.put("result", "-1");
                return resultMap;
            } else {
                normalNodesMap.put(fromHumenNodeOfSplitNode.getId(), fromHumenNodeOfSplitNode.getId());
                resultMap.put("normal_nodes", normalNodesMap);
                resultMap.put("result", "0");
                return resultMap;
            }
        } else {
            Map tempMap;
            if (fromNodeOfcurrSplitNode.getNodeType().equals(NodeType.split)) {
                tempMap = isCanNotStepOfGivenPolicyForSplit(fromNodeOfcurrSplitNode, givenPolicyId, isConsiderHumenValid, theCase);
                currFromHumenNodePolicy = String.valueOf(tempMap.get("result"));
                if (currFromHumenNodePolicy.equals("-1")) {
                    resultMap.put("result", "-1");
                    return resultMap;
                } else {
                    resultMap.put("result", tempMap.get("result"));
                    if (tempMap.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                    }

                    resultMap.put("normal_nodes", normalNodesMap);
                    return resultMap;
                }
            } else if (fromNodeOfcurrSplitNode.getNodeType().equals(NodeType.join)) {
                tempMap = isCanNotStepOfGivenPolicyForJoin((BPMActivity)fromNodeOfcurrSplitNode, (BPMActivity)fromNodeOfcurrSplitNode, givenPolicyId, isConsiderHumenValid, theCase);
                Map<String, BPMActivity> subDesNodeSetTmp = (Map)tempMap.get("subDesNodeSet");
                Map var10000 = (Map)tempMap.get("subRelationInfoSplitMap");
                String result_str = String.valueOf(tempMap.get("result"));
                if (result_str.equals("-1")) {
                    resultMap.put("result", "-1");
                    return resultMap;
                } else if (subDesNodeSetTmp.size() == 1) {
                    Iterator<String> iter = subDesNodeSetTmp.keySet().iterator();
                    key = (String)iter.next();
                    BPMActivity desSplitNode = (BPMActivity)subDesNodeSetTmp.get(key);
                    if (desSplitNode.getNodeType().equals(NodeType.split)) {
                        Map tempMap1 = isCanNotStepOfGivenPolicyForSplit(desSplitNode, givenPolicyId, isConsiderHumenValid, theCase);
                        String result_str1 = String.valueOf(tempMap1.get("result"));
                        if (result_str1.equals("-1")) {
                            resultMap.put("result", "-1");
                            return resultMap;
                        } else {
                            resultMap.put("result", tempMap1.get("result"));
                            if (tempMap1.get("normal_nodes") != null) {
                                normalNodesMap.putAll((Map)tempMap1.get("normal_nodes"));
                            }

                            resultMap.put("normal_nodes", normalNodesMap);
                            return resultMap;
                        }
                    } else {
                        resultMap.put("result", tempMap.get("result"));
                        if (tempMap.get("normal_nodes") != null) {
                            normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                        }

                        resultMap.put("normal_nodes", normalNodesMap);
                        return resultMap;
                    }
                } else {
                    resultMap.put("result", tempMap.get("result"));
                    if (tempMap.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                    }

                    resultMap.put("normal_nodes", normalNodesMap);
                    return resultMap;
                }
            } else if (fromNodeOfcurrSplitNode.getNodeType().equals(NodeType.start)) {
                normalNodesMap.put(fromNodeOfcurrSplitNode.getId(), fromNodeOfcurrSplitNode.getId());
                resultMap.put("result", "1");
                resultMap.put("normal_nodes", normalNodesMap);
                return resultMap;
            } else {
                resultMap.put("result", "0");
                resultMap.put("normal_nodes", normalNodesMap);
                return resultMap;
            }
        }
    }

    private static Map<String, Object> isCanNotStepOfGivenPolicyForJoin(BPMActivity firstJoinNode, BPMActivity currentJoinNode, String givenPolicyId, boolean isConsiderHumenValid, BPMCase theCase) {
        Map<String, BPMActivity> subDesNodeSet = new HashMap();
        Map<String, List<BPMActivity>> subRelationInfoSplitMap = new HashMap();
        Map<String, String> normalNodesMap = new HashMap();
        int result = 0;
        String informActivityPolicy = BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getId();
        String edocInformActivityPolicy = BPMSeeyonPolicy.EDOC_POLICY_ZHIHUI.getId();
        List links_ba = currentJoinNode.getUpTransitions();
        Iterator iter = links_ba.iterator();

        Map subRelationInfoSplitMapTmp;
        while(iter.hasNext()) {
            BPMTransition upLink = (BPMTransition)iter.next();
            BPMAbstractNode fromNode = upLink.getFrom();
            String fromNodeIsDelete = getNodeConditionFromCase(theCase, fromNode, "isDelete");
            if ("false".equals(fromNodeIsDelete)) {
                NodeType fromNodeType = fromNode.getNodeType();
                String currFromHumenNodePolicy;
                String splitIdTmp;
                if (fromNodeType.equals(NodeType.join)) {
                    subRelationInfoSplitMapTmp = isCanNotStepOfGivenPolicyForJoin(firstJoinNode, (BPMActivity)fromNode, givenPolicyId, isConsiderHumenValid, theCase);
                    currFromHumenNodePolicy = String.valueOf(subRelationInfoSplitMapTmp.get("result"));
                    if (currFromHumenNodePolicy.equals("-1")) {
                        result = -1;
                        break;
                    }
                    if (subRelationInfoSplitMapTmp.get("subDesNodeSet") != null) {
                        subRelationInfoSplitMapTmp = (Map)subRelationInfoSplitMapTmp.get("subDesNodeSet");
                        subDesNodeSet.putAll(subRelationInfoSplitMapTmp);
                    }

                    if (subRelationInfoSplitMapTmp.get("subRelationInfoSplitMap") != null) {
                        subRelationInfoSplitMapTmp = (Map)subRelationInfoSplitMapTmp.get("subRelationInfoSplitMap");
                        if (subRelationInfoSplitMapTmp.size() > 0) {
                            Iterator iterSplitTmp = subRelationInfoSplitMapTmp.keySet().iterator();

                            while(iterSplitTmp.hasNext()) {
                                splitIdTmp = (String)iterSplitTmp.next();
                                List<BPMActivity> lastInfoList = (List)subRelationInfoSplitMap.get(splitIdTmp);
                                if (lastInfoList != null) {
                                    lastInfoList.addAll((Collection)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                } else {
                                    subRelationInfoSplitMap.put(splitIdTmp, (List)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                }
                            }
                        }
                    }

                    if (subRelationInfoSplitMapTmp.get("normal_nodes") != null) {
                        normalNodesMap.putAll((Map)subRelationInfoSplitMapTmp.get("normal_nodes"));
                    }
                }

                if (fromNodeType.equals(NodeType.humen)) {
                    BPMHumenActivity fromNodeOfJoinNode = (BPMHumenActivity)fromNode;
                    if (isConsiderHumenValid) {
                        BPMActor actor = (BPMActor)fromNodeOfJoinNode.getActorList().get(0);
                        BPMParticipant party = actor.getParty();
                        String partyTypeId = party.getType().id;
                        if (!"normal".equals(fromNodeOfJoinNode.isValid()) && "user".equals(partyTypeId)) {
                            result = -1;
                            break;
                        }
                    }

                    currFromHumenNodePolicy = fromNode.getSeeyonPolicy().getId();
                    boolean currFromHumenNodeIsInformNode = currFromHumenNodePolicy.equals(informActivityPolicy) || currFromHumenNodePolicy.equals(edocInformActivityPolicy);
                    if (currFromHumenNodeIsInformNode) {
                        Map tempMap = isCanNotStepOfGivenPolicyForJoin(firstJoinNode, fromNodeOfJoinNode, givenPolicyId, isConsiderHumenValid, theCase);
                        splitIdTmp = String.valueOf(tempMap.get("result"));
                        if (splitIdTmp.equals("-1")) {
                            result = -1;
                            break;
                        }


                        if (tempMap.get("subDesNodeSet") != null) {
                            subRelationInfoSplitMapTmp = (Map)tempMap.get("subDesNodeSet");
                            subDesNodeSet.putAll(subRelationInfoSplitMapTmp);
                        }

                        if (tempMap.get("subRelationInfoSplitMap") != null) {
                            subRelationInfoSplitMapTmp = (Map)tempMap.get("subRelationInfoSplitMap");
                            if (subRelationInfoSplitMapTmp.size() > 0) {
                                Iterator iterSplitTmp = subRelationInfoSplitMapTmp.keySet().iterator();

                                while(iterSplitTmp.hasNext()) {
                                     splitIdTmp = (String)iterSplitTmp.next();
                                    List<BPMActivity> lastInfoList = (List)subRelationInfoSplitMap.get(splitIdTmp);
                                    if (lastInfoList != null) {
                                        lastInfoList.addAll((Collection)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                    } else {
                                        subRelationInfoSplitMap.put(splitIdTmp, (List)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                    }
                                }
                            }
                        }

                        if (tempMap.get("normal_nodes") != null) {
                            normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                        }
                    } else {
                        if (givenPolicyId != null && !"".equals(givenPolicyId.trim()) && currFromHumenNodePolicy.trim().equals(givenPolicyId.trim())) {
                            normalNodesMap.put(fromNode.getId(), fromNode.getId());
                            subDesNodeSet.put(fromNodeOfJoinNode.getId(), fromNodeOfJoinNode);
                            result = -1;
                            break;
                        }

                        normalNodesMap.put(fromNode.getId(), fromNode.getId());
                        subDesNodeSet.put(fromNodeOfJoinNode.getId(), fromNodeOfJoinNode);
                    }
                }

                if (fromNodeType.equals(NodeType.split)) {
                    subDesNodeSet.put(fromNode.getId(), (BPMActivity)fromNode);
                    List<BPMActivity> lastInfoList = (List)subRelationInfoSplitMap.get(fromNode.getId());
                    if (lastInfoList == null) {
                        lastInfoList = new ArrayList();
                    }

                    ((List)lastInfoList).add(currentJoinNode);
                    subRelationInfoSplitMap.put(fromNode.getId(), lastInfoList);
                }

                if (fromNodeType.equals(NodeType.start)) {
                    normalNodesMap.put(fromNode.getId(), fromNode.getId());
                    result = 1;
                }
            }
        }

        if (currentJoinNode.getNodeType().equals(NodeType.join) && result != -1 && !firstJoinNode.getId().equals(currentJoinNode.getId())) {
            if (subDesNodeSet.size() == 1) {
                iter = subDesNodeSet.keySet().iterator();
                String key = (String)iter.next();
                BPMActivity desSplitNode = (BPMActivity)subDesNodeSet.get(key);
                if (desSplitNode.getNodeType().equals(NodeType.split)) {
                    subDesNodeSet.remove(key);
                    subRelationInfoSplitMap.remove(key);
                    Map tempMap = isCanNotStepOfGivenPolicyForJoin(firstJoinNode, desSplitNode, givenPolicyId, isConsiderHumenValid, theCase);
                    String result_str = String.valueOf(tempMap.get("result"));
                    if (result_str.equals("-1")) {
                        result = -1;
                    } else {
                        if (tempMap.get("subDesNodeSet") != null) {
                            subRelationInfoSplitMapTmp = (Map)tempMap.get("subDesNodeSet");
                            subDesNodeSet.putAll(subRelationInfoSplitMapTmp);
                        }

                        if (tempMap.get("subRelationInfoSplitMap") != null) {
                            subRelationInfoSplitMapTmp = (Map)tempMap.get("subRelationInfoSplitMap");
                            if (subRelationInfoSplitMapTmp.size() > 0) {
                                Iterator iterSplitTmp = subRelationInfoSplitMapTmp.keySet().iterator();

                                while(iterSplitTmp.hasNext()) {
                                    String splitIdTmp = (String)iterSplitTmp.next();
                                    List<BPMActivity> lastInfoList = (List)subRelationInfoSplitMap.get(splitIdTmp);
                                    if (lastInfoList != null) {
                                        lastInfoList.addAll((Collection)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                    } else {
                                        subRelationInfoSplitMap.put(splitIdTmp, (List)subRelationInfoSplitMapTmp.get(splitIdTmp));
                                    }
                                }
                            }
                        }

                        if (tempMap.get("normal_nodes") != null) {
                            normalNodesMap.putAll((Map)tempMap.get("normal_nodes"));
                        }
                    }
                }
            } else {
                subRelationInfoSplitMap.clear();
            }
        }

        Map tempMap = new HashMap();
        tempMap.put("subDesNodeSet", subDesNodeSet);
        tempMap.put("subRelationInfoSplitMap", subRelationInfoSplitMap);
        tempMap.put("result", String.valueOf(result));
        tempMap.put("normal_nodes", normalNodesMap);
        return tempMap;
    }

    public static String specailCharReplacement(String oldString, String regExp, String newString) {
        Pattern p = Pattern.compile(regExp);
        Matcher m = p.matcher(oldString);
        StringBuffer sb = new StringBuffer();

        while(m.find()) {
            m.group();
            m.appendReplacement(sb, newString);
        }

        m.appendTail(sb);
        return sb.toString();
    }

    public static List<BPMAbstractNode> findAllParentNodes(BPMAbstractNode node) {
        List<BPMAbstractNode> results = new ArrayList();
        if (node != null) {
            List nodeups = node.getUpTransitions();
            int i = 0;

            for(int ilen = nodeups.size(); i < ilen; ++i) {
                BPMAbstractNode tempParent = ((BPMTransition)nodeups.get(i)).getFrom();
                if (tempParent instanceof BPMHumenActivity) {
                    results.add(tempParent);
                } else if (tempParent instanceof BPMStart) {
                    results.add(tempParent);
                } else if (tempParent instanceof BPMAndRouter) {
                    results.addAll(findAllParentNodes(tempParent));
                }
            }
        }

        return results;
    }

    public static List<BPMHumenActivity> findAllParentHumenActivitys(BPMAbstractNode node) {
        List<BPMHumenActivity> results = new ArrayList();
        if (node != null) {
            List nodeups = node.getUpTransitions();
            int i = 0;

            for(int ilen = nodeups.size(); i < ilen; ++i) {
                BPMAbstractNode tempParent = ((BPMTransition)nodeups.get(i)).getFrom();
                if (tempParent instanceof BPMHumenActivity) {
                    results.add((BPMHumenActivity)tempParent);
                } else if (tempParent instanceof BPMAndRouter) {
                    results.addAll(findAllParentHumenActivitys(tempParent));
                }
            }
        }

        return results;
    }

    public static List<BPMHumenActivity> findAllAncestorHumenActivitys(BPMAbstractNode node) {
        List<BPMHumenActivity> results = null;
        if (node != null) {
            Map<String, BPMHumenActivity> nodeMap = new HashMap();
            List nodeups = node.getUpTransitions();
            int i = 0;

            for(int ilen = nodeups.size(); i < ilen; ++i) {
                BPMAbstractNode tempParent = ((BPMTransition)nodeups.get(i)).getFrom();
                List tempList;
                BPMHumenActivity tn;
                Iterator var9;
                if (tempParent instanceof BPMHumenActivity) {
                    nodeMap.put(tempParent.getId(), (BPMHumenActivity)tempParent);
                    tempList = findAllAncestorHumenActivitys(tempParent);
                    if (tempList != null && tempList.size() > 0) {
                        var9 = tempList.iterator();

                        while(var9.hasNext()) {
                            tn = (BPMHumenActivity)var9.next();
                            nodeMap.put(tn.getId(), tn);
                        }
                    }
                } else if (tempParent instanceof BPMAndRouter) {
                    tempList = findAllAncestorHumenActivitys(tempParent);
                    if (tempList != null && tempList.size() > 0) {
                        var9 = tempList.iterator();

                        while(var9.hasNext()) {
                            tn = (BPMHumenActivity)var9.next();
                            nodeMap.put(tn.getId(), tn);
                        }
                    }
                } else if (tempParent instanceof BPMStart) {
                    return results;
                }
            }

            if (nodeMap.size() > 0) {
                results = new ArrayList();
                Iterator var11 = nodeMap.entrySet().iterator();

                while(var11.hasNext()) {
                    Entry<String, BPMHumenActivity> entry = (Entry)var11.next();
                    results.add((BPMHumenActivity)entry.getValue());
                }
            }
        }

        return results;
    }

    public static List<BPMHumenActivity> findAllChildHumenActivitys(BPMAbstractNode node) {
        List<BPMHumenActivity> results = null;
        if (node != null) {
            Map<String, BPMHumenActivity> nodeMap = new HashMap();
            List nodeups = node.getDownTransitions();
            int i = 0;

            for(int ilen = nodeups.size(); i < ilen; ++i) {
                BPMAbstractNode tempParent = ((BPMTransition)nodeups.get(i)).getTo();
                List tempList;
                BPMHumenActivity tn;
                Iterator var9;
                if (tempParent instanceof BPMHumenActivity) {
                    nodeMap.put(tempParent.getId(), (BPMHumenActivity)tempParent);
                    tempList = findAllChildHumenActivitys(tempParent);
                    if (tempList != null && tempList.size() > 0) {
                        var9 = tempList.iterator();

                        while(var9.hasNext()) {
                            tn = (BPMHumenActivity)var9.next();
                            nodeMap.put(tn.getId(), tn);
                        }
                    }
                } else if (tempParent instanceof BPMAndRouter) {
                    tempList = findAllChildHumenActivitys(tempParent);
                    if (tempList != null && tempList.size() > 0) {
                        var9 = tempList.iterator();

                        while(var9.hasNext()) {
                            tn = (BPMHumenActivity)var9.next();
                            nodeMap.put(tn.getId(), tn);
                        }
                    }
                } else if (tempParent instanceof BPMEnd) {
                    return results;
                }
            }

            if (nodeMap.size() > 0) {
                results = new ArrayList();
                Iterator var11 = nodeMap.entrySet().iterator();

                while(var11.hasNext()) {
                    Entry<String, BPMHumenActivity> entry = (Entry)var11.next();
                    results.add((BPMHumenActivity)entry.getValue());
                }
            }
        }

        return results;
    }

    public static List<SubProcessSetting> createSubSettingFromStringArray(String process_subsetting) {
        List<SubProcessSetting> subSettingList = null;
        Object obj = JSONUtil.parseJSONString(process_subsetting);
        if (obj instanceof Map) {
            Map map = (Map)obj;
            if (map.size() > 0) {
                subSettingList = new ArrayList();
                Iterator var5 = map.entrySet().iterator();

                while(true) {
                    while(var5.hasNext()) {
                        Object entryObj = var5.next();
                        Entry entry = (Entry)entryObj;
                        if (entry.getValue() instanceof List) {
                            List list = (List)entry.getValue();
                            Iterator var9 = list.iterator();

                            while(var9.hasNext()) {
                                Object object = var9.next();
                                SubProcessSetting setting = createSubSettingFromString(object);
                                if (setting != null) {
                                    subSettingList.add(setting);
                                }
                            }
                        } else {
                            SubProcessSetting setting = createSubSettingFromString(entry.getValue());
                            if (setting != null) {
                                subSettingList.add(setting);
                            }
                        }
                    }

                    return subSettingList;
                }
            }
        }

        return subSettingList;
    }

    public static String removeNFFlag(String processXml) {
        String newProcessXML = processXml;
        if (processXml != null) {
            BPMProcess process = BPMProcess.fromXML(processXml);
            List<BPMHumenActivity> nfNodeList = getAllNFList(process);
            if (nfNodeList != null && nfNodeList.size() > 0) {
                Iterator var5 = nfNodeList.iterator();

                while(var5.hasNext()) {
                    BPMHumenActivity node = (BPMHumenActivity)var5.next();
                    node.getSeeyonPolicy().setNF("0");
                }

                newProcessXML = process.toXML();
            }
        }

        return newProcessXML;
    }

    public static List<BPMHumenActivity> getAllNFList(BPMProcess process) {
        List<BPMHumenActivity> result = null;
        if (process != null) {
            result = new ArrayList();
            List<BPMAbstractNode> allNodes = process.getActivitiesList();
            if (allNodes != null && allNodes.size() > 0) {
                Iterator var4 = allNodes.iterator();

                while(var4.hasNext()) {
                    BPMAbstractNode node = (BPMAbstractNode)var4.next();
                    if (node.getNodeType().equals(NodeType.humen) && "1".equals(node.getSeeyonPolicy().getNF())) {
                        result.add((BPMHumenActivity)node);
                    }
                }
            }
        }

        return result;
    }

    public static TemplateIEMessageVO templateToVO(ProcessTemplete template) {
        TemplateIEMessageVO vo = new TemplateIEMessageVO();
        if (template != null) {
            vo = new TemplateIEMessageVO();
            vo.setTemplateId(String.valueOf(template.getId()));
            vo.setWorkflow(template.getWorkflow());
        }

        return vo;
    }

    public static List<TemplateIEMessageVO> templateListToVOList(List<ProcessTemplete> templeteList) {
        List<TemplateIEMessageVO> voList = null;
        if (templeteList != null && templeteList.size() > 0) {
            voList = new ArrayList();
            Iterator var3 = templeteList.iterator();

            while(var3.hasNext()) {
                ProcessTemplete templete = (ProcessTemplete)var3.next();
                TemplateIEMessageVO vo = templateToVO(templete);
                if (vo != null) {
                    voList.add(vo);
                }
            }
        }

        return voList;
    }

    private static SubProcessSetting createSubSettingFromString(Object object) {
        SubProcessSetting result = null;
        if (object != null) {
            if (object instanceof Map) {
                Map map = (Map)object;
                result = new SubProcessSetting();
                result.setNodeId(String.valueOf(map.get("nodeId")));
                result.setNewflowTempleteId(Long.parseLong(String.valueOf(map.get("newflowTempleteId"))));
                result.setNewflowSender(String.valueOf(map.get("newflowSender")));
                result.setTriggerCondition(String.valueOf(map.get("triggerCondition")));
                result.setConditionTitle(String.valueOf(map.get("conditionTitle")));
                result.setConditionBase(String.valueOf(map.get("conditionBase")));
                result.setIsForce("true".equals(String.valueOf(map.get("isForce"))));
                result.setFlowRelateType(Integer.parseInt(String.valueOf(map.get("flowRelateType"))));
                result.setIsCanViewMainFlow("true".equals(String.valueOf(map.get("isCanViewMainFlow"))));
                result.setIsCanViewByMainFlow("true".equals(String.valueOf(map.get("isCanViewByMainFlow"))));
                result.setSubject(String.valueOf(map.get("subject")));
            } else {
                String string = object.toString();
                if (string != null && string.trim().length() > 0) {
                    String[] attrs = string.split("@");
                    if (attrs != null && attrs.length > 0) {
                        result = new SubProcessSetting();
                        result.setNodeId(attrs[0]);
                        result.setNewflowTempleteId(Long.parseLong(attrs[1]));
                        result.setNewflowSender(attrs[2]);
                        result.setTriggerCondition(attrs[3]);
                        result.setConditionTitle(attrs[4]);
                        result.setConditionBase(attrs[5]);
                        result.setIsForce("true".equals(attrs[6]));
                        result.setFlowRelateType(Integer.parseInt(attrs[7]));
                        result.setIsCanViewMainFlow("true".equals(attrs[8]));
                        result.setIsCanViewByMainFlow("true".equals(attrs[9]));
                    }
                }
            }
        }

        return result;
    }

    public static boolean isVerifyPolicy(String policyId) {
        boolean result = false;
        if (WorkFlowFinal.CANOT_REPEAL_POLICY_IDS != null && WorkFlowFinal.CANOT_REPEAL_POLICY_IDS.length > 0) {
            String[] var5 = WorkFlowFinal.CANOT_REPEAL_POLICY_IDS;
            int var4 = WorkFlowFinal.CANOT_REPEAL_POLICY_IDS.length;

            for(int var3 = 0; var3 < var4; ++var3) {
                String temp = var5[var3];
                if (temp.equals(policyId)) {
                    result = true;
                    break;
                }
            }
        }

        return result;
    }

    public static List<String> checkPrevNodeHasNewflow(BPMActivity activity, BPMCase theCase) throws BPMException {
        List<String> result = new ArrayList();
        if (activity != null) {
            List upTransitions = activity.getUpTransitions();
            checkPrevNodeHasNewflowHelper(upTransitions, result, theCase);
        }

        return result;
    }

    private static void checkPrevNodeHasNewflowHelper(List upTransitions, List<String> result, BPMCase theCase) throws BPMException {
        if (upTransitions != null) {
            for(int i = 0; i < upTransitions.size(); ++i) {
                BPMTransition trans = (BPMTransition)upTransitions.get(i);
                BPMAbstractNode from = trans.getFrom();
                String isDelete = getNodeConditionFromCase(theCase, from, "isDelete");
                if ("false".equals(isDelete)) {
                    if (from.getNodeType().equals(NodeType.start)) {
                        return;
                    }

                    if (!from.getNodeType().equals(NodeType.split) && !from.getNodeType().equals(NodeType.join)) {
                        if (from.getNodeType().equals(NodeType.humen)) {
                            if (!from.getSeeyonPolicy().getId().equals(BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getId()) && !from.getSeeyonPolicy().getId().equals(BPMSeeyonPolicy.EDOC_POLICY_ZHIHUI.getId())) {
                                if ("1".equals(from.getSeeyonPolicy().getNF())) {
                                    result.add(from.getId());
                                }
                            } else {
                                checkPrevNodeHasNewflowHelper(from.getUpTransitions(), result, theCase);
                            }
                        }
                    } else {
                        checkPrevNodeHasNewflowHelper(from.getUpTransitions(), result, theCase);
                    }
                }
            }
        }

    }

    public static String getNodeConditionFromCase(BPMCase theCase, BPMAbstractNode node, String key) {
        String isDelete = "";
        String nodeId = node.getId();
        Object result = null;
        if (theCase != null) {
            result = theCase.getData("wf_node_condition_change_key");
        }

        Map<String, Map<String, String>> myMap = result == null ? new HashMap() : (Map)result;
        if (((Map)myMap).get(nodeId) != null && ((Map)((Map)myMap).get(nodeId)).get(key) != null) {
            isDelete = (String)((Map)((Map)myMap).get(nodeId)).get(key);
        }

        if (Strings.isBlank(isDelete) && "isDelete".equals(key)) {
            isDelete = node.getSeeyonPolicy().getIsDelete();
        }

        if (Strings.isBlank(isDelete) && "isPass".equals(key)) {
            isDelete = node.getSeeyonPolicy().getIsPass();
        }

        return isDelete;
    }

    public static String getNodeConditionFromContext(WorkflowBpmContext context, BPMAbstractNode node, String key) {
        String isDelete = "";
        String nodeId = node.getId();
        Map<String, Map<String, String>> myMap = context.getNodeConditionChangeInfoMap();
        if (myMap.get(nodeId) != null && ((Map)myMap.get(nodeId)).get(key) != null) {
            isDelete = (String)((Map)myMap.get(nodeId)).get(key);
        }

        if (Strings.isBlank(isDelete) && "isDelete".equals(key)) {
            isDelete = node.getSeeyonPolicy().getIsDelete();
        }

        if (Strings.isBlank(isDelete) && "isPass".equals(key)) {
            isDelete = node.getSeeyonPolicy().getIsPass();
        }

        return isDelete;
    }

    public static void putNodeConditionToContext(WorkflowBpmContext context, BPMAbstractNode toNode, String key, String value) {
        Map<String, String> myMap = (Map)context.getNodeConditionChangeInfoMap().get(toNode.getId());
        if (myMap == null) {
            myMap = new HashMap();
        }

        ((Map)myMap).put(key, value);
        context.getNodeConditionChangeInfoMap().put(toNode.getId(), myMap);
        if ("isDelete".equals(key)) {
            toNode.getSeeyonPolicy().setIsDelete(value);
        }

        if ("isPass".equals(key)) {
            toNode.getSeeyonPolicy().setIsPass(value);
        }

    }

    public static void putNodeAdditionToContext(WorkflowBpmContext context, String nodeId, BPMParticipant party, String key, String value) {
        if ("addition".equals(key)) {
            context.getNodeAdditionMap().put(nodeId, value);
        }

        if ("raddition".equals(key)) {
            context.getNodeRAdditionMap().put(nodeId, value);
        }

    }

    public static String getNodeAdditionFromContext(WorkflowBpmContext context, String nodeId, BPMParticipant party, String key) {
        String addition = "";
        if ("addition".equals(key)) {
            addition = (String)context.getNodeAdditionMap().get(nodeId);
            if (Strings.isBlank(addition)) {
                addition = party.getAddition();
            }
        }

        if ("raddition".equals(key)) {
            addition = (String)context.getNodeRAdditionMap().get(nodeId);
            if (Strings.isBlank(addition)) {
                addition = party.getRaddition();
            }
        }

        return addition;
    }

    public static String getNodeAdditionFromCase(BPMCase theCase, String nodeId, BPMParticipant party, String key) {
        String addition = "";
        Object result = null;
        Object myMap;
        if ("addition".equals(key)) {
            if (theCase != null) {
                result = theCase.getData("wf_node_addition_key");
            }

            myMap = result == null ? new HashMap() : (Map)result;
            addition = (String)((Map)myMap).get(nodeId);
            if (Strings.isBlank(addition)) {
                addition = party.getAddition();
            }
        }

        if ("raddition".equals(key)) {
            if (theCase != null) {
                result = theCase.getData("wf_node_raddition_key");
            }

            myMap = result == null ? new HashMap() : (Map)result;
            addition = (String)((Map)myMap).get(nodeId);
            if (Strings.isBlank(addition)) {
                addition = party.getRaddition();
            }
        }

        return addition;
    }

    public static List<BPMTransition> getAllConditionLink(BPMProcess process) {
        return getAllChildConditionLink(process.getStart());
    }

    private static List<BPMTransition> getAllChildConditionLink(BPMAbstractNode node) {
        List<BPMTransition> result = new ArrayList();
        if (node != null) {
            if (node instanceof BPMEnd) {
                return result;
            }

            List<BPMTransition> downList = node.getDownTransitions();
            Map<String, BPMTransition> linkMap = new HashMap();
            Iterator var5;
            if (downList != null && downList.size() > 0) {
                var5 = downList.iterator();

                label80:
                while(true) {
                    List childDownList;
                    do {
                        do {
                            BPMTransition link;
                            do {
                                if (!var5.hasNext()) {
                                    break label80;
                                }

                                link = (BPMTransition)var5.next();
                            } while(link == null);

                            if (link != null && (1 == link.getConditionType() || 4 == link.getConditionType())) {
                                linkMap.put(link.getId(), link);
                            }

                            childDownList = getAllChildConditionLink(link.getTo());
                        } while(childDownList == null);
                    } while(childDownList.size() <= 0);

                    Iterator var8 = childDownList.iterator();

                    while(true) {
                        BPMTransition link2;
                        do {
                            do {
                                if (!var8.hasNext()) {
                                    continue label80;
                                }

                                link2 = (BPMTransition)var8.next();
                            } while(link2 == null);
                        } while(1 != link2.getConditionType() && 4 != link2.getConditionType());

                        linkMap.put(link2.getId(), link2);
                    }
                }
            }

            if (linkMap != null && linkMap.size() > 0) {
                var5 = linkMap.entrySet().iterator();

                while(var5.hasNext()) {
                    Entry<String, BPMTransition> entry = (Entry)var5.next();
                    result.add((BPMTransition)entry.getValue());
                }
            }
        }

        return result;
    }

    public static List<BPMHumenActivity> getChildHumens(BPMActivity activity) {
        List<BPMHumenActivity> humenList = getChildHumens(activity, true);
        return humenList;
    }

    public static List<BPMHumenActivity> getChildHumens(BPMActivity activity, boolean isPassInformNode) {
        List<BPMHumenActivity> humenList = new UniqueList();
        List<BPMTransition> transitions = activity.getDownTransitions();
        Iterator var5 = transitions.iterator();

        while(true) {
            while(var5.hasNext()) {
                BPMTransition trans = (BPMTransition)var5.next();
                BPMAbstractNode child = trans.getTo();
                String policy = child.getSeeyonPolicy().getId();
                if (child.getNodeType() == NodeType.humen && (policy.equals("inform") || policy.equals("zhihui"))) {
                    if (isPassInformNode) {
                        humenList.addAll(getChildHumens((BPMActivity)child));
                    } else {
                        humenList.add((BPMHumenActivity)child);
                    }
                } else if (child.getNodeType() == NodeType.humen) {
                    humenList.add((BPMHumenActivity)child);
                } else if (child.getNodeType() == NodeType.join || child.getNodeType() == NodeType.split) {
                    humenList.addAll(getChildHumens((BPMActivity)child, isPassInformNode));
                }
            }

            return humenList;
        }
    }

    public static boolean preIsSplitNode(BPMAbstractNode node) {
        boolean result = false;
        if (node != null) {
            List<BPMTransition> upLinks = node.getUpTransitions();
            if (upLinks != null && upLinks.size() > 0) {
                for(int i = 0; i < upLinks.size(); ++i) {
                    BPMAbstractNode rup = ((BPMTransition)upLinks.get(i)).getFrom();
                    if (rup instanceof BPMHumenActivity) {
                        if (ObjectName.isInformObject(rup)) {
                            boolean result1 = preIsSplitNode(rup);
                            if (result1) {
                                result = true;
                                break;
                            }
                        }
                    } else if (rup instanceof BPMAndRouter) {
                        BPMAndRouter joinOrSplit = (BPMAndRouter)rup;
                        if (joinOrSplit.isStartAnd()) {
                            result = true;
                            break;
                        }

                        boolean result1 = preIsSplitNode(rup);
                        if (result1) {
                            result = true;
                            break;
                        }
                    }
                }
            }
        }

        return result;
    }

    public static String getFirstNextSplitNode(BPMAbstractNode node) {
        String hst = "-1";
        if (node != null) {
            BPMAbstractNode finalNode = getFirstNextSplitNodeNode(node);
            if (finalNode != null) {
                hst = finalNode.getSeeyonPolicy().getHst();
            }
        }

        return hst;
    }

    public static BPMAbstractNode getFirstNextSplitNodeNode(BPMAbstractNode node) {
        boolean flag = true;
        BPMAbstractNode next = node;

        while(flag) {
            List<BPMTransition> downLinks = next.getDownTransitions();
            if (downLinks == null || downLinks.size() == 0) {
                break;
            }

            BPMAbstractNode rnext = ((BPMTransition)downLinks.get(0)).getTo();
            if (rnext instanceof BPMEnd) {
                break;
            }

            if (rnext instanceof BPMHumenActivity) {
                BPMHumenActivity current = (BPMHumenActivity)rnext;
                String policy = current.getSeeyonPolicy().getId();
                if (!"inform".equals(policy) && !"zhihui".equals(policy) && !"BlankNode".equals(node.getId())) {
                    break;
                }

                next = rnext;
            } else if (rnext instanceof BPMAndRouter) {
                BPMAndRouter joinOrSplit = (BPMAndRouter)rnext;
                if (joinOrSplit.isStartAnd()) {
                    if ("-1".equals(joinOrSplit.getSeeyonPolicy().getHst())) {
                        List<BPMTransition> joinDowns = joinOrSplit.getDownTransitions();
                        BPMAbstractNode nextJoin = null;
                        boolean find = true;
                        Iterator var10 = joinDowns.iterator();

                        while(var10.hasNext()) {
                            BPMTransition l = (BPMTransition)var10.next();
                            BPMAbstractNode lnext = l.getTo();
                            BPMAbstractNode nextTempJoin = getFirstNextSplitNodeNode(lnext);
                            if (nextJoin == null) {
                                nextJoin = nextTempJoin;
                            } else if (!nextJoin.equals(nextTempJoin)) {
                                break;
                            }
                        }

                        if (find) {
                            next = nextJoin;
                        }
                    } else {
                        next = rnext;
                    }
                    break;
                }

                next = rnext;
            }
        }

        return next;
    }

    public static List<BPMHumenActivity> getChildHumensWithoutDelete(BPMActivity activity, boolean isPassInformNode, BPMCase theCase) {
        List<BPMHumenActivity> humenList = new UniqueList();
        List<BPMTransition> transitions = activity.getDownTransitions();
        Iterator var6 = transitions.iterator();

        while(true) {
            while(true) {
                BPMAbstractNode child;
                String policy;
                String isDelete;
                do {
                    if (!var6.hasNext()) {
                        return humenList;
                    }

                    BPMTransition trans = (BPMTransition)var6.next();
                    child = trans.getTo();
                    BPMSeeyonPolicy seeyonPolicy = child.getSeeyonPolicy();
                    policy = seeyonPolicy.getId();
                    isDelete = getNodeConditionFromCase(theCase, child, "isDelete");
                } while(Strings.isNotBlank(isDelete) && "true".equals(isDelete.trim()));

                if (child.getNodeType() == NodeType.humen && (policy.equals("inform") || policy.equals("zhihui"))) {
                    if (isPassInformNode) {
                        humenList.addAll(getChildHumens((BPMActivity)child));
                    } else {
                        humenList.add((BPMHumenActivity)child);
                    }
                } else if (child.getNodeType() == NodeType.humen) {
                    humenList.add((BPMHumenActivity)child);
                } else if (child.getNodeType() == NodeType.join || child.getNodeType() == NodeType.split) {
                    humenList.addAll(getChildHumens((BPMActivity)child, isPassInformNode));
                }
            }
        }
    }

    public static List<BPMHumenActivity> findDirectHumenChildrenXNDX(BPMAbstractNode current_node, Map<String, String> condtionResult, Map<String, String> nodeTypes) {
        List<BPMHumenActivity> result = new ArrayList();
        String upCondition = (String)condtionResult.get(current_node.getId());
        String preForce = null;
        if (upCondition != null && upCondition.endsWith("↗1")) {
            upCondition = upCondition.substring(0, upCondition.indexOf("↗1"));
            preForce = "1";
        }

        String currentIsStart = "false";
        if ("start".equals(current_node.getId())) {
            currentIsStart = "true";
        }

        List<BPMTransition> down_links = current_node.getDownTransitions();
        Iterator var9 = down_links.iterator();

        while(true) {
            while(true) {
                while(var9.hasNext()) {
                    BPMTransition down_link = (BPMTransition)var9.next();
                    BPMAbstractNode toNode = down_link.getTo();
                    String isForce = preForce == null ? down_link.getIsForce() : preForce;
                    String currentCondition = down_link.getFormCondition();
                    String conditionBase = down_link.getConditionBase();
                    if (currentCondition != null) {
                        currentCondition = currentCondition.replaceAll("isNotRole", "isnotrole").replaceAll("isRole", "isrole").replaceAll("isPost", "ispost").replaceAll("isNotPost", "isNotpost");
                    }

                    if ("start".equals(conditionBase) && !"true".equals(currentIsStart)) {
                        currentCondition = currentCondition.replace("[Level]", "[startlevel]").replace("[Account]", "[startaccount]").replace("Concurrent_Acunt", "Start_ConcurrentAcunt").replace("Concurrent_Levl", "Start_ConcurrentLevl").replace("Account,Concurrent_Acunt", "startaccount,Start_ConcurrentAcunt").replace("Level,Concurrent_Levl", "startlevel,Start_ConcurrentLevl").replace("[StartMemberLoginAcuntLevl]", "[startStartMemberLoginAcuntLevl]");
                        currentCondition = currentCondition.replaceAll("Department", "startdepartment").replaceAll("Post", "startpost").replaceAll("Level", "startlevel").replaceAll("team", "startTeam").replaceAll("secondpost", "startSecondpost").replaceAll("Account", "startaccount").replaceAll("standardpost", "startStandardpost").replaceAll("grouplevel", "startGrouplevel").replaceAll("Role", "startrole").replaceAll("ispost", "isStartpost").replaceAll("isNotpost", "isNotStartpost").replaceAll("isNotDep", "isNotStartDep").replaceAll("isDep", "isStartDep");
                    }

                    if ("1".equals(isForce)) {
                        String str = (String)condtionResult.get(toNode.getId());
                        if (str != null && !"".equals(str)) {
                            String[] arr = str.split("↗");
                            if (arr != null) {
                                switch(arr.length) {
                                    case 3:
                                        isForce = null;
                                }
                            }
                        }
                    } else {
                        isForce = null;
                    }

                    NodeType nodeType = toNode.getNodeType();
                    if (nodeType.equals(NodeType.humen)) {
                        BPMHumenActivity hNode = (BPMHumenActivity)toNode;
                        result.add(hNode);
                        BPMSeeyonPolicy policy = hNode.getSeeyonPolicy();
                        boolean isNew = condtionResult.get(hNode.getId()) == null;
                        String nodeName = hNode.getBPMAbstractNodeName();
                        String currentConditionValue;
                        if (upCondition != null && !"".equals(upCondition)) {
                            if (upCondition.indexOf("↗") == -1) {
                                if (down_link.getConditionType() != 1 && down_link.getConditionType() != 4) {
                                    if (down_link.getConditionType() != 2) {
                                        condtionResult.put(hNode.getId(), nodeName + "↗" + upCondition);
                                    } else {
                                        currentConditionValue = "";
                                        if (currentCondition != null && !"".equals(currentCondition)) {
                                            currentConditionValue = nodeName + "↗(" + upCondition + ") && (handCondition)";
                                        } else {
                                            currentConditionValue = nodeName + "↗(" + upCondition + ")";
                                        }

                                        condtionResult.put(hNode.getId(), currentConditionValue);
                                    }
                                } else {
                                    currentConditionValue = "";
                                    if (currentCondition != null && !"".equals(currentCondition)) {
                                        currentConditionValue = nodeName + "↗(" + upCondition + ") && (" + currentCondition + ")";
                                    } else {
                                        currentConditionValue = nodeName + "↗(" + upCondition + ")";
                                    }

                                    condtionResult.put(hNode.getId(), currentConditionValue);
                                }
                            }
                        } else if (down_link.getConditionType() != 1 && down_link.getConditionType() != 4) {
                            if (down_link.getConditionType() == 2) {
                                condtionResult.put(hNode.getId(), nodeName + "↗handCondition");
                            }
                        } else {
                            condtionResult.put(hNode.getId(), nodeName + "↗" + currentCondition);
                        }

                        if (isNew) {
                            if (condtionResult.get("nodeCount") == null) {
                                condtionResult.put("nodeCount", "1");
                            } else {
                                int count = Integer.parseInt((String)condtionResult.get("nodeCount")) + 1;
                                condtionResult.put("nodeCount", String.valueOf(count));
                            }
                        }

                        if (policy != null) {
                            condtionResult.put("linkTo" + hNode.getId(), down_link.getId());
                        }

                        currentConditionValue = (String)condtionResult.get("order");
                        if (currentConditionValue == null) {
                            condtionResult.put("order", hNode.getId());
                        } else {
                            condtionResult.put("order", currentConditionValue + "$" + hNode.getId());
                        }

                        if (isForce != null && condtionResult.get(hNode.getId()) != null) {
                            condtionResult.put(hNode.getId(), (String)condtionResult.get(hNode.getId()) + "↗" + isForce);
                        }

                        if (policy != null && ("inform".equals(policy.getId()) || "zhihui".equals(policy.getId()))) {
                            nodeTypes.put(hNode.getId(), "inform");
                        } else {
                            nodeTypes.put(hNode.getId(), "normal");
                        }
                    } else if (!nodeType.equals(NodeType.split) && !nodeType.equals(NodeType.join)) {
                        if (nodeType.equals(NodeType.end)) {
                            return new ArrayList(0);
                        }
                    } else {
                        if (upCondition != null && !"".equals(upCondition)) {
                            if (down_link.getConditionType() != 1 && down_link.getConditionType() != 4) {
                                if (down_link.getConditionType() == 2) {
                                    condtionResult.put(toNode.getId(), "(" + upCondition + ")" + " && (handCondition)");
                                } else {
                                    condtionResult.put(toNode.getId(), upCondition);
                                }
                            } else {
                                condtionResult.put(toNode.getId(), "(" + upCondition + ")" + " && (" + currentCondition + ")");
                            }
                        } else if (down_link.getConditionType() != 1 && down_link.getConditionType() != 4) {
                            if (down_link.getConditionType() == 2) {
                                condtionResult.put(toNode.getId(), "(handCondition)");
                            } else {
                                condtionResult.put(toNode.getId(), upCondition);
                            }
                        } else {
                            String currentConditionValue = "";
                            if (currentCondition != null && !"".equals(currentCondition)) {
                                currentConditionValue = "(" + currentCondition + ")";
                            } else {
                                currentConditionValue = "";
                            }

                            condtionResult.put(toNode.getId(), currentConditionValue);
                        }

                        if (isForce != null) {
                            condtionResult.put(toNode.getId(), (String)condtionResult.get(toNode.getId()) + "↗" + isForce);
                        }

                        List<BPMHumenActivity> children = findDirectHumenChildrenXNDX(toNode, condtionResult, nodeTypes);
                        result.addAll(children);
                        condtionResult.remove(toNode.getId());
                    }
                }

                return result;
            }
        }
    }

    public static HashMap<String, Object> splitCondition(HashMap<String, String> hash) {
        HashMap<String, Object> result = new HashMap();
        Set<Entry<String, String>> entry = hash.entrySet();
        List<String> keys = new ArrayList();
        List<String> nodeNames = new ArrayList();
        List<String> conditions = new ArrayList();
        List<String> forces = new ArrayList();
        List<String> links = new ArrayList();
        String[] temp = (String[])null;
        String[] temp1 = (String[])null;
        String order = (String)hash.get("order");
        if (order != null && order.indexOf("$") != -1) {
            temp1 = StringUtils.split(order, "$");
        }

        StringBuffer sb = new StringBuffer();
        if (temp1 != null && temp1.length > 0) {
            String[] var15 = temp1;
            int var14 = temp1.length;

            for(int var18 = 0; var18 < var14; ++var18) {
                String item = var15[var18];
                String value = (String)hash.get(item);
                if (value != null && value.indexOf("↗") != -1) {
                    sb.append(item + ":");
                    keys.add(item);
                    links.add((String)hash.get("linkTo" + item));
                    temp = value.split("↗");
                    if (temp != null) {
                        nodeNames.add(temp[0]);
                        conditions.add(temp[1]);
                        if (temp.length == 3 && "1".equals(temp[2])) {
                            forces.add("true");
                        } else {
                            forces.add("false");
                        }
                    }
                }
            }
        } else {
            Iterator var13 = entry.iterator();

            while(var13.hasNext()) {
                Entry<String, String> item = (Entry)var13.next();
                if (item.getValue() != null && ((String)item.getValue()).indexOf("↗") != -1) {
                    sb.append((String)item.getKey() + ":");
                    keys.add((String)item.getKey());
                    links.add((String)hash.get("linkTo" + (String)item.getKey()));
                    temp = ((String)item.getValue()).split("↗");
                    if (temp != null) {
                        nodeNames.add(temp[0]);
                        conditions.add(temp[1]);
                        if (temp.length == 3) {
                            forces.add("true");
                        } else {
                            forces.add("false");
                        }
                    }
                }
            }
        }

        if (keys.size() > 0 && conditions.size() > 0) {
            result.put("allNodes", sb.toString());
            result.put("keys", keys);
            result.put("names", nodeNames);
            result.put("conditions", conditions);
            result.put("nodeCount", hash.get("nodeCount"));
            result.put("forces", forces);
            result.put("links", links);
        }

        return result;
    }
}
