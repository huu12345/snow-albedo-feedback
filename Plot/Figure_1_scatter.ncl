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
inpath_model_SS   = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/seasonal/result/result_cmip6/"
inpath_ERA5_SS    = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/seasonal/result/result_ERA5-Land/"
inpath_MERRA2_SS  = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/seasonal/result/result_MERRA2/"
inpath_JRA55_SS   = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/seasonal/result/result_JRA55/"
inpath_JRA3Q_SS   = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/seasonal/result/result_JRA3Q/"
inpath_ERA5snow_SS= "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/seasonal/result/result_ERA5snow/"
inpath_OBS_SS     = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/seasonal/result/result_obs_all/"

;*******
inpath_model_DS   = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/decadal_minus_first/result/result_cmip6/"
inpath_ERA5_DS    = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/decadal_minus_first/result/result_ERA5-Land/"
inpath_MERRA2_DS  = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/decadal_minus_first/result/result_MERRA2/"
inpath_JRA55_DS   = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/decadal_minus_first/result/result_JRA55/"
inpath_JRA3Q_DS   = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/decadal_minus_first/result/result_JRA3Q/"
inpath_ERA5snow_DS= "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/decadal_minus_first/result/result_ERA5snow/"
inpath_OBS_DS     = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/data_amip/decadal_minus_first/result/result_obs_all/"

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

NET_obs_SS = new(2*3*3,"double")
SNC_obs_SS = new(2*3*3,"double")
TEM_obs_SS = new(2*3*3,"double")

h=0
do k= 0,2
do m = 0,1
  do n = 0,2
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

      ; print(nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k))
      ; print(avg(k4_season_obs))
      NET_obs_SS(h) = avg(k4_season_obs)
      SNC_obs_SS(h) = avg(k1k2_season_obs)
      TEM_obs_SS(h) = avg(k3_season_obs)
      h=h+1
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

; ;;;;;print(NET_ERA5_SS)
; ;;;;;print(SNC_ERA5_SS)
; ;;;;;print(TEM_ERA5_SS)

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
NET_obs_DS = new(2*3*3,"double")
SNC_obs_DS = new(2*3*3,"double")
TEM_obs_DS = new(2*3*3,"double")

h=0
do k= 0,2
do m = 0,1
  do n = 0,2

      f_k4_obs   = addfile(inpath_OBS_DS+"k4.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_k1k2_obs = addfile(inpath_OBS_DS+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_k3_obs   = addfile(inpath_OBS_DS+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")

      NET_obs_DS(h) = f_k4_obs->k4(0,0,0)
      SNC_obs_DS(h) = f_k1k2_obs->k1k2(0,0,0)
      TEM_obs_DS(h) = f_k3_obs->k3(0,0,0)

      h=h+1

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

;;;;;print(NET_ERA5_DS)
;;;;;print(SNC_ERA5_DS)
;;;;;print(TEM_ERA5_DS)
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
;print(NET_JRA3Q_DS)
;print(SNC_JRA3Q_DS)
;print(TEM_JRA3Q_DS)

;*************读取ERA5snow**********
f_k4_ERA5snow   = addfile(inpath_ERA5snow_DS+"k4.ERA5snow2.EASE_grid.aa.nc","r")
f_k1k2_ERA5snow = addfile(inpath_ERA5snow_DS+"k1k2.ERA5snow2.EASE_grid.aa.nc","r")
f_k3_ERA5snow   = addfile(inpath_ERA5snow_DS+"k3.ERA5snow2.EASE_grid.aa.nc","r")

NET_ERA5snow_DS = f_k4_ERA5snow->k4(0,0,0)
SNC_ERA5snow_DS = f_k1k2_ERA5snow->k1k2(0,0,0)
TEM_ERA5snow_DS = f_k3_ERA5snow->k3(0,0,0)


;**************************************
;**************计算观测均值*************
;观测平均
; NET_obs_SS_all  = ndtooned(NET_obs_SS)
; SNC_obs_SS_all  = ndtooned(SNC_obs_SS)
; TEM_obs_SS_all  = ndtooned(TEM_obs_SS)
; ; printVarSummary(NET_obs_SS_all)
;
; NET_obs_DS_all  = ndtooned(NET_obs_DS)
; SNC_obs_DS_all  = ndtooned(SNC_obs_DS)
; TEM_obs_DS_all  = ndtooned(TEM_obs_DS)
;
; x := NET_obs_SS_all
; y := NET_obs_DS_all
;
; rc      := regline_stats(x,y)
; pval    := rc@pval                                   ; use markers
; pltarry := rc*x + rc@yintercept              ; use solid line
;
; print(rc)
; ; print(pval(1))
; print(rc@yintercept)

NET_obs_SS_avg  = NET_obs_SS
SNC_obs_SS_avg  = SNC_obs_SS
TEM_obs_SS_avg  = TEM_obs_SS
; printVarSummary(NET_obs_SS_avg)

NET_obs_DS_avg  = NET_obs_DS
SNC_obs_DS_avg  = SNC_obs_DS
TEM_obs_DS_avg  = TEM_obs_DS

; x := NET_obs_SS_avg
; y := NET_obs_DS_avg
;
; rc      := regline_stats(x,y)
; pval    := rc@pval                                   ; use markers
; pltarry := rc*x + rc@yintercept              ; use solid line
;
; print(rc)
; ; print(pval(1))
; print(rc@yintercept)

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

res@tiYAxisString    = "Decadal (%/K)"
res@tiXAxisString    = "Seasonal (%/K)"

res@xyMarkLineMode   = "Markers"                ; choose to use markers
res@xyMarkerOpacityF = 0.0  ; 设置透明度为0（完全透明）

res@tiYAxisFontHeightF   = 0.03
res@tiYAxisFontHeightF   = 0.03
res@tiMainFontHeightF    = 0.038

str_cmip = sprintf("%2.2g",ispan(1,n_model6,1))
str_obs  = (/"A","C2","C3"/)
str_rea  = (/"E","Es","J3","J5","M"/)

; print(str_cmip)

;******************plot1: NET*******************
res@tiMainString     = "SAF~B~NET~N~"

res@trYMinF          = -2.5
res@trYMaxF          = 0.        ; extra space for demo
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = -2.5
res@tmYLTickEndF     = 0.
res@tmYLTickSpacingF = 0.5

res@trXMinF          = -2.5
res@trXMaxF          = 0.           ; extra space for demo
res@tmXBMode         = "Manual"
res@tmXBTickStartF   = -2.5
res@tmXBTickEndF     = 0.
res@tmXBTickSpacingF = 0.5

res@tmXBPrecision = 2
res@tmYLPrecision = 2

res@tmXBMinorPerMajor = 4
res@tmYLMinorPerMajor = 4

plot1 = gsn_csm_xy(wks, NET_SS, NET_DS, res)

;**CMIP6**
txres = True   ; 设置文本
txres@txFontHeightF = 0.02
txres@txJust = "CenterCenter"

text1 = gsn_add_text(wks,plot1,str_cmip,NET_SS,NET_DS,txres)

; ;**观测**
; txres@txFontColor = "red"
; text2 = gsn_add_text(wks,plot1,str_obs,NET_obs_SS_avg,NET_obs_DS_avg,txres)

;**再分析**
txres@txFontColor = "blue2"
text3 = gsn_add_text(wks,plot1,str_rea,NET_rea_SS,NET_rea_DS,txres)

;******************plot2: SNC*******************
res@tiMainString     = "SAF~B~SNC~N~"

; res@tmXBMinorPerMajor = 2
; res@tmYLMinorPerMajor = 2

res@trYMinF          = -1.5
res@trYMaxF          = 0.0         ; extra space for demo
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = -1.5
res@tmYLTickEndF     = 0.
res@tmYLTickSpacingF = 0.5

res@trXMinF          = -1.5
res@trXMaxF          = 0.0           ; extra space for demo
res@tmXBMode         = "Manual"
res@tmXBTickStartF   = -1.5
res@tmXBTickEndF     = 0.
res@tmXBTickSpacingF = 0.5

plot2 = gsn_csm_xy(wks, SNC_SS, SNC_DS, res)

;**CMIP6**
txres@txFontColor = "black"
text1 = gsn_add_text(wks,plot2,str_cmip,SNC_SS,SNC_DS,txres)

;**观测**
; txres@txFontColor = "red"
; text2 = gsn_add_text(wks,plot2,str_obs,SNC_obs_SS_avg,SNC_obs_DS_avg,txres)

;**再分析**
txres@txFontColor = "blue"
text3 = gsn_add_text(wks,plot2,str_rea,SNC_rea_SS,SNC_rea_DS,txres)

;******************plot3: TEM*******************
res@tiMainString     = "SAF~B~TEM~N~"

; res@tmXBMinorPerMajor = 2
; res@tmYLMinorPerMajor = 4

res@trYMinF          = -2.0
res@trYMaxF          = 0.5         ; extra space for demo
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = -2.0
res@tmYLTickEndF     = 0.5
res@tmYLTickSpacingF = 0.5

res@trXMinF          = -2.0
res@trXMaxF          = 0.5           ; extra space for demo
res@tmXBMode         = "Manual"
res@tmXBTickStartF   = -2.0
res@tmXBTickEndF     = 0.5
res@tmXBTickSpacingF = 0.5

plot3 = gsn_csm_xy(wks, TEM_SS, TEM_DS, res)

;**CMIP6**
txres@txFontColor = "black"
text1 = gsn_add_text(wks,plot3,str_cmip,TEM_SS,TEM_DS,txres)

; ;**观测**
; txres@txFontColor = "red"
; text2 = gsn_add_text(wks,plot3,str_obs,TEM_obs_SS_avg,TEM_obs_DS_avg,txres)

;**再分析**
txres@txFontColor = "blue"
text3 = gsn_add_text(wks,plot3,str_rea,TEM_rea_SS,TEM_rea_DS,txres)


;****************观测***************
mark = new(18,"integer")
mark(0:5) = 4
mark(6:11) = 7
mark(12:17) = 6

plot10 = new(18,graphic)
plot20 = new(18,graphic)
plot30 = new(18,graphic)

do i=0,17
res@xyMarkLineMode   = "Markers"                ; choose to use markers
res@xyMarkers         =  mark(i)                      ; choose type of marker
res@xyMarkerColor     = "red"                    ; Marker color
res@xyMarkerSizeF     = 0.012                     ; Marker size (default 0.01)
res@xyMarkerThicknessF= 0.9
res@xyMarkerOpacityF = 1.0  ; 设置透明度为0（完全透明）

plot10(i) = gsn_csm_xy(wks,  (/NET_obs_SS_avg(i),NET_obs_SS_avg(i)/), (/NET_obs_DS_avg(i),NET_obs_DS_avg(i)/), res)
plot20(i) = gsn_csm_xy(wks,  (/SNC_obs_SS_avg(i),SNC_obs_SS_avg(i)/), (/SNC_obs_DS_avg(i),SNC_obs_DS_avg(i)/), res)
plot30(i) = gsn_csm_xy(wks,  (/TEM_obs_SS_avg(i),TEM_obs_SS_avg(i)/), (/TEM_obs_DS_avg(i),TEM_obs_DS_avg(i)/), res)
overlay(plot1,plot10(i))
overlay(plot2,plot20(i))
overlay(plot3,plot30(i))
end do

;****************添加对角线 (y=x)***************
diagonal_x = (/-3, 0.5/)  ; 对角线的 X 范围
diagonal_y = diagonal_x   ; 对角线的 Y 范围

res1=True
res1@gsLineDashPattern = 1
res1@gsLineColor = "gray40"

dum1 = gsn_add_polyline(wks, plot1, diagonal_x, diagonal_y, res1)  ; 添加对角线
dum2 = gsn_add_polyline(wks, plot2, diagonal_x, diagonal_y, res1)  ; 添加对角线
dum3 = gsn_add_polyline(wks, plot3, diagonal_x, diagonal_y, res1)  ; 添加对角线

;*******************线性回归********************
;***********plot1************
;*****OBS******
res@xyMarkLineModes     = "Lines"  ; choose which have markers
res@xyLineThicknesses   = 1.8                ; set second line to 2
res@xyLineColor         = "red"

x := NET_obs_SS_avg
y := NET_obs_DS_avg

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("NET OBS P: "+pval(1))
; print("yintercept:"+rc@yintercept)
; print(rc@r)

plot12  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot1,plot12)

;线性函数
res2               = True                     ; text mods desired
res2@txFontHeightF = 0.017                     ; font smaller. default big
res2@txFontColor   = "red"

x1 = (/-0.55, -0.48/) +0.04
y1 = (/-1.6, -1.73/)+0.1

if rc@yintercept.lt.0 then
   dum11 = gsn_add_text(wks,plot1,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum11 = gsn_add_text(wks,plot1,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum11 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum11 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum11 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum11 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;*****再分析******
res@xyLineColor         = "blue"

x := NET_rea_SS
y := NET_rea_DS

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("NET Rea P: "+pval(1))
; print("yintercept:"+rc@yintercept)

plot13  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot1,plot13)

;线性函数
res2@txFontColor   = "blue"

x1 = (/-0.56, -0.49/)+0.04
y1 = (/-1.7, -1.83/)-0.25+0.1


if rc@yintercept.lt.0 then
   dum12 = gsn_add_text(wks,plot1,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum12 = gsn_add_text(wks,plot1,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum12 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum12 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum12 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum12 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;*****CMIP6******
res@xyLineColor         = "black"

x := NET_SS
y := NET_DS

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("NET CMIP6 P: "+pval(1))
; print("yintercept:"+rc@yintercept)

plot11  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot1,plot11)

;线性函数
res2@txFontColor   = "black"

x1 = (/-0.55, -0.495/)+0.04
y1 = (/-1.6, -1.73/) -0.7+0.1

if rc@yintercept.lt.0 then
   dum13 = gsn_add_text(wks,plot1,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum13 = gsn_add_text(wks,plot1,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum13 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum13 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum13 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum13 = gsn_add_text(wks,plot1,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;***********plot2************
;*****OBS******
res@xyLineColor         = "red"

x := SNC_obs_SS_avg
y := SNC_obs_DS_avg

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("SNC OBS P: "+pval(1))
; print("OBS yintercept:"+rc@yintercept)

plot21  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot2,plot21)

;线性函数
res2@txFontColor   = "red"

x1 = (/-0.315, -0.28/)
y1 = (/-0.88, -0.95/) -0.05

if rc@yintercept.lt.0 then
   dum21 = gsn_add_text(wks,plot2,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum21 = gsn_add_text(wks,plot2,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum21 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum21 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum21 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum21 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;*****再分析******
res@xyLineColor         = "blue"

x := SNC_rea_SS
y := SNC_rea_DS

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("SNC Rea P: "+pval(1))
; print("Rea yintercept:"+rc@yintercept)

plot22  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot2,plot22)

;线性函数
res2@txFontColor   = "blue"

x1 = (/-0.315, -0.28/)
y1 = (/-0.88, -0.95/) -0.2 -0.05

if rc@yintercept.lt.0 then
   dum22 = gsn_add_text(wks,plot2,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum22 = gsn_add_text(wks,plot2,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum22 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum22 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum22 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum22 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;*****CMIP6******
res@xyLineColor         = "black"

x := SNC_SS
y := SNC_DS

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("SNC CMIP6 P: "+pval(1))
; print("CMIP6 yintercept:"+rc@yintercept)

plot23  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot2,plot23)

;线性函数
res2@txFontColor   = "black"

x1 = (/-0.322, -0.28/)
y1 = (/-0.88, -0.95/) -0.4 -0.05

if rc@yintercept.lt.0 then
   dum23 = gsn_add_text(wks,plot2,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum23 = gsn_add_text(wks,plot2,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum23 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum23 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum23 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum23 = gsn_add_text(wks,plot2,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;***********plot3************
;*****OBS******
res@xyLineColor         = "red"

x := TEM_obs_SS_avg
y := TEM_obs_DS_avg

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("TEM OBS P: "+pval(1))
; print("TEM OBS yintercept:"+rc@yintercept)

plot31  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot3,plot31)

;线性函数
res2@txFontColor   = "red"

x1 = (/-1.58, -1.51/)
y1 = (/0.05, -0.07/)

if rc@yintercept.lt.0 then
   dum31 = gsn_add_text(wks,plot3,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum31 = gsn_add_text(wks,plot3,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum31 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum31 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum31 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum31 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;*****再分析******
res@xyLineColor         = "blue"

x := TEM_rea_SS
y := TEM_rea_DS

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("TEM Rea P: "+pval(1))
; print("TEM Rea yintercept:"+rc@yintercept)

plot32  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot3,plot32)

;线性函数
res2@txFontColor   = "blue"

x1 = (/-1.58, -1.525/)
y1 = (/0.05, -0.07/) -0.33

if rc@yintercept.lt.0 then
   dum32 = gsn_add_text(wks,plot3,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum32 = gsn_add_text(wks,plot3,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum32 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum32 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum32 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum32 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;*****CMIP6******
res@xyLineColor         = "black"

x := TEM_SS
y := TEM_DS

rc      := regline_stats(x,y)
pval    := rc@pval                                   ; use markers
pltarry := rc*x + rc@yintercept              ; use solid line

if rc.lt.0 then
   rc_r = -rc@r
 else
   rc_r = rc@r
end if

print("TEM CMIP6 P: "+pval(1))
; print("TEM CMIP6 yintercept:"+rc@yintercept)

plot33  = gsn_csm_xy(wks,x,pltarry,res)        ; create plot
overlay(plot3,plot33)

;线性函数
res2@txFontColor   = "black"

x1 = (/-1.58, -1.525/)
y1 = (/0.05, -0.07/) -0.66

if rc@yintercept.lt.0 then
   dum33 = gsn_add_text(wks,plot3,"y = "+sprintf("%.2f",rc)+"x - "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
else
   dum33 = gsn_add_text(wks,plot3,"y = "+sprintf("%.2f",rc)+"x + "+sprintf("%.2f",abs(rc@yintercept)),x1(0),y1(0),res2)
end if

if pval(1).lt.0.01 then
   dum33 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.01)",x1(1),y1(1),res2)
else if pval(1).lt.0.05 then
   dum33 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.05)",x1(1),y1(1),res2)
else if pval(1).lt.0.1 then
   dum33 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p < 0.10)",x1(1),y1(1),res2)
else
   dum33 = gsn_add_text(wks,plot3,"r = "+sprintf("%.2f",rc_r)+" (p = "+sprintf("%.2f",pval(1))+")",x1(1),y1(1),res2)
end if
end if
end if

;************ Create some labelbars for a legend*******
labels1  = (/"OBS","Reanalysis","CMIP6"/)
colors_line = (/"red","blue","black"/)

xpos  := (/0.14,0.18,0.31,0.35,0.52,0.56/)+0.14
ypos  := (/0.1,0.1,0.1,0.1,0.1,0.1/)+0.2

res_text               = True
res_text@txFontHeightF = 0.014
res_text@txJust        = "CenterLeft"

res_lines                   = True        ; polyline mods desired
res_lines@gsLineThicknessF  = 2.2           ; line thicker
res_lines@gsLineDashPattern = 0   ; dash pattern

do i = 0,2
  res_lines@gsLineColor       = colors_line(i)   ; line color

  gsn_polyline_ndc(wks,xpos(i*2:i*2+1),ypos(i*2:i*2+1),res_lines)
  gsn_text_ndc(wks,labels1(i),xpos(i*2)+0.045,ypos(i*2),res_text)
end do

;**********************************************************
 pres = True
; pres@txString = "albedo("+ymStrt+"-"+ymLast+")"
; pres@gsnPanelMainFontHeightF     = 0.015
 pres@gsnPanelXWhiteSpacePercent  = 5       ;留白
; pres@gsnPanelYWhiteSpacePercent  = 5

pres@gsnPanelFigureStrings        = (/"(a)","(b)","(c)"/)
pres@gsnPanelFigureStringsJust    = "TopLeft"
pres@gsnPanelFigureStringsPerimOn = False
pres@gsnPanelFigureStringsFontHeightF = 0.012

; XF = fspan(0.13,0.72,3)-0.06
; pres@gsnPanelXF = (/XF(0),XF(1),XF(2)/)

; plot4 = new(1,graphic)
gsn_panel(wks,(/plot1,plot2,plot3/),(/1,3/),pres)

end
