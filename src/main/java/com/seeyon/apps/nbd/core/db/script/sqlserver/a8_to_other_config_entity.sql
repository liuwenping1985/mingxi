CREATE TABLE [a8_to_other_config_entity]
(
[id]           [bigint] NOT NULL,
[name]         [NVARCHAR](255),
[create_time]  [datetime],
[update_time]  [datetime],
[status]       [NUMERIC](6, 0),
[affair_type]  [NVARCHAR](255),
[trigger_type] [NVARCHAR](512),
[export_type]  [NVARCHAR](255),
[export_url]   [NVARCHAR](255),
[link_id]      [NVARCHAR](255),
[ftd_id]      [bigint],
  PRIMARY KEY (id)

)