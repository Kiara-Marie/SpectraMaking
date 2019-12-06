curr = pwd;
addpath(curr);
cd ../RESMO;
addToPath = pwd;
addpath(addToPath);
cd ../Results;
bestIterateAllShells(1, 350, 65:70);
cd ../SpectraMaking;
