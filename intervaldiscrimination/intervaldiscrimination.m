function output=intervaldiscrimination()
%function created in order to measure just noticeable difference in discriminating two sequential intervals.

%setting up the simulation screen using PsychToolBox
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
DrawFormattedText(win, 'In this portion, you will be presented with multiple sets of tone intervals.\n\nYou will hear an interval, and after a short pause another interval.\n\n You must determine if the relative distance between the two tones is identical.\n\n\n\n\n\nPress the left arrow if the two intervals were the identical, and the right arrow if they were not.\n\n\n\n\n\nPress any key to continue to the task.', 'center', 'center');
Screen('Flip',win);
KbStrokeWait;


nblocks=2; %number of trial blocks, can be changed dependent on task.

reversals=[4;8];%defaults from other scripts and experiments
stepsize=[1,1.05]; %step size of interval differences.
%reversalforthresh=8;
expplan=[(1:sum(reversals))',zeros(sum(reversals),1)]; %creating the experiment plan
down=2; %setting the number of down
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
expthresholds = zeros(nblocks, 1);

%overall loop to outline the entire experimental simulation
for block=1:nblocks
    
    count_of_n_of_reversals=0;
    trial=1;
    
    n_down=0;%variable to count the number down
   
    %variables to count the pos/neg responses from user
    pos=0;
    neg=0;
    trend=30;
         
    actualstep=expplan(1,2);
         
    % creating all the tones and intervals
    Fs=44100; %sampling frequency used
    delta=1.5; %initial delta value to be held constant.
    difdelta=0.5; %altered interval delta in order to be varied.
    factor=0.9; %to make sure the second interval does not dip below the original interval.
    tone1freq=440; %440 hz pure A
    %tone1freq=261.63; %can be altered to start on different notes - E here.
    time=0:1/Fs:0.5; %generate time vector
    %must ultimately have 4 tones - 2 intervals.
    tone1=tone_generator(tone1freq,time);
    tone2freq=tone1freq*delta;%fixed
    tone2=tone_generator(tone2freq,time);
    reversal_thresh=zeros(1,sum(reversals));
    
    %loop that will continue while it is less than the amount of reversals.
    while count_of_n_of_reversals<sum(reversals)
        Screen('Flip',win);
        DrawFormattedText(win,sprintf('Left arrow = intervals are identical. Right arrow = intervals are different.\n\n\n\n\nBlock %d of %d',block,nblocks),'center','center');
        Screen('Flip',win);
        InitializePsychSound(1);
        trial_type=randi([1,2]);%1 means same, 2 means dif
        tone3freqoptions=[tone1freq,392]; %A and E
        tone3freq=tone3freqoptions(randi([1,2])); %either base of A or base of E, randomly generated.
        tone3=tone_generator(tone3freq,time);
        
        if trial_type==1 %same trial
            tone4freq=tone3freq*delta;%delta is the constant
            tone4=tone_generator(tone4freq,time);
        elseif trial_type==2 %different trial
            tone4freq=tone3freq*(1.5+difdelta);%difdelta changes based on the trial results
            tone4=tone_generator(tone4freq,time);
        end
         
    intervals=[tone1,tone2,zeros(1,10000),tone3,tone4,zeros(1,10000);tone1,tone2,zeros(1,10000),tone3,tone4,zeros(1,10000)]; %full stereo interval sound vector.
        
        %initialize and play the intervals with PsychPortAudio
        nrchannels=2;%stereo not mono
        pahandle = PsychPortAudio('Open', [], [], 2, Fs, nrchannels);
        PsychPortAudio('FillBuffer',pahandle,intervals);
        PsychPortAudio('Start',pahandle,1,0,1);
        PsychPortAudio('Stop',pahandle,1);
        PsychPortAudio('Close',pahandle);
        
        %collect the responses after hearing the intervals
        resp=true;
        while resp
            [~,~,keyCode] = KbCheck;
            if keyCode(left)
                key=1;%key=1 means user response thought intervals were identical
                resp=false;
            elseif keyCode(right)
                key=2;%key=2 means user response thought intervals were different
                resp=false;
            end
        end
        
        %evaluate the response itself
        accuracy=evaluateintervalresponse(key,trial_type,delta,difdelta);%key=1/2 (identical/different), trial_type=1/2 (same/different)
        subjectaccuracy(trial)=accuracy;
         
        %store responses in an organized response matrix
        rowofoutput (1, 1) = block;
        rowofoutput (1, 2) = trial;
        rowofoutput (1, 3) = difdelta;
        rowofoutput (1, 4) = trial_type;
        rowofoutput (1, 5) = subjectaccuracy(trial);
        
        %adjust the different set values based on the accuracy of their response.
        if subjectaccuracy(trial)==1 %they got it right
            n_down=n_down+1;%one correct
            if n_down==down %checking if two down happened
                n_down=0;%resetting the n_down value
                pos=1;
                trend=1;
                difdelta=difdelta*(factor*actualstep); %anytime 2 correct, change the delta to make harder
                
                %update the count of reversals and step size based on
                %right/wrong
                if pos==1 && neg==-1 %if a reversal occured AND they were correct
                    count_of_n_of_reversals=count_of_n_of_reversals+1;%a reversal occured
 
                    actualstep=expplan(count_of_n_of_reversals,2);
                    pos=trend;
                    neg=trend;
                    reversal_thresh(count_of_n_of_reversals)=difdelta;
                end
            end
            
        elseif subjectaccuracy(trial)==0 %they got it wrong
            neg=-1;
            trend=-1;
            n_down=0;
            difdelta=difdelta/(factor*actualstep); %anytime incorrect, make easier by changing delta
            
            if pos==1 && neg==-1
                count_of_n_of_reversals=count_of_n_of_reversals+1;
                %blockthresholds(n_threshold) ---> figure out how to
                %calculate thresholds / based on frequency
                %n_threshold=n_threshold+1;
                actualstep=expplan(count_of_n_of_reversals,2);
                pos=trend;
                neg=trend;
                reversal_thresh(count_of_n_of_reversals)=difdelta;
            end
        end
        
        rowofoutput(1,6)=count_of_n_of_reversals;
        rowofoutput(1,7)=actualstep;
        
        %update the overall output matrix
        output=[output;rowofoutput];
    
        trial=trial+1;%update the number of trials
        
        WaitSecs(1.5);
          
    end
    thresh=sum(reversal_thresh(5:end))/length(reversal_thresh(5:end));
    
    %save results to text file - eventually to be organized into an xls file
    [r,~]=size(output);
    filename=sprintf('intervaldata_block%d.txt',block);
    fid=fopen(filename,'w');
    for i = 1:r
        fprintf(fid,'%d %d %.1f %d %d %d %.2f\n',output(i,1),output(i,2),output(i,3),output(i,4),output(i,5),output(i,6),output(i,7));
    end
    fprintf(fid,'\n');
    fprintf(fid,'threshold = %f',thresh);
    fclose(fid);
    filename2=sprintf('intervalresults_block%d.mat',block);
    save(filename2,'output','reversal_thresh','thresh');
end
Screen('CloseAll');
end
