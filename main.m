clear variables;

if 0 % 窄视场    
    rawFilePath = './raw-data/窄视场信号/';
    resulFileName = 'narrow_totalData';
else
    rawFilePath = './raw-data/宽视场信号/';
    resulFileName = 'wide_totalData';
end

resuleFilePath = './result/';

totalParallel = zeros(1, RawSeaData.parallel532_row(2) - RawSeaData.parallel532_row(1) + 1);
totalCross = zeros(1, RawSeaData.cross532_row(2) - RawSeaData.cross532_row(1) + 1);

% 尝试读取已有文件
flagFileValued = 0;
try
    lastwarn('') % Clear last warning message
    ... run code ...
    load([resuleFilePath resulFileName], getVarName(totalParallel), getVarName(totalCross));
    flagFileValued = 1;
catch
end
[warnMsg, warnId] = lastwarn;
if ~isempty(warnMsg)
    ...react to warning...
    flagFileValued = 0;
end

if flagFileValued == 0 % 读取结果失败 读取源数据
    totalFilesInfo = dir([rawFilePath '*.txt']);
    totalFilesName = totalFilesInfo(:).name;
    countFile = size(totalFilesInfo, 1);
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
    save([resuleFilePath resulFileName], getVarName(totalParallel), getVarName(totalCross));
end
