% test edge detection
% edge detection on mandrill.jpg
% parameters: image, sigma, gaussian size, t1, t2
image = imread('img/mandrill.jpg');
image1 = edge_detection(image, 'output/mandrill', 'y', 1, 9, 0.003, 0.01);
image2 = edge_detection(image, 'output/mandrill', 'n', 2, 9, 0.003, 0.025);
image3 = edge_detection(image, 'output/mandrill', 'n', 2, 16, 0.004, 0.03);
imwrite(image1, 'output/edge_mandrill1', 'jpg');
imwrite(image2, 'output/edge_mandrill2', 'jpg');
imwrite(image3, 'output/edge_mandrill3', 'jpg');

% edge detection on csbldg.jpg
image = imread('img/csbldg.jpg');
image1 = edge_detection(image, 'output/csbldg', 'y', 2, 9, 0.003, 0.001);
image2 = edge_detection(image, 'output/csbldg', 'n', 1, 9, 0.003, 0.025);
image3 = edge_detection(image, 'output/csbldg', 'n', 2, 16, 0.004, 0.03);
imwrite(image1, 'output/edge_csbldg1', 'jpg');
imwrite(image2, 'output/edge_csbldg2', 'jpg');
imwrite(image3, 'output/edge_csbldg3', 'jpg');

% test corner detection
% corner detection on csbldg.jpg
% parameters: image, sigma, gaussian size, neighborhood size, threshold
image = imread('img/csbldg.jpg');
image1 = corner_detection(image, 2, 9, 9, 0.05);
image2 = corner_detection(image, 2, 9, 9, 0.04);
image3 = corner_detection(image, 2, 16, 9, 0.04);
imwrite(image1, 'output/corner_csbldg1', 'jpg');
imwrite(image2, 'output/corner_csbldg2', 'jpg');
imwrite(image3, 'output/corner_csbldg3', 'jpg');

% corner detection on checker.jpg
image = imread('img/checker.jpg');
image1 = corner_detection(image, 2, 9, 9, 0.05);
image2 = corner_detection(image, 2, 9, 15, 0.05);
imwrite(image1, 'output/corner_checker1','jpg');
imwrite(image2, 'output/corner_checker2','jpg');

% test blob detection 
% parameters: image, gaussian size, number of scales(sigma), threshold 
% blob detection on butterfly.png
image = imread('img/butterfly.png');
image1 = blob_detection(image, 6, 10, 0.16);
imwrite(image1, 'output/blob_butterfly1', 'jpg');

