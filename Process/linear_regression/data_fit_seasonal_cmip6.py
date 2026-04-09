
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

# **************模型列表**************
model6 = np.array(["ACCESS-ESM1-5", "BCC-ESM1", "CanESM5",
    "CESM2", "CESM2-FV2", "CESM2-WACCM", "CESM2-WACCM-FV2",
    "CNRM-CM6-1", "CNRM-CM6-1-HR", "CNRM-ESM2-1", "E3SM-2-0",
    "E3SM-2-1", "EC-Earth3", "EC-Earth3-AerChem", "EC-Earth3-Veg",
    "EC-Earth3-Veg-LR", "FGOALS-f3-L", "GISS-E2-1-G", "GISS-E2-2-G",
    "GISS-E3-G", "HadGEM3-GC31-LL", "IPSL-CM6A-LR", "IPSL-CM6A-MR1",
    "MIROC6", "MIROC-ES2L", "MPI-ESM-1-2-HAM", "MPI-ESM1-2-HR",
    "MPI-ESM1-2-LR", "MRI-ESM2-0", "NorCPM1", "UKESM1-0-LL"])

n_model6 = len(model6)
print(f"模型数量: {n_model6}")
print("模型列表:", model6)

outpath = '/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/reviewer3_amip/'

# **************读取数据**************
# 季节类型
M = np.array(["AM_0.25_misstoc/", "MA_0.25_misstoc/", "MJ_0.25_misstoc/"])

# 输入路径
inpath_model_SS = "/home/hujl/SAF_time/NH45_dTNH45/paper3_reply/reviewer3_amip/data_snow_albedo/seasonal/result_cmip6/"

# 空间维度
n_lat = 45
n_lon = 360

# 初始化数组
delta_tas = np.full((n_model6, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
delta_alpsnow = np.full((n_model6, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
delta_prsn = np.full((n_model6, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
snc = np.full((n_model6, 132, n_lat, n_lon), np.nan, dtype=np.float64)

print("\n开始读取数据...")
for i in range(n_model6):
    for j in range(3):  # 3个季节
        m6 = model6[i]

        # 构建文件路径
        file1 = os.path.join(inpath_model_SS, M[j], f"delta_tas.{m6}.EASE_grid.nc")
        file2 = os.path.join(inpath_model_SS, M[j], f"delta_alpha_snow.{m6}.EASE_grid.nc")
        file3 = os.path.join(inpath_model_SS, M[j], f"delta_prsn.{m6}.EASE_grid.nc")
        file4 = os.path.join(inpath_model_SS, M[j], f"snc.all.{m6}.EASE_grid.nc")

        try:
            if os.path.exists(file1):
                ds1 = xr.open_dataset(file1, decode_times=False)
                # 直接使用数值索引，不依赖时间坐标
                delta_tas[i, j,:, :, :] = ds1['tas'].values[:, :, :]
                ds1.close()

            if os.path.exists(file2):
                ds2 = xr.open_dataset(file2, decode_times=False)
                delta_alpsnow[i, j,:, :, :] = ds2['alpha_snow'].values[:, :, :]
                ds2.close()

            if os.path.exists(file3):
                ds3 = xr.open_dataset(file3, decode_times=False)
                delta_prsn[i, j,:, :, :] = ds3['prsn'].values[:, :, :]
                ds3.close()

            if os.path.exists(file4):
                ds4 = xr.open_dataset(file4, decode_times=False)
                # snc: 取索引2-5
                snc[i, :, :, :] = ds4['snc'].values[:, :, :]
                ds4.close()

                a=ds4['snc'].values[:, :, :]
                print(f"a: min={np.nanmin(a):.2f}, max={np.nanmax(a):.2f}")

        except Exception as e:
            print(f"读取模型 {m6} 季节 {j} 时出错: {e}")

# 数据转换
snc = snc*100.0  # snc转换为百分比
delta_prsn = delta_prsn * 24 * 60 * 60 *30 # delta_prsn从kg m-2 s-1转换为mm/mon，和观测的单位保持一致

# 打印数据范围
print("\n数据范围:")
print(f"snc: min={np.nanmin(snc):.2f}, max={np.nanmax(snc):.2f}")
# print(f"delta_alpsnow: min={np.nanmin(delta_alpsnow):.2f}, max={np.nanmax(delta_alpsnow):.2f}")
# print(f"delta_prsn: min={np.nanmin(delta_prsn):.2f}, max={np.nanmax(delta_prsn):.2f}")
# print(f"delta_tas: min={np.nanmin(delta_tas):.2f}, max={np.nanmax(delta_tas):.2f}")

#**************选择积雪覆盖区域**************
delta_tas_mk = np.full((n_model6, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
delta_alpsnow_mk = np.full((n_model6, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)
delta_prsn_mk = np.full((n_model6, 3, 33, n_lat, n_lon), np.nan, dtype=np.float64)

value = 25.0  # 积雪覆盖阈值

for mon in range(3):  # 0,1,2 对应3个季节
    # 创建掩码：当前月和下一月积雪覆盖都大于阈值
    mask = (snc[:, mon::4, :, :] > value) & (snc[:, (mon+1)::4, :, :] > value)

    # 应用掩码
    delta_tas_mk[:, mon, :, :, :] = np.where(mask, delta_tas[:, mon, :, :, :], np.nan)
    delta_alpsnow_mk[:, mon, :, :, :] = np.where(mask, delta_alpsnow[:, mon, :, :, :], np.nan)
    delta_prsn_mk[:, mon, :, :, :] = np.where(mask, delta_prsn[:, mon, :, :, :], np.nan)

#**************计算多元线性相关**********
coeff_tas = np.empty([n_model6, n_lat, n_lon], dtype = np.float64)
coeff_prsn= np.empty([n_model6, n_lat, n_lon], dtype = np.float64)
coeff_c   = np.empty([n_model6, n_lat, n_lon], dtype = np.float64)

r2 = np.empty([n_model6, n_lat, n_lon], dtype = np.float64)

pvalue_tas = np.empty([n_model6, n_lat, n_lon], dtype = np.float64)   # x的p值
pvalue_prsn = np.empty([n_model6, n_lat, n_lon], dtype = np.float64) # y的p值
pvalue_c = np.empty([n_model6, n_lat, n_lon], dtype = np.float64)    # 截距的p值

for i in range(0,n_model6):
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

             # 检查条件数（避免多重共线性）
             # cond_num = np.linalg.cond(X_with_const)
             # if cond_num > 1e10:  # 条件数过大
             #     coeff_tas[i, lat, lon] = np.nan
             #     coeff_prsn[i, lat, lon] = np.nan
             #     coeff_c[i, lat, lon] = np.nan
             #     r2[i, lat, lon] = np.nan
             #     pvalue_tas[i, lat, lon] = np.nan
             #     pvalue_prsn[i, lat, lon] = np.nan
             #     pvalue_c[i, lat, lon] = np.nan
             #     continue

             try:

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

             except np.linalg.LinAlgError:
                 # 矩阵奇异
                 coeff_c[i, lat, lon] = np.nan
                 coeff_tas[i, lat, lon] = np.nan
                 coeff_prsn[i, lat, lon] = np.nan
                 r2[i, lat, lon] = np.nan
                 pvalue_c[i, lat, lon] = np.nan
                 pvalue_tas[i, lat, lon] = np.nan
                 pvalue_prsn[i, lat, lon] = np.nan
                 continue

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
# out1 = xr.DataArray(exp_var, coords=[np.arange(0,n_model6,1),np.arange(0,3,1)],dims=['model','mon'])
out1 = xr.DataArray(coeff_tas, coords=[np.arange(0,n_model6,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','lat','lon'])
out2 = xr.DataArray(coeff_prsn, coords=[np.arange(0,n_model6,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','lat','lon'])
out3 = xr.DataArray(coeff_c, coords=[np.arange(0,n_model6,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','lat','lon'])
out4 = xr.DataArray(r2, coords=[np.arange(0,n_model6,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','lat','lon'])
out5 = xr.DataArray(pvalue_c, coords=[np.arange(0,n_model6,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','lat','lon'])
out6 = xr.DataArray(pvalue_tas, coords=[np.arange(0,n_model6,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','lat','lon'])
out7 = xr.DataArray(pvalue_prsn, coords=[np.arange(0,n_model6,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','lat','lon'])

out8 = xr.DataArray(delta_tas_mk, coords=[np.arange(0,n_model6,1),np.arange(0,3,1),np.arange(0,33,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','mon','year','lat','lon'])
out9 = xr.DataArray(delta_alpsnow_mk, coords=[np.arange(0,n_model6,1),np.arange(0,3,1),np.arange(0,33,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','mon','year','lat','lon'])
out10 = xr.DataArray(delta_prsn_mk, coords=[np.arange(0,n_model6,1),np.arange(0,3,1),np.arange(0,33,1),np.arange(0,n_lat,1),np.arange(0,n_lon,1)],dims=['model','mon','year','lat','lon'])

out = xr.merge([out1.rename('coeff_tas'), out2.rename('coeff_prsn'), out3.rename('coeff_c'), \
                out4.rename('r2'), out5.rename('pvalue_c'), out6.rename('pvalue_tas'), out7.rename('pvalue_prsn'),\
                out8.rename('delta_tas_mk'), out9.rename('delta_alpsnow_mk'), out10.rename('delta_prsn_mk')])

out.to_netcdf(outpath+'data_fit_seasonal_cmip6.nc')
