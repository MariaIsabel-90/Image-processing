%%Function to separate the image in background information and 
function    [cluster] = segmentimage(I)
m = size(I,1);% 

%%Step 1
% Segmentation of the image in 2 clusters, without spatial information
%the image in lab space
lab_he = rgb2lab(I);
ab = lab_he(:,:,2:3);
ab = im2single(ab);
% Number of groups
nColors = 2;
%the kmeans clustering version for images
[L,~] = imsegkmeans(ab,nColors,'NormalizeInput',true);  
%separating the clusters
cluster1 = I .* uint8(L==1);
cluster2 = I .* uint8(L==2);
%calculating histograms of pixel intensity. We want to choose the
%cluster with more empty spaces
hist1 = histcounts(cluster1(1:round(m/2),:,:),255);
hist2 = histcounts(cluster2(1:round(m/2),:,:),255);
%first criterea for choosing the right cluster: less pixels with nonzero information  
tnonz_1=sum(hist1(2:end));
tnonz_2=sum(hist2(2:end));

if tnonz_1<tnonz_2
    % To take into account only pixels which does not belong to the background
    %idx = find(cluster1 < 255);
    [row,col] = find(cluster1 < 255);
    % Concatenate them to pixel colors
    featureSet = cat(1,cluster1(cluster1<255),row,col);
    %% Step2
    %performing clustering for the second time, now considering spatial
    %information
    bestk=2;
    rng(1); 
    [L_best,~] = kmeans(double(featureSet),bestk);
    labels = uint8(zeros(size(cluster1)));
    for i=1:size(row)
        labels(row(i),col(i))=L_best(i);
    end
    %saving only the cluster of interest after a second segmentation
    cl1_best = cluster1 .* uint8(labels==1);
    cl2_best = cluster1 .* uint8(labels==2);
    %the best cluster should have more variance
    var1 = var(double(cl1_best(:)));
    var2 = var(double(cl2_best(:))); 
    %plotting the cluster with higher variance
    if var1>var2
        cluster=cl1_best;
    else
        cluster=cl2_best;
    end
    
else
    % To take into account only pixels which does not belong to the background
    [row,col] = find(cluster2 < 255);
    % Concatenate them to pixel colors
    featureSet = cat(1,cluster2(cluster2<255),row,col);
    %% Step2
    %performing clustering for the second time, now with spatial
    %information
    bestk=2;
    [L_best,~] = kmeans(double(featureSet),bestk);
    %%% To create an image with labels
    labels = uint8(zeros(size(cluster2)));
    for i=1:size(row)
        labels(row(i),col(i))=L_best(i);
    end
    %saving only the cluster of interest after a second segmentation
    cl1_best = cluster2 .* uint8(labels==1);
    cl2_best = cluster2 .* uint8(labels==2);
    %the best cluster should have more variance   
    var1 = var(double(cl1_best(:)));
    var2 = var(double(cl2_best(:))); 
    %plotting the cluster with higher variance
    %newfig=figure('visible','off');
    if var1>var2
       cluster=cl1_best;
    else
       cluster=cl2_best;  
    end
end

end
