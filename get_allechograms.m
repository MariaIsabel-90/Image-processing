%%%%%% Script made by Maria Isabel Barros%%%%%%%%%%%%%%%%%%%
%We want to get all the available echograms in the 2018 file. At the same time, we also want to discard the ones with too much noise, or the ones unusables

clear 
close all
load('~/all_jerks_random_2018.mat'); % make sure the structure ('PCA_random') is being loaded 

warning off

path_save = '~/all_images/';
for ii=2787:size(PCA_random.pr,2)
    %indiv = results.prefix(ind_rand(ii));
    indiv = PCA_random.indiv(ii);
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
        recdir = ['/media/mariaisabel/Seagate Expansion Drive/ml18/' prefix]; 
        pr = PCA_random.pr(ii);

        if ~isempty(pr) % to get only viable echograms
            %read specific parts of the sound record, in particular the ones involved with prey capture
            [yy,fs]=d3wavread([PCA_random.start_time(ii)-PCA_random.toffs(ii)-5 PCA_random.end_time(ii)-PCA_random.toffs(ii)+2],recdir,prefix,'snr');

            %hh=figure;
            R = sonar_display2(yy,fs);
          %%we transform the noisy data from the first 10cm into nan to avoid hindering the threshold choice
            NL = 20*log10(prctile(reshape(R(400:end-10,:),[],1),10));
            RR = 20*log10(R)-NL ;
            RR_gray=db2gray(RR);
            hh = figure('visible','off'); %off option so we don't plot it
            %figure;
            h =imagesc(RR_gray);axis xy; %colormap jet
            caxis([0 255])
            set(gca,'xticklabel',{[]})
            set(gca,'yticklabel',{[]})
            fName3 = [path_save,'Echogram_',num2str(ii),'.png'];
            exportgraphics(hh,fName3,'Resolution',300) 
            
        end
        close all
    end
    clear NL RR RR_gray hh R pr
end
