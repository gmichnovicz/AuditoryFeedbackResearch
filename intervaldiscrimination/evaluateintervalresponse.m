function accuracy=evaluateintervalresponse(key,trial_type,delta,difdelta)
%function used to evaluate the accuracy of the users response to the simulation

%key=1/2 (identical/different), trial_type=1/2 (same/different)
if (key==1 && trial_type==1) || (key==2 && trial_type==2) || (key==1 && delta==difdelta) 
    accuracy=1;
else
    accuracy=0;
end

end
