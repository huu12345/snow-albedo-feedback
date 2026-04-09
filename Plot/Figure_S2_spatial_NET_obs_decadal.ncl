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

wks = gsn_open_wks("pdf",outpath+"Figure_S2")
; gsn_define_colormap(wks,"rainbow")


n_lat6 = 45
n_lon6 = 360

NET_36 = new((/3,n_lat6,n_lon6/),"double")
SNC_36 = NET_36
TEM_36 = NET_36

;---------------seasonal--------------------
;---------------观测-------------
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3","GLASS"/)

NET_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
SNC_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
TEM_obs = new((/2,3,4,n_lat6,n_lon6/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;snc
    do k= 0,3  ;alb

       do j = 0,2
          files_NET := systemfunc("ls "+inpath_OBS_SS+M(j)+"k4.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_SNC := systemfunc("ls "+inpath_OBS_SS+M(j)+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_TEM := systemfunc("ls "+inpath_OBS_SS+M(j)+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")

          f_NET   = addfiles(files_NET,"r")
          f_SNC   = addfiles(files_SNC,"r")
          f_TEM   = addfiles(files_TEM,"r")

          NET_36(j,:,:) = f_NET[:]->k4(0,:,:)
          SNC_36(j,:,:) = f_SNC[:]->k1k2(0,:,:)
          TEM_36(j,:,:) = f_TEM[:]->k3(0,:,:)

          copy = f_NET[:]->k4(0,:,:)
       end do

       NET_obs(m,n,k,:,:) = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
       SNC_obs(m,n,k,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
       TEM_obs(m,n,k,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

    end do
  end do
end do

NET_obs_SS = dim_avg_n(NET_obs,(/0,1/))
SNC_obs_SS = dim_avg_n(SNC_obs,(/0,1/))
TEM_obs_SS = dim_avg_n(TEM_obs,(/0,1/))

NET_APPx_SS     = NET_obs_SS(0,:,:)
NET_clara_a2_SS = NET_obs_SS(1,:,:)
NET_clara_a3_SS = NET_obs_SS(2,:,:)
NET_GLASS_SS    = NET_obs_SS(3,:,:)

SNC_APPx_SS     = SNC_obs_SS(0,:,:)
SNC_clara_a2_SS = SNC_obs_SS(1,:,:)
SNC_clara_a3_SS = SNC_obs_SS(2,:,:)
SNC_GLASS_SS    = SNC_obs_SS(3,:,:)

TEM_APPx_SS     = TEM_obs_SS(0,:,:)
TEM_clara_a2_SS = TEM_obs_SS(1,:,:)
TEM_clara_a3_SS = TEM_obs_SS(2,:,:)
TEM_GLASS_SS    = TEM_obs_SS(3,:,:)

copy_VarCoords(copy,NET_APPx_SS)
copy_VarCoords(copy,NET_clara_a2_SS)
copy_VarCoords(copy,NET_clara_a3_SS)
copy_VarCoords(copy,NET_GLASS_SS)

copy_VarCoords(copy,SNC_APPx_SS)
copy_VarCoords(copy,SNC_clara_a2_SS)
copy_VarCoords(copy,SNC_clara_a3_SS)
copy_VarCoords(copy,SNC_GLASS_SS)

copy_VarCoords(copy,TEM_APPx_SS)
copy_VarCoords(copy,TEM_clara_a2_SS)
copy_VarCoords(copy,TEM_clara_a3_SS)
copy_VarCoords(copy,TEM_GLASS_SS)

;--------------decadal---------------------
;---------------观测-------------
nm_tas = (/"CRU","GHCN"/)
nm_snc = (/"JASMES","NSIDC","Rutgers"/)
nm_alb = (/"APPx","clara_a2","clara_a3","GLASS"/)

NET_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
SNC_obs = new((/2,3,4,n_lat6,n_lon6/),"double")
TEM_obs = new((/2,3,4,n_lat6,n_lon6/),"double")

do m = 0,1  ;tas
  do n = 0,2  ;snc
    do k= 0,3  ;alb

       do j = 0,2
          files_NET := systemfunc("ls "+inpath_OBS_DS+"k4.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_SNC := systemfunc("ls "+inpath_OBS_DS+"k1k2.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")
          files_TEM := systemfunc("ls "+inpath_OBS_DS+"k3.obs_"+nm_tas(m)+"_"+nm_snc(n)+"_"+nm_alb(k)+".EASE_grid.nc")

          f_NET   = addfiles(files_NET,"r")
          f_SNC   = addfiles(files_SNC,"r")
          f_TEM   = addfiles(files_TEM,"r")

          NET_36(j,:,:) = f_NET[:]->k4(0,:,:)
          SNC_36(j,:,:) = f_SNC[:]->k1k2(0,:,:)
          TEM_36(j,:,:) = f_TEM[:]->k3(0,:,:)
       end do

       NET_obs(m,n,k,:,:) = dim_avg_n(NET_36,0)      ;27,n_lat,n_lon
       SNC_obs(m,n,k,:,:) = dim_avg_n(SNC_36,0)      ;27,n_lat,n_lon
       TEM_obs(m,n,k,:,:) = dim_avg_n(TEM_36,0)      ;27,n_lat,n_lon

    end do
  end do
end do

NET_obs_DS = dim_avg_n(NET_obs,(/0,1/))
SNC_obs_DS = dim_avg_n(SNC_obs,(/0,1/))
TEM_obs_DS = dim_avg_n(TEM_obs,(/0,1/))

NET_APPx_DS     = NET_obs_DS(0,:,:)
NET_clara_a2_DS = NET_obs_DS(1,:,:)
NET_clara_a3_DS = NET_obs_DS(2,:,:)
NET_GLASS_DS    = NET_obs_DS(3,:,:)

SNC_APPx_DS     = SNC_obs_DS(0,:,:)
SNC_clara_a2_DS = SNC_obs_DS(1,:,:)
SNC_clara_a3_DS = SNC_obs_DS(2,:,:)
SNC_GLASS_DS    = SNC_obs_DS(3,:,:)

TEM_APPx_DS     = TEM_obs_DS(0,:,:)
TEM_clara_a2_DS = TEM_obs_DS(1,:,:)
TEM_clara_a3_DS = TEM_obs_DS(2,:,:)
TEM_GLASS_DS    = TEM_obs_DS(3,:,:)

copy_VarCoords(copy,NET_APPx_DS)
copy_VarCoords(copy,NET_clara_a2_DS)
copy_VarCoords(copy,NET_clara_a3_DS)
copy_VarCoords(copy,NET_GLASS_DS)

copy_VarCoords(copy,SNC_APPx_DS)
copy_VarCoords(copy,SNC_clara_a2_DS)
copy_VarCoords(copy,SNC_clara_a3_DS)
copy_VarCoords(copy,SNC_GLASS_DS)

copy_VarCoords(copy,TEM_APPx_DS)
copy_VarCoords(copy,TEM_clara_a2_DS)
copy_VarCoords(copy,TEM_clara_a3_DS)
copy_VarCoords(copy,TEM_GLASS_DS)

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

; res@gsnLeftString = ""

colors = (/"BlueWhiteOrangeRed"/)
; res@cnFillPalette = "GMT_hot"temp_diff_18lev
min_1   = -2.4
max_1   = 2.4
space_1 = 0.3

res@lbLabelBarOn   = False
res@lbLabelFontHeightF = 0.02

res@tiYAxisFontHeightF = 0.06
res@tiYAxisOffsetXF    = -0.02

res@tiMainFontHeightF = 0.06
res@tiMainOffsetYF    = 0.004

res@gsnLeftStringFontHeightF = 0.041
res@gsnLeftStringOrthogonalPosF = -0.02

;************NET sesonal*************
res@tiMainString      = "SAF~B~NET~N~"

res@cnFillPalette   = colors(0)

res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF  = min_1		; set the minimum contour level
res@cnMaxLevelValF  = max_1			; set the maximum contour level
res@cnLevelSpacingF = space_1
;res@gsnCenterString = "(j)APP-x: ~F33~D~F~{Sc}/~F33~D~F~{Ts}"

res@tiYAxisString   = "APP-x"
res@gsnLeftString = "(a)"
plot_NET_APPx_SS = gsn_csm_contour_map_polar(wks,NET_APPx_SS,res)
plot_NET_APPx_DS = gsn_csm_contour_map_polar(wks,NET_APPx_DS,res)

res@tiMainOn        = False
res@tiYAxisString   = "CLARA-A2"
res@gsnLeftString = "(d)"
plot_NET_clara_a2_SS = gsn_csm_contour_map_polar(wks,NET_clara_a2_SS,res)
plot_NET_clara_a2_DS = gsn_csm_contour_map_polar(wks,NET_clara_a2_DS,res)

res@tiYAxisString   = "CLARA-A3"
res@gsnLeftString = "(g)"
plot_NET_clara_a3_SS = gsn_csm_contour_map_polar(wks,NET_clara_a3_SS,res)
plot_NET_clara_a3_DS = gsn_csm_contour_map_polar(wks,NET_clara_a3_DS,res)

res@tiYAxisString   = "GLASS"
res@tiMainOn        = False
res@gsnLeftString = "(j)"
plot_NET_GLASS_SS = gsn_csm_contour_map_polar(wks,NET_GLASS_SS,res)
plot_NET_GLASS_DS = gsn_csm_contour_map_polar(wks,NET_GLASS_DS,res)

;************SNC sesonal*************
res@tiYAxisOn       = False
res@tiMainOn        = True
res@tiMainString      = "SAF~B~SNC~N~"

res@gsnLeftString = "(b)"
plot_SNC_APPx_SS = gsn_csm_contour_map_polar(wks,SNC_APPx_SS,res)
plot_SNC_APPx_DS = gsn_csm_contour_map_polar(wks,SNC_APPx_DS,res)

res@tiMainOn        = False
res@gsnLeftString = "(e)"
plot_SNC_clara_a2_SS = gsn_csm_contour_map_polar(wks,SNC_clara_a2_SS,res)
plot_SNC_clara_a2_DS = gsn_csm_contour_map_polar(wks,SNC_clara_a2_DS,res)

res@gsnLeftString = "(h)"
plot_SNC_clara_a3_SS = gsn_csm_contour_map_polar(wks,SNC_clara_a3_SS,res)
plot_SNC_clara_a3_DS = gsn_csm_contour_map_polar(wks,SNC_clara_a3_DS,res)

res@gsnLeftString = "(k)"
plot_SNC_GLASS_SS    = gsn_csm_contour_map_polar(wks,SNC_GLASS_SS,res)
plot_SNC_GLASS_DS    = gsn_csm_contour_map_polar(wks,SNC_GLASS_DS,res)

;************TEM sesonal*************
res@tiMainOn        = True
res@tiMainString      = "SAF~B~TEM~N~"

res@gsnLeftString = "(c)"
plot_TEM_APPx_SS = gsn_csm_contour_map_polar(wks,TEM_APPx_SS,res)
plot_TEM_APPx_DS = gsn_csm_contour_map_polar(wks,TEM_APPx_DS,res)

res@tiMainOn         = False
res@gsnLeftString = "(f)"
plot_TEM_clara_a2_SS = gsn_csm_contour_map_polar(wks,TEM_clara_a2_SS,res)
plot_TEM_clara_a2_DS = gsn_csm_contour_map_polar(wks,TEM_clara_a2_DS,res)

res@gsnLeftString = "(i)"
plot_TEM_clara_a3_SS = gsn_csm_contour_map_polar(wks,TEM_clara_a3_SS,res)
plot_TEM_clara_a3_DS = gsn_csm_contour_map_polar(wks,TEM_clara_a3_DS,res)

res@gsnLeftString = "(l)"
plot_TEM_GLASS_SS    = gsn_csm_contour_map_polar(wks,TEM_GLASS_SS,res)
plot_TEM_GLASS_DS    = gsn_csm_contour_map_polar(wks,TEM_GLASS_DS,res)


;-------------------------------------
;-------------------------------------
pres           = True
pres@gsnDraw   = True
pres@gsnFrame  = True
pres@gsnMaximize   = True
; pres@gsnPanelXWhiteSpacePercent = 2
; pres@gsnPanelYWhiteSpacePercent = 2

pres@gsnPanelLabelBar = True
pres@lbLabelFontHeightF   = 0.014
pres@gsnPanelBottom = 0.001
pres@lbLabelStride = 2

; XF = fspan(0.15,0.8,6)+0.015
; pres@gsnPanelXF = (/XF(0),XF(1),XF(2),XF(3),XF(4),XF(5),\
;                     XF(0),XF(1),XF(2),XF(3),XF(4),XF(5),\
;                     XF(0),XF(1),XF(2),XF(3),XF(4),XF(5),\
;                     XF(0),XF(1),XF(2),XF(3),XF(4),XF(5)/)
;
YF = fspan(0.9,0.26,4)
pres@gsnPanelYF = (/YF(0),YF(0),YF(0),\
                    YF(1),YF(1),YF(1),\
                    YF(2),YF(2),YF(2),\
                    YF(3),YF(3),YF(3)/)

; gsn_panel(wks,(/plot_NET_APPx_SS,     plot_SNC_APPx_SS,     plot_TEM_APPx_SS,     \
;                 plot_NET_clara_a2_SS, plot_SNC_clara_a2_SS, plot_TEM_clara_a2_SS, \
;                 plot_NET_clara_a3_SS, plot_SNC_clara_a3_SS, plot_TEM_clara_a3_SS, \
;                 plot_NET_GLASS_SS,    plot_SNC_GLASS_SS,    plot_TEM_GLASS_SS   /),(/4,3/),pres)
;
gsn_panel(wks,(/plot_NET_APPx_DS,     plot_SNC_APPx_DS,     plot_TEM_APPx_DS,     \
                plot_NET_clara_a2_DS, plot_SNC_clara_a2_DS, plot_TEM_clara_a2_DS, \
                plot_NET_clara_a3_DS, plot_SNC_clara_a3_DS, plot_TEM_clara_a3_DS/),(/3,3/),pres)

end
