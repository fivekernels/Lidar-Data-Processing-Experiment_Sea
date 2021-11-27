classdef AccSeaData
    %ACCSEADATA �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties (SetAccess =private,GetAccess = public) % ֻ�� ����ʼ��ʱ��ֵ������
        accData % ԭʼ�ۼ�����
        accDataValid % ������������
        accDataValidSmooth % ��Ч���ݻ����˲�
        depthResolution % ����ֱ���
        depth_arr % ԭʼ������Ϣ
        depthValid_arr % ��Ч������� ��������
        pZSquare % pz^2
        kLidar
    end
    
    methods % ���캯��
        function obj = AccSeaData(accData, depthResolution)
            %ACCSEADATA ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.accData = accData;
            obj.depthResolution = depthResolution;
            obj.depth_arr = depthResolution: depthResolution: depthResolution * size(accData, 2);
            [~, mIndex]=max(accData);
            % countValidData = size(accData, 2) - mIndex + 1; %�����������ݸ���
            obj.accDataValid = obj.accData(mIndex:end);
            obj.accDataValidSmooth = smooth(obj.accDataValid, 9)';
            obj.depthValid_arr = obj.depth_arr(mIndex:end);
            obj.pZSquare = obj.calculatePZSquare();
            obj.kLidar = obj.calculateKLidar();
        end
    end % end method
    
    methods (Access = protected)
        function retPZSquare = calculatePZSquare(obj)
            %pZSquare �������ƽ����������
            %   �˴���ʾ��ϸ˵��
            pZSquareAll = obj.accDataValidSmooth .* obj.depthValid_arr.^2;
%             % ��ȫ��pz2
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

