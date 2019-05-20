clear all
close all
clc

% This script plots the colormap of the axial component of the velocity
% field, in a portion of the canal of width 2.5 diameter between the
% ventral wall (here represented in the top of the plot, while it is in the
% bottom of the plot in the figure 3 of the article) and the dorsal wall
% (in the bottom of the plot). 

% Concerning the scarce cilia model, the streamlines are superimposed on the 
%colormap, to illustrate the presence of recirculation regions induced by the 
% irregular axial distribution of cilia (i.e. of force).

%% Panel A3 - Axial velocity distribution in the homogeneous force model

A = load('homogeneous_force_distribution_velocity_magnitude.txt');

map = jet(200)
A= A(3:end,:);
rescaled = A-min(min(A));
map = jet(200);

figure
imshow(rescaled/max(max((rescaled)))*200,map)
hold on
plot([1 2500], [1 1],'color','black','linewidth',3)%bottom wall
plot([1 2500], [998 998],'color','black','linewidth',3) %top wall

plot([1 2500], [499 499],'--','color','black','linewidth',1)%bottom wall
title('Panel A3 - Homogeneous force distribution, axial invariance','Fontsize',20)

cb = colorbar;
pause(1)
cb.Ticks = linspace(1,200,2);
cb.TickLabels = {num2str(round(min(min(A))*10^6,2));num2str(round(max(max(A))*10^6,2))};
cb.FontSize = 20;
title(cb,'Axial velocity (\mum/s)','fontsize',20)

%% Scarce cilia model w = 2d - Large empty regions
% Axial velocity value 
A = load('w=2d_velocity_magnitude.txt');

map = jet(200)
A= A(3:end,:);
rescaled = A-min(min(A));
map = jet(200);

figure
imshow(rescaled/max(max((rescaled)))*200,map)
hold on
plot([1 2500], [1 1],'color','black','linewidth',3)%bottom wall
plot([1 2500], [998 998],'color','black','linewidth',3) %top wall

plot([250 1250 1250 250 250], [1 1 499 499 1],'--','color','black','linewidth',1)%bottom wall
plot([2500 2250 2250], [500 500 1],'--','color','black','linewidth',1)%bottom wall
hold on

cb = colorbar;
pause(1)
cb.Ticks = linspace(1,200,2);
cb.TickLabels = {num2str(round(min(min(A))*10^6,2));num2str(round(max(max(A))*10^6,2))};
cb.FontSize = 20;
title(cb,'Axial velocity (\mum/s)','fontsize',20)
% Superimpose the streamlines

B = load('w=2d_streamlines.txt');
sel = find(B(:,1)<10.25*10^-5 & B(:,1)>7.75*10^-5); %select only a width of about 2 diameter in the canal axis
%Variable change for the superimposition: X and Y will go from 1 to 1000

X = B(sel,1)-min(B(sel,1));
X = X/max(X)*2499 +1;
Y = B(sel,2)-min(B(sel,2));
Y = Y/max(Y)*997 +1;

plot(X,Y,'.','color','black','markersize',0.5)
title('Panel C2 - w = 2d : Large empty regions','fontsize',20)

%% Scarce cilia model w = d - Medium empty regions
% Axial velocity value 
A = load('w=d_velocity_magnitude.txt');

map = jet(200)
A= A(3:end,:);
rescaled = A-min(min(A));
map = jet(200);

figure
imshow(rescaled/max(max((rescaled)))*200,map)
pbaspect([1 2 1])
hold on
plot([1 2500], [1 1],'color','black','linewidth',3)%bottom wall
plot([1 2500], [998 998],'color','black','linewidth',3) %top wall

plot([250 750 750 250 250], [1 1 499 499 1],'--','color','black','linewidth',1)%bottom wall
plot([1250 1750 1750 1250 1250], [1 1 499 499 1],'--','color','black','linewidth',1)%bottom wall
plot([2500 2250 2250], [500 500 1],'--','color','black','linewidth',1)%bottom wall

hold on
cb = colorbar;
pause(1)
cb.Ticks = linspace(1,200,2);
cb.TickLabels = {num2str(round(min(min(A))*10^6,2));num2str(round(max(max(A))*10^6,2))};
cb.FontSize = 20;
title(cb,'Axial velocity (\mum/s)','fontsize',20)

% Superimpose the streamlines

B = load('w=d_streamlines.txt');
sel = find(B(:,1)<4.25*10^-5 & B(:,1)>1.75*10^-5); %select only a width of about 2 diameter in the canal axis
%Variable change for the superimposition: X and Y will go from 1 to 1000

X = B(sel,1)-min(B(sel,1));
X = X/max(X)*2499 +1;
Y = B(sel,2)-min(B(sel,2));
Y = Y/max(Y)*997 +1;
plot(X,Y,'.','color','black','markersize',0.5)
title('Panel C2 - w = d : Medium empty regions','fontsize',20)

%% Scarce cilia model w = d/2 - Short empty regions
% Axial velocity value 
A = load('w=d_over_2_velocity_magnitude.txt');

map = jet(200)
A= A(3:end,:);
rescaled = A-min(min(A));
map = jet(200);

figure
imshow(rescaled/max(max((rescaled)))*200,map)
pbaspect([1 2 1])
hold on
plot([1 2500], [1 1],'color','black','linewidth',3)%bottom wall
plot([1 2500], [998 998],'color','black','linewidth',3) %top wall

plot([250 500 500 250 250], [1 1 499 499 1],'--','color','black','linewidth',1)%bottom wall
plot([750 1000 1000 750 750], [1 1 499 499 1],'--','color','black','linewidth',1)%bottom wall
plot([1250 1500 1500 1250 1250], [1 1 499 499 1],'--','color','black','linewidth',1)%bottom wall
plot([1750 2000 2000 1750 1750], [1 1 499 499 1],'--','color','black','linewidth',1)%bottom wall
plot([2250 2500 2500 2250 2250], [1 1 499 499 1],'--','color','black','linewidth',1)%bottom wall

hold on
cb = colorbar;
pause(1)
cb.Ticks = linspace(1,200,2);
cb.TickLabels = {num2str(round(min(min(A))*10^6,2));num2str(round(max(max(A))*10^6,2))};
cb.FontSize = 20;
title(cb,'Axial velocity (\mum/s)','fontsize',20)
% Superimpose the streamlines

B = load('w=d_over_2_streamlines.txt');
sel = find(B(:,1)<4.25*10^-5 & B(:,1)>1.75*10^-5); %select only a width of about 2 diameter in the canal axis
%Variable change for the superimposition: X and Y will go from 1 to 1000

X = B(sel,1)-min(B(sel,1));
X = X/max(X)*2499 +1;
Y = B(sel,2)-min(B(sel,2));
Y = Y/max(Y)*997 +1;
plot(X,Y,'.','color','black','markersize',0.5)
title('Panel C2 - w = d/2 : Short empty regions','fontsize',20)
