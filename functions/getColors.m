function colors = getColors(colorScheme)
if nargin < 1
    colorScheme = 28;
end

switch colorScheme
    case 1
        colors = {...
            [76,195,217],... %blue 1
            [240,0,105],... %magenta9 %[207,0,91],... %magenta9 2
            [169,222,3],... %green 3
            [199,13,255],... %purple 4
            [75,130,198],...%cyan 5 %[75,172,198],...%cyan 5
            [255,88,1],... %orange 6
            [255,240,0],... %yellow 7
            [232,16,12],... %red 8
            [0,0,0],... %black9
            [0,51,153],...%blue 10
            [76,195,217],... %blue 11
            [240,0,105],... %magenta9 %[207,0,91],... %magenta9 12
            [169,222,3],... %green 3 13 
            [199,13,255],... %purple 4 14
            [75,130,198],...%cyan 5 %[75,172,198],...%cyan 15
            [255,88,1],... %orange 6
            [255,240,0],... %yellow 7
            [232,16,12],... %red 8
            [207,0,91],... %magenta9
            [0,51,153],...%blue 10
            [0,0,0]... %black 
            };
     case 9
        colors = {...
            [0 0 0],... %black
            [255 255 255],... %white
            [100 100 100],... %grey
            [255 255 255]... %white
            };
    case 28
         colors = {...
            [236,0,139],...%magenta dot1
            [0,173,239],...%blue dot2
            [255,241,0]%yellow dot3
            };
    case 29
        colors = {...
            [0,0,0],...%black val1
            [56,180,73],...%green val2
            [241,101,33]%orange val3
            };
    case 30 %just black
        colors = {...
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0]... %black 
            };
    case 31 %just black
        colors = {...
            [0,0,0],... %black 
            [120,120,120],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0],... %black 
            [0,0,0]... %black 
            };
end
for i = 1:length(colors)
    colors{i} = colors{i}./255;
end
