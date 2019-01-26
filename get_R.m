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

function [MAT]=get_R(obj_unici1,obj_unici2,filename)

[el1, el2, w] = textread(filename,'%s %s %f','headerlines',0,'delimiter',','); 

m=length(obj_unici1);
n=length(obj_unici2);

ind_riga=zeros(length(w),1);
ind_col=zeros(length(w),1);

for k=1:length(w)
    ind_riga(k)=find(strcmp(el1{k},obj_unici1));
    ind_col(k)=find(strcmp(el2{k},obj_unici2));
end

indTOT=[ind_riga,ind_col,w];
ind=unique(indTOT,'rows');

MAT=sparse(ind(:,1),ind(:,2),ind(:,3),m,n);
