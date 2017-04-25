function [gaussian_dx, gaussian_dy] = dev_gaussian(input_image, sigma, size) 
    % construct first derivative of gaussian
    dev_gau_x = zeros(1,size);
    dev_gau_y = zeros(size, 1);
    gau_x = zeros(1,size);
    gau_y = zeros(size, 1);
    for r = -floor(size/2):floor(size/2)
        i = r+floor(size/2);
        gau_x(i+1) = (exp(-(r^2)/(2*sigma^2)))/(sqrt(2*pi*sigma^2));
        gau_y(i+1,1) = (exp(-(r^2)/(2*sigma^2)))/(sqrt(2*pi*sigma^2));
        dev_gau_x(i+1) = - (r*exp(-(r*r)/(2*sigma^2)))/(sqrt(2*pi)*(sigma^2)^(3/2));
        dev_gau_y(i+1,1) = - (r*exp(-(r*r)/(2*sigma^2)))/(sqrt(2*pi)*(sigma^2)^(3/2));
    end
    
    input_image = im2double(input_image);    
    gaussian_dx = conv2(input_image, dev_gau_x);
    gaussian_dx = conv2(gaussian_dx, gau_y);
    gaussian_dy = conv2(input_image, gau_x);
    gaussian_dy = conv2(gaussian_dy, dev_gau_y);
end