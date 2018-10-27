require 'mkmf'

$CFLAGS << ' -I/usr/local/gr/include '
$LDFLAGS << ' -L/usr/local/gr/lib -lGR -lm -Wl,-rpath,/usr/local/gr/lib '

create_makefile('grruby/grruby')
