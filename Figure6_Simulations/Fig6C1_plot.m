% This script tracks the z-position (in the axis of the canal), 
% for a logarithmically distributed 
% selection of 33 times (from 10^(-3)s to 10^5 s) 
% at which c=10^-11 is reached.

clear all 
close all
clc

%% With no flow
ConcenNF=load('concentration_vs_time_D=10-11_no_flow.txt');

timevalue = logspace(-3,5,33);

for time = 1:33
    
Concen_centrale = ConcenNF(10001:20000,2+time);
ZborderNF11(time) = max(find (Concen_centrale > 10^(-11)))-5000;

end
figure

plot(timevalue,ConcenNF(ZborderNF11,1),'o','Markerfacecolor','blue','markeredgecolor','black','markersize',16)
hold on

set(gca,'yscale','log','xscale','log')
xlabel('Time (s)')
ylabel('Front position (m)')
set(gca,'Fontsize',20)
xlim([1 10^5])

%% With a flow of peak velocity v=6mum/s 


Concen=load('concentration_vs_time_D=10-11_moderate_flow_6mum_per_s.txt');

% 
for time = 1:33
    
Concen_centrale = Concen(10001:20000,2+time);
Zborder11(time) = max(find (Concen_centrale > 10^(-11)))-5000;

end
plot(timevalue,Concen(Zborder11,1),'s','Markerfacecolor','red','markeredgecolor','black','markersize',16)
%loglog(timevalue2,Concen(Xborder12,1),'o','Markerfacecolor','blue','markeredgecolor','black','markersize',12)
%loglog(timevalue2,Concen(Xborder09,1),'^','Markerfacecolor','green','markeredgecolor','black','markersize',12)
%loglog([10^2 10^4],[10^(-4) 10^(-3)],'black','linewidth',3)


%% With a flow of peak velocity v=20mum/s 

ConcenHF=load('concentration_vs_time_D=10-11_strong_flow_20mum_per_s.txt');

for time = 1:33
    
Concen_centrale = ConcenHF(10001:20000,2+time);
ZborderHF11(time) = max(find (Concen_centrale > 10^(-11)))-5000;

end
plot(timevalue,ConcenHF(ZborderHF11,1),'^','Markerfacecolor','green','markeredgecolor','black','markersize',16)


%% Superimpose the theoretical asymptotic diffusion law 
% With the effective diffusive obtained from Taylor-Aris diffusion
% derivation
Diff_no_flow = 10^-11; %m^2/s
Diff_v_6mum_per_s = Diff_no_flow*(1+(6*10^-6*10^-5/Diff_no_flow)^2/24);
Diff_v_20mum_per_s = Diff_no_flow*(1+(20*10^-6*10^-5/Diff_no_flow)^2/24);

hold on 
plot([100 100000],[100 100000].^(1/2)*sqrt(Diff_no_flow)/1.8,'blue','linewidth',2)
plot([100 100000],[100 100000].^(1/2)*sqrt(Diff_v_6mum_per_s)/1.8,'red','linewidth',2)
plot([100 100000],[100 100000].^(1/2)*sqrt(Diff_v_20mum_per_s)/1.8,'green','linewidth',2)

legend('v = 0 : no flow','v = 6 \mum/s','v = 20 \mum/s', 'D_{eff} = D = 10^{-11} m^2/s','D_{eff} = 2.5 D','D_{eff} = 17.7 D')
