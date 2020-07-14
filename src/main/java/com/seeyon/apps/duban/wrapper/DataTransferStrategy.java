package com.seeyon.apps.duban.wrapper;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.service.MappingService;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.vo.form.FormField;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import org.springframework.util.CollectionUtils;

import java.lang.reflect.Field;
import java.util.*;

/**
 * Created by liuwenping on 2019/11/7.
 */
public final class DataTransferStrategy {


    public static <T> T filledFtdValueByObjectType(Class<T> cls, Map data, FormTableDefinition ftd) {
        try {
            T obj = cls.newInstance();

            List<FormField> formFiledList = ftd.getFormTable().getFormFieldList();
            if (!CollectionUtils.isEmpty(formFiledList)) {
                //特殊的list值
                Map<String, Map> multiListContainer = new HashMap<String, Map>();

                for (FormField ff : formFiledList) {
                    String barcode = ff.getBarcode();
                    if (!CommonUtils.isEmpty(barcode)) {
                        //classname 不为空特殊处理
                        if (!CommonUtils.isEmpty(ff.getClassname())) {

                            if ("multi_list".equals(ff.getExport())) {
                                /**
                                 * barcode": "slaveDubanTaskList@com.seeyon.apps.duban.po.SlaveDubanTask",
                                 "export": "multi_list",
                                 "classname": "department@10@deptName",
                                 */
                                try {
                                    String[] barCodes = barcode.split("@");
                                    if (barCodes == null || barCodes.length < 2) {
                                        continue;
                                    }
                                    String[] classTokens = ff.getClassname().split("@");
                                    if (classTokens == null || classTokens.length < 3) {
                                        continue;
                                    }
                                    Map<String, Object> multiData = multiListContainer.get(barCodes[0]);
                                    if (multiData == null) {
                                        multiData = new HashMap<String, Object>();
                                        multiListContainer.put(barCodes[0], multiData);
                                    }
                                    Object val_ = data.get(ff.getName());
                                    String export_ = classTokens[0];
                                    String barCode_ = classTokens[2];

                                    String index_ = classTokens[1];
                                    if ("no".equals(barCode_)) {
                                        val_ = index_;
                                    }
                                    String clsName = barCodes[1];
                                    Class cls_ = Class.forName(clsName);
                                    Object obj_ = multiData.get(index_);
                                    if (obj_ == null) {
                                        obj_ = cls_.newInstance();
                                        multiData.put(index_, obj_);
                                    }
                                    Field f = getClassField(cls_, barCode_);
                                    if (f != null) {
                                        f.setAccessible(true);
                                        filledObject(f, obj_, export_, val_);
                                    }

                                } catch (Exception e) {

                                    e.printStackTrace();
                                }


                            }

                            continue;

                        } else {


                            //一般逻辑
                            Field f = getClassField(cls, barcode);
                            if (f != null) {
                                f.setAccessible(true);
                                String export = ff.getExport();
                                Object val = data.get(ff.getName());
                                filledObject(f, obj, export, val);
                            }
                        }

                    }
                }
                if (!CommonUtils.isEmpty(multiListContainer)) {

                    Set<String> keys = multiListContainer.keySet();
                    for (String key : keys) {
                        Map data_ = multiListContainer.get(key);
                        if (!CommonUtils.isEmpty(data_)) {
                            Field f = getClassField(cls, key);
                            Collection datas = data_.values();
                            f.setAccessible(true);
                            List list = new ArrayList();
                            list.addAll(datas);
                            f.set(obj, list);
                        }


                    }


                }

            }


            return obj;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    private static void filledObject(Field f, Object obj, String export, Object val) {
        try {
            if ("enum".equals(export)) {
                val = CommonUtils.getEnumShowValue(val);
            }
            if ("member".equals(export)) {
                Long mid = CommonUtils.getLong(val);
                if (mid != null) {
                    try {
                        V3xOrgMember member = CommonUtils.getOrgManager().getMemberById(mid);
                        if (member != null) {
                            val = member.getName();
                        }
                    } catch (Exception e) {

                    }
                }

            }
            if ("member_list".equals(export)) {
                String members = String.valueOf(val);
                if (!CommonUtils.isEmpty(members)) {
                    String[] membersArg = members.split(",");
                    List<String> memberList = new ArrayList<String>();
                    for (String mbers : membersArg) {
                        Long mid = CommonUtils.getLong(mbers);
                        if (mid == null) {
                            continue;
                        }
                        try {
                            V3xOrgMember member = CommonUtils.getOrgManager().getMemberById(mid);
                            if (member != null) {
                                memberList.add(member.getName());
                            }
                        } catch (Exception e) {

                        }
                    }
                    val = CommonUtils.join(memberList, ",");

                }

            }
            if ("department".equals(export)) {
                Long mid = CommonUtils.getLong(val);
                if (mid != null) {
                    try {
                        V3xOrgDepartment dept = CommonUtils.getOrgManager().getDepartmentById(mid);
                        if (dept != null) {
                            val = dept.getName();
                        }
                    } catch (Exception e) {

                    }
                }

            }
            if (f.getType() == Long.class) {
                f.setLong(obj, CommonUtils.getLong(val));
            } else if (f.getType() == String.class) {
                if (val == null) {
                    f.set(obj, "");
                } else {
                    f.set(obj, String.valueOf(val));
                }

            } else if(f.getType()==Date.class){
                String val_ = String.valueOf(val);
                Date dt = CommonUtils.parseDate(val_);
                f.set(obj, dt);
            }else{
                f.set(obj, val);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    private static Field getClassField(Class cls, String fieldName) {
        Field f = null;
        try {
            f = cls.getDeclaredField(fieldName);
            f.setAccessible(true);
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }
        if (f == null) {
            cls = cls.getSuperclass();
            while (cls != null) {
                try {
                    f = cls.getDeclaredField(fieldName);
                    if (f != null) {
                        break;
                    }
                } catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
                cls = cls.getSuperclass();

            }

        }

        return f;

    }


    public static void main(String[] args) {
        String data = "{\n" +
                "            \"ID\": \"6006856691204055558\",\n" +
                "            \"state\": \"1\",\n" +
                "            \"start_member_id\": \"4539057419316513978\",\n" +
                "            \"start_date\": \"7/11/2019 12:14:12\",\n" +
                "            \"approve_member_id\": \"0\",\n" +
                "            \"approve_date\": \"7/11/2019 12:13:10\",\n" +
                "            \"finishedflag\": \"0\",\n" +
                "            \"ratifyflag\": \"0\",\n" +
                "            \"ratify_member_id\": \"0\",\n" +
                "            \"ratify_date\": \"\",\n" +
                "            \"sort\": \"0\",\n" +
                "            \"modify_member_id\": \"4539057419316513978\",\n" +
                "            \"modify_date\": \"7/11/2019 12:23:52\",\n" +
                "            \"field0001\": \"2019110700003\",\n" +
                "            \"field0002\": \"681414739367841537\",\n" +
                "            \"field0003\": \"-9060139754049026412\",\n" +
                "            \"field0004\": \"集团任务督办\",\n" +
                "            \"field0005\": \"按集团要求完成\",\n" +
                "            \"field0006\": \"6937357795156968839\",\n" +
                "            \"field0007\": \"31/12/2019\",\n" +
                "            \"field0008\": \"-1328139057052299698\",\n" +
                "            \"field0009\": \"\",\n" +
                "            \"field0010\": \"-2990144099836671923\",\n" +
                "            \"field0011\": \"-8524830509111950591,-5523832285393039950\",\n" +
                "            \"field0012\": \"4539057419316513978\",\n" +
                "            \"field0013\": \"\",\n" +
                "            \"field0014\": \"\",\n" +
                "            \"field0015\": \"\",\n" +
                "            \"field0016\": \"\",\n" +
                "            \"field0017\": \"6911374949904761279\",\n" +
                "            \"field0018\": \"80\",\n" +
                "            \"field0019\": \"-298463695659972307\",\n" +
                "            \"field0020\": \"\",\n" +
                "            \"field0021\": \"\",\n" +
                "            \"field0022\": \"\",\n" +
                "            \"field0023\": \"1\",\n" +
                "            \"field0024\": \"-2417073550831697731\",\n" +
                "            \"field0025\": \"10\",\n" +
                "            \"field0026\": \"6303864327864664914\",\n" +
                "            \"field0027\": \"\",\n" +
                "            \"field0028\": \"\",\n" +
                "            \"field0029\": \"\",\n" +
                "            \"field0030\": \"1\",\n" +
                "            \"field0031\": \"-3565537035546179393\",\n" +
                "            \"field0032\": \"5\",\n" +
                "            \"field0033\": \"7855655465727249028\",\n" +
                "            \"field0034\": \"\",\n" +
                "            \"field0035\": \"\",\n" +
                "            \"field0036\": \"\",\n" +
                "            \"field0037\": \"1\",\n" +
                "            \"field0038\": \"3380002593912996096\",\n" +
                "            \"field0039\": \"5\",\n" +
                "            \"field0040\": \"-3695111546401830688\",\n" +
                "            \"field0041\": \"\",\n" +
                "            \"field0042\": \"\",\n" +
                "            \"field0043\": \"\",\n" +
                "            \"field0044\": \"0\",\n" +
                "            \"field0045\": \"\",\n" +
                "            \"field0046\": \"0\",\n" +
                "            \"field0047\": \"\",\n" +
                "            \"field0048\": \"\",\n" +
                "            \"field0049\": \"\",\n" +
                "            \"field0050\": \"\",\n" +
                "            \"field0051\": \"0\",\n" +
                "            \"field0052\": \"\",\n" +
                "            \"field0053\": \"0\",\n" +
                "            \"field0054\": \"\",\n" +
                "            \"field0055\": \"\",\n" +
                "            \"field0056\": \"\",\n" +
                "            \"field0057\": \"\",\n" +
                "            \"field0058\": \"0\",\n" +
                "            \"field0059\": \"\",\n" +
                "            \"field0060\": \"0\",\n" +
                "            \"field0061\": \"\",\n" +
                "            \"field0062\": \"\",\n" +
                "            \"field0063\": \"\",\n" +
                "            \"field0064\": \"\",\n" +
                "            \"field0065\": \"0\",\n" +
                "            \"field0066\": \"\",\n" +
                "            \"field0067\": \"0\",\n" +
                "            \"field0068\": \"\",\n" +
                "            \"field0069\": \"\",\n" +
                "            \"field0070\": \"\",\n" +
                "            \"field0071\": \"\",\n" +
                "            \"field0072\": \"0\",\n" +
                "            \"field0073\": \"\",\n" +
                "            \"field0074\": \"0\",\n" +
                "            \"field0075\": \"\",\n" +
                "            \"field0076\": \"\",\n" +
                "            \"field0077\": \"\",\n" +
                "            \"field0078\": \"\",\n" +
                "            \"field0079\": \"0\",\n" +
                "            \"field0080\": \"\",\n" +
                "            \"field0081\": \"0\",\n" +
                "            \"field0082\": \"\",\n" +
                "            \"field0083\": \"\",\n" +
                "            \"field0084\": \"\",\n" +
                "            \"field0085\": \"\",\n" +
                "            \"field0086\": \"0\",\n" +
                "            \"field0087\": \"\",\n" +
                "            \"field0088\": \"0\",\n" +
                "            \"field0089\": \"\",\n" +
                "            \"field0090\": \"\",\n" +
                "            \"field0091\": \"\",\n" +
                "            \"field0092\": \"\",\n" +
                "            \"field0093\": \"\",\n" +
                "            \"field0094\": \"收到。\",\n" +
                "            \"field0095\": \"-2417073550831697731\",\n" +
                "            \"field0096\": \"-658568178801950423\",\n" +
                "            \"field0097\": \"7/11/2019\",\n" +
                "            \"field0098\": \"已签收。\",\n" +
                "            \"field0099\": \"-3565537035546179393\",\n" +
                "            \"field0100\": \"-1046765851205939806\",\n" +
                "            \"field0101\": \"7/11/2019\",\n" +
                "            \"field0102\": \"按时完成任务\",\n" +
                "            \"field0103\": \"6911374949904761279\",\n" +
                "            \"field0104\": \"8415179587609578779\",\n" +
                "            \"field0105\": \"7/11/2019\",\n" +
                "            \"field0106\": \"OK。\",\n" +
                "            \"field0107\": \"3380002593912996096\",\n" +
                "            \"field0108\": \"-3695111546401830688\",\n" +
                "            \"field0109\": \"7/11/2019\",\n" +
                "            \"field0110\": \"\",\n" +
                "            \"field0111\": \"\",\n" +
                "            \"field0112\": \"\",\n" +
                "            \"field0113\": \"\",\n" +
                "            \"field0114\": \"\",\n" +
                "            \"field0115\": \"\",\n" +
                "            \"field0116\": \"\",\n" +
                "            \"field0117\": \"\",\n" +
                "            \"field0118\": \"\",\n" +
                "            \"field0119\": \"\",\n" +
                "            \"field0120\": \"\",\n" +
                "            \"field0121\": \"\",\n" +
                "            \"field0122\": \"\",\n" +
                "            \"field0123\": \"\",\n" +
                "            \"field0124\": \"\",\n" +
                "            \"field0125\": \"\",\n" +
                "            \"field0126\": \"\",\n" +
                "            \"field0127\": \"\",\n" +
                "            \"field0128\": \"\",\n" +
                "            \"field0129\": \"\",\n" +
                "            \"field0130\": \"\",\n" +
                "            \"field0131\": \"\",\n" +
                "            \"field0132\": \"\",\n" +
                "            \"field0133\": \"\",\n" +
                "            \"field0134\": \"\",\n" +
                "            \"field0135\": \"\",\n" +
                "            \"field0136\": \"\",\n" +
                "            \"field0137\": \"\",\n" +
                "            \"field0142\": \"-1804267680213545464\"\n" +
                "        }";

        Map data2 = JSON.parseObject(data, HashMap.class);
        data2.put("start_date", new Date());
        data2.put("field0022", new Date());
        data2.put("field0015", new Date());
        data2.put("field0007", new Date());

        DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, data2, MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK));
        System.out.println(JSON.toJSONString(task));
    }
}
