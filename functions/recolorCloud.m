function recolored = recolorCloud(colorInCloud,measuredColor,originalColor)
[mList,bList]=findColorAdjustment(measuredColor,originalColor);
colorInHSV = rgb2hsv(double(colorInCloud)./255);
for n = 1:3
    colorInHSV(:,n) = colorInHSV(:,n).*mList(n) + bList(n);
end
% try
colorInHSV(colorInHSV > 1) = 1;
colorInHSV(colorInHSV < 0) = 0;
recolored = hsv2rgb(colorInHSV).*255;
% catch
%     colorInHSV
% end
