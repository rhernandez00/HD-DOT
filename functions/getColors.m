function colors = getColors(colorScheme)
if nargin < 1
    colorScheme = 1;
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
    case 2
        colors = {...
            [0,51,153],...%blue 1
            [207,0,91],... %magenta9
            [169,222,3],... %green 3
            [76,195,217],... %blue 4
            [75,172,198],...%cyan 5
            [255,88,1],... %orange 6
            [255,240,0],... %yellow 7
            [232,16,12],... %red 8
            [207,0,91],... %magenta9
            [0,0,0]... %black 10
            };
     case 3
        colors = {...
            
            [254,39,149],...%pink 2 
            [76,195,217],...%cyan 5
            [241,103,69],... %orangeINB  3 
            [194,103,255],... %light purple  3 
            [68,141,135],... %dark green 1
            [217,4,43],...%bloody red 4
            [107,12,34],...%bloody red 5
            [0,0,0]... %black 
            };
    case 4
        colors = {...  
            [255,0,0],...%red 1 
            [0,255,0],...%green 2
            [75,172,198],... %blue  3 
            [0,0,0],... %black 4  
            [255,255,255],... %white 5 
            [255,255,0],...%
            [255,0,255],...%
            [0,255,255]... %
            };
    case 5 %for colorblind 1 
        colors = {...  
            [230,159,0],...% 1 Yellow 
            [86,180,233],...% 2 blue
            [0,158,115],... %3 
            [240,228,66],... %4  
            [0,114,178],... %5
            [213,94,0],...
            [204,121,167],...
            [0,0,0]...
            };
    case 6 %for colorblind 1 
        colors = {...  
            [146,0,0],...%red 1 
            [31,217,118],...%green 2
            [0,109,219],... %blue  3 
            [0,73,73],... %dark blue 4  
            [219,109,0],... %orange 5 
            };
    case 7
        colors = {...
            [75,172,198],...%cyan 1
            [240,0,105],... %magenta2 %[207,0,91],... %magenta9
            [169,222,3],... %green 3
            [199,13,255],... %purple 4
            [255,88,1],... %orange 5
            [76,195,217],... %blue 6
            [255,240,0],... %yellow 7
            [232,16,12],... %red 8
            [207,0,91],... %magenta 9
            [0,51,153],...%blue 10
            [0,0,0],... %black 11
            [0,0,0]... %black 12
            [255,255,255]... %white 13
            };
    case 8 %pairs, same color but softer
        colors = {...
            [76,195,217],... %blue 1
            [76,195,217]./1.3,... %blue 1
            [240,0,105],... %magenta9 %[207,0,91],... %magenta9
            [240,0,105]./1.3,... %magenta9 %[207,0,91],... %magenta9
            [169,222,3],... %green 3
            [199,13,255],... %purple 4
            [75,130,198],...%cyan 5 %[75,172,198],...%cyan 5
            [255,88,1],... %orange 6
            [255,240,0],... %yellow 7
            [232,16,12],... %red 8
            [207,0,91],... %magenta9
            [0,51,153],...%blue 10
            [0,0,0],... %black 11
            [0,0,0]... %black 12
            [255,255,255]... %white 13
            };
    case 9
        colors = {...
            [0 0 0],... %black
            [255 255 255],... %white
            [100 100 100],... %grey
            [255 255 255]... %white
            };
    case 10
        colors = {...
        [76,195,217],... %blue 1
        [240,0,105],... %magenta9 %[207,0,91],... %magenta9
        [169,222,3],... %green 3
        [199,13,255],... %purple 4
        [75,130,198],...%cyan 5 %[75,172,198],...%cyan 5
        [232,16,12],... %red 6
        [255,240,0],... %yellow 7
        [255,88,1],... %orange 8
        [207,0,91],... %magenta9
        [0,51,153],...%blue 10
        [76,195,217],... %blue 1
        [240,0,105],... %magenta9 %[207,0,91],... %magenta9
        [169,222,3],... %green 3
        [199,13,255],... %purple 4
        [75,130,198],...%cyan 5 %[75,172,198],...%cyan 5
        [255,88,1],... %orange 6
        [255,240,0],... %yellow 7
        [232,16,12],... %red 8
        [207,0,91],... %magenta9
        [0,51,153],...%blue 10
        [0,0,0]... %black 
        };
    case 11 %Complex
        colors = {...
            [169,222,3],... %Cat face, green
            [71,94,1],... %Cat body, green dark
            [76,195,217],... %DF, blue
            [69,93,230],... %DB, blue dark
            [240,0,105],... %HF, magenta
            [255,85,255],... %HB, pink
            [255/2,255/2,255/2],... %Objects, Grey
            [255,255,255]... %others, black
            };
    case 12 %Complex, Hierarchy
        colors = {...
            [255,255,0],... %Animacy, yellow [242,183,5];
            [255,127,0],... %Face, light orange
            [255,64,0]... %Body, red-orange
            };
    case 14 %80's colors
        colors = {...
            [146,0,0],... %Red
            [109,182,255],... %Blue
            [36,255,36]... %Green
            };
    case 13 %colorblind 3
        colors = {...
            [255,0,0],... %Red
            [0,0,255],... %Blue
            [0,255,0]... %Green
            };
    case 15 %for multiple graphs
        colors = {...
            [76,195,217],... %blue 1
            [240,0,105],... %magenta9 %[207,0,91],... %magenta9 2
            [169,222,3],... %green 3
            [199,13,255],... %purple 4
            [75,130,198],...%cyan 5 %[75,172,198],...%cyan 5
            [255,88,1],... %orange 6
            [255,240,0],... %yellow 7
            [0,0,0]... %black8
            };
    case 16 %Complex, bodies
        colors = {...
            [71,94,1],... %Cat body, green dark
            [69,93,230],... %DB, blue dark
            [255,85,255],... %HB, pink
            [255/2,255/2,255/2],... %Objects, Grey
            [255,255,255]... %others, black
            };
    case 21 %Complex OLD
        colors = {...
            [169,222,3],... %Cat face, green
            [0,170,0],... %Cat body
            [76,195,217],... %DF, blue
            [92,45,145],... %DB, purple
            [240,0,105],... %HF, magenta
            [206,11,217],... %HB, pink
            [255/2,255/2,255/2]... %white
            };
    case 22 %Complex specie
        colors = {...
            [127,127,127],... %grey, cars 1
            [120,158,2],... %green, cats2
            [72,144,223],... %blue, dogs3
            [252,42,180],... %red, human4
            [1,1,1],... %white5
            [0,0,0],... %black6
            [242,183,5] %yellow living7
            };
    case 23 %Azalea's project
        colors = {...
            [76,195,217],... %blue 1
            [240,0,105],... %magenta9 
            [0,0,0]... %black 
            };
    case 24 %Prosody quilt boxplot
        colors = {...
            [76,195,217],... %Hf, blue
            [92,45,145],... %Hq, purple
            [240,0,105],... %Sf, magenta
            [206,11,217] %Sq, pink
            };
    case 25 %Complex specie
        colors = {...
            [120,158,2],... %green, cats
            [72,144,223],... %blue, dogs
            [252,42,180],... %red, human
            [127,127,127],... %grey, cars
            [1,1,1]
            };
    case 26 %Emotions
        colors = {...
            [255,242,0],... %yellow, happy
            [75,172,198],... %blue, sad
            [237,28,36],... %red, anger
            [127,63,152],... %fear, purple
            [255,255,255],... %white
            [20,62,239],... %6 - occipital 
            [106.08,62.985,172.89]}; %7 - temporal
    case 27 %some random colors
        colors = {...
            [172,28,255],...
            [24,157,222],...
            [46,245,39],...
            [222,180,24],...
            [250,51,12],...
            [15,39,255],...
            [16,222,130],...
            [245,240,29],...
            [224,104,11],...
            [15,15,15],...
            [240,240,240],...
            [248,10,250]
            };
    case 28 %colors for HD-DOT pallet
%         colors = {...
%             [236,0,139],...%magenta dot1
%             [0,173,239],...%blue dot2
%             [255,241,0],...%yellow dot3
%             [126,63,152],...%purple 0
%             [56,180,73],...%green 1
%             [255,255,255],...%white 2
%             [241,101,33],...%orange 3
%             [0,0,0]%black
%             };
%          colors = {...
%             [236,0,139],...%magenta dot1
%             [0,173,239],...%blue dot2
%             [255,241,0],...%yellow dot3
%             [126,63,152],...%purple 0
%             [56,180,73],...%green 1
%             [255,255,255],...%white 2
%             [0,0,0]%black
%             };
%         colors = {...
%             [245,130,185],...%magenta dot1
%             [0,217,255],...%blue dot2
%             [232,196,60],...%yellow dot3
%             };
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
    case 32 %Voice_sens1
         colors = {...
            [255,165,165],... %1, Chimpanzee
            [68,210,234],... %2, Dogs
            [250,207,103],... %3, Engines
            [121,184,193],... %4, Foxes
            [247,152,58],... %5, Music
            [255,82,205],... %6, Non-speech
            [253,144,223],... %7, Speech
            [254,113,214]% 8, Human
            
            };
    case 33 %Voice_sens1 specie
        colors = {...
            [255,165,165],... %1, Chimpanzee
            [68,210,234],... %2, Dogs
            [121,184,193],... %3, Foxes
            [254,113,214]% 4 Human
            };
        
    case 34 %Voice_sens1 order for figure
         colors = {...
            [253,144,223],... %1, Speech
            [255,82,205],... %2, Non-speech
            [255,165,165],... %3, Chimpanzee
            [68,210,234],... %4, Dogs
            [121,184,193],... %5, Foxes
            [247,152,58],... %6, Music
            [250,207,103],... %7, Engines
            };
end
for i = 1:length(colors)
    colors{i} = colors{i}./255;
end

%% Getting middle color
% initialColor = [249,0,105];
% finalColor = [255,85,255];
% 
% 
% colorMapList = [linspace(initialColor(1), finalColor(1), 3);...
%     linspace(initialColor(2), finalColor(2), 3);...
%     linspace(initialColor(3), finalColor(3), 3)]
% middleColor = [colorMapList(1,2),colorMapList(2,2),colorMapList(3,2)];
