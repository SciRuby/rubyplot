require 'mkmf'

$CFLAGS << ' -I/home/sameer/Downloads/gr/include '
$LDFLAGS << ' -L/home/sameer/Downloads/gr/lib -lGR -lm -Wl,-rpath,/home/sameer/Downloads/gr/lib '

create_makefile('grruby/grruby')
