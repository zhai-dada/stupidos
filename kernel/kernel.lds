OUTPUT_FORMAT("elf64-x86-64","elf64-x86-64","elf64-x86-64")
OUTPUT_ARCH(i386:x86-64)
ENTRY(_start)
SECTIONS
{

	. = 0xffff800000000000 + 0x100000;
	.text :
	{
		_text = .;
		*(.text)
		_etext = .;
	}
	. = ALIGN(8);
	.data :
	{
		_data = .;
		*(.data)
		_edata = .;
	}
	. = ALIGN(8);
	.rodata : 
	{
		_rodata = .;	
		*(.rodata)
		_erodata = .;
	}
	. = ALIGN(32768);
	.data.inittask_stack :
	{
		*(.data.inittask_stack)
	}
	.bss :
	{
		_bss = .;
		*(.bss)
		_ebss = .;
	}

	_end = .;
}