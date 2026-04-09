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

M=(/"AM_0.25_misstoc/","MA_0.25_misstoc/","MJ_0.25_misstoc/"/)

wks = gsn_open_wks("pdf",outpath+"Figure_2")

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
print(NET_SS)
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
print(TEM_DS)

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

print(SNC_obs_DS(:,:,0))
print(SNC_obs_DS(:,:,2))

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

print(SNC_SS)
print(SNC_DS)
print(iarr_SNC_DS(2,:))
;******************设置xy-plot***************************
color_GLASS    = "175"
color_clara_a3 = "2"
color_clara_a2 = "forestgreen"
color_APPx     = "deeppink2";"sienna4"

color_ERA5     = (/"sienna4"/)
color_ERA5snow = (/"blue3"/)
color_MERRA2   = (/"springgreen3"/)
color_JRA55    = (/"magenta"/)
color_JRA3Q    = (/"250"/)

color_mean     = "red"

mark_GHCN = (/16,10,11/)
mark_CRU  = (/4,7,8/)

x = (/-0.6, 0., 0.6/)

x_obs = x(0)
res = True

;res@gsnMaximize = True
res@trXMinF          = -0.9
res@trXMaxF          = 0.9

; res@tmXBMode   = "Manual"
; res@tmXBTickStartF   = -0.4
; res@tmXBTickEndF     = 0.4
; res@tmXBTickSpacingF = 0.4
res@tmXBLabels = (/"OBS","Reanalysis","CMIP6"/)

res@vpWidthF         = 0.18   ;图形宽度
res@vpHeightF        = 0.25   ;图形宽度

; res@trYReverse       = True
res@tmYRBorderOn     = True
res@tmXTBorderOn     = True

res@tmYLMajorLengthF = -0.006     ;y轴大刻度长度，负值朝外
res@tmXBMajorLengthF = -0.006     ;x轴大刻度长度，负值朝外
res@tmYLMinorLengthF = -0.003      ;小刻度长度
res@tmYLMajorThicknessF = 1.5        ;大刻度线宽
res@tmXBMajorThicknessF = 1.5        ;大刻度线宽
res@tmYLMinorThicknessF = 0.9        ;小刻度线宽

res@tmXBLabelFontHeightF = 0.01    ;字号
res@tmYLLabelFontHeightF = 0.01
res@tiYAxisFontHeightF   = 0.015
res@tiMainFontHeightF    = 0.015
;********************设置箱形图上下的两条线*******************
llres = True
llres@gsLineThicknessF = 1.6
;*********************设置箱子的颜色和宽度*********************
opti = True
opti@boxWidth  = 0.3
opti@boxColors = (/"black","black","black"/)

;***************模式箱型图*************
;;*******第一列***********
res@trYReverse       = False
res@tmYLPrecision    = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

YMin_SS    = -2.1
YMax_SS    = 0.6
YLStart_SS = -2.
YLSpace_SS = 0.5
YLEnd_SS   = 0.5

YMin_DS    = -2.1
YMax_DS    = 0.6
YLStart_DS = -2.
YLSpace_DS = 0.5
YLEnd_DS   = 0.5

YMin_diff    = -1.5
YMax_diff    = 1.5
YLStart_diff = -1.5
YLSpace_diff = 0.5
YLEnd_diff   = 1.5

;seasonal
res@trYMinF          = YMin_SS
res@trYMaxF          = YMax_SS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_SS
res@tmYLTickSpacingF = YLSpace_SS
res@tmYLTickEndF     = YLEnd_SS

res@tiYAxisString     = "Seasonal"
res@tiMainString      = "SAF~B~NET~N~ (%/K)"
plot1 = boxplot(wks,x,iarr_NET_SS,opti,res,llres) ;seasonal

;decadal
res@trYMinF          = YMin_DS
res@trYMaxF          = YMax_DS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_DS
res@tmYLTickSpacingF = YLSpace_DS
res@tmYLTickEndF     = YLEnd_DS

res@tiYAxisString     = "Decadal"
res@tiMainOn          = False
plot4 = boxplot(wks,x,iarr_NET_DS,opti,res,llres) ;decadal

;difference
res@trYMinF          = YMin_diff
res@trYMaxF          = YMax_diff
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_diff
res@tmYLTickSpacingF = YLSpace_diff
res@tmYLTickEndF     = YLEnd_diff

res@tiYAxisString     = "Decadal~V11F33~ _ ~V-11~~F~Seasonal"
res@tiMainOn          = False
plot7 = boxplot(wks,x,iarr_NET_diff,opti,res,llres) ;decadal

;;*******第二列***********
res@tmYLPrecision    = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

res@tiYAxisOn        = False

;seasonal
res@trYMinF          = YMin_SS
res@trYMaxF          = YMax_SS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_SS
res@tmYLTickSpacingF = YLSpace_SS
res@tmYLTickEndF     = YLEnd_SS

res@tiMainOn         = True
res@tiMainString      = "SAF~B~SNC~N~ (%/K)"
plot2 = boxplot(wks,x,iarr_SNC_SS,opti,res,llres)

;decadal
res@trYMinF          = YMin_DS
res@trYMaxF          = YMax_DS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_DS
res@tmYLTickSpacingF = YLSpace_DS
res@tmYLTickEndF     = YLEnd_DS

res@tiMainOn          = False
plot5 = boxplot(wks,x,iarr_SNC_DS,opti,res,llres)

;difference
res@trYMinF          = YMin_diff
res@trYMaxF          = YMax_diff
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_diff
res@tmYLTickSpacingF = YLSpace_diff
res@tmYLTickEndF     = YLEnd_diff

res@tiMainOn          = False
plot8 = boxplot(wks,x,iarr_SNC_diff,opti,res,llres) ;decadal

;;*******第三列***********
res@tmYLPrecision    = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

;seasonal
res@trYMinF          = YMin_SS
res@trYMaxF          = YMax_SS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_SS
res@tmYLTickSpacingF = YLSpace_SS
res@tmYLTickEndF     = YLEnd_SS

res@tiMainOn          = True
res@tiMainString      = "SAF~B~TEM~N~ (%/K)"
plot3 = boxplot(wks,x,iarr_TEM_SS,opti,res,llres)

;decadal
res@trYMinF          = YMin_DS
res@trYMaxF          = YMax_DS
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_DS
res@tmYLTickSpacingF = YLSpace_DS
res@tmYLTickEndF     = YLEnd_DS

res@tiMainOn          = False
plot6 = boxplot(wks,x,iarr_TEM_DS,opti,res,llres)

;difference
res@trYMinF          = YMin_diff
res@trYMaxF          = YMax_diff
res@tmYLMode         = "Manual"
res@tmYLTickStartF   = YLStart_diff
res@tmYLTickSpacingF = YLSpace_diff
res@tmYLTickEndF     = YLEnd_diff

res@tiMainOn          = False
plot9 = boxplot(wks,x,iarr_TEM_diff,opti,res,llres) ;decadal

;************模式平均值**********
mres = True
mres@gsMarkerIndex = 9
mres@gsMarkerSizeF = 9.0
mres@gsMarkerColor = "black"

;;cmip6
;seaslnal
NET_avg := avg(NET_SS)                       ; polymarker locations
SNC_avg := avg(SNC_SS)
TEM_avg := avg(TEM_SS)
; ;;;;;print(TEM_avg)

dum4_SS = gsn_add_polymarker(wks,plot1,x(2),NET_avg,mres)
dum5_SS = gsn_add_polymarker(wks,plot2,x(2),SNC_avg,mres)
dum6_SS = gsn_add_polymarker(wks,plot3,x(2),TEM_avg,mres)

;decadal
NET_avg := avg(NET_DS)                       ; polymarker locations
SNC_avg := avg(SNC_DS)
TEM_avg := avg(TEM_DS)
; ;;;;;print(NET_avg)
; ;;;;;print(SNC_avg)
; ;;;;;print(TEM_avg)

dum4_DS = gsn_add_polymarker(wks,plot4,x(2),NET_avg,mres)
dum5_DS = gsn_add_polymarker(wks,plot5,x(2),SNC_avg,mres)
dum6_DS = gsn_add_polymarker(wks,plot6,x(2),TEM_avg,mres)

;difference
NET_avg := avg(NET_diff)                       ; polymarker locations
SNC_avg := avg(SNC_diff)
TEM_avg := avg(TEM_diff)

dum7_diff = gsn_add_polymarker(wks,plot7,x(2),NET_avg,mres)
dum8_diff = gsn_add_polymarker(wks,plot8,x(2),SNC_avg,mres)
dum9_diff = gsn_add_polymarker(wks,plot9,x(2),TEM_avg,mres)

;**************画再分析***********
NET_rea_SS = new(5,float)
SNC_rea_SS = new(5,float)
TEM_rea_SS = new(5,float)

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

NET_rea_DS = new(5,float)
SNC_rea_DS = new(5,float)
TEM_rea_DS = new(5,float)

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
; print(TEM_JRA3Q_SS)

colors_rea = (/color_ERA5,color_ERA5snow,color_JRA3Q,color_JRA55,color_MERRA2/)
mres2 = True
mres2@gsMarkerIndex = 2
mres2@gsMarkerSizeF = 11.
mres2@gsMarkerThicknessF = 1.9

dum_rea_1_SS = new(5,graphic)
dum_rea_2_SS = new(5,graphic)
dum_rea_3_SS = new(5,graphic)

dum_rea_1_DS = new(5,graphic)
dum_rea_2_DS = new(5,graphic)
dum_rea_3_DS = new(5,graphic)

dum_rea_1_diff = new(5,graphic)
dum_rea_2_diff = new(5,graphic)
dum_rea_3_diff = new(5,graphic)

NET_rea_diff = NET_rea_DS - NET_rea_SS
SNC_rea_diff = SNC_rea_DS - SNC_rea_SS
TEM_rea_diff = TEM_rea_DS - TEM_rea_SS

do i = 0,4
  mres2@gsMarkerColor = colors_rea(i)

  dum_rea_1_SS(i) = gsn_add_polymarker(wks,plot1,x(1),NET_rea_SS(i),mres2)
  dum_rea_2_SS(i) = gsn_add_polymarker(wks,plot2,x(1),SNC_rea_SS(i),mres2)
  dum_rea_3_SS(i) = gsn_add_polymarker(wks,plot3,x(1),TEM_rea_SS(i),mres2)

  dum_rea_1_DS(i) = gsn_add_polymarker(wks,plot4,x(1),NET_rea_DS(i),mres2)
  dum_rea_2_DS(i) = gsn_add_polymarker(wks,plot5,x(1),SNC_rea_DS(i),mres2)
  dum_rea_3_DS(i) = gsn_add_polymarker(wks,plot6,x(1),TEM_rea_DS(i),mres2)

  dum_rea_1_diff(i) = gsn_add_polymarker(wks,plot7,x(1),NET_rea_diff(i),mres2)
  dum_rea_2_diff(i) = gsn_add_polymarker(wks,plot8,x(1),SNC_rea_diff(i),mres2)
  dum_rea_3_diff(i) = gsn_add_polymarker(wks,plot9,x(1),TEM_rea_diff(i),mres2)
end do

;**********再分析 avg***********
mres2@gsMarkerIndex = 5
mres2@gsMarkerColor := color_mean
mres2@gsMarkerSizeF = 12.
mres2@gsMarkerThicknessF = 2.2

NET_avg_SS = avg(NET_rea_SS)
SNC_avg_SS = avg(SNC_rea_SS)
TEM_avg_SS = avg(TEM_rea_SS)

NET_avg_DS = avg(NET_rea_DS)
SNC_avg_DS = avg(SNC_rea_DS)
TEM_avg_DS = avg(TEM_rea_DS)

NET_avg_diff = NET_avg_DS - NET_avg_SS
SNC_avg_diff = SNC_avg_DS - SNC_avg_SS
TEM_avg_diff = TEM_avg_DS - TEM_avg_SS


dum_rea_17_SS = gsn_add_polymarker(wks,plot1,x(1),NET_avg_SS,mres2)
dum_rea_27_SS = gsn_add_polymarker(wks,plot2,x(1),SNC_avg_SS,mres2)
dum_rea_37_SS = gsn_add_polymarker(wks,plot3,x(1),TEM_avg_SS,mres2)

dum_rea_17_DS = gsn_add_polymarker(wks,plot4,x(1),NET_avg_DS,mres2)
dum_rea_27_DS = gsn_add_polymarker(wks,plot5,x(1),SNC_avg_DS,mres2)
dum_rea_37_DS = gsn_add_polymarker(wks,plot6,x(1),TEM_avg_DS,mres2)

dum_rea_17_diff = gsn_add_polymarker(wks,plot7,x(1),NET_avg_diff,mres2)
dum_rea_27_diff = gsn_add_polymarker(wks,plot8,x(1),SNC_avg_diff,mres2)
dum_rea_37_diff = gsn_add_polymarker(wks,plot9,x(1),TEM_avg_diff,mres2)

;**************************************
;***************画观测 ***************
colors_obs = (/color_APPx,color_clara_a2,color_clara_a3/)

mres3 = True
mres3@gsMarkerSizeF = 9.
mres3@gsMarkerThicknessF = 1.9

dum_obs_1_SS = new(3,graphic)
dum_obs_2_SS = new(3,graphic)
dum_obs_3_SS = new(3,graphic)

dum_obs_1_DS = new(3,graphic)
dum_obs_2_DS = new(3,graphic)
dum_obs_3_DS = new(3,graphic)

dum_obs_1_diff = new(3,graphic)
dum_obs_2_diff = new(3,graphic)
dum_obs_3_diff = new(3,graphic)

NET_obs_SS_avg = dim_avg_n(NET_obs_SS,(/0,1/))
SNC_obs_SS_avg = dim_avg_n(SNC_obs_SS,(/0,1/))
TEM_obs_SS_avg = dim_avg_n(TEM_obs_SS,(/0,1/))

NET_obs_DS_avg = dim_avg_n(NET_obs_DS,(/0,1/))
SNC_obs_DS_avg = dim_avg_n(SNC_obs_DS,(/0,1/))
TEM_obs_DS_avg = dim_avg_n(TEM_obs_DS,(/0,1/))

NET_obs_diff = NET_obs_DS_avg - NET_obs_SS_avg
SNC_obs_diff = SNC_obs_DS_avg - SNC_obs_SS_avg
TEM_obs_diff = TEM_obs_DS_avg - TEM_obs_SS_avg

do j = 0,2   ;alb
  mres3@gsMarkerIndex = 4
  mres3@gsMarkerColor = colors_obs(j)

  dum_obs_1_SS(j) = gsn_add_polymarker(wks,plot1,x_obs,NET_obs_SS_avg(j),mres3)
  dum_obs_2_SS(j) = gsn_add_polymarker(wks,plot2,x_obs,SNC_obs_SS_avg(j),mres3)
  dum_obs_3_SS(j) = gsn_add_polymarker(wks,plot3,x_obs,TEM_obs_SS_avg(j),mres3)

  dum_obs_1_DS(j) = gsn_add_polymarker(wks,plot4,x_obs,NET_obs_DS_avg(j),mres3)
  dum_obs_2_DS(j) = gsn_add_polymarker(wks,plot5,x_obs,SNC_obs_DS_avg(j),mres3)
  dum_obs_3_DS(j) = gsn_add_polymarker(wks,plot6,x_obs,TEM_obs_DS_avg(j),mres3)

  dum_obs_1_diff(j) = gsn_add_polymarker(wks,plot7,x_obs,NET_obs_diff(j),mres3)
  dum_obs_2_diff(j) = gsn_add_polymarker(wks,plot8,x_obs,SNC_obs_diff(j),mres3)
  dum_obs_3_diff(j) = gsn_add_polymarker(wks,plot9,x_obs,TEM_obs_diff(j),mres3)
end do

;**********观测 avg***********
mres3@gsMarkerIndex = 5
mres3@gsMarkerColor = color_mean
mres3@gsMarkerSizeF = 12.
mres3@gsMarkerThicknessF = 2.2

NET_avg_SS := avg(NET_obs_SS)
SNC_avg_SS := avg(SNC_obs_SS)
TEM_avg_SS := avg(TEM_obs_SS)

NET_avg_DS := avg(NET_obs_DS)
SNC_avg_DS := avg(SNC_obs_DS)
TEM_avg_DS := avg(TEM_obs_DS)

NET_avg_diff := NET_avg_DS - NET_avg_SS
SNC_avg_diff := SNC_avg_DS - SNC_avg_SS
TEM_avg_diff := TEM_avg_DS - TEM_avg_SS

dum_obs_SS_avg_1 = gsn_add_polymarker(wks,plot1,x(0),NET_avg_SS,mres3)
dum_obs_SS_avg_2 = gsn_add_polymarker(wks,plot2,x(0),SNC_avg_SS,mres3)
dum_obs_SS_avg_3 = gsn_add_polymarker(wks,plot3,x(0),TEM_avg_SS,mres3)

dum_obs_DS_avg_1 = gsn_add_polymarker(wks,plot4,x(0),NET_avg_DS,mres3)
dum_obs_DS_avg_2 = gsn_add_polymarker(wks,plot5,x(0),SNC_avg_DS,mres3)
dum_obs_DS_avg_3 = gsn_add_polymarker(wks,plot6,x(0),TEM_avg_DS,mres3)

dum_obs_diff_avg_1 = gsn_add_polymarker(wks,plot7,x(0),NET_avg_diff,mres3)
dum_obs_diff_avg_2 = gsn_add_polymarker(wks,plot8,x(0),SNC_avg_diff,mres3)
dum_obs_diff_avg_3 = gsn_add_polymarker(wks,plot9,x(0),TEM_avg_diff,mres3)


;*******************************legend*****************************
index = (/4,4,4,4,5/)

y = fspan(0.87,0.6,10)+0.05
; print(y)

xleg := (/0.14,0.14,0.14,0.14,0.14/)+0.7 ; legend markers位置
xtxt := (/0.119,0.137,0.137,0.123,0.122/)+0.057+0.7 ;
yleg := y(0:2)   ; text位置
ytxt := y(0:2)   ;

colors := (/color_APPx,color_clara_a2,color_clara_a3,color_GLASS,color_mean/)

labels := (/"APP-x","CLARA-A2","CLARA-A3"/)

do i = 0,2
  gsres               = True
  gsres@gsMarkerIndex = index(i)          ; Use filled dots for markers.
  gsres@gsMarkerSizeF = 11.
  gsres@gsMarkerThicknessF = 3.0
  gsres@gsMarkerColor = colors(i)

  txres               = True
  txres@txFontHeightF = 0.013
  ; txres@txPerimOn  =True
  ; txres@txPerimSpaceF  = 1

  gsn_polymarker_ndc(wks,xleg(i),yleg(i),gsres)
  gsn_text_ndc(wks,labels(i),xtxt(i),ytxt(i),txres)
end do

;*******************************legend*****************************
index := (/2,2,2,2,2,5/)

xleg := (/0.14,0.14,0.14,0.14,0.14,0.14/)+0.7 ; legend markers位置
xtxt := (/0.14,0.142,0.126,0.125,0.134,0.117/)+0.057+0.7 ;
yleg := y(3:8)   ; text位置
ytxt := y(3:8)   ;

colors := (/color_ERA5,color_ERA5snow,color_JRA3Q,color_JRA55,color_MERRA2,color_mean/)

labels := (/"ERA5-Land","ERA5-Snow","JRA-3Q","JRA-55","MERRA-2","Mean"/)

do i = 0,5
  gsres               = True
  gsres@gsMarkerIndex = index(i)          ; Use filled dots for markers.
  gsres@gsMarkerSizeF = 11.
  gsres@gsMarkerThicknessF = 3.0
  gsres@gsMarkerColor = colors(i)

  txres               = True
  txres@txFontHeightF = 0.013
  ; txres@txPerimOn  =True
  ; txres@txPerimSpaceF  = 1

  gsn_polymarker_ndc(wks,xleg(i),yleg(i),gsres)
  gsn_text_ndc(wks,labels(i),xtxt(i),ytxt(i),txres)
end do

;**********************************************************
 pres = True
; pres@txString = "albedo("+ymStrt+"-"+ymLast+")"
; pres@gsnPanelMainFontHeightF     = 0.015
 ; pres@gsnPanelXWhiteSpacePercent  = 0       ;留白
; pres@gsnPanelYWhiteSpacePercent  = 0

pres@gsnPanelFigureStrings        = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)"/)
pres@gsnPanelFigureStringsJust    = "TopLeft"
pres@gsnPanelFigureStringsPerimOn = False
pres@gsnPanelFigureStringsFontHeightF = 0.013

YF = fspan(0.93,0.29,3)
pres@gsnPanelYF = (/YF(0),YF(0),YF(0),\
                    YF(1),YF(1),YF(1),\
                    YF(2),YF(2),YF(2)/)

XF = fspan(0.09,0.61,3)
pres@gsnPanelXF = (/XF(0),XF(1),XF(2),\
                    XF(0),XF(1),XF(2),\
                    XF(0),XF(1),XF(2)/)

gsn_panel(wks,(/plot1,plot2,plot3,plot4,plot5,plot6,plot7,plot8,plot9/),(/3,3/),pres)

end
