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

function [MAT]=get_teta(filename,obj_unici)

n=length(obj_unici);

[el1, el2, w] = textread(filename,'%s %s %f','headerlines',0,'delimiter',','); 

ind_riga=zeros(1,length(w));
ind_col=zeros(1,length(w));

for k=1:length(w)
    ind_riga(k)=find(strcmp(el1{k},obj_unici));
    ind_col(k)=find(strcmp(el2{k},obj_unici));
end

ind_diag= 1:n ;
val_diag = -ones(1,n);

index1=cat(2,ind_riga',ind_col',w);
index2=cat(2,ind_col',ind_riga',w);
index3=cat(2,ind_diag',ind_diag',val_diag');

indTOT=[index1;index2;index3];
ind_simm=unique(indTOT,'rows');

MAT=sparse(ind_simm(:,1),ind_simm(:,2),ind_simm(:,3),n,n);

end



