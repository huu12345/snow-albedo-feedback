import pandas as pd
import numpy as np
import scipy as sp
import scipy.stats as stats
from statsmodels.formula.api import ols
from scipy.stats import pearsonr
from math import sqrt, ceil
import warnings
warnings.filterwarnings("ignore")
import os
import xarray as xr
from scipy.stats import gaussian_kde

#===================path==================
inpath_model_SS   = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_cmip6/"
inpath_model_DS   = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/decadal_minus_first/result/result_cmip6/"

inpath_OBS_SS     = "/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/data_amip/seasonal/result/result_obs_all/"

M = np.array(["AM_0.25_misstoc/", "MA_0.25_misstoc/", "MJ_0.25_misstoc/"])

outpath = '/home/hujl/SAF_time/NH45_dTNH45/paper4_reply_noGLASS/scatter/'

#================= read seasonal cmip6 ==================
#exclude Res/NET>10% and Had
model6 = np.array(["ACCESS-ESM1-5","BCC-ESM1","CanESM5",\
"CESM2","CESM2-FV2","CESM2-WACCM","CESM2-WACCM-FV2","CIESM",\
"CNRM-CM6-1","CNRM-CM6-1-HR","CNRM-ESM2-1","E3SM-2-0",\
"E3SM-2-1","EC-Earth3","EC-Earth3-AerChem","EC-Earth3-Veg","EC-Earth3-Veg-LR",\
"FGOALS-f3-L","GISS-E2-1-G","GISS-E2-2-G","GISS-E3-G","HadGEM3-GC31-LL",\
"IPSL-CM6A-LR","IPSL-CM6A-MR1","MIROC6","MIROC-ES2L",\
"MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1",\
"UKESM1-0-LL"])

n_model6 = len(model6)
print(n_model6)

ss = np.full((n_model6), np.nan, dtype=np.float64)

k4_season   = np.full((3), np.nan, dtype=np.float64)

print("\nStarting to read data...")
for i in range(n_model6):
    for j in range(3):  # 3 seasons
        m6 = model6[i]

        # Build file paths
        file1 = os.path.join(inpath_model_SS, M[j], f"k4.{m6}.EASE_grid.aa.nc")

        try:
            if os.path.exists(file1):
                ds1 = xr.open_dataset(file1, decode_times=False)
                k4_season[j] = ds1['k4'].values[0, 0, 0]
                ds1.close()

        except Exception as e:
            print(f"Error reading model {m6}, seasonl: {e}")

        ss[i] = np.mean(k4_season,axis=0)

#=================== read decadal cmip6 ==================
fs = np.full((n_model6), np.nan, dtype=np.float64)

for i in range(n_model6):
        m6 = model6[i]

        # Build file paths
        file1 = os.path.join(inpath_model_DS, f"k4.{m6}.EASE_grid.aa.nc")

        try:
            if os.path.exists(file1):
                ds1 = xr.open_dataset(file1, decode_times=False)
                fs[i] = ds1['k4'].values[0, 0, 0]
                ds1.close()


        except Exception as e:
            print(f"Error reading model {m6}, climate change: {e}")

#================= read seasonal obs ==================
nm_tas = np.array(["CRU", "GHCN"])
nm_snc = np.array(["JASMES", "NSIDC", "Rutgers"])
nm_alb = np.array(["APPx", "clara_a2", "clara_a3"])

NET_SS_obs1 = np.full((len(nm_tas), len(nm_snc), len(nm_alb)), np.nan, dtype=np.float64)

for m in range(len(nm_tas)):       # tas datasets
   for n in range(len(nm_snc)):    # snc datasets
      for k in range(len(nm_alb)): # albedo datasets
         k4_season   = np.full((3), np.nan, dtype=np.float64)

         for j in range(3):  # 3 seasons

            # Build file paths
            file1 = os.path.join(inpath_OBS_SS, M[j],f"k4.obs_{nm_tas[m]}_{nm_snc[n]}_{nm_alb[k]}.EASE_grid.aa.nc")

            try:
                if os.path.exists(file1):
                    ds1 = xr.open_dataset(file1, decode_times=False)
                    k4_season[j] = ds1['k4'].values[0, 0, 0]
                    ds1.close()

            except Exception as e:
               print(f"Error reading obs_{nm_tas[m]}_{nm_snc[n]}_{nm_alb[k]}, seasonl: {e}")

         NET_SS_obs1[m,n,k] = np.mean(k4_season,axis=0)

obsmean_list = np.mean(NET_SS_obs1, axis=(0, 1))

# print(ss)
# print(fs)
# print(NET_SS_obs)

# 需要的输入：ss(x轴的模式值)；fs(y轴的模式值)；obsmean_list(3套观测值)
# Convert input ss and fs to numpy arrays
ss = np.array(ss, dtype=np.float64)
fs = np.array(fs, dtype=np.float64)
# Create DataFrame and sort
df = pd.DataFrame({'x': ss, 'y': fs})
df = df.sort_values('x')

zmean = np.mean(fs)
zstd = np.std(fs)
print('zmean = ' + str(round(zmean, 3)))
print('zstd = ' + str(round(zstd, 3)))

# Calculate the forecasted value with emerging constraints
nbboot  = 10000                 # number of bootstrap
n_residual = 100                # 每个回归模型生成的残差样本数 (100个)
n_total = len(ss)               # 总模式数（应为32）
n_sample = 26                   # 每次有放回抽取的模式数
yinfer_all  = []
bootindex = np.random.randint
for ij in range(nbboot):
    # 从32个模式中有放回地抽取26个
    idx = bootindex(0, n_total-1, n_sample)

    # 用抽取的子集进行线性回归
    pc = np.polyfit(ss[idx], fs[idx], 1)  # 得到斜率(pc[0])和截距(pc[1])

    # 计算该回归模型的残差标准差（用抽取的子集计算）
    y_pred_sub = pc[0] * ss[idx] + pc[1]
    resid_sub = fs[idx] - y_pred_sub
    sigma_sub = np.std(resid_sub, ddof=1)  # 样本标准差（ddof=1）

    # 对每个观测值分别生成残差样本
    for obsmean in obsmean_list:  # 遍历3个观测值
      # 假设残差服从高斯分布，生成n_residual个残差样本
      for ir in range(n_residual):
        # 生成随机残差（正态分布，均值为0，标准差为sigma_sub）
        epsilon = np.random.normal(0, sigma_sub)

        # 用观测值计算预测的y值
        y_pred = pc[0] * obsmean + pc[1] + epsilon

        # 存储结果
        yinfer_all.append(y_pred)

# 转换为numpy数组
yinfer = np.array(yinfer_all)
print(f'yinfer_all 列表长度: {len(yinfer_all):,}')

# # Confidence interval of yinfer推测值的置信区间
# zmean_EC = np.mean(yinfer)
# zstd_EC = np.std(yinfer)
# print('zmean_EC = ' + str(round(zmean_EC, 3)))
# print('zstd_EC = ' + str(round(zstd_EC, 3)))

#高斯核密度估计
kde = gaussian_kde(yinfer)  # 使用高斯核密度估计拟合概率密度函数

x_min = np.percentile(yinfer, 0.1)  # 生成用于评估的x轴范围
x_max = np.percentile(yinfer, 99.9)
x_range = np.linspace(x_min, x_max, 1000)
pdf = kde(x_range)

dx = x_range[1] - x_range[0]  # 基于KDE计算均值
zmean_EC = np.sum(x_range * pdf * dx)

kde_var = np.sum((x_range - zmean_EC)**2 * pdf * dx) # 基于KDE计算标准差
zstd_EC = np.sqrt(kde_var)

print('zmean_EC = ' + str(round(zmean_EC, 3)))
print('zstd_EC = ' + str(round(zstd_EC, 3)))

# ================== save output ==================
ds = xr.Dataset(
    data_vars={
        'zmean_EC': xr.DataArray(zmean_EC, attrs={'long_name': 'Emerging constraint mean', 'units': 'unknown'}),
        'zstd_EC': xr.DataArray(zstd_EC, attrs={'long_name': 'Emerging constraint standard deviation', 'units': 'unknown'}),
        'zmean': xr.DataArray(zmean, attrs={'long_name': 'Mean of future change', 'units': 'unknown'}),
        'zstd': xr.DataArray(zstd, attrs={'long_name': 'Standard deviation of future change', 'units': 'unknown'}),
    },
    attrs={
        'description': 'Emerging constraint results',
        'observation_mean': float(obsmean),
        'n_bootstrap': nbboot,
        'n_models': int(n_total)
    }
)

# Save to netCDF
output_file = os.path.join(outpath, 'constrain.nc')
ds.to_netcdf(output_file)
# print(f"\nData saved to: {output_file}")
