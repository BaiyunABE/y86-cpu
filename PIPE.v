module PIPE(
	input CLK,
	input reset,
	output [1:0] Stat
);
	parameter IHALT   = 4'h0;
	parameter INOP    = 4'h1;
	parameter IRRMOVQ = 4'h2;
	parameter ICMOVXX = 4'h2;
	parameter IIRMOVQ = 4'h3;
	parameter IRMMOVQ = 4'h4;
	parameter IMRMOVQ = 4'h5;
	parameter IOPQ    = 4'h6;
	parameter IJXX    = 4'h7;
	parameter ICALL   = 4'h8;
	parameter IRET    = 4'h9;
	parameter IPUSHQ  = 4'hA;
	parameter IPOPQ   = 4'hB;
	
	parameter RRSP    = 4'h4;
	parameter RNONE   = 4'hF;
	
	parameter SAOK     = 2'h0;
	parameter SHLT     = 2'h1;
	parameter SADR     = 2'h2;
	parameter SINS     = 2'h3;
	
	// F
	wire F_stall;
	reg  [63:0] F_predPC;
	
	// D
	wire D_stall;
	wire D_bubble;
	reg  [1:0]  D_stat;
	reg  [3:0]  D_icode;
	reg  [3:0]  D_ifun;
	reg  [3:0]  D_rA;
	reg  [3:0]  D_rB;
	reg  [63:0] D_valC;
	reg  [63:0] D_valP;
	
	// E
	wire E_bubble;
	reg  [1:0]  E_stat;
	reg  [3:0]  E_icode;
	reg  [3:0]  E_ifun;
	reg  [63:0] E_valC;
	reg  [63:0] E_valA;
	reg  [63:0] E_valB;
	reg  [3:0]  E_dstE;
	reg  [3:0]  E_dstM;
	reg  [3:0]  E_srcA;
	reg  [3:0]  E_srcB;
	
	// M
	wire M_bubble;
	reg  [1:0]  M_stat;
	reg  [3:0]  M_icode;
	reg         M_Cnd;
	reg  [63:0] M_valE;
	reg  [63:0] M_valA;
	reg  [3:0]  M_dstE;
	reg  [3:0]  M_dstM;
	
	// W
	wire W_stall;
	reg  [1:0]  W_stat;
	reg  [3:0]  W_icode;
	reg  [63:0] W_valE;
	reg  [63:0] W_valM;
	reg  [3:0]  W_dstE;
	reg  [3:0]  W_dstM;
	
	// fetch
	wire [3:0] f_icode;
	wire [3:0] f_ifun;
	wire need_valC;
	wire need_regids;
	wire [3:0] f_rA;
	wire [3:0] f_rB;
	wire [63:0] f_valC;
	wire [63:0] f_valP;
	wire imem_error;
	reg [63:0] f_pc;
	reg [63:0] f_predPC;
	reg instr_valid;
	reg [1:0] f_stat;
	
	// decode
	wire [63:0] d_rvalA;
	wire [63:0] d_rvalB;
	reg [63:0] d_valA;
	reg [63:0] d_valB;
	reg [3:0] d_dstE;
	reg [3:0] d_dstM;
	reg [3:0] d_srcA;
	reg [3:0] d_srcB;
	
	// execute
	wire set_cc;
	reg [63:0] aluA;
	reg [63:0] aluB;
	reg [3:0] alufun;
	reg new_ZF;
	reg new_SF;
	reg new_OF;
	reg [3:0] e_dstE;
	reg [63:0] e_valE;
	reg e_Cnd;

	// memory
	wire mem_read;
	wire mem_write;
	wire [63:0] mem_addr;
	wire [63:0] mem_data;
	wire dmem_error;
	wire [63:0] m_valM;
	reg [1:0] m_stat;
	
	// instruction mamory
	reg [7:0] IMEM [0:7];
	
	// register file
	reg [63:0] R [0:14];
	
	// flag
	reg ZF;
	reg SF;
	reg OF;
	
	// data memory
	reg [7:0] DMEM [0:7];
	
	/* fetch */
	
	// Select PC
	always @ (*)
	begin
		if (M_icode == IJXX && !M_Cnd)	// Mispredicted branch
			f_pc = M_valA;
		else if (W_icode == IRET)	// RET
			f_pc = W_valM;
		else
			f_pc = F_predPC;
	end
	
	// Predict PC
	always @ (*)
	begin
		if (f_icode == IJXX || f_icode == ICALL)
			f_predPC = f_valC;
		else
			f_predPC = f_valP;
	end
	
	// update F
	assign F_stall = (E_icode == IMRMOVQ || E_icode == IPOPQ) && (E_dstM == d_srcA || E_dstM == d_srcB) || (D_icode == IRET || E_icode == IRET || M_icode == IRET);
	always @ (posedge CLK)
	begin
		if (F_stall)
			;
		else
			F_predPC <= f_predPC;
	end
	
	assign { f_icode, f_ifun } = IMEM[f_pc];
	assign { f_rA, f_rB } = IMEM[f_pc + 1];
	
	assign f_valC = need_regids ? {
				IMEM[f_pc + 9],
				IMEM[f_pc + 8],
				IMEM[f_pc + 7],
				IMEM[f_pc + 6],
				IMEM[f_pc + 5],
				IMEM[f_pc + 4],
				IMEM[f_pc + 3],
				IMEM[f_pc + 2]
			} : {
				IMEM[f_pc + 9],
				IMEM[f_pc + 8],
				IMEM[f_pc + 7],
				IMEM[f_pc + 6],
				IMEM[f_pc + 5],
				IMEM[f_pc + 4],
				IMEM[f_pc + 3],
				IMEM[f_pc + 2]
			};
	
	assign need_valC = (f_icode == IIRMOVQ || f_icode == IRMMOVQ || f_icode == IMRMOVQ || f_icode == IJXX || f_icode == ICALL);
	assign need_regids = (f_icode == IRRMOVQ || f_icode == IIRMOVQ || f_icode == IRMMOVQ || f_icode == IMRMOVQ || f_icode == IOPQ || f_icode == IPUSHQ || f_icode == IPOPQ);
	
	assign f_valP = f_pc + 1 + (need_valC ? 8 : 0) + (need_regids ? 1 : 0);
	
	assign imem_error = (f_pc >= 64'h100);
	always @ (*)	// instr_valid
	begin
		if (imem_error)
			instr_valid = 0;
		else if (f_icode > 4'hB)	// invalid icode
			instr_valid = 0;
		else if (f_icode == ICMOVXX && f_ifun > 4'h6)	// invalid cmovXX
			instr_valid = 0;
		else if (f_icode == IOPQ && f_ifun > 4'h3)	// invalid OPq
			instr_valid = 0;
		else if (f_icode == IJXX && f_ifun > 4'h6)	// invalid jXX
			instr_valid = 0;
		else
			instr_valid = 1;
	end
	
	// f_stat
	always @ (*)
	begin
		if (imem_error)
			f_stat = SADR;
		else if (!instr_valid)
			f_stat = SINS;
		else if (f_icode == IHALT)
			f_stat = SHLT;
		else
			f_stat = SAOK;
	end
	
	// update D
	assign D_stall = (E_icode == IMRMOVQ || E_icode == IPOPQ) && (E_dstM == d_srcA || E_dstM == d_srcB);
	assign D_bubble = (E_icode == IJXX && !e_Cnd) || !((E_icode == IMRMOVQ || E_icode == IPOPQ) && (E_dstM == d_srcA || E_dstM == d_srcB)) && (D_icode == IRET || E_icode == IRET || M_icode == IRET);
	always @ (posedge CLK)
	begin
		if (D_stall)
			;
		else if (D_bubble)
			D_icode <= INOP;
		else
		begin
			D_stat <= f_stat;
			D_icode <= f_icode;
			D_ifun <= f_ifun;
			D_rA <= f_rA;
			D_rB <= f_rB;
			D_valC <= f_valC;
			D_valP <= f_valP;
		end
	end
	
	/* decode and write back */
	
	assign d_rvalA = (d_srcA == RNONE) ? 64'h0 : R[d_srcA];
	assign d_rvalB = (d_srcB == RNONE) ? 64'h0 : R[d_srcB];
	
	always @ (posedge CLK) begin
		if (W_dstE != RNONE)
			R[W_dstE] <= W_valE;
		if (W_dstM != RNONE)
			R[W_dstM] <= W_valM;
	end
	
	// Sel+Fwd A
	always @ (*)
	begin
		if (D_icode == ICALL || D_icode == IJXX)
			d_valA = D_valP;
		else if (d_srcA == e_dstE)
			d_valA = e_valE;
		else if (d_srcA == M_dstM)
			d_valA = m_valM;
		else if (d_srcA == M_dstE)
			d_valA = M_valE;
		else if (d_srcA == W_dstM)
			d_valA = W_valM;
		else if (d_srcA == W_dstE)
			d_valA = W_valE;
		else
			d_valA = d_rvalA;
	end
	
	// Fwd B
	always @ (*)
	begin
		if (d_srcB == e_dstE)
			d_valB = e_valE;
		else if (d_srcB == M_dstM)
			d_valB = m_valM;
		else if (d_srcB == M_dstE)
			d_valB = M_valE;
		else if (d_srcB == W_dstM)
			d_valB = W_valM;
		else if (d_srcB == W_dstE)
			d_valB = W_valE;
		else
			d_valB = d_rvalB;
	end
	
	// dstE
	always @ (*)
	begin
		case (D_icode)
			IRRMOVQ:	d_dstE = D_rB;
			IIRMOVQ:	d_dstE = D_rB;
			IOPQ: 		d_dstE = D_rB;
			ICALL: 		d_dstE = RRSP;
			IRET: 		d_dstE = RRSP;
			IPUSHQ:		d_dstE = RRSP;
			IPOPQ: 		d_dstE = RRSP;
			default:	d_dstE = RNONE;
		endcase
	end
	
	// dstM
	always @ (*)
	begin
		case (D_icode)
			IMRMOVQ:	d_dstM = D_rA;
			IPOPQ: 		d_dstM = D_rA;
			default:	d_dstM = RNONE;
		endcase
	end
	
	// srcA
	always @ (*)
	begin
		case (D_icode)
			IRRMOVQ:	d_srcA = D_rB;
			IRMMOVQ:	d_srcA = D_rB;
			IOPQ:		d_srcA = D_rB;
			IRET: 		d_srcA = RRSP;
			IPUSHQ:		d_srcA = D_rB;
			IPOPQ: 		d_srcA = RRSP;
			default:	d_srcA = RNONE;
		endcase
	end
	
	// srcB
	always @ (*)
	begin
		case (D_icode)
			IRMMOVQ:	d_srcB = D_rB;
			IMRMOVQ: 	d_srcB = D_rB;
			IOPQ: 		d_srcB = D_rB;
			ICALL: 		d_srcB = RRSP;
			IRET: 		d_srcB = RRSP;
			IPUSHQ: 	d_srcB = RRSP;
			IPOPQ: 		d_srcB = RRSP;
			default:	d_srcB = RNONE;
		endcase
	end
	
	// update E
	assign E_bubble = (E_icode == IMRMOVQ || E_icode == IPOPQ) && (E_dstM == d_srcA || E_dstM == d_srcB) || (E_icode == IJXX && !e_Cnd);
	always @ (posedge CLK)
	begin
		if (E_bubble)
		begin
			E_icode <= INOP;
			E_dstE <= RNONE;
			E_dstM <= RNONE;
			E_srcA <= RNONE;
			E_srcB <= RNONE;
		end
		else
		begin
			E_stat <= D_stat;
			E_icode <= D_icode;
			E_ifun <= D_ifun;
			E_valC <= D_valC;
			E_valA <= d_valA;
			E_valB <= d_valB;
			E_dstE <= d_dstE;
			E_dstM <= d_dstM;
			E_srcA <= d_srcA;
			E_srcB <= d_srcB;
		end
	end
	
	/* execute */
	
	// ALU A
	always @ (*)
	begin
		if (E_icode == IRRMOVQ || E_icode == IOPQ)
			aluA = E_valA;
		else if (E_icode == IIRMOVQ || E_icode == IRMMOVQ || E_icode == IMRMOVQ)
			aluA = E_valC;
		else if (E_icode == ICALL || E_icode == IPUSHQ)
			aluA = -64'h8;
		else if (E_icode == IRET || E_icode == IPOPQ)
			aluA = 64'h8;
		else
			aluA = 64'h0;
	end
	
	// ALU B
	always @ (*)
	begin	
		if (E_icode == IRRMOVQ || E_icode == IIRMOVQ)
			aluB = 64'h0;
		else if (E_icode == IJXX)
			aluB = 64'h0;
		else
			aluB = E_valB;
	end
	
	// ALU fun
	always @ (*) begin
		if (E_icode == IOPQ)
			alufun = E_ifun;
		else
			alufun = 4'h0;
	end
	
	// ALU
	always @ (*)
	begin
		case (alufun)
			4'h0 : e_valE = aluB + aluA;	// addq
			4'h1 : e_valE = aluB - aluA;	// subq
			4'h2 : e_valE = aluB & aluA;	// andq
			4'h3 : e_valE = aluB ^ aluA;	// xorq
			default : e_valE = 64'h0;
		endcase
	end
	
	assign set_cc = (E_icode == IOPQ) && (m_stat == SAOK) && (W_stat == SAOK);	// Set CC
	
	always @ (posedge CLK)	// CC
	begin
		if (set_cc) begin
			ZF <= ~|e_valE;
			SF <= e_valE[63];
			OF <= !(alufun == 4'h0 && aluA[63] == aluB[63] && aluA[63] ^ e_valE[63] || alufun == 4'h1 && aluA[63] ^ aluB[63] && aluA[63] == e_valE[63]);
		end
	end
	
	always @ (*)
	begin	// cond
		case (E_ifun)
			4'h0 : e_Cnd = 1;
			4'h1 : e_Cnd = (SF ^ OF) | ZF;
			4'h2 : e_Cnd = SF ^ OF;
			4'h3 : e_Cnd = ZF;
			4'h4 : e_Cnd = ~ZF;
			4'h5 : e_Cnd = ~(SF ^ OF);
			4'h6 : e_Cnd = ~(SF ^ OF) & ~ZF;
			default : e_Cnd = 1;
		endcase
	end
	
	// dstE
	always @ (*)
	begin
		if (E_icode == ICMOVXX && !e_Cnd)
			e_dstE = RNONE;
		else
			e_dstE = E_dstE;
	end
	
	// update M
	assign M_bubble = (m_stat != SAOK) || (W_stat != SAOK);
	always @ (posedge CLK)
	begin
		if (M_bubble)
		begin
			M_icode <= INOP;
			M_valE <= RNONE;
			M_valA <= RNONE;
			M_dstE <= RNONE;
			M_dstM <= RNONE;
		end
		else
		begin
			M_stat <= E_stat;
			M_icode <= E_icode;
			M_Cnd <= e_Cnd;
			M_valE <= e_valE;
			M_valA <= E_valA;
			M_dstE <= e_dstE;
			M_dstM <= E_dstM;
		end
	end
	
	/* memory */
	
	assign mem_read = (M_icode == IMRMOVQ || M_icode == IRET || M_icode == IPOPQ);
	assign mem_write = (M_icode == IRMMOVQ || M_icode == ICALL || M_icode == IPUSHQ);
	assign mem_addr = (M_icode == IRET || M_icode == IPOPQ) ? M_valA : M_valE;
	assign mem_data = M_valA;
	
	assign dmem_error = ((mem_read || mem_write) && mem_addr >= 64'h100);
	
	always @ (posedge CLK)
	begin
		if (mem_write && !dmem_error) begin
			DMEM[mem_addr] <= mem_data[7:0];
			DMEM[mem_addr + 1] <= mem_data[15:8];
			DMEM[mem_addr + 2] <= mem_data[23:16];
			DMEM[mem_addr + 3] <= mem_data[31:24];
			DMEM[mem_addr + 4] <= mem_data[39:32];
			DMEM[mem_addr + 5] <= mem_data[47:40];
			DMEM[mem_addr + 6] <= mem_data[55:48];
			DMEM[mem_addr + 7] <= mem_data[63:56];
		end
	end
	
	assign m_valM = {
		DMEM[mem_addr + 7],
		DMEM[mem_addr + 6],
		DMEM[mem_addr + 5],
		DMEM[mem_addr + 4],
		DMEM[mem_addr + 3],
		DMEM[mem_addr + 2],
		DMEM[mem_addr + 1],
		DMEM[mem_addr]
	};
	
	// m_stat
	always @ (*)
	begin
		if (M_stat == SAOK && dmem_error)
			m_stat <= SADR;
		else
			m_stat <= M_stat;
	end
	
	// update W
	assign W_stall = W_stat != SAOK;
	always @ (posedge CLK)
	begin
		if (W_stall)
			;
		else
		begin
			W_stat <= m_stat;
			W_icode <= M_icode;
			W_valE <= M_valE;
			W_valM <= m_valM;
			W_dstE <= M_dstE;
			W_dstM <= M_dstM;
		end
	end
	
	// Stat
	assign Stat = W_stat;
	
endmodule
