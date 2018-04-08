/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     2015/6/3 14:51:05                            */
/*==============================================================*/


/*==============================================================*/
/* Table: DOC_ARCHIVE                                    */
/*==============================================================*/
CREATE TABLE DOC_ARCHIVE (
  ID INT8 NOT NULL,
  ARCHIVE_ID INT8,
  DOC_XML TEXT,
  CREATE_TIME TIMESTAMP,
  STATE INT2,
  CONSTRAINT PK_DOC_ARCHIVE PRIMARY KEY (ID)
)