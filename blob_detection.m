function output_image = blob_detection(input_image, gaussian_size, numSigma, thresh) 
    numRows = size(input_image, 1);
    numCols = size(input_image, 2);
    images = [];
    dogs = [];
    input_image = rgb2gray(input_image);
    input_image = im2double(input_image);
    
    init_images();  
    output_image = scale_selection(input_image);

    % select scales and get DoGs
    function output = scale_selection(input)
        output = input;
        %features = cat(3, features, zeros(numRows, numCols));
        for d = 2: (size(dogs, 3)-1)
            dog1 = dogs(:,:,d-1);
            dog2 = dogs(:,:,d);
            dog3 = dogs(:,:,d+1);
            for y = 3 : numRows-2
                for x = 3 : numCols-2 
                    curr_pixel_value = dog2(y, x); 
                    mat1 = dog1([y-1:y+1],[x-1:x+1]);
                    mat2 = dog3([y-1:y+1],[x-1:x+1]);
                    mat3 = [dog2(y-1,x-1) dog2(y-1,x) dog2(y-1,x+1) dog2(y,x-1) dog2(y,x+1) dog2(y+1,x-1) dog2(y+1,x) dog2(y+1,x+1)];  
                    cube_max = max(max(mat1(:)), max(mat2(:)));
                    cube_max = max(cube_max, max(mat3));
                    cube_min = min(min(mat1(:)), min(mat2(:)));
                    cube_min = min(cube_min, min(mat3));
                    if ((curr_pixel_value > cube_max) || (curr_pixel_value < cube_min))
                        if abs(curr_pixel_value) > thresh
                            side = 10*(sqrt(2)^(d-1));
                            output = draw_rectangle(output, x-floor(side/2), y-floor(side/2), side);
                        end
                    end    
                end 
            end
        end   
    end
    
    function init_images() 
        for i = 1 : numSigma
            images = cat(3, images, gaussian(input_image, sqrt(2)^i, gaussian_size));
        end
        
        for j = 1 : (numSigma-1)
            dogs = cat(3, dogs, images(:,:,j)-images(:,:,j+1));
        end
    end 
    
    function ot_image = gaussian(image, sigma, size) 
        gau_x = zeros(1,size);
        gau_y = zeros(size, 1);
        for r = -floor(size/2):floor(size/2)
            i = r+floor(size/2);
            gau_x(i+1) = (exp(-(r^2)/(2*sigma^2)))/(sqrt(2*pi*sigma^2));
            gau_y(i+1,1) = (exp(-(r^2)/(2*sigma^2)))/(sqrt(2*pi*sigma^2));
        end
       
        ot_image = conv2(gau_x, image);
    end

    function output = draw_rectangle(im, x, y, s) 
        output = im;
        n = 5;
        c = floor(s/2);
        if (x-c>0 && y-c>0 && x+c<numCols && y+c<numRows)
            for i = -c : c
                output(y-c+n, x+i+n) = 0;
                output(y+c+n, x+i+n) = 0;
                output(y+i+n, x-c+n) = 0;
                output(y+i+n, x+c+n) = 0;
            end
        else
            
        end
    end
end