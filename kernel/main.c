#ifdef __linux__
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

#ifndef __x86_64__
#error "You are not using a x86_64 compiler, this is required for this kernel"
#endif


void kmain(void) {
  // Yay kernel
}

void init() {
  kmain();
}
