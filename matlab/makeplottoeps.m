function [] = makeplottoeps(s, v, d, e, plot_title, filename)
    % Define lighter shades for colors
    red_light = [1, 0.6, 0.6];     % Light red
    green_light = [0.6, 1, 0.6];   % Light green
    blue_light = [0.6, 0.6, 1];    % Light blue
    magenta_light = [1, 0.6, 1];   % Light magenta
    
    % Plot results
    subplot(4, 1, 1);
    plot(s, 'Color', red_light); % Light red line
    title('Original Signal s(n)');
    xlabel('Samples');
    ylabel('Amplitude');
    
    subplot(4, 1, 2);
    plot(v, 'Color', green_light); % Light green line
    title('Noise Signal v(n)');
    xlabel('Samples');
    ylabel('Amplitude');
    
    subplot(4, 1, 3);
    plot(d, 'Color', blue_light); % Light blue line
    title('Clean Signal with Noise d(n)');
    xlabel('Samples');
    ylabel('Amplitude');
    
    subplot(4, 1, 4);
    plot(e, 'Color', magenta_light); % Light magenta line
    title('Proposed Multi Stage Adaptive Filter Output e(n)');
    xlabel('Samples');
    ylabel('Amplitude');
    
    % Add overall title
    sgtitle(plot_title);
    
    % Create directory 'figures' if it does not exist
    if ~exist('figures', 'dir')
        mkdir('figures');
    end
    
    % Save the figure as an EPS file in the 'figures' folder
    saveas(gcf, fullfile('figures', filename), 'epsc');
end