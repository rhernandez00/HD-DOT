function p = pFromDist(distribution,val,side)
%Compares val to distribution. The comparison depends on the side. Sides
%accepted are 'lessThan' and 'moreThan', meaning that the test indicates
%the probability of val being less or more than the values in the
%distribution

if nargin < 3
    side = 'lessThan';
end
if isobject(distribution)
    switch side
        case 'lessThan'
            p = cdf(distribution,val);
        case 'moreThan'
            p = 1 - cdf(distribution,val);
        otherwise
            error('use lessThan or moreThan')
    end
else
    switch side
        case 'lessThan'
            p = sum(distribution(:)<val)/length(distribution(:));
        case 'moreThan'
            p = sum(distribution(:)>val)/length(distribution(:));
        otherwise
            error('use lessThan or moreThan')
    end
    if p == 0
        p = 1/length(distribution(:));
        %warning('Val is beyond the distribution so its p = 1/length(distribution)');
    end
end