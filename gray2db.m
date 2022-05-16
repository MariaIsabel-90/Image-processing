% Function to transform a grayscale image in an db scale image 

function    [new_rr] = gray2db(Im)

%RR_corr=RR(30:end,:); %cutting the first 10 centimeters of echograms that are noisy
%first we transform db in grayscale
db_max=80;
new_rr=Im*db_max/255;

end
