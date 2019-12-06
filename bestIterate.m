function bestIterate(density,t_max,rangeOfPQN)

% runs simulation with density in um^-3, t_max in ns

addToPath = pwd;
addpath(addToPath);

N = 20; % shells
steps = 100; %time steps

totalRyd = zeros(1);
sigma_z=1*1000; %Gaussian width in um
sigma_x=0.70*1000; %um
sigma_env=5;

dirname = ['BestCalcs_den_' , strrep(num2str(density),'.','p')];
pqnIndex = 1;
for pqn = rangeOfPQN
    filename = ['pqn_' , num2str(pqn) , 'Density0_' , strrep(num2str(density),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max)];
    [time,nden,eden,deac_n_min,deac_dr,deac_pd,Te,rx,ry,rz,vx,vy,vz,vol,y0] = startFullSim(density,pqn,N,t_max,steps,dirname,filename);
    cd (dirname);
    [totalRyd,eTotal,totaldeac] = getTotals();
    makeDenTimePlots();
    makeInnerAndOuterTimePlots()
    cd '..';
    pqnIndex = pqnIndex + 1;
end

    function [] = makeDenTimePlots()
        filename = ['pqn_' , num2str(pqn) , 'Density_' , strrep(num2str(density),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max)];
        csvwrite(['Overall_Fraction_vs_time',filename,'.csv'],[time,totalRyd,totaldeac,eTotal,Te,vol]);
    end

    function[] = makeInnerAndOuterTimePlots()
        filename = ['pqn_' , num2str(pqn) , 'Density_' , strrep(num2str(density),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max)];
        reshapedRyd = reshape(nden,numel(time),100,N); % 100 should be number of pqns considered
        reshapedRyd = sum(reshapedRyd, 2);
        innerRydShell = reshapedRyd(:,1,1);
        outerRydShell = reshapedRyd(:,1,N);
       
        innerEshell = eden(:,1);
        outerEshell = eden(:,N);
        
        csvwrite(['Inner_Fraction_vs_time',filename,'.csv'],[time, innerRydShell, innerEshell]);
        csvwrite(['Outer_Fraction_vs_time',filename,'.csv'],[time, outerRydShell,outerEshell]);
    end
        

    function [totalRyd,eTotal,totaldeac] = getTotals()
        eTotal = sum(eden.*vol,2);
        
        reshapedRyd = reshape(nden,numel(time),100,N); % 100 should be number of pqns considered
        rydPerShell = sum(reshapedRyd,2);
        rydPerShell = reshape(rydPerShell, numel(time), N);
        totalRyd = sum(rydPerShell.*vol,2);
        
        reshapedPDDeac = reshape(deac_pd,numel(time),100,N); % 100 should be number of pqns considered
        pdDeacPerShell = sum(reshapedPDDeac,2);
        pdDeacPerShell = reshape(pdDeacPerShell, numel(time), N);
        totalPDDeac = sum(pdDeacPerShell.*vol,2);
        
        reshapedNMDeac = reshape(deac_n_min,numel(time),10,N); % 10 should be number of pqns considered too low
        nmDeacPerShell = sum(reshapedNMDeac,2);
        nmDeacPerShell = reshape(nmDeacPerShell, numel(time), N);
        totalNMDeac = sum(nmDeacPerShell.*vol,2);
        
        totaldeac = (sum(deac_dr.*vol,2))+totalNMDeac+totalPDDeac;
        
        totalTotal = eTotal + totalRyd + totaldeac;
        eTotal = eTotal./totalTotal;
        totalRyd = totalRyd./totalTotal;
        totaldeac = totaldeac./totalTotal;
    end


end
