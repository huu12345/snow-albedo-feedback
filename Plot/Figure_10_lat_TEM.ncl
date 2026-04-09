begin

model6 = (/"ACCESS-ESM1-5","BCC-ESM1","CanESM5",\
"CESM2","CESM2-FV2","CESM2-WACCM","CESM2-WACCM-FV2","CIESM",\
"CNRM-CM6-1","CNRM-CM6-1-HR","CNRM-ESM2-1","E3SM-2-0",\
"E3SM-2-1","EC-Earth3","EC-Earth3-AerChem","EC-Earth3-Veg","EC-Earth3-Veg-LR",\
"FGOALS-f3-L","GISS-E2-1-G","GISS-E2-2-G","GISS-E3-G","HadGEM3-GC31-LL",\
"IPSL-CM6A-LR","IPSL-CM6A-MR1","MIROC6","MIROC-ES2L",\
"MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1",\
"UKESM1-0-LL"/)

;"ACCESS-CM2","BCC-CSM2-MR","CAS-ESM2-0","CMCC-CM2-HR4","CMCC-CM2-SR5",
; ,"E3SM-2-0-NARRM","EC-Earth3-CC","FGOALS-g3","HadGEM3-GC31-MM","KIOST-ESM",
; "NorESM2-LM","SAM0-UNICON","TaiESM1",,"UKESM1-1-LL"

;*******
inpath_model_SS   = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_cmip6/"
inpath_ERA5_SS    = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_ERA5-Land/"
inpath_MERRA2_SS  = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_MERRA2/"
inpath_JRA55_SS   = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_JRA55/"
inpath_JRA3Q_SS   = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_JRA3Q/"
inpath_ERA5snow_SS= "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_ERA5snow/"
inpath_OBS_SS     = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_obs_all/"

;*******
inpath_model_DS   = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/decadal_minus_first/result/result_cmip6/"
inpath_ERA5_DS    = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/decadal_minus_first/result/result_ERA5-Land/"
inpath_MERRA2_DS  = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/decadal_minus_first/result/result_MERRA2/"
inpath_JRA55_DS   = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/decadal_minus_first/result/result_JRA55/"
inpath_JRA3Q_DS   = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/decadal_minus_first/result/result_JRA3Q/"
inpath_ERA5snow_DS= "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/decadal_minus_first/result/result_ERA5snow/"
inpath_OBS_DS     = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/decadal_minus_first/result/result_obs_all/"

;*******
outpath = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/lat/"

M=(/"AM_0.25_misstoc/","MA_0.25_misstoc/","MJ_0.25_misstoc/"/)

wks = gsn_open_wks("pdf",outpath+"Figure_10")

n_model6 = dimsizes(model6)

print(n_model6)

;**************************************************************
;*************************季节时间尺度**************************
;****************读取CMIP6************
n_lon = 360
n_lat = 30   ;45N-75N

k1_36 = new((/3,n_lat,n_lon/),"double")
k2_36 = new((/3,n_lat,n_lon/),"double")
snc_36= new((/3,n_lat,n_lon/),"double")
k5_36 = new((/3,n_lat,n_lon/),"double")

k1_6_SS = new ((/n_model6,n_lat/),double)
k2_6_SS = new ((/n_model6,n_lat/),double)
snc_6_SS= new ((/n_model6,n_lat/),double)
k5_6_SS = new ((/n_model6,n_lat/),double)

do i = 0,n_model6-1

  m6 := model6(i)
  do j = 0,2

    files_k1 := systemfunc("ls "+inpath_model_SS+M(j)+"k1.*"+m6+".*grid.nc")
    files_k2 := systemfunc("ls "+inpath_model_SS+M(j)+"k2.*"+m6+".*grid.nc")
    files_snc:= systemfunc("ls "+inpath_model_SS+M(j)+"mean_snow.*"+m6+".*grid.nc")
    files_k5 := systemfunc("ls "+inpath_model_SS+M(j)+"k5.*"+m6+".*grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_36(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_36(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_36(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_36(j,:,:)= f_snc[:]->snc(0,{45:75},:)

    lat = f_k5[:]->lat
  end do

  k1_2  := dim_avg_n(k1_36,0)     ;季节平均
  k2_2  := dim_avg_n(k2_36,0)
  snc_2 := dim_avg_n(snc_36,0)
  k5_2 := dim_avg_n(k5_36,0)

  ; printVarSummary(k2_1)
  k1_6_SS(i,:) = dim_avg_n(k1_2,1)       ;纬向平均
  k2_6_SS(i,:) = dim_avg_n(k2_2,1)
  snc_6_SS(i,:)= dim_avg_n(snc_2,1)*100.0
  k5_6_SS(i,:) = dim_avg_n(k5_2,1)
end do

print(lat)

;******************读取观测**************
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3"/)

k1_obs_SS = new((/2,3,3,n_lat/),"double")
k2_obs_SS = new((/2,3,3,n_lat/),"double")
snc_obs_SS= new((/2,3,3,n_lat/),"double")
k5_obs_SS = new((/2,3,3,n_lat/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;snc
    do k= 0,2  ;alb

       k1_3_obs  = new((/3,n_lat,n_lon/),"double")
       k2_3_obs  = new((/3,n_lat,n_lon/),"double")
       snc_3_obs = new((/3,n_lat,n_lon/),"double")
       k5_3_obs  = new((/3,n_lat,n_lon/),"double")

       do j = 0,2
           files_k1 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k1.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
           files_k2 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
           files_snc:= systemfunc("ls "+inpath_OBS_SS+M(j)+"mean_snow.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
           files_k5 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k5.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")

           f_k1 := addfiles(files_k1,"r")
           f_k2 := addfiles(files_k2,"r")
           f_snc:= addfiles(files_snc,"r")
           f_k5 := addfiles(files_k5,"r")

           k1_3_obs(j,:,:) = f_k1[:]->k1(0,{45:75},:)
           k2_3_obs(j,:,:) = f_k2[:]->k2(0,{45:75},:)
           k5_3_obs(j,:,:) = f_k5[:]->k5(0,{45:75},:)
           snc_3_obs(j,:,:)= f_snc[:]->snc(0,{45:75},:)
       end do

       k1_3 = dim_avg_n(k1_3_obs,0)     ;季节平均
       k2_3 = dim_avg_n(k2_3_obs,0)
       snc_3= dim_avg_n(snc_3_obs,0)*100.0
       k5_3 = dim_avg_n(k5_3_obs,0)

       k1_obs_SS(m,n,k,:) = dim_avg_n(k1_3,1)       ;纬向平均
       k2_obs_SS(m,n,k,:) = dim_avg_n(k2_3,1)
       snc_obs_SS(m,n,k,:)= dim_avg_n(snc_3,1)
       k5_obs_SS(m,n,k,:) = dim_avg_n(k5_3,1)
     end do
   end do
end do


;*****************读取ERA5-Land****************
k1_3_ERA5 = new((/3,n_lat,n_lon/),"double")
k2_3_ERA5 = new((/3,n_lat,n_lon/),"double")
snc_3_ERA5= new((/3,n_lat,n_lon/),"double")
k5_3_ERA5 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k1.ERA5-Land2.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k2.ERA5-Land2.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_ERA5_SS+M(j)+"mean_snow.ERA5-Land2.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k5.ERA5-Land2.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_ERA5(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_ERA5(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_ERA5(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_ERA5(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 = dim_avg_n(k1_3_ERA5,0)     ;季节平均
k2_3 = dim_avg_n(k2_3_ERA5,0)
snc_3= dim_avg_n(snc_3_ERA5,0)*100.0
k5_3 = dim_avg_n(k5_3_ERA5,0)

; print(i)
k1_ERA5_SS = dim_avg_n(k1_3,1)       ;纬向平均
k2_ERA5_SS = dim_avg_n(k2_3,1)
snc_ERA5_SS= dim_avg_n(snc_3,1)
k5_ERA5_SS = dim_avg_n(k5_3,1)

;*****************读取MERRA2****************
k1_3_MERRA2 = new((/3,n_lat,n_lon/),"double")
k2_3_MERRA2 = new((/3,n_lat,n_lon/),"double")
snc_3_MERRA2= new((/3,n_lat,n_lon/),"double")
k5_3_MERRA2 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k1.MERRA22.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k2.MERRA22.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_MERRA2_SS+M(j)+"mean_snow.MERRA22.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k5.MERRA22.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_MERRA2(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_MERRA2(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_MERRA2(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_MERRA2(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 = dim_avg_n(k1_3_MERRA2,0)     ;季节平均
k2_3 = dim_avg_n(k2_3_MERRA2,0)
snc_3= dim_avg_n(snc_3_MERRA2,0)*100.0
k5_3 = dim_avg_n(k5_3_MERRA2,0)

; print(i)
k1_MERRA2_SS = dim_avg_n(k1_3,1)       ;纬向平均
k2_MERRA2_SS = dim_avg_n(k2_3,1)
snc_MERRA2_SS= dim_avg_n(snc_3,1)
k5_MERRA2_SS = dim_avg_n(k5_3,1)

;*****************读取JRA55****************
k1_3_JRA55 = new((/3,n_lat,n_lon/),"double")
k2_3_JRA55 = new((/3,n_lat,n_lon/),"double")
snc_3_JRA55= new((/3,n_lat,n_lon/),"double")
k5_3_JRA55 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k1.JRA552.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k2.JRA552.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_JRA55_SS+M(j)+"mean_snow.JRA552.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k5.JRA552.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_JRA55(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_JRA55(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_JRA55(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_JRA55(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 = dim_avg_n(k1_3_JRA55,0)     ;季节平均
k2_3 = dim_avg_n(k2_3_JRA55,0)
snc_3= dim_avg_n(snc_3_JRA55,0)*100.0
k5_3 = dim_avg_n(k5_3_JRA55,0)

; print(i)
k1_JRA55_SS = dim_avg_n(k1_3,1)       ;纬向平均
k2_JRA55_SS = dim_avg_n(k2_3,1)
snc_JRA55_SS= dim_avg_n(snc_3,1)
k5_JRA55_SS = dim_avg_n(k5_3,1)

;*****************读取JRA3Q****************
k1_3_JRA3Q = new((/3,n_lat,n_lon/),"double")
k2_3_JRA3Q = new((/3,n_lat,n_lon/),"double")
snc_3_JRA3Q= new((/3,n_lat,n_lon/),"double")
k5_3_JRA3Q = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k1.JRA3Q2.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k2.JRA3Q2.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"mean_snow.JRA3Q2.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k5.JRA3Q2.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_JRA3Q(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_JRA3Q(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_JRA3Q(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_JRA3Q(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 = dim_avg_n(k1_3_JRA3Q,0)     ;季节平均
k2_3 = dim_avg_n(k2_3_JRA3Q,0)
snc_3= dim_avg_n(snc_3_JRA3Q,0)*100.0
k5_3 = dim_avg_n(k5_3_JRA3Q,0)

; print(i)
k1_JRA3Q_SS = dim_avg_n(k1_3,1)       ;纬向平均
k2_JRA3Q_SS = dim_avg_n(k2_3,1)
snc_JRA3Q_SS= dim_avg_n(snc_3,1)
k5_JRA3Q_SS = dim_avg_n(k5_3,1)

;*****************读取ERA5snow****************
k1_3_ERA5snow = new((/3,n_lat,n_lon/),"double")
k2_3_ERA5snow = new((/3,n_lat,n_lon/),"double")
snc_3_ERA5snow= new((/3,n_lat,n_lon/),"double")
k5_3_ERA5snow = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k1.ERA5snow2.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k2.ERA5snow2.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"mean_snow.ERA5snow2.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k5.ERA5snow2.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_ERA5snow(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_ERA5snow(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_ERA5snow(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_ERA5snow(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 = dim_avg_n(k1_3_ERA5snow,0)     ;季节平均
k2_3 = dim_avg_n(k2_3_ERA5snow,0)
snc_3= dim_avg_n(snc_3_ERA5snow,0)*100.0
k5_3 = dim_avg_n(k5_3_ERA5snow,0)

; print(i)
k1_ERA5snow_SS = dim_avg_n(k1_3,1)       ;纬向平均
k2_ERA5snow_SS = dim_avg_n(k2_3,1)
snc_ERA5snow_SS= dim_avg_n(snc_3,1)
k5_ERA5snow_SS = dim_avg_n(k5_3,1)

;************每个纬度上，多模式的平均值和标准差***********
;;cmip6
k1_stat4    = dim_stat4_n(k1_6_SS,0)
k1_avg_6_SS = k1_stat4(0,:)
k1_std_6_SS = sqrt(k1_stat4(1,:))

k2_stat4    = dim_stat4_n(k2_6_SS,0)
k2_avg_6_SS = k2_stat4(0,:)
k2_std_6_SS = sqrt(k2_stat4(1,:))

snc_stat4    = dim_stat4_n(snc_6_SS,0)
snc_avg_6_SS = snc_stat4(0,:)
snc_std_6_SS = sqrt(snc_stat4(1,:))

k5_stat4    = dim_stat4_n(k5_6_SS,0)
k5_avg_6_SS = k5_stat4(0,:)
k5_std_6_SS = sqrt(k5_stat4(1,:))

;**************************************************************
;*************************年代际时间尺度*************************
;****************读取CMIP6************
k1_36 = new((/3,n_lat,n_lon/),"double")
k2_36 = new((/3,n_lat,n_lon/),"double")
snc_36= new((/3,n_lat,n_lon/),"double")
k5_36 = new((/3,n_lat,n_lon/),"double")

k1_6_DS = new ((/n_model6,n_lat/),double)
k2_6_DS = new ((/n_model6,n_lat/),double)
snc_6_DS= new ((/n_model6,n_lat/),double)
k5_6_DS = new ((/n_model6,n_lat/),double)

do i = 0,n_model6-1

  m6 := model6(i)
  do j = 0,2

    files_k1 := systemfunc("ls "+inpath_model_DS+"k1.*"+m6+".*grid.nc")
    files_k2 := systemfunc("ls "+inpath_model_DS+"k2.*"+m6+".*grid.nc")
    files_snc:= systemfunc("ls "+inpath_model_DS+"mean_snow.*"+m6+".*grid.nc")
    files_k5 := systemfunc("ls "+inpath_model_DS+"k5.*"+m6+".*grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_36(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_36(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_36(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_36(j,:,:)= f_snc[:]->snc(0,{45:75},:)
  end do
  k1_2 := dim_avg_n(k1_36,0)     ;季节平均
  k2_2 := dim_avg_n(k2_36,0)
  snc_2:= dim_avg_n(snc_36,0)
  k5_2 := dim_avg_n(k5_36,0)

  ; printVarSummary(k2_1)
  k1_6_DS(i,:) = dim_avg_n(k1_2,1)       ;纬向平均
  k2_6_DS(i,:) = dim_avg_n(k2_2,1)
  snc_6_DS(i,:)= dim_avg_n(snc_2,1)*100.0
  k5_6_DS(i,:) = dim_avg_n(k5_2,1)
end do

;********************读取观测*******************
k1_obs_DS  = new((/2,3,3,n_lat/),"double")
k2_obs_DS  = new((/2,3,3,n_lat/),"double")
k5_obs_DS  = new((/2,3,3,n_lat/),"double")
snc_obs_DS = new((/2,3,3,n_lat/),"double")

do m = 0,1
  do n = 0,2
    do k= 0,2

       files_k1 := systemfunc("ls "+inpath_OBS_DS+"k1.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
       files_k2 := systemfunc("ls "+inpath_OBS_DS+"k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
       files_k5 := systemfunc("ls "+inpath_OBS_DS+"k5.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
       files_snow := systemfunc("ls "+inpath_OBS_DS+"mean_snow.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")

       f_k1  := addfiles(files_k1,"r")
       f_k2  := addfiles(files_k2,"r")
       f_k5  := addfiles(files_k5,"r")
       f_snc := addfiles(files_snow,"r")

       k1_3 := f_k1[:]->k1(0,{45:75},:)
       k2_3 := f_k2[:]->k2(0,{45:75},:)
       k5_3 := f_k5[:]->k5(0,{45:75},:)
       snc_3:= f_snc[:]->snc(0,{45:75},:)

       ;纬向平均
       k1_obs_DS(m,n,k,:) = dim_avg_n(k1_3,1)
       k2_obs_DS(m,n,k,:) = dim_avg_n(k2_3,1)
       snc_obs_DS(m,n,k,:)= dim_avg_n(snc_3,1)*100.0
       k5_obs_DS(m,n,k,:) = dim_avg_n(k5_3,1)

     end do
   end do
end do


;***************************读取ERA5-Land****************************
k1_3_ERA5 = new((/3,n_lat,n_lon/),"double")
k2_3_ERA5 = new((/3,n_lat,n_lon/),"double")
snc_3_ERA5= new((/3,n_lat,n_lon/),"double")
k5_3_ERA5 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5_DS+"k1.ERA5-Land2.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5_DS+"k2.ERA5-Land2.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_ERA5_DS+"mean_snow.ERA5-Land2.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5_DS+"k5.ERA5-Land2.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_ERA5(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_ERA5(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_ERA5(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_ERA5(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 := dim_avg_n(k1_3_ERA5,0)     ;季节平均
k2_3 := dim_avg_n(k2_3_ERA5,0)
snc_3:= dim_avg_n(snc_3_ERA5,0)*100.0
k5_3 := dim_avg_n(k5_3_ERA5,0)

; print(i)
k1_ERA5_DS = dim_avg_n(k1_3,1)       ;纬向平均
k2_ERA5_DS = dim_avg_n(k2_3,1)
snc_ERA5_DS= dim_avg_n(snc_3,1)
k5_ERA5_DS = dim_avg_n(k5_3,1)

;***************************读取MERRA2****************************
k1_3_MERRA2 = new((/3,n_lat,n_lon/),"double")
k2_3_MERRA2 = new((/3,n_lat,n_lon/),"double")
snc_3_MERRA2= new((/3,n_lat,n_lon/),"double")
k5_3_MERRA2 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_MERRA2_DS+"k1.MERRA22.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_MERRA2_DS+"k2.MERRA22.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_MERRA2_DS+"mean_snow.MERRA22.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_MERRA2_DS+"k5.MERRA22.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_MERRA2(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_MERRA2(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_MERRA2(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_MERRA2(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 := dim_avg_n(k1_3_MERRA2,0)     ;季节平均
k2_3 := dim_avg_n(k2_3_MERRA2,0)
snc_3:= dim_avg_n(snc_3_MERRA2,0)*100.0
k5_3 := dim_avg_n(k5_3_MERRA2,0)

; print(i)
k1_MERRA2_DS = dim_avg_n(k1_3,1)       ;纬向平均
k2_MERRA2_DS = dim_avg_n(k2_3,1)
snc_MERRA2_DS= dim_avg_n(snc_3,1)
k5_MERRA2_DS = dim_avg_n(k5_3,1)

;***************************读取JRA55****************************
k1_3_JRA55 = new((/3,n_lat,n_lon/),"double")
k2_3_JRA55 = new((/3,n_lat,n_lon/),"double")
snc_3_JRA55= new((/3,n_lat,n_lon/),"double")
k5_3_JRA55 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA55_DS+"k1.JRA552.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA55_DS+"k2.JRA552.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_JRA55_DS+"mean_snow.JRA552.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA55_DS+"k5.JRA552.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_JRA55(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_JRA55(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_JRA55(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_JRA55(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 := dim_avg_n(k1_3_JRA55,0)     ;季节平均
k2_3 := dim_avg_n(k2_3_JRA55,0)
snc_3:= dim_avg_n(snc_3_JRA55,0)*100.0
k5_3 := dim_avg_n(k5_3_JRA55,0)

; print(i)
k1_JRA55_DS = dim_avg_n(k1_3,1)       ;纬向平均
k2_JRA55_DS = dim_avg_n(k2_3,1)
snc_JRA55_DS= dim_avg_n(snc_3,1)
k5_JRA55_DS = dim_avg_n(k5_3,1)

;***************************读取JRA3Q****************************
k1_3_JRA3Q = new((/3,n_lat,n_lon/),"double")
k2_3_JRA3Q = new((/3,n_lat,n_lon/),"double")
snc_3_JRA3Q= new((/3,n_lat,n_lon/),"double")
k5_3_JRA3Q = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA3Q_DS+"k1.JRA3Q2.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA3Q_DS+"k2.JRA3Q2.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_JRA3Q_DS+"mean_snow.JRA3Q2.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA3Q_DS+"k5.JRA3Q2.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_JRA3Q(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_JRA3Q(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_JRA3Q(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_JRA3Q(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 := dim_avg_n(k1_3_JRA3Q,0)     ;季节平均
k2_3 := dim_avg_n(k2_3_JRA3Q,0)
snc_3:= dim_avg_n(snc_3_JRA3Q,0)*100.0
k5_3 := dim_avg_n(k5_3_JRA3Q,0)

; print(i)
k1_JRA3Q_DS = dim_avg_n(k1_3,1)       ;纬向平均
k2_JRA3Q_DS = dim_avg_n(k2_3,1)
snc_JRA3Q_DS= dim_avg_n(snc_3,1)
k5_JRA3Q_DS = dim_avg_n(k5_3,1)

;***************************读取ERA5snow****************************
k1_3_ERA5snow = new((/3,n_lat,n_lon/),"double")
k2_3_ERA5snow = new((/3,n_lat,n_lon/),"double")
snc_3_ERA5snow= new((/3,n_lat,n_lon/),"double")
k5_3_ERA5snow = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5snow_DS+"k1.ERA5snow2.EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5snow_DS+"k2.ERA5snow2.EASE_grid.nc")
    files_snc:= systemfunc("ls "+inpath_ERA5snow_DS+"mean_snow.ERA5snow2.EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5snow_DS+"k5.ERA5snow2.EASE_grid.nc")

    f_k1 := addfiles(files_k1,"r")
    f_k2 := addfiles(files_k2,"r")
    f_snc:= addfiles(files_snc,"r")
    f_k5 := addfiles(files_k5,"r")

    k1_3_ERA5snow(j,:,:) = f_k1[:]->k1(0,{45:75},:)
    k2_3_ERA5snow(j,:,:) = f_k2[:]->k2(0,{45:75},:)
    k5_3_ERA5snow(j,:,:) = f_k5[:]->k5(0,{45:75},:)
    snc_3_ERA5snow(j,:,:)= f_snc[:]->snc(0,{45:75},:)
end do

k1_3 := dim_avg_n(k1_3_ERA5snow,0)     ;季节平均
k2_3 := dim_avg_n(k2_3_ERA5snow,0)
snc_3:= dim_avg_n(snc_3_ERA5snow,0)*100.0
k5_3 := dim_avg_n(k5_3_ERA5snow,0)

; print(i)
k1_ERA5snow_DS = dim_avg_n(k1_3,1)       ;纬向平均
k2_ERA5snow_DS = dim_avg_n(k2_3,1)
snc_ERA5snow_DS= dim_avg_n(snc_3,1)
k5_ERA5snow_DS = dim_avg_n(k5_3,1)

;**********************每个纬度上，多模式的平均值和标准差*********************
;;cmip6
k1_stat4    = dim_stat4_n(k1_6_DS,0)
k1_avg_6_DS = k1_stat4(0,:)
k1_std_6_DS = sqrt(k1_stat4(1,:))

k2_stat4    = dim_stat4_n(k2_6_DS,0)
k2_avg_6_DS = k2_stat4(0,:)
k2_std_6_DS = sqrt(k2_stat4(1,:))

snc_stat4    = dim_stat4_n(snc_6_DS,0)
snc_avg_6_DS = snc_stat4(0,:)
snc_std_6_DS = sqrt(snc_stat4(1,:))

k5_stat4    = dim_stat4_n(k5_6_DS,0)
k5_avg_6_DS = k5_stat4(0,:)
k5_std_6_DS = sqrt(k5_stat4(1,:))

print(k5_avg_6_DS)
;************************画散点图和平均值************************
y6  = ispan(455,745,10)/10.0

; colors := (/"220","60","black","220","orange"/)
; color_scatter := (/"254","120"/)

color_cmip6  = (/"black"/)
colors_shadow = "gray"

color_GLASS    = "175"
color_clara_a3 = "2"
color_clara_a2 = "forestgreen"
color_APPx     = "deeppink2";"sienna4"

color_ERA5     = (/"sienna4"/)
color_ERA5snow = (/"blue3"/)
color_MERRA2   = (/"springgreen3"/)
color_JRA55    = (/"magenta"/)
color_JRA3Q    = (/"250"/)

color_obs_avg  = "red"
color_rea_avg  = "72"

;;cmip6
res = True
res@gsnDraw     = False
res@gsnFrame    = False
res@gsnMaximize = False

res@trXMinF = 45.5
res@trXMaxF = 74.5
res@tmXBMode = "Explicit"                  ; 使用显式标签
res@tmXBValues = (/50,60,70/)              ; 指定要标记的值位置
res@tmXBLabels = (/"50N","60N","70N"/)

res@tmBorderThicknessF = 1.5
res@tmXBMajorThicknessF= 1.4
res@tmXTMajorThicknessF= 1.4
res@tmYLMajorThicknessF= 1.4
res@tmYRMajorThicknessF= 1.4

; res@trXReverse   = True
res@tmXTLabelsOn = False
res@tmYRLabelsOn = False

res@tmYMajorGrid = True         ;打开刻度网格
res@tmYMajorGridLineColor  = "grey75"
res@tmYMajorGridThicknessF = 1

res@tiMainFontHeightF    = 0.015
res@tiYAxisFontHeightF   = 0.015
res@tmYLLabelFontHeightF = 0.009    ;字号
res@tmYLLabelFontHeightF = 0.01

res@tmGridDrawOrder = "PreDraw"

; res@vpXF= 0.12
; res@vpYF= 0.95
res@vpWidthF    = 0.2
res@vpHeightF   = 0.2

XMin1 = -15.
XMax1 = 4.0

XMin2 = 0.
XMax2 = 60.

XMin3 = 0.
XMax3 = 100.

XMin4 = -12.
XMax4 = 4.

;-------------------第一列--------------------
res@tfPolyDrawOrder    = "Predraw"

res@trYMinF = XMin1
res@trYMaxF = XMax1

res@xyMarkLineMode = "Lines"
res@xyMarkers     := 16
res@xyMarkerSizeF  = 0.005
res@xyMarkerColor  = color_cmip6
res@xyLineColor    = color_cmip6
res@xyLineThicknessF = 2.8 ;折线宽度

;*******seasonal*******
res@tiMainOn      = True
res@tiMainString = "~F33~D~F~S~B~C~N~/<~F33~D~F~T~B~S~N~> (%/K)"
res@tiYAxisString = "Seasonal"

plot1 = gsn_csm_xy (wks,y6,k1_avg_6_SS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = k1_avg_6_SS(k) + k1_std_6_SS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = k1_avg_6_SS(k) - k1_std_6_SS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum1 = gsn_add_polygon (wks,plot1,xp,yp,gsres)

;*******decadal*******
res@tiYAxisString = "Decadal"
res@tiMainOn      = False

plot5 = gsn_csm_xy (wks,y6,k1_avg_6_DS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = k1_avg_6_DS(k) + k1_std_6_DS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = k1_avg_6_DS(k) - k1_std_6_DS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum5 = gsn_add_polygon (wks,plot5,xp,yp,gsres)

;-------------------第二列--------------------
res@trYMinF = XMin2
res@trYMaxF = XMax2

;*******seasonal*******
res@tiMainOn     = True
res@tiMainString = "~F33~a~F~~B~snow~N~~H-57V6F35~EEEEE~FV-6H3~~V11F33~ _ ~V-11~~F33~a~F~~B~land~N~ (%)"
; res@tiYAxisOn    = False

plot2 = gsn_csm_xy (wks,y6,k2_avg_6_SS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = k2_avg_6_SS(k) + k2_std_6_SS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = k2_avg_6_SS(k) - k2_std_6_SS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum2 = gsn_add_polygon (wks,plot2,xp,yp,gsres)

;*******decadal*******
res@tiMainOn      = False
plot6 = gsn_csm_xy (wks,y6,k2_avg_6_DS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = k2_avg_6_DS(k) + k2_std_6_DS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = k2_avg_6_DS(k) - k2_std_6_DS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum6 = gsn_add_polygon (wks,plot6,xp,yp,gsres)

;-------------------第三列--------------------
res@trYMinF = XMin3
res@trYMaxF = XMax3

;*******seasonal*******
res@tiMainString = "S~B~C~N~~H-28V10F35~EE~FV-6H3~ (%)"
res@tiMainOn     = True
res@tiYAxisString = "Seasonal"

plot3 = gsn_csm_xy (wks,y6,snc_avg_6_SS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = snc_avg_6_SS(k) + snc_std_6_SS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = snc_avg_6_SS(k) - snc_std_6_SS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum3 = gsn_add_polygon (wks,plot3,xp,yp,gsres)

;*******decadal*******
res@tiYAxisString = "Decadal"
res@tiMainOn      = False
plot7 = gsn_csm_xy (wks,y6,snc_avg_6_DS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = snc_avg_6_DS(k) + snc_std_6_DS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = snc_avg_6_DS(k) - snc_std_6_DS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum7 = gsn_add_polygon (wks,plot7,xp,yp,gsres)

res@tiYAxisOn    = False

;-------------------第四列--------------------
;*******seasonal*******
res@trYMinF = -2.5
res@trYMaxF = 0.5
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = -2.5
res@tmYLTickSpacingF = 0.5
res@tmYLTickEndF     = 0.5

res@tiMainString = "~F33~D~F~~F33~a~F~~B~snow~N~/<~F33~D~F~T~B~S~N~> (%/K)"
res@tiMainOn      = True

plot4 = gsn_csm_xy (wks,y6,k5_avg_6_SS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = k5_avg_6_SS(k) + k5_std_6_SS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = k5_avg_6_SS(k) - k5_std_6_SS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum4 = gsn_add_polygon (wks,plot4,xp,yp,gsres)

;*******decadal*******
res@trYMinF = -12.
res@trYMaxF = 6.

res@tmYLMode         = "Manual"
res@tmYLTickStartF   = -12
res@tmYLTickSpacingF = 3.
res@tmYLTickEndF     = 9.

res@tiMainOn      = False

plot8 = gsn_csm_xy (wks,y6,k5_avg_6_DS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = k5_avg_6_DS(k) + k5_std_6_DS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = k5_avg_6_DS(k) - k5_std_6_DS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum8 = gsn_add_polygon (wks,plot8,xp,yp,gsres)


;***************************OBS***********************************
x_k1_SS_obs = dim_avg_n(k1_obs_SS,(/0,1/))
x_k2_SS_obs = dim_avg_n(k2_obs_SS,(/0,1/))
x_k5_SS_obs = dim_avg_n(k5_obs_SS,(/0,1/))
x_snc_SS_obs= dim_avg_n(snc_obs_SS,(/0,1/))

x_k1_DS_obs = dim_avg_n(k1_obs_DS,(/0,1/))
x_k2_DS_obs = dim_avg_n(k2_obs_DS,(/0,1/))
x_k5_DS_obs = dim_avg_n(k5_obs_DS,(/0,1/))
x_snc_DS_obs= dim_avg_n(snc_obs_DS,(/0,1/))
; print(x_k5_DS_obs)

res@xyMarkLineMode = "Lines"

res@xyCurveDrawOrder = "PreDraw"
res@xyLineThicknessF = 1.5 ;折线宽度

res@xyDashPattern    = 0

res@trYMinF = XMin2
res@trYMaxF = XMax2
res@xyLineColors    := (/color_APPx,color_clara_a2,color_clara_a3/)
plot22_obs = gsn_csm_xy (wks,y6,x_k2_SS_obs,res)
plot66_obs = gsn_csm_xy (wks,y6,x_k2_DS_obs,res)

res@trYMinF = XMin4
res@trYMaxF = XMax4
res@xyLineColors    := (/color_APPx,color_clara_a2,color_clara_a3/)
plot44_obs = gsn_csm_xy (wks,y6,x_k5_SS_obs,res)
plot88_obs = gsn_csm_xy (wks,y6,x_k5_DS_obs,res)

overlay(plot2,plot22_obs)
overlay(plot4,plot44_obs)

overlay(plot6,plot66_obs)
overlay(plot8,plot88_obs)

;***************************再分析***********************************
x_k1_SS = new((/5,30/),double)
x_k2_SS = new((/5,30/),double)
x_snc_SS = new((/5,30/),double)
x_k5_SS= new((/5,30/),double)

x_k1_DS = new((/5,30/),double)
x_k2_DS = new((/5,30/),double)
x_snc_DS = new((/5,30/),double)
x_k5_DS= new((/5,30/),double)

x_k1_SS(0,:) = k1_ERA5_SS
x_k1_SS(1,:) = k1_ERA5snow_SS
x_k1_SS(2,:) = k1_JRA3Q_SS
x_k1_SS(3,:) = k1_JRA55_SS
x_k1_SS(4,:) = k1_MERRA2_SS

x_k1_DS(0,:) = k1_ERA5_DS
x_k1_DS(1,:) = k1_ERA5snow_DS
x_k1_DS(2,:) = k1_JRA3Q_DS
x_k1_DS(3,:) = k1_JRA55_DS
x_k1_DS(4,:) = k1_MERRA2_DS

x_k2_SS(0,:) = k2_ERA5_SS
x_k2_SS(1,:) = k2_ERA5snow_SS
x_k2_SS(2,:) = k2_JRA3Q_SS
x_k2_SS(3,:) = k2_JRA55_SS
x_k2_SS(4,:) = k2_MERRA2_SS

x_k2_DS(0,:) = k2_ERA5_DS
x_k2_DS(1,:) = k2_ERA5snow_DS
x_k2_DS(2,:) = k2_JRA3Q_DS
x_k2_DS(3,:) = k2_JRA55_DS
x_k2_DS(4,:) = k2_MERRA2_DS

x_snc_SS(0,:) = snc_ERA5_SS
x_snc_SS(1,:) = snc_ERA5snow_SS
x_snc_SS(2,:) = snc_JRA3Q_SS
x_snc_SS(3,:) = snc_JRA55_SS
x_snc_SS(4,:) = snc_MERRA2_SS

x_snc_DS(0,:) = snc_ERA5_DS
x_snc_DS(1,:) = snc_ERA5snow_DS
x_snc_DS(2,:) = snc_JRA3Q_DS
x_snc_DS(3,:) = snc_JRA55_DS
x_snc_DS(4,:) = snc_MERRA2_DS

x_k5_SS(0,:) = k5_ERA5_SS
x_k5_SS(1,:) = k5_ERA5snow_SS
x_k5_SS(2,:) = k5_JRA3Q_SS
x_k5_SS(3,:) = k5_JRA55_SS
x_k5_SS(4,:) = k5_MERRA2_SS

x_k5_DS(0,:) = k5_ERA5_DS
x_k5_DS(1,:) = k5_ERA5snow_DS
x_k5_DS(2,:) = k5_JRA3Q_DS
x_k5_DS(3,:) = k5_JRA55_DS
x_k5_DS(4,:) = k5_MERRA2_DS

res@xyDashPattern    = 14
res@xyLineColors  := (/color_ERA5,color_ERA5snow,color_JRA3Q,color_JRA55,color_MERRA2/)

res@trYMinF = XMin1
res@trYMaxF = XMax1
plot11_ERA5 = gsn_csm_xy (wks,y6,x_k1_SS,res)
plot55_ERA5 = gsn_csm_xy (wks,y6,x_k1_DS,res)

res@trYMinF = XMin2
res@trYMaxF = XMax2
plot22_ERA5 = gsn_csm_xy (wks,y6,x_k2_SS,res)
plot66_ERA5 = gsn_csm_xy (wks,y6,x_k2_DS,res)

res@trYMinF = XMin3
res@trYMaxF = XMax3
plot33_ERA5 = gsn_csm_xy (wks,y6,x_snc_SS,res)
plot77_ERA5 = gsn_csm_xy (wks,y6,x_snc_DS,res)

res@trYMinF = XMin4
res@trYMaxF = XMax4
plot44_ERA5 = gsn_csm_xy (wks,y6,x_k5_SS,res)
plot88_ERA5 = gsn_csm_xy (wks,y6,x_k5_DS,res)

overlay(plot1,plot11_ERA5)
overlay(plot2,plot22_ERA5)
overlay(plot3,plot33_ERA5)
overlay(plot4,plot44_ERA5)

overlay(plot5,plot55_ERA5)
overlay(plot6,plot66_ERA5)
overlay(plot7,plot77_ERA5)
overlay(plot8,plot88_ERA5)

;***************观测、再分析平均*****************
;;;reanalysis avg
res@xyCurveDrawOrder = "PostDraw"

res@xyLineColors    := color_rea_avg
res@xyDashPattern    = 0
res@xyLineThicknessF = 2.8       ;折线宽度

x_k1_SS_avg  = dim_avg_n(x_k1_SS,0)
x_k2_SS_avg  = dim_avg_n(x_k2_SS,0)
x_snc_SS_avg = dim_avg_n(x_snc_SS,0)
x_k5_SS_avg  = dim_avg_n(x_k5_SS,0)

x_k1_DS_avg  = dim_avg_n(x_k1_DS,0)
x_k2_DS_avg  = dim_avg_n(x_k2_DS,0)
x_snc_DS_avg = dim_avg_n(x_snc_DS,0)
x_k5_DS_avg  = dim_avg_n(x_k5_DS,0)

plot11_ERA5_avg = gsn_csm_xy (wks,y6,x_k1_SS_avg,res)
plot22_ERA5_avg = gsn_csm_xy (wks,y6,x_k2_SS_avg,res)
plot33_ERA5_avg = gsn_csm_xy (wks,y6,x_snc_SS_avg,res)
plot44_ERA5_avg = gsn_csm_xy (wks,y6,x_k5_SS_avg,res)

plot55_ERA5_avg = gsn_csm_xy (wks,y6,x_k1_DS_avg,res)
plot66_ERA5_avg = gsn_csm_xy (wks,y6,x_k2_DS_avg,res)
plot77_ERA5_avg = gsn_csm_xy (wks,y6,x_snc_DS_avg,res)
plot88_ERA5_avg = gsn_csm_xy (wks,y6,x_k5_DS_avg,res)

overlay(plot1,plot11_ERA5_avg)
overlay(plot2,plot22_ERA5_avg)
overlay(plot3,plot33_ERA5_avg)
overlay(plot4,plot44_ERA5_avg)

overlay(plot5,plot55_ERA5_avg)
overlay(plot6,plot66_ERA5_avg)
overlay(plot7,plot77_ERA5_avg)
overlay(plot8,plot88_ERA5_avg)

;;;obs avg
res@xyLineColors    := color_obs_avg

x_k1_SS_obs_avg = dim_avg_n(x_k1_SS_obs(0:2,:),0)
x_k2_SS_obs_avg = dim_avg_n(x_k2_SS_obs(0:2,:),0)
x_k5_SS_obs_avg = dim_avg_n(x_k5_SS_obs(0:2,:),0)
x_snc_SS_obs_avg= dim_avg_n(x_snc_SS_obs(0:2,:),0)

x_k1_DS_obs_avg = dim_avg_n(x_k1_DS_obs(0:2,:),0)
x_k2_DS_obs_avg = dim_avg_n(x_k2_DS_obs(0:2,:),0)
x_k5_DS_obs_avg = dim_avg_n(x_k5_DS_obs(0:2,:),0)
x_snc_DS_obs_avg= dim_avg_n(x_snc_DS_obs(0:2,:),0)
print(x_k5_DS_obs_avg)

plot11_obs_avg = gsn_csm_xy (wks,y6,x_k1_SS_obs_avg,res)
plot22_obs_avg = gsn_csm_xy (wks,y6,x_k2_SS_obs_avg,res)
plot33_obs_avg = gsn_csm_xy (wks,y6,x_snc_SS_obs_avg,res)
plot44_obs_avg = gsn_csm_xy (wks,y6,x_k5_SS_obs_avg,res)

plot55_obs_avg = gsn_csm_xy (wks,y6,x_k1_DS_obs_avg,res)
plot66_obs_avg = gsn_csm_xy (wks,y6,x_k2_DS_obs_avg,res)
plot77_obs_avg = gsn_csm_xy (wks,y6,x_snc_DS_obs_avg,res)
plot88_obs_avg = gsn_csm_xy (wks,y6,x_k5_DS_obs_avg,res)

overlay(plot1,plot11_obs_avg)
overlay(plot2,plot22_obs_avg)
overlay(plot3,plot33_obs_avg)
overlay(plot4,plot44_obs_avg)

overlay(plot5,plot55_obs_avg)
overlay(plot6,plot66_obs_avg)
overlay(plot7,plot77_obs_avg)
overlay(plot8,plot88_obs_avg)

;*******************************legend*****************************
colors := (/color_APPx, color_clara_a2, color_clara_a3,\
            color_ERA5, color_ERA5snow, color_JRA3Q,   color_JRA55,color_MERRA2,\
            color_obs_avg,color_rea_avg,color_cmip6/)

labels = (/"APP-x","CLARA-A2","CLARA-A3",\
           "ERA5-Land","ERA5-Snow","JRA-3Q","JRA-55","MERRA-2",\
           "OBS mean","Reanalysis mean","CMIP6 mean"/)

dash = new(dimsizes(colors),"integer")
dash(0:2)  = 0
dash(3:7)  = 14
dash(8:10) = 0

thick = new(dimsizes(colors),"float")
thick(0:7)  = 2.
thick(8:10) = 5.3

xpos  := new(12,float)
xpos(:) = 0.14+0.69

ypos  := fspan(0.76,0.45,12)+0.015

res_text               = True
res_text@txFontHeightF = 0.012
res_text@txJust        = "CenterLeft"

res_lines                   = True        ; polyline mods desired

do i = 0,10
   res_lines@gsLineColor       = colors(i)   ; line color
   res_lines@gsLineDashPattern = dash(i)   ; dash pattern
   res_lines@gsLineThicknessF  = thick(i)           ; line thicker

   gsn_polyline_ndc(wks,(/xpos(i),xpos(i)+0.04/),(/ypos(i),ypos(i)/),res_lines)
   gsn_text_ndc(wks,labels(i),xpos(i)+0.043,ypos(i),res_text)
end do

;********************************************************************
;**********************************************************
pres = True
; pres@txString = "albedo("+ymStrt+"-"+ymLast+")"
; pres@gsnPanelMainFontHeightF     = 0.015
pres@gsnPanelXWhiteSpacePercent  = 17      ;留白
; pres@gsnPanelYWhiteSpacePercent  = 2
;
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)"/)
pres@gsnPanelFigureStringsJust    = "TopLeft"
; pres@gsnPanelFigureStringsPositions = (/0.5, 0.98/)

pres@gsnPanelFigureStringsPerimOn = False
pres@gsnPanelFigureStringsFontHeightF = 0.015

YF = fspan(0.78,0.4,2)
pres@gsnPanelYF = (/YF(0),YF(0),\
                    YF(1),YF(1)/)

XF = fspan(0.12,0.5,2)
pres@gsnPanelXF = (/XF(0),XF(1),\
                    XF(0),XF(1)/)

gsn_panel(wks,(/plot3,plot4,plot7,plot8/),(/2,2/),pres)

; psres = True
; maximize_output(wks,psres)  ; calls draw and frame for you

end
