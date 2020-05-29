rangeOfDen = [0.01, 0.1, 0.2, 0.4, 0.6, 0.8, 1, 1.5];
folderPrefix = "MoreTimesCalcs_den_";
for den = rangeOfDen
    folderName = folderPrefix + strrep(num2str(den), '.', 'p');
    allFiles = dir(folderName);
    cd(folderName);
    for k = 1:length(allFiles)
        fileName = allFiles(k).name;
        fprintf(1, 'Now reading %s\n', fileName);
        if (fileName == "." || fileName == ".." || contains(fileName, "bin"))
            continue
        end
        mat = csvread(fileName);
        [numRows,numCols] = size(mat);
        [fileId, msg] = fopen(strrep(fileName, '.csv', '.bin'),'w');
        fwrite(fileId,numRows,'int');
        fwrite(fileId,numCols,'int');
        fwrite(fileId,mat,'double');
        fclose(fileId);
    end
    cd ..;
end



