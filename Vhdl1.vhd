entity somador is
	port (a,b,cin: in bit;
			s,cout:out bit);
end entity;

architecture soma of somador is
begin --igual ao da sala
	s<= a xor b xor cin;
	cout <= ((a xor b) and cin )or (a and b);
end soma;