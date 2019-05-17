%%%%%%%%%%%%%%%%%%%%%%%%%%%
%General parameters
%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables; close all; clc

NTracesMin=5;% Number of min traces  at min or max for which the trial is rejected.
%%%%%%%%%%%%%%%%%%%%%%%
%XP Folder
%%%%%%%%%%%%%%%%%%%%%%%
DataPath='G:\PostDoc\Manips\20180726_SCO\WTvsSCO\'; %Find path of current directory
cd(DataPath)
%%%%%%%%%%%%%%%%%open all subfolders and the .mat file inside%%%%%

list=ls('KymoAnalysis_Wa*');
PixelSize=0.189;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Concatenate all data in a few matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SpeedvsPosition_CT=nan(260,40,3);% AvgSpeed and StdError and X vs (<=250pixels per fish) for all WT fish (N<=20)
%ExtremeSpeed_CT=nan(20,2);% MaxSpeed and MinSpeed for all WT fish(N<=20)
ExtremeTraces_CT=nan(260,40,2); % Traces(<=250 per fish) for MaxSpeed and MinSpeed for all WTfish (N<=20)

SpeedvsPosition_MT=nan(260,40,3);% AvgSpeed and StdError and X vs (<=250pixels per fish) for all SCO-/- fish (N<=20)
%ExtremeSpeed_MT=nan(20,2);% MaxSpeed and MinSpeed for all SCO-/- fish(N<=20)
ExtremeTraces_MT=nan(260,40,2); % Traces(<=250 per fish) for MaxSpeed and MinSpeed for all SCO-/- fish (N<=20)



ComptCT=1;
ComptMT=1;

for nn=1:size(list,1)
   % if nn~=3
    File=[DataPath,'\',strtrim(list(nn,:)),'\SpeedvsPos_AllTraces.mat'];
    S=load(File);
    T=fieldnames(S);

    for ii=1:size(T,1) % For each field of the structure, do something
        str=string(T(ii));
        eval(strcat('data=S.',str,';'))
        
        if contains(str,'WT')
            switch 1
                
                case contains(str,'Speed_')
                    SpeedvsPosition_CT(1:length(data),ceil(ComptCT/5),1)=data;
                case contains(str,'Error_')
                    SpeedvsPosition_CT(1:length(data),ceil(ComptCT/5),2)=data;
                case contains(str,'X_')
                    SpeedvsPosition_CT(1:length(data),ceil(ComptCT/5),3)=data;
                case contains(str,'TracesMaxDorsal_')
                    ExtremeTraces_CT(1:length(data),ceil(ComptCT/5),1)=data;
                case contains(str,'TracesMaxVentral_')
                    ExtremeTraces_CT(1:length(data),ceil(ComptCT/5),2)=data;
            end
            
            ComptCT=ComptCT+1;
            
        elseif contains(str,'MT')
            switch 1
                
                case contains(str,'Speed_')
                    SpeedvsPosition_MT(1:length(data),ceil(ComptMT/5),1)=data;
                case contains(str,'Error_')
                    SpeedvsPosition_MT(1:length(data),ceil(ComptMT/5),2)=data;
                case contains(str,'X_')
                    SpeedvsPosition_MT(1:length(data),ceil(ComptMT/5),3)=data;
                case contains(str,'TracesMaxDorsal_')
                    ExtremeTraces_MT(1:length(data),ceil(ComptMT/5),1)=data;
                case contains(str,'TracesMaxVentral_')
                    ExtremeTraces_MT(1:length(data),ceil(ComptMT/5),2)=data;
            end
            
            ComptMT=ComptMT+1;
            
        end
    end
  %  end     
end

Test=SpeedvsPosition_CT(:,:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot max and min speed for all fish
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %WT Fish
DorsalSpeed_CT=nan(40,2);
VentralSpeed_CT=nan(40,2);
ComptD=1;
ComptV=1;
SpeedVsWidth_Dorsal=zeros(2,10);
SpeedVsWidth_Ventral=zeros(2,10);
N_CT=zeros(40,2);

for zz=1:40
    
    Profile=SpeedvsPosition_CT(:,zz,1);
    Profile=Profile(isnan(Profile)==0);
   
    if length(Profile)>1
    [Max,posM]=max(smooth(Profile));
    [Min,posm]=min(smooth(Profile));
    
    if posm>posM %Profil inversé
        Profile=-Profile;
        SpeedvsPosition_CT(:,zz,1)=-SpeedvsPosition_CT(:,zz,1);
        [Max,posM]=max(smooth(Profile));
        [Min,posm]=min(smooth(Profile));
    end
    
    DorsalSpeed_CT(zz,:)=[Min SpeedvsPosition_CT(posm,zz,2)];
    VentralSpeed_CT(zz,:)=[Max SpeedvsPosition_CT(posM,zz,2)];
    N_CT(zz,1)=sum(isnan(ExtremeTraces_CT(:,zz,1))==0);%Number of traces for min position
    N_CT(zz,2)=sum(isnan(ExtremeTraces_CT(:,zz,2))==0);%Number of traces for max position

    if sum(N_CT(zz,:)<NTracesMin)>0 %Si il n'y a pas de particules (ou pas assez à terme, on supprime la trace)
        DorsalSpeed_CT(zz,:)=nan(1,2);
        VentralSpeed_CT(zz,:)=nan(1,2);
    end
    
    Width=find(smooth(Profile)~=0);
    Width_Dorsal(zz)=length(Width);
    Width=find(smooth(Profile)~=0);
    Width_Ventral(zz)=length(Width);
    
    SpeedVsWidth_Dorsal(1:2,ComptD)=transpose([Width_Dorsal(zz),DorsalSpeed_CT(zz,1)]);
    SpeedVsWidth_Ventral(1:2,ComptV)=transpose([Width_Ventral(zz),VentralSpeed_CT(zz,1)]);
    ComptD=ComptD+1;
    ComptV=ComptV+1;

    end
    
end



% Blab=DorsalSpeed_CT;
% Blab(:,2)=Blab(:,2).*sqrt(N_CT(:,1));
% DorsalSpeed_CT=DorsalSpeed_CT(Blab(:,2)<abs(Blab(:,1)+1),:);

DorsalSpeed_CT=DorsalSpeed_CT(isnan(DorsalSpeed_CT)==0);
DorsalSpeed_CT=DorsalSpeed_CT(DorsalSpeed_CT~=0);
DorsalSpeed_CT=reshape(DorsalSpeed_CT,length(DorsalSpeed_CT)/2,2);

VentralSpeed_CT=VentralSpeed_CT(isnan(VentralSpeed_CT)==0);
VentralSpeed_CT=VentralSpeed_CT(VentralSpeed_CT~=0);
VentralSpeed_CT=reshape(VentralSpeed_CT,length(VentralSpeed_CT)/2,2);
%Idem for SCO-/- fish

DorsalSpeed_MT=zeros(40,2);
VentralSpeed_MT=zeros(40,2);
N_MT=zeros(40,2);

for zz=1:40
    
    Profile=SpeedvsPosition_MT(:,zz,1);
    Profile=Profile(isnan(Profile)==0);

    if length(Profile)>1
    [Max,posM]=max(smooth(Profile));
    [Min,posm]=min(smooth(Profile));
    
    if posm>posM %Profil inversé
        Profile=-Profile;
        SpeedvsPosition_MT(:,zz,1)=-SpeedvsPosition_MT(:,zz,1);
        [Max,posM]=max(smooth(Profile));
        [Min,posm]=min(smooth(Profile));
    end
    
    DorsalSpeed_MT(zz,:)=[Min SpeedvsPosition_MT(posm,zz,2)];
    VentralSpeed_MT(zz,:)=[Max SpeedvsPosition_MT(posM,zz,2)];
    
    N_MT(zz,1)=sum(isnan(ExtremeTraces_MT(:,zz,1))==0);%Number of traces for min position
    N_MT(zz,2)=sum(isnan(ExtremeTraces_MT(:,zz,2))==0);%Number of traces for max position
    
    if sum(N_MT(zz,:)<NTracesMin)>0 %Si il n'y a pas de particules (ou pas assez à terme, on supprime la trace)
        DorsalSpeed_MT(zz,:)=nan(1,2);
        VentralSpeed_MT(zz,:)=nan(1,2);
    end
    
     Width=find(smooth(Profile)~=0);
    Width_Dorsal(zz)=length(Width);
    Width=find(smooth(Profile)~=0);
    Width_Ventral(zz)=length(Width);
    
   SpeedVsWidth_Dorsal(1:2,ComptD)=transpose([Width_Dorsal(zz),DorsalSpeed_MT(zz,1)]);
    SpeedVsWidth_Ventral(1:2,ComptV)=transpose([Width_Ventral(zz),VentralSpeed_MT(zz,1)]);
    ComptD=ComptD+1;
    ComptV=ComptV+1;
    
    end
   
    
end

DorsalSpeed_MT=DorsalSpeed_MT(isnan(DorsalSpeed_MT)==0);
DorsalSpeed_MT=DorsalSpeed_MT(DorsalSpeed_MT~=0);
DorsalSpeed_MT=reshape(DorsalSpeed_MT,length(DorsalSpeed_MT)/2,2);

VentralSpeed_MT=VentralSpeed_MT(isnan(VentralSpeed_MT)==0);
VentralSpeed_MT=VentralSpeed_MT(VentralSpeed_MT~=0);
VentralSpeed_MT=reshape(VentralSpeed_MT,length(VentralSpeed_MT)/2,2);

Nmin=min(min(N_CT));
Nmax=max(max(N_CT));

figure(1)
N1=(1:0.1:1+(size(DorsalSpeed_CT,1)-0.1)*0.1);
N2=(5:0.1:5+(size(DorsalSpeed_MT,1)-0.1)*0.1);
%Cmap=[0 0 1]*N_CT(:,1)/Nmax;


h1=errorbar(N1,DorsalSpeed_CT(:,1),DorsalSpeed_CT(:,2),'+','linewidth',2);%'Color',Cmap);
hold on
h2=errorbar(N1,VentralSpeed_CT(:,1),VentralSpeed_CT(:,2),'+r','linewidth',2);
h3=errorbar(N2,DorsalSpeed_MT(:,1),DorsalSpeed_MT(:,2),'+g','linewidth',2);
h4=errorbar(N2,VentralSpeed_MT(:,1),VentralSpeed_MT(:,2),'+c','linewidth',2);

N=(1:0.01:6);
plot(N,ones(size(N)) *mean(DorsalSpeed_CT(:,1)),'--b','linewidth',1.5)
plot(N,ones(size(N)) *mean(VentralSpeed_CT(:,1)),'--r','linewidth',1.5)
plot(N,ones(size(N)) *mean(DorsalSpeed_MT(:,1)),'--g','linewidth',1.5)
plot(N,ones(size(N)) *mean(VentralSpeed_MT(:,1)),'--c','linewidth',1.5)

title('Max Dorsal and Ventral Speed in the central canal for WT vs. SCO larvae');
xlabel('N° fish')
ylabel('Speed (um/s)')
legend([h1 h2 h3 h4],{'DorsalSpeed_ WT','VentralSpeed_ WT','DorsalSpeed_ SCO','VentralSpeed_ SCO'});
set(gca,'XLim',[0.5 8])
set(gca,'YLim',[-20 20])
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gca,'linewidth',3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot all SpeedvsDVPosition curves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%WT Fish
figure(2)
hold on
% v = VideoWriter('Traces.avi');
% open(v);
for zz=1:35
    if isnan(SpeedvsPosition_CT(1,zz,1))==0
        %plot(SpeedvsPosition_CT(:,zz,1))
        %plot(SpeedvsPosition_CT(:,zz,3),smooth(SpeedvsPosition_CT(:,zz,1)),'b')
        errorbar(SpeedvsPosition_CT(1:600,zz,3),smooth(SpeedvsPosition_CT(1:600,zz,1)),SpeedvsPosition_CT(1:600,zz,2),'linewidth',2);
        xlabel('Normalized position')
        ylabel('Speed (um/s)')
        title(strcat('CT',num2str(zz)));
        set(gca,'XLim',[-0.5 1.5])
        set(gca,'YLim',[-10 10])
        set(gca,'FontSize',24)
        set(gca,'FontWeight','bold')
        set(gca,'linewidth',3)
        
        pause()
 
        
%         frame=getframe(gcf);
%         writeVideo(v,frame);
    end
end

%SCo-/- Fish

% figure(3)
  hold on
for zz=1:36
    if isnan(SpeedvsPosition_MT(1,zz,1))==0
         plot(SpeedvsPosition_MT(:,zz,3),smooth(SpeedvsPosition_MT(:,zz,1)),'r')
     
     %   errorbar(SpeedvsPosition_MT(:,zz,3),smooth(SpeedvsPosition_MT(:,zz,1)),SpeedvsPosition_MT(:,zz,2));
     %  pause();
     
      xlabel('Normalized position')
        ylabel('Speed (um/s)')
        set(gca,'XLim',[-0.5 1.5])
        set(gca,'YLim',[-8 8])
        set(gca,'FontSize',20)
        set(gca,'FontWeight','bold')
        set(gca,'linewidth',3)
        title(strcat('MT-',num2str(zz)))
     %frame=getframe(gcf);
%      writeVideo(v,frame);
     hold on
    end
end




figure(3)
plot(SpeedVsWidth_Dorsal(1,1:size(DorsalSpeed_CT)),SpeedVsWidth_Dorsal(2,1:size(DorsalSpeed_CT)),'+b');
hold on
plot(SpeedVsWidth_Dorsal(1,size(DorsalSpeed_CT)+1:end),SpeedVsWidth_Dorsal(2,size(DorsalSpeed_CT)+1:end),'+g');
plot(SpeedVsWidth_Ventral(1,1:size(DorsalSpeed_CT)),SpeedVsWidth_Ventral(2,1:size(DorsalSpeed_CT)),'+r');
plot(SpeedVsWidth_Ventral(1,size(DorsalSpeed_CT)+1:end),SpeedVsWidth_Ventral(2,size(DorsalSpeed_CT)+1:end),'+c');



hold on
set(gcf,'units','normalized','outerposition',[0.025 0.1 0.95 0.9])

p1=polyfit(PixelSize*SpeedVsWidth_Dorsal(1,:),SpeedVsWidth_Dorsal(2,:),1);
 X1=PixelSize*linspace(min(SpeedVsWidth_Dorsal(1,:)),max(SpeedVsWidth_Dorsal(1,:)),length(SpeedVsWidth_Dorsal(1,:))); 
 plot(X1,p1(2)+p1(1)*X1,'r','linewidth',2)


p2=polyfit(PixelSize*SpeedVsWidth_Ventral(1,:),SpeedVsWidth_Ventral(2,:),1);
 X=PixelSize*linspace(min(SpeedVsWidth_Ventral(1,:)),max(SpeedVsWidth_Ventral(1,:)),length(SpeedVsWidth_Ventral(1,:))); 
 plot(X,p2(2)+p2(1)*X,'r','linewidth',2)


title('Correlation between Max speed and canal size for 150 WT canal positions ');
xlabel('Canal Width')
ylabel('Extreme speed (um/s)')
set(gca,'XLim',[0 30])
set(gca,'YLim',[-15 15])
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gca,'linewidth',3)

yL=get(gca,'YLim'); 
xL=get(gca,'XLim');   

  text((xL(1)+xL(2))/2,yL(2)-2,strcat('y=',num2str(round(p2(2)*10)/10),'+',num2str(round(10*p2(1))/10),'x'),...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'BackgroundColor',[1 1 1],...
      'FontSize',16,'FontWeight','Bold');
 
  text((xL(1)+xL(2))/2,yL(1)+4,strcat('y=',num2str(round(p1(2)*10)/10),num2str(round(10*p1(2))/10),'x'),...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'BackgroundColor',[1 1 1],...
      'FontSize',16,'FontWeight','Bold');

  

  