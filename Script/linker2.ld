ENTRY( reset_handler )

MEMORY
{ 
  ICACHE (rwx) : ORIGIN = 0x00020000, LENGTH = 1K
  DCACHE (rx)  : ORIGIN = 0x00000000, LENGTH = 2K
}


SECTIONS
{
  __stack_size = DEFINED(__stack_size) ? __stack_size : 200;

  .text :
  {

    *(.text .text.*)
  } >ICACHE

  . = ALIGN(4);

  PROVIDE (__etext = .);
  PROVIDE (_etext = .);
  PROVIDE (etext = .);

  _sidata = .;
  .data : AT( _sidata )
  {
    _sdata = .;
    *(.data .data.*)
    *(.sdata .sdata.*)
    *(.rodata .rodata.*)  
    *(.srodata .srodata.*)
    *(.rdata) 

    . = ALIGN(4);
    _edata = .;
  } >DCACHE

  PROVIDE( _edata = . );
  PROVIDE( edata = . );
  PROVIDE( _fbss = . );
  PROVIDE( __bss_start = . );

  .bss :
  {
    _sbss = .;
    *(.sbss*)
    *(.bss .bss.*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
  } >DCACHE

  . = ALIGN(8);
  PROVIDE( _end = . );
  PROVIDE( end = . );

  .stack ORIGIN(DCACHE) + LENGTH(DCACHE) - __stack_size :
  {
    PROVIDE( _heap_end = . ); 
    . = __stack_size;  
    PROVIDE( _sp = . ); 
  } >DCACHE
}