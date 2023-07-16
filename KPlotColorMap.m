function color_map = KPlotColorMap(color_idx,color_num,color_mode)

    color_map1 = [
        20,81,124;
        47,127,193;
        150,195,125;
        243,210,102;
        216,56,58;
        196,151,178;
        169,184,198;
        ];

    color_map2 = [
        242,121,112;
        187,151,39;
        84,179,69;
        50,184,151;
        5,185,226;
        137,131,191;
        199,109,162;
        ];

    color_map3 = [
        219,49,36;
        252,140,90;
        255,223,146;
        144,190,224;
        75,116,178
        ];

    color_map4 = [
        144,201,230;
        33,158,188;
        2,48,71;
        255,183,3;
        251,132,2
        ];

    color_map5 = [
        255,0,0;
        0,0,255;
        hsv2rgb([0.55,1,1])*255;
        hsv2rgb([0.85,1,1])*255;
        hsv2rgb([0.1,1,1])*255;
        hsv2rgb([0.8,1,0.7])*255
        ];
    color_map_cell = {color_map1;color_map2;color_map3;color_map4;color_map5};
    color_map = color_map_cell{color_idx};
    if color_mode == "interp"
        color_map = color_iterp(color_map,color_num);
    else
        color_map = color_map./255;
    end
    

    function new_color_mat = color_iterp(color_mat,color_k)
        now_color_n = size(color_mat,1);
        new_color_mat = zeros(now_color_n,3);
        if now_color_n >= color_k
            new_color_mat = color_mat;
        else
            line_vec = linspace(1,now_color_n,color_k);
            for ii = 1:color_k
                if floor(line_vec(ii)) == line_vec(ii)
                    new_color_mat(ii,:) = color_mat(line_vec(ii),:);
                else
                    now_id = floor(line_vec(ii));
                    now_t = line_vec(ii) - floor(line_vec(ii));
                    color1 = color_mat(now_id,:);
                    color2 = color_mat(now_id+1,:);
                    new_color_mat(ii,:) = color1.*(1-now_t) + color2.*now_t;
                end
            end
        end
        new_color_mat = new_color_mat./255;
    end 
end