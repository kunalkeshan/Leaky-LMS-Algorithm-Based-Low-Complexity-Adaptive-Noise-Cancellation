function [] = makeplot_m(s, v, d, eMatrix, selStage, showFirst6000)
% makeplot_m: Plots original, noise, noisy-clean, and selected adaptive filter output.
%   Uses a LOG_INTERVAL constant to map selStage to the appropriate row of eMatrix.
%
%   Inputs:
%     s            - Original clean signal vector
%     v            - Noise signal vector
%     d            - Noisy signal vector (clean + noise)
%     eMatrix      - Error signal matrix (stages x samples)
%     selStage     - Integer index of logged stage (1 maps to row 1, 2 maps to row LOG_INTERVAL+1, etc.)
%     showFirst6000- (optional) boolean to plot only the first 6000 samples

    % ---- User-adjustable logging interval ----
    LOG_INTERVAL = 5;  % must match the interval used in nllms_m

    % Default for showFirst6000
    if nargin < 6 || isempty(showFirst6000)
        showFirst6000 = false;
    end

    %     % Determine which row of eMatrix to plot
    % selStage=1 -> row 1; selStage>1 -> select multiple of LOG_INTERVAL
    if selStage <= 1
        rowIdx = 1;
    else
        rowIdx = selStage * LOG_INTERVAL;
    end
    % Clamp to valid range
    rowIdx = min(max(1, rowIdx), size(eMatrix,1));
    rowIdx = min(max(1, rowIdx), size(eMatrix,1));
    e = eMatrix(rowIdx, :);

    % Optionally limit to first 6000 samples
    if showFirst6000
        N = min(6000, numel(s));
        s = s(1:N);
        v = v(1:N);
        d = d(1:N);
        e = e(1:N);
    end

    % Define lighter shades for plotting
    red_light     = [1, 0.6, 0.6];
    green_light   = [0.6, 1, 0.6];
    blue_light    = [0.6, 0.6, 1];
    magenta_light = [1, 0.6, 1];

    % Create subplots
    subplot(4,1,1);
    plot(s, 'Color', red_light);
    title('Original Signal s(n)');
    xlabel('Samples'); ylabel('Amplitude');

    subplot(4,1,2);
    plot(v, 'Color', green_light);
    title('Noise Signal v(n)');
    xlabel('Samples'); ylabel('Amplitude');

    subplot(4,1,3);
    plot(d, 'Color', blue_light);
    title('Noisy Input d(n)');
    xlabel('Samples'); ylabel('Amplitude');

    subplot(4,1,4);
    plot(e, 'Color', magenta_light);
    title(['Adaptive Filter Output e_{stage=' num2str(rowIdx) '}(n)']);
    xlabel('Samples'); ylabel('Amplitude');
end
