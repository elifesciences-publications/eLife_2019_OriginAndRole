Datasets associated with « Origin of the bidirectionality of cerebrospinal fluid flow and impact on long-range transport between brain and spinal cord”, Thouvenin and Keiser et al., submitted to eLife in 2019.

Measurements of central canal diameter.


1)	The Diameter_WT.mat and Diameter_WTvsMutants.mat are the datasets containing all the measurements of central canal diameter in WT embryos and ciliary mutants embryos. They are respectively used in figure 2 and figure 4. Diameter_WT contains one line with all diameter measurements from all WT embryos. The Diameter_AllEmbryos contained in Diameter_WTvsMutants.mat has a cell structure each cell containing all measurements for one condition (respectively for the following conditions ‘WT', 'Lrrc50', 'WT', 'Foxj1a', 'WT', 'Elipsa', 'WT', 'Kurly', 'WT', 'SCO’). The PlotFigure4_WtvsMutants.m allows reproducing the same figure as figure 4 from  Diameter_WTvsMutants.mat dataset.

2)	These measurements have been performed using a semi-automatic program (Size_Canal_Manual.m) allowing to open all files, choosing a correct rotation angle (to have the central canal as flat as possible), and a region of interest. Then, a third figure pops up allowing to draw the region corresponding to the central canal. The height of the drawn rectangle is extracted as the central canal diameter averaged over the width of the rectangle. The SizeCanal_Manual function calls the following subfunctions : ‘RotateAndCropImage.m, CheckRotation.m and CheckROI.m, as well as the following subfigures to draw the corresponding GUIs   CheckRotation.fig and CheckROI.fig

3)	A part of the dataset (Foxj1a embryos vs their WT siblings) is shared in Dryad, and the entire dataset can be shared upon request.
