entity menor is
	port (a,b: in bit;
			s,cout:out bit);
end entity;

architecture ehmenor of menor is
begin  
 cout<= a xnor b;  --igualdade
 s <= not a and b; --a menor que b
end ehmenor;