function [primitives, encodings, models, genopt] = addpather()

PrjFname = 'demo.prj.txt';

THISFOLDER = fileparts(mfilename('fullpath'));
DATAFOLDER = fullfile(THISFOLDER,'data');
FUNCFOLDER = fullfile(THISFOLDER,'func');
CODEFOLDER = fullfile(THISFOLDER,'code');
SELFFOLDER = fullfile(THISFOLDER,'self');

addpath(FUNCFOLDER);
addpath(CODEFOLDER);
addpath(DATAFOLDER);
addpath(SELFFOLDER);

[primitives, models, genopt]  = InputProjectData( PrjFname, DATAFOLDER );

%filik = ;
tokensFeatures = textscan(fopen('numbParam.txt'), '%s%f%f', 'delimiter', ' ');
encodings  = tokensFeatures{1};

fclose(fopen('timer.txt','w'));
fclose(fopen('tree_struct.txt','w'));
fclose(fopen('structs.txt','w'));
fclose('all'); 

end