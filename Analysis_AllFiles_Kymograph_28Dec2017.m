%Routine to generate particle tracks on tiff files with only a small part
%of the CC in the fov.

%Opens an image and find the particles within

function Analysis_AllFiles_Kymograph_28Dec2017(FileTif,Name,n,PixelSize,FrameTime)

if exist('PixelSize','var')==0
    PixelSize=0.189; %um
end

if exist('FrameTime','var')==0
    FrameTime=0.1; %s
end

% v = VideoWriter(strcat('Kymograph_',Name,'.avi'));
% open(v);


%Image parameters
Infos=imfinfo(FileTif);
NCol=Infos(1).Width;
NLines=Infos(1).Height;
NImages=numel(Infos);
Ima=zeros(NLines,NCol,NImages);

for ii=1:NImages
    Ima(:,:,ii) = double(imread(FileTif,'Index',ii,'Info', Infos));
    % Ima(:,:,ii)=Ima(:,:,ii)./mean(mean(Ima(:,:,ii)));
end

Kymo=permute(Ima,[3 2 1]);


Test=zeros(length(NLines)-5,1);
Test2=zeros(length(NLines)-5,1);

%Norm Factor and general threshold

Norm=ones(NImages,NCol,1);
%Norm(Norm<100)=100;
NAvg=3;
Perc=2.5;
SortedIm=sort(reshape(Kymo./repmat(Norm,1,1,NLines),NImages*NCol*NLines,1),'descend');
Kymo(Kymo<SortedIm(floor(length(SortedIm)/(100/Perc))))=SortedIm(floor(length(SortedIm)/(100/Perc)));

SpeedAll=zeros(NLines-5,100);

figure(1)

for ii=1:NLines-NAvg
    
    test0=mean(Kymo(:,:,ii:ii+NAvg),3)./Norm;
    %test=Kymo(:,:,ii);
    test=test0./repmat(mean(test0,1),NImages,1);
    %test=imgaussfilt(test,1);
    %test(test<1.25)=0;
    
    subplot(2,2,1)
    imagesc(test)
    title('Original image (avg 5 lines)')
    
    %Add a local threshold if one frame is much brighter than the average
    %    Perc2=5;
    %    SortedIm2=sort(reshape(test,NImages*NCol,1),'descend');
    
    %Binary mask is made from a general threshold (to avoid counting the
    %noise in frames where there is not a single trace) and a local
    %threshold
    %    Binary=(Kymo(:,:,ii)>SortedIm(floor(length(SortedIm)/(100/Perc)))& test>SortedIm2(floor(length(SortedIm2)/(100/Perc2))));
    %    Binary= bwlabel(Binary, 8);
    
    %Binary=(test0>SortedIm(floor(length(SortedIm)/(100/Perc))));%& test>1);
    %Binary= bwlabel(Binary, 8);
    %test(test0<SortedIm(floor(length(SortedIm)/(100/Perc))))=1;
    % [Binary, Gdir] = imgradient(test);
    % Binary=Binary>1;
%     figure(1)
%     
%     [H,T,R] = hough(test>1.01);
%     P=houghpeaks(H,20,'threshold',ceil(0.3*max(H(:))));
%     lines = houghlines(F,T,R,P,'FillGap',3,'MinLength',5);
%     imagesc(test)
%     hold on
%     for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%     end
%     
    
    
    Binary=test>1.01;
   %Binary=edge(test,'canny');
    %BW=edge(test,'canny');
    Binary= bwlabel(Binary, 8);
    subplot(2,2,2)
    imagesc(Binary)
    title('Binary image')

    %     F=abs(fftshift(fft2(test)));
    %     F(1+floor(NImages/2),:)=0;
    %     Perc=1;
    %     SortedIm=sort(reshape(F,NImages*NCol,1),'descend');
    %     Binary=F>SortedIm(floor(length(SortedIm)/(100/Perc)));
    %
    %     imagesc(Binary)
    %
    blobMeasurements = regionprops(Binary, test, 'all');
    EffectiveLines=blobMeasurements([blobMeasurements.Eccentricity]>0.9&[blobMeasurements.Area]>15&abs(sin(pi/180*[blobMeasurements.Orientation]))>0.1&abs(cos(pi/180*[blobMeasurements.Orientation]))>0.1);
    keeperIndexes = find([blobMeasurements.Eccentricity]>0.9&[blobMeasurements.Area]>15&abs(sin(pi/180*[blobMeasurements.Orientation]))>0.1&abs(cos(pi/180*[blobMeasurements.Orientation]))>0.1);
    keeperBlobsImage = ismember(Binary, keeperIndexes);
    keeperBlobsImage= bwlabel(keeperBlobsImage, 8);
    subplot(2,2,3)
    imagesc(keeperBlobsImage)
    title('Kept Traces')
    
    % %Hough transform
    % [H,T,R] = hough(Binary);
    % P  = houghpeaks(H,50,'threshold',ceil(0.3*max(H(:))));
    % lines = houghlines(Binary,T,R,P,'FillGap',5,'MinLength',7);
    %       subplot(2,2,3)
    %       hold off
    %       imagesc(test)
    %       hold on
    %       title('Kept Traces')
    %
    % for k = 1:length(lines)
    %    xy = [lines(k).point1; lines(k).point2];
    %    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % end
    %
    % if size(lines,2)<5
    %     Speed=0;
    %     Test(ii)=0;
    %     Test2(ii)=0;
    % else
    %     Orient_Kymo=[lines.theta];
    %     Speed=1./tan(-Orient_Kymo*pi/180)*(PixelSize/FrameTime);
    %     Speed=Speed(abs(Speed)<20);
    %
    %     Test(ii)=mean(Speed);
    %     Test2(ii)=std(Speed,0)/sqrt(length(Speed));
    %     SpeedAll(ii,1:length(Speed))=Speed;
    %
    %
    %
    % end
    % subplot(2,2,4)
    %     histogram(Speed,20)
    %     xlim([-20 20]);
    %     title('Histo speeds')
    %       X=linspace(1,NLines-5,NLines-5);
    %       X=(X-PosCanal(n,1))./(PosCanal(n,2)-PosCanal(n,1));
    
    Orient_Kymo=[EffectiveLines.Orientation];
    Speed=1./tan(-Orient_Kymo*pi/180)*(PixelSize/FrameTime);
    %Speed=Speed(abs(Speed)<20);
    
    if isempty(Speed)||length(Speed)<5
        Test(ii)=0;
        Test2(ii)=0;
        
    else
        Test(ii)=mean(Speed);
        Test2(ii)=std(Speed,0)/sqrt(length(Speed));
        SpeedAll(ii,1:length(Speed))=Speed;
    end
    
    subplot(2,2,4)
    histogram(Speed,20)
    xlim([-20 20]);
    title('Histo speeds')
    X=linspace(1,NLines-NAvg,NLines-NAvg);
    
    
%        polarplot(Orient_Kymo*pi/180,abs(Speed),'.')
       histogram(Speed,20)
    %     pause(0.1)
    %     hold on
    %  frame=getframe(gcf);
    %
     % writeVideo(v,frame);
      pause(0.05)
    
end

%close(v)

Blab=smooth(Test);
Blab2=find(Blab~=0);
X=1-(X-Blab2(1))./(Blab2(end)-Blab2(1));
eval(strcat('Speed','_',Name,'=Test;'));
eval(strcat('Error','_',Name,'=Test2;'));

[~,Posm]=min(smooth(Test));
[~,PosM]=max(smooth(Test));

VentralTraces=SpeedAll(PosM,:);
VentralTraces=VentralTraces(VentralTraces~=0);% Because I had to define a matrix where all lines have the same size, there are zeros at the end. I could have used a struct instead
DorsalTraces=SpeedAll(Posm,:);
DorsalTraces=DorsalTraces(DorsalTraces~=0);% Because I had to define a matrix where all lines have the same size, there are zeros at the end. I could have used a struct instead

eval(strcat('TracesMaxVentral','_',Name,'=VentralTraces;'));
eval(strcat('TracesMaxDorsal','_',Name,'=DorsalTraces;'));


%close(v)

%   if ismember(n,[3,4,7,8,9,10])
%       X=flip(X);
%   end

eval(strcat('X','_',Name,'=X;'));

if n>1
    save('SpeedvsPos_AllTraces.mat',strcat('X','_',Name),strcat('Speed','_',Name), strcat('Error','_',Name),strcat('TracesMaxVentral','_',Name),strcat('TracesMaxDorsal','_',Name),'-append');
else
    save('SpeedvsPos_AllTraces.mat',strcat('X','_',Name),strcat('Speed','_',Name), strcat('Error','_',Name),strcat('TracesMaxVentral','_',Name),strcat('TracesMaxDorsal','_',Name));
end

figure(10)
hold on
plot(X,smooth(squeeze(Test)))
xlabel('Normalized Dorso-ventral position')
ylabel('Average Rostro-Caudal Speed (um/s)')
figure(2)
hold off
errorbar(X,smooth(squeeze(Test)),squeeze(Test2));
xlabel('Normalized Dorso-ventral position')
ylabel('Average Rostro-Caudal Speed (um/s)')
pause(0.5)
end
 

   