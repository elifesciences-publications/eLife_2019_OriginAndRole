Datasets associated with « Origin of the bidirectionality of cerebrospinal fluid flow and impact on long-range transport between brain and spinal cord”, Thouvenin and Keiser et al., submitted to eLife in 2019.

Analysis of cilia beating shown in figure 2.

The entire dataset (~70 Go) can be shared upon request. One typical test file is shared here, with the analysis code to compute cilia mean frequency, orientation and length. A .mat file containing all the values plotted in figure 2 is shared in the folder. 

1)	From raw .tif file (Example WT4_1_Middle_100Hz.tif’), execute matlab function Frequency.map to calculate the local time Fourier transform for all pixels of the image. This function outputs a .png file with the main peaks of the Fourier transform, and a .mat file with a matrix called Freq with all the peaks detected and sorted by intensity of the Fourier transform for each pixel in the image.
2)	Run AnalysisCilia in the folder where the .mat file containing a Freq matrix can be found. It creates an image from the Freq matrix and performs segmentation of all cilia regions, and computes the mean intensity (mean frequency), the dimeter, orientation, eccentricity, area, and major axis length of all regions. Finally, the matrix AllFreq2 is computed after excluding regions with less than 100 pixels (to select only cilia regions.)
3)	The AllFreq2 matrix contains 7 rows, and N columns, with N, the number of cilia regions found in one central canal region. The rows respectively correspond to the Mean frequency, the equivalent diameter, the orientation (versus the dorso-ventral axis), the eccentricity, the area (in number of pixels), and the major axis length. Only the Mean Frequency, orientation, and major axis length are plotted. 
4)	The dataset CiliaInfo.mat shows all the frequency (Freq), orientation (Angle) and length(Length) measurements corresponding to 360 cilia from 22 WT Arl13b-GFP 30 hpf embryos. These values are plotted as histograms in figure2.
