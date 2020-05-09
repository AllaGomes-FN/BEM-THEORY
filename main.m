%%POR ALLAN GOMES ARRUDA- UNIVERSIDADE FEDERAL DO AMAZONAS- MANAUS - 2020
%% ORIENTAÇÃO PROF. DR. JOÃO CALDAS DO LAGO NETO
%PROJETO : PARAMETRIZAÇÃO DE ROTORES AXIAIS PARA TURBINAS HIDROCINÉTICAS NA
%REGIÃO AMAZONICA.
clc
clear

AR=14;


% Ne=input ('Número de elementos(10-20):');%%Número de elementos do rotor 
% eta = input('Eficiencia Mecanica (0.7-0.9): ');
% rho = input('Densidade da água(kg/m^3): ');
% B=input ('Número de pás: ');%%Número de pás do rotor
% R=input ('Raio da pá: ');%%Raio da pá 
% lambda=input('TSR(Razão velocidade ponta de pá) : ');%%TSR - razão de velocidade de ponta de pá
% V0=input('Velocidade do fluxo de água livre : ');%%Velocidade do fluxo do fluido
% alpha_design = input('Angulo de ataque para otimização para o hidrofólio(Não coloque zero!): ');
perfil = 'LOAD SG6043.dat';
Ne = 15;
eta = 0.8;
rho = 996;
B=3;
R=1;
V0=2;

xfoil_input
bladeprofile = load('coordinatesfoil.txt');
plot(bladeprofile(:,1).',bladeprofile(:,2).');
title('PERFIL DE PÁ UTILIZADO');
xlim([-0.1 1.1]);
ylim([-0.1 0.5]);
DADOS = importdata('polar_data.txt',' ',12);
DATApolar = DADOS.data;
Extrapolation=procurapolar(DATApolar,AR);

lambdad=3.5:0.5:9;
alpha_d = 1:0.5:10;
Cp_melhor=0;
for  i = 1:1:size(alpha_d,2)
    for j = 1:1:size(lambdad,2)
        [Cp(i,j),DATAturbine,Pot]=BEM(alpha_d(i),lambdad(j),Ne,Extrapolation,R,eta,rho,B,V0);
        if Cp(i,j)>Cp_melhor
            Cp_melhor = Cp(i,j);
            palpha_melhor = i;
            plambda_melhor=j;
            DADOSTURBINA = DATAturbine;
            POTENCIA = Pot;
        end
    end
end
fprintf('O MELHOR COEFICIENTE DE POTENCIA PARA O PERFIL DE PÁ SELECIONADO: '+string(Cp_melhor));
fprintf('\n\nANGULO DE ATAQUE OTIMIZADO: '+string(alpha_d(palpha_melhor))+'\n TSR OTIMIZADO: '+string(lambdad(plambda_melhor)) );
fprintf('\n\n');
disp('    r(x) | Corda da pá(r) |Angulo Phi |Angulo Pitch |Angulo Twist |Fator de Correção| C.sustentação| C.arrasto');
disp(DADOSTURBINA);
fprintf('POTENCIA TOTAL DA TURBINA : '+string(POTENCIA)+' (WATTS)');


figure;
plot(lambdad,Cp(palpha_melhor,:));
title('Cp vs TSR');
xlabel('TSR - Lambda');
ylabel('Cp');
xlim([3.5 9]);
ylim([0.39 0.5]);

figure;
plot(alpha_d,Cp(:,plambda_melhor));
title('Cp vs Alpha(AoA)');
xlabel('AoA - Alpha');
ylabel('Cp');
xlim([1 10]);
ylim([0.3 0.5]);


