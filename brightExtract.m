I = imread('../Dataset/ddb1_fundusimages/image014.png');
figure, imshow(I);

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
figure('Name', 'Median Filtered'), imshow(medianFilt1);


se = strel('line',10,1);
IMerod = imerode(medianFilt1,se);

ImDiff = imsubtract(medianFilt1, IMerod);

ImNorm = double(ImDiff) / 255;
ImContrast = imadjust(ImNorm);

im = ImContrast;
ImBacNorm = (im-min(im(:)))/(max(im(:))-min(im(:)));

level = graythresh(ImBacNorm);
BW = im2bw(ImBacNorm,level);
BW2 = bwareaopen(BW, 100)

h = fspecial('average', [9 9]);
JF = imfilter(BW2, h);

figure, imshow(JF);

maskImage = zeros(500);

[x, y, z] = size(medianFilt1);
for j = 1:y
    for i = 1:x
        if medianFilt1(i,j) > 0.99
            maskImage(i,j) = 1;
        end
    end
end

figure('Name', 'Mask Image'), imshow(maskImage);

Z = imabsdiff(double(JF),maskImage);
figure('Name', 'Diff Image'), imshow(Z);