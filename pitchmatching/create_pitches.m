function [pitch_config,stim,fs]=create_pitches(gender,num_pitches)
%function to generate random permutations of pitch sequences and return them 

if strcmp(gender,'male') %must have separate sets of pitches for male versus female
    %set of all frequencies of the even-tempered scale
    c3=130.81;
    cs3=138.59;
    d3=146.83;
    ds3=155.56;
    e3=164.81;
    f3=174.61;
    fs3=185;
    g3=196;
    gs3=207.65;
    a3=220;
    as3=233.08;
    b3=246.94;
    m_opt_pitch={'c3','cs3','d3','ds3','e3','f3','fs3','g3','gs3','a3','as3','b3'};
    m_opt_freq=[c3,cs3,d3,ds3,e3,f3,fs3,gs3,a3,as3,b3];
    fs=48000; %sampling frequency based on sound card used
    timevec=0:1/fs:0.5;
    
    trial_config=randperm(length(m_opt_freq),num_pitches); %random permutation of the given pitches
    pitch_config=m_opt_pitch(trial_config);
    freq=m_opt_freq(trial_config);
    stim=[];
    pitchstring='';
    for i=1:length(freq)
        stim=[stim,sin(2*pi*freq(i)*timevec).*tukeywin(length(sin(2*pi*freq(i)*timevec)))'];
        pitchstring=[pitchstring,pitch_config{i}];
    end %create tone stimulatuion with tukeywin and in stereo form
    stim=repmat(stim,2,1); 
    pitch_config=pitchstring; %return string of pitches used in order to track the order
    
elseif strcmp(gender,'female') %same as above but given female
    c4=261.63;
    cs4=277.18;
    d4=293.66;
    ds4=311.13;
    e4=329.63;
    f4=349.23;
    fs4=369.99;
    g4=392.00;
    gs4=415.3;
    a4=440.00;
    as4=466.16;
    b4=493.88;
    f_opt_pitch={'c4','cs4','d4','ds4','e4','f4','fs4','g4','gs4','a4','as4','b4'};
    f_opt_freq=[c4,cs4,d4,ds4,e4,f4,fs4,gs4,a4,as4,b4];
    fs=48000;
    timevec=0:1/fs:0.5;
    
    trial_config=randperm(length(f_opt_freq),num_pitches);
    pitch_config=f_opt_pitch(trial_config);
    freq=f_opt_freq(trial_config);
    stim=[];
    pitchstring='';
    for i=1:length(freq)
        stim=[stim,sin(2*pi*freq(i)*timevec).*tukeywin(length(sin(2*pi*freq(i)*timevec)))'];
        pitchstring=[pitchstring,pitch_config{i}];
    end
    stim=repmat(stim,2,1);
    pitch_config=pitchstring;
end
