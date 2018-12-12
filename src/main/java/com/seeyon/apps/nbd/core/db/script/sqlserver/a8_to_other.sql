CREATE TABLE [a8_to_other]
   (
  [id] [bigint] NOT NULL,
	[name] [nvarchar](255),
	[create_time] [datetime] NULL,
	[update_time] [datetime] NULL,
	[status] [NUMERIC](10, 0),
	[data] [ntext],
	[source_id] [nvarchar](255),
	PRIMARY KEY (id)
)