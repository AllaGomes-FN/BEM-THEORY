function [cl,cd] = encontraclcd(extrapolation,alpha)
    for i = 1:1:(size(extrapolation,1)-1)
        if extrapolation(i+1,1)>= alpha && extrapolation(i,1)<=alpha
            cl=extrapolation(i,2);
            cd = extrapolation(i,4);
        end
    end
end

