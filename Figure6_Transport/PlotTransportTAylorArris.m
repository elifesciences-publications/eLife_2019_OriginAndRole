r=(0.1:0.1:1000);%nm
v=5*10^(-6); %m/s
Radius=5*10^(-6);%um
Diff= 1.38064852 * 10^(-23)*300./(6*pi*r*10^(-9)*10^(-3));

EffectiveD=Diff.*(1+(v^2*Radius^2./(24*Diff.^2)));

Distance=3*10^(-4);
Time_Active=Distance^2./(2*EffectiveD);
Time_Passive=Distance^2./(2*Diff);

%%%%PLot%%%%

figure(2)
plot(r,Time_Active/60,'c','linewidth',5)
hold on
plot(r,Time_Passive/60,'m','linewidth',5)
axis([0 200 0 200])
legend ('Diffusion + Flow','Diffusion')
xlabel('Particle radius (nm)')
ylabel('Time to travel 300 um')
set(gca,'FontSize',32)



figure(3)
semilogx(r,Time_Active/60,'c','linewidth',5)
hold on
semilogx(r,Time_Passive/60,'m','linewidth',5)
axis([5 1000 0 500])
legend ('Diffusion + Flow','Diffusion')
xlabel('Particle radius (nm)')
ylabel('Time to travel 300 um')
set(gca,'FontSize',32)




