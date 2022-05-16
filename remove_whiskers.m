%%%%%%%% Function to remove the whiskers signal at the bottom of the echogram

function    [im_nowhiskers] = remove_whiskers(I2)
I3 = imresize(I2,[800 1000]);
lower_end2 = fix(size(rgb2gray(I3),1)*0.95);
%%Part 1: getting the color of the main regions
cc = bwconncomp(rgb2gray(I3));
s = regionprops(cc, {'Area',  'PixelIdxList', 'MajorAxisLength','MinorAxisLength','BoundingBox'});
bw2 = false(size(im2gray(I3)));
for kk = 1:numel(s)
    if s(kk).Area> 100 && s(kk).BoundingBox(2)>lower_end2
        bw2(s(kk).PixelIdxList) = 1;
    else
       bw2(s(kk).PixelIdxList) = 0;
    end
end
im2 = I3.* uint8(bw2);
Ir = im2(:,:,1);
Ig = im2(:,:,2);
Ib = im2(:,:,3);
idx = rgb2gray(im2) == 0;
% Calculate average RGB of the region
Rave = uint8(mean(Ir(~idx)));
Gave = uint8(mean(Ig(~idx)));
Bave = uint8(mean(Ib(~idx))); 
%Calculate the std of the RGB
Rstd = uint8(std(double(Ir(~idx))));
Gstd = uint8(std(double(Ig(~idx))));
Bstd = uint8(std(double(Ib(~idx))));
%to get the connected components with right size and are not connected
%to preys
mask_whiskers = true(size(I3));
for ii=lower_end2:size(I3,1)
    if ii>lower_end2+4 && ii<lower_end2+42
        for jj=1:size(I3,2)          
            imR = I3(ii,jj,1);
            imG = I3(ii,jj,2);
            imB = I3(ii,jj,3);
            if (imR >= Rave-Rstd)  && (imR <=Rave+Rstd) && (imG >= Gave-Gstd)  && (imG <= Gave+Gstd) && (imB >= Bave-Bstd) && (imB <= Bave+Bstd)
                mask_whiskers(ii,jj,:)=0;
            end
        end
    end
end
im_nowhiskers = I3.* uint8(mask_whiskers);
end
