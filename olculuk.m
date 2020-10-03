function [time signal revSig] = olculuk(file,z , h)

parse  = parseMusicXML(file);
zarf   = z;
hmk    = h;
Fs     = 44100;
signal = 0;
revSig = 0;
time   = 0;
tt     = 0;
   

for i  = 1:length(parse)
    k  = parse(i,8);
 if(k==16)
   frek  = note(parse(i,4));
   start = parse(i,6);
   dur   = parse(i,7);
   tt    = start:1/Fs:(start+dur-1/Fs);
   nota  = zeros(size(tt));
  for n = 1:hmk
         nota = nota + (1/n)*cos(2*pi*n*frek*tt);
  end
 
  if(zarf==1)
     %Exponential
     len  = length(nota);
     env  = exp(-len/parse(i,2)); 
     xx   = env.*nota;
  elseif(zarf==2)   
     %ADSR
     len  = length(nota);
     env  = [linspace(0,1.5,ceil(len/5)) linspace(1.5,1,ceil(len/10)) ones(1,ceil(len/2)) linspace(1,0,ceil(len/5))];
     fark = length(env) - length(nota);
     env  = env(1,1:end-fark);
     nota = nota.*env;
  end
   signal  = horzcat(signal,nota);
   time    = horzcat(time,tt); 
 end
end
 
 
 sig      =  signal';
 reverb   =  reverberator('PreDelay',0.5,'WetDryMix',1);
 revSig   =  reverb(sig);
 
 %plot(time,signal,'DisplayName','Signal')
 %legend('Signal')
 %figure
 %plot(time,revSig,'DisplayName','Reverb')
 %legend('Signal','Reverb')
 %soundsc(revSig,fs);
 
end
 