%%POR ALLAN GOMES ARRUDA- UNIVERSIDADE FEDERAL DO AMAZONAS- MANAUS - 2020
%% ORIENTA��O PROF. DR. JO�O CALDAS DO LAGO NETO
%PROJETO : PARAMETRIZA��O DE ROTORES AXIAIS PARA TURBINAS HIDROCIN�TICAS NA
%REGI�O AMAZONICA.
clc
clear

AR=14;


% Ne=input ('N�mero de elementos(10-20):');%%N�mero de elementos do rotor 
% eta = input('Eficiencia Mecanica (0.7-0.9): ');
% rho = input('Densidade da �gua(kg/m^3): ');
% B=input ('N�mero de p�s: ');%%N�mero de p�s do rotor
% R=input ('Raio da p�: ');%%Raio da p� 
% lambda=input('TSR(Raz�o velocidade ponta de p�) : ');%%TSR - raz�o de velocidade de ponta de p�
% V0=input('Velocidade do fluxo de �gua livre : ');%%Velocidade do fluxo do fluido
% alpha_design = input('Angulo de ataque para otimiza��o para o hidrof�lio(N�o coloque zero!): ');
perfil = 'NACA 0018';
Ne = 15;
eta = 0.8;
rho = 996;
B=3;
R=1;
V0=2;

xfoil_input
bladeprofile = load('coordinatesfoil.txt');
plot(bladeprofile(:,1).',bladeprofile(:,2).');
title('PERFIL DE P� UTILIZADO');
xlim([-1 1.5]);
ylim([-1 1]);
DADOS = importdata('polar_data.txt',' ',12);
DATApolar = DADOS.data;
Extrapolation=procurapolar(DATApolar,AR);

lambda=3.5:0.5:9;
alpha_design = 1:0.5:10;
Cp_melhor=0;

for  i = 1:1:size(alpha_design,2)
    for j = 1:1:size(lambda,2)
        [Cp(i,j),DATAturbine,Pot]=BEM(alpha_design(i),lambda(j),Ne,Extrapolation,R,eta,rho,B,V0);
        if Cp(i,j)>Cp_melhor
            Cp_melhor = Cp(i,j);
            palpha_melhor = i;
            plambda_melhor=j;
            DADOSTURBINA = DATAturbine;
            POTENCIA = Pot;
        end
    end
end
fprintf('O MELHOR COEFICIENTE DE POTENCIA PARA O PERFIL DE P� SELECIONADO: '+string(Cp_melhor));
fprintf('\n\nANGULO DE ATAQUE OTIMIZADO: '+string(alpha_design(palpha_melhor))+'\n TSR OTIMIZADO: '+string(lambda(plambda_melhor)) );
fprintf('\n\n');
disp('    r(x) | Corda da p�(r) |Angulo Phi |Angulo Pitch |Angulo Twist |Fator de Corre��o| C.sustenta��o| C.arrasto');
disp(DADOSTURBINA);
fprintf('POTENCIA TOTAL DA TURBINA : '+string(POTENCIA)+' (WATTS)');

