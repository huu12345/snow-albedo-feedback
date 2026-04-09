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

wks = gsn_open_wks("pdf",outpath+"Figure_11")
; gsn_define_colormap(wks,"rainbow")

n_model6 = dimsizes(model6)

print(n_model6)

n_lat6 = 45
n_lon6 = 360

k1_36 = new((/3,n_lat6,n_lon6/),"double")
k2_36 = k1_36
k5_36 = k1_36

k1_6 = new((/n_model6,n_lat6,n_lon6/),"double")
k2_6 = k1_6
k5_6 = k1_6

;---------------seasonal--------------------
;---------------cmip6模式-------------
do i = 0,n_model6-1
  m6 := model6(i)
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_model_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_model_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_model_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = todouble(k1)    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

  k1_6(i,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
  k2_6(i,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
  k5_6(i,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon
end do

;;;CMIP6平均值
k1_model_SS  = dim_avg_n(k1_6,0)    ;144*25
k2_model_SS  = dim_avg_n(k2_6,0)    ;144*25
k5_model_SS  = dim_avg_n(k5_6,0)    ;144*25

k1_model_SS!0     = "lat"
k1_model_SS&lat   = k1&lat
k1_model_SS!1     = "lon"
k1_model_SS&lon   = k1&lon
copy_VarCoords(k1_model_SS,k2_model_SS)
copy_VarCoords(k1_model_SS,k5_model_SS)

;---------------观测-------------
nm_tas = (/"CRU","GHCN"/)
nm_k2 = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3"/)

k1_obs = new((/2,3,3,n_lat6,n_lon6/),"double")
k2_obs = new((/2,3,3,n_lat6,n_lon6/),"double")
k5_obs = new((/2,3,3,n_lat6,n_lon6/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;k2
    do k= 0,2  ;alb

       do j = 0,2
          files_k1 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k1.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_k2 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k2.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_k5 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k5.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")

          f_k1   = addfiles(files_k1,"r")
          f_k2   = addfiles(files_k2,"r")
          f_k5   = addfiles(files_k5,"r")

          k1_36(j,:,:) = f_k1[:]->k1(0,:,:)
          k2_36(j,:,:) = f_k2[:]->k2(0,:,:)
          k5_36(j,:,:) = f_k5[:]->k5(0,:,:)
       end do

       k1_obs(m,n,k,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
       k2_obs(m,n,k,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
       k5_obs(m,n,k,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

    end do
  end do
end do

k1_obs_SS = dim_avg_n(k1_obs,(/0,1,2/))
k2_obs_SS = dim_avg_n(k2_obs,(/0,1,2/))
k5_obs_SS = dim_avg_n(k5_obs,(/0,1,2/))

copy_VarCoords(k1_model_SS,k1_obs_SS)
copy_VarCoords(k1_model_SS,k2_obs_SS)
copy_VarCoords(k1_model_SS,k5_obs_SS)

;---------------ERA5-Land-------------
k1_rea = new((/5,n_lat6,n_lon6/),"double")
k2_rea = new((/5,n_lat6,n_lon6/),"double")
k5_rea = new((/5,n_lat6,n_lon6/),"double")

  m6 := "ERA5-Land2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(0,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(0,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(0,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

;---------------MERRA2-------------
  m6 := "MERRA22"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(1,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(1,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(1,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

;---------------JRA55-------------
  m6 := "JRA552"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(2,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(2,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(2,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

;---------------JRA3Q-------------
  m6 := "JRA3Q2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(3,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(3,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(3,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

;---------------ERA5snow-------------
  m6 := "ERA5snow2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(4,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(4,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(4,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

k1_rea_SS = dim_avg_n(k1_rea,0)      ;27,n_lat,n_lon
k2_rea_SS = dim_avg_n(k2_rea,0)      ;27,n_lat,n_lon
k5_rea_SS = dim_avg_n(k5_rea,0)      ;27,n_lat,n_lon

copy_VarCoords(k1_model_SS,k1_rea_SS)
copy_VarCoords(k1_model_SS,k2_rea_SS)
copy_VarCoords(k1_model_SS,k5_rea_SS)

;--------------decadal---------------------
;---------------cmip6模式-------------
do i = 0,n_model6-1
    m6 := model6(i)
    files_k1 := systemfunc("ls "+inpath_model_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_model_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_model_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_6(i,:,:) = todouble(k1)    ;3*1*144*25
    k2_6(i,:,:) = k2
    k5_6(i,:,:) = k5
end do

;;;CMIP6平均值
k1_model_DS  = dim_avg_n(k1_6,0)    ;144*25
k2_model_DS  = dim_avg_n(k2_6,0)    ;144*25
k5_model_DS  = dim_avg_n(k5_6,0)    ;144*25

copy_VarCoords(k1_model_SS,k1_model_DS)
copy_VarCoords(k1_model_SS,k2_model_DS)
copy_VarCoords(k1_model_SS,k5_model_DS)

;---------------观测-------------
k1_obs = new((/2,3,3,n_lat6,n_lon6/),"double")
k2_obs = new((/2,3,3,n_lat6,n_lon6/),"double")
k5_obs = new((/2,3,3,n_lat6,n_lon6/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;k2
    do k= 0,2  ;alb

       do j = 0,2
          files_k1 := systemfunc("ls "+inpath_OBS_DS+"k1.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_k2 := systemfunc("ls "+inpath_OBS_DS+"k2.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_k5 := systemfunc("ls "+inpath_OBS_DS+"k5.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")

          f_k1   = addfiles(files_k1,"r")
          f_k2   = addfiles(files_k2,"r")
          f_k5   = addfiles(files_k5,"r")

          k1_36(j,:,:) = f_k1[:]->k1(0,:,:)
          k2_36(j,:,:) = f_k2[:]->k2(0,:,:)
          k5_36(j,:,:) = f_k5[:]->k5(0,:,:)
       end do

       k1_obs(m,n,k,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
       k2_obs(m,n,k,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
       k5_obs(m,n,k,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

    end do
  end do
end do

k1_obs_DS = dim_avg_n(k1_obs,(/0,1,2/))
k2_obs_DS = dim_avg_n(k2_obs,(/0,1,2/))
k5_obs_DS = dim_avg_n(k5_obs,(/0,1,2/))

copy_VarCoords(k1_model_SS,k1_obs_DS)
copy_VarCoords(k1_model_SS,k2_obs_DS)
copy_VarCoords(k1_model_SS,k5_obs_DS)

;---------------ERA5-Land-------------
k1_rea = new((/5,n_lat6,n_lon6/),"double")
k2_rea = new((/5,n_lat6,n_lon6/),"double")
k5_rea = new((/5,n_lat6,n_lon6/),"double")

  m6 := "ERA5-Land2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(0,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(0,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(0,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

;---------------MERRA2-------------
  m6 := "MERRA22"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_MERRA2_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_MERRA2_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_MERRA2_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(1,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(1,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(1,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

;---------------JRA55-------------
  m6 := "JRA552"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA55_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA55_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA55_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(2,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(2,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(2,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

;---------------JRA3Q-------------
  m6 := "JRA3Q2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA3Q_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA3Q_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA3Q_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(3,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(3,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(3,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

;---------------ERA5snow-------------
  m6 := "ERA5snow2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5snow_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5snow_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5snow_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_rea(4,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_rea(4,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_rea(4,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

k1_rea_DS = dim_avg_n(k1_rea,0)      ;27,n_lat,n_lon
k2_rea_DS = dim_avg_n(k2_rea,0)      ;27,n_lat,n_lon
k5_rea_DS = dim_avg_n(k5_rea,0)      ;27,n_lat,n_lon

copy_VarCoords(k1_model_SS,k1_rea_DS)
copy_VarCoords(k1_model_SS,k2_rea_DS)
copy_VarCoords(k1_model_SS,k5_rea_DS)

;-----------------------------------
;--------------画图------------
res=True
res@gsnDraw        = False
res@gsnFrame       = False
res@cnFillOn       = True
res@cnLinesOn      = False

; res@vpWidthF     = 0.1
; res@vpHeightF    = 0.1
; res@mpShapeMode  = "FreeAspect"

res@gsnPolar       = "NH"
res@mpMinLatF      = 45
res@mpGeophysicalLineThicknessF = 0.6
res@mpLandFillColor = 0
;res@mpGridLineDashPattern = 5
res@mpGridLineThicknessF = 0.005
res@mpGridLineColor = "grey35"
;res@mpGridMaskMode = "MaskLand"

res@gsnPolarLabelFontHeightF = 0.022

min_1   = -6.
max_1   = 6.
space_1 = 1.

min_2   = 0.0
max_2   = 40.0
space_2 = 5.0

min_3   = -3.
max_3   = 3.
space_3 = 0.5

res@lbLabelBarOn   = False
res@lbLabelFontHeightF   = 0.035

res@tiYAxisFontHeightF = 0.057
res@tiYAxisOffsetXF    = -0.03

res@tiMainFontHeightF = 0.057
res@tiMainOffsetYF    = 0.008
res@tiMainFont        = 22

res@gsnLeftStringFontHeightF = 0.041
res@gsnLeftStringOrthogonalPosF = -0.02

;************Albedo Contrast*************
res@cnFillPalette   = "BlueWhiteOrangeRed"
res@lbLabelStride   = 2

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_3		; set the minimum contour level
res@cnMaxLevelValF  = max_3			; set the maximum contour level
res@cnLevelSpacingF = space_3
;res@gk2enterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"

; res@tiMainString = "~F33~D~F~S~B~C~N~/<~F33~D~F~T~B~S~N~>"
res@tiMainString = "Seasonal"

res@tiYAxisString   = "OBS"
res@gsnLeftString   = "(a)"
plot_k5_obs_SS = gsn_csm_contour_map_polar(wks,k5_obs_SS,res)

res@tiYAxisOn      = False
res@tiMainString = "Decadal"
res@gsnLeftString   = "(b)"
plot_k5_obs_DS = gsn_csm_contour_map_polar(wks,k5_obs_DS,res)

res@tiYAxisOn      = True
res@tiMainOn        = False
res@tiYAxisString   = "Reanalysis"
res@gsnLeftString   = "(c)"
plot_k5_rea_SS = gsn_csm_contour_map_polar(wks,k5_rea_SS,res)

res@tiYAxisOn      = False
res@gsnLeftString   = "(d)"
plot_k5_rea_DS = gsn_csm_contour_map_polar(wks,k5_rea_DS,res)

res@tiYAxisOn      = True
; res@lbLabelBarOn    = True
res@tiYAxisString   = "CMIP6"
res@gsnLeftString   = "(e)"
plot_k5_model_SS = gsn_csm_contour_map_polar(wks,k5_model_SS,res)

res@tiYAxisOn      = False
res@gsnLeftString   = "(f)"
plot_k5_model_DS = gsn_csm_contour_map_polar(wks,k5_model_DS,res)

res@lbLabelBarOn   = False
res@tiYAxisOn      = False

; ;************alpha snow *************
; cmap = read_colormap_file("cmocean_deep")
; reversed_cmap = cmap(::-1, :); 反转行的顺序
;
; res@cnFillPalette  := reversed_cmap
; res@lbLabelStride   = 2
;
; res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
; res@cnMinLevelValF  = min_2		; set the minimum contour level
; res@cnMaxLevelValF  = max_2			; set the maximum contour level
; res@cnLevelSpacingF = space_2
;
; res@tiMainOn        = True
; res@tiMainString     = "~F33~a~F~~B~snow~N~~H-60V6F35~EEEEE~FV-6H3~"
; res@gsnLeftString   = "(b)"
; plot_k2_obs_SS = gsn_csm_contour_map_polar(wks,k2_obs_SS,res)
; plot_k2_obs_DS = gsn_csm_contour_map_polar(wks,k2_obs_DS,res)
;
; res@tiMainOn        = False
; res@gsnLeftString   = "(e)"
; plot_k2_rea_SS = gsn_csm_contour_map_polar(wks,k2_rea_SS,res)
; plot_k2_rea_DS = gsn_csm_contour_map_polar(wks,k2_rea_DS,res)
;
; res@lbLabelBarOn   = True
; res@gsnLeftString  = "(h)"
; plot_k2_model_SS = gsn_csm_contour_map_polar(wks,k2_model_SS,res)
; plot_k2_model_DS = gsn_csm_contour_map_polar(wks,k2_model_DS,res)
;
; res@lbLabelBarOn   = False
;
; ;************delta snow / delta T*************
; res@cnFillPalette  := "BlueWhiteOrangeRed"
; res@lbLabelStride   = 2
;
; res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
; res@cnMinLevelValF  = min_3		; set the minimum contour level
; res@cnMaxLevelValF  = max_3			; set the maximum contour level
; res@cnLevelSpacingF = space_3
;
; res@tiMainString = "Seasonal"
;
; res@tiYAxisString   = "OBS"
;
; res@tiMainOn        = True
; ; res@tiMainString = "~F33~D~F~~F33~a~F~~B~snow~N~/<~F33~D~F~T~B~S~N~>"
; res@gsnLeftString   = "(c)"
; plot_k5_obs_SS = gsn_csm_contour_map_polar(wks,k5_obs_SS,res)
; plot_k5_obs_DS = gsn_csm_contour_map_polar(wks,k5_obs_DS,res)
;
; res@tiMainOn        = False
; res@gsnLeftString   = "(f)"
; plot_k5_rea_SS = gsn_csm_contour_map_polar(wks,k5_rea_SS,res)
; plot_k5_rea_DS = gsn_csm_contour_map_polar(wks,k5_rea_DS,res)
;
; res@lbLabelBarOn   = True
; res@gsnLeftString  = "(i)"
; plot_k5_model_SS = gsn_csm_contour_map_polar(wks,k5_model_SS,res)
; plot_k5_model_DS = gsn_csm_contour_map_polar(wks,k5_model_DS,res)

;-------------------------------------
;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
;pres@gsnMaximize   = True
pres@gsnPanelXWhiteSpacePercent = 5
pres@gsnPanelYWhiteSpacePercent = 2

pres@gsnPanelLabelBar = True
pres@lbLabelFontHeightF   = 0.016
; pres@gsnPanelBottom = 0.001

; XF = fspan(0.15,0.79,3)-0.06
; pres@gsnPanelXF = (/XF(0),XF(1),\
;                     XF(0),XF(1),\
;                     XF(0),XF(1)/)
;
YF = fspan(0.73,0.19,3)+0.15
pres@gsnPanelYF = (/YF(0),YF(0),\
                    YF(1),YF(1),\
                    YF(2),YF(2)/)

gsn_panel(wks,(/plot_k5_obs_SS,   plot_k5_obs_DS, \
                plot_k5_rea_SS,   plot_k5_rea_DS,  \
                plot_k5_model_SS, plot_k5_model_DS/),(/3,2/),pres)

; gsn_panel(wks,(/plot_k1_obs_DS,   plot_k2_obs_DS,   plot_k5_obs_DS, \
;                 plot_k1_rea_DS,   plot_k2_rea_DS,   plot_k5_rea_DS, \
;                 plot_k1_model_DS, plot_k2_model_DS, plot_k5_model_DS/),(/3,3/),pres)


end
