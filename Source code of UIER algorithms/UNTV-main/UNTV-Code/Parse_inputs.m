%Parse Inputs
%%%
function X = parse_inputs(varargin)

narginchk(1,1);
X = varargin{1};

if ismatrix(X)
    % For backward compatibility, this function handles uint8 and uint16
    % colormaps. This usage will be removed in a future release.
    
    validateattributes(X,{'uint8','uint16','single','double'}, ...
        {'nonempty','real'},mfilename,'MAP',1);
    if (size(X,2) ~= 3 || size(X,1) < 1)
        error(message('images:rgb2ycbcr:invalidSizeForColormap'));
    end
    if ~isfloat(X)
        warning(message('images:rgb2ycbcr:notAValidColormap'));
        X = im2double(X);
    end
elseif (ndims(X) == 3)
    validateattributes(X,{'uint8','uint16','single','double'},{'real'}, ...
        mfilename,'RGB',1);
    if (size(X,3) ~= 3)
        error(message('images:rgb2ycbcr:invalidTruecolorImage'));
    end
else
    error(message('images:rgb2ycbcr:invalidInputSize'))
end