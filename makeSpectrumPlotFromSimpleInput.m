function [] = makeSpectrumPlotFromSimpleInput(filename)
mat = csvread(filename);

PQNvector = mat(1,2:end);
PQNvector = PQNvector(PQNvector ~= 0);

minN = PQNvector(1);
maxN = PQNvector(end);
%minN = 60;
%maxN = 80;
betweenOffset = 200;
%plot a figure of the product of the Rydberg and electron <densities> at an
%evolution time timat varies with density as

E_b = -109735./(PQNvector.^2);
sortedDens = sort(mat(:,1));
for denIndex = 2:length(mat(:,1)) 
    intensity = mat(denIndex,2:end);
    den = mat(denIndex,1);
    xaxis = mat(1,2:end);
    xaxis = repelem(xaxis,5);
    %[lineshape,omega] = makeLineshape(intensity');
    %lineshape = lineshape * -1;
    %plot(-omega,(lineshape+(betweenOffset*denIndex)),'DisplayName',strcat("\rho_{0} = ",strrep(num2str(den),'.','p'),"\mum^{-3}"))
    %lineshape = makeStupidLineshape(intensity);
    [lineshape,omega] = makeLineshape(intensity);
    denPos = find(sortedDens == den);
    plot(omega,(lineshape-(betweenOffset*denPos)),'DisplayName',strcat("\rho_{0} = ",num2str(den),"\mum^{-3}"))
    hold on;
end
title("Predicted intensity");
xticklabels([]);
yticklabels([]);
%set(gca,'xticklabel',num2str(abs(get(gca,'xtick').')))
legend('Location','northeastoutside');
ylabel('Intensity', 'FontSize', 16)
%xlabel('Approx Associated Principal Quantum Number', 'FontSize', 16)
newFileName = 'NormIntensity' + strrep(filename, '.csv', '.svg');
saveas(gcf, newFileName);
    function [lineshape,omega] = makeLineshape(Intensity)
        Intensity = Intensity / max(Intensity);
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
        
        %lineshape=lineshape / max(lineshape);
        
    end

    function [lineshape] = makeStupidLineshape(intensity)
        lineshape = zeros(length(intensity)*5,1);
        lineshape(1:5:length(lineshape)) = intensity;
        lineshape = lineshape / max(lineshape);
           
    end

end

