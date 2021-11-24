clear variables;

if 0 % 窄视场    
    rawFilePath = './raw-data/窄视场信号/';
    resulFileName = 'narrow_totalData_getRidNoise';
else
    rawFilePath = './raw-data/宽视场信号/';
    resulFileName = 'wide_totalData_getRidNoise';
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
    noiseRawCount = zeros(1, 2); % 去除个数 P C
    singleFileMaxIndexCount = zeros(2, 2048); % P C
    for fileIndex = 1:countFile
        fprintf("fileIndex = %d\n", fileIndex);
        rawFileName = totalFilesInfo(fileIndex).name;

        oneRawSeaData = RawSeaData(rawFilePath, rawFileName);
        [oneParallel532_Val, oneCross532_Val] = oneRawSeaData.CalParaCross();
        
        % 找单个最大值
        [~, maxParaIndex]=max(oneParallel532_Val);
        [~, maxCrossIndex]=max(oneCross532_Val);
        singleFileMaxIndexCount(1, maxParaIndex) = singleFileMaxIndexCount(1, maxParaIndex) + 1;
        singleFileMaxIndexCount(2, maxCrossIndex) = singleFileMaxIndexCount(1, maxCrossIndex) + 1;
        
        sumNoiseP = sum(oneParallel532_Val(700:end));
        sumNoiseC = sum(oneCross532_Val(600:end));
%         figure(1);
%         semilogy(oneParallel532_Val);
%         scatter(fileIndex, sumNoiseP, 'x');
%         hold on;
%         figure(2);
%         semilogy(oneCross532_Val);
%         scatter(fileIndex, sumNoiseC, 'x');
%         hold on;

        if sumNoiseP <= 1000
            totalParallel = totalParallel + oneParallel532_Val;
        else
            noiseRawCount(1) = noiseRawCount(1) + 1;
        end
        
        if sumNoiseC <= 1000
            totalCross = totalCross + oneCross532_Val;
        else
            noiseRawCount(2) = noiseRawCount(2) + 1;
        end
    end
    toc
    save([resuleFilePath resulFileName], getVarName(totalParallel), getVarName(totalCross));
end

accSeaDataParallel = AccSeaData(totalParallel, 0.1125);
accSeaDataCross = AccSeaData(totalCross, 0.1125);

% % 画单文件统计直方图
% bar(singleFileMaxIndexCount(1,350:440))
% histogram(singleFileMaxIndexCount(1,350:440),440-350+1) % 不会用...
% histfit(singleFileMaxIndexCount(1,100:600))

% 画原始信号
semilogy(accSeaDataParallel.depth_arr, accSeaDataParallel.accData);
hold on;
semilogy(accSeaDataCross.depth_arr, accSeaDataCross.accData);

semilogy(accSeaDataParallel.depthValid_arr, accSeaDataParallel.accDataValid);
hold on;
semilogy(accSeaDataParallel.depthValid_arr, accSeaDataParallel.accDataValidSmooth);

% 画pz2
pZSquareDataParallel = accSeaDataParallel.pZSquare;
pZSquareDataCross = accSeaDataCross.pZSquare;
semilogy(accSeaDataParallel.depthValid_arr(1:size(pZSquareDataParallel, 2)) - accSeaDataParallel.depthValid_arr(1), pZSquareDataParallel);
hold on;
semilogy(accSeaDataCross.depthValid_arr(1:size(pZSquareDataCross, 2)) - accSeaDataCross.depthValid_arr(1), pZSquareDataCross);

% 画klidar
kLidarParallel = accSeaDataParallel.kLidar;
kLidarCross = accSeaDataCross.kLidar;
plot(accSeaDataParallel.depthValid_arr(1:size(kLidarParallel, 2)) - accSeaDataParallel.depthValid_arr(1), kLidarParallel);
semilogy(accSeaDataParallel.depthValid_arr(1:size(kLidarParallel, 2)) - accSeaDataParallel.depthValid_arr(1), kLidarParallel);
hold on;
semilogy(accSeaDataCross.depthValid_arr(1:size(kLidarCross, 2)) - accSeaDataCross.depthValid_arr(1), kLidarCross);
% plot(accSeaDataCross.depthValid_arr(1:size(kLidarCross, 2)), kLidarCross)


% 图例
% open('result/narrow_klidar-p&c.fig');
set(gca,'FontSize',20,'fontname','宋体', 'linewidth', 1);
title('');
xlabel('距离(m)');
xlabel('深度(m)');
ylabel('count');
ylabel('P*z^2');
ylabel('Klidat');
legend( '原始数据', '海面以下', '99平均','FontSize',25 );
legend( '海面以下', '99平均','FontSize',25 );
legend( 'Parallel', 'Cross','FontSize',25 );
legend( 'Parallel', ' ', 'Cross', ' ');
% set(gca,'FontSize',16,'fontname','Times New Roman', 'linewidth', 1);
xlabel(['\fontname{宋体}距离\fontname{Times new roman}(m)'],'FontSize',20);
xlabel(['\fontname{宋体}深度\fontname{Times new roman}(m)'],'FontSize',20);
ylabel(['\fontname{Times new roman}count'],'FontSize',20);
ylabel(['\fontname{Times new roman}P*z^2'],'FontSize',20);
ylabel(['\fontname{Times new roman}Klidar'],'FontSize',20);

