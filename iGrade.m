function iGrade(day,whichQuestion)
% Writes a tab-delimited file [day].txt with the score for one question for
% each student.
% Assumes student files have the correct name, and that each student has a
% subfolder in the pwd folder '[day]'.

if nargin < 2
    error('iGrade:whichQuestion','Which question do you want to grade?')
end

system(['rm ' day '/.DS_Store'])
allNames = dir(day);
allNames = arrayfun(@(x) x.name,allNames,'UniformOutput',false);
allNames(1:2) = []; %remove folders '.' and '..'

fileID = fopen([day num2str(whichQuestion) '.txt'],'wt');
fprintf(fileID,'Name, Number, activity \r\n');

for k=1:length(allNames)
    student = allNames{k};
    [name,ID] = readIDfile(day,student);
    switch whichQuestion
        case 1
            points = gradeA1(day,student);
        case 2
            points = gradeA2(day,student);
        case 3
            points = gradeFZ(day,student);
        case 4
            points = gradeAct2(day,student);           
    end
    fprintf(fileID,'%6s, %0.1d, %1.1f \r\n',name,ID,points);
    close all
end

fclose(fileID);


function [name,ID] = readIDfile(day,student)
    IDFile = fopen([day '/' student '/ID.txt'],'r');
    data = textscan(IDFile, '%s %s', 'Delimiter', ':');
    name = data{1,2}{1};
    ID = str2double(data{1,2}{2});


function points = gradeA1(day,student)
homedir = pwd;
try
    run([day '/' student '/findzero'])
    axis normal
    scrsz = get(0,'ScreenSize'); figure('Position',[0 scrsz(4) scrsz(3)/4 scrsz(4)/2]) % avoids plots being on top of each other
    cd(homedir)
    activity1(day);
    clc;
    disp(student)
    waitforbuttonpress
    points = 2; % 2 points for correct plot
catch
    points = NaN; % NaN indicates missing file
    if exist([day '/' student '/findzero'],'file')
        points = 1; % 1 point indicates file present, but contains errors
    end
end
cd(homedir)



function points = gradeA2(day,student)
homedir = pwd;
global LOGLEVEL
LOGLEVEL = 1;
f  = @(x) 10*x.*x.*exp(-x) + x - 5;
df = @(x) 20*x.*exp(-x) - 10*x.*x.*exp(-x) + 1;
ab = [2 2];
try
    cd([day '/' student])
    clc
    [mynan,myempty] = findzero(f,df,ab);
    points = 1;
    disp(student)
    waitforbuttonpress
    points = points + isnan(mynan) + isempty(myempty);
catch
    points = NaN;
end
cd(homedir)    


function points = gradeFZ(day,student)
homedir = pwd;
global LOGLEVEL
LOGLEVEL = 1;
f  = @(x) sin(x) ./ x;
df = @(x) -sin(x)./(x.*x) + cos(x)./x;
ab = [4 9];
try
    cd([day '/' student])
    [p,his] = findzero(f,df,ab);
    cd(homedir)
    scrsz = get(0,'ScreenSize'); figure('Position',[0 scrsz(4) scrsz(3)/4 scrsz(4)/2])
    [pc,hisc] = findzero(f,df,ab);
    clc
    disp(student)
    waitforbuttonpress
    if 20==length(his)
        hisc = hisc(1:20);
    end
    points = 10 + 1*myVectorsAlmostEqual(p,pc) + 2*myVectorsAlmostEqual(his,hisc);
catch
    points = NaN;    
end
cd(homedir)
    

function points = gradeAct2(day,student)
homedir = pwd;
try
    run([day '/' student '/activity2'])
    axis normal
    cd(homedir)
    [~,Ysol] = activity2;
    clc;
    disp(student)
    waitforbuttonpress
    points = 2;
catch
    cd(homedir)
    points = NaN;
    if exist([day '/' student '/activity2'],'file')
        points = 1;
    end
end

try
    if myVectorsAlmostEqual(Y_HI_RES,Ysol)
        points = 4;
    end
end
cd(homedir)



function areAlmostEqual = myVectorsAlmostEqual(a,b,tol)
    %to account for small rounding errors
    if nargin < 3
        tol = 0.01;
    end
    if ~all(size(a)==size(b))
        b=b'; % to compare row with col vector just fine
    end
    if ~length(a)==length(b)
        areAlmostEqual = false;
    else
        areAlmostEqual = all(abs(a-b)<tol);
    end



