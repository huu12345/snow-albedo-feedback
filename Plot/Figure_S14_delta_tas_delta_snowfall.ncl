begin

;生成多元线性拟合所需要的数据，季节与年代际数据合并在一起

model6 = (/"APP-x","CLARA-A2","CLARA-A3","ERA5-Land","ERA5-Snow","JRA-3Q","JRA-55","MERRA-2",\
" ","ACCESS-ESM1-5","BCC-ESM1","CanESM5",\
"CESM2","CESM2-FV2","CESM2-WACCM","CESM2-WACCM-FV2",\
"CNRM-CM6-1","CNRM-CM6-1-HR","CNRM-ESM2-1","E3SM-2-0",\
"E3SM-2-1","EC-Earth3","EC-Earth3-AerChem","EC-Earth3-Veg","EC-Earth3-Veg-LR",\
"FGOALS-f3-L","GISS-E2-1-G","GISS-E2-2-G","GISS-E3-G","HadGEM3-GC31-LL",\
"IPSL-CM6A-LR","IPSL-CM6A-MR1","MIROC6","MIROC-ES2L",\
"MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1",\
"UKESM1-0-LL"/)
; ;print(model6)

n_model6 = dimsizes(model6)

inpath="/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/reviewer3_amip/"

outpath = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/snowfall/"
name    = "Figure_S14"

; *************************网格面积**************************
f=addfile("/home/hujl/data_script/mask_greenland_MODIS/MCD12C1/mask_greenland_MCD12C1_1.0x1.0.nc","r")

newlat = f->lat({45:90})
newlon = f->lon

nlat = dimsizes(newlat)
nlon = dimsizes(newlon)

pi = 3.1415926
r  = 6372*10^3   ;radius

areacella = new((/nlat,nlon/),float)

do i = 0,nlat-1
  do j = 0,nlon-1
    areacella(i,j) = cos(newlat(i)/180.0*pi)
    ; areacella(i,j) = abs(r*r*0.5/180*pi*(sin((newlat(i)+0.25)/180*pi)-sin((newlat(i)-0.25)/180*pi)))
  end do
end do

; *************************季节时间尺度 CMIP6**************************
f=addfile(inpath+"data_fit_seasonal_cmip6.nc","r")

coeff_tas = f->coeff_tas  ;model*lat*lon
coeff_prsn= f->coeff_prsn

delta_tas = f->delta_tas_mk  ;model*mon*year*lat*lon
delta_alpsnow = f->delta_alpsnow_mk
delta_prsn = f->delta_prsn_mk

;将NaN值替换为默认的_FillValue
if (any(isnan_ieee(coeff_tas))) then
    replace_ieeenan(coeff_tas, -999., 0)
end if
if (any(isnan_ieee(coeff_prsn))) then
    replace_ieeenan(coeff_prsn, -999., 0)
end if
if (any(isnan_ieee(delta_tas))) then
    replace_ieeenan(delta_tas, -999., 0)
end if
if (any(isnan_ieee(delta_alpsnow))) then
    replace_ieeenan(delta_alpsnow, -999., 0)
end if
if (any(isnan_ieee(delta_prsn))) then
    replace_ieeenan(delta_prsn, -999., 0)
end if

coeff_tas@_FillValue = -999.
coeff_prsn@_FillValue = -999.
delta_tas@_FillValue = -999.
delta_alpsnow@_FillValue = -999.
delta_prsn@_FillValue = -999.

;年平均
delta_tas := dim_avg_n(delta_tas,(/1,2/))  ;model*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,(/1,2/))
delta_prsn := dim_avg_n(delta_prsn,(/1,2/))

;贡献
contr_tas = delta_tas*coeff_tas ;model*lat*lon
contr_prsn = delta_prsn*coeff_prsn

;面积权重
areacella_3d  = conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_tas),areacella_3d@_FillValue,areacella_3d)
delta_tas_model_SS = dim_sum_n(delta_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(delta_prsn),areacella_3d@_FillValue,areacella_3d)
delta_prsn_model_SS = dim_sum_n(delta_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_model_SS = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_model_SS = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_model_SS = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_model_SS = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; *************************季节时间尺度 观测**************************
f=addfile(inpath+"data_fit_seasonal_obs.nc","r")

coeff_tas := f->coeff_tas  ;model*lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;model*mon*year*lat*lon
delta_alpsnow := f->delta_alpsnow_mk
delta_prsn := f->delta_prsn_mk
; printMinMax(delta_tas(1,:,:,:),True)

;将NaN值替换为默认的_FillValue
if (any(isnan_ieee(coeff_tas))) then
    replace_ieeenan(coeff_tas, -999., 0)
end if
if (any(isnan_ieee(coeff_prsn))) then
    replace_ieeenan(coeff_prsn, -999., 0)
end if
if (any(isnan_ieee(delta_tas))) then
    replace_ieeenan(delta_tas, -999., 0)
end if
if (any(isnan_ieee(delta_alpsnow))) then
    replace_ieeenan(delta_alpsnow, -999., 0)
end if
if (any(isnan_ieee(delta_prsn))) then
    replace_ieeenan(delta_prsn, -999., 0)
end if

coeff_tas@_FillValue = -999.
coeff_prsn@_FillValue = -999.
delta_tas@_FillValue = -999.
delta_alpsnow@_FillValue = -999.
delta_prsn@_FillValue = -999.
; printMinMax(delta_tas(1,:,:,:,:),True)
printVarSummary(delta_tas)

;年平均
delta_tas := dim_avg_n(delta_tas,(/1,2/))  ;model*mon*year*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,(/1,2/))
delta_prsn := dim_avg_n(delta_prsn,(/1,2/))

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d  := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_tas),areacella_3d@_FillValue,areacella_3d)
delta_tas_obs_SS = dim_sum_n(delta_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))
; print(delta_tas_rea_SS)

areacella_mk := where(ismissing(delta_prsn),areacella_3d@_FillValue,areacella_3d)
delta_prsn_obs_SS = dim_sum_n(delta_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_obs_SS = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_obs_SS = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_obs_SS = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_obs_SS = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; *************************季节时间尺度 再分析**************************
f=addfile(inpath+"data_fit_seasonal_rea.nc","r")

coeff_tas := f->coeff_tas  ;model*lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;model*mon*year*lat*lon
delta_alpsnow := f->delta_alpsnow_mk
delta_prsn := f->delta_prsn_mk
; printMinMax(delta_tas(1,:,:,:),True)

;将NaN值替换为默认的_FillValue
if (any(isnan_ieee(coeff_tas))) then
    replace_ieeenan(coeff_tas, -999., 0)
end if
if (any(isnan_ieee(coeff_prsn))) then
    replace_ieeenan(coeff_prsn, -999., 0)
end if
if (any(isnan_ieee(delta_tas))) then
    replace_ieeenan(delta_tas, -999., 0)
end if
if (any(isnan_ieee(delta_alpsnow))) then
    replace_ieeenan(delta_alpsnow, -999., 0)
end if
if (any(isnan_ieee(delta_prsn))) then
    replace_ieeenan(delta_prsn, -999., 0)
end if

coeff_tas@_FillValue = -999.
coeff_prsn@_FillValue = -999.
delta_tas@_FillValue = -999.
delta_alpsnow@_FillValue = -999.
delta_prsn@_FillValue = -999.
printMinMax(delta_tas(1,:,:,:,:),True)
; printVarSummary(delta_tas)

;年平均
delta_tas := dim_avg_n(delta_tas,(/1,2/))  ;model*mon*year*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,(/1,2/))
delta_prsn := dim_avg_n(delta_prsn,(/1,2/))

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d  := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_tas),areacella_3d@_FillValue,areacella_3d)
delta_tas_rea_SS = dim_sum_n(delta_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))
; print(delta_tas_rea_SS)

areacella_mk := where(ismissing(delta_prsn),areacella_3d@_FillValue,areacella_3d)
delta_prsn_rea_SS = dim_sum_n(delta_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_rea_SS = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_rea_SS = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_rea_SS = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_rea_SS = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; *************************年代际时间尺度 CMIP6**************************
f=addfile(inpath+"data_fit_decadal_cmip6.nc","r")

coeff_tas := f->coeff_tas  ;model*lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;model*mon*year*lat*lon
delta_alpsnow := f->delta_alpsnow_mk
delta_prsn := f->delta_prsn_mk

;将NaN值替换为默认的_FillValue
if (any(isnan_ieee(coeff_tas))) then
    replace_ieeenan(coeff_tas, -999., 0)
end if
if (any(isnan_ieee(coeff_prsn))) then
    replace_ieeenan(coeff_prsn, -999., 0)
end if
if (any(isnan_ieee(delta_tas))) then
    replace_ieeenan(delta_tas, -999., 0)
end if
if (any(isnan_ieee(delta_alpsnow))) then
    replace_ieeenan(delta_alpsnow, -999., 0)
end if
if (any(isnan_ieee(delta_prsn))) then
    replace_ieeenan(delta_prsn, -999., 0)
end if

coeff_tas@_FillValue = -999.
coeff_prsn@_FillValue = -999.
delta_tas@_FillValue = -999.
delta_alpsnow@_FillValue = -999.
delta_prsn@_FillValue = -999.

;年平均
delta_tas := dim_avg_n(delta_tas,1)  ;model*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,1)
delta_prsn := dim_avg_n(delta_prsn,1)

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d  := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_tas),areacella_3d@_FillValue,areacella_3d)
delta_tas_model_DS = dim_sum_n(delta_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(delta_prsn),areacella_3d@_FillValue,areacella_3d)
delta_prsn_model_DS = dim_sum_n(delta_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_model_DS = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_model_DS = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_model_DS = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_model_DS = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; *************************年代际时间尺度 观测**************************
f=addfile(inpath+"data_fit_decadal_obs.nc","r")

coeff_tas := f->coeff_tas  ;model*lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;model*year*lat*lon
delta_alpsnow := f->delta_alpsnow_mk
delta_prsn := f->delta_prsn_mk

;将NaN值替换为默认的_FillValue
if (any(isnan_ieee(coeff_tas))) then
    replace_ieeenan(coeff_tas, -999., 0)
end if
if (any(isnan_ieee(coeff_prsn))) then
    replace_ieeenan(coeff_prsn, -999., 0)
end if
if (any(isnan_ieee(delta_tas))) then
    replace_ieeenan(delta_tas, -999., 0)
end if
if (any(isnan_ieee(delta_alpsnow))) then
    replace_ieeenan(delta_alpsnow, -999., 0)
end if
if (any(isnan_ieee(delta_prsn))) then
    replace_ieeenan(delta_prsn, -999., 0)
end if

coeff_tas@_FillValue = -999.
coeff_prsn@_FillValue = -999.
delta_tas@_FillValue = -999.
delta_alpsnow@_FillValue = -999.
delta_prsn@_FillValue = -999.

;年平均
delta_tas := dim_avg_n(delta_tas,1)  ;model*year*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,1)
delta_prsn := dim_avg_n(delta_prsn,1)

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d  := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_tas),areacella_3d@_FillValue,areacella_3d)
delta_tas_obs_DS = dim_sum_n(delta_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(delta_prsn),areacella_3d@_FillValue,areacella_3d)
delta_prsn_obs_DS = dim_sum_n(delta_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_obs_DS = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_obs_DS = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_obs_DS = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_obs_DS = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; *************************年代际时间尺度 再分析**************************
f=addfile(inpath+"data_fit_decadal_rea.nc","r")

coeff_tas := f->coeff_tas  ;model*lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;model*year*lat*lon
delta_alpsnow := f->delta_alpsnow_mk
delta_prsn := f->delta_prsn_mk

;将NaN值替换为默认的_FillValue
if (any(isnan_ieee(coeff_tas))) then
    replace_ieeenan(coeff_tas, -999., 0)
end if
if (any(isnan_ieee(coeff_prsn))) then
    replace_ieeenan(coeff_prsn, -999., 0)
end if
if (any(isnan_ieee(delta_tas))) then
    replace_ieeenan(delta_tas, -999., 0)
end if
if (any(isnan_ieee(delta_alpsnow))) then
    replace_ieeenan(delta_alpsnow, -999., 0)
end if
if (any(isnan_ieee(delta_prsn))) then
    replace_ieeenan(delta_prsn, -999., 0)
end if

coeff_tas@_FillValue = -999.
coeff_prsn@_FillValue = -999.
delta_tas@_FillValue = -999.
delta_alpsnow@_FillValue = -999.
delta_prsn@_FillValue = -999.

;年平均
delta_tas := dim_avg_n(delta_tas,1)  ;model*year*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,1)
delta_prsn := dim_avg_n(delta_prsn,1)

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d  := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_tas),areacella_3d@_FillValue,areacella_3d)
delta_tas_rea_DS = dim_sum_n(delta_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(delta_prsn),areacella_3d@_FillValue,areacella_3d)
delta_prsn_rea_DS = dim_sum_n(delta_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_rea_DS = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_rea_DS = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_rea_DS = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_rea_DS = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))


; *************************将观测和模式放在一个数组**************************
coeff_tas_all_SS  = new(n_model6,double)
coeff_prsn_all_SS = new(n_model6,double)
delta_tas_all_SS  = new(n_model6,double)
delta_prsn_all_SS = new(n_model6,double)
contr_tas_all_SS  = new(n_model6,double)
contr_prsn_all_SS = new(n_model6,double)

coeff_tas_all_DS  = new(n_model6,double)
coeff_prsn_all_DS = new(n_model6,double)
delta_tas_all_DS  = new(n_model6,double)
delta_prsn_all_DS = new(n_model6,double)
contr_tas_all_DS  = new(n_model6,double)
contr_prsn_all_DS = new(n_model6,double)

;观测
coeff_tas_all_SS(0:2)  = coeff_tas_obs_SS
coeff_prsn_all_SS(0:2) = coeff_prsn_obs_SS
delta_tas_all_SS(0:2)  = delta_tas_obs_SS
delta_prsn_all_SS(0:2) = delta_prsn_obs_SS
contr_tas_all_SS(0:2)  = contr_tas_obs_SS
contr_prsn_all_SS(0:2) = contr_prsn_obs_SS

coeff_tas_all_DS(0:2)  = coeff_tas_obs_DS
coeff_prsn_all_DS(0:2) = coeff_prsn_obs_DS
delta_tas_all_DS(0:2)  = delta_tas_obs_DS
delta_prsn_all_DS(0:2) = delta_prsn_obs_DS
contr_tas_all_DS(0:2)  = contr_tas_obs_DS
contr_prsn_all_DS(0:2) = contr_prsn_obs_DS

;再分析
coeff_tas_all_SS(3:7)  = coeff_tas_rea_SS
coeff_prsn_all_SS(3:7) = coeff_prsn_rea_SS
delta_tas_all_SS(3:7)  = delta_tas_rea_SS
delta_prsn_all_SS(3:7) = delta_prsn_rea_SS
contr_tas_all_SS(3:7)  = contr_tas_rea_SS
contr_prsn_all_SS(3:7) = contr_prsn_rea_SS

coeff_tas_all_DS(3:7)  = coeff_tas_rea_DS
coeff_prsn_all_DS(3:7) = coeff_prsn_rea_DS
delta_tas_all_DS(3:7)  = delta_tas_rea_DS
delta_prsn_all_DS(3:7) = delta_prsn_rea_DS
contr_tas_all_DS(3:7)  = contr_tas_rea_DS
contr_prsn_all_DS(3:7) = contr_prsn_rea_DS

;模式平均
coeff_tas_all_SS(8)  = avg(coeff_tas_model_SS)
coeff_prsn_all_SS(8) = avg(coeff_prsn_model_SS)
delta_tas_all_SS(8)  = avg(delta_tas_model_SS)
delta_prsn_all_SS(8) = avg(delta_prsn_model_SS)
contr_tas_all_SS(8)  = avg(contr_tas_model_SS)
contr_prsn_all_SS(8) = avg(contr_prsn_model_SS)

coeff_tas_all_DS(8)  = avg(coeff_tas_model_DS)
coeff_prsn_all_DS(8) = avg(coeff_prsn_model_DS)
delta_tas_all_DS(8)  = avg(delta_tas_model_DS)
delta_prsn_all_DS(8) = avg(delta_prsn_model_DS)
contr_tas_all_DS(8)  = avg(contr_tas_model_DS)
contr_prsn_all_DS(8) = avg(contr_prsn_model_DS)

;模式
coeff_tas_all_SS(9:n_model6-1)  = coeff_tas_model_SS
coeff_prsn_all_SS(9:n_model6-1) = coeff_prsn_model_SS
delta_tas_all_SS(9:n_model6-1)  = delta_tas_model_SS
delta_prsn_all_SS(9:n_model6-1) = delta_prsn_model_SS
contr_tas_all_SS(9:n_model6-1)  = contr_tas_model_SS
contr_prsn_all_SS(9:n_model6-1) = contr_prsn_model_SS

coeff_tas_all_DS(9:n_model6-1)  = coeff_tas_model_DS
coeff_prsn_all_DS(9:n_model6-1) = coeff_prsn_model_DS
delta_tas_all_DS(9:n_model6-1)  = delta_tas_model_DS
delta_prsn_all_DS(9:n_model6-1) = delta_prsn_model_DS
contr_tas_all_DS(9:n_model6-1)  = contr_tas_model_DS
contr_prsn_all_DS(9:n_model6-1) = contr_prsn_model_DS


a=avg(delta_tas_all_SS(3:7))
print("rea delta_tas SS: "+a)

a=avg(delta_tas_all_DS(3:7))
print("rea delta_tas DS: "+a)

; a=avg(contr_tas_all_SS(0:2))
; print("OBS contr_tas SS: "+a)
;
; a=avg(contr_tas_all_DS(0:2))
; print("OBS contr_tas DS: "+a)

a=avg(delta_prsn_all_SS(3:7))
print("rea delta_prsn SS: "+a)

a=avg(delta_prsn_all_DS(3:7))
print("rea delta_prsn DS: "+a)

;print(delta_prsn_all_SS(0:1))
;print(delta_prsn_all_DS(0:1))

; a1 = avg(delta_tas_all_SS(1:n_model6-1))
; std1 = stddev(delta_tas_all_SS(1:n_model6-1))
; CV1 = std1/abs(a1)
;
; a2 = avg(delta_tas_all_DS(1:n_model6-1))
; std2 = stddev(delta_tas_all_DS(1:n_model6-1))
; CV2 = std2/abs(a2)
; ;print("CMIP6 delta_tas CV SS: "+CV1)
; ;print("CMIP6 delta_tas CV DS: "+CV2)
;
; a1 = avg(delta_prsn_all_SS(1:n_model6-1))
; std1 = stddev(delta_prsn_all_SS(1:n_model6-1))
; CV1 = std1/abs(a1)
;
; a2 = avg(delta_prsn_all_DS(1:n_model6-1))
; std2 = stddev(delta_prsn_all_DS(1:n_model6-1))
; CV2 = std2/abs(a2)
; ;print("CMIP6 delta_prsn CV SS: "+CV1)
; ;print("CMIP6 delta_prsn CV DS: "+CV2)

;************画图**************
wks = gsn_open_wks("pdf",outpath+name)

res = True
res@gsnDraw = False
res@gsnFrame = False

res@tmXTOn     = False
; res@tmXBOn     = False
res@tmXBLabelsOn= False

res@tmBorderThicknessF  = 0.1
res@tmXBMajorThicknessF = 0.1
res@tmYLMajorThicknessF = 0.1
res@tmYRMajorThicknessF = 0.1
res@tmXBMinorThicknessF = 0.1
res@tmYLMinorThicknessF = 0.1
res@tmYRMinorThicknessF = 0.1

res@vpWidthF           = 0.5
res@vpHeightF          = 0.2
res@trXMinF            = 1-0.2-0.2
res@trXMaxF            = n_model6+0.2+0.2

res@tmXBMode           = "Explicit"         ; explicit labels
res@tmXBValues         = ispan(1,n_model6,1)
res@tmXBLabels         = model6

res@tmXBLabelFontHeightF = 0.009
res@tmYLLabelFontHeightF = 0.009

res@tmXBLabelAngleF = 90    ;标注倾斜角度
res@tmXBLabelDeltaF = 0.1   ;标注与刻度的距离
res@tmXBLabelJust = "CenterCenter"

res@gsnYRefLine            = 0.0
; res@gsnYRefLineColor       = "grey50"
; res@gsnYRefLineThicknessF  = 0.5
res@gsnYRefLineDashPattern = 0

; res@trYReverse = True

; res@trYMinF          = -0.04
; res@trYMaxF          = 0.2
; res@tmYLMode         = "Manual"
; res@tmYLTickStartF   = -0.04
; res@tmYLTickSpacingF = 0.04
; res@tmYLTickEndF     = 0.2

res@gsnXYBarChart = True
res@gsnXYBarChartBarWidth = 0.26           ; change bar widths
res@gsnXYBarChartColors = "dodgerblue"
res@xyLineColors = (/"dodgerblue","dodgerblue"/)   ;边框颜色
res@xyLineThicknesses = (/0.001,0.001/)  ;边框线宽

; ========== 图1-2: tas change ==========
plot = new(4,graphic)

x_SS = ispan(1, n_model6, 1)   ; SS向左偏移
x_DS = ispan(1, n_model6, 1)   ; DS向右偏移

res@tiYAxisString  = "~F33~D~F21~T (K)"
res@tiYAxisFontHeightF = 0.019
res@tiYAxisOffsetXF    = -0.005

res@trYMinF = -2.3
res@trYMaxF = 11.

res@tiMainString= "Seasonal"
res@tiMainFontHeightF = 0.019
res@tiMainOffsetYF    = 0.007

plot(0) = gsn_csm_xy(wks, x_SS, delta_tas_all_SS, res)

;******
res@trYMinF = -0.3
res@trYMaxF = 1.5

res@tiYAxisOn       = False
res@tiMainString= "Decadal"
plot(1) = gsn_csm_xy(wks, x_DS, delta_tas_all_DS, res)

res@tiMainOn        = False

; ========== 图3-4: prsn change ==========
res@tiYAxisOn     = True
res@tiYAxisString = "~F33~D~F21~P (kg m~S~-2~N~)"
res@tmXBLabelsOn  = True

res@trYMinF = -21.
res@trYMaxF = 0.

plot(2) = gsn_csm_xy(wks, x_SS, delta_prsn_all_SS, res)

;******
res@trYMinF = -2.
res@trYMaxF = 3.

res@tiYAxisOn       = False
plot(3) = gsn_csm_xy(wks, x_DS, delta_prsn_all_DS, res)

; ; ========== 图5-6: tas contribution ==========
; res@tiYAxisOn     = True
; res@tiYAxisString = "~F33~b~F21~~B~T~N~ ~F33~D~F21~T (%)"
;
; res@trYMinF = -13.
; res@trYMaxF = 0.
;
; plot(4) = gsn_csm_xy(wks, x_SS, contr_tas_all_SS, res)
;
; ;******
; res@trYMinF = -1.9
; res@trYMaxF = 0.
;
; res@tiYAxisOn       = False
; plot(5) = gsn_csm_xy(wks, x_DS, contr_tas_all_DS, res)

; ; ========== 图7-8: prsn contribution ==========
; res@tiYAxisOn     = True
; res@tiYAxisString = "~F33~b~F21~~B~P~N~ ~F33~D~F21~P (%)"
; res@tmXBLabelsOn  = True
;
; res@trYMinF = -3.
; res@trYMaxF = 0.
;
; plot(6) = gsn_csm_xy(wks, x_SS, contr_prsn_all_SS, res)
;
; ;******
; res@trYMinF = -0.4
; res@trYMaxF = 0.3
;
; res@tiYAxisOn       = False
; plot(7) = gsn_csm_xy(wks, x_DS, contr_prsn_all_DS, res)

; ========== 手动添加X轴标签（加粗CMIP6 mean）==========
txres = True
txres@txFontHeightF = 0.0075
txres@txFont = 22
txres@txFontColor = "black"
txres@txAngleF = 90
txres@txJust = "CenterCenter"
txres@txFontThicknessF = 10.0

gsn_text_ndc(wks, "CMIP6 Mean", 0.164, 0.247, txres)
gsn_text_ndc(wks, "CMIP6 Mean", 0.659, 0.247, txres)

gsn_text_ndc(wks, "CMIP6 Mean", 0.164, 0.247, txres)
gsn_text_ndc(wks, "CMIP6 Mean", 0.659, 0.247, txres)

;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
;pres@gsnMaximize   = True
pres@gsnPanelXWhiteSpacePercent = 2
pres@gsnPanelYWhiteSpacePercent = 1

pres@gsnPanelFigureStrings        = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)"/)
pres@gsnPanelFigureStringsJust    = "BottomRight"
pres@gsnPanelFigureStringsPerimOn = False
pres@gsnPanelFigureStringsFontHeightF = 0.009

; pres@gsnPanelLabelBar = True
; pres@lbLabelFontHeightF   = 0.016
; pres@gsnPanelBottom = 0.001
XF = (/0.077,0.572/)
pres@gsnPanelXF = (/XF(0),XF(1),\
                    XF(0),XF(1)/)

YF = fspan(0.7,0.47,2)
pres@gsnPanelYF = (/YF(0),YF(0),\
                    YF(1),YF(1)/)

gsn_panel(wks,plot,(/2,2/),pres)

end
