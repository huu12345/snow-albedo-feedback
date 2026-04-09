# Manuscript Code Repository

**Spring Snow Albedo Feedback on Seasonal and Decadal Timescales for Observations, Reanalysis Products and CMIP6 Models** *(submitted)*

**Git project initialized: 9 Apr 2026**

## Description

This repository contains all codes used in the manuscript Spring Snow Albedo Feedback on Seasonal and Decadal Timescales for Observations, Reanalysis Products and CMIP6 Models.

The repository is organized into two main directories: **Process** and **Plot**.

- **Process/** — data processing scripts
- **Plot/** — plotting scripts

## Process/

The Process folder includes the complete data processing workflow. It contains:
- snow_albedo_feedback
  
  Compute NET, SNC and TEM on the seasonal and decadal timescles. Each Shell is named according to timescles and datasets.
- snow_albedo
  
  Compute snow albedo changes, temperature changes and snowfall changes as preprocessing steps for linear regression. Each Shell is named according to timescles and datasets
- linear_regerssion
  
  Compute multiple linear regression between temperature, snowfall and snow albedo changes. Each Python script is named according to timescles and datasets.

## Plot/

The **Plot** folder contains all plotting scripts (13 Jupyter notebooks in Python) used to generate the figures presented in the manuscript.

- Each ncl is named according to the figure and table number in the paper.
- Input data are obtained from the outputs of the ##Process##.
