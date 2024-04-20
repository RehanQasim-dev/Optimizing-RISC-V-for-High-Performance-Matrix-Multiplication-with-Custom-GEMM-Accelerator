 # Reset handler and interrupt vector table entries
.global reset_handler
reset_handler:
# Load the initial stack pointer value.
lui sp, %hi(_sp)   # Load upper 20 bits of _sp
addi sp, sp, %lo(_sp)  # Add lower 12 bits of _sp
# li sp,0x210

# Call user 'main(0,0)' (.data/.bss sections initialized there)
  li   a0, 0
  li   a1, 0
  li    a2, 134
  j verilate
