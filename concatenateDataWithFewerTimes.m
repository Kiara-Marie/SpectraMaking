function [] =  concatenateDataWithFewerTimes(desiredPoints)

% Initialization which you may need to edit
pow = 2; % uj (Still needed because it is in the original filenames)
N = 100; % shells
rangeOfPQN = 21:75;
rangeOfDen = ["0p03","0p05","0p1","0p2","0p4","0p6"];
rangeOfEndTime = [350,350,350,350,350,350]; %tmax for each in ns
whichShell = 30;


for rIndex = 1:length(rangeOfDen)
    %Initialization of things that will be used
    megaMatrix = zeros(10000,numel(rangeOfPQN)*6);
    
    r = rangeOfDen(1,rIndex);
    t_max = rangeOfEndTime(1,rIndex);
    
    % Go into the directory with the info we want
    dirname = ['C:\Users\Kiara\Documents\glw\CleanBifurcation\Results\Oct14\BestCalcs_den_' , strrep(num2str(r),'.','p')];
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
    fileToWrite = ['Nov6_ShellThirtyDataConcat_Den_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' ,num2str(new_t),'.csv' ];
    
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
        totaldeac(1,1) = mat(1,whichShell+N+2);
        totalE(1,1) = mat(1,whichShell+2*N+2);
        Te(1,1) = mat(1,3*N+2);
        vol(1,1) = mat(1,3*N+3);
       
        for i = 2:length(allTimes)
            currT = allTimes(i);
            if (currT - prevT > gap)
                time(toFill,1) = mat(i,1);
                totalRyd(toFill,1) = mat(i,whichShell+1);
                totaldeac(toFill,1) = mat(i,whichShell+N+1);
                totalE(toFill,1) = mat(i,whichShell+2*N+1);
                Te(toFill,1) = mat(i,whichShell+3*N+1);
                vol(toFill,1) = mat(i,whichShell+3*N+2);
                toFill = toFill + 1;
                prevT = currT;
            end
        end
    end
end