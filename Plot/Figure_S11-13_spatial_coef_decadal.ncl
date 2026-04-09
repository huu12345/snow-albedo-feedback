begin

;生成多元线性拟合所需要的数据，季节与年代际数据合并在一起

model6 = (/"APP-x","CLARA-A2","CLARA-A3","ERA5-Land","ERA5-Snow","JRA-3Q","JRA-55","MERRA-2",\
"ACCESS-ESM1-5","BCC-ESM1","CanESM5",\
"CESM2","CESM2-FV2","CESM2-WACCM","CESM2-WACCM-FV2",\
"CNRM-CM6-1","CNRM-CM6-1-HR","CNRM-ESM2-1","E3SM-2-0",\
"E3SM-2-1","EC-Earth3","EC-Earth3-AerChem","EC-Earth3-Veg","EC-Earth3-Veg-LR",\
"FGOALS-f3-L","GISS-E2-1-G","GISS-E2-2-G","GISS-E3-G","HadGEM3-GC31-LL",\
"IPSL-CM6A-LR","IPSL-CM6A-MR1","MIROC6","MIROC-ES2L",\
"MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1",\
"UKESM1-0-LL"/)
; print(model6)

n_model6 = dimsizes(model6)
print(n_model6)

inpath="/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/reviewer3_amip/"

outpath = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/snowfall/"
name    = "Figure_S11-13"

; *************************年代际时间尺度 观测**************************
coeff_tas = new((/n_model6,45,360/),double)
coeff_prsn= new((/n_model6,45,360/),double)
pvalue_tas= new((/n_model6,45,360/),double)
pvalue_prsn= new((/n_model6,45,360/),double)

f=addfile(inpath+"data_fit_decadal_obs.nc","r")

coeff_tas(0:2,:,:) = f->coeff_tas  ;lat*lon
coeff_prsn(0:2,:,:)= f->coeff_prsn
pvalue_tas(0:2,:,:)= f->pvalue_tas
pvalue_prsn(0:2,:,:)= f->pvalue_prsn

; *************************季节时间尺度 再分析**************************
f=addfile(inpath+"data_fit_decadal_rea.nc","r")

coeff_tas(3:7,:,:) = (/f->coeff_tas/)  ;lat*lon
coeff_prsn(3:7,:,:)= (/f->coeff_prsn/)
pvalue_tas(3:7,:,:)= (/f->pvalue_tas/)
pvalue_prsn(3:7,:,:)= (/f->pvalue_prsn/)

; *************************年代际时间尺度 CMIP6**************************
f=addfile(inpath+"data_fit_decadal_cmip6.nc","r")

coeff_tas(8:n_model6-1,:,:) = (/f->coeff_tas/)  ;model*lat*lon
coeff_prsn(8:n_model6-1,:,:)= (/f->coeff_prsn/)
pvalue_tas(8:n_model6-1,:,:)= (/f->pvalue_tas/)
pvalue_prsn(8:n_model6-1,:,:)= (/f->pvalue_prsn/)

;将NaN值替换为默认的_FillValue
if (any(isnan_ieee(coeff_tas))) then
    replace_ieeenan(coeff_tas, -999., 0)
end if
if (any(isnan_ieee(coeff_prsn))) then
    replace_ieeenan(coeff_prsn, -999., 0)
end if
if (any(isnan_ieee(pvalue_tas))) then
    replace_ieeenan(pvalue_tas, -999., 0)
end if
if (any(isnan_ieee(pvalue_prsn))) then
    replace_ieeenan(pvalue_prsn, -999., 0)
end if

coeff_tas@_FillValue = -999.
coeff_prsn@_FillValue = -999.
pvalue_tas@_FillValue = -999.
pvalue_prsn@_FillValue = -999.

f=addfile("/home/hujl/data_script/mask_greenland_MODIS/MCD12C1/mask_greenland_MCD12C1_1.0x1.0.nc","r")
copy = f->RCN_reg({45:90},:)

;************画图**************
wks = gsn_open_wks("pdf",outpath+name)
gsn_define_colormap(wks,"MPL_coolwarm");MPL_OrRd  BlueYellowRed

res = True
res@gsnDraw       = False
res@gsnFrame      = False
res@cnFillOn      = True
res@cnLinesOn     = False
res@gsnMaximize   = False

res@gsnPolar       = "NH"
res@mpMinLatF      = 45

res@cnFillMode = "RasterFill"

; res@cnConstFEnableFill = True
res@lbLabelBarOn   = False
res@gsnCenterStringFontHeightF = 0.041

; 设置点状标记的属性
sig_level = 0.05  ; p<0.05 为显著

sres                 = True                                                           ; set up a second resource list
sres@gsnDraw         = False                                                          ;         do not draw the plot
sres@gsnFrame        = False                                                          ; do not advance the frame
sres@cnLineLabelsOn  = False                                                          ; do not use line labels
sres@cnLinesOn       = False                                                          ; do not draw contour lines
sres@cnInfoLabelOn   = False
sres@cnFillOn        = True                                                          ; color fill
sres@lbLabelBarOn    = False
sres@cnLevelSelectionMode = "ExplicitLevels"
sres@cnFillDrawOrder ="postDraw"
sres@cnLevels        = (/sig_level/)
sres@cnMonoFillPattern = False
sres@cnFillPatterns  = (/17,-1/)
sres@cnMonoFillScale = False   ; want different densities
sres@cnFillScales    = 0.5    ; change densities
sres@cnMonoFillColor =True
sres@cnFillDotSizeF  = 0.0021

plot1 = new(n_model6,graphic)
plot2 = new(n_model6,graphic)

do n = 0,n_model6-1
  ;************** coeff_tas **************
  res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
  res@cnMinLevelValF  = -2.		; set the minimum contour level
  res@cnMaxLevelValF  = 2.			; set the maximum contour level
  res@cnLevelSpacingF = 0.2

  contr := tofloat(coeff_tas(n,:,:))
  copy_VarCoords(copy,contr)
  res@gsnCenterString = model6(n)
  plot1(n) = gsn_csm_contour_map_polar(wks,contr,res) ;第1列

  ; 为显著区域添加点状标记
  pvalue_1 := tofloat(pvalue_tas(n,:,:))
  copy_VarCoords(copy, pvalue_1)

  plot1_1 := gsn_csm_contour(wks, pvalue_1, sres)
  overlay(plot1(n),plot1_1)

;************** coeff_prsn **************
  res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
  res@cnMinLevelValF  = -0.6		; set the minimum contour level
  res@cnMaxLevelValF  = 0.6			; set the maximum contour level
  res@cnLevelSpacingF = 0.1

  contr := tofloat(coeff_prsn(n,:,:))
  copy_VarCoords(copy,contr)
  res@gsnCenterString = model6(n)
  plot2(n) = gsn_csm_contour_map_polar(wks,contr,res) ;第1列

  ; 为显著区域添加点状标记
  pvalue_1 := tofloat(pvalue_prsn(n,:,:))
  copy_VarCoords(copy, pvalue_1)

  plot2_1 := gsn_csm_contour(wks, pvalue_1, sres)
  overlay(plot2(n),plot2_1)

end do

;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
;pres@gsnMaximize   = True
; pres@gsnPanelXWhiteSpacePercent = 5
pres@gsnPanelYWhiteSpacePercent = 3

pres@gsnPanelLabelBar = True
; pres@lbLabelFontHeightF   = 0.016
; pres@gsnPanelBottom = 0.001

gsn_panel(wks,plot1,(/8,5/),pres)
gsn_panel(wks,plot2,(/8,5/),pres)



end
