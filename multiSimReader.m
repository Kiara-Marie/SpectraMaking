% Read .csv files with shell model output at various peak densities

rangeOfDen = ["0p01","0p03","0p05","0p2","0p6","1"];
rangeOfDen = fliplr(rangeOfDen);
%select an input .csv file
pathPrefix = "C:\Users\Kiara\Documents\glw\Sims4Ed\KP\";
pathSuffix = "KP_den_0p01\UniformDataConcat_Den_0p01_shells_20_t_max_350.csv";
betweenOffset = 2;
megaFigure = figure();
%title(pltlab, 'FontSize', 16)
%ylabel('Intensity', 'FontSize', 16)
%xlabel('Electron Binding Energy', 'FontSize', 16)
for currD = 1:length(rangeOfDen)
    rho = rangeOfDen(currD);
    currPathSuffix = strrep(pathSuffix, "0p01", rho);
    filepath = strcat(pathPrefix,currPathSuffix);
    % specify density
    dens = extractBetween(filepath,'den_','\');
    
    %strip header fromn .csv file
    
    OutputMatrix = csvread(filepath,2,0);
    PQNtable = csvread(filepath,0,0,[0,0,0,size(OutputMatrix,2)-1]);
    
    %create vector of sequential principal quantum numbers
    
    PQNvector = unique(PQNtable);
    minN = PQNvector(1);
    maxN = PQNvector(end);
    
    %make plot label
    
    den = strrep(dens,"p",".");
    
    
    pltlab = strcat("\rho = ", den,"\mum^{-3}, n_0 = ", num2str(minN), " to ", num2str(maxN));
    
    timeToCheck=120; % ns
    
   % Rydfig = figure;
    
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
        
        %plot(time,Ryd_t)
        
        %title(pltlab, 'FontSize', 16)
        %xlabel('Time', 'FontSize', 16)
        %ylabel('Rydberg Density', 'FontSize', 16)
        
       % hold on
        
    end
    
    filename = strcat("Rydberg(t)", dens);
    %saveas(Rydfig,filename,"pdf")
    
    %elecfig = figure
    
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
        
        
        %plot(time,electrons)
        
        %title(pltlab, 'FontSize', 16)
        %xlabel('Time', 'FontSize', 16)
        %ylabel('Electron Density', 'FontSize', 16)
        
        %hold on
        
    end
    
    filename = strcat("electron(t)", dens);
    %saveas(elecfig,filename,"pdf")
    
    %eTemp = figure
    
    for n = 1:6:((6*(maxN-minN))+1)
        
        time_full = OutputMatrix(:,n);
        Te_full=OutputMatrix(:,n+4);
        
        %strip away zeros from OutputMatrix
        
        time = [0; nonzeros(time_full)];
        Te = [nonzeros(Te_full)];
        
        %plot(time,Te)
        
        %title(pltlab, 'FontSize', 16)
        %xlabel('Time', 'FontSize', 16)
        %ylabel('Electron Temperature', 'FontSize', 16)
        
       % hold on
        
    end
    
    filename = strcat("Te(t)", dens);
    %saveas(eTemp,filename,"pdf")
    
    
    
    %plot a figure of the product of the Rydberg and electron <densities> at an
    %evolution time timat varies with density as
    
    %predIten = figure
    
    %PQN_vec = (1:m)+37;
    
    E_b = -109735./(PQNvector.^2);
    
    Intensity = -Selectrons.*SRyd_t;
    
    %plot(E_b,Intensity)
    
    %title(pltlab, 'FontSize', 16)
    %ylabel('Intensity', 'FontSize', 16)
    %xlabel('Electron Binding Energy', 'FontSize', 16)
    
    filename = strcat("Product(Eb)", dens);
    %saveas(predIten,filename,"pdf")
    
    %figure;
    %plot(E_b,Selectrons)
   % hold on
    %plot(E_b,SRyd_t)
    
    sigma = 0;
    q = 10;
    omega = -80:0.01:0;
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
    
    %spectrum = figure
    
    %plot(omega,lineshape)
    
    %title(pltlab, 'FontSize', 16)
    %ylabel('Intensity', 'FontSize', 16)
    %xlabel('Electron Binding Energy', 'FontSize', 16)
    
  %  hold on
    
    
    % xx0p83 = 2e07./x0p83 - 30542.3;
    
    
    %plot(xx0p83,2*y0p83)
    %%title('x2p47', 'FontSize', 16)
    
%     filename = strcat("w2Spect", dens)
%     saveas(spectrum,filename,"fig")
%     saveas(spectrum,filename,"emf")
  
    figure(megaFigure);
    hold on;
    plot(-1*omega,(lineshape+(betweenOffset*currD)),'DisplayName',strcat("\rho_{0} = ",den,"\mum^{-3}"))
    
end
title(strcat("Product of Rydberg and Electron Fraction at Time",num2str(timeToCheck),"ns"));
legend('Location','northeastoutside');
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
