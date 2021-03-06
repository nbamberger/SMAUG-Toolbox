function Xdata = UnpackTracesIntoRawData(TraceStruct, left_chop, top_chop)
    %Copyright 2020 LabMonti.  Written by Nathan Bamberger.  This work is 
    %licensed under the Creative Commons Attribution-NonCommercial 4.0 
    %International License. To view a copy of this license, visit 
    %http://creativecommons.org/licenses/by-nc/4.0/.  
    %
    %Function Description: takes in a trace structure and "unpacks" all
    %the traces to combine their data into a single array. If a noise floor
    %is defined in the trace structure then points below it will be thrown
    %out; points left of the left_chop value will also be thrown out.
    %
    %~~~INPUTS~~~:
    %
    %TraceStruct: a matlab structure containing log(G/G_0) vs. distance
    %   traces and associated information
    %
    %left_chop: the minimum distance value to use; traces will be
    %   chopped at this value and any distance points less than it will be
    %   discarded
    %
    %top_chop: the maximum conductance value to use; traces will be chopped
    %   after the last time they dip below this value
    %
    %######################################################################
    %
    %~~~OUTPUTS~~~:
    %
    %Xdata: a two-column array containing all data points from all traces,
    %with distance in the first column and log(G/G_0) in the second

    
    TraceStruct = LoadTraceStruct(TraceStruct);
    Ntraces = TraceStruct.Ntraces;
    
    %Apply left and top chops
    TraceStruct.apply_LeftChop(left_chop);
    TraceStruct.chopAtConductanceCeiling(top_chop);

    %Get total # of data points
    NumTotalPoints = TraceStruct.NumTotalPoints;

    %Make array for all data points and fill it up
    Xdata = zeros(NumTotalPoints, 2);
    counter = 0;
    for i = 1:Ntraces
        %%%tr = TraceStruct.(strcat('Trace',num2str(i)));
        tr = TraceStruct.Traces{i};
        ncurr = size(tr,1);
        Xdata(counter + 1:counter + ncurr, :) = tr;
        counter = counter + ncurr;
    end

    %Chop below noise floor, if it is defined
    if isfield(TraceStruct,'NoiseFloor')
        nf = log10(TraceStruct.NoiseFloor);
        Xdata = Xdata(Xdata(:,2) > nf, :);
    end

end
