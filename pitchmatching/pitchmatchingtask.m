function data=pitchmatchingtask()

screenid=max(Screen('Screens'));
[win,rect]=Screen('OpenWindow',screenid);
Screen('FillRect',win,255);
Screen('Flip',win);
xCenter=rect(3)/2;
yCenter=rect(4)/2;

%trial_dur=2.5;

white = WhiteIndex(screenid);
grey = white / 2;
black = BlackIndex(screenid);
[screenXpixels, screenYpixels] = Screen('WindowSize', win);

%setting up the number of trials between sets of 3 tones and 5 tones
num5trials=5;
num3trials=5;

%Create hot keys
KbName('UnifyKeyNames');
space=KbName('Space');
stopkey=KbName('ESCAPE');
left=KbName('LeftArrow'); 
enter=KbName('Return');
right=KbName('RightArrow'); 
%Draw text and wait for key click from user
DrawFormattedText(win, 'Welcome! Press any key to begin.', 'center', 'center');
Screen('Flip',win);
KbStrokeWait;

%Present instructions and wait for user key press to move on to the trials
Screen('Flip',win);
DrawFormattedText(win, 'You will hear a series of tone sequences.\n\n After the designated sequence completes, you will be asked to repeat the sequence back vocally to the best of your abilites.\n\n\nPress any key to continue to the task.', 'center', 'center');
Screen('Flip',win);
KbStrokeWait;

Screen('Flip',win);
DrawFormattedText(win,'Press the left arrow if you are female or the right arrow if you are male.','center','center');
Screen('Flip',win);
resp=true;
gender='';

%wait to collect response over the user is a female or a male
while resp
    [~,~,keyCode]=KbCheck;
    if keyCode(left)
        gender='female';
        resp=false;
    elseif keyCode(right)
        gender='male';
        resp=false;
    end
end

%must have two options for female and male -- present simulation accordingly (repetative code - can be consolidated)
if strcmp(gender,'female')
    %create a data structure to store all the results in an organized fashion
    data=struct;
    data.gen=gender;
    nrchannels=2;
    recordeddata5=cell(num5trials,2);
    
    for i=1:num5trials %present the number of trials decided
        %open PsychPortAudio
        InitializePsychSound(1)
        [pitch_config,stim,fs]=create_pitches(gender,5);
        DrawFormattedText(win,sprintf('Sequence %d of %d\n\n\nListen carefully to the tones played.',i,num5trials),'center','center');
        Screen('Flip',win);
        WaitSecs(2);

        %organize sound presentation buffers
        pahandle = PsychPortAudio('Open', [], [], 2, fs, nrchannels);
        PsychPortAudio('FillBuffer',pahandle,stim);
        PsychPortAudio('Start',pahandle,1,0,1);
        PsychPortAudio('Stop',pahandle,1);
        PsychPortAudio('Close',pahandle);
        
        WaitSecs(1);
        
        if i==1 %give instructions when it is the first trial
            Screen('Flip',win);
            DrawFormattedText(win,'Now, to the best of you ability, repeat the prior sequence back vocally into the microphone using the syllable ''ah''.\n\nLeave space between each syllable as you heard in the playback. \n\n\n\n Use the visual cueing to pace yourself on the pitch reproduction.\n\n\n\n\n\n Press any key to continue.','center','center');
            Screen('Flip',win);
            KbStrokeWait;
        end
        pahandle=PsychPortAudio('Open',[],2,0,fs,2);
        PsychPortAudio('GetAudioData',pahandle,10);

        %probably a better way to organize metronome presentation - based on word presentation return
        word1=[359+100,426,411.7969+100,463];
        word2=[440+100,426,492.7969+100,463];
        word3=[521+100,426,573.7969+100,463];
        word4=[602+100,426,654.7969+100,463];
        word5=[683+100,426,735.7969+100,463];
        
        Screen('Flip',win);
        Screen('FillOval',win, 0, word1);
        Screen('FillOval',win, 0, word2);
        Screen('FillOval',win, 0, word3);
        Screen('FillOval',win, 0, word4);
        Screen('FillOval',win, 0, word5);
        DrawFormattedText(win,'Press any key to start the visual cue.',10,20,0,40);
        Screen('Flip',win);
        KbStrokeWait;
        recordedaudio=[];
        PsychPortAudio('Start',pahandle,0,0,1);
        
        for j=1:5 %present metronome visual cue to pace user producing tones
            if j==1
                Screen('FillOval',win, [0,0,255], word1);
                Screen('FillOval',win,0, word2);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, 0, word4);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==2
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,[0,0,255], word2);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, 0, word4);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==3
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,0, word2);
                Screen('FillOval',win, [0,0,255], word3);
                Screen('FillOval',win, 0, word4);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==4
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,0, word2);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, [0,0,255], word4);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==5
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,0, word2);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, 0, word4);
                Screen('FillOval',win, [0,0,255], word5);
                WaitSecs(0.5);
            end
            Screen('Flip',win);
            audiodata=PsychPortAudio('GetAudioData',pahandle);
            recordedaudio=[recordedaudio,audiodata];
        end
        WaitSecs(1);
        
        PsychPortAudio('Stop',pahandle);
        audiodata=PsychPortAudio('GetAudioData',pahandle);
        PsychPortAudio('Close',pahandle);

        %store audio data and save to .wav files accordingly
        recordedaudio=[recordedaudio,audiodata];
        recordeddata5{i,1}=recordedaudio;
        recordeddata5{i,2}=pitch_config;
        filename=sprintf('task1trial%d.wav',i);
        audiowrite(filename,recordedaudio',fs);
    end

    data.five_tones=recordeddata5;
    Screen('Flip',win);
    DrawFormattedText(win,'In the next portion, you will hear another series shorter of tone sequences.\n\nBetween each sequence you will be asked to vocally reproduce each sequence to the best of your ability.\n\n\n\n\n Press the space bar to continue to the task.','center','center');
    Screen('Flip',win);
    KbStrokeWait;
      
    InitializePsychSound(1);
    recordeddata3=cell(num3trials,2);
    
    for i=1:num3trials %presentation of 3-tone sequences
        Screen('Flip',win);
        DrawFormattedText(win,sprintf('Sequence %d of %d\n\n\nListen carefully to the tones played.',i,num3trials),'center','center');
        Screen('Flip',win);
        [pitch_config,stim,fs]=create_pitches('female',3); %generate pitch_configuations based on female

        WaitSecs(0.5);
        
        pahandle = PsychPortAudio('Open', [], [], 2, fs, nrchannels);
        PsychPortAudio('FillBuffer',pahandle,stim);
        PsychPortAudio('Start',pahandle,1,0,1);
        PsychPortAudio('Stop',pahandle,1);
        PsychPortAudio('Close',pahandle);
        
        if i==1 %present instructions on first presenation of stimuli
            Screen('Flip',win);
            DrawFormattedText(win,'Now, to the best of you ability, repeat the prior sequence back vocally into the microphone using the syllable ''ah''.\n\nLeave space between each syllable as you heard in the playback. \n\n\n\n Use the visual cueing to pace yourself on the pitch reproduction.\n\n\n\n\n\n Press any key to continue.','center','center');
            Screen('Flip',win);
            KbStrokeWait;
        end
        pahandle2=PsychPortAudio('Open',[],2,0,fs,2);
        PsychPortAudio('GetAudioData',pahandle,10);

        Screen('Flip',win);
        Screen('FillOval',win, 0, word1);
        Screen('FillOval',win, 0, word3);
        Screen('FillOval',win, 0, word5);
        DrawFormattedText(win,'Press any key to start the visual cue.',10,20,0,40);
        Screen('Flip',win);
        
        KbStrokeWait;
        PsychPortAudio('Start',pahandle,0,0,1);

        recordedaudio=[];
        for j=1:2:5 %present visual stimuli to pace user
            if j==1
                Screen('FillOval',win, [0,0,255], word1);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==3
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,[0,0,255], word3);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==5
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, [0,0,255], word5);
                WaitSecs(0.5);
            end 
            Screen('Flip',win);
                   
            %begin to collect sound from PsychPortAudio
            audiodata=PsychPortAudio('GetAudioData',pahandle);
            recordedaudio=[recordedaudio,audiodata];           
        end
        WaitSecs(1);
        PsychPortAudio('Stop',pahandle);
               
        audiodata=PsychPortAudio('GetAudioData',pahandle);
        recordedaudio=[recordedaudio,audiodata];
        PsychPortAudio('Close',pahandle);
        recordeddata3{i,1}=recordedaudio;
        recordeddata3{i,2}=pitch_config;
        filename=sprintf('task2trial%d.wav',i);
        audiowrite(filename,recordedaudio',fs);
    end
    WaitSecs(0.5);
    data.three_tones=recordeddata3;
    
    %save the results
    save results.mat data recordeddata3 recordeddata5 

    Screen('Flip',win);
    DrawFormattedText(win,'You have reached the end of the trial. Thank you for your participation!','center','center');
    Screen('Flip',win);
    WaitSecs(3);
    Screen('CloseAll');
    
    
elseif strcmp(gender,'male') %present same experiment but for male - repetative code to be fixed later
    %data structure to store all results in an organized fashion
    data=struct;
    data.gen=gender;
    nrchannels=2;
    recordeddata5=cell(num5trials,2);
    
    for i=1:num5trials
        InitializePsychSound(1)
        [pitch_config,stim,fs]=create_pitches(gender,5);
        DrawFormattedText(win,sprintf('Sequence %d of %d\n\n\nListen carefully to the tones played.',i,num5trials),'center','center');
        Screen('Flip',win);
        WaitSecs(2);
        
        %open sound presentation buffers
        pahandle = PsychPortAudio('Open', [], [], 2, fs, nrchannels);
        PsychPortAudio('FillBuffer',pahandle,stim);
        PsychPortAudio('Start',pahandle,1,0,1);
        PsychPortAudio('Stop',pahandle,1);
        PsychPortAudio('Close',pahandle);
        
        WaitSecs(1);
        
        if i==1 %present instructions upon first trial
            Screen('Flip',win);
            DrawFormattedText(win,'Now, to the best of you ability, repeat the prior sequence back vocally into the microphone using the syllable ''ah''.\n\nLeave space between each syllable as you heard in the playback. \n\n\n\n Use the visual cueing to pace yourself on the pitch reproduction.\n\n\n\n\n\n Press any key to continue.','center','center');
            Screen('Flip',win);
            KbStrokeWait;
        end
        pahandle=PsychPortAudio('Open',[],2,0,fs,2);
        PsychPortAudio('GetAudioData',pahandle,10);
        
        %generating positions of metronome presentation - probably a better way
        word1=[359+100,426,411.7969+100,463];
        word2=[440+100,426,492.7969+100,463];
        word3=[521+100,426,573.7969+100,463];
        word4=[602+100,426,654.7969+100,463];
        word5=[683+100,426,735.7969+100,463];
        
        Screen('Flip',win);
        Screen('FillOval',win, 0, word1);
        Screen('FillOval',win,0, word2);
        Screen('FillOval',win, 0, word3);
        Screen('FillOval',win, 0, word4);
        Screen('FillOval',win, 0, word5);
        DrawFormattedText(win,'Press any key to start the visual cue.',10,20,0,40);
        Screen('Flip',win);
        KbStrokeWait;
        recordedaudio=[];
        PsychPortAudio('Start',pahandle,0,0,1);
        
        for j=1:5 %presentation of 5-tone sequence stimuli
            if j==1
                Screen('FillOval',win, [0,0,255], word1);
                Screen('FillOval',win,0, word2);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, 0, word4);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==2
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,[0,0,255], word2);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, 0, word4);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==3
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,0, word2);
                Screen('FillOval',win, [0,0,255], word3);
                Screen('FillOval',win, 0, word4);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==4
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,0, word2);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, [0,0,255], word4);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==5
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,0, word2);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, 0, word4);
                Screen('FillOval',win, [0,0,255], word5);
                WaitSecs(0.5);
                
            end
            Screen('Flip',win);
            
            %collect audio data from microphone input card
            audiodata=PsychPortAudio('GetAudioData',pahandle);
            recordedaudio=[recordedaudio,audiodata];
        end
        WaitSecs(1);
        
        PsychPortAudio('Stop',pahandle);
        audiodata=PsychPortAudio('GetAudioData',pahandle);
        PsychPortAudio('Close',pahandle);
        
        recordedaudio=[recordedaudio,audiodata];
        recordeddata5{i,1}=recordedaudio;
        recordeddata5{i,2}=pitch_config;
        filename=sprintf('task1trial%d.wav',i);
        audiowrite(filename,recordedaudio',fs);
    end

    %save recorded results
    data.five_tones=recordeddata5;
    Screen('Flip',win);
    DrawFormattedText(win,'In the next portion, you will hear another series shorter of tone sequences.\n\nBetween each sequence you will be asked to vocally reproduce each sequence to the best of your ability.\n\n\n\n\n Press the space bar to continue to the task.','center','center');
    Screen('Flip',win);
    KbStrokeWait;
      
    InitializePsychSound(1);
    recordeddata3=cell(num3trials,2);
    
    for i=1:num3trials %present 3-tone sequence stimuli
        Screen('Flip',win);
        DrawFormattedText(win,sprintf('Sequence %d of %d\n\n\nListen carefully to the tones played.',i,num3trials),'center','center');
        Screen('Flip',win);
        [pitch_config,stim,fs]=create_pitches(gender,3);

        WaitSecs(0.5);
        
        pahandle = PsychPortAudio('Open', [], [], 2, fs, nrchannels);
        PsychPortAudio('FillBuffer',pahandle,stim);
        PsychPortAudio('Start',pahandle,1,0,1);
        PsychPortAudio('Stop',pahandle,1);
        PsychPortAudio('Close',pahandle);
        
        if i==1
            Screen('Flip',win);
            DrawFormattedText(win,'Now, to the best of you ability, repeat the prior sequence back vocally into the microphone using the syllable ''ah''.\n\nLeave space between each syllable as you heard in the playback. \n\n\n\n Use the visual cueing to pace yourself on the pitch reproduction.\n\n\n\n\n\n Press any key to continue.','center','center');
            Screen('Flip',win);
            KbStrokeWait;
        end
        pahandle2=PsychPortAudio('Open',[],2,0,fs,2);
        PsychPortAudio('GetAudioData',pahandle,10);

        Screen('Flip',win);
        Screen('FillOval',win, 0, word1);
        Screen('FillOval',win, 0, word3);
        Screen('FillOval',win, 0, word5);
        DrawFormattedText(win,'Press any key to start the visual cue.',10,20,0,40);
        Screen('Flip',win);
        
        KbStrokeWait;
        PsychPortAudio('Start',pahandle,0,0,1);

        recordedaudio=[];
        for j=1:2:5
            if j==1
                Screen('FillOval',win, [0,0,255], word1);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==3
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win,[0,0,255], word3);
                Screen('FillOval',win, 0, word5);
                WaitSecs(0.5);
            elseif j==5
                Screen('FillOval',win, 0, word1);
                Screen('FillOval',win, 0, word3);
                Screen('FillOval',win, [0,0,255], word5);
                WaitSecs(0.5);
            end 
            Screen('Flip',win);           
            audiodata=PsychPortAudio('GetAudioData',pahandle);
            recordedaudio=[recordedaudio,audiodata];           
        end
        WaitSecs(1);
        PsychPortAudio('Stop',pahandle);

        audiodata=PsychPortAudio('GetAudioData',pahandle);
        recordedaudio=[recordedaudio,audiodata];
        PsychPortAudio('Close',pahandle);
        recordeddata3{i,1}=recordedaudio;
        recordeddata3{i,2}=pitch_config;
        filename=sprintf('task2trial%d.wav',i);
        audiowrite(filename,recordedaudio',fs);
    end
    WaitSecs(0.5);
    data.three_tones=recordeddata3;
    
    %save results
    save results.mat data recordeddata3 recordeddata5 

    Screen('Flip',win);
    DrawFormattedText(win,'You have reached the end of the trial. Thank you for your participation!','center','center');
    Screen('Flip',win);
    WaitSecs(3);
    Screen('CloseAll');
    
    
end

end
