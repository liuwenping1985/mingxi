CREATE TABLE log_entry(
  id BIGINT NOT NULL,
  name NVARCHAR(255),
  create_time DATETIME,
  update_time DATETIME,
  status NUMERIC(6,0),
  msg NTEXT,
  [level] NVARCHAR(255),
  success NUMERIC(6,0),
  data NVARCHAR(512),
  PRIMARY KEY (id)
)