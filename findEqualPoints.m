function equalTimes = findEqualPoints()
rangeOfPQN = [38,50,63];
rangeOfBeamRadius = [1];
pow = 2; % uj
N = 20; % shells
t_max = 800; % ns
equalTimes = zeros(length(rangeOfBeamRadius),length(rangeOfPQN));
for rIndex = 1:length(rangeOfBeamRadius)
    r = rangeOfBeamRadius(1,rIndex);
    dirname = ['NewCalcs_den_' , strrep(num2str(r),'.','p')];
    cd (dirname);
    pqnIndex = 1;
    for pqn = rangeOfPQN
        filename = ['Pow_' , num2str(pow),'_pqn_' , num2str(pqn) , 'BeamRadius_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max)];
        
        [time ,totaldeac, totalRyd, eTotal] = readBeamRadiusTimePlots();
        RydEdiff = abs(totalRyd - eTotal);
        [~,minIndex]= min(RydEdiff);
        equalTimes(rIndex,pqnIndex) = time(minIndex);
        pqnIndex = pqnIndex + 1;
    end
    cd '..';
end
    function [time, totaldeac, totalRyd, totalE] = readBeamRadiusTimePlots()
        filename = ['Pow_' , num2str(pow),'_pqn_' , num2str(pqn) , 'BeamRadius_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max)];
        
        mat = csvread(['Ryd_Deac_den_',filename,'.csv']);
        time = mat(:,1);
        totaldeac = mat(:,3);
        totalRyd = mat(:,2);
        mat = csvread(['Electron_den_',filename,'.csv']);
        totalE = mat(:,2); 
    end
end