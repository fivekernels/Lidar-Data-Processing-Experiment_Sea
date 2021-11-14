clear variables;

rawFilePath = './raw-data/窄视场信号/';
% rawFileName = 'N1118-224101_40.txt';


totalFilesInfo = dir([rawFilePath '*.txt']);
totalFilesName = totalFilesInfo(:).name;
countFile = size(totalFilesInfo, 1);

totalParallel = zeros(1, RawSeaData.parallel532_row(2) - RawSeaData.parallel532_row(1) + 1);
totalCross = zeros(1, RawSeaData.cross532_row(2) - RawSeaData.cross532_row(1) + 1);
tic
%代码块
for fileIndex = 1:countFile
    fprintf("fileIndex = %d\n", fileIndex);
    rawFileName = totalFilesInfo(fileIndex).name;
    
    oneRawSeaData = RawSeaData(rawFilePath, rawFileName);
    [oneParallel532_Val, oneCross532_Val] = oneRawSeaData.method1();
    
    totalParallel = totalParallel + oneParallel532_Val;
    totalCross = totalCross + oneCross532_Val;
end
toc
% disp(['运行时间: ',num2str(toc)]);

