function easyKPlot(fig,varargin)
    p = inputParser;
    addOptional(p,"fig",0);
    addOptional(p,"marginleft",0);
    addOptional(p,"marginright",0);
    addOptional(p,"margindown",0);
    addOptional(p,"margintop",0);
    addOptional(p,"fontsize",22);
    addOptional(p,"fontname","Times New Roman");
    addOptional(p,"fontweight","bold");
    addOptional(p,"color_num","auto");
    addOptional(p,"color_map_id",5);
    addOptional(p,"color_mode","origin");
    addOptional(p,"data_down_sample",false);
    addOptional(p,"data_down_n",100);
    addOptional(p,"partial_enlarge",false);
    addOptional(p,"rect_info",0);
    addOptional(p,"markersize",8);
    addOptional(p,"plot_linewidth",2);
    addOptional(p,"axes_linewidth",1.5);
    parse(p,varargin{:});
    marginleft = p.Results.marginleft;
    marginright = p.Results.marginright;
    margindown = p.Results.margindown;
    margintop = p.Results.margintop;
    color_num = p.Results.color_num;
    fontname = p.Results.fontname;
    fontsize = p.Results.fontsize;
    fontweight = p.Results.fontweight;
    color_map_id = p.Results.color_map_id;
    color_mode = p.Results.color_mode;
    data_down_sample = p.Results.data_down_sample;
    data_down_n = p.Results.data_down_n;
    markersize = p.Results.markersize;
    partial_enlarge = p.Results.partial_enlarge;
    rect_info = p.Results.rect_info;
    axes_linewidth = p.Results.axes_linewidth;
    plot_linewidth = p.Results.plot_linewidth;
    marker_tbl = ["o";"*";"^";"h";">";"s";"<";"x";"p";"diamond"];
    linestyle_tbl = ["-";"--";"-.";":"];
    for fig_child_id = 1:length(fig.Children)
        now_child = fig.Children(fig_child_id);
        fig_child_class = class(now_child);
        fig_child_class = regexprep(...
            fig_child_class,...
            "(axis)|(matlab)|(graphics)|(illustration)|(chart)|(primitive)|(layout)|[.]",...
            "");
        
        if fig_child_class == "Axes"
            do_axes(now_child);
        elseif fig_child_class == "Legend"
            set(now_child,"Orientation","Horizontal");
        elseif fig_child_class == "TiledChartLayout"
            for sub_ci = 1:length(now_child.Children)
                sub_obj = now_child.Children(sub_ci);
                fprintf(class(sub_obj));
                now_sub_class = class(sub_obj);
                now_sub_class = regexprep(...
                    now_sub_class,...
                    "(axis)|(matlab)|(graphics)|(chart)|(primitive)|(layout)|[.]",...
                    "");
                if now_sub_class == "Axes"
                    do_axes(sub_obj);
                end
            end
        end
    end
    set(fig,'outerposition',get(0,'screensize'));

    function do_axes(ax_obj)
        set(ax_obj,...
            'box','on',...
            'linewidth',axes_linewidth,...
            'fontsize',fontsize,...
            'fontname',fontname,...
            'fontweight',fontweight);
        plot_line = ax_obj.Children();
        plot_x1 = 0;
        plot_y1 = 0;
        plot_x2 = 0;
        plot_y2 = 0;
        non_area_k = 0;
        
        if lower(class(color_num)) == "string"
            color_num = length(plot_line);
        end
        color_map = KPlotColorMap(color_map_id,color_num,color_mode);

        for ii = 1:length(plot_line)
            now_class = string(class(plot_line(ii)));
            now_class = regexprep(...
                now_class,...
                "(matlab)|(graphics)|(chart)|(primitive)|[.]",...
                "");
            if now_class == "Line"
                non_area_k = non_area_k + 1;
                marker_id = mod(non_area_k-1,length(marker_tbl))+1;
                linestyle_id = mod(non_area_k-1,length(linestyle_tbl))+1;
                set(plot_line(ii), ...
                    'linewidth',plot_linewidth, ...
                    'color',color_map(mod(non_area_k-1,size(color_map,1))+1,:),...
                    'marker',marker_tbl(marker_id),...
                    'linestyle',linestyle_tbl(linestyle_id),...
                    'markersize',markersize);
                now_xdata = plot_line(ii).XData;
                now_ydata = plot_line(ii).YData;
                now_data_n = length(now_ydata);
                if data_down_sample
                    now_pw = ceil(now_data_n/data_down_n);
                else
                    now_pw = 1;
                end
                set(plot_line(ii), ...
                    'xdata',now_xdata(1:now_pw:now_data_n), ...
                    'ydata',now_ydata(1:now_pw:now_data_n));
            elseif now_class == "Area"
                set(plot_line(ii),'linestyle','none');
            elseif now_class == "Text"
                set(plot_line(ii),...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','Middle',...
                    'fontsize',16);
            end
            if now_class == "Line"
                if non_area_k == 1
                    [plot_x1,plot_x2] = bounds(now_xdata);
                    [plot_y1,plot_y2] = bounds(now_ydata);
                else
                    [tplot_x1,tplot_x2] = bounds(now_xdata);
                    [tplot_y1,tplot_y2] = bounds(now_ydata);
                    plot_x1 = min(plot_x1,tplot_x1);
                    plot_x2 = max(plot_x2,tplot_x2);
                    plot_y1 = min(plot_y1,tplot_y1);
                    plot_y2 = max(plot_y2,tplot_y2);
                end
            end
        end

        ax_x1 = plot_x1-marginleft*(plot_x2-plot_x1);
        ax_x2 = plot_x2+marginright*(plot_x2-plot_x1);
        ax_y1 = plot_y1-margindown*(plot_y2-plot_y1);
        ax_y2 = plot_y2+margintop*(plot_y2-plot_y1);

        set(ax_obj,...
            'xlim',[ax_x1,ax_x2],...
            'ylim',[ax_y1,ax_y2]);
    end

end