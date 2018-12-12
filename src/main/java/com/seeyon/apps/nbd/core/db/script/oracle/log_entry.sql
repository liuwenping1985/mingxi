CREATE TABLE log_entry(
  id NUMBER(20,0) NOT NULL ENABLE,
  name NVARCHAR2(255),
  create_time DATE,
  update_time DATE,
  status NUMBER(6,0),
  msg NCLOB,
  "level" NVARCHAR2(255),
  success NUMBER(6,0),
  data NVARCHAR2(512),
  PRIMARY KEY (id)
)