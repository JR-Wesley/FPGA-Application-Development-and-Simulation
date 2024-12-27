
typedef logic [31 : 0] dw_t;
typedef logic [2 : 0] prt_t;
typedef logic [1 : 0] rsp_t;

interface axi4liteif_if #(
    parameter int unsigned AW = 32
) (
    input logic clk,
    input logic reset_n
);
  typedef logic [AW-1 : 0] aw_t;

  aw_t awaddr;
  prt_t awprot;
  logic awvalid = '0, awready;
  aw_t wdata;
  logic [3:0] wstrb;
  logic wvalid = '0, wready;
  rsp_t bresp;
  logic bvalid = '0, bready;
  aw_t araddr;
  prt_t arprot;
  logic arvalid = '0, arready;
  dw_t rdata;
  rsp_t rresp;
  logic rvalid = '0, rready;
  modport master(
      input clk, reset_n,
      output awaddr, awprot, awvalid,
      input awready,
      output wdata, wstrb, wvalid,
      input wready,
      input bresp, bvalid,
      output bready,
      output araddr, arprot, arvalid,
      input arready,
      input rdata, rresp, rvalid,
      output rready
  );
  modport slave(
      input clk, reset_n,
      input awaddr, awprot, awvalid,
      output awready,
      input wdata, wstrb, wvalid,
      output wready,
      output bresp, bvalid,
      input bready,
      input araddr, arprot, arvalid,
      output arready,
      output rdata, rresp, rvalid,
      input rready
  );
  //    task Write(
  //        input logic [AW-1:0] addr, logic [31:0] data,
  //        logic [31:0] strb = '1, prt_t prot = '0
  //    );
  //        @(posedge clk) begin
  //            awaddr = addr; awprot = prot; awvalid = '1;
  //            wdata = data; wstrb = strb; wvalid = '1;
  //            bready = '1;
  //        end
  //        fork
  //            wait(awready) @(posedge clk) awvalid = '0;
  //            wait(wready) @(posedge clk) wvalid = '0;
  //            wait(bvalid) @(posedge clk) bready = '0;
  //        join
  //    endtask
  //    task Read(
  //        input logic [AW-1:0] addr, output logic [31:0] data,
  //        input logic [3:0] prot = '0
  //    );
  //        @(posedge clk) begin
  //            araddr = addr; arprot = prot; arvalid = '1;
  //            rready = '1;
  //        end
  //        wait(arready) @(posedge clk) arvalid = '0;
  //        wait(rvalid) @(posedge clk) begin
  //            rready = '0;
  //            data = rdata;
  //        end
  //    endtask
endinterface
