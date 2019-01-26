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

function [R_tmp, R, Theta, dim, Theta_temp]=read_mats(directoryMAT)
% read the matrices, it works also with multiple thetas
% MATRICES MUST BE SPARSE AND SAVED WITH THE .mat EXTENSION

% encoding
% R: R1-2.mat, relation between the objects of type 1 and 2
% Theta: T1-1.mat relation between obects of type 1 e 1, first multiplicity
% Theta: T1-2.mat relation between obects of type 1 e 1, second multiplicity
% Theta: T1-n.mat relation between obects of type 1 e 1, n-th multiplicity

% read the file names
files=dir(directoryMAT);

%calculation of Rs and Thetas

n_matr=1;

for i=1:length(files)   
    name=files(i).name;
    if(strncmpi(name,'.',1))
        continue;
    end
    C=strsplit(name,'.');    
    name2=C{1};
    primo_carattere=name2(1);
    name2 = name2(2:end);
    C=strsplit(name2,'-');
    if str2double(C{1})>n_matr
        n_matr=str2double(C{1});
    end
    if str2double(C{2})>n_matr
        n_matr=str2double(C{2});
    end
end

R_tmp=cell(n_matr);
Theta_temp = cell(n_matr,1);

for i=1:length(files)   
    name=files(i).name;
    if(strncmpi(name,'.',1))
        continue;
    end
    C=strsplit(name,'.');    
    name2=C{1};
    primo_carattere=name2(1);
    name2 = name2(2:end);
    C=strsplit(name2,'-');
    load (strcat(directoryMAT,'/',name));
    if primo_carattere == 'R'
        R_tmp{str2double(C{1}),str2double(C{2})}=R_matr;
        % given R_ij, if the file to create R_ji is present in the
        % directory we read it, if not we create R_ji as the transpose
        % matrix of R_ij
        if isempty(R_tmp{str2double(C{2}),str2double(C{1})});
            R_tmp{str2double(C{2}),str2double(C{1})}=R_tmp{str2double(C{1}),str2double(C{2})}';
        end
        clear R_matr;
    else
       Theta_temp{str2double(C{1}),str2double(C{2})} = teta_matr;
       dim(str2double(C{1})) = size(Theta_temp{str2double(C{1}),str2double(C{2})}, 1);
       clear teta_matr;
    end
end

N=sum(dim);

%R
R=sparse(N,N);
cs=[0 cumsum(dim)];
for i=1:n_matr
    for j=1:n_matr
        if isempty(R_tmp{i,j})
            R_tmp{i,j}=sparse(dim(i),dim(j));
        end
    end
end

disp('Dimensions')
disp(dim)
disp('cs')
disp(cs)

for i=1:length(R_tmp)
    for j=i+1:length(R_tmp)
%        disp(i)
%        disp(j)
%        disp(cs)
%        disp(R_tmp{i,j})
%        disp(size(R_tmp{i,j}))
        R(1+cs(i):cs(i+1),1+cs(j):cs(j+1))=R_tmp{i,j};
        R(1+cs(j):cs(j+1),1+cs(i):cs(i+1))=R_tmp{j,i};
    end
end

%Theta 
Theta = cell(1,size(Theta_temp,2));

% replace the null blocks of Theta_temp with zeros
for i=1:size(Theta_temp,1)
    for j=1:size(Theta_temp,2)
        if isempty(Theta_temp{i,j})
            Theta_temp{i,j}=sparse(dim(i),dim(i));
        end
    end
end


for i=1:size(Theta_temp,2)
    Theta{i} = Theta_temp{1,i};
    for j=2:size(Theta_temp,1)
        Theta{i} = blkdiag(Theta{i},Theta_temp{j,i});
    end
end
