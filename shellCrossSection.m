function [] =  shellCrossSection()
clf;
% Initialization which you may need to edit
N = 100; % shells
%rangeOfPQN = [30,40,50,60,70];
rangeOfPQN = 30:40;
rangeOfDen = [0.6];
rangeOfEndTime = 100;
%rangeOfEndTime = [100]
den = 0.1;
fileTime = 350;
t_max = 350;

sigma_x = 700; %um
sigma_env = 5;

pos_x=linspace(0.5*sigma_env*sigma_x/(N-0.5),sigma_env*sigma_x,N);
firstHalf = pos_x(2:end);
firstHalf = -1*fliplr(firstHalf);
xaxis = [firstHalf, pos_x];
index = 1;

for den = rangeOfDen
for pqn = rangeOfPQN
    for endTime = rangeOfEndTime
            yaxis = getYAxis(pqn, den, endTime);
            title =['\rho_{0} = ',strrep(num2str(den),'.','p'),'\mum^{-3}, n_0 = ',num2str(pqn),...
                ' time = ', num2str(endTime), 'ns'];
            plot(xaxis,yaxis,'DisplayName',['\rho_{0} = ',strrep(num2str(den),'.','p'),'\mum^{-3}, n_0 = ',num2str(pqn),...
                ', time = ', num2str(endTime), 'ns']);
            legend('Location','northeastoutside');
            hold on;
            index = index + 1;
    end
end
end

xlabel('x-position in \mu m');
ylabel('Fractional electron density');


    function yaxis = getYAxis(pqn, den, endTime)
        dirname = ...
            ['C:\Users\Kiara\Documents\glw\CleanBifurcation\Results\Oct14\BestCalcs_den_' ...
            , strrep(num2str(den),'.','p')];
        cd (dirname);
        yaxis = zeros(N*2 - 1,1);
        filename = ['All_Fractions_vs_timepqn_',num2str(pqn) , 'Density_'...
            , strrep(num2str(den),'.','p') , '_shells_' , num2str(N) , '_t_max_'...
            , num2str(t_max),'.csv'];
        if ~(isfile(filename))
            fprintf("missing file! %s\n", filename);
            return;
        end
        mat = csvread(filename);
        
        
        time_full = mat(:,1);
        
        %strip away zeros from OutputMatrix
        
        allTimes = [0; nonzeros(time_full)];
        indexToLook = binarySearch(allTimes,endTime);
        for whichShell = 1:N
            totalRyd(whichShell) = mat(indexToLook,whichShell+1);
            totaldeac(whichShell) = mat(indexToLook,whichShell+N+1);
            totalE(whichShell) = mat(indexToLook,whichShell+2*N+1);
            Te(whichShell) = mat(indexToLook,3*N+1);
            vol(whichShell) = mat(indexToLook,whichShell+3*N+2);
        end
        
        yaxis(1:N) = fliplr(totalE);
        yaxis(N:2*N-1) = totalE;
        cd '..';
        return;
    end
end