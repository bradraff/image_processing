function vid_obj_out = write_vid(frames, filename_out, file_type_out)

% % Determine number of dimensions of the frames
num_dims = length(size(frames));

% % Extract the number of frames, assuming they are encoded in the last dimension
num_frames = size(frames, num_dims); 

% % Create video object and open it
vid_obj_out = VideoWriter(filename_out, file_type_out);
open(vid_obj_out)

% % Open the figure window
figure
ax = gca;

% % Loop through each frame to add it to the figure and write the figure to the video
for f = 1:num_frames
    if f == 1 % Then this is our first frame, populate figure object using imshow()
        h =	imshow(frames(:,:,:,f));
        set(ax, 'XLimMode', 'manual', 'YLimMode', 'manual') % Set limits
    else % Then we only need to change the CData in the image handle h, which is much faster then doing imshow() again
        set(h, 'CData', frames(:,:,:,f)) % Replace image data
    end
    writeVideo(vid_obj_out, getframe(ax)); % Change to getframe(gcf) if axes, titles, etc. are desired
end
close(vid_obj_out)

end