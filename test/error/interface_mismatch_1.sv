// pattern: port intf has type Interface1, but the binding intf2 has type Interface2
`include "interface_mismatch.svh"
module Module(intf);
    Interface1 intf;
endmodule
module top;
    Interface2 intf2();
    Module m(intf2);
endmodule
