load('Transport.mat')
TimeForFit=linspace(0,60,1000);

Color=[[0 1 1];[1 0 1]];
scatter(Time3,Trs2(1,:),100,Color(Trs2(2,:),:),'filled')
hold on
Idx_Np=Trs2(2,:)==1;

p1=polyfit([0 sqrt(Time3(Idx_Np))],[0 Trs2(1,Idx_Np)],1);
plot(TimeForFit,p1(2)+p1(1)*sqrt(TimeForFit),'c','linewidth',5)

Idx_P=Trs2(2,:)==2;

p1=polyfit([0 sqrt(Time3(Idx_P))],[0 Trs2(1,Idx_P)],1);
plot(TimeForFit,p1(2)+p1(1)*sqrt(TimeForFit),'m','linewidth',5)

legend({'Paralyzed','Active'});

axis([0 60 0 600])
set(gca,'FontSize',28)
set(gca,'FontWeight','bold')
set(gca,'linewidth',3)
xlabel('Time post-injection (minutes)')
ylabel('Traveled distance (um)')
set(gcf,'Units','Normalized','Position', [0.05, 0.05, 0.9, 0.85])