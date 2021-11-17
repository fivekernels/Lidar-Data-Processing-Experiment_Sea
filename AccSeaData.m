classdef AccSeaData
    %ACCSEADATA 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        accData % 原始累加数据
        accDataValid % 海面以下数据
        accDataValidSmooth % 有效数据滑动滤波
        depthResolution % 距离分辨率
        depth_arr
        depthValid_arr % 有效深度数组
    end
    
    methods
        function obj = AccSeaData(accData, depthResolution)
            %ACCSEADATA 构造此类的实例
            %   此处显示详细说明
            obj.accData = accData;
            obj.depthResolution = depthResolution;
            obj.depth_arr = depthResolution: depthResolution: depthResolution * size(accData, 2);
            [~, mIndex]=max(accData);
            % countValidData = size(accData, 2) - mIndex + 1; %海面以下数据个数
            obj.accDataValid = obj.accData(mIndex:end);
            obj.accDataValidSmooth = smooth(obj.accDataValid, 99)';
            obj.depthValid_arr = obj.depth_arr(mIndex:end);
        end
        
        function pZSquare = CalPZSquare(obj)
            %pZSquare 计算距离平方矫正数据
            %   此处显示详细说明
            pZSquareAll = obj.accDataValidSmooth .* obj.depthValid_arr.^2;
%             % 画全部pz2
%             semilogy(obj.depthValid_arr, pZSquareAll);
            [~, minIndex]=min(pZSquareAll);
            pZSquare = pZSquareAll(1:minIndex);
        end
        
        function kLidar = CalKLidar(obj)
            ln_P_zSquare = log( obj.CalPZSquare() );
            kLidar = (-1/2) .* diff(ln_P_zSquare) ./ obj.depthResolution;
        end
    end
end

