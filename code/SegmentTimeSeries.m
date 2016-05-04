function [] = SegmentTimeSeries(time_series)
    parts = 10;
    cell_parts_ts = cell(1,parts);
    length_of_part = floor(length(time_series)/parts);
    for ii = 1:parts
end