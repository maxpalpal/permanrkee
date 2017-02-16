
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include <gtkextext.h>
#include "GtkExTextDefs.h"

//typedef Lines *Gtk__ExTextLines;
//PerlGtkExTextDeclareFunc(SV *, newSVGtkExTextLines)(Lines * value);
//PerlGtkExTextDeclareFunc(Lines *, SvGtkExTextLines)(SV * value);
#define sp (*_sp)

static int fixup_extext_u(SV ** * _sp, int match, GtkObject * object, char * signame, int nparams, GtkArg * args, GtkType return_type)
{
    	dTHR;
    	if (match == 0) {
                XPUSHs(sv_2mortal(newSVGtkExTextProperty((GtkExTextProperty*)GTK_VALUE_POINTER(args[0]))));
		XPUSHs(sv_2mortal(newSViv(GTK_VALUE_INT(args[1]))));
		XPUSHs(sv_2mortal(newSViv(GTK_VALUE_INT(args[2]))));
	
        } else if (match == 1) {
                XPUSHs(sv_2mortal(newSVGtkExTextProperty((GtkExTextProperty*)GTK_VALUE_POINTER(args[0]))));
		XPUSHs(sv_2mortal(newSViv(GTK_VALUE_INT(args[1]))));
		XPUSHs(sv_2mortal(newSViv(GTK_VALUE_INT(args[2]))));
        } else if (match == 2) {
                XPUSHs(sv_2mortal(newSVGtkExTextProperty((GtkExTextProperty*)GTK_VALUE_POINTER(args[0]))));
        } else if (match == 3) {
                XPUSHs(sv_2mortal(newSVGtkExTextProperty((GtkExTextProperty*)GTK_VALUE_POINTER(args[0]))));
        } else if (match == 4) {
		XPUSHs(sv_2mortal(newSViv(GTK_VALUE_INT(args[0]))));
		XPUSHs(sv_2mortal(newSViv(GTK_VALUE_INT(args[1]))));
	} else if (match == 5) {
		XPUSHs(sv_2mortal(newSViv(GTK_VALUE_INT(args[0]))));
	} else if (match == 6) {
		XPUSHs(sv_2mortal(newSViv(GTK_VALUE_INT(args[0]))));
	}
	return 1;
}
#undef sp

MODULE = Gtk::ExText		PACKAGE = Gtk::ExText		PREFIX = gtk_extext_

void
init(Class)
	SV *	Class
	CODE:
	{
		static char *names[] = {"property_text_insert",
					"property_text_remove",
					"property_destroy",
					"undo_changed",
					"property_mark",
					"line_insert",
					"line_remove",
					NULL};
		static int did_it = 0;
		if (did_it)
			return;
		did_it = 1;
		GtkExText_InstallTypedefs();
		GtkExText_InstallObjects();
                AddSignalHelperParts(gtk_extext_get_type(), names, fixup_extext_u, 0);	
	}

Gtk::ExText_Sink
new(Class,...)
	SV * Class
	CODE:
	{
		GtkWidget * g;
		int * attr = malloc(sizeof(int)*(items));
		int i;
		for (i=0; i < items -1; ++i)
			attr[i] = SvIV(ST(i+1));
		attr[i] = 0;
		g = gtk_extext_new(attr);
		RETVAL = g ? GTK_EXTEXT(g) : 0;
		free(attr);
	}
	OUTPUT:
	RETVAL

Gtk::ExText_Sink
share_new(Class, share, ...)
	SV * Class
	Gtk::ExText	share
	CODE:
	{
		int * attr = malloc(sizeof(int)*(items-1));
		int i;
		for (i=0; i < items -2; ++i)
			attr[i] = SvIV(ST(i+2));
		attr[i] = 0;
		RETVAL = GTK_EXTEXT(gtk_extext_share_new(attr, share));
		free(attr);
	}
	OUTPUT:
	RETVAL

void
gtk_extext_set_editable(text, editable)
	Gtk::ExText	text
	int	editable

void
gtk_extext_set_adjustments(text, hadjustment, vadjustment)
	Gtk::ExText	text
	Gtk::Adjustment	hadjustment
	Gtk::Adjustment	vadjustment

void
gtk_extext_set_point(text, index)
	Gtk::ExText	text
	int	index

int
gtk_extext_get_point(text)
	Gtk::ExText	text

int
gtk_extext_get_length(text)
	Gtk::ExText	text

int
gtk_extext_length(text)
	Gtk::ExText	text
	CODE:
	{
		RETVAL = gtk_extext_get_length(text);
	}
	OUTPUT:
	RETVAL


void
gtk_extext_freeze(text)
	Gtk::ExText	text

void
gtk_extext_thaw(text)
	Gtk::ExText	text

void
gtk_extext_backward_delete(text, nchars)
	Gtk::ExText	text
	int	nchars

void
gtk_extext_forward_delete(text, nchars)
	Gtk::ExText	text
	int	nchars

void
gtk_extext_insert(text, string,len=0)
	Gtk::ExText	text
	char *	string
	int len
	CODE:
	{
		STRLEN len;
		if (items<3) len = strlen(string);
		gtk_extext_insert(text, string, len);
	}

void 
gtk_extext_insert_with_style(text,chars,stylekey, userdata=0)
	Gtk::ExText	text
	char *	chars
	char *	stylekey
	void *	userdata
	CODE:
	gtk_extext_insert_with_style(text,chars,strlen(chars),stylekey,userdata);	



#if GTK_HVER >= 0x010200

void
gtk_extext_set_line_wrap (text, line_wrap)
	Gtk::ExText	text
	gint	line_wrap

#endif

Gtk::Adjustment
hadj(text)
	Gtk::ExText	text
	CODE:
	RETVAL = text->hadj;
	OUTPUT:
	RETVAL

Gtk::Adjustment
vadj(text)
	Gtk::ExText	text
	CODE:
	RETVAL = text->vadj;
	OUTPUT:
	RETVAL

int 
gtk_extext_set_line(text,pos)
	Gtk::ExText	text
	int	pos

gint
gtk_extext_get_line(text)
	Gtk::ExText	text

void 
gtk_extext_set_line_userdata(text,line,userdata)
	Gtk::ExText	text
	int	line
	void * userdata

void 
gtk_extext_set_word_wrap(text,set)
	Gtk::ExText	text
	bool	set

void 
gtk_extext_set_line_max_chars(text,col)
	Gtk::ExText	text
	int	col

int 
gtk_extext_set_column(text,col)
	Gtk::ExText	text
	int	col

int 
gtk_extext_get_column(text)
	Gtk::ExText	text

bool
gtk_extext_get_editable(text)
	Gtk::ExText	text

bool 
gtk_extext_search(text,search,pos,iscase,forward,m)
	Gtk::ExText	text
	char *	search
	int	pos
	bool iscase
	bool forward
	Gtk::ExText::Match	m


void 
gtk_extext_undo_set_max(text,max)
	Gtk::ExText	text
	int	max

gboolean 
gtk_extext_undo_is_empty(text)
	Gtk::ExText	text

gboolean 
gtk_extext_redo_is_empty(text)
	Gtk::ExText	text

void 
gtk_extext_undo_clear_all(text)
	Gtk::ExText	text

void 
gtk_extext_undo(text)
	Gtk::ExText	text

void 
gtk_extext_redo(text)
	Gtk::ExText	text

Gtk::ExText::Style
gtk_extext_style_insert(text,stylename,font,fg,bg)
	Gtk::ExText	text
	char *	stylename
	Gtk::Gdk::Font font
	Gtk::Gdk::Color	fg
	Gtk::Gdk::Color	bg

Gtk::ExText::Style 
gtk_extext_style_get(text,key)
	Gtk::ExText	text
	char *	key

void 
gtk_extext_style_remove(textclass,key)
	Gtk::ExText	textclass
	char *	key


Gtk::ExText::Property
gtk_extext_property_insert(text,key,startpos, endpos,data,typ,prev=NULL)
	Gtk::ExText	text
	char *	key
	int 	startpos
	int	endpos
	int	data
	int	typ
	Gtk::ExText::Property	prev


Gtk::ExText::Property
gtk_extext_property_remove(text,remove)
	Gtk::ExText	text
	Gtk::ExText::Property	remove


Gtk::ExText::Property 
gtk_extext_property_get_at_pos(text,pos,cur)
	Gtk::ExText	text
	int	pos
	Gtk::ExText::Property_OrNULL cur
	CODE:
	{
		gtk_extext_property_get_at_pos(text,pos,cur);
		RETVAL = cur;
	}
	OUTPUT:
	RETVAL	

Gtk::ExText::LineData
gtk_extext_get_line_data(text,line)
	Gtk::ExText text
	gint line
	CODE:
	{
	    GtkExTextLineData lines;
	    
	    RETVAL = gtk_extext_get_line_data(text,line,&lines);
	}
	OUTPUT:
	RETVAL


Gtk::ExText::LineData 
gtk_extext_get_first_visible_line(text)
	Gtk::ExText text


Gtk::ExText::LineData 
gtk_extext_get_line_by_char_pos(text,pos)
	Gtk::ExText text
	gint pos


Gtk::ExText::LineData 
gtk_extext_get_line_by_offset(text,y)
	Gtk::ExText text
	gint y
	CODE:
	{
	    gint offset;

	    RETVAL=gtk_extext_get_line_by_offset(text,y,&offset);
	}
	

gint 
gtk_extext_get_column_by_offset(text,linedataptr,x)
	Gtk::ExText text
	Gtk::ExText::LineData linedataptr
	int x
	CODE:
	{
	    gint newx;

	    RETVAL=gtk_extext_get_column_by_offset(text,linedataptr,x,&newx);
	}



Gtk::ExText::Property
gtk_extext_property_move_all(text,pos,diff,cur)
	Gtk::ExText	text
	int	pos
	int	diff
	Gtk::ExText::Property_OrNULL	cur

Gtk::ExText::Property 
gtk_extext_property_remove_all(text,start, end,cur)
	Gtk::ExText	text
	int	start
	int	end
	Gtk::ExText::Property_OrNULL cur

Gtk::ExText::Property 
gtk_extext_property_nearest_forward(text,pos,cur=0)
	Gtk::ExText	text
	int	pos
	Gtk::ExText::Property cur

Gtk::ExText::Property 
gtk_extext_property_nearest_backward(text,pos,cur=0)
	Gtk::ExText	text
	int	pos
	Gtk::ExText::Property	cur

Gtk::ExText::Property 
gtk_extext_property_get_current(text)
	Gtk::ExText	text


void
gtk_extext_get_current_word(text,start=0,end=0)
	Gtk::ExText	text
	gint start
	gint end
	PREINIT:
	gint *new_start,*new_end;
	PPCODE:
	{
	    new_start = &start;
	    new_end = &end;
	    if (gtk_extext_get_current_word(text,new_start,new_end)) {
		EXTEND(SP,2);
		PUSHs(sv_2mortal(newSViv(start)));
		PUSHs(sv_2mortal(newSViv(end)));
	    }
	    
	}



void
gtk_extext_get_next_word(text,start=0,end=0)
	Gtk::ExText	text
	gint start
	gint end
	PREINIT:
	gint *new_start,*new_end;
	PPCODE:
	{
	    new_start = &start;
	    new_end = &end;
	    if (gtk_extext_get_next_word(text,new_start,new_end)) {
		EXTEND(SP,2);
		PUSHs(sv_2mortal(newSViv(start)));
		PUSHs(sv_2mortal(newSViv(end)));
	    }
	}


void
gtk_extext_get_previous_word(text,start=0,end=0)
	Gtk::ExText	text
	gint start
	gint end
	PREINIT:
	gint *new_start,*new_end;
	PPCODE:
	{
	    new_start = &start;
	    new_end = &end;
	    if (gtk_extext_get_previous_word(text,new_start,new_end)) {
		EXTEND(SP,2);
		PUSHs(sv_2mortal(newSViv(start)));
		PUSHs(sv_2mortal(newSViv(end)));
	    }
	}



MODULE = Gtk::ExText::Style		PACKAGE = Gtk::ExText::Style		PREFIX = gtk_extext_

Gtk::Gdk::Font
font(self,new_font=0)
    Gtk::ExText::Style	self
    Gtk::Gdk::Font  new_font
    CODE:
    {
	RETVAL = self->font;
	if (items>1) self->font = new_font;
    }
    OUTPUT:
    RETVAL

Gtk::Gdk::Color
fg_color(self,new_color=0)
    Gtk::ExText::Style	self
    Gtk::Gdk::Color new_color
    CODE:
    {
	RETVAL = &self->fg_color;
	if (items>1) self->fg_color = *new_color;
    }
    OUTPUT:
    RETVAL


Gtk::Gdk::Color
bg_color(self, new_color=0)
    Gtk::ExText::Style	self
    Gtk::Gdk::Color new_color
    CODE:
    {
	RETVAL = &self->bg_color;
	if (items>1) self->bg_color = *new_color;
    }
    OUTPUT:
    RETVAL

char *
key(self,new_key=0)
    Gtk::ExText::Style	self
    char *  new_key
    CODE:
    {
	RETVAL = self->key;
	if (items>1)
	    strncpy(self->key,new_key,32);
    }
    OUTPUT:
    RETVAL

int
flags(self,new_flags=0)
    Gtk::ExText::Style	self
    int new_flags
    CODE:
    {
	RETVAL = self->flags;
	if (items>1) self->flags = new_flags;
    }
    OUTPUT:
    RETVAL

int
rbearing(self,new_v=0)
    Gtk::ExText::Style	self
    int	new_v
    CODE:
    {
	RETVAL = self->rbearing;
	if (items>1) self->rbearing = new_v;
    }
    OUTPUT:
    RETVAL

int
lbearing(self,new_v=0)
    Gtk::ExText::Style	self
    int	new_v
    CODE:
    {
	RETVAL = self->lbearing;
	if (items>1) self->lbearing = new_v;
    }
    OUTPUT:
    RETVAL

int
ascent(self,new_v=0)
    Gtk::ExText::Style	self
    int	new_v
    CODE:
    {
	RETVAL = self->ascent;
	if (items>1) self->ascent = new_v;
    }
    OUTPUT:
    RETVAL

int
descent(self,new_v=0)
    Gtk::ExText::Style	self
    int new_v
    CODE:
    {
	RETVAL = self->descent;
	if (items>1) self->descent = new_v;
    }
    OUTPUT:
    RETVAL



MODULE = Gtk::ExText::Property		PACKAGE = Gtk::ExText::Property		PREFIX = gtk_extext_

int
startpos(self)
    Gtk::ExText::Property self
    CODE:
    {
	RETVAL = self->startpos;
    }
    OUTPUT:
    RETVAL

int
endpos(self)
    Gtk::ExText::Property self
    int new_v
    CODE:
    {
	RETVAL = self->endpos;
    }
    OUTPUT:
    RETVAL

Gtk::ExText::Style
style(self,new_style=0)
    Gtk::ExText::Property	self
    Gtk::ExText::Style	new_style
    CODE:
    {
	RETVAL = self->style;
	if (items>1) self->style = new_style;
    }
    OUTPUT:
    RETVAL

int
user_data(self)
    Gtk::ExText::Property	self
    CODE:
    {
	RETVAL = (int)self->user_data;
    }
    OUTPUT:
    RETVAL

Gtk::ExText::Property
next(self)
    Gtk::ExText::Property self
    CODE:
    RETVAL=(self->next==1)? NULL:self->next;
    OUTPUT:
    RETVAL

Gtk::ExText::Property
prev(self)
    Gtk::ExText::Property self
    CODE:
    RETVAL=self->prev;
    OUTPUT:
    RETVAL




MODULE = Gtk::ExText::LineData		PACKAGE = Gtk::ExText::LineData		PREFIX = gtk_extext_

gint
startpos(self)
    Gtk::ExText::LineData	self
    CODE:
    RETVAL = self->startpos;
    OUTPUT:
    RETVAL


gint
endpos(self)
    Gtk::ExText::LineData	self
    CODE:
    RETVAL = self->endpos;
    OUTPUT:
    RETVAL

gint
line_number(self)
    Gtk::ExText::LineData	self
    CODE:
    RETVAL = self->line_number;
    OUTPUT:
    RETVAL

Gtk::ExText::Property
property_first(self)
    Gtk::ExText::LineData	self
    CODE:
    RETVAL = self->property_first;
    OUTPUT:
    RETVAL

SV *
lines(self)
    Gtk::ExText::LineData self
    CODE:
    {
	AV *a = newAV();
	Lines *l = self->lineptr;
	while(l) {
	    AV *i = newAV();
	    av_push(i,newSViv(l->length));
	    av_push(i,newSViv(l->flags));
	    av_push(i,newSViv(l->width));
	    av_push(i,newSViv(l->height));
	    av_push(i,newSViv((int)l->user_data));
	    av_push(a,newRV_inc((SV*)i));
	    l = l->next;
	}
	RETVAL = newRV_inc((SV *) a);
    }
    OUTPUT:
    RETVAL


INCLUDE: ../build/boxed.xsh

INCLUDE: ../build/objects.xsh

INCLUDE: ../build/extension.xsh

