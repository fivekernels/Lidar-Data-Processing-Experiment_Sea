classdef AccSeaData
    %ACCSEADATA �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        accData % ԭʼ�ۼ�����
        accDataValid % ������������
        accDataValidSmooth % ��Ч���ݻ����˲�
        depthResolution % ����ֱ���
        depth_arr
        depthValid_arr % ��Ч�������
    end
    
    methods
        function obj = AccSeaData(accData, depthResolution)
            %ACCSEADATA ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.accData = accData;
            obj.depthResolution = depthResolution;
            obj.depth_arr = depthResolution: depthResolution: depthResolution * size(accData, 2);
            [~, mIndex]=max(accData);
            % countValidData = size(accData, 2) - mIndex + 1; %�����������ݸ���
            obj.accDataValid = obj.accData(mIndex:end);
            obj.accDataValidSmooth = smooth(obj.accDataValid, 99)';
            obj.depthValid_arr = obj.depth_arr(mIndex:end);
        end
        
        function pZSquare = CalPZSquare(obj)
            %pZSquare �������ƽ����������
            %   �˴���ʾ��ϸ˵��
            pZSquareAll = obj.accDataValidSmooth .* obj.depthValid_arr.^2;
%             % ��ȫ��pz2
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

