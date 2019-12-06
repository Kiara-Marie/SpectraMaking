[timeSteps,garbage] = size(nden);
numShells = 100;
npqn = 100;
totalNDen = zeros(timeSteps,numShells);
for ii=0:numShells-1
    totalNDen(:,ii+1) = sum(nden(:,(ii*npqn+1:ii*(npqn+1))),2);
end
    