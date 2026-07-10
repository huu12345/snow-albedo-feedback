begin

model6 = (/"ACCESS-ESM1-5","BCC-ESM1","CanESM5",\
"CESM2","CESM2-FV2","CESM2-WACCM","CESM2-WACCM-FV2","CIESM",\
"CNRM-CM6-1","CNRM-CM6-1-HR","CNRM-ESM2-1","E3SM-2-0",\
"E3SM-2-1","EC-Earth3","EC-Earth3-AerChem","EC-Earth3-Veg","EC-Earth3-Veg-LR",\
"FGOALS-f3-L","GISS-E2-1-G","GISS-E2-2-G","GISS-E3-G","HadGEM3-GC31-LL",\
"IPSL-CM6A-LR","IPSL-CM6A-MR1","MIROC6","MIROC-ES2L",\
"MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1",\
"UKESM1-0-LL"/)

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
outpath = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/scatter/"

M=(/"AM_0.25_misstoc/","MA_0.25_misstoc/","MJ_0.25_misstoc/"/)

wks = gsn_open_wks("pdf",outpath+"Figure_1")

n_model6 = dimsizes(model6)
print(n_model6)
;**************************************************************
;*************************季节时间尺度**************************
;****************读取CMIP6************
k4_season   = new(3,"double")
k1k2_season = new(3,"double")
k3_season   = new(3,"double")

NET_SS = new(n_model6,double)
SNC_SS = new(n_model6,double)
TEM_SS = new(n_model6,double)

do i = 0,n_model6-1
  do j = 0,2
    ; ****k4=NET, k1k2=SNC, k3=TEM****
    files_k4   := systemfunc("ls "+inpath_model_SS+M(j)+"k4.*"+model6(i)+".*aa.nc")
    files_k1k2 := systemfunc("ls "+inpath_model_SS+M(j)+"k1k2.*"+model6(i)+".*aa.nc")
    files_k3   := systemfunc("ls "+inpath_model_SS+M(j)+"k3.*"+model6(i)+".*aa.nc")

    f_k4     := addfiles(files_k4,"r")
    f_k1k2   := addfiles(files_k1k2,"r")
    f_k3     := addfiles(files_k3,"r")

    k4       := f_k4[:]->k4(0,0,0)
    k1k2     := f_k1k2[:]->k1k2(0,0,0)
    k3       := f_k3[:]->k3(0,0,0)

    k4_season(j)   = k4    ;3
    k1k2_season(j) = k1k2  ;3
    k3_season(j)   = k3    ;3
  end do

NET_SS(i) = avg(k4_season)
SNC_SS(i) = avg(k1k2_season)
TEM_SS(i) = avg(k3_season)

end do
; qsort(NET_SS)
; qsort(SNC_SS)
; qsort(TEM_SS)

;*************************************
;**************读取观测************
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3"/)

NET_obs_SS = new((/2,3,3/),"double")
SNC_obs_SS = new((/2,3,3/),"double")
TEM_obs_SS = new((/2,3,3/),"double")

do m = 0,1
  do n = 0,2
    do k= 0,2
      k4_season_obs   := new(3,"double")
      k1k2_season_obs := new(3,"double")
      k3_season_obs   := new(3,"double")

      do j = 0,2
         f_k4_obs   = addfile(inpath_OBS_SS+M(j)+"k4.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
         f_k1k2_obs = addfile(inpath_OBS_SS+M(j)+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
         f_k3_obs   = addfile(inpath_OBS_SS+M(j)+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")

         k4_season_obs(j)  = f_k4_obs->k4(0,0,0)
         k1k2_season_obs(j)= f_k1k2_obs->k1k2(0,0,0)
         k3_season_obs(j)  = f_k3_obs->k3(0,0,0)
      end do

      NET_obs_SS(m,n,k) = avg(k4_season_obs)
      SNC_obs_SS(m,n,k) = avg(k1k2_season_obs)
      TEM_obs_SS(m,n,k) = avg(k3_season_obs)
    end do
  end do
end do

;*********************************
;***********读取ERA5-Land*********
k4_season_ERA5   = new(3,"double")
k1k2_season_ERA5 = new(3,"double")
k3_season_ERA5   = new(3,"double")

do j = 0,2
   f_k4_ERA5   = addfile(inpath_ERA5_SS+M(j)+"k4.ERA5-Land2.EASE_grid.aa.nc","r")
   f_k1k2_ERA5 = addfile(inpath_ERA5_SS+M(j)+"k1k2.ERA5-Land2.EASE_grid.aa.nc","r")
   f_k3_ERA5   = addfile(inpath_ERA5_SS+M(j)+"k3.ERA5-Land2.EASE_grid.aa.nc","r")

   k4_ERA5    := f_k4_ERA5->k4(0,0,0)
   k1k2_ERA5  := f_k1k2_ERA5->k1k2(0,0,0)
   k3_ERA5    := f_k3_ERA5->k3(0,0,0)

   k4_season_ERA5(j)   = k4_ERA5    ;3
   k1k2_season_ERA5(j) = k1k2_ERA5  ;3
   k3_season_ERA5(j)   = k3_ERA5    ;3
end do

NET_ERA5_SS = avg(k4_season_ERA5)
SNC_ERA5_SS = avg(k1k2_season_ERA5)
TEM_ERA5_SS = avg(k3_season_ERA5)

;***********读取MERRA2*********
k4_season_MERRA2   = new(3,"double")
k1k2_season_MERRA2 = new(3,"double")
k3_season_MERRA2   = new(3,"double")

do j = 0,2
   f_k4_MERRA2   = addfile(inpath_MERRA2_SS+M(j)+"k4.MERRA22.EASE_grid.aa.nc","r")
   f_k1k2_MERRA2 = addfile(inpath_MERRA2_SS+M(j)+"k1k2.MERRA22.EASE_grid.aa.nc","r")
   f_k3_MERRA2   = addfile(inpath_MERRA2_SS+M(j)+"k3.MERRA22.EASE_grid.aa.nc","r")

   k4_MERRA2    := f_k4_MERRA2->k4(0,0,0)
   k1k2_MERRA2  := f_k1k2_MERRA2->k1k2(0,0,0)
   k3_MERRA2    := f_k3_MERRA2->k3(0,0,0)

   k4_season_MERRA2(j)   = k4_MERRA2    ;3
   k1k2_season_MERRA2(j) = k1k2_MERRA2  ;3
   k3_season_MERRA2(j)   = k3_MERRA2    ;3
end do

NET_MERRA2_SS = avg(k4_season_MERRA2)
SNC_MERRA2_SS = avg(k1k2_season_MERRA2)
TEM_MERRA2_SS = avg(k3_season_MERRA2)

;***********读取JRA55*********
k4_season_JRA55   = new(3,"double")
k1k2_season_JRA55 = new(3,"double")
k3_season_JRA55   = new(3,"double")

do j = 0,2
   f_k4_JRA55   = addfile(inpath_JRA55_SS+M(j)+"k4.JRA552.EASE_grid.aa.nc","r")
   f_k1k2_JRA55 = addfile(inpath_JRA55_SS+M(j)+"k1k2.JRA552.EASE_grid.aa.nc","r")
   f_k3_JRA55   = addfile(inpath_JRA55_SS+M(j)+"k3.JRA552.EASE_grid.aa.nc","r")

   k4_JRA55    := f_k4_JRA55->k4(0,0,0)
   k1k2_JRA55  := f_k1k2_JRA55->k1k2(0,0,0)
   k3_JRA55    := f_k3_JRA55->k3(0,0,0)

   k4_season_JRA55(j)   = k4_JRA55    ;3
   k1k2_season_JRA55(j) = k1k2_JRA55  ;3
   k3_season_JRA55(j)   = k3_JRA55    ;3
end do

NET_JRA55_SS = avg(k4_season_JRA55)
SNC_JRA55_SS = avg(k1k2_season_JRA55)
TEM_JRA55_SS = avg(k3_season_JRA55)

;***********读取JRA3Q*********
k4_season_JRA3Q   = new(3,"double")
k1k2_season_JRA3Q = new(3,"double")
k3_season_JRA3Q   = new(3,"double")

do j = 0,2
   f_k4_JRA3Q   = addfile(inpath_JRA3Q_SS+M(j)+"k4.JRA3Q2.EASE_grid.aa.nc","r")
   f_k1k2_JRA3Q = addfile(inpath_JRA3Q_SS+M(j)+"k1k2.JRA3Q2.EASE_grid.aa.nc","r")
   f_k3_JRA3Q   = addfile(inpath_JRA3Q_SS+M(j)+"k3.JRA3Q2.EASE_grid.aa.nc","r")

   k4_JRA3Q    := f_k4_JRA3Q->k4(0,0,0)
   k1k2_JRA3Q  := f_k1k2_JRA3Q->k1k2(0,0,0)
   k3_JRA3Q    := f_k3_JRA3Q->k3(0,0,0)

   k4_season_JRA3Q(j)   = k4_JRA3Q    ;3
   k1k2_season_JRA3Q(j) = k1k2_JRA3Q  ;3
   k3_season_JRA3Q(j)   = k3_JRA3Q    ;3
end do

NET_JRA3Q_SS = avg(k4_season_JRA3Q)
SNC_JRA3Q_SS = avg(k1k2_season_JRA3Q)
TEM_JRA3Q_SS = avg(k3_season_JRA3Q)

;***********读取ERA5snow*********
k4_season_ERA5snow   = new(3,"double")
k1k2_season_ERA5snow = new(3,"double")
k3_season_ERA5snow   = new(3,"double")

do j = 0,2
   f_k4_ERA5snow   = addfile(inpath_ERA5snow_SS+M(j)+"k4.ERA5snow2.EASE_grid.aa.nc","r")
   f_k1k2_ERA5snow = addfile(inpath_ERA5snow_SS+M(j)+"k1k2.ERA5snow2.EASE_grid.aa.nc","r")
   f_k3_ERA5snow   = addfile(inpath_ERA5snow_SS+M(j)+"k3.ERA5snow2.EASE_grid.aa.nc","r")

   k4_ERA5snow    := f_k4_ERA5snow->k4(0,0,0)
   k1k2_ERA5snow  := f_k1k2_ERA5snow->k1k2(0,0,0)
   k3_ERA5snow    := f_k3_ERA5snow->k3(0,0,0)

   k4_season_ERA5snow(j)   = k4_ERA5snow    ;3
   k1k2_season_ERA5snow(j) = k1k2_ERA5snow  ;3
   k3_season_ERA5snow(j)   = k3_ERA5snow    ;3
end do

NET_ERA5snow_SS = avg(k4_season_ERA5snow)
SNC_ERA5snow_SS = avg(k1k2_season_ERA5snow)
TEM_ERA5snow_SS = avg(k3_season_ERA5snow)

;**************************************************************
;*************************年代际时间尺度**************************
;**************读取CMIP6************
NET_DS = new(n_model6,double)
SNC_DS = new(n_model6,double)
TEM_DS = new(n_model6,double)

do i = 0,n_model6-1
    ; ****k4=NET, k1k2=SNC, k3=TEM****
    files_k4   := systemfunc("ls "+inpath_model_DS+"k4.*"+model6(i)+".*aa.nc")
    files_k1k2 := systemfunc("ls "+inpath_model_DS+"k1k2.*"+model6(i)+".*aa.nc")
    files_k3   := systemfunc("ls "+inpath_model_DS+"k3.*"+model6(i)+".*aa.nc")

    f_k4     := addfiles(files_k4,"r")
    f_k1k2   := addfiles(files_k1k2,"r")
    f_k3     := addfiles(files_k3,"r")

    k4     := f_k4[:]->k4(0,0,0)
    k1k2   := f_k1k2[:]->k1k2(0,0,0)
    k3     := f_k3[:]->k3(0,0,0)

    NET_DS(i) = k4    ;3
    SNC_DS(i) = k1k2  ;3
    TEM_DS(i) = k3    ;3
end do


;**************************************
;**************读取观测 ************
NET_obs_DS = new((/2,3,3/),"double")
SNC_obs_DS = new((/2,3,3/),"double")
TEM_obs_DS = new((/2,3,3/),"double")

do m = 0,1
  do n = 0,2
    do k= 0,2

      f_k4_obs   = addfile(inpath_OBS_DS+"k4.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_k1k2_obs = addfile(inpath_OBS_DS+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_k3_obs   = addfile(inpath_OBS_DS+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")

      NET_obs_DS(m,n,k) = f_k4_obs->k4(0,0,0)
      SNC_obs_DS(m,n,k) = f_k1k2_obs->k1k2(0,0,0)
      TEM_obs_DS(m,n,k) = f_k3_obs->k3(0,0,0)

    end do
  end do
end do

;************************************
;*************读取ERA5-Land**********
f_k4_ERA5   = addfile(inpath_ERA5_DS+"k4.ERA5-Land2.EASE_grid.aa.nc","r")
f_k1k2_ERA5 = addfile(inpath_ERA5_DS+"k1k2.ERA5-Land2.EASE_grid.aa.nc","r")
f_k3_ERA5   = addfile(inpath_ERA5_DS+"k3.ERA5-Land2.EASE_grid.aa.nc","r")

NET_ERA5_DS = f_k4_ERA5->k4(0,0,0)
SNC_ERA5_DS = f_k1k2_ERA5->k1k2(0,0,0)
TEM_ERA5_DS = f_k3_ERA5->k3(0,0,0)

;*************读取MERRA2**********
f_k4_MERRA2   = addfile(inpath_MERRA2_DS+"k4.MERRA22.EASE_grid.aa.nc","r")
f_k1k2_MERRA2 = addfile(inpath_MERRA2_DS+"k1k2.MERRA22.EASE_grid.aa.nc","r")
f_k3_MERRA2   = addfile(inpath_MERRA2_DS+"k3.MERRA22.EASE_grid.aa.nc","r")

NET_MERRA2_DS = f_k4_MERRA2->k4(0,0,0)
SNC_MERRA2_DS = f_k1k2_MERRA2->k1k2(0,0,0)
TEM_MERRA2_DS = f_k3_MERRA2->k3(0,0,0)

;*************读取JRA55**********
f_k4_JRA55   = addfile(inpath_JRA55_DS+"k4.JRA552.EASE_grid.aa.nc","r")
f_k1k2_JRA55 = addfile(inpath_JRA55_DS+"k1k2.JRA552.EASE_grid.aa.nc","r")
f_k3_JRA55   = addfile(inpath_JRA55_DS+"k3.JRA552.EASE_grid.aa.nc","r")

NET_JRA55_DS = f_k4_JRA55->k4(0,0,0)
SNC_JRA55_DS = f_k1k2_JRA55->k1k2(0,0,0)
TEM_JRA55_DS = f_k3_JRA55->k3(0,0,0)

;*************读取JRA3Q**********
f_k4_JRA3Q   = addfile(inpath_JRA3Q_DS+"k4.JRA3Q2.EASE_grid.aa.nc","r")
f_k1k2_JRA3Q = addfile(inpath_JRA3Q_DS+"k1k2.JRA3Q2.EASE_grid.aa.nc","r")
f_k3_JRA3Q   = addfile(inpath_JRA3Q_DS+"k3.JRA3Q2.EASE_grid.aa.nc","r")

NET_JRA3Q_DS = f_k4_JRA3Q->k4(0,0,0)
SNC_JRA3Q_DS = f_k1k2_JRA3Q->k1k2(0,0,0)
TEM_JRA3Q_DS = f_k3_JRA3Q->k3(0,0,0)

;*************读取ERA5snow**********
f_k4_ERA5snow   = addfile(inpath_ERA5snow_DS+"k4.ERA5snow2.EASE_grid.aa.nc","r")
f_k1k2_ERA5snow = addfile(inpath_ERA5snow_DS+"k1k2.ERA5snow2.EASE_grid.aa.nc","r")
f_k3_ERA5snow   = addfile(inpath_ERA5snow_DS+"k3.ERA5snow2.EASE_grid.aa.nc","r")

NET_ERA5snow_DS = f_k4_ERA5snow->k4(0,0,0)
SNC_ERA5snow_DS = f_k1k2_ERA5snow->k1k2(0,0,0)
TEM_ERA5snow_DS = f_k3_ERA5snow->k3(0,0,0)


;*************约束后的结果**********
f=addfile("/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/scatter/constrain.nc","r")
zmean_EC = f->zmean_EC
zstd_EC = f->zstd_EC

print(zmean_EC)
print(zstd_EC)

;**************************************
;**************数据处理*************
;观测
NET_obs_SS  := dim_avg_n(NET_obs_SS,(/0,1/))
SNC_obs_SS  := dim_avg_n(SNC_obs_SS,(/0,1/))
TEM_obs_SS  := dim_avg_n(TEM_obs_SS,(/0,1/))

NET_obs_DS  := dim_avg_n(NET_obs_DS,(/0,1/))
SNC_obs_DS  := dim_avg_n(SNC_obs_DS,(/0,1/))
TEM_obs_DS  := dim_avg_n(TEM_obs_DS,(/0,1/))
printVarSummary(NET_obs_DS)

obsmean_SS = avg(NET_obs_SS)
obsstd_SS  = dim_stddev(NET_obs_SS)
obsmean_DS = avg(NET_obs_DS)
obsstd_DS  = dim_stddev(NET_obs_DS)

;再分析
;seasonal
NET_rea_SS  = new(5,float)
SNC_rea_SS  = new(5,float)
TEM_rea_SS  = new(5,float)
; printVarSummary(NET_ERA5_SS)

NET_rea_SS(0) = tofloat(NET_ERA5_SS)
NET_rea_SS(1) = tofloat(NET_ERA5snow_SS)
NET_rea_SS(2) = tofloat(NET_JRA3Q_SS)
NET_rea_SS(3) = tofloat(NET_JRA55_SS)
NET_rea_SS(4) = tofloat(NET_MERRA2_SS)

SNC_rea_SS(0) = tofloat(SNC_ERA5_SS)
SNC_rea_SS(1) = tofloat(SNC_ERA5snow_SS)
SNC_rea_SS(2) = tofloat(SNC_JRA3Q_SS)
SNC_rea_SS(3) = tofloat(SNC_JRA55_SS)
SNC_rea_SS(4) = tofloat(SNC_MERRA2_SS)

TEM_rea_SS(0) = tofloat(TEM_ERA5_SS)
TEM_rea_SS(1) = tofloat(TEM_ERA5snow_SS)
TEM_rea_SS(2) = tofloat(TEM_JRA3Q_SS)
TEM_rea_SS(3) = tofloat(TEM_JRA55_SS)
TEM_rea_SS(4) = tofloat(TEM_MERRA2_SS)

;decadal
NET_rea_DS  = new(5,float)
SNC_rea_DS  = new(5,float)
TEM_rea_DS  = new(5,float)

NET_rea_DS(0) = tofloat(NET_ERA5_DS)
NET_rea_DS(1) = tofloat(NET_ERA5snow_DS)
NET_rea_DS(2) = tofloat(NET_JRA3Q_DS)
NET_rea_DS(3) = tofloat(NET_JRA55_DS)
NET_rea_DS(4) = tofloat(NET_MERRA2_DS)

SNC_rea_DS(0) = tofloat(SNC_ERA5_DS)
SNC_rea_DS(1) = tofloat(SNC_ERA5snow_DS)
SNC_rea_DS(2) = tofloat(SNC_JRA3Q_DS)
SNC_rea_DS(3) = tofloat(SNC_JRA55_DS)
SNC_rea_DS(4) = tofloat(SNC_MERRA2_DS)

TEM_rea_DS(0) = tofloat(TEM_ERA5_DS)
TEM_rea_DS(1) = tofloat(TEM_ERA5snow_DS)
TEM_rea_DS(2) = tofloat(TEM_JRA3Q_DS)
TEM_rea_DS(3) = tofloat(TEM_JRA55_DS)
TEM_rea_DS(4) = tofloat(TEM_MERRA2_DS)

;************************画图************************
res                   = True                     ; plot mods desired
; res@gsnMaximize       = True                     ; maximize plot
res@gsnDraw       = False
res@gsnFrame      = False

res@tmXTOn     = False
res@tmYROn     = False

res@tiYAxisFontHeightF   = 0.025
res@tiXAxisFontHeightF   = 0.025

; res@tiMainFontHeightF    = 0.04
; res@tiMainOffsetYF       = 0.008
; res@tiMainFont           = 22

res@tmXBPrecision = 2
res@tmYLPrecision = 2

res@tmXBMinorPerMajor = 0
res@tmYLMinorPerMajor = 0

; res@trYMinF          = -2.
; res@trYMaxF          = 0.1        ; extra space for demo
; res@tmYLMode         = "Manual"
; res@tmYLTickStartF   = -2.
; res@tmYLTickEndF     = 0.
; res@tmYLTickSpacingF = 0.2
; ;
; res@trXMinF          = -2.0
; res@trXMaxF          = 0.1           ; extra space for demo
; res@tmXBMode         = "Manual"
; res@tmXBTickStartF   = -2.0
; res@tmXBTickEndF     = 0.
; res@tmXBTickSpacingF = 0.2

res@trYMinF          = -2.1
res@trYMaxF          = 0.        ; extra space for demo
; res@tmYLMode         = "Manual"
; res@tmYLTickStartF   = -2.4
; res@tmYLTickEndF     = 0.4
; res@tmYLTickSpacingF = 0.4

res@trXMinF          = -2.1
res@trXMaxF          = -0.           ; extra space for demo

;***************画模式*****************
;画散点
res@tiXAxisString    = "Seasonal SAF~B~NET~N~ (%/K)"
res@tiYAxisString    = "Decadal SAF~B~NET~N~ (%/K)"

res@xyMarkLineMode   = "Markers"                ; choose to use markers
; res@xyMarkerOpacityF = 0.0  ; 设置透明度为0（完全透明）
res@xyMarkers         =  16                      ; choose type of marker
res@xyMarkerColor     = "mediumblue";"indianred2"                    ; Marker color
res@xyMarkerSizeF     = 0.011                     ; Marker size (default 0.01)
res@xyMarkerThicknessF= 1.

x := NET_SS
y := NET_DS

plot = gsn_csm_xy(wks, x, y, res)

;回归线
res1 = True
res1@gsnDraw       = False
res1@gsnFrame      = False

res1@xyLineColor       = "mediumblue";"dodgerblue3"
res1@xyLineThicknessF  = 5.
res1@xyDashPattern = 16

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line
rc_r    = rc@r

plot1  := gsn_csm_xy(wks,(/min(x),max(x)/),(/min(pltarry),max(pltarry)/),res1)        ; create plot
overlay(plot,plot1)

;阴影
; ymr025 = rc@YMR025
; ymr975 = rc@YMR975
;
; ; 获取排序索引（不改变原始 x）
; idx = dim_pqsort(x, 1)
;
; ; 重新排序所有数据
; x_sorted = x(idx)
; y_fit_sorted = pltarry(idx)
; ci_low_sorted = ymr025(idx)
; ci_high_sorted = ymr975(idx)
; ; print(x_sorted)
; ; print(y_fit_sorted)
; ; print(ci_low_sorted)
; ; print(ci_high_sorted)
;
; ; 构造多边形顶点
; xp = new( (/2*32/), double )
; yp = new( (/2*32/), double )
;
; do k = 0,31
;   xp(k) = x_sorted(k)
;   yp(k) = ci_low_sorted(k)
;
;   xp(2*32-1-k) = x_sorted(k)
;   yp(2*32-1-k) = ci_high_sorted(k)
; end do
;
; res_ci = True
; res_ci@tfPolyDrawOrder = "PreDraw"  ; this can be used for polylines, polymarkers, or polygons
; res_ci@gsFillColor = "lightblue1"
; res_ci@gsFillOpacityF = 0.6
; poly = gsn_add_polygon(wks, plot, xp, yp, res_ci)

;***************画观测***************
;阴影
gres                 = True
gres@gsFillColor     = "gray81"
gres@gsFillOpacityF  = 0.42
gres@tfPolyDrawOrder = "PreDraw"  ; this can be used for polylines, polymarkers, or polygons
dum_obs_1 = gsn_add_polygon(wks,plot, (/obsmean_SS-obsstd_SS, obsmean_SS+obsstd_SS, obsmean_SS+obsstd_SS, obsmean_SS-obsstd_SS/), (/-2.5, -2.5, 0.5, 0.5/),gres)

dum_obs_2 = gsn_add_polygon(wks,plot, (/-2.5, -2.5, 0.5, 0.5/),(/obsmean_DS-obsstd_DS, obsmean_DS+obsstd_DS, obsmean_DS+obsstd_DS, obsmean_DS-obsstd_DS/), gres)

;平均值
plres2 = True
plres2@gsLineThicknessF  = 4.          ; make second line thicker
plres2@gsLineColor       = "black"         ; change line color
plres2@gsLineDashPattern = 0
dum_obs_3 = gsn_add_polyline(wks,plot,(/obsmean_SS,obsmean_SS/),(/-2.5,0.5/),plres2)

dum_obs_4 = gsn_add_polyline(wks,plot,(/-2.5,0.5/),(/obsmean_DS,obsmean_DS/),plres2)

;*************约束后的结果**********
;阴影
gres1                 = True
gres1@gsFillColor     = "darkgreen"
gres1@gsFillOpacityF  = 0.38
; gres@tfPolyDrawOrder = "PreDraw"  ; this can be used for polylines, polymarkers, or polygons
dum_EC_1 = gsn_add_polygon(wks,plot, (/-2.5, -2.5, -2.0, -2.0/),(/zmean_EC-zstd_EC, zmean_EC+zstd_EC, zmean_EC+zstd_EC, zmean_EC-zstd_EC/), gres1)

;平均值
plres3 = True
plres3@gsLineThicknessF  = 5.          ; make second line thicker
plres3@gsLineColor       = "darkgreen"         ; change line color
plres3@gsLineDashPattern = 16
dum_EC_2 = gsn_add_polyline(wks,plot,(/-2.5,obsmean_SS/),(/zmean_EC,zmean_EC/),plres3)

;****************添加对角线 (y=x)***************
diagonal_x = (/-3, 0.5/)  ; 对角线的 X 范围
diagonal_y = diagonal_x   ; 对角线的 Y 范围

res2=True
res2@gsLineDashPattern = 1
res2@gsLineColor = "gray80";"indianred2"
res2@gsLineThicknessF  = 5.          ; make second line thicker

dum1 = gsn_add_polyline(wks, plot, diagonal_x, diagonal_y, res2)  ; 添加对角线

;****************添加观测标注***************
str_obs  = (/"A","C2","C3"/)
str_rea  = (/"E","Es","J3","J5","M"/)

txres = True   ;  CMIP6
txres@txFontHeightF = 0.015
txres@txJust = "CenterCenter"
txres@txFontColor = "red"   ; 观测
text2 = gsn_add_text(wks,plot,str_obs,NET_obs_SS,NET_obs_DS,txres)

txres@txFontColor = "darkorange2"  ; 再分析
text3 = gsn_add_text(wks,plot,str_rea,NET_rea_SS,NET_rea_DS,txres)

;再分析回归线
res@xyMarkLineModes     = "Lines"
res@xyLineThicknesses   = 5.
res@xyLineColor         = "darkorange2"
res@xyDashPattern = 16

x := NET_rea_SS
y := NET_rea_DS

rc      := regline_stats(x,y)
pval_rea:= rc@pval
pltarry := rc*x + rc@yintercept

if rc.lt.0 then
   rc_r_rea = -rc@r
 else
   rc_r_rea = rc@r
end if

; plot2  = gsn_csm_xy(wks,(/min(x),max(x)/),(/min(pltarry),max(pltarry)/),res)
; overlay(plot,plot2)

;****************标注***************
txres                  = True
txres@txFontHeightF    = 0.017

amres                  = True
amres@amJust           = "BottomLeft"
txres@txFontColor      = "mediumblue"

;CMIP6标注
amres@amParallelPosF   = -0.03
amres@amOrthogonalPosF = 0.5

if pval(1).lt.0.01 then
  txid1 = gsn_create_text(wks, "CMIP6 (r = "+sprintf("%.2f",rc_r)+", p < 0.01)", txres)
  annoid1 = gsn_add_annotation(plot, txid1, amres)
else if pval(1).lt.0.05 then
  txid1 = gsn_create_text(wks, "CMIP6 (r = "+sprintf("%.2f",rc_r)+", p < 0.05)", txres)
  annoid1 = gsn_add_annotation(plot, txid1, amres)
else if pval(1).lt.0.1 then
  txid1 = gsn_create_text(wks, "CMIP6 (r = "+sprintf("%.2f",rc_r)+", p < 0.10)", txres)
  annoid1 = gsn_add_annotation(plot, txid1, amres)
else
  txid1 = gsn_create_text(wks, "CMIP6 (r = "+sprintf("%.2f",rc_r)+", p = "+sprintf("%.2f",pval(1))+")", txres)
  annoid1 = gsn_add_annotation(plot, txid1, amres)
end if
end if
end if

;再分析标注
txres@txFontColor      = "darkorange2"

amres@amParallelPosF   = -0.03
amres@amOrthogonalPosF = 0.45

pval = pval_rea

; txid1 = gsn_create_text(wks, "Reanalysis", txres)
; annoid2 = gsn_add_annotation(plot, txid1, amres)

if pval(1).lt.0.01 then
  txid2 = gsn_create_text(wks, "Reanalysis (r = "+sprintf("%.2f",rc_r_rea)+", p < 0.01)", txres)
  annoid2 = gsn_add_annotation(plot, txid2, amres)
else if pval(1).lt.0.05 then
  txid2 = gsn_create_text(wks, "Reanalysis (r = "+sprintf("%.2f",rc_r_rea)+", p < 0.05)", txres)
  annoid2 = gsn_add_annotation(plot, txid2, amres)
else if pval(1).lt.0.1 then
  txid2 = gsn_create_text(wks, "Reanalysis (r = "+sprintf("%.2f",rc_r_rea)+", p < 0.10)", txres)
  annoid2 = gsn_add_annotation(plot, txid2, amres)
else
  txid2 = gsn_create_text(wks, "Reanalysis (r = "+sprintf("%.2f",rc_r_rea)+", p = "+sprintf("%.2f",pval(1))+")", txres)
  annoid2 = gsn_add_annotation(plot, txid2, amres)
end if
end if
end if

; ;观测标注
txres@txFontColor      = "red"
amres@amParallelPosF   = -0.03
amres@amOrthogonalPosF = 0.4
txid2 = gsn_create_text(wks, "OBS", txres)
annoid2 = gsn_add_annotation(plot, txid2, amres)

txres@txFontColor      = "black"
amres@amParallelPosF   = -0.46
amres@amOrthogonalPosF = -0.385
txid2 = gsn_create_text(wks, "OBS mean", txres)
annoid2 = gsn_add_annotation(plot, txid2, amres)

txres@txFontColor      = "gray50"
amres@amParallelPosF   = -0.495
amres@amOrthogonalPosF = -0.33
txid2 = gsn_create_text(wks, "~F34~1~F~ OBS uncertainty", txres)
annoid2 = gsn_add_annotation(plot, txid2, amres)

txres@txFontColor      = "darkgreen"
txres@txAngleF         = 90
amres@amParallelPosF   = -0.445
amres@amOrthogonalPosF = 0.102 ;-0.015
txid2 = gsn_create_text(wks, "Constrained", txres)
annoid2 = gsn_add_annotation(plot, txid2, amres)

;**********************************************************
pres = True
gsn_panel(wks,plot,(/1,1/),pres)

end
