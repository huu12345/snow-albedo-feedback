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
outpath = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/spatial/"

M=(/"AM_0.25_misstoc/","MA_0.25_misstoc/","MJ_0.25_misstoc/"/)

wks = gsn_open_wks("pdf",outpath+"Figure_S7")
; gsn_define_colormap(wks,"rainbow")

n_model6 = dimsizes(model6)

print(n_model6)

n_lat6 = 45
n_lon6 = 360

dtas_36 = new((/3,n_lat6,n_lon6/),"double")
SNC_36 = dtas_36
TEM_36 = dtas_36

dtas_6 = new((/n_model6,n_lat6,n_lon6/),"double")
SNC_6 = dtas_6
TEM_6 = dtas_6

;---------------seasonal--------------------
;---------------cmip6模式-------------
do i = 0,n_model6-1
  m6 := model6(i)
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_model_SS+M(j)+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_model_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_model_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = todouble(dtas)    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

  dtas_6(i,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
  SNC_6(i,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
  TEM_6(i,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon
end do

;;;CMIP6平均值
dtas_model_SS  = dim_avg_n(dtas_6,0)    ;144*25
SNC_model_SS  = dim_avg_n(SNC_6,0)    ;144*25
TEM_model_SS  = dim_avg_n(TEM_6,0)    ;144*25

; dtas_model_SS_std  = dim_stddev_n(dtas_6,0)    ;144*25
; SNC_model_SS_std  = dim_stddev_n(SNC_6,0)    ;144*25
; TEM_model_SS_std  = dim_stddev_n(TEM_6,0)    ;144*25

dtas_model_SS!0     = "lat"
dtas_model_SS&lat   = dtas&lat
dtas_model_SS!1     = "lon"
dtas_model_SS&lon   = dtas&lon
copy_VarCoords(dtas_model_SS,SNC_model_SS)
copy_VarCoords(dtas_model_SS,TEM_model_SS)

; copy_VarCoords(dtas_model_SS,dtas_model_SS)
; copy_VarCoords(dtas_model_SS,SNC_model_SS)
; copy_VarCoords(dtas_model_SS,TEM_model_SS)
; copy_VarCoords(dtas_model_SS,dtas_model_SS)

;---------------观测-------------
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3","GLASS"/)

dtas_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
SNC_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
TEM_obs = new((/2,3,4,n_lat6,n_lon6/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;snc
    do k= 0,3  ;alb

       do j = 0,2
          files_dtas := systemfunc("ls "+inpath_OBS_SS+M(j)+"delta_tas.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_SNC := systemfunc("ls "+inpath_OBS_SS+M(j)+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_TEM := systemfunc("ls "+inpath_OBS_SS+M(j)+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")

          f_dtas   = addfiles(files_dtas,"r")
          f_SNC   = addfiles(files_SNC,"r")
          f_TEM   = addfiles(files_TEM,"r")

          dtas_36(j,:,:) = f_dtas[:]->tas(0,:,:)
          SNC_36(j,:,:) = f_SNC[:]->k1k2(0,:,:)
          TEM_36(j,:,:) = f_TEM[:]->k3(0,:,:)
       end do

       dtas_obs(m,n,k,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
       SNC_obs(m,n,k,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
       TEM_obs(m,n,k,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

    end do
  end do
end do

dtas_obs_SS = dim_avg_n(dtas_obs,(/0,1,2/))
SNC_obs_SS = dim_avg_n(SNC_obs,(/0,1,2/))
TEM_obs_SS = dim_avg_n(TEM_obs,(/0,1,2/))

copy_VarCoords(dtas_model_SS,dtas_obs_SS)
copy_VarCoords(dtas_model_SS,SNC_obs_SS)
copy_VarCoords(dtas_model_SS,TEM_obs_SS)

;---------------ERA5-Land-------------
dtas_rea = new((/5,n_lat6,n_lon6/),"double")
SNC_rea = new((/5,n_lat6,n_lon6/),"double")
TEM_rea = new((/5,n_lat6,n_lon6/),"double")

m6 := "ERA5-Land2"
do j = 0,2
  files_dtas := systemfunc("ls "+inpath_ERA5_SS+M(j)+"delta_tas."+m6+".EASE_grid.nc")
  files_SNC := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
  files_TEM := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k3."+m6+".EASE_grid.nc")

  f_dtas   = addfiles(files_dtas,"r")
  f_SNC   = addfiles(files_SNC,"r")
  f_TEM   = addfiles(files_TEM,"r")

  dtas     = f_dtas[:]->tas(0,:,:)
  SNC     = f_SNC[:]->k1k2(0,:,:)
  TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
  dtas_36(j,:,:) = dtas    ;3*1*144*25
  SNC_36(j,:,:) = SNC
  TEM_36(j,:,:) = TEM
end do

dtas_rea(0,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(0,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(0,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

;---------------MERRA2-------------
  m6 := "MERRA22"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(1,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(1,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(1,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

;---------------JRA55-------------
  m6 := "JRA552"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_JRA55_SS+M(j)+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(2,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(2,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(2,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

;---------------JRA3Q-------------
  m6 := "JRA3Q2"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(3,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(3,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(3,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

;---------------ERA5snow-------------
  m6 := "ERA5snow2"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(4,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(4,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(4,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

dtas_rea_SS = dim_avg_n(dtas_rea,0)
SNC_rea_SS = dim_avg_n(SNC_rea,0)
TEM_rea_SS = dim_avg_n(TEM_rea,0)

copy_VarCoords(dtas_model_SS,dtas_rea_SS)
copy_VarCoords(dtas_model_SS,SNC_rea_SS)
copy_VarCoords(dtas_model_SS,TEM_rea_SS)

;--------------decadal---------------------
;---------------cmip6模式-------------
do i = 0,n_model6-1
    m6 := model6(i)
    files_dtas := systemfunc("ls "+inpath_model_DS+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_model_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_model_DS+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_6(i,:,:) = todouble(dtas)    ;3*1*144*25
    SNC_6(i,:,:) = SNC
    TEM_6(i,:,:) = TEM
end do

;;;CMIP6平均值
dtas_model_DS  = dim_avg_n(dtas_6,0)    ;144*25
SNC_model_DS  = dim_avg_n(SNC_6,0)    ;144*25
TEM_model_DS  = dim_avg_n(TEM_6,0)    ;144*25

copy_VarCoords(dtas_model_SS,dtas_model_DS)
copy_VarCoords(dtas_model_SS,SNC_model_DS)
copy_VarCoords(dtas_model_SS,TEM_model_DS)

;---------------观测-------------
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3","GLASS"/)

dtas_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
SNC_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
TEM_obs = new((/2,3,4,n_lat6,n_lon6/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;snc
    do k= 0,3  ;alb

       do j = 0,2
          files_dtas := systemfunc("ls "+inpath_OBS_DS+"delta_tas.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_SNC := systemfunc("ls "+inpath_OBS_DS+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_TEM := systemfunc("ls "+inpath_OBS_DS+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")

          f_dtas   = addfiles(files_dtas,"r")
          f_SNC   = addfiles(files_SNC,"r")
          f_TEM   = addfiles(files_TEM,"r")

          dtas_36(j,:,:) = f_dtas[:]->tas(0,:,:)
          SNC_36(j,:,:) = f_SNC[:]->k1k2(0,:,:)
          TEM_36(j,:,:) = f_TEM[:]->k3(0,:,:)
       end do

       dtas_obs(m,n,k,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
       SNC_obs(m,n,k,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
       TEM_obs(m,n,k,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

    end do
  end do
end do

dtas_obs_DS = dim_avg_n(dtas_obs,(/0,1,2/))
SNC_obs_DS = dim_avg_n(SNC_obs,(/0,1,2/))
TEM_obs_DS = dim_avg_n(TEM_obs,(/0,1,2/))

copy_VarCoords(dtas_model_SS,dtas_obs_DS)
copy_VarCoords(dtas_model_SS,SNC_obs_DS)
copy_VarCoords(dtas_model_SS,TEM_obs_DS)


;---------------ERA5-Land-------------
dtas_rea = new((/5,n_lat6,n_lon6/),"double")
SNC_rea = new((/5,n_lat6,n_lon6/),"double")
TEM_rea = new((/5,n_lat6,n_lon6/),"double")

  m6 := "ERA5-Land2"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_ERA5_DS+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5_DS+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(0,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(0,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(0,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

;---------------MERRA2-------------
  m6 := "MERRA22"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_MERRA2_DS+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_MERRA2_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_MERRA2_DS+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(1,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(1,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(1,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

;---------------JRA55-------------
  m6 := "JRA552"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_JRA55_DS+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA55_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA55_DS+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(2,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(2,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(2,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

;---------------JRA3Q-------------
  m6 := "JRA3Q2"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_JRA3Q_DS+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA3Q_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA3Q_DS+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(3,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(3,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(3,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

;---------------ERA5snow-------------
  m6 := "ERA5snow2"
  do j = 0,2
    files_dtas := systemfunc("ls "+inpath_ERA5snow_DS+"delta_tas."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5snow_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5snow_DS+"k3."+m6+".EASE_grid.nc")

    f_dtas   = addfiles(files_dtas,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    dtas     = f_dtas[:]->tas(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(dtas)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    dtas_36(j,:,:) = dtas    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

dtas_rea(4,:,:) = dim_avg_n(dtas_36,0)      ;27,n_lat,n_lon
SNC_rea(4,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_rea(4,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

dtas_rea_DS = dim_avg_n(dtas_rea,0)      ;27,n_lat,n_lon
SNC_rea_DS = dim_avg_n(SNC_rea,0)      ;27,n_lat,n_lon
TEM_rea_DS = dim_avg_n(TEM_rea,0)      ;27,n_lat,n_lon

copy_VarCoords(dtas_model_SS,dtas_rea_DS)
copy_VarCoords(dtas_model_SS,SNC_rea_DS)
copy_VarCoords(dtas_model_SS,TEM_rea_DS)

;-----------------------------------
;--------------画图------------
res=True
res@gsnDraw        = False
res@gsnFrame       = False
res@cnFillOn       = True
res@cnLinesOn      = False

; res@vpWidthF     = 0.2
; res@vpHeightF    = 0.2
; res@mpShapeMode  = "FreeAspect"

res@gsnPolar       = "NH"
res@mpMinLatF      = 45
res@mpGeophysicalLineThicknessF = 0.6
res@mpLandFillColor = 0
;res@mpGridLineDashPattern = 5
res@mpGridLineThicknessF = 0.005
res@mpGridLineColor = "grey35"
;res@mpGridMaskMode = "MaskLand"

res@gsnPolarLabelFontHeightF = 0.025

;res@gsnCenterStringFontHeightF = 0.005
;res@gsnCenterStringOrthogonalPosF = 0.05

res@gsnLeftString = ""

colors = (/"MPL_OrRd","cmp_b2r","cmocean_haline"/)
; res@cnFillPalette = "GMT_hot"

min_1   = 2.0
max_1   = 12.0
space_1 = 2.

min_2   = -2.0
max_2   = 2.0
space_2 = 0.5

res@lbLabelBarOn   = False
res@lbLabelFontHeightF   = 0.034

res@tiYAxisFontHeightF = 0.057
res@tiYAxisOffsetXF    = -0.03

res@tiMainFontHeightF = 0.057
res@tiMainOffsetYF    = 0.008
res@tiMainFont        = 22

res@gsnLeftStringFontHeightF = 0.041
res@gsnLeftStringOrthogonalPosF = -0.02

;************obs*************
res@cnFillPalette   = colors(0)

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_1		; set the minimum contour level
res@cnMaxLevelValF  = max_1			; set the maximum contour level
res@cnLevelSpacingF = space_1
;res@gsnCenterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"

res@tiYAxisString   = "OBS"

res@tiMainString= "Seasonal"
res@gsnLeftString   = "(a)"
plot_dtas_obs_SS = gsn_csm_contour_map_polar(wks,dtas_obs_SS,res)

res@cnFillPalette   = colors(1)
res@tiYAxisOn       = False
res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_2		; set the minimum contour level
res@cnMaxLevelValF  = max_2			; set the maximum contour level
res@cnLevelSpacingF = space_2
;res@gsnCenterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"
res@tiMainString= "Decadal"
res@gsnLeftString   = "(b)"
plot_dtas_obs_DS = gsn_csm_contour_map_polar(wks,dtas_obs_DS,res)

; res@tiYAxisOn       = False
; res@tiMainString= " SNC"
; plot_SNC_obs_SS = gsn_csm_contour_map_polar(wks,SNC_obs_SS,res)
; plot_SNC_obs_DS = gsn_csm_contour_map_polar(wks,SNC_obs_DS,res)
;
; res@tiMainString= "TEM"
; plot_TEM_obs_SS = gsn_csm_contour_map_polar(wks,TEM_obs_SS,res)
; plot_TEM_obs_DS = gsn_csm_contour_map_polar(wks,TEM_obs_DS,res)

res@tiMainOn        = False

;************reanalysis*************
res@tiYAxisOn       = True
res@tiYAxisString   = "Reanalysis"

res@cnFillPalette   = colors(0)

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_1		; set the minimum contour level
res@cnMaxLevelValF  = max_1			; set the maximum contour level
res@cnLevelSpacingF = space_1

res@gsnLeftString   = "(c)"
plot_dtas_rea_SS = gsn_csm_contour_map_polar(wks,dtas_rea_SS,res)

res@cnFillPalette   = colors(1)
res@tiYAxisOn       = False
res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_2		; set the minimum contour level
res@cnMaxLevelValF  = max_2			; set the maximum contour level
res@cnLevelSpacingF = space_2

res@gsnLeftString   = "(d)"
plot_dtas_rea_DS = gsn_csm_contour_map_polar(wks,dtas_rea_DS,res)


;************model*************
res@lbLabelBarOn    = True

res@tiYAxisOn       = True
res@tiYAxisString   = "CMIP6"

res@cnFillPalette   = colors(0)

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_1		; set the minimum contour level
res@cnMaxLevelValF  = max_1			; set the maximum contour level
res@cnLevelSpacingF = space_1

res@gsnLeftString   = "(e)"
plot_dtas_model_SS = gsn_csm_contour_map_polar(wks,dtas_model_SS,res)

res@cnFillPalette   = colors(1)
res@tiYAxisOn       = False
res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_2		; set the minimum contour level
res@cnMaxLevelValF  = max_2			; set the maximum contour level
res@cnLevelSpacingF = space_2

res@gsnLeftString   = "(f)"
plot_dtas_model_DS = gsn_csm_contour_map_polar(wks,dtas_model_DS,res)

; res@tiYAxisOn       = False
; plot_SNC_model_SS = gsn_csm_contour_map_polar(wks,SNC_model_SS,res)
; plot_SNC_model_DS = gsn_csm_contour_map_polar(wks,SNC_model_DS,res)
;
; plot_TEM_model_SS = gsn_csm_contour_map_polar(wks,TEM_model_SS,res)
; plot_TEM_model_DS = gsn_csm_contour_map_polar(wks,TEM_model_DS,res)

;-------------------------------------
;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
;pres@gsnMaximize   = True
; pres@gsnPanelXWhiteSpacePercent = 2
pres@gsnPanelYWhiteSpacePercent = 2

pres@gsnPanelLabelBar = False
pres@lbLabelFontHeightF   = 0.016
; pres@gsnPanelBottom = -0.01

; XF = fspan(0.15,0.79,3)-0.06
; pres@gsnPanelXF = (/XF(0),XF(1),XF(2),\
;                     XF(0),XF(1),XF(2),\
;                     XF(0),XF(1),XF(2)/)
;
YF = fspan(0.73,0.16,3)+0.15
pres@gsnPanelYF = (/YF(0),YF(0),\
                    YF(1),YF(1),\
                    YF(2),YF(2)/)

gsn_panel(wks,(/plot_dtas_obs_SS,   plot_dtas_obs_DS,  \
                plot_dtas_rea_SS,   plot_dtas_rea_DS,  \
                plot_dtas_model_SS, plot_dtas_model_DS /),(/3,2/),pres)

; gsn_panel(wks,(/plot_dtas_obs_SS,   plot_SNC_obs_SS,   plot_TEM_obs_SS, \
;                 plot_dtas_rea_SS,   plot_SNC_rea_SS,   plot_TEM_rea_SS, \
;                 plot_dtas_model_SS, plot_SNC_model_SS, plot_TEM_model_SS/),(/3,3/),pres)
;
; gsn_panel(wks,(/plot_dtas_obs_DS,   plot_SNC_obs_DS,   plot_TEM_obs_DS, \
;                 plot_dtas_rea_DS,   plot_SNC_rea_DS,   plot_TEM_rea_DS, \
;                 plot_dtas_model_DS, plot_SNC_model_DS, plot_TEM_model_DS/),(/3,3/),pres)

end
