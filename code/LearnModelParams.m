function model = LearnModelParams(model, target, variable)
% Find model parameters solving an optimization problem;
% Calcullate model MSE and error
%
% Inputs:
% model - input model structure;
% y - m-by-1 target variable;
% x - m-by-n independent variable
% nlinopt - options for nlinfit (nonlinear regression adjustment) method
%
% Outputs:
% model with the following new fields:
%  model.FoundParams - found parameters according to the data and
%  optimization problem solution;
%  model.MSE - mean squared error on a learning part of the dataset;
%  model.Error - model error value
%
% http://strijov.com
% Eliseev, 14-dec-07
% Strijov, 29-apr-08
% M. Kuznetsov, 20.12.2013

random_shuffle = randperm(length(variable));
part_to_train = ceil(0.7*length(variable));
x = variable(random_shuffle(1:part_to_train));
xcontrol = variable(random_shuffle(part_to_train+1:end));
y = target(random_shuffle(1:part_to_train));
ycontrol = target(random_shuffle(part_to_train+1:end)); 


nlinopt.FunValCheck = 'off'; % Check for invalid values, such as NaN or Inf, from  the objective function [ 'off' | 'on' (default) ].
%fprintf('currently in RefreshTreeInfo \n');
%model.Handle
handle = str2func(model.Handle);

initParams = cell2mat(model.InitParams');
%fprintf(1, '\nTune: %s', model.Name);
model.FoundParams = [];
if ~isempty(model.InitParams)
    try
        [model.FoundParams, ~, ~, model.ParamsCov, model.MSE] =...
            nlinfit(x, y, handle, initParams, nlinopt); % find parameters
    catch
          disp('nlinfit failed, Found Params = Init Params')
          model.FoundParams = initParams;
    end
    model.MSE = mean( (handle(model.FoundParams, x) - y) .^ 2);
    model.Error = errorFun(model.MSE, model.FoundParams, length(model.Tokens));
    if (model.Error == nan)
        model.Error = Inf;
    end
    model.Control = mean( (handle(model.FoundParams, xcontrol) - ycontrol) .^ 2);
end

end

function [value] = errorFun (MSE, dimOmega, modelCompl)
    constInterpr = 20;
    tendToBeBad = 0.0000001;
    
    
    %aic = log(dimSelect)*dimOmega+dimSelect*log(MSE);
    
    aic = 0.000003*norm(dimOmega)+MSE;
    value = aic;
    %norm(dimOmega)^2
    %MSE
    if modelCompl<constInterpr
        adding =  tendToBeBad*MSE*MSE*modelCompl;
    else
        adding =  MSE*MSE*(modelCompl-constInterpr)+tendToBeBad*MSE*constInterpr;
    end
    
    value = value+adding;
    %[adding, MSE, value]
end
