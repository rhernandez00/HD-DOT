function [mList,bList] = findColorAdjustment(measuredColor,originalColor)
%takes two color lists in rgb. The first list contains the colors as measured.
%The second list contains the original colors. Calculates the transformation 
%in HSV so new measured colors can be transformed to original colors

% measuredColor = {[235,158,210],[112,203,248],[243,250,157]};
% originalColor = getColors(28);

props = {'h','s','v'};
nColors = numel(measuredColor);
c0 = table('Size',[nColors,3],'VariableNames',props,'VariableTypes',{'double','double','double'});
%Calculates the transformation to HSV and transforms the color 
for n = 1:numel(measuredColor)
    currentColor = rgb2hsv(measuredColor{n});
    for nProp = 1:numel(props)
        prop = props{nProp};
        c0.(prop)(n) = currentColor(nProp);
    end
end


c1 = table('Size',[nColors,3],'VariableNames',props,'VariableTypes',{'double','double','double'});
for n = 1:numel(measuredColor)
    currentColor = rgb2hsv(originalColor{n});
    for nProp = 1:numel(props)
        prop = props{nProp};
        c1.(prop)(n) = currentColor(nProp);
    end
end

mList = zeros(1,numel(props));
bList = zeros(1,numel(props));
for nProp = 1:numel(props)
    prop = props{nProp};
    fun = @(vars)calculateColorPropMatch(c0,c1,vars,prop);
    vars0 = [1,0];
    vars = fminsearch(fun,vars0);
    mList(nProp) = vars(1);
    bList(nProp) = vars(2);
end
