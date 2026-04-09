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

wks = gsn_open_wks("pdf",outpath+"Figure_3")

n_model6 = dimsizes(model6)
; n_obs    = 4*4*4

;**************************************************************
;*************************季节时间尺度**************************
;****************读取CMIP6************
n_lon = 360
n_lat = 30   ;45N-75N

NET_3 = new((/3,n_lat,n_lon/),"double")
SNC_3 = new((/3,n_lat,n_lon/),"double")
TEM_3 = new((/3,n_lat,n_lon/),"double")

NET_6_SS = new ((/n_model6,n_lat/),double)
SNC_6_SS = new ((/n_model6,n_lat/),double)
TEM_6_SS = new ((/n_model6,n_lat/),double)

do i = 0,n_model6-1

  m6 := model6(i)
  ;print(i)
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_model_SS+M(j)+"k4.*"+m6+"*grid.nc")
    files_SNC := systemfunc("ls "+inpath_model_SS+M(j)+"k1k2.*"+m6+"*grid.nc")
    files_TEM := systemfunc("ls "+inpath_model_SS+M(j)+"k3.*"+m6+"*grid.nc")
    ; ;print(files_NET)
    ; ;print(files_SNC)
    ; ;print(files_TEM)
    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
  end do

  NET_1     = dim_avg_n(NET_3,0)   ;月平均
  SNC_1     = dim_avg_n(SNC_3,0)
  TEM_1     = dim_avg_n(TEM_3,0)
  ; printVarSummary(NET_1)

  NET_6_SS(i,:) = dim_avg_n(NET_1,1)   ;纬向平均
  SNC_6_SS(i,:) = dim_avg_n(SNC_1,1)
  TEM_6_SS(i,:) = dim_avg_n(TEM_1,1)
end do

;print(SNC_6)
;print(TEM_6)

;*****************读取观测***************
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3"/)


NET_obs_SS = new((/2,3,3,n_lat/),"double")
SNC_obs_SS = new((/2,3,3,n_lat/),"double")
TEM_obs_SS = new((/2,3,3,n_lat/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;snc
    do k= 0,2  ;alb
      NET_3_obs = new((/3,n_lat,n_lon/),"double")
      SNC_3_obs = new((/3,n_lat,n_lon/),"double")
      TEM_3_obs = new((/3,n_lat,n_lon/),"double")

      do j = 0,2
          files_NET := systemfunc("ls "+inpath_OBS_SS+M(j)+"k4.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_SNC := systemfunc("ls "+inpath_OBS_SS+M(j)+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_TEM := systemfunc("ls "+inpath_OBS_SS+M(j)+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          ; ;print(files_NET)

          f_NET := addfiles(files_NET,"r")
          f_SNC := addfiles(files_SNC,"r")
          f_TEM := addfiles(files_TEM,"r")

          NET_3_obs(j,:,:) = f_NET[:]->k4(0,{45:75},:)
          SNC_3_obs(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
          TEM_3_obs(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
      end do

      NET_4 := dim_avg_n(NET_3_obs,0)  ;月平均
      SNC_4 := dim_avg_n(SNC_3_obs,0)
      TEM_4 := dim_avg_n(TEM_3_obs,0)

      NET_obs_SS(m,n,k,:) = dim_avg_n(NET_4,1)  ;纬向平均
      SNC_obs_SS(m,n,k,:) = dim_avg_n(SNC_4,1)
      TEM_obs_SS(m,n,k,:) = dim_avg_n(TEM_4,1)
    end do
  end do
end do


;***************************读取ERA5-Land****************************
NET_3_ERA5 = new((/3,n_lat,n_lon/),"double")
SNC_3_ERA5 = new((/3,n_lat,n_lon/),"double")
TEM_3_ERA5 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k4.ERA5-Land2.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k1k2.ERA5-Land2.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k3.ERA5-Land2.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_ERA5(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_ERA5(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_ERA5(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_ERA5,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_ERA5,0)
TEM_5   = dim_avg_n(TEM_3_ERA5,0)

NET_ERA5_SS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_ERA5_SS = dim_avg_n(SNC_5,1)
TEM_ERA5_SS = dim_avg_n(TEM_5,1)

;***************************读取MERRA2****************************
NET_3_MERRA2 = new((/3,n_lat,n_lon/),"double")
SNC_3_MERRA2 = new((/3,n_lat,n_lon/),"double")
TEM_3_MERRA2 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k4.MERRA22.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k1k2.MERRA22.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k3.MERRA22.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_MERRA2(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_MERRA2(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_MERRA2(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_MERRA2,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_MERRA2,0)
TEM_5   = dim_avg_n(TEM_3_MERRA2,0)

NET_MERRA2_SS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_MERRA2_SS = dim_avg_n(SNC_5,1)
TEM_MERRA2_SS = dim_avg_n(TEM_5,1)

;***************************读取JRA55****************************
NET_3_JRA55 = new((/3,n_lat,n_lon/),"double")
SNC_3_JRA55 = new((/3,n_lat,n_lon/),"double")
TEM_3_JRA55 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k4.JRA552.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k1k2.JRA552.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k3.JRA552.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_JRA55(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_JRA55(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_JRA55(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_JRA55,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_JRA55,0)
TEM_5   = dim_avg_n(TEM_3_JRA55,0)

NET_JRA55_SS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_JRA55_SS = dim_avg_n(SNC_5,1)
TEM_JRA55_SS = dim_avg_n(TEM_5,1)

;***************************读取JRA3Q****************************
NET_3_JRA3Q = new((/3,n_lat,n_lon/),"double")
SNC_3_JRA3Q = new((/3,n_lat,n_lon/),"double")
TEM_3_JRA3Q = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k4.JRA3Q2.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k1k2.JRA3Q2.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k3.JRA3Q2.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_JRA3Q(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_JRA3Q(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_JRA3Q(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_JRA3Q,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_JRA3Q,0)
TEM_5   = dim_avg_n(TEM_3_JRA3Q,0)

NET_JRA3Q_SS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_JRA3Q_SS = dim_avg_n(SNC_5,1)
TEM_JRA3Q_SS = dim_avg_n(TEM_5,1)

;***************************读取ERA5snow****************************
NET_3_ERA5snow = new((/3,n_lat,n_lon/),"double")
SNC_3_ERA5snow = new((/3,n_lat,n_lon/),"double")
TEM_3_ERA5snow = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k4.ERA5snow2.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k1k2.ERA5snow2.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k3.ERA5snow2.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_ERA5snow(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_ERA5snow(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_ERA5snow(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_ERA5snow,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_ERA5snow,0)
TEM_5   = dim_avg_n(TEM_3_ERA5snow,0)

NET_ERA5snow_SS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_ERA5snow_SS = dim_avg_n(SNC_5,1)
TEM_ERA5snow_SS = dim_avg_n(TEM_5,1)

;***************每个纬度上，多模式的平均值和标准差************
;;cmip6
NET_stat41   = dim_stat4_n(NET_6_SS,0)
NET_avg_6_SS = NET_stat41(0,:)
NET_std_6_SS = sqrt(NET_stat41(1,:))

SNC_stat41   = dim_stat4_n(SNC_6_SS,0)
SNC_avg_6_SS = SNC_stat41(0,:)
SNC_std_6_SS = sqrt(SNC_stat41(1,:))

TEM_stat41   = dim_stat4_n(TEM_6_SS,0)
TEM_avg_6_SS = TEM_stat41(0,:)
TEM_std_6_SS = sqrt(TEM_stat41(1,:))

;**************************************************************
;*************************年代际时间尺度**************************
;****************读取CMIP6************
NET_3 = new((/3,n_lat,n_lon/),"double")
SNC_3 = new((/3,n_lat,n_lon/),"double")
TEM_3 = new((/3,n_lat,n_lon/),"double")

NET_6_DS = new ((/n_model6,n_lat/),double)
SNC_6_DS = new ((/n_model6,n_lat/),double)
TEM_6_DS = new ((/n_model6,n_lat/),double)

do i = 0,n_model6-1

  m6 := model6(i)
  ;print(i)
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_model_DS+"k4.*"+m6+"*grid.nc")
    files_SNC := systemfunc("ls "+inpath_model_DS+"k1k2.*"+m6+"*grid.nc")
    files_TEM := systemfunc("ls "+inpath_model_DS+"k3.*"+m6+"*grid.nc")
    ; ;print(files_NET)
    ; ;print(files_SNC)
    ; ;print(files_TEM)
    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
  end do

  NET_1     = dim_avg_n(NET_3,0)   ;月平均
  SNC_1     = dim_avg_n(SNC_3,0)
  TEM_1     = dim_avg_n(TEM_3,0)
  ; printVarSummary(NET_1)

  NET_6_DS(i,:) = dim_avg_n(NET_1,1)   ;纬向平均
  SNC_6_DS(i,:) = dim_avg_n(SNC_1,1)
  TEM_6_DS(i,:) = dim_avg_n(TEM_1,1)
end do

;print(SNC_6)
;print(TEM_6)

;***************读取观测**************
NET_obs_DS = new((/2,3,3,n_lat/),"double")
SNC_obs_DS = new((/2,3,3,n_lat/),"double")
TEM_obs_DS = new((/2,3,3,n_lat/),"double")

do m = 0,1
  do n = 0,2
    do k= 0,2

       f_NET := addfile(inpath_OBS_DS+"k4.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc","r")
       f_SNC := addfile(inpath_OBS_DS+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc","r")
       f_TEM := addfile(inpath_OBS_DS+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc","r")

       NET_4 := f_NET->k4(0,{45:75},:)
       SNC_4 := f_SNC->k1k2(0,{45:75},:)
       TEM_4 := f_TEM->k3(0,{45:75},:)
       ; printVarSummary(NET_4)

       NET_obs_DS(m,n,k,:) = dim_avg_n(NET_4,1)  ;纬向平均
       SNC_obs_DS(m,n,k,:) = dim_avg_n(SNC_4,1)
       TEM_obs_DS(m,n,k,:) = dim_avg_n(TEM_4,1)
    end do
  end do
end do


;****************读取ERA5-Land**************
NET_3_ERA5 = new((/3,n_lat,n_lon/),"double")
SNC_3_ERA5 = new((/3,n_lat,n_lon/),"double")
TEM_3_ERA5 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_ERA5_DS+"k4.ERA5-Land2.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5_DS+"k1k2.ERA5-Land2.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5_DS+"k3.ERA5-Land2.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_ERA5(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_ERA5(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_ERA5(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_ERA5,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_ERA5,0)
TEM_5   = dim_avg_n(TEM_3_ERA5,0)

NET_ERA5_DS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_ERA5_DS = dim_avg_n(SNC_5,1)
TEM_ERA5_DS = dim_avg_n(TEM_5,1)

;print(NET_obs)
;****************读取MERRA2**************
NET_3_MERRA2 = new((/3,n_lat,n_lon/),"double")
SNC_3_MERRA2 = new((/3,n_lat,n_lon/),"double")
TEM_3_MERRA2 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_MERRA2_DS+"k4.MERRA22.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_MERRA2_DS+"k1k2.MERRA22.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_MERRA2_DS+"k3.MERRA22.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_MERRA2(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_MERRA2(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_MERRA2(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_MERRA2,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_MERRA2,0)
TEM_5   = dim_avg_n(TEM_3_MERRA2,0)

NET_MERRA2_DS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_MERRA2_DS = dim_avg_n(SNC_5,1)
TEM_MERRA2_DS = dim_avg_n(TEM_5,1)

;****************读取JRA55**************
NET_3_JRA55 = new((/3,n_lat,n_lon/),"double")
SNC_3_JRA55 = new((/3,n_lat,n_lon/),"double")
TEM_3_JRA55 = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_JRA55_DS+"k4.JRA552.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA55_DS+"k1k2.JRA552.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA55_DS+"k3.JRA552.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_JRA55(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_JRA55(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_JRA55(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_JRA55,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_JRA55,0)
TEM_5   = dim_avg_n(TEM_3_JRA55,0)

NET_JRA55_DS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_JRA55_DS = dim_avg_n(SNC_5,1)
TEM_JRA55_DS = dim_avg_n(TEM_5,1)

;****************读取JRA3Q**************
NET_3_JRA3Q = new((/3,n_lat,n_lon/),"double")
SNC_3_JRA3Q = new((/3,n_lat,n_lon/),"double")
TEM_3_JRA3Q = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_JRA3Q_DS+"k4.JRA3Q2.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA3Q_DS+"k1k2.JRA3Q2.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA3Q_DS+"k3.JRA3Q2.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_JRA3Q(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_JRA3Q(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_JRA3Q(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_JRA3Q,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_JRA3Q,0)
TEM_5   = dim_avg_n(TEM_3_JRA3Q,0)

NET_JRA3Q_DS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_JRA3Q_DS = dim_avg_n(SNC_5,1)
TEM_JRA3Q_DS = dim_avg_n(TEM_5,1)

;****************读取ERA5snow**************
NET_3_ERA5snow = new((/3,n_lat,n_lon/),"double")
SNC_3_ERA5snow = new((/3,n_lat,n_lon/),"double")
TEM_3_ERA5snow = new((/3,n_lat,n_lon/),"double")

do j = 0,2
    files_NET := systemfunc("ls "+inpath_ERA5snow_DS+"k4.ERA5snow2.EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5snow_DS+"k1k2.ERA5snow2.EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5snow_DS+"k3.ERA5snow2.EASE_grid.nc")
    ; ;print(files_NET)

    f_NET := addfiles(files_NET,"r")
    f_SNC := addfiles(files_SNC,"r")
    f_TEM := addfiles(files_TEM,"r")

    NET_3_ERA5snow(j,:,:) = f_NET[:]->k4(0,{45:75},:)
    SNC_3_ERA5snow(j,:,:) = f_SNC[:]->k1k2(0,{45:75},:)
    TEM_3_ERA5snow(j,:,:) = f_TEM[:]->k3(0,{45:75},:)
end do

NET_5   = dim_avg_n(NET_3_ERA5snow,0)  ;月平均
SNC_5   = dim_avg_n(SNC_3_ERA5snow,0)
TEM_5   = dim_avg_n(TEM_3_ERA5snow,0)

NET_ERA5snow_DS = dim_avg_n(NET_5,1)  ;纬向平均
SNC_ERA5snow_DS = dim_avg_n(SNC_5,1)
TEM_ERA5snow_DS = dim_avg_n(TEM_5,1)

; printVarSummary(NET_ERA5snow_DS)
;*************每个纬度上，多模式的平均值和标准差************
;;cmip6
NET_stat41   = dim_stat4_n(NET_6_DS,0)
NET_avg_6_DS = NET_stat41(0,:)
NET_std_6_DS = sqrt(NET_stat41(1,:))

SNC_stat41   = dim_stat4_n(SNC_6_DS,0)
SNC_avg_6_DS = SNC_stat41(0,:)
SNC_std_6_DS = sqrt(SNC_stat41(1,:))

TEM_stat41   = dim_stat4_n(TEM_6_DS,0)
TEM_avg_6_DS = TEM_stat41(0,:)
TEM_std_6_DS = sqrt(TEM_stat41(1,:))

;*******************画散点图和平均值**********************
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

y6  = ispan(455,745,10)/10.0
; print(y6)

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

res@tmXBMinorOn = True
res@tmXBMinorPerMajor = 4

; res@trXReverse   = False
res@tmXTLabelsOn = False
res@tmYRLabelsOn = False

; res@tiXAxisString = "Feedback[%/K]"

res@tmYLLabelFontHeightF = 0.006    ;字号
res@tmYLLabelFontHeightF = 0.006
res@tiYAxisFontHeightF   = 0.009
res@tiXAxisFontHeightF   = 0.006

res@tiMainFontHeightF    = 0.009

; res@vpXF        = 0.07
; res@vpYF        = 0.47

res@vpWidthF    = 0.13
res@vpHeightF   = 0.13

res@tmYMajorGrid = True         ;打开刻度网格
res@tmYMajorGridLineColor  = "grey75"
res@tmYMajorGridThicknessF = 1

res@tmGridDrawOrder = "PreDraw"

;-------------------第一列--------------------
YMin_SS    = -3.
YMax_SS    = 0.7
YLStart_SS = -3.
YLEnd_SS   = 1.
YLSpace_SS = 0.5

YMin_DS    = -6.5
YMax_DS    = 4.
YLStart_DS = -6.
YLEnd_DS   = 4.
YLSpace_DS = 2.

res@tfPolyDrawOrder    = "PreDraw"

res@xyMarkLineMode = "Lines"
; res@xyMarkers     := 16
; res@xyMarkerSizeF  = 0.005
; res@xyMarkerColor  = color_cmip6
res@xyLineColor    = color_cmip6
res@xyLineThicknessF = 3.2       ;折线宽度

;*******seasonal*******
res@tiMainOn      = True
res@tiMainString  = "SAF~B~NET~N~ (%/K)"
res@tiYAxisString = "Seasonal"

res@trYMinF          = YMin_SS
res@trYMaxF          = YMax_SS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_SS
res@tmYLTickSpacingF = YLSpace_SS
res@tmYLTickEndF     = YLEnd_SS

plot1 = gsn_csm_xy (wks,y6,NET_avg_6_SS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = NET_avg_6_SS(k) + NET_std_6_SS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = NET_avg_6_SS(k) - NET_std_6_SS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum1 = gsn_add_polygon (wks,plot1,xp,yp,gsres)

;*******decadal*******
res@tiYAxisString = "Decadal"
res@tiMainOn      = False

res@trYMinF          = YMin_DS
res@trYMaxF          = YMax_DS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_DS
res@tmYLTickSpacingF = YLSpace_DS
res@tmYLTickEndF     = YLEnd_DS

plot4 = gsn_csm_xy (wks,y6,NET_avg_6_DS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = NET_avg_6_DS(k) + NET_std_6_DS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = NET_avg_6_DS(k) - NET_std_6_DS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum4 = gsn_add_polygon (wks,plot4,xp,yp,gsres)

; ;-------------------第二列--------------------
;*******seasonal*******
res@tiMainOn     = True
res@tiMainString  = "SAF~B~SNC~N~ (%/K)"
res@tiYAxisOn    = False

res@trYMinF          = YMin_SS
res@trYMaxF          = YMax_SS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_SS
res@tmYLTickSpacingF = YLSpace_SS
res@tmYLTickEndF     = YLEnd_SS

plot2 = gsn_csm_xy (wks,y6,SNC_avg_6_SS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = SNC_avg_6_SS(k) + SNC_std_6_SS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = SNC_avg_6_SS(k) - SNC_std_6_SS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum2 = gsn_add_polygon (wks,plot2,xp,yp,gsres)

;*******decadal*******
res@trYMinF          = YMin_DS
res@trYMaxF          = YMax_DS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_DS
res@tmYLTickSpacingF = YLSpace_DS
res@tmYLTickEndF     = YLEnd_DS

res@tiMainOn      = False

plot5 = gsn_csm_xy (wks,y6,SNC_avg_6_DS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = SNC_avg_6_DS(k) + SNC_std_6_DS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = SNC_avg_6_DS(k) - SNC_std_6_DS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum5 = gsn_add_polygon (wks,plot5,xp,yp,gsres)

; ;-------------------第三列--------------------
;*******seasonal*******
res@tiMainString  = "SAF~B~TEM~N~ (%/K)"
res@tiMainOn      = True

res@trYMinF          = YMin_SS
res@trYMaxF          = YMax_SS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_SS
res@tmYLTickSpacingF = YLSpace_SS
res@tmYLTickEndF     = YLEnd_SS

plot3 = gsn_csm_xy (wks,y6,TEM_avg_6_SS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = TEM_avg_6_SS(k) + TEM_std_6_SS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = TEM_avg_6_SS(k) - TEM_std_6_SS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum3 = gsn_add_polygon (wks,plot3,xp,yp,gsres)

;*******decadal*******
res@trYMinF          = YMin_DS
res@trYMaxF          = YMax_DS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_DS
res@tmYLTickSpacingF = YLSpace_DS
res@tmYLTickEndF     = YLEnd_DS

res@tiMainOn      = False

plot6 = gsn_csm_xy (wks,y6,TEM_avg_6_DS,res)

;添加阴影
xp = new( (/2*30/), double )
yp = new( (/2*30/), double )

do k = 0,29
  xp(k) = y6(k)
  yp(k) = TEM_avg_6_DS(k) + TEM_std_6_DS(k)

  xp(2*30-1-k) = y6(k)
  yp(2*30-1-k) = TEM_avg_6_DS(k) - TEM_std_6_DS(k)
end do

gsres                   = True                        ; poly res
gsres@gsFillColor       = colors_shadow            ; color chosen
; gsres@gsFillOpacityF    = 0.32
dum6 = gsn_add_polygon (wks,plot6,xp,yp,gsres)

;****************OBS****************
x_NET_SS_obs = dim_avg_n(NET_obs_SS,(/0,1/))
x_SNC_SS_obs = dim_avg_n(SNC_obs_SS,(/0,1/))
x_TEM_SS_obs = dim_avg_n(TEM_obs_SS,(/0,1/))

x_NET_DS_obs = dim_avg_n(NET_obs_DS,(/0,1/))
x_SNC_DS_obs = dim_avg_n(SNC_obs_DS,(/0,1/))
x_TEM_DS_obs = dim_avg_n(TEM_obs_DS,(/0,1/))

res@xyMarkLineMode = "Lines"

res@xyCurveDrawOrder = "PreDraw"
res@xyLineThicknessF = 1.6 ;折线宽度

res@xyLineColors    := (/color_APPx,color_clara_a2,color_clara_a3/)
res@xyDashPattern    = 0

plot1_obs = gsn_csm_xy (wks,y6+0.15,x_NET_SS_obs,res)
plot2_obs = gsn_csm_xy (wks,y6+0.15,x_SNC_SS_obs,res)
plot3_obs = gsn_csm_xy (wks,y6+0.15,x_TEM_SS_obs,res)

plot4_obs = gsn_csm_xy (wks,y6+0.15,x_NET_DS_obs,res)
plot5_obs = gsn_csm_xy (wks,y6+0.15,x_SNC_DS_obs,res)
plot6_obs = gsn_csm_xy (wks,y6+0.15,x_TEM_DS_obs,res)

overlay(plot1,plot1_obs)
overlay(plot2,plot2_obs)
overlay(plot3,plot3_obs)

overlay(plot4,plot4_obs)
overlay(plot5,plot5_obs)
overlay(plot6,plot6_obs)

;***************再分析*****************
x_NET_SS = new((/5,30/),double)
x_SNC_SS = new((/5,30/),double)
x_TEM_SS = new((/5,30/),double)
x_NET_DS = new((/5,30/),double)
x_SNC_DS = new((/5,30/),double)
x_TEM_DS = new((/5,30/),double)

x_NET_SS(0,:) = NET_ERA5_SS
x_NET_SS(1,:) = NET_ERA5snow_SS
x_NET_SS(2,:) = NET_JRA3Q_SS
x_NET_SS(3,:) = NET_JRA55_SS
x_NET_SS(4,:) = NET_MERRA2_SS

x_NET_DS(0,:) = NET_ERA5_DS
x_NET_DS(1,:) = NET_ERA5snow_DS
x_NET_DS(2,:) = NET_JRA3Q_DS
x_NET_DS(3,:) = NET_JRA55_DS
x_NET_DS(4,:) = NET_MERRA2_DS

x_SNC_SS(0,:) = SNC_ERA5_SS
x_SNC_SS(1,:) = SNC_ERA5snow_SS
x_SNC_SS(2,:) = SNC_JRA3Q_SS
x_SNC_SS(3,:) = SNC_JRA55_SS
x_SNC_SS(4,:) = SNC_MERRA2_SS

x_SNC_DS(0,:) = SNC_ERA5_DS
x_SNC_DS(1,:) = SNC_ERA5snow_DS
x_SNC_DS(2,:) = SNC_JRA3Q_DS
x_SNC_DS(3,:) = SNC_JRA55_DS
x_SNC_DS(4,:) = SNC_MERRA2_DS

x_TEM_SS(0,:) = TEM_ERA5_SS
x_TEM_SS(1,:) = TEM_ERA5snow_SS
x_TEM_SS(2,:) = TEM_JRA3Q_SS
x_TEM_SS(3,:) = TEM_JRA55_SS
x_TEM_SS(4,:) = TEM_MERRA2_SS

x_TEM_DS(0,:) = TEM_ERA5_DS
x_TEM_DS(1,:) = TEM_ERA5snow_DS
x_TEM_DS(2,:) = TEM_JRA3Q_DS
x_TEM_DS(3,:) = TEM_JRA55_DS
x_TEM_DS(4,:) = TEM_MERRA2_DS

res@xyDashPattern    = 14
res@xyLineColors  := (/color_ERA5,color_ERA5snow,color_JRA3Q,color_JRA55,color_MERRA2/)

plot1_rea = gsn_csm_xy (wks,y6,x_NET_SS,res)
plot2_rea = gsn_csm_xy (wks,y6,x_SNC_SS,res)
plot3_rea = gsn_csm_xy (wks,y6,x_TEM_SS,res)

plot4_rea = gsn_csm_xy (wks,y6,x_NET_DS,res)
plot5_rea = gsn_csm_xy (wks,y6,x_SNC_DS,res)
plot6_rea = gsn_csm_xy (wks,y6,x_TEM_DS,res)

overlay(plot1,plot1_rea)
overlay(plot2,plot2_rea)
overlay(plot3,plot3_rea)

overlay(plot4,plot4_rea)
overlay(plot5,plot5_rea)
overlay(plot6,plot6_rea)

;***************观测、再分析平均*****************
;;;reanalysis avg
res@xyCurveDrawOrder = "PostDraw"

res@xyLineColors    := color_rea_avg
res@xyDashPattern    = 0
res@xyLineThicknessF = 3.2       ;折线宽度

x_NET_SS_avg := dim_avg_n(x_NET_SS,0)
x_SNC_SS_avg := dim_avg_n(x_SNC_SS,0)
x_TEM_SS_avg := dim_avg_n(x_TEM_SS,0)

x_NET_DS_avg := dim_avg_n(x_NET_DS,0)
x_SNC_DS_avg := dim_avg_n(x_SNC_DS,0)
x_TEM_DS_avg := dim_avg_n(x_TEM_DS,0)

plot1_rea1 = gsn_csm_xy (wks,y6,x_NET_SS_avg,res)
plot2_rea1 = gsn_csm_xy (wks,y6,x_SNC_SS_avg,res)
plot3_rea1 = gsn_csm_xy (wks,y6,x_TEM_SS_avg,res)

plot4_rea1 = gsn_csm_xy (wks,y6,x_NET_DS_avg,res)
plot5_rea1 = gsn_csm_xy (wks,y6,x_SNC_DS_avg,res)
plot6_rea1 = gsn_csm_xy (wks,y6,x_TEM_DS_avg,res)

overlay(plot1,plot1_rea1)
overlay(plot2,plot2_rea1)
overlay(plot3,plot3_rea1)

overlay(plot4,plot4_rea1)
overlay(plot5,plot5_rea1)
overlay(plot6,plot6_rea1)

;;;obs avg
res@xyLineColors    := color_obs_avg

x_NET_SS_obs_avg = dim_avg_n(x_NET_SS_obs(0:2,:),0)
x_SNC_SS_obs_avg = dim_avg_n(x_SNC_SS_obs(0:2,:),0)
x_TEM_SS_obs_avg = dim_avg_n(x_TEM_SS_obs(0:2,:),0)

x_NET_DS_obs_avg = dim_avg_n(x_NET_DS_obs(0:2,:),0)
x_SNC_DS_obs_avg = dim_avg_n(x_SNC_DS_obs(0:2,:),0)
x_TEM_DS_obs_avg = dim_avg_n(x_TEM_DS_obs(0:2,:),0)
print(x_NET_DS_obs_avg)
print(y6)
plot1_obs_avg = gsn_csm_xy (wks,y6+0.15,x_NET_SS_obs_avg,res)
plot2_obs_avg = gsn_csm_xy (wks,y6+0.15,x_SNC_SS_obs_avg,res)
plot3_obs_avg = gsn_csm_xy (wks,y6+0.15,x_TEM_SS_obs_avg,res)

plot4_obs_avg = gsn_csm_xy (wks,y6+0.15,x_NET_DS_obs_avg,res)
plot5_obs_avg = gsn_csm_xy (wks,y6+0.15,x_SNC_DS_obs_avg,res)
plot6_obs_avg = gsn_csm_xy (wks,y6+0.15,x_TEM_DS_obs_avg,res)

overlay(plot1,plot1_obs_avg)
overlay(plot2,plot2_obs_avg)
overlay(plot3,plot3_obs_avg)

overlay(plot4,plot4_obs_avg)
overlay(plot5,plot5_obs_avg)
overlay(plot6,plot6_obs_avg)

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
thick(8:10) = 5.5

xpos  := new(dimsizes(colors),float)
xp    := fspan(0.12,0.8,5)
xpos(0:2)  = xp(0:2)
xpos(3:7)  = xp
xpos(8:9)  = xp(0:1)
xpos(10)   = xp(2)+0.05

ypos  := new(dimsizes(colors),float)
ypos(0:2)  = 0.11
ypos(3:7)  = 0.08
ypos(8:10) = 0.05

res_text               = True
res_text@txFontHeightF = 0.014
res_text@txJust        = "CenterLeft"

res_lines                   = True        ; polyline mods desired

do i = 0,10
  res_lines@gsLineColor       = colors(i)   ; line color
  res_lines@gsLineDashPattern = dash(i)   ; dash pattern
  res_lines@gsLineThicknessF  = thick(i)           ; line thicker

  gsn_polyline_ndc(wks,(/xpos(i),xpos(i)+0.04/),(/ypos(i),ypos(i)/),res_lines)
  gsn_text_ndc(wks,labels(i),xpos(i)+0.043,ypos(i),res_text)
end do

; ;**********************************************************
pres = True
; pres@txString = "albedo("+ymStrt+"-"+ymLast+")"
; pres@gsnPanelMainFontHeightF     = 0.015
 pres@gsnPanelXWhiteSpacePercent  = 0.7       ;留白
; pres@gsnPanelYWhiteSpacePercent  = 0.2
;
; pres@gsnPanelXF = (/0.2,0.5,0.7,0.1,0.4,0.7/)
; pres@gsnPanelYF = (/0.9,0.9,0.9,0.4,0.4,0.4/)
pres@gsnPanelFigureStrings        = (/"(a)","(b)","(c)","(d)","(e)","(f)"/)
pres@gsnPanelFigureStringsJust    = "TopLeft"
pres@gsnPanelFigureStringsPerimOn = False
pres@gsnPanelFigureStringsFontHeightF = 0.012

YF = fspan(0.73,0.42,2)
pres@gsnPanelYF = (/YF(0),YF(0),YF(0),\
                    YF(1),YF(1),YF(1)/)

; XF = fspan(0.09,0.66,3)
; pres@gsnPanelXF = (/XF(0),XF(1),XF(2),\
;                     XF(0),XF(1),XF(2)/)


; overlay(plot1,plot11)
; overlay(plot2,plot22)
; overlay(plot3,plot33)
;
; overlay(plot4,plot44)
; overlay(plot5,plot55)
; overlay(plot6,plot66)

gsn_panel(wks,(/plot1,plot2,plot3,plot4,plot5,plot6/),(/2,3/),pres)
; gsn_panel(wks,(/plot1/),(/2,3/),pres)

; psres = True
; maximize_output(wks,psres)  ; calls draw and frame for you

end
