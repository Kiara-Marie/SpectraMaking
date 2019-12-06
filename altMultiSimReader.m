% Read .csv files with shell model output at various peak densities
function [] = altMultiSimReader()
rangeOfDen = ["0p03","0p05","0p1","0p2","0p4","0p6"];
rangeOfDen = fliplr(rangeOfDen);
whichShell = 30;
%select an input .csv file
pathPrefix = "C:\Users\Kiara\Documents\glw\CleanBifurcation\Results\Oct14\";
pathSuffix = "BestCalcs_den_0p1\Nov6_ShellThirtyDataConcat_Den_0p1_shells_100_t_max_800.csv";
betweenOffset = 2;
megaFigure = figure();
megaRFigure = figure();
megaEFigure = figure();
for currD = 1:length(rangeOfDen)
    rho = rangeOfDen(currD);
    currPathSuffix = strrep(pathSuffix, "0p1", rho);
    filepath = strcat(pathPrefix,currPathSuffix);
    % specify density
    dens = extractBetween(filepath,'den_','\');
    if ~(isfile(filepath))
            filepath = extractBetween(filepath,'','t_max_');
            filepath = strcat(filepath, "t_max_350.csv")
    end
    if (~isfile(filepath))
        "BROKEN"
        return;
    end
    
    %strip header fromn .csv file
    
    OutputMatrix = csvread(filepath,2,0);
    PQNtable = csvread(filepath,0,0,[0,0,0,size(OutputMatrix,2)-1]);
    
    %create vector of sequential principal quantum numbers
    
    PQNvector = unique(PQNtable);
    minN = PQNvector(1);
    maxN = 75;
    
    %make plot label
    
    den = strrep(dens,"p",".");
    
    
    pltlab = strcat("\rho = ", den,"\mum^{-3}, n_0 = ", num2str(minN), " to ", num2str(maxN));
    
    timeToCheck=120; % ns

    
    m=0 ;
    
    for n = 1:6:((6*(maxN-minN))+1)
        m = m+1 ;
        time_full = OutputMatrix(:,n);
        Ryd_t_full=OutputMatrix(:,n+1);
        
        %strip away zeros from OutputMatrix
        
        time = [0; nonzeros(time_full)];
        Ryd_t = [nonzeros(Ryd_t_full)];
        
        
        idx = binarySearch(time,timeToCheck);
        Stime = time(idx);
        
        SRyd_t(m) = Ryd_t(idx);
        
    end
    
    m = 0 ;
    
    for n = 1:6:((6*(maxN-minN))+1)
        m = m + 1 ;
        time_full = OutputMatrix(:,n);
        electrons_full=OutputMatrix(:,n+3);
        
        %strip away zeros from OutputMatrix
        
        time = [0; nonzeros(time_full)];
        electrons = [nonzeros(electrons_full)];
        
        %find the index for a time set to 600 ns divided by the density in
        %micrometers^-3 (longer time for quench to begin at lower density)
        
        %idx = binarySearch(time,600/str2num(den));
        
        idx = binarySearch(time,timeToCheck);
        Stime = time(idx);
        
        Selectrons(m) = electrons(idx);
        
    end
    
    %plot a figure of the product of the Rydberg and electron <densities> at an
    %evolution time timat varies with density as
    
    E_b = -109735./(PQNvector.^2);
    
    
    [Rlineshape,omega] = makeLineshape(-SRyd_t);
    figure(megaRFigure);
    hold on;
    plot(-omega,(Rlineshape+(betweenOffset*currD)),'DisplayName',strcat("\rho_{0} = ",den,"\mum^{-3}"))
    
    
    [Elineshape,omega] = makeLineshape(-Selectrons);
    figure(megaEFigure);
    hold on;
    plot(-omega,(Elineshape+(betweenOffset*currD)),'DisplayName',strcat("\rho_{0} = ",den,"\mum^{-3}"))
    
    intensity = -Selectrons.*SRyd_t;
    [lineshape,omega] = makeLineshape(intensity);
    figure(megaFigure);
    hold on;
    plot(-omega,(lineshape+(betweenOffset*currD)),'DisplayName',strcat("\rho_{0} = ",den,"\mum^{-3}"))
    
    
    
end

figure(megaEFigure);
title(strcat("Electron Fraction at Time ",num2str(timeToCheck)," ns - Shell", ...
num2str(whichShell)));
yticklabels([]);
xticklabels(["85","82","77","55","49","30","26","23","0"]);
% from https://www.mathworks.com/matlabcentral/answers/134118-y-axis-only-absolute-values
legend('Location','northeastoutside');
ylabel('Intensity', 'FontSize', 16)
xlabel('Associated Principal Quantum Number', 'FontSize', 16)

figure(megaRFigure);
title(strcat("Rydberg Fraction at Time ",num2str(timeToCheck)," ns - Shell ", num2str(whichShell)));
xticklabels(["85","82","77","55","49","30","26","23","0"]);
yticklabels([]);
%set(gca,'xticklabel',num2str(abs(get(gca,'xtick').')))
legend('Location','northeastoutside');
ylabel('Intensity', 'FontSize', 16)
xlabel('Associated Principal Quantum Number', 'FontSize', 16)

figure(megaFigure);
title(strcat("Product Fraction at Time ",num2str(timeToCheck),"ns - Shell",num2str(whichShell)));
xticklabels(["85","82","77","55","49","30","26","23","0"]);
yticklabels([]);
set(gca,'xticklabel',num2str(abs(get(gca,'xtick').')))
legend('Location','northeastoutside');
ylabel('Intensity', 'FontSize', 16)
xlabel('Associated Principal Quantum Number', 'FontSize', 16)
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

function [lineshape,omega] = makeLineshape(Intensity)
    sigma = 0;
    q = 10;
    omega =  -80:0.01:-1;
    %allN = -80:0.01:0;
    %omega = -109735./(allN.^2);
    sigma = zeros(size(omega));
    lineshape = zeros(size(omega));
    
    
    nn = 1;
    for n = minN:1:maxN
        omega_0 = -109735/(n^2);
        HalfGamma(nn) = 9120/(n^3);
        for m = 1:length(omega)
            epsilon = (omega(m) - omega_0)/HalfGamma(nn);
            sigma(m) = Intensity(nn)*((q + epsilon)^2)/(1 + epsilon^2);
        end
        lineshape = lineshape + sigma;
        nn = nn + 1;
    end
    
    offset = lineshape(1);
    
    lineshape = lineshape - offset;
    
    lineshape=lineshape./min(lineshape);
    
end

end

