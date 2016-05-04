function [] = StructWriter( population, filename, label_of_population, segment_index, primitives, numVariables, numGeneratedModels)
% 'structs.txt'

struct_file = fopen(filename,'a+');
%fprintf(struct_file, '== %s == %s == \n', label_of_population{1}, segment_index);

% frequencyTemp = cell(length(population),1); 
heightTemp = cell(length(population),1); 
depthTemp = cell(length(population),1);
consistencyTemp = cell(length(population),1);
matchesTemp = cell(length(population),1);
parfor( ii = 1:length(population), 100)
    [~, heightTemp{ii}, depthTemp{ii}, consistencyTemp{ii}, matchesTemp{ii}] = StructExtracter(population{ii}, primitives, numVariables);
end

frequency = zeros(1, length(primitives) + numVariables);
height = zeros(1, length(primitives) + numVariables); 
depth = zeros(1, length(primitives) + numVariables);
consistency = zeros(1, length(primitives) + numVariables);

for ii = 1:length(population)
    temp_match = matchesTemp{ii}';
    temp_dept = depthTemp{ii};
    temp_heig = heightTemp{ii};
    temp_cons = consistencyTemp{ii};
    for jj = 1:length(temp_match)
        frequency(temp_match(jj)) = frequency(temp_match(jj)) + 1;
        height(temp_match(jj)) = height(temp_match(jj)) + temp_heig(jj);
        depth(temp_match(jj)) = depth(temp_match(jj)) + temp_dept(jj);
        consistency(temp_match(jj)) = consistency(temp_match(jj)) + temp_cons(jj);
    end
    
end

for ii = 1:length(primitives)
    if (frequency(ii) ~= 0)
        height(ii) = height(ii) / frequency(ii);        
        depth(ii) = depth(ii) / frequency(ii);
        consistency(ii) = consistency(ii) / frequency(ii);
        frequency(ii) = frequency(ii) / numGeneratedModels;
    end    
    
end


dlmwrite(filename, [frequency, height, depth, consistency], '-append');
%fprintf(struct_file, '\n');
fclose(struct_file);

end
