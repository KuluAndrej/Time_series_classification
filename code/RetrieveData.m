function [data] = RetrieveData(filename)

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
    data = [heart_rate; chest_volume; blood_oxygen];
end