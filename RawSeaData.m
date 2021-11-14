classdef RawSeaData
    %RAWSEADATA �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties (Constant)
        cloumn532Parallel = 2;                % 532nmƽ��ͨ������ ��
        row532Parallel = [514 - 1, 2561 - 1]; % 532nmƽ��ͨ������ ��
        cloumn532Crossl = 3;                  % 532nmƽ��ͨ������ ��
        row532Cross = [5634 - 1, 7681 - 1];   % 532nmƽ��ͨ������ ��
    end
    
    properties
        fileFullName
    end
    
    methods (Access = private)
        function retTable = importRawTxt(obj, dataLines)
            %IMPORTFILE ���ı��ļ��е�������
            %  N111822410140 = IMPORTFILE(FILENAME)��ȡ�ı��ļ� FILENAME ��Ĭ��ѡ����Χ�����ݡ�
            %  �Ա���ʽ�������ݡ�
            %
            %  N111822410140 = IMPORTFILE(FILE, DATALINES)��ָ���м����ȡ�ı��ļ� FILENAME
            %  �е����ݡ����ڲ��������м�����뽫 DATALINES ָ��Ϊ������������ N��2 �������������顣
            %
            %  ʾ��:
            %  N111822410140 = importfile("C:\Users\Think\Documents\MATLAB\��ˮ�ز��ź�_��ϰ\ori-data\խ�ӳ��ź�\N1118-224101_40.txt", [2, Inf]);
            %
            %  ������� READTABLE��
            %
            % �� MATLAB �� 2021-11-14 15:37:38 �Զ�����
            
            %% ���봦��
            
            % �����ָ�� dataLines���붨��Ĭ�Ϸ�Χ
            if nargin < 2
                dataLines = [2, Inf];
            end
            
            %% Set up the Import Options and import the data
            opts = delimitedTextImportOptions("NumVariables", 3);
            
            % ָ����Χ�ͷָ���
            opts.DataLines = dataLines;
            opts.Delimiter = " ";
            
            % ָ�������ƺ�����
            opts.VariableNames = ["VarName1", "VarName2", "VarName3"];
            opts.VariableTypes = ["double", "categorical", "categorical"];
            
            % ָ���ļ�������
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
            opts.ConsecutiveDelimitersRule = "join";
            opts.LeadingDelimitersRule = "ignore";
            
            % ָ����������
            opts = setvaropts(opts, ["VarName2", "VarName3"], "EmptyFieldRule", "auto");
            
            % ��������
            retTable = readtable(obj.fileFullName, opts);
            
            end
    end

    methods
        function obj = RawSeaData(filePath,fileName)
            %RAWSEADATA ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.fileFullName = strcat(filePath, fileName);
        end
        
        function outputArg = method1(obj)
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
            outputArg = obj.importRawTxt();
        end
    end
end

