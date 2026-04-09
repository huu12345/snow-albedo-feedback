
#读取数据，并作多元线性拟合,计算相关系数

import numpy as np
import xarray as xr
import os
from glob import glob
import matplotlib.pyplot as plt
# import xesmf as xe
import pandas as pd
import pingouin as pg
import netCDF4 as nc
from sklearn.linear_model import LinearRegression
from sklearn.metrics import explained_variance_score
from sklearn.preprocessing import StandardScaler
import statsmodels.api as sm

import cartopy.crs as ccrs
import cartopy.feature as cfeature
import warnings

outpath = '/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/reviewer3_amip/'

# **************读取数据**************
M = np.array(["AM_0.25_misstoc/", "MA_0.25_misstoc/", "MJ_0.25_misstoc/"])

inpath_model_SS = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/reviewer3_amip/data_snow_albedo/seasonal/result_obs_all/"

nm_tas = np.array(["CRU","GHCN"])
nm_snc = np.array(["JASMES","NSIDC","Rutgers"])
nm_alb = np.array(["APPx","clara_a2","clara_a3"])

# 空间维度
n_lat = 45
n_lon = 360

# 初始化数组
delta_tas = np.full((2,3,3, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
delta_alpsnow = np.full((2,3,3, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
delta_prsn = np.full((2,3,3, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
snc = np.full((2,3,3, 132, n_lat, n_lon), np.nan, dtype=np.float64)

print("\n开始读取数据...")
for m in range(2):  #tas
  for n in range(3): #snc
    for k in range(3): #alb
      for j in range(3): #alb
        # print(h)
        # 构建文件路径
        file1 = os.path.join(inpath_model_SS, M[j], f"delta_tas.obs_{nm_tas[m]}_{nm_snc[n]}_{nm_alb[k]}.EASE_grid.nc")
        file2 = os.path.join(inpath_model_SS, M[j], f"delta_alpha_snow.obs_{nm_tas[m]}_{nm_snc[n]}_{nm_alb[k]}.EASE_grid.nc")
        file3 = os.path.join(inpath_model_SS, M[j], f"delta_prsn.obs_{nm_tas[m]}_{nm_snc[n]}_{nm_alb[k]}.EASE_grid.nc")
        file4 = os.path.join(inpath_model_SS, M[j], f"snc.all.obs_{nm_tas[m]}_{nm_snc[n]}_{nm_alb[k]}.EASE_grid.nc")

        try:
            if os.path.exists(file1):
                ds1 = xr.open_dataset(file1, decode_times=False)
                a1 = ds1['tas'].values
                delta_tas[m,n,k, j,:, :, :] = a1.astype(np.float64)
                ds1.close()

            if os.path.exists(file2):
                ds2 = xr.open_dataset(file2, decode_times=False)
                a2 = ds2['alpha_snow'].values
                delta_alpsnow[m,n,k, j,:, :, :] = a2.astype(np.float64)
                ds2.close()

            if os.path.exists(file3):
                ds3 = xr.open_dataset(file3, decode_times=False)
                a3 = ds3['prsn'].values
                delta_prsn[m,n,k, j,:, :, :] = a3.astype(np.float64)
                ds3.close()

            if os.path.exists(file4):
                ds4 = xr.open_dataset(file4, decode_times=False)
                a4 = ds4['snc'].values
                snc[m,n,k,:, :, :] = a4.astype(np.float64)

                ds4.close()
        except Exception as e:
            print(f"读取观测 {nm_tas[m]}_{nm_snc[n]}_{nm_alb[k]} 季节 {j} 时出错: {e}")


# 数据转换
snc = snc*100.0  # snc转换为百分比
# delta_prsn = delta_prsn * 24 * 60 * 60 # delta_prsn从mm/s转换为mm/day

# 打印数据范围
print("\n数据范围:")
print(f"snc: min={np.nanmin(snc):.2f}, max={np.nanmax(snc):.2f}")
# print(f"delta_tas_avg: min={np.nanmin(delta_tas_avg):.2f}, max={np.nanmax(delta_tas_avg):.2f}")
# print(f"delta_alpsnow: min={np.nanmin(delta_alpsnow):.2f}, max={np.nanmax(delta_alpsnow_avg):.2f}")
# print(f"delta_prsn: min={np.nanmin(delta_prsn):.2f}, max={np.nanmax(delta_prsn_avg):.2f}")
# print(f"delta_tas: min={np.nanmin(delta_tas):.2f}, max={np.nanmax(delta_tas_avg):.2f}")

#**************选择积雪覆盖区域**************
delta_tas_mk1 = np.full((2,3,3,3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
delta_alpsnow_mk1 = np.full((2,3,3,3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
delta_prsn_mk1 = np.full((2,3,3,3, 33, n_lat, n_lon), np.nan, dtype=np.float64)

value = 25.0  # 积雪覆盖阈值

for mon in range(3):  # 0,1,2 对应3个季节
    # 创建掩码：当前月和下一月积雪覆盖都大于阈值
    mask = (snc[:,:,:,mon::4, :, :] > value) & (snc[:,:,:,(mon+1)::4, :, :] > value)

    # 应用掩码
    delta_tas_mk1[:,:,:,mon, :, :, :] = np.where(mask, delta_tas[:,:,:,mon, :, :, :], np.nan)
    delta_alpsnow_mk1[:,:,:,mon, :, :, :] = np.where(mask, delta_alpsnow[:,:,:,mon, :, :, :], np.nan)
    delta_prsn_mk1[:,:,:,mon, :, :, :] = np.where(mask, delta_prsn[:,:,:,mon, :, :, :], np.nan)

# print(f"delta_tas_mk: min={np.nanmin(delta_tas_mk):.2f}, max={np.nanmax(delta_tas_mk):.2f}")

# 观测均值
def safe_nanmean(arr, axis=None):
    """安全的nanmean，处理全NaN切片"""
    with warnings.catch_warnings():
        warnings.filterwarnings('ignore', category=RuntimeWarning,
                                message='Mean of empty slice')
        return np.nanmean(arr, axis=axis)

delta_tas_mk = safe_nanmean(delta_tas_mk1, axis=(0, 1))  #3, 3, 33, n_lat, n_lon
delta_alpsnow_mk = safe_nanmean(delta_alpsnow_mk1, axis=(0, 1))
delta_prsn_mk = safe_nanmean(delta_prsn_mk1, axis=(0, 1))
# snc_avg = safe_nanmean(snc, axis=0)  #132, n_lat, n_lon
print(f"delta_tas_mk  shape: {delta_tas_mk .shape}")

#**************计算多元线性相关**********
coeff_tas = np.empty([3,n_lat, n_lon], dtype = np.float64)
coeff_prsn= np.empty([3,n_lat, n_lon], dtype = np.float64)
coeff_c   = np.empty([3,n_lat, n_lon], dtype = np.float64)

r2 = np.empty([3,n_lat, n_lon], dtype = np.float64)

pvalue_tas = np.empty([3,n_lat, n_lon], dtype = np.float64)   # x的p值
pvalue_prsn = np.empty([3,n_lat, n_lon], dtype = np.float64) # y的p值
pvalue_c = np.empty([3,n_lat, n_lon], dtype = np.float64)    # 截距的p值

for i in range(0,3):
   print(i)
   for lat in range(0,n_lat):
     for lon in range(0,n_lon):

          x = delta_tas_mk[i,:,:,lat,lon].flatten()  #z=ax+by+c
          y = delta_prsn_mk[i,:,:,lat,lon].flatten()  # 转化为一维
          z = delta_alpsnow_mk[i,:,:,lat,lon].flatten()

          # 使用有效数据
          valid_mask = ~(np.isnan(x) | np.isnan(y) | np.isnan(z))
          n_valid = np.sum(valid_mask)
         # print(n_valid)

          if n_valid >= 20:  # 一共33*3=99个样本，至少需要50个样本

             x_valid = x[valid_mask]
             y_valid = y[valid_mask]
             z_valid = z[valid_mask]
             # print(x_valid)
             # print(y_valid)
             # print(z_valid)

             # 检查因变量z的方差
             if np.std(z_valid) == 0:
                 coeff_tas[i, lat, lon] = np.nan
                 coeff_prsn[i, lat, lon] = np.nan
                 coeff_c[i, lat, lon] = z_valid[0]  # 常数
                 r2[i, lat, lon] = 0
                 pvalue_tas[i, lat, lon] = np.nan
                 pvalue_prsn[i, lat, lon] = np.nan
                 pvalue_c[i, lat, lon] = np.nan
                 continue

             # 检查自变量变量x方差（避免常数变量）
             if np.std(x_valid) == 0 or np.std(y_valid) == 0:
                 coeff_tas[i, lat, lon] = np.nan
                 coeff_prsn[i, lat, lon] = np.nan
                 coeff_c[i, lat, lon] = np.nan
                 r2[i, lat, lon] = np.nan
                 pvalue_tas[i, lat, lon] = np.nan
                 pvalue_prsn[i, lat, lon] = np.nan
                 pvalue_c[i, lat, lon] = np.nan
                 continue

             # 构建设计矩阵
             X = np.column_stack([x_valid, y_valid])

             # 添加常数项（截距）
             X_with_const = sm.add_constant(X)

             # 拟合
             model = sm.OLS(z_valid, X_with_const) #生成模型
             result = model.fit() #模型拟合
             # print(result.summary())

             # 提取系数
             coeff_c[i,lat,lon] = result.params[0]  # 截距 c
             coeff_tas[i,lat,lon] = result.params[1]  # x系数 a
             coeff_prsn[i,lat,lon]= result.params[2]  # y系数 b
             r2[i,lat,lon]= result.rsquared

             # 提取p值
             pvalue_c[i,lat,lon] = result.pvalues[0]    # 截距的p值
             pvalue_tas[i,lat,lon] = result.pvalues[1]  # x系数的p值
             pvalue_prsn[i,lat,lon] = result.pvalues[2] # y系数的p值

          else:
             coeff_c[i,lat,lon] = np.nan  # 截距 c
             coeff_tas[i,lat,lon] = np.nan  # x系数 a
             coeff_prsn[i,lat,lon]= np.nan  # y系数 b
             r2[i,lat,lon]= np.nan  # y系数 b

             pvalue_c[i,lat,lon] = np.nan
             pvalue_tas[i,lat,lon] = np.nan
             pvalue_prsn[i,lat,lon] = np.nan

# np.set_printoptions(precision=2, suppress=True)

# print(f"coeff_tas: {coeff_tas}")
# print(f"coeff_prsn: {coeff_prsn}")
# print(f"coeff_c: {coeff_c}")
# print(f"alpha_snow_pred: {z_pred}")
# print(f"alpha_snow_real: {z_mean}")
# print(f"R2: {r2}")

# 恢复默认设置
# np.set_printoptions(precision=8, suppress=False)

#****************save output**********************
# out1 = xr.DataArray(exp_var, coords=[np.arange(0,3,1)],dims=['model','mon'])
out1 = xr.DataArray(coeff_tas, coords=[np.arange(0,3,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','lat','lon'])
out2 = xr.DataArray(coeff_prsn, coords=[np.arange(0,3,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','lat','lon'])
out3 = xr.DataArray(coeff_c, coords=[np.arange(0,3,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','lat','lon'])
out4 = xr.DataArray(r2, coords=[np.arange(0,3,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','lat','lon'])
out5 = xr.DataArray(pvalue_c, coords=[np.arange(0,3,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','lat','lon'])
out6 = xr.DataArray(pvalue_tas, coords=[np.arange(0,3,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','lat','lon'])
out7 = xr.DataArray(pvalue_prsn, coords=[np.arange(0,3,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','lat','lon'])

out8 = xr.DataArray(delta_tas_mk, coords=[np.arange(0,3,1),np.arange(0,3,1),np.arange(0,33,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','mon','year','lat','lon'])
out9 = xr.DataArray(delta_alpsnow_mk, coords=[np.arange(0,3,1),np.arange(0,3,1),np.arange(0,33,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','mon','year','lat','lon'])
out10 = xr.DataArray(delta_prsn_mk, coords=[np.arange(0,3,1),np.arange(0,3,1),np.arange(0,33,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['alb','mon','year','lat','lon'])

out = xr.merge([out1.rename('coeff_tas'), out2.rename('coeff_prsn'), out3.rename('coeff_c'), \
                out4.rename('r2'), out5.rename('pvalue_c'), out6.rename('pvalue_tas'), out7.rename('pvalue_prsn'),\
                out8.rename('delta_tas_mk'), out9.rename('delta_alpsnow_mk'), out10.rename('delta_prsn_mk')])

out.to_netcdf(outpath+'data_fit_seasonal_obs.nc')
