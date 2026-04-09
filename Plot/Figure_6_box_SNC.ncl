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

wks = gsn_open_wks("pdf",outpath+"Figure_6")

n_model6 = dimsizes(model6)
;;print(n_model6)

;***************************************************************
;***************************seasonal****************************
;*******************读取CMIP6*************
k1_season   = new(3,"double")
k2_season   = new(3,"double")
snow_season = new(3,"double")
land_season = new(3,"double")

k1_SS = new(n_model6,double)
k2_SS = new(n_model6,double)
snow_SS = new(n_model6,double)
land_SS = new(n_model6,double)

do i = 0,n_model6-1
  do j = 0,2
    ; ****k1 is Delta k2 / <Delta_Ts>_NH****
    ; ****k2 is mean albedo_snow - albedo_land****
    ; mean_alpha_snow, alpha_land
    files_k1         := systemfunc("ls "+inpath_model_SS+M(j)+"k1.*"+model6(i)+".*aa.nc")
    files_k2         := systemfunc("ls "+inpath_model_SS+M(j)+"k2.*"+model6(i)+".*aa.nc")
    files_alpha_snow := systemfunc("ls "+inpath_model_SS+M(j)+"mean_alpha_snow.wgt*"+model6(i)+".*aa.nc")
    files_alpha_land := systemfunc("ls "+inpath_model_SS+M(j)+"alpha_land.wgt*"+model6(i)+".*aa.nc")

    ; ;;print(files_k1)
    ; ;;print(files_k2)
    ; ;;print(files_alpha_snow)
    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_alpha_snow = addfiles(files_alpha_snow,"r")
    f_alpha_land = addfiles(files_alpha_land,"r")

    k1_season(j)   = f_k1[:]->k1(0,0,0)
    k2_season(j)   = f_k2[:]->k2(0,0,0)
    snow_season(j) = f_alpha_snow[:]->alpha_snow(0,0,0)
    land_season(j) = f_alpha_land[:]->alpha_land(0,0,0)
  end do

k1_SS(i)   = avg(k1_season)
k2_SS(i)   = avg(k2_season)
snow_SS(i) = avg(snow_season)
land_SS(i) = avg(land_season)

end do
; ;;print(k2_SS)
; ;;print(snow_SS)
; qsort(snow_SS)
; ;;print(snow_SS)

;;print(land_SS)
; qsort(land_SS)
; ;;print(land_SS)

;*************************************
;**************读取观测 ************
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3"/)

k1_obs_SS   = new((/2,3,3/),"double")
k2_obs_SS   = new((/2,3,3/),"double")
snow_obs_SS = new((/2,3,3/),"double")
land_obs_SS = new((/2,3,3/),"double")

do m = 0,1
  do n = 0,2
    do k= 0,2
      k1_season_obs   = new(3,"double")
      k2_season_obs   = new(3,"double")
      snow_season_obs = new(3,"double")
      land_season_obs = new(3,"double")

      do j = 0,2
         f_k1_obs   = addfile(inpath_OBS_SS+M(j)+"k1.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
         f_k2_obs   = addfile(inpath_OBS_SS+M(j)+"k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
         f_snow_obs = addfile(inpath_OBS_SS+M(j)+"mean_alpha_snow.wgt.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
         f_land_obs = addfile(inpath_OBS_SS+M(j)+"alpha_land.wgt.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")

         k1_season_obs(j)   = f_k1_obs->k1(0,0,0)
         k2_season_obs(j)   = f_k2_obs->k2(0,0,0)
         snow_season_obs(j) = f_snow_obs->alpha_snow(0,0,0)
         land_season_obs(j) = f_land_obs->alpha_land(0,0,0)
      end do

      ; print(nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k))
      ; print(avg(k4_season_obs))
      k1_obs_SS(m,n,k)   = avg(k1_season_obs)
      k2_obs_SS(m,n,k)   = avg(k2_season_obs)
      snow_obs_SS(m,n,k) = avg(snow_season_obs)
      land_obs_SS(m,n,k) = avg(land_season_obs)

    end do
  end do
end do


;************************************
;************读取ERA5-land************
k1_season_ERA5   = new(3,"double")
k2_season_ERA5   = new(3,"double")
snow_season_ERA5 = new(3,"double")
land_season_ERA5 = new(3,"double")

do j = 0,2
   f_k1_ERA5 = addfile(inpath_ERA5_SS+M(j)+"k1.ERA5-Land2.EASE_grid.aa.nc","r")
   f_k2_ERA5 = addfile(inpath_ERA5_SS+M(j)+"k2.ERA5-Land2.EASE_grid.aa.nc","r")
   f_snow_ERA5 = addfile(inpath_ERA5_SS+M(j)+"mean_alpha_snow.wgt.ERA5-Land2.EASE_grid.aa.nc","r")
   f_land_ERA5 = addfile(inpath_ERA5_SS+M(j)+"alpha_land.wgt.ERA5-Land2.EASE_grid.aa.nc","r")

   k1_season_ERA5(j)   = f_k1_ERA5->k1(0,0,0)
   k2_season_ERA5(j)   = f_k2_ERA5->k2(0,0,0)
   snow_season_ERA5(j) = f_snow_ERA5->alpha_snow(0,0,0)
   land_season_ERA5(j) = f_land_ERA5->alpha_land(0,0,0)
end do

k1_ERA5_SS   = avg(k1_season_ERA5)
k2_ERA5_SS   = avg(k2_season_ERA5)
snow_ERA5_SS = avg(snow_season_ERA5)
land_ERA5_SS = avg(land_season_ERA5)

;************读取MERRA2************
k1_season_MERRA2   = new(3,"double")
k2_season_MERRA2   = new(3,"double")
snow_season_MERRA2 = new(3,"double")
land_season_MERRA2 = new(3,"double")

do j = 0,2
   f_k1_MERRA2 = addfile(inpath_MERRA2_SS+M(j)+"k1.MERRA22.EASE_grid.aa.nc","r")
   f_k2_MERRA2 = addfile(inpath_MERRA2_SS+M(j)+"k2.MERRA22.EASE_grid.aa.nc","r")
   f_snow_MERRA2 = addfile(inpath_MERRA2_SS+M(j)+"mean_alpha_snow.wgt.MERRA22.EASE_grid.aa.nc","r")
   f_land_MERRA2 = addfile(inpath_MERRA2_SS+M(j)+"alpha_land.wgt.MERRA22.EASE_grid.aa.nc","r")

   k1_season_MERRA2(j)   = f_k1_MERRA2->k1(0,0,0)
   k2_season_MERRA2(j)   = f_k2_MERRA2->k2(0,0,0)
   snow_season_MERRA2(j) = f_snow_MERRA2->alpha_snow(0,0,0)
   land_season_MERRA2(j) = f_land_MERRA2->alpha_land(0,0,0)
end do

k1_MERRA2_SS   = avg(k1_season_MERRA2)
k2_MERRA2_SS   = avg(k2_season_MERRA2)
snow_MERRA2_SS = avg(snow_season_MERRA2)
land_MERRA2_SS = avg(land_season_MERRA2)

;************读取JRA55************
k1_season_JRA55   = new(3,"double")
k2_season_JRA55   = new(3,"double")
snow_season_JRA55 = new(3,"double")
land_season_JRA55 = new(3,"double")

do j = 0,2
   f_k1_JRA55 = addfile(inpath_JRA55_SS+M(j)+"k1.JRA552.EASE_grid.aa.nc","r")
   f_k2_JRA55 = addfile(inpath_JRA55_SS+M(j)+"k2.JRA552.EASE_grid.aa.nc","r")
   f_snow_JRA55 = addfile(inpath_JRA55_SS+M(j)+"mean_alpha_snow.wgt.JRA552.EASE_grid.aa.nc","r")
   f_land_JRA55 = addfile(inpath_JRA55_SS+M(j)+"alpha_land.wgt.JRA552.EASE_grid.aa.nc","r")

   k1_season_JRA55(j)   = f_k1_JRA55->k1(0,0,0)
   k2_season_JRA55(j)   = f_k2_JRA55->k2(0,0,0)
   snow_season_JRA55(j) = f_snow_JRA55->alpha_snow(0,0,0)
   land_season_JRA55(j) = f_land_JRA55->alpha_land(0,0,0)
end do

k1_JRA55_SS   = avg(k1_season_JRA55)
k2_JRA55_SS   = avg(k2_season_JRA55)
snow_JRA55_SS = avg(snow_season_JRA55)
land_JRA55_SS = avg(land_season_JRA55)

;************读取JRA3Q************
k1_season_JRA3Q   = new(3,"double")
k2_season_JRA3Q   = new(3,"double")
snow_season_JRA3Q = new(3,"double")
land_season_JRA3Q = new(3,"double")

do j = 0,2
   f_k1_JRA3Q = addfile(inpath_JRA3Q_SS+M(j)+"k1.JRA3Q2.EASE_grid.aa.nc","r")
   f_k2_JRA3Q = addfile(inpath_JRA3Q_SS+M(j)+"k2.JRA3Q2.EASE_grid.aa.nc","r")
   f_snow_JRA3Q = addfile(inpath_JRA3Q_SS+M(j)+"mean_alpha_snow.wgt.JRA3Q2.EASE_grid.aa.nc","r")
   f_land_JRA3Q = addfile(inpath_JRA3Q_SS+M(j)+"alpha_land.wgt.JRA3Q2.EASE_grid.aa.nc","r")

   k1_season_JRA3Q(j)   = f_k1_JRA3Q->k1(0,0,0)
   k2_season_JRA3Q(j)   = f_k2_JRA3Q->k2(0,0,0)
   snow_season_JRA3Q(j) = f_snow_JRA3Q->alpha_snow(0,0,0)
   land_season_JRA3Q(j) = f_land_JRA3Q->alpha_land(0,0,0)
end do

k1_JRA3Q_SS   = avg(k1_season_JRA3Q)
k2_JRA3Q_SS   = avg(k2_season_JRA3Q)
snow_JRA3Q_SS = avg(snow_season_JRA3Q)
land_JRA3Q_SS = avg(land_season_JRA3Q)

; ;print(k1_JRA3Q_SS)
; ;print(k2_JRA3Q_SS)
; ;print(snow_JRA3Q_SS)
; ;print(land_JRA3Q_SS)

;************读取ERA5snow************
k1_season_ERA5snow   = new(3,"double")
k2_season_ERA5snow   = new(3,"double")
snow_season_ERA5snow = new(3,"double")
land_season_ERA5snow = new(3,"double")

do j = 0,2
   f_k1_ERA5snow = addfile(inpath_ERA5snow_SS+M(j)+"k1.ERA5snow2.EASE_grid.aa.nc","r")
   f_k2_ERA5snow = addfile(inpath_ERA5snow_SS+M(j)+"k2.ERA5snow2.EASE_grid.aa.nc","r")
   f_snow_ERA5snow = addfile(inpath_ERA5snow_SS+M(j)+"mean_alpha_snow.wgt.ERA5snow2.EASE_grid.aa.nc","r")
   f_land_ERA5snow = addfile(inpath_ERA5snow_SS+M(j)+"alpha_land.wgt.ERA5snow2.EASE_grid.aa.nc","r")

   k1_season_ERA5snow(j)   = f_k1_ERA5snow->k1(0,0,0)
   k2_season_ERA5snow(j)   = f_k2_ERA5snow->k2(0,0,0)
   snow_season_ERA5snow(j) = f_snow_ERA5snow->alpha_snow(0,0,0)
   land_season_ERA5snow(j) = f_land_ERA5snow->alpha_land(0,0,0)
end do

k1_ERA5snow_SS   = avg(k1_season_ERA5snow)
k2_ERA5snow_SS   = avg(k2_season_ERA5snow)
snow_ERA5snow_SS = avg(snow_season_ERA5snow)
land_ERA5snow_SS = avg(land_season_ERA5snow)

;*************计算百分位数************
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
k1_x25_SS  = prctile(k1_SS,25)
k1_x75_SS  = prctile(k1_SS,75)

k2_x25_SS  = prctile(k2_SS,25)
k2_x75_SS  = prctile(k2_SS,75)

snow_x25_SS  = prctile(snow_SS,25)
snow_x75_SS  = prctile(snow_SS,75)

land_x25_SS  = prctile(land_SS,25)
land_x75_SS  = prctile(land_SS,75)
; ;************计算上下边界**********
; qsort(k1_SS)
; qsort(k2_SS)
; qsort(snow_SS)
; qsort(land_SS)
;
; ; ;;print(alpha_land)
;
; k1_d_SS = k1_x25_SS - (k1_x75_SS - k1_x25_SS)*1.5  ;box的下边界
; k1_u_SS = k1_x75_SS + (k1_x75_SS - k1_x25_SS)*1.5  ;box的上边界
; k1_nor_SS = mask(k1_SS,k1_SS.lt.k1_d_SS .or. k1_SS.gt.k1_u_SS,False)  ;位于box外的异常数据
;
; k2_d_SS = k2_x25_SS - (k2_x75_SS - k2_x25_SS)*1.5
; k2_u_SS = k2_x75_SS + (k2_x75_SS - k2_x25_SS)*1.5
; k2_nor_SS = mask(k2_SS,k2_SS.lt.k2_d_SS .or. k2_SS.gt.k2_u_SS,False)
;
; snow_d_SS = snow_x25_SS - (snow_x75_SS - snow_x25_SS)*1.5
; snow_u_SS = snow_x75_SS + (snow_x75_SS - snow_x25_SS)*1.5
; snow_nor_SS = mask(snow_SS,snow_SS.lt.snow_d_SS .or. snow_SS.gt.snow_u_SS,False)
;
; land_d_SS = land_x25_SS - (land_x75_SS - land_x25_SS)*1.5
; land_u_SS = land_x75_SS + (land_x75_SS - land_x25_SS)*1.5
; land_nor_SS = mask(land_SS,land_SS.lt.land_d_SS .or. land_SS.gt.land_u_SS,False)

;*************箱型图所需的变量************
iarr_k1_SS = new((/3,5/),double)
iarr_k2_SS = new((/3,5/),double)
iarr_snow_SS = new((/3,5/),double)
iarr_land_SS = new((/3,5/),double)

iarr_k1_SS(2,:) = (/min(k1_SS),k1_x25_SS,dim_median(k1_SS),k1_x75_SS,max(k1_SS)/)  ;CMIP6
iarr_k2_SS(2,:) = (/min(k2_SS),k2_x25_SS,dim_median(k2_SS),k2_x75_SS,max(k2_SS)/)
iarr_snow_SS(2,:) = (/min(snow_SS),snow_x25_SS,dim_median(snow_SS),snow_x75_SS,max(snow_SS)/)
iarr_land_SS(2,:) = (/min(land_SS),land_x25_SS,dim_median(land_SS),land_x75_SS,max(land_SS)/)

; ;;print(s;;printf("%4.3g",iarr_k1_SS(2,4))+"  "+s;;printf("%4.3g",iarr_k1_SS(2,0)))
; ;;print(s;;printf("%5.4g",iarr_k2_SS(2,0))+"  "+s;;printf("%5.4g",iarr_k2_SS(2,4)))
; ;;print(s;;printf("%5.4g",iarr_snow_SS(2,0))+"  "+s;;printf("%5.4g",iarr_snow_SS(2,4)))
; ; ;;print(s;;printf("%5.4g",iarr_land_SS(2,0))+"  "+s;;printf("%5.4g",iarr_land_SS(2,4)))

;***************************************************************
;***************************decadal****************************
;**************读取CMIP6************
k1_DS = new(n_model6,double)
k2_DS = new(n_model6,double)
snow_DS = new(n_model6,double)
land_DS = new(n_model6,double)

do i = 0,n_model6-1
    ; ****k1 is Delta k2 / <Delta_Ts>_NH****
    ; ****k2 is mean albedo_snow - albedo_land****
    ; mean_alpha_snow, alpha_land
    files_k1         := systemfunc("ls "+inpath_model_DS+"k1.*"+model6(i)+".*aa.nc")
    files_k2         := systemfunc("ls "+inpath_model_DS+"k2.*"+model6(i)+".*aa.nc")
    files_alpha_snow := systemfunc("ls "+inpath_model_DS+"mean_alpha_snow.wgt*"+model6(i)+".*aa.nc")
    files_alpha_land := systemfunc("ls "+inpath_model_DS+"alpha_land.wgt*"+model6(i)+".*aa.nc")

    ; ;;print(files_k1)
    ; ;;print(files_k2)
    ; ;;print(files_alpha_snow)
    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_alpha_snow = addfiles(files_alpha_snow,"r")
    f_alpha_land = addfiles(files_alpha_land,"r")

    k1_DS(i)  = f_k1[:]->k1(0,0,0)
    k2_DS(i)  = f_k2[:]->k2(0,0,0)
    snow_DS(i)= f_alpha_snow[:]->alpha_snow(0,0,0)
    land_DS(i)= f_alpha_land[:]->alpha_land(0,0,0)
end do
; ;;printVarSummary(k1)
; ;;print(k2)
; ;;print(alpha_land)
;*************************************
;**************读取观测************
k1_obs_DS   = new((/2,3,3/),"double")
k2_obs_DS   = new((/2,3,3/),"double")
snow_obs_DS = new((/2,3,3/),"double")
land_obs_DS = new((/2,3,3/),"double")

do m = 0,1
  do n = 0,2
    do k= 0,2

      f_k1_obs   = addfile(inpath_OBS_DS+"k1.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_k2_obs   = addfile(inpath_OBS_DS+"k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_snow_obs = addfile(inpath_OBS_DS+"mean_alpha_snow.wgt.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")
      f_land_obs = addfile(inpath_OBS_DS+"alpha_land.wgt.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.aa.nc","r")

      k1_obs_DS(m,n,k)   = f_k1_obs->k1(0,0,0)
      k2_obs_DS(m,n,k)   = f_k2_obs->k2(0,0,0)
      snow_obs_DS(m,n,k) = f_snow_obs->alpha_snow(0,0,0)
      land_obs_DS(m,n,k) = f_land_obs->alpha_land(0,0,0)

    end do
  end do
end do


;********************************************
;****************读取ERA5-land***************
f_k1_ERA5 = addfile(inpath_ERA5_DS+"k1.ERA5-Land2.EASE_grid.aa.nc","r")
f_k2_ERA5 = addfile(inpath_ERA5_DS+"k2.ERA5-Land2.EASE_grid.aa.nc","r")
f_snow_ERA5 = addfile(inpath_ERA5_DS+"mean_alpha_snow.wgt.ERA5-Land2.EASE_grid.aa.nc","r")
f_land_ERA5 = addfile(inpath_ERA5_DS+"alpha_land.wgt.ERA5-Land2.EASE_grid.aa.nc","r")

k1_ERA5_DS   = f_k1_ERA5->k1(0,0,0)
k2_ERA5_DS   = f_k2_ERA5->k2(0,0,0)
snow_ERA5_DS = f_snow_ERA5->alpha_snow(0,0,0)
land_ERA5_DS = f_land_ERA5->alpha_land(0,0,0)

; ;;print(k1_ERA5_DS)
; ;;print(k2_ERA5_DS)
; ;;print(snow_ERA5_DS)
; ;;print(land_ERA5_DS)

;****************读取JRA55***************
f_k1_JRA55 = addfile(inpath_JRA55_DS+"k1.JRA552.EASE_grid.aa.nc","r")
f_k2_JRA55 = addfile(inpath_JRA55_DS+"k2.JRA552.EASE_grid.aa.nc","r")
f_snow_JRA55 = addfile(inpath_JRA55_DS+"mean_alpha_snow.wgt.JRA552.EASE_grid.aa.nc","r")
f_land_JRA55 = addfile(inpath_JRA55_DS+"alpha_land.wgt.JRA552.EASE_grid.aa.nc","r")

k1_JRA55_DS   = f_k1_JRA55->k1(0,0,0)
k2_JRA55_DS   = f_k2_JRA55->k2(0,0,0)
snow_JRA55_DS = f_snow_JRA55->alpha_snow(0,0,0)
land_JRA55_DS = f_land_JRA55->alpha_land(0,0,0)
;;print(k1_JRA55_DS)

;****************读取MERRA2***************
f_k1_MERRA2 = addfile(inpath_MERRA2_DS+"k1.MERRA22.EASE_grid.aa.nc","r")
f_k2_MERRA2 = addfile(inpath_MERRA2_DS+"k2.MERRA22.EASE_grid.aa.nc","r")
f_snow_MERRA2 = addfile(inpath_MERRA2_DS+"mean_alpha_snow.wgt.MERRA22.EASE_grid.aa.nc","r")
f_land_MERRA2 = addfile(inpath_MERRA2_DS+"alpha_land.wgt.MERRA22.EASE_grid.aa.nc","r")

k1_MERRA2_DS   = f_k1_MERRA2->k1(0,0,0)
k2_MERRA2_DS   = f_k2_MERRA2->k2(0,0,0)
snow_MERRA2_DS = f_snow_MERRA2->alpha_snow(0,0,0)
land_MERRA2_DS = f_land_MERRA2->alpha_land(0,0,0)

;****************读取JRA3Q***************
f_k1_JRA3Q = addfile(inpath_JRA3Q_DS+"k1.JRA3Q2.EASE_grid.aa.nc","r")
f_k2_JRA3Q = addfile(inpath_JRA3Q_DS+"k2.JRA3Q2.EASE_grid.aa.nc","r")
f_snow_JRA3Q = addfile(inpath_JRA3Q_DS+"mean_alpha_snow.wgt.JRA3Q2.EASE_grid.aa.nc","r")
f_land_JRA3Q = addfile(inpath_JRA3Q_DS+"alpha_land.wgt.JRA3Q2.EASE_grid.aa.nc","r")

k1_JRA3Q_DS   = f_k1_JRA3Q->k1(0,0,0)
k2_JRA3Q_DS   = f_k2_JRA3Q->k2(0,0,0)
snow_JRA3Q_DS = f_snow_JRA3Q->alpha_snow(0,0,0)
land_JRA3Q_DS = f_land_JRA3Q->alpha_land(0,0,0)
; ;print(k1_JRA3Q_DS)
; ;print(k2_JRA3Q_DS)
; ;print(snow_JRA3Q_DS)
; ;print(land_JRA3Q_DS)

;****************读取ERA5snow***************
f_k1_ERA5snow = addfile(inpath_ERA5snow_DS+"k1.ERA5snow2.EASE_grid.aa.nc","r")
f_k2_ERA5snow = addfile(inpath_ERA5snow_DS+"k2.ERA5snow2.EASE_grid.aa.nc","r")
f_snow_ERA5snow = addfile(inpath_ERA5snow_DS+"mean_alpha_snow.wgt.ERA5snow2.EASE_grid.aa.nc","r")
f_land_ERA5snow = addfile(inpath_ERA5snow_DS+"alpha_land.wgt.ERA5snow2.EASE_grid.aa.nc","r")

k1_ERA5snow_DS   = f_k1_ERA5snow->k1(0,0,0)
k2_ERA5snow_DS   = f_k2_ERA5snow->k2(0,0,0)
snow_ERA5snow_DS = f_snow_ERA5snow->alpha_snow(0,0,0)
land_ERA5snow_DS = f_land_ERA5snow->alpha_land(0,0,0)

print(land_ERA5snow_DS)
print(land_ERA5snow_SS)

;************计算百分位数************
;;cmip6
k1_x25_DS  = prctile(k1_DS,25)
k1_x75_DS  = prctile(k1_DS,75)

k2_x25_DS  = prctile(k2_DS,25)
k2_x75_DS  = prctile(k2_DS,75)

snow_x25_DS  = prctile(snow_DS,25)
snow_x75_DS  = prctile(snow_DS,75)

land_x25_DS  = prctile(land_DS,25)
land_x75_DS  = prctile(land_DS,75)
; ;************计算上下边界**********
; qsort(k1_DS)
; qsort(k2_DS)
; qsort(snow_DS)
; qsort(land_DS)
; ; ;;print(alpha_land)
;
; k1_d_DS = k1_x25_DS - (k1_x75_DS - k1_x25_DS)*1.5  ;box的下边界
; k1_u_DS = k1_x75_DS + (k1_x75_DS - k1_x25_DS)*1.5  ;box的上边界
; k1_nor_DS = mask(k1_DS,k1_DS.lt.k1_d_DS .or. k1_DS.gt.k1_u_DS,False)  ;位于box外的异常数据
;
; k2_d_DS = k2_x25_DS - (k2_x75_DS - k2_x25_DS)*1.5
; k2_u_DS = k2_x75_DS + (k2_x75_DS - k2_x25_DS)*1.5
; k2_nor_DS = mask(k2_DS,k2_DS.lt.k2_d_DS .or. k2_DS.gt.k2_u_DS,False)
;
; snow_d_DS = snow_x25_DS - (snow_x75_DS - snow_x25_DS)*1.5
; snow_u_DS = snow_x75_DS + (snow_x75_DS - snow_x25_DS)*1.5
; snow_nor_DS = mask(snow_DS,snow_DS.lt.snow_d_DS .or. snow_DS.gt.snow_u_DS,False)
;
; land_d_DS = land_x25_DS - (land_x75_DS - land_x25_DS)*1.5
; land_u_DS = land_x75_DS + (land_x75_DS - land_x25_DS)*1.5
; land_nor_DS = mask(land_DS,land_DS.lt.land_d_DS .or. land_DS.gt.land_u_DS,False)

;*************箱型图所需的变量************
iarr_k1_DS   = new((/3,5/),double)
iarr_k2_DS   = new((/3,5/),double)
iarr_snow_DS = new((/3,5/),double)
iarr_land_DS = new((/3,5/),double)

iarr_k1_DS(2,:)   = (/min(k1_DS),k1_x25_DS,dim_median(k1_DS),k1_x75_DS,max(k1_DS)/)  ;CMIP6
iarr_k2_DS(2,:)   = (/min(k2_DS),k2_x25_DS,dim_median(k2_DS),k2_x75_DS,max(k2_DS)/)
iarr_snow_DS(2,:) = (/min(snow_DS),snow_x25_DS,dim_median(snow_DS),snow_x75_DS,max(snow_DS)/)
iarr_land_DS(2,:) = (/min(land_DS),land_x25_DS,dim_median(land_DS),land_x75_DS,max(land_DS)/)


;difference
iarr_k1_diff   = new((/3,5/),double)
iarr_k2_diff   = new((/3,5/),double)
iarr_snow_diff = new((/3,5/),double)
iarr_land_diff = new((/3,5/),double)

k1_diff   = k1_DS - k1_SS
k2_diff   = k2_DS - k2_SS
snow_diff = snow_DS - snow_SS
land_diff = land_DS - land_SS

k1_x25_diff  = prctile(k1_diff,25)
k1_x75_diff  = prctile(k1_diff,75)
k2_x25_diff  = prctile(k2_diff,25)
k2_x75_diff  = prctile(k2_diff,75)
snow_x25_diff  = prctile(snow_diff,25)
snow_x75_diff  = prctile(snow_diff,75)
land_x25_diff  = prctile(land_diff,25)
land_x75_diff  = prctile(land_diff,75)

iarr_k1_diff(2,:)   = (/min(k1_diff),k1_x25_diff,dim_median(k1_diff),k1_x75_diff,max(k1_diff)/)  ;CMIP6
iarr_k2_diff(2,:)   = (/min(k2_diff),k2_x25_diff,dim_median(k2_diff),k2_x75_diff,max(k2_diff)/)
iarr_snow_diff(2,:) = (/min(snow_diff),snow_x25_diff,dim_median(snow_diff),snow_x75_diff,max(snow_diff)/)
iarr_land_diff(2,:) = (/min(land_diff),land_x25_diff,dim_median(land_diff),land_x75_diff,max(land_diff)/)

;******************设置xy-plot***************************
color_GLASS    = "175"
color_clara_a3 = "2"
color_clara_a2 = "forestgreen"
color_APPx     = "deeppink2";"sienna4"

color_CRU  = (/"deeppink2","forestgreen","2"/)
color_GHCN =  (/"175","blue3","sienna4"/)

color_ERA5     = (/"sienna4"/)
color_ERA5snow = (/"blue3"/)
color_MERRA2   = (/"springgreen3"/)
color_JRA55    = (/"magenta"/)
color_JRA3Q    = (/"250"/)

color_mean     = "red"

mark_CRU  = 7
mark_GHCN = 7
mark_alb = 4
mark_rea = 2
mark_mean= 5

x = (/-0.6, 0., 0.6/)

x_obs = fspan(-0.9,-0.3,6)
print(x_obs)

res = True

;res@gsnMaximize = True
res@trXMinF    = -1.0
res@trXMaxF    = 1.0

; res@tmXBMode   = "Manual"
; res@tmXBTickStartF   = -0.4
; res@tmXBTickEndF     = 0.4
; res@tmXBTickSpacingF = 0.4
res@tmXBLabels = (/"OBS","Reanalysis","CMIP6"/)

res@vpWidthF   = 0.45   ;图形宽度

res@trYReverse = True
res@tmYRBorderOn     = True
res@tmXTBorderOn     = True

res@tmYLMajorLengthF = -0.012     ;y轴大刻度长度，负值朝外
res@tmXBMajorLengthF = -0.012     ;x轴大刻度长度，负值朝外
res@tmYLMinorLengthF = -0.008      ;小刻度长度
res@tmYLMajorThicknessF = 2        ;大刻度线宽
res@tmXBMajorThicknessF = 2        ;大刻度线宽
res@tmYLMinorThicknessF = 1        ;小刻度线宽

res@tmXBLabelFontHeightF = 0.023    ;字号
res@tmYLLabelFontHeightF = 0.022
res@tiYAxisFontHeightF   = 0.034
res@tiMainFontHeightF    = 0.035
;********************设置箱形图上下的两条线*******************
llres = True
llres@gsLineThicknessF = 1.6
;*********************设置箱子的颜色和宽度*********************
opti = True
opti@boxWidth  = 0.3
opti@boxColors = (/"black","black","black"/)

;*************************画箱形图**********************
;;*******第一列***********
res@trYReverse = False
res@tmYLPrecision    = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

;seasonal
res@trYMinF    = -5.0
res@trYMaxF    = -0.
res@tmYLMode   = "Manual"
res@tmYLTickStartF   = -5.0
res@tmYLTickSpacingF = 1.0
res@tmYLTickEndF     = -0.

res@tiYAxisString     = "Seasonal"
res@tiMainString = "~F33~D~F~S~B~C~N~/<~F33~D~F~T~B~S~N~> (%/K)"
plot1 = boxplot(wks,x,iarr_k1_SS,opti,res,llres)

;decadal
; res@trYMinF    = -4.0
; res@trYMaxF    = -0.
; res@tmYLMode   = "Manual"
; res@tmYLTickStartF   = -4.0
; res@tmYLTickSpacingF = 0.5
; res@tmYLTickEndF     = -0.

res@tiYAxisString     = "Decadal"
res@tiMainOn    = False
plot5 = boxplot(wks,x,iarr_k1_DS,opti,res,llres)

;difference
res@trYReverse = False

res@trYMinF    = -3.0
res@trYMaxF    = 3.
res@tmYLMode   = "Manual"
res@tmYLTickStartF   = -3.0
res@tmYLTickSpacingF = 1.0
res@tmYLTickEndF     = 3.

res@tiYAxisString     = "Decadal~V11F33~ _ ~V-11~~F~Seasonal"
plot9 = boxplot(wks,x,iarr_k1_diff,opti,res,llres)

;;*******第二列***********
res@trYReverse = False
res@tmYLPrecision    = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

;seasonal
res@trYMinF    = 15.
res@trYMaxF    = 45.
res@tmYLMode   = "Manual"
res@tmYLTickStartF   = 15.
res@tmYLTickSpacingF = 5.
res@tmYLTickEndF     = 45.

res@tiYAxisOn    = False
res@tiMainOn     = True
res@tiMainString = "~F33~a~F~~B~snow~N~~H-57V6F35~EEEEE~FV-6H3~~V11F33~ _ ~V-11~~F33~a~F~~B~land~N~ (%)"
plot2 = boxplot(wks,x,iarr_k2_SS,opti,res,llres)

;decadal
; res@trYMinF    = 15.
; res@trYMaxF    = 45.
; res@tmYLMode   = "Manual"
; res@tmYLTickStartF   = 15.
; res@tmYLTickSpacingF = 5.
; res@tmYLTickEndF     = 45.

res@tiMainOn    = False
plot6 = boxplot(wks,x,iarr_k2_DS,opti,res,llres)

;difference
res@trYMinF    = -2.0
res@trYMaxF    = 3.
res@tmYLMode   = "Manual"
res@tmYLTickStartF   = -2.0
res@tmYLTickSpacingF = 1.0
res@tmYLTickEndF     = 3.

res@tiYAxisString     = "Difference"
plot10 = boxplot(wks,x,iarr_k2_diff,opti,res,llres)

;;*******第三列***********
res@tmYLPrecision    = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

;seasonal
res@trYMinF    = 25.
res@trYMaxF    = 55.
res@tmYLMode   = "Manual"
res@tmYLTickStartF   = 25.
res@tmYLTickSpacingF = 5.
res@tmYLTickEndF     = 55.

res@tiMainOn   = True
res@tiMainString     = "~F33~a~F~~B~snow~N~~H-57V6F35~EEEEE~FV-6H3~ (%)"
; res@tiMainString     = "~F33~a~F~~B~snow~N~~H-15V6F35~E~FV-6H3~ (%)"

plot3 = boxplot(wks,x,iarr_snow_SS,opti,res,llres)

;decadal
; res@trYMinF    = 30.
; res@trYMaxF    = 60.
; res@tmYLMode   = "Manual"
; res@tmYLTickStartF   = 30.
; res@tmYLTickSpacingF = 5.
; res@tmYLTickEndF     = 60.

res@tiMainOn    = False
plot7 = boxplot(wks,x,iarr_snow_DS,opti,res,llres)

;difference
res@trYMinF    = -2.0
res@trYMaxF    = 3.
res@tmYLMode   = "Manual"
res@tmYLTickStartF   = -2.0
res@tmYLTickSpacingF = 1.0
res@tmYLTickEndF     = 3.

res@tiYAxisString     = "Difference"
plot11 = boxplot(wks,x,iarr_snow_diff,opti,res,llres)

;;*******第四列***********
res@tmYLPrecision    = 2    ;y轴精度
res@tmYLMinorPerMajor= 4   ;相邻大刻度间的小刻度数量

;seasonal
res@trYMinF    = 10.
res@trYMaxF    = 20.
res@tmYLMode   = "Manual"
res@tmYLTickStartF   = 10.
res@tmYLTickSpacingF = 2.
res@tmYLTickEndF     = 20.

res@tiMainOn   = True
res@tiMainString     = "~F33~a~F~~B~land~N~ (%)"
plot4 = boxplot(wks,x,iarr_land_SS,opti,res,llres)

;decadal
; res@trYMinF    = YMin_DS
; res@trYMaxF    = YMax_DS
; res@tmYLMode   = "Manual"
; res@tmYLTickStartF   = YLStart_DS
; res@tmYLTickSpacingF = YLSpace_DS
; res@tmYLTickEndF     = YLEnd_DS

res@tiMainOn    = False
plot8 = boxplot(wks,x,iarr_land_DS,opti,res,llres)

;difference
res@trYMinF    = -2.0
res@trYMaxF    = 3.
res@tmYLMode   = "Manual"
res@tmYLTickStartF   = -2.0
res@tmYLTickSpacingF = 1.0
res@tmYLTickEndF     = 3.

res@tiYAxisString     = "Difference"
plot12 = boxplot(wks,x,iarr_land_diff,opti,res,llres)

;**********************画平均值************************
mres = True
mres@gsMarkerIndex = 9
mres@gsMarkerSizeF = 9.0
mres@gsMarkerColor = "black"

;;cmip6
;seaslnal
k1_avg = avg(k1_SS)                       ; polymarker locations
k2_avg = avg(k2_SS)
snow_avg = avg(snow_SS)
land_avg = avg(land_SS)

; ;;print(k1_avg)
; ;;print(k2_avg)
; ;;print(snow_avg)
; ;;print(land_avg)

dum4 = gsn_add_polymarker(wks,plot1,x(2),k1_avg,mres)
dum5 = gsn_add_polymarker(wks,plot2,x(2),k2_avg,mres)
dum6 = gsn_add_polymarker(wks,plot3,x(2),snow_avg,mres)
dum7 = gsn_add_polymarker(wks,plot4,x(2),land_avg,mres)

;decadal
k1_avg = avg(k1_DS)                       ; polymarker locations
k2_avg = avg(k2_DS)
snow_avg = avg(snow_DS)
land_avg = avg(land_DS)

;print(k1_avg)
;print(k2_avg)
;print(snow_avg)
;print(land_avg)

dum4_DS = gsn_add_polymarker(wks,plot5,x(2),k1_avg,mres)
dum5_DS = gsn_add_polymarker(wks,plot6,x(2),k2_avg,mres)
dum6_DS = gsn_add_polymarker(wks,plot7,x(2),snow_avg,mres)
dum7_DS = gsn_add_polymarker(wks,plot8,x(2),land_avg,mres)

;difference
k1_avg   = avg(k1_DS - k1_SS)                       ; polymarker locations
k2_avg   = avg(k2_DS - k2_SS)
snow_avg = avg(snow_DS - snow_SS)
land_avg = avg(land_DS - land_SS)

dum4_diff = gsn_add_polymarker(wks,plot9, x(2),k1_avg,mres)
dum5_diff = gsn_add_polymarker(wks,plot10,x(2),k2_avg,mres)
dum6_diff = gsn_add_polymarker(wks,plot11,x(2),snow_avg,mres)
dum7_diff = gsn_add_polymarker(wks,plot12,x(2),land_avg,mres)

;**************画再分析***********
k1_rea_SS   = new(5,float)
k2_rea_SS   = new(5,float)
snow_rea_SS = new(5,float)
land_rea_SS = new(5,float)

k1_rea_SS(0) = tofloat(k1_ERA5_SS)
k1_rea_SS(1) = tofloat(k1_ERA5snow_SS)
k1_rea_SS(2) = tofloat(k1_JRA3Q_SS)
k1_rea_SS(3) = tofloat(k1_JRA55_SS)
k1_rea_SS(4) = tofloat(k1_MERRA2_SS)

k2_rea_SS(0) = tofloat(k2_ERA5_SS)
k2_rea_SS(1) = tofloat(k2_ERA5snow_SS)
k2_rea_SS(2) = tofloat(k2_JRA3Q_SS)
k2_rea_SS(3) = tofloat(k2_JRA55_SS)
k2_rea_SS(4) = tofloat(k2_MERRA2_SS)

snow_rea_SS(0) = tofloat(snow_ERA5_SS)
snow_rea_SS(1) = tofloat(snow_ERA5snow_SS)
snow_rea_SS(2) = tofloat(snow_JRA3Q_SS)
snow_rea_SS(3) = tofloat(snow_JRA55_SS)
snow_rea_SS(4) = tofloat(snow_MERRA2_SS)

land_rea_SS(0) = tofloat(land_ERA5_SS)
land_rea_SS(1) = tofloat(land_ERA5snow_SS)
land_rea_SS(2) = tofloat(land_JRA3Q_SS)
land_rea_SS(3) = tofloat(land_JRA55_SS)
land_rea_SS(4) = tofloat(land_MERRA2_SS)

k1_rea_DS = new(5,float)
k2_rea_DS = new(5,float)
snow_rea_DS = new(5,float)
land_rea_DS = new(5,float)

k1_rea_DS(0) = tofloat(k1_ERA5_DS)
k1_rea_DS(1) = tofloat(k1_ERA5snow_DS)
k1_rea_DS(2) = tofloat(k1_JRA3Q_DS)
k1_rea_DS(3) = tofloat(k1_JRA55_DS)
k1_rea_DS(4) = tofloat(k1_MERRA2_DS)

k2_rea_DS(0) = tofloat(k2_ERA5_DS)
k2_rea_DS(1) = tofloat(k2_ERA5snow_DS)
k2_rea_DS(2) = tofloat(k2_JRA3Q_DS)
k2_rea_DS(3) = tofloat(k2_JRA55_DS)
k2_rea_DS(4) = tofloat(k2_MERRA2_DS)

snow_rea_DS(0) = tofloat(snow_ERA5_DS)
snow_rea_DS(1) = tofloat(snow_ERA5snow_DS)
snow_rea_DS(2) = tofloat(snow_JRA3Q_DS)
snow_rea_DS(3) = tofloat(snow_JRA55_DS)
snow_rea_DS(4) = tofloat(snow_MERRA2_DS)

land_rea_DS(0) = tofloat(land_ERA5_DS)
land_rea_DS(1) = tofloat(land_ERA5snow_DS)
land_rea_DS(2) = tofloat(land_JRA3Q_DS)
land_rea_DS(3) = tofloat(land_JRA55_DS)
land_rea_DS(4) = tofloat(land_MERRA2_DS)

;**************画再分析************
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

;difference
dum_rea_1_diff = new(5,graphic)
dum_rea_2_diff = new(5,graphic)
dum_rea_3_diff = new(5,graphic)
dum_rea_4_diff = new(5,graphic)

k1_rea_diff   = k1_rea_DS - k1_rea_SS
k2_rea_diff   = k2_rea_DS - k2_rea_SS
snow_rea_diff = snow_rea_DS - snow_rea_SS
land_rea_diff = land_rea_DS - land_rea_SS

do i = 0,4
  mres2@gsMarkerColor = colors_rea(i)

  dum_rea_1_SS(i) = gsn_add_polymarker(wks,plot1,x(1),k1_rea_SS(i),mres2)
  dum_rea_2_SS(i) = gsn_add_polymarker(wks,plot2,x(1),k2_rea_SS(i),mres2)
  dum_rea_3_SS(i) = gsn_add_polymarker(wks,plot3,x(1),snow_rea_SS(i),mres2)
  dum_rea_4_SS(i) = gsn_add_polymarker(wks,plot4,x(1),land_rea_SS(i),mres2)

  dum_rea_1_DS(i) = gsn_add_polymarker(wks,plot5,x(1),k1_rea_DS(i),mres2)
  dum_rea_2_DS(i) = gsn_add_polymarker(wks,plot6,x(1),k2_rea_DS(i),mres2)
  dum_rea_3_DS(i) = gsn_add_polymarker(wks,plot7,x(1),snow_rea_DS(i),mres2)
  dum_rea_4_DS(i) = gsn_add_polymarker(wks,plot8,x(1),land_rea_DS(i),mres2)

  dum_rea_1_diff(i) = gsn_add_polymarker(wks,plot9,x(1),k1_rea_diff(i),mres2)
  dum_rea_2_diff(i) = gsn_add_polymarker(wks,plot10,x(1),k2_rea_diff(i),mres2)
  dum_rea_3_diff(i) = gsn_add_polymarker(wks,plot11,x(1),snow_rea_diff(i),mres2)
  dum_rea_4_diff(i) = gsn_add_polymarker(wks,plot12,x(1),land_rea_diff(i),mres2)
end do

;**********再分析 avg***********
mres2@gsMarkerIndex = mark_mean
mres2@gsMarkerColor := color_mean
mres2@gsMarkerSizeF = 13.
mres2@gsMarkerThicknessF = 2.2

k1_avg_SS   = avg(k1_rea_SS)
k2_avg_SS   = avg(k2_rea_SS)
snow_avg_SS = avg(snow_rea_SS)
land_avg_SS = avg(land_rea_SS)

k1_avg_DS   = avg(k1_rea_DS)
k2_avg_DS   = avg(k2_rea_DS)
snow_avg_DS = avg(snow_rea_DS)
land_avg_DS = avg(land_rea_DS)

k1_avg_diff   = avg(k1_rea_DS - k1_rea_SS)
k2_avg_diff   = avg(k2_rea_DS - k2_rea_SS)
snow_avg_diff = avg(snow_rea_DS - snow_rea_SS)
land_avg_diff = avg(land_rea_DS - land_rea_SS)


dum_rea_17_SS = gsn_add_polymarker(wks,plot1,x(1),k1_avg_SS,mres2)
dum_rea_27_SS = gsn_add_polymarker(wks,plot2,x(1),k2_avg_SS,mres2)
dum_rea_37_SS = gsn_add_polymarker(wks,plot3,x(1),snow_avg_SS,mres2)
dum_rea_47_SS = gsn_add_polymarker(wks,plot4,x(1),land_avg_SS,mres2)

dum_rea_17_DS = gsn_add_polymarker(wks,plot5,x(1),k1_avg_DS,mres2)
dum_rea_27_DS = gsn_add_polymarker(wks,plot6,x(1),k2_avg_DS,mres2)
dum_rea_37_DS = gsn_add_polymarker(wks,plot7,x(1),snow_avg_DS,mres2)
dum_rea_47_DS = gsn_add_polymarker(wks,plot8,x(1),land_avg_DS,mres2)

dum_rea_17_diff = gsn_add_polymarker(wks,plot9,x(1),k1_avg_diff,mres2)
dum_rea_27_diff = gsn_add_polymarker(wks,plot10,x(1),k2_avg_diff,mres2)
dum_rea_37_diff = gsn_add_polymarker(wks,plot11,x(1),snow_avg_diff,mres2)
dum_rea_47_diff = gsn_add_polymarker(wks,plot12,x(1),land_avg_diff,mres2)

;*************************************
;***************画观测*****************
colors_obs = (/color_APPx,color_clara_a2,color_clara_a3/)

mres3 = True
mres3@gsMarkerSizeF = 11.
mres3@gsMarkerThicknessF = 1.9

dum_obs_1_SS = new(3,graphic)
dum_obs_2_SS = new(3,graphic)
dum_obs_3_SS = new(3,graphic)
dum_obs_4_SS = new(3,graphic)

dum_obs_1_DS = new(3,graphic)
dum_obs_2_DS = new(3,graphic)
dum_obs_3_DS = new(3,graphic)
dum_obs_4_DS = new(3,graphic)

dum_obs_1_diff = new(3,graphic)
dum_obs_2_diff = new(3,graphic)
dum_obs_3_diff = new(3,graphic)
dum_obs_4_diff = new(3,graphic)

k1_obs_SS_avg   = dim_avg_n(k1_obs_SS,(/0,1/))
k2_obs_SS_avg   = dim_avg_n(k2_obs_SS,(/0,1/))
snow_obs_SS_avg = dim_avg_n(snow_obs_SS,(/0,1/))
land_obs_SS_avg = dim_avg_n(land_obs_SS,(/0,1/))

k1_obs_DS_avg   = dim_avg_n(k1_obs_DS,(/0,1/))
k2_obs_DS_avg   = dim_avg_n(k2_obs_DS,(/0,1/))
snow_obs_DS_avg = dim_avg_n(snow_obs_DS,(/0,1/))
land_obs_DS_avg = dim_avg_n(land_obs_DS,(/0,1/))

k1_obs_diff   = k1_obs_DS_avg - k1_obs_SS_avg
k2_obs_diff   = k2_obs_DS_avg - k2_obs_SS_avg
snow_obs_diff = snow_obs_DS_avg - snow_obs_SS_avg
land_obs_diff = land_obs_DS_avg - land_obs_SS_avg


do j = 0,2   ;alb
   mres3@gsMarkerIndex = mark_alb
   mres3@gsMarkerColor = colors_obs(j)

   dum_obs_2_SS(j) = gsn_add_polymarker(wks,plot2,x(0),k2_obs_SS_avg(j),mres3)
   dum_obs_3_SS(j) = gsn_add_polymarker(wks,plot3,x(0),snow_obs_SS_avg(j),mres3)
   dum_obs_4_SS(j) = gsn_add_polymarker(wks,plot4,x(0),land_obs_SS_avg(j),mres3)

   dum_obs_2_DS(j) = gsn_add_polymarker(wks,plot6,x(0),k2_obs_DS_avg(j),mres3)
   dum_obs_3_DS(j) = gsn_add_polymarker(wks,plot7,x(0),snow_obs_DS_avg(j),mres3)
   dum_obs_4_DS(j) = gsn_add_polymarker(wks,plot8,x(0),land_obs_DS_avg(j),mres3)

   dum_obs_2_diff(j) = gsn_add_polymarker(wks,plot10,x(0),k2_obs_diff(j),mres3)
   dum_obs_3_diff(j) = gsn_add_polymarker(wks,plot11,x(0),snow_obs_diff(j),mres3)
   dum_obs_4_diff(j) = gsn_add_polymarker(wks,plot12,x(0),land_obs_diff(j),mres3)
end do

;snc/tas
dum_obs_1_SS1   = new((/2,3/),graphic)
dum_obs_1_DS1   = new((/2,3/),graphic)
dum_obs_1_diff1 = new((/2,3/),graphic)

k1_obs_diff   := k1_obs_DS - k1_obs_SS

do i = 0,2  ;snc
  ;CRU
  mres3@gsMarkerIndex = mark_CRU
  mres3@gsMarkerColor = color_CRU(i)

  dum_obs_1_SS1(0,i)   = gsn_add_polymarker(wks,plot1,x(0),k1_obs_SS(0,i,0),mres3)
  dum_obs_1_DS1(0,i)   = gsn_add_polymarker(wks,plot5,x(0),k1_obs_DS(0,i,0),mres3)
  dum_obs_1_diff1(0,i) = gsn_add_polymarker(wks,plot9,x(0),k1_obs_diff(0,i,0),mres3)

  ;GHCN
  mres3@gsMarkerIndex = mark_GHCN
  mres3@gsMarkerColor = color_GHCN(i)
  dum_obs_1_SS1(1,i)   = gsn_add_polymarker(wks,plot1,x(0),k1_obs_SS(1,i,0),mres3)
  dum_obs_1_DS1(1,i)   = gsn_add_polymarker(wks,plot5,x(0),k1_obs_DS(1,i,0),mres3)
  dum_obs_1_diff1(1,i) = gsn_add_polymarker(wks,plot9,x(0),k1_obs_diff(1,i,0),mres3)
end do

;**********观测 avg***********
mres3@gsMarkerIndex = mark_mean
mres3@gsMarkerColor = color_mean
mres3@gsMarkerSizeF = 13.
mres3@gsMarkerThicknessF = 2.2

;*******
k1_avg_SS   := avg(k1_obs_SS)
k2_avg_SS   := avg(k2_obs_SS)
snow_avg_SS := avg(snow_obs_SS)
land_avg_SS := avg(land_obs_SS)

k1_avg_DS   := avg(k1_obs_DS)
k2_avg_DS   := avg(k2_obs_DS)
snow_avg_DS := avg(snow_obs_DS)
land_avg_DS := avg(land_obs_DS)

k1_avg_diff   := k1_avg_DS - k1_avg_SS
k2_avg_diff   := k2_avg_DS - k2_avg_SS
snow_avg_diff := snow_avg_DS - snow_avg_SS
land_avg_diff := land_avg_DS - land_avg_SS

dum_obs_17_SS_avg = gsn_add_polymarker(wks,plot1,x(0),k1_avg_SS,mres3)
dum_obs_27_SS_avg = gsn_add_polymarker(wks,plot2,x(0),k2_avg_SS,mres3)
dum_obs_37_SS_avg = gsn_add_polymarker(wks,plot3,x(0),snow_avg_SS,mres3)
dum_obs_47_SS_avg = gsn_add_polymarker(wks,plot4,x(0),land_avg_SS,mres3)

dum_obs_17_DS_avg = gsn_add_polymarker(wks,plot5,x(0),k1_avg_DS,mres3)
dum_obs_27_DS_avg = gsn_add_polymarker(wks,plot6,x(0),k2_avg_DS,mres3)
dum_obs_37_DS_avg = gsn_add_polymarker(wks,plot7,x(0),snow_avg_DS,mres3)
dum_obs_47_DS_avg = gsn_add_polymarker(wks,plot8,x(0),land_avg_DS,mres3)

dum_obs_17_diff_avg = gsn_add_polymarker(wks,plot9,x(0),k1_avg_diff,mres3)
dum_obs_27_diff_avg = gsn_add_polymarker(wks,plot10,x(0),k2_avg_diff,mres3)
dum_obs_37_diff_avg = gsn_add_polymarker(wks,plot11,x(0),snow_avg_diff,mres3)
dum_obs_47_diff_avg = gsn_add_polymarker(wks,plot12,x(0),land_avg_diff,mres3)

;*******************************legend*****************************
index       = new(15,"integer")
index(0:2)  = mark_CRU
index(3:5)  = mark_GHCN
index(6:8)  = mark_alb
index(9:13)= mark_rea
index(14)   = mark_mean

xleg    = new(15,float)
xleg(:) = 0.845 ; legend markers位置
xtxt    := xleg+0.01

yleg := fspan(0.8,0.48,15)+0.07   ; text位置
ytxt := fspan(0.8,0.48,15)+0.07

colors = new(16,typeof(color_CRU))
colors(0:2) = color_CRU
colors(3:5) = color_GHCN
colors(6:14)= (/color_APPx,color_clara_a2,color_clara_a3,\
                color_ERA5,color_ERA5snow,color_JRA3Q,color_JRA55,color_MERRA2,color_mean/)

labels := (/"CRU + JASMES","CRU + NSIDC","CRU + Rutgers","GHCN-CAM + JASMES","GHCN-CAM + NSIDC","GHCN-CAM + Rutgers",\
            "APP-x","CLARA-A2","CLARA-A3",\
            "ERA5-Land","ERA5-Snow","JRA-3Q","JRA-55","MERRA-2","Mean"/)

do i = 0,14
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
; pres@gsnPanelMainFontHeightF     = 0.015
 pres@gsnPanelXWhiteSpacePercent  = 8       ;留白
; pres@gsnPanelYWhiteSpacePercent  = 7

pres@gsnPanelFigureStrings  = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)","(k)","(l)"/)
pres@gsnPanelFigureStringsJust    = "TopLeft"
pres@gsnPanelFigureStringsPerimOn = False
; pres@gsnPanelFigureStringsFontHeightF = 0.01

XF = fspan(0.054,0.658,4)
pres@gsnPanelXF = (/XF(0),XF(1),XF(2),XF(3),\
                    XF(0),XF(1),XF(2),XF(3),\
                    XF(0),XF(1),XF(2),XF(3)/)

; YF = fspan(0.92,0.2,3)
; pres@gsnPanelXF = (/YF(0),YF(0),YF(0),YF(0),\
;                     YF(1),YF(1),YF(1),YF(1),\
;                     YF(2),YF(2),YF(2),YF(2)/)

gsn_panel(wks,(/plot1,plot2,plot3,plot4,\
                plot5,plot6,plot7,plot8,\
                plot9,plot10,plot11,plot12/),(/3,4/),pres)
;print("f2")

end
