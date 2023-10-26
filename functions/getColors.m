function colors = getColors(colorScheme)
if nargin < 1
    colorScheme = 28;
end

switch colorScheme
    case 28
         colors = {...
            [236,0,139],...%magenta dot1
            [0,173,239],...%blue dot2
            [255,241,0]%yellow dot3
            };
end
for i = 1:length(colors)
    colors{i} = colors{i}./255;
end
