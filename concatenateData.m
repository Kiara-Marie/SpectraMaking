function [] =  concatenateData()

% Initialization which you may need to edit
pow = 2; % uj (Still needed because it is in the original filenames)
N = 20; % shells
rangeOfPQN = 21:80;
rangeOfDen = [0.6];
rangeOfEndTime = [800 800 800 800 800 800 800 800 800 800]; %tmax for each in ns


for rIndex = 1:length(rangeOfDen)
    %Initialization of things that will be used
    megaMatrix = zeros(10000,numel(rangeOfPQN)*6);
    
    r = rangeOfDen(1,rIndex);
    t_max = rangeOfEndTime(1,rIndex);
    
    % Go into the directory with the info we want
    dirname = ['C:\Users\Kiara\Documents\glw\Sims4Ed\ts\TwoSigma_den_' , strrep(num2str(r),'.','p')];
    cd (dirname);
    pqnIndex = 1;
    for pqn = rangeOfPQN
        
        %Get name of file to look in
        filename = ['Overall_Fraction_vs_timepqn_',num2str(pqn) , 'Density_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max),'.csv'];
        new_t = t_max;
        % Get values from file
        [time ,totaldeac, totalRyd, eTotal,Te,vol] = readDenTimePlots();
        start = (pqnIndex*6)-5;
        fin = ((pqnIndex+1)*6)-6;
        rows = numel(time);
        megaMatrix(1:rows,start:fin) = [time ,totaldeac, totalRyd, eTotal,Te,vol];
        
        pqnIndex = pqnIndex + 1;
    end
    fileToWrite = ['TSDataConcat_Den_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' ,num2str(new_t),'.csv' ];
    
    cHeader = repelem(rangeOfPQN,6);
    cHeader = sprintfc('%d',cHeader);
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    headerOne = cell2mat(commaHeader); %cHeader in text with commas
    
    cHeader = {'Time' 'Rydbergs' 'Deactivated' 'Electrons' 'Electron Temperature' 'Volume'}; 
    cHeader = repmat(cHeader,1,numel(rangeOfPQN));
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    headerTwo = cell2mat(commaHeader); %cHeader in text with commas
    
    %write header to file
    fid = fopen(fileToWrite,'w');
    fprintf(fid,"%s\n",headerOne);
    fprintf(fid,'%s\n',headerTwo);
    fclose(fid);
    %write data to end of file
    dlmwrite(fileToWrite,megaMatrix,'-append');
    cd '../../../Sims4K';
end

    function [time,totalRyd,totaldeac,totalE,Te,vol] = readDenTimePlots()
        
        
        mat = csvread([filename]);
        time = mat(:,1);
        totalRyd = mat(:,2);
        totaldeac = mat(:,3);
        totalE = mat(:,4);
        Te = mat(:,5);
        vol = mat(:,6);
    end
end