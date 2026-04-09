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

wks = gsn_open_wks("pdf",outpath+"Figure_S8")
; gsn_define_colormap(wks,"rainbow")

n_lat6 = 45
n_lon6 = 360

k1_36 = new((/3,n_lat6,n_lon6/),"double")
k2_36 = k1_36
k5_36 = k1_36

;---------------seasonal--------------------
;---------------ERA5-Land-------------
  m6 := "ERA5-Land2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_ERA5_SS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_ERA5_SS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_ERA5_SS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_ERA5_SS)
copy_VarCoords(k1,k2_ERA5_SS)
copy_VarCoords(k1,k5_ERA5_SS)

;---------------MERRA2-------------
  m6 := "MERRA22"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_MERRA2_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_MERRA2_SS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_MERRA2_SS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_MERRA2_SS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_MERRA2_SS)
copy_VarCoords(k1,k2_MERRA2_SS)
copy_VarCoords(k1,k5_MERRA2_SS)

;---------------JRA55-------------
  m6 := "JRA552"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA55_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_JRA55_SS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_JRA55_SS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_JRA55_SS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_JRA55_SS)
copy_VarCoords(k1,k2_JRA55_SS)
copy_VarCoords(k1,k5_JRA55_SS)

;---------------JRA3Q-------------
  m6 := "JRA3Q2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA3Q_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_JRA3Q_SS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_JRA3Q_SS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_JRA3Q_SS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_JRA3Q_SS)
copy_VarCoords(k1,k2_JRA3Q_SS)
copy_VarCoords(k1,k5_JRA3Q_SS)

;---------------ERA5snow-------------
  m6 := "ERA5snow2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5snow_SS+M(j)+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_ERA5snow_SS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_ERA5snow_SS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_ERA5snow_SS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_ERA5snow_SS)
copy_VarCoords(k1,k2_ERA5snow_SS)
copy_VarCoords(k1,k5_ERA5snow_SS)

;--------------decadal---------------------
;---------------ERA5-Land-------------
  m6 := "ERA5-Land2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_ERA5_DS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_ERA5_DS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_ERA5_DS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_ERA5_DS)
copy_VarCoords(k1,k2_ERA5_DS)
copy_VarCoords(k1,k5_ERA5_DS)

;---------------MERRA2-------------
  m6 := "MERRA22"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_MERRA2_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_MERRA2_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_MERRA2_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_MERRA2_DS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_MERRA2_DS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_MERRA2_DS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_MERRA2_DS)
copy_VarCoords(k1,k2_MERRA2_DS)
copy_VarCoords(k1,k5_MERRA2_DS)

;---------------JRA55-------------
  m6 := "JRA552"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA55_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA55_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA55_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_JRA55_DS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_JRA55_DS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_JRA55_DS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_JRA55_DS)
copy_VarCoords(k1,k2_JRA55_DS)
copy_VarCoords(k1,k5_JRA55_DS)

;---------------JRA3Q-------------
  m6 := "JRA3Q2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_JRA3Q_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_JRA3Q_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_JRA3Q_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_JRA3Q_DS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_JRA3Q_DS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_JRA3Q_DS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_JRA3Q_DS)
copy_VarCoords(k1,k2_JRA3Q_DS)
copy_VarCoords(k1,k5_JRA3Q_DS)

;---------------ERA5snow-------------
  m6 := "ERA5snow2"
  do j = 0,2
    files_k1 := systemfunc("ls "+inpath_ERA5snow_DS+"k1."+m6+".EASE_grid.nc")
    files_k2 := systemfunc("ls "+inpath_ERA5snow_DS+"k2."+m6+".EASE_grid.nc")
    files_k5 := systemfunc("ls "+inpath_ERA5snow_DS+"k5."+m6+".EASE_grid.nc")

    f_k1   = addfiles(files_k1,"r")
    f_k2   = addfiles(files_k2,"r")
    f_k5   = addfiles(files_k5,"r")

    k1     = f_k1[:]->k1(0,:,:)
    k2     = f_k2[:]->k2(0,:,:)
    k5     = f_k5[:]->k5(0,:,:)
    ; printVarSummary(k1)
    ; printVarSummary(k2)
    ; printVarSummary(k5)
    k1_36(j,:,:) = k1    ;3*1*144*25
    k2_36(j,:,:) = k2
    k5_36(j,:,:) = k5
  end do

k1_ERA5snow_DS = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
k2_ERA5snow_DS = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
k5_ERA5snow_DS = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

copy_VarCoords(k1,k1_ERA5snow_DS)
copy_VarCoords(k1,k2_ERA5snow_DS)
copy_VarCoords(k1,k5_ERA5snow_DS)

printVarSummary(k5_ERA5snow_DS)
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

;res@gsnCenterStringFontHeightF = 0.005
;res@gsnCenterStringOrthogonalPosF = 0.05

res@gsnLeftString = ""

colors = (/"BlueWhiteOrangeRed","cmocean_deep","BlueWhiteOrangeRed"/)
; res@cnFillPalette = "GMT_hot"

min_1   = -6.
max_1   = 6.
space_1 = 1.

min_2   = 0.0
max_2   = 40.0
space_2 = 5.0

min_3   = -3.
max_3   = 3.
space_3 = 0.5

res@lbLabelBarOn   = False
res@lbLabelFontHeightF = 0.036

res@tiYAxisFontHeightF = 0.057
res@tiYAxisOffsetXF    = -0.022

res@tiMainFontHeightF = 0.057
res@tiMainOffsetYF    = 0.004

res@gsnLeftStringFontHeightF = 0.039
res@gsnLeftStringOrthogonalPosF = -0.02

res@lbLabelStride   = 2


;************k1*************
res@cnFillPalette   = colors(0)

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_1		; set the minimum contour level
res@cnMaxLevelValF  = max_1			; set the maximum contour level
res@cnLevelSpacingF = space_1
;res@gk1enterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"

res@tiYAxisString   = "ERA5-Land"
res@tiMainString    = "~F33~D~F~S~B~C~N~/<~F33~D~F~T~B~S~N~>"
res@gsnLeftString   = "(a)"
plot_k1_ERA5_SS = gsn_csm_contour_map_polar(wks,k1_ERA5_SS,res)

res@gsnLeftString   = "(c)"
res@tiYAxisOn       = False
plot_k1_ERA5_DS = gsn_csm_contour_map_polar(wks,k1_ERA5_DS,res)

res@tiYAxisOn       = True
res@tiMainOn        = False
res@tiYAxisString   = "ERA5-Snow"
res@gsnLeftString   = "(e)"
plot_k1_ERA5snow_SS = gsn_csm_contour_map_polar(wks,k1_ERA5snow_SS,res)

res@gsnLeftString   = "(g)"
res@tiYAxisOn       = False
plot_k1_ERA5snow_DS = gsn_csm_contour_map_polar(wks,k1_ERA5snow_DS,res)

res@tiYAxisOn       = True
res@tiYAxisString   = "JRA-3Q"
res@gsnLeftString   = "(i)"
plot_k1_JRA3Q_SS = gsn_csm_contour_map_polar(wks,k1_JRA3Q_SS,res)

res@gsnLeftString   = "(k)"
res@tiYAxisOn       = False
plot_k1_JRA3Q_DS = gsn_csm_contour_map_polar(wks,k1_JRA3Q_DS,res)

res@tiYAxisOn       = True
res@tiYAxisString   = "JRA-55"
res@gsnLeftString   = "(m)"
plot_k1_JRA55_SS = gsn_csm_contour_map_polar(wks,k1_JRA55_SS,res)

res@gsnLeftString   = "(o)"
res@tiYAxisOn       = False
plot_k1_JRA55_DS = gsn_csm_contour_map_polar(wks,k1_JRA55_DS,res)

res@tiYAxisOn       = True
res@tiYAxisString   = "MERRA-2"
res@lbLabelBarOn    = True
res@gsnLeftString   = "(q)"
plot_k1_MERRA2_SS = gsn_csm_contour_map_polar(wks,k1_MERRA2_SS,res)

res@gsnLeftString   = "(s)"
res@tiYAxisOn       = False
plot_k1_MERRA2_DS = gsn_csm_contour_map_polar(wks,k1_MERRA2_DS,res)

res@lbLabelBarOn    = False
res@tiYAxisOn       = False

;************k2*************
cmap = read_colormap_file("cmocean_deep")
reversed_cmap = cmap(::-1, :); 反转行的顺序
res@cnFillPalette   := reversed_cmap

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_2		; set the minimum contour level
res@cnMaxLevelValF  = max_2			; set the maximum contour level
res@cnLevelSpacingF = space_2
;res@gk2enterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"

res@tiMainOn        = True
res@tiMainString = "~F33~a~F~~B~snow~N~~H-57V6F35~EEEEE~FV-6H3~~V11F33~ _ ~V-11~~F33~a~F~~B~land~N~ (%)"
; res@tiMainString     = "~F33~a~F~~B~snow~N~(%)"
; line_x = (/0.2, 0.8/)  ; 上划线的起止点（x坐标）
; line_y = (/0.97, 0.97/)  ; 上划线的 y 坐标（位于文本上方）
; plot_line = gsn_add_polyline(wks, plot_k1_MERRA2_SS, line_x, line_y)
; gsn_set_polymarker(plot_line, "LineThickness", 2)

res@gsnLeftString   = "(b)"
plot_k2_ERA5_SS = gsn_csm_contour_map_polar(wks,k2_ERA5_SS,res)
res@gsnLeftString   = "(d)"
plot_k2_ERA5_DS = gsn_csm_contour_map_polar(wks,k2_ERA5_DS,res)

res@tiMainOn        = False
res@gsnLeftString   = "(f)"
plot_k2_ERA5snow_SS = gsn_csm_contour_map_polar(wks,k2_ERA5snow_SS,res)

res@gsnLeftString   = "(h)"
plot_k2_ERA5snow_DS = gsn_csm_contour_map_polar(wks,k2_ERA5snow_DS,res)

res@gsnLeftString   = "(j)"
plot_k2_JRA3Q_SS   = gsn_csm_contour_map_polar(wks,k2_JRA3Q_SS,res)
res@gsnLeftString   = "(l)"
plot_k2_JRA3Q_DS   = gsn_csm_contour_map_polar(wks,k2_JRA3Q_DS,res)

res@gsnLeftString   = "(n)"
plot_k2_JRA55_SS   = gsn_csm_contour_map_polar(wks,k2_JRA55_SS,res)
res@gsnLeftString   = "(p)"
plot_k2_JRA55_DS   = gsn_csm_contour_map_polar(wks,k2_JRA55_DS,res)

res@lbLabelBarOn   = True
res@gsnLeftString   = "(r)"
plot_k2_MERRA2_SS  = gsn_csm_contour_map_polar(wks,k2_MERRA2_SS,res)
res@gsnLeftString   = "(t)"
plot_k2_MERRA2_DS  = gsn_csm_contour_map_polar(wks,k2_MERRA2_DS,res)

res@lbLabelBarOn   = False

;************k5*************
res@cnFillPalette   := colors(2)

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_3		; set the minimum contour level
res@cnMaxLevelValF  = max_3			; set the maximum contour level
res@cnLevelSpacingF = space_3
;res@gk2enterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"

res@tiMainOn        = True
res@tiMainString = "~F33~D~F~~F33~a~F~~B~snow~N~/<~F33~D~F~T~B~S~N~>"
res@gsnLeftString   = "(c)"
plot_k5_ERA5_SS = gsn_csm_contour_map_polar(wks,k5_ERA5_SS,res)
plot_k5_ERA5_DS = gsn_csm_contour_map_polar(wks,k5_ERA5_DS,res)

res@tiMainOn         = False
res@gsnLeftString   = "(f)"
plot_k5_ERA5snow_SS = gsn_csm_contour_map_polar(wks,k5_ERA5snow_SS,res)
plot_k5_ERA5snow_DS = gsn_csm_contour_map_polar(wks,k5_ERA5snow_DS,res)

res@gsnLeftString   = "(i)"
plot_k5_JRA3Q_SS = gsn_csm_contour_map_polar(wks,k5_JRA3Q_SS,res)
plot_k5_JRA3Q_DS = gsn_csm_contour_map_polar(wks,k5_JRA3Q_DS,res)

res@gsnLeftString   = "(l)"
plot_k5_JRA55_SS = gsn_csm_contour_map_polar(wks,k5_JRA55_SS,res)
plot_k5_JRA55_DS = gsn_csm_contour_map_polar(wks,k5_JRA55_DS,res)

res@lbLabelBarOn    = True
res@gsnLeftString   = "(o)"
plot_k5_MERRA2_SS    = gsn_csm_contour_map_polar(wks,k5_MERRA2_SS,res)
plot_k5_MERRA2_DS    = gsn_csm_contour_map_polar(wks,k5_MERRA2_DS,res)

res@lbLabelBarOn    = False

;-------------------------------------
;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
; pres@gsnMaximize   = True
; pres@gsnPanelXWhiteSpacePercent = 2
pres@gsnPanelYWhiteSpacePercent = 3

pres@txString = "Seasonal                                        Decadal"
pres@gsnPanelMainFontHeightF  = 0.018
pres@gsnPanelMainFont    = 22

pres@gsnPanelLabelBar = False
; pres@lbLabelFontHeightF   = 0.02
; pres@gsnPanelBottom = 0.001

; XF = fspan(0.06,0.85,5)
; pres@gsnPanelXF = (/XF(0),XF(1),XF(2),XF(3),\
;                     XF(0),XF(1),XF(2),XF(3),\
;                     XF(0),XF(1),XF(2),XF(3),\
;                     XF(0),XF(1),XF(2),XF(3),\
;                     XF(0),XF(1),XF(2),XF(3)/)

YF = fspan(0.85,0.21,5)
pres@gsnPanelYF = (/YF(0),YF(0),YF(0),YF(0),\
                    YF(1),YF(1),YF(1),YF(1),\
                    YF(2),YF(2),YF(2),YF(2),\
                    YF(3),YF(3),YF(3),YF(3),\
                    YF(4),YF(4),YF(4),YF(4)/)

gsn_panel(wks,(/plot_k1_ERA5_SS,    plot_k2_ERA5_SS,     plot_k1_ERA5_DS,    plot_k2_ERA5_DS,    \
                plot_k1_ERA5snow_SS,plot_k2_ERA5snow_SS, plot_k1_ERA5snow_DS,plot_k2_ERA5snow_DS,\
                plot_k1_JRA3Q_SS,   plot_k2_JRA3Q_SS,    plot_k1_JRA3Q_DS,   plot_k2_JRA3Q_DS,   \
                plot_k1_JRA55_SS,   plot_k2_JRA55_SS,    plot_k1_JRA55_DS,   plot_k2_JRA55_DS,   \
                plot_k1_MERRA2_SS,  plot_k2_MERRA2_SS,   plot_k1_MERRA2_DS,  plot_k2_MERRA2_DS /),(/5,4/),pres)


end
