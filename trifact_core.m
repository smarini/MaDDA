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

function [G,S,norm_new]=trifact_core(G,R,Theta,epsilon,cs,tp,tn,rTarg,cTarg,R_targ,flag,csr) 

GG=(G'*G);
m=GG\G';
mr=m*R;

%update S
S=mr*m';
RGS=R*G*S;
SGGS=S*GG*S;

tpg = cell(1, length(Theta));
tng = cell(1, length(Theta));
for i=1:length(Theta)
    tpg{i}=tp{i}*G;
    tng{i}=tn{i}*G;
end
RGSp=getPos(RGS);
RGSn=getNeg(RGS);
SGGSp=getPos(SGGS);
a=G*SGGSp;

SGGSn=getNeg(SGGS);
b=G*SGGSn;
num=RGSp+b;
den=RGSn+a+epsilon;

for i=1:length(Theta)
    num = num + tng{i};
    den = den + tpg{i};
end

update=(num./den).^0.5;
G=update.*G;

if flag==1
    G1=G(cs(rTarg)+1:cs(rTarg+1),csr(rTarg)+1:csr(rTarg+1));
    S12=S(csr(rTarg)+1:csr(rTarg+1),csr(cTarg)+1:csr(cTarg+1));
    G2=G(cs(cTarg)+1:cs(cTarg+1),csr(cTarg)+1:csr(cTarg+1));
    R_new_targ=G1*S12*G2';
    
    norm_new=norm(R_new_targ-R_targ,'fro')^2;
else
    norm_new=0;
end
