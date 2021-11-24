classdef AccSeaData
    %ACCSEADATA 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties (SetAccess =private,GetAccess = public) % 只读 仅初始化时赋值并计算
        accData % 原始累加数据
        accDataValid % 海面以下数据
        accDataValidSmooth % 有效数据滑动滤波
        depthResolution % 距离分辨率
        depth_arr % 原始距离信息
        depthValid_arr % 有效深度数组 海面以下
        pZSquare % pz^2
        kLidar
    end
    
    methods % 构造函数
        function obj = AccSeaData(accData, depthResolution)
            %ACCSEADATA 构造此类的实例
            %   此处显示详细说明
            obj.accData = accData;
            obj.depthResolution = depthResolution;
            obj.depth_arr = depthResolution: depthResolution: depthResolution * size(accData, 2);
            [~, mIndex]=max(accData);
            % countValidData = size(accData, 2) - mIndex + 1; %海面以下数据个数
            obj.accDataValid = obj.accData(mIndex:end);
            obj.accDataValidSmooth = smooth(obj.accDataValid, 9)';
            obj.depthValid_arr = obj.depth_arr(mIndex:end);
            obj.pZSquare = obj.calculatePZSquare();
            obj.kLidar = obj.calculateKLidar();
        end
    end % end method
    
    methods (Access = protected)
        function retPZSquare = calculatePZSquare(obj)
            %pZSquare 计算距离平方矫正数据
            %   此处显示详细说明
            pZSquareAll = obj.accDataValidSmooth .* obj.depthValid_arr.^2;
%             % 画全部pz2
%             semilogy(obj.depthValid_arr - obj.depthValid_arr(1), pZSquareAll);
            [~, minIndex]=min(pZSquareAll);
            obj.pZSquare = pZSquareAll(1:minIndex);
            retPZSquare = obj.pZSquare;
        end % end calculatePZSquare()
        
        function retKLidar = calculateKLidar(obj)
            ln_P_zSquare = log( obj.pZSquare );
            obj.kLidar = (-1/2) .* diff(ln_P_zSquare) ./ obj.depthResolution;
            retKLidar = obj.kLidar;
        end
    end % end methods (Access = protected)
    
end

