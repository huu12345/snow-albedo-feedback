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

wks = gsn_open_wks("pdf",outpath+"Figure_9")

n_model6 = dimsizes(model6)
print(model6)

;***************************************************************
;***************************seasonal****************************
;*******************读取CMIP6*************
snow_cmip6_season     = new(3,"double")
d_tas_cmip6_season    = new(3,"double")
k5_cmip6_season       = new(3,"double")
d_alsnow_cmip6_season = new(3,"double")

snow_SS     = new(n_model6,double)
d_tas_SS    = new(n_model6,double)
k5_SS       = new(n_model6,double)
d_alsnow_SS = new(n_model6,double)

do i = 0,n_model6-1
  do j = 0,2
    files_snow_cmip6    := systemfunc("ls "+inpath_model_SS+M(j)+"mean_snow.*"+model6(i)+".*aa.nc")
    files_d_tas_cmip6   := systemfunc("ls "+inpath_model_SS+M(j)+"delta_tas.*"+model6(i)+".*aa.nc")
    files_k5_cmip6      := systemfunc("ls "+inpath_model_SS+M(j)+"k5.*"+model6(i)+".*aa.nc")
    files_d_alsnow_cmip6:= systemfunc("ls "+inpath_model_SS+M(j)+"delta_alpha_snow.*"+model6(i)+".*aa.nc")

    f_snow_cmip6     = addfiles(files_snow_cmip6,"r")
    f_d_tas_cmip6    = addfiles(files_d_tas_cmip6,"r")
    f_k5_cmip6       = addfiles(files_k5_cmip6,"r")
    f_d_alsnow_cmip6 = addfiles(files_d_alsnow_cmip6,"r")

    snow_cmip6_season(j)    = f_snow_cmip6[:]->snc(0,0,0)
    d_tas_cmip6_season(j)   = f_d_tas_cmip6[:]->tas(0,0,0)
    k5_cmip6_season(j)      = f_k5_cmip6[:]->k5(0,0,0)
    d_alsnow_cmip6_season(j)= f_d_alsnow_cmip6[:]->delta_alpha_snow(0,0,0)
  end do

  snow_SS(i)     = avg(snow_cmip6_season)*100.0
  d_tas_SS(i)    = avg(d_tas_cmip6_season)
  k5_SS(i)       = avg(k5_cmip6_season)
  d_alsnow_SS(i) = avg(d_alsnow_cmip6_season)
end do
; ;printVarSummary(mean_snow)
; print(k5_SS)
; qsort(d_alsnow_SS)
; print(d_alsnow_SS)
;
; a1 = avg(snow_SS(18:20))
; ;print(a1)

;**************************************
;**************读取观测************
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3","GLASS"/)

snow_obs_SS     = new((/2,3,3/),"double")
d_tas_obs_SS    = new((/2,3,3/),"double")
k5_obs_SS       = new((/2,3,3/),"double")
d_alsnow_obs_SS = new((/2,3,3/),"double")

do m = 0,1
  do n = 0,2
    do k= 0,2
      snow_season_obs     = new(3,"double")
      d_tas_season_obs    = new(3,"double")
      k5_season_obs       = new(3,"double")
      d_alsnow_season_obs = new(3,"double")

      do j = 0,2
         f_snow_obs    = addfile(inpath_OBS_SS+M(j)+"mean_snow.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
         f_d_tas_obs   = addfile(inpath_OBS_SS+M(j)+"delta_tas.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
         f_k5_obs      = addfile(inpath_OBS_SS+M(j)+"k5.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
         f_d_alsnow_obs= addfile(inpath_OBS_SS+M(j)+"delta_alpha_snow.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")

         snow_season_obs(j)     = f_snow_obs->snc(0,0,0)
         d_tas_season_obs(j)    = f_d_tas_obs->tas(0,0,0)
         k5_season_obs(j)       = f_k5_obs->k5(0,0,0)
         d_alsnow_season_obs(j) = f_d_alsnow_obs->delta_alpha_snow(0,0,0)
      end do

      snow_obs_SS(m,n,k)     = avg(snow_season_obs)*100.0
      d_tas_obs_SS(m,n,k)    = avg(d_tas_season_obs)
      k5_obs_SS(m,n,k)       = avg(k5_season_obs)
      d_alsnow_obs_SS(m,n,k) = avg(d_alsnow_season_obs)

    end do
  end do
end do


;****************读取ERA5-Land**************
snow_season_ERA5     = new(3,"double")
d_tas_season_ERA5    = new(3,"double")
k5_season_ERA5       = new(3,"double")
d_alsnow_season_ERA5 = new(3,"double")

do j = 0,2
   f_snow_obs     := addfile(inpath_ERA5_SS+M(j)+"mean_snow.ERA5-Land2.EASE_grid.aa.nc","r")
   f_d_tas_obs    := addfile(inpath_ERA5_SS+M(j)+"delta_tas.ERA5-Land2.EASE_grid.aa.nc","r")
   f_k5_obs       := addfile(inpath_ERA5_SS+M(j)+"k5.ERA5-Land2.EASE_grid.aa.nc","r")
   f_d_alsnow_obs := addfile(inpath_ERA5_SS+M(j)+"delta_alpha_snow.ERA5-Land2.EASE_grid.aa.nc","r")

   snow_cmip5_season_1    := f_snow_obs->snc(0,0,0)
   d_tas_cmip5_season_1   := f_d_tas_obs->tas(0,0,0)
   k5_cmip5_season_1      := f_k5_obs->k5(0,0,0)
   d_alsnow_cmip5_season_1:= f_d_alsnow_obs->delta_alpha_snow(0,0,0)

   snow_season_ERA5(j)     = avg(snow_cmip5_season_1)*100.0
   d_tas_season_ERA5(j)    = avg(d_tas_cmip5_season_1)
   k5_season_ERA5(j)       = avg(k5_cmip5_season_1)
   d_alsnow_season_ERA5(j) = avg(d_alsnow_cmip5_season_1)
end do

snow_ERA5_SS     = avg(snow_season_ERA5)
d_tas_ERA5_SS    = avg(d_tas_season_ERA5)
k5_ERA5_SS       = avg(k5_season_ERA5)
d_alsnow_ERA5_SS = avg(d_alsnow_season_ERA5)

;****************读取MERRA2**************
snow_season_MERRA2     = new(3,"double")
d_tas_season_MERRA2    = new(3,"double")
k5_season_MERRA2       = new(3,"double")
d_alsnow_season_MERRA2 = new(3,"double")

do j = 0,2
   f_snow_obs     := addfile(inpath_MERRA2_SS+M(j)+"mean_snow.MERRA22.EASE_grid.aa.nc","r")
   f_d_tas_obs    := addfile(inpath_MERRA2_SS+M(j)+"delta_tas.MERRA22.EASE_grid.aa.nc","r")
   f_k5_obs       := addfile(inpath_MERRA2_SS+M(j)+"k5.MERRA22.EASE_grid.aa.nc","r")
   f_d_alsnow_obs := addfile(inpath_MERRA2_SS+M(j)+"delta_alpha_snow.MERRA22.EASE_grid.aa.nc","r")

   snow_cmip5_season_1    := f_snow_obs->snc(0,0,0)
   d_tas_cmip5_season_1   := f_d_tas_obs->tas(0,0,0)
   k5_cmip5_season_1      := f_k5_obs->k5(0,0,0)
   d_alsnow_cmip5_season_1:= f_d_alsnow_obs->delta_alpha_snow(0,0,0)

   snow_season_MERRA2(j)     = avg(snow_cmip5_season_1)*100.0
   d_tas_season_MERRA2(j)    = avg(d_tas_cmip5_season_1)
   k5_season_MERRA2(j)       = avg(k5_cmip5_season_1)
   d_alsnow_season_MERRA2(j) = avg(d_alsnow_cmip5_season_1)
end do

snow_MERRA2_SS     = avg(snow_season_MERRA2)
d_tas_MERRA2_SS    = avg(d_tas_season_MERRA2)
k5_MERRA2_SS       = avg(k5_season_MERRA2)
d_alsnow_MERRA2_SS = avg(d_alsnow_season_MERRA2)

;****************读取JRA55**************
snow_season_JRA55     = new(3,"double")
d_tas_season_JRA55    = new(3,"double")
k5_season_JRA55       = new(3,"double")
d_alsnow_season_JRA55 = new(3,"double")

do j = 0,2
   f_snow_obs     := addfile(inpath_JRA55_SS+M(j)+"mean_snow.JRA552.EASE_grid.aa.nc","r")
   f_d_tas_obs    := addfile(inpath_JRA55_SS+M(j)+"delta_tas.JRA552.EASE_grid.aa.nc","r")
   f_k5_obs       := addfile(inpath_JRA55_SS+M(j)+"k5.JRA552.EASE_grid.aa.nc","r")
   f_d_alsnow_obs := addfile(inpath_JRA55_SS+M(j)+"delta_alpha_snow.JRA552.EASE_grid.aa.nc","r")

   snow_cmip5_season_1    := f_snow_obs->snc(0,0,0)
   d_tas_cmip5_season_1   := f_d_tas_obs->tas(0,0,0)
   k5_cmip5_season_1      := f_k5_obs->k5(0,0,0)
   d_alsnow_cmip5_season_1:= f_d_alsnow_obs->delta_alpha_snow(0,0,0)

   snow_season_JRA55(j)     = avg(snow_cmip5_season_1)*100.0
   d_tas_season_JRA55(j)    = avg(d_tas_cmip5_season_1)
   k5_season_JRA55(j)       = avg(k5_cmip5_season_1)
   d_alsnow_season_JRA55(j) = avg(d_alsnow_cmip5_season_1)
end do

snow_JRA55_SS     = avg(snow_season_JRA55)
d_tas_JRA55_SS    = avg(d_tas_season_JRA55)
k5_JRA55_SS       = avg(k5_season_JRA55)
d_alsnow_JRA55_SS = avg(d_alsnow_season_JRA55)

;****************读取JRA3Q**************
snow_season_JRA3Q     = new(3,"double")
d_tas_season_JRA3Q    = new(3,"double")
k5_season_JRA3Q       = new(3,"double")
d_alsnow_season_JRA3Q = new(3,"double")

do j = 0,2
   f_snow_obs     := addfile(inpath_JRA3Q_SS+M(j)+"mean_snow.JRA3Q2.EASE_grid.aa.nc","r")
   f_d_tas_obs    := addfile(inpath_JRA3Q_SS+M(j)+"delta_tas.JRA3Q2.EASE_grid.aa.nc","r")
   f_k5_obs       := addfile(inpath_JRA3Q_SS+M(j)+"k5.JRA3Q2.EASE_grid.aa.nc","r")
   f_d_alsnow_obs := addfile(inpath_JRA3Q_SS+M(j)+"delta_alpha_snow.JRA3Q2.EASE_grid.aa.nc","r")

   snow_cmip5_season_1    := f_snow_obs->snc(0,0,0)
   d_tas_cmip5_season_1   := f_d_tas_obs->tas(0,0,0)
   k5_cmip5_season_1      := f_k5_obs->k5(0,0,0)
   d_alsnow_cmip5_season_1:= f_d_alsnow_obs->delta_alpha_snow(0,0,0)

   snow_season_JRA3Q(j)     = avg(snow_cmip5_season_1)*100.0
   d_tas_season_JRA3Q(j)    = avg(d_tas_cmip5_season_1)
   k5_season_JRA3Q(j)       = avg(k5_cmip5_season_1)
   d_alsnow_season_JRA3Q(j) = avg(d_alsnow_cmip5_season_1)
end do

snow_JRA3Q_SS     = avg(snow_season_JRA3Q)
d_tas_JRA3Q_SS    = avg(d_tas_season_JRA3Q)
k5_JRA3Q_SS       = avg(k5_season_JRA3Q)
d_alsnow_JRA3Q_SS = avg(d_alsnow_season_JRA3Q)

;****************读取ERA5snow**************
snow_season_ERA5snow    = new(3,"double")
d_tas_season_ERA5snow   = new(3,"double")
k5_season_ERA5snow      = new(3,"double")
d_alsnow_season_ERA5snow= new(3,"double")

do j = 0,2
   f_snow_obs     := addfile(inpath_ERA5snow_SS+M(j)+"mean_snow.ERA5snow2.EASE_grid.aa.nc","r")
   f_d_tas_obs    := addfile(inpath_ERA5snow_SS+M(j)+"delta_tas.ERA5snow2.EASE_grid.aa.nc","r")
   f_k5_obs       := addfile(inpath_ERA5snow_SS+M(j)+"k5.ERA5snow2.EASE_grid.aa.nc","r")
   f_d_alsnow_obs := addfile(inpath_ERA5snow_SS+M(j)+"delta_alpha_snow.ERA5snow2.EASE_grid.aa.nc","r")

   snow_cmip5_season_1    := f_snow_obs->snc(0,0,0)
   d_tas_cmip5_season_1   := f_d_tas_obs->tas(0,0,0)
   k5_cmip5_season_1      := f_k5_obs->k5(0,0,0)
   d_alsnow_cmip5_season_1:= f_d_alsnow_obs->delta_alpha_snow(0,0,0)

   snow_season_ERA5snow(j)     = avg(snow_cmip5_season_1)*100.0
   d_tas_season_ERA5snow(j)    = avg(d_tas_cmip5_season_1)
   k5_season_ERA5snow(j)       = avg(k5_cmip5_season_1)
   d_alsnow_season_ERA5snow(j) = avg(d_alsnow_cmip5_season_1)
end do

snow_ERA5snow_SS     = avg(snow_season_ERA5snow)
d_tas_ERA5snow_SS    = avg(d_tas_season_ERA5snow)
k5_ERA5snow_SS       = avg(k5_season_ERA5snow)
d_alsnow_ERA5snow_SS = avg(d_alsnow_season_ERA5snow)

; print(snow_ERA5snow_SS)
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
snow_x25_SS  = prctile(snow_SS,25)
snow_x75_SS  = prctile(snow_SS,75)

d_tas_x25_SS  = prctile(d_tas_SS,25)
d_tas_x75_SS  = prctile(d_tas_SS,75)

k5_x25_SS  = prctile(k5_SS,25)
k5_x75_SS  = prctile(k5_SS,75)

d_alsnow_x25_SS  = prctile(d_alsnow_SS,25)
d_alsnow_x75_SS  = prctile(d_alsnow_SS,75)
; ;*******************计算上下边界********************
; qsort(snow_SS)
; qsort(d_tas_SS)
; qsort(k5_SS)
; qsort(d_alsnow_SS)
;
; snow_d_SS = snow_x25_SS - (snow_x75_SS - snow_x25_SS)*1.5  ;box的下边界
; snow_u_SS = snow_x75_SS + (snow_x75_SS - snow_x25_SS)*1.5  ;box的上边界
; snow_nor_SS = mask(snow_SS,snow_SS.lt.snow_d_SS .or. snow_SS.gt.snow_u_SS,False)  ;位于box外的异常数据
;
; d_tas_d_SS = d_tas_x25_SS - (d_tas_x75_SS - d_tas_x25_SS)*1.5
; d_tas_u_SS = d_tas_x75_SS + (d_tas_x75_SS - d_tas_x25_SS)*1.5
; d_tas_nor_SS = mask(d_tas_SS,d_tas_SS.lt.d_tas_d_SS .or. d_tas_SS.gt.d_tas_u_SS,False)
;
; k5_d_SS = k5_x25_SS - (k5_x75_SS - k5_x25_SS)*1.5
; k5_u_SS = k5_x75_SS + (k5_x75_SS - k5_x25_SS)*1.5
; k5_nor_SS = mask(k5_SS,k5_SS.lt.k5_d_SS .or. k5_SS.gt.k5_u_SS,False)
;
; d_alsnow_d_SS = d_alsnow_x25_SS - (d_alsnow_x75_SS - d_alsnow_x25_SS)*1.5
; d_alsnow_u_SS = d_alsnow_x75_SS + (d_alsnow_x75_SS - d_alsnow_x25_SS)*1.5
; d_alsnow_nor_SS = mask(d_alsnow_SS,d_alsnow_SS.lt.d_alsnow_d_SS .or. d_alsnow_SS.gt.d_alsnow_u_SS,False)

;***************箱型图所需的变量*****************
iarr_snow_SS     = new((/3,5/),double)
iarr_d_tas_SS    = new((/3,5/),double)
iarr_k5_SS       = new((/3,5/),double)
iarr_d_alsnow_SS = new((/3,5/),double)

iarr_snow_SS(2,:)    = (/min(snow_SS),snow_x25_SS,dim_median(snow_SS),snow_x75_SS,max(snow_SS)/)  ;CMIP6
iarr_d_tas_SS(2,:)   = (/min(d_tas_SS),d_tas_x25_SS,dim_median(d_tas_SS),d_tas_x75_SS,max(d_tas_SS)/)
iarr_k5_SS(2,:)      = (/min(k5_SS),k5_x25_SS,dim_median(k5_SS),k5_x75_SS,max(k5_SS)/)
iarr_d_alsnow_SS(2,:)= (/min(d_alsnow_SS),d_alsnow_x25_SS,dim_median(d_alsnow_SS),d_alsnow_x75_SS,max(d_alsnow_SS)/)

; ;print(iarr_k5_SS(2,0)+"  "+iarr_k5_SS(2,4))
; ;print(iarr_d_alsnow_SS(2,0)+"  "+iarr_d_alsnow_SS(2,4))

;***************************************************************
;***************************decadal****************************
;**************读取CMIP6************
snow_DS     = new(n_model6,double)
d_tas_DS    = new(n_model6,double)
k5_DS       = new(n_model6,double)
d_alsnow_DS = new(n_model6,double)

do i = 0,n_model6-1
  files_snow        := systemfunc("ls "+inpath_model_DS+"mean_snow.*"+model6(i)+".*aa.nc")
  files_k5          := systemfunc("ls "+inpath_model_DS+"k5.*"+model6(i)+".*aa.nc")
  files_delta_asnow := systemfunc("ls "+inpath_model_DS+"delta_alpha_snow.*"+model6(i)+".*aa.nc")
  files_d_tas       := systemfunc("ls "+inpath_model_DS+"delta_tas.*"+model6(i)+".*aa.nc")

  ; ;print(files_snow_pr1)

  f_snow        := addfiles(files_snow,"r")
  f_k5          := addfiles(files_k5,"r")
  f_delta_asnow := addfiles(files_delta_asnow,"r")
  f_d_tas       := addfiles(files_d_tas,"r")

  snow_cmip6    := f_snow[:]->snc(0,0,0)
  k5_cmip6      := f_k5[:]->k5(0,0,0)
  d_alsnow_cmip6:= f_delta_asnow[:]->delta_alpha_snow(0,0,0)
  d_tas_cmip6   := f_d_tas[:]->tas(0,0,0)

  snow_DS(i)     = 100.0*snow_cmip6
  d_tas_DS(i)    = d_tas_cmip6
  k5_DS(i)       = k5_cmip6
  d_alsnow_DS(i) = d_alsnow_cmip6
end do
; ;printVarSummary(mean_snow)
; ;print(k5)
; ;print(k5)
print(snow_DS)

; print(k5_DS)
; print(d_tas_DS)

;**************************************
;**************读取观测************
snow_obs_DS     = new((/2,3,3/),"double")
d_tas_obs_DS    = new((/2,3,3/),"double")
k5_obs_DS       = new((/2,3,3/),"double")
d_alsnow_obs_DS = new((/2,3,3/),"double")

do m = 0,1
  do n = 0,2
    do k= 0,2

      f_snow     := addfile(inpath_OBS_DS+"mean_snow.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_k5       := addfile(inpath_OBS_DS+"k5.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_d_alsnow := addfile(inpath_OBS_DS+"delta_alpha_snow.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_d_tas    := addfile(inpath_OBS_DS+"delta_tas.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")

      snow       := f_snow->snc(0,0,0)
      k5         := f_k5->k5(0,0,0)
      d_alsnow_o := f_d_alsnow->delta_alpha_snow(0,0,0)
      d_tas_obs  := f_d_tas->tas(0,0,0)

      snow_obs_DS(m,n,k)     = 100.0*snow
      d_tas_obs_DS(m,n,k)    = d_tas_obs
      k5_obs_DS(m,n,k)       = k5
      d_alsnow_obs_DS(m,n,k) = d_alsnow_o

    end do
  end do
end do

; print(snow_obs_DS)
;*****************读取ERA5-Land***************
f_snow    := addfile(inpath_ERA5_DS+"mean_snow.ERA5-Land2.EASE_grid.aa.nc","r")
f_d_tas   := addfile(inpath_ERA5_DS+"delta_tas.ERA5-Land2.EASE_grid.aa.nc","r")
f_k5      := addfile(inpath_ERA5_DS+"k5.ERA5-Land2.EASE_grid.aa.nc","r")
f_d_alsnow:= addfile(inpath_ERA5_DS+"delta_alpha_snow.ERA5-Land2.EASE_grid.aa.nc","r")

snow   := f_snow->snc(0,0,0)
d_tas  := f_d_tas->tas(0,0,0)
k5     := f_k5->k5(0,0,0)
d_alsnow_E := f_d_alsnow->delta_alpha_snow(0,0,0)

snow_ERA5_DS     = 100.0*snow
d_tas_ERA5_DS    = d_tas
k5_ERA5_DS       = k5
d_alsnow_ERA5_DS = d_alsnow_E

; ;print(s;printf("%5.4g",snow_ERA5_SS))
; ;print(s;printf("%4.3g",d_tas_ERA5_SS))
; ;print(s;printf("%4.3g",d_alsnow_ERA5_SS))
; ;print(s;printf("%4.3g",k5_ERA5_SS))

; ;print(s;printf("%5.4g",snow_ERA5_DS))
; ;print(s;printf("%4.3g",d_tas_ERA5_DS))
; ;print(s;printf("%4.3g",d_alsnow_ERA5_DS))
; ;print(s;printf("%4.3g",k5_ERA5_DS))

;*****************读取JRA55***************
f_snow    := addfile(inpath_JRA55_DS+"mean_snow.JRA552.EASE_grid.aa.nc","r")
f_d_tas   := addfile(inpath_JRA55_DS+"delta_tas.JRA552.EASE_grid.aa.nc","r")
f_k5      := addfile(inpath_JRA55_DS+"k5.JRA552.EASE_grid.aa.nc","r")
f_d_alsnow := addfile(inpath_JRA55_DS+"delta_alpha_snow.JRA552.EASE_grid.aa.nc","r")

snow   := f_snow->snc(0,0,0)
d_tas  := f_d_tas->tas(0,0,0)
k5     := f_k5->k5(0,0,0)
d_alsnow_E := f_d_alsnow->delta_alpha_snow(0,0,0)

snow_JRA55_DS     = 100.0*snow
d_tas_JRA55_DS    = d_tas
k5_JRA55_DS       = k5
d_alsnow_JRA55_DS = d_alsnow_E

;*****************读取MERRA2***************
f_snow    := addfile(inpath_MERRA2_DS+"mean_snow.MERRA22.EASE_grid.aa.nc","r")
f_d_tas   := addfile(inpath_MERRA2_DS+"delta_tas.MERRA22.EASE_grid.aa.nc","r")
f_k5      := addfile(inpath_MERRA2_DS+"k5.MERRA22.EASE_grid.aa.nc","r")
f_d_alsnow := addfile(inpath_MERRA2_DS+"delta_alpha_snow.MERRA22.EASE_grid.aa.nc","r")

snow   := f_snow->snc(0,0,0)
d_tas  := f_d_tas->tas(0,0,0)
k5     := f_k5->k5(0,0,0)
d_alsnow_E := f_d_alsnow->delta_alpha_snow(0,0,0)

snow_MERRA2_DS     = 100.0*snow
d_tas_MERRA2_DS    = d_tas
k5_MERRA2_DS       = k5
d_alsnow_MERRA2_DS = d_alsnow_E

;*****************读取JRA3Q***************
f_snow    := addfile(inpath_JRA3Q_DS+"mean_snow.JRA3Q2.EASE_grid.aa.nc","r")
f_d_tas   := addfile(inpath_JRA3Q_DS+"delta_tas.JRA3Q2.EASE_grid.aa.nc","r")
f_k5      := addfile(inpath_JRA3Q_DS+"k5.JRA3Q2.EASE_grid.aa.nc","r")
f_d_alsnow := addfile(inpath_JRA3Q_DS+"delta_alpha_snow.JRA3Q2.EASE_grid.aa.nc","r")

snow   := f_snow->snc(0,0,0)
d_tas  := f_d_tas->tas(0,0,0)
k5     := f_k5->k5(0,0,0)
d_alsnow_E := f_d_alsnow->delta_alpha_snow(0,0,0)

snow_JRA3Q_DS     = 100.0*snow
d_tas_JRA3Q_DS    = d_tas
k5_JRA3Q_DS       = k5
d_alsnow_JRA3Q_DS = d_alsnow_E

;print(d_alsnow_JRA3Q_DS)

;*****************读取ERA5snow***************
f_snow    := addfile(inpath_ERA5snow_DS+"mean_snow.ERA5snow2.EASE_grid.aa.nc","r")
f_d_tas   := addfile(inpath_ERA5snow_DS+"delta_tas.ERA5snow2.EASE_grid.aa.nc","r")
f_k5      := addfile(inpath_ERA5snow_DS+"k5.ERA5snow2.EASE_grid.aa.nc","r")
f_d_alsnow := addfile(inpath_ERA5snow_DS+"delta_alpha_snow.ERA5snow2.EASE_grid.aa.nc","r")

snow   := f_snow->snc(0,0,0)
d_tas  := f_d_tas->tas(0,0,0)
k5     := f_k5->k5(0,0,0)
d_alsnow_E := f_d_alsnow->delta_alpha_snow(0,0,0)

snow_ERA5snow_DS     = 100.0*snow
d_tas_ERA5snow_DS    = d_tas
k5_ERA5snow_DS       = k5
d_alsnow_ERA5snow_DS = d_alsnow_E

;****************计算百分位数***************
;;cmip6
;;cmip6
snow_x25_DS  = prctile(snow_DS,25)
snow_x75_DS  = prctile(snow_DS,75)

d_tas_x25_DS  = prctile(d_tas_DS,25)
d_tas_x75_DS  = prctile(d_tas_DS,75)

k5_x25_DS  = prctile(k5_DS,25)
k5_x75_DS  = prctile(k5_DS,75)

d_alsnow_x25_DS  = prctile(d_alsnow_DS,25)
d_alsnow_x75_DS  = prctile(d_alsnow_DS,75)

; print(d_tas_SS)
; print(d_tas_DS)
; ;*******************计算上下边界********************
; qsort(snow_DS)
; qsort(d_tas_DS)
; qsort(k5_DS)
; qsort(d_alsnow_DS)
;
; snow_d_DS = snow_x25_DS - (snow_x75_DS - snow_x25_DS)*1.5  ;box的下边界
; snow_u_DS = snow_x75_DS + (snow_x75_DS - snow_x25_DS)*1.5  ;box的上边界
; snow_nor_DS = mask(snow_DS,snow_DS.lt.snow_d_DS .or. snow_DS.gt.snow_u_DS,False)  ;位于box外的异常数据
;
; d_tas_d_DS = d_tas_x25_DS - (d_tas_x75_DS - d_tas_x25_DS)*1.5
; d_tas_u_DS = d_tas_x75_DS + (d_tas_x75_DS - d_tas_x25_DS)*1.5
; d_tas_nor_DS = mask(d_tas_DS,d_tas_DS.lt.d_tas_d_DS .or. d_tas_DS.gt.d_tas_u_DS,False)
;
; k5_d_DS = k5_x25_DS - (k5_x75_DS - k5_x25_DS)*1.5
; k5_u_DS = k5_x75_DS + (k5_x75_DS - k5_x25_DS)*1.5
; k5_nor_DS = mask(k5_DS,k5_DS.lt.k5_d_DS .or. k5_DS.gt.k5_u_DS,False)
;
; d_alsnow_d_DS = d_alsnow_x25_DS - (d_alsnow_x75_DS - d_alsnow_x25_DS)*1.5
; d_alsnow_u_DS = d_alsnow_x75_DS + (d_alsnow_x75_DS - d_alsnow_x25_DS)*1.5
; d_alsnow_nor_DS = mask(d_alsnow_DS,d_alsnow_DS.lt.d_alsnow_d_DS .or. d_alsnow_DS.gt.d_alsnow_u_DS,False)

;***************箱型图所需的变量*****************
iarr_snow_DS     = new((/3,5/),double)
iarr_d_tas_DS    = new((/3,5/),double)
iarr_k5_DS       = new((/3,5/),double)
iarr_d_alsnow_DS = new((/3,5/),double)

iarr_snow_DS(2,:)    = (/min(snow_DS),snow_x25_DS,dim_median(snow_DS),snow_x75_DS,max(snow_DS)/)  ;CMIP6
iarr_d_tas_DS(2,:)   = (/min(d_tas_DS),d_tas_x25_DS,dim_median(d_tas_DS),d_tas_x75_DS,max(d_tas_DS)/)
iarr_k5_DS(2,:)      = (/min(k5_DS),k5_x25_DS,dim_median(k5_DS),k5_x75_DS,max(k5_DS)/)
iarr_d_alsnow_DS(2,:)= (/min(d_alsnow_DS),d_alsnow_x25_DS,dim_median(d_alsnow_DS),d_alsnow_x75_DS,max(d_alsnow_DS)/)

; print(sprintf("%4.4g",avg(snow_SS))+"("+sprintf("%4.4g",min(snow_SS))+"~"+sprintf("%4.4g",max(snow_SS))+")")
; print(sprintf("%4.3g",avg(d_tas_SS))+"("+sprintf("%4.3g",min(d_tas_SS))+"~"+sprintf("%4.3g",max(d_tas_SS))+")")
; print(sprintf("%4.3g",avg(d_alsnow_SS))+"("+sprintf("%4.3g",max(d_alsnow_SS))+"~"+sprintf("%4.3g",min(d_alsnow_SS))+")")
; print(sprintf("%4.3g",avg(k5_SS))+"("+sprintf("%4.3g",max(k5_SS))+"~"+sprintf("%4.3g",min(k5_SS))+")")
;
; print(sprintf("%4.4g",avg(snow_DS))+"("+sprintf("%4.4g",min(snow_DS))+"~"+sprintf("%4.4g",max(snow_DS))+")")
; print(sprintf("%4.3g",avg(d_tas_DS))+"("+sprintf("%4.3g",min(d_tas_DS))+"~"+sprintf("%4.3g",max(d_tas_DS))+")")
; print(sprintf("%4.3g",avg(d_alsnow_DS))+"("+sprintf("%4.3g",max(d_alsnow_DS))+"~"+sprintf("%4.3g",min(d_alsnow_DS))+")")
; print(sprintf("%4.3g",avg(k5_DS))+"("+sprintf("%4.3g",max(k5_DS))+"~"+sprintf("%4.3g",min(k5_DS))+")")

;difference
iarr_snow_diff     = new((/3,5/),double)
iarr_d_tas_diff    = new((/3,5/),double)
iarr_k5_diff       = new((/3,5/),double)
iarr_d_alsnow_diff = new((/3,5/),double)

snow_diff    = snow_DS - snow_SS
d_tas_diff   = d_tas_DS - d_tas_SS
k5_diff      = k5_DS - k5_SS
d_alsnow_diff= d_alsnow_DS - d_alsnow_SS

snow_x25_diff  = prctile(snow_diff,25)
snow_x75_diff  = prctile(snow_diff,75)
d_tas_x25_diff = prctile(d_tas_diff,25)
d_tas_x75_diff = prctile(d_tas_diff,75)
k5_x25_diff    = prctile(k5_diff,25)
k5_x75_diff    = prctile(k5_diff,75)
d_alsnow_x25_diff = prctile(d_alsnow_diff,25)
d_alsnow_x75_diff = prctile(d_alsnow_diff,75)

iarr_snow_diff(2,:)    = (/min(snow_diff),snow_x25_diff,dim_median(snow_diff),snow_x75_diff,max(snow_diff)/)  ;CMIP6
iarr_d_tas_diff(2,:)   = (/min(d_tas_diff),d_tas_x25_diff,dim_median(d_tas_diff),d_tas_x75_diff,max(d_tas_diff)/)
iarr_k5_diff(2,:)      = (/min(k5_diff),k5_x25_diff,dim_median(k5_diff),k5_x75_diff,max(k5_diff)/)
iarr_d_alsnow_diff(2,:)= (/min(d_alsnow_diff),d_alsnow_x25_diff,dim_median(d_alsnow_diff),d_alsnow_x75_diff,max(d_alsnow_diff)/)

;******************设置xy-plot***************************
color_GLASS = "175"
color_clara_a3 = "2"
color_clara_a2 = "forestgreen"
color_APPx  = "deeppink2";"sienna4"

color_JASMES = "deeppink2"
color_NSIDC = "forestgreen"
color_Rutgers = "2"

color_CRU   = "blue3";"sienna4"
color_GHCN  = "175";"sienna4"

color_ERA5  = (/"sienna4"/)
color_ERA5snow = (/"blue3"/)
color_MERRA2   = (/"springgreen3"/)
color_JRA55 = (/"magenta"/)
color_JRA3Q = (/"250"/)

color_mean = "red"

mark_alb = 4
mark_snc = 7
mark_tas = 6
mark_rea = 2
mark_mean= 5

x = (/-0.6, 0., 0.6/)

x_obs = fspan(-0.9,-0.3,6)
; print(x_obs)

res = True

;res@gsnMaximize = True
res@trXMinF       = -1.0
res@trXMaxF       = 1.0

; res@tmXBMode   = "Manual"
; res@tmXBTickStartF   = -0.4
; res@tmXBTickEndF  = 0.4
; res@tmXBTickSpacingF = 0.4
res@tmXBLabels = (/"OBS","Reanalysis","CMIP6"/)

res@vpWidthF      = 0.45   ;图形宽度

res@trYReverse    = True
res@tmYRBorderOn  = True
res@tmXTBorderOn  = True

res@tmYLMajorLengthF = -0.012     ;y轴大刻度长度，负值朝外
res@tmXBMajorLengthF = -0.012     ;x轴大刻度长度，负值朝外
res@tmYLMinorLengthF = -0.008      ;小刻度长度
res@tmYLMajorThicknessF = 2        ;大刻度线宽
res@tmXBMajorThicknessF = 2        ;大刻度线宽
res@tmYLMinorThicknessF = 1        ;小刻度线宽

res@tmXBLabelFontHeightF = 0.023    ;字号
res@tmYLLabelFontHeightF = 0.022
res@tiYAxisFontHeightF   = 0.034
res@tiMainFontHeightF = 0.035
;********************设置箱形图上下的两条线*******************
llres = True
llres@gsLineThicknessF = 1.6
;*********************设置箱子的颜色和宽度*********************
opti = True
opti@boxWidth  = 0.3
opti@boxColors = (/"black","black","black"/)

;*************************画箱形图**********************
;;*******第一列***********
res@trYReverse    = False
res@tmYLPrecision = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

;seasonal
res@trYMinF      = 30.
res@trYMaxF      = 80.
res@tmYLMode     = "Manual"   ;设置刻度和标注
res@tmYLTickStartF  = 30.
res@tmYLTickSpacingF= 10.
res@tmYLTickEndF = 80.

res@tiYAxisString  = "Seasonal"
res@tiMainString = "S~B~C~N~~H-28V10F35~EE~FV-6H3~ (%)"
plot1 = boxplot(wks,x,iarr_snow_SS,opti,res,llres)

;decadal
res@tiYAxisString  = "Decadal"
res@tiMainOn       = False

plot5 = boxplot(wks,x,iarr_snow_DS,opti,res,llres)

;difference
res@trYMinF      = -6.
res@trYMaxF      = 6.
res@tmYLMode     = "Manual"   ;设置刻度和标注
res@tmYLTickStartF  = -6.
res@tmYLTickSpacingF= 2.
res@tmYLTickEndF = 6.

res@tiYAxisString     = "Decadal~V11F33~ _ ~V-11~~F~Seasonal"
plot9 = boxplot(wks,x,iarr_snow_diff,opti,res,llres)

;;*******第二列***********
res@tmYLPrecision = 2    ;y轴精度
res@trYReverse    = False

;seasonal
res@trYMinF       = 6.
res@trYMaxF       = 10.
res@tmYLMode      = "Manual"
res@tmYLTickStartF   = 6.
res@tmYLTickSpacingF = 1.
res@tmYLTickEndF  = 10.

res@tiYAxisOn = False
res@tiMainOn  = True
res@tiMainString = "~F33~D~F~T~B~S~N~ (K)"
plot2 = boxplot(wks,x,iarr_d_tas_SS,opti,res,llres)

;decadal
res@trYMinF       = -2.
res@trYMaxF       = 2.
res@tmYLMode      = "Manual"
res@tmYLTickStartF   = -2.
res@tmYLTickSpacingF = 1.
res@tmYLTickEndF  = 2.

res@tiMainOn       = False
plot6 = boxplot(wks,x,iarr_d_tas_DS,opti,res,llres)

;difference
res@trYMinF      = -9.
res@trYMaxF      = -5.
res@tmYLMode     = "Manual"   ;设置刻度和标注
res@tmYLTickStartF  = -9.
res@tmYLTickSpacingF= 1.
res@tmYLTickEndF = -5.

plot10 = boxplot(wks,x,iarr_d_tas_diff,opti,res,llres)

;;*******第三列***********
; res@trYReverse    = True

res@tmYLPrecision = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

;seasonal
res@trYMinF       = -15.
res@trYMaxF       = 3.
res@tmYLMode      = "Manual"
res@tmYLTickStartF   = -15.
res@tmYLTickSpacingF = 3.
res@tmYLTickEndF  = 3.

res@tiMainOn      = True
res@tiMainString  = "~F33~D~F~~F33~a~F~~B~snow~N~ (%)"
plot4 = boxplot(wks,x,iarr_d_alsnow_SS,opti,res,llres)

;decadal
res@tiMainOn       = False
plot8 = boxplot(wks,x,iarr_d_alsnow_DS,opti,res,llres)

;difference
res@trYReverse    = False

res@trYMinF      = -3.
res@trYMaxF      = 15.
res@tmYLMode     = "Manual"   ;设置刻度和标注
res@tmYLTickStartF  = -3.
res@tmYLTickSpacingF= 3.
res@tmYLTickEndF = 15.

plot12 = boxplot(wks,x,iarr_d_alsnow_diff,opti,res,llres)

;;*******第四列***********
res@trYReverse    = False
res@tmYLPrecision = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

;seasonal
res@trYMinF       = -6.
res@trYMaxF       = 2.
res@tmYLMode      = "Manual"
res@tmYLTickStartF   = -6.
res@tmYLTickSpacingF = 2.
res@tmYLTickEndF  = 2.

res@tiMainOn      = True
res@tiMainString = "~F33~D~F~~F33~a~F~~B~snow~N~/<~F33~D~F~T~B~S~N~> (%/K)"
plot3 = boxplot(wks,x,iarr_k5_SS,opti,res,llres)

;decadal
res@tiMainOn       = False
plot7 = boxplot(wks,x,iarr_k5_DS,opti,res,llres)

;difference
res@trYReverse    = False

res@trYMinF      = -6.
res@trYMaxF      = 4.
res@tmYLMode     = "Manual"   ;设置刻度和标注
res@tmYLTickStartF  = -6.
res@tmYLTickSpacingF= 2.
res@tmYLTickEndF = 4.

plot11 = boxplot(wks,x,iarr_k5_diff,opti,res,llres)

;**********************画平均值************************
mres = True
mres@gsMarkerIndex = 9
mres@gsMarkerSizeF = 9.0
mres@gsMarkerColor = "black"

;;cmip6
;;seasonal
snow_avg     = avg(snow_SS)                       ; polymarker locations
d_tas_avg    = avg(d_tas_SS)
k5_avg       = avg(k5_SS)
d_alsnow_avg = avg(d_alsnow_SS)


dum4 = gsn_add_polymarker(wks,plot1,x(2),snow_avg,mres)
dum5 = gsn_add_polymarker(wks,plot2,x(2),d_tas_avg,mres)
dum6 = gsn_add_polymarker(wks,plot3,x(2),k5_avg,mres)
dum7 = gsn_add_polymarker(wks,plot4,x(2),d_alsnow_avg,mres)

;;decadal
snow_avg     = avg(snow_DS)                       ; polymarker locations
d_tas_avg    = avg(d_tas_DS)
k5_avg       = avg(k5_DS)
d_alsnow_avg = avg(d_alsnow_DS)


dum4_DS = gsn_add_polymarker(wks,plot5,x(2),snow_avg,mres)
dum5_DS = gsn_add_polymarker(wks,plot6,x(2),d_tas_avg,mres)
dum6_DS = gsn_add_polymarker(wks,plot7,x(2),k5_avg,mres)
dum7_DS = gsn_add_polymarker(wks,plot8,x(2),d_alsnow_avg,mres)

;;difference
snow_avg     = avg(snow_DS - snow_SS)                       ; polymarker locations
d_tas_avg    = avg(d_tas_DS - d_tas_SS)
k5_avg       = avg(k5_DS - k5_SS )
d_alsnow_avg = avg(d_alsnow_DS - d_alsnow_SS )

dum4_diff = gsn_add_polymarker(wks,plot9,x(2),snow_avg,mres)
dum5_diff = gsn_add_polymarker(wks,plot10,x(2),d_tas_avg,mres)
dum6_diff = gsn_add_polymarker(wks,plot11,x(2),k5_avg,mres)
dum7_diff = gsn_add_polymarker(wks,plot12,x(2),d_alsnow_avg,mres)

;**************画再分析***********
snow_rea_SS     = new(5,float)
d_tas_rea_SS    = new(5,float)
k5_rea_SS       = new(5,float)
d_alsnow_rea_SS = new(5,float)

snow_rea_SS(0) = tofloat(snow_ERA5_SS)
snow_rea_SS(1) = tofloat(snow_ERA5snow_SS)
snow_rea_SS(2) = tofloat(snow_JRA3Q_SS)
snow_rea_SS(3) = tofloat(snow_JRA55_SS)
snow_rea_SS(4) = tofloat(snow_MERRA2_SS)

d_tas_rea_SS(0) = tofloat(d_tas_ERA5_SS)
d_tas_rea_SS(1) = tofloat(d_tas_ERA5snow_SS)
d_tas_rea_SS(2) = tofloat(d_tas_JRA3Q_SS)
d_tas_rea_SS(3) = tofloat(d_tas_JRA55_SS)
d_tas_rea_SS(4) = tofloat(d_tas_MERRA2_SS)

k5_rea_SS(0) = tofloat(k5_ERA5_SS)
k5_rea_SS(1) = tofloat(k5_ERA5snow_SS)
k5_rea_SS(2) = tofloat(k5_JRA3Q_SS)
k5_rea_SS(3) = tofloat(k5_JRA55_SS)
k5_rea_SS(4) = tofloat(k5_MERRA2_SS)

d_alsnow_rea_SS(0) = tofloat(d_alsnow_ERA5_SS)
d_alsnow_rea_SS(1) = tofloat(d_alsnow_ERA5snow_SS)
d_alsnow_rea_SS(2) = tofloat(d_alsnow_JRA3Q_SS)
d_alsnow_rea_SS(3) = tofloat(d_alsnow_JRA55_SS)
d_alsnow_rea_SS(4) = tofloat(d_alsnow_MERRA2_SS)

snow_rea_DS     = new(5,float)
d_tas_rea_DS    = new(5,float)
k5_rea_DS       = new(5,float)
d_alsnow_rea_DS = new(5,float)

snow_rea_DS(0) = tofloat(snow_ERA5_DS)
snow_rea_DS(1) = tofloat(snow_ERA5snow_DS)
snow_rea_DS(2) = tofloat(snow_JRA3Q_DS)
snow_rea_DS(3) = tofloat(snow_JRA55_DS)
snow_rea_DS(4) = tofloat(snow_MERRA2_DS)

d_tas_rea_DS(0) = tofloat(d_tas_ERA5_DS)
d_tas_rea_DS(1) = tofloat(d_tas_ERA5snow_DS)
d_tas_rea_DS(2) = tofloat(d_tas_JRA3Q_DS)
d_tas_rea_DS(3) = tofloat(d_tas_JRA55_DS)
d_tas_rea_DS(4) = tofloat(d_tas_MERRA2_DS)

k5_rea_DS(0) = tofloat(k5_ERA5_DS)
k5_rea_DS(1) = tofloat(k5_ERA5snow_DS)
k5_rea_DS(2) = tofloat(k5_JRA3Q_DS)
k5_rea_DS(3) = tofloat(k5_JRA55_DS)
k5_rea_DS(4) = tofloat(k5_MERRA2_DS)

d_alsnow_rea_DS(0) = tofloat(d_alsnow_ERA5_DS)
d_alsnow_rea_DS(1) = tofloat(d_alsnow_ERA5snow_DS)
d_alsnow_rea_DS(2) = tofloat(d_alsnow_JRA3Q_DS)
d_alsnow_rea_DS(3) = tofloat(d_alsnow_JRA55_DS)
d_alsnow_rea_DS(4) = tofloat(d_alsnow_MERRA2_DS)

; print(d_alsnow_rea_DS)

colors_rea = (/color_ERA5,color_ERA5snow,color_JRA3Q,color_JRA55,color_MERRA2/)
mres2 = True
mres2@gsMarkerIndex = mark_rea
mres2@gsMarkerSizeF = 11.
mres2@gsMarkerThicknessF = 1.9

dum_rea_1_SS = new(5,graphic)
dum_rea_2_SS = new(5,graphic)
dum_rea_3_SS = new(5,graphic)
dum_rea_4_SS = new(5,graphic)

dum_rea_1_DS = new(5,graphic)
dum_rea_2_DS = new(5,graphic)
dum_rea_3_DS = new(5,graphic)
dum_rea_4_DS = new(5,graphic)

dum_rea_1_diff = new(5,graphic)
dum_rea_2_diff = new(5,graphic)
dum_rea_3_diff = new(5,graphic)
dum_rea_4_diff = new(5,graphic)

snow_rea_diff    = snow_rea_DS - snow_rea_SS
d_tas_rea_diff   = d_tas_rea_DS - d_tas_rea_SS
k5_rea_diff      = k5_rea_DS - k5_rea_SS
d_alsnow_rea_diff= d_alsnow_rea_DS - d_alsnow_rea_SS

do i = 0,4
  mres2@gsMarkerColor = colors_rea(i)

  dum_rea_1_SS(i) = gsn_add_polymarker(wks,plot1,x(1),snow_rea_SS(i),mres2)
  dum_rea_2_SS(i) = gsn_add_polymarker(wks,plot2,x(1),d_tas_rea_SS(i),mres2)
  dum_rea_3_SS(i) = gsn_add_polymarker(wks,plot3,x(1),k5_rea_SS(i),mres2)
  dum_rea_4_SS(i) = gsn_add_polymarker(wks,plot4,x(1),d_alsnow_rea_SS(i),mres2)

  dum_rea_1_DS(i) = gsn_add_polymarker(wks,plot5,x(1),snow_rea_DS(i),mres2)
  dum_rea_2_DS(i) = gsn_add_polymarker(wks,plot6,x(1),d_tas_rea_DS(i),mres2)
  dum_rea_3_DS(i) = gsn_add_polymarker(wks,plot7,x(1),k5_rea_DS(i),mres2)
  dum_rea_4_DS(i) = gsn_add_polymarker(wks,plot8,x(1),d_alsnow_rea_DS(i),mres2)

  dum_rea_1_diff(i) = gsn_add_polymarker(wks,plot9,x(1),snow_rea_diff(i),mres2)
  dum_rea_2_diff(i) = gsn_add_polymarker(wks,plot10,x(1),d_tas_rea_diff(i),mres2)
  dum_rea_3_diff(i) = gsn_add_polymarker(wks,plot11,x(1),k5_rea_diff(i),mres2)
  dum_rea_4_diff(i) = gsn_add_polymarker(wks,plot12,x(1),d_alsnow_rea_diff(i),mres2)
end do

;**********再分析 avg***********
mres2@gsMarkerIndex = mark_mean
mres2@gsMarkerColor:= color_mean
mres2@gsMarkerSizeF = 13.
mres2@gsMarkerThicknessF = 2.2

snow_avg_SS     = avg(snow_rea_SS)
d_tas_avg_SS    = avg(d_tas_rea_SS)
k5_avg_SS       = avg(k5_rea_SS)
d_alsnow_avg_SS = avg(d_alsnow_rea_SS)

snow_avg_DS     = avg(snow_rea_DS)
d_tas_avg_DS    = avg(d_tas_rea_DS)
k5_avg_DS       = avg(k5_rea_DS)
d_alsnow_avg_DS = avg(d_alsnow_rea_DS)

snow_avg_diff     = snow_avg_DS - snow_avg_SS
d_tas_avg_diff    = d_tas_avg_DS - d_tas_avg_SS
k5_avg_diff       = k5_avg_DS - k5_avg_SS
d_alsnow_avg_diff = d_alsnow_avg_DS - d_alsnow_avg_SS

dum_rea_17_SS = gsn_add_polymarker(wks,plot1,x(1),snow_avg_SS,mres2)
dum_rea_27_SS = gsn_add_polymarker(wks,plot2,x(1),d_tas_avg_SS,mres2)
dum_rea_37_SS = gsn_add_polymarker(wks,plot3,x(1),k5_avg_SS,mres2)
dum_rea_47_SS = gsn_add_polymarker(wks,plot4,x(1),d_alsnow_avg_SS,mres2)

dum_rea_17_DS = gsn_add_polymarker(wks,plot5,x(1),snow_avg_DS,mres2)
dum_rea_27_DS = gsn_add_polymarker(wks,plot6,x(1),d_tas_avg_DS,mres2)
dum_rea_37_DS = gsn_add_polymarker(wks,plot7,x(1),k5_avg_DS,mres2)
dum_rea_47_DS = gsn_add_polymarker(wks,plot8,x(1),d_alsnow_avg_DS,mres2)

dum_rea_17_diff = gsn_add_polymarker(wks,plot9,x(1),snow_avg_diff,mres2)
dum_rea_27_diff = gsn_add_polymarker(wks,plot10,x(1),d_tas_avg_diff,mres2)
dum_rea_37_diff = gsn_add_polymarker(wks,plot11,x(1),k5_avg_diff,mres2)
dum_rea_47_diff = gsn_add_polymarker(wks,plot12,x(1),d_alsnow_avg_diff,mres2)

;*************************************
;**************读取观测************
colors_obs = (/color_APPx,color_clara_a2,color_clara_a3,color_GLASS/)

mres3 = True
mres3@gsMarkerSizeF = 11.
mres3@gsMarkerThicknessF = 1.9

dum_obs_3_SS = new(3,graphic)
dum_obs_4_SS = new(3,graphic)

dum_obs_3_DS = new(3,graphic)
dum_obs_4_DS = new(3,graphic)

dum_obs_3_diff = new(3,graphic)
dum_obs_4_diff = new(3,graphic)

k5_obs_SS_avg       = dim_avg_n(k5_obs_SS,(/0,1/))
d_alsnow_obs_SS_avg = dim_avg_n(d_alsnow_obs_SS,(/0,1/))
print(d_alsnow_obs_SS_avg)
k5_obs_DS_avg       = dim_avg_n(k5_obs_DS,(/0,1/))
d_alsnow_obs_DS_avg = dim_avg_n(d_alsnow_obs_DS,(/0,1/))
print(d_alsnow_obs_DS_avg)
k5_obs_diff         = k5_obs_DS_avg - k5_obs_SS_avg
d_alsnow_obs_diff   = d_alsnow_obs_DS_avg - d_alsnow_obs_SS_avg

do j = 0,2   ;alb
   mres3@gsMarkerIndex = mark_alb
   mres3@gsMarkerColor = colors_obs(j)

   dum_obs_3_SS(j) = gsn_add_polymarker(wks,plot3,x(0),k5_obs_SS_avg(j),mres3)
   dum_obs_4_SS(j) = gsn_add_polymarker(wks,plot4,x(0),d_alsnow_obs_SS_avg(j),mres3)

   dum_obs_3_DS(j) = gsn_add_polymarker(wks,plot7,x(0),k5_obs_DS_avg(j),mres3)
   dum_obs_4_DS(j) = gsn_add_polymarker(wks,plot8,x(0),d_alsnow_obs_DS_avg(j),mres3)

   dum_obs_3_diff(j) = gsn_add_polymarker(wks,plot11,x(0),k5_obs_diff(j),mres3)
   dum_obs_4_diff(j) = gsn_add_polymarker(wks,plot12,x(0),d_alsnow_obs_diff(j),mres3)
end do

;观测snc和tas
snow_obs_diff    = snow_obs_DS - snow_obs_SS
d_tas_obs_diff   = d_tas_obs_DS - d_tas_obs_SS

dum_obs_1_SS1   = new(3,graphic)
dum_obs_1_DS1   = new(3,graphic)
dum_obs_1_diff1 = new(3,graphic)

dum_obs_2_SS1   = new(2,graphic)
dum_obs_2_DS1   = new(2,graphic)
dum_obs_2_diff1 = new(2,graphic)

; mres3@gsMarkerColor = "black"
colors_obs_snc = (/color_JASMES,color_NSIDC,color_Rutgers/)
colors_obs_tas = (/color_CRU,color_GHCN/)

do i=0,2
  mres3@gsMarkerIndex = mark_snc
  mres3@gsMarkerColor = colors_obs_snc(i)

  dum_obs_1_SS1(i)   = gsn_add_polymarker(wks,plot1,x(0),snow_obs_SS(0,i,0),mres3)
  dum_obs_1_DS1(i)   = gsn_add_polymarker(wks,plot5,x(0),snow_obs_DS(0,i,0),mres3)
  dum_obs_1_diff1(i) = gsn_add_polymarker(wks,plot9,x(0),snow_obs_diff(0,i,0),mres3)
end do

do i=0,1
  mres3@gsMarkerIndex = mark_tas
  mres3@gsMarkerColor = colors_obs_tas(i)

  dum_obs_2_SS1(i)   = gsn_add_polymarker(wks,plot2,x(0),d_tas_obs_SS(i,0,0),mres3)
  dum_obs_2_DS1(i)   = gsn_add_polymarker(wks,plot6,x(0),d_tas_obs_DS(i,0,0),mres3)
  dum_obs_2_diff1(i) = gsn_add_polymarker(wks,plot10,x(0),d_tas_obs_diff(i,0,0),mres3)
end do


;**********观测 avg***********
mres3@gsMarkerIndex = mark_mean
mres3@gsMarkerColor = color_mean
mres3@gsMarkerSizeF = 13.
mres3@gsMarkerThicknessF = 2.2

;*******
snow_avg_SS    := avg(snow_obs_SS)
d_tas_avg_SS   := avg(d_tas_obs_SS)
k5_avg_SS      := avg(k5_obs_SS)
d_alsnow_avg_SS:= avg(d_alsnow_obs_SS)

snow_avg_DS    := avg(snow_obs_DS)
d_tas_avg_DS   := avg(d_tas_obs_DS)
k5_avg_DS      := avg(k5_obs_DS)
d_alsnow_avg_DS:= avg(d_alsnow_obs_DS)

snow_avg_diff    := snow_avg_DS - snow_avg_SS
d_tas_avg_diff   := d_tas_avg_DS - d_tas_avg_SS
k5_avg_diff      := k5_avg_DS - k5_avg_SS
d_alsnow_avg_diff:= d_alsnow_avg_DS - d_alsnow_avg_SS

dum_obs_17_SS_avg = gsn_add_polymarker(wks,plot1,x(0),snow_avg_SS,mres3)
dum_obs_27_SS_avg = gsn_add_polymarker(wks,plot2,x(0),d_tas_avg_SS,mres3)
dum_obs_37_SS_avg = gsn_add_polymarker(wks,plot3,x(0),k5_avg_SS,mres3)
dum_obs_47_SS_avg = gsn_add_polymarker(wks,plot4,x(0),d_alsnow_avg_SS,mres3)

dum_obs_17_DS_avg = gsn_add_polymarker(wks,plot5,x(0),snow_avg_DS,mres3)
dum_obs_27_DS_avg = gsn_add_polymarker(wks,plot6,x(0),d_tas_avg_DS,mres3)
dum_obs_37_DS_avg = gsn_add_polymarker(wks,plot7,x(0),k5_avg_DS,mres3)
dum_obs_47_DS_avg = gsn_add_polymarker(wks,plot8,x(0),d_alsnow_avg_DS,mres3)

dum_obs_17_diff_avg = gsn_add_polymarker(wks,plot9,x(0),snow_avg_diff,mres3)
dum_obs_27_diff_avg = gsn_add_polymarker(wks,plot10,x(0),d_tas_avg_diff,mres3)
dum_obs_37_diff_avg = gsn_add_polymarker(wks,plot11,x(0),k5_avg_diff,mres3)
dum_obs_47_diff_avg = gsn_add_polymarker(wks,plot12,x(0),d_alsnow_avg_diff,mres3)


;*******************************legend*****************************
index      = new(14,"integer")
index(0:2) = mark_snc
index(3:4) = mark_tas
index(5:7) = mark_alb
index(8:12)= mark_rea
index(13)  = mark_mean

xleg = new(15,float)
xleg(:) = 0.845 ; legend markers位置
xtxt := xleg+0.01

yleg := fspan(0.8,0.5,15)+0.07   ; text位置
ytxt := fspan(0.8,0.5,15)+0.07

colors := (/color_JASMES,color_NSIDC,color_Rutgers,color_CRU,color_GHCN,\
            color_APPx,color_clara_a2,color_clara_a3,\
            color_ERA5,color_ERA5snow,color_JRA3Q,color_JRA55,color_MERRA2,color_mean/)

labels := (/"JASMES","NSIDC","Rutgers","CRU","GHCN-CAM",\
            "APP-x","CLARA-A2","CLARA-A3",\
            "ERA5-Land","ERA5-Snow","JRA-3Q","JRA-55","MERRA-2","Mean"/)

do i = 0,13
  gsres    = True
  gsres@gsMarkerIndex = index(i)          ; Use filled dots for markers.
  gsres@gsMarkerSizeF = 10.
  gsres@gsMarkerThicknessF = 2.0
  gsres@gsMarkerColor = colors(i)

  txres    = True
  txres@txFontHeightF = 0.01
  ; txres@txPerimOn  =True
  ; txres@txPerimSpaceF  = 1
  txres@txJust = "CenterLeft"

  gsn_polymarker_ndc(wks,xleg(i),yleg(i),gsres)
  gsn_text_ndc(wks,labels(i),xtxt(i),ytxt(i),txres)
end do


;**********************************************************
 pres = True
; pres@txString = "albedo("+ymStrt+"-"+ymLast+")"
; pres@gsnPanelMainFontHeightF  = 0.015
 pres@gsnPanelXWhiteSpacePercent  = 10       ;留白
; pres@gsnPanelYWhiteSpacePercent  = 7

pres@gsnPanelFigureStrings  = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)","(k)","(l)"/)
pres@gsnPanelFigureStringsJust    = "TopLeft"
pres@gsnPanelFigureStringsPerimOn = False
; pres@gsnPanelFigureStringsFontHeightF = 0.01

XF = fspan(0.054,0.658,4)
pres@gsnPanelXF = (/XF(0),XF(1),XF(2),XF(3),\
                    XF(0),XF(1),XF(2),XF(3),\
                    XF(0),XF(1),XF(2),XF(3)/)

gsn_panel(wks,(/plot1,plot2,plot4,plot3,\
                plot5,plot6,plot8,plot7,\
                plot9,plot10,plot12,plot11/),(/3,4/),pres)

end
