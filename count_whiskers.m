%%%%%%%%%%%%%%%%%%%Scritpt made by Maria Isabel Barros%%%%%%%%%%%%%%%%%%%%%%%%
%%%%We want to verify the presence of elephant seal's whiskers in sonar images%%%
%Load data
load('/home/mariaisabel/Documents/MATLAB/results_sonargame/files_trainingdataset.mat');
load('ind_training.mat', 'ind_qfoiusado')
load('results_echograms.mat')
ind=ind_qfoiusado(ind_qfoiusado~=0);
clear ind_qfoiusado
%
res_wh = table(ind');
for ii=1:4977
    %create a new table with only the echograms that were analyzed
    res_wh.prefix(ii) = results.prefix(ind(ii));
    res_wh.nb_prey(ii) = results.nb_prey(ind(ii));
    %get echogram filename from table
    baseFileName = sortedS(ii).name;
    fullFileName = fullfile(sortedS(ii).folder, baseFileName);
    %reading the image
    I = imread(fullFileName); 
    %resizing the image
    I2 = imresize(I,[800 1000]);
    %choosing the area with the probable presence 
    lower_end2 = fix(size(rgb2gray(I2),1)*0.97);
    im_sep = segmentimage(I2(lower_end2:end,:,:));
%%Part 1: getting the color of the main regions
    %getting the connected components from the image
    cc = bwconncomp(rgb2gray(im_sep));
    %to get information on these connected components
    s = regionprops(cc, {'Area',  'PixelIdxList', 'MajorAxisLength','Orientation','BoundingBox'});
    bw2 = false(size(im2gray(im_sep)));
    for kk = 1:numel(s)
        if s(kk).Area> 200 && s(kk).Orientation<2 && s(kk).Orientation>-2 && s(kk).Area~=1032
            bw2(s(kk).PixelIdxList) = 1;
        else
           bw2(s(kk).PixelIdxList) = 0;
        end
    end
   % I3 = im_sep.* uint8(bw2);
    %figure; imshow(I3)
    c2 = regionprops(bw2,'Area');
    if size(c2,1)==0
        res_wh.havewhiskers(ii) = 0;
    else
        res_wh.havewhiskers(ii) = 1;
    end
       
end
%put the results in a table
writetable(results,'results_whiskers2.csv')



