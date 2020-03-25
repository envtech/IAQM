pro read_dem, dem_file,  $
              dem_coord,dem

sd_id = hdf_sd_start( dem_file, /read )

sds_name = 'coord'
sds_id = hdf_sd_select( sd_id, hdf_sd_nametoindex( sd_id, sds_name ) )
hdf_sd_getinfo, sds_id, type=type1, ndims = ndim1, natts = natt1, dims = dim_size1
hdf_sd_getdata, sds_id, dem_coord
hdf_sd_endaccess, sds_id

sds_name = 'dem_10m'
sds_id = hdf_sd_select( sd_id, hdf_sd_nametoindex( sd_id, sds_name ) )
hdf_sd_getinfo, sds_id, type=type1, ndims = ndim1, natts = natt1, dims = dim_size1
hdf_sd_getdata, sds_id, dem
hdf_sd_endaccess, sds_id

hdf_sd_end, sd_id

dem = REVERSE(dem, 2)

end