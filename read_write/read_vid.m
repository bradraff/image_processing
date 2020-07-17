function frames = read_vid(vid_filepath, varargin)
%%read_vid takes as input a filepath to a video and outputs a matrix array
%%of the frames in the video. The input can take optional inputs
%%start_frame and end_frame as the second and third arguments. The third
%%optional input is a boolean, with 0 meaning do not crop all frames based
%%on the cropping input by the user on the first frame, and 1 meaning do
%%crop.
%
%Example:
%   frames = read_vid('path\to\vid.mp4', 1, 50, 0);
%
%Written by Brad Rafferty

%% Handle arguments

% % Ensure at least one input
assert(nargin >= 1, 'read_vid requires the video filepath as the first argument');

% % Read the video into an object
vid_obj     = VideoReader(vid_filepath);

% % Handle the varargin to retrieve start and end frames
assert(length(varargin) <= 3, 'Only three optional arguments allowed beyond the required video filepath')
if ~isempty(varargin)
    start_frame = varargin{1};
    if length(varargin) >= 2
        end_frame   = varargin{2};
    end
    if length(varargin) == 3
        crop_frame = varargin{3};
    end
else
    % % Set default start and end: first frame and last frame
    start_frame = 1;
    end_frame = vid_obj.NumFrames;
end

%% Read frames

f_t = 1;
for f = start_frame:end_frame
    % % Read frame f from video
    frame = read(vid_obj, f);
    
    % % Determine size and the crop region on only the first frame
    if f == start_frame
        dims_vid = size(frame);
        num_dims = length(dims_vid);
        if crop_frame
            [frame, crop_region] = imcrop(frame);
            close
        end
    end
    
    % % Print progress to the command windpow
    if mod(f, 20) == 0
        fprintf('Reading frame %d\n', f)
    end
    
    % % Assign frame to frames, account for crop vs no crop and the size of
    % the video
    if crop_frame
        if num_dims == 2 && f > start_frame
            frames(:,:,f_t) = imcrop(frame, crop_region);
        elseif num_dims == 3 && f > start_frame
            frames(:,:,:,f_t) = imcrop(frame, crop_region);
        end
    else
        if num_dims == 2 && f > start_frame
            frames(:,:,f_t) = frame;
        elseif num_dims == 3 && f > start_frame
            frames(:,:,:,f_t) = frame;
        end
    end
    f_t = f_t + 1;
end

end