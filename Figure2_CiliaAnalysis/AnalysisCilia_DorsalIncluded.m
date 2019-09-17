clear
AllFreq=zeros(6,10);
Compt=0;


DrawCentralLine=0;

if DrawCentralLine
    
    %%%To draw the central lien of central canal in order to find dorsal vs
    %%%ventral cilia
    
    list1=ls('*.tif');
    
    % Tracé de la ligne de demarquation:
    CentralLine=cell(1,size(list1,1));
    
    for nn=1:size(list1,1)
        nn
        
        FileTif=strcat(InitialFolder,strtrim(list1(nn,:)));
        
        
        %Open data
        Infos=imfinfo(FileTif);
        NCol=Infos(1).Width;
        NLines=Infos(1).Height;
        NImages=numel(Infos);
        Ima_M=zeros(NLines,NCol);
        
        for ii=1:NImages
            Ima_M(:,:) =Ima_M+1/NImages* double(imread(FileTif,'Index',ii,'Info', Infos));
        end
        
        close(gcf)
        imagesc(Ima_M)
        title('Define central line')
        [x, y] = getline;
        SeparationLine=zeros(2,1+ceil(x(end))-floor(x(1)));
        SeparationLine(1,:)=(floor(x(1)):ceil(x(end)));
        Compt=0;
        for zz=1:(length(x)-1)
            Length=sum(SeparationLine(1,:)<x(zz+1)&SeparationLine(1,:)>x(zz));
            SeparationLine(2,1+Compt:Compt+Length)=(y(zz):(y(zz+1)-y(zz))/(Length-1):y(zz+1));
            Compt=Compt+Length;
        end
        SeparationLine(2,Compt:end)=y(end);
        hold on
        plot(SeparationLine(1,:),SeparationLine(2,:),'r','linewidth',2)
        pause(0.1)
        CentralLine{nn}=SeparationLine;
    end
    
    save('CentralLine.mat','CentralLine')
    
    
else
    Line=load('CentralLine.mat');
    CentralLine=Line.CentralLine;
end


InitialFolder=uigetdir();
%InitialFolder='C:\Users\Thouvenin Olivier\Desktop\SharedData_CsfCircu_eLife\Cilia\';
cd(InitialFolder)

list=ls('*.mat');

for nn=1:size(list,1)
    nn
    Data=load(strcat(InitialFolder,'\', strtrim(list(nn,:))));
    
for ff=1:9
    
%Freq=Data.Freq_FromPSD;
Freq=Data.Freq;
Freq2=Freq(:,:,1);
%Test=Freq2(Data.SNR_Freq(:,:,1)>2);
Freq2=Freq2>ff*5&Freq2<(ff+1)*5;

%imagesc(Freq2)
Freq2=bwlabel(Freq2, 8);
Freq2=imfill(Freq2);

blobMeasurements = regionprops(Freq2, Freq(:,:,1), 'all');
EffectiveCilia=blobMeasurements([blobMeasurements.Area]>40);

keeperIndexes = find([blobMeasurements.Area]>40);
keeperBlobsImage = ismember(Freq2, keeperIndexes);
keeperBlobsImage= bwlabel(keeperBlobsImage, 8);

SeparationLine=CentralLine{nn};
AngleLine=atan(diff(SeparationLine(2,:),1,2))*180/pi;


NAreas=size(EffectiveCilia,1);
PosCilia(1:2,Compt+1:Compt+NAreas)=reshape([EffectiveCilia.Centroid],2,NAreas);

AllFreq(1,Compt+1:Compt+NAreas)=[EffectiveCilia.MeanIntensity];
AllFreq(2,Compt+1:Compt+NAreas)=[EffectiveCilia.EquivDiameter];
AllFreq(4,Compt+1:Compt+NAreas)=[EffectiveCilia.Eccentricity];
AllFreq(5,Compt+1:Compt+NAreas)=[EffectiveCilia.Area];
AllFreq(6,Compt+1:Compt+NAreas)=[EffectiveCilia.MajorAxisLength];
AllFreq(8,Compt+1:Compt+NAreas)=nn;

IsDorsal=reshape([EffectiveCilia.Centroid],2,NAreas);
CiliaAngle=[EffectiveCilia.Orientation];

SeparationLine=CentralLine{nn};

for zz=1:NAreas
    [~,Idx]=min(abs(round(SeparationLine(1,:)-IsDorsal(1,zz))));
    AllFreq(3,Compt+zz)=CiliaAngle(zz)+AngleLine(max(1,Idx-1));
    AllFreq(3,Compt+zz)=90-AllFreq(3,Compt+zz);% Je calcule l'angle par rapport à la verticale
    AllFreq(7,Compt+zz)=(IsDorsal(2,zz)>SeparationLine(2,Idx)); %1 if ventral 0 if dorsal
    AllFreq(9,Compt+zz)=abs(IsDorsal(2,zz)-SeparationLine(2,Idx))<35;%1 if not too far (6.5um away) from central canal cetral line
end


Compt=Compt+NAreas;
end
end

Angles=AllFreq(3,:);
%calculate the angle versus the 
Angles(Angles>0)=90-Angles(Angles>0);
Angles(Angles<0)=-90-Angles(Angles<0);
AllFreq_goodAngle=AllFreq;
AllFreq_goodAngle(3,:)=Angles;
Idx=AllFreq_goodAngle(5,:)>100;% Selects only regions with at least 100 pixels.
AllFreq2=AllFreq_goodAngle(:,Idx);

%Colors=linspecer(min(8,size(list,1)));
%ColorPoints=Colors(1+mod(AllFreq2(7,:)-1,8),:);
%scatter((1/size(AllFreq2,2):1/size(AllFreq2,2):1),AllFreq2(3,:),15,ColorPoints,'filled');
scatter((1/size(AllFreq2,2):1/size(AllFreq2,2):1),AllFreq2(1,:),15,'filled');
title('Cilia mean Frequency in central canal of WT zebrafish (N=22)')
xlabel('Nb of cilia (A.U.). Each Color represents a different fish')
ylabel('Orientation')
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gcf,'Units','Normalized','Position', [0.05, 0.05, 0.9, 0.85])

% Account for the fact that the fish can be oriented either in RC or CR
% direction

for nn=1:size(list,1)
    Idx=AllFreq2(7,:)==nn;
    
    mean(AllFreq2(3,Idx))
    
    if mean(AllFreq2(3,Idx))>0
        AllFreq2(3,Idx)=-AllFreq2(3,Idx);
    end
    
end

%Figures
figure();
histogram(AllFreq2(3,:),(-90:5:90))
title('histogram of cilia mean orientation in central canal of WT zebrafish (N=22)')
xlabel('Angle with vertical (Dorso-Ventral) axis (°)')
ylabel('Nb of cilia')
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gcf,'Units','Normalized','Position', [0.05, 0.05, 0.9, 0.85])

mean(AllFreq2(3,:))
median(AllFreq2(3,:))


figure();
histogram(AllFreq2(1,:),(0:2.5:50))
title('histogram of cilia mean frequency in central canal of WT zebrafish (N=22)')
xlabel('Frequency (Hz)')
ylabel('Nb of cilia')
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gcf,'Units','Normalized','Position', [0.05, 0.05, 0.9, 0.85])

mean(AllFreq2(1,:))
median(AllFreq2(1,:))

figure();
histogram(AllFreq2(6,:)*0.189,(0:0.25:15))
title('Histogram of cilia mean length in central canal of WT zebrafish (N=22)')
xlabel(' Major axis length- Cilia length (um)')
ylabel('Nb of cilia')
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gcf,'Units','Normalized','Position', [0.05, 0.05, 0.9, 0.85])

mean(AllFreq2(6,:)*0.189)
median(AllFreq2(6,:)*0.189)

figure();
histogram(AllFreq2(6,:)*0.189.*cos(pi*AllFreq2(3,:)/180),(0:0.25:10))
title('Histogram of cilia extension along Dorso-ventral axis in WT zebrafish (N=22)')
xlabel(' Height of motile cilia region (um)')
ylabel('Nb of cilia')
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gcf,'Units','Normalized','Position', [0.05, 0.05, 0.9, 0.85])

mean(AllFreq2(6,:)*0.189.*cos(pi*AllFreq2(3,:)/180))
median(AllFreq2(6,:)*0.189.*cos(pi*AllFreq2(3,:)/180))
%plot an example


