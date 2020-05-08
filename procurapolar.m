function [DATAextra] = procurapolar(DATApolar,AR)
%Viterna-Corrigan extrapolation polar 360º
    [AoAs1,AoAs2,C_l_stall_1,C_l_stall_2,C_d_stall_1,C_d_stall_2,pclmax,pclmin]= procurastallpos(DATApolar);
    AoAs1 = deg2rad(AoAs1);
    AoAs2 = deg2rad(AoAs2);
    delta_alfa = abs(DATApolar(1,1) - DATApolar(2,1));
    palfa = pclmax;
    C_d_max = 1.11 + 0.018*AR;
    A2 = (C_l_stall_1 - C_d_max*sin(AoAs1)*cos(AoAs1))*(sin(AoAs1)/(cos(AoAs1))^2);%%EXTRAPOLAçÂO POSITIVA
    B2 = C_d_stall_1 - (C_d_max*(sin(AoAs1))^2)/cos(AoAs1);
    A1 = C_d_max/2;
    B1=1.8;
    while DATApolar(palfa,1) <=90
        DATApolar = [DATApolar(1:palfa,1:7);zeros(1,7)];
        ataqang=deg2rad(DATApolar(palfa,1));
        DATApolar(palfa,2)= A1 * sin(2*ataqang) + A2*((cos(ataqang))^2)/sin(ataqang);
        DATApolar(palfa,4)=B1*(sin(ataqang))^2 + B2*cos(ataqang);
        palfa=palfa+1;
        DATApolar(palfa,1) = DATApolar(palfa-1,1)+delta_alfa;
    end
    while DATApolar(palfa,1)<180
        DATApolar = [DATApolar(1:palfa,1:7);zeros(1,7)];
        ataqang=deg2rad(DATApolar(palfa,1));
        DATApolar(palfa,2)= B1 * sin(ataqang)*cos(ataqang);
        DATApolar(palfa,4)=B1*(sin(ataqang))^2;
        palfa=palfa+1;
        DATApolar(palfa,1) = DATApolar(palfa-1,1)+delta_alfa;
    end
    mm=palfa;
    palfa=pclmin;
    A2 = (C_l_stall_2 - C_d_max*sin(AoAs2)*cos(AoAs2))*(sin(AoAs2)/(cos(AoAs2))^2);%%EXTRAPOLAçÂO NEGATIVA
    B2 = C_d_stall_2 - (C_d_max*(sin(AoAs2))^2)/cos(AoAs2);
    DATApolar = [zeros(1,7);DATApolar(palfa:mm,1:7)];
    
    while DATApolar(2,1) >=-90
        ataqang=deg2rad(DATApolar(2,1));
        DATApolar(2,2)= A1 * sin(2*ataqang) + A2*((cos(ataqang))^2)/sin(ataqang);
        DATApolar(2,4)=B1*(sin(ataqang))^2 + B2*cos(ataqang);
        DATApolar(1,1) = DATApolar(2,1)-delta_alfa;
        DATApolar = [zeros(1,7);DATApolar(1:size(DATApolar,1),1:7)];
    end
    while DATApolar(2,1) >-180
        ataqang=deg2rad(DATApolar(2,1));
        DATApolar(2,2)= B1 * sin(ataqang)*cos(ataqang);
        DATApolar(2,4)=B1*(sin(ataqang))^2;
        DATApolar(1,1) = DATApolar(2,1)-delta_alfa;
        DATApolar = [zeros(1,7);DATApolar(1:size(DATApolar,1),1:7)];
    end
    DATAextra=DATApolar(2:size(DATApolar,1),1:7);
    figure;
    subplot
    plot(DATAextra(:,1).',DATAextra(:,2).','-',DATAextra(:,1).',DATAextra(:,4).','-');
    legend('C. Sustentação','C. Arrasto');
    title('Cl/Cd Extrapolação em 360º em angulos de ataque (Viterna-Corrigan)');
    xlabel('Alpha(AoA)');
    xlim([-180 180]);
    ylim([-2 3])
    ylabel('Cl/Cd');
    grid on;
end

