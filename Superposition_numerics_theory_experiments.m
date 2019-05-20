close all
clear all
clc
figure

%% Numerically predicted velocity profile (FEM with Comsol)

hold on
B=load('Velocity profile_Comsol.txt') % velocity profiles. The 2nd column gives the y-position and the 3rd column gives the velocity
hold on
plot(B(:,2)/10^(-5),B(:,3)*10^6,'s','Markeredgecolor','red','Markersize',14)
% The y-position is rescaled by the diameter of the channel to compare
% quantitatively with the measured that are also plotted as a fonction of a
% dimensionless radial position to get rid of the biological variability on
% the central canal diameter

%Note that the velocity is multiplied by 10^6 to plot the values in
%micron/s instead of the m/s provided by Comsol simulations.

%% Experimentally measured profiles 
load('TracesWT.mat'); % loads the 57 experimentally measured velocity profiles (PTV technique, as fully described in the Methods section) 
N = length(AllProfiles);
%Scale : 1 pixel = 0.189 microns

for ii = 1:N
hold on
MAT=AllProfiles{ii};
plot(MAT(:,3),-smooth(MAT(:,1),5),'color',[0.5 0.5 0.5])
end
xlim([-0.1 1.2])

% A smooth function is applied on the velocity in order to average the
% measurements. To plot the raw data, use instead the command :  
% plot(MAT(:,3),-MAT(:,1),'color',[0.5 0.5 0.5])

%% Theoretically predicted velocity profiles 
% following the equations written in the main manuscript

hold on 
syms B f_v h_I1 h_I2 mu omega l
mu = 10^-3; %Pa.s
f = 40; %Hz
h = 10*10^-6; %m
l = 5*10^-6; %m
f_v = 0.5*mu*f/l; %N/m^3
SOL = solve(B*h_I1*l+f_v*l^2/2-f_v*l*h_I1 == B*h_I2*l+B*h^2/2-B*h_I2*h,...
B*h_I2 == f_v*l+B*h_I1-f_v*h_I1,...
(B*h_I1*l^2/2+f_v*l^3/6-f_v*l^2*h_I1/2)+...
(-B*h^3/6+B*h_I2*h^2/2+B*h^3/2-B*h_I2*h^2)+...
(-B*h_I2*l^2/2-B*h^2*l/2+B*h_I2*h*l)==0,...
'ReturnConditions', true);

% Two solutions are found, and we select the physically relevant one, using
% this if condition.
if abs(double(SOL.h_I1(1)))>h||abs(double(SOL.h_I2(1)))>h
h_I_cils = double(SOL.h_I1(2));
BB = double(SOL.B(2));
h_I_ext = double(SOL.h_I2(2));
else
h_I_cils = double(SOL.h_I1(1));
BB = double(SOL.B(1));
h_I_ext = double(SOL.h_I2(1));
end

hold on
syms z
fplot(-(-BB*(z*h)^2/2/mu+BB*h_I_cils*z*h/mu+f_v*(z*h)^2/2/mu-f_v*h_I_cils*z*h/mu)*10^6,[0,l/h],'blue','Linewidth',2)
hold on
fplot(-(-BB*(z*h)^2/2/mu+BB*h_I_ext*z*h/mu+BB*h^2/2/mu-BB*h_I_ext*h/mu)*10^6,[l/h,1],'blue','Linewidth',2)
xlabel('normalized position','Fontsize',20)
ylabel('velocity (\mum/s)','Fontsize',20)
box on
 
view(90,-90) %rotate the plot


% Plot the walls
hold on 
plot([1 1],[-8 8],'color','black','linewidth',3)
plot([0 0],[-8 8],'color','black','linewidth',3)

set(gca,'fontsize',20)
