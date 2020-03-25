pro make_aeromod_input,period,src_X,src_Y,src_Z,  $
                                       QS,HS,TS,VS,DIA,  $
                                       xcoor,ycoor,dem,hill,  $
                                       sfc_file,pro_file,met_code,probase


  ;-----------------------------------------------
  ; make input file & aermod run
  ;-----------------------------------------------
  inp_file = 'aermod.inp'
  dim_size=size(dem, /DIMENSIONS)
  
  openw, lun, inp_file, /GET_LUN
  
  printf, lun, '***********************************'
  printf, lun, '**  pm dispersion  simulation  ***********'
  printf, lun, '***********************************'
  
  ; control pathway
  printf, lun, ''
  printf, lun, 'CO STARTING'
  printf, lun, '   TITLEONE PM emission contribution'
  printf, lun, '   MODELOPT  CONC  ELEV  BETA'
  printf, lun, '   AVERTIME  '+period+'  PERIOD'
  
  ;   printf, lun, '   MULTYEAR  YEAR1.SAV'
  printf, lun, '   POLLUTID  PM10'
  printf, lun, '   RUNORNOT  RUN'
  printf, lun, '   EVENTFIL  test.inp'
  printf, lun, '   ERRORFIL  errors.out'
  printf, lun, 'CO FINISHED'
  printf, lun, ''
  
  ;------------------------------------------------------
  ; source pathway
  ;------------------------------------------------------
  printf, lun, 'SO STARTING'
  printf, lun, '   ELEVUNIT  METERS'
  printf, lun, '   LOCATION STACK1 POINT  ',src_X,src_Y,src_Z,format='(a26,8x,i6,6x,i6,1x,f5.1)'
  ; SO SRCPARAM emission rate in g/(s-m2), average release height, $
  ;             Temp,EXIT Vel,DIAMETER
  ;Point Source                               QS       HS    TS    VS     D
  ;printf, lun, '   SRCPARAM  STACK1  100.0 10.00  425.  15.0   1.0'
  printf, lun, '   SRCPARAM  STACK1  ',QS,HS,TS,VS,DIA,format='(a21,f15.7,f6.2,3f7.2)'
  
  ;printf, lun, '   LOCATION STACK2 POINT  1300.0  1090.0  0.0'
  ;printf, lun, '   LOCATION STACK2 POINT  1300.0  1090.0  0.0'
  ; SO SRCPARAM emission rate in g/(s-m2), average release height, TEMP,  $
  ; EXIT VEL,DIAMETER
  ;printf, lun, '   SRCPARAM  STACK2  5000.0 10.00  425.  15.0   5.0'
  ;
  ;
  ;
  ;   printf, lun, '   SO BUILDHGT  STACK1    1*50.'
  ;   printf, lun, '   SO BUILDWID  STACK1    50.0'
  ;   printf, lun, '   SO BUILDLEN  STACK1    10.0'
  ;   printf, lun, '   SO XBADJ     STACK1   -47.35'
  ;   printf, lun, '   SO YBADJ     STACK1     34.35'
  printf, lun, '   SRCGROUP  ALL'
  printf, lun, 'SO FINISHED'
  printf, lun, ''
  
  ;------------------------------------------------------
  ; receptor pathway
  ;------------------------------------------------------
  printf, lun, 'RE STARTING'
  
  for i=0, dim_size(0)-1 do begin
  for j=0, dim_size(1)-1 do begin
      printf, lun, 'RE DISCCART ',xcoor(i),ycoor(j),dem(i,j),hill(i,j), format='(a12,4f10.0)'
  endfor
  endfor
  
  printf, lun, 'RE FINISHED'
  printf, lun, ''
  
  ;------------------------------------------------------
  ; meterology pathway
  ;------------------------------------------------------
  printf, lun, 'ME STARTING'
  printf, lun, '   SURFFILE  met_sfc.dat'
  printf, lun, '   PROFFILE  met_pro.dat'
  printf, lun, '   SURFDATA  '+met_code+' 2015 NAMWON,KR'
  printf, lun, '   UAIRDATA  '+met_code+' 2015 NAMWON,KR'
  printf, lun, '   PROFBASE  '+probase+'  METERS'
  printf, lun, 'ME FINISHED'
  ;  printf, lun, ''
  
  ;------------------------------------------------------
  ; OUTPUT pathway
  ;------------------------------------------------------
  printf, lun, 'OU STARTING'
  printf, lun, '   RECTABLE  ALLAVE  FIRST'
  ;printf, lun, '   MAXTABLE  ALLAVE  50'
  printf, lun, '   SUMMFILE  TEST.sum'
  printf, lun, 'OU FINISHED'
  
  free_lun, lun


end