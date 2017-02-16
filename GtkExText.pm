package Gtk::ExText;

require Gtk;
require Exporter;
require DynaLoader;
require AutoLoader;

use Carp;
use Gtk::ExText::Highlight;

$VERSION = '0.7000';

@ISA = qw(Exporter DynaLoader Gtk::Editable);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
        
);
# Other items we are prepared to export if requested
@EXPORT_OK = qw(
);

bootstrap Gtk::ExText $VERSION;

sub dl_load_flags {0x01}

#require Gtk::ExText::Types;

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
