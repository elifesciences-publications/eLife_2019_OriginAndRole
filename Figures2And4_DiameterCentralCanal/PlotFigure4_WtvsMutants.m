Data=load('C:\Users\Thouvenin Olivier\Desktop\SharedData_CsfCircu_eLife\DiameterCentralCanal_Figures2And4\Diameter_WTvsMutants.mat');
Diameter_AllEmbryos=Data.Diameter_AllEmbryos;

figure(1)
hold on

for ii=1:size(Diameter_AllEmbryos,1)
    Diam=Diameter_AllEmbryos{ii,1};
    N1=linspace(ii-0.2,ii+0.2,length(Diam));
    if mod(ii,2)==1
        plot(N1,Diam,'ob','linewidth',2)
    else
        plot(N1,Diam,'or','linewidth',2)
    end
end


set(gca,'XTick',1:1:10)
set(gca,'XTickLabel',{'WT','Lrrc50','WT','Foxj1a','WT','Elipsa','WT','Kurly','WT','SCO'})

title('\bf{Comparison of central canal diameter in WT vs ciliary mutants (30 hpf larvae)}','Interpreter','latex');
xlabel('\bf{Condition}','Interpreter','latex')
ylabel('\bf{Average central canal diameter ($\mu$m)}','Interpreter','latex')

legend({'WT ','Mutant'});

axis([0.5 10.5 2 15])
set(gca,'FontSize',20)
set(gca,'FontWeight','bold')
set(gca,'linewidth',3)

set(gcf,'Units','Normalized','Position', [0.05, 0.05, 0.9, 0.85])
%Statistical testing
    
for ii=1:2:10
    [h,p,ci,stats] = ttest2(Diameter_AllEmbryos{ii},Diameter_AllEmbryos{ii+1});
end

