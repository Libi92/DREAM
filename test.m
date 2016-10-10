Im = imread('../Dataset/ddb1_fundusimages/image005.png');

% get image and mode from workspace
Im = evalin('base','Im');
singlemode = evalin('base','singlemode');

% apply filter on green component
f1 = fspecial('average',31); % create averaging filter
IMA = imadjust(Im(:,:,2)); % adjust green component intensity first
Imf = filter2(f1,IMA);  % apply filter
Imf = mat2gray(Imf); % convert back from (0,1) to (0,255)


axes(handles.axes2); % show grayscale filtered image
imshow(Imf);

%% Edge Detection.
thrsh = str2num(get(handles.edit1,'String')); % default = 0.98

Ibw=im2bw(Imf,thrsh); % binary mask / black & white threshold
I_edge = edge(Ibw);  % edge detection

% axes(handles.axes3);
% imshow(I_edge);      % show image


%% Circular Hough transform to detect optical disc (OD).

% Rmin = str2num(get(handles.edit3,'String')); % minimum radius from user input
% Rmax = str2num(get(handles.edit4,'String')); % maximum radius from user input

Rmin = 80;
Rmax = 120;

radii = Rmin:5:Rmax; % radii to check

h = circle_hough(I_edge,radii,'same','normalise');
peaks = circle_houghpeaks(h,radii,'nhoodxy',2*(Rmax/2)+1,'nhoodr',5,'npeaks',1); % find the peaks in the transform, meaning find the best fit of a circle. and we only want 1 circle.
%  Lines 196 -207 - if we're in single mode, we're plotting the circle in the top left image
if singlemode
    axes(handles.axes1);
    imshow(Im);
    hold on
    for peak = peaks
        [x y] = circlepoints(peak(3)); % This function returns the x,y coordinates of the found circle, peak(3) is the radius of the found circle.
        plot(x+peak(1),y+peak(2),'b-'); % we plot the x,y coordinates shifted by the center of the circle, which are peak(1) and peak(2)
    end

    plot(peak(1),peak(2),'r+'); % We plot the center of the circle with a red cross.
    hold off
end    
axes(handles.axes2); % Lines 208 - 214, we repeat the plot of the circle into axes2, the top right figure
hold on
for peak = peaks
    [x y] = circlepoints(peak(3));
    plot(x+peak(1),y+peak(2),'b-');
end
hold off


%% Region of Interest (ROI) Processing.
% we have localized the OD, define the ROI around this position for further
% processing.

axes(handles.axes2); % Activate axes2.
e = imellipse(gca,[peak(1)-2*peak(3) peak(2)-2*peak(3) 4*peak(3) 4*peak(3)]); %get an elliptical sub image centered around the peak(1) and peak(2) values (the centers of the previously found OD) and 2 times the radius that was found previously.
BW = createMask(e); %  Create a mask from this region of interest = ROI.

Imf_masked = Imf.*BW; % Apply mask to the image, this will make everything outside of the ROI become black.

% axes(handles.axes4);
% imshow(Imf_masked);

thrsh = str2num(get(handles.edit5,'String')); %  get threshold for ROI hough transform from the GUI, default = 0.65

Ibw=im2bw(Imf_masked,thrsh); % binary mask / black & white threshold (threshold the masked image).
I_edge = edge(Ibw);  % edge detection
% axes(handles.axes3);
% imshow(I_edge);      % show image

% hough transform to find circle in the ROI
h = circle_hough(I_edge,radii,'same','normalise');
peaks = circle_houghpeaks(h,radii,'nhoodxy',2*(Rmax/2)+1,'nhoodr',5,'npeaks',1);

if singlemode
    axes(handles.axes1);
    hold on
    for peak = peaks
        [x y] = circlepoints(peak(3));
        plot(x+peak(1),y+peak(2),'g-');
    end

    plot(peak(1),peak(2),'g+');
    hold off
end