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
outpath = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/box/"


name = "Table_S2_NET.txt"

M=(/"AM_0.25_misstoc/","MA_0.25_misstoc/","MJ_0.25_misstoc/"/)

n_model6 = dimsizes(model6)

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
; print(NET_SS)
; print(SNC_SS)
; print(TEM_SS)

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

do m = 0,1  ;tas
  do n = 0,2  ;snc
    do k= 0,2  ;alb
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
      NET_obs_SS(m,n,k) = avg(k4_season_obs)
      SNC_obs_SS(m,n,k) = avg(k1k2_season_obs)
      TEM_obs_SS(m,n,k) = avg(k3_season_obs)
    end do
  end do
end do

; print(NET_obs_SS)
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

;****************计算百分位数***************
function prctile(var,percentile)
begin
  qsort(var)
  p = percentile/100.*dimsizes(var)
  i = floattoint(p)
  if ( abs(p-i) .lt.1e-10) then
    avg1 = (var(i)+var(i-1))/2.*1.0
    return avg1
  else
    return var(i)
  end if
end

;;cmip6
NET_x25_SS  := prctile(NET_SS,25)
NET_x75_SS  := prctile(NET_SS,75)

SNC_x25_SS  := prctile(SNC_SS,25)
SNC_x75_SS  := prctile(SNC_SS,75)

TEM_x25_SS  := prctile(TEM_SS,25)
TEM_x75_SS  := prctile(TEM_SS,75)

;*********************箱型图所需的变量************************************
iarr_NET_SS =new((/3,5/),double)
iarr_SNC_SS =new((/3,5/),double)
iarr_TEM_SS =new((/3,5/),double)

iarr_NET_SS(2,:) = (/min(NET_SS),NET_x25_SS,dim_median(NET_SS),NET_x75_SS,max(NET_SS)/)  ;CMIP6
iarr_SNC_SS(2,:) = (/min(SNC_SS),SNC_x25_SS,dim_median(SNC_SS),SNC_x75_SS,max(SNC_SS)/)
iarr_TEM_SS(2,:) = (/min(TEM_SS),TEM_x25_SS,dim_median(TEM_SS),TEM_x75_SS,max(TEM_SS)/)

; ;;;print(s;;;printf("%4.2g",iarr_NET_SS(2,4))+"~"+s;;;printf("%4.3g",iarr_NET_SS(2,0)))
; ;;;print(s;;;printf("%4.2g",iarr_SNC_SS(2,4))+"~"+s;;;printf("%4.3g",iarr_SNC_SS(2,0)))
; ;;;print(s;;;printf("%4.2g",iarr_TEM_SS(2,4))+"~"+s;;;printf("%4.3g",iarr_TEM_SS(2,0)))

; ;;;;;print(iarr_TEM_SS(2,:))

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
; print(NET_DS)
; print(SNC_DS)
; print(TEM_DS)

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
; ;print(NET_ERA5snow_DS)
; ;print(SNC_ERA5snow_DS)
; ;print(TEM_ERA5snow_DS)

;****************计算百分位数***************
;;cmip6
NET_x25_DS  := prctile(NET_DS,25)
NET_x75_DS  := prctile(NET_DS,75)

SNC_x25_DS  := prctile(SNC_DS,25)
SNC_x75_DS  := prctile(SNC_DS,75)

TEM_x25_DS  := prctile(TEM_DS,25)
TEM_x75_DS  := prctile(TEM_DS,75)

;*********************箱型图所需的变量************************************
iarr_NET_DS =new((/3,5/),double)
iarr_SNC_DS =new((/3,5/),double)
iarr_TEM_DS =new((/3,5/),double)

iarr_NET_DS(2,:) = (/min(NET_DS),NET_x25_DS,dim_median(NET_DS),NET_x75_DS,max(NET_DS)/)  ;CMIP6
iarr_SNC_DS(2,:) = (/min(SNC_DS),SNC_x25_DS,dim_median(SNC_DS),SNC_x75_DS,max(SNC_DS)/)
iarr_TEM_DS(2,:) = (/min(TEM_DS),TEM_x25_DS,dim_median(TEM_DS),TEM_x75_DS,max(TEM_DS)/)

; print(sprintf("%4.3g",avg(NET_SS))+"("+sprintf("%4.2g",max(NET_SS))+"~"+sprintf("%4.3g",min(NET_SS))+")")
; print(sprintf("%4.3g",avg(SNC_SS))+"("+sprintf("%4.2g",max(SNC_SS))+"~"+sprintf("%4.3g",min(SNC_SS))+")")
; print(sprintf("%4.3g",avg(TEM_SS))+"("+sprintf("%4.2g",max(TEM_SS))+"~"+sprintf("%4.3g",min(TEM_SS))+")")
;
; print(sprintf("%4.3g",avg(NET_DS))+"("+sprintf("%4.2g",max(NET_DS))+"~"+sprintf("%4.3g",min(NET_DS))+")")
; print(sprintf("%4.3g",avg(SNC_DS))+"("+sprintf("%4.2g",max(SNC_DS))+"~"+sprintf("%4.3g",min(SNC_DS))+")")
; print(sprintf("%4.3g",avg(TEM_DS))+"("+sprintf("%4.2g",max(TEM_DS))+"~"+sprintf("%4.3g",min(TEM_DS))+")")

;difference
NET_diff = NET_DS - NET_SS
SNC_diff = SNC_DS - SNC_SS
TEM_diff = TEM_DS - TEM_SS

NET_x25_diff  := prctile(NET_diff,25)
NET_x75_diff  := prctile(NET_diff,75)

SNC_x25_diff  := prctile(SNC_diff,25)
SNC_x75_diff  := prctile(SNC_diff,75)

TEM_x25_diff  := prctile(TEM_diff,25)
TEM_x75_diff  := prctile(TEM_diff,75)

iarr_NET_diff =new((/3,5/),double)
iarr_SNC_diff =new((/3,5/),double)
iarr_TEM_diff =new((/3,5/),double)

iarr_NET_diff(2,:) = (/min(NET_diff),NET_x25_diff,dim_median(NET_diff),NET_x75_diff,max(NET_diff)/)  ;CMIP6
iarr_SNC_diff(2,:) = (/min(SNC_diff),SNC_x25_diff,dim_median(SNC_diff),SNC_x75_diff,max(SNC_diff)/)
iarr_TEM_diff(2,:) = (/min(TEM_diff),TEM_x25_diff,dim_median(TEM_diff),TEM_x75_diff,max(TEM_diff)/)

; print(SNC_SS)
; print(SNC_DS)
; print(iarr_SNC_DS(2,:))

;**********再分析***********
NET_rea_SS = new(5,double)
SNC_rea_SS = new(5,double)
TEM_rea_SS = new(5,double)
printVarSummary(NET_ERA5_SS)

NET_rea_SS(0) = NET_ERA5_SS
NET_rea_SS(1) = NET_ERA5snow_SS
NET_rea_SS(2) = NET_JRA3Q_SS
NET_rea_SS(3) = NET_JRA55_SS
NET_rea_SS(4) = NET_MERRA2_SS

SNC_rea_SS(0) = SNC_ERA5_SS
SNC_rea_SS(1) = SNC_ERA5snow_SS
SNC_rea_SS(2) = SNC_JRA3Q_SS
SNC_rea_SS(3) = SNC_JRA55_SS
SNC_rea_SS(4) = SNC_MERRA2_SS

TEM_rea_SS(0) = TEM_ERA5_SS
TEM_rea_SS(1) = TEM_ERA5snow_SS
TEM_rea_SS(2) = TEM_JRA3Q_SS
TEM_rea_SS(3) = TEM_JRA55_SS
TEM_rea_SS(4) = TEM_MERRA2_SS

NET_rea_DS = new(5,double)
SNC_rea_DS = new(5,double)
TEM_rea_DS = new(5,double)

NET_rea_DS(0) = NET_ERA5_DS
NET_rea_DS(1) = NET_ERA5snow_DS
NET_rea_DS(2) = NET_JRA3Q_DS
NET_rea_DS(3) = NET_JRA55_DS
NET_rea_DS(4) = NET_MERRA2_DS

SNC_rea_DS(0) = SNC_ERA5_DS
SNC_rea_DS(1) = SNC_ERA5snow_DS
SNC_rea_DS(2) = SNC_JRA3Q_DS
SNC_rea_DS(3) = SNC_JRA55_DS
SNC_rea_DS(4) = SNC_MERRA2_DS

TEM_rea_DS(0) = TEM_ERA5_DS
TEM_rea_DS(1) = TEM_ERA5snow_DS
TEM_rea_DS(2) = TEM_JRA3Q_DS
TEM_rea_DS(3) = TEM_JRA55_DS
TEM_rea_DS(4) = TEM_MERRA2_DS

;**********表格数据***********
NET_all_avg = new(6,double)
NET_all_min = new(6,double)
NET_all_max = new(6,double)

SNC_all_avg = new(6,double)
SNC_all_min = new(6,double)
SNC_all_max = new(6,double)

TEM_all_avg = new(6,double)
TEM_all_min = new(6,double)
TEM_all_max = new(6,double)

;NET
NET_all_avg(0) = avg(NET_obs_SS)
NET_all_min(0) = min(NET_obs_SS)
NET_all_max(0) = max(NET_obs_SS)

NET_all_avg(1) = avg(NET_rea_SS)
NET_all_min(1) = min(NET_rea_SS)
NET_all_max(1) = max(NET_rea_SS)

NET_all_avg(2) = avg(NET_SS)
NET_all_min(2) = min(NET_SS)
NET_all_max(2) = max(NET_SS)

NET_all_avg(3) = avg(NET_obs_DS)
NET_all_min(3) = min(NET_obs_DS)
NET_all_max(3) = max(NET_obs_DS)

NET_all_avg(4) = avg(NET_rea_DS)
NET_all_min(4) = min(NET_rea_DS)
NET_all_max(4) = max(NET_rea_DS)

NET_all_avg(5) = avg(NET_DS)
NET_all_min(5) = min(NET_DS)
NET_all_max(5) = max(NET_DS)

;SNC
SNC_all_avg(0) = avg(SNC_obs_SS)
SNC_all_min(0) = min(SNC_obs_SS)
SNC_all_max(0) = max(SNC_obs_SS)

SNC_all_avg(1) = avg(SNC_rea_SS)
SNC_all_min(1) = min(SNC_rea_SS)
SNC_all_max(1) = max(SNC_rea_SS)

SNC_all_avg(2) = avg(SNC_SS)
SNC_all_min(2) = min(SNC_SS)
SNC_all_max(2) = max(SNC_SS)

SNC_all_avg(3) = avg(SNC_obs_DS)
SNC_all_min(3) = min(SNC_obs_DS)
SNC_all_max(3) = max(SNC_obs_DS)

SNC_all_avg(4) = avg(SNC_rea_DS)
SNC_all_min(4) = min(SNC_rea_DS)
SNC_all_max(4) = max(SNC_rea_DS)

SNC_all_avg(5) = avg(SNC_DS)
SNC_all_min(5) = min(SNC_DS)
SNC_all_max(5) = max(SNC_DS)

;TEM
TEM_all_avg(0) = avg(TEM_obs_SS)
TEM_all_min(0) = min(TEM_obs_SS)
TEM_all_max(0) = max(TEM_obs_SS)

TEM_all_avg(1) = avg(TEM_rea_SS)
TEM_all_min(1) = min(TEM_rea_SS)
TEM_all_max(1) = max(TEM_rea_SS)

TEM_all_avg(2) = avg(TEM_SS)
TEM_all_min(2) = min(TEM_SS)
TEM_all_max(2) = max(TEM_SS)

TEM_all_avg(3) = avg(TEM_obs_DS)
TEM_all_min(3) = min(TEM_obs_DS)
TEM_all_max(3) = max(TEM_obs_DS)

print(TEM_obs_DS)

TEM_all_avg(4) = avg(TEM_rea_DS)
TEM_all_min(4) = min(TEM_rea_DS)
TEM_all_max(4) = max(TEM_rea_DS)

TEM_all_avg(5) = avg(TEM_DS)
TEM_all_min(5) = min(TEM_DS)
TEM_all_max(5) = max(TEM_DS)

;*****************写成表格***************************
header  = [/"       ","       ", "NET","SNC","TEM"/]

strings  = (/"OBS","Reanalysis","CMIP6","OBS","Reanalysis","CMIP6"/)

alist   = [/strings,\
           NET_all_avg,NET_all_min,NET_all_max,\
           SNC_all_avg,SNC_all_min,SNC_all_max,\
           TEM_all_avg,TEM_all_min,TEM_all_max/]

write_table(outpath+name, "w", header, "%s %s %s %s %s ")
write_table(outpath+name, "a", alist, "%s %.2f(%.2f,%.2f) %.2f(%.2f,%.2f) %.2f(%.2f,%.2f)")

end
