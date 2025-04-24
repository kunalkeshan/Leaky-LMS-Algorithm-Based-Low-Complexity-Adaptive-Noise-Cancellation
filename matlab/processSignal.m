function varargout = processSignal(sourceType, condition, desiredSNR, method)
% processSignal  Generate a noisy PCG or speech signal and run an adaptive filter.
% Automatically pushes all inputs, intermediate variables, and outputs to the base workspace.

%   Inputs:
%     sourceType  – 'pcg' or 'speech'
%     condition   – 'normal' or 'abnormal'
%     desiredSNR  – desired SNR in dB (numeric)
%     method      – one of {'lms','llms','nllms','rllms'}

    %% 0) Push inputs to base workspace
    assignin('base','sourceType',sourceType);
    assignin('base','condition',condition);
    assignin('base','desiredSNR',desiredSNR);
    assignin('base','method',method);

    %% 1) Load & resample the chosen file
    switch lower(sourceType)
        case 'pcg'
            if strcmpi(condition,'normal')
                [s,fs] = audioread('a0001.mp3');
            else
                [s,fs] = audioread('a0007.mp3');
            end
        case 'speech'
            if strcmpi(condition,'normal')
                [s,fs] = audioread('sp01.wav');
            else
                [s,fs] = audioread('natrajan_2a.wav');
            end
        otherwise
            error('Unknown sourceType: must be ''pcg'' or ''speech''.');
    end
    assignin('base','s',s);
    assignin('base','fs',fs);
    s1 = resample(s,1,1);
    assignin('base','s1',s1);

    %% 2) Add white Gaussian noise at desired SNR
    rms_s = rms(s1);
    noise_rms = rms_s / (10^(desiredSNR/20));
    v = noise_rms * randn(size(s1));
    orig = s1 + v;
    assignin('base','rms_s',rms_s);
    assignin('base','noise_rms',noise_rms);
    assignin('base','v',v);
    assignin('base','orig',orig);

    %% 3) Prepare filter inputs
    x     = 0.95 * v';
    dn    = orig;
    clean = s1;
    assignin('base','x',x);
    assignin('base','dn',dn);
    assignin('base','clean',clean);

    %% 4) Default algorithm parameters (edit inside as needed)
    mu        = 0.1;
    M         = 2;
    lambda    = 1e-4;
    n_stages  = 50;
    threshold = 0.1;
    assignin('base','mu',mu);
    assignin('base','M',M);
    assignin('base','lambda',lambda);
    assignin('base','n_stages',n_stages);
    assignin('base','threshold',threshold);

    %% 5) Dispatch to chosen method and push outputs
    switch lower(method)
        case 'lms'
            [w,y,e] = lms(x,dn,mu,M);
            varargout = {w,y,e};

        case 'llms'
            [w,y,e] = llms(x,dn,mu,M,lambda);
            varargout = {w,y,e};

        case 'nllms'
            [w,y,e,corrcoef_values,mse_values,snr_values] = nllms_m(x,dn,mu,M,lambda,n_stages,clean);
            varargout = {w,y,e,corrcoef_values,mse_values,snr_values};

        case 'rllms'
            [w,y,e,stage] = rllms_m(x,dn,mu,M,lambda,threshold,clean);
            varargout = {w,y,e,stage};

        otherwise
            error('Unknown method: choose ''lms'', ''llms'', ''nllms2'' or ''rllms''.');
    end

    % Push outputs to base
    outputNames = {'w','y','e','corrcoef_values','mse_values','snr_values','stage'};
    for k = 1:length(varargout)
        assignin('base', outputNames{k}, varargout{k});
    end
end
