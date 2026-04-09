begin

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

wks = gsn_open_wks("pdf",outpath+"Figure_S3")
; gsn_define_colormap(wks,"rainbow")

n_lat6 = 45
n_lon6 = 360

NET_36 = new((/3,n_lat6,n_lon6/),"double")
SNC_36 = NET_36
TEM_36 = NET_36

;---------------seasonal--------------------
;---------------ERA5-Land-------------
  m6 := "ERA5-Land2"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_ERA5_SS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_ERA5_SS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_ERA5_SS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_ERA5_SS)
copy_VarCoords(NET,SNC_ERA5_SS)
copy_VarCoords(NET,TEM_ERA5_SS)

;---------------MERRA2-------------
  m6 := "MERRA22"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_MERRA2_SS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_MERRA2_SS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_MERRA2_SS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_MERRA2_SS)
copy_VarCoords(NET,SNC_MERRA2_SS)
copy_VarCoords(NET,TEM_MERRA2_SS)

;---------------JRA55-------------
  m6 := "JRA552"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_JRA55_SS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_JRA55_SS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_JRA55_SS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_JRA55_SS)
copy_VarCoords(NET,SNC_JRA55_SS)
copy_VarCoords(NET,TEM_JRA55_SS)

;---------------JRA3Q-------------
  m6 := "JRA3Q2"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_JRA3Q_SS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_JRA3Q_SS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_JRA3Q_SS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_JRA3Q_SS)
copy_VarCoords(NET,SNC_JRA3Q_SS)
copy_VarCoords(NET,TEM_JRA3Q_SS)

;---------------ERA5snow-------------
  m6 := "ERA5snow2"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_ERA5snow_SS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_ERA5snow_SS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_ERA5snow_SS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_ERA5snow_SS)
copy_VarCoords(NET,SNC_ERA5snow_SS)
copy_VarCoords(NET,TEM_ERA5snow_SS)

;--------------decadal---------------------
;---------------ERA5-Land-------------
  m6 := "ERA5-Land2"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_ERA5_DS+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5_DS+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_ERA5_DS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_ERA5_DS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_ERA5_DS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_ERA5_DS)
copy_VarCoords(NET,SNC_ERA5_DS)
copy_VarCoords(NET,TEM_ERA5_DS)

;---------------MERRA2-------------
  m6 := "MERRA22"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_MERRA2_DS+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_MERRA2_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_MERRA2_DS+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_MERRA2_DS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_MERRA2_DS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_MERRA2_DS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_MERRA2_DS)
copy_VarCoords(NET,SNC_MERRA2_DS)
copy_VarCoords(NET,TEM_MERRA2_DS)

;---------------JRA55-------------
  m6 := "JRA552"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_JRA55_DS+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA55_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA55_DS+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_JRA55_DS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_JRA55_DS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_JRA55_DS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_JRA55_DS)
copy_VarCoords(NET,SNC_JRA55_DS)
copy_VarCoords(NET,TEM_JRA55_DS)

;---------------JRA3Q-------------
  m6 := "JRA3Q2"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_JRA3Q_DS+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_JRA3Q_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_JRA3Q_DS+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_JRA3Q_DS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_JRA3Q_DS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_JRA3Q_DS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_JRA3Q_DS)
copy_VarCoords(NET,SNC_JRA3Q_DS)
copy_VarCoords(NET,TEM_JRA3Q_DS)

;---------------ERA5snow-------------
  m6 := "ERA5snow2"
  do j = 0,2
    files_NET := systemfunc("ls "+inpath_ERA5snow_DS+"k4."+m6+".EASE_grid.nc")
    files_SNC := systemfunc("ls "+inpath_ERA5snow_DS+"k1k2."+m6+".EASE_grid.nc")
    files_TEM := systemfunc("ls "+inpath_ERA5snow_DS+"k3."+m6+".EASE_grid.nc")

    f_NET   = addfiles(files_NET,"r")
    f_SNC   = addfiles(files_SNC,"r")
    f_TEM   = addfiles(files_TEM,"r")

    NET     = f_NET[:]->k4(0,:,:)
    SNC     = f_SNC[:]->k1k2(0,:,:)
    TEM     = f_TEM[:]->k3(0,:,:)
    ; printVarSummary(NET)
    ; printVarSummary(SNC)
    ; printVarSummary(TEM)
    NET_36(j,:,:) = NET    ;3*1*144*25
    SNC_36(j,:,:) = SNC
    TEM_36(j,:,:) = TEM
  end do

NET_ERA5snow_DS = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
SNC_ERA5snow_DS = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
TEM_ERA5snow_DS = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

copy_VarCoords(NET,NET_ERA5snow_DS)
copy_VarCoords(NET,SNC_ERA5snow_DS)
copy_VarCoords(NET,TEM_ERA5snow_DS)

printVarSummary(TEM_ERA5snow_DS)
;-----------------------------------
;--------------画图------------
res=True
res@gsnDraw        = False
res@gsnFrame       = False
res@cnFillOn       = True
res@cnLinesOn      = False

; res@vpWidthF     = 0.2
; res@vpHeightF    = 0.2
; res@mpShapeMode  = "FreeAspect"

res@gsnPolar       = "NH"
res@mpMinLatF      = 45
res@mpGeophysicalLineThicknessF = 0.6
res@mpLandFillColor = 0
;res@mpGridLineDashPattern = 5
res@mpGridLineThicknessF = 0.005
res@mpGridLineColor = "grey35"
;res@mpGridMaskMode = "MaskLand"

res@gsnPolarLabelFontHeightF = 0.025

colors = (/"BlueWhiteOrangeRed"/)
; res@cnFillPalette = "GMT_hot"temp_diff_18lev

min_1   = -2.4
max_1   = 2.4
space_1 = 0.3

res@lbLabelBarOn   = False
res@lbLabelFontHeightF = 0.016

res@tiYAxisFontHeightF = 0.06
res@tiYAxisOffsetXF    = -0.02

res@tiMainFontHeightF = 0.06
res@tiMainOffsetYF    = 0.004

res@gsnLeftStringFontHeightF = 0.04
res@gsnLeftStringOrthogonalPosF = -0.02
;************NET sesonal*************
res@tiMainString      = "SAF~B~NET~N~"

res@cnFillPalette   = colors(0)

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_1		; set the minimum contour level
res@cnMaxLevelValF  = max_1			; set the maximum contour level
res@cnLevelSpacingF = space_1
;res@gsnCenterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"

res@tiMainOn        = True
res@tiYAxisString   = "ERA5-Land"
res@gsnLeftString   = "(a)"
plot_NET_ERA5_SS = gsn_csm_contour_map_polar(wks,NET_ERA5_SS,res)
plot_NET_ERA5_DS = gsn_csm_contour_map_polar(wks,NET_ERA5_DS,res)

res@tiMainOn        = False
res@tiYAxisString   = "ERA5-Snow"
res@gsnLeftString   = "(d)"
plot_NET_ERA5snow_SS = gsn_csm_contour_map_polar(wks,NET_ERA5snow_SS,res)
plot_NET_ERA5snow_DS = gsn_csm_contour_map_polar(wks,NET_ERA5snow_DS,res)

res@tiYAxisString   = "JRA-3Q"
res@gsnLeftString   = "(g)"
plot_NET_JRA3Q_SS = gsn_csm_contour_map_polar(wks,NET_JRA3Q_SS,res)
plot_NET_JRA3Q_DS = gsn_csm_contour_map_polar(wks,NET_JRA3Q_DS,res)

res@tiYAxisString   = "JRA-55"
res@gsnLeftString   = "(j)"
plot_NET_JRA55_SS = gsn_csm_contour_map_polar(wks,NET_JRA55_SS,res)
plot_NET_JRA55_DS = gsn_csm_contour_map_polar(wks,NET_JRA55_DS,res)

res@tiYAxisString   = "MERRA-2"
res@gsnLeftString   = "(m)"
plot_NET_MERRA2_SS = gsn_csm_contour_map_polar(wks,NET_MERRA2_SS,res)
plot_NET_MERRA2_DS = gsn_csm_contour_map_polar(wks,NET_MERRA2_DS,res)

;************SNC sesonal*************
res@tiYAxisOn       = False
res@tiMainOn        = True
res@tiMainString      = "SAF~B~SNC~N~"

res@gsnLeftString   = "(b)"
plot_SNC_ERA5_SS     = gsn_csm_contour_map_polar(wks,SNC_ERA5_SS,res)
plot_SNC_ERA5_DS     = gsn_csm_contour_map_polar(wks,SNC_ERA5_DS,res)

res@tiMainOn         = False
res@gsnLeftString   = "(e)"
plot_SNC_ERA5snow_SS = gsn_csm_contour_map_polar(wks,SNC_ERA5snow_SS,res)
plot_SNC_ERA5snow_DS = gsn_csm_contour_map_polar(wks,SNC_ERA5snow_DS,res)

res@gsnLeftString   = "(h)"
plot_SNC_JRA3Q_SS    = gsn_csm_contour_map_polar(wks,SNC_JRA3Q_SS,res)
plot_SNC_JRA3Q_DS    = gsn_csm_contour_map_polar(wks,SNC_JRA3Q_DS,res)

res@gsnLeftString   = "(k)"
plot_SNC_JRA55_SS    = gsn_csm_contour_map_polar(wks,SNC_JRA55_SS,res)
plot_SNC_JRA55_DS    = gsn_csm_contour_map_polar(wks,SNC_JRA55_DS,res)

res@gsnLeftString   = "(n)"
plot_SNC_MERRA2_SS   = gsn_csm_contour_map_polar(wks,SNC_MERRA2_SS,res)
plot_SNC_MERRA2_DS   = gsn_csm_contour_map_polar(wks,SNC_MERRA2_DS,res)


;************TEM sesonal*************
res@tiMainOn        = True
res@tiMainString      = "SAF~B~TEM~N~"

res@gsnLeftString   = "(c)"
plot_TEM_ERA5_SS     = gsn_csm_contour_map_polar(wks,TEM_ERA5_SS,res)
plot_TEM_ERA5_DS     = gsn_csm_contour_map_polar(wks,TEM_ERA5_DS,res)

res@tiMainOn         = False
res@gsnLeftString   = "(f)"
plot_TEM_ERA5snow_SS = gsn_csm_contour_map_polar(wks,TEM_ERA5snow_SS,res)
plot_TEM_ERA5snow_DS = gsn_csm_contour_map_polar(wks,TEM_ERA5snow_DS,res)

res@gsnLeftString   = "(i)"
plot_TEM_JRA3Q_SS    = gsn_csm_contour_map_polar(wks,TEM_JRA3Q_SS,res)
plot_TEM_JRA3Q_DS    = gsn_csm_contour_map_polar(wks,TEM_JRA3Q_DS,res)

res@gsnLeftString   = "(l)"
plot_TEM_JRA55_SS    = gsn_csm_contour_map_polar(wks,TEM_JRA55_SS,res)
plot_TEM_JRA55_DS    = gsn_csm_contour_map_polar(wks,TEM_JRA55_DS,res)

res@gsnLeftString   = "(o)"
plot_TEM_MERRA2_SS   = gsn_csm_contour_map_polar(wks,TEM_MERRA2_SS,res)
plot_TEM_MERRA2_DS   = gsn_csm_contour_map_polar(wks,TEM_MERRA2_DS,res)

;-------------------------------------
;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
pres@gsnMaximize   = True
; pres@gsnPanelXWhiteSpacePercent = 2
; pres@gsnPanelYWhiteSpacePercent = 2

pres@gsnPanelLabelBar = True
pres@lbLabelFontHeightF   = 0.012
pres@gsnPanelBottom = 0.001
pres@lbLabelStride = 2

; XF = fspan(0.15,0.8,6)+0.015
; pres@gsnPanelXF = (/XF(0),XF(1),XF(2),XF(3),XF(4),XF(5),\
;                     XF(0),XF(1),XF(2),XF(3),XF(4),XF(5),\
;                     XF(0),XF(1),XF(2),XF(3),XF(4),XF(5),\
;                     XF(0),XF(1),XF(2),XF(3),XF(4),XF(5)/)
;
YF = fspan(0.9,0.22,5)
pres@gsnPanelYF = (/YF(0),YF(0),YF(0),\
                    YF(1),YF(1),YF(1),\
                    YF(2),YF(2),YF(2),\
                    YF(3),YF(3),YF(3),\
                    YF(4),YF(4),YF(4)/)

gsn_panel(wks,(/plot_NET_ERA5_SS,      plot_SNC_ERA5_SS,     plot_TEM_ERA5_SS,     \
                plot_NET_ERA5snow_SS,  plot_SNC_ERA5snow_SS, plot_TEM_ERA5snow_SS, \
                plot_NET_JRA3Q_SS,     plot_SNC_JRA3Q_SS,    plot_TEM_JRA3Q_SS,    \
                plot_NET_JRA55_SS,     plot_SNC_JRA55_SS,    plot_TEM_JRA55_SS,    \
                plot_NET_MERRA2_SS,    plot_SNC_MERRA2_SS,   plot_TEM_MERRA2_SS/),(/5,3/),pres)

; gsn_panel(wks,(/plot_NET_ERA5_DS,      plot_SNC_ERA5_DS,     plot_TEM_ERA5_DS,     \
;                 plot_NET_ERA5snow_DS,  plot_SNC_ERA5snow_DS, plot_TEM_ERA5snow_DS, \
;                 plot_NET_JRA3Q_DS,     plot_SNC_JRA3Q_DS,    plot_TEM_JRA3Q_DS,    \
;                 plot_NET_JRA55_DS,     plot_SNC_JRA55_DS,    plot_TEM_JRA55_DS,    \
;                 plot_NET_MERRA2_DS,    plot_SNC_MERRA2_DS,   plot_TEM_MERRA2_DS/),(/5,3/),pres)

end
