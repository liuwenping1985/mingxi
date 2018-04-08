/*==============================================================*/
/* DBMS name:      MYSQL                   */
/* Created on:     2015/6/3 14:41:02                            */
/*==============================================================*/

/*==============================================================*/
/* Table: DOC_ARCHIVE                                    */
/*==============================================================*/
CREATE TABLE DOC_ARCHIVE (
  ID BIGINT(20) NOT NULL,
  ARCHIVE_ID BIGINT(20) DEFAULT NULL,
  DOC_XML LONGTEXT,
  CREATE_TIME DATETIME DEFAULT NULL,
  STATE INT(11) DEFAULT NULL,
  PRIMARY KEY  (ID)
)