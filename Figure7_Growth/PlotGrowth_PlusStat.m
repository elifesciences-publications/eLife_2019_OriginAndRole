
clear
load('Growth.mat')

%%%%%Plot%%%%

figure(1)
hold on
scatter(Length_Abla(1,:),Length_Abla(2,:),20,'b','filled')
scatter(Length_Control(1,:),Length_Control(2,:),20,'g','filled')
scatter(Length_NoAbla(1,:),Length_NoAbla(2,:),20,'m','filled')
axis([0.5 3.5 0.5 4])


figure(2)
hold on
scatter(Angle_Abla(1,:),Angle_Abla(2,:),20,'b','filled')
scatter(Angle_Control(1,:),Angle_Control(2,:),20,'g','filled')
scatter(Angle_NoAbla(1,:),Angle_NoAbla(2,:),20,'m','filled')
axis([0.5 3.5 0 20])

%%%%%%  (Not the most appropriate) Statisical test %%%%%%%%%%%%%

[h,p,ci,stats] = ttest2(Length_Abla(2,:),Length_Control(2,:))
[h,p,ci,stats] = ttest2(Length_Abla(2,:),Length_NoAbla(2,:))

[h,p,ci,stats] = ttest2(Angle_Abla(2,:),Angle_Control(2,:))
[h,p,ci,stats] = ttest2(Angle_Abla(2,:),Angle_NoAbla(2,:))