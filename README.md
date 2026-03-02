#  MIPS32 Processor Design & Architecture

> 本專案收錄了「計算機組織 (Computer Organization)」課程的完整處理器開發與硬體設計實作。

本系列專案帶領我們從最上層的 MIPS 組合語言出發，一路向下深潛至硬體底層，最終使用 Verilog HDL 從零開始打造出一顆具備**5-Stage Pipeline**、**Data Forwarding** 以及**Hazard Detection** 完整機制的 MIPS32 架構處理器。

##  開發與驗證環境

* **硬體描述語言 (HDL):** Verilog
* **指令集架構 (ISA):** MIPS32
* **模擬與編譯環境:** Icarus Verilog (iverilog), SPIM Simulator
* **波形觀察工具:** GTKWave

---

##  專案導覽 (Project Overview)

###  Lab 1: MIPS Assembly Programming (組合語言實作)
在接觸硬體電路前，先從軟體層面熟悉 MIPS 指令集架構 (ISA)。
[Image of SPIM MIPS simulator interface]
* **技術亮點:** 透過 SPIM 模擬器，直接操作暫存器與記憶體，實作了數字反轉、費氏數列加總 ，以及運用於密碼學的**擴展歐幾里得演算法 **，展現對底層流程控制與系統呼叫的掌握。

###  Lab 2: 32-bit Arithmetic Logic Unit (算術邏輯單元)
捨棄高階語法，純粹以邏輯閘層級 (Gate-level) 搭建 CPU 的運算核心。
[Image of 32-bit ALU internal architecture]
* **技術亮點:** 自行設計 1-bit ALU 與各類型多工器 (MUX)，並將其串接擴展為完整的 32-bit 算術邏輯單元。具備處理加減法 (`add`, `sub`)、邏輯運算 (`and`, `or`, `nor`) 與大小比較 (`slt`) 的能力，並能精準輸出 Zero 與 Overflow 旗標。

###  Lab 3: Single Cycle Processor (單週期處理器)
建構處理器的核心資料路徑 (Datapath) 與控制單元 (Control Unit)，實現純硬體的指令解析與執行。
[Image of MIPS single cycle datapath]
* **技術亮點:** 完美整合 Register File、 ALU 以及指令/資料記憶體，體現標準的 Harvard Architecture。實作的主控制器 (Decoder) 能成功在一條時脈週期內，精準控管 R-type, I-type 與 J-type 指令的資料流向。

###  Lab 4: 5-Stage Pipelined Processor (管線化處理器)
突破單週期效能瓶頸，導入現代處理器必備的流水線技術，大幅提升系統吞吐量。
[Image of 5-stage MIPS pipeline architecture]
* **技術亮點:** 設計專屬的管線化暫存器 (`Pipe_Reg.v`)，將指令週期硬生生切分為 **IF, ID, EX, MEM, WB** 五個獨立階段。並成功解決了控制訊號在不同管線階段間的伴隨傳遞問題。

###  Lab 5: Advanced Pipeline Architecture (進階管線化與危險防護)
實作處理器中最複雜的相依性處理機制，打造具備商業晶片雛形的強大核心。
[Image of 5-stage MIPS pipeline with forwarding and hazard detection units]
* **技術亮點:** * **Data Forwarding:** 實作 Bypass 網路，攔截 `EX/MEM` 與 `MEM/WB` 階段的最新運算結果，直接導回 ALU 輸入端，完美消除 Read-After-Write (RAW) 產生的效能氣泡。
  * **Hazard Detection:** 針對無法單靠前遞解決的 Load-Use Hazard，實作了精確的 Stall 與插入 NOP 氣泡機制；同時完美處理了 Branch 發生時的管線 Flush。

---

##  專案目錄結構 (Repository Layout)

```text
MIPS-Processor-Design/
├── Lab1_MIPS_Assembly/         # MIPS 組合語言演算法實作
├── Lab2_ALU/                   # 32-bit 邏輯閘級 ALU 設計
├── Lab3_Single_Cycle_CPU/      # 單週期處理器與資料路徑建立
├── Lab4_Pipelined_CPU/         # 五級管線化基礎架構
└── Lab5_Advanced_Pipeline/     # 具備 Forwarding & Hazard Detection 的終極版本
