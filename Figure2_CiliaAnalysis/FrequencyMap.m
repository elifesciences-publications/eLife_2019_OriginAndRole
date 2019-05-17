
function FrequencyMap(DataPath,FileTif)




if exist('FileTif','var')==0
    clear variables; close all; clc
    [FileTif, DataPath]=uigetfile('.tif');
    cd(DataPath)
    FileTif=strcat(DataPath,FileTif);
end

Name=char(FileTif);
SaveFigure=strcat(Name(1:end-4),'.png');
SaveFreq=strcat(Name(1:end-4),'.mat');

AcqFreq=100;%Hz
%Open data
Infos=imfinfo(FileTif);
NCol=Infos(1).Width;
NLines=Infos(1).Height;
NImages=numel(Infos);
Ima=zeros(NLines,NCol,NImages);

for ii=1:NImages
    Ima(:,:,ii) = sum(double(imread(FileTif,'Index',ii,'Info', Infos)),3);
end

%Local Average (Smooth)
BinValue=4;
Test=Ima*0;
for ii=0:BinValue-1
    for jj=0:BinValue-1
        Test=Test+circshift(circshift(Ima,ii,1),jj,2);
    end
end
Test=Test/(BinValue^2);
imagesc(Test(:,:,1))

%Test=imgaussfilt(Ima,2);
%Test=Ima;

%Calculate FFt and PSD

Freq=zeros(NLines,NCol,5);
Freq_FromPSD=zeros(NLines,NCol,5);

h=waitbar(0,'Frequency Calculation');
for ll=1:NLines
    waitbar(ll/NLines,h);
    for cc=1:NCol
        F=fft(squeeze(Test(ll,cc,:)/max(Test(ll,cc,:))));
        PSD=F.*conj(F);%Power Spectral density
        Blob=smooth(abs(F(2:floor(end/2))));
        %Blob(Blob<1)=0;
        [Max,LocalFreq]=findpeaks(Blob,'MinPeakDistance',10);
        [Max2,LocalFreq2]=findpeaks(PSD(2:floor(end/2)),'MinPeakDistance',10);
        LocalFreq=LocalFreq*AcqFreq/(length(F)-1);
        LocalFreq2=LocalFreq2*AcqFreq/(length(F)-1);
        
        if isempty(LocalFreq)==0
            L=size(LocalFreq,1);
            [~,Order]=sort(Max,'descend');
            SortedLocalFreq=LocalFreq(Order);
            Freq(ll,cc,1:L)=SortedLocalFreq;
        end
        
        if isempty(LocalFreq2)==0
            L2=size(LocalFreq2,1);
            [~,Order]=sort(Max2,'descend');
            SortedLocalFreq2=LocalFreq2(Order);
            Freq_FromPSD(ll,cc,1:L2)=SortedLocalFreq2;
        end
        

    end
end

close(h)



h=figure(1);
title('Cilia beating frequency')
subplot(2,2,1)
imagesc(squeeze(mean(Ima,3)))
title('Mean Image in the Central Canal')
subplot(2,2,2)
imagesc(Freq(:,:,1))
title('Main frequency of cilia beating')
subplot(2,2,3)
imagesc(Freq(:,:,2))
title('2nd frequency of cilia beating')
subplot(2,2,4)
imagesc(Freq(:,:,3))
title('3rd frequency of cilia beating')
%
saveas(h,SaveFigure)
save(SaveFreq,'Freq','Freq_FromPSD')

figure(2)
title('Cilia beating frequency')
subplot(2,2,1)
imagesc(squeeze(mean(Ima,3)))
title('Mean Image in the Central Canal')
subplot(2,2,2)
imagesc(Freq_FromPSD(:,:,1))
title('Main frequency of cilia beating')
subplot(2,2,3)
imagesc(Freq_FromPSD(:,:,2))
title('2nd frequency of cilia beating')
subplot(2,2,4)
imagesc(Freq_FromPSD(:,:,3))
title('3rd frequency of cilia beating')
end

