CREATE TABLE data_link
(
  id             BIGINT NOT NULL ,
  name           NVARCHAR(255),
  create_time    DATETIME,
  update_time    DATETIME,
  data_base_name NVARCHAR(255),
  host           NVARCHAR(255),
  status         NUMERIC(6, 0),
  user_name      NVARCHAR(255),
  password       NVARCHAR(512),
  port           NVARCHAR(255),
  ext_string1    NVARCHAR(255),
  ext_string2    NVARCHAR(255),
  ext_string3    NVARCHAR(255),
  ext_string4    NVARCHAR(255),
  ext_string5    NVARCHAR(255),
  ext_string6    NVARCHAR(255),
  ext_string7    NVARCHAR(255),
  ext_string8    NVARCHAR(255),
  link_type      NVARCHAR(255),
  db_type        NVARCHAR(255),
  PRIMARY KEY (id)
)