% Demo of Arnold's Cat Map method of scrambling an image.
% Ref: https://en.wikipedia.org/wiki/Arnold's_cat_map

% Initialization and clean up code.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

%===============================================================================
% Get the name of the demo image the user wants to use.
% Let's let the user select from a list of all the demo images that ship with the Image Processing Toolbox.
folder = fileparts(which('cameraman.tif')); % Determine where demo folder is (works with all versions).
% Demo images have extensions of TIF, PNG, and JPG.  Get a list of all of them.
imageFiles = [dir(fullfile(folder,'*.TIF')); dir(fullfile(folder,'*.PNG')); dir(fullfile(folder,'*.jpg'))];
for k = 1 : length(imageFiles)
% 	fprintf('%d: %s\n', k, files(k).name);
	[~, baseFileName, extension] = fileparts(imageFiles(k).name);
	ca{k} = [baseFileName, extension];
end
% Sort the base file names alphabetically.
[ca, sortOrder] = sort(ca);
imageFiles = imageFiles(sortOrder);
button = menu('Use which gray scale demo image?', ca); % Display all image file names in a popup menu.
% Get the base filename.
baseFileName = imageFiles(button).name; % Assign the one on the button that they clicked on.
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);

% Read in an image.
grayImage = imread(fullFileName);

% Get the dimensions of the image.  
% numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
[rows, columns, numberOfColorChannels] = size(grayImage);

% Set a max size so the demo doesn't take too long.
maxAllowableSize = 201;
% Note: the number of iterations needed to return to the original image
% is very sensitive to the size of the image.  For example if 
% maxAllowableSize = 201 it takes 68 iterations, but if
% maxAllowableSize = 200 it takes 150 iterations.

% Make sure the image is square.
if rows ~= columns
	% It's not yet square.  Make it square and resize if needed.
	N = max([rows, columns]);
	if N > maxAllowableSize
		N = maxAllowableSize;
	end
	grayImage = imresize(grayImage, [N, N]);
end
[rows, columns, numberOfColorChannels] = size(grayImage);

if rows > maxAllowableSize
	% Make it smaller to speed up demo.
	N = maxAllowableSize;
	grayImage = imresize(grayImage, [N, N]);
end
% Update values.
[rows, columns, numberOfColorChannels] = size(grayImage);

% Display starting image.
% Note: the "coloredChips.png" demo image is a nice one to use.
subplot(1, 2, 1);
imshow(grayImage);
axis on;
caption = sprintf('Original Image, %s', baseFileName);
title(caption, 'FontSize', fontSize);

% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
% set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Arnolds Cat Map Demo by ImageAnalyst', 'NumberTitle', 'Off') 

startingTime = tic;
iteration = 1;
% Initialize image.
oldScrambledImage = grayImage;
% The number of iterations needed to restore the image can be shown never to exceed 3N.
N = rows;
while iteration <= 3 * N
	% Scramble the image based on the old image.
	for row = 1 : rows % y
		for col = 1 : columns % x
			c = mod((2 * col) + row, N) + 1; % x coordinate
			r = mod(col + row, N) + 1; % y coordinate
			% Move the pixel.  Note indexes are (row, column) = (y, x) NOT (x, y)!
			currentScrambledImage(row, col, :) = oldScrambledImage(r, c, :);
		end
	end
	
	% Display the current image.
	caption = sprintf('Arnolds Cat Map, Iteration #%d', iteration);
	fprintf('%s\n', caption);
	subplot(1, 2, 2);
	imshow(currentScrambledImage);
	axis on;
	title(caption, 'FontSize', fontSize);
	drawnow;
	
	% Insert a delay if desired.
% 	pause(0.1);
	
	% Save the image, if desired.
	filename = sprintf('Arnold Cat Iteration %d.png', iteration);
% 	imwrite(currentScrambledImage, filename);
	fprintf('Saved image file %s to disk.\n', filename);
	
	if immse(currentScrambledImage, grayImage) == 0
		caption = sprintf('Back to Original after %d Iterations.', iteration);
		fprintf('%s\n', caption);
		title(caption, 'FontSize', fontSize);
		break;
	end
	
	% Make the current image the prior/old one so we'll operate on that the next iteration.
	oldScrambledImage = currentScrambledImage;
	% Update the iteration counter.
	iteration = iteration+1;
end
elapsedTime = toc(startingTime);
fprintf('Elapsed time = %.1f seconds.\n', elapsedTime);
% Note: an interesting experiment might be to put the above loop in a loop where you're
% changing N and see how iteration (the number of iterations to return to the original)
% changes depending on N.
