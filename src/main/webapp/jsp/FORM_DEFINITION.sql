INSERT INTO "FORM_DEFINITION" VALUES (4490086914774746130, '员工入职审批单', -7273032013234748168, TO_DATE('20180522224822', 'YYYYMMDDHH24MISS'), 1, 706798653460660266, 2, 0, 0, '<TableList>
  <Table id="-4623027938869492256" name="formmain_0001" display="formmain_0001" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="7478988693643937803" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="555066595423569382" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="3773280084038665969" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-1345314169012207227" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-6201140667672805276" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6580389434151027150" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="5993941733128294282" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="4960078297116068697" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="7282451668143984034" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-7713334095065102860" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-1813455247685562670" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5488775965627270235" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-542942880326922303" name="field0003" display="基础-姓名" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2039671340692846544" name="field0004" display="基础-性别" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2915152722395808113" name="field0005" display="基础-民族" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3178156282874645316" name="field0006" display="基础-照片" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2533555665955866292" name="field0007" display="基础-状态" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7788747241911201995" name="field0008" display="基础-出生日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5330193487689370834" name="field0009" display="基础-年龄" fieldtype="DECIMAL" fieldlength="2,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8195487795069433668" name="field0010" display="基础-政治面貌" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5943265930418304360" name="field0011" display="基础-婚姻状况" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-233096032585300561" name="field0012" display="基础-身份证号" fieldtype="VARCHAR" fieldlength="18,0" is_null="false" is_primary="false" classname=""/>
          <Field id="947296041005961076" name="field0013" display="基础-学历" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8548878617952040901" name="field0014" display="基础-毕业院校" fieldtype="VARCHAR" fieldlength="60,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3874897594038531287" name="field0015" display="基础-所学专业" fieldtype="VARCHAR" fieldlength="60,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4959870297192416245" name="field0016" display="基础-户籍" fieldtype="VARCHAR" fieldlength="120,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3179611931602432712" name="field0017" display="基础-身高" fieldtype="DECIMAL" fieldlength="3,2" is_null="false" is_primary="false" classname=""/>
          <Field id="7636280083286017143" name="field0018" display="基础-体重" fieldtype="DECIMAL" fieldlength="3,2" is_null="false" is_primary="false" classname=""/>
          <Field id="59779531977673693" name="field0019" display="基础-职称资格" fieldtype="VARCHAR" fieldlength="120,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1747281614684403135" name="field0020" display="基础-个人简历" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1581738260307397772" name="field0021" display="基础-联系电话" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3463557257479539582" name="field0022" display="基础-电子邮箱" fieldtype="VARCHAR" fieldlength="90,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6308521380056317582" name="field0023" display="基础-邮政编码" fieldtype="DECIMAL" fieldlength="6,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5065521413277922754" name="field0024" display="基础-通讯住址" fieldtype="VARCHAR" fieldlength="120,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1385200820447657569" name="field0025" display="基础-其他信息" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2204166563655696329" name="field0026" display="职位-供职部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-281121022039275700" name="field0027" display="职位-岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6879688221084958842" name="field0028" display="职位-兼任部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6159337835082006222" name="field0029" display="职位-兼任职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3635813428403682583" name="field0030" display="职位-直接上级部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4539572459800539206" name="field0031" display="职位-直接上级岗位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8218013045639986680" name="field0032" display="职位-职务层级" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3933937631649840011" name="field0033" display="职位-入职日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5431486375272399472" name="field0034" display="职位-试用开始日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="228669667333654629" name="field0035" display="职位-试用结束日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1450251626505417709" name="field0036" display="职位-试用月数" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1258965151529287301" name="field0037" display="协同帐号-用户" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7158923353389876177" name="field0038" display="协同帐号-登录名" fieldtype="VARCHAR" fieldlength="15,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3348512091297657860" name="field0039" display="协同帐号-密码" fieldtype="VARCHAR" fieldlength="10,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4999999846025675644" name="field0040" display="薪资-工资标准" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="1660405569568391776" name="field0041" display="薪资-试用期月工资" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="5136471304882439140" name="field0042" display="薪资-试用期发放比例" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8192809565948628983" name="field0043" display="薪资-绩效基数" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-2790851263359073276" name="field0044" display="薪资-年奖基数" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-6377735389483876284" name="field0045" display="薪资-交通补贴" fieldtype="DECIMAL" fieldlength="4,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4495364485964543488" name="field0046" display="薪资-通讯补贴" fieldtype="DECIMAL" fieldlength="4,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1494752954138970190" name="field0047" display="薪资-餐费补贴" fieldtype="DECIMAL" fieldlength="4,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2602177475071555353" name="field0048" display="薪资-社保基数" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-4418407944659384254" name="field0049" display="薪资-住房公积金基数" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-8001687949985690268" name="field0050" display="薪资-住房公积金缴交比例" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8505028080165408267" name="field0051" display="薪资-其他福利" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6244674038583703063" name="field0052" display="部门负责人意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1659411448516329828" name="field0053" display="人事部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6648477773743633860" name="field0054" display="部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3580026224833249270" name="field0055" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1965534484852066260" name="field0056" display="劳动合同-编号" fieldtype="VARCHAR" fieldlength="90,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2855726880119700813" name="field0057" display="劳动合同-签订日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6355560693018412624" name="field0058" display="劳动合同-期限" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6531033634423589832" name="field0059" display="劳动合同-开始日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7617820607230883833" name="field0060" display="劳动合同-结束日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2677789845781985041" name="field0061" display="劳动合同-说明" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-4993623318340025854" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="20153.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-3730890441545003031" name="填写" filename="Operation_179076601567462457.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-749083251896923627" name="审批" filename="Operation_-4216908898680486438.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-4187960629521134602" name="显示" filename="Operation_6844615815095796873.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224822', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="员工入职审批单" id="4490086914774746130"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0001"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-1813455247685562670"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="5488775965627270235"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-542942880326922303"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-2039671340692846544"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="2915152722395808113"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="3178156282874645316"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="2533555665955866292"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-7788747241911201995"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="5330193487689370834"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-8195487795069433668"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-5943265930418304360"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-233096032585300561"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="947296041005961076"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-8548878617952040901"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-3874897594038531287"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="4959870297192416245"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-3179611931602432712"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="7636280083286017143"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="59779531977673693"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="-1747281614684403135"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="1581738260307397772"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="3463557257479539582"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-6308521380056317582"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-5065521413277922754"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="-1385200820447657569"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="-2204166563655696329"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0027" id="-281121022039275700"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0028" id="6879688221084958842"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0029" id="-6159337835082006222"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0030" id="-3635813428403682583"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0031" id="-4539572459800539206"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0032" id="-8218013045639986680"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0033" id="-3933937631649840011"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0034" id="5431486375272399472"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0035" id="228669667333654629"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0036" id="-1450251626505417709"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0037" id="-1258965151529287301"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0038" id="7158923353389876177"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0039" id="-3348512091297657860"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0040" id="4999999846025675644"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0041" id="1660405569568391776"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0042" id="5136471304882439140"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0043" id="8192809565948628983"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0044" id="-2790851263359073276"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0045" id="-6377735389483876284"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0046" id="-4495364485964543488"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0047" id="1494752954138970190"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0048" id="-2602177475071555353"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0049" id="-4418407944659384254"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0050" id="-8001687949985690268"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0051" id="8505028080165408267"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0052" id="-6244674038583703063"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0053" id="1659411448516329828"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0054" id="-6648477773743633860"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0055" id="-3580026224833249270"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0056" id="1965534484852066260"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0057" id="-2855726880119700813"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0058" id="6355560693018412624"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0059" id="6531033634423589832"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0060" id="-7617820607230883833"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0061" id="-2677789845781985041"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '70FEFC527A2BF5A519050EF56207C7D8EA3B58E5BB3940F187561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (-1011912163487036590, '员工离职审批单', -7273032013234748168, TO_DATE('20180522224823', 'YYYYMMDDHH24MISS'), 1, 706798653460660266, 2, 0, 0, '<TableList>
  <Table id="3058884730245172100" name="formmain_0002" display="formmain_0002" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-8742172394405806023" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-3549884070849722824" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-2184864660426831885" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="1651086455325344928" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="7670339497806547226" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-2426244058427273945" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-7034472716406928203" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-3988930404707515086" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-9159429691512634043" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="4164179469251332197" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="6965926198449094979" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5802159747031023152" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7637932161888793694" name="field0003" display="姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3210655502023085" name="field0004" display="供职部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8945219889373922704" name="field0005" display="岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3264980575056643413" name="field0006" display="个人辞职" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3966381669773588651" name="field0007" display="公司解聘" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6202851472363572940" name="field0008" display="劳动合同到期不续签" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7476207175415057045" name="field0009" display="离职原因-申请或通知" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7417493890466954736" name="field0010" display="离职原因-说明" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7273004622454473406" name="field0011" display="供职部门-工作接交人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="906758897103687347" name="field0012" display="供职部门-文件资料接交人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1678711360799523356" name="field0013" display="供职部门-移交清单" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="9076973596363935671" name="field0014" display="供职部门-审批意见1" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-722506946143828978" name="field0015" display="供职部门-审批意见2" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4397575476925085705" name="field0016" display="人力部门-离职告知日期" fieldtype="TIMESTAMP" fieldlength="600,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4993624223202982599" name="field0017" display="人力部门-最后工作日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3935624177494898185" name="field0018" display="人力部门-薪资截止日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6839776059827899914" name="field0019" display="人力部门-审批意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="690306249674867798" name="field0020" display="有关部门-资产物品档案资料" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3252513968112290350" name="field0021" display="有关部门-借款和欠款" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5752306336829455575" name="field0022" display="有关部门-其他事项" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7840439726843805228" name="field0023" display="有关部门-审批意见1" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3527103330375023137" name="field0024" display="有关部门-审批意见2" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5044354905975996265" name="field0025" display="部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4818908386885324762" name="field0026" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="8990666680986782133" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-4464780259946643272" name="填写" filename="Operation_3772194152361250078.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-8209943680472299285" name="审批" filename="Operation_2851629154821294703.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="7622725261820776339" name="显示" filename="Operation_3288415845199728497.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224823', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="员工离职审批单" id="-1011912163487036590"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0002"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="6965926198449094979"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-5802159747031023152"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-7637932161888793694"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-3210655502023085"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="8945219889373922704"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="3264980575056643413"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-3966381669773588651"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="6202851472363572940"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="7476207175415057045"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-7417493890466954736"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="7273004622454473406"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="906758897103687347"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="1678711360799523356"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="9076973596363935671"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-722506946143828978"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="-4397575476925085705"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-4993624223202982599"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="-3935624177494898185"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="6839776059827899914"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="690306249674867798"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="3252513968112290350"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="-5752306336829455575"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-7840439726843805228"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-3527103330375023137"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="-5044354905975996265"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="4818908386885324762"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '9D98591A9CC17DD75D189047DF1EE6BD881214B49254C1C3F3F30080F8E8FC7E5CC0524C0AE786EE');
INSERT INTO "FORM_DEFINITION" VALUES (4905104609888979263, '差旅费报销单', -7273032013234748168, TO_DATE('20180522224823', 'YYYYMMDDHH24MISS'), 1, -619573809937168879, 2, 0, 0, '<TableList>
  <Table id="-9147724382863800079" name="formmain_0005" display="formmain_0005" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-2926318581693987371" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="9075450152384678669" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="8819738913036978487" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-1251847348500804778" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-1249321527001003465" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="636334358316467583" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="7177822778685475224" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="747050546511560736" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="1995673293343444162" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6258387000025828577" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="7418217853868787701" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7250937113835778127" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="962486655133763184" name="field0003" display="姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="906745286409734750" name="field0004" display="供职部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2280924599461629761" name="field0005" display="岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3472570749639740524" name="field0006" display="单据数量" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1432868397920664425" name="field0007" display="出差开始日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2890591679184678947" name="field0008" display="出差结束日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1078367817907090054" name="field0009" display="出差天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="6431495276178001022" name="field0010" display="出差地点" fieldtype="VARCHAR" fieldlength="60,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6921932263190839830" name="field0011" display="出差事由" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1378641817104922685" name="field0012" display="报销项目-飞机票数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1329343891632899133" name="field0013" display="报销项目-火车票数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8909934547660720673" name="field0014" display="报销项目-汽车票数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7294296093411029838" name="field0015" display="报销项目-轮船票数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5583674050542678124" name="field0016" display="报销项目-住宿票数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-426738142051286426" name="field0017" display="报销项目-市内交通票数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3530004235386175944" name="field0018" display="报销项目-通讯票数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7322146442074570305" name="field0019" display="报销项目-补贴天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="379812126526361328" name="field0020" display="报销项目-其他票数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3183263407115421765" name="field0021" display="报销项目-飞机费" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="2779954820964108838" name="field0022" display="报销项目-火车费" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-7792765262987247550" name="field0023" display="报销项目-汽车费" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="8362384624530902320" name="field0024" display="报销项目-轮船费" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-7947102287541878471" name="field0025" display="报销项目-住宿费" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-8388184095178470748" name="field0026" display="报销项目-市内交通费" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-4875059651077780007" name="field0027" display="报销项目-通讯费" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="2666114649519246572" name="field0028" display="报销项目-出差补贴" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-3151367015461402306" name="field0029" display="报销项目-其他" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-5923160801135211393" name="field0030" display="报销金额小写" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-6470833900990675093" name="field0031" display="报销金额大写" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4633595432205726860" name="field0032" display="借款金额" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-4268172015836314472" name="field0033" display="应退金额" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="2034695884357716807" name="field0034" display="应补金额" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-2852014749802738683" name="field0035" display="供职部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6558476919397762656" name="field0036" display="财务部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1429705945895421069" name="field0037" display="部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1927604712910965322" name="field0038" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8718691734410670677" name="field0039" display="会计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3903248588350505046" name="field0040" display="出纳" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="3878817356916932823" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-6321501742490434764" name="填写" filename="Operation_7542913187342730743.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="4210023571704727447" name="审批" filename="Operation_-7357639972174082314.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-565908012927859476" name="显示" filename="Operation_-6905082448924095248.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224823', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="差旅费报销单" id="4905104609888979263"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0005"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="7418217853868787701"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-7250937113835778127"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="962486655133763184"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="906745286409734750"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="2280924599461629761"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="3472570749639740524"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-1432868397920664425"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-2890591679184678947"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-1078367817907090054"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="6431495276178001022"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="6921932263190839830"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-1378641817104922685"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="1329343891632899133"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="8909934547660720673"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-7294296093411029838"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="-5583674050542678124"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-426738142051286426"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="3530004235386175944"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="-7322146442074570305"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="379812126526361328"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="3183263407115421765"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="2779954820964108838"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-7792765262987247550"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="8362384624530902320"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="-7947102287541878471"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="-8388184095178470748"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0027" id="-4875059651077780007"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0028" id="2666114649519246572"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0029" id="-3151367015461402306"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0030" id="-5923160801135211393"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0031" id="-6470833900990675093"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0032" id="-4633595432205726860"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0033" id="-4268172015836314472"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0034" id="2034695884357716807"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0035" id="-2852014749802738683"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0036" id="6558476919397762656"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0037" id="1429705945895421069"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0038" id="1927604712910965322"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0039" id="-8718691734410670677"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0040" id="3903248588350505046"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '01DC36CAEEB69A1CAFD4BEA8DC3D9B07A7FA560F2734B55587561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (-4191680153610991642, '物品采购审批单', -7273032013234748168, TO_DATE('20180522224824', 'YYYYMMDDHH24MISS'), 1, 126083046181520631, 2, 0, 0, '<TableList>
  <Table id="-209524217059783761" name="formmain_0010" display="formmain_0010" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="3025242677811102881" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-8882752778909891882" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="3967659078288098857" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-1396626829150302584" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-5816564889481100709" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="2932889311177165320" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="4605512666461325103" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-4984286994909147783" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-1927230834037537594" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="1938537841690036001" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="7958161568615517356" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2300937731205609455" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2938284658005724707" name="field0003" display="申请人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7379147127947739733" name="field0004" display="部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8760814067932903819" name="field0005" display="岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1078254830394392141" name="field0006" display="申购原因及用途" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5530236694472867649" name="field0007" display="询价情况-询价单" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3945088720394826913" name="field0008" display="询价情况-详细" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1182827871927056189" name="field0009" display="预估总价合计-小写" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-2533434787595859555" name="field0010" display="实际总价合计-小写" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="5221845615764193712" name="field0011" display="实际总价合计-大写" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3135776256574075495" name="field0012" display="申购部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1619920168230863420" name="field0013" display="采购部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7676612428227264198" name="field0014" display="分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2077520293514136535" name="field0015" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4771350903118514478" name="field0016" display="入库说明" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-1276860575872889582" name="formson_0011" display="申购明细表" tabletype="slave" onwertable="formmain_0010" onwerfield="formmain_id">
      <FieldList>
          <Field id="1324373696477088529" name="field0017" display="申购明细-序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8227158967764299885" name="field0018" display="申购明细-名称" fieldtype="VARCHAR" fieldlength="90,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5196799982665810434" name="field0019" display="申购明细-型号规格" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8210393315401971374" name="field0020" display="申购明细-单位" fieldtype="VARCHAR" fieldlength="15,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4934103598153091437" name="field0021" display="申购明细-数量" fieldtype="DECIMAL" fieldlength="6,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8409589301850818039" name="field0022" display="申购明细-预估单价" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="2243995816805550202" name="field0023" display="申购明细-实际单价" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="3891076534686007522" name="field0024" display="申购明细-预估总价" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-3953688892609967645" name="field0025" display="申购明细-实际总价" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="1864434285174345682" name="field0026" display="申购明细-是否购买" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9132094786448242185" name="field0027" display="申购明细-购买日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6411694246019678766" name="field0028" display="申购明细-供应单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-8380884256861305848" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-7838602068082668572" name="填写" filename="Operation_-1798795514419986428.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="9112679966748134623" name="审批" filename="Operation_-4883567520577339109.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="7148115634129028077" name="显示" filename="Operation_-6965907637759032845.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224824', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="物品采购审批单" id="-4191680153610991642"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0010"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="7958161568615517356"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-2300937731205609455"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="2938284658005724707"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="7379147127947739733"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-8760814067932903819"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-1078254830394392141"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-5530236694472867649"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-3945088720394826913"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-1182827871927056189"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-2533434787595859555"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="5221845615764193712"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-3135776256574075495"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="1619920168230863420"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-7676612428227264198"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="2077520293514136535"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="4771350903118514478"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0011"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0017" id="1324373696477088529"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="-8227158967764299885"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="5196799982665810434"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="-8210393315401971374"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="4934103598153091437"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="8409589301850818039"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="2243995816805550202"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="3891076534686007522"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="-3953688892609967645"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="1864434285174345682"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0027" id="-9132094786448242185"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0028" id="6411694246019678766"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, 'F807767A3A9088FB6C7420DFA241B7C6D59093BC8ABE5FFCF3F30080F8E8FC7E5CC0524C0AE786EE');
INSERT INTO "FORM_DEFINITION" VALUES (-7159336086635393373, '付款审批单', -7273032013234748168, TO_DATE('20180522224824', 'YYYYMMDDHH24MISS'), 1, -619573809937168879, 2, 0, 0, '<TableList>
  <Table id="-3738747066714013656" name="formmain_0008" display="formmain_0008" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="1284901757696624349" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-7697826448630657683" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="8319815126970943512" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-8843932945179524260" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-2851385277483366526" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-5783443646404474962" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="807773211111541126" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-8789898569475211222" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-7670742585817480845" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="8894656349743499305" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-6546922692884281882" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-230558350328379865" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="9024243244030969976" name="field0003" display="经办人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3638036963735716980" name="field0004" display="经办部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8355750845820324603" name="field0005" display="合同名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7909753621593372075" name="field0006" display="款项名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5271223839688573160" name="field0007" display="收款单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7961668425036155447" name="field0008" display="开户银行" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5371108218930808388" name="field0009" display="银行账号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4673038186368223593" name="field0010" display="付款情况-付款次数" fieldtype="DECIMAL" fieldlength="2,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6828045173203157897" name="field0011" display="付款情况-合同金额" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-1052360768841957082" name="field0012" display="付款情况-实际已付金额" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-6832413498497282961" name="field0013" display="付款条件" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8860710835195758111" name="field0014" display="付款金额-小写" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-3121878411855378070" name="field0015" display="付款金额-大写" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8138828349588027961" name="field0016" display="本次付款说明" fieldtype="VARCHAR" fieldlength="600,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8164293567368152330" name="field0017" display="经办部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5244115710566024165" name="field0018" display="财务部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8146317610165815202" name="field0019" display="经办部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8427155033419302384" name="field0020" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2804590312888645013" name="field0021" display="付款记录-付款日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4910389974254794754" name="field0022" display="付款记录-付款方式" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5544423457776908400" name="field0023" display="付款记录-实际付款金额小写" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-8041225915632237747" name="field0024" display="付款记录-实际付款金额大写" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-4293354531781324841" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-4343873343523042203" name="填写" filename="Operation_-4363474765769912333.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-780886842071495794" name="审批" filename="Operation_-317914902785998309.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="2207530845857203327" name="显示" filename="Operation_-339585442922675951.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224824', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="付款审批单" id="-7159336086635393373"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0008"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-6546922692884281882"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-230558350328379865"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="9024243244030969976"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="3638036963735716980"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="8355750845820324603"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-7909753621593372075"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="5271223839688573160"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="7961668425036155447"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="5371108218930808388"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="4673038186368223593"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="6828045173203157897"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-1052360768841957082"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-6832413498497282961"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="8860710835195758111"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-3121878411855378070"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="-8138828349588027961"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="8164293567368152330"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="5244115710566024165"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="8146317610165815202"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="8427155033419302384"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="-2804590312888645013"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="-4910389974254794754"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-5544423457776908400"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-8041225915632237747"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '1DFD7B70783269253FCB436E5C5DDE40DA9C6CE737168B0DF3F30080F8E8FC7E5CC0524C0AE786EE');
INSERT INTO "FORM_DEFINITION" VALUES (-6376466419393150961, '印章使用审批单', -7273032013234748168, TO_DATE('20180522224825', 'YYYYMMDDHH24MISS'), 1, 126083046181520631, 2, 0, 0, '<TableList>
  <Table id="3093498408363246329" name="formmain_0012" display="formmain_0012" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-1254559627466027602" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-4923728344332480903" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-6101617908201207825" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-6629537363484325259" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="2083033602421902665" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-6769542487228989087" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-7849222421848568898" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="5000015945239970212" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-1381569910260611823" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="3432983785034435303" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-8562884492231098235" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7009552164665605095" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7190684307293031443" name="field0003" display="姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="889106993117415774" name="field0004" display="部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2975364052656569909" name="field0005" display="岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1474787955027758125" name="field0006" display="印章名称-公章" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6134127640691127110" name="field0007" display="印章名称-合同专用章" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-401829879748671737" name="field0008" display="印章名称-法人代表名章" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1405365910447673274" name="field0009" display="印章名称-财务专用章" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4314605868050330805" name="field0010" display="印章名称-发票专用章" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5597193239185044426" name="field0011" display="用印文件名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3173223073104310865" name="field0012" display="用印文件数量" fieldtype="DECIMAL" fieldlength="4,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-40144682834507834" name="field0013" display="用印文件电子文档" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5361459576962629878" name="field0014" display="用印文件重要程度" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8117881677930279904" name="field0015" display="用印文件用途" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7307310987988913173" name="field0016" display="部门负责人意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8973251797612383330" name="field0017" display="行政部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8466641616372910065" name="field0018" display="部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6198415876440767305" name="field0019" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5459283773095130138" name="field0020" display="印章使用记录-用印日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="9122858622617472344" name="field0021" display="印章使用记录-文件份数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4404738715188442205" name="field0022" display="印章使用记录-用印数量" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1899330939074529792" name="field0023" display="印章使用记录-操作人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3224039591530902007" name="field0024" display="印章使用记录-说明" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="7914255141970988048" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-5389874543166010887" name="填写" filename="Operation_4806123843749890134.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-597580935460274129" name="审批" filename="Operation_2297417745674162095.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-2190217782914363760" name="显示" filename="Operation_-5391341194513791000.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224825', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="印章使用审批单" id="-6376466419393150961"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0012"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-8562884492231098235"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-7009552164665605095"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="7190684307293031443"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="889106993117415774"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-2975364052656569909"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="1474787955027758125"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-6134127640691127110"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-401829879748671737"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="1405365910447673274"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-4314605868050330805"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-5597193239185044426"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-3173223073104310865"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-40144682834507834"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="5361459576962629878"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-8117881677930279904"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="7307310987988913173"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="8973251797612383330"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="8466641616372910065"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="-6198415876440767305"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="-5459283773095130138"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="9122858622617472344"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="-4404738715188442205"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="1899330939074529792"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-3224039591530902007"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '1F06A30A18FCE18065B4A35326F23569BE68AAA95F50CD0AF3F30080F8E8FC7E5CC0524C0AE786EE');
INSERT INTO "FORM_DEFINITION" VALUES (-7663681133104185262, '事项台账', -2565180276577582553, TO_DATE('20180522224828', 'YYYYMMDDHH24MISS'), 2, 4358901251920773292, 1, 2, 0, '<TableList>
  <Table id="-3656843735759306408" name="formmain_0013" display="formmain_0013" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-5808966590576899110" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="9191466032684354491" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="5616704198391185688" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-1557090449735268636" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-8904639340348618079" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-142037168712496876" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-6558713607883832974" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="2882533817932203440" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-9137510070607461154" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6286181143619715825" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="1947049709817841270" name="field0005" display="D2自评" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5963600875326818785" name="field0006" display="D2考核评价" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8743158315334519995" name="field0007" display="D2等级" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3013402179524972120" name="field0008" display="D2得分" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3993837131572200894" name="field0132" display="销账人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4890920521935637678" name="field0133" display="签收人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5905870092029477413" name="field0134" display="承办人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4147034735481932723" name="field0149" display="反馈方式" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3620678578374685115" name="field0013" display="表单流水号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1970104555359089719" name="field0129" display="评价次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4723177538931110627" name="field0009" display="提醒次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7918862170998197687" name="field0019" display="上级事项" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1457979753721775684" name="field0101" display="批示内容" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7369035896287871585" name="field0029" display="事项数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3353723007726959115" name="field0025" display="事项流水号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3691460201640672157" name="field0089" display="会议期次" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8641224029115663647" name="field0098" display="立项时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2743474752209927183" name="field0121" display="创建人记录" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5705649805103484897" name="field0085" display="会议类型" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7826020188783885851" name="field0017" display="开始时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7792000909267913274" name="field0118" display="批示次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1575366234956974419" name="field0117" display="超期次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4253975166108713470" name="field0091" display="议题序号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6099568764639493684" name="field0088" display="批示领导" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1769620599867750064" name="field0026" display="督查要求" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2101345941514371280" name="field0001" display="责任单位部门" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7690922730890611799" name="field0030" display="事项完成总进度" fieldtype="DECIMAL" fieldlength="20,2" is_null="false" is_primary="false" classname=""/>
          <Field id="8158352381330213997" name="field0124" display="批示时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="9116768859279476631" name="field0010" display="催办次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1437927484086596990" name="field0090" display="会议名称" fieldtype="VARCHAR" fieldlength="1000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7179182277899172822" name="field0002" display="协办单位部门" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8469375206575552332" name="field0115" display="关注次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3893931117260158256" name="field0016" display="协办人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1107208716575132225" name="field0125" display="签收时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1241215904170881462" name="field0028" display="完成进度" fieldtype="DECIMAL" fieldlength="20,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-3866936559155851675" name="field0095" display="督办承办人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7229581364791361999" name="field0096" display="分管领导" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5596281353342989450" name="field0015" display="责任领导" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9043260523520769585" name="field0094" display="分管秘书长" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4049794608879059369" name="field0027" display="目标事项" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6198541753758662881" name="field0004" display="要求完成时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8139929554324143202" name="field0100" display="目标来源" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8744406953466379129" name="field0099" display="紧急程度" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2522398103338270700" name="field0093" display="来件原文" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8683724232594994855" name="field0024" display="事项状态" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2356628156480666461" name="field0018" display="实际完成时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="220819349383038056" name="field0011" display="变更次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6874657730616772149" name="field0128" display="反馈次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4533401841961383072" name="field0126" display="销账时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6298983490198523770" name="field0014" display="责任人联系电话" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3600251486307434666" name="field0021" display="期号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4985351614497181034" name="field0087" display="交办单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1557407867529678045" name="field0020" display="专报名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2302754408745712109" name="field0023" display="事项名称" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3801488554079858960" name="field0003" display="责任人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7688089986691515040" name="field0131" display="上级事项ID" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7480354057418786350" name="field0022" display="事项分类" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-583725742937781688" name="field0113" display="创建人单位部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4710124130964294582" name="field0012" display="预警" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8619596787229737678" name="field0151" display="总得分" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-6648379018407753124" name="formson_0014" display="R5提醒记录" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="-4125064441997733944" name="field0031" display="DR5序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5033521940682918020" name="field0033" display="提醒内容" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="787029518828259940" name="field0036" display="提醒单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4492133677929219683" name="field0035" display="提醒备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3129775232782482622" name="field0032" display="提醒人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2854903732519716881" name="field0034" display="提醒时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1381852623486142283" name="field0152" display="提醒创建人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="1928498755085680998" name="formson_0015" display="R6催办记录" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="2495068025129945451" name="field0037" display="DR6序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8743758520747574918" name="field0038" display="催办单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4686408528421080170" name="field0040" display="催办单" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-497658021029982820" name="field0039" display="催办时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4204115667440258182" name="field0041" display="催办内容" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-6297405551782703968" name="formson_0016" display="R7变更记录" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="90955087149419875" name="field0042" display="DR7序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1054056980862289353" name="field0047" display="申请记录" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2572787266413441973" name="field0045" display="延长天数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4863101099948489381" name="field0044" display="变更类型" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4924013921023540268" name="field0043" display="申请单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="738214660891297535" name="field0046" display="延期完成时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2319699220499351852" name="field0048" display="申请时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8311742307593138892" name="field0049" display="申请原因" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-459350258116180916" name="formson_0017" display="R事项分解" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="-1929399590670479954" name="field0050" display="DR3序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3677091262405165913" name="field0064" display="DR3催办次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5213814087237651403" name="field0065" display="DR3提醒次数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="259121936448897898" name="field0066" display="DR3自评" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3288327967154157790" name="field0067" display="DR3等级" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2667505374046407597" name="field0068" display="DR3考核评价" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9168570051817553086" name="field0069" display="DR3得分" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3879267013485311829" name="field0070" display="DR3权重乘完成率" fieldtype="DECIMAL" fieldlength="20,3" is_null="false" is_primary="false" classname=""/>
          <Field id="-6095375505062280343" name="field0147" display="DR3上级事项ID" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6273271130730968920" name="field0062" display="分解完成率" fieldtype="DECIMAL" fieldlength="20,2" is_null="false" is_primary="false" classname=""/>
          <Field id="5342144816104361075" name="field0136" display="分解督办人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3224798783510787693" name="field0059" display="分解完成时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2850462042352928919" name="field0061" display="分解权重" fieldtype="DECIMAL" fieldlength="20,2" is_null="false" is_primary="false" classname=""/>
          <Field id="7762584300984814602" name="field0122" display="分解创建人单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3750932239953841243" name="field0148" display="分解承办人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4051222077621356378" name="field0123" display="分解创建人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4907949666892794391" name="field0054" display="分解责任人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2133425848735676443" name="field0051" display="分解事项分类" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6721503360610225118" name="field0063" display="分解完成情况" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-600483292142222730" name="field0060" display="分解实际完成时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8678910066395886612" name="field0119" display="分解责任人电话" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3850957852209623770" name="field0053" display="分解责任单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2979559197789763131" name="field0150" display="分解反馈方式" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="750540008232206598" name="field0056" display="分解协办人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6754365528978864748" name="field0120" display="分解紧急程度" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="620697999204372096" name="field0058" display="分解开始时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6876736163030191969" name="field0052" display="分解事项名称" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5306217768783821336" name="field0057" display="分解事项要求" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4710926583850877342" name="field0055" display="分解协办单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="2816241520779217218" name="formson_0018" display="DR4反馈记录" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="3021974611939380070" name="field0079" display="DR4备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4456057903182035238" name="field0086" display="DR4审核结果" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-960740655952017495" name="field0092" display="DR4计划周期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5096648802625605396" name="field0097" display="DR4计划内容" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1037318764728856757" name="field0130" display="DR4计划周期2" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7039223389991647638" name="field0135" display="DR4反馈类型" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6170045724823108154" name="field0146" display="DR4计划ID" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6228575449979009759" name="field0072" display="反馈单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2614831650078870652" name="field0071" display="DR4反馈序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8201987318901788415" name="field0074" display="完成率" fieldtype="DECIMAL" fieldlength="22,2" is_null="false" is_primary="false" classname=""/>
          <Field id="4286574277032889709" name="field0075" display="反馈时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6163317310701680157" name="field0078" display="反馈记录单" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="38841326179272773" name="field0077" display="结果关联文档" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4043681220377621151" name="field0073" display="完成情况" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3259183300499097340" name="field0076" display="结果附件" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-1478085173819980901" name="formson_0019" display="组5" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="4297272022608203737" name="field0084" display="DR8关注备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6849509342457738983" name="field0080" display="DR8关注序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8271102089543502174" name="field0081" display="关注领导" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6055776447866160158" name="field0082" display="关注批示内容" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3620952994810183940" name="field0083" display="关注时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="0" name="formson_0020" display="R8评价记录表" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="-4020051843566514613" name="field0102" display="DR8评价序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5678572494278574816" name="field0114" display="自评时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1185362974803669707" name="field0127" display="自评人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6599806957314720260" name="field0103" display="自评" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="0" name="formson_0021" display="R9考核" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="7227420175971795845" name="field0104" display="DR9考核序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5312840653181925182" name="field0116" display="评价时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-586294293922430420" name="field0107" display="考核评价" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="582558198702361185" name="field0106" display="得分" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6497339883592306212" name="field0105" display="等级" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3933412525758984752" name="field0108" display="评价人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="0" name="formson_0022" display="DR10批示" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="-2152687216596398762" name="field0109" display="DR10批示序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4183000740774039099" name="field0110" display="批示内容记录" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3878295805648456073" name="field0111" display="批示领导记录" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3026848442587855163" name="field0112" display="批示时间记录" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="0" name="formson_0023" display="R11计划反馈" tabletype="slave" onwertable="formmain_0013" onwerfield="formmain_id">
      <FieldList>
          <Field id="-6279917884510616317" name="field0137" display="R11序号计划" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="441116292104274471" name="field0140" display="计划反馈单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3724319374616540034" name="field0143" display="计划ID" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4408662127607069674" name="field0138" display="计划周期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3554307852396311211" name="field0139" display="计划内容" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2890755005759835072" name="field0145" display="计划关联文档" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5889527706482262891" name="field0142" display="计划周期2" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="906262005958330098" name="field0144" display="附件计划" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-667791217976064167" name="field0141" display="计划反馈时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-1617523181331529596" name="事项分解表" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-7580123277247037073" name="填写" filename="-1485569482895373578.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="850948738971813949" name="审批" filename="6964097562689752914.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="8070703209676361228" name="显示" filename="4920594096409366445.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="8953447079335839866" name="销账" filename="Operation_541055384820730557.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-5101651208061304115" name="签收" filename="Operation_5011413751389046175.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="7514088449302284502" name="会议议定事项" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view2.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="316965146892192072" name="审批" filename="8771449382909068037.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-5859303747312402370" name="显示" filename="3246539199225745205.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="-1767071477650011160" name="政府工作报告" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view3.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-9073947268715231281" name="审批" filename="-4148193224197716021.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-4506286724901418432" name="显示" filename="2609121682424088421.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="897192652241258698" name="领导批示件" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view4.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="4669724108192238962" name="审批" filename="7950980718960855903.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-9195869307764651996" name="显示" filename="-238380521492493885.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="-6206666125536768295" name="来文办件" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view5.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-1432068373091629060" name="审批" filename="-3015194869325672505.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="6710205425598285130" name="显示" filename="-3364867217194336130.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="-3760175315485703696" name="领导批示件" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view6.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="5819224349807821136" name="审批" filename="-4425224686744877190.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="3280386989888654267" name="显示" filename="-2258670927479092981.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="1534662928977382342" name="新建领导批示" filename="Operation_-360393108169474016.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="-4672958407626504562" name="会议议定事项" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view7.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="2258432241835197836" name="审批" filename="4927324216860233709.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="7863883690505093227" name="显示" filename="-4432595863278108055.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-5145577120489912395" name="新建会议议定" filename="Operation_-8467320294008012251.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="-4783109424647484735" name="来文办件" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view8.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="4134520180699384211" name="审批" filename="-7845547646689721416.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-6937741353130832511" name="显示" filename="5925265382396413694.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="3515050777870683899" name="新增来文办件" filename="Operation_1481176914097752493.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="-4857441029041076712" name="上级交办" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view9.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-7218546283113658340" name="审批" filename="-5931957196109427957.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="4759309174520627581" name="显示" filename="-7140152880576902103.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-4848189851217146551" name="新建上级交办" filename="Operation_2627773321344598417.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
    <Event id="-6610287501020214731" name="月度超期" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="4112700381330490532" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-6799060790120067395" param="month" time="17:00" runFormulaId="-1858518827873124259" stopFormulaId="2367687239989346904" />
        </ConditionList>
        <ActionList>
            <Action id="-6209721616507384562" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}超期未反馈，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                </Param>
            </Action>
            <Action id="2181516458717629282" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}超期未反馈]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
            <Action id="8277007808038653843" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"4805468119426220345","field2":"field0117","cale2":"cale","formulaId2":"-1544054998877846759","fieldValue2":"{超期次数}+1","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-7087885116198140769" name="季度超期" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-4237828565607953308" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="5822785272027826635" param="season" time="17:00" runFormulaId="-7337250400015464777" stopFormulaId="-7577220113844124350" />
        </ConditionList>
        <ActionList>
            <Action id="-4791516953436601034" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"4805468119426220345","field2":"field0117","cale2":"cale","formulaId2":"-2514613503836928488","fieldValue2":"{超期次数}+1","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="-4780378789498435698" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}超期未反馈，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                </Param>
            </Action>
            <Action id="-4580475911611987340" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}超期未反馈]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-9066558675043990931" name="按月预警重置" state="1" type="1" formId="-7663681133104185262" creator="-8457210782547751721" createTime="2017-06-14 15:23:55" modifyTime="2017-07-24 09:36:15">
        <ConditionList>
            <Condition type="form" formulaId="-6718313396376745480" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-4662165795437657714" param="month" time="6:00" runFormulaId="-7031496950519414396" stopFormulaId="139658793872933869" />
        </ConditionList>
        <ActionList>
            <Action id="3045426525441641737" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"369103772469642840","field2":"","cale2":"cale1","formulaId2":"","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="4071729584946823193" name="按季度预警重置" state="1" type="1" formId="-7663681133104185262" creator="-8457210782547751721" createTime="2017-06-14 15:40:44" modifyTime="2017-07-20 11:11:13">
        <ConditionList>
            <Condition type="form" formulaId="7563788231456867486" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-6172727480656378634" param="season" time="6:00" runFormulaId="4739401398678275243" stopFormulaId="5173763854578959242" />
        </ConditionList>
        <ActionList>
            <Action id="-4181351692009257921" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"369103772469642840","field2":"","cale2":"cale1","formulaId2":"","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-962034940332129639" name="月度即将超期" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="1324096197841276699" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-5919466110911691928" param="month" time="17:00" runFormulaId="-2113153609721626082" stopFormulaId="7206988266467643006" />
        </ConditionList>
        <ActionList>
            <Action id="-2380743142778320317" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"-7460014425726500540","field2":"","cale2":"cale1","formulaId2":"","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="98885715293129339" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}即将超期，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                </Param>
            </Action>
            <Action id="-6786110317530231984" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}即将超期]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="8219521679916027696" name="季度即将超期" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-4988563703477285567" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-5406224070006714479" param="season" time="17:00" runFormulaId="980674966518121750" stopFormulaId="-523189893445562918" />
        </ConditionList>
        <ActionList>
            <Action id="556728571128794162" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"-7460014425726500540","field2":"","cale2":"cale1","formulaId2":"","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="-1409629520795906290" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}即将超期，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                </Param>
            </Action>
            <Action id="-979456681992959896" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}即将超期]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-774081533551162446" name="新反馈提醒" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-2524797687391302814" param="22" />
        </ConditionList>
        <ActionList>
            <Action id="-1146068988235661140" type="message" name="null">
                <Param type="msgContent"><![CDATA[{反馈单位}反馈了督办事项{事项流水号}完成情况]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="2780273914431816419" name="领导关注提醒" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-8108620158056249555" param="22" />
        </ConditionList>
        <ActionList>
            <Action id="-3798501735199063869" type="message" name="null">
                <Param type="msgContent"><![CDATA[{关注领导}领导关注了事项{事项流水号}]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#D1责任人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Member@field0095#D1督办承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="2077843088937863129" name="提醒消息" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-4495847456118519871" param="22" />
        </ConditionList>
        <ActionList>
            <Action id="6878591281787391273" type="message" name="null">
                <Param type="msgContent"><![CDATA[{提醒内容}]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0032#提醒人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-7926905372282174501" name="事项自评消息" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-3178891666486115565" param="22" />
        </ConditionList>
        <ActionList>
            <Action id="7240320657246470686" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}有新自评]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-904905049066356729" name="事项评价消息" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-3194625821039902618" param="22" />
        </ConditionList>
        <ActionList>
            <Action id="1833022262647408995" type="message" name="null">
                <Param type="msgContent"><![CDATA[{评价人}评价了督办事项{事项流水号}]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-6088417316202200750" name="事项批示消息" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-7448381893533285661" param="22" />
        </ConditionList>
        <ActionList>
            <Action id="-8379554002901774921" type="message" name="null">
                <Param type="msgContent"><![CDATA[{批示领导记录}领导批示事项{事项流水号}]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="82029230100595633" name="新计划消息" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-2175369394719997299" param="22" />
        </ConditionList>
        <ActionList>
            <Action id="688611223687088944" type="message" name="null">
                <Param type="msgContent"><![CDATA[{计划反馈单位}填报了督办事项{事项流水号}计划]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0081#关注领导">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="6799382113638565777" name="一次反馈超期" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="8824288907780309568" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-4333138768221222859" param="month" time="17:00" runFormulaId="6312123783283822301" stopFormulaId="-2612114832204214298" />
        </ConditionList>
        <ActionList>
            <Action id="-981854138589167325" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}超期未反馈，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                </Param>
            </Action>
            <Action id="-5457765944791579862" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"4805468119426220345","field2":"field0117","cale2":"cale","formulaId2":"-2576097140270282985","fieldValue2":"{超期次数}+1","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="-4077326552633029397" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}超期未反馈]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-3359663538917324567" name="一次反馈即将超期" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="4809891663451342373" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="3607773099719148931" param="year" time="17:00" runFormulaId="7903032137645573759" stopFormulaId="-5652099330578100465" />
        </ConditionList>
        <ActionList>
            <Action id="-3479610319049635681" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"-7460014425726500540","field2":"","cale2":"cale1","formulaId2":"","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="5223878531183299081" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}即将超期，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                </Param>
            </Action>
            <Action id="-1419645367538528334" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}即将超期]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-8782586982070074130" name="完成期限超期（按月）" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="-6217944437246178700" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-7909640910201207345" param="day" time="17:00" runFormulaId="-6347864858502740816" stopFormulaId="-771065940133985457" />
        </ConditionList>
        <ActionList>
            <Action id="1191300425938127933" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"4805468119426220345","field2":"","cale2":"val","formulaId2":"1663800791145139419","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="8841000638252796759" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}超期未反馈，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                </Param>
            </Action>
            <Action id="-2202602078342396559" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}超期未反馈]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-2988562665242934172" name="完成时限即将超期（按月）" state="1" type="1" formId="-7663681133104185262" creator="9167677149301981874" createTime="2017-07-18 15:05:57" modifyTime="2017-07-18 15:05:57">
        <ConditionList>
            <Condition type="form" formulaId="18041492566786191" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="7511648583863583230" param="day" time="17:00" runFormulaId="1211101551331790818" stopFormulaId="5410497859966158919" />
        </ConditionList>
        <ActionList>
            <Action id="129027685437688121" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"-7460014425726500540","field2":"","cale2":"cale1","formulaId2":"","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="5259628053011057907" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}即将超期，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                </Param>
            </Action>
            <Action id="7756168488326742470" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}即将超期]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="2798866997930444753" name="完成期限超期（按季度）" state="1" type="1" formId="-7663681133104185262" creator="738181485194463946" createTime="2017-07-10 19:51:06" modifyTime="2017-07-20 11:13:32">
        <ConditionList>
            <Condition type="form" formulaId="8702677259821335381" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-6931073354877088072" param="day" time="17:00" runFormulaId="3376883846567707561" stopFormulaId="-795896656725327852" />
        </ConditionList>
        <ActionList>
            <Action id="-8139189633440331697" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"4805468119426220345","field2":"","cale2":"val","formulaId2":"-9114786599670755690","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="8899128802306509975" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}超期未反馈，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                </Param>
            </Action>
            <Action id="7259947859152619296" type="message" name="null">
                <Param type="msgContent"><![CDATA[督办事项{事项流水号}超期未反馈]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="6607180356006134850" name="完成时限即将超期（按季度）" state="1" type="1" formId="-7663681133104185262" creator="738181485194463946" createTime="2017-07-10 20:06:42" modifyTime="2017-07-24 09:38:47">
        <ConditionList>
            <Condition type="form" formulaId="-4419566016359546548" param="21" />
            <Operation value="and" display="" />
            <Condition type="date" formulaId="-2513174387769917043" param="day" time="17:00" runFormulaId="-4191222964371111612" stopFormulaId="3098743888334570382" />
        </ConditionList>
        <ActionList>
            <Action id="5716560967264651911" type="resetData" name="数据赋值">
                <Param type="ConfigValue"><![CDATA[{"field1":"field0012","cale1":"val","formulaId1":"","fieldValue1":"-7460014425726500540","field2":"","cale2":"cale1","formulaId2":"","fieldValue2":"","field3":"","cale3":"cale1","formulaId3":"","fieldValue3":""}]]></Param>
            </Action>
            <Action id="7645246046877404472" type="message" name="null">
                <Param type="msgContent"><![CDATA[您的督办事项{事项流水号}即将超期，请尽快办理落实。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Multimember@field0134#承办人">
</Prop>                    <Prop type="messageSender" key="FormField" value="Multimember@field0003#责任人">
</Prop>                </Param>
            </Action>
            <Action id="-4064289113662864188" type="message" name="null">
                <Param type="msgContent"><![CDATA[办事项{事项流水号}即将超期。]]></Param>
                <Param type="msgSendSMS"><![CDATA[false]]></Param>
                <Param type="entity">
                    <Prop type="messageSender" key="FormField" value="Member@field0095#督办承办人">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
  </EventList>
</Trigger>', '<Bind id="-8180793962035000829" >
    <FormCode ></FormCode>
    <FormBindAuthList >
        <FormBindAuth id="1165958230867985974" name="我关注事项列表" formId="-7663681133104185262" creator="-2937103766103699883" modifyTime="2017-06-19 17:16:35" createTime="2017-05-22 17:35:53" >
            <ShowFieldList >
                <Colum id="0" name="formmain_0013.field0012" type="showField" value="预警" display="" />
                <Colum id="0" name="formmain_0013.field0023" type="showField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="showField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="showField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="showField" value="责任单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0028" type="showField" value="完成进度" display="" />
                <Colum id="0" name="formmain_0013.field0024" type="showField" value="事项状态" display="" />
                <Colum id="0" name="formmain_0013.field0098" type="showField" value="立项时间" display="" />
                <Colum id="0" name="formmain_0013.field0002" type="showField" value="协办单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0003" type="showField" value="责任人" display="" />
                <Colum id="0" name="formmain_0013.field0005" type="showField" value="D2自评" display="" />
                <Colum id="0" name="formmain_0013.field0006" type="showField" value="D2考核评价" display="" />
                <Colum id="0" name="formmain_0013.field0007" type="showField" value="D2等级" display="" />
                <Colum id="0" name="formmain_0013.field0008" type="showField" value="D2得分" display="" />
                <Colum id="0" name="formmain_0013.field0009" type="showField" value="提醒次数" display="" />
                <Colum id="0" name="formmain_0013.field0010" type="showField" value="催办次数" display="" />
                <Colum id="0" name="formmain_0013.field0011" type="showField" value="变更次数" display="" />
                <Colum id="0" name="formmain_0013.field0013" type="showField" value="表单流水号" display="" />
                <Colum id="0" name="formmain_0013.field0014" type="showField" value="责任人联系电话" display="" />
                <Colum id="0" name="formmain_0013.field0015" type="showField" value="责任领导" display="" />
                <Colum id="0" name="formmain_0013.field0016" type="showField" value="协办人" display="" />
                <Colum id="0" name="formmain_0013.field0017" type="showField" value="开始时间" display="" />
                <Colum id="0" name="formmain_0013.field0018" type="showField" value="实际完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0019" type="showField" value="上级事项" display="" />
                <Colum id="0" name="formmain_0013.field0020" type="showField" value="专报名称" display="" />
                <Colum id="0" name="formmain_0013.field0021" type="showField" value="期号" display="" />
                <Colum id="0" name="formmain_0013.field0025" type="showField" value="事项流水号" display="" />
                <Colum id="0" name="formmain_0013.field0026" type="showField" value="督查要求" display="" />
                <Colum id="0" name="formmain_0013.field0027" type="showField" value="目标事项" display="" />
                <Colum id="0" name="formmain_0013.field0029" type="showField" value="事项数" display="" />
                <Colum id="0" name="formmain_0013.field0030" type="showField" value="事项完成总进度" display="" />
                <Colum id="0" name="formmain_0013.field0085" type="showField" value="会议类型" display="" />
                <Colum id="0" name="formmain_0013.field0087" type="showField" value="交办单位" display="" />
                <Colum id="0" name="formmain_0013.field0088" type="showField" value="批示领导" display="" />
                <Colum id="0" name="formmain_0013.field0089" type="showField" value="会议期次" display="" />
                <Colum id="0" name="formmain_0013.field0090" type="showField" value="会议名称" display="" />
                <Colum id="0" name="formmain_0013.field0091" type="showField" value="议题序号" display="" />
                <Colum id="0" name="formmain_0013.field0094" type="showField" value="分管秘书长" display="" />
                <Colum id="0" name="formmain_0013.field0095" type="showField" value="督办承办人" display="" />
                <Colum id="0" name="formmain_0013.field0096" type="showField" value="分管领导" display="" />
                <Colum id="0" name="formmain_0013.field0099" type="showField" value="紧急程度" display="" />
                <Colum id="0" name="formmain_0013.field0100" type="showField" value="目标来源" display="" />
                <Colum id="0" name="formmain_0013.field0101" type="showField" value="批示内容" display="" />
                <Colum id="0" name="formmain_0013.field0113" type="showField" value="创建人单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0115" type="showField" value="关注次数" display="" />
                <Colum id="0" name="formmain_0013.field0117" type="showField" value="超期次数" display="" />
                <Colum id="0" name="formmain_0013.field0118" type="showField" value="批示次数" display="" />
                <Colum id="0" name="formmain_0013.field0121" type="showField" value="创建人记录" display="" />
            </ShowFieldList>
            <OrderByList >
                <Colum id="0" name="formmain_0013.field0098" type="orderBy" value="desc" display="" />
                <Colum id="0" name="formmain_0013.field0012" type="orderBy" value="desc" display="" />
            </OrderByList>
            <SearchFieldList >
                <Colum id="0" name="formmain_0013.field0023" type="searchField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="searchField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="searchField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="searchField" value="责任单位部门" display="" />
            </SearchFieldList>
            <AuthList >
                <Colum id="0" name="authId" type="auth" value="1630749822102684132" display="" />
                <Colum id="0" name="add" type="auth" value="-1617523181331529596.-7580123277247037073" display="新建" />
                <Colum id="0" name="browse" type="auth" value="-1617523181331529596.8070703209676361228|7514088449302284502.-5859303747312402370|-1767071477650011160.-4506286724901418432|897192652241258698.-9195869307764651996|-6206666125536768295.6710205425598285130|" display="" />
                <Colum id="0" name="bathupdate" type="auth" value="" display="" />
                <Colum id="0" name="bathFresh" type="auth" value="false" display="" />
                <Colum id="0" name="allowdelete" type="auth" value="false" display="" />
                <Colum id="0" name="allowlock" type="auth" value="false" display="" />
                <Colum id="0" name="allowexport" type="auth" value="false" display="" />
                <Colum id="0" name="allowquery" type="auth" value="false" display="" />
                <Colum id="0" name="allowreport" type="auth" value="false" display="" />
                <Colum id="0" name="allowprint" type="auth" value="false" display="" />
                <Colum id="0" name="allowlog" type="auth" value="false" display="" />
                <Colum id="0" name="formula" type="auth" value="-4807805530660713400" display="" />
                <Colum id="0" name="authName" type="auth" value="我关注的事项" display="" />
            </AuthList>
        </FormBindAuth>
        <FormBindAuth id="-8931160783830168002" name="督办超期事项列表" formId="-7663681133104185262" creator="-2937103766103699883" modifyTime="2017-07-17 17:30:10" createTime="2017-05-22 18:00:33" >
            <ShowFieldList >
                <Colum id="0" name="formmain_0013.field0012" type="showField" value="预警" display="" />
                <Colum id="0" name="formmain_0013.field0023" type="showField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="showField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="showField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="showField" value="责任单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0028" type="showField" value="完成进度" display="" />
                <Colum id="0" name="formmain_0013.field0024" type="showField" value="事项状态" display="" />
                <Colum id="0" name="formmain_0013.field0098" type="showField" value="立项时间" display="" />
                <Colum id="0" name="formmain_0013.field0002" type="showField" value="协办单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0003" type="showField" value="责任人" display="" />
                <Colum id="0" name="formmain_0013.field0005" type="showField" value="D2自评" display="" />
                <Colum id="0" name="formmain_0013.field0006" type="showField" value="D2考核评价" display="" />
                <Colum id="0" name="formmain_0013.field0007" type="showField" value="D2等级" display="" />
                <Colum id="0" name="formmain_0013.field0008" type="showField" value="D2得分" display="" />
                <Colum id="0" name="formmain_0013.field0009" type="showField" value="提醒次数" display="" />
                <Colum id="0" name="formmain_0013.field0010" type="showField" value="催办次数" display="" />
                <Colum id="0" name="formmain_0013.field0011" type="showField" value="变更次数" display="" />
                <Colum id="0" name="formmain_0013.field0013" type="showField" value="表单流水号" display="" />
                <Colum id="0" name="formmain_0013.field0014" type="showField" value="责任人联系电话" display="" />
                <Colum id="0" name="formmain_0013.field0015" type="showField" value="责任领导" display="" />
                <Colum id="0" name="formmain_0013.field0016" type="showField" value="协办人" display="" />
                <Colum id="0" name="formmain_0013.field0017" type="showField" value="开始时间" display="" />
                <Colum id="0" name="formmain_0013.field0018" type="showField" value="实际完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0019" type="showField" value="上级事项" display="" />
                <Colum id="0" name="formmain_0013.field0020" type="showField" value="专报名称" display="" />
                <Colum id="0" name="formmain_0013.field0021" type="showField" value="期号" display="" />
                <Colum id="0" name="formmain_0013.field0025" type="showField" value="事项流水号" display="" />
                <Colum id="0" name="formmain_0013.field0026" type="showField" value="督查要求" display="" />
                <Colum id="0" name="formmain_0013.field0027" type="showField" value="目标事项" display="" />
                <Colum id="0" name="formmain_0013.field0029" type="showField" value="事项数" display="" />
                <Colum id="0" name="formmain_0013.field0030" type="showField" value="事项完成总进度" display="" />
                <Colum id="0" name="formmain_0013.field0085" type="showField" value="会议类型" display="" />
                <Colum id="0" name="formmain_0013.field0087" type="showField" value="交办单位" display="" />
                <Colum id="0" name="formmain_0013.field0088" type="showField" value="批示领导" display="" />
                <Colum id="0" name="formmain_0013.field0089" type="showField" value="会议期次" display="" />
                <Colum id="0" name="formmain_0013.field0090" type="showField" value="会议名称" display="" />
                <Colum id="0" name="formmain_0013.field0091" type="showField" value="议题序号" display="" />
                <Colum id="0" name="formmain_0013.field0094" type="showField" value="分管秘书长" display="" />
                <Colum id="0" name="formmain_0013.field0095" type="showField" value="督办承办人" display="" />
                <Colum id="0" name="formmain_0013.field0096" type="showField" value="分管领导" display="" />
                <Colum id="0" name="formmain_0013.field0099" type="showField" value="紧急程度" display="" />
                <Colum id="0" name="formmain_0013.field0100" type="showField" value="目标来源" display="" />
                <Colum id="0" name="formmain_0013.field0101" type="showField" value="批示内容" display="" />
                <Colum id="0" name="formmain_0013.field0113" type="showField" value="创建人单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0115" type="showField" value="关注次数" display="" />
                <Colum id="0" name="formmain_0013.field0117" type="showField" value="超期次数" display="" />
                <Colum id="0" name="formmain_0013.field0118" type="showField" value="批示次数" display="" />
                <Colum id="0" name="formmain_0013.field0121" type="showField" value="创建人记录" display="" />
            </ShowFieldList>
            <OrderByList >
                <Colum id="0" name="formmain_0013.field0098" type="orderBy" value="desc" display="" />
                <Colum id="0" name="formmain_0013.field0012" type="orderBy" value="desc" display="" />
            </OrderByList>
            <SearchFieldList >
                <Colum id="0" name="formmain_0013.field0023" type="searchField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="searchField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="searchField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="searchField" value="责任单位部门" display="" />
            </SearchFieldList>
            <AuthList >
                <Colum id="0" name="authId" type="auth" value="175178484144882172" display="" />
                <Colum id="0" name="add" type="auth" value="-1617523181331529596.-7580123277247037073" display="新建" />
                <Colum id="0" name="browse" type="auth" value="-1617523181331529596.8070703209676361228|7514088449302284502.-5859303747312402370|-1767071477650011160.-4506286724901418432|897192652241258698.-9195869307764651996|-6206666125536768295.6710205425598285130|" display="" />
                <Colum id="0" name="bathupdate" type="auth" value="" display="" />
                <Colum id="0" name="bathFresh" type="auth" value="false" display="" />
                <Colum id="0" name="allowdelete" type="auth" value="false" display="" />
                <Colum id="0" name="allowlock" type="auth" value="false" display="" />
                <Colum id="0" name="allowexport" type="auth" value="true" display="" />
                <Colum id="0" name="allowquery" type="auth" value="false" display="" />
                <Colum id="0" name="allowreport" type="auth" value="false" display="" />
                <Colum id="0" name="allowprint" type="auth" value="false" display="" />
                <Colum id="0" name="allowlog" type="auth" value="false" display="" />
                <Colum id="0" name="formula" type="auth" value="-9140989192968451618" display="" />
                <Colum id="0" name="authName" type="auth" value="督办超期事项列表" display="" />
                <Colum id="0" name="update" type="auth" value="-1617523181331529596.850948738971813949" display="修改" modifyShowDeal="false" />
            </AuthList>
        </FormBindAuth>
        <FormBindAuth id="7379012689255943666" name="督办事项列表" formId="-7663681133104185262" creator="-2937103766103699883" modifyTime="2017-06-19 17:17:16" createTime="2017-05-23 11:44:01" >
            <ShowFieldList >
                <Colum id="0" name="formmain_0013.field0012" type="showField" value="预警" display="" />
                <Colum id="0" name="formmain_0013.field0023" type="showField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="showField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0096" type="showField" value="分管领导" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="showField" value="责任单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0095" type="showField" value="督办承办人" display="" />
                <Colum id="0" name="formmain_0013.field0101" type="showField" value="批示内容" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="showField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0028" type="showField" value="完成进度" display="" />
                <Colum id="0" name="formmain_0013.field0002" type="showField" value="协办单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0003" type="showField" value="责任人" display="" />
                <Colum id="0" name="formmain_0013.field0005" type="showField" value="D2自评" display="" />
                <Colum id="0" name="formmain_0013.field0006" type="showField" value="D2考核评价" display="" />
                <Colum id="0" name="formmain_0013.field0007" type="showField" value="D2等级" display="" />
                <Colum id="0" name="formmain_0013.field0008" type="showField" value="D2得分" display="" />
                <Colum id="0" name="formmain_0013.field0009" type="showField" value="提醒次数" display="" />
                <Colum id="0" name="formmain_0013.field0010" type="showField" value="催办次数" display="" />
                <Colum id="0" name="formmain_0013.field0011" type="showField" value="变更次数" display="" />
                <Colum id="0" name="formmain_0013.field0013" type="showField" value="表单流水号" display="" />
                <Colum id="0" name="formmain_0013.field0014" type="showField" value="责任人联系电话" display="" />
                <Colum id="0" name="formmain_0013.field0015" type="showField" value="责任领导" display="" />
                <Colum id="0" name="formmain_0013.field0016" type="showField" value="协办人" display="" />
                <Colum id="0" name="formmain_0013.field0017" type="showField" value="开始时间" display="" />
                <Colum id="0" name="formmain_0013.field0018" type="showField" value="实际完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0019" type="showField" value="上级事项" display="" />
                <Colum id="0" name="formmain_0013.field0020" type="showField" value="专报名称" display="" />
                <Colum id="0" name="formmain_0013.field0021" type="showField" value="期号" display="" />
                <Colum id="0" name="formmain_0013.field0024" type="showField" value="事项状态" display="" />
                <Colum id="0" name="formmain_0013.field0025" type="showField" value="事项流水号" display="" />
                <Colum id="0" name="formmain_0013.field0026" type="showField" value="督查要求" display="" />
                <Colum id="0" name="formmain_0013.field0027" type="showField" value="目标事项" display="" />
                <Colum id="0" name="formmain_0013.field0029" type="showField" value="事项数" display="" />
                <Colum id="0" name="formmain_0013.field0030" type="showField" value="事项完成总进度" display="" />
                <Colum id="0" name="formmain_0013.field0085" type="showField" value="会议类型" display="" />
                <Colum id="0" name="formmain_0013.field0087" type="showField" value="交办单位" display="" />
                <Colum id="0" name="formmain_0013.field0088" type="showField" value="批示领导" display="" />
                <Colum id="0" name="formmain_0013.field0089" type="showField" value="会议期次" display="" />
                <Colum id="0" name="formmain_0013.field0090" type="showField" value="会议名称" display="" />
                <Colum id="0" name="formmain_0013.field0091" type="showField" value="议题序号" display="" />
                <Colum id="0" name="formmain_0013.field0094" type="showField" value="分管秘书长" display="" />
                <Colum id="0" name="formmain_0013.field0098" type="showField" value="立项时间" display="" />
                <Colum id="0" name="formmain_0013.field0099" type="showField" value="紧急程度" display="" />
                <Colum id="0" name="formmain_0013.field0100" type="showField" value="目标来源" display="" />
                <Colum id="0" name="formmain_0013.field0113" type="showField" value="创建人单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0115" type="showField" value="关注次数" display="" />
                <Colum id="0" name="formmain_0013.field0117" type="showField" value="超期次数" display="" />
                <Colum id="0" name="formmain_0013.field0118" type="showField" value="批示次数" display="" />
                <Colum id="0" name="formmain_0013.field0121" type="showField" value="创建人记录" display="" />
            </ShowFieldList>
            <OrderByList >
                <Colum id="0" name="formmain_0013.field0098" type="orderBy" value="desc" display="" />
                <Colum id="0" name="formmain_0013.field0012" type="orderBy" value="desc" display="" />
            </OrderByList>
            <SearchFieldList >
                <Colum id="0" name="formmain_0013.field0023" type="searchField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="searchField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="searchField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="searchField" value="责任单位部门" display="" />
            </SearchFieldList>
            <AuthList >
                <Colum id="0" name="authId" type="auth" value="2099270470776472966" display="" />
                <Colum id="0" name="add" type="auth" value="-1617523181331529596.-7580123277247037073" display="新建" />
                <Colum id="0" name="browse" type="auth" value="-1617523181331529596.8070703209676361228|7514088449302284502.-5859303747312402370|-1767071477650011160.-4506286724901418432|897192652241258698.-9195869307764651996|-6206666125536768295.6710205425598285130|" display="" />
                <Colum id="0" name="bathupdate" type="auth" value="" display="" />
                <Colum id="0" name="bathFresh" type="auth" value="false" display="" />
                <Colum id="0" name="allowdelete" type="auth" value="false" display="" />
                <Colum id="0" name="allowlock" type="auth" value="false" display="" />
                <Colum id="0" name="allowexport" type="auth" value="false" display="" />
                <Colum id="0" name="allowquery" type="auth" value="false" display="" />
                <Colum id="0" name="allowreport" type="auth" value="false" display="" />
                <Colum id="0" name="allowprint" type="auth" value="false" display="" />
                <Colum id="0" name="allowlog" type="auth" value="false" display="" />
                <Colum id="0" name="formula" type="auth" value="" display="" />
                <Colum id="0" name="authName" type="auth" value="督办事项列表" display="" />
            </AuthList>
        </FormBindAuth>
        <FormBindAuth id="-3699595133610867258" name="领导交办事项列表" formId="-7663681133104185262" creator="-2937103766103699883" modifyTime="2017-06-19 17:17:23" createTime="2017-05-23 13:23:15" >
            <ShowFieldList >
                <Colum id="0" name="formmain_0013.field0012" type="showField" value="预警" display="" />
                <Colum id="0" name="formmain_0013.field0023" type="showField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0088" type="showField" value="批示领导" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="showField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="showField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="showField" value="责任单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0095" type="showField" value="督办承办人" display="" />
                <Colum id="0" name="formmain_0013.field0099" type="showField" value="紧急程度" display="" />
                <Colum id="0" name="formmain_0013.field0028" type="showField" value="完成进度" display="" />
                <Colum id="0" name="formmain_0013.field0002" type="showField" value="协办单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0003" type="showField" value="责任人" display="" />
                <Colum id="0" name="formmain_0013.field0005" type="showField" value="D2自评" display="" />
                <Colum id="0" name="formmain_0013.field0006" type="showField" value="D2考核评价" display="" />
                <Colum id="0" name="formmain_0013.field0007" type="showField" value="D2等级" display="" />
                <Colum id="0" name="formmain_0013.field0008" type="showField" value="D2得分" display="" />
                <Colum id="0" name="formmain_0013.field0009" type="showField" value="提醒次数" display="" />
                <Colum id="0" name="formmain_0013.field0010" type="showField" value="催办次数" display="" />
                <Colum id="0" name="formmain_0013.field0011" type="showField" value="变更次数" display="" />
                <Colum id="0" name="formmain_0013.field0013" type="showField" value="表单流水号" display="" />
                <Colum id="0" name="formmain_0013.field0014" type="showField" value="责任人联系电话" display="" />
                <Colum id="0" name="formmain_0013.field0015" type="showField" value="责任领导" display="" />
                <Colum id="0" name="formmain_0013.field0016" type="showField" value="协办人" display="" />
                <Colum id="0" name="formmain_0013.field0017" type="showField" value="开始时间" display="" />
                <Colum id="0" name="formmain_0013.field0018" type="showField" value="实际完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0019" type="showField" value="上级事项" display="" />
                <Colum id="0" name="formmain_0013.field0020" type="showField" value="专报名称" display="" />
                <Colum id="0" name="formmain_0013.field0021" type="showField" value="期号" display="" />
                <Colum id="0" name="formmain_0013.field0024" type="showField" value="事项状态" display="" />
                <Colum id="0" name="formmain_0013.field0025" type="showField" value="事项流水号" display="" />
                <Colum id="0" name="formmain_0013.field0026" type="showField" value="督查要求" display="" />
                <Colum id="0" name="formmain_0013.field0027" type="showField" value="目标事项" display="" />
                <Colum id="0" name="formmain_0013.field0029" type="showField" value="事项数" display="" />
                <Colum id="0" name="formmain_0013.field0030" type="showField" value="事项完成总进度" display="" />
                <Colum id="0" name="formmain_0013.field0085" type="showField" value="会议类型" display="" />
                <Colum id="0" name="formmain_0013.field0087" type="showField" value="交办单位" display="" />
                <Colum id="0" name="formmain_0013.field0089" type="showField" value="会议期次" display="" />
                <Colum id="0" name="formmain_0013.field0090" type="showField" value="会议名称" display="" />
                <Colum id="0" name="formmain_0013.field0091" type="showField" value="议题序号" display="" />
                <Colum id="0" name="formmain_0013.field0094" type="showField" value="分管秘书长" display="" />
                <Colum id="0" name="formmain_0013.field0096" type="showField" value="分管领导" display="" />
                <Colum id="0" name="formmain_0013.field0098" type="showField" value="立项时间" display="" />
                <Colum id="0" name="formmain_0013.field0100" type="showField" value="目标来源" display="" />
                <Colum id="0" name="formmain_0013.field0101" type="showField" value="批示内容" display="" />
                <Colum id="0" name="formmain_0013.field0113" type="showField" value="创建人单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0115" type="showField" value="关注次数" display="" />
                <Colum id="0" name="formmain_0013.field0117" type="showField" value="超期次数" display="" />
                <Colum id="0" name="formmain_0013.field0118" type="showField" value="批示次数" display="" />
                <Colum id="0" name="formmain_0013.field0121" type="showField" value="创建人记录" display="" />
            </ShowFieldList>
            <OrderByList >
                <Colum id="0" name="formmain_0013.field0098" type="orderBy" value="desc" display="" />
                <Colum id="0" name="formmain_0013.field0012" type="orderBy" value="desc" display="" />
            </OrderByList>
            <SearchFieldList >
                <Colum id="0" name="formmain_0013.field0023" type="searchField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="searchField" value="责任单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0088" type="searchField" value="批示领导" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="searchField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="searchField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0095" type="searchField" value="督办承办人" display="" />
            </SearchFieldList>
            <AuthList >
                <Colum id="0" name="authId" type="auth" value="760685738275261861" display="" />
                <Colum id="0" name="add" type="auth" value="-1617523181331529596.-7580123277247037073" display="新建" />
                <Colum id="0" name="browse" type="auth" value="-1617523181331529596.8070703209676361228|7514088449302284502.-5859303747312402370|-1767071477650011160.-4506286724901418432|897192652241258698.-9195869307764651996|-6206666125536768295.6710205425598285130|" display="" />
                <Colum id="0" name="bathupdate" type="auth" value="" display="" />
                <Colum id="0" name="bathFresh" type="auth" value="false" display="" />
                <Colum id="0" name="allowdelete" type="auth" value="false" display="" />
                <Colum id="0" name="allowlock" type="auth" value="false" display="" />
                <Colum id="0" name="allowexport" type="auth" value="false" display="" />
                <Colum id="0" name="allowquery" type="auth" value="false" display="" />
                <Colum id="0" name="allowreport" type="auth" value="false" display="" />
                <Colum id="0" name="allowprint" type="auth" value="false" display="" />
                <Colum id="0" name="allowlog" type="auth" value="false" display="" />
                <Colum id="0" name="formula" type="auth" value="" display="" />
                <Colum id="0" name="authName" type="auth" value="领导交办事项列表" display="" />
            </AuthList>
        </FormBindAuth>
        <FormBindAuth id="4770214128208070890" name="来文督办列表" formId="-7663681133104185262" creator="-2937103766103699883" modifyTime="2017-06-19 17:17:30" createTime="2017-05-23 13:25:44" >
            <ShowFieldList >
                <Colum id="0" name="formmain_0013.field0012" type="showField" value="预警" display="" />
                <Colum id="0" name="formmain_0013.field0023" type="showField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="showField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0096" type="showField" value="分管领导" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="showField" value="责任单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0095" type="showField" value="督办承办人" display="" />
                <Colum id="0" name="formmain_0013.field0099" type="showField" value="紧急程度" display="" />
                <Colum id="0" name="formmain_0013.field0101" type="showField" value="批示内容" display="" />
                <Colum id="0" name="formmain_0013.field0028" type="showField" value="完成进度" display="" />
                <Colum id="0" name="formmain_0013.field0002" type="showField" value="协办单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0003" type="showField" value="责任人" display="" />
                <Colum id="0" name="formmain_0013.field0005" type="showField" value="D2自评" display="" />
                <Colum id="0" name="formmain_0013.field0006" type="showField" value="D2考核评价" display="" />
                <Colum id="0" name="formmain_0013.field0007" type="showField" value="D2等级" display="" />
                <Colum id="0" name="formmain_0013.field0008" type="showField" value="D2得分" display="" />
                <Colum id="0" name="formmain_0013.field0009" type="showField" value="提醒次数" display="" />
                <Colum id="0" name="formmain_0013.field0010" type="showField" value="催办次数" display="" />
                <Colum id="0" name="formmain_0013.field0011" type="showField" value="变更次数" display="" />
                <Colum id="0" name="formmain_0013.field0013" type="showField" value="表单流水号" display="" />
                <Colum id="0" name="formmain_0013.field0014" type="showField" value="责任人联系电话" display="" />
                <Colum id="0" name="formmain_0013.field0015" type="showField" value="责任领导" display="" />
                <Colum id="0" name="formmain_0013.field0016" type="showField" value="协办人" display="" />
                <Colum id="0" name="formmain_0013.field0017" type="showField" value="开始时间" display="" />
                <Colum id="0" name="formmain_0013.field0018" type="showField" value="实际完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0019" type="showField" value="上级事项" display="" />
                <Colum id="0" name="formmain_0013.field0020" type="showField" value="专报名称" display="" />
                <Colum id="0" name="formmain_0013.field0021" type="showField" value="期号" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="showField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0024" type="showField" value="事项状态" display="" />
                <Colum id="0" name="formmain_0013.field0025" type="showField" value="事项流水号" display="" />
                <Colum id="0" name="formmain_0013.field0026" type="showField" value="督查要求" display="" />
                <Colum id="0" name="formmain_0013.field0027" type="showField" value="目标事项" display="" />
                <Colum id="0" name="formmain_0013.field0029" type="showField" value="事项数" display="" />
                <Colum id="0" name="formmain_0013.field0030" type="showField" value="事项完成总进度" display="" />
                <Colum id="0" name="formmain_0013.field0085" type="showField" value="会议类型" display="" />
                <Colum id="0" name="formmain_0013.field0087" type="showField" value="交办单位" display="" />
                <Colum id="0" name="formmain_0013.field0088" type="showField" value="批示领导" display="" />
                <Colum id="0" name="formmain_0013.field0089" type="showField" value="会议期次" display="" />
                <Colum id="0" name="formmain_0013.field0090" type="showField" value="会议名称" display="" />
                <Colum id="0" name="formmain_0013.field0091" type="showField" value="议题序号" display="" />
                <Colum id="0" name="formmain_0013.field0094" type="showField" value="分管秘书长" display="" />
                <Colum id="0" name="formmain_0013.field0098" type="showField" value="立项时间" display="" />
                <Colum id="0" name="formmain_0013.field0100" type="showField" value="目标来源" display="" />
                <Colum id="0" name="formmain_0013.field0113" type="showField" value="创建人单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0115" type="showField" value="关注次数" display="" />
                <Colum id="0" name="formmain_0013.field0117" type="showField" value="超期次数" display="" />
                <Colum id="0" name="formmain_0013.field0118" type="showField" value="批示次数" display="" />
                <Colum id="0" name="formmain_0013.field0121" type="showField" value="创建人记录" display="" />
            </ShowFieldList>
            <OrderByList >
                <Colum id="0" name="formmain_0013.field0098" type="orderBy" value="desc" display="" />
                <Colum id="0" name="formmain_0013.field0012" type="orderBy" value="desc" display="" />
            </OrderByList>
            <SearchFieldList >
                <Colum id="0" name="formmain_0013.field0023" type="searchField" value="事项名称" display="" />
                <Colum id="0" name="formmain_0013.field0001" type="searchField" value="责任单位部门" display="" />
                <Colum id="0" name="formmain_0013.field0096" type="searchField" value="分管领导" display="" />
                <Colum id="0" name="formmain_0013.field0004" type="searchField" value="要求完成时间" display="" />
                <Colum id="0" name="formmain_0013.field0022" type="searchField" value="事项分类" display="" />
                <Colum id="0" name="formmain_0013.field0095" type="searchField" value="督办承办人" display="" />
            </SearchFieldList>
            <AuthList >
                <Colum id="0" name="authId" type="auth" value="4363981999036253459" display="" />
                <Colum id="0" name="add" type="auth" value="-1617523181331529596.-7580123277247037073" display="新建" />
                <Colum id="0" name="browse" type="auth" value="-1617523181331529596.8070703209676361228|7514088449302284502.-5859303747312402370|-1767071477650011160.-4506286724901418432|897192652241258698.-9195869307764651996|-6206666125536768295.6710205425598285130|" display="" />
                <Colum id="0" name="bathupdate" type="auth" value="" display="" />
                <Colum id="0" name="bathFresh" type="auth" value="false" display="" />
                <Colum id="0" name="allowdelete" type="auth" value="false" display="" />
                <Colum id="0" name="allowlock" type="auth" value="false" display="" />
                <Colum id="0" name="allowexport" type="auth" value="false" display="" />
                <Colum id="0" name="allowquery" type="auth" value="false" display="" />
                <Colum id="0" name="allowreport" type="auth" value="false" display="" />
                <Colum id="0" name="allowprint" type="auth" value="false" display="" />
                <Colum id="0" name="allowlog" type="auth" value="false" display="" />
                <Colum id="0" name="formula" type="auth" value="" display="" />
                <Colum id="0" name="authName" type="auth" value="来文督办列表" display="" />
            </AuthList>
        </FormBindAuth>
    </FormBindAuthList>
</Bind>
', '<Extensions>
    <UniqueFieldLists >
    <UniqueFieldList >
        <UniqueField name="field0023" />
    </UniqueFieldList>
    <UniqueFieldList >
        <UniqueField name="field0025" />
    </UniqueFieldList>
    </UniqueFieldLists>
</Extensions>', TO_DATE('20180522224832', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="事项台账" id="-7663681133104185262"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0013"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0005" id="1947049709817841270"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="5963600875326818785"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="8743158315334519995"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="3013402179524972120"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0132" id="3993837131572200894"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0133" id="4890920521935637678"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0134" id="5905870092029477413"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0149" id="4147034735481932723"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-3620678578374685115"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0129" id="-1970104555359089719"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-4723177538931110627"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="7918862170998197687"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0101" id="1457979753721775684"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0029" id="7369035896287871585"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="-3353723007726959115"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0089" id="-3691460201640672157"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0098" id="8641224029115663647"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0121" id="-2743474752209927183"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0085" id="5705649805103484897"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-7826020188783885851"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0118" id="7792000909267913274"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0117" id="1575366234956974419"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0091" id="4253975166108713470"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0088" id="-6099568764639493684"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="-1769620599867750064"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0001" id="2101345941514371280"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0030" id="7690922730890611799"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0124" id="8158352381330213997"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="9116768859279476631"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0090" id="-1437927484086596990"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-7179182277899172822"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0115" id="-8469375206575552332"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="-3893931117260158256"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0125" id="1107208716575132225"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0028" id="-1241215904170881462"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0095" id="-3866936559155851675"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0096" id="7229581364791361999"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-5596281353342989450"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0094" id="-9043260523520769585"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0027" id="4049794608879059369"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="6198541753758662881"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0100" id="-8139929554324143202"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0099" id="-8744406953466379129"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0093" id="-2522398103338270700"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-8683724232594994855"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="-2356628156480666461"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="220819349383038056"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0128" id="6874657730616772149"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0126" id="-4533401841961383072"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="6298983490198523770"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="3600251486307434666"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0087" id="4985351614497181034"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="1557407867529678045"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-2302754408745712109"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-3801488554079858960"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0131" id="7688089986691515040"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="7480354057418786350"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0113" id="-583725742937781688"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="4710124130964294582"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0151" id="8619596787229737678"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0014"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0031" id="-4125064441997733944"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0033" id="5033521940682918020"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0036" id="787029518828259940"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0035" id="4492133677929219683"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0032" id="-3129775232782482622"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0034" id="2854903732519716881"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0152" id="1381852623486142283"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0015"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0037" id="2495068025129945451"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0038" id="8743758520747574918"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0040" id="4686408528421080170"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0039" id="-497658021029982820"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0041" id="4204115667440258182"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0016"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0042" id="90955087149419875"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0047" id="1054056980862289353"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0045" id="-2572787266413441973"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0044" id="-4863101099948489381"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0043" id="-4924013921023540268"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0046" id="738214660891297535"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0048" id="2319699220499351852"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0049" id="-8311742307593138892"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0017"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0050" id="-1929399590670479954"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0064" id="3677091262405165913"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0065" id="5213814087237651403"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0066" id="259121936448897898"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0067" id="-3288327967154157790"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0068" id="2667505374046407597"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0069" id="-9168570051817553086"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0070" id="-3879267013485311829"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0147" id="-6095375505062280343"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0062" id="-6273271130730968920"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0136" id="5342144816104361075"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0059" id="-3224798783510787693"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0061" id="2850462042352928919"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0122" id="7762584300984814602"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0148" id="3750932239953841243"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0123" id="4051222077621356378"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0054" id="4907949666892794391"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0051" id="-2133425848735676443"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0063" id="6721503360610225118"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0060" id="-600483292142222730"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0119" id="-8678910066395886612"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0053" id="-3850957852209623770"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0150" id="-2979559197789763131"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0056" id="750540008232206598"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0120" id="-6754365528978864748"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0058" id="620697999204372096"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0052" id="6876736163030191969"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0057" id="-5306217768783821336"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0055" id="4710926583850877342"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0018"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0079" id="3021974611939380070"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0086" id="-4456057903182035238"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0092" id="-960740655952017495"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0097" id="5096648802625605396"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0130" id="-1037318764728856757"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0135" id="-7039223389991647638"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0146" id="-6170045724823108154"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0072" id="-6228575449979009759"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0071" id="2614831650078870652"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0074" id="8201987318901788415"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0075" id="4286574277032889709"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0078" id="-6163317310701680157"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0077" id="38841326179272773"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0073" id="-4043681220377621151"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0076" id="3259183300499097340"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0019"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0084" id="4297272022608203737"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0080" id="-6849509342457738983"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0081" id="8271102089543502174"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0082" id="6055776447866160158"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0083" id="3620952994810183940"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0020"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0102" id="-4020051843566514613"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0114" id="5678572494278574816"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0127" id="-1185362974803669707"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0103" id="6599806957314720260"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0021"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0104" id="7227420175971795845"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0116" id="-5312840653181925182"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0107" id="-586294293922430420"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0106" id="582558198702361185"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0105" id="6497339883592306212"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0108" id="-3933412525758984752"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0022"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0109" id="-2152687216596398762"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0110" id="4183000740774039099"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0111" id="3878295805648456073"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0112" id="-3026848442587855163"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0023"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0137" id="-6279917884510616317"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0140" id="441116292104274471"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0143" id="-3724319374616540034"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0138" id="-4408662127607069674"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0139" id="-3554307852396311211"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0145" id="2890755005759835072"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0142" id="5889527706482262891"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0144" id="906262005958330098"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0141" id="-667791217976064167"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '01135A787E64C5422FA610A4D2D32C1164DD86FBB499CEF4F3F30080F8E8FC7E5CC0524C0AE786EE');
INSERT INTO "FORM_DEFINITION" VALUES (343888736848791432, '费用报销单', -7273032013234748168, TO_DATE('20180522224824', 'YYYYMMDDHH24MISS'), 1, -619573809937168879, 2, 0, 0, '<TableList>
  <Table id="-5568611935115394217" name="formmain_0006" display="formmain_0006" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-8061959845202540652" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="5815809027401140708" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="5499030599981090966" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-8633323445601288026" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="6459436468966146958" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="4321094836915620944" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="3983496560591063686" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-4434074155478595942" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="2246048357759600723" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-5555184229481036433" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="5413502380051220724" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-858192713536287745" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5784979954282837209" name="field0003" display="姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8202526584518523341" name="field0004" display="供职部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="310897874431525797" name="field0005" display="岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3311245361398395033" name="field0006" display="单据数量" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8687508897168604648" name="field0007" display="报销金额小写" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="5533332714198878246" name="field0008" display="报销金额大写" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3669534177308291668" name="field0009" display="借款金额" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="5434763301540545583" name="field0010" display="应退金额" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="2127111598306577664" name="field0011" display="应补金额" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="9213084902001624940" name="field0012" display="供职部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8444867406424883110" name="field0013" display="财务部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7632748130405954984" name="field0014" display="部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5485687594112823689" name="field0015" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3479179187405799597" name="field0016" display="会计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8053314533538446545" name="field0017" display="出纳" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-3997658228392835377" name="formson_0007" display="报销明细" tabletype="slave" onwertable="formmain_0006" onwerfield="formmain_id">
      <FieldList>
          <Field id="-6168657580320536023" name="field0018" display="报销明细-序号" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3031580053423436563" name="field0019" display="报销明细-费用项目" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7897169931951293770" name="field0020" display="报销明细-费用类别" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6897676859670642140" name="field0021" display="报销明细-单据数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1292967741386110070" name="field0022" display="报销明细-金额" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-979825626763277239" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-8850069785359596463" name="填写" filename="Operation_5644957908884212304.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-5609696838406943376" name="审批" filename="Operation_1263100689137290305.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="782976238388201783" name="显示" filename="Operation_-2044960819447969676.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224824', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="费用报销单" id="343888736848791432"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0006"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="5413502380051220724"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-858192713536287745"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-5784979954282837209"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-8202526584518523341"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="310897874431525797"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-3311245361398395033"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-8687508897168604648"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="5533332714198878246"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-3669534177308291668"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="5434763301540545583"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="2127111598306577664"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="9213084902001624940"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-8444867406424883110"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-7632748130405954984"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-5485687594112823689"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="3479179187405799597"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-8053314533538446545"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0007"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0018" id="-6168657580320536023"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="-3031580053423436563"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="7897169931951293770"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="-6897676859670642140"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="-1292967741386110070"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '2F52F7ACD7F4A86BBD276D1B33DE063F1D1E615A841931BFDAE3445FE867585A5887F540BC12AD01');
INSERT INTO "FORM_DEFINITION" VALUES (-823535878356188773, '合同审批单', -7273032013234748168, TO_DATE('20180522224824', 'YYYYMMDDHH24MISS'), 1, -619573809937168879, 2, 0, 0, '<TableList>
  <Table id="-1597359706075086489" name="formmain_0009" display="formmain_0009" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="621995729055924365" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-7335534698867244271" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-7344198968420381770" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="1665859021851549" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="3165432331710385001" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-4401506330646985145" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="3467182089885010329" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-9039081998765898563" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="6040109661237233877" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="7804103234564473125" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="8795937100073157125" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6256286434570160392" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7598266418145964481" name="field0003" display="经办人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5824928044198507117" name="field0004" display="部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1597728822694297528" name="field0005" display="岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1455884693856960105" name="field0006" display="合同名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-612981938491995912" name="field0007" display="合同编号" fieldtype="VARCHAR" fieldlength="90,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3425634596153177621" name="field0008" display="合同文本" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3751364676454927691" name="field0009" display="合同主要内容-合同方名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3803066868510508582" name="field0010" display="合同主要内容-合同总金额小写" fieldtype="DECIMAL" fieldlength="12,2" is_null="false" is_primary="false" classname=""/>
          <Field id="-2689160738636741031" name="field0011" display="合同主要内容-合同总金额大写" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8291262406781127093" name="field0012" display="合同主要内容-合同期限开始日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8255711097423377744" name="field0013" display="合同主要内容-合同期限结束日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="364368237097470449" name="field0014" display="合同主要内容-重要条款" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3498986569849848209" name="field0015" display="部门负责人意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1116702542727105454" name="field0016" display="法务意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5150626154121282348" name="field0017" display="部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4795150599810138655" name="field0018" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1046410176908706325" name="field0019" display="经办人说明-正式合同文本" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-350881801578135352" name="field0020" display="经办人说明-合同修改情况" fieldtype="VARCHAR" fieldlength="600,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3614366434027982523" name="field0021" display="印章使用记录-印章名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8533752463659516327" name="field0022" display="印章使用记录-用印日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7836619796368179119" name="field0023" display="印章使用记录-合同份数" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1933262744847993788" name="field0024" display="印章使用记录-用印数量" fieldtype="DECIMAL" fieldlength="3,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6937928072326827817" name="field0025" display="印章使用记录-操作人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="5777516619625287439" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="2537179835636008095" name="填写" filename="Operation_4228530079224450696.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="5722021340158185333" name="审批" filename="Operation_1107882485171441389.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-4276047163987046519" name="显示" filename="Operation_-8174490946465413164.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224824', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="合同审批单" id="-823535878356188773"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0009"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="8795937100073157125"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="6256286434570160392"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-7598266418145964481"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-5824928044198507117"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-1597728822694297528"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-1455884693856960105"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-612981938491995912"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-3425634596153177621"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="3751364676454927691"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="3803066868510508582"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-2689160738636741031"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="8291262406781127093"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-8255711097423377744"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="364368237097470449"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="3498986569849848209"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="1116702542727105454"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="5150626154121282348"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="4795150599810138655"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="1046410176908706325"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="-350881801578135352"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="3614366434027982523"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="8533752463659516327"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-7836619796368179119"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="1933262744847993788"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="6937928072326827817"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '2418CED890CDD76E741C4A16FAF77A68966EF46D3BD23EE187561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (9123811285288437453, '签收单', -884316703172445, TO_DATE('20180523001202', 'YYYYMMDDHH24MISS'), 6, 403, 1, 2, 0, '<TableList>
  <Table id="8074108440250303622" name="formmain_0026" display="" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-7067580608352858132" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="668483019047912808" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-1297702438760527831" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="3938711818376661315" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-3173488597230729763" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-6867460508698852622" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="1863137175357116304" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-2359610372792237590" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-8448731725794818264" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="8637242901497400999" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-1079213184114406621" name="field0001" display="公文标题" fieldtype="VARCHAR" mappingField="subject" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="-9100547577454051086" name="field0002" display="接收单位" fieldtype="VARCHAR" mappingField="receive_unit" fieldlength="200" is_null="false" is_primary="false" classname=""/>
          <Field id="-3249547460196088978" name="field0003" display="拟稿人" fieldtype="VARCHAR" mappingField="create_person" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="5023192425691105735" name="field0004" display="分送日期" fieldtype="TIMESTAMP" mappingField="packdate" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2134595660550616613" name="field0005" display="发文单位" fieldtype="VARCHAR" mappingField="send_unit" fieldlength="200" is_null="false" is_primary="false" classname=""/>
          <Field id="-4780644543051119441" name="field0006" display="公文级别" fieldtype="VARCHAR" mappingField="unit_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6321365009745398664" name="field0007" display="公文文号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="7095605473145997683" name="field0008" display="公文种类" fieldtype="VARCHAR" mappingField="doc_type" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3826077899316769599" name="field0009" display="签发人" fieldtype="VARCHAR" mappingField="issuer" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="7450242841627214625" name="field0010" display="签发日期" fieldtype="TIMESTAMP" mappingField="signing_date" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2744860298512844834" name="field0011" display="文件密级" fieldtype="VARCHAR" mappingField="secret_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5146563251508262626" name="field0012" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5706664846256158243" name="field0013" display="印发份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2303125935229062052" name="field0014" display="签收人" fieldtype="VARCHAR" mappingField="sign_person" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="1677345945774606252" name="field0015" display="签收日期" fieldtype="TIMESTAMP" mappingField="receipt_date" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5044595830340403403" name="field0016" display="签收编号" fieldtype="VARCHAR" mappingField="sign_mark" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="-4736959951054550075" name="field0017" display="保密期限" fieldtype="VARCHAR" mappingField="keep_period" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6642514705201870796" name="field0018" display="登记人" fieldtype="VARCHAR" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="-7584867391202049606" name="field0019" display="纸质附件说明" fieldtype="VARCHAR" fieldlength="255" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-304566377891017381" name="签收单" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view2.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-4649851046128039136" name="填写" filename="-3190291290280475078.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-7992590917515784767" name="审批" filename="6489330302110222607.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-4718011693225849298" name="显示" filename="7626228620363320529.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180523001202', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="签收单" id="9123811285288437453"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0026"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-1079213184114406621"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-9100547577454051086"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-3249547460196088978"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="5023192425691105735"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-2134595660550616613"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-4780644543051119441"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="6321365009745398664"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="7095605473145997683"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-3826077899316769599"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="7450242841627214625"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="2744860298512844834"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-5146563251508262626"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-5706664846256158243"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="2303125935229062052"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="1677345945774606252"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="5044595830340403403"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-4736959951054550075"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="-6642514705201870796"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="-7584867391202049606"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, 'B8C46E7750D3599E092B33BCD36AB70FE3EA5286E96558F687561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (2716575996775056756, '请休假审批单', -7273032013234748168, TO_DATE('20180522224823', 'YYYYMMDDHH24MISS'), 1, 706798653460660266, 2, 0, 0, '<TableList>
  <Table id="-4428787388813652006" name="formmain_0003" display="formmain_0003" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-4637690241362868303" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="2153770360641310351" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-7991125984352581748" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-3173448529923325261" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-2849750649943930753" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="5653909820775944030" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="8835852512525110567" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="5430177187993503914" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="5710785553651747144" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="4929600495079804571" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-5405080154243053723" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7085631749679595323" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1871848375472730986" name="field0003" display="姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7118695599521743495" name="field0004" display="部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3689843295653872311" name="field0005" display="岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3402230641155393467" name="field0006" display="请休假天数-起始日期时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="267239334381899064" name="field0007" display="请休假天数-终止日期时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="721625532142798420" name="field0008" display="请休假天数-合计天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="7185457418529555805" name="field0009" display="请休假天数-年休" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-6687351905662385579" name="field0010" display="请休假天数-调休" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-2949355972289411652" name="field0011" display="请休假天数-病假" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="7771519064197449434" name="field0012" display="请休假天数-事假" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="8016157878058830305" name="field0013" display="请休假天数-婚假" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-1815099149229929650" name="field0014" display="请休假天数-丧假" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="2302844848925263684" name="field0015" display="请休假天数-产假" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="128101026381580904" name="field0016" display="请休假天数-工伤假" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-1292194192763436559" name="field0017" display="请休假有关证明文件" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-703072851147666376" name="field0018" display="请休假事由" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4492247647427998786" name="field0019" display="部门负责人意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8409360656538188724" name="field0020" display="行政部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4017092625341133289" name="field0021" display="部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4305733723893222067" name="field0022" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9159453738577149391" name="field0023" display="请休假记录-起始日期时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9187118784102905465" name="field0024" display="请休假记录-终止日期时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8787086569161931061" name="field0025" display="请休假记录-合计天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="7597136399989621222" name="field0026" display="请休假记录-年休天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="7800101599882068173" name="field0027" display="请休假记录-调休天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="6193099718618333903" name="field0028" display="请休假记录-病假天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="6066144542361535993" name="field0029" display="请休假记录-事假天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="3005320713158280848" name="field0030" display="请休假记录-婚假天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="1940149199389148000" name="field0031" display="请休假记录-丧假天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-6564445654029745064" name="field0032" display="请休假记录-产假天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="2460080463372566813" name="field0033" display="请休假记录-工伤假天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-4975681865161291845" name="field0034" display="请休假记录-说明" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-4704460338741624514" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="5119647528712817279" name="填写" filename="Operation_1554521157018602509.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="3112247090962712865" name="审批" filename="Operation_7273650750694508826.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-70633080038407731" name="显示" filename="Operation_-5468431984747855061.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224823', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="请休假审批单" id="2716575996775056756"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0003"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-5405080154243053723"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-7085631749679595323"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-1871848375472730986"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="7118695599521743495"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="3689843295653872311"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="3402230641155393467"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="267239334381899064"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="721625532142798420"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="7185457418529555805"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-6687351905662385579"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-2949355972289411652"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="7771519064197449434"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="8016157878058830305"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-1815099149229929650"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="2302844848925263684"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="128101026381580904"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-1292194192763436559"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="-703072851147666376"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="-4492247647427998786"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="-8409360656538188724"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="-4017092625341133289"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="4305733723893222067"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-9159453738577149391"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-9187118784102905465"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="-8787086569161931061"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="7597136399989621222"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0027" id="7800101599882068173"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0028" id="6193099718618333903"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0029" id="6066144542361535993"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0030" id="3005320713158280848"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0031" id="1940149199389148000"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0032" id="-6564445654029745064"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0033" id="2460080463372566813"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0034" id="-4975681865161291845"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '98C4551A2095709FEAB94D88F334C6758115DB66A2239E4087561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (-3968531576091490243, '出差审批单', -7273032013234748168, TO_DATE('20180522224823', 'YYYYMMDDHH24MISS'), 1, 706798653460660266, 2, 0, 0, '<TableList>
  <Table id="-4479738270429264982" name="formmain_0004" display="formmain_0004" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="1715685403719255943" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-5950813534881625774" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="3395064934425249124" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="1241720314848429958" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="7978617199565950711" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6777884255506678669" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="1497233463608887224" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-2595811774358991454" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-4809182383555591328" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-447776470672916035" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="193558738108368667" name="field0001" display="编号" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1450562949416007030" name="field0002" display="填写日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="9120718508775522951" name="field0003" display="姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2366655408696344961" name="field0004" display="部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3813694840479005805" name="field0005" display="岗位职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-103473225856234831" name="field0006" display="出发地" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8334908485844185272" name="field0007" display="目的地" fieldtype="VARCHAR" fieldlength="30,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2621175775469192922" name="field0008" display="同行人员" fieldtype="VARCHAR" fieldlength="90,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4807992356340057724" name="field0009" display="出差日期-出发日期时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1363350978187017654" name="field0010" display="出差日期-返回日期时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2216362778047303563" name="field0011" display="出差日期-预计天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="8226799985166862507" name="field0012" display="预借款项" fieldtype="DECIMAL" fieldlength="7,2" is_null="false" is_primary="false" classname=""/>
          <Field id="8914404942759481118" name="field0013" display="出差事由" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6331473683678645792" name="field0014" display="交通工具-公共汽车" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7032552322092871853" name="field0015" display="交通工具-自驾车" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8189562758709987057" name="field0016" display="交通工具-普速列出硬卧" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3943051523556226843" name="field0017" display="交通工具-普速列车软卧" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1476008207420142296" name="field0018" display="交通工具-高速列车座席" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8457312965141614516" name="field0019" display="交通工具-高速列车卧铺" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8054126157062423935" name="field0020" display="交通工具-飞机" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4739840486724712948" name="field0021" display="部门负责人意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7689178488092933171" name="field0022" display="行政部门意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5087635993208901490" name="field0023" display="部门分管领导意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3974820825642809013" name="field0024" display="总经理意见" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1621792508303949783" name="field0025" display="出差记录_出发日期时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2874651377479301668" name="field0026" display="出差记录-返回日期时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4718081871231882" name="field0027" display="出差记录-天数" fieldtype="DECIMAL" fieldlength="3,1" is_null="false" is_primary="false" classname=""/>
          <Field id="4610525799715456389" name="field0028" display="出差记录-说明" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-7060891642982349975" name="2015年6月版" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-8274470575924820966" name="填写" filename="Operation_9067607578317505054.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-2121275016937648515" name="审批" filename="Operation_4512405027992850158.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-1472334203020099059" name="显示" filename="Operation_4071586060248828709.xml" type="readonly" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224823', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="出差审批单" id="-3968531576091490243"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0004"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="193558738108368667"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-1450562949416007030"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="9120718508775522951"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="2366655408696344961"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-3813694840479005805"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-103473225856234831"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-8334908485844185272"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="2621175775469192922"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="4807992356340057724"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-1363350978187017654"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="2216362778047303563"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="8226799985166862507"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="8914404942759481118"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="6331473683678645792"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-7032552322092871853"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="8189562758709987057"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-3943051523556226843"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="-1476008207420142296"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="8457312965141614516"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="8054126157062423935"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="-4739840486724712948"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="-7689178488092933171"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="5087635993208901490"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-3974820825642809013"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="-1621792508303949783"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="-2874651377479301668"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0027" id="-4718081871231882"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0028" id="4610525799715456389"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 1, '44AF4437DB331C4F8928CA48F557C42EF6155BC63BF276FCF3F30080F8E8FC7E5CC0524C0AE786EE');
INSERT INTO "FORM_DEFINITION" VALUES (1062812201860547208, '签报单', -884316703172445, TO_DATE('20180523001205', 'YYYYMMDDHH24MISS'), 8, 402, 1, 2, 0, '<TableList>
  <Table id="-1610863989567303966" name="formmain_0029" display="" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-3902591863944298020" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="1469477886110745271" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="7383775042241119072" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-7799803854036514213" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-251399162685928989" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="7771622746166742152" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-9089648259275209430" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-5612621552704926492" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-3311500739026795930" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="1747766022680366109" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="624224925492333032" name="field0001" display="公文文号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="6548764901807112329" name="field0002" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3744248570698707650" name="field0003" display="文件密级" fieldtype="VARCHAR" mappingField="secret_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8898369300936635307" name="field0004" display="签发" fieldtype="VARCHAR" mappingField="qianfa" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="756843746032369759" name="field0005" display="会签" fieldtype="VARCHAR" mappingField="huiqian" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5417256713267494605" name="field0006" display="审核" fieldtype="VARCHAR" mappingField="shenhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-690749097281893523" name="field0007" display="办理" fieldtype="VARCHAR" mappingField="banli" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1106343429182015585" name="field0008" display="发文单位" fieldtype="VARCHAR" mappingField="send_unit" fieldlength="200" is_null="false" is_primary="false" classname=""/>
          <Field id="7504592134900763875" name="field0009" display="签发日期" fieldtype="TIMESTAMP" mappingField="signing_date" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2292674577700504961" name="field0010" display="拟稿人" fieldtype="VARCHAR" mappingField="create_person" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="-8758268139923748138" name="field0011" display="联系电话" fieldtype="VARCHAR" mappingField="phone" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="-4538152593564676728" name="field0012" display="印发份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7543795104166660273" name="field0013" display="公文标题" fieldtype="VARCHAR" mappingField="subject" fieldlength="255" is_null="false" is_primary="false" classname=""/>
          <Field id="3732212190757930133" name="field0014" display="主送单位" fieldtype="VARCHAR" mappingField="send_to" fieldlength="4000" is_null="false" is_primary="false" classname=""/>
          <Field id="-881903722195563632" name="field0015" display="抄送单位" fieldtype="VARCHAR" mappingField="copy_to" fieldlength="4000" is_null="false" is_primary="false" classname=""/>
          <Field id="5517605407675531930" name="field0016" display="附件" fieldtype="VARCHAR" mappingField="attachments" fieldlength="255" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="4329882633032646742" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="7723832131949511734" name="填写" filename="879827358046899252.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="1354828810591882176" name="审批" filename="4681607657610825265.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="6990886211219442848" name="显示" filename="4060604207917845574.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180523001205', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="签报单" id="1062812201860547208"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0029"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="624224925492333032"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="6548764901807112329"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-3744248570698707650"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-8898369300936635307"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="756843746032369759"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-5417256713267494605"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-690749097281893523"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="1106343429182015585"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="7504592134900763875"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="2292674577700504961"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-8758268139923748138"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-4538152593564676728"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="7543795104166660273"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="3732212190757930133"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-881903722195563632"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="5517605407675531930"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, 'A09CF9ED5E039D06C7715C52E958A2DAF4C58EA0E216B5E287561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (1203914004254770317, '督办变更单', 738181485194463946, TO_DATE('20180522224828', 'YYYYMMDDHH24MISS'), 1, 4358901251920773292, 0, 2, 0, '<TableList>
  <Table id="-5810157455114482487" name="formmain_0024" display="formmain_0024" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="665334270404349438" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="310516131284666209" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-6826447967413648410" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-1349165578414896849" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-6252307632939709752" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="3405545681443439006" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="7044270031150075197" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-7525134429232216013" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="6522247990657368455" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-8013606820278876536" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-8702980086565879172" name="field0001" display="变更主题" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1918278871742103688" name="field0002" display="申请单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1061314711420907919" name="field0003" display="申请人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="368940028920416935" name="field0004" display="申请时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4658725206201974166" name="field0005" display="变更类型" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8890151337318236194" name="field0006" display="变更事项" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2842770753415002257" name="field0007" display="申请原因" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2234564360062192046" name="field0008" display="审批意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6868970664632992953" name="field0009" display="督办人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5289364664543563529" name="field0010" display="完成时限" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1687689312276466768" name="field0011" display="延长天数" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7639247047540821721" name="field0012" display="延期完成时限" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="1701570661115446707" name="查看视图" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view2.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="6301329175485366629" name="填写" filename="-9125314245190531287.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="3634319680154061659" name="审批" filename="5488702783582715964.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-4479309571470572437" name="显示" filename="7305841547724015461.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
    <Event id="-4887289203921960767" name="事项台账（6-27）" state="1" type="2" formId="1203914004254770317" creator="738181485194463946" createTime="2017-06-29 20:30:35" flowState="1" modifyTime="2017-06-29 20:30:35">
        <ConditionList>
            <Condition type="form" formulaId="-3925252667056435606" param="-7663681133104185262" />
        </ConditionList>
        <ActionList>
            <Action id="3387097497569742786" type="calculate" name="null">
                <Param type="formId"><![CDATA[-7663681133104185262]]></Param>
                <Param type="withholding"><![CDATA[false]]></Param>
                <Param type="addSlaveRow"><![CDATA[true]]></Param>
                <Param type="fillBack">
                    <Prop type="copy" key="formson_0016.field0047" value="flowTitleName">
</Prop>                    <Prop type="copy" key="formson_0016.field0045" value="formmain_0024.field0011">
</Prop>                    <Prop type="copy" key="formson_0016.field0044" value="formmain_0024.field0005">
</Prop>                    <Prop type="copy" key="formson_0016.field0043" value="formmain_0024.field0002">
</Prop>                    <Prop type="copy" key="formson_0016.field0046" value="formmain_0024.field0012">
</Prop>                    <Prop type="copy" key="formson_0016.field0048" value="formmain_0024.field0004">
</Prop>                    <Prop type="copy" key="formson_0016.field0049" value="formmain_0024.field0007">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224830', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="督办变更单" id="1203914004254770317"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0024"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-8702980086565879172"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="1918278871742103688"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-1061314711420907919"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="368940028920416935"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-4658725206201974166"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="8890151337318236194"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-2842770753415002257"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="2234564360062192046"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="6868970664632992953"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="5289364664543563529"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="1687689312276466768"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="7639247047540821721"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, 'EA5556E8CB9FCBCE5C9179F908343719420805591D4DED7987561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (6132300817238279718, '教育培训登记表', -4390973113109755711, TO_DATE('20180606171950', 'YYYYMMDDHH24MISS'), 1, -732547941328516542, 1, 2, 0, '<TableList>
  <Table id="-988665765476545417" name="formmain_0036" display="formmain_0036" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="2579647659164453933" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="7875010036137545524" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-7078778174808244073" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-21961702832322858" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-465481475188636525" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="2735963828164841100" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="8668029861968233350" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-6535582683630908103" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-4579246863303881442" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="5634157939326994960" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="5953554718835360293" name="field0002" display="填报时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-695016091513106882" name="field0003" display="报告人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6398585741019558468" name="field0005" display="职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2847881409017168542" name="field0006" display="联系电话" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5961276322595946732" name="field0009" display="主办单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-578029110492442779" name="field0010" display="开始时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1434453309110336676" name="field0011" display="结束时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1303039550266784479" name="field0012" display="天数" fieldtype="DECIMAL" fieldlength="20,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-1962258160438654916" name="field0013" display="培训总结" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6239633968526411459" name="field0015" display="培训地点" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5305703603949713117" name="field0016" display="施教机构" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5102452025953269650" name="field0018" display="备注" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5730854642051039230" name="field0007" display="培训项目" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5715968936019867233" name="field0004" display="部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3762845720920111733" name="field0001" display="填报部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8823734052561991026" name="field0014" display="单位及职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5195597254400821829" name="field0008" display="培训层次" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5305710443814826122" name="field0017" display="培训类型" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3240331365472946798" name="field0019" display="次数" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="736797583849965657" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="5794820516797434076" name="填写" filename="7239363599480210176.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-8778527874195370165" name="审批" filename="3933342715637678987.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-7058757835753896116" name="显示" filename="1978172939959158959.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
    <Query id="-2647021732741689992" name="培训查询表" formId="6132300817238279718" creator="7561137710640218641" modifyTime="2018-07-29 13:27:44" createTime="2018-07-15 18:53:29" type="0" queryRange="1" >
        <ShowFieldList >
            <Colum id="0" name="formmain_0036.field0001" type="showField" value="填报部门(单位或部门)" display="" />
            <Colum id="0" name="formmain_0036.field0002" type="showField" value="填报时间" display="" />
            <Colum id="0" name="formmain_0036.field0003" type="showField" value="报告人" display="" />
            <Colum id="0" name="formmain_0036.field0004" type="showField" value="部门(单位或部门)" display="" />
            <Colum id="0" name="formmain_0036.field0005" type="showField" value="职务" display="" />
            <Colum id="0" name="formmain_0036.field0006" type="showField" value="联系电话" display="" />
            <Colum id="0" name="formmain_0036.field0007" type="showField" value="培训项目" display="" />
            <Colum id="0" name="formmain_0036.field0008" type="showField" value="培训层次" display="" />
            <Colum id="0" name="formmain_0036.field0017" type="showField" value="培训类型" display="" />
            <Colum id="0" name="formmain_0036.field0009" type="showField" value="主办单位" display="" />
            <Colum id="0" name="formmain_0036.field0015" type="showField" value="培训地点" display="" />
            <Colum id="0" name="formmain_0036.field0016" type="showField" value="施教机构" display="" />
            <Colum id="0" name="formmain_0036.field0010" type="showField" value="开始时间" display="" />
            <Colum id="0" name="formmain_0036.field0011" type="showField" value="结束时间" display="" />
            <Colum id="0" name="formmain_0036.field0012" type="showField" value="天数" display="" />
            <Colum id="0" name="formmain_0036.field0018" type="showField" value="备注" display="" />
        </ShowFieldList>
        <OrderByList >
            <Colum id="0" name="formmain_0036.field0002" type="orderBy" value="desc" display="" />
        </OrderByList>
        <SystemCondition >1279134093630262449</SystemCondition>
        <UserCondition >1084349684562806808</UserCondition>
        <UserFieldList >
            <UserField id="-1" name="开始时间" parentId="-2647021732741689992" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="开始时间" >
                <Input inputType="date" enumId="0" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
            <UserField id="-1" name="结束时间" parentId="-2647021732741689992" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="结束时间" >
                <Input inputType="date" enumId="0" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
            <UserField id="-1" name="部门" parentId="-2647021732741689992" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="部门" >
                <Input inputType="department" enumId="0" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
            <UserField id="-1" name="人员" parentId="-2647021732741689992" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="人员" >
                <Input inputType="member" enumId="0" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
        </UserFieldList>
        <Description ><![CDATA[]]></Description>
    </Query>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180729204202', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="教育培训登记表" id="6132300817238279718"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0036"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0002" id="5953554718835360293"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-695016091513106882"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-6398585741019558468"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="2847881409017168542"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="5961276322595946732"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-578029110492442779"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-1434453309110336676"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-1303039550266784479"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-1962258160438654916"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="6239633968526411459"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="-5305703603949713117"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="-5102452025953269650"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-5730854642051039230"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-5715968936019867233"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0001" id="-3762845720920111733"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-8823734052561991026"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="5195597254400821829"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-5305710443814826122"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="3240331365472946798"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '3EF81015A899794E124B77AF77A58EBD8E557DB8CF56BD1D3966DA19231A071A7949B4961FB7F640C46E55E304E891CBA19F630797382C81A06FE6DC4B6CE19073BAEDF6A0093615');
INSERT INTO "FORM_DEFINITION" VALUES (-40698508916517, '日喀则市县处级及以上领导干部教育培训情况登记表', 2741622736629419309, TO_DATE('20180619151638', 'YYYYMMDDHH24MISS'), 2, -732547941328516542, 1, 2, 0, '<TableList>
  <Table id="-4945170136720063577" name="formmain_0080" display="formmain_0080" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-6234189812194129269" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="7422421299495717733" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-6102050355377058783" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-4233487223669504585" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-4935197058640034866" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6418129575179276225" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-2772673912735383025" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="509162511996177200" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-4223619613084530199" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-2899715906576496487" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="2000841036044651757" name="field0001" display="填报单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7401727482594899861" name="field0002" display="填报日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4229810535416182081" name="field0003" display="姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8799519645482437118" name="field0004" display="性别" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7818092611885351104" name="field0005" display="出生年月" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7650832006307168223" name="field0006" display="民族" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1323626124368759480" name="field0007" display="籍贯" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1555963423095504719" name="field0008" display="出生地" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2078971081370977154" name="field0009" display="入团入党时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1364411691793365377" name="field0010" display="参工时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8779889830339916481" name="field0011" display="健康状况" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1726709363887814290" name="field0012" display="职务职称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1632691721774019336" name="field0013" display="熟悉专业有何特长" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1135427574960312177" name="field0014" display="照片" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1563874705699914484" name="field0015" display="全日制教育" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8937134614321083905" name="field0016" display="全日制教育毕业院校系及专业" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="327595936470485682" name="field0017" display="在职教育" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7076991063279224401" name="field0018" display="在职教育毕业院校系及专业" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="799263435431822910" name="field0019" display="现工作单位及职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3315959652230870677" name="field0020" display="培训课程学制总合计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3969910792773191968" name="field0021" display="国家级培训学制合计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7591822322442846479" name="field0022" display="自治区级培训学制合计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8182624427988663755" name="field0023" display="市级培训学制合计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8808586558188832966" name="field0024" display="援藏培训学制合计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4194210776178378146" name="field0025" display="自主举办培训学制合计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1235935478311437531" name="field0026" display="网络培训学制合计" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="3988706875870039078" name="formson_0081" display="组2" tabletype="slave" onwertable="formmain_0080" onwerfield="formmain_id">
      <FieldList>
          <Field id="947316561857431050" name="field0027" display="国家级培训-序号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7566107594049695848" name="field0028" display="国家级培训-培训开始时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2911113691159180462" name="field0029" display="国家级培训-培训结束时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9220762443975998233" name="field0030" display="国家级培训-培训地点" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4131774465775352194" name="field0031" display="国家级培训-培训班名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1171122414250641456" name="field0032" display="国家级培训-主办单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7817644206536803174" name="field0033" display="国家级培训-施教机构" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7872308290677326360" name="field0034" display="国家级培训-学制" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="718061725524443379" name="field0035" display="国家级培训-备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="1713995181158122041" name="formson_0082" display="组4" tabletype="slave" onwertable="formmain_0080" onwerfield="formmain_id">
      <FieldList>
          <Field id="9122932447604131270" name="field0036" display="自治区级培训-序号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3253174018210547451" name="field0037" display="自治区级培训-培训开始时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3383818155100454170" name="field0038" display="自治区级培训-培训结束时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="599958845782050827" name="field0039" display="自治区级培训-培训地点" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8416157429803695244" name="field0040" display="自治区级培训-培训班名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4425061627778515954" name="field0041" display="自治区级培训-主办单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4624686950342479076" name="field0042" display="自治区级培训-施教机构" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5609562323553005665" name="field0043" display="自治区级培训-学制" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7773685734542327404" name="field0044" display="自治区级培训-备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-1819357470791154299" name="formson_0083" display="组6" tabletype="slave" onwertable="formmain_0080" onwerfield="formmain_id">
      <FieldList>
          <Field id="-5285930328819940569" name="field0045" display="市级培训-序号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4027644717094160480" name="field0046" display="市级培训-培训开始时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7426783440308778004" name="field0047" display="市级培训-培训结束时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8932182836321303240" name="field0048" display="市级培训-培训地点" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1591336052773242345" name="field0049" display="市级培训-培训班名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-439037128461431218" name="field0050" display="市级培训-主办单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2154406271173872294" name="field0051" display="市级培训-施教机构" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8462689276100000837" name="field0052" display="市级培训-学制" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8458587334326336822" name="field0053" display="市级培训-备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="4079333949097134043" name="formson_0084" display="组8" tabletype="slave" onwertable="formmain_0080" onwerfield="formmain_id">
      <FieldList>
          <Field id="-8284125842944995790" name="field0054" display="援藏培训-序号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4788081497937889072" name="field0055" display="援藏培训-培训开始时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1024726601065345901" name="field0056" display="援藏培训-培训结束时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2649734488971982782" name="field0057" display="援藏培训-培训地点" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4160392059668117609" name="field0058" display="援藏培训-培训班名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7530152658419860311" name="field0059" display="援藏培训-主办单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2813275833306954308" name="field0060" display="援藏培训-施教机构" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3532706111783678286" name="field0061" display="援藏培训-学制" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4415144538256262647" name="field0062" display="援藏培训-备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-8974479802809040470" name="formson_0085" display="组10" tabletype="slave" onwertable="formmain_0080" onwerfield="formmain_id">
      <FieldList>
          <Field id="6187233070288883512" name="field0063" display="自主举办培训-序号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1459416484718033371" name="field0064" display="自主举办培训-培训开始时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1743449831729968227" name="field0065" display="自主举办培训-培训结束时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1283022422335114481" name="field0066" display="自主举办培训-培训地点" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8087291348051016612" name="field0067" display="自主举办培训-培训班名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2363541117202548426" name="field0068" display="自主举办培训-主办单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8851370862462482885" name="field0069" display="自主举办培训-施教机构" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8310602276274027905" name="field0070" display="自主举办培训-学制" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1123077881750207145" name="field0071" display="自主举办培训-备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-1303620993160228900" name="formson_0086" display="组12" tabletype="slave" onwertable="formmain_0080" onwerfield="formmain_id">
      <FieldList>
          <Field id="8663595136938689367" name="field0072" display="网络培训-序号" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-908495665995627589" name="field0073" display="网络培训-在线学习课程名称" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4036704109456605477" name="field0074" display="网络培训-培训网校" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5793990117267754039" name="field0075" display="网络培训-学制" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8820955228798301888" name="field0076" display="网络培训-备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-1643525699140696238" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="4443861578717417130" name="填写" filename="6941683621279907964.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-2838066505834543656" name="审批" filename="244741393381737824.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-3314566205134452735" name="显示" filename="-2136911218602260706.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind id="3831450845737010692" >
    <FormCode ></FormCode>
</Bind>
', '<Extensions>
</Extensions>', TO_DATE('20180619160606', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="日喀则市县处级及以上领导干部教育培训情况登记表" id="-40698508916517"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0080"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="2000841036044651757"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-7401727482594899861"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-4229810535416182081"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="8799519645482437118"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="7818092611885351104"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-7650832006307168223"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="1323626124368759480"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-1555963423095504719"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="2078971081370977154"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-1364411691793365377"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-8779889830339916481"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-1726709363887814290"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-1632691721774019336"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="1135427574960312177"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="1563874705699914484"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="-8937134614321083905"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="327595936470485682"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="7076991063279224401"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="799263435431822910"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="-3315959652230870677"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="3969910792773191968"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="7591822322442846479"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-8182624427988663755"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="8808586558188832966"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="4194210776178378146"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="1235935478311437531"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0081"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0027" id="947316561857431050"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0028" id="-7566107594049695848"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0029" id="-2911113691159180462"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0030" id="-9220762443975998233"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0031" id="-4131774465775352194"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0032" id="1171122414250641456"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0033" id="7817644206536803174"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0034" id="7872308290677326360"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0035" id="718061725524443379"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0082"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0036" id="9122932447604131270"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0037" id="3253174018210547451"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0038" id="-3383818155100454170"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0039" id="599958845782050827"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0040" id="-8416157429803695244"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0041" id="4425061627778515954"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0042" id="4624686950342479076"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0043" id="-5609562323553005665"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0044" id="-7773685734542327404"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0083"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0045" id="-5285930328819940569"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0046" id="4027644717094160480"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0047" id="-7426783440308778004"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0048" id="-8932182836321303240"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0049" id="1591336052773242345"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0050" id="-439037128461431218"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0051" id="2154406271173872294"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0052" id="-8462689276100000837"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0053" id="-8458587334326336822"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0084"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0054" id="-8284125842944995790"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0055" id="4788081497937889072"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0056" id="-1024726601065345901"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0057" id="-2649734488971982782"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0058" id="-4160392059668117609"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0059" id="7530152658419860311"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0060" id="-2813275833306954308"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0061" id="-3532706111783678286"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0062" id="4415144538256262647"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0085"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0063" id="6187233070288883512"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0064" id="-1459416484718033371"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0065" id="-1743449831729968227"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0066" id="1283022422335114481"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0067" id="-8087291348051016612"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0068" id="2363541117202548426"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0069" id="-8851370862462482885"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0070" id="-8310602276274027905"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0071" id="-1123077881750207145"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0086"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0072" id="8663595136938689367"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0073" id="-908495665995627589"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0074" id="4036704109456605477"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0075" id="5793990117267754039"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0076" id="-8820955228798301888"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, 'C7CB1E4E6896F39A0BD7DD7827A61E7B1B9AA24EDCAA92F259A23EDB1D6A493DFEC8536E5C907CEBE799E17C5C80FAE3A73B06E0A1A306FF3D9995C644AC0545C4B73E8D57CC8C0F');
INSERT INTO "FORM_DEFINITION" VALUES (3896662438514410375, '日喀则市纪委监委文稿呈签卡2', -884316703172445, TO_DATE('20180710121706', 'YYYYMMDDHH24MISS'), 5, 401, 0, 2, 0, '<TableList>
  <Table id="-3096358806505438016" name="formmain_0089" display="formmain_0089" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="4312447214714310063" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="4148357386160455852" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="3099538969985239576" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6487508866042055719" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="8809482751136516728" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="4380659403792141298" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-3775556644535712692" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="7403955458950581810" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-7871738647295409174" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-7214080590503787780" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-1220506565630278227" name="field0001" display="公文文号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6932927223068838414" name="field0002" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8466281184563412618" name="field0003" display="文稿名称" fieldtype="VARCHAR" mappingField="subject" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2833930658113698013" name="field0004" display="主送单位" fieldtype="VARCHAR" mappingField="send_to" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2630128080917646639" name="field0005" display="抄送单位" fieldtype="VARCHAR" mappingField="copy_to" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3008697951423478124" name="field0006" display="文件密级" fieldtype="VARCHAR" mappingField="secret_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4463581312200753725" name="field0007" display="主要领导签批" fieldtype="VARCHAR" mappingField="qianfa" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2201990507003426025" name="field0008" display="分管领导意见" fieldtype="VARCHAR" mappingField="shenhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7245489887033836659" name="field0009" display="协管领导意见" fieldtype="VARCHAR" mappingField="shenpi" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5826382594444380798" name="field0010" display="呈报部门意见" fieldtype="VARCHAR" mappingField="chengban" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3411397413425758124" name="field0011" display="领导会签" fieldtype="VARCHAR" mappingField="huiqian" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-43131090327289724" name="field0012" display="办公室核稿" fieldtype="VARCHAR" mappingField="fuhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4306671919584293945" name="field0013" display="印刷份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5143313308878355368" name="field0014" display="联系方式" fieldtype="VARCHAR" mappingField="phone" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-2118109074239763919" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-4408433250156264409" name="填写" filename="2741973174520137412.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="8083654194031513166" name="审批" filename="-6108549653097594036.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-843647952129143066" name="显示" filename="-5535661328641339811.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-8946212870907541926" name="主要领导签批" filename="Operation_-9133109965261746616.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="4342356125566453853" name="分管领导意见" filename="Operation_-499925448522774428.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="3873605864268186781" name="协管领导意见" filename="Operation_-787564983404969114.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-8090973397266313425" name="呈报部门意见" filename="Operation_-5912543011464525377.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="1123080254164257062" name="领导会签" filename="Operation_5583197892277192436.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="62922674582733977" name="办公室核稿" filename="Operation_-5651418134041116091.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180725152037', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="日喀则市纪委监委文稿呈签卡2" id="3896662438514410375"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0089"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-1220506565630278227"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="6932927223068838414"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-8466281184563412618"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-2833930658113698013"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="2630128080917646639"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-3008697951423478124"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="4463581312200753725"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-2201990507003426025"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="7245489887033836659"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="5826382594444380798"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-3411397413425758124"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-43131090327289724"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-4306671919584293945"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-5143313308878355368"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '75DECA7882771AD88199371198232B3E34C50597BE40CCF53966DA19231A071A7949B4961FB7F640C46E55E304E891CBA19F630797382C81A06FE6DC4B6CE19073BAEDF6A0093615');
INSERT INTO "FORM_DEFINITION" VALUES (-5359551153399707487, '督办催办单', 738181485194463946, TO_DATE('20180522224828', 'YYYYMMDDHH24MISS'), 1, 4358901251920773292, 0, 2, 0, '<TableList>
  <Table id="-795357114987757374" name="formmain_0025" display="formmain_0025" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-5102508013423276264" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-7912933229705279849" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="8742142910343826067" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="3228096805509481051" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="9154305041810997797" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-8919875208823485829" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="6319195292136655492" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-5081813391467197720" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="3939766988811292488" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-1422669839916380392" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-947016280932855992" name="field0001" display="催办主题" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6559383601597008034" name="field0002" display="责任单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7129979333150290810" name="field0003" display="催办时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7019245516928432777" name="field0004" display="督查意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3172667475587909973" name="field0005" display="催办内容" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1448082147437097773" name="field0006" display="催办事项" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1882177443162600032" name="field0007" display="责任人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4138496188632091985" name="field0008" display="催办单位" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2692243976891221107" name="field0009" display="完成时限" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1933133679226043774" name="field0010" display="督办人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7250333879155967778" name="field0011" display="承办人" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="8859344206638892850" name="查看视图" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="2.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-8014550927274590058" name="填写" filename="-5226965346172583008.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="1862731480024892807" name="审批" filename="6612315252029735988.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-8171125384042558472" name="显示" filename="5374733548190188473.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
    <Event id="7830878779548126520" name="事项台账（6-27）" state="1" type="2" formId="-5359551153399707487" creator="738181485194463946" createTime="2017-06-29 20:21:36" flowState="1" modifyTime="2017-06-29 20:21:36">
        <ConditionList>
            <Condition type="form" formulaId="-2865518111206456738" param="-7663681133104185262" />
        </ConditionList>
        <ActionList>
            <Action id="-6675682560536655166" type="calculate" name="null">
                <Param type="formId"><![CDATA[-7663681133104185262]]></Param>
                <Param type="withholding"><![CDATA[false]]></Param>
                <Param type="addSlaveRow"><![CDATA[true]]></Param>
                <Param type="fillBack">
                    <Prop type="copy" key="formson_0015.field0038" value="formmain_0025.field0008">
</Prop>                    <Prop type="copy" key="formson_0015.field0040" value="flowTitleName">
</Prop>                    <Prop type="copy" key="formson_0015.field0039" value="formmain_0025.field0003">
</Prop>                    <Prop type="copy" key="formson_0015.field0041" value="formmain_0025.field0005">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180522224831', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="督办催办单" id="-5359551153399707487"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0025"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-947016280932855992"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="6559383601597008034"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-7129979333150290810"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-7019245516928432777"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="3172667475587909973"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-1448082147437097773"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-1882177443162600032"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="4138496188632091985"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="2692243976891221107"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-1933133679226043774"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="7250333879155967778"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, 'EF0391BC737DD5E67AE55AABB4D19E7B61D444795F3A0428F3F30080F8E8FC7E5CC0524C0AE786EE');
INSERT INTO "FORM_DEFINITION" VALUES (6327895360738381199, '日喀则市纪委监察局收件公文呈批卡-废弃', -4709450004260764208, TO_DATE('20180523125221', 'YYYYMMDDHH24MISS'), 7, 402, 0, 2, 0, '<TableList>
  <Table id="4139664660475757996" name="formmain_0030" display="formmain_0030" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-5153782486538304992" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="6323003774394453155" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-6715426525557929536" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="2900916389291640221" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="2354340424110001672" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="378383191160147543" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="2947231295439456035" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-5252614998398709869" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="8469392310334145512" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-7300398690944924981" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="7242475407944470167" name="field0001" display="来文机关" fieldtype="VARCHAR" mappingField="send_unit" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-527010818416425221" name="field0003" display="文件种类" fieldtype="VARCHAR" mappingField="doc_type" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9067584368379411824" name="field0004" display="收文时间" fieldtype="TIMESTAMP" mappingField="packdate" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9150603573375514680" name="field0005" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6956664888826966412" name="field0006" display="收文序号" fieldtype="VARCHAR" mappingField="serial_no" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6052639033983218726" name="field0007" display="文件名称" fieldtype="VARCHAR" mappingField="subject" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8276271516212442970" name="field0009" display="份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2799862660167058845" name="field0010" display="主要领导批示" fieldtype="VARCHAR" mappingField="pishi" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-789428716008681957" name="field0012" display="办公室意见" fieldtype="VARCHAR" mappingField="niban" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6667816361695034509" name="field0014" display="备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3825984105467823715" name="field0013" display="协管领导意见" fieldtype="VARCHAR" mappingField="shenpi" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4190840330016964125" name="field0011" display="分管领导意见" fieldtype="VARCHAR" mappingField="shenhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6340491022928855323" name="field0008" display="收文文号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9047718571840158951" name="field0002" display="期限" fieldtype="VARCHAR" mappingField="keep_period" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4486860117314847503" name="field0015" display="密级" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-6212900254465569641" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-4990485421222049925" name="填写" filename="-867918021021122175.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="1106536409920717278" name="审批" filename="-2749803177009066258.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-5198014027462587969" name="显示" filename="-2409810450573210648.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="8411399840397872460" name="主要领导批示" filename="Operation_8711385177107415263.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-8041565633373321167" name="分管领导意见" filename="Operation_-7591807040915288179.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-7897291856553227336" name="办公室意见" filename="Operation_3057399507126603444.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="1819354968519033404" name="协管领导意见" filename="Operation_-8822346541019936534.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180725151955', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="日喀则市纪委监察局收件公文呈批卡-废弃" id="6327895360738381199"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0030"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="7242475407944470167"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-527010818416425221"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-9067584368379411824"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-9150603573375514680"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-6956664888826966412"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-6052639033983218726"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-8276271516212442970"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="2799862660167058845"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-789428716008681957"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-6667816361695034509"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="3825984105467823715"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-4190840330016964125"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="6340491022928855323"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-9047718571840158951"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="4486860117314847503"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '898005EB30F26A114DAC8700F409292BDA45511ADC66D97087561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (-1182755591615459451, '发文单', -884316703172445, TO_DATE('20180523001204', 'YYYYMMDDHH24MISS'), 5, 401, 0, 2, 0, '<TableList>
  <Table id="-4571460358151451719" name="formmain_0027" display="formmain_0027" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-6534455221331804106" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="918969528470816976" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="6456528307604965372" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-4338896842174673414" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="7914342739362008308" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="3745957550605550537" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-1623843586989602724" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-2894898993417468406" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="8719237758329768699" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-981892488056780608" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-387508310479450343" name="field0001" display="公文文号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6732204090317519713" name="field0002" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5246685599344603258" name="field0003" display="文件密级" fieldtype="VARCHAR" mappingField="secret_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1742292418229219660" name="field0004" display="签发" fieldtype="VARCHAR" mappingField="qianfa" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2572062184267560446" name="field0005" display="会签" fieldtype="VARCHAR" mappingField="huiqian" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7887051824291361323" name="field0006" display="审核" fieldtype="VARCHAR" mappingField="shenhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3698573991993652006" name="field0007" display="复核" fieldtype="VARCHAR" mappingField="fuhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3524052868704846512" name="field0008" display="发文单位" fieldtype="VARCHAR" mappingField="send_unit" fieldlength="200,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6873627687486507726" name="field0009" display="签发日期" fieldtype="TIMESTAMP" mappingField="signing_date" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1149689735954806482" name="field0010" display="拟稿人" fieldtype="VARCHAR" mappingField="create_person" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1837183279634467650" name="field0011" display="联系电话" fieldtype="VARCHAR" mappingField="phone" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1263411807320425263" name="field0012" display="印发份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="910797174045821619" name="field0013" display="公文标题" fieldtype="VARCHAR" mappingField="subject" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5480295802325123879" name="field0014" display="主送单位" fieldtype="VARCHAR" mappingField="send_to" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8206683405023789890" name="field0015" display="抄送单位" fieldtype="VARCHAR" mappingField="copy_to" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4552845569843806323" name="field0016" display="附件" fieldtype="VARCHAR" mappingField="attachments" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5736391032454036887" name="field0017" display="签发人" fieldtype="VARCHAR" mappingField="issuer" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3079373844216824296" name="field0018" display="分送日期" fieldtype="TIMESTAMP" mappingField="packdate" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-8625109492044249454" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-6453729562557264209" name="填写" filename="-7317419085865727647.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-1652873077839474783" name="审批" filename="6064398501573053311.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-1308519794845069532" name="显示" filename="3380757374273144499.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180715161902', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="发文单" id="-1182755591615459451"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0027"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-387508310479450343"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-6732204090317519713"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-5246685599344603258"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-1742292418229219660"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-2572062184267560446"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-7887051824291361323"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-3698573991993652006"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="3524052868704846512"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="6873627687486507726"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-1149689735954806482"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="1837183279634467650"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="1263411807320425263"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="910797174045821619"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="5480295802325123879"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="8206683405023789890"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="4552845569843806323"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-5736391032454036887"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="3079373844216824296"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, 'B3E7B058341303B3FA475C3C2C567712EED19F1FDFEB5518F3F30080F8E8FC7E5CC0524C0AE786EE');
INSERT INTO "FORM_DEFINITION" VALUES (-767293252451679338, '日喀则市纪委监察局收件公文呈阅卡', -884316703172445, TO_DATE('20180525143220', 'YYYYMMDDHH24MISS'), 7, 402, 0, 2, 0, '<TableList>
  <Table id="6481186473014542700" name="formmain_0033" display="formmain_0033" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="7137453969312925131" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="2928712704327502296" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="483979177049344829" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-8540428410564361080" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="3461393532423390616" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-5697144975793303633" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="4432609252548496531" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-7880381722857615957" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-5744548530200164512" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="1478104851592857379" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-1104411863518003166" name="field0001" display="来文机关" fieldtype="VARCHAR" mappingField="send_unit" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5757903642159986551" name="field0002" display="秘密期限" fieldtype="VARCHAR" mappingField="keep_period" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7203395565334972024" name="field0003" display="文件种类" fieldtype="VARCHAR" mappingField="doc_type" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4733707630602990965" name="field0004" display="收文时间" fieldtype="TIMESTAMP" mappingField="registration_date" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-867054052055364020" name="field0005" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-9084707745426618530" name="field0006" display="收文序号" fieldtype="VARCHAR" mappingField="serial_no" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8009753121869379710" name="field0007" display="文件名称" fieldtype="VARCHAR" mappingField="subject" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2974992555408836483" name="field0008" display="发文序号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4677296925683660991" name="field0009" display="份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7346085712185833983" name="field0010" display="阅文记录" fieldtype="VARCHAR" mappingField="yuedu" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4204695838026412622" name="field0011" display="备注" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-8984859308383256495" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="127827724201315796" name="填写" filename="-25395661577502045.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="6091424738087487391" name="审批" filename="-8359054942131502494.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-880030908673013696" name="显示" filename="-3790934565101287262.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-2904418728025111278" name="阅读" filename="Operation_-4876475416990300896.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180715162413', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="日喀则市纪委监察局收件公文呈阅卡" id="-767293252451679338"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0033"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-1104411863518003166"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-5757903642159986551"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="7203395565334972024"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-4733707630602990965"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-867054052055364020"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-9084707745426618530"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-8009753121869379710"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="2974992555408836483"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-4677296925683660991"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-7346085712185833983"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-4204695838026412622"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, 'DCCAE7C86686C666DBAFCDAFA78CB0254F1910847D840EC287561F575AC49FEB75FDED1773B141AA');
INSERT INTO "FORM_DEFINITION" VALUES (-1840490557122917237, '外出报批（报备）表', 7561137710640218641, TO_DATE('20180716170246', 'YYYYMMDDHH24MISS'), 1, -732547941328516542, 1, 2, 0, '<TableList>
  <Table id="7322379653862214457" name="formmain_0140" display="formmain_0140" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-8122793470633033332" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="7190274956324196005" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="4252647570477762725" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-8063440081763876202" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-4644538953437723824" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-5330406344182248175" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-2665822349970617356" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-8086489554187304888" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="8508051968269961701" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="1134415953223961269" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-940873441905326998" name="field0002" display="填报时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3056057529136792341" name="field0003" display="报告人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-371751528075345168" name="field0004" display="单位" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3652311780170223370" name="field0005" display="职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1050349565209038682" name="field0006" display="联系电话" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8828876714590948427" name="field0007" display="事由" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2212717097919626084" name="field0008" display="开始时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3399710074003606433" name="field0009" display="结束时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-373716127902314883" name="field0010" display="天数" fieldtype="DECIMAL" fieldlength="20,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-4623006150431126038" name="field0013" display="领导姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4235443761729286662" name="field0014" display="领导职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6150255900956051167" name="field0015" display="领导联系电话" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1000427529534487568" name="field0017" display="市委组织部意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-797553441555198570" name="field0018" display="分管市级领导意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6963817405840703830" name="field0019" display="在家主持工作领导意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-152448558318268733" name="field0020" display="备注" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2271124953659754263" name="field0021" display="外出类型" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5195930541160415931" name="field0022" display="单位及职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2949130978877157963" name="field0023" display="取年" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4629423373765619869" name="field0024" display="校验本年是否报备" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4862045450496425870" name="field0025" display="本部门意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2389205786272875563" name="field0026" display="组织部意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4133766844548661583" name="field0027" display="分管领导意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="283593743962292572" name="field0016" display="市委主要领导意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4596977521009250073" name="field0001" display="填报部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7421334695599162250" name="field0011" display="往返地点" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1585225871346939316" name="field0012" display="次数" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-2811794633656676875" name="formson_0141" display="组2" tabletype="slave" onwertable="formmain_0140" onwerfield="formmain_id">
      <FieldList>
          <Field id="5730312621723304164" name="field0028" display="本年请休假情况" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-7722159128346735325" name="视图1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="3766294677092057748" name="填写" filename="3867922639326236653.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="6562868796894758601" name="审批" filename="3335640971901685100.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-6212563872024411083" name="显示" filename="6033793282205765194.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-8807256581063619160" name="市委主要领导意见" filename="Operation_-529308344948601953.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-5053823483240036662" name="市委组织部意见" filename="Operation_-190186594071131718.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-4424726625508766886" name="分管市级领导意见" filename="Operation_7682208847256767281.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-2096476189978376537" name="在家主持工作领导意见" filename="Operation_-527237532438215232.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-9216493415677803657" name="备注" filename="Operation_-6268567995035663363.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="-8052740114048988068" name="纪委监委机关干部职工外出报批（报备）表" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view2.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="1410992587639506220" name="审批" filename="-5036877842789479111.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-4343585179161114149" name="显示" filename="-5650102936131780511.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="1870020644355327380" name="填写" filename="Operation_-1471327296938947182.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="295206310543377026" name="本部门意见" filename="Operation_7479471627858822154.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="8875643635937132618" name="组织部意见" filename="Operation_-683150464561296814.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="6657425805052559928" name="分管领导意见" filename="Operation_-868341172069184932.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="6528448408880828390" name="备注" filename="Operation_7558781823685772808.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
  <Form id="5083157833571452869" name="市级领导干部外出报批（报备）表" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view3.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="4668006106204228466" name="审批" filename="-7820352807032241689.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="4023737783640805194" name="显示" filename="-4078004042688151065.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="255786991981513625" name="填写" filename="Operation_7427202896170206630.xml" type="add" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="9006643771709147577" name="市委主要领导意见" filename="Operation_5129740505799018907.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-78826531590553568" name="在家主持工作领导意见" filename="Operation_7213660945648992723.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-7222263850607556611" name="备注" filename="Operation_-419698513417646318.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
    <Query id="-7609051453161517870" name="考勤查询表" formId="-1840490557122917237" creator="7561137710640218641" modifyTime="2018-07-29 13:27:29" createTime="2018-07-16 17:37:23" type="0" queryRange="1" >
        <ShowFieldList >
            <Colum id="0" name="formmain_0140.field0001" type="showField" value="填报部门(单位或部门)" display="" />
            <Colum id="0" name="formmain_0140.field0002" type="showField" value="填报时间" display="" />
            <Colum id="0" name="formmain_0140.field0003" type="showField" value="报告人" display="" />
            <Colum id="0" name="formmain_0140.field0004" type="showField" value="单位(单位或部门)" display="" />
            <Colum id="0" name="formmain_0140.field0005" type="showField" value="职务" display="" />
            <Colum id="0" name="formmain_0140.field0006" type="showField" value="联系电话" display="" />
            <Colum id="0" name="formmain_0140.field0007" type="showField" value="事由(外出事由)" display="" />
            <Colum id="0" name="formmain_0140.field0021" type="showField" value="外出类型" display="" />
            <Colum id="0" name="formmain_0140.field0008" type="showField" value="开始时间(外出开始时间)" display="" />
            <Colum id="0" name="formmain_0140.field0009" type="showField" value="结束时间(外出结束时间)" display="" />
            <Colum id="0" name="formmain_0140.field0010" type="showField" value="天数(外出天数)" display="" />
            <Colum id="0" name="formmain_0140.field0011" type="showField" value="往返地点" display="" />
            <Colum id="0" name="formmain_0140.field0013" type="showField" value="领导姓名(代管领导姓名)" display="" />
            <Colum id="0" name="formmain_0140.field0014" type="showField" value="领导职务(代管领导职务)" display="" />
            <Colum id="0" name="formmain_0140.field0020" type="showField" value="备注" display="" />
        </ShowFieldList>
        <OrderByList >
            <Colum id="0" name="formmain_0140.field0002" type="orderBy" value="desc" display="" />
        </OrderByList>
        <SystemCondition >-345723080708763827</SystemCondition>
        <UserCondition >-8208387993267517414</UserCondition>
        <UserFieldList >
            <UserField id="-1" name="开始时间" parentId="-7609051453161517870" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="开始时间" >
                <Input inputType="date" enumId="0" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
            <UserField id="-1" name="结束时间" parentId="-7609051453161517870" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="结束时间" >
                <Input inputType="date" enumId="0" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
            <UserField id="-1" name="部门" parentId="-7609051453161517870" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="部门" >
                <Input inputType="department" enumId="0" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
            <UserField id="-1" name="人员" parentId="-7609051453161517870" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="人员" >
                <Input inputType="member" enumId="0" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
            <UserField id="-1" name="外出类型" parentId="-7609051453161517870" creator="7561137710640218641" modifyTime="2018-07-29" createTime="2018-07-29" title="外出类型" >
                <Input inputType="select" enumId="-7752172872896526022" valueType="text" enumLevel="1" finalChecked="false" hasMoreLevel="false"  />
            </UserField>
        </UserFieldList>
        <Description ><![CDATA[]]></Description>
    </Query>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
    <Event id="-3816413177784416217" name="触发请假记录" state="1" type="1" formId="-1840490557122917237" creator="7561137710640218641" createTime="2018-07-16 17:58:59" flowState="1" modifyTime="2018-07-16 18:00:00">
        <ConditionList>
            <Condition type="form" formulaId="7828688087355838086" />
        </ConditionList>
        <ActionList>
            <Action id="-8332810724676907989" type="unflow" name="数据存档">
                <Param type="formId"><![CDATA[7601436640427462008]]></Param>
                <Param type="templateId"><![CDATA[-6942659150481963465]]></Param>
                <Param type="entity">
                    <Prop type="collaborationSender" key="Role" value="Sender">
</Prop>                </Param>
                <Param type="fillBack">
                    <Prop type="copy" key="formmain_0102.field0001" value="formmain_0140.field0003">
</Prop>                    <Prop type="copy" key="formmain_0102.field0002" value="formmain_0140.field0023">
</Prop>                    <Prop type="copy" key="formson_0103.field0003" value="formmain_0140.field0008">
</Prop>                    <Prop type="copy" key="formson_0103.field0004" value="formmain_0140.field0009">
</Prop>                    <Prop type="copy" key="formson_0103.field0005" value="formmain_0140.field0021">
</Prop>                    <Prop type="copy" key="formson_0103.field0006" value="formmain_0140.field0010">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
    <Event id="-5452798036492399089" name="请假外出报备记录表" state="1" type="2" formId="-1840490557122917237" creator="7561137710640218641" createTime="2018-07-16 18:01:18" flowState="1" modifyTime="2018-07-16 18:01:18">
        <ConditionList>
            <Condition type="form" formulaId="-7357296397877621024" param="7601436640427462008" />
        </ConditionList>
        <ActionList>
            <Action id="2370579204588851016" type="calculate" name="null">
                <Param type="formId"><![CDATA[7601436640427462008]]></Param>
                <Param type="withholding"><![CDATA[false]]></Param>
                <Param type="addSlaveRow"><![CDATA[true]]></Param>
                <Param type="fillBack">
                    <Prop type="copy" key="formson_0103.field0003" RowCondition="8943603461138104637" value="formmain_0140.field0008">
</Prop>                    <Prop type="copy" key="formson_0103.field0004" RowCondition="-7943133375297007649" value="formmain_0140.field0009">
</Prop>                    <Prop type="copy" key="formson_0103.field0005" RowCondition="-2894195756230621745" value="formmain_0140.field0021">
</Prop>                    <Prop type="copy" key="formson_0103.field0006" RowCondition="3762098830807420146" value="formmain_0140.field0010">
</Prop>                </Param>
            </Action>
        </ActionList>
    </Event>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180801174329', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="外出报批（报备）表" id="-1840490557122917237"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0140"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0002" id="-940873441905326998"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="3056057529136792341"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-371751528075345168"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="3652311780170223370"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="1050349565209038682"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="8828876714590948427"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-2212717097919626084"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="3399710074003606433"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-373716127902314883"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-4623006150431126038"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-4235443761729286662"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="6150255900956051167"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-1000427529534487568"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="-797553441555198570"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="6963817405840703830"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="-152448558318268733"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="2271124953659754263"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="5195930541160415931"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="-2949130978877157963"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-4629423373765619869"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="-4862045450496425870"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0026" id="2389205786272875563"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0027" id="4133766844548661583"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="283593743962292572"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0001" id="4596977521009250073"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="7421334695599162250"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="-1585225871346939316"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0141"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0028" id="5730312621723304164"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, 'C3D8D203BC810E51ADFA18B55761E142594FC759A1A6B0E1E52861941CEA82C01007827D35A2F7940162477926388738362C9DA917C60C4C4B7360D54598B4F98858775428BBC476');
INSERT INTO "FORM_DEFINITION" VALUES (5920422443653089051, '日喀则市纪委监委内部办文发文呈批卡', -884316703172445, TO_DATE('20180726124735', 'YYYYMMDDHH24MISS'), 5, 401, 1, 2, 0, '<TableList>
  <Table id="7521454966952971209" name="formmain_0216" display="formmain_0089" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="8233125277856317826" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-3908697126726906324" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="-577047321192608825" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-3502022609597675565" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-6000333007400056702" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="485246514844748036" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-4999323532914635554" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-3159238522806580211" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-6950378992821580713" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="3822788006360728075" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-3778332845066924339" name="field0001" display="公文文号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1915628250423671434" name="field0002" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-91364117985801966" name="field0003" display="文稿名称" fieldtype="VARCHAR" mappingField="subject" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2889928806936591305" name="field0004" display="主送单位" fieldtype="VARCHAR" mappingField="send_to" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3014823750338299956" name="field0005" display="抄送单位" fieldtype="VARCHAR" mappingField="copy_to" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7194890048948028603" name="field0006" display="文件密级" fieldtype="VARCHAR" mappingField="secret_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1999070176803701916" name="field0007" display="主要领导签批" fieldtype="VARCHAR" mappingField="text1" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6599176267963677446" name="field0008" display="分管领导意见" fieldtype="VARCHAR" mappingField="text2" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4941140544370031280" name="field0009" display="协管领导意见" fieldtype="VARCHAR" mappingField="text3" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3058721730813185109" name="field0010" display="呈报部门意见" fieldtype="VARCHAR" mappingField="text4" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3902659000938575790" name="field0011" display="领导会签" fieldtype="VARCHAR" mappingField="text5" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8186054881992460799" name="field0012" display="办公室核稿" fieldtype="VARCHAR" mappingField="fuhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5911626825986556722" name="field0013" display="印刷份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7165411176908764662" name="field0014" display="联系方式" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3921126197474539032" name="field0016" display="呈报时间" fieldtype="TIMESTAMP" mappingField="date1" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8885819781980048175" name="field0017" display="承办人" fieldtype="VARCHAR" mappingField="undertaker" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="133013804267620957" name="field0018" display="期限" fieldtype="VARCHAR" mappingField="keep_period" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4368854656983088311" name="field0015" display="呈报部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-430010890247715557" name="field0019" display="分管领导" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1112662634542484639" name="field0020" display="主管领导日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="502156982106998492" name="field0021" display="部门负责人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1992087332696182727" name="field0022" display="主管领导" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3070983807299045619" name="field0023" display="协管领导日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5701259119969546251" name="field0024" display="协管领导" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1582034291506562599" name="field0025" display="分管领导日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="4624873733927620298" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-47062663876163044" name="填写" filename="2741973174520137412.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-8863313682742425599" name="审批" filename="-6108549653097594036.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-1400687052185908195" name="显示" filename="-5535661328641339811.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-9206595413681223983" name="办公室核稿" filename="Operation_-5651418134041116091.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-5911620182555278107" name="主要领导签批" filename="Operation_-9133109965261746616.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
      <Operation id="-5865646330108950729" name="分管领导意见" filename="Operation_-499925448522774428.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
      <Operation id="8632171621561421189" name="协管领导意见" filename="Operation_-787564983404969114.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
      <Operation id="-3382824864532577064" name="呈报部门意见" filename="Operation_-5912543011464525377.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
      <Operation id="8505246568146356905" name="领导会签" filename="Operation_5583197892277192436.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180730161002', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="日喀则市纪委监委内部办文发文呈批卡" id="5920422443653089051"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0216"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-3778332845066924339"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-1915628250423671434"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="-91364117985801966"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-2889928806936591305"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="3014823750338299956"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="7194890048948028603"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="1999070176803701916"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-6599176267963677446"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-4941140544370031280"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="3058721730813185109"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-3902659000938575790"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="8186054881992460799"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="5911626825986556722"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="-7165411176908764662"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="-3921126197474539032"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="8885819781980048175"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0018" id="133013804267620957"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-4368854656983088311"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0019" id="-430010890247715557"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0020" id="1112662634542484639"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0021" id="502156982106998492"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0022" id="1992087332696182727"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0023" id="3070983807299045619"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0024" id="-5701259119969546251"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0025" id="1582034291506562599"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '74EB12D42AA340BE1B430346DB2C3EDCB5785B1D0344856A3966DA19231A071A7949B4961FB7F640C46E55E304E891CBA19F630797382C81A06FE6DC4B6CE19073BAEDF6A0093615');
INSERT INTO "FORM_DEFINITION" VALUES (7601436640427462008, '请假外出报备记录表', 7561137710640218641, TO_DATE('20180710163838', 'YYYYMMDDHH24MISS'), 2, -732547941328516542, 1, 2, 0, '<TableList>
  <Table id="-246056852294843120" name="formmain_0102" display="formmain_0102" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-4117265861122699273" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-3016583264307163230" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="7233214873295341465" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="787995411065422453" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-4395168763619884985" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6164895001920357307" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-3650800154397359513" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="37989359897560250" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-4323386833704171603" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-2543129637460950180" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-8912702292366110964" name="field0001" display="姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-541113572320395084" name="field0002" display="年份" fieldtype="DECIMAL" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="6359007179329061418" name="formson_0103" display="组2" tabletype="slave" onwertable="formmain_0102" onwerfield="formmain_id">
      <FieldList>
          <Field id="-4344105633986950367" name="field0003" display="起始时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4517874790849793884" name="field0004" display="结束时间" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8851340154630390413" name="field0005" display="外出类型" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2958378519612050035" name="field0006" display="天数" fieldtype="DECIMAL" fieldlength="21,1" is_null="false" is_primary="false" classname=""/>
          <Field id="-4945380721018450280" name="field0007" display="拼接" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="5749163886380731451" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="5468382285729252047" name="填写" filename="3800805947318223017.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="8421118921245739268" name="审批" filename="-5557952369241866133.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="3819041160981400481" name="显示" filename="-4357585458178864848.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind id="-8461752874118659799" >
    <FormCode ></FormCode>
    <FormBindAuthList >
        <FormBindAuth id="-6942659150481963465" name="请假外出报备记录表" formId="7601436640427462008" creator="7561137710640218641" modifyTime="2018-07-29 21:16:14" createTime="2018-07-10 16:39:15" >
            <ShowFieldList >
                <Colum id="0" name="formmain_0102.field0002" type="showField" value="年份" display="" />
                <Colum id="0" name="formmain_0102.field0001" type="showField" value="姓名" display="" />
            </ShowFieldList>
            <SearchFieldList >
                <Colum id="0" name="formmain_0102.field0002" type="searchField" value="年份" display="" />
                <Colum id="0" name="formmain_0102.field0001" type="searchField" value="姓名" display="" />
            </SearchFieldList>
            <AuthList >
                <Colum id="0" name="authId" type="auth" value="1051446424940331326" display="" />
                <Colum id="0" name="authName" type="auth" value="请假外出报备记录表" display="" />
                <Colum id="0" name="formula" type="auth" value="" display="" />
                <Colum id="0" name="allowdelete" type="auth" value="true" display="" />
                <Colum id="0" name="allowlock" type="auth" value="false" display="" />
                <Colum id="0" name="allowexport" type="auth" value="true" display="" />
                <Colum id="0" name="allowquery" type="auth" value="true" display="" />
                <Colum id="0" name="allowreport" type="auth" value="true" display="" />
                <Colum id="0" name="allowprint" type="auth" value="true" display="" />
                <Colum id="0" name="allowlog" type="auth" value="true" display="" />
                <Colum id="0" name="browse" type="auth" value="5749163886380731451.3819041160981400481|" display="" />
                <Colum id="0" name="add" type="auth" value="5749163886380731451.5468382285729252047" display="新建" />
                <Colum id="0" name="bathupdate" type="auth" value="" display="" />
                <Colum id="0" name="bathFresh" type="auth" value="true" display="" />
                <Colum id="0" name="update" type="auth" value="5749163886380731451.8421118921245739268" display="修改" modifyShowDeal="false" />
            </AuthList>
        </FormBindAuth>
    </FormBindAuthList>
</Bind>
', '<Extensions>
    <UniqueFieldLists >
    <UniqueFieldList >
        <UniqueField name="field0002" />
        <UniqueField name="field0001" />
    </UniqueFieldList>
    </UniqueFieldLists>
</Extensions>', TO_DATE('20180729211616', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="请假外出报备记录表" id="7601436640427462008"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0102"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-8912702292366110964"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-541113572320395084"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0103"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0003" id="-4344105633986950367"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="4517874790849793884"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="8851340154630390413"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="2958378519612050035"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-4945380721018450280"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '48D8A1DF54937DB8B36271EA122F85017ADF22BD92A74FE43966DA19231A071A7949B4961FB7F640C46E55E304E891CBA19F630797382C81A06FE6DC4B6CE19073BAEDF6A0093615');
INSERT INTO "FORM_DEFINITION" VALUES (4461866551585360014, '日喀则市纪委监察局收件公文呈批卡', -4709450004260764208, TO_DATE('20180722145447', 'YYYYMMDDHH24MISS'), 7, 402, 1, 2, 0, '<TableList>
  <Table id="-156567707917137097" name="formmain_0199" display="formmain_0030" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-6580365480902308426" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="6362548231353486143" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="5809131048414235842" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="4877149277153673391" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="8130886057999614825" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-6692449262372306126" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="6400681442630979018" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-1425859984103420031" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-1209586810217019014" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="7768307788613436488" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="1678403731831801425" name="field0001" display="来文机关" fieldtype="VARCHAR" mappingField="send_unit" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1112889478729321942" name="field0003" display="文件种类" fieldtype="VARCHAR" mappingField="doc_type" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="903520638806150074" name="field0004" display="收文时间" fieldtype="TIMESTAMP" mappingField="packdate" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3822679502123348270" name="field0005" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6037364823558211785" name="field0007" display="文件名称" fieldtype="VARCHAR" mappingField="subject" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-2482983598820605825" name="field0009" display="份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-7750134542558278702" name="field0010" display="主要领导批示" fieldtype="VARCHAR" mappingField="pishi" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="619190739069846960" name="field0012" display="办公室意见" fieldtype="VARCHAR" mappingField="niban" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5576535070174693640" name="field0014" display="备注" fieldtype="VARCHAR" mappingField="chengban" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1943092296111800005" name="field0013" display="协管领导意见" fieldtype="VARCHAR" mappingField="shenpi" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6207660655613688935" name="field0011" display="分管领导意见" fieldtype="VARCHAR" mappingField="shenhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-751754599776497986" name="field0002" display="期限" fieldtype="VARCHAR" mappingField="keep_period" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1134025519684827860" name="field0015" display="密级" fieldtype="VARCHAR" mappingField="secret_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6795202819275013813" name="field0008" display="公文文号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5213191661007387394" name="field0006" display="内部序号" fieldtype="VARCHAR" mappingField="serial_no" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="-9021112544799145416" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-35202459656567928" name="填写" filename="-867918021021122175.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="5152327797220262733" name="审批" filename="-2749803177009066258.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-7104374783713196549" name="显示" filename="-2409810450573210648.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="4709025424382445156" name="主要领导批示" filename="Operation_8711385177107415263.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="6956868730572325143" name="分管领导意见" filename="Operation_-7591807040915288179.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-6892499438309455226" name="办公室意见" filename="Operation_3057399507126603444.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="974251618819916283" name="协管领导意见" filename="Operation_-8822346541019936534.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="9155982818046462842" name="承办" filename="Operation_3605508660700334067.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180730160907', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="日喀则市纪委监察局收件公文呈批卡" id="4461866551585360014"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0199"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="1678403731831801425"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="1112889478729321942"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="903520638806150074"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-3822679502123348270"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="6037364823558211785"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-2482983598820605825"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="-7750134542558278702"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="619190739069846960"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="5576535070174693640"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-1943092296111800005"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-6207660655613688935"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-751754599776497986"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="-1134025519684827860"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="-6795202819275013813"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="-5213191661007387394"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '5E1EA8C45557419E3822F7B4206C9D69EE5CD8A33E7DCEA93966DA19231A071A7949B4961FB7F640C46E55E304E891CBA19F630797382C81A06FE6DC4B6CE19073BAEDF6A0093615');
INSERT INTO "FORM_DEFINITION" VALUES (3677851881895839829, '日喀则市纪委监委文稿呈签卡3', -884316703172445, TO_DATE('20180716184419', 'YYYYMMDDHH24MISS'), 5, 401, 0, 2, 0, '<TableList>
  <Table id="-5256207455242469313" name="formmain_0142" display="formmain_0089" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="8994522952823554739" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-3030795586304851429" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="2622986889244856156" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="8272971173194518265" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-2961310110486213538" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6911060837581866089" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-7930900066734815708" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-8533226379367723585" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-1420266884745704875" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="5418525595661779027" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="8137490351759638813" name="field0001" display="公文文号" fieldtype="VARCHAR" mappingField="doc_mark" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-8283609694511542996" name="field0002" display="紧急程度" fieldtype="VARCHAR" mappingField="urgent_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5959866726513853083" name="field0003" display="文稿名称" fieldtype="VARCHAR" mappingField="subject" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6215264660550104119" name="field0004" display="主送单位" fieldtype="VARCHAR" mappingField="send_to" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3222788256486831085" name="field0005" display="抄送单位" fieldtype="VARCHAR" mappingField="copy_to" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2963317553206545392" name="field0006" display="文件密级" fieldtype="VARCHAR" mappingField="secret_level" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3930677257367826603" name="field0007" display="主要领导签批" fieldtype="VARCHAR" mappingField="text1" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="7921382872060742264" name="field0008" display="分管领导意见" fieldtype="VARCHAR" mappingField="text2" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5365716565317141575" name="field0009" display="协管领导意见" fieldtype="VARCHAR" mappingField="text3" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="678450202035703020" name="field0010" display="呈报部门意见" fieldtype="VARCHAR" mappingField="text4" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-149966672408457970" name="field0011" display="领导会签" fieldtype="VARCHAR" mappingField="text5" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4134423707355072070" name="field0012" display="办公室核稿" fieldtype="VARCHAR" mappingField="fuhe" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3311986267109964931" name="field0013" display="印刷份数" fieldtype="DECIMAL" mappingField="copies" fieldlength="20,0" is_null="false" is_primary="false" classname=""/>
          <Field id="5274806966549693594" name="field0014" display="联系方式" fieldtype="VARCHAR" mappingField="phone" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="1100930175709037106" name="field0015" display="部门领导" fieldtype="VARCHAR" mappingField="string1" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-3293506256030183526" name="field0016" display="呈报时间" fieldtype="TIMESTAMP" mappingField="date1" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6157823906846847636" name="field0017" display="承办人" fieldtype="VARCHAR" mappingField="undertaker" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="4263276764315536300" name="视图 1" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="-1896321806170307723" name="填写" filename="2741973174520137412.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-4075393269880961601" name="审批" filename="-6108549653097594036.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="2980852930606678898" name="显示" filename="-5535661328641339811.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="7780460041319301441" name="办公室核稿" filename="Operation_-5651418134041116091.xml" type="update" defaultAuth="false" delete="false" phoneviewid="0" />
      <Operation id="-2131422030752167531" name="主要领导签批" filename="Operation_-9133109965261746616.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
      <Operation id="28724322274789580" name="分管领导意见" filename="Operation_-499925448522774428.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
      <Operation id="-5905233580417135097" name="协管领导意见" filename="Operation_-787564983404969114.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
      <Operation id="-5050310238807046773" name="呈报部门意见" filename="Operation_-5912543011464525377.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
      <Operation id="-3052288804194923514" name="领导会签" filename="Operation_5583197892277192436.xml" type="update" defaultAuth="false" delete="true" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind></Bind>', '<Extensions>
</Extensions>', TO_DATE('20180725152028', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="日喀则市纪委监委文稿呈签卡3" id="3677851881895839829"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0142"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="8137490351759638813"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-8283609694511542996"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="5959866726513853083"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="-6215264660550104119"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="-3222788256486831085"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="2963317553206545392"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-3930677257367826603"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="7921382872060742264"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="5365716565317141575"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="678450202035703020"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="-149966672408457970"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="4134423707355072070"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-3311986267109964931"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="5274806966549693594"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="1100930175709037106"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0016" id="-3293506256030183526"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0017" id="-6157823906846847636"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '6CCE3EA2D70F9FCDD7322F093E259EABB22FA3C7BFC50A0E3966DA19231A071A7949B4961FB7F640C46E55E304E891CBA19F630797382C81A06FE6DC4B6CE19073BAEDF6A0093615');
INSERT INTO "FORM_DEFINITION" VALUES (-5571175006922715837, '465', 289918544909713602, TO_DATE('20180810123504', 'YYYYMMDDHH24MISS'), 2, -732547941328516542, 1, 2, 0, '<TableList>
  <Table id="-4514271476369571086" name="formmain_0259" display="" tabletype="master" onwertable="" onwerfield="">
      <FieldList>
          <Field id="-2988096606321226670" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
          <Field id="-2728695124546861387" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/> 
          <Field id="1573341887600217963" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="-4397140176745904788" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-465478049380088469" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="4429848924410235626" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          <Field id="-6168383782306297268" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="-621315903240124672" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>
          <Field id="5342495166722885176" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>
          <Field id="6128033107990761222" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>
          
          
          
          <Field id="-6006779331886626638" name="field0001" display="填报部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-6643583495674115275" name="field0002" display="填报时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4537170503739525752" name="field0003" display="报告人" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6082532273606641287" name="field0004" display="单位及职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="3004046729087042099" name="field0005" display="联系电话" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="395139482621726439" name="field0006" display="外出类型" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-1749199503374530679" name="field0007" display="事由" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="4213085520024258376" name="field0008" display="开始时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-4093243834000388180" name="field0009" display="结束时间" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="8646772313071633252" name="field0010" display="天数" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="2015304418496629743" name="field0011" display="往返地点" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6225788136187906091" name="field0012" display="领导姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="-5068542250245404319" name="field0013" display="领导职务" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6189143776398754883" name="field0014" display="领导联系电话" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
          <Field id="6557972911565127956" name="field0015" display="备注" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
  <Table id="-4448447075996709163" name="formson_0260" display="组2" tabletype="slave" onwertable="formmain_0259" onwerfield="formmain_id">
      <FieldList>
          <Field id="-8330239594808849643" name="field0016" display="本年请休假情况" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>
      </FieldList>
      <IndexList>
      </IndexList>
  </Table>
</TableList>
', '<FormList>
  <Form id="2239025561079923196" name="日喀则市市直党政正职领导干部外出报批（报备）表" relviewid="0" type="seeyonform">
    <Engine>  infopath  </Engine>
    <ViewList>
      <View viewfile="view1.xsl" viewtype="html"/>
    </ViewList>
    <OperationList>
      <Operation id="1562832237433538879" name="填写" filename="-2626914156985889843.xml" type="add" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="7260367875809494587" name="审批" filename="4334713934132366168.xml" type="update" defaultAuth="true" delete="false" phoneviewid="0" />
      <Operation id="-1565792233639163051" name="显示" filename="-2692070393044120046.xml" type="readonly" defaultAuth="true" delete="false" phoneviewid="0" />
    </OperationList>
  </Form>
</FormList>
', '<QueryList>
</QueryList>', '<ReportList></ReportList>', '<Trigger>
  <EventList>
  </EventList>
</Trigger>', '<Bind id="-8250368896419214438" >
    <FormCode ></FormCode>
</Bind>
', '<Extensions>
</Extensions>', TO_DATE('20180810123504', 'YYYYMMDDHH24MISS'), '<?xml version="1.0" encoding="UTF-8"?>
<STYLE><FORMSTYLE name="465" id="-5571175006922715837"><VALUE><![CDATA[]]></VALUE><TABLESTYLES><TABLESTYLE name="formmain_0259"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0001" id="-6006779331886626638"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0002" id="-6643583495674115275"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0003" id="4537170503739525752"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0004" id="6082532273606641287"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0005" id="3004046729087042099"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0006" id="395139482621726439"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0007" id="-1749199503374530679"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0008" id="4213085520024258376"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0009" id="-4093243834000388180"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0010" id="8646772313071633252"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0011" id="2015304418496629743"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0012" id="6225788136187906091"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0013" id="-5068542250245404319"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0014" id="6189143776398754883"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE><FIELDSTYLE name="field0015" id="6557972911565127956"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE><TABLESTYLE name="formson_0260"><VALUE><![CDATA[]]></VALUE><FIELDSTYLES><FIELDSTYLE name="field0016" id="-8330239594808849643"><FIELDSTYLE><![CDATA[]]></FIELDSTYLE><FIELDVALUESTYLE><![CDATA[]]></FIELDVALUESTYLE></FIELDSTYLE></FIELDSTYLES></TABLESTYLE></TABLESTYLES></FORMSTYLE></STYLE>', 2, '58660954FDF5F66C08575964C7350DF9499C985CAA1C7B7AE52861941CEA82C01007827D35A2F7940162477926388738362C9DA917C60C4C4B7360D54598B4F98858775428BBC476');
