curr = pwd;
cd ..;
addToPath = pwd;
addpath(addToPath);
cd Sims4Ed;
bestIterateAllShells(0.1, 200, 30:80)
