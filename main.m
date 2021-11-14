clear variables;

rawFilePath = './raw-data/窄视场信号/';
rawFileName = 'N1118-224101_40.txt';
oneRawSeaData = RawSeaData(rawFilePath, rawFileName);
rawData = oneRawSeaData.method1();
