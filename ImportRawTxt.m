function retTable = ImportRawTxt(filename, dataLines)
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
retTable = readtable(filename, opts);

end