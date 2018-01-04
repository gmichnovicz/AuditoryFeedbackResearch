%% task 1

e3=164.81;
e4=329.63;
gs3=207.65;
gs4=415.3;
f3=174.61;
f4=349.23;
b3=246.94;
b4=493.88;
ds3=155.56;
ds4=311.13;
freq_cell={'e3',e3,'e4',e4,'gs3',gs3,'gs4',gs4,'f3',f3,'f4',f4, ...
    'b3',b3,'b4',b4,'ds3',ds3,'ds4',ds4};

fs=48000;
timevec=0:1/fs:0.5;
task1_cell=cell(1,length(freq_cell));

for i=1:2:length(freq_cell)
    tone=sin(2*pi*freq_cell{i+1}*timevec);
    tone = sin(2*pi*freq_cell{i+1}*timevec).*tukeywin(length(sin(2*pi*freq_cell{i+1}*timevec)))';
    task1_cell{i}=freq_cell{i};
    task1_cell{i+1}=tone;
end


men_stim1to5_mono=[task1_cell{2},task1_cell{6},task1_cell{10},task1_cell{14},task1_cell{18}];
men_stim1to5_stereo=[men_stim1to5_mono;men_stim1to5_mono]; 

% soundsc(men_stim1to5_mono,fs)

women_stim1to5_mono=[task1_cell{4},task1_cell{8},task1_cell{12},task1_cell{16},task1_cell{20}];
women_stim1to5_stereo=[women_stim1to5_mono;women_stim1to5_mono];
% 
% soundsc(women_stim1to5_stereo,fs)

save task1_m.mat men_stim1to5_stereo fs
save task1_f.mat women_stim1to5_stereo fs
%% task 2

a3=220;
a4=440;
fs3=185;
fs4=369.99;
g3=196;
g4=392;
ds3=155.56;
ds4=311.13;
f3=174.61;
f4=349.23;
d3=146.83;
d4=293.66;
as3=233.88;
as4=466.16;
e3=164.81;
e4=329.63;


freq_cell_task2={'a3',a3,'a4',a4,'fs3',fs3,'fs4',fs4,'g3',g3,'g4',g4,'ds3',ds3,'ds4',ds4 ...
    'f3',f3,'f4',f4,'d3',d3,'d4',d4,'as3',as3,'as4',as4,'e3',e3,'e4',e4};

fs=44100;
timevec=0:1/fs:0.5;
task2=cell(1,length(freq_cell_task2));

for i=1:2:length(freq_cell_task2)
    tone=sin(2*pi*freq_cell_task2{i+1}*timevec);
    tone=tone.*tukeywin(length(tone))';
    task2{i}=freq_cell_task2{i};
    task2{i+1}=tone;
end

t2=struct('a3',[task2{2}],'a4',[task2{4}],'fs3',[task2{6}],'fs4',[task2{8}],'g3',[task2{10}],'g4',[task2{12}],'ds3',[task2{14}],'ds4',[task2{16}], ...
    'f3',[task2{18}],'f4',[task2{20}],'d3',[task2{22}],'d4',[task2{24}],'as3',[task2{26}],'as4',[task2{28}],'e3',[task2{30}],'e4',[task2{32}]);

s1_m=[t2.e3,t2.a3,t2.fs3;t2.e3,t2.a3,t2.fs3];
s1_f=[t2.e4,t2.a4,t2.fs4;t2.e4,t2.a4,t2.fs4];

s2_m=[t2.g3,t2.ds3,t2.f3;t2.g3,t2.ds3,t2.f3];
s2_f=[t2.g4,t2.ds4,t2.f4;t2.g4,t2.ds4,t2.f4];

s3_m=[t2.d3,t2.g3,t2.e3;t2.d3,t2.g3,t2.e3];
s3_f=[t2.d4,t2.g4,t2.e4;t2.d4,t2.g4,t2.e4];

s4_m=[t2.d3,t2.f3,t2.a3;t2.d3,t2.f3,t2.a3];
s4_f=[t2.d4,t2.f4,t2.a4;t2.d4,t2.f4,t2.a4];

s5_m=[t2.as3,t2.fs3,t2.e3;t2.as3,t2.fs3,t2.e3];
s5_f=[t2.as4,t2.fs4,t2.e4;t2.as4,t2.fs4,t2.e4];

% for i=1:5
%     eval(sprintf('soundsc(s%d_m,fs)',i))
%     pause(5)
%     eval(sprintf('soundsc(s%d_f,fs)',i))
%     pause(5)
% end

save task2_m.mat s1_m s2_m s3_m s4_m s5_m fs
save task2_f.mat s1_f s2_f s3_f s4_f s5_f fs

