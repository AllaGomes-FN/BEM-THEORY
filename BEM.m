
function [Cp,DATAturbine,Pot]=BEM(alpha_design,lambda,Ne,Extrapolation,R,eta,rho,B,V0)
    [c_l_design, ~] = encontraclcd(Extrapolation,alpha_design);

    r=zeros(1,Ne);
    for i = 1:1:Ne %% Define o tamanho de cada elemento da pá. 
        r(i) =  (R/Ne)*(i);
    end
    local_lambda = zeros(1,Ne);
    phi=zeros(1,Ne);
    corda=zeros(1,Ne);
    pitch=zeros(1,Ne);
    sigma_local=zeros(1,Ne);
    twist = zeros(1,Ne);
    a=zeros(1,Ne);
    a_linha = zeros(1,Ne);
    for i = 1:1:Ne
       local_lambda(i) = lambda*(r(i)/R);
       phi(i) = (2/3)*atan(1/local_lambda(i));
       corda(i) = (8*pi*r(i)/(B*c_l_design))*(1-cos(phi(i)));%%otimização de Schimitz
       pitch(i) = phi(i) - deg2rad(alpha_design);
       sigma_local(i) = (B*corda(i))/(2*pi*r(i));
    end
    for i = 1:1:Ne
        twist(i) = pitch(i)-pitch(Ne);
        a(i) = 1/(1+(4*(sin(phi(i)))^2)/(sigma_local(i)*c_l_design*cos(phi(i))));
        a_linha(i)=(1-3*a(i))/(4*a(i)-1);  
    end
       i=1;
       tipLossF = zeros(1,Ne);
       new_c_l=zeros(1,Ne);
       new_c_d=zeros(1,Ne);
       C_Tr =zeros(1,Ne);
       c_n = zeros(1,Ne);
       c_t = zeros(1,Ne);
       iter = 100;
    while i<= Ne
        delta_a = 1;
        j=1;
        delta_a_ant=0;
        delta_a_linha_ant = 0;
        while (j <= iter && delta_a > 0.0001 || a_linha(i)<0)
            phi(i) = atan((1-a(i))/((1+a_linha(i))*local_lambda(i)));%% calcula o angulo phi

            f=B*(R-r(i))/(2*r(i)*sin(phi(i)));
            tipLossF(i) = (2/pi)*acos(exp(-f));

            new_alpha = phi(i) - pitch(i);
            while new_alpha>pi 
                new_alpha=new_alpha-2*pi;
            end
            while new_alpha<-pi 
                new_alpha=new_alpha+2*pi;
            end

            [cl,cd]=encontraclcd(Extrapolation,rad2deg(new_alpha));
            new_c_l(i) =cl;
            new_c_d(i) = cd;

            c_n(i) = new_c_l(i)*cos(phi(i)) + new_c_d(i)*sin(phi(i));
            c_t(i) = new_c_l(i)*sin(phi(i)) - new_c_d(i)*cos(phi(i));

            C_Tr(i)=(sigma_local(i)*(1-a(i))^2*c_n(i))/(sin(phi(i)))^2;

            if C_Tr(i)<=0.96*tipLossF(i)

                new_a = 1/(4*tipLossF(i)*((sin(phi(i)))^2)/(sigma_local(i)*c_n(i))+1);
            end
            if C_Tr>0.96*tipLossF(i)
                new_a = (18*tipLossF(i)-20-3*abs(C_Tr(i)*(50-36*tipLossF(i))+12*tipLossF(i)*(3*tipLossF(i)-4))^0.5)/(36*tipLossF(i)-50);
            end
                new_a_linha = 0.5 * (abs(1+4/(local_lambda(i))^2*new_a*(1-new_a))^0.5-1);

                delta_a = abs(a(i) - new_a);

                if (delta_a - delta_a_ant<0.0001)
                    delta_a=0;
                end
                delta_a_ant=delta_a;
                delta_a_linha = abs(a_linha(i) - new_a_linha);

                if(delta_a - delta_a_linha_ant <0.0001)
                    delta_a_linha=0;
                end
                delta_a_linha_ant = delta_a_linha;
                a(i)=new_a;
                a_linha(i)=new_a_linha; 
            j=j+1;
        end
        i=i+1;
    end
    s=zeros(1,Ne);
    for i=1:1:Ne
        if new_c_l(i)==0
            s(i)=tipLossF(i)*local_lambda(i)^3*a_linha(i)*(1-a(i))*(1*cot(phi(i)));
        else
            s(i)=tipLossF(i)*local_lambda(i)^3*a_linha(i)*(1-a(i))*(1-(new_c_d(i)/new_c_l(i))*cot(phi(i)));
        end
    end
    pp=0;
    for i=2:1:Ne
        integral = (s(i)+s(i-1))*(local_lambda(i)-local_lambda(i-1))/2;
        pp = pp+integral;
    end
    Cp = pp*8/lambda^2;
    Pot = Cp*eta*(1/2)*rho*pi*R*V0^3;
    DATAturbine = [r.' corda.' rad2deg(phi).' rad2deg(pitch).' rad2deg(twist).' tipLossF.' new_c_l.' new_c_d.'];
   

