let T =
      { dw_hk_wake_interval_s : Natural
      , dw_ingest_url : Text
      , dw_sj_access_name : Text
      , dw_sj_shelf_life : Text
      , gec_data_dir : Text
      }

let default =
      { dw_hk_wake_interval_s = 10
      , dw_sj_access_name = "dw-write"
      , dw_sj_shelf_life = "10 days"
      }

in  { Type = T, default }
