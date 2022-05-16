%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Maria Isabel Barros
%This script has the objective of separate the echograms from a specific
%seal. It's based on the script sonar_game_vf
%For now, only PCAs will be studied
%Initially, we study ml18_295a, in PCA_random is indiv=5
%For further analysis we will use 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear 
% close all
% load('~/all_jerks_random_2018.mat'); % make sure the structure ('PCA_random') is being loaded 
% 
% warning off
% 
% load('results_echograms.mat')
% index=1:6655;
% ind_rand = randsample(index,1000);
% for jj=1:1000% input here the index of PCAs to be processed in one go.
%  
%  ii= k_idx(jj);
%   %% load the corresponding sonar data and display it
%   
%   indiv = PCA_random.indiv(ii);
%   if indiv==5
%       switch indiv
%           case 1
%               prefix = 'ml18_292a';
%           case 2
%               prefix = 'ml18_293a';
%           case 3
%               prefix = 'ml18_294a';
%           case 4
%               prefix = 'ml18_294c';
%           case 5
%               prefix = 'ml18_295a';
%           case 6
%               prefix = 'ml18_294d';
%       end
%     %  prefix=PCA_random.prefix(ii);
%      %recdir=(['F:\ml18\' prefix]);
%      recdir = '~/ml18_295a/';
%      pr = PCA_random.pr(ii);
%      toffs = PCA_random.toffs(ii);
%      [yy,fs]=d3wavread([PCA_random.start_time(ii)-PCA_random.toffs(ii)-5 PCA_random.end_time(ii)-PCA_random.toffs(ii)+2],recdir,prefix,'snr');
%      %hh=figure;
%      R = sonar_display(yy,fs);
%       %%we transform the noisy data from the first 10cm into nan to avoid
% % %hindering the threshold choice
%      NL = 20*log10(prctile(reshape(R(400:end-10,:),[],1),10));
%      RR = 20*log10(R)-NL ;
%      RR_gray=db2gray(RR);
%      hh = figure;
%      imagesc((0:size(RR_gray,2)-1)'/pr,(1:size(RR_gray,1))/fs*ss/2,RR_gray),axis xy; colormap jet;
%      caxis([0 255])
%      set(gca,'xticklabel',{[]})
%      set(gca,'yticklabel',{[]})
%      %fName = ['RRnew_',num2str(jj),'.mat'];
%      %save(fName,'RR','RR_gray');
%      fName = ['Echogray_',num2str(jj),'.png'];
%      exportgraphics(hh,fName,'BackgroundColor','none')
% 
%   end
%   
%   
% %     if ~isnan(max_db)
% %         
% %        pause 
% %        close all
% %     end
% %         save(fName,'distance','time','RR','RR_gray')
% %         
% %     end
% %    % end
% %       
% % end
% %  %Now we transform db in grayscale
% %  %RR_corr=db2gray(RR);
% % %save(savefile, 'PCA_ml18295a');
% % close all
%     close all
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%To compare with Pauline results
%N=800;
%same_ana=zeros(1,800);
%for ii=1:800
 %   for jj=1:N
  %      if results_isabel.start_time(jj)==pv2.day(ii)
   %         same_ana(:,ii)=1;
    %    else
     %       same_ana(:,ii)=0;
      %  end
    %end
%end

%getting images according to results_echograms

clear 
close all
load('~/all_jerks_random_2018.mat'); % make sure the structure ('PCA_random') is being loaded 

warning off

load('results_echograms.mat')
% ind_rand = randsample(index,2000);
%ind_qfoiusado = zeros(1,6655);
path_save = '~/echo_trainingdataset/';
for ii=659
    %indiv = results.prefix(ind_rand(ii));
    indiv = results.prefix(ii);
    if indiv~=6
        switch indiv
            case 1
                prefix = 'ml18_292a';
            case 2
                prefix = 'ml18_293a';
            case 3
                prefix = 'ml18_294a';
            case 4
                prefix = 'ml18_294c';
            case 5
                prefix = 'ml18_295a';
            %case 6
                %prefix = 'ml18_294d';
        end
        recdir = ['~/ml18/' prefix]; 
        pr = PCA_random.pr(PCA_random.start_time == results.start_time(ii));

        if ~isempty(pr)
            ind_qfoiusado(:,ii)=ii;
            %get specific areas of the sound record, notably the ones during prey capture attempts (PCA)
            [yy,fs]=d3wavread([PCA_random.start_time(PCA_random.start_time == results.start_time(ii))-PCA_random.toffs(PCA_random.start_time == results.start_time(ii))-5 PCA_random.end_time(PCA_random.start_time == results.start_time(ii))-PCA_random.toffs(PCA_random.start_time == results.start_time(ii))+2],recdir,prefix,'snr');

            %hh=figure;
            R = sonar_display2(yy,fs);
          %%we transform the noisy data from the first 10cm into nan to avoid
          %%hindering the threshold choice
            NL = 20*log10(prctile(reshape(R(400:end-10,:),[],1),10));
            RR = 20*log10(R)-NL ;
            RR_gray=db2gray(RR);
            hh = figure;% if we want to save the images but not display them, we do ('visible','off');
            h =imagesc(time, distance,RR);axis xy; colormap jet
            caxis([2 80])
            set(gca,'xticklabel',{[]})
            set(gca,'yticklabel',{[]})
            fName3 = ['Echogram_',num2str(ii),'.png'];
            exportgraphics(hh,fName3,'Resolution',300) 
            
        end
    end
end


%to find where there is equal o
clear all
%l1=1:18;
l2=20:34;
l3=36:53;
l4=55:66;
l5=68:100;
ltot=[l1,l2,l3,l4,l5];
clear l1 l2 l3 l4 l5
path='/~/Images_echograms/echo_dbscale_mat/';
path_save = '/~/grayimages_tiphaine/';
 for ii=1:length(ltot)
    fname= ['RRnew_',num2str(ltot(ii)),'.mat'];
    load(fname);
    fnamedist=[path,'RRandcoord_',num2str(ltot(ii)),'.mat'];
    load(fnamedist,'distance', 'time');
    hh = figure('visible','off');
    imagesc(time,distance,RR_gray),axis xy;
    caxis([0 255])
    %ylabel('Distance (m)')
    %xlabel('Time (s)')
    set(gca,'xticklabel',{[]})
    set(gca,'yticklabel',{[]})     
    fName2 = [path_save,'Echo_db_',num2str(ltot(ii)),'.png'];
    exportgraphics(hh,fName2,'Resolution',300)
    close all
 end

% load the nc file containing the sensor data
load_nc(['F:\analysis_sonar\data_sonar\' prefix 'sensPJ50.nc'],{'J'}) ;

kj= round(J.sampling_rate*(PCA_random.start_time(ii)-5):J.sampling_rate*(PCA_random.end_time(ii)+30));
    tj= (0:length(kj)-1)/J.sampling_rate ;
    ax(2) = subplot(2,1,2);
    if PCA_random.day(ii) == 1,
    plot(tj,J.data(kj), 'r') ;
    else if PCA_random.day(ii) == -1,
    plot(tj,J.data(kj), 'b') ;
        else plot(tj,J.data(kj), 'k') ;
        end
    end
    grid
    ylabel('Jerk (m/s^3)')
    ylim([0 1500])
    
    linkaxes(ax,'x'); 
