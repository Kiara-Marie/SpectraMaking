% Read .csv files with shell model output at various peak densities
function [] = altMultiSimReader()
rangeOfDen = ["0p01"];
rangeOfDen = fliplr(rangeOfDen);
whichShell = 1;
%select an input .csv file
pathPrefix = "C:\Kevin\Matlab\Spectra_Simulation\SpectraMaking\Results\";
pathSuffix = "TestCalcs_den_0p1\May3rd_SumShells_Den_0p01_shells_100_t_max_200.csv";
betweenOffset = 0;
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
            filepath = strcat(filepath, "t_max_350.csv");
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
    maxN = 32;
    
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

function [lineshape,omega] = makeLineshape(Intensity)
    sigma = 0;
    q = 10;
    omega =  -80:0.01:-1;
    %allN = -80:0.01:0;
    %omega = -109735./(allN.^2);
    sigma = zeros(size(omega));
    lineshape = zeros(size(omega));
    
    
    nn = 1;
    for currN = minN:1:maxN
        omega_0 = -109735/(currN^2);
        HalfGamma(nn) = 9120/(currN^3);
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

