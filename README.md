# Image-processing

In this repository I present a summary of the methodology and results from my Masters second year's internhip, as well as the Matlab scripts. In this work I intended to study the types of prey targeted by Southern Elephant Seals from micro-sonar attached to their heads. For more details, please refer to my Internship report that is also available in this repository.

## Goals of this work 

The main goal of this work was:
> Develop a methodology for processing micro-sonar images based on image processing and machine learning methods to automatically and efficiently extract relevant information from the obatined echograms.
> Isolate the portion of the dataset where relevant predator-targeted prey encounter signals are present in the echograms,
> Classify these extracted signals into prey type (single vs schooling prey, passive versus active).

## Image segmentation

Once there's much information that would not be useful to prey identification, I decided to separate the main information from the background. The micro-sonar images were processed using k-means unsupervised learning. I used the Image Processing Matlab Toolbox and the function *imsegkmeans*.
A few images of results:
file:///home/isabel/Downloads/Echo_4clusters_43.png![Image segmented in 4 clusters. The main information lies in cluster 2. ](https://user-images.githubusercontent.com/67869172/165357820-1c6aadb0-12a2-401e-aae5-39e1ef3ff78c.png)



