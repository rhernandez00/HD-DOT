
%x - input
%y1 - output. original
%y0 - real number. measured

props = {'h','s','v'};
measuredColor = {[235,158,210],[112,203,248],[243,250,157]};
nColors = numel(measuredColor);

c0 = table('Size',[nColors,3],'VariableNames',props,'VariableTypes',{'double','double','double'});

for n = 1:numel(measuredColor)
    currentColor = rgb2hsv(measuredColor{n}./255);
    for nProp = 1:numel(props)
        prop = props{nProp};
        c0.(prop)(n) = currentColor(nProp);
    end
end

originalColor = getColors(28);
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
