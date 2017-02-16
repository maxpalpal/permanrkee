package Gtk::ExText::Highlight;
use Gtk::ExText;
@ISA=(Gtk::ExText);

sub new {
  my $class=shift;

  my $self = new Gtk::ExText;
  bless $self,$class;

  $self->{pattern} = [];
  $self->{style_count} = 0;
  $self->signal_connect("property_text_remove" => \&text_remove);
  $self->signal_connect("property_text_insert" => \&text_insert);
  return $self;
}

sub add_pattern {
  my $self = shift;
  my $pat = shift;
  my $style = shift;
  my $synentry;

  $synentry = [$pat,$style];
  push(@{$self->{pattern}},$synentry);
  if (defined($self->{all_pattern})) {
    $self->{all_pattern} .= "|(?:$pat)";
  } else {
    $self->{all_pattern} = "(?:$pat)";
  }
}


sub text_remove {
  my $self = shift;
  my $prop = shift;
  my $start =shift;
  my $end = shift;
  my $prop_end;

  if ($end > $self->length) {
    $self->property_remove_all($self->length,$end,$prop);
    $end = $self->length;
  }
  my $diff = $end-$start;
  $prop_end = $self->property_get_at_pos($end-1,$prop);
  
  if (!defined($prop_end)) {
    $prop_end = $prop;
    #$prop = $e->property_get_at_pos(0,$prop);
  }
  
  $start = $prop? $prop->startpos : $start;
  if (defined($prop_end) && $prop_end->endpos > $end) {
    if ($prop_end->endpos < $self->length) {
      $end = $prop_end->endpos;
    } else {
      $end = $self->length;
    }
  } else {
    my ($pstart,$pend) = $self->get_previous_word($start);
    $start = defined($pstart)? $pstart:0;
  }
    
  $self->property_remove_all($end,-$diff,$prop);
  $self->property_remove_all($start,$end,$prop);
  $self->check_syntax($start,$end);
  return 1;
}

sub text_insert {
  my $self = shift;
  my $prop = shift;
  my $start = shift;
  my $end = shift;

  my $diff = $end-$start;
  my $prop_end = $self->property_get_at_pos($end-1,$prop);
  if (defined($prop)) {
    $start = $prop->startpos;
  }
  $firstword = $start;
  if (!defined($prop)) {
    my ($pstart,$pend) = $self->get_previous_word($firstword);
    if (!defined($pstart)) {
      $start = 0;
    } elsif ($pstart < $start) {
      $start = $pstart;
    }
  }
  $lastword = $end;
  $s = $end;
  if (defined($prop_end) && $prop_end->endpos > $end) {
    $end = $prop_end->endpos;
  } elsif (!defined($prop_end)) {
    $end = $self->length;
  } else {
    my ($pstart,$pend) = $self->get_next_word($s,$lastword);
    if (!defined($pend)) {
      $end = $self->length;
    } elsif ($pend > $end) {
      $end = $pend;
    }
  }
  $self->property_move_all($end,$diff,$prop);
  $self->property_remove_all($start,$end,$prop);
  $self->check_syntax($start,$end);
  return 1;
}


sub check_syntax {
  my $text = shift;
  my $start = shift;
  my $end = shift;
  my $i = $start;
  my $lines;
  while(1) {
    $lines= $text->get_chars($start,$end);
    if ($lines =~ /($text->{all_pattern})/g) {
      my $item = $1;
      $start = $start + pos($lines);
      foreach(@{$text->{pattern}}) {
	my ($pat,$style) = @{$_};
	if ($item =~ /^($pat)/) {
	  $text->property_insert($style,$start-length($1),$start,0,0);
	  last;
	}
      }
      $lines = $newline;
    } else {
      last;
    }
  }
}

sub SetupStyle {
  my $self = shift;
  my $s = shift;
  my $style = "style$self->{style_count}";
  $self->{style_count}++;

  my $font = $self->style->font;
  my $fg = $self->style->fg(0);
  my $bg = $self->style->bg(0);
  
  while(1) {
    if ($s =~ /\Gfg:(\w+)/gc) {
      $fg = Gtk::Gdk::Color->parse_color($1);
    } elsif ($s =~/\Gbg:(\w+)/gc) {
      $bg = Gtk::Gdk::Color->parse_color($1);
    } else {
      last;
    }
  }

  $self->style_insert($style,$font,$fg,$bg);
  return $style;
}

sub ParseSyntaxScript {
  my $self = shift;
  my $script = shift;
  my @lines = split("\n",$script);

  foreach(@lines) {
    if (/([^ \t\n]+)\s+(.*)/) {
      my $s = $1;
      my $pat = $2;
      
      my $style = $self->SetupStyle($s);
      $self->add_pattern($pat,$style);
    }
  }
}
1;
