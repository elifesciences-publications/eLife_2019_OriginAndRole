
Datasets associated with « Origin of the bidirectionality of cerebrospinal fluid flow and impact on long-range transport between brain and spinal cord”, Thouvenin and Keiser et al., submitted to eLife in 2019.

Analysis of CSF flow- Profile, and extremal values extraction.

Part, or the entire dataset (>300 Go) can be shared upon request. One typical test file is shared here, with the analysis code to compute one CSF flow profile. 2 .mat files containing all the values plotted in figure 1 ( Maximal negative and positive speeds in CSFFlow.mat, and positions of these maxima as well as the position of the zero-crossing in the profile in CSFFlowPosExtrema.mat). 

1)	In CodeCSFFlow, run ExecuteAllkymos on the test file, and select the folder containing this test file (‘WT4_2_10Hz_180728.tif’). This function runs the segmentation of all lines detected as particles in successive kymographs. At the end of the code, the CSf Flow profile is obtained as well as a matrix contained in SpeedvsPos_AllTraces.mat

2)	By loading SpeedvsPos_AllTraces.mat, the profile can be plotted with the command errorbar(X_WT4_2_10Hz_180728, Speed_WT4_2_10Hz_180728,Error_WT4_2_10Hz_180728). The values from all the individual traces at the maximal positive and negative velocities are extracted in TracesMaxVentral, and TracesMaxDorsal to illustrate the distribution. From all Dorso-ventral positions, similar distributions are obtained and the average value is saved in Speed_WT4_2_10Hz_180728, while the standard error of the mean is saved in Error_WT4_2_10Hz_180728.

3)	In CSFFlow.mat, all the values of maximal velocity in ventral and dorsal positions can be found in the matrix Speed after extraction from all the profiles. The 220 first values correspond to the maximal velocity in ventral side (positive values) and the 220 next correspond to the maximal velocity in dorsal side (negative values). The first value (ventral side) originates from the same profile than the 221 st value (dorsal side), and so on.  Figure 1D1 can be created with the command scatter(X,Speed,25,SpeedData_Color,'filled').

4)	Similarly, CSFFlowPosExtrema.mat contains all the values for the normalized position of the maximal velocity in ventral part (close to 1), the position where the profile crosses the zero velocity, and the position of the maximal velocity in dorsal part. Here, only 212 profiles were kept, after exclusion of profiles where the position normalization was ineffective (Normalized position below 0, or above 1). The speed matrix contains 212x3 positions, with the first, the 213th, and 425th, are extracted from the same profile (respectively ventral position, central position, and dorsal position), and so on. Figure 1D2 can be generated with the command boxplot(Speed,X).
