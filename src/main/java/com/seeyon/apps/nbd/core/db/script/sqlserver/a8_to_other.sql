CREATE TABLE [a8_to_other]
   (
  [id] [bigint] NOT NULL,
	[name] [nvarchar](255),
	[create_time] [datetime] NULL,
	[update_time] [datetime] NULL,
	[status] [NUMERIC](10, 0),
	[data] [ntext],
ext_string1    NVARCHAR(255),
ext_string2    NVARCHAR(255),
ext_string3    NVARCHAR(255),
ext_string4    NVARCHAR(255),
ext_string5    NVARCHAR(255),
ext_string6    NVARCHAR(255),
ext_string7    NVARCHAR(255),
ext_string8    NVARCHAR(255),
	[source_id] [nvarchar](255),
	PRIMARY KEY (id)
)