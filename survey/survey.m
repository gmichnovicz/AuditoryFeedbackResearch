function survey(filename)
%generated GUI in order for the user to respond to a pre-created survey that was adapted for my need

f = figure('Visible','off','Units', 'normalized','Position',[1,1,1,1], 'Color', [1 1 1]);
set(f, 'Name', 'Musical Questionnaire','NumberTitle','off', 'Resize', 'off');
set(f, 'DefaultUIPanelFontName', 'Helvetica', 'DefaultUIPanelFontSize', 10);
set(f, 'DefaultUIControlFontName', 'Helvetica', 'DefaultUIControlFontSize', 10);
set(f, 'DefaultTextFontName', 'Helvetica', 'DefaultTextFontSize', 10)
movegui(f,'center');
hp = uipanel('Parent',f,'Units','normalized','BackgroundColor','white','Position',[0,0,1,1]);
hp2=uipanel('Parent',f,'Visible','off','Units','normalized','BackgroundColor','white','Position',[0 0 1 1]);
f.Visible='on';

[~,~,q]=xlsread('questions.xlsx');

options=uicontrol('Parent',hp,'Style','text','Units','normalized','Position',[0.05,0.88,0.2,0.09],'String','Please choose a number for your response to the following questions based on the following scale:', ...
    'BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',12,'FontWeight','bold');
optionlist=uicontrol('Parent',hp,'Style','text','Units','normalized','Position',[0.3,0.9,0.66,0.05],'String','1 - Completely Disagree    2 - Strongly Disagree    3 - Disagree    4 - Neither Agree or Disagree    5 - Agree    6 - Stongly Agree    7 - Completely Agree', ...
    'BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',12);
nextpage=uicontrol('Parent',hp,'Style','pushbutton','Units','normalized','Position',[0.93,0.02,0.06,0.04],'String','Next Page','FontName','Times New Roman','Callback',@get_scores);
options2=uicontrol('Parent',hp,'Style','text','Visible','off','Units','normalized','Position',[0.05,0.85,0.6,0.09],'String','Choose a response from the dropdown that best answers the question for you personally.', ...
    'BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',14,'FontWeight','bold','HorizontalAlignment','left');
donebutton=uicontrol('Parent',hp2,'Style','pushbutton','Units','Normalized','Position',[0.89,0.02,0.1,0.1],'String','Finished','FontName','Times New Roman','FontSize',11,'Callback',@complete);
info=uicontrol('Parent',hp2,'Style','text','Units','normalized','Position',[0.38,0.7,0.3,0.2],'String','General Information','FontName','Times New Roman','FontSize',16,'BackgroundColor',[1 1 1],'HorizontalAlignment','center','FontWeight','bold');
age=uicontrol('Parent',hp2,'Style','text','Units','normalized','Position',[0.33,0.62,0.2,0.1],'String','Age:','FontName','Times New Roman','FontSize',12,'BackgroundColor',[1 1 1],'HorizontalAlignment','center');
agedata=uicontrol('Parent',hp2,'Style','edit','Units','normalized','Position',[0.5,0.64,0.1,.1],'BackgroundColor',[1 1 1]);
gender=uicontrol('Parent',hp2,'Style','text','Units','normalized','Position',[0.33,0.45,0.2,0.1],'String','Gender:','FontName','Times New Roman','FontSize',12,'BackgroundColor',[1 1 1],'HorizontalAlignment','center');
genderdata=uicontrol('Parent',hp2,'Style','popup','Units','normalized','Position',[0.5,0.52,.15,0.04],'String',{'Female','Male','Other'},'FontName','Times New Roman','FontSize',12,'BackgroundColor',[1 1 1],'HorizontalAlignment','center');
thankyou=uicontrol('Style','text','Units','normalized','Position',[0.3,0.45,0.4,0.2],'BackgroundColor','White','String','Thank you for your participation!','FontName','Times New Roman','FontSize',14,'Visible','off');
numq=length(q);
for i=1:8
    var=uicontrol('Parent',hp,'Style','text','Units','normalized','Position',[0.05,0.85-(i*0.1),0.3,0.08],'String',sprintf('%s. %s',num2str(i),q{i}),'BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',11,'HorizontalAlignment','left');
end

for i=1:7
    var=uicontrol('Parent',hp,'Style','text','Units','normalized','Position',[0.5,0.85-(i*0.1),0.3,0.08],'String',sprintf('%s. %s',num2str(i+8),q{i+8}),'BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',11,'HorizontalAlignment','left');
end

resp1=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.78,0.03,0.05]);
resp2=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.68,0.03,0.05]);
resp3=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.58,0.03,0.05]);
resp4=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.48,0.03,0.05]);
resp5=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.38,0.03,0.05]);
resp6=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.28,0.03,0.05]);
resp7=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.18,0.03,0.05]);
resp8=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.08,0.03,0.05]);
resp9=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.78,0.03,0.05]);
resp10=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.68,0.03,0.05]);
resp11=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.58,0.03,0.05]);
resp12=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.48,0.03,0.05]);
resp13=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.38,0.03,0.05]);
resp14=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.28,0.03,0.05]);
resp15=uicontrol('Style','popup','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.18,0.03,0.05]);

resp16=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.78,0.03,0.05]);
resp17=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.68,0.03,0.05]);
resp18=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.58,0.03,0.05]);
resp19=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.48,0.03,0.05]);
resp20=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.38,0.03,0.05]);
resp21=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.28,0.03,0.05]);
resp22=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.18,0.03,0.05]);
resp23=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.4,0.08,0.03,0.05]);
resp24=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.78,0.03,0.05]);
resp25=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.68,0.03,0.05]);
resp26=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.58,0.03,0.05]);
resp27=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.48,0.03,0.05]);
resp28=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.38,0.03,0.05]);
resp29=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.28,0.03,0.05]);
resp30=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.18,0.03,0.05]);
resp31=uicontrol('Style','popup','Visible','off','Units','normalized','String',{'1','2','3','4','5','6','7'},'Position',[0.9,0.18,0.03,0.05]);

resp32=uicontrol('Parent',hp,'Style','popup','Units','Normalized','Position',[0.8,0.78,0.1,0.05],'String',{'0','1','2','3','4-5','6-9','10 or more'},'Visible','off');
resp33=uicontrol('Parent',hp,'Style','popup','Units','Normalized','Position',[0.8,0.68,0.1,0.05],'String',{'0','0.5','1','1.5','2','3-4','5 or more'},'Visible','off');
resp34=uicontrol('Parent',hp,'Style','popup','Units','Normalized','Position',[0.8,0.58,0.1,0.05],'String',{'0','1','2','3','4-6','7-10','11 or more'},'Visible','off');
resp35=uicontrol('Parent',hp,'Style','popup','Units','Normalized','Position',[0.8,0.48,0.1,0.05],'String',{'week','month','3-5 months','year','-5 years','5-10 years','10 or more years'},'Visible','off');
resp36=uicontrol('Parent',hp,'Style','popup','Units','Normalized','Position',[0.8,0.38,0.1,0.05],'String',{'0','0.5','1','2','3','4-6','7 or more'},'Visible','off');
resp37=uicontrol('Parent',hp,'Style','popup','Units','Normalized','Position',[0.8,0.28,0.1,0.05],'String',{'0','0.5','1','2','3-5','6-9','10 or more'},'Visible','off');
resp38=uicontrol('Parent',hp,'Style','popup','Units','Normalized','Position',[0.8,0.18,0.1,0.05],'String',{'0','1','2','3','4','5','6 or more'},'Visible','off');
resp39=uicontrol('Parent',hp,'Style','popup','Units','Normalized','Position',[0.8,0.08,0.1,0.05],'String',{'0-15 min','15-30 min','30-60 min','60-90 min','2 hours','2-3 hours','4 hours or more'},'Visible','off');
    
    function get_scores(hobj,eventdata)
        
        persistent numpushed %use persistent in order to track the button pushed
        if isempty(numpushed)
            numpushed=1;
        end
        
        
        if numpushed==1
            for i=1:15
                varname=sprintf('resp%s',num2str(i));
                eval(sprintf('set(%s,''Visible'',''off'')',varname));
            end
            
            for i=16:31
                varname=sprintf('resp%s',num2str(i));
                eval(sprintf('set(%s,''Visible'',''on'')',varname));
            end
            
            for i=1:8
                var=uicontrol('Parent',hp,'Style','text','Units','normalized','Position',[0.05,0.85-(i*0.1),0.3,0.08],'String',sprintf('%s. %s',num2str(i+15),q{i+15}),'BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',11,'HorizontalAlignment','left');
            end
            
            for i=1:7
                var=uicontrol('Parent',hp,'Style','text','Units','normalized','Position',[0.5,0.85-(i*0.1),0.3,0.08],'String',sprintf('%s. %s',num2str(i+24),q{i+24}),'BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',11,'HorizontalAlignment','left');
            end
            numpushed=2;
            
            
            
        elseif numpushed==2 
            numpushed=3;
            
            for i=16:31
                varname=sprintf('resp%s',num2str(i));
                eval(sprintf('set(%s,''Visible'',''off'')',varname));
            end
            
            for i=32:39
                varname=sprintf('resp%s',num2str(i));
                eval(sprintf('set(%s,''Visible'',''on'')',varname));
            end
            
            set(optionlist,'Visible','off');
            set(options,'Visible','off');
            set(options2,'Visible','on');
            
            for i=1:8
                var=uicontrol('Parent',hp,'Style','text','Units','normalized','Position',[0.05,0.85-(i*0.1),0.5,0.08],'String',sprintf('%s. %s',num2str(i+31),q{i+31}),'BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',12,'HorizontalAlignment','left');
            end
            
            for i=1:7
                var=uicontrol('Parent',hp,'Style','text','Units','normalized','Position',[0.5,0.85-(i*0.1),0.3,0.08],'String','','BackgroundColor',[1 1 1],'FontName','Times New Roman','FontSize',11,'HorizontalAlignment','left');
            end
            
        elseif numpushed==3
            set(hp,'Visible','off');
            set(hp2,'Visible','on');
            %set(f,'Position',[0.3 0.4 0.35 0.35])
            numpushed=1;
        end
        
        
        
    end

    function complete(~,~) 
    
    % this function automatically generates the score of the user upon completion - saves grunt work
        set(hp2,'Visible','off');
        set(thankyou,'Visible','on');
        scores=0;
        for i = 1:31
            varname=sprintf('resp%s',num2str(i));
            val=eval(sprintf('(%s.Value)',varname));
            scores=scores+val;
        end
        
        for i = 32:39
            varname=sprintf('resp%s',num2str(i));
            val=eval(sprintf('(%s.Value)',varname));
            scores=scores+val;
        end
        fid=fopen(filename,'A');
        %fprintf(fid,'%s %s %s %s\n',num2str(randi([10000000, 99999999])),agedata.String,genderdata.String{genderdata.Value},num2str(scores));
        
        for i=1:31
            varname=sprintf('resp%s',num2str(i));
            val=eval(sprintf('(%s.Value)',varname));
            fprintf(fid,'%s ',num2str(val));
        end
        for i = 32:39
            varname=sprintf('resp%s',num2str(i));
            val=eval(sprintf('(%s.Value)',varname));
            fprintf(fid,'%s ',num2str(val));
        end
        %generates a random ID for the user 
        fprintf(fid,'\n%s %s %s %s\n\n',num2str(randi([10000000, 99999999])),agedata.String,genderdata.String{genderdata.Value},num2str(scores));

        fclose(fid);
        pause(3)
        delete(f)
        
    end


end
