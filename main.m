% Copyright 2019
% Code by	Simone Marini,
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

format long 

mainFolder = input('input the name of the project folder ', 's')
save([mainFolder '/mainFolder'],'mainFolder');
addpath(mainFolder)
parameters
rmpath(mainFolder)


[R_tmp, R, Theta, dim, Theta_temp]=read_mats(directoryMAT);

dim_g_row=zeros(1,length(R_tmp));
dim_g_col=zeros(1,length(R_tmp));
cs=[0 cumsum(dim)];

for i=1:length(R_tmp)
    dim_g_row(i)=nnz(R(cs(i)+1:cs(i+1),:));
    dim_g_col(i)=nnz(R(:,cs(i)+1:cs(i+1)));
end

% dim_g=[3, 5, 4] % this line is an example of fixing a priori the # of columuns in the G matrix to 3, 5, and 4 in an application with 3 data types.

dim_g=round(((dim_g_row+dim_g_col)/2)/lambda);
dim_g=min(dim_g,dim);

R_targ=R(cs(rTarg)+1:cs(rTarg+1),cs(cTarg)+1:cs(cTarg+1));

parfor rep=1:num_rep
    
    iter=max_iter;  % stop criteria: max iterations
    
    tp = cell(1, length(Theta));
    tn = cell(1, length(Theta));
    
    G=cell(length(R_tmp),1);
    ranks=zeros(size(dim));
    
    for i=1:length(R_tmp)
        ranks(i) = dim_g(i);
        G{i}=sparse(rand(dim(i),ranks(i))*nnz(R)/(numel(R)*1000));
    end
    csr=[0 cumsum(ranks)];
    
    G=blkdiag(G{:});
    norm_old=100000;
    G_old=G;
    
    for i=1:length(Theta)
        tp{i}=getPos(Theta{i});
        tn{i}=getNeg(Theta{i});
    end
    
    disp('Starting trifactorization process...');
  
    
    while iter>0
        iter=iter-1;

        %flag every 10-th iteration for checks
        flag=0;
        if mod(iter,10)==0
            flag=1;
        end
        
        [G,S,norm_new]=trifact_core(G,R,Theta,epsilon,cs,tp,tn,rTarg,cTarg,R_targ,flag,csr);

        if ~isempty(find(isnan(G), 1))
            disp('NaN Found')
            length(find(isnan(G)))
            iter=-1;
            %break;
        end
        
        % checks every 10 iterations
        if flag==1
            
            if norm_new-norm_old > 10e-2 %norm_new > norm_old
                disp('Warning: new norm more than 1% larger than old norm.')
                disp(['rep=' num2str(rep) '  num_iter=' num2str(iter) '   norm_new=' num2str(norm_new)])

            end
            
            disp(['rep=' num2str(rep) '  num_iter=' num2str(iter) '   norm_new=' num2str(norm_new)])
            if norm_old-norm_new<T
                disp('End. Difference of two consecutive iterations < T')
                S_old=S;
                G_old=G;
                break;
            end
            norm_old=norm_new;
            S_old=S;
            G_old=G;
        end
        
        % saves the process every 100 iterations
        if mod(iter,100)==0
            parsave([ 'dump' num2str(rep) '.mat'],{'iter','tp','tn','G','ranks','G_old','S','S_old','csr','norm_new','norm_old'},iter,tp,tn,G,ranks,G_old,S,S_old,csr,norm_new,norm_old);
        end
    end
    
    G1=G_old(cs(rTarg)+1:cs(rTarg+1),csr(rTarg)+1:csr(rTarg+1));
    S12=S_old(csr(rTarg)+1:csr(rTarg+1),csr(cTarg)+1:csr(cTarg+1));
    G2=G_old(cs(cTarg)+1:cs(cTarg+1),csr(cTarg)+1:csr(cTarg+1));
    R_new_targs{rep}=G1*S12*G2';
    disp(['rep=' num2str(rep) '  end   norm_new=' num2str(norm_new)])
    
    if strcmp(select, 's')
         G_targ = G(cs(index_target)+1:cs(index_target+1), csr(index_target)+1:csr(index_target+1));
        % Create the connectivity matrix for objects of the same type
        [~, massimi_ind] = max(G_targ, [], 2);


        conn=zeros(length(massimi_ind),length(massimi_ind));

        for i_riga = 1:length(massimi_ind)
            for i_colonna = i_riga:length(massimi_ind)
                if massimi_ind(i_riga) == massimi_ind(i_colonna)
                    conn(i_riga, i_colonna) = conn(i_riga, i_colonna) +1;
                end
            end
        end
        connectivity{rep}=sparse(conn);
    end
end

if strcmp(select, 'd')
    save(strcat(mainFolder, '/output/R_targ.mat'),'R_new_targs')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          % consensus matrices calculation
          % init
          consensus_row = zeros(size(R_targ));
          consensus_col = zeros(size(R_targ));
          disp('Calculating the consensus matrices...')


          for i=1:length(R_new_targs)
            consensus_tmp_row = find_new_relations(R_targ, R_new_targs{i}, select,i);
            consensus_row = consensus_row + consensus_tmp_row;
            consensus_tmp_col = (find_new_relations(R_targ', R_new_targs{i}', select,i))';
            consensus_col = consensus_col + consensus_tmp_col;
          end

          consensus_row=consensus_row/length(R_new_targs); % rowcentric
          consensus_col=consensus_col/length(R_new_targs); % columncentric

    save(strcat(mainFolder,'/output/consensus_col.mat'),'consensus_col')
    save(strcat(mainFolder,'/output/consensus_row.mat'),'consensus_row')

    R_reconstructed_col = R_targ + consensus_col;
    R_reconstructed_row = R_targ + consensus_row;

    save(strcat(mainFolder,'/output/R_reconstructed_col.mat'),'R_reconstructed_col')
    save(strcat(mainFolder,'/output/R_reconstructed_row.mat'),'R_reconstructed_row')
            %%%%%%%%%%%%RHO%%%%%%%%%%%%%%
            %computes the dispersion coefficient Rho for the current rank values    
            
    for i=1:size(consensus_row,1)
           for j=1:size(consensus_row,2)
                 if ne(i,j)
                    consensus_row(j,i) = consensus_row(i,j);
                 end
           end
    end
    
    for i=1:size(consensus_col,1)
           for j=1:size(consensus_col,2)
                 if ne(i,j)
                    consensus_row(j,i) = consensus_col(i,j);
                 end
           end
    end
            
     consensus1 = full(consensus_row);
            n=size(consensus1,1);
            score = 0;
            for t=1:size(consensus1,1)
                for z=1:size(consensus1,2)
                    score = score + (4*(consensus1(t,z)-0.5)^2);
                end
            end
            Rho1 = (1/n^2) * score;
            
            consensus2 = full(consensus_col);
            n=size(consensus2,1);
            score = 0;
            for t=1:size(consensus2,1)
                for z=1:size(consensus2,2)
                    score = score + (4*(consensus2(t,z)-0.5)^2);
                end
            end
            Rho2 = (1/n^2) * score;
            
            Rho = mean([Rho1 Rho2]);
            save(strcat(mainFolder,'/output/Rho.mat'),'Rho')

    get_list
else
    
    save(strcat(mainFolder,'/output/connectivity.mat'),'connectivity')
    
    consensus = zeros(size(connectivity{1}));
    for i=1:num_rep
        consensus_tmp = find_new_relations(R_targ, connectivity{i}, select,i);
        consensus=consensus+consensus_tmp;
    end
    consensus=consensus/num_rep;
    consensus=sparse(consensus);
    save(strcat(mainFolder,'/output/consensus.mat'),'consensus')
    
    for i=1:size(consensus,1)
                for j=1:size(consensus,2)
                    if ne(i,j)
                    consensus(j,i) = consensus(i,j);
                    end
                end
    end
            
            %%%%%%%%%%%%RHO%%%%%%%%%%%%%%
            %computes the dispersion coefficient Rho for the current rank values
            n=size(consensus,1);

            score = 0;
            for t=1:size(consensus,1)
                for z=1:size(consensus,2)
                    score = score + (4*(consensus(t,z)-0.5)^2);
                end
            end

            Rho = (1/n^2) * score;
    
    get_list
    
end

disp('Finished.')

