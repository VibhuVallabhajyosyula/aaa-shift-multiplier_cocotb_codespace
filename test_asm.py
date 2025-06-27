
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import random

@cocotb.test()
async def test_asm_module(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    for _ in range(10):
        A = random.randint(0, 2**5 - 1)
        B = random.randint(0, 2**6 - 1)
        dut.A.value = A
        dut.B.value = B

        while not dut.done.value:
            await RisingEdge(dut.clk)

        result = dut.acc.value.signed_integer
        expected = A * B
        assert result == expected, f"FAIL: {A} * {B} = {result}, expected {expected}"

        dut.rst.value = 1
        await RisingEdge(dut.clk)
        dut.rst.value = 0
