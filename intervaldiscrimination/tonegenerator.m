function tone=tone_generator(freq,timevec)
%function used to generate tone

tone=sin(2*pi*freq*timevec); %generate tone with sin function
%tone=tone.*(tukeywin(length(tone))'); %use tukeywin for smooth sound
end
