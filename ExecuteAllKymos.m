%%%%%%%%%%%%%%%%%%%%%%%%%%%
%General parameters
%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables; close all; clc
DataPath=uigetdir();
%addpath(genpath(DataPath))
%%%%%%%%%%%%%%%%%%%%%%%
%XP Folder
%%%%%%%%%%%%%%%%%%%%%%%


cd(DataPath)
list=ls('*.tif');


for nn=1:size(list,1)
 
    nn
    l=strtrim(list(nn,:));
    Name=l(1:end-4);
    DataFile=strcat(DataPath,'\',l);      
    
    PixelSize=0.189; %µm
    FrameTime=0.1;%s
    Analysis_AllFiles_Kymograph_28Dec2017(DataFile,Name,nn,PixelSize,FrameTime);

end
