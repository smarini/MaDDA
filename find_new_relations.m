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


function [consensus_tmp,consensus_strength]=find_new_relations(R_targ, R_new_targ, select, rep)

if strcmp(select, 'd')
    consensus_tmp = zeros(size(R_new_targ));
    consensus_strength=zeros(size(R_new_targ));
    for row=1:size(R_new_targ, 1)
        original_notable_indexes = find(R_targ(row,:)>0);   %values >0 in the row
        media = mean(R_new_targ(row,original_notable_indexes));  %mean
        if isempty(media);
           ;
        else
            maybe_notable = find(~R_targ(row,:)>0);   %values = 0
            above_average = (R_new_targ(row,:)>media);
            ind_above=find(above_average); %indexes of values > mean
            for i=ind_above
                if (any(i==maybe_notable))
                    consensus_tmp(row,i) = consensus_tmp(row,i)+1;
                    known_vals=(R_new_targ(R_targ(:,i)>0,i));
                    if isempty(known_vals)
                        continue;
                    end
                    strength=sum(known_vals<R_new_targ(row,i));
                    consensus_strength(row,i)=strength;
                end
            end
        end
    end
else
    
    consensus_tmp=R_new_targ;

end


