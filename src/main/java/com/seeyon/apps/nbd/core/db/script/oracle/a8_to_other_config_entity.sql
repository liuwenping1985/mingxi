CREATE TABLE "a8_to_other_config_entity"
   (	"id" NUMBER(20,0) NOT NULL ENABLE,
	"name" NVARCHAR2(255),
	"create_time" DATE,
	"update_time" DATE,
	"status" NUMBER(6,0),
	"affair_type" NVARCHAR2(255),
	"trigger_type" NVARCHAR2(512),
	"export_type" NVARCHAR2(255),
	"export_url" NVARCHAR2(255),
	"link_id" NVARCHAR2(255),
	"ftd_id" NUMBER(20,0),
	 PRIMARY KEY ("id")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "V5XSPACE"  ENABLE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "V5XSPACE"