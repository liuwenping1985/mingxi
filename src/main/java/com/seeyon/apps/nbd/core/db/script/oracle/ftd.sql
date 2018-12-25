CREATE TABLE ftd
   (	id NUMBER(20,0) NOT NULL ENABLE,
	    name NVARCHAR2(255),
	    create_time DATE,
	    update_time DATE,
	    status NUMBER(6,0),
	    data NCLOB,
	ext_string1    NVARCHAR2(255),
	ext_string2    NVARCHAR2(255),
	ext_string3    NVARCHAR2(255),
	ext_string4    NVARCHAR2(255),
	ext_string5    NVARCHAR2(255),
	ext_string6    NVARCHAR2(255),
	ext_string7    NVARCHAR2(255),
	ext_string8    NVARCHAR2(255),
			PRIMARY KEY (id)
	)