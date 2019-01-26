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


num_rep=10;                     % # of runs
directoryMAT=strcat(mainFolder,'/matrices');        % where matrices are to be found
T=10^-4;                        % stop criteria: threshold T for difference of consecutive iterations
lambda = [200 200 200 200 200 200];         % ranking scaling factors
max_iter=1000;                  % stop criteria: maximum iterations
epsilon=10^-16;

% for both 's' and 'd' options
rTarg=6;                        % block-row index of the target matrix
cTarg=3;                        % column-row index of the target matrix

% for 's' option only
index_target = 6;               % index of the G target, i.e. object type we are interested in 

select = 's';  %select = s: use the algorithm to find the relations between objects of the same type
               %select = d: use the algorithm to find the relations between objects of different type

directoryOBJ = './objects';
filePattern = fullfile(directoryOBJ, '*.mat');
matFiles = dir(filePattern);
if ne(length(lambda),size(matFiles,1))
    disp('ERROR: parameter "lambda" must have length equal to the number of Objects! Open the script "parameter" to fix it.');
    break;
end


save('output/rTarg.mat','rTarg');
save('output/cTarg.mat', 'cTarg');
save('output/index_target.mat', 'index_target')
load(strcat('matrices/R',num2str(rTarg),'-',num2str(cTarg)))
save('output/R_Original.mat', 'R_matr');
save('../select.mat', 'select')

    
    
