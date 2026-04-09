#!/bin/csh
set echo
##################################
#
# snow albedo on the seasonal timescale
# This script is based on that of Fletcher et al. (2014) and has been improved
#
##################################


######################################################################################
 ################  ((((( START of user modification section ))))) ##################
######################################################################################
# Setup input/output directories:
# Change these variables to match your data/preference
# The INPUT_DATA directory should contain monthly mean
# albedo, snow cover fraction or swe, tas, and a land-sea mask
# for as many years as specified below.
# Models - change to model of choice, or create model_list

foreach model (ACCESS-ESM1-5 BCC-ESM1 CanESM5 \
  CESM2 CESM2-FV2 CESM2-WACCM CESM2-WACCM-FV2 \
  CNRM-CM6-1 CNRM-CM6-1-HR CNRM-ESM2-1 E3SM-2-0 \
  E3SM-2-1 EC-Earth3 EC-Earth3-AerChem EC-Earth3-Veg \
  EC-Earth3-Veg-LR FGOALS-f3-L GISS-E2-1-G GISS-E2-2-G \
  GISS-E3-G HadGEM3-GC31-LL IPSL-CM6A-LR IPSL-CM6A-MR1 \
  MIROC6 MIROC-ES2L MPI-ESM-1-2-HAM MPI-ESM1-2-HR \
  MPI-ESM1-2-LR MRI-ESM2-0 NorCPM1 UKESM1-0-LL)

 echo ${model}
 set convert_snw = 0  # change this option to 1 to convert SWE to snc on the fly.
 #set model = "ACCESS1-0" || exit 1
 set INPUT_DATA = /home/hujl/cmip6/${model}/r1/rename || exit 1
 set expt = amip || exit 1
# Set years of study - should be changed to match years available in your data files
 set start_year = 1982 || exit 1
 set end_year = 2014 || exit 1
 #set time_period_str = "${start_year}-${end_year}" || exit 1
# Are we using an ensemble mean (default -- needs to be created by the user) or a single realization?
 #set realization = "em"  ## em = ensemble mean; can be changed to "r1i1p1" "r2i1p1" etc. _${gg}
 set albedo_file = $INPUT_DATA/albedo_Amon_${model}_${expt}_grid1.0.nc || exit 1
 set tas_file = $INPUT_DATA/tas_Amon_${model}_${expt}_grid1.0.nc || exit 1
# This is the snc file (to be created if convert_snw > 0)
 set snc_file = $INPUT_DATA/snc_LImon_${model}_${expt}_grid1.0.nc  || exit 1
 set prsn_file = $INPUT_DATA/prsn_Amon_${model}_${expt}_grid1.0.nc || exit 1

 #set snc_nomask = $INPUT_DATA/snc_LImon_${model}_${expt}_${realization}_185001-201412.nc  || exit 1
 # set snw_file = $INPUT_DATA/snw_LImon_${model}_${expt}.nc || exit 1
# This is the land mask file
 # set lmask_file = /home/hujl/data_script/mask_greenland_PCN/PCN_byhands/PCN_Domain_1.0x1.0.nc || exit 1
 set lmask_file = /home/hujl/data_script/mask_greenland_MODIS/MCD12C1/mask_greenland_MCD12C1_1.0x1.0.nc || exit 1

 # ROOT_DIR is the path to the aux_data, and also where the working dir and results will be stored by default.
 set ROOT_DIR = /home/hujl/SAF_time/NH45_dTNH45  || exit 1
 set outdir_root =/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/reviewer3_amip/data_snow_albedo/seasonal/result_cmip6 || exit 1
 # Set work directory
 set work =/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/reviewer3_amip/data_snow_albedo/seasonal/work_cmip6 || exit 1
 # Set locations of auxillary files
 set obs_mask = /home/hujl/SAF_time/NH45_dTNH45/aux_data/EASE/EASE_mask_grid1.0.nc
 set insol_file = $ROOT_DIR/aux_data/dswrf.ntat.climon.mon.mean.1982-2014.nc || exit 1

 #同一个模式内所用的不同netcdf文件中的经纬度坐标有差异��? #对同一个模式，可以��?sftlf_fx 文件中的 lon, lat 坐标值替换其他文件中��?lon, lat 坐标值��?
 # ncl $ROOT_DIR/script_v3/lon_${model}.ncl

# The seasonal transitions are computed as the difference between mon1 and mon2
# Here we can define the first and last transition to be analysed:
# startmon is the first mon1 (e.g., 3 (March), 4 (April) or 5 (May) )
setenv startmon 3
# endmon is the last mon1 (e.g., 3 (March), 4 (April) or 5 (May) )
setenv endmon 5
# Define analysis region (degrees; default: 30N-90N, 0-360E)
set latmin = 45.
set latmax = 90.
set lonmin = 0.
set lonmax = 360.
# Snow Threshold - the minimum amount of snow cover required to include a grid cell in the analysis
set snow_thresh = 0.25

######################################################################################
  ################  ((((( END of user modification section ))))) ##################
######################################################################################
#
#
#   WARNING: modifications not recommended below here.
#
#
#
# set up paths and time vars
if (! -d $outdir_root ) mkdir -p $outdir_root || exit 1
mkdir -p $work || exit 1
cd $work || exit 1
set dates = "${start_year}-01-01,${end_year}-12-31" || exit 1
set datesMar = "${start_year}-01-01,${end_year}-12-31"
set regstr = "${lonmin},${lonmax},${latmin},${latmax}" || exit 1
# We can opt to set missing values to 0 in the calculation of K terms, but defauly is not to.
 set misstocstr = "-setmisstoc,0.0" || exit 1
 set flagstr = "misstoc"  || exit 1   #"nomisstoc"

# Loop over models from model_list
 set model_list = ( $model ) || exit 1
# outdir pattern is the identifier for all SAF terms computed using this script version
 set outdir_pattern = ${snow_thresh}_${flagstr} || exit 1
# Set the snow cover threshold - we will calculate SAF all cells with more than 0.25 snc (previously used 0.1)
 set snow_present_thresh = $snow_thresh || exit 1

 echo ">>>>>>   PROCESSING: $model"

 # Locate land mask for this model
 if (! -f $lmask_file ) exit 1
 # cdo selindexbox,1,360,121,180 $lmask_file lmask.nc || exit 1
 cdo sellonlatbox,${regstr} $lmask_file lmask.nc || exit 1
 set lmask_file = lmask.nc || exit 1

 # Locate snow_noveg domain mask for this model
 cdo sellonlatbox,${regstr} $obs_mask obs_mask.nc || exit 1
 set obs_mask = obs_mask.nc || exit 1

 # +++++++++++++++++++++++++++++++++++++++++++++
 # +++++++++++++++++++++++++++++++++++++++++++++
 # 	Multi-stage SAF calculation begins here
 # +++++++++++++++++++++++++++++++++++++++++++++
 # 1.  Read in input files for albedo tas and snc
 # Get native-resolution grids of alpha_s, Ts and snc for all 12 months (climatological mean, NH30 domain + landmask).
 # +++++++++++++++++++++++++++++++++++++++++++++
 foreach var (albedo tas snc)
  #
  if ($var == albedo) set infile = $albedo_file
  if ($var == tas) set infile = $tas_file
  if ($var == snc) then
   set infile = $snc_file
   # Convert SNW to snc on the fly if needed:
   # Begin conversion if requested
   if ($convert_snw == 1) then
    echo ">>> Converting snw to snc" || exit 1
    set gridstr = "" || exit 1
    # Added check for using selgrid
    set flag = `cdo info $snw_file | grep "1 : generic"` || exit 1
    if ($#flag != 0 ) set gridstr = "-selgrid,2" || exit 1
    cdo -b f64 lec,0 $gridstr $snw_file msk0.nc || exit 1
    cdo -b f64 gtc,60 $gridstr $snw_file msk1.nc || exit 1
    cdo -b f64 divc,60 $gridstr $snw_file tmp1.nc || exit 1
    # Create snc from snow mass and merge into same file
    # Procedure using CDO: make 3 mask fields: msk1.nc = snw > 60, msk2.nc = 0 < snw < 60 and msk3.nc = snw = 0
    # Then for msk1.nc apply snc = 1.0, and for msk0.nc apply snc = 0.0
    cdo -b f64 setmisstoc,1.0 -ifnotthen msk1.nc tmp1.nc tmp2.nc || exit 1
    cdo -b f64 setname,snc -setmisstoc,0.0 -ifnotthen msk0.nc tmp2.nc $infile || exit 1
   endif
   if (! -f $infile) then
    echo "FATAL: snc file does not exist"
    echo "Either data not available, or convert from SWE by selecting convert_snw = 1."
    exit 1
   endif
  endif # are we snc?
  # Processing the data into monthly climatologies for NH30 domain
  if ($var == albedo) then
    cdo ymonmean -selname,$var -setvrange,0.0,1.0 -setmissval,-999.0 -seldate,$dates -sellonlatbox,${regstr} $infile tmp.albedo.nc || exit 1
  else if ($var == snc) then
    set gridstr = ""
  # Added check for using selgrid
  set flag = `cdo info $infile | grep "1 : generic"`
  if ($#flag != 0 ) set gridstr = "-selgrid,2"
    cdo ymonmean -selname,$var -setvrange,0.0,100.1 -setmissval,-999.0 -seldate,$dates -sellonlatbox,${regstr} $gridstr $infile tmp.snc.nc || exit 1
  else if ($var == tas) then
    cdo ymonmean -setmissval,-999.0 -seldate,$dates -sellonlatbox,${regstr} -selname,tas $infile tmp.tas.nc || exit 1
  endif
  # if albedo then multiply by 100% to get a percentage value
  if ($var == albedo) then
   cdo mulc,100 tmp.albedo.nc tmp.nc && \mv tmp.nc tmp.albedo.nc || exit 1
  endif
  # if snc then div by 100% to get a 0-1 value
  if ($var == snc) then
   cdo divc,100 tmp.snc.nc tmp.nc && \mv tmp.nc tmp.snc.nc || exit 1
  endif
 end  # get var loop

 # ++++++++++++++++++++++++++++++++++++++++
 # 2. Compute max_albedo and alpha_land -- these are time-invariant quantities
 # max_albedo is the maximum albedo over all months (monmean instead of ymonmean)
 set allmons_albedo_file = $albedo_file
 cdo mulc,100  -timmax -selmon,2,3,4,5,6 -seldate,$dates -sellonlatbox,${regstr} -setmissval,-999.0 $allmons_albedo_file tmp.max_albedo.nc || exit 1

 cdo mulc,100 -selname,albedo -setvrange,0.0,1.0 -selmon,3,4,5,6 -seldate,$dates -sellonlatbox,${regstr} -setmissval,-999.0 $albedo_file tmp.albedo.all.nc || exit 1
 cdo divc,100 -selname,snc -setvrange,0.0,100.1 -selmon,3,4,5,6 -seldate,$dates -sellonlatbox,${regstr} -setmissval,-999.0 $snc_file tmp.snc.all.nc || exit 1
 cdo selname,tas -selmon,3,4,5,6 -seldate,$dates -sellonlatbox,${regstr} -setmissval,-999.0 $tas_file tmp.tas.all.nc || exit 1
 cdo selname,prsn -selmon,3,4,5,6 -seldate,$dates -sellonlatbox,${regstr} -setmissval,-999.0 $prsn_file tmp.prsn.all.nc || exit 1

 cdo ymonmean -setmissval,-999.0 -seldate,$dates -sellonlatbox,${regstr} -selname,prsn $prsn_file tmp.prsn.nc || exit 1

 # # ++++++++++++++++++++++++++++++++++++++++
 # # Compute alpha_snow and alpha_land using Qu and Hall (2013) method:
 # # i. Define threshold snc >= 0.9 (90%) / < 0.1 (10%) for "snow-covered" / "snow-free"
 # # ii. Create mask from monthly climo (12-month) snc files using threshold
 # cdo gec,0.9 tmp.snc.nc mask.snc90.nc || exit 1
 # cdo ltc,0.1 tmp.snc.nc mask.snc10.nc || exit 1
 # # iii. Average albedo from monthly climo (same 12-months) for non-missing cells in the mask
 # cdo setname,qh_asnow -timmean -ifthen mask.snc90.nc tmp.albedo.nc tmp.qh_asnow.nc || exit 1
 # cdo setname,qh_aland -timmean -ifthen mask.snc10.nc tmp.albedo.nc tmp.qh_aland.nc || exit 1
 # # iv. Save these new quantities: qh_aland_snc10 and qh_asnow_snc90
 # # done later, after interpolating and applying obs mask.

 # ++++++++++++++++++++++++++++++++++++++++
 # alpha_land is the surface albedo for the first two month after snow melts
 @ mon = 1
 @ ind = 10
 while ($mon <= 11)  # final mon + 1 = 12
  @ mon2 = $mon + 1
  @ mon3 = $mon + 2
  cdo selmon,$mon tmp.snc.nc this_snc_before.nc || exit 1
  cdo selmon,$mon2 tmp.snc.nc this_snc_after.nc || exit 1
  cdo selmon,$mon2,$mon3 tmp.albedo.nc this_albedo.nc || exit 1
  #
  cdo gtc,0.1 this_snc_before.nc mask.nc || exit 1
  cdo ifthen mask.nc this_snc_after.nc tmp2.nc || exit 1
  cdo ltc,0.1 tmp2.nc mask2.nc || exit 1
 # Now mask albedo grids with mask2.nc
  cdo ifthen mask2.nc this_albedo.nc this_albedo_msk.nc || exit 1
 # Now average to get this month's values of alpha_land
  cdo setname,alpha_land -timmean this_albedo_msk.nc tmp.$ind.nc || exit 1
  @ mon ++
  @ ind ++
 end
 # Finally, take sum of the first two non-missing months = alpha_land
 cdo -O enssum tmp.??.nc tmp.alpha_land.nc || exit 1

 cdo enlarge,tmp.alpha_land.nc tmp.albedo.all.nc tmp.alpha_land.all.nc
 # ++++++++++++++++++++++++++++++++++++++++
 # 3. For March, April, May and June only: compute alpha_snow
 # ++++++++++++++++++++++++++++++++++++++++
 @ mon = 3
 while ($mon <= 6)
  # Merge alpha_land, alpha_s and snow cover for this month
  #alpha_land小于albedo
  cdo selmon,$mon tmp.albedo.all.nc tmp.alb.nc || exit 1
  cdo setname,alpha_land -setmon,$mon -min tmp.alb.nc tmp.alpha_land.all.nc tmp.alpha_land.0$mon.nc || exit 1
  cdo ifthen tmp.alpha_land.all.nc tmp.alpha_land.0$mon.nc tmp.alpha_land.mk.nc || exit 1
  \mv tmp.alpha_land.mk.nc tmp.alpha_land.0$mon.nc || exit 1

  cdo selmon,$mon tmp.albedo.all.nc tmp2.nc || exit 1
  cdo selmon,$mon tmp.snc.all.nc tmp3.nc || exit 1
  \rm -rf tmp.allvars.nc || exit 1
  cdo -O merge tmp2.nc tmp.alpha_land.0$mon.nc tmp3.nc tmp.allvars.nc || exit 1
  cdo setmon,$mon tmp.allvars.nc tmp.nc && \mv tmp.nc tmp.allvars.nc || exit 1

  # Expression for alpha_snow (albedo in %, snc as fraction):
  cdo -b 64 setvrange,0,100 -setmissval,-999 -expr,"alpha_snow=(albedo-((1-snc)*alpha_land))/snc" tmp.allvars.nc tmp.alsnw.0$mon.nc || exit 1

  # Here we add the "checks" imposed by F09 for small snc
  # (I will impose for all cells, not just those where snc < 10%):
  if ($mon <= 3) then
   # alpha_snow(March) = min(alpha_snow(march), max_snow_albedo)
   cdo min tmp.alsnw.0$mon.nc tmp.max_albedo.nc tmp.nc || exit 1
   \mv tmp.nc tmp.alsnw.0$mon.nc || exit 1
  else
   # Cases other than march: we compare this month with previous and take the minimum
   # alpha_snow(April) = min(alpha_snow(april), alpha_snow(march))
   # alpha_snow(May) = min(alpha_snow(may), alpha_snow(april))
   @ mm1 = $mon - 1
   cdo min tmp.alsnw.0$mon.nc tmp.alsnw.0$mm1.nc tmp.nc || exit 1
   \mv tmp.nc tmp.alsnw.0$mon.nc || exit 1
  endif
  # Final check: alpha_snow = max(alpha_snow, alpha_land), i.e. snow albedo cannot be < land albedo!
  cdo max tmp.alsnw.0$mon.nc tmp.alpha_land.0$mon.nc tmp.nc || exit 1
  \mv tmp.nc tmp.alsnw.0$mon.nc || exit 1
  @ mon ++
 end
 if (-f tmp.alpha_snow.nc ) \rm -rf tmp.alpha_snow.nc || exit 1
 cdo mergetime tmp.alsnw.??.nc tmp.alpha_snow.nc || exit 1

 if (-f tmp.alpha_land.min.nc ) \rm -rf tmp.alpha_land.min.nc || exit 1
 cdo mergetime tmp.alpha_land.0?.nc tmp.alpha_land.min.nc || exit 1

 # ++++++++++++++++++++++++++++++++++++++++
 # 4. Loop over monthly transitions and compute k4(NET), k1k2(SNC) and k3(TEM)
 # ++++++++++++++++++++++++++++++++++++++++
 @ mon1 = $startmon
 set monstr = "MA"
 while ($mon1 <= $endmon)
  if ($mon1 == 4) set monstr = "AM"
  if ($mon1 == 5) set monstr = "MJ"
  if ($mon1 > 5) exit 1
  @ mon2 = $mon1 + 1

# output location for k-coefficients remapbild to the obs grid
 set outdir = $outdir_root/${monstr}_${outdir_pattern}
  if (! -d $outdir ) mkdir -p $outdir

  cdo sub -selmon,$mon2 tmp.tas.all.nc -selmon,$mon1 tmp.tas.all.nc tmp.delta_tas.nc || exit 1
  cdo sub -selmon,$mon2 tmp.snc.all.nc -selmon,$mon1 tmp.snc.all.nc tmp.delta_snc.nc || exit 1
  cdo sub -selmon,$mon2 tmp.albedo.all.nc -selmon,$mon1 tmp.albedo.all.nc tmp.delta_albedo.nc || exit 1
  cdo sub -selmon,$mon2 tmp.alpha_snow.nc -selmon,$mon1 tmp.alpha_snow.nc tmp.delta_alpha_snow.nc || exit 1
  cdo sub -selmon,$mon2 tmp.prsn.all.nc -selmon,$mon1 tmp.prsn.all.nc tmp.delta_prsn.nc || exit 1

# #
#  # ++++++++++++++++++++++++++++++++++++++++
#  # 4a. Insolation weight all albedo fields using observed TOA insolation weighting
#  # ++++++++++++++++++++++++++++++++++++++++
#  cdo -b 64 -setmissval,-999.0 -remapbil,tmp.albedo.nc -setname,albedo -timmean -selmon,$mon1,$mon2 -sellonlatbox,${regstr} $insol_file tmp1.nc || exit 1
#  # land mask insolation (weighting only relative to land)
#  echo $model
#  cdo ifthen $lmask_file tmp1.nc tmp.nc && \mv tmp.nc tmp1.nc || exit 1
#  cdo fldmean tmp1.nc tmp2.nc
#  cdo div tmp1.nc -enlarge,tmp1.nc tmp2.nc tmp.obs.insol_toa.$monstr.nc || exit 1
#  # multiply tmp.albedo, tmp.alpha_land and tmp.alpha_snow by insol weight field
#  cdo mul tmp.albedo.nc tmp.obs.insol_toa.$monstr.nc tmp.albedo.wgt.nc || exit 1
#  cdo mul tmp.alpha_snow.nc tmp.obs.insol_toa.$monstr.nc tmp.alpha_snow.wgt.nc || exit 1
#  cdo mul tmp.alpha_land.min.nc tmp.obs.insol_toa.$monstr.nc tmp.alpha_land.min.wgt.nc || exit 1
#  # new: weight QH_asnow and QH_aland by insolation
#  cdo mul tmp.qh_asnow.nc tmp.obs.insol_toa.$monstr.nc tmp.qh_asnow.wgt.nc || exit 1
#  cdo mul tmp.qh_aland.nc tmp.obs.insol_toa.$monstr.nc tmp.qh_aland.wgt.nc || exit 1

#  # ++++++++++++++++++++++++++++++++++++++++
#  # 4b. Here we calculate the K terms
#  # ++++++++++++++++++++++++++++++++++++++++
#  # Calculate k4 (NET SAF)
 # cdo sub -selmon,$mon2 tmp.tas.nc -selmon,$mon1 tmp.tas.nc tmp.delta_tas.nc || exit 1
#  cdo ifthen $lmask_file tmp.delta_tas.nc tmp1.nc || exit 1
#  cdo enlarge,tmp1.nc -fldmean -sellonlatbox,${regstr} tmp1.nc tmp.delta_ts_nh.nc || exit 1
#  # next compute Delta alpha_s and divide by tmp.delta_ts_nh, then mask, then area-avg
#  cdo sub -selmon,$mon2 tmp.albedo.wgt.nc -selmon,$mon1 tmp.albedo.wgt.nc tmp.delta_albedo.nc || exit 1
#  cdo -setname,k4 -div tmp.delta_albedo.nc tmp.delta_ts_nh.nc k4.$model.nc || exit 1
#
#  # k1k2 (SNC COMPONENT)
#  # k1 is Delta snc / <Delta_Ts>_NH
#  cdo sub -selmon,$mon2 tmp.snc.nc -selmon,$mon1 tmp.snc.nc tmp.delta_snc.nc || exit 1
#  cdo setname,k1 -mulc,100 -div tmp.delta_snc.nc tmp.delta_ts_nh.nc k1.$model.nc || exit 1
#  # k2 is mean albedo_snow - albedo_land
#  cdo divc,2 -add -selmon,$mon2 tmp.alpha_snow.wgt.nc -selmon,$mon1 tmp.alpha_snow.wgt.nc tmp.mean_alpha_snow.wgt.nc || exit 1
#  cdo divc,2 -add -selmon,$mon2 tmp.alpha_land.min.wgt.nc -selmon,$mon1 tmp.alpha_land.min.wgt.nc tmp.alpha_land.wgt.nc || exit 1
#
#  cdo setvrange,0,100.0 -setname,k2 -sub tmp.mean_alpha_snow.wgt.nc tmp.alpha_land.wgt.nc k2.$model.nc || exit 1
#  cdo -setname,k1k2 -divc,100 -mul k2.$model.nc k1.$model.nc k1k2.$model.nc || exit 1
#
#  # k3 (TEM component):
#  # First, k3 as a residual (k4 - k1k2) [method of Fernandes et al. 2009, GRL]
#  cdo -setname,k3_res -sub k4.$model.nc k1k2.$model.nc k3_res.$model.nc || exit 1
#
#  # We use alpha_snow to compute k3 explicitly for this month pair
#  # compute mean snow, Delta alpha_snow, multiply them and divide by dTs NH
#  cdo divc,2 -add -selmon,$mon2 tmp.snc.nc -selmon,$mon1 tmp.snc.nc tmp.mean_snow.nc || exit 1
#  cdo sub -setname,delta_alpha_snow -selmon,$mon2 tmp.alpha_snow.wgt.nc -selmon,$mon1 tmp.alpha_snow.wgt.nc tmp.delta_alpha_snow.nc || exit 1
#  cdo mul tmp.mean_snow.nc tmp.delta_alpha_snow.nc tmp2.nc || exit 1
#  # Divide by NH avg Delta Ts to create TEM:
#  cdo setname,k3 -div tmp2.nc tmp.delta_ts_nh.nc k3.$model.nc || exit 1
#
#  # k5 is Delta alpha_snow / <Delta_Ts>_NH
#  cdo -setname,k5 -div tmp.delta_alpha_snow.nc tmp.delta_ts_nh.nc k5.$model.nc || exit 1
#
 # ++++++++++++++++++++++++++++++++++++++++
 # 4c. Regrid all k fields to obs grid, apply obs land mask, then compute area-averages.
 # We need to save monthly mean snow albedo, Ts, S and alpha_s.
 # -- first save important diagnostics, like the different albedos
 set save_vars = (delta_alpha_snow delta_albedo delta_snc delta_tas delta_prsn snc.all prsn.all tas.all snc prsn tas alpha_snow) || exit 1
 foreach var ($save_vars)
  # Need to do a copy here, so that the constant vars (alpha_land) are preserved
  \cp tmp.$var.nc $var.$model.nc || exit 1
 end
 foreach k (delta_alpha_snow delta_albedo delta_snc delta_tas delta_prsn snc.all prsn.all tas.all snc prsn tas alpha_snow) || exit 1
  # Add explicit condition limiting domain to S > 0 cells.
  # If misstocstr is set, then cells where S < threshold are set to zero.
  # This means they will not be missing, and contribute zero to average SAF.
  # We need to reapply the land-sea mask so that ocean = missing,and not = 0 (this messes up interpolation).
  # -- APPLY ONLY TO k-fields, for all others we set cells with S < thresh to MISSING.

  # Snc >= 0.25 in the first month of each transition.
  # cdo gec,$snow_thresh -selmon,$mon1 tmp.snc.nc tmp.snc_gt_${snow_thresh}_mask.nc || exit 1
  # if ($k == "k1k2" || $k == "k3" || $k == "k3_res" || $k == "k4" || ) then || exit 1
  #   cdo ifthen $lmask_file $misstocstr -ifthen tmp.snc_gt_${snow_thresh}_mask.nc $k.$model.nc tmp1.nc || exit 1
  #   \mv tmp1.nc $k.$model.nc || exit 1
  # else
    cdo ifthen $lmask_file $k.$model.nc tmp1.nc || exit 1
    \mv tmp1.nc $k.$model.nc || exit 1
  # endif

   # The following should now be the only land-sea mask applied to the fields.
   # This ensures we have the correct missing data area for obs and all model grids.
  cdo ifthen $obs_mask $k.$model.nc $outdir/$k.$model.EASE_grid.nc || exit 1
  cdo fldmean $outdir/$k.$model.EASE_grid.nc $outdir/$k.$model.EASE_grid.aa.nc || exit 1
 end

 @ mon1 ++
 end # loop over months

 # clean up work dir
 set files = `ls tmp*.nc *mask*.nc tas_20.*.nc this_*.nc`
 \rm -rf $files
end
