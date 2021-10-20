%% Plot Settings
pos = [10 10 800 300];
LineWidth = 2;
FontSize = 20;
%% Computational Grid
N = 101;
x = 2/(N-1)*(-(N-1):N-1)';
%% Window Functions
winu = ones(N,1);
winhann = hanning(N);
winhamm = hamming(N);
wincheb = chebwin(N);
%% Zero Pad
winu = [zeros((N-1)/2,1); winu; zeros((N-1)/2,1)];
winhann = [zeros((N-1)/2,1); winhann; zeros((N-1)/2,1)];
winhamm = [zeros((N-1)/2,1); winhamm; zeros((N-1)/2,1)];
wincheb = [zeros((N-1)/2,1); wincheb; zeros((N-1)/2,1)];
%% Plot
figure
plot(x,winu,'k','LineWidth',LineWidth)
hold on
plot(x,winhann,'r','LineWidth',LineWidth)
plot(x,winhamm,'g','LineWidth',LineWidth)
plot(x,wincheb,'b','LineWidth',LineWidth)
hold off
grid on
hleg = legend('Uniform','Hanning','Hamming','Chebyshev','location','northeast');
set(hleg,'FontSize',FontSize,'Interpreter','latex')
%% Save Plot
set(gcf,'Position',pos,'Renderer','painters','PaperPositionMode','auto')
try
    print(gcf,'-depsc2','WindowFunctions.eps')
catch me
    disp('Unable to save WindowFunctions.eps, check write status.')
end
