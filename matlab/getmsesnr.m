function [mse, snr] = getmsesnr(s, orig, e)
    % Ensure 'e' matches the dimensions of 's'
    if size(e, 1) ~= size(s, 1)
        e = e'; % Transpose e if necessary
    end
    % Ensure 'orig' matches the dimensions of 's'
    if size(orig, 1) ~= size(s, 1)
        orig = orig'; % Transpose orig if necessary
    end
    % Calculate Mean Squared Error (MSE)
    mse = immse(s, orig);
    
    % Calculate RMS values
    rms_s1 = rms(s);
    rms_difference = rms(s - e);
    
    % Calculate Signal-to-Noise Ratio (SNR)
    snr = 20 * log10(rms_s1 / rms_difference);

    % Display the results
    disp(['MSE: ', num2str(mse)]);
    disp(['SNR: ', num2str(snr), ' dB']);
end
