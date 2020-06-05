rangeOfT = [0, 10, 15, 30]; 
rangeOfP = [0.01, 0.05, 0.1, 0.25];
for t_begin = rangeOfT
    for balance_point = rangeOfP
        createdFile = integrateBalancedParticles(t_begin, balance_point);
        makeSpectrumPlotFromSimpleInput(createdFile);
    end
end