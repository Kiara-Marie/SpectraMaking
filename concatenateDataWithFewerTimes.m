function [] =  concatenateDataWithFewerTimes(desiredPoints)

% Initialization which you may need to edit
N = 100; % shells
NumSavedShells = 1;
rangeOfPQN = 30:32;
rangeOfDen = ["0p01"];
rangeOfEndTime = [200]; %tmax for each in ns
whichShell = 0; %zero index


for rIndex = 1:length(rangeOfDen)
    %Initialization of things that will be used
    megaMatrix = zeros(desiredPoints,numel(rangeOfPQN)*6);
    
    r = rangeOfDen(1,rIndex);
    t_max = rangeOfEndTime(1,rIndex);
    
    % Go into the directory with the info we want
    dirname = ['C:\Kevin\Matlab\Spectra_Simulation\SpectraMaking\Results\TestCalcs_den_' , strrep(num2str(r),'.','p')];
    cd (dirname);
    pqnIndex = 1;
    for pqn = rangeOfPQN
        
        %Get name of file to look in
        filename = ['All_Fractions_vs_timepqn_',num2str(pqn) , 'Density_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max),'.csv'];
        if ~(isfile(filename))
            new_t = 800;
        else
            new_t = t_max;
        end
        
        filename = ['All_Fractions_vs_timepqn_',num2str(pqn) , 'Density_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(new_t),'.csv'];
        if ~(isfile(filename))
            fprintf("missing file! %s\n", filename);
            continue;
        end
        % Get values from file
        [time ,totaldeac, totalRyd, eTotal,Te,vol] = readDenTimePlots();
        start = (pqnIndex*6)-5;
        fin = ((pqnIndex+1)*6)-6;
        rows = numel(time);
        megaMatrix(1:rows,start:fin) = [time ,totaldeac, totalRyd, eTotal,Te,vol];
        
        pqnIndex = pqnIndex + 1;
    end
    fileToWrite = ['May3rd_SumShells_Den_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' ,num2str(new_t),'.csv' ];
    
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
end

    function [time,totalRyd,totaldeac,totalE,Te,vol] = readDenTimePlots()
        
        mat = csvread([filename]);
        allTimes = mat(:,1);
        if length(allTimes) == desiredPoints
            time = allTimes;
        elseif length(allTimes) < desiredPoints
            msg = 'Not enough points';
            error(msg);
        else
            [time,totalRyd,totaldeac,totalE,Te,vol]= readDenTimePlotsWithTooManyPoints();
        end
        time(:,:) = mat(:,1);
        totalRyd(:,:) = mat(:,whichShell+2);
        totaldeac(:,:) = mat(:,whichShell+NumSavedShells+2);
        totalE(:,:) = mat(:,whichShell+2*NumSavedShells+2);
        Te(:,:) = mat(:,3*NumSavedShells+2);
        vol(:,:) = mat(:,3*NumSavedShells+3);
    end

    function [time,totalRyd,totaldeac,totalE,Te,vol]= readDenTimePlotsWithTooManyPoints()
        
        gap = (max(allTimes) - min(allTimes))/desiredPoints;
        prevT = allTimes(1);
        toFill = 1;
        
        time = zeros(desiredPoints,1);
        totalRyd = zeros(desiredPoints,1);
        totaldeac = zeros(desiredPoints,1);
        totalE = zeros(desiredPoints,1);
        Te = zeros(desiredPoints,1);
        vol = zeros(desiredPoints,1);
        
        time(1,1) = mat(1,1);
        totalRyd(1,1) = mat(1,whichShell+2);
        totaldeac(1,1) = mat(1,whichShell+NumSavedShells+2);
        totalE(1,1) = mat(1,whichShell+2*NumSavedShells+2);
        Te(1,1) = mat(1,3*NumSavedShells+2);
        vol(1,1) = mat(1,3*NumSavedShells+3);
        
        for i = 2:length(allTimes)
            currT = allTimes(i);
            if (currT - prevT > gap)
                time(toFill,1) = mat(i,1);
                totalRyd(toFill,1) = mat(i,whichShell+1);
                totaldeac(toFill,1) = mat(i,whichShell+NumSavedShells+1);
                totalE(toFill,1) = mat(i,whichShell+2*NumSavedShells+1);
                Te(toFill,1) = mat(i,whichShell+3*NumSavedShells+1);
                vol(toFill,1) = mat(i,whichShell+3*NumSavedShells+2);
                toFill = toFill + 1;
                prevT = currT;
            end
        end
    end
end