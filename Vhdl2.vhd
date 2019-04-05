
----------------
entity subtrador is
	port (a,b,cin: in bit;
			s,cout:out bit);
end entity;

architecture subtrair of subtrador is
begin  --inverso do somador, logica deboas de tirar. o cout diz se precisa tirar 1 do proximo bit ou n
	s<= (not a and (b xor cin )) or (a and (b  xnor cin ));
	cout<=(not a and(b or cin))or (a and b and cin);
end subtrair;