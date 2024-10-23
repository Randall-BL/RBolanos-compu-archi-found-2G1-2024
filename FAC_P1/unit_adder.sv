
// SUMADOR COMPLETO DE 1 BIT

module unit_adder(input logic a, b, cin,
			output logic sum, cout);
		
	assign sum  = cin ^ ( a ^ b);
	assign cout = a && b || cin && (a ^ b);
	
	
endmodule	