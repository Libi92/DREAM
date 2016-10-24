%% Preprocessing

I = imread('../Dataset/ddb1_fundusimages/image014.png');
figure('Name', 'Original'), imshow(I);
% Hist eq of green channel
histEq = histeq(I(:,:,2));
figure('Name', 'Histogram Equalized'), imshow(histEq);

% Resize to 500x500 pix
resized = imresize(histEq, [500 500]);
figure('Name', 'Resized'), imshow(resized);

% Pixel intensity scaled in range [0,1]
rescaled = double(resized) / 255;
figure('Name', 'Scaled'), imshow(rescaled);

% Sharpen Image
sharp = adapthisteq(rescaled,'numTiles',[8 8],'nBins',128);
figure('Name', 'Sharpened'), imshow(sharp);

% Laplacian of Gaussian
filter = fspecial('log');
log = imfilter(sharp, filter);
figure('Name', 'Laplacian of Gaussian'), imshow(log);

diffImg = imsubtract(sharp, log);

medianFilt1 = medfilt2(diffImg);

% Background Exclusion
% Apply Average Filter
h = fspecial('average', [9 9]);
JF = imfilter(diffImg, h);

% Diff image with median filtering
Imdiff = imsubtract(JF, sharp);
medianFilt = medfilt2(Imdiff);
figure('Name', 'Diff image with median filtered'), imshow(medianFilt);


%% Stage 1

% Threshold using the IsoData Method
level=isodata(medianFilt);
% Convert to Binary
BW = im2bw(medianFilt, level-.008)
figure('Name', 'BW'), imshow(BW);
% Remove small pixels
BW2 = bwareaopen(BW, 100)
figure('Name', 'BW2'), imshow(BW2);
% Overlay
out = imoverlay(resized, BW2, [255 0 0])

[x, y, z] = size(out);

maxI = min(medianFilt);
disp(maxI);
for j = 1:y
    for i = 1:x
        if medianFilt1(i,j) > 0.99
            out(i,j,1) = 0;
            out(i,j,2) = 0;
            out(i,j,3) = 255;
        end
    end
end

figure('Name', 'Bright and Red lesions'), imshow(out);