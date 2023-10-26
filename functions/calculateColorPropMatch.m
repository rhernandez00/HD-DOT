function dif = calculateColorPropMatch(c0,c1,vars,prop)
%takes c0 and c1. Tables with as many rows as number of colors to test and
%columns as properties that determine those colors. Also takes vars which
%contains m and b from a line. Compares the property prop and returns the
%difference (dif).
m = vars(1); b = vars(2);
y1 = linef(c0.(prop),m,b);
dif = pdist2(c1.(prop)',y1');