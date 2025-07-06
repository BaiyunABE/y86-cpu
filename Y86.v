module IMEM (
    input  [63:0] addr,
    output [79:0] data
);
    reg [7:0] M [0:255]; // 2 ^ 64 - 1

	integer i;
	initial begin
		// .pos 0
		M[64'h000] = 8'h30;	// irmovq
		M[64'h001] = 8'hf4;	// %rsp
		M[64'h002] = 8'h80;
		M[64'h003] = 8'h00;
		M[64'h004] = 8'h00;
		M[64'h005] = 8'h00;
		M[64'h006] = 8'h00;
		M[64'h007] = 8'h00;
		M[64'h008] = 8'h00;
		M[64'h009] = 8'h00;	// stack
		M[64'h00a] = 8'h80;	// call
		M[64'h00b] = 8'h14;
		M[64'h00c] = 8'h00;
		M[64'h00d] = 8'h00;
		M[64'h00e] = 8'h00;
		M[64'h00f] = 8'h00;
		M[64'h010] = 8'h00;
		M[64'h011] = 8'h00;
		M[64'h012] = 8'h00;	// main
		M[64'h013] = 8'h00; // halt
		// main:
		M[64'h014] = 8'h30;	// irmovq
		M[64'h015] = 8'hf7;	// %rdi
		M[64'h016] = 8'h00;
		M[64'h017] = 8'h00;
		M[64'h018] = 8'h00;
		M[64'h019] = 8'h00;
		M[64'h01a] = 8'h00;
		M[64'h01b] = 8'h00;
		M[64'h01c] = 8'h00;
		M[64'h01d] = 8'h00;	// array
		M[64'h01e] = 8'h30;	// irmovq
		M[64'h01f] = 8'hf6;	// %rsi
		M[64'h020] = 8'h04;
		M[64'h021] = 8'h00;
		M[64'h022] = 8'h00;
		M[64'h023] = 8'h00;
		M[64'h024] = 8'h00;
		M[64'h025] = 8'h00;
		M[64'h026] = 8'h00;
		M[64'h027] = 8'h00;	// $4
		M[64'h028] = 8'h80;	// call
		M[64'h029] = 8'h32;
		M[64'h02a] = 8'h00;
		M[64'h02b] = 8'h00;
		M[64'h02c] = 8'h00;
		M[64'h02d] = 8'h00;
		M[64'h02e] = 8'h00;
		M[64'h02f] = 8'h00;
		M[64'h030] = 8'h00;	// sum
		M[64'h031] = 8'h90;	// ret
		// sum:
		M[64'h032] = 8'h30;	// irmovq
		M[64'h033] = 8'hf8;	// %r8
		M[64'h034] = 8'h08;
		M[64'h035] = 8'h00;
		M[64'h036] = 8'h00;
		M[64'h037] = 8'h00;
		M[64'h038] = 8'h00;
		M[64'h039] = 8'h00;
		M[64'h03a] = 8'h00;
		M[64'h03b] = 8'h00;	// $8
		M[64'h03c] = 8'h30;	// irmovq
		M[64'h03d] = 8'hf9;	// %r9
		M[64'h03e] = 8'h01;
		M[64'h03f] = 8'h00;
		M[64'h040] = 8'h00;
		M[64'h041] = 8'h00;
		M[64'h042] = 8'h00;
		M[64'h043] = 8'h00;
		M[64'h044] = 8'h00;
		M[64'h045] = 8'h00;	// $1
		M[64'h046] = 8'h63;	// xorq
		M[64'h047] = 8'h00;	// %rax,%rax
		M[64'h048] = 8'h62;	// andq
		M[64'h049] = 8'h66;	// %rsi,%rsi
		M[64'h04a] = 8'h70;	// jmp
		M[64'h04b] = 8'h63;
		M[64'h04c] = 8'h00;
		M[64'h04d] = 8'h00;
		M[64'h04e] = 8'h00;
		M[64'h04f] = 8'h00;
		M[64'h050] = 8'h00;
		M[64'h051] = 8'h00;
		M[64'h052] = 8'h00;	// test
		// loop:
		M[64'h053] = 8'h50;	// mrmovq
		M[64'h054] = 8'ha7;	// (%rdi),%r10
		M[64'h055] = 8'h00;
		M[64'h056] = 8'h00;
		M[64'h057] = 8'h00;
		M[64'h058] = 8'h00;
		M[64'h059] = 8'h00;
		M[64'h05a] = 8'h00;
		M[64'h05b] = 8'h00;
		M[64'h05c] = 8'h00;	// $0
		M[64'h05d] = 8'h60;	// addq
		M[64'h05e] = 8'ha0;	// %r10,%rax
		M[64'h05f] = 8'h60;	// addq
		M[64'h060] = 8'h87;	// %r8,%rdi
		M[64'h061] = 8'h61;	// subq
		M[64'h062] = 8'h96;	// %r9,%rsi
		// test:
		M[64'h063] = 8'h74;	// jne
		M[64'h064] = 8'h53;
		M[64'h065] = 8'h00;
		M[64'h066] = 8'h00;
		M[64'h067] = 8'h00;
		M[64'h068] = 8'h00;
		M[64'h069] = 8'h00;
		M[64'h06a] = 8'h00;
		M[64'h06b] = 8'h00;	// loop
		M[64'h06c] = 8'h90;	// ret
		for (i = 32'h06d; i < 32'h100; i = i + 1) begin
			M[i] = 8'h00;
		end
	end
    
    assign data = {
		M[addr + 9],
		M[addr + 8],
		M[addr + 7],
		M[addr + 6],
		M[addr + 5],
		M[addr + 4],
		M[addr + 3],
		M[addr + 2],
		M[addr + 1],
		M[addr + 0]
	};
endmodule

module DMEM(
	input  CLK,
	input  read,
	input  write,
	input  [63:0] addr,
	input  [63:0] data,
	output [63:0] valM
);
	reg  [7:0] M     [0:255]; // 2 ^ 64 - 1
	reg  [7:0] Cache [0:15];
	reg  [3:0] seq;
	wire [3:0] seq_t;
	wire [3:0] iaddr;
	
	assign { seq_t, iaddr } = addr;
	
	always @ (posedge CLK)
	begin
		if (read) begin
			if (seq_t != seq) begin
				seq <= seq_t;
				Cache[4'h0] <= M[{seq_t, 4'h0}];
				Cache[4'h1] <= M[{seq_t, 4'h1}];
				Cache[4'h2] <= M[{seq_t, 4'h2}];
				Cache[4'h3] <= M[{seq_t, 4'h3}];
				Cache[4'h4] <= M[{seq_t, 4'h4}];
				Cache[4'h5] <= M[{seq_t, 4'h5}];
				Cache[4'h6] <= M[{seq_t, 4'h6}];
				Cache[4'h7] <= M[{seq_t, 4'h7}];
				Cache[4'h8] <= M[{seq_t, 4'h8}];
				Cache[4'h9] <= M[{seq_t, 4'h9}];
				Cache[4'ha] <= M[{seq_t, 4'ha}];
				Cache[4'hb] <= M[{seq_t, 4'hb}];
				Cache[4'hc] <= M[{seq_t, 4'hc}];
				Cache[4'hd] <= M[{seq_t, 4'hd}];
				Cache[4'he] <= M[{seq_t, 4'he}];
				Cache[4'hf] <= M[{seq_t, 4'hf}];
			end
        end
		if (write) begin
			if (seq_t == seq) begin
				Cache[iaddr + 0] <= data[7:0];       
				Cache[iaddr + 1] <= data[15:8];      
				Cache[iaddr + 2] <= data[23:16];     
				Cache[iaddr + 3] <= data[31:24];     
				Cache[iaddr + 4] <= data[39:32];     
				Cache[iaddr + 5] <= data[47:40];     
				Cache[iaddr + 6] <= data[55:48];     
				Cache[iaddr + 7] <= data[63:56];     
			end
			M[addr + 0] <= data[7:0];
			M[addr + 1] <= data[15:8];
			M[addr + 2] <= data[23:16];
			M[addr + 3] <= data[31:24];
			M[addr + 4] <= data[39:32];
			M[addr + 5] <= data[47:40];
			M[addr + 6] <= data[55:48];
			M[addr + 7] <= data[63:56];
		end
	end
	
	assign valM = read ? (
        seq_t == seq ? {
            Cache[iaddr + 7],
            Cache[iaddr + 6],
            Cache[iaddr + 5],
            Cache[iaddr + 4],
            Cache[iaddr + 3],
            Cache[iaddr + 2],
            Cache[iaddr + 1],
            Cache[iaddr + 0]
        } : {
            M[addr + 7],
            M[addr + 6],
            M[addr + 5],
            M[addr + 4],
            M[addr + 3],
            M[addr + 2],
            M[addr + 1],
            M[addr + 0]
        }
	) : 64'h0;
	
	integer i;
	initial begin
		// array:
		M[64'h000] = 8'h0d;
		M[64'h001] = 8'h00;
		M[64'h002] = 8'h0d;
		M[64'h003] = 8'h00;
		M[64'h004] = 8'h0d;
		M[64'h005] = 8'h00;
		M[64'h006] = 8'h00;
		M[64'h007] = 8'h00;
		M[64'h008] = 8'hc0;
		M[64'h009] = 8'h00;
		M[64'h00a] = 8'hc0;
		M[64'h00b] = 8'h00;
		M[64'h00c] = 8'hc0;
		M[64'h00d] = 8'h00;
		M[64'h00e] = 8'h00;
		M[64'h00f] = 8'h00;
		M[64'h010] = 8'h00;
		M[64'h011] = 8'h0b;
		M[64'h012] = 8'h00;
		M[64'h013] = 8'h0b;
		M[64'h014] = 8'h00;
		M[64'h015] = 8'h0b;
		M[64'h016] = 8'h00;
		M[64'h017] = 8'h00;
		M[64'h018] = 8'h00;
		M[64'h019] = 8'ha0;
		M[64'h01a] = 8'h00;
		M[64'h01b] = 8'ha0;
		M[64'h01c] = 8'h00;
		M[64'h01d] = 8'ha0;
		M[64'h01e] = 8'h00;
		M[64'h01f] = 8'h00;
		for (i = 32'h020; i < 32'h100; i = i + 1) begin
			M[i] = 8'h00;
		end
		
		Cache[4'h0] = 8'h0d;
		Cache[4'h1] = 8'h00;
		Cache[4'h2] = 8'h0d;
		Cache[4'h3] = 8'h00;
		Cache[4'h4] = 8'h0d;
		Cache[4'h5] = 8'h00;
		Cache[4'h6] = 8'h00;
		Cache[4'h7] = 8'h00;
		Cache[4'h8] = 8'hc0;
		Cache[4'h9] = 8'h00;
		Cache[4'ha] = 8'hc0;
		Cache[4'hb] = 8'h00;
		Cache[4'hc] = 8'hc0;
		Cache[4'hd] = 8'h00;
		Cache[4'he] = 8'h00;
		Cache[4'hf] = 8'h00;
		
		seq = 0;
	end

endmodule

module Y86(
	input CLK,
	input reset,
	output reg	[63:0]	F_predPC,
	output reg	[3:0]	D_icode,
	output reg	[3:0]	D_ifun,
	output reg	[3:0]	D_rA,
	output reg	[3:0]	D_rB,
	output reg	[63:0]	D_valC,
	output reg	[63:0]	D_valP,
	output reg	[3:0]	E_icode,
	output reg	[3:0]	E_ifun,
	output reg	[63:0]	E_valC,
	output reg	[63:0]	E_valA,
	output reg	[63:0]	E_valB,
	output reg	[3:0]	E_dstE,
	output reg	[3:0]	E_dstM,
	output reg	[3:0]	M_icode,
	output reg			M_Cnd,
	output reg	[63:0]	M_valE,
	output reg	[63:0]	M_valA,
	output reg	[63:0]	M_valC,
	output reg	[3:0]	M_dstE,
	output reg	[3:0]	M_dstM,
	output reg	[3:0]	W_icode,
	output reg			W_Cnd,
	output reg	[63:0]	W_valE,
	output reg	[63:0]	W_valM,
	output reg	[3:0]	W_dstE,
	output reg	[3:0]	W_dstM,
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

	parameter FNONE   = 4'h0;

	parameter RRSP    = 4'h4;
	parameter RNONE   = 4'hF;

	parameter ALUADD  = 4'h0;

	parameter SAOK    = 2'h0;
	parameter SHLT    = 2'h1;
	parameter SADR    = 2'h2;
	parameter SINS    = 2'h3;

	// F
	wire F_stall;
//	reg  [63:0] F_predPC;
	
	// D
	wire D_stall;
	wire D_bubble;
	reg  [1:0]  D_stat;
//	reg  [3:0]  D_icode;
//	reg  [3:0]  D_ifun;
//	reg  [3:0]  D_rA;
//	reg  [3:0]  D_rB;
//	reg  [63:0] D_valC;
//	reg  [63:0] D_valP;
	
	// E
	wire E_bubble;
	reg  [1:0]  E_stat;
//	reg  [3:0]  E_icode;
//	reg  [3:0]  E_ifun;
//	reg  [63:0] E_valC;
//	reg  [63:0] E_valA;
//	reg  [63:0] E_valB;
//	reg  [3:0]  E_dstE;
//	reg  [3:0]  E_dstM;
	
	// M
	wire M_bubble;
	reg  [1:0]  M_stat;
//	reg  [3:0]  M_icode;
//	reg         M_Cnd;
//	reg  [63:0] M_valE;
//	reg  [63:0] M_valA;
//	reg  [63:0] M_valC;
//	reg  [3:0]  M_dstE;
//	reg  [3:0]  M_dstM;
	
	// W
	wire W_stall;
	
	reg  [1:0]  W_stat;
//	reg  [3:0]  W_icode;
//	reg  [63:0] W_valE;
//	reg  [63:0] W_valM;
//	reg  [3:0]  W_dstE;
//	reg  [3:0]  W_dstM;
//	reg W_Cnd;
	
	// fetch
	wire [79:0] f_ins;
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
	reg [63:0] stack [0:15];
	
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

	// instruction memory
	IMEM IMEM(
		.addr(f_pc),
		.data(f_ins)
	);
	
	// register file
	reg [63:0] R [0:14];
	
	// flag
	reg ZF;
	reg SF;
	reg OF;
	
	// data memory
	DMEM DMEM(
		.CLK(CLK),
		.read(mem_read),
		.write(mem_write),
		.addr(mem_addr),
		.data(mem_data),
		.valM(m_valM)
	);
	
	// pipeline control logic
	wire load_use_hazard = (E_icode == IMRMOVQ || E_icode == IPOPQ) && (E_dstM != RNONE) && (E_dstM == d_srcA || E_dstM == d_srcB);
	wire brunch_pred_err = E_icode == IJXX && !e_Cnd;
	wire return_pred_err = M_icode == IRET && M_valC != m_valM;
	wire pipeline_except = (m_stat != SAOK) || (W_stat != SAOK);

	/* fetch */

	always @ (posedge CLK or posedge reset)
	begin
		if (reset)
		begin
			stack[4'h0] <= 64'h0;
			stack[4'h1] <= 64'h0;
			stack[4'h2] <= 64'h0;
			stack[4'h3] <= 64'h0;
			stack[4'h4] <= 64'h0;
			stack[4'h5] <= 64'h0;
			stack[4'h6] <= 64'h0;
			stack[4'h7] <= 64'h0;
			stack[4'h8] <= 64'h0;
			stack[4'h9] <= 64'h0;
			stack[4'ha] <= 64'h0;
			stack[4'hb] <= 64'h0;
			stack[4'hc] <= 64'h0;
			stack[4'hd] <= 64'h0;
			stack[4'he] <= 64'h0;
			stack[4'hf] <= 64'h0;
		end
		else if (M_icode == ICALL)
		begin
			stack[4'h0] <= M_valA;
			stack[4'h1] <= stack[4'h0];
			stack[4'h2] <= stack[4'h1];
			stack[4'h3] <= stack[4'h2];
			stack[4'h4] <= stack[4'h3];
			stack[4'h5] <= stack[4'h4];
			stack[4'h6] <= stack[4'h5];
			stack[4'h7] <= stack[4'h6];
			stack[4'h8] <= stack[4'h7];
			stack[4'h9] <= stack[4'h8];
			stack[4'ha] <= stack[4'h9];
			stack[4'hb] <= stack[4'ha];
			stack[4'hc] <= stack[4'hb];
			stack[4'hd] <= stack[4'hc];
			stack[4'he] <= stack[4'hd];
			stack[4'hf] <= stack[4'he];
		end
		else if (M_icode == IRET)
		begin
			stack[4'h0] <= stack[4'h1];
			stack[4'h1] <= stack[4'h2];
			stack[4'h2] <= stack[4'h3];
			stack[4'h3] <= stack[4'h4];
			stack[4'h4] <= stack[4'h5];
			stack[4'h5] <= stack[4'h6];
			stack[4'h6] <= stack[4'h7];
			stack[4'h7] <= stack[4'h8];
			stack[4'h8] <= stack[4'h9];
			stack[4'h9] <= stack[4'ha];
			stack[4'ha] <= stack[4'hb];
			stack[4'hb] <= stack[4'hc];
			stack[4'hc] <= stack[4'hd];
			stack[4'hd] <= stack[4'he];
			stack[4'he] <= stack[4'hf];
			stack[4'hf] <= 64'h0;
		end
	end
	
	// Select PC
	always @ (*)
	begin
        if (M_icode == IJXX && !M_Cnd)
            f_pc = M_valA;
        else if (W_icode == IRET && W_Cnd)
            f_pc = W_valM;
        else
            f_pc = F_predPC;
	end
	
	// Predict PC
	always @ (*)
	begin
		if (f_icode == IJXX || f_icode == ICALL)
			f_predPC = f_valC;
		else if (f_icode == IRET)
			f_predPC = stack[0];
		else
			f_predPC = f_valP;
	end
	
	// update F
	assign F_stall = load_use_hazard && !return_pred_err || Stat != SAOK;
	always @ (posedge CLK or posedge reset)
	begin
        if (reset)
            F_predPC <= 64'h0;
		else if (F_stall)
			;
		else
			F_predPC <= f_predPC;
	end
	
	assign { f_icode, f_ifun } = f_ins[7:0];
	
	assign need_regids = (f_icode == IRRMOVQ || f_icode == IIRMOVQ || f_icode == IRMMOVQ || f_icode == IMRMOVQ || f_icode == IOPQ || f_icode == IPUSHQ || f_icode == IPOPQ);
	
	assign { f_rA, f_rB } = need_regids ? f_ins[15:8] : { RNONE, RNONE };
	
	assign need_valC = (f_icode == IIRMOVQ || f_icode == IRMMOVQ || f_icode == IMRMOVQ || f_icode == IJXX || f_icode == ICALL);
	
	assign f_valC = need_valC ? (need_regids ? f_ins[79:16] : f_ins[71:8]) : ((f_icode == IRET) ? stack[4'h0] : 64'h0);
	
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
	assign D_stall = load_use_hazard && !return_pred_err;
	assign D_bubble = brunch_pred_err || return_pred_err;
	always @ (posedge CLK or posedge reset)
	begin
        if (reset) begin
			D_stat  <= SAOK;
			D_icode <= INOP;
			D_ifun  <= FNONE;
			D_rA    <= RNONE;
			D_rB    <= RNONE;
			D_valC  <= 64'h0;
			D_valP  <= 64'h0;
        end
		else if (D_stall)
			;
		else if (D_bubble)
			D_icode <= INOP;
		else
		begin
			D_stat  <= f_stat;
			D_icode <= f_icode;
			D_ifun  <= f_ifun;
			D_rA    <= f_rA;
			D_rB    <= f_rB;
			D_valC  <= f_valC;
			D_valP  <= f_valP;
		end
	end
	
	/* decode and write back */
	
	assign d_rvalA = (d_srcA == RNONE) ? 64'h0 : R[d_srcA];
	assign d_rvalB = (d_srcB == RNONE) ? 64'h0 : R[d_srcB];
	
	always @ (posedge CLK or posedge reset)
	begin
        if (reset) begin
            R[4'h0] <= 64'h0;
            R[4'h1] <= 64'h0;
            R[4'h2] <= 64'h0;
            R[4'h3] <= 64'h0;
            R[4'h4] <= 64'h0;
            R[4'h5] <= 64'h0;
            R[4'h6] <= 64'h0;
            R[4'h7] <= 64'h0;
            R[4'h8] <= 64'h0;
            R[4'h9] <= 64'h0;
            R[4'ha] <= 64'h0;
            R[4'hb] <= 64'h0;
            R[4'hc] <= 64'h0;
            R[4'hd] <= 64'h0;
            R[4'he] <= 64'h0;
        end
		else begin
            if (W_dstE != RNONE)
                R[W_dstE] <= W_valE;
            if (W_dstM != RNONE)
                R[W_dstM] <= W_valM;
		end
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
			IRRMOVQ:	d_srcA = D_rA;
			IRMMOVQ:	d_srcA = D_rA;
			IOPQ:		d_srcA = D_rA;
			IRET: 		d_srcA = RRSP;
			IPUSHQ:		d_srcA = D_rA;
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
	assign E_bubble = load_use_hazard || brunch_pred_err || return_pred_err;
	always @ (posedge CLK or posedge reset)
	begin
        if (reset) begin
			E_stat  <= SAOK;
			E_icode <= INOP;
			E_ifun  <= FNONE;
			E_valC  <= 64'h0;
			E_valA  <= 64'h0;
			E_valB  <= 64'h0;
			E_dstE  <= RNONE;
			E_dstM  <= RNONE;
        end
		else if (E_bubble)
		begin
			E_icode <= INOP;
			E_dstE  <= RNONE;
			E_dstM  <= RNONE;
		end
		else
		begin
			E_stat  <= D_stat;
			E_icode <= D_icode;
			E_ifun  <= D_ifun;
			E_valC  <= D_valC;
			E_valA  <= d_valA;
			E_valB  <= d_valB;
			E_dstE  <= d_dstE;
			E_dstM  <= d_dstM;
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
	always @ (*)
	begin
		if (E_icode == IOPQ)
			alufun = E_ifun;
		else
			alufun = ALUADD;
	end
	
	// ALU
	always @ (*)
	begin
		case (alufun)
			4'h0: e_valE = aluB + aluA;	// addq
			4'h1: e_valE = aluB - aluA;	// subq
			4'h2: e_valE = aluB & aluA;	// andq
			4'h3: e_valE = aluB ^ aluA;	// xorq
			default: e_valE = 64'h0;
		endcase
	end
	
	assign set_cc = (E_icode == IOPQ) && !pipeline_except && !return_pred_err;	// Set CC
	
	always @ (posedge CLK or posedge reset)	// CC
	begin
        if (reset) begin
            ZF <= 0;
            SF <= 0;
            OF <= 0;
        end
		else if (set_cc) begin
			ZF <= ~|e_valE;
			SF <= e_valE[63];
			OF <= !(alufun == ALUADD && aluA[63] == aluB[63] && aluA[63] ^ e_valE[63] || alufun == 4'h1 && aluA[63] ^ aluB[63] && aluA[63] == e_valE[63]);
		end
	end
	
	always @ (*)
	begin	// cond
		case (E_ifun)
			4'h0: e_Cnd = 1;
			4'h1: e_Cnd = (SF ^ OF) | ZF;
			4'h2: e_Cnd = SF ^ OF;
			4'h3: e_Cnd = ZF;
			4'h4: e_Cnd = ~ZF;
			4'h5: e_Cnd = ~(SF ^ OF);
			4'h6: e_Cnd = ~(SF ^ OF) & ~ZF;
			default: e_Cnd = 1;
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
	assign M_bubble = pipeline_except || return_pred_err;
	always @ (posedge CLK or posedge reset)
	begin
        if (reset) begin
			M_stat  <= SAOK;
			M_icode <= INOP;
			M_Cnd   <= 0;
			M_valE  <= 64'h0;
			M_valA  <= 64'h0;
			M_valC 	<= 64'h0;
			M_dstE  <= RNONE;
			M_dstM  <= RNONE;
        end
		else if (M_bubble)
		begin
			M_icode <= INOP;
			M_valE  <= RNONE;
			M_valA  <= RNONE;
			M_dstE  <= RNONE;
			M_dstM  <= RNONE;
		end
		else
		begin
			M_stat  <= E_stat;
			M_icode <= E_icode;
			M_Cnd   <= e_Cnd;
			M_valE  <= e_valE;
			M_valA  <= E_valA;
			M_valC  <= E_valC;
			M_dstE  <= e_dstE;
			M_dstM  <= E_dstM;
		end
	end
	
	/* memory */
	
	assign mem_read  = (M_icode == IMRMOVQ || M_icode == IRET || M_icode == IPOPQ);
	assign mem_write = (M_icode == IRMMOVQ || M_icode == ICALL || M_icode == IPUSHQ);
	assign mem_addr  = (M_icode == IRET || M_icode == IPOPQ) ? M_valA : M_valE;
	assign mem_data  = M_valA;
	
	assign dmem_error = ((mem_read || mem_write) && mem_addr >= 64'h100);
	
	// m_stat
	always @ (*)
	begin
		if (M_stat == SAOK && dmem_error)
			m_stat <= SADR;
		else
			m_stat <= M_stat;
	end
	
	// update W
	assign W_stall = (W_stat != SAOK);
	always @ (posedge CLK or posedge reset)
	begin
        if (reset) begin
			W_Cnd	<= 0;
			W_stat  <= SAOK;
			W_icode <= INOP;
			W_valE  <= 64'h0;
			W_valM  <= 64'h0;
			W_dstE  <= RNONE;
			W_dstM  <= RNONE;
        end
		else if (W_stall)
			;
		else
		begin
			W_Cnd 	<= return_pred_err;
			W_stat  <= m_stat;
			W_icode <= M_icode;
			W_valE  <= M_valE;
			W_valM  <= m_valM;
			W_dstE  <= M_dstE;
			W_dstM  <= M_dstM;
		end
	end
	
	// Stat
	assign Stat = W_stat;
	
endmodule
