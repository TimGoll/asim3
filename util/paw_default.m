function [] = paw_default(data_x, data_y, data_title, label_x, label_y, task, title, folder, do_legend, do_write)
    do_legend = do_legend || false;
    do_write  = do_write || false;
    
    % create figute
    this_fig = figure('Name', title);
    xlabel(label_x);
    ylabel(label_y);
    
    data_length = size(data_y, 1); %x is always the same
    for i=1:1:data_length %iterate over plot array
        plot(data_x{i}, data_y{i}, 'DisplayName', data_title{i}, 'Linewidth', 2);
        hold on;
    end
    
    if (do_legend)
        legend show;
    end
    
    set(gca, 'FontSize', 18);
    
    if (do_write)
        path = folder + "/" + task + "___" + strrep(title, ' ', '_') + ".png";
        saveas(this_fig, path);
    end
    
    
end