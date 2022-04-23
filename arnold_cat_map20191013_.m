clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;
% Import image file
imagefile=imread("C:\Users\MSI\Downloads\luffy.png");%add path to the image here
%Get dimensions of the image
[rows,columns,Colourchannel]=size(imagefile);
%max size for image so that demo takes little time
maxsize=201;

% Making the image square
if rows ~= columns
    N = max([rows, columns]);
	if N > maxsize;
        N = maxsize;
	end
	imagefile= imresize(imagefile, [N, N]);
end
if rows > maxsize
    N=maxsize;
    imagefile= imresize(imagefile, [N, N]);
end

% Update rows and columns
[rows,columns,Colourchannel]=size(imagefile);

% Display startng image
subplot(1,2,1);
imshow(imagefile)
axis on;
title('Original Image');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf, 'Name', 'Arnolds Cat Map Demo', 'NumberTitle', 'Off') 

startingTime = tic;
iteration = 1;
% Initialize image.
ScrambledImage = imagefile;
% The number of iterations needed to restore the image can be shown never to exceed 3N.
N = rows;
while iteration <= 3 * N
	% Scramble the image based on the old image.
	for row = 1 : rows % along y
		for col = 1 : columns %  along x
			c = mod((2 * col) + row, N)+1; % x coordinate
			r = mod(col + row, N)+1; % y coordinate
			% Move the pixel.  Note indexes are (row, column) = (y, x) NOT (x, y)!
			currentScrambledImage(row, col, :) = ScrambledImage(r, c, :);
		end
	end
	
	% Display the current image.
    pause(0.5);
	caption = sprintf('Arnolds Cat Map, Iteration #%d', iteration);
	fprintf('%s\n', caption);
	subplot(1, 2, 2);
	imshow(currentScrambledImage);
	axis on;
	title(caption);
	drawnow;
	filename = sprintf('Arnold Cat Iteration %d.png', iteration);
	if immse(currentScrambledImage,imagefile) == 0
		caption = sprintf('Back to Original after %d Iterations.', iteration);
		fprintf('%s\n', caption);
		title(caption);
		break;
	end
	
	% Make the current image the prior/old one so we'll operate on that the next iteration.
	ScrambledImage = currentScrambledImage;
	% Update the iteration counter.
	iteration = iteration+1;
end