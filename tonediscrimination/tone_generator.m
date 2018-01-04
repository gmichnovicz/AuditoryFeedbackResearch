function tone=tone_generator(freq,timevec)
%function to generate a tone based on specified frequency and time vectors

tone=sin(2*pi*freq*timevec);
tone=tone.*(tukeywin(length(tone))'); %use a tukeywin mask to adjust clean sound
end
