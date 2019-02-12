package com.seeyon.apps.doc.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.doc.dao.DocMetadataDao;
import com.seeyon.apps.doc.dao.DocResourceDao;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.vo.DocSearchModel;
import com.seeyon.apps.doc.vo.SimpleDocQueryModel;
import com.seeyon.apps.edoc.bo.EdocElementBO;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.Strings;
import com.thoughtworks.xstream.XStream;


/**
 * 文档简单属性、高级组合查询工具类，用于解析查询条件并获取列表结果
 * @author <a href="mailto:yangm@seeyon.com">Rookie Young</a> 2010-12-24
 */
public class DocSearchHqlUtils {
	private static final Log logger = LogFactory.getLog(DocSearchHqlUtils.class);
	private static final XStream xStream4Debug             = new XStream();
	
	/**
	 * Hql语句中对文档类型部分的约束条件，约定文档主表别名为"d"
	 */
	public static final String HQL_FR_TYPE = " and d.frType!=" + Constants.FOLDER_PLAN
											+ " and d.frType!=" + Constants.FOLDER_TEMPLET
											+ " and d.frType!=" + Constants.FOLDER_BORROW
											+ " and d.frType!=" + Constants.FOLDER_SHARE
											+ " and d.frType!=" + Constants.FOLDER_SHAREOUT
											+ " and d.frType!=" + Constants.FOLDER_BORROWOUT
											+ " and d.frType!=" + Constants.FOLDER_PLAN_WORK
											+ " and d.frType!=" + Constants.FOLDER_PLAN_DAY
											+ " and d.frType!=" + Constants.FOLDER_PLAN_MONTH
											+ " and d.frType!=" + Constants.FOLDER_PLAN_WEEK;
	
	/**
	 * Hql语句中对所得结果的排序条件，约定文档主表别名为"d"，按照最后修改时间降序、排序字段升序排列
	 */
	public static String Order_By_Query = " order by d.lastUpdate desc, d.frOrder ";

	@SuppressWarnings("unchecked")
	public static List<DocResourcePO> searchByProperties(DocResourcePO dr, DocSearchModel dsm, DocResourceDao docResourceDao, DocMetadataDao docMetadataDao,boolean isNew,Integer pageNo) throws BusinessException {
		Map<String, Object> params = CommonTools.newHashMap("logicalPath", dr.getLogicalPath() + ".%");
		StringBuilder hql2 = searchByProperties(dsm, params);
		return docMetadataDao.find(hql2.toString() + HQL_FR_TYPE + Order_By_Query, -1, -1, params);
	}
	
	@SuppressWarnings("unchecked")
	public static List<DocResourcePO> searchByPropertiesDA(DocResourcePO dr, DocSearchModel dsm, DocResourceDao docResourceDao, DocMetadataDao docMetadataDao,boolean isNew,Integer pageNo) throws BusinessException {
		Map<String, Object> params = new HashMap<String, Object>();
		StringBuilder hql2 = searchByPropertiesDA(dsm, params);
		return docMetadataDao.find(hql2.toString() + HQL_FR_TYPE + Order_By_Query, -1, -1, params);
	}
	@SuppressWarnings("unchecked")
	public static List<DocResourcePO> searchByProperties4XZ(DocSearchModel dsm, DocResourceDao docResourceDao, DocMetadataDao docMetadataDao,boolean isNew,Integer pageNo) throws BusinessException {
		if (logger.isDebugEnabled()) {
			logger.debug("[高级查询条件]:\n" + xStream4Debug.toXML(dsm));
		}
		
		List<SimpleDocQueryModel> metaDataQs = dsm.getMetaDataQueries();
		List<SimpleDocQueryModel> simpleQs = dsm.getSimplePropertyQueries();
		boolean hasMetaDataQ = CollectionUtils.isNotEmpty(metaDataQs);
		boolean hasSimpleQ = CollectionUtils.isNotEmpty(simpleQs);
		boolean hasMetaDataQData = false;
		StringBuilder hql2 = new StringBuilder("select d from "+ DocResourcePO.class.getName()+" as d ");
		if(hasMetaDataQ) {	
			hasMetaDataQData = hasSearchData(metaDataQs);
			for(SimpleDocQueryModel sdm : metaDataQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql2.append(" ,OrgMember as " + sdm.getPropertyName() + "PO");
				}
			}
		}		
		if(hasSimpleQ) {
			for(SimpleDocQueryModel sdm : simpleQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql2.append(" ,OrgMember as " + sdm.getPropertyName() + "PO");
				}
			}
		}		
		Map<String, Object> params =  new HashMap<String, Object>();
		// 仅有简单属性查询
		hql2.append(" where d.isFolder = false ");
		for(SimpleDocQueryModel sdm : simpleQs) {
			if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
				hql2.append(" and d." + sdm.getPropertyName() + "=" + sdm.getPropertyName() + "PO.id");
			}
		}
		parseProperties4Hql(hql2, simpleQs, params, " d.");
		logger.info(hql2.toString() + HQL_FR_TYPE + Order_By_Query+"-------"+params);
		return docMetadataDao.find(hql2.toString() + HQL_FR_TYPE + Order_By_Query, -1, -1, params);
	}
	
	private static boolean hasSearchData(List<SimpleDocQueryModel> sdms) {
		for(SimpleDocQueryModel sdm : sdms) {
			if(Strings.isNotEmpty(sdm.getValue1())) {
				return true;
			}
			if(Strings.isNotEmpty(sdm.getValue2())) {
				return true;
			}
		}
		return false;
	}
	
	public static final String[] EDOCTABNAMES = { "EdocSummary", "EdocSummaryExtend" };
    public static final String[] EDOCTABPKS   = { "id", "summaryId" };
	
    private static void parseTab4Hql(StringBuilder hql, List<SimpleDocQueryModel> sdms) throws BusinessException {
        if (CollectionUtils.isNotEmpty(sdms)) {
            List<String> poNames = new ArrayList<String>();
            List<String> aliasPoNames = new ArrayList<String>();
            for (SimpleDocQueryModel sdm : sdms) {
                if (sdm.getPropertyName().startsWith("edoc_")) {
                    String edocElementPoName = sdm.getPropertyName().substring("edoc_".length());
                    EdocElementBO edocElement = DocMVCUtils.getEdocApi().getEdocElementByFiledName(edocElementPoName);
                    String aliasTable = "_" + edocElement.getPoName().toLowerCase();
                    if (!poNames.contains(edocElement.getPoName()) && (Strings.isNotBlank(sdm.getValue1())||Strings.isNotBlank(sdm.getValue2())||Strings.isNotBlank(sdm.getValue3()))) {
                        poNames.add(edocElement.getPoName());//tableName
                        aliasPoNames.add(aliasTable);// _tableName
                    }
                }
            }
            
            for (int i = 0; i < poNames.size(); i++) {
                hql.append(",").append(poNames.get(i)).append(" as ").append(aliasPoNames.get(i));
            }
            
            if (!poNames.isEmpty()) {
                hql.append(" where ");
            }
            
            for (int i = 0; i < aliasPoNames.size(); i++) {
                if (i != 0) {
                    hql.append(" = ");
                }
                int index = Arrays.binarySearch(DocSearchHqlUtils.EDOCTABNAMES, poNames.get(i), new StringComparator());
                hql.append(aliasPoNames.get(i)).append(".").append(DocSearchHqlUtils.EDOCTABPKS[index]);
            }
            
            if (!poNames.isEmpty()) {
                if (poNames.size() > 1) {
                    hql.append(" and ");
                    int index = Arrays.binarySearch(DocSearchHqlUtils.EDOCTABNAMES, poNames.get(0), new StringComparator());
                    hql.append(aliasPoNames.get(0)).append(".").append(DocSearchHqlUtils.EDOCTABPKS[index]);
                }
                hql.append(" = d.sourceId ");
            }
        }
    }
    
    private static class StringComparator implements Comparator<String> {
        @Override
        public int compare(String s1, String s2) {
            return s1.equals(s2) ? 0 : -1;
        }
    }
	
	private static void parseProperties4Hql(StringBuilder hql, List<SimpleDocQueryModel> sdms, Map<String, Object> params, String as) throws BusinessException {
		if(CollectionUtils.isNotEmpty(sdms)) {
			for(SimpleDocQueryModel sdm : sdms) {
			    if(sdm.getPropertyName().startsWith("edoc_")){
		            String edocElementName = sdm.getPropertyName().substring("edoc_".length());
                    EdocElementBO edocElement = DocMVCUtils.getEdocApi().getEdocElementByFiledName(edocElementName);
                    String _as = "_" + edocElement.getPoName().toLowerCase()+".";
                    String sdmPropertyName = sdm.getPropertyName();
                    sdm.setPropertyName(edocElement.getPoFieldName());
                    parseSingleProperty4Hql(hql, sdm, params, _as);
                    sdm.setPropertyName(sdmPropertyName);
			    }else{
			        parseSingleProperty4Hql(hql, sdm, params, as);
			    }
			}
		}
	}
	/**
	 * 将单个属性查询的约束条件拼接到Hql语句中，并将命名变量键值对设定好
	 * @param hql	主hql语句
	 * @param sdm	查询条件
	 * @param params	命名变量键值Map
	 */
	private static void parseSingleProperty4Hql(StringBuilder hql, SimpleDocQueryModel sdm, Map<String, Object> params, String as) {
		if(sdm == null || Strings.isBlank(sdm.getPropertyName()))
			throw new IllegalArgumentException("这位大侠，您给出的文档查询条件无效，恕洒家无法给力...");
		
		String propertyName = sdm.getPropertyName();
		int type = sdm.getPropertyType();
		String and = " and ";
		switch(type) {
		case Constants.DATE :
		case Constants.DATETIME :
			if(Strings.isNotBlank(sdm.getValue1())) {
				hql.append(and + as + propertyName + " >= :" + propertyName + "startDate ");
				params.put(propertyName + "startDate", Datetimes.getTodayFirstTime(sdm.getValue1()));
			}
			
			if(Strings.isNotBlank(sdm.getValue2())) {
				hql.append(and + as + propertyName + " <= :" + propertyName + "endDate ");
				params.put(propertyName + "endDate", Datetimes.getTodayLastTime(sdm.getValue2()));
			}	
			break;
		case Constants.USER_ID :
			if(Strings.isNotBlank(sdm.getValue1())) {
				hql.append(and + propertyName + "PO.name like :" + propertyName + "Value ");
				params.put(propertyName + "Value", "%" + SQLWildcardUtil.escape(sdm.getValue1().trim()) + "%");
			}
			break;
		case Constants.DEPT_ID :
		case Constants.REFERENCE :
		case Constants.CONTENT_TYPE :
		case Constants.ENUM :
		case Constants.SIZE :
		case Constants.IMAGE_ID :
			Long value = NumberUtils.toLong(sdm.getValue1(), -1l);
			if(value != -1l) {
				hql.append(and + as + propertyName + " = :" + propertyName + "Value ");
				params.put(propertyName + "Value", value);
			}
			break;
		case Constants.EDOCENUM :
                if (Strings.isNotBlank(sdm.getValue1())) {
                    hql.append(and + as + propertyName + " = :" + propertyName + "Value ");
                    Object value1 = SQLWildcardUtil.escape(sdm.getValue1().trim());
                    if ("keepPeriod".equals(propertyName)) {
                        value1 = Integer.valueOf(value1.toString());
                    }
                    params.put(propertyName + "Value", value1);
                }
            break;
		case Constants.TEXT_ONE_LINE :
		case Constants.TEXT :
			if(Strings.isNotBlank(sdm.getValue1())) {
				hql.append(and + as + propertyName + " like :" + propertyName + "Value ");
				params.put(propertyName + "Value", "%" + SQLWildcardUtil.escape(sdm.getValue1().trim()) + "%");
			}
			break;
		case Constants.INTEGER :
			hql.append(and + as + propertyName + " = :" + propertyName + "Value ");
			params.put(propertyName + "Value", NumberUtils.toInt(sdm.getValue1()));
			break;
		case Constants.BOOLEAN :
			if(Strings.isNotBlank(sdm.getValue1())) {
				hql.append(and + as + propertyName + " = :" + propertyName + "Value ");
				params.put(propertyName + "Value", BooleanUtils.toBoolean(sdm.getValue1()));
			}
			break;
		case Constants.FLOAT :
			if(Strings.isNotBlank(sdm.getValue1())) {
				hql.append(and + as + propertyName + " = :" + propertyName + "Value ");
				params.put(propertyName + "Value", NumberUtils.toDouble(sdm.getValue1()));
			}
			break;
		}
	}

	/**
	 * 用于共享文档和借阅文档的查询
	 * @param logicPaths
	 * @param dsm
	 * @param params
	 * @return
	 * @throws BusinessException
	 */
	public static StringBuilder searchByProperties(DocSearchModel dsm, Map<String, Object> params) throws BusinessException {
		if (logger.isDebugEnabled()) {
			logger.debug("[高级查询条件]:\n" + xStream4Debug.toXML(dsm));
		}
		
		List<SimpleDocQueryModel> metaDataQs = dsm.getMetaDataQueries();
		List<SimpleDocQueryModel> simpleQs = dsm.getSimplePropertyQueries();
		boolean hasMetaDataQ = CollectionUtils.isNotEmpty(metaDataQs);
		boolean hasSimpleQ = CollectionUtils.isNotEmpty(simpleQs);
		boolean hasMetaDataQData = false;
		StringBuilder hql2 = new StringBuilder("select d from "+ DocResourcePO.class.getName()+" as d ");
		if(hasMetaDataQ) {	
			hasMetaDataQData = hasSearchData(metaDataQs);
			for(SimpleDocQueryModel sdm : metaDataQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql2.append(" ,OrgMember as " + sdm.getPropertyName() + "PO");
				}
			}
		}		
		if(hasSimpleQ) {
			for(SimpleDocQueryModel sdm : simpleQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql2.append(" ,OrgMember as " + sdm.getPropertyName() + "PO");
				}
			}
		}
		
		if (hasMetaDataQ) {// 扩展属性 + 简单属性查询 或 扩展属性查询
			StringBuilder hql1 = null;
			if(hasMetaDataQData){
			    hql1 = new StringBuilder(" , DocMetadata as dm ");
			    parseTab4Hql(hql1,metaDataQs);
                if (hql1.indexOf("where") == -1) {
                    hql1.append(" where 1=1 ");
                }
                hql1.append(" and d.id=dm.id and d.logicalPath like :logicalPath");
			}else if(hasMetaDataQData) {
				hql1 = new StringBuilder(" , DocMetadata as dm where d.id=dm.id and d.logicalPath like :logicalPath");
			} else {
			    hql1 = new StringBuilder();
			    parseTab4Hql(hql1,metaDataQs);
			    if(hql1.indexOf("where")==-1){
			        hql1.append(" where 1=1 ");
			    }
				hql1.append(" and d.logicalPath like :logicalPath");
			}
			for(SimpleDocQueryModel sdm : metaDataQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql1.append(" and dm." + sdm.getPropertyName() + "=" + sdm.getPropertyName() + "PO.id");
				}
			}
			parseProperties4Hql(hql1, metaDataQs, params, " dm.");
			hql2.append(hql1);
			if (hasSimpleQ) {
				for(SimpleDocQueryModel sdm : simpleQs) {
					if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
						hql2.append(" and d." + sdm.getPropertyName() + "=" + sdm.getPropertyName() + "PO.id");
					}
				}
				parseProperties4Hql(hql2, simpleQs, params, " d.");
			}
		} else {// 仅有简单属性查询
			hql2.append(" where d.logicalPath like :logicalPath ");
			for(SimpleDocQueryModel sdm : simpleQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql2.append(" and d." + sdm.getPropertyName() + "=" + sdm.getPropertyName() + "PO.id");
				}
			}
			parseProperties4Hql(hql2, simpleQs, params, " d.");
		}
		
		return hql2;
	}
	
	
	/**
	 * 用于共享文档和借阅文档的查询 客开 赵辉 重写方法
	 * @param logicPaths
	 * @param dsm
	 * @param params
	 * @return
	 * @throws BusinessException  
	 */
	public static StringBuilder searchByPropertiesDA(DocSearchModel dsm, Map<String, Object> params) throws BusinessException {
		if (logger.isDebugEnabled()) {
			logger.debug("[高级查询条件]:\n" + xStream4Debug.toXML(dsm));
		}
		
		List<SimpleDocQueryModel> metaDataQs = dsm.getMetaDataQueries();
		List<SimpleDocQueryModel> simpleQs = dsm.getSimplePropertyQueries();
		boolean hasMetaDataQ = CollectionUtils.isNotEmpty(metaDataQs);
		boolean hasSimpleQ = CollectionUtils.isNotEmpty(simpleQs);
		boolean hasMetaDataQData = false;
		StringBuilder hql2 = new StringBuilder("select d from "+ DocResourcePO.class.getName()+" as d ");
		if(hasMetaDataQ) {
			hasMetaDataQData = hasSearchData(metaDataQs);
			for(SimpleDocQueryModel sdm : metaDataQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql2.append(" ,OrgMember as " + sdm.getPropertyName() + "PO");
				}
			}
		}		
		if(hasSimpleQ) {
			for(SimpleDocQueryModel sdm : simpleQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql2.append(" ,OrgMember as " + sdm.getPropertyName() + "PO");
				}
			}
		}
		
		if (hasMetaDataQ) {// 扩展属性 + 简单属性查询 或 扩展属性查询
			StringBuilder hql1 = null;
			if(hasMetaDataQData){
			    hql1 = new StringBuilder(" , DocMetadata as dm ");
			    parseTab4Hql(hql1,metaDataQs);
                if (hql1.indexOf("where") == -1) {
                    hql1.append(" where 1=1 ");
                }
                hql1.append(" and d.id=dm.id ");//and d.logicalPath like :logicalPath
			}else if(hasMetaDataQData) {
				hql1 = new StringBuilder(" , DocMetadata as dm where d.id=dm.id ");//and d.logicalPath like :logicalPath
			} else {
			    hql1 = new StringBuilder();
			    parseTab4Hql(hql1,metaDataQs);
			    if(hql1.indexOf("where")==-1){
			        hql1.append(" where 1=1 ");
			    }
				//hql1.append(" and d.logicalPath like :logicalPath");
			}
			for(SimpleDocQueryModel sdm : metaDataQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql1.append(" and dm." + sdm.getPropertyName() + "=" + sdm.getPropertyName() + "PO.id");
				}
			}
			parseProperties4Hql(hql1, metaDataQs, params, " dm.");
			hql2.append(hql1);
			if (hasSimpleQ) {
				for(SimpleDocQueryModel sdm : simpleQs) {
					if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
						hql2.append(" and d." + sdm.getPropertyName() + "=" + sdm.getPropertyName() + "PO.id");
					}
				}
				parseProperties4Hql(hql2, simpleQs, params, " d.");
			}
		} else {// 仅有简单属性查询
			hql2.append(" where 1=1 ");//d.logicalPath like :logicalPath
			for(SimpleDocQueryModel sdm : simpleQs) {
				if(sdm.getPropertyType() == 8 && !sdm.getValue1().isEmpty()) {
					hql2.append(" and d." + sdm.getPropertyName() + "=" + sdm.getPropertyName() + "PO.id");
				}
			}
			parseProperties4Hql(hql2, simpleQs, params, " d.");
		}
		
		return hql2;
	}
	
}
