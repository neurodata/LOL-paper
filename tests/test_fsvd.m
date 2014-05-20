% Example code for fast SVD.

clc, clear
load clown
%% TRY ME
k = 10; % # dims
i = 2;  % # power
COMPUTE_SVD0 = true; % Comment out if you do not want to spend time with builtin SVD.

% A is the m×n matrix we want to decompose
A = [X; X]; %im2double(rgb2gray(imread('test_image.jpg')))';
A = [A, A];

%% DO NOT MODIFY
if COMPUTE_SVD0
    tic
    % Compute SVD of A directly
    [U0, S0, V0] = svd(A,'econ');
    A0 = U0(:,1:k) * S0(1:k,1:k) * V0(:,1:k)';
    toc
    display(['SVD Error: ' num2str(compute_error(A,A0))])
    clear U0 S0 V0
end

% FSVD without power method
tic
[U1, S1, V1] = fsvd(A, k, i);
toc
A1 = U1 * S1 * V1';
display(['FSVD HYBRID Error: ' num2str(compute_error(A,A1))])
clear U1 S1 V1

% FSVD with power method
tic
[U2, S2, V2] = fsvd(A, k, i, true);
toc
A2 = U2 * S2 * V2';
display(['FSVD POWER Error: ' num2str(compute_error(A,A2))])
clear U2 S2 V2

subplot(2,2,1), imshow(A'), title('A (orig)')
if COMPUTE_SVD0, subplot(2,2,2), imshow(A0'), title('A0 (svd)'), end
subplot(2,2,3), imshow(A1'), title('A1 (fsvd hybrid)')
subplot(2,2,4), imshow(A2'), title('A2 (fsvd power)')