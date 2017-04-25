function final_output = edge_detection(image, image_name, write_info, gaussian_sigma, gaussian_size, t1, t2)
    numRows = size(image, 1); 
    numCols = size(image, 2);
    
    edges_orientation = zeros(numRows, numCols);
    edges_strength = zeros(numRows, numCols);
    edges_ori_new = zeros(numRows, numCols);
    intensity_map = zeros(numRows, numCols);
    edges = false(numRows, numCols);
    visited = false(numRows, numCols);   
    image = rgb2gray(image);
    

    function canny_enhancer(gradient_x, gradient_y)         
        % edge strength      
        for r = 1:numRows
            for c = 1:numCols
                gx = gradient_x(r, c); 
                gy = gradient_y(r, c);
                edges_strength(r, c) = sqrt(gx*gx+gy*gy);
                edges_orientation(r, c) = atan(gy/gx);
            end
        end
    end

    function nonmax_suppression()
        %find best approximate orientation 
        for r = 2:(numRows-1)
            for c = 2:(numCols-1)
                ori_old = edges_orientation(r, c);
                if ((ori_old >= 0 && ori_old <= pi/8) || (ori_old <= pi && ori_old > (7*pi)/8)) 
                    edges_ori_new(r, c) = 0;
                elseif (ori_old > pi/8 && ori_old <= (pi*3)/8) 
                    edges_ori_new(r, c) = pi/4;
                elseif (ori_old > (pi*3)/8 && ori_old <= (pi*5)/8)
                    edges_ori_new(r, c) = pi/2;
                else 
                    edges_ori_new(r, c) = (pi*3)/4;
                end
            end  
        end

        %suppression
        for r = 2:(numRows-1)
            for c = 2:(numCols-1)
                current_ori = edges_ori_new(r, c);
                % case 1
                if current_ori == 0.0 
                    if (edges_strength(r, c) < edges_strength(r, c-1) || edges_strength(r, c) < edges_strength(r, c+1))
                        intensity_map(r, c) = 0.0;
                    else 
                        intensity_map(r, c) = edges_strength(r, c);
                    end
                end
                % case 2
                if current_ori == pi/4 
                    if (edges_strength(r, c) < edges_strength(r+1, c+1) || edges_strength(r, c) < edges_strength(r-1, c-1))
                        intensity_map(r, c) = 0.0;
                    else 
                        intensity_map(r, c) = edges_strength(r, c);
                    end
                end
                % case 3
                if current_ori == pi/2 
                    if (edges_strength(r, c) < edges_strength(r, c+1) || edges_strength(r, c) < edges_strength(r, c-1))
                        intensity_map(r, c) = 0.0;
                    else 
                        intensity_map(r, c) = edges_strength(r, c);
                    end
                end
                % case 4
                if current_ori == (3*pi)/4
                    if (edges_strength(r, c) < edges_strength(r-1, c+1) || edges_strength(r, c) < edges_strength(r+1, c-1))
                        intensity_map(r, c) = 0.0;
                    else 
                        intensity_map(r, c) = edges_strength(r, c);
                    end
                end
            end
        end
    end 

    function hysteresis_thresh() 
        for r = 2:(numRows-1)
            for c = 2:(numCols-1)
                if ~visited(r, c)
                    if intensity_map(r, c) > t2
                        recur_contour(r, c);
                    end
                end
            end
        end
    end

    function recur_contour(r, c) 
        if ~visited(r, c)
            visited(r, c) = true;
            if intensity_map(r, c) > t1
                edges(r, c) = true; 
                
                curr_ori = edges_ori_new(r, c);
                if curr_ori == 0 
                    recur_contour(r-1, c);
                    recur_contour(r+1, c);
                elseif curr_ori == pi/4
                    recur_contour(r+1, c-1);
                    recur_contour(r-1, c+1);
                elseif curr_ori == pi/2
                    recur_contour(r, c+1);
                    recur_contour(r, c-1);
                else
                    recur_contour(r-1, c-1);
                    recur_contour(r+1, c+1);
                end
            end
        end        
    end

    function canny_image() 
         for r = 2:(numRows-1)
            for c = 2:(numCols-1)
                if edges(r, c) == true
                    image(r, c) = 255; 
                else 
                    image(r, c) = 0;
                end
            end
         end
         final_output = image;
    end

    [gradient_x, gradient_y] = dev_gaussian(image, gaussian_sigma, gaussian_size);
    canny_enhancer(gradient_x, gradient_y);
    mag_1 = edges_strength;
    nonmax_suppression();
    hysteresis_thresh();
    mag_2 = intensity_map;
    canny_image();
       
    if write_info == 'y'
        % the smoothed horizontal and vertical gradient
        % the gradient magnitude
        % gradient magnitude after nonmaximum suppression. 
        imwrite(gradient_x, strcat(image_name,'_gradient_x'), 'jpg');
        imwrite(gradient_y, strcat(image_name,'_gradient_y'), 'jpg');
        imwrite(mag_1, strcat(image_name,'_mag1'), 'jpg');
        imwrite(mag_2, strcat(image_name,'_mag2'), 'jpg');
    end
end
