function [] = makeplot(s, v, d, e, showFirst6000)
    % makeplot: Plots four signals in subplots with optional sample limiting.
    % Inputs:
    % s            : Original signal
    % v            : Noise signal
    % d            : Clean signal with noise
    % e            : Output signal from the adaptive filter
    % showFirst6000: (Optional boolean) If true, plots only the first 6000 samples; 
    %                if false or omitted, plots all samples.

    if nargin < 5
        showFirst6000 = false; % Default to showing all samples
    end

    % Limit signals to first 6000 samples if requested
    if showFirst6000
        s = s(1:min(6000, length(s)));
        v = v(1:min(6000, length(v)));
        d = d(1:min(6000, length(d)));
        e = e(1:min(6000, length(e)));
    end

    % Define lighter shades for colors
    red_light = [1, 0.6, 0.6];     % Light red
    green_light = [0.6, 1, 0.6];     % Light green
    blue_light = [0.6, 0.6, 1];      % Light blue
    magenta_light = [1, 0.6, 1];     % Light magenta
    
    % Plot results
    subplot(4, 1, 1);
    plot(s, 'Color', red_light); 
    title('Original Signal s(n)');
    xlabel('Samples');
    ylabel('Amplitude');
    
    subplot(4, 1, 2);
    plot(v, 'Color', green_light);
    title('Noise Signal v(n)');
    xlabel('Samples');
    ylabel('Amplitude');
    
    subplot(4, 1, 3);
    plot(d, 'Color', blue_light);
    title('Clean Signal with Noise d(n)');
    xlabel('Samples');
    ylabel('Amplitude');
    
    subplot(4, 1, 4);
    plot(e, 'Color', magenta_light);
    title('Proposed Multi Stage Adaptive Filter Output e(n)');
    xlabel('Samples');
    ylabel('Amplitude');
end
