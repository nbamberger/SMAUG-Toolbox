function sequenceIDs = step_SplitShift(sequenceIDs,GCO)
    %Copyright 2021 LabMonti.  Written by Nathan Bamberger.  This work is 
    %licensed under the Creative Commons Attribution-NonCommercial 4.0 
    %International License. To view a copy of this license, visit 
    %http://creativecommons.org/licenses/by-nc/4.0/.  
    %
    %Function Description: Generate a trial MCMC step by trying to move
    %the left half of the node sequence up/down one node and the right half
    %down/up one node.
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
    
    
    n = length(sequenceIDs);
    mid = ceil(n/2);
    
    %Move left up and right down with 50% probability
    if rand() > 0.5
       
        %If ANY of the nodes cannot be moved up or down, return NaN (will be
        %interpreted as an instant reject) (columns 2 & 1 for northern &
        %southern neighbors)
        if any(GCO.MissingNeighbors(sequenceIDs(1:mid),2)) || ...
                any(GCO.MissingNeighbors(sequenceIDs(mid+1:n),1))
            sequenceIDs = NaN;
        else
            %Move left up, right down
            sequenceIDs(1:mid) = GCO.VerticalNeighbors(sequenceIDs(1:mid),2);
            sequenceIDs(mid+1:n) = GCO.VerticalNeighbors(sequenceIDs(mid+1:n),1);
        end 
    
    %Else move left down and right up
    else

        %If ANY of the nodes cannot be moved up or down, return NaN (will be
        %interpreted as an instant reject) (columns 1 & 2 for southern &
        %northern neighbors)
        if any(GCO.MissingNeighbors(sequenceIDs(1:mid),1)) || ...
                any(GCO.MissingNeighbors(sequenceIDs(mid+1:n),2))
            sequenceIDs = NaN;
        else
            %Move left down, right up
            sequenceIDs(1:mid) = GCO.VerticalNeighbors(sequenceIDs(1:mid),1);
            sequenceIDs(mid+1:n) = GCO.VerticalNeighbors(sequenceIDs(mid+1:n),2);
        end         
        
    end
    
end