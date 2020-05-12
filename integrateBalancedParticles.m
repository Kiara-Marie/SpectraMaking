function [] = integrateBalancedParticles()
% if either electrons or rydbergs represent more than 30% of the particles,
% they will be included in the sum
equalThreshhold = 0.3;

% Initialization which you may need to edit
N = 100; % shells
rangeOfPQN = 30:80;
rangeOfDen = [0.001,0.01, 0.05, 0.1,0.5, 1];
t_max = 200;

%Initialization of things that will be used
megaMatrix = zeros(numel(rangeOfDen), numel(rangeOfPQN) + 1);
megaMatrix(:,1) = rangeOfDen';

for rIndex = 1:length(rangeOfDen)
    r = rangeOfDen(1,rIndex);
    
    % Go into the directory with the info we want
    dirname = ['C:\Users\Kiara\Documents\glw\CleanBifurcation\Results\AllShellsCalcs_den_' , strrep(num2str(r),'.','p')];
    cd (dirname);
    pqnIndex = 2;
    for pqn = rangeOfPQN
        
        %Get name of file to look in
        filename = ['All_Fractions_vs_timepqn_',num2str(pqn) , 'Density_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max),'.csv'];
        
        if ~(isfile(filename))
            fprintf("missing file! %s\n", filename);
            continue;
        end
        % Get values from file
        megaMatrix(rIndex, pqnIndex) = getIntegralOfBalanced(filename, N, equalThreshhold);
        pqnIndex = pqnIndex + 1;
    end
end
    cd '..'
    fileToWrite = ['May12IntegralCalc_shells_' , num2str(N) , '_t_max_' ,num2str(t_max),'.csv' ];
    cHeader = sprintfc('%d',rangeOfPQN);
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    header = cell2mat(commaHeader); %cHeader in text with commas
    
    %write header to file
    fid = fopen(fileToWrite,'w');
    fprintf(fid, ",");
    fprintf(fid,"%s\n",header);
    fclose(fid);
    %write data to end of file
    dlmwrite(fileToWrite,megaMatrix,'-append');
end

function [result] = getIntegralOfBalanced(filename, N, balancedThreshold)
% matrix is organized [times,totalRyd,totaldeac,totalE,Te,vol]
%                      1        N         N       N    1   N
result = 0;
mat = csvread(filename);
totalRyd = mat(:,2:N+1);
totalElectrons = mat(:,N*2+2:3*N+1);

justBalancedRyd = totalRyd((totalRyd >= balancedThreshold) & (totalRyd <= (1 - balancedThreshold)));
justBalancedElectrons = totalElectrons((totalElectrons >= balancedThreshold) & (totalElectrons <= (1 - balancedThreshold)));

summedRyd = sum(justBalancedRyd, 1);
result = result + sum(summedRyd, 1);

summedElectrons = sum(justBalancedElectrons,1);
result = result + sum(summedElectrons, 1);

end
