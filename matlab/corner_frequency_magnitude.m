clear all
close all

C  = 1.9;
V  = 4200;
Mw = 3.0:0.1:4.0;

Mo = 10.^(1.5*Mw + 9.1);

sd = [1e6 10e6 100e6];    % stress drop
r  = zeros(numel(sd), numel(Mw));
f  = zeros(numel(sd), numel(Mw));

for k = 1:numel(sd)
    r(k,:)  = (7*Mo/(16*sd(k))).^(1/3);
    f(k,:)  = C*V./(2*pi*r(k,:));
end

figure()
setwin([33   300   1052  669])

subplot(1,2,1)
plot(Mw,r/1e3,'k-','LineWidth',2);
grid 
axis tight
xlabel('Mw','Interpreter','Latex')
ylabel('$radius [km]$','Interpreter','Latex')
fontsize(18)

text(mean(Mw)-.1,mean(r(1,:)/1e3)+.02,'1MPa'  ,'FontSize',14)
text(mean(Mw)-.1,mean(r(2,:)/1e3)+.02,'10MPa' ,'FontSize',14)
text(mean(Mw)-.1,mean(r(3,:)/1e3)+.02,'100MPa','FontSize',14)

subplot(1,2,2)
semilogx(f,Mw,'k-','LineWidth',2)
xlabel('Corner\,\,frequency [Hz]','Interpreter','Latex')
ylabel('$M_w$','Interpreter','Latex')
fontsize(18)
grid
setw

text(mean(f(1,:))-.1,3.6,'1MPa'  ,'FontSize',14,'Rotation',-75)
text(mean(f(2,:))-.1,3.6,'10MPa' ,'FontSize',14,'Rotation',-75)
text(mean(f(3,:))-.1,3.6,'100MPa','FontSize',14,'Rotation',-75)
