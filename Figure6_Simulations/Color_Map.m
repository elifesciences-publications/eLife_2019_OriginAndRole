%% Concentration distrib. in beginning (both in absence and presence of flow)
% from x=-d to x = +d (axial direction), 
% and from y = 0 (bottom wall) to y = d (top wall).

% Darkest red corresponds to maximal concentration
% Darkest blue corresponds to concentration = 0
clear all
map = jet(200)
DATA_conc = load('initial_concentration.txt');
DATA_conc = DATA_conc(3:end',:);
figure
imshow(DATA_conc/max(max(DATA_conc))*200,map)
hold on
plot([1 1000], [1000 1000],'color','black','linewidth',5)
plot([1 1000], [1 1],'color','black','linewidth',5)

%% Concentration distrib. in absence of flow 
% from x=-d to x = +d (axial direction), 
% and from y = 0 (bottom wall) to y = d (top wall).

% Darkest red corresponds to maximal concentration
% Darkest blue corresponds to concentration = 0clear all
map = jet(200)
DATA_conc = load('t=1s_no_flow_D=10^-11.txt');
DATA_conc = DATA_conc(3:end',:);
figure
imshow(DATA_conc/max(max(DATA_conc))*200,map)
hold on
plot([1 1000], [1000 1000],'color','black','linewidth',5)
plot([1 1000], [1 1],'color','black','linewidth',5)

%% Concentration distrib. in presence of flow (v=6 mum/s)
% from x=-d to x = +d (axial direction), 
% and from y = 0 (bottom wall) to y = d (top wall).

% Darkest red corresponds to maximal concentration
% Darkest blue corresponds to concentration = 0clear all
map = jet(200)
DATA_conc = load('t=1s_v=6mum_per_s.txt');
DATA_conc = DATA_conc(3:end',:);
figure
imshow(DATA_conc/max(max(DATA_conc))*200,map)
hold on
plot([1 1000], [1000 1000],'color','black','linewidth',5)
plot([1 1000], [1 1],'color','black','linewidth',5)


%% Concentration distrib. in absence of flow 
% from x=-70*d to x = +70*d (axial direction), 
% and from y = 0 (bottom wall) to y = d (top wall).

% Darkest red corresponds to maximal concentration
% Darkest blue corresponds to concentration = 0clear all
map = jet(200)
DATA_conc = load('t=1000s_no_flow_D=10^-11_70d.txt');
DATA_conc = DATA_conc(3:end',:);
figure
imshow(DATA_conc/max(max(DATA_conc))*200,map)
hold on
plot([1 1000], [1000 1000],'color','black','linewidth',5)
plot([1 1000], [1 1],'color','black','linewidth',5)
%% Concentration distrib. in presence of flow (v=6 mum/s)
% from x=-70*d to x = +70*d (axial direction), 
% and from y = 0 (bottom wall) to y = d (top wall).

% Darkest red corresponds to maximal concentration
% Darkest blue corresponds to concentration = 0
clear all
map = jet(200)
DATA_conc = load('t=1000s_v=6mum_per_s.txt');
DATA_conc = DATA_conc(3:end',:);
figure
imshow(DATA_conc/max(max(DATA_conc))*200,map)
hold on
plot([1 1000], [1000 1000],'color','black','linewidth',5)
plot([1 1000], [1 1],'color','black','linewidth',5)
xlabel(

