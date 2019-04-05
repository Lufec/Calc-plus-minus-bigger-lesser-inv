
-----------------------
entity maior is
	port (a,b: in bit;
			s,cout:out bit);
end entity;

architecture ehmaior of maior is
begin   -- cout compara se é igual, s compara se a é maior.
 cout<= a xnor b;
 s <= a and not b; 
end ehmaior;