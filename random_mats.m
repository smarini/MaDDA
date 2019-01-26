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

clear all
mainFolder = input('input the name of the project folder in which you desire to save the random matrices', 's')
save('mainFolder','mainFolder');

dim = [50 100 40] %number and dimensions of the object types
lett = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I'];

% Generate a list of .csv files named objectn_objectm.csv, n,m=1:length(dim)
% and the correspondent Theta_matrices.

for i=1:length(dim)
    objects{1,i} = cell(dim(i),1);
    for j=1:dim(i)
        SET = char(['a':'z' '0':'9']) ; % name the objects with random strings
        N = 5 ; 
        NSET = length(SET);
        st1 = ceil(NSET*rand(1,N)) ; % with repeat
        ST1 = SET(st1) ;
        objects{1,i}{j,1} = ST1;
    end
end

for i=1:length(objects)
    for k=1:length(objects)
        for j=1:length(objects{1,i})  
            for n=1:length(objects{1,k})
                val = rand(1);
                spars = rand(1);
                sign = round(rand(1));
                if ne(i,k) 
                    if (j==1&&n==1)
                        fpunt = fopen(strcat(mainFolder, '\pair_value\object',lett(i),'_','object',lett(k),'.csv'),'w');
                    end
                    if spars >= 0.9
                        fprintf(fpunt,'%s,%s,%f\n', objects{1,i}{j,1}, objects{1,k}{n,1}, val);
                    end
                else
                    if (j==1&&n==1)
                        fpunt = fopen(strcat(mainFolder, '\pair_value\object',lett(i),'_object',lett(k),'_1.csv'),'w');
                    end
                    if spars >= 0.9
                        if sign == 1
                            fprintf(fpunt,'%s,%s,%f\n', objects{1,i}{j,1}, objects{1,k}{n,1}, val);
                        else
                            fprintf(fpunt,'%s,%s,%f\n', objects{1,i}{j,1}, objects{1,k}{n,1}, -val);
                        end
                    end
                end
             end
        end
        fclose(fpunt);
    end
end

