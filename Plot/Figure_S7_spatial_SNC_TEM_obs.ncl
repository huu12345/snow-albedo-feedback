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

wks = gsn_open_wks("pdf",outpath+"Figure_S6")
; gsn_define_colormap(wks,"rainbow")

n_lat6 = 45
n_lon6 = 360

k1_36 = new((/3,n_lat6,n_lon6/),"double")
k2_36 = k1_36
k5_36 = k1_36

;---------------seasonal--------------------
;---------------观测-------------
nm_tas = (/"CRU","GHCN"/)
nm_k2 = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3","GLASS"/)

k1_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
k2_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
k5_obs = new((/2,3,4,n_lat6,n_lon6/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;k2
    do k= 0,3  ;alb

       do j = 0,2
          files_k1 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k1.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_k2 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k2.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_k5 := systemfunc("ls "+inpath_OBS_SS+M(j)+"k5.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")

          f_k1   = addfiles(files_k1,"r")
          f_k2   = addfiles(files_k2,"r")
          f_k5   = addfiles(files_k5,"r")

          k1_36(j,:,:) = f_k1[:]->k1(0,:,:)
          k2_36(j,:,:) = f_k2[:]->k2(0,:,:)
          k5_36(j,:,:) = f_k5[:]->k5(0,:,:)

          copy = f_k1[:]->k1(0,:,:)
       end do

       k1_obs(m,n,k,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
       k2_obs(m,n,k,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
       k5_obs(m,n,k,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

    end do
  end do
end do

k1_obs_SS = dim_avg_n(k1_obs,(/0,1/))
k2_obs_SS = dim_avg_n(k2_obs,(/0,1/))
k5_obs_SS = dim_avg_n(k5_obs,(/0,1/))

k1_APPx_SS     = k1_obs_SS(0,:,:)
k1_clara_a2_SS = k1_obs_SS(1,:,:)
k1_clara_a3_SS = k1_obs_SS(2,:,:)
k1_GLASS_SS    = k1_obs_SS(3,:,:)

k2_APPx_SS     = k2_obs_SS(0,:,:)
k2_clara_a2_SS = k2_obs_SS(1,:,:)
k2_clara_a3_SS = k2_obs_SS(2,:,:)
k2_GLASS_SS    = k2_obs_SS(3,:,:)

k5_APPx_SS     = k5_obs_SS(0,:,:)
k5_clara_a2_SS = k5_obs_SS(1,:,:)
k5_clara_a3_SS = k5_obs_SS(2,:,:)
k5_GLASS_SS    = k5_obs_SS(3,:,:)

copy_VarCoords(copy,k1_APPx_SS)
copy_VarCoords(copy,k1_clara_a2_SS)
copy_VarCoords(copy,k1_clara_a3_SS)
copy_VarCoords(copy,k1_GLASS_SS)

copy_VarCoords(copy,k2_APPx_SS)
copy_VarCoords(copy,k2_clara_a2_SS)
copy_VarCoords(copy,k2_clara_a3_SS)
copy_VarCoords(copy,k2_GLASS_SS)

copy_VarCoords(copy,k5_APPx_SS)
copy_VarCoords(copy,k5_clara_a2_SS)
copy_VarCoords(copy,k5_clara_a3_SS)
copy_VarCoords(copy,k5_GLASS_SS)


;--------------decadal---------------------
;---------------观测-------------
nm_tas = (/"CRU","GHCN"/)
nm_k2 = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3","GLASS"/)

k1_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
k2_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
k5_obs = new((/2,3,4,n_lat6,n_lon6/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;k2
    do k= 0,3  ;alb

       do j = 0,2
          files_k1 := systemfunc("ls "+inpath_OBS_DS+"k1.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_k2 := systemfunc("ls "+inpath_OBS_DS+"k2.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_k5 := systemfunc("ls "+inpath_OBS_DS+"k5.obs_"+nm_tas(m)+"_"+nm_k2(n)+"_"+nm_alb(k)+".EASE_grid.nc")

          f_k1   = addfiles(files_k1,"r")
          f_k2   = addfiles(files_k2,"r")
          f_k5   = addfiles(files_k5,"r")

          k1_36(j,:,:) = f_k1[:]->k1(0,:,:)
          k2_36(j,:,:) = f_k2[:]->k2(0,:,:)
          k5_36(j,:,:) = f_k5[:]->k5(0,:,:)
       end do

       k1_obs(m,n,k,:,:) = dim_avg_n(k1_36,0)      ;27,n_lat,n_lon
       k2_obs(m,n,k,:,:) = dim_avg_n(k2_36,0)      ;27,n_lat,n_lon
       k5_obs(m,n,k,:,:) = dim_avg_n(k5_36,0)      ;27,n_lat,n_lon

    end do
  end do
end do

k1_obs_DS = dim_avg_n(k1_obs,(/0,1/))
k2_obs_DS = dim_avg_n(k2_obs,(/0,1/))
k5_obs_DS = dim_avg_n(k5_obs,(/0,1/))

k1_APPx_DS     = k1_obs_DS(0,:,:)
k1_clara_a2_DS = k1_obs_DS(1,:,:)
k1_clara_a3_DS = k1_obs_DS(2,:,:)
k1_GLASS_DS    = k1_obs_DS(3,:,:)

k2_APPx_DS     = k2_obs_DS(0,:,:)
k2_clara_a2_DS = k2_obs_DS(1,:,:)
k2_clara_a3_DS = k2_obs_DS(2,:,:)
k2_GLASS_DS    = k2_obs_DS(3,:,:)

k5_APPx_DS     = k5_obs_DS(0,:,:)
k5_clara_a2_DS = k5_obs_DS(1,:,:)
k5_clara_a3_DS = k5_obs_DS(2,:,:)
k5_GLASS_DS    = k5_obs_DS(3,:,:)

copy_VarCoords(copy,k1_APPx_DS)
copy_VarCoords(copy,k1_clara_a2_DS)
copy_VarCoords(copy,k1_clara_a3_DS)
copy_VarCoords(copy,k1_GLASS_DS)

copy_VarCoords(copy,k2_APPx_DS)
copy_VarCoords(copy,k2_clara_a2_DS)
copy_VarCoords(copy,k2_clara_a3_DS)
copy_VarCoords(copy,k2_GLASS_DS)

copy_VarCoords(copy,k5_APPx_DS)
copy_VarCoords(copy,k5_clara_a2_DS)
copy_VarCoords(copy,k5_clara_a3_DS)
copy_VarCoords(copy,k5_GLASS_DS)

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

res@gsnPolarLabelFontHeightF = 0.022

;res@gsnCenterStringFontHeightF = 0.005
;res@gsnCenterStringOrthogonalPosF = 0.05

min_1   = -5.0
max_1   = 0.0
space_1 = 0.5

min_2   = 0.0
max_2   = 40.0
space_2 = 5.0

min_3   = -3.
max_3   = 3.
space_3 = 0.5

min_4   = -6.
max_4   = 6.
space_4 = 1.

res@lbLabelBarOn   = False
res@lbLabelFontHeightF = 0.034

res@tiYAxisFontHeightF = 0.057
res@tiYAxisOffsetXF    = -0.02

res@tiMainFontHeightF = 0.057
res@tiMainOffsetYF    = 0.004

res@gsnLeftStringFontHeightF = 0.039
res@gsnLeftStringOrthogonalPosF = -0.02

res@lbLabelStride   = 2

;************k2*************
cmap = read_colormap_file("cmocean_deep")
reversed_cmap = cmap(::-1, :); 反转行的顺序
res@cnFillPalette   = reversed_cmap

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_2		; set the minimum contour level
res@cnMaxLevelValF  = max_2			; set the maximum contour level
res@cnLevelSpacingF = space_2
;res@gk2enterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"

res@tiYAxisString   = "APP-x"
res@tiMainString = "~F33~a~F~~B~snow~N~~H-57V6F35~EEEEE~FV-6H3~~V11F33~ _ ~V-11~~F33~a~F~~B~land~N~"
res@gsnLeftString   = "(a)"
plot_k2_APPx_SS = gsn_csm_contour_map_polar(wks,k2_APPx_SS,res)

res@tiYAxisOn       = False
res@tiMainString = "~F33~a~F~~B~snow~N~~H-57V6F35~EEEEE~FV-6H3~~V11F33~ _ ~V-11~~F33~a~F~~B~land~N~"
res@gsnLeftString   = "(c)"
plot_k2_APPx_DS = gsn_csm_contour_map_polar(wks,k2_APPx_DS,res)

res@tiMainOn        = False
res@tiYAxisString   = "CLARA-A2"
res@tiYAxisOn       = True
res@gsnLeftString   = "(e)"
plot_k2_clara_a2_SS = gsn_csm_contour_map_polar(wks,k2_clara_a2_SS,res)

res@tiYAxisOn       = False
res@gsnLeftString   = "(g)"
plot_k2_clara_a2_DS = gsn_csm_contour_map_polar(wks,k2_clara_a2_DS,res)

res@lbLabelBarOn    = True
res@tiYAxisString   = "CLARA-A3"
res@tiYAxisOn       = True
res@gsnLeftString   = "(i)"
plot_k2_clara_a3_SS = gsn_csm_contour_map_polar(wks,k2_clara_a3_SS,res)

res@tiYAxisOn       = False
res@gsnLeftString   = "(k)"
plot_k2_clara_a3_DS = gsn_csm_contour_map_polar(wks,k2_clara_a3_DS,res)

res@tiYAxisString   = "GLASS"
; res@tiYAxisOn       = True
res@lbLabelBarOn    = True
res@gsnLeftString   = "(m)"
plot_k2_GLASS_SS = gsn_csm_contour_map_polar(wks,k2_GLASS_SS,res)

res@tiYAxisOn       = False
res@gsnLeftString   = "(o)"
plot_k2_GLASS_DS = gsn_csm_contour_map_polar(wks,k2_GLASS_DS,res)

res@lbLabelBarOn    = False
res@tiYAxisOn       = False

;************k5*************
res@cnFillPalette  := "BlueWhiteOrangeRed"
res@lbLabelStride   = 2

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_3		; set the minimum contour level
res@cnMaxLevelValF  = max_3			; set the maximum contour level
res@cnLevelSpacingF = space_3
res@tiMainOn        = True
res@tiMainString = "~F33~D~F~~F33~a~F~~B~snow~N~/<~F33~D~F~T~B~S~N~>"
res@gsnLeftString   = "(b)"
plot_k5_APPx_SS = gsn_csm_contour_map_polar(wks,k5_APPx_SS,res)

res@cnMinLevelValF  = min_4		; set the minimum contour level
res@cnMaxLevelValF  = max_4			; set the maximum contour level
res@cnLevelSpacingF = space_4
res@tiMainString = "~F33~D~F~~F33~a~F~~B~snow~N~/<~F33~D~F~T~B~S~N~>"
res@gsnLeftString   = "(d)"
plot_k5_APPx_DS = gsn_csm_contour_map_polar(wks,k5_APPx_DS,res)

res@cnMinLevelValF  = min_3		; set the minimum contour level
res@cnMaxLevelValF  = max_3			; set the maximum contour level
res@cnLevelSpacingF = space_3
res@tiMainOn         = False
res@gsnLeftString   = "(f)"
plot_k5_clara_a2_SS = gsn_csm_contour_map_polar(wks,k5_clara_a2_SS,res)

res@cnMinLevelValF  = min_4		; set the minimum contour level
res@cnMaxLevelValF  = max_4			; set the maximum contour level
res@cnLevelSpacingF = space_4
res@gsnLeftString   = "(h)"
plot_k5_clara_a2_DS = gsn_csm_contour_map_polar(wks,k5_clara_a2_DS,res)

res@lbLabelBarOn    = True
res@cnMinLevelValF  = min_3		; set the minimum contour level
res@cnMaxLevelValF  = max_3			; set the maximum contour level
res@cnLevelSpacingF = space_3
res@gsnLeftString   = "(j)"
plot_k5_clara_a3_SS = gsn_csm_contour_map_polar(wks,k5_clara_a3_SS,res)

res@cnMinLevelValF  = min_4		; set the minimum contour level
res@cnMaxLevelValF  = max_4			; set the maximum contour level
res@cnLevelSpacingF = space_4
res@gsnLeftString   = "(l)"
plot_k5_clara_a3_DS = gsn_csm_contour_map_polar(wks,k5_clara_a3_DS,res)

res@cnMinLevelValF  = min_3		; set the minimum contour level
res@cnMaxLevelValF  = max_3			; set the maximum contour level
res@cnLevelSpacingF = space_3
res@lbLabelBarOn    = True
res@gsnLeftString   = "(n)"
plot_k5_GLASS_SS    = gsn_csm_contour_map_polar(wks,k5_GLASS_SS,res)

res@cnMinLevelValF  = min_4		; set the minimum contour level
res@cnMaxLevelValF  = max_4			; set the maximum contour level
res@cnLevelSpacingF = space_4
res@gsnLeftString   = "(p)"
plot_k5_GLASS_DS    = gsn_csm_contour_map_polar(wks,k5_GLASS_DS,res)

res@lbLabelBarOn    = False

;-------------------------------------
;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
; pres@gsnMaximize   = True
; pres@gsnPanelXWhiteSpacePercent = 2
; pres@gsnPanelYWhiteSpacePercent = 2
pres@txString = "Seasonal                                                     Decadal"
pres@gsnPanelMainFontHeightF  = 0.018
pres@gsnPanelMainFont    = 22

pres@gsnPanelLabelBar = False
; pres@lbLabelFontHeightF   = 0.016
; pres@gsnPanelBottom = 0.001

XF = fspan(0.06,0.77,4)
pres@gsnPanelXF = (/XF(0),XF(1),XF(2),XF(3),\
                    XF(0),XF(1),XF(2),XF(3),\
                    XF(0),XF(1),XF(2),XF(3)/)

YF = fspan(0.85,0.38,3)
pres@gsnPanelYF = (/YF(0),YF(0),YF(0),YF(0),\
                    YF(1),YF(1),YF(1),YF(1),\
                    YF(2),YF(2),YF(2),YF(2)/)

gsn_panel(wks,(/plot_k2_APPx_SS,     plot_k5_APPx_SS,     plot_k2_APPx_DS,     plot_k5_APPx_DS,    \
                plot_k2_clara_a2_SS, plot_k5_clara_a2_SS, plot_k2_clara_a2_DS, plot_k5_clara_a2_DS,\
                plot_k2_clara_a3_SS, plot_k5_clara_a3_SS, plot_k2_clara_a3_DS, plot_k5_clara_a3_DS/),(/3,4/),pres)


end
