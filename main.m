function [ ] = main(PrjFname)

warning off
SWITCHER = 'cross-mute';

[primitives, encodings, ~, genopt] = addpather();
data = dlmread('B1.dat');
range_to_use = 1:17000;
heart_rate = data(range_to_use,1);
number_rows = 1000;
number_columns = size(heart_rate, 1) / number_rows; 
heart_rate = reshape(heart_rate' , number_rows, number_columns);
chest_volume = data(range_to_use,2);
chest_volume = reshape(chest_volume', number_rows, number_columns);
blood_oxygen = data(range_to_use,3);
blood_oxygen = reshape(blood_oxygen', number_rows, number_columns);

united_data = [heart_rate; chest_volume; blood_oxygen];

populationSize = 30;
dlmwrite('tree_struct.txt', size(united_data,1), '-append'); 
dlmwrite('tree_struct.txt', populationSize, '-append'); 
for row_data = 1:100:size(united_data,1)
    data  = united_data(row_data, :);
    timing = 0:0.5:(length(data)-1)/2;
    
    
    disp(['iteration #' num2str(row_data)]);    
    
    population = CreateRandomPopulation(30, primitives, 1, 3);
    numGeneratedModels = length(population);
    
    population = LearnPopulation(population, data', timing');
    numbGenerModels = 0;

    tic
    
    for itr = 1 : genopt.MAXCYCLECOUNT
        disp([itr, row_data])
        populationCO = CrossoverPopulation(population, genopt.CROSSINGAMOUNT);
        populationCO = LearnPopulation(populationCO, data', timing');
        populationMU = MutationPopulation(population, primitives, 1, genopt.MUTATIONAMOUNT);
        populationMU = LearnPopulation(populationMU, data', timing');        
        population = [population, populationCO, populationMU];
        population = SelectBestPopulationElements(population, genopt.BESTELEMAMOUNT);
        
        numbGenerModels = numbGenerModels + length(population);
        timeElapsed = toc;

        fprintf('Number of generated models: %d\nElapsed time: %d\nPerfomance: %.1f models per sec.\n',numbGenerModels,timeElapsed,double(numbGenerModels)/timeElapsed);
        PrintPopulation(population);
    end
       
    timeElapsed = toc;
    fprintf('Elapsed time = %d\n',timeElapsed);     
    
    names_times = {'heart_rate','chest_volume', 'blood_oxygen'};
    %StructWriter(population, 'structs.txt', names_times(ceil(divider/50)), num2str(mod(divider,50)), primitives, 1, numGeneratedModels);
    fillPopulationStruct(population(1:populationSize));
end
%}
end
