function accuracy=evaluatetoneresponse(key,trial_type)
%function needed to determine accuracy based on inputted key and trial type

%key=1/2 (identical/different), trial_type=1/2 (same/different)
if (key==1 && trial_type==1) || (key==2 && trial_type==2) 
    accuracy=1;
else
    accuracy=0;
end

end
