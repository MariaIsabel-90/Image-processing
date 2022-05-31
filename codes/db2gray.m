%%Function that transforms a pseudocolor sonar image into a grayscale image

function    [RR_round] = db2gray(RR)

RR_corr=RR(30:end,:); %cutting the first 10 centimeters of echograms that are noise
%first we transform db in grayscale
db_max=80;
new_rr=RR_corr*255/db_max;
%tranform negative values to 0
new_rr(new_rr<0)=0;
%for grayscale we can only use round numbers
RR_round=round(new_rr);%
end
