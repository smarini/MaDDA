% Copyright 2017
% Code by		Simone Marini,
% 			Francesca Vitali,
% 			Andrea Demartini,
% 			Daniele Pala
%
% This file is part of "Matrix trifactorization for discovery of data similarity and association".
%
% "Matrix trifactorization for discovery of data similarity and association" is free software: you
% can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% "Matrix trifactorization for discovery of data similarity and association" is distributed in
% the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% GNU General Public License for more details.
% See the
%
% You should have received a copy of the GNU General Public License
% along with "Matrix trifactorization for discovery of data similarity and association"
% If not, see <http://www.gnu.org/licenses/>.

%% Generates relation matrices from relation lists in pair_value format
clc
clear all
close all

mainFolder = input('input the name of the project folder ', 's')
save('mainFolder','mainFolder');
directoryPV = strcat(strtrim(mainFolder),  '/pair_value');

filePattern = fullfile(directoryPV, '*.csv');
matFiles = dir(filePattern);
arrayNameFile = cell(length(matFiles),1);
obj = cell(1);

multiple_teta =  cell(1,2);
ind=1;
disp('running...')

for k = 1:length(matFiles)
    arrayNameFile{k} = matFiles(k).name;
    strSplitted = regexp(arrayNameFile{k},'[_.]','split');
    if strcmp(strSplitted{1},strSplitted{2})
        if cellfun('isempty',multiple_teta)
            multiple_teta{ind,1} = strSplitted{1};
            multiple_teta{ind,2} = 1;
            ind =ind+1;
        elseif ~ismember(strSplitted(1),multiple_teta(:,1))
            multiple_teta{ind,1} = strSplitted{1};
            multiple_teta{ind,2} = 1;
            ind =ind+1;
        elseif ismember(strSplitted(1),multiple_teta(:,1))
            ind_obj = find(ismember(multiple_teta(:,1),strSplitted(1)));
            multiple_teta{ind_obj,2} = multiple_teta{ind_obj,2} +1;
        end
    end
    
    %array with all the objects
    if k ==1
        obj = strSplitted(1:2);
    else
        obj = [obj strSplitted(1:2)];
    end
end
obj = unique(obj);
obj_vett = cell(1,length(obj));

for n=1:length(obj)
    obj_vett{n}= [];
end

disp('...generating object vectors...')

for i =1:length(obj)
    for j=1:length(obj)
        num2add =[];
        if i==j && ~nnz(cellfun('isempty',multiple_teta))>0
            if ismember(obj(j), multiple_teta(:,1))
                ind_ob =find(ismember(multiple_teta(:,1), obj(j)));
                num2add=1:multiple_teta{ind_ob,2};
            end
        end
        for n_n2ADD =1:max(length(num2add),1)
            string2add='';
            if ~isempty(num2add)
                string2add=['_' num2str(num2add(n_n2ADD))];
            end
            filename = [directoryPV '/' obj{i} '_' obj{j} string2add '.csv'];
            if exist(filename, 'file') == 2
                [el1, el2, weight] = textread(filename,'%s %s %f','headerlines',0,'delimiter',',');
                obj_vett{i} = union(obj_vett{i},el1);
                obj_vett{j} = union(obj_vett{j},el2);
            end
            
        end
    end
end

% double check
obj_unici = cell(1,length(obj));

for t=1:length(obj)
    obj_unici{t}= unique(obj_vett{t});
end

% unique objects are saved in vectors
for tt=1:length(obj)
    nameVett=obj{tt};
    vett=obj_unici{tt};
    directoryOBJ = strcat('./', strtrim(mainFolder),  '/objects');
    filePattern = fullfile(directoryOBJ, nameVett);
    save(filePattern, 'vett')
end

disp('...generating matrices...')

%% costruisco le matrici
% teta matrix
disp('...thetas...')
for i =1:length(obj)
    i
    name_objects = [obj{i} '_' obj{i}];
    if ~cellfun('isempty',multiple_teta)
        if ismember(obj{i}, multiple_teta(:,1))
            ind_obj = find(ismember(multiple_teta(:,1), obj{i}));
            for jj = 1:multiple_teta{ind_obj,2}
                filename = [directoryPV '/' name_objects '_' num2str(jj) '.csv'];
                teta_matr = get_teta(filename,obj_unici{i});
                save([strcat('./', strtrim(mainFolder),  '/matrices/T') num2str(i) '-' num2str(jj) '.mat'], 'teta_matr');
            end
        end
    else
        filename = [directoryPV '/' name_objects '.csv'];
        teta_matr = get_teta(filename,obj_unici{i});
        save ([strcat('./', strtrim(mainFolder),  '/matrices/T') num2str(i) '-1.mat'], 'teta_matr');
    end
    
end
disp('...Rs...')
% R matrix

for m =1:length(obj)
    for n=1:length(obj)
        if m~=n
            name_obj = [obj{m} '_' obj{n}];
            filename = [directoryPV '/' name_obj '.csv'];
            if exist(filename, 'file') == 2
                filename
                R_matr = get_R(obj_unici{m},obj_unici{n},filename);
                save([strcat(strtrim(mainFolder),  '/matrices/R') num2str(m) '-' num2str(n) '.mat'], 'R_matr');
            end
        end
    end
end

