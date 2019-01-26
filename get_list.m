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

%load consensus and indexes of the target objects



if strcmp(select, 'd')
    load(strcat(mainFolder,'/output/consensus_row.mat'))
    load(strcat(mainFolder,'/output/consensus_col.mat'))
    load(strcat(mainFolder,'/output/rTarg.mat'))
    load(strcat(mainFolder,'/output/cTarg.mat'))

    %load the files in "objects", corresponding to the name of the target
    %objects
    filePattern = fullfile(strcat(mainFolder,'/objects/', '*.mat'));
    matFiles = dir(filePattern);
    load(strcat(mainFolder, '/objects/',matFiles(rTarg).name))
    vett_r = vett; %unique objects rows
    load(strcat(mainFolder,'/objects/',matFiles(cTarg).name))
    vett_c = vett; %unique objects columns

    for r=1:length(vett_r)
        for c=1:length(vett_c)
            elementA = vett_r(r);
            elementA = elementA{1};

            elementB   = vett_c(c);
            elementB   = elementB{1};

            % check for elements >0 for row rule
            if (consensus_row(r,c)>0)
                dlmwrite ( ...
                strcat(mainFolder,'/output/new_found_relations_row.csv'), [ ...
                elementA ',' elementB ',' ...
                num2str(consensus_row(r,c)) ',' ...
                ], 'delimiter', '', '-append');
            end

            % check for elements >0 for column rule
            if (consensus_col(r,c)>0)
                dlmwrite ( ...
                strcat(mainFolder,'/output/new_found_relations_col.csv'), [ ...
                elementA ',' elementB ',' ...
                num2str(consensus_col(r,c)) ',' ...
                ], 'delimiter', '', '-append');
            end
        end
    end
else
    load(strcat(mainFolder, '/output/consensus.mat'));
    load(strcat(mainFolder,'/output/index_target.mat'));

    %load the file corresponding to the name of the target
    %object
    filePattern = fullfile(strcat(mainFolder,'/objects/', '*.mat'));
    matFiles = dir(filePattern);
    load(strcat(mainFolder,'/objects/',matFiles(index_target).name));
    
    for r=1:length(vett)
        for c=1:length(vett)
            elementA = vett(r);
            elementA = elementA{1};

            elementB   = vett(c);
            elementB   = elementB{1};

            % check for elements >0 for same-object
            if (consensus(r,c)>0)
                dlmwrite ( ...
                strcat(mainFolder,'/output/new_found_relations.csv'), [ ...
                elementA ',' elementB ',' ...
                num2str(consensus(r,c)) ',' ...
                ], 'delimiter', '', '-append');
            end
        end
    end

end
