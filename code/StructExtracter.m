function [frequency, height, depth, consistency, matches] = StructExtracter(model, primitives, numVariables)

matrix = model.Mat;
tokens = model.Tokens;
primitivesSqueezed = cell(length(primitives), 1);

matches = zeros(length(tokens), 1);
frequency = zeros(length(primitives) + numVariables, 1);

for ii = 1:length(primitivesSqueezed)
    primitivesSqueezed{ii} = primitives{ii}.Name;
end

for ii = 1:length(tokens)    
    temp = find(ismember(primitivesSqueezed, tokens{ii}));
    
    if ~isempty(temp) 
        matches(ii) = temp;
    else
        string = tokens{ii};
        matches(ii) = length(primitivesSqueezed) + str2num(string(2));
    end
end


for ii = 1:length(primitives)
    temp = strfind(tokens, primitives{ii}.Name);
    frequency(ii) = sum(arrayfun(@(x) length(temp{x}), 1:length(tokens)));
end


for ii = 1:numVariables
    temp = strfind(tokens, ['x' num2str(ii)]);
    frequency(length(primitives) + ii) = sum(arrayfun(@(x) length(temp{x}), 1:length(tokens)));
end


[height, depth, consistency] = dfsSearch(matrix);

end


function [height, depth, consistency] = dfsSearch(matr)
    len = length(matr);
    adjasency_cell = cell(len,1);
    
    height = Inf * ones(len, 1);
    consistency = ones(len, 1);   
    depth = zeros(len, 1);
    
    
    for ii = 1:len
        adjasency_cell{ii} = find(matr(ii,:));
        if isempty(adjasency_cell{ii})
            height(ii) = 0;
        end
    end
    
    stack = [1];
    visited = zeros(len, 1);
    visited(1) = 1;
    while ~isempty(stack)
        root = stack(end);
        visited(root) = 1;
        neighbours = adjasency_cell{root};
        unvisited = neighbours(visited(neighbours) == 0);
        
        if isempty(unvisited) 
            %[root, neighbours, 99999999]
            for ii = 1:length(neighbours)
                height(root) = min(height(root), height(neighbours(ii)) + 1);
                depth(root) = max(depth(root), depth(neighbours(ii)) + 1);
                consistency(root) = consistency(root) + consistency(neighbours(ii));
            end
            stack(end) = [];            
        else 
            unvisited = unvisited(1);
            stack = [stack unvisited];
        end
        %[root, neighbours]
    end
end

