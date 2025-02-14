def addrimm12 : ComplexPattern<iPTR, 2, "selectIntAddrMM", [frameindex]>;
def addrimm4lsl2 : ComplexPattern<iPTR, 2, "selectIntAddrLSL2MM", [frameindex]>;

def simm4 : Operand<i32> {
  let DecoderMethod = "DecodeSimm4";
}
def simm7 : Operand<i32>;
def li_simm7 : Operand<i32> {
  let DecoderMethod = "DecodeLiSimm7";
}

def simm12 : Operand<i32> {
  let DecoderMethod = "DecodeSimm12";
}

def uimm5_lsl2 : Operand<OtherVT> {
  let EncoderMethod = "getUImm5Lsl2Encoding";
  let DecoderMethod = "DecodeUImm5lsl2";
}

def uimm6_lsl2 : Operand<i32> {
  let EncoderMethod = "getUImm6Lsl2Encoding";
  let DecoderMethod = "DecodeUImm6Lsl2";
}

def simm9_addiusp : Operand<i32> {
  let EncoderMethod = "getSImm9AddiuspValue";
  let DecoderMethod = "DecodeSimm9SP";
}

def uimm3_shift : Operand<i32> {
  let EncoderMethod = "getUImm3Mod8Encoding";
}

def simm3_lsa2 : Operand<i32> {
  let EncoderMethod = "getSImm3Lsa2Value";
  let DecoderMethod = "DecodeAddiur2Simm7";
}

def uimm4_andi : Operand<i32> {
  let EncoderMethod = "getUImm4AndValue";
  let DecoderMethod = "DecodeANDI16Imm";
}

def immSExtAddiur2 : ImmLeaf<i32, [{return Imm == 1 || Imm == -1 ||
                                           ((Imm % 4 == 0) &&
                                            Imm < 28 && Imm > 0);}]>;

def immSExtAddius5 : ImmLeaf<i32, [{return Imm >= -8 && Imm <= 7;}]>;

def immZExtAndi16 : ImmLeaf<i32,
  [{return (Imm == 128 || (Imm >= 1 && Imm <= 4) || Imm == 7 || Imm == 8 ||
            Imm == 15 || Imm == 16 || Imm == 31 || Imm == 32 || Imm == 63 ||
            Imm == 64 || Imm == 255 || Imm == 32768 || Imm == 65535 );}]>;

def immZExt2Shift : ImmLeaf<i32, [{return Imm >= 1 && Imm <= 8;}]>;

def immLi16 : ImmLeaf<i32, [{return Imm >= -1 && Imm <= 126;}]>;

def MicroMipsMemGPRMM16AsmOperand : AsmOperandClass {
  let Name = "MicroMipsMem";
  let RenderMethod = "addMicroMipsMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithGRPMM16Base";
}

class mem_mm_4_generic : Operand<i32> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops GPRMM16, simm4);
  let OperandType = "OPERAND_MEMORY";
  let ParserMatchClass = MicroMipsMemGPRMM16AsmOperand;
}

def mem_mm_4 : mem_mm_4_generic {
  let EncoderMethod = "getMemEncodingMMImm4";
}

def mem_mm_4_lsl1 : mem_mm_4_generic {
  let EncoderMethod = "getMemEncodingMMImm4Lsl1";
}

def mem_mm_4_lsl2 : mem_mm_4_generic {
  let EncoderMethod = "getMemEncodingMMImm4Lsl2";
}

def MicroMipsMemSPAsmOperand : AsmOperandClass {
  let Name = "MicroMipsMemSP";
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithUimmWordAlignedOffsetSP<7>";
}

def mem_mm_sp_imm5_lsl2 : Operand<i32> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops GPR32:$base, simm5:$offset);
  let OperandType = "OPERAND_MEMORY";
  let ParserMatchClass = MicroMipsMemSPAsmOperand;
  let EncoderMethod = "getMemEncodingMMSPImm5Lsl2";
}

def mem_mm_gp_imm7_lsl2 : Operand<i32> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops GPRMM16:$base, simm7:$offset);
  let OperandType = "OPERAND_MEMORY";
  let EncoderMethod = "getMemEncodingMMGPImm7Lsl2";
}

def mem_mm_12 : Operand<i32> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops GPR32, simm12);
  let EncoderMethod = "getMemEncodingMMImm12";
  let ParserMatchClass = MipsMemAsmOperand;
  let OperandType = "OPERAND_MEMORY";
}

def MipsMemUimm4AsmOperand : AsmOperandClass {
  let Name = "MemOffsetUimm4";
  let SuperClasses = [MipsMemAsmOperand];
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithUimmOffsetSP<6>";
}

def mem_mm_4sp : Operand<i32> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops GPR32, uimm8);
  let EncoderMethod = "getMemEncodingMMImm4sp";
  let ParserMatchClass = MipsMemUimm4AsmOperand;
  let OperandType = "OPERAND_MEMORY";
}

def jmptarget_mm : Operand<OtherVT> {
  let EncoderMethod = "getJumpTargetOpValueMM";
}

def calltarget_mm : Operand<iPTR> {
  let EncoderMethod = "getJumpTargetOpValueMM";
}

def brtarget7_mm : Operand<OtherVT> {
  let EncoderMethod = "getBranchTarget7OpValueMM";
  let OperandType   = "OPERAND_PCREL";
  let DecoderMethod = "DecodeBranchTarget7MM";
  let ParserMatchClass = MipsJumpTargetAsmOperand;
}

def brtarget10_mm : Operand<OtherVT> {
  let EncoderMethod = "getBranchTargetOpValueMMPC10";
  let OperandType   = "OPERAND_PCREL";
  let DecoderMethod = "DecodeBranchTarget10MM";
  let ParserMatchClass = MipsJumpTargetAsmOperand;
}

def brtarget_mm : Operand<OtherVT> {
  let EncoderMethod = "getBranchTargetOpValueMM";
  let OperandType   = "OPERAND_PCREL";
  let DecoderMethod = "DecodeBranchTargetMM";
  let ParserMatchClass = MipsJumpTargetAsmOperand;
}

def simm23_lsl2 : Operand<i32> {
  let EncoderMethod = "getSimm23Lsl2Encoding";
  let DecoderMethod = "DecodeSimm23Lsl2";
}

class CompactBranchMM<string opstr, DAGOperand opnd, PatFrag cond_op,
                      RegisterOperand RO> :
  InstSE<(outs), (ins RO:$rs, opnd:$offset),
         !strconcat(opstr, "\t$rs, $offset"), [], IIBranch, FrmI> {
  let isBranch = 1;
  let isTerminator = 1;
  let hasDelaySlot = 0;
  let Defs = [AT];
}

let canFoldAsLoad = 1 in
class LoadLeftRightMM<string opstr, SDNode OpNode, RegisterOperand RO,
                      Operand MemOpnd> :
  InstSE<(outs RO:$rt), (ins MemOpnd:$addr, RO:$src),
         !strconcat(opstr, "\t$rt, $addr"),
         [(set RO:$rt, (OpNode addrimm12:$addr, RO:$src))],
         NoItinerary, FrmI> {
  let DecoderMethod = "DecodeMemMMImm12";
  string Constraints = "$src = $rt";
}

class StoreLeftRightMM<string opstr, SDNode OpNode, RegisterOperand RO,
                       Operand MemOpnd>:
  InstSE<(outs), (ins RO:$rt, MemOpnd:$addr),
         !strconcat(opstr, "\t$rt, $addr"),
         [(OpNode RO:$rt, addrimm12:$addr)], NoItinerary, FrmI> {
  let DecoderMethod = "DecodeMemMMImm12";
}

/// A register pair used by movep instruction.
def MovePRegPairAsmOperand : AsmOperandClass {
  let Name = "MovePRegPair";
  let ParserMethod = "parseMovePRegPair";
  let PredicateMethod = "isMovePRegPair";
}

def movep_regpair : Operand<i32> {
  let EncoderMethod = "getMovePRegPairOpValue";
  let ParserMatchClass = MovePRegPairAsmOperand;
  let PrintMethod = "printRegisterList";
  let DecoderMethod = "DecodeMovePRegPair";
  let MIOperandInfo = (ops GPR32Opnd, GPR32Opnd);
}

class MovePMM16<string opstr, RegisterOperand RO> :
MicroMipsInst16<(outs movep_regpair:$dst_regs), (ins RO:$rs, RO:$rt),
                 !strconcat(opstr, "\t$dst_regs, $rs, $rt"), [],
                 NoItinerary, FrmR> {
  let isReMaterializable = 1;
}

/// A register pair used by load/store pair instructions.
def RegPairAsmOperand : AsmOperandClass {
  let Name = "RegPair";
  let ParserMethod = "parseRegisterPair";
}

def regpair : Operand<i32> {
  let EncoderMethod = "getRegisterPairOpValue";
  let ParserMatchClass = RegPairAsmOperand;
  let PrintMethod = "printRegisterPair";
  let DecoderMethod = "DecodeRegPairOperand";
  let MIOperandInfo = (ops GPR32Opnd, GPR32Opnd);
}

class StorePairMM<string opstr, InstrItinClass Itin = NoItinerary,
                  ComplexPattern Addr = addr> :
  InstSE<(outs), (ins regpair:$rt, mem_mm_12:$addr),
         !strconcat(opstr, "\t$rt, $addr"), [], Itin, FrmI, opstr> {
  let DecoderMethod = "DecodeMemMMImm12";
  let mayStore = 1;
}

class LoadPairMM<string opstr, InstrItinClass Itin = NoItinerary,
                 ComplexPattern Addr = addr> :
  InstSE<(outs regpair:$rt), (ins mem_mm_12:$addr),
          !strconcat(opstr, "\t$rt, $addr"), [], Itin, FrmI, opstr> {
  let DecoderMethod = "DecodeMemMMImm12";
  let mayLoad = 1;
}

class LLBaseMM<string opstr, RegisterOperand RO> :
  InstSE<(outs RO:$rt), (ins mem_mm_12:$addr),
         !strconcat(opstr, "\t$rt, $addr"), [], NoItinerary, FrmI> {
  let DecoderMethod = "DecodeMemMMImm12";
  let mayLoad = 1;
}

class SCBaseMM<string opstr, RegisterOperand RO> :
  InstSE<(outs RO:$dst), (ins RO:$rt, mem_mm_12:$addr),
         !strconcat(opstr, "\t$rt, $addr"), [], NoItinerary, FrmI> {
  let DecoderMethod = "DecodeMemMMImm12";
  let mayStore = 1;
  let Constraints = "$rt = $dst";
}

class LoadMM<string opstr, DAGOperand RO, SDPatternOperator OpNode = null_frag,
             InstrItinClass Itin = NoItinerary> :
  InstSE<(outs RO:$rt), (ins mem_mm_12:$addr),
         !strconcat(opstr, "\t$rt, $addr"),
         [(set RO:$rt, (OpNode addrimm12:$addr))], Itin, FrmI> {
  let DecoderMethod = "DecodeMemMMImm12";
  let canFoldAsLoad = 1;
  let mayLoad = 1;
}

class ArithRMM16<string opstr, RegisterOperand RO, bit isComm = 0,
                 InstrItinClass Itin = NoItinerary,
                 SDPatternOperator OpNode = null_frag> :
  MicroMipsInst16<(outs RO:$rd), (ins RO:$rs, RO:$rt),
                  !strconcat(opstr, "\t$rd, $rs, $rt"),
                  [(set RO:$rd, (OpNode RO:$rs, RO:$rt))], Itin, FrmR> {
  let isCommutable = isComm;
}

class AndImmMM16<string opstr, RegisterOperand RO,
                 InstrItinClass Itin = NoItinerary> :
  MicroMipsInst16<(outs RO:$rd), (ins RO:$rs, uimm4_andi:$imm),
                  !strconcat(opstr, "\t$rd, $rs, $imm"), [], Itin, FrmI>;

class LogicRMM16<string opstr, RegisterOperand RO,
                 InstrItinClass Itin = NoItinerary,
                 SDPatternOperator OpNode = null_frag> :
  MicroMipsInst16<(outs RO:$dst), (ins RO:$rs, RO:$rt),
         !strconcat(opstr, "\t$rt, $rs"),
         [(set RO:$dst, (OpNode RO:$rs, RO:$rt))], Itin, FrmR> {
  let isCommutable = 1;
  let Constraints = "$rt = $dst";
}

class NotMM16<string opstr, RegisterOperand RO> :
  MicroMipsInst16<(outs RO:$rt), (ins RO:$rs),
         !strconcat(opstr, "\t$rt, $rs"),
         [(set RO:$rt, (not RO:$rs))], NoItinerary, FrmR>;

class ShiftIMM16<string opstr, Operand ImmOpnd, RegisterOperand RO,
                 InstrItinClass Itin = NoItinerary> :
  MicroMipsInst16<(outs RO:$rd), (ins RO:$rt, ImmOpnd:$shamt),
                  !strconcat(opstr, "\t$rd, $rt, $shamt"), [], Itin, FrmR>;

class LoadMM16<string opstr, DAGOperand RO, SDPatternOperator OpNode,
               InstrItinClass Itin, Operand MemOpnd> :
  MicroMipsInst16<(outs RO:$rt), (ins MemOpnd:$addr),
                  !strconcat(opstr, "\t$rt, $addr"), [], Itin, FrmI> {
  let DecoderMethod = "DecodeMemMMImm4";
  let canFoldAsLoad = 1;
  let mayLoad = 1;
}

class StoreMM16<string opstr, DAGOperand RTOpnd, DAGOperand RO,
                SDPatternOperator OpNode, InstrItinClass Itin,
                Operand MemOpnd> :
  MicroMipsInst16<(outs), (ins RTOpnd:$rt, MemOpnd:$addr),
                  !strconcat(opstr, "\t$rt, $addr"), [], Itin, FrmI> {
  let DecoderMethod = "DecodeMemMMImm4";
  let mayStore = 1;
}

class LoadSPMM16<string opstr, DAGOperand RO, InstrItinClass Itin,
                 Operand MemOpnd> :
  MicroMipsInst16<(outs RO:$rt), (ins MemOpnd:$offset),
                  !strconcat(opstr, "\t$rt, $offset"), [], Itin, FrmI> {
  let DecoderMethod = "DecodeMemMMSPImm5Lsl2";
  let canFoldAsLoad = 1;
  let mayLoad = 1;
}

class StoreSPMM16<string opstr, DAGOperand RO, InstrItinClass Itin,
                  Operand MemOpnd> :
  MicroMipsInst16<(outs), (ins RO:$rt, MemOpnd:$offset),
                  !strconcat(opstr, "\t$rt, $offset"), [], Itin, FrmI> {
  let DecoderMethod = "DecodeMemMMSPImm5Lsl2";
  let mayStore = 1;
}

class LoadGPMM16<string opstr, DAGOperand RO, InstrItinClass Itin,
                 Operand MemOpnd> :
  MicroMipsInst16<(outs RO:$rt), (ins MemOpnd:$offset),
                  !strconcat(opstr, "\t$rt, $offset"), [], Itin, FrmI> {
  let DecoderMethod = "DecodeMemMMGPImm7Lsl2";
  let canFoldAsLoad = 1;
  let mayLoad = 1;
}

class AddImmUR2<string opstr, RegisterOperand RO> :
  MicroMipsInst16<(outs RO:$rd), (ins RO:$rs, simm3_lsa2:$imm),
                  !strconcat(opstr, "\t$rd, $rs, $imm"),
                  [], NoItinerary, FrmR> {
  let isCommutable = 1;
}

class AddImmUS5<string opstr, RegisterOperand RO> :
  MicroMipsInst16<(outs RO:$dst), (ins RO:$rd, simm4:$imm),
                  !strconcat(opstr, "\t$rd, $imm"), [], NoItinerary, FrmR> {
  let Constraints = "$rd = $dst";
}

class AddImmUR1SP<string opstr, RegisterOperand RO> :
  MicroMipsInst16<(outs RO:$rd), (ins uimm6_lsl2:$imm),
                  !strconcat(opstr, "\t$rd, $imm"), [], NoItinerary, FrmR>;

class AddImmUSP<string opstr> :
  MicroMipsInst16<(outs), (ins simm9_addiusp:$imm),
                  !strconcat(opstr, "\t$imm"), [], NoItinerary, FrmI>;

class MoveFromHILOMM<string opstr, RegisterOperand RO, Register UseReg> :
      MicroMipsInst16<(outs RO:$rd), (ins), !strconcat(opstr, "\t$rd"),
  [], II_MFHI_MFLO, FrmR> {
  let Uses = [UseReg];
  let hasSideEffects = 0;
}

class MoveMM16<string opstr, RegisterOperand RO, bit isComm = 0,
               InstrItinClass Itin = NoItinerary> :
  MicroMipsInst16<(outs RO:$rd), (ins RO:$rs),
                  !strconcat(opstr, "\t$rd, $rs"), [], Itin, FrmR> {
  let isCommutable = isComm;
  let isReMaterializable = 1;
}

class LoadImmMM16<string opstr, Operand Od, RegisterOperand RO> :
  MicroMipsInst16<(outs RO:$rd), (ins Od:$imm),
                  !strconcat(opstr, "\t$rd, $imm"), [], NoItinerary, FrmI> {
  let isReMaterializable = 1;
}

// 16-bit Jump and Link (Call)
class JumpLinkRegMM16<string opstr, RegisterOperand RO> :
  MicroMipsInst16<(outs), (ins RO:$rs), !strconcat(opstr, "\t$rs"),
           [(MipsJmpLink RO:$rs)], IIBranch, FrmR> {
  let isCall = 1;
  let hasDelaySlot = 1;
  let Defs = [RA];
}

// 16-bit Jump Reg
class JumpRegMM16<string opstr, RegisterOperand RO> :
  MicroMipsInst16<(outs), (ins RO:$rs), !strconcat(opstr, "\t$rs"),
           [], IIBranch, FrmR> {
  let hasDelaySlot = 1;
  let isBranch = 1;
  let isIndirectBranch = 1;
}

// Base class for JRADDIUSP instruction.
class JumpRAddiuStackMM16 :
  MicroMipsInst16<(outs), (ins uimm5_lsl2:$imm), "jraddiusp\t$imm",
                  [], IIBranch, FrmR> {
  let isTerminator = 1;
  let isBarrier = 1;
  let isBranch = 1;
  let isIndirectBranch = 1;
}

// 16-bit Jump and Link (Call) - Short Delay Slot
class JumpLinkRegSMM16<string opstr, RegisterOperand RO> :
  MicroMipsInst16<(outs), (ins RO:$rs), !strconcat(opstr, "\t$rs"),
           [], IIBranch, FrmR> {
  let isCall = 1;
  let hasDelaySlot = 1;
  let Defs = [RA];
}

// 16-bit Jump Register Compact - No delay slot
class JumpRegCMM16<string opstr, RegisterOperand RO> :
  MicroMipsInst16<(outs), (ins RO:$rs), !strconcat(opstr, "\t$rs"),
                  [], IIBranch, FrmR> {
  let isTerminator = 1;
  let isBarrier = 1;
  let isBranch = 1;
  let isIndirectBranch = 1;
}

// Break16 and Sdbbp16
class BrkSdbbp16MM<string opstr> :
  MicroMipsInst16<(outs), (ins uimm4:$code_),
                  !strconcat(opstr, "\t$code_"),
                  [], NoItinerary, FrmOther>;

class CBranchZeroMM<string opstr, DAGOperand opnd, RegisterOperand RO> :
  MicroMipsInst16<(outs), (ins RO:$rs, opnd:$offset),
                  !strconcat(opstr, "\t$rs, $offset"), [], IIBranch, FrmI> {
  let isBranch = 1;
  let isTerminator = 1;
  let hasDelaySlot = 1;
  let Defs = [AT];
}

// MicroMIPS Jump and Link (Call) - Short Delay Slot
let isCall = 1, hasDelaySlot = 1, Defs = [RA] in {
  class JumpLinkMM<string opstr, DAGOperand opnd> :
    InstSE<(outs), (ins opnd:$target), !strconcat(opstr, "\t$target"),
           [], IIBranch, FrmJ, opstr> {
    let DecoderMethod = "DecodeJumpTargetMM";
  }

  class JumpLinkRegMM<string opstr, RegisterOperand RO>:
    InstSE<(outs RO:$rd), (ins RO:$rs), !strconcat(opstr, "\t$rd, $rs"),
            [], IIBranch, FrmR>;

  class BranchCompareToZeroLinkMM<string opstr, DAGOperand opnd,
                                  RegisterOperand RO> :
    InstSE<(outs), (ins RO:$rs, opnd:$offset),
           !strconcat(opstr, "\t$rs, $offset"), [], IIBranch, FrmI, opstr>;
}

class LoadWordIndexedScaledMM<string opstr, RegisterOperand RO,
                              InstrItinClass Itin = NoItinerary,
                              SDPatternOperator OpNode = null_frag> :
  InstSE<(outs RO:$rd), (ins PtrRC:$base, PtrRC:$index),
         !strconcat(opstr, "\t$rd, ${index}(${base})"), [], Itin, FrmFI>;

class AddImmUPC<string opstr, RegisterOperand RO> :
  InstSE<(outs RO:$rs), (ins simm23_lsl2:$imm),
         !strconcat(opstr, "\t$rs, $imm"), [], NoItinerary, FrmR>;

/// A list of registers used by load/store multiple instructions.
def RegListAsmOperand : AsmOperandClass {
  let Name = "RegList";
  let ParserMethod = "parseRegisterList";
}

def reglist : Operand<i32> {
  let EncoderMethod = "getRegisterListOpValue";
  let ParserMatchClass = RegListAsmOperand;
  let PrintMethod = "printRegisterList";
  let DecoderMethod = "DecodeRegListOperand";
}

def RegList16AsmOperand : AsmOperandClass {
  let Name = "RegList16";
  let ParserMethod = "parseRegisterList";
  let PredicateMethod = "isRegList16";
  let RenderMethod = "addRegListOperands";
}

def reglist16 : Operand<i32> {
  let EncoderMethod = "getRegisterListOpValue16";
  let DecoderMethod = "DecodeRegListOperand16";
  let PrintMethod = "printRegisterList";
  let ParserMatchClass = RegList16AsmOperand;
}

class StoreMultMM<string opstr,
            InstrItinClass Itin = NoItinerary, ComplexPattern Addr = addr> :
  InstSE<(outs), (ins reglist:$rt, mem_mm_12:$addr),
         !strconcat(opstr, "\t$rt, $addr"), [], Itin, FrmI, opstr> {
  let DecoderMethod = "DecodeMemMMImm12";
  let mayStore = 1;
}

class LoadMultMM<string opstr,
            InstrItinClass Itin = NoItinerary, ComplexPattern Addr = addr> :
  InstSE<(outs reglist:$rt), (ins mem_mm_12:$addr),
          !strconcat(opstr, "\t$rt, $addr"), [], Itin, FrmI, opstr> {
  let DecoderMethod = "DecodeMemMMImm12";
  let mayLoad = 1;
}

class StoreMultMM16<string opstr,
                    InstrItinClass Itin = NoItinerary,
                    ComplexPattern Addr = addr> :
  MicroMipsInst16<(outs), (ins reglist16:$rt, mem_mm_4sp:$addr),
                  !strconcat(opstr, "\t$rt, $addr"), [], Itin, FrmI> {
  let DecoderMethod = "DecodeMemMMReglistImm4Lsl2";
  let mayStore = 1;
}

class LoadMultMM16<string opstr,
                   InstrItinClass Itin = NoItinerary,
                   ComplexPattern Addr = addr> :
  MicroMipsInst16<(outs reglist16:$rt), (ins mem_mm_4sp:$addr),
                  !strconcat(opstr, "\t$rt, $addr"), [], Itin, FrmI> {
  let DecoderMethod = "DecodeMemMMReglistImm4Lsl2";
  let mayLoad = 1;
}

class UncondBranchMM16<string opstr> :
  MicroMipsInst16<(outs), (ins brtarget10_mm:$offset),
                  !strconcat(opstr, "\t$offset"),
                  [], IIBranch, FrmI> {
  let isBranch = 1;
  let isTerminator = 1;
  let isBarrier = 1;
  let hasDelaySlot = 1;
  let Predicates = [RelocPIC, InMicroMips];
  let Defs = [AT];
}

def ADDU16_MM : ArithRMM16<"addu16", GPRMM16Opnd, 1, II_ADDU, add>,
                ARITH_FM_MM16<0>;
def SUBU16_MM : ArithRMM16<"subu16", GPRMM16Opnd, 0, II_SUBU, sub>,
                ARITH_FM_MM16<1>;
def ANDI16_MM : AndImmMM16<"andi16", GPRMM16Opnd, II_AND>, ANDI_FM_MM16<0x0b>;
def AND16_MM : LogicRMM16<"and16", GPRMM16Opnd, II_AND, and>,
               LOGIC_FM_MM16<0x2>;
def OR16_MM  : LogicRMM16<"or16", GPRMM16Opnd, II_OR, or>,
               LOGIC_FM_MM16<0x3>;
def XOR16_MM : LogicRMM16<"xor16", GPRMM16Opnd, II_XOR, xor>,
               LOGIC_FM_MM16<0x1>;
def NOT16_MM : NotMM16<"not16", GPRMM16Opnd>, LOGIC_FM_MM16<0x0>;
def SLL16_MM : ShiftIMM16<"sll16", uimm3_shift, GPRMM16Opnd, II_SLL>,
               SHIFT_FM_MM16<0>;
def SRL16_MM : ShiftIMM16<"srl16", uimm3_shift, GPRMM16Opnd, II_SRL>,
               SHIFT_FM_MM16<1>;
def LBU16_MM : LoadMM16<"lbu16", GPRMM16Opnd, zextloadi8, II_LBU,
                        mem_mm_4>, LOAD_STORE_FM_MM16<0x02>;
def LHU16_MM : LoadMM16<"lhu16", GPRMM16Opnd, zextloadi16, II_LHU,
                        mem_mm_4_lsl1>, LOAD_STORE_FM_MM16<0x0a>;
def LW16_MM : LoadMM16<"lw16", GPRMM16Opnd, load, II_LW, mem_mm_4_lsl2>,
                      LOAD_STORE_FM_MM16<0x1a>;
def SB16_MM : StoreMM16<"sb16", GPRMM16OpndZero, GPRMM16Opnd, truncstorei8,
                        II_SB, mem_mm_4>, LOAD_STORE_FM_MM16<0x22>;
def SH16_MM : StoreMM16<"sh16", GPRMM16OpndZero, GPRMM16Opnd, truncstorei16,
                        II_SH, mem_mm_4_lsl1>,
                        LOAD_STORE_FM_MM16<0x2a>;
def SW16_MM : StoreMM16<"sw16", GPRMM16OpndZero, GPRMM16Opnd, store, II_SW,
                        mem_mm_4_lsl2>, LOAD_STORE_FM_MM16<0x3a>;
def LWGP_MM : LoadGPMM16<"lw", GPRMM16Opnd, II_LW, mem_mm_gp_imm7_lsl2>,
                         LOAD_GP_FM_MM16<0x19>;
def LWSP_MM : LoadSPMM16<"lw", GPR32Opnd, II_LW, mem_mm_sp_imm5_lsl2>,
              LOAD_STORE_SP_FM_MM16<0x12>;
def SWSP_MM : StoreSPMM16<"sw", GPR32Opnd, II_SW, mem_mm_sp_imm5_lsl2>,
              LOAD_STORE_SP_FM_MM16<0x32>;
def ADDIUR1SP_MM : AddImmUR1SP<"addiur1sp", GPRMM16Opnd>, ADDIUR1SP_FM_MM16;
def ADDIUR2_MM : AddImmUR2<"addiur2", GPRMM16Opnd>, ADDIUR2_FM_MM16;
def ADDIUS5_MM : AddImmUS5<"addius5", GPR32Opnd>, ADDIUS5_FM_MM16;
def ADDIUSP_MM : AddImmUSP<"addiusp">, ADDIUSP_FM_MM16;
def MFHI16_MM : MoveFromHILOMM<"mfhi", GPR32Opnd, AC0>, MFHILO_FM_MM16<0x10>;
def MFLO16_MM : MoveFromHILOMM<"mflo", GPR32Opnd, AC0>, MFHILO_FM_MM16<0x12>;
def MOVE16_MM : MoveMM16<"move", GPR32Opnd>, MOVE_FM_MM16<0x03>;
def MOVEP_MM : MovePMM16<"movep", GPRMM16OpndMoveP>, MOVEP_FM_MM16;
def LI16_MM : LoadImmMM16<"li16", li_simm7, GPRMM16Opnd>, LI_FM_MM16,
              IsAsCheapAsAMove;
def JALR16_MM : JumpLinkRegMM16<"jalr", GPR32Opnd>, JALR_FM_MM16<0x0e>;
def JALRS16_MM : JumpLinkRegSMM16<"jalrs16", GPR32Opnd>, JALR_FM_MM16<0x0f>;
def JRC16_MM : JumpRegCMM16<"jrc", GPR32Opnd>, JALR_FM_MM16<0x0d>;
def JRADDIUSP : JumpRAddiuStackMM16, JRADDIUSP_FM_MM16<0x18>;
def JR16_MM : JumpRegMM16<"jr16", GPR32Opnd>, JALR_FM_MM16<0x0c>;
def BEQZ16_MM : CBranchZeroMM<"beqz16", brtarget7_mm, GPRMM16Opnd>,
                BEQNEZ_FM_MM16<0x23>;
def BNEZ16_MM : CBranchZeroMM<"bnez16", brtarget7_mm, GPRMM16Opnd>,
                BEQNEZ_FM_MM16<0x2b>;
def B16_MM : UncondBranchMM16<"b16">, B16_FM;
def BREAK16_MM : BrkSdbbp16MM<"break16">, BRKSDBBP16_FM_MM<0x28>;
def SDBBP16_MM : BrkSdbbp16MM<"sdbbp16">, BRKSDBBP16_FM_MM<0x2C>;

class WaitMM<string opstr> :
  InstSE<(outs), (ins uimm10:$code_), !strconcat(opstr, "\t$code_"), [],
         NoItinerary, FrmOther, opstr>;

let DecoderNamespace = "MicroMips", Predicates = [InMicroMips] in {
  /// Compact Branch Instructions
  def BEQZC_MM : CompactBranchMM<"beqzc", brtarget_mm, seteq, GPR32Opnd>,
                 COMPACT_BRANCH_FM_MM<0x7>;
  def BNEZC_MM : CompactBranchMM<"bnezc", brtarget_mm, setne, GPR32Opnd>,
                 COMPACT_BRANCH_FM_MM<0x5>;

  /// Arithmetic Instructions (ALU Immediate)
  def ADDiu_MM : MMRel, ArithLogicI<"addiu", simm16, GPR32Opnd>,
                 ADDI_FM_MM<0xc>;
  def ADDi_MM  : MMRel, ArithLogicI<"addi", simm16, GPR32Opnd>,
                 ADDI_FM_MM<0x4>;
  def SLTi_MM  : MMRel, SetCC_I<"slti", setlt, simm16, immSExt16, GPR32Opnd>,
                 SLTI_FM_MM<0x24>;
  def SLTiu_MM : MMRel, SetCC_I<"sltiu", setult, simm16, immSExt16, GPR32Opnd>,
                 SLTI_FM_MM<0x2c>;
  def ANDi_MM  : MMRel, ArithLogicI<"andi", uimm16, GPR32Opnd>,
                 ADDI_FM_MM<0x34>;
  def ORi_MM   : MMRel, ArithLogicI<"ori", uimm16, GPR32Opnd>,
                 ADDI_FM_MM<0x14>;
  def XORi_MM  : MMRel, ArithLogicI<"xori", uimm16, GPR32Opnd>,
                 ADDI_FM_MM<0x1c>;
  def LUi_MM   : MMRel, LoadUpper<"lui", GPR32Opnd, uimm16>, LUI_FM_MM;

  def LEA_ADDiu_MM : MMRel, EffectiveAddress<"addiu", GPR32Opnd>,
                     LW_FM_MM<0xc>;

  /// Arithmetic Instructions (3-Operand, R-Type)
  def ADDu_MM  : MMRel, ArithLogicR<"addu", GPR32Opnd, 1, II_ADDU, add>,
                 ADD_FM_MM<0, 0x150>;
  def SUBu_MM  : MMRel, ArithLogicR<"subu", GPR32Opnd, 0, II_SUBU, sub>,
                 ADD_FM_MM<0, 0x1d0>;
  def MUL_MM   : MMRel, ArithLogicR<"mul", GPR32Opnd>, ADD_FM_MM<0, 0x210>;
  def ADD_MM   : MMRel, ArithLogicR<"add", GPR32Opnd>, ADD_FM_MM<0, 0x110>;
  def SUB_MM   : MMRel, ArithLogicR<"sub", GPR32Opnd>, ADD_FM_MM<0, 0x190>;
  def SLT_MM   : MMRel, SetCC_R<"slt", setlt, GPR32Opnd>, ADD_FM_MM<0, 0x350>;
  def SLTu_MM  : MMRel, SetCC_R<"sltu", setult, GPR32Opnd>,
                 ADD_FM_MM<0, 0x390>;
  def AND_MM   : MMRel, ArithLogicR<"and", GPR32Opnd, 1, II_AND, and>,
                 ADD_FM_MM<0, 0x250>;
  def OR_MM    : MMRel, ArithLogicR<"or", GPR32Opnd, 1, II_OR, or>,
                 ADD_FM_MM<0, 0x290>;
  def XOR_MM   : MMRel, ArithLogicR<"xor", GPR32Opnd, 1, II_XOR, xor>,
                 ADD_FM_MM<0, 0x310>;
  def NOR_MM   : MMRel, LogicNOR<"nor", GPR32Opnd>, ADD_FM_MM<0, 0x2d0>;
  def MULT_MM  : MMRel, Mult<"mult", II_MULT, GPR32Opnd, [HI0, LO0]>,
                 MULT_FM_MM<0x22c>;
  def MULTu_MM : MMRel, Mult<"multu", II_MULTU, GPR32Opnd, [HI0, LO0]>,
                 MULT_FM_MM<0x26c>;
  def SDIV_MM  : MMRel, Div<"div", II_DIV, GPR32Opnd, [HI0, LO0]>,
                 MULT_FM_MM<0x2ac>;
  def UDIV_MM  : MMRel, Div<"divu", II_DIVU, GPR32Opnd, [HI0, LO0]>,
                 MULT_FM_MM<0x2ec>;

  /// Arithmetic Instructions with PC and Immediate
  def ADDIUPC_MM : AddImmUPC<"addiupc", GPRMM16Opnd>, ADDIUPC_FM_MM;

  /// Shift Instructions
  def SLL_MM   : MMRel, shift_rotate_imm<"sll", uimm5, GPR32Opnd, II_SLL>,
                 SRA_FM_MM<0, 0>;
  def SRL_MM   : MMRel, shift_rotate_imm<"srl", uimm5, GPR32Opnd, II_SRL>,
                 SRA_FM_MM<0x40, 0>;
  def SRA_MM   : MMRel, shift_rotate_imm<"sra", uimm5, GPR32Opnd, II_SRA>,
                 SRA_FM_MM<0x80, 0>;
  def SLLV_MM  : MMRel, shift_rotate_reg<"sllv", GPR32Opnd, II_SLLV>,
                 SRLV_FM_MM<0x10, 0>;
  def SRLV_MM  : MMRel, shift_rotate_reg<"srlv", GPR32Opnd, II_SRLV>,
                 SRLV_FM_MM<0x50, 0>;
  def SRAV_MM  : MMRel, shift_rotate_reg<"srav", GPR32Opnd, II_SRAV>,
                 SRLV_FM_MM<0x90, 0>;
  def ROTR_MM  : MMRel, shift_rotate_imm<"rotr", uimm5, GPR32Opnd, II_ROTR>,
                 SRA_FM_MM<0xc0, 0>;
  def ROTRV_MM : MMRel, shift_rotate_reg<"rotrv", GPR32Opnd, II_ROTRV>,
                 SRLV_FM_MM<0xd0, 0>;

  /// Load and Store Instructions - aligned
  let DecoderMethod = "DecodeMemMMImm16" in {
    def LB_MM  : Load<"lb", GPR32Opnd>, MMRel, LW_FM_MM<0x7>;
    def LBu_MM : Load<"lbu", GPR32Opnd>, MMRel, LW_FM_MM<0x5>;
    def LH_MM  : Load<"lh", GPR32Opnd>, MMRel, LW_FM_MM<0xf>;
    def LHu_MM : Load<"lhu", GPR32Opnd>, MMRel, LW_FM_MM<0xd>;
    def LW_MM  : Load<"lw", GPR32Opnd>, MMRel, LW_FM_MM<0x3f>;
    def SB_MM  : Store<"sb", GPR32Opnd>, MMRel, LW_FM_MM<0x6>;
    def SH_MM  : Store<"sh", GPR32Opnd>, MMRel, LW_FM_MM<0xe>;
    def SW_MM  : Store<"sw", GPR32Opnd>, MMRel, LW_FM_MM<0x3e>;
  }

  def LWXS_MM : LoadWordIndexedScaledMM<"lwxs", GPR32Opnd>, LWXS_FM_MM<0x118>;

  def LWU_MM : LoadMM<"lwu", GPR32Opnd, zextloadi32, II_LWU>, LL_FM_MM<0xe>;

  /// Load and Store Instructions - unaligned
  def LWL_MM : LoadLeftRightMM<"lwl", MipsLWL, GPR32Opnd, mem_mm_12>,
               LWL_FM_MM<0x0>;
  def LWR_MM : LoadLeftRightMM<"lwr", MipsLWR, GPR32Opnd, mem_mm_12>,
               LWL_FM_MM<0x1>;
  def SWL_MM : StoreLeftRightMM<"swl", MipsSWL, GPR32Opnd, mem_mm_12>,
               LWL_FM_MM<0x8>;
  def SWR_MM : StoreLeftRightMM<"swr", MipsSWR, GPR32Opnd, mem_mm_12>,
               LWL_FM_MM<0x9>;

  /// Load and Store Instructions - multiple
  def SWM32_MM  : StoreMultMM<"swm32">, LWM_FM_MM<0xd>;
  def LWM32_MM  : LoadMultMM<"lwm32">, LWM_FM_MM<0x5>;
  def SWM16_MM : StoreMultMM16<"swm16">, LWM_FM_MM16<0x5>;
  def LWM16_MM : LoadMultMM16<"lwm16">, LWM_FM_MM16<0x4>;

  /// Load and Store Pair Instructions
  def SWP_MM  : StorePairMM<"swp">, LWM_FM_MM<0x9>;
  def LWP_MM  : LoadPairMM<"lwp">, LWM_FM_MM<0x1>;

  /// Load and Store multiple pseudo Instructions
  class LoadWordMultMM<string instr_asm > :
    MipsAsmPseudoInst<(outs reglist:$rt), (ins mem_mm_12:$addr),
                      !strconcat(instr_asm, "\t$rt, $addr")> ;

  class StoreWordMultMM<string instr_asm > :
    MipsAsmPseudoInst<(outs), (ins reglist:$rt, mem_mm_12:$addr),
                      !strconcat(instr_asm, "\t$rt, $addr")> ;


  def SWM_MM  : StoreWordMultMM<"swm">;
  def LWM_MM  : LoadWordMultMM<"lwm">;

  /// Move Conditional
  def MOVZ_I_MM : MMRel, CMov_I_I_FT<"movz", GPR32Opnd, GPR32Opnd,
                  NoItinerary>, ADD_FM_MM<0, 0x58>;
  def MOVN_I_MM : MMRel, CMov_I_I_FT<"movn", GPR32Opnd, GPR32Opnd,
                  NoItinerary>, ADD_FM_MM<0, 0x18>;
  def MOVT_I_MM : MMRel, CMov_F_I_FT<"movt", GPR32Opnd, II_MOVT>,
                  CMov_F_I_FM_MM<0x25>;
  def MOVF_I_MM : MMRel, CMov_F_I_FT<"movf", GPR32Opnd, II_MOVF>,
                  CMov_F_I_FM_MM<0x5>;

  /// Move to/from HI/LO
  def MTHI_MM : MMRel, MoveToLOHI<"mthi", GPR32Opnd, [HI0]>,
                MTLO_FM_MM<0x0b5>;
  def MTLO_MM : MMRel, MoveToLOHI<"mtlo", GPR32Opnd, [LO0]>,
                MTLO_FM_MM<0x0f5>;
  def MFHI_MM : MMRel, MoveFromLOHI<"mfhi", GPR32Opnd, AC0>,
                MFLO_FM_MM<0x035>;
  def MFLO_MM : MMRel, MoveFromLOHI<"mflo", GPR32Opnd, AC0>,
                MFLO_FM_MM<0x075>;

  /// Multiply Add/Sub Instructions
  def MADD_MM  : MMRel, MArithR<"madd", II_MADD, 1>, MULT_FM_MM<0x32c>;
  def MADDU_MM : MMRel, MArithR<"maddu", II_MADDU, 1>, MULT_FM_MM<0x36c>;
  def MSUB_MM  : MMRel, MArithR<"msub", II_MSUB>, MULT_FM_MM<0x3ac>;
  def MSUBU_MM : MMRel, MArithR<"msubu", II_MSUBU>, MULT_FM_MM<0x3ec>;

  /// Count Leading
  def CLZ_MM : MMRel, CountLeading0<"clz", GPR32Opnd>, CLO_FM_MM<0x16c>,
               ISA_MIPS32;
  def CLO_MM : MMRel, CountLeading1<"clo", GPR32Opnd>, CLO_FM_MM<0x12c>,
               ISA_MIPS32;

  /// Sign Ext In Register Instructions.
  def SEB_MM : MMRel, SignExtInReg<"seb", i8, GPR32Opnd, II_SEB>,
               SEB_FM_MM<0x0ac>, ISA_MIPS32R2;
  def SEH_MM : MMRel, SignExtInReg<"seh", i16, GPR32Opnd, II_SEH>,
               SEB_FM_MM<0x0ec>, ISA_MIPS32R2;

  /// Word Swap Bytes Within Halfwords
  def WSBH_MM : MMRel, SubwordSwap<"wsbh", GPR32Opnd>, SEB_FM_MM<0x1ec>,
                ISA_MIPS32R2;

  def EXT_MM : MMRel, ExtBase<"ext", GPR32Opnd, uimm5, MipsExt>,
               EXT_FM_MM<0x2c>;
  def INS_MM : MMRel, InsBase<"ins", GPR32Opnd, uimm5, MipsIns>,
               EXT_FM_MM<0x0c>;

  /// Jump Instructions
  let DecoderMethod = "DecodeJumpTargetMM" in {
    def J_MM        : MMRel, JumpFJ<jmptarget_mm, "j", br, bb, "j">,
                      J_FM_MM<0x35>;
    def JAL_MM      : MMRel, JumpLink<"jal", calltarget_mm>, J_FM_MM<0x3d>;
    def JALX_MM     : MMRel, JumpLink<"jalx", calltarget>, J_FM_MM<0x3c>;
  }
  def JR_MM   : MMRel, IndirectBranch<"jr", GPR32Opnd>, JR_FM_MM<0x3c>;
  def JALR_MM : JumpLinkReg<"jalr", GPR32Opnd>, JALR_FM_MM<0x03c>;

  /// Jump Instructions - Short Delay Slot
  def JALS_MM   : JumpLinkMM<"jals", calltarget_mm>, J_FM_MM<0x1d>;
  def JALRS_MM  : JumpLinkRegMM<"jalrs", GPR32Opnd>, JALR_FM_MM<0x13c>;

  /// Branch Instructions
  def BEQ_MM  : MMRel, CBranch<"beq", brtarget_mm, seteq, GPR32Opnd>,
                BEQ_FM_MM<0x25>;
  def BNE_MM  : MMRel, CBranch<"bne", brtarget_mm, setne, GPR32Opnd>,
                BEQ_FM_MM<0x2d>;
  def BGEZ_MM : MMRel, CBranchZero<"bgez", brtarget_mm, setge, GPR32Opnd>,
                BGEZ_FM_MM<0x2>;
  def BGTZ_MM : MMRel, CBranchZero<"bgtz", brtarget_mm, setgt, GPR32Opnd>,
                BGEZ_FM_MM<0x6>;
  def BLEZ_MM : MMRel, CBranchZero<"blez", brtarget_mm, setle, GPR32Opnd>,
                BGEZ_FM_MM<0x4>;
  def BLTZ_MM : MMRel, CBranchZero<"bltz", brtarget_mm, setlt, GPR32Opnd>,
                BGEZ_FM_MM<0x0>;
  def BGEZAL_MM : MMRel, BGEZAL_FT<"bgezal", brtarget_mm, GPR32Opnd>,
                  BGEZAL_FM_MM<0x03>;
  def BLTZAL_MM : MMRel, BGEZAL_FT<"bltzal", brtarget_mm, GPR32Opnd>,
                  BGEZAL_FM_MM<0x01>;

  /// Branch Instructions - Short Delay Slot
  def BGEZALS_MM : BranchCompareToZeroLinkMM<"bgezals", brtarget_mm,
                                             GPR32Opnd>, BGEZAL_FM_MM<0x13>;
  def BLTZALS_MM : BranchCompareToZeroLinkMM<"bltzals", brtarget_mm,
                                             GPR32Opnd>, BGEZAL_FM_MM<0x11>;

  /// Control Instructions
  def SYNC_MM    : MMRel, SYNC_FT<"sync">, SYNC_FM_MM;
  def BREAK_MM   : MMRel, BRK_FT<"break">, BRK_FM_MM;
  def SYSCALL_MM : MMRel, SYS_FT<"syscall">, SYS_FM_MM;
  def WAIT_MM    : WaitMM<"wait">, WAIT_FM_MM;
  def ERET_MM    : MMRel, ER_FT<"eret">, ER_FM_MM<0x3cd>;
  def DERET_MM   : MMRel, ER_FT<"deret">, ER_FM_MM<0x38d>;
  def EI_MM      : MMRel, DEI_FT<"ei", GPR32Opnd>, EI_FM_MM<0x15d>,
                   ISA_MIPS32R2;
  def DI_MM      : MMRel, DEI_FT<"di", GPR32Opnd>, EI_FM_MM<0x11d>,
                   ISA_MIPS32R2;

  /// Trap Instructions
  def TEQ_MM  : MMRel, TEQ_FT<"teq", GPR32Opnd>, TEQ_FM_MM<0x0>;
  def TGE_MM  : MMRel, TEQ_FT<"tge", GPR32Opnd>, TEQ_FM_MM<0x08>;
  def TGEU_MM : MMRel, TEQ_FT<"tgeu", GPR32Opnd>, TEQ_FM_MM<0x10>;
  def TLT_MM  : MMRel, TEQ_FT<"tlt", GPR32Opnd>, TEQ_FM_MM<0x20>;
  def TLTU_MM : MMRel, TEQ_FT<"tltu", GPR32Opnd>, TEQ_FM_MM<0x28>;
  def TNE_MM  : MMRel, TEQ_FT<"tne", GPR32Opnd>, TEQ_FM_MM<0x30>;

  def TEQI_MM  : MMRel, TEQI_FT<"teqi", GPR32Opnd>, TEQI_FM_MM<0x0e>;
  def TGEI_MM  : MMRel, TEQI_FT<"tgei", GPR32Opnd>, TEQI_FM_MM<0x09>;
  def TGEIU_MM : MMRel, TEQI_FT<"tgeiu", GPR32Opnd>, TEQI_FM_MM<0x0b>;
  def TLTI_MM  : MMRel, TEQI_FT<"tlti", GPR32Opnd>, TEQI_FM_MM<0x08>;
  def TLTIU_MM : MMRel, TEQI_FT<"tltiu", GPR32Opnd>, TEQI_FM_MM<0x0a>;
  def TNEI_MM  : MMRel, TEQI_FT<"tnei", GPR32Opnd>, TEQI_FM_MM<0x0c>;

  /// Load-linked, Store-conditional
  def LL_MM : LLBaseMM<"ll", GPR32Opnd>, LL_FM_MM<0x3>;
  def SC_MM : SCBaseMM<"sc", GPR32Opnd>, LL_FM_MM<0xb>;

  let DecoderMethod = "DecodeCacheOpMM" in {
  def CACHE_MM : MMRel, CacheOp<"cache", mem_mm_12>,
                 CACHE_PREF_FM_MM<0x08, 0x6>;
  def PREF_MM  : MMRel, CacheOp<"pref", mem_mm_12>,
                 CACHE_PREF_FM_MM<0x18, 0x2>;
  }
  def SSNOP_MM : MMRel, Barrier<"ssnop">, BARRIER_FM_MM<0x1>;
  def EHB_MM   : MMRel, Barrier<"ehb">, BARRIER_FM_MM<0x3>;
  def PAUSE_MM : MMRel, Barrier<"pause">, BARRIER_FM_MM<0x5>;

  def TLBP_MM : MMRel, TLB<"tlbp">, COP0_TLB_FM_MM<0x0d>;
  def TLBR_MM : MMRel, TLB<"tlbr">, COP0_TLB_FM_MM<0x4d>;
  def TLBWI_MM : MMRel, TLB<"tlbwi">, COP0_TLB_FM_MM<0x8d>;
  def TLBWR_MM : MMRel, TLB<"tlbwr">, COP0_TLB_FM_MM<0xcd>;

  def SDBBP_MM : MMRel, SYS_FT<"sdbbp">, SDBBP_FM_MM;
  def RDHWR_MM : MMRel, ReadHardware<GPR32Opnd, HWRegsOpnd>, RDHWR_FM_MM;
}

let Predicates = [InMicroMips] in {

//===----------------------------------------------------------------------===//
// MicroMips arbitrary patterns that map to one or more instructions
//===----------------------------------------------------------------------===//

def : MipsPat<(i32 immLi16:$imm),
              (LI16_MM immLi16:$imm)>;
def : MipsPat<(i32 immSExt16:$imm),
              (ADDiu_MM ZERO, immSExt16:$imm)>;
def : MipsPat<(i32 immZExt16:$imm),
              (ORi_MM ZERO, immZExt16:$imm)>;
def : MipsPat<(not GPR32:$in),
              (NOR_MM GPR32Opnd:$in, ZERO)>;

def : MipsPat<(add GPRMM16:$src, immSExtAddiur2:$imm),
              (ADDIUR2_MM GPRMM16:$src, immSExtAddiur2:$imm)>;
def : MipsPat<(add GPR32:$src, immSExtAddius5:$imm),
              (ADDIUS5_MM GPR32:$src, immSExtAddius5:$imm)>;
def : MipsPat<(add GPR32:$src, immSExt16:$imm),
              (ADDiu_MM GPR32:$src, immSExt16:$imm)>;

def : MipsPat<(and GPRMM16:$src, immZExtAndi16:$imm),
              (ANDI16_MM GPRMM16:$src, immZExtAndi16:$imm)>;
def : MipsPat<(and GPR32:$src, immZExt16:$imm),
              (ANDi_MM GPR32:$src, immZExt16:$imm)>;

def : MipsPat<(shl GPRMM16:$src, immZExt2Shift:$imm),
              (SLL16_MM GPRMM16:$src, immZExt2Shift:$imm)>;
def : MipsPat<(shl GPR32:$src, immZExt5:$imm),
              (SLL_MM GPR32:$src, immZExt5:$imm)>;

def : MipsPat<(srl GPRMM16:$src, immZExt2Shift:$imm),
              (SRL16_MM GPRMM16:$src, immZExt2Shift:$imm)>;
def : MipsPat<(srl GPR32:$src, immZExt5:$imm),
              (SRL_MM GPR32:$src, immZExt5:$imm)>;

def : MipsPat<(store GPRMM16:$src, addrimm4lsl2:$addr),
              (SW16_MM GPRMM16:$src, addrimm4lsl2:$addr)>;
def : MipsPat<(store GPR32:$src, addr:$addr),
              (SW_MM GPR32:$src, addr:$addr)>;

def : MipsPat<(load addrimm4lsl2:$addr),
              (LW16_MM addrimm4lsl2:$addr)>;
def : MipsPat<(load addr:$addr),
              (LW_MM addr:$addr)>;

//===----------------------------------------------------------------------===//
// MicroMips instruction aliases
//===----------------------------------------------------------------------===//

class UncondBranchMMPseudo<string opstr> :
  MipsAsmPseudoInst<(outs), (ins brtarget_mm:$offset),
                    !strconcat(opstr, "\t$offset")>;

def B_MM_Pseudo : UncondBranchMMPseudo<"b">, ISA_MICROMIPS;

  def : MipsInstAlias<"wait", (WAIT_MM 0x0), 1>;
  def : MipsInstAlias<"nop", (SLL_MM ZERO, ZERO, 0), 1>;
  def : MipsInstAlias<"nop", (MOVE16_MM ZERO, ZERO), 1>;
}

let Predicates = [InMicroMips] in {
def : MipsInstAlias<"ei", (EI_MM ZERO), 1>, ISA_MIPS32R2;
}
