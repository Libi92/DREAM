%% Preprocessing

I = imread('../Dataset/ddb1_fundusimages/image005.png');
figure('Name', 'Original'), imshow(I);
% Hist eq of green channel
histEq = histeq(I(:,:,2));
figure('Name', 'Histogram Equalized'), imshow(histEq);

% Resize to 500x500 pix
resized = imresize(histEq, 0.3);
figure('Name', 'Resized'), imshow(resized);

% Pixel intensity scaled in range [0,1]
rescaled = double(resized) / 255;
figure('Name', 'Scaled'), imshow(rescaled);

% Sharpen Image
sharp = imsharpen(rescaled);
figure('Name', 'Sharpened'), imshow(sharp);

% Laplacian of Gaussian
filter = fspecial('log');
log = imfilter(sharp, filter);
figure('Name', 'Laplacian of Gaussian'), imshow(log);

% Diff image with median filtering
Imdiff = sharp - log
medianFilt = medfilt2(Imdiff);
figure('Name', 'Diff image with median filtered'), imshow(medianFilt);

%% Stage 1

[x, y, z] = size(medianFilt);

for j = 1:y
    for i = 1:x
        if medianFilt(i,j) > 0.99
            medianFilt(i,j,1) = 0;
            medianFilt(i,j,2) = 0;
            medianFilt(i,j,3) = 255;
        elseif log(i,j) == 1
            medianFilt(i,j,1) = 255;
            medianFilt(i,j,2) = 0;
            medianFilt(i,j,3) = 0;
        end
    end
end

figure('Name', 'Bright and Red lesions'), imshow(medianFilt);