CREATE TABLE a8_to_other
   (
  id NUMBER(20,0) NOT NULL ENABLE,
	name NVARCHAR2(255),
	create_time DATE,
	update_time DATE,
	status NUMBER(6,0),
	data NCLOB,
	source_id NVARCHAR2(255),
	PRIMARY KEY (id)
	)