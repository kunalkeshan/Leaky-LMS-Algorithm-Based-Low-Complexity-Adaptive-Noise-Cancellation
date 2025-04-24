function [w, y, e, stage] = rllms_with_plots(x, dn, mu, M, lambda, threshold, clean)
    % Initialize variables
    [w(1,:), y(1,:), e(1,:)] = llms(x, dn, mu, M, lambda);
    corrcoefMatrix = corrcoef(e(1,:), x);
    corrcoefConstant = corrcoefMatrix(1,2);
    stage = 1;
    disp(['Stage: ', num2str(stage)]);
    disp(['corrcoefConstant: ', num2str(corrcoefConstant)]);
    [mse(stage,:), snr(stage,:)] = getmsesnr(clean, dn, e(1,:));
    makeplot(stage, clean, x, dn, e(1,:));
    fprintf(['\n']);

    % Recursive processing
    while corrcoefConstant > threshold
        stage = stage + 1;
        x(stage,:) = (x(stage-1,:) - y(stage-1,:));
        dn = e(stage-1,:); % Update dn with the previous error signal
        [w(stage,:), y(stage,:), e(stage,:)] = llms(x(stage,:), dn, mu, M, lambda);
        corrcoefMatrix = corrcoef(e(stage,:), x(stage,:));
        corrcoefConstant = corrcoefMatrix(1,2);

        disp(['Stage: ', num2str(stage)]);
        disp(['corrcoefConstant: ', num2str(corrcoefConstant)]);
        [mse(stage,:), snr(stage,:)] = getmsesnr(clean, dn, e(stage,:));

        % Plot up to 4 figures only
        if stage <= 4
            makeplot(stage, clean, x(stage,:), dn, e(stage,:));
        end
        fprintf(['\n']);
    end
end

function [] = makeplot(stage, s, v, d, e)
    % Define lighter shades for colors
    red_light = [1, 0.6, 0.6];     % Light red
    green_light = [0.6, 1, 0.6];   % Light green
    blue_light = [0.6, 0.6, 1];    % Light blue
    magenta_light = [1, 0.6, 1];   % Light magenta

    % Create a new figure for each stage
    figure;
    sgtitle(['Stage ', num2str(stage)]); % Set title for the figure

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
end
