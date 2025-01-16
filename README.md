# Motivations


The aim of this macro is to measure the relative position of the nuclei using Cellpose to segment the cells in Fiji and the Color Deconvolution to segment the nuclei

## How to install

Drag and drop the file into Fiji and click on Run.

## Requirements

This macro requires **PTBIOP** and **IJPB-plugins** from the Fiji plugins updater. Please follow the instructions from their [website](https://github.com/MouseLand/cellpose) to install Cellpose GUI and cite the respective authors.

## How to use

Select a rectangle and click on run. The data are expected to be in a single brightfield image .
<br>The first step aims at detecting the nuclei by doing a color deconvolution using the H&E DAB vectors, denoising the image using a median filter of size 5, and thresholding the image using MaxEntropy.
<br>Cellpose cyto3 is then run on the original image to identify each cell, then the distance map of each cell is computed. The final step aims at taking the maximum value of the distance max under the nucleis to get the max relative position of the nuclei for that cell.
<br>The result is then put into a table and saved.

## Citations

Please cite [Cellpose](https://www.nature.com/articles/s41592-020-01018-x) if you use this macro.

## Updates history
(0.0.1) Segment using Cellpose cyto3

