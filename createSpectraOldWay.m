function [eDenAtTimeXForR, rydDenAtTimeXForR] =  createSpectraOldWay()

% Initialization which you may need to edit
save = 0; % because by default the figures will not be saved. 
            % change to 1 in order to save figures automatically
pow = 2; % uj (Still needed because it is in the original filenames)
N = 20; % shells
rangeOfPQN = 20:80;
rangeOfDen = ["0p01","0p05","0p3","0p4","1"];
rangeOfDen = fliplr(rangeOfDen);
rangeOfEndTime = [350 350 350 350 350 350 350 350 350]; %tmax for each in ns
rangeOfTime = [90 120];

% Constants
Ryd = 10973731.6; % 1/m
h = 6.62607004*10^-34; % m2 kg / s
c = 299792458; % m/s

eDenAtTimeXForR = zeros(length(rangeOfPQN),length(rangeOfTime),length(rangeOfDen));
rydDenAtTimeXForR = zeros(length(rangeOfPQN),length(rangeOfTime),length(rangeOfDen));

% Convert pqn to binding energy
rangeOfEb = ones(size(rangeOfPQN));
rangeOfEb = rangeOfEb.*Ryd.*h.*c;
rangeOfEb = rangeOfEb./(rangeOfPQN.^2); % J
cd '../../Sims4K//';
for rIndex = 1:length(rangeOfDen)
    r = rangeOfDen(1,rIndex);
    t_max = rangeOfEndTime(1,rIndex);
    
    % Go into the directory with the info we want
    dirname = ['BestCalcs_den_' , strrep(num2str(r),'.','p')];
    cd (dirname);
    pqnIndex = 1;
    for pqn = rangeOfPQN
        
        %Get name of file to look in
        filename = ['Overall_Fraction_vs_timepqn_',num2str(pqn) , 'Density_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(t_max),'.csv'];
        if ~(isfile(filename))
            new_t = 800;
        else 
            new_t = t_max;
        end
        
         filename = ['Overall_Fraction_vs_timepqn_',num2str(pqn) , 'Density_' , strrep(num2str(r),'.','p') , '_shells_' , num2str(N) , '_t_max_' , num2str(new_t),'.csv'];
        
        % Get values from file
        [time ,totaldeac, totalRyd, eTotal] = readDenTimePlots();
        
        
        
        timeIndex = 1;
        for currTime = rangeOfTime
            
            % Figure out what time index has the time of interest, and
            % record eden and rden and desired times
            indexToLook = binarySearch(time,currTime);
            eDenAtTimeXForR(pqnIndex,timeIndex,rIndex) = eTotal(indexToLook,1);
            rydDenAtTimeXForR(pqnIndex,timeIndex,rIndex) = totalRyd(indexToLook,1);
            timeIndex = timeIndex + 1;
        end
        pqnIndex = pqnIndex + 1;
    end
    cd '..';
end
% make plots
makeDenAtTimeXVsPQNPlots(eDenAtTimeXForR, 'e');
makeDenAtTimeXVsPQNPlots(rydDenAtTimeXForR, 'ryd');
makeDenAtTimeXVsPQNPlots(eDenAtTimeXForR, 'pdt',rydDenAtTimeXForR);


% Get data from file
    function [time, totaldeac, totalRyd, totalE] = readDenTimePlots()
        %[time,totalRyd,totaldeac,eTotal,Te,vol]
        mat = csvread([filename]);
        time = mat(:,1);
        totalRyd = mat(:,2);
        totaldeac = mat(:,3);
        totalE = mat(:,4);
    end

    function [] = makeDenAtTimeXVsPQNPlots(matrixToPlot, type, matrix2ToPlot)
        timeIndex = 1;
        yMaxes = zeros(length(rangeOfDen),1);
        for innerTime = rangeOfTime
            figure;
            offset = 1.3;
            for rIndex = 1:length(rangeOfDen)
                currentR = rangeOfDen(1,rIndex);
                [xToPlot, yToPlot,maxY] = spaceOutWithBE();
                YMaxes(rIndex,1) = maxY;
                plot(xToPlot,yToPlot,'-', ...
                    'DisplayName',['\rho_{0} = ',num2str(currentR),'\mum^{-3}']);
                hold on;
            end
            hold off;
            legend('Location','northeastoutside');
            if (type == 'e')
                title(['Electron density at Time ',num2str(innerTime)]);
            end
            if (type == 'ryd')
                title(['Rydberg density at Time ',num2str(innerTime)]);
            end
            if (type == 'pdt')
                title(['Product of Rydberg and Electron Density at Time',num2str(innerTime)]);
            end
            xlabel('Binding Energy in J');
            ylabel('Normalized Density');
            xlim([0,2e-21]);
            yticks(1:length(rangeOfDen));
            yticklabels(YMaxes);
            fig = gcf;
           
           if(save)
               saveas(fig,[type,'DenAtTime_',num2str(innerTime),'vsR.fig']);
               saveas(fig,[type,'DenAtTime_',num2str(innerTime),'vsR.jpg']);
           end
            timeIndex = timeIndex+1;
        end
        
        
        function [yValuesToInsert,maxY] = createNormalized(matrixToPlot)
            yValuesToInsert = matrixToPlot(:,timeIndex,rIndex);
            maxY = max(yValuesToInsert);
            yValuesToInsert = yValuesToInsert/max(yValuesToInsert);
        end
        
        
        function [yValuesToInsert,maxY] = createPdt(matrixToPlot, matrix2ToPlot)
            yValues1 = matrixToPlot(:,timeIndex,rIndex);
            yValues2 = matrix2ToPlot(:,timeIndex,rIndex);
            yValues1 = yValues1/max(yValues1);
            yValues2 = yValues2/max(yValues2);
            yValuesToInsert = yValues1.*yValues2;
            maxY = max(yValuesToInsert);
        end
        
        function [xToPlot, yToPlot,maxY] = spaceOutWithBE()
            xToPlot = linspace(rangeOfEb(1,1),rangeOfEb(1,end),50*length(rangeOfEb));
            %the i-th specialXPos element is the position (in xToPlot)
            %of the i-th binding energy in the rangeOfEb,
            specialXPos = zeros(length(rangeOfEb),1);
            for bindex = 1:length(rangeOfEb)
                be = rangeOfEb(bindex);
                [specialPos,val] = binarySearch(xToPlot',be,true);
                specialXPos(bindex) = specialPos;
                xToPlot(specialPos) = be;
            end
            yToPlot = zeros(10*length(rangeOfEb),1);
            if ~exist('matrix2ToPlot','var')
                % third parameter does not exist, so default it to something
                [yToPlot(specialXPos),maxY] = createNormalized(matrixToPlot);
                yToPlot = yToPlot + offset*(rIndex-1);
            else
                [yToPlot(specialXPos),maxY] = createPdt(matrixToPlot,matrix2ToPlot);
                yToPlot = yToPlot/max(yToPlot) + offset*(rIndex-1);
            end
        end
    end
end
%%

% this function gives you the value in a sorted array closest to the one
% you are looking for
function [index,curr] = binarySearch(arr,lf,dir)
%arr = a sorted array
%lf = number you are looking for
%dir = true if the matrix is in reverse order
if(exist('dir','var'))
    arr = flip(arr,1);
end
index = round((1+length(arr))/2);
lower = 1;
upper = length(arr);

while (lower < upper)
    index = floor((lower+upper)/2);
    curr = arr(index,1);
    if (curr == lf)
        if(exist('dir','var'))
            index = length(arr) + 1 - index;
        end
        return;
    end
    if (curr > lf)
        upper = index;
    end
    
    if (curr < lf)
        lower = index +1;
    end
    
end

if (index<length(arr) && abs(arr(index+1)-lf) < abs(arr(index)-lf))
    index = index +1;
    curr = arr(index);
end
if (index>1 && abs(arr(index-1)-lf) < abs(arr(index)-lf))
    index = index -1;
    curr = arr(index);
end
if(exist('dir','var'))
    index = length(arr) + 1 - index;
end
return;
end
