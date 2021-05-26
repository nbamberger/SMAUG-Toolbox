function sequenceIDs = step_ScrambleShift(sequenceIDs, GCO)
    %Copyright 2021 LabMonti.  Written by Nathan Bamberger.  This work is 
    %licensed under the Creative Commons Attribution-NonCommercial 4.0 
    %International License. To view a copy of this license, visit 
    %http://creativecommons.org/licenses/by-nc/4.0/.  
    %
    %Function Description: Generate a trial MCMC step by independently 
    %trying to move each node in the sequence up or down at random
    %
    %~~~INPUTS~~~:
    %
    %sequenceIDs: vector listing the node ID# for each node in the
    %   node-sequence
    %
    %GCO: GridCorrelationObject containing all the node information for the
    %   dataset that the MCMC is being run on 
    %
    %######################################################################
    %
    %~~~OUTPUTS~~~:
    %  
    %sequenceIDs: vector listing the node ID#s for the new sequence
    %   generated by the trial step; will be NaN if the trial step was
    %   automatically rejected because it would have fallen off the
    %   existing nodes
    
    
    %Columns 1 or 2 means randomly pick moving down or up, respectively,
    %for each node
    n = length(sequenceIDs);    
    cols = randi(2,n,1);
    
    %See if the total move is allowed or not by checking if any of the
    %shifts would move onto missing neighbors
    allowed = true;
    for i = 1:n
        if GCO.MissingNeighbors(sequenceIDs(i),cols(i))
            allowed = false;
        end
    end
    
    %If it is allowed, do the move
    if allowed
        for i = 1:n
            sequenceIDs(i) = GCO.VerticalNeighbors(sequenceIDs(i),cols(i));
        end
    end

end