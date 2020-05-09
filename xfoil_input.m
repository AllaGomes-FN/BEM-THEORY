AoAinf = '-10';
AoAmax = '10';
saveFilepolar = 'polar_data.txt';
savedmbpolar = 'dmb';
Re = '100000';
if (exist(saveFilepolar,'file'))
    delete(saveFilepolar);
end
if (exist(savedmbpolar,'file'))
    delete(savedmbpolar);
end
if (exist('xfoil_input.txt','file'))
    delete('xfoil_input.txt');
end
if (exist('coordinatesfoil.txt','file'))
    delete('coordinatesfoil.txt');
end

fid = fopen('xfoil_input.txt','w');
fprintf(fid,[perfil '\n']);
fprintf(fid,'PANE\n');
fprintf(fid,'PSAV\n');
fprintf(fid,'coordinatesfoil.txt\n');
fprintf(fid,'OPER\n');
fprintf(fid,'v\n');
fprintf(fid,[Re '\n']);
fprintf(fid,'ITER\n');
fprintf(fid,'250\n');
fprintf(fid,'PACC\n');
fprintf(fid,[saveFilepolar '\n']);
fprintf(fid,[savedmbpolar '\n']);
fprintf(fid,'ASEQ\n');

fprintf(fid,[AoAinf '\n']);
fprintf(fid,[AoAmax '\n']);
fprintf(fid,'0.25\n');
fprintf(fid,'\n');
fprintf(fid,'quit\n');
fclose(fid);
cmd = 'xfoil.exe < xfoil_input.txt';

[status, result] = system(cmd);








