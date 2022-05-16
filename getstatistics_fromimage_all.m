clear 
%to read all the images on the directory
myFolder = '~/all_images';

filePattern = fullfile(myFolder, '*.png'); % Change to whatever pattern you need.
theFiles = dir(filePattern); %structure with all the names of the directory
T = struct2table(theFiles); % convert the struct array to a table
sortedT = sortrows(T, 'date'); % sort the table by 'date'
sortedS = table2struct(sortedT);
clear sortedT T theFiles filePattern myFolder

save_path = '~/stats';

indiv=PCA_random.indiv';
tabela_all = table(indiv,PCA_random.depth');
results2=tabela_all;
tic;
%to get image information from all echograms
for ii=1:38222
    baseFileName = sortedS(ii).name;
    fullFileName = fullfile(sortedS(ii).folder, baseFileName);
    %reading the image
    I = imread(fullFileName); 
    BW = imbinarize(rgb2gray(I),0.4);
    [~, numberOfObjects] = bwlabel(BW);
    cc = bwconncomp(BW); %get connected components in a binary image
    ss = regionprops(cc, 'Area');  
    Area = [ss.Area];
    if numberOfObjects~=1 && any(max(Area)<150000) %get only the bigger connected components
        clear cc
        %I = imread('Echogram_7902.png');
        %segmenting the image with kmeans
        im_sep = segmentimage(I);
        %removing whiskers
        im_nowh = remove_whiskers(im_sep);
       % figure; imshow(im_nowh)    
        cc = bwconncomp(rgb2gray(im_nowh));
        s = regionprops(cc,rgb2gray(im_nowh), {'Area',  'PixelIdxList','MaxIntensity','MeanIntensity','MinIntensity','Orientation'});  
        db_max = max(max((double(rgb2gray(im_nowh)))*80/255));
        db_test = zeros(1,numel(s));
        bw2 = false(size(im2gray(im_nowh)));
        for kk = 1:numel(s)
            db_test(:,kk)=double(max(double(s(kk).MaxIntensity)*80/255));
            if (s(kk).Area>250 && s(kk).Orientation >-4 &&  s(kk).Orientation<4)
                bw2(s(kk).PixelIdxList) = 1;
            elseif db_test(:,kk)>db_max*0.75 
                bw2(s(kk).PixelIdxList) = 1;
            else
                bw2(s(kk).PixelIdxList) = 0;
            end
        end
        Im_final = im_nowh.* uint8(bw2);
        
        %prealocating variables
        area = zeros(1,numel(s));
        ma_int = zeros(1,numel(s));
        
       %separate the RGB channels
        Ir = Im_final(:,:,1);
        Ig = Im_final(:,:,2);
        Ib = Im_final(:,:,3);
        cc = bwconncomp(rgb2gray(Im_final));
        s = regionprops(cc,rgb2gray(Im_final), {'Area',  'PixelIdxList','MaxIntensity','MeanIntensity','MinIntensity','Orientation'});
        for kk = 1:numel(s)
            if s(kk).Orientation ~= 0
                ma_int(:,kk) = s(kk).MaxIntensity;
                area(:,kk)=s(kk).Area;
    
            end
        end
        idx = rgb2gray(Im_final) == 0;  
      
        %save the data in a structure 
        results2.MaxArea(ii) = max(area);
        results2.Maxdb(ii) = double(max(double(ma_int)*80/255));
        results2.MaxintGray(ii) = max(ma_int);
        results2.Areaper(ii) = 100*max(area)/(size(Im_final,1)*size(Im_final,2));
        % Calculate average RGB of the region
        results2.ChannelR(ii) = uint8(mean(Ir(~idx)));
        results2.ChannelG(ii) = uint8(mean(Ig(~idx)));
        results2.ChannelB(ii) = uint8(mean(Ib(~idx))); 
        clear I s cc area ma_int Ir Ig Ib idx im_sep im_nowh Im_final BW numberOfObjects
        %close all
    end
end
toc
writetable(results2,'stats_allechograms.csv')
% Elapsed time is 180823.896881 seconds.
%analyizing suspicious rows
ind_empty=zeros(1,3690);
for ii=1:3690
    baseFileName = sortedS(ind_tolook(ii)).name;
    fullFileName = fullfile(sortedS(ind_tolook(ii)).folder, baseFileName);
    %reading the image
    I = imread(fullFileName); 
    BW = imbinarize(rgb2gray(I),0.4);
    [~, numberOfObjects] = bwlabel(BW);
    if numberOfObjects==1
        ind_empty(:,ii)=ii;
    end
    clear I
end
    
%to get the address of empty images
%to create another table with only the echograms that were reanalyzed
load('index_comparacao.mat', 'ind_qfoiusado')
load('index_comparacao.mat', 'index')
load('index_comparacao.mat', 'ind_rand')
xx=ind_qfoiusado(ind_qfoiusado~=0);
xxx=ind_qfoiusado(1:1336);
x=xxx(xxx~=0);
x=x';
tabela = table(x);
tabela.index = y;
nb_truetif = zeros(1,500);
for ii=1:500
    intt = nb_true(ind_true==ind_tif(ii));
    if ~isempty(intt)
        nb_truetif(:,ii)=intt;
    end
end
