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


name = "Table_S4_model.txt"

M=(/"AM_0.25_misstoc/","MA_0.25_misstoc/","MJ_0.25_misstoc/"/)

n_model6 = dimsizes(model6)

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
; print(NET_SS)
; print(SNC_SS)
; print(TEM_SS)

; qsort(NET_SS)
; qsort(SNC_SS)
; qsort(TEM_SS)

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
; print(TEM_DS)

res_SS = 100.0*(NET_SS - SNC_SS - TEM_SS)/NET_SS
res_DS = 100.0*(NET_DS - SNC_DS - TEM_DS)/NET_DS

;*****************写成表格***************************
header  = [/"       ","       ", "NET","       ","SNC","       ","TEM","     ","Res/NET"/]

; strings  = (/"OBS","Reanalysis","CMIP6","OBS","Reanalysis","CMIP6"/)

alist   = [/model6,NET_SS,NET_DS,SNC_SS,SNC_DS,TEM_SS,TEM_DS,res_SS,res_DS/]

write_table(outpath+name, "w", header, "%s %s %s %s %s %s %s %s %s")
write_table(outpath+name, "a", alist, "%s %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f")

end
