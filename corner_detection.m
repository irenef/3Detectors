function final_output = corner_detection(input_image, gaussian_sigma, gaussian_size, nbh_size, thresh) 
    numRows = size(input_image, 1);
    numCols = size(input_image, 2); 
    l2_list = [];
    corner_x = [];
    corner_y = [];
    
    image = rgb2gray(input_image);
    [gaussian_dx, gaussian_dy] = dev_gaussian(image, gaussian_sigma, gaussian_size);
    [l2_list, corner_y, corner_x] = eigen_list(gaussian_dx, gaussian_dy, thresh);
    [l2_list_sorted, corner_y_sorted, corner_x_sorted] = sort(l2_list, corner_y, corner_x);
    [corner_y_final, corner_x_final] = delete_nbrs(l2_list_sorted, corner_y_sorted, corner_x_sorted);
    draw_corners(corner_y_final, corner_x_final);
    
    final_output = input_image;
    
    function output = draw_rectangle(im, x, y) 
        output = im;
        n = 20;
        if (x-(n/2)>0 && y-(n/2)>0 && x+(n/2)<numCols && y+(n/2)<numRows)
            for i = -(n/2) : (n/2)
                output(y-(n/2), x+i) = 0;
                output(y+(n/2), x+i) = 0;
                output(y+i, x-(n/2)) = 0;
                output(y+i, x+(n/2)) = 0;
            end
        else
            
        end
    end
    
    function draw_corners(corner_y, corner_x) 
        for i = 1 : size(corner_x,2)
            if corner_x(i) ~= -1
                input_image = draw_rectangle(input_image, corner_x(i), corner_y(i));
            end
        end
    end
    
    % delete neighbors
    function [corner_y, corner_x] = delete_nbrs(l2_list, corner_y, corner_x) 
        for i = 1 : (size(l2_list,2)-1)
            for j = (i+1) : size(l2_list,2)
                if ((abs(corner_x(i)-corner_x(j)) <= nbh_size) && (abs(corner_y(i)-corner_y(j)) <=nbh_size))
                    corner_x(j) = -1; 
                    corner_y(j) = -1; 
                end
            end
        end
    end
    
    function [l2_list, corner_y, corner_x] = sort(l2_list, corner_y, corner_x)
        for i = 1:size(l2_list,2)
            for j = 1:(size(l2_list,2)-1)
                v1 = l2_list(j);
                v2 = l2_list(j+1);
                if v1 < v2
                    tmp = v1;
                    l2_list(j) = v2;
                    l2_list(j+1) = tmp;
                    tmp = corner_x(j);
                    corner_x(j) = corner_x(j+1);
                    corner_x(j+1) = tmp;
                    tmp = corner_y(j);
                    corner_y(j) = corner_y(j+1);
                    corner_y(j+1) = tmp;
                end
            end
        end
    end
    
    function [l2_list, corner_y, corner_x] = eigen_list(gaussian_dx, gaussian_dy, thresh)
        frame_size = floor(nbh_size/2);
        corner_x = [];
        corner_y = [];
        l2_list = []; 
        
        for y_i = (frame_size+1) : (numRows-frame_size)
            for x_i = (frame_size+1) : (numCols-frame_size)
                c1 = 0;
                c2 = 0; 
                c4 = 0;
                % kernel
                for y_k = -frame_size : frame_size
                    for x_k = -frame_size : frame_size
                        dx = gaussian_dx(y_i+y_k, x_i+x_k);
                        dy = gaussian_dy(y_i+y_k, x_i+x_k);
                        c1 = c1 + dx^2;
                        c2 = c2 + dx*dy;
                        c4 = c4 + dy^2;
                    end
                end
                C = [c1, c2; c2, c4];
                eigenvalues = eig(C); 
                l2 = min(eigenvalues(1), eigenvalues(2));
                if l2 > thresh
                    l2_list = [l2_list l2];
                    corner_x = [corner_x x_i];
                    corner_y = [corner_y y_i];
                end
            end
        end
    end

end