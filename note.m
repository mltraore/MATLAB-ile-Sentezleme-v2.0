%note fonksiyonu bir notanın pitch değerini alarak frekansını döndürür.
function frekans = note(nota)
         frekans = 440*2^((nota-69)/12) ;
end