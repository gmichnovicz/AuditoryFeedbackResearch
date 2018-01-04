
function output=tonediscrimination()
%function created in order to measure the just noticeable difference in discriminating two sequential tones.


%setting up the screen using PsychToolBox
screenid=max(Screen('Screens'));
[win,rect]=Screen('OpenWindow',screenid);
Screen('FillRect',win,255);
Screen('Flip',win);
xCenter=rect(3)/2;
yCenter=rect(4)/2;

white = WhiteIndex(screenid);
grey = white / 2;
black = BlackIndex(screenid);
[screenXpixels, screenYpixels] = Screen('WindowSize', win);


%Create hot keys
KbName('UnifyKeyNames');
space=KbName('Space');
stopkey=KbName('ESCAPE');
left=KbName('LeftArrow');
right=KbName('RightArrow');
enter=KbName('Return');

%Draw text and wait for key click from user
DrawFormattedText(win, 'Welcome! Press any key to begin.', 'center', 'center');
Screen('Flip',win);
KbStrokeWait;

%Present instructions and wait for user key press to move on to the trials
Screen('Flip',win);
DrawFormattedText(win, 'In this portion, you will be presented with two sequential tones.\n\n\n Press the left arrow if the two tones were identical, and the right arrow if they were not.\n\n\n\n\n\nPress any key to continue to the task.', 'center', 'center');
Screen('Flip',win);
KbStrokeWait;


nblocks=2; %number of trial blocks, can be changed dependent on task.

reversals=[4;8]; %defaults from other scripts and experiments
stepsize=[1,1.05]; %step size of interval difference
%reversalforthresh=8;
expplan=[(1:sum(reversals))',zeros(sum(reversals),1)]; %creating the vector of values to craft the experiment outline
down=2; %number of incorrect responses needed in order to reverse the experiment
subjectaccuracy=[];
%feedback=0;
         
i=1;
         
for j=1:length(reversals)
    for k=1:reversals(j)
        expplan(i, 2)=stepsize(j);
        i=i+1;
    end
end
         
output = [];
rowofoutput = zeros(1, 7);
%expthresholds = zeros(nblocks, 1);

%overall loop to outline the entire experiment stimulation
for block=1:nblocks
    
    count_of_n_of_reversals=0;
    trial=1;
         
    %blockthresholds=zeros(length(reversalforthresh),1);
    %n_threshold=1;
         
    n_down=0;%variable to count the number down
         
    %variables to count the pos/neg responses from user
    pos=0;
    neg=0;
    trend=30;
         
    actualstep=expplan(1,2);
         
    % creating all the tones and intervals
    Fs=44100; %sampling frequency - default

    delta=0.2; %initial value to create the two toned interval.
    factor=0.9; %to make sure that the second frequency doesn't dip below the original frequency
    reversal_thresh=zeros(1,sum(reversals)); %vector to track responses
    tone1freq=440; %440 hz pure A
    time=0:1/Fs:0.75; %time vector
    tone1=tone_generator(tone1freq,time); %function to create the tone vector.
    tone2freq=tone1freq*delta; %fixed comparison tone frequency that is delta - away from fixed.
    tone2=tone_generator(tone2freq,time);
    
    %this loop will continue to present the two tones until the user undergoes as many as predetermined reversals.
    while count_of_n_of_reversals<sum(reversals)
        %creating the screen on PsychToolBox to present stimuli
         
        Screen('Flip',win);
        DrawFormattedText(win,sprintf('Left arrow = tones are identical. Right arrow = tones are different.\n\n\n\n\nBlock %d of %d',block,nblocks),'center','center');
        Screen('Flip',win);
         
        %Open PsychPortAudio in order to present sound stimuli
        InitializePsychSound(1);
        trial_type=randi([1,2]); %1 means same (presenting two of the same tones), 2 means different (presenting two different tones based on delta)
        
        %generate the tone vectors accordingly.
        if trial_type==1 %same trial
            tone2freq=tone1freq;%fixed
            tone2=tone_generator(tone2freq,time);
         
        elseif trial_type==2 %different trial
            tone2freq=tone1freq*(1+delta);
            tone2=tone_generator(tone2freq,time);
        end
        
        %final tone vector to be presented with both tones - in stereo.
        interval=[tone1,zeros(1,50000),tone2;tone1,zeros(1,50000),tone2];
        
         
        %initialize and play the intervals with PsychPortAudio
        nrchannels=2;%stereo not mono
        pahandle = PsychPortAudio('Open', [], [], 2, Fs, nrchannels);
        PsychPortAudio('FillBuffer',pahandle,interval);
        PsychPortAudio('Start',pahandle,1,0,1);
        PsychPortAudio('Stop',pahandle,1);
        PsychPortAudio('Close',pahandle);
        
        %collect the responses after hearing the intervals
        resp=true;
        while resp
            [~,~,keyCode] = KbCheck;
            if keyCode(left)
                key=1; %key=1 means user response thought intervals were identical
                resp=false;
            elseif keyCode(right)
                key=2; %key=2 means user response thought intervals were different
                resp=false;
            end
        end
        
        %evaluate the response itself
        accuracy=evaluatetoneresponse(key,trial_type); %key=1/2 (same/different), trial_type=1/2 (same/different)
        subjectaccuracy(trial)=accuracy;
         
        %matrix to organize results
        rowofoutput (1, 1) = block;
        rowofoutput (1, 2) = trial;
        rowofoutput (1, 3) = delta;
        rowofoutput (1, 4) = trial_type;
        rowofoutput (1, 5) = subjectaccuracy(trial);
        
        if subjectaccuracy(trial)==1  %the user got it correct - must track the 2-up 1-down
            n_down=n_down+1; %one correct
            if n_down==down %checking if 2-down happened
                n_down=0; %resetting the n_down value
                pos=1;
                trend=1;
         
                delta=delta*(factor*actualstep); %anytime 2 correct, change the delta to make harder
                %update the count of reversals and step size based on
                %right/wrong
                if pos==1 && neg==-1 %if a reversal occured AND they were correct
                    count_of_n_of_reversals=count_of_n_of_reversals+1; %a reversal occured
                    actualstep=expplan(count_of_n_of_reversals,2);
                    pos=trend;
                    neg=trend;
                    reversal_thresh(count_of_n_of_reversals)=delta; %track the current delta value
                end
            end
            
        elseif subjectaccuracy(trial)==0 %they got it wrong
            neg=-1;
            trend=-1;
            n_down=0;
            delta=delta/(factor*actualstep); %anytime incorrect, make easier by changing delta
         
            %track values according to how many up versus down
            if pos==1 && neg==-1
                count_of_n_of_reversals=count_of_n_of_reversals+1;
                actualstep=expplan(count_of_n_of_reversals,2);
                pos=trend;
                neg=trend;
                reversal_thresh(count_of_n_of_reversals)=delta;
            end
        end
        
        %store values accordingly into results matrix
        rowofoutput(1,6)=count_of_n_of_reversals;
        rowofoutput(1,7)=actualstep;
        
        
        %update the overall output matrix
        output=[output;rowofoutput];
        
        
        trial=trial+1; %update the number of trials
        
       % Screen('Flip',win);
        WaitSecs(0.5);
        
    end
         
    %calculate threshold based on trials
    thresh=sum(reversal_thresh(5:end))/length(reversal_thresh(5:end));
    [r,~]=size(output);
         
    %store results in a text file - eventually want to convert to xls file for better formatting
    filename=sprintf('tonedata_block%d.txt',block);
    fid=fopen(filename,'w');
    for i = 1:r
        fprintf(fid,'%d %d %.1f %d %d %d %.2f\n',output(i,1),output(i,2),output(i,3),output(i,4),output(i,5),output(i,6),output(i,7));
    end
    fprintf(fid,'\n');
    fprintf(fid,'threshold = %f',thresh);
    fclose(fid);
    filename2=sprintf('toneresults_block%d.mat',block);
    save(filename2,'output','reversal_thresh','thresh');
end
         
Screen('CloseAll');
end
