function [AoAs1,AoAs2,C_l_stall_1,C_l_stall_2,C_d_stall_1,C_d_stall_2,pclmax,pclmin] = procurastallpos(DATApolar)
    C_l_stall_1=0;
    C_l_stall_2=1000;
    C_d_stall_1=0;
    C_d_stall_2=0;
    AoAs2=0;
    AoAs1=0;
    for i=1:1:size(DATApolar,1)
        if DATApolar(i,1) >-25 && DATApolar(i,1)<25
             if DATApolar(i,2)>C_l_stall_1
                 C_l_stall_1=DATApolar(i,2);
                 C_d_stall_1 = DATApolar(i,4);
                 AoAs1 = DATApolar(i,1);
                 pclmax = i;
             end
             if DATApolar(i,2)<C_l_stall_2
                 C_l_stall_2 = DATApolar(i,2);
                 C_d_stall_2=DATApolar(i,4);
                 AoAs2 = DATApolar(i,1);
                 pclmin=i;
             end
        end
    end
end

