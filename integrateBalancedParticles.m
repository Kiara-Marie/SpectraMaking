function [fileToWrite] = integrateBalancedParticles(t_begin, equalThreshhold)
% if both electrons and rydbergs represent more than this proportion
% of the particles in their own shell they will be included in the sum

% Initialization which you may need to edit
N = 100; % shells
rangeOfPQN = 30:79;
rangeOfDen = [0.01, 0.1, 0.2, 0.4, 0.6, 0.8, 1, 1.5];
t_max = 200;


%Initialization of things that will be used
megaMatrix = zeros(numel(rangeOfDen), numel(rangeOfPQN) + 1);
megaMatrix(:,1) = rangeOfDen';

for rIndex = 1:length(rangeOfDen)
    r = rangeOfDen(1,rIndex);
    
    % Go into the directory with the info we want
    dirname = ['.\KillPenning_den_'...
        , strrep(num2str(r),'.','p')];
    cd (dirname);
    pqnIndex = 2;
    for pqn = rangeOfPQN
        
        %Get name of file to look in
        filename = ['All_Fractions_vs_timepqn_',num2str(pqn) , ...
            'Density_' , strrep(num2str(r),'.','p') , '_shells_' , ...
            num2str(N) , '_t_max_' , num2str(t_max),'.bin'];
        
        if ~(isfile(filename))
            fprintf("missing file! %s\n", filename);
            continue;
        end
        % Get values from file
        megaMatrix(rIndex, pqnIndex) = getIntegralOfBalanced(filename, N, equalThreshhold, t_begin);
        pqnIndex = pqnIndex + 1;
    end
end
cd '..'
fileToWrite = ['KillPenningCalcs_p_balance_'...
    ,strrep(num2str(equalThreshhold),'.','p')...
    , '_t_begin_' , num2str(t_begin), '.csv' ];
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

function [result] = getIntegralOfBalanced(filename, N, balancedThreshold, t_begin)
% matrix is organized [times,totalRyd,totaldeac,totalE,Te,vol]
%                      1        N         N       N    1   N
result = 0;
fid = fopen(filename, 'r');
numRows = fread(fid, 1, 'int');
numCols = fread(fid, 1, 'int');
mat = fread(fid, [numRows,numCols], 'double');
fclose(fid);
times = mat(:,1);


[t_begin_index,~] = binarySearch(times,t_begin);

times = times(t_begin_index:end);

dTimes = zeros(length(times),1);
dTimes(2:end) = times(2:end) - times(1:end-1);
dTimes(1) = dTimes(2);
dTimesMat = repelem(dTimes,1,N);

totalRyd = mat(t_begin_index:end,2:N+1);
totalDeac = mat(t_begin_index:end,N+2:N*2+1);
totalElectrons = mat(t_begin_index:end,N*2+2:3*N+1);

totalByShell = totalRyd + totalElectrons + totalDeac;

rydProportionOfShell = totalRyd./totalByShell;
eProportionOfShell = totalElectrons./totalByShell;

indicesToInclude = (rydProportionOfShell >= balancedThreshold) & (eProportionOfShell >= balancedThreshold);

justBalancedRyd = totalRyd(indicesToInclude);
justBalancedElectrons = totalElectrons(indicesToInclude);
dTimesFactor = dTimesMat(indicesToInclude);

justBalancedRyd = justBalancedRyd .* dTimesFactor;
summedRyd = sum(justBalancedRyd, 1);
result = result + sum(summedRyd, 1);

justBalancedElectrons = justBalancedElectrons .* dTimesFactor;
summedElectrons = sum(justBalancedElectrons,1);
result = result + sum(summedElectrons, 1);

end
