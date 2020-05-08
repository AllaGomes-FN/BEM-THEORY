function [cl,cd] = encontraclcd(extrapolation,alpha)
    for i = 1:1:size(extrapolation,1)
        if extrapolation(i,1) + 0.25 >= alpha && extrapolation(i,1) - 0.25 <=alpha
            cl=extrapolation(i,2);
            cd = extrapolation(i,4);
        end
    end
end

