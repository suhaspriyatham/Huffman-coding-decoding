%project huffman coding decocoding. The data from 5 sensors are sampled
%signal and stored in the file 5sensordata.xlsx


clear all;
clc;

sn=5;       %no of sensors
fid=fopen('5sensordata.txt','r');
File_Values=fscanf(fid,'%f');
fclose(fid);

Nv=numel(File_Values)/sn;
fprintf('Number of patterns (Nv) = %d\n',Nv);
File_Values=reshape(File_Values,[sn Nv]);
A=(File_Values)';
clear File_Values;

%reading data from sensors to vectors
s1=A(:,1);
s2=A(:,2);
s3=A(:,3);
s4=A(:,4);
s5=A(:,5);
s=[s1; s2; s3; s4; s5];

s=100*rand(100000,1);
% plot(s1);
% figure
% plot(s2);
% figure
% plot(s3);
% figure
% plot(s4);
% figure
% plot(s5);
% figure
% histogram(s1);

% Use a smaller number for maxbits, 8 or 9 if it takes too long to execution
maxbits=11; 
compratio=zeros(maxbits,1);
for N=1:maxbits
    
    % quantisation
    n=N
    nsymbols=2^n; %2^n quantisation levels so 2^n symbols
    upperlimit=max(s)+1;
    lowerlimit=min(s);
    height=(upperlimit-lowerlimit)/nsymbols;
    prob=zeros(1,nsymbols);
    legh=length(s);
    symbols=1:nsymbols;
    
    symbolsequence=zeros(legh,1);
    for i=1:legh
       symbolsequence(i)=floor((s(i)-lowerlimit)/height)+1;
       prob(symbolsequence(i))=prob(symbolsequence(i))+1;
    end
    prob=prob/legh;

    %huffman coding
    dict=huffmandict(symbols,prob);
    %tx data bits
    tx=huffmanenco(symbolsequence,dict);

    %rx data bits
    %rx=tx;
    save('encoded.txt','tx','-ascii');
    rx=load('encoded.txt','-ascii');

    %huffman decoding
    decodedsymbolsequence=huffmandeco(rx,dict);

    if isequal(symbolsequence,decodedsymbolsequence)
        disp('huffman coding and decoding performed without error');
    else
        disp('error');
    end
    compratio(N)= length(tx)/(n*length(s));

end

figure
plot(1:maxbits,compratio);
xlabel('number of bits per symbol');
ylabel('compression ratio');
title('Huffman coding');
