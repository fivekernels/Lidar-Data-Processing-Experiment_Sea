function [ str_varName ] = getVarName( ~ )
    % 获取变量对应的变量名字符串
    str_varName = sprintf('%s', inputname(1));
end
