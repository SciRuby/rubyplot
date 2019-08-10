require 'mkmf'

GRDIR = ENV["GRDIR"] ||  '/usr/local/gr'

$CFLAGS << " -I#{GRDIR}/include "
$LDFLAGS << " -L#{GRDIR}/lib -lGR -lm -Wl,-rpath,#{GRDIR}/lib "

create_makefile('grruby/grruby')
