function [] =  shellCrossSection()
clf;
readFromCsv = false;
% Initialization which you may need to edit
N = 100; % shells
rangeOfPQN = [50];
%rangeOfPQN = 30:40;
rangeOfDen = [0.2];
rangeOfEndTime = [20, 40, 60, 80, 100] ;
%rangeOfEndTime = [100]

t_max = 200;

sigma_x = 700; %um
sigma_env = 5;

pos_x=linspace(0.5*sigma_env*sigma_x/(N-0.5),sigma_env*sigma_x,N);
firstHalf = pos_x(2:end);
firstHalf = -1*fliplr(firstHalf);
xaxis = [firstHalf, pos_x];
xaxis = xaxis / 1000;
index = 1;

for den = rangeOfDen
    for pqn = rangeOfPQN
        for endTime = rangeOfEndTime
            [eAxis, rydAxis] = getYAxis(pqn, den, endTime);
            title =['\rho_{0} = ',strrep(num2str(den),'.','p'),'\mum^{-3}, n_0 = ',num2str(pqn),...
                ' time = ', num2str(endTime), 'ns'];
            plot(xaxis,eAxis,'--','DisplayName',['electrons, \rho_{0} = ',num2str(den),'\mum^{-3}, n_0 = ',num2str(pqn),...
                ', time = ', num2str(endTime), 'ns']);
            hold on;
            plot(xaxis,rydAxis,'DisplayName',['rydbergs, \rho_{0} = ',num2str(den),'\mum^{-3}, n_0 = ',num2str(pqn),...
                ', time = ', num2str(endTime), 'ns']);
            legend('Location','northeastoutside');
            hold on;
            index = index + 1;
        end
    end
end

xlabel('x-position in mm');
ylabel('Density in \mum^{-3}');


    function [eAxis, rydAxis] = getYAxis(pqn, den, endTime)
        dirname = ...
            ['C:\Users\Kiara\Documents\glw\CleanBifurcation\Results\SpecialSigma\SpecialSigma_den_' ...
            , strrep(num2str(den),'.','p')];
        cd (dirname);
        eAxis = zeros(N*2 - 1,1);
        rydAxis = zeros(N*2 - 1,1);
        if (readFromCsv)
            filename = ['All_Fractions_vs_timepqn_',num2str(pqn) , 'Density_'...
                , strrep(num2str(den),'.','p') , '_shells_' , num2str(N) , '_t_max_'...
                , num2str(t_max),'.csv'];
            if ~(isfile(filename))
                fprintf("missing file! %s\n", filename);
                return;
            end
            mat = csvread(filename);
        else
            filename = ['All_Fractions_vs_timepqn_',num2str(pqn) , 'Density_'...
                , strrep(num2str(den),'.','p') , '_shells_' , num2str(N) , '_t_max_'...
                , num2str(t_max),'.bin'];
            if ~(isfile(filename))
                fprintf("missing file! %s\n", filename);
                return;
            end
            fid = fopen(filename, 'r');
            numRows = fread(fid, 1, 'int');
            numCols = fread(fid, 1, 'int');
            mat = fread(fid, [numRows,numCols], 'double');
            fclose(fid);
        end
        
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
        
        eAxis(1:N) = fliplr(totalE);
        eAxis(N:2*N-1) = totalE;
        
        rydAxis(1:N) = fliplr(totalRyd);
        rydAxis(N:2*N-1) = totalRyd;
        cd '..';
        return;
    end
end