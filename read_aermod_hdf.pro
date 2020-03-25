pro read_aermod_hdf,hdf_file,QS,mod_PM25,                     $
                                measured_pm25,measured_oc,           $
                                mean_wind_spd,mean_wind_dir
                                



  ;-----------------------------------------------
  ; read hdf file
  ;-----------------------------------------------
  sd_id = hdf_sd_start( hdf_file, /read )

  sds_name = 'PM2.5'
  sds_id = hdf_sd_select( sd_id, hdf_sd_nametoindex( sd_id, sds_name ) )
  hdf_sd_getinfo, sds_id, type=type1, ndims = ndim1, natts = natt1, dims = dim_size1
  hdf_sd_getdata, sds_id, mod_PM25
  hdf_sd_endaccess, sds_id

  sds_name = 'measured_pm25'
  sds_id = hdf_sd_select( sd_id, hdf_sd_nametoindex( sd_id, sds_name ) )
  hdf_sd_getinfo, sds_id, type=type1, ndims = ndim1, natts = natt1, dims = dim_size1
  hdf_sd_getdata, sds_id, measured_pm25
  hdf_sd_endaccess, sds_id
  
  sds_name = 'measured_oc'
  sds_id = hdf_sd_select( sd_id, hdf_sd_nametoindex( sd_id, sds_name ) )
  hdf_sd_getinfo, sds_id, type=type1, ndims = ndim1, natts = natt1, dims = dim_size1
  hdf_sd_getdata, sds_id, measured_oc
  hdf_sd_endaccess, sds_id

  sds_name = 'mean_wind_spd'
  sds_id = hdf_sd_select( sd_id, hdf_sd_nametoindex( sd_id, sds_name ) )
  hdf_sd_getinfo, sds_id, type=type1, ndims = ndim1, natts = natt1, dims = dim_size1
  hdf_sd_getdata, sds_id, mean_wind_spd
  hdf_sd_endaccess, sds_id

  sds_name = 'mean_wind_dir'
  sds_id = hdf_sd_select( sd_id, hdf_sd_nametoindex( sd_id, sds_name ) )
  hdf_sd_getinfo, sds_id, type=type1, ndims = ndim1, natts = natt1, dims = dim_size1
  hdf_sd_getdata, sds_id, mean_wind_dir
  hdf_sd_endaccess, sds_id

  sds_name = 'QS'
  sds_id = hdf_sd_select( sd_id, hdf_sd_nametoindex( sd_id, sds_name ) )
  hdf_sd_getinfo, sds_id, type=type2, ndims = ndim2, natts = natt2, dims = dim_size2
  hdf_sd_getdata, sds_id, QS
  hdf_sd_endaccess, sds_id
  
  hdf_sd_end, sd_id



 print,' == End of read_aermod_out  !! == '

end