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
; print(model6)

n_model6 = dimsizes(model6)

inpath="/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/reviewer3_amip/"

outpath = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/snowfall/"
name    = "Figure_12"

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

;年平均，选择月份
delta_tas := dim_avg_n(delta_tas,(/1,2/))  ;model*mon*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,(/1,2/))
delta_prsn := dim_avg_n(delta_prsn,(/1,2/))
; printVarSummary(delta_prsn)
; delta_alpsnow := delta_alpsnow(:,0,:,:)
; delta_tas := delta_tas(:,0,:,:)
; delta_prsn := delta_prsn(:,0,:,:)

;贡献
contr_tas = delta_tas*coeff_tas ;model*lat*lon
contr_prsn = delta_prsn*coeff_prsn

;面积权重
areacella_3d  = conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_alpsnow),areacella_3d@_FillValue,areacella_3d)
delta_alpsnow_SS_cmip6 = dim_sum_n(delta_alpsnow*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_SS_cmip6 = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_SS_cmip6 = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_SS_cmip6 = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_SS_cmip6 = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; *************************季节时间尺度 观测**************************
f=addfile(inpath+"data_fit_seasonal_obs.nc","r")

coeff_tas := f->coeff_tas  ;lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;mon*year*lat*lon
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

; printMinMax(coeff_tas,True)
; printMinMax(delta_tas,True)

;年平均，选择月份
delta_tas := dim_avg_n(delta_tas,(/1,2/))  ;model*mon*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,(/1,2/))
delta_prsn := dim_avg_n(delta_prsn,(/1,2/))
; printVarSummary(delta_prsn)
; delta_alpsnow := delta_alpsnow(:,0,:,:)
; delta_tas := delta_tas(:,0,:,:)
; delta_prsn := delta_prsn(:,0,:,:)

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d  := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_alpsnow),areacella_3d@_FillValue,areacella_3d)
delta_alpsnow_SS_obs = dim_sum_n(delta_alpsnow*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_SS_obs = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_SS_obs = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_SS_obs = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_SS_obs = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; print(delta_alpsnow_SS_obs)

; *************************季节时间尺度 再分析**************************
f=addfile(inpath+"data_fit_seasonal_rea.nc","r")

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

;年平均，选择月份
delta_tas := dim_avg_n(delta_tas,(/1,2/))  ;model*mon*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,(/1,2/))
delta_prsn := dim_avg_n(delta_prsn,(/1,2/))
; printVarSummary(delta_prsn)
; delta_alpsnow := delta_alpsnow(:,0,:,:)
; delta_tas := delta_tas(:,0,:,:)
; delta_prsn := delta_prsn(:,0,:,:)

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d  := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;model*lat*lon

areacella_mk := where(ismissing(delta_alpsnow),areacella_3d@_FillValue,areacella_3d)
delta_alpsnow_SS_rea = dim_sum_n(delta_alpsnow*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_SS_rea = dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_SS_rea = dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_SS_rea = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_SS_rea = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))


; *************************年代际时间尺度 CMIP6**************************
f=addfile(inpath+"data_fit_decadal_cmip6.nc","r")

coeff_tas := f->coeff_tas  ;31*lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;model*64*lat*lon
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
; printMinMax(coeff_tas,True)
; printMinMax(delta_tas,True)

;年平均
; delta_tas_34 := (delta_tas(:,0::4,:,:) + delta_tas(:,1::4,:,:)) / 2.0   ;3-4月平均
; delta_prsn_34 := (delta_prsn(:,0::4,:,:) + delta_prsn(:,1::4,:,:)) / 2.0
; delta_alpsnow_34 := (delta_alpsnow(:,0::4,:,:) + delta_alpsnow(:,1::4,:,:)) / 2.0

delta_tas := dim_avg_n(delta_tas,1)  ;model*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,1)
delta_prsn := dim_avg_n(delta_prsn,1)
; printVarSummary(delta_alpsnow)

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;31*lat*lon

areacella_mk := where(ismissing(delta_alpsnow),areacella_3d@_FillValue,areacella_3d)
delta_alpsnow_DS_cmip6 := dim_sum_n(delta_alpsnow*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_DS_cmip6 := dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_DS_cmip6 := dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_DS_cmip6 = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_DS_cmip6 = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; *************************年代际时间尺度 观测**************************
f=addfile(inpath+"data_fit_decadal_obs.nc","r")

coeff_tas := f->coeff_tas  ;lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;64*lat*lon
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
; printVarSummary(delta_alpsnow)

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;31*lat*lon

areacella_mk := where(ismissing(delta_alpsnow),areacella_3d@_FillValue,areacella_3d)
delta_alpsnow_DS_obs := dim_sum_n(delta_alpsnow*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_DS_obs := dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_DS_obs := dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_DS_obs = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_DS_obs = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; print(delta_alpsnow_DS_obs)
; print(contr_tas_DS_obs)
; print(contr_prsn_DS_obs)
; *************************年代际时间尺度 再分析**************************
f=addfile(inpath+"data_fit_decadal_rea.nc","r")

coeff_tas := f->coeff_tas  ;31*lat*lon
coeff_prsn:= f->coeff_prsn

delta_tas := f->delta_tas_mk  ;model*64*lat*lon
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
; printMinMax(coeff_tas,True)
; printMinMax(delta_tas,True)

;年平均
delta_tas := dim_avg_n(delta_tas,1)  ;model*lat*lon
delta_alpsnow := dim_avg_n(delta_alpsnow,1)
delta_prsn := dim_avg_n(delta_prsn,1)
; printVarSummary(delta_alpsnow)

;贡献
contr_tas := delta_tas*coeff_tas ;model*lat*lon
contr_prsn := delta_prsn*coeff_prsn

;面积权重
areacella_3d := conform_dims(dimsizes(contr_tas),areacella,(/1,2/))  ;31*lat*lon

areacella_mk := where(ismissing(delta_alpsnow),areacella_3d@_FillValue,areacella_3d)
delta_alpsnow_DS_rea := dim_sum_n(delta_alpsnow*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_tas),areacella_3d@_FillValue,areacella_3d)
contr_tas_DS_rea := dim_sum_n(contr_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(contr_prsn),areacella_3d@_FillValue,areacella_3d)
contr_prsn_DS_rea := dim_sum_n(contr_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_tas),areacella_3d@_FillValue,areacella_3d)
coeff_tas_DS_rea = dim_sum_n(coeff_tas*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

areacella_mk := where(ismissing(coeff_prsn),areacella_3d@_FillValue,areacella_3d)
coeff_prsn_DS_rea = dim_sum_n(coeff_prsn*areacella_mk,(/1,2/))/dim_sum_n(areacella_mk,(/1,2/))

; *************************将观测和模式放在一个数组**************************
delta_alpsnow_SS = new(n_model6,double)
contr_tas_SS  = new(n_model6,double)
contr_prsn_SS = new(n_model6,double)
coeff_tas_SS  = new(n_model6,double)
coeff_prsn_SS = new(n_model6,double)

delta_alpsnow_DS = new(n_model6,double)
contr_tas_DS  = new(n_model6,double)
contr_prsn_DS = new(n_model6,double)
coeff_tas_DS  = new(n_model6,double)
coeff_prsn_DS = new(n_model6,double)

;观测
delta_alpsnow_SS(0:2) = delta_alpsnow_SS_obs
contr_tas_SS(0:2)  = contr_tas_SS_obs
contr_prsn_SS(0:2) = contr_prsn_SS_obs
coeff_tas_SS(0:2)  = coeff_tas_SS_obs
coeff_prsn_SS(0:2) = coeff_prsn_SS_obs

delta_alpsnow_DS(0:2) = delta_alpsnow_DS_obs
contr_tas_DS(0:2)  = contr_tas_DS_obs
contr_prsn_DS(0:2) = contr_prsn_DS_obs
coeff_tas_DS(0:2)  = coeff_tas_DS_obs
coeff_prsn_DS(0:2) = coeff_prsn_DS_obs

;再分析
delta_alpsnow_SS(3:7) = delta_alpsnow_SS_rea
contr_tas_SS(3:7)  = contr_tas_SS_rea
contr_prsn_SS(3:7) = contr_prsn_SS_rea
coeff_tas_SS(3:7)  = coeff_tas_SS_rea
coeff_prsn_SS(3:7) = coeff_prsn_SS_rea

delta_alpsnow_DS(3:7) = delta_alpsnow_DS_rea
contr_tas_DS(3:7)  = contr_tas_DS_rea
contr_prsn_DS(3:7) = contr_prsn_DS_rea
coeff_tas_DS(3:7)  = coeff_tas_DS_rea
coeff_prsn_DS(3:7) = coeff_prsn_DS_rea

;模式平均
delta_alpsnow_SS(8) = avg(delta_alpsnow_SS_cmip6)
contr_tas_SS(8)  = avg(contr_tas_SS_cmip6)
contr_prsn_SS(8) = avg(contr_prsn_SS_cmip6)
coeff_tas_SS(8)  = avg(coeff_tas_SS_cmip6)
coeff_prsn_SS(8) = avg(coeff_prsn_SS_cmip6)

delta_alpsnow_DS(8) = avg(delta_alpsnow_DS_cmip6)
contr_tas_DS(8)  = avg(contr_tas_DS_cmip6)
contr_prsn_DS(8) = avg(contr_prsn_DS_cmip6)
coeff_tas_DS(8)  = avg(coeff_tas_DS_cmip6)
coeff_prsn_DS(8) = avg(coeff_prsn_DS_cmip6)

;模式
delta_alpsnow_SS(9:n_model6-1) = delta_alpsnow_SS_cmip6
contr_tas_SS(9:n_model6-1)  = contr_tas_SS_cmip6
contr_prsn_SS(9:n_model6-1) = contr_prsn_SS_cmip6
coeff_tas_SS(9:n_model6-1)  = coeff_tas_SS_cmip6
coeff_prsn_SS(9:n_model6-1) = coeff_prsn_SS_cmip6

delta_alpsnow_DS(9:n_model6-1) = delta_alpsnow_DS_cmip6
contr_tas_DS(9:n_model6-1)  = contr_tas_DS_cmip6
contr_prsn_DS(9:n_model6-1) = contr_prsn_DS_cmip6
coeff_tas_DS(9:n_model6-1)  = coeff_tas_DS_cmip6
coeff_prsn_DS(9:n_model6-1) = coeff_prsn_DS_cmip6

;ratio
ratio_tas_SS  = 100.0*contr_tas_SS/delta_alpsnow_SS
ratio_prsn_SS = 100.0*contr_prsn_SS/delta_alpsnow_SS

ratio_tas_DS  = 100.0*contr_tas_DS/delta_alpsnow_DS
ratio_prsn_DS = 100.0*contr_prsn_DS/delta_alpsnow_DS


; a=avg(coeff_tas_SS(3:7))
; print("rea coeff_tas SS: "+a)
; a=avg(coeff_tas_DS(3:7))
; print("rea coeff_tas DS: "+a)
; a=avg(coeff_prsn_SS(3:7))
; print("rea coeff_prsn SS: "+a)
; a=avg(coeff_prsn_DS(3:7))
; print("rea coeff_prsn DS: "+a)

; a=avg(coeff_tas_DS(0:2))
; print("OBS coeff_tas DS: "+a)

; a=avg(coeff_tas_SS(0:2))
; print("OBS coeff_tas SS: "+a)
;
; a=avg(coeff_tas_DS(0:2))
; print("OBS coeff_tas DS: "+a)
a=avg(ratio_tas_SS(3:7))
print("rea ratio_tas SS: "+a)

a=avg(ratio_tas_DS(3:7))
print("rea ratio_tas DS: "+a)


a=avg(ratio_prsn_SS(3:7))
print("rea ratio_prsn SS: "+a)

a=avg(ratio_prsn_DS(3:7))
print("rea ratio_prsn DS: "+a)

; a=avg(coeff_prsn_SS(0:2))
; print("OBS coeff_prsn SS: "+a)
;
; a=avg(coeff_prsn_DS(0:2))
; print("OBS coeff_prsn DS: "+a)

; print(ratio_tas_SS(0:1))
; print(ratio_prsn_SS(0:1))
;
; print(ratio_tas_DS(0:1))
; print(ratio_prsn_DS(0:1))

; print("OBS coeff_tas SS: "+coeff_tas_SS(0))
; print("OBS coeff_tas DS: "+coeff_tas_DS(0))
; print("OBS coeff_prsn SS: "+coeff_prsn_SS(0))
; print("OBS coeff_prsn DS: "+coeff_prsn_DS(0))
; print("OBS contr_tas SS: "+contr_tas_SS(0))
; print("OBS contr_tas DS: "+contr_tas_DS(0))
; print("OBS contr_prsn SS: "+contr_prsn_SS(0))
; print("OBS contr_prsn DS: "+contr_prsn_DS(0))

; a1 = avg(coeff_tas_SS(1:n_model6-1))
; a2 = avg(coeff_tas_DS(1:n_model6-1))
; std1 = stddev(coeff_tas_SS(1:n_model6-1))
; std2 = stddev(coeff_tas_DS(1:n_model6-1))
; CV1 = std1/abs(a1)
; CV2 = std2/abs(a2)
; ; print("CMIP6 coeff_tas SS: "+a1)
; ; print("CMIP6 coeff_tas DS: "+a2)
; print("CMIP6 coeff_tas CV SS: "+CV1)
; print("CMIP6 coeff_tas CV DS: "+CV2)
;
; a3 = avg(coeff_prsn_SS(1:n_model6-1))
; a4 = avg(coeff_prsn_DS(1:n_model6-1))
; std1 = stddev(coeff_prsn_SS(1:n_model6-1))
; std2 = stddev(coeff_prsn_DS(1:n_model6-1))
; CV1 = std1/abs(a3)
; CV2 = std2/abs(a4)
; ; print("CMIP6 coeff_prsn SS: "+a3)
; ; print("CMIP6 coeff_prsn DS: "+a4)
; print("CMIP6 coeff_prsn CV SS: "+CV1)
; print("CMIP6 coeff_prsn CV DS: "+CV2)
;
; a1 = avg(contr_tas_SS(1:n_model6-1))
; a2 = avg(contr_tas_DS(1:n_model6-1))
; std1 = stddev(contr_tas_SS(1:n_model6-1))
; std2 = stddev(contr_tas_DS(1:n_model6-1))
; CV1 = std1/abs(a1)
; CV2 = std2/abs(a2)
; ; print("CMIP6 contr_tas SS: "+a1)
; ; print("CMIP6 contr_tas DS: "+a2)
; print("CMIP6 contr_tas CV SS: "+CV1)
; print("CMIP6 contr_tas CV DS: "+CV2)
;
; a3 = avg(contr_prsn_SS(1:n_model6-1))
; a4 = avg(contr_prsn_DS(1:n_model6-1))
; std1 = stddev(contr_prsn_SS(1:n_model6-1))
; std2 = stddev(contr_prsn_DS(1:n_model6-1))
; CV1 = std1/abs(a3)
; CV2 = std2/abs(a4)
; ; print("CMIP6 contr_prsn SS: "+a3)
; ; print("CMIP6 contr_prsn DS: "+a4)
; print("CMIP6 contr_prsn CV SS: "+CV1)
; print("CMIP6 contr_prsn CV DS: "+CV2)

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

; res@trYReverse = True

res@gsnYRefLine            = 0.0
; res@gsnYRefLineColor       = "grey50"
; res@gsnYRefLineThicknessF  = 0.5
res@gsnYRefLineDashPattern = 0

res@gsnXYBarChart = True
res@gsnXYBarChartBarWidth = 0.25           ; change bar widths
; res@gsnXYBarChartFillScaleF = 0.45
res@gsnXYBarChartFillOpacityF = 0.88
; res@gsnXYBarChartFillLineThicknessF = 0.5
res@xyLineThicknesses = (/0.001,0.001/)  ;边框线宽

; ========== 图1: tas coefficient ==========
colors1 = (/"red","blue"/)
colors2 = (/"darkviolet","dodgerblue","darkorange"/)
;orchid violetred1  darkviolet magenta2 "purple2"
x_SS = ispan(1, n_model6, 1) - 0.13  ; SS向左偏移
x_DS = ispan(1, n_model6, 1) + 0.13  ; DS向右偏移

res@tiYAxisString = "~F33~b~F21~" + "~B~T~N~ (% K~S~-1~N~)"
res@tiYAxisFontHeightF   = 0.015

res@trYMinF = -1.9
res@trYMaxF = 0.33
res@gsnXYBarChartColors = colors1(0)
res@xyLineColors = (/colors1(0),colors1(0)/)   ;边框颜色

plot1 = gsn_csm_xy(wks,x_SS,coeff_tas_SS,res)		; draw each time series

res@gsnXYBarChartColors = colors1(1)
res@xyLineColors = (/colors1(1),colors1(1)/)   ;边框颜色
plot1_DS = gsn_csm_xy(wks,x_DS,coeff_tas_DS,res)		; draw each time series

overlay(plot1, plot1_DS)

; ========== 图2: prsn coefficient ==========
res@tiYAxisString = "~F33~b~F21~" + "~B~P~N~ (% kg~S~-1~N~ m~S~2~N~)"

res@trYMinF = -0.05
res@trYMaxF = 0.6

res@gsnXYBarChartColors = colors1(0)
res@xyLineColors = (/colors1(0),colors1(0)/)   ;边框颜色
plot2 = gsn_csm_xy(wks, x_SS, coeff_prsn_SS, res)

res@gsnXYBarChartColors = colors1(1)
res@xyLineColors = (/colors1(1),colors1(1)/)   ;边框颜色
plot2_DS = gsn_csm_xy(wks, x_DS, coeff_prsn_DS, res)

overlay(plot2, plot2_DS)

; ========== 图3: seasonal contribution ==========
res@tiYAxisString = "Seasonal ~F33~D~F21~~F33~a~F21~~B~snow~N~ (%)"
res@tmXBLabelsOn  = True

res@trYMinF       = -18.
res@trYMaxF       = 4.

res@gsnXYBarChartColors = colors2(0)
res@xyLineColors = (/colors2(0),colors2(0)/)   ;边框颜色
plot3 = gsn_csm_xy(wks, x_SS, delta_alpsnow_SS, res)

test := contr_prsn_SS*contr_tas_SS
contr_prsn_SS := where(test.ge.0,contr_prsn_SS+contr_tas_SS,contr_prsn_SS)

res@gsnXYBarChartColors = colors2(2)  ;降雪贡献颜色
res@xyLineColors = (/colors2(2),colors2(2)/)   ;边框颜色
plot3_contrib1 = gsn_csm_xy(wks, x_DS, contr_prsn_SS, res)

res@gsnXYBarChartColors = colors2(1)  ;温度贡献颜色
res@xyLineColors = (/colors2(1),colors2(1)/)   ;边框颜色
plot3_contrib2 = gsn_csm_xy(wks, x_DS, contr_tas_SS, res)

overlay(plot3, plot3_contrib1)
overlay(plot3, plot3_contrib2)

; ========== 图4: decadal contribution ==========
res@tiYAxisString = "Decadal ~F33~D~F21~~F33~a~F21~~B~snow~N~ (%)"

res@trYMinF       = -1.8
res@trYMaxF       = 0.4

res@gsnXYBarChartColors = colors2(0)
res@xyLineColors = (/colors2(0),colors2(0)/)   ;边框颜色
plot4 = gsn_csm_xy(wks,x_SS, delta_alpsnow_DS, res)		; draw each time series

test := contr_prsn_DS*contr_tas_DS
contr_prsn_DS := where(test.ge.0,contr_prsn_DS+contr_tas_DS,contr_prsn_DS)

res@gsnXYBarChartColors = colors2(2)  ;降雪贡献颜色
res@xyLineColors = (/colors2(2),colors2(2)/)   ;边框颜色
plot4_contrib1 = gsn_csm_xy(wks, x_DS, contr_prsn_DS, res)

res@gsnXYBarChartColors = colors2(1)  ;温度贡献颜色
res@xyLineColors = (/colors2(1),colors2(1)/)   ;边框颜色
plot4_contrib2 = gsn_csm_xy(wks, x_DS, contr_tas_DS, res)

overlay(plot4, plot4_contrib1)
overlay(plot4, plot4_contrib2)

; ; ========== 图5: seasonal contribution ratio ==========
; colors3 = (/"dodgerblue","darkorange"/)
; res@tmXBLabelsOn  = True
;
; res@tiYAxisString = "Seasonal Contribution Ratio(%)"
;
; res@trYMinF = -10.
; res@trYMaxF = 105.
; res@gsnXYBarChartColors = colors3(0)
; res@xyLineColors = (/colors3(0),colors3(0)/)   ;边框颜色
;
; plot5 = gsn_csm_xy(wks,x_SS,ratio_tas_SS,res)		; draw each time series
;
; res@gsnXYBarChartColors = colors3(1)
; res@xyLineColors = (/colors3(1),colors3(1)/)   ;边框颜色
; plot5_DS = gsn_csm_xy(wks,x_DS,ratio_prsn_SS,res)		; draw each time series
;
; overlay(plot5, plot5_DS)
;
; ; ========== 图6: decadal contribution ratio ==========
; res@tiYAxisString = "Decadal Contribution Ratio(%)"
;
; res@trYMinF = -250.
; res@trYMaxF = 250.
;
; res@gsnXYBarChartColors = colors3(0)
; res@xyLineColors = (/colors3(0),colors3(0)/)   ;边框颜色
; plot6 = gsn_csm_xy(wks, x_SS, ratio_tas_DS, res)
;
; res@gsnXYBarChartColors = colors3(1)
; res@xyLineColors = (/colors3(1),colors3(1)/)   ;边框颜色
; plot6_DS = gsn_csm_xy(wks, x_DS, ratio_prsn_DS, res)
;
; overlay(plot6, plot6_DS)

;************ Create some labelbars for a legend*******
lbres                    = True
lbres@lbBoxMajorExtentF  = 0.35
lbres@lbLabelFontHeightF = 0.0085
lbres@lbLabelJust        = "centerLeft"
lbres@lbPerimOn          = False
lbres@lbLabelOffsetF     = 0.08
lbres@lbFillScaleF       = 0.45

labels := (/"Decadal","Seasonal"/)
lbres@vpWidthF        = 0.08
lbres@vpHeightF       = 0.035
lbres@lbFillColors   := colors1(::-1)
lbres@lbFillPatterns := (/0,0/)
lbres@lbBoxLinesOn = False
gsn_labelbar_ndc(wks,2,labels,0.083,0.58,lbres)


labels := (/"~F33~b~F21~~B~P~N~ ~F33~D~F21~P", \
           "~F33~b~F21~~B~T~N~ ~F33~D~F21~T", \
           "Total"/)
lbres@vpWidthF        = 0.08
lbres@vpHeightF       = 0.052
lbres@lbFillColors   := colors2(::-1)
lbres@lbFillPatterns := (/0,0,0/)
lbres@lbBoxLinesOn = False
gsn_labelbar_ndc(wks,3,labels,0.075,0.386,lbres)

; ========== 手动添加X轴标签（加粗CMIP6 mean）==========
txres = True
txres@txFontHeightF = 0.007
txres@txFont = 22
txres@txFontColor = "black"
txres@txAngleF = 90
txres@txJust = "CenterCenter"
txres@txFontThicknessF = 10.0

gsn_text_ndc(wks, "CMIP6 Mean", 0.161, 0.28, txres)
gsn_text_ndc(wks, "CMIP6 Mean", 0.661, 0.28, txres)

gsn_text_ndc(wks, "CMIP6 Mean", 0.161, 0.28, txres)
gsn_text_ndc(wks, "CMIP6 Mean", 0.661, 0.28, txres)

;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
;pres@gsnMaximize   = True
pres@gsnPanelXWhiteSpacePercent = 4
pres@gsnPanelYWhiteSpacePercent = 4

pres@gsnPanelFigureStrings        = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)"/)
pres@gsnPanelFigureStringsJust    = "TopRight"
pres@gsnPanelFigureStringsPerimOn = False
pres@gsnPanelFigureStringsFontHeightF = 0.008

; pres@gsnPanelLabelBar = True
; pres@lbLabelFontHeightF   = 0.016
; pres@gsnPanelBottom = 0.001
; YF = fspan(0.95,0.56,2)
; pres@gsnPanelYF = (/YF(0),YF(1)/)

gsn_panel(wks,(/plot1,plot2,plot3,plot4/),(/2,2/),pres)

end
