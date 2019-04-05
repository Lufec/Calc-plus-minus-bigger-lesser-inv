
entity Projeto is
	port (a,b: in bit_vector (3 downto 0);   --bits pra operar
			ld : in bit;                       --liga desliga
			key: in bit_vector(2 downto 0);    --chave pra mudar operação
			saida: out bit_vector (3 downto 0);--saida que so existe pra ver respostas, depois tira
			dsp: out bit_vector (6 downto 0);  --saidas do display
			cout: out bit);                    -- saida do led

end Projeto;

architecture main of projeto is

--CÓDIGOS DA CHAVE :
--000 : somador
--001: subtrador
--010: maior
--100: menor
--111: inversor

component mux  --multiplex simples 5 entradas, 3 chaves, 1 saida
	port(a,b,c,d,e:in bit;
	      s: in bit_vector(2 downto 0);
		   cout: out bit);
end component;

component somador is  -- somador simples de 1 bit
	port (a,b,cin: in bit;
			s,cout: out bit);
end component;

component subtrador is  -- sub simples de 1 bit
	port (a,b,cin: in bit;
			s,cout: out bit);
end component;

component maior        --comparador de 1 bit
	port (a,b: in bit;
	   	s,cout: out bit);  --s é pra dizer se é maior, cout do componente é responsavel pela igualdade
end component;

component menor      -- igual ao de cima
	port (a,b: in bit;
	   	s,cout: out bit);
end component;

component inversor  -- inverte 1 bit
    port(a : in bit;
	       cout:out bit );
end component;

component display   -- recebe o resultado da operação escolhida e converte em coisa do display
	 	port(y: in bit_vector(3 downto 0); 
		     ld: in bit;   --botao liga desliga, prototipo (falta o ctrl)
	     dsp: out bit_vector (6 downto 0));
end component;

signal s:bit_vector (3 downto 0);  --pra tirar a saída do resultado
signal c:bit_vector (4 downto 0);  --auxiliar para a soma (parte que carrega pro proximo bit)
signal s1:bit_vector (3 downto 0); --auxiliar para soma   (resultado)
signal d:bit_vector(4 downto 0);   --auxiliar para sub    (parte que carrega pro proximo bit)
signal s2:bit_vector (3 downto 0); --auxiliar para sub    (resultado)
signal e:bit_vector(3 downto 0);   --auxiliar para maior (é o confirmador de igualdade)
signal f:bit_vector(3 downto 0);   --auxiliar para menor (idem ao de cima)
signal st1:bit_vector(3 downto 0); --auxiliar para maior (pega se algarismo é maior)
signal st2:bit_vector(3 downto 0); --auxiliar para menor (idem ao de cima)
signal s3:bit_vector(3 downto 0);  --auxiliar do inversor (resposta)
signal cf,df,ef,ff,gf: bit;        --saida cout da soma,sub,maior,menor. gf recebe a saída escolhida entre todas as anteriores
	begin
	c(0)<=NULL;  -- pra algumas operações é preciso isso
	gen: for i in 0 to 3 generate  -- faz operação bit a bit dos componentes abaixo
	 u1t: somador port map(a=> a(i),b=> b(i),cin=> c(i),s=> s1(i),cout=> c(i+1));
	 u2t: subtrador port map(a=> a(i),b=> b(i),cin=> d(i),s=> s2(i),cout=> d(i+1));
	 u3t: maior port map(a=> a(i),b=> b(i),s=> st1(i),cout=> e(i));
	 u4t: menor port map(a=> a(i),b=> b(i),s=> st2(i),cout=> f(i));
	 u5t: inversor port map(a=>a(i),cout=>s3(i));
	end generate;
	cf<=c(4);  --Cout do somador (estourou o numero de casas)
	df<=d(4);  --Cout do sub (ficou "negativo")
	ef<= st1(3) or (e(3)and(st1(2) or (e(2)and(st1(1)or (e(1)and st1(0))))));  --fórmula pra determinar se é maior
	ff<= st2(3) or (f(3)and(st2(2) or (f(2)and(st2(1)or (f(1)and st2(0))))));  -- fórmula pro menor
mult: for i in 0 to 3 generate
	 uut: mux port map (a=>s1(i) , b=>s2(i) , c=>ef , d=>ff , e=>s3(i) ,s(2)=>key(2), s(1)=>key(1), s(0)=>key(0), cout=>s(i));	--mux funcionando para a saída escolhida (transmitindo resposta)
end generate;
   multi: mux port map (a=> cf, b=> df, c=> ef, d=>ff, e=>ld, s(2)=>key(2), s(1)=>key(1), s(0)=>key(0), cout=> gf); --(mux transmitindo cout)
cout<=gf and ld; --botao desligar

result: for i in 0 to 3 generate
	saida(i)<=s(i);   --so serve pra vermos resposta na waveform
end generate;
disp: display port map(y(3)=>s(3) ,y(2)=>s(2) ,y(1)=>s(1) ,y(0)=>s(0) ,dsp(0)=>dsp(6),dsp(1)=>dsp(5),
                          dsp(2)=>dsp(4),dsp(3)=>dsp(3),dsp(4)=>dsp(2),dsp(5)=>dsp(1),dsp(6)=>dsp(0), ld=>ld);
	--funcao display 
	end main;
	
