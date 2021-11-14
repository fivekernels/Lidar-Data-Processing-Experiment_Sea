classdef RawSeaData
    %RAWSEADATA 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties (Constant)
        cloumn532Parallel = 2;                % 532nm平行通道数据 列
        row532Parallel = [514 - 1, 2561 - 1]; % 532nm平行通道数据 行
        cloumn532Crossl = 3;                  % 532nm平行通道数据 列
        row532Cross = [5634 - 1, 7681 - 1];   % 532nm平行通道数据 行
    end
    
    properties
        fileFullName
    end
    
    methods (Access = private)
        function retTable = importRawTxt(obj, dataLines)
            %IMPORTFILE 从文本文件中导入数据
            %  N111822410140 = IMPORTFILE(FILENAME)读取文本文件 FILENAME 中默认选定范围的数据。
            %  以表形式返回数据。
            %
            %  N111822410140 = IMPORTFILE(FILE, DATALINES)按指定行间隔读取文本文件 FILENAME
            %  中的数据。对于不连续的行间隔，请将 DATALINES 指定为正整数标量或 N×2 正整数标量数组。
            %
            %  示例:
            %  N111822410140 = importfile("C:\Users\Think\Documents\MATLAB\海水回波信号_练习\ori-data\窄视场信号\N1118-224101_40.txt", [2, Inf]);
            %
            %  另请参阅 READTABLE。
            %
            % 由 MATLAB 于 2021-11-14 15:37:38 自动生成
            
            %% 输入处理
            
            % 如果不指定 dataLines，请定义默认范围
            if nargin < 2
                dataLines = [2, Inf];
            end
            
            %% Set up the Import Options and import the data
            opts = delimitedTextImportOptions("NumVariables", 3);
            
            % 指定范围和分隔符
            opts.DataLines = dataLines;
            opts.Delimiter = " ";
            
            % 指定列名称和类型
            opts.VariableNames = ["VarName1", "VarName2", "VarName3"];
            opts.VariableTypes = ["double", "categorical", "categorical"];
            
            % 指定文件级属性
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
            opts.ConsecutiveDelimitersRule = "join";
            opts.LeadingDelimitersRule = "ignore";
            
            % 指定变量属性
            opts = setvaropts(opts, ["VarName2", "VarName3"], "EmptyFieldRule", "auto");
            
            % 导入数据
            retTable = readtable(obj.fileFullName, opts);
            
            end
    end

    methods
        function obj = RawSeaData(filePath,fileName)
            %RAWSEADATA 构造此类的实例
            %   此处显示详细说明
            obj.fileFullName = strcat(filePath, fileName);
        end
        
        function outputArg = method1(obj)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
            outputArg = obj.importRawTxt();
        end
    end
end

