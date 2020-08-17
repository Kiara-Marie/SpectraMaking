function bestIterateAllShells(density,t_max,rangeOfPQN)
sumOverShells = false;
fractionExpressedOutOfTrueTotal = true;
savedAsFractions = false;

% runs simulation with density in um^-3, t_max in ns

addToPath = pwd;
addpath(addToPath);

N = 100; % shells
steps = 300; %time steps


totalRyd = zeros(1);
sigma_z=420; %Gaussian width in um
sigma_x=750; %um
sigma_env=5;

dirname = ['NewRESMOTest_den_' , strrep(num2str(density),'.','p')];
pqnIndex = 1;
for pqn = rangeOfPQN
    filename = ['pqn_' , num2str(pqn) , 'Density0_' , strrep(num2str(density),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max)];
    [time,nden,eden,deac_n_min,deac_dr,deac_pd,Te,rx,ry,rz,vx,vy,vz,vol,y0] = startFullSim(density,pqn,N,t_max,steps,dirname,filename,sigma_z,sigma_x);
    cd (dirname);
    [totalRyd,eTotal,totaldeac] = getTotals();
    %     makeInnerAndOuterTimePlots()
    makeDenTimePlots();
    cd '..';
    pqnIndex = pqnIndex + 1;
end

    function [] = makeDenTimePlots()
        toWrite = [time,totalRyd,totaldeac,eTotal,Te,vol];
        numCols = size(toWrite);
        numCols = numCols(2);
        filename = ['pqn_', num2str(pqn), ...
            'Density_' , strrep(num2str(density),'.','p') , ...
            '_shells_' , num2str(N) , '_t_max_' , num2str(t_max)];
        fileId = fopen(['All_Fractions_vs_time',filename,'.bin'],'w');
        fwrite(fileId,length(time),'int');
        fwrite(fileId,numCols,'int');
        fwrite(fileId,toWrite,'double');
        fclose(fileId);
    end

    function [totalRyd,eTotal,totaldeac] = getTotals()
        
        reshapedRyd = reshape(nden,numel(time),100,N); % 100 should be number of pqns considered
        rydPerShell = sum(reshapedRyd,2);
        rydPerShell = reshape(rydPerShell, numel(time), N);
        
        reshapedPDDeac = reshape(deac_pd,numel(time),100,N); % 100 should be number of pqns considered
        pdDeacPerShell = sum(reshapedPDDeac,2);
        pdDeacPerShell = reshape(pdDeacPerShell, numel(time), N);
        
        reshapedNMDeac = reshape(deac_n_min,numel(time),10,N); % 10 should be number of pqns considered too low
        nmDeacPerShell = sum(reshapedNMDeac,2);
        nmDeacPerShell = reshape(nmDeacPerShell, numel(time), N);
        
        totaldeac = deac_dr+nmDeacPerShell+pdDeacPerShell;
        
        if sumOverShells
            rydPerShell = sum(rydPerShell,2);
            totaldeac = sum(totaldeac,2);
            eden = sum(eden,2);
        end
        
        totalTotal = eden + rydPerShell + totaldeac;
        if (fractionExpressedOutOfTrueTotal)
            totalTotal = sum(totalTotal, 2);
        end
        
        if ~savedAsFractions
           totalTotal = 1;
        end
        
        eTotal = eden./totalTotal;
        totalRyd = rydPerShell./totalTotal;
        totaldeac = totaldeac./totalTotal;
        
        
    end


end
