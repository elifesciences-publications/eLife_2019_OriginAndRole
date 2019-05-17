
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%General parameters
%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables; close all; clc
InitialPath=pwd;
addpath(InitialPath);
PixelSize=0.189;%40X Spinning Leica

%%%%%%%%%%%%%%%%%%%%%%%
%XP Folder
%%%%%%%%%%%%%%%%%%%%%%%

DataPath=strcat(InitialPath,'\ShapeCC\');
cd(DataPath)
list=ls('*T*');
SizeAll=zeros(3,size(list,1));

for n=1:size(list,1)
    
    Name=strtrim(list(n,:));  
    
    FinalDataPath=strcat(DataPath,Name,'\');   
    cd(FinalDataPath)
    list3=ls('*.TIF');

    %Opens all .tif to create a movie
    %Opens first time point to extract relevant info
    l=strtrim(list3(1,:));
    FileTif=strcat(FinalDataPath,l);
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Open .tiff file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Infos=imfinfo(FileTif);
    NCol=Infos(1).Width;
    NLines=Infos(1).Height;
    NImages=numel(Infos);
   
    Ima=zeros(NLines,NCol,NImages);
    
    for ii=1:NImages
        Ima(:,:,ii) = double(imread(FileTif,'Index',ii,'Info', Infos));
        % Ima(:,:,ii)=Ima(:,:,ii)./mean(mean(Ima(:,:,ii)));
    end
    
    Ima_M=max(Ima,[],3);
    imagesc(Ima_M)
    
    Ima1=RotateAndCropImage(Ima_M);
    NCol=size(Ima1,2);
    NLines=size(Ima1,1);
    
    imagesc(Ima1)
    
    set(gcf,'Units','Normalized','Position', [0.05, 0.05, 0.9, 0.85]) 
    title('Draw central Canal')
    ROI=imrect;
    pause();
    
    Pos=round(getPosition(ROI));
    Size=Pos(4);
    N=Pos(3);

SizeAll(1,n)=Size*PixelSize;
SizeAll(2,n)=N;

switch 1
    case contains(strtrim(list(n,:)),'WT')
        SizeAll(3,n)=1;
    case contains(strtrim(list(n,:)),'MT')
        SizeAll(3,n)=2;
end


disp(n)
end

save(strcat(maison,'SizeCanal_Foxj1vsWT.mat'),'SizeAll')

IdxWT=SizeAll(3,:)==1;
IdxMT=SizeAll(3,:)==2;

N1=linspace(0.8,1.2,sum(IdxWT));
N2=linspace(1.8,2.2,sum(IdxMT));

plot(N1,SizeAll(1,IdxWT),'o','linewidth',2)
hold on
plot(N2,SizeAll(1,IdxMT),'or','linewidth',2)

set(gca,'XTick',1:1:2)
set(gca,'XTickLabel',{'WT','Foxj1a'})

title('Comparison of central canal diameter in WT vs Foxj1a 30hpf larvae','Interpreter','latex');
xlabel('Condition','Interpreter','latex')
ylabel('Average central canal diameter ($\mu$m)','Interpreter','latex')

legend({'WT ','Foxj1a'});

axis([0.5 2.5 0 12])
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gca,'linewidth',3)
    