use ExtUtils::MakeMaker;
use File::Basename;
use blib '..';
use Gtk::Install::Files;
use Cwd;
require '../Depends.pm';
import ExtUtils::Depends;

require '../tools/gendefs.pl';

mkdir('build', 0777);

$pm = {};

$inc = '-I/usr/local/include -DWITH_REGEX ' . `gtk-config --cflags`;
chomp($inc);
$libs = "-L/usr/local/lib -lgtkextext " . `gtk-config --libs`;
chomp($libs);

@typemaps = @Gtk::Install::Files::typemaps;
$typemaps = [cwd() . '/pkg.typemap', cwd().'/build/GtkExTextTypemap'];
@headers = ( 'build/GtkExTextDefs.h', 'build/PerlGtkExTextInt.h');

#add_boot ('Gtk::ExText');

ExtUtils::Depends::save_config('Gtk::ExText', 'build/IFiles.pm', $inc, $libs, 
	$typemaps, [keys %defs], [@defines], [@headers], $pm);

foreach (@typemaps) {
	print "Add typemap: $Gtk::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Install::Files::CORE . '/'. $_);
}

push(@defines, @Gtk::Install::Files::defines);
push(@defines, '-I../build', '-Ibuild', '-I.', '-I../Gtk');

$pm->{'GtkExText.pm'} = '$(INST_ARCHLIBDIR)/ExText.pm';
$pm->{'GtkExTextHighlight.pm'} = '$(INST_ARCHLIBDIR)/ExText/Highlight.pm';
$pm->{'build/GtkExTextTypes.pm'} = '$(INST_ARCHLIBDIR)/ExText/Types.pm';

add_c ( 'build/GtkExTextDefs.c');
add_defs ('pkg.defs');
add_headers (qw( <gtkextext.h> ));
#add_raw_xs('xs/HighLight.xs');
add_headers('<highlight.h>');
@a = (	'-f', 'GtkExText', 
		'-p', 'GtkExTextHighlight=Gtk::ExText::Highlight',
		'-p', 'GtkExText=Gtk::ExText',
		'-m', 'Gtk::ExText');

add_headers (keys %Gtk::Install::files::headers);
# FIXME: use defs and headers from ExtUtils::Depends....
%defs = %ExtUtils::Depends::defs;
%headers = %ExtUtils::Depends::headers;
foreach (sort {$defs{$a} <=> $defs{$b}} keys %defs) {
	push @a, '-d', $_;
}
foreach (sort {$headers{$a} <=> $headers{$b}} keys %headers) {
	push @a, '-i', $_;
}

add_raw_xs(gendefs::gendefs(@a));
($xfiles, $object, $ldfrom) = setup_xs();

$depend = { 'build/GtkExTextDefs.c' => 'build/GtkExTextDefs.h build/PerlGtkExTextInt.h' };

foreach (qw( build/GtkExTextDefs.h build/PerlGtkExTextInt.h)) {
	$pm->{$_} = '$(INST_ARCHLIBDIR)/ExText/Install/'. basename($_);
}

write_ext();

@clean = qw(
	build/IFiles.pm build/GtkExTextDefs.c build/GtkExTextDefs.h 
	build/GtkExTextDefs.o build/GtkExTextTypemap build/GtkExTextTypes.pm 
	build/PerlGtkExTextExt.c build/PerlGtkExTextExt.h build/PerlGtkExTextInt.h 
	build/boxed.xsh build/extension.xsh build/objects.xsh
	build/perl-gtkglarea-ds.pod  build/perl-gtkglarea-ref.pod
);
push(@clean, @ExtUtils::Depends::clean);

# documentation
gendefs::gen_doc('gtkglarea');
system("../tools/gendoc.pl", "-t", 'gtkglarea', keys %ExtUtils::Depends::xs);

WriteMakefile(
	'NAME'      => 'Gtk::ExText',
	'VERSION_FROM'	=> 'GtkExText.pm',
	'PM' => $pm,
	'TYPEMAPS' => $typemaps,
	'XS' => $xfiles,
	'XSOPT' => '-noversioncheck',
	'DEFINE'    => join(' ',@defines),
	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
	'INC' => $inc,
	'LIBS' => [$libs],
	'OBJECT' => $object,
	'clean' => {FILES => join(' ', @clean) },
	#'LDFROM' => $ldfrom,
	'depend' => $depend,
);

sub MY::postamble {

'
Makefile: ' . join(' ',
	sort {$defs{$a} <=> $defs{$b}} keys %defs,
	<*/pkg*.pl>
	) . '

build/PerlGtkExTextExt.h build/PerlGtkExTextExt.c build/PerlGtkExTextInt.h: build/GtkExTextDefs.h ../tools/genext.pl
	$(PERL) ../tools/genext.pl GtkExText </dev/null

';



}

sub MY::c_o {
	package MY; # so that "SUPER" works right
	my $inherited = shift->SUPER::c_o(@_);
	$inherited =~ s/CCCMD.*$/$&\n\t\@if test -f `basename \$*.o` -a "`basename \$*.o`" != "\$*.o"; then mv `basename \$*.o` \$*.o; fi/m;
    $inherited;
}

sub MY::const_config
{
	package MY;
	my $self = shift;
	my $flags = $self->{'CCCDLFLAGS'};
	$flags =~ s/(-[fK]?\s*)pic\b/${1}PIC/;
	$self->{'CCCDLFLAGS'} = $flags;
	return $self->SUPER::const_config;
}

	
