# Manuscript Code Repository

**Spring Snow Albedo Feedback on Seasonal and Decadal Timescales for Observations, Reanalysis Products and CMIP6 Models** (submitted)

**Git project initialized: 9 Apr 2026**

## Description

This repository contains all codes used in the manuscript *Spring Snow Albedo Feedback on Seasonal and Decadal Timescales for Observations, Reanalysis Products and CMIP6 Models*.

The repository is organized into two main directories: **Process** and **Plot**.

- **Process/** — data processing scripts
- **Plot/** — plotting scripts

## Process/

The Process folder includes the complete data processing workflow. It contains:
- snow_albedo_feedback \
  This folder is used to calculate the total snow albedo feedback (SAF<sub>NET<sub>) and its snow cover feedback component (SAF<sub>SNC<sub>) and snow metamorphism feedback (SAF<sub>TEM<sub>) component on the seasonal and decadal timescales. Each shell script is named according to timescales and datasets.
  
- snow_albedo \
  This folder is used to calculate snow albedo changes, temperature changes, and snowfall changes as preprocessing steps for linear regression. Each shell script is named according to timescales and datasets.
  
- linear_regression \
  This folder is used to calculate multiple linear regression between temperature, snowfall and snow albedo changes. Each python script is named according to timescales and datasets.

## Plot/

The **Plot** folder contains all plotting and tabling scripts used to generate the figures and tables presented in the manuscript.

- Each ncl script is named according to the figure and table number in the paper.
- Input data are obtained from the outputs of the ##Process##/ folder.
