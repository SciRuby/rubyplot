#include <ruby.h>
#include <gr.h>

double* rb_ar_2_dbl_ar(VALUE ar) {
  long ar_size=RARRAY_LEN(ar);
  double *arc = (double *)malloc(ar_size * sizeof(double));
  int i;
  for (i=0; i < ar_size; i++){
    arc[i] = NUM2DBL(rb_ary_entry(ar, i));
  }
  return arc; 
}

int* rb_ar_2_int_ar(VALUE ar){
  long ar_size=RARRAY_LEN(ar);
  int *arc = (int *)malloc(ar_size * sizeof(int));
  int i;
  for (i=0; i < ar_size; i++){
    arc[i] = NUM2INT(rb_ary_entry(ar, i));
  }
  return arc;
}

static VALUE opengks(VALUE self){
  gr_opengks();
  return Qtrue;
}

static VALUE closegks(VALUE self){
  gr_closegks();
  return Qtrue;
}

static VALUE inqdspsize(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d){
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b); 
  int *cc = rb_ar_2_int_ar(c);
  int *dc = rb_ar_2_int_ar(d);
  gr_inqdspsize(ac,bc,cc,dc);
  
  return Qtrue;
}

/*
 * call-seq:
 *   Rubyplot::GR.openws()
 *
 * Open a graphical workstation.
 *
 * *Parameters:**
 *
 * `workstation_id` :
 * A workstation identifier.
 * `connection` :
 * A connection identifier.
 * `workstation_type` :
 * The desired workstation type.
 *
 * Available workstation types:
 *
 * +-------------+------------------------------------------------------+
 * |            5|Workstation Independent Segment Storage               |
 * +-------------+------------------------------------------------------+
 * |         7, 8|Computer Graphics Metafile (CGM binary, clear text)   |
 * +-------------+------------------------------------------------------+
 * |           41|Windows GDI                                           |
 * +-------------+------------------------------------------------------+
 * |           51|Mac Quickdraw                                         |
 * +-------------+------------------------------------------------------+
 * |      61 - 64|PostScript (b/w, color)                               |
 * +-------------+------------------------------------------------------+
 * |     101, 102|Portable Document Format (plain, compressed)          |
 * +-------------+------------------------------------------------------+
 * |    210 - 213|X Windows                                             |
 * +-------------+------------------------------------------------------+
 * |          214|Sun Raster file (RF)                                  |
 * +-------------+------------------------------------------------------+
 * |     215, 218|Graphics Interchange Format (GIF87, GIF89)            |
 * +-------------+------------------------------------------------------+
 * |          216|Motif User Interface Language (UIL)                   |
 * +-------------+------------------------------------------------------+
 * |          320|Windows Bitmap (BMP)                                  |
 * +-------------+------------------------------------------------------+
 * |          321|JPEG image file                                       |
 * +-------------+------------------------------------------------------+
 * |          322|Portable Network Graphics file (PNG)                  |
 * +-------------+------------------------------------------------------+
 * |          323|Tagged Image File Format (TIFF)                       |
 * +-------------+------------------------------------------------------+
 * |          370|Xfig vector graphics file                             |
 * +-------------+------------------------------------------------------+
 * |          371|Gtk                                                   |
 * +-------------+------------------------------------------------------+
 * |          380|wxWidgets                                             |
 * +-------------+------------------------------------------------------+
 * |          381|Qt4                                                   |
 * +-------------+------------------------------------------------------+
 * |          382|Scaleable Vector Graphics (SVG)                       |
 * +-------------+------------------------------------------------------+
 * |          390|Windows Metafile                                      |
 * +-------------+------------------------------------------------------+
 * |          400|Quartz                                                |
 * +-------------+------------------------------------------------------+
 * |          410|Socket driver                                         |
 * +-------------+------------------------------------------------------+
 * |          415|0MQ driver                                            |
 * +-------------+------------------------------------------------------+
 * |          420|OpenGL                                                |
 * +-------------+------------------------------------------------------+
 * |          430|HTML5 Canvas                                          |
 * +-------------+------------------------------------------------------+
 * 
 */
static VALUE openws(VALUE self,VALUE ws_id,VALUE connection, VALUE type) {
  int ws_idc = NUM2INT(ws_id);
  char *connectionc = StringValueCStr(connection);
  int typec = NUM2INT(type);
  
  gr_openws(ws_idc,connectionc,typec);
  return Qtrue;
}

static VALUE closews(VALUE self,VALUE ws_id){
  int ws_idc=NUM2INT(ws_id);
  gr_closews(ws_idc);
  return Qtrue;
}

static VALUE activatews(VALUE self,VALUE ws_id){
  int ws_idc=NUM2INT(ws_id);
  gr_activatews(ws_idc);
  return Qtrue;
}

static VALUE deactivatews(VALUE self,VALUE ws_id){
  int ws_idc=NUM2INT(ws_id);
  gr_deactivatews(ws_idc);
  return Qtrue;
}

static VALUE clearws(VALUE self){
  gr_clearws();
  return Qtrue;
}

static VALUE updatews(VALUE self){
  gr_updatews();
  return Qtrue;
}

/**
 *
 * call-seq:
 *   Rubyplot::GR.polyline(x,y) -> true
 *
 * Draw a polyline using the current line attributes, starting from the
 * first data point and ending at the last data point.
 * 
 * Parameters:
 * 
 * `x` :
 * A list containing the X coordinates
 * `y` :
 * A list containing the Y coordinates
 * 
 * The values for `x` and `y` are in world coordinates. The attributes that
 * control the appearance of a polyline are linetype, linewidth and color
 * index.
*/
static VALUE polyline(VALUE self,VALUE x, VALUE y) {
  int x_size = RARRAY_LEN(x);
  int y_size = RARRAY_LEN(y);
  int size = (x_size <= y_size)?x_size:y_size;
  double *xc = rb_ar_2_dbl_ar(x);
  double *yc = rb_ar_2_dbl_ar(y); 
  gr_polyline(size,xc,yc);
  
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.polymarker(x, y) -> true
 *
 * Draw marker symbols centered at the given data points.
 * 
 * **Parameters:**
 * 
 * `x` :
 * A list containing the X coordinates
 * `y` :
 * A list containing the Y coordinates
 * 
 * The values for `x` and `y` are in world coordinates. The attributes that
 * control the appearance of a polymarker are marker type, marker size
 *   scale factor and color index.
 */
static VALUE polymarker(VALUE self,VALUE x, VALUE y) {
  int x_size = RARRAY_LEN(x);
  int y_size = RARRAY_LEN(y);
  int size = (x_size <= y_size) ? x_size : y_size;
  double *xc = rb_ar_2_dbl_ar(x);
  double *yc = rb_ar_2_dbl_ar(y);
  
  gr_polymarker(size,xc,yc);
  return Qtrue;
}

/**
 *    call-seq:
 *       Rubyplot::GR.text(x, y, text) -> true
 *
 *    Draw a text at position `x`, `y` using the current text attributes.
 *
 *    **Parameters:**
 *
 *    `x` :
 *        The X coordinate of starting position of the text string
 *    `y` :
 *        The Y coordinate of starting position of the text string
 *    `string` :
 *        The text to be drawn
 *
 *    The values for `x` and `y` are in normalized device coordinates.
 *    The attributes that control the appearance of text are text font and precision,
 *    character expansion factor, character spacing, text color index, character
 *    height, character up vector, text path and text alignment.
 */
static VALUE text(VALUE self,VALUE x, VALUE y, VALUE string) {
  double xc = NUM2DBL(x);
  double yc = NUM2DBL(y);
  char *stringc=StringValueCStr(string);
  gr_text(xc,yc,stringc);
  
  return Qtrue;
}

static VALUE inqtext(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d,VALUE e) {
  double ac = NUM2DBL(a);
  double bc = NUM2DBL(b);
  char *cc = StringValueCStr(c);
  double *dc = rb_ar_2_dbl_ar(d);
  double *ec = rb_ar_2_dbl_ar(e);
  gr_inqtext(ac,bc,cc,dc,ec);
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.fillarea([1,2,3], [1,2,3]) -> true
 *  
 * Allows you to specify a polygonal shape of an area to be filled.
 * 
 * **Parameters:**
 * 
 * `x` :
 * A list containing the X coordinates
 * `y` :
 * A list containing the Y coordinates
 * 
 * The attributes that control the appearance of fill areas are fill area interior
 * style, fill area style index and fill area color index.
 */
static VALUE fillarea(VALUE self,VALUE x, VALUE y){
  int x_size = RARRAY_LEN(x);
  int y_size = RARRAY_LEN(y);
  int size = (x_size <= y_size) ? x_size : y_size;
  double *xc = rb_ar_2_dbl_ar(x);
  double *yc = rb_ar_2_dbl_ar(y); 
  gr_fillarea(size,xc,yc);
  
  return Qtrue;
}

static VALUE cellarray(VALUE self,VALUE xmin,VALUE xmax,VALUE ymin,VALUE ymax,
                       VALUE dimx,VALUE dimy,VALUE scol,VALUE srow,VALUE ncol,
                       VALUE nrow,VALUE color) {
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  int dimxc = NUM2INT(dimx);
  int dimyc = NUM2INT(dimy);
  int scolc = NUM2INT(scol);
  int srowc = NUM2INT(srow);
  int ncolc = NUM2INT(ncol);
  int nrowc = NUM2INT(nrow);
  int *colorc = rb_ar_2_int_ar(color);
  gr_cellarray(xminc,xmaxc,yminc,ymaxc,dimxc,dimyc,scolc,srowc,ncolc,nrowc,colorc);
  return Qtrue;
}

static VALUE gdp(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d,VALUE e,VALUE f){
  int ac = NUM2INT(a);
  double *bc = rb_ar_2_dbl_ar(b);
  double *cc = rb_ar_2_dbl_ar(c);
  int dc = NUM2INT(d);
  int ec = NUM2INT(e);
  int *fc = rb_ar_2_int_ar(f);
  gr_gdp(ac,bc,cc,dc,ec,fc);
  return Qtrue;
}

static VALUE spline(VALUE self,VALUE n,VALUE px,VALUE py,VALUE m,VALUE method){
  int nc = NUM2INT(n);
  double *pxc = rb_ar_2_dbl_ar(px);
  double *pyc = rb_ar_2_dbl_ar(py);
  int mc = NUM2INT(m);
  int methodc = NUM2INT(method);
  gr_spline(nc,pxc,pyc,mc,methodc);
  return Qtrue;
}

static VALUE gridit(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d,VALUE e,VALUE f,
                    VALUE g,VALUE h,VALUE i) {
  int ac = NUM2INT(a);
  double *bc = rb_ar_2_dbl_ar(b);
  double *cc = rb_ar_2_dbl_ar(c);
  double *dc = rb_ar_2_dbl_ar(d);
  int ec = NUM2INT(e);
  int fc = NUM2INT(f);
  double *gc = rb_ar_2_dbl_ar(g);
  double *hc = rb_ar_2_dbl_ar(h);
  double *ic = rb_ar_2_dbl_ar(i);
  gr_gridit(ac,bc,cc,dc,ec,fc,gc,hc,ic);
  return Qtrue;
  //Can be optimised for Ruby
}

/**
 * call-seq:
 *   Rubyplot::GR.setlinetype(type) -> true
 *
 * Specify the line style for polylines.
 * 
 * **Parameters:**
 * 
 * `style` :
 * The polyline line style
 * 
 * The available line types are:
 * 
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_SOLID             |   1|Solid line                                         |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_DASHED            |   2|Dashed line                                        |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_DOTTED            |   3|Dotted line                                        |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_DASHED_DOTTED     |   4|Dashed-dotted line                                 |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_DASH_2_DOT        |  -1|Sequence of one dash followed by two dots          |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_DASH_3_DOT        |  -2|Sequence of one dash followed by three dots        |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_LONG_DASH         |  -3|Sequence of long dashes                            |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_LONG_SHORT_DASH   |  -4|Sequence of a long dash followed by a short dash   |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_SPACED_DASH       |  -5|Sequence of dashes double spaced                   |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_SPACED_DOT        |  -6|Sequence of dots double spaced                     |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_DOUBLE_DOT        |  -7|Sequence of pairs of dots                          |
 * +---------------------------+----+---------------------------------------------------+
 * |LINETYPE_TRIPLE_DOT        |  -8|Sequence of groups of three dots                   |
 * +---------------------------+----+---------------------------------------------------+
 */
static VALUE setlinetype(VALUE self,VALUE type){
  int typec = NUM2INT(type);
  gr_setlinetype(typec);
  return Qtrue;
}

static VALUE inqlinetype(VALUE self,VALUE a){
  int *ac = rb_ar_2_int_ar(a);
  gr_inqlinetype(ac);
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.setlinewidth(1.3) -> true
 * Define the line width of subsequent polyline output primitives.
 * 
 * Parameters:
 * 
 * `width` :
 *   The polyline line width scale factor
 * 
 * The line width is calculated as the nominal line width generated
 * on the workstation multiplied by the line width scale factor.
 * This value is mapped by the workstation to the nearest available line width.
 * The default line width is 1.0, or 1 times the line width generated on the graphics device.
 */
static VALUE setlinewidth(VALUE self,VALUE width) {
  double widthc = NUM2DBL(width);
  gr_setlinewidth(widthc);
  
  return Qtrue;
}

static VALUE inqlinewidth(VALUE self,VALUE a){
  double *ac = rb_ar_2_dbl_ar(a);
  gr_inqlinewidth(ac);
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.setlinecolorind(4) -> true
 *
 * Define the color of subsequent polyline output primitives.
 * 
 * **Parameters:**
 * 
 * `color` :
 * The polyline color index (COLOR < 1256)
 */
static VALUE setlinecolorind(VALUE self,VALUE color) {
  int colorc = NUM2INT(color);
  gr_setlinecolorind(colorc);
  
  return Qtrue;
}

static VALUE inqlinecolorind(VALUE self,VALUE a){
  int *ac = rb_ar_2_int_ar(a);
  gr_inqlinecolorind(ac);
  return Qtrue;
}

/**
 *  call-seq:
 *    Rubyplot::GR.setmarkertype(style) -> true
 *
 *    Specifiy the marker type for polymarkers.
 *
 *    **Parameters:**
 *
 *    `style` :
 *        The polymarker marker type
 *
 *    The available marker types are:
 *
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_DOT               |    1|Smallest displayable dot                        |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_PLUS              |    2|Plus sign                                       |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_ASTERISK          |    3|Asterisk                                        |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_CIRCLE            |    4|Hollow circle                                   |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_DIAGONAL_CROSS    |    5|Diagonal cross                                  |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_CIRCLE      |   -1|Filled circle                                   |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_TRIANGLE_UP       |   -2|Hollow triangle pointing upward                 |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_TRI_UP      |   -3|Filled triangle pointing upward                 |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_TRIANGLE_DOWN     |   -4|Hollow triangle pointing downward               |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_TRI_DOWN    |   -5|Filled triangle pointing downward               |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SQUARE            |   -6|Hollow square                                   |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_SQUARE      |   -7|Filled square                                   |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_BOWTIE            |   -8|Hollow bowtie                                   |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_BOWTIE      |   -9|Filled bowtie                                   |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_HGLASS            |  -10|Hollow hourglass                                |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_HGLASS      |  -11|Filled hourglass                                |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_DIAMOND           |  -12|Hollow diamond                                  |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_DIAMOND     |  -13|Filled Diamond                                  |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_STAR              |  -14|Hollow star                                     |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_STAR        |  -15|Filled Star                                     |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_TRI_UP_DOWN       |  -16|Hollow triangles pointing up and down overlaid  |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_TRI_RIGHT   |  -17|Filled triangle point right                     |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID_TRI_LEFT    |  -18|Filled triangle pointing left                   |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_HOLLOW PLUS       |  -19|Hollow plus sign                                |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_SOLID PLUS        |  -20|Solid plus sign                                 |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_PENTAGON          |  -21|Pentagon                                        |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_HEXAGON           |  -22|Hexagon                                         |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_HEPTAGON          |  -23|Heptagon                                        |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_OCTAGON           |  -24|Octagon                                         |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_STAR_4            |  -25|4-pointed star                                  |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_STAR_5            |  -26|5-pointed star (pentagram)                      |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_STAR_6            |  -27|6-pointed star (hexagram)                       |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_STAR_7            |  -28|7-pointed star (heptagram)                      |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_STAR_8            |  -29|8-pointed star (octagram)                       |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_VLINE             |  -30|verical line                                    |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_HLINE             |  -31|horizontal line                                 |
 *    +-----------------------------+-----+------------------------------------------------+
 *    |MARKERTYPE_OMARK             |  -32|o-mark                                          |
 *    +-----------------------------+-----+------------------------------------------------+
 *
 *    Polymarkers appear centered over their specified coordinates.
 */
static VALUE setmarkertype(VALUE self, VALUE type){
  int typec = NUM2INT(type);
  gr_setmarkertype(typec);
  return Qtrue;
}

static VALUE inqmarkertype(VALUE self,VALUE a){
  int *ac = rb_ar_2_int_ar(a);
  gr_inqmarkertype(ac);
  return Qtrue;
}


static VALUE setmarkersize(VALUE self, VALUE size){
  double sizec = NUM2DBL(size);
  gr_setmarkersize(sizec);
  
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR::setmarkercolorind(color) -> true
 *
 * 
 */
static VALUE setmarkercolorind(VALUE self,VALUE color){
  double colorc = NUM2INT(color);
  gr_setmarkercolorind(colorc);

  return Qtrue;
}

static VALUE inqmarkercolorind(VALUE self,VALUE a){
  int *ac = rb_ar_2_int_ar(a);
  gr_inqmarkercolorind(ac);
  return Qtrue;
}
/**
 * call-seq:
 *   Rubyplot::GR.settextprecision(font, precision)-> true
 * 
 * Specify the text font and precision for subsequent text output primitives.
 * 
 * **Parameters:**
 * 
 * `font` :
 * Text font (see tables below)
 *   `precision` :
 * Text precision (see table below)
 * 
 *   The available text fonts are:
 * 
 * +--------------------------------------+-----+
 * |FONT_TIMES_ROMAN                      |  101|
 * +--------------------------------------+-----+
 * |FONT_TIMES_ITALIC                     |  102|
 * +--------------------------------------+-----+
 * |FONT_TIMES_BOLD                       |  103|
 * +--------------------------------------+-----+
 * |FONT_TIMES_BOLDITALIC                 |  104|
 * +--------------------------------------+-----+
 * |FONT_HELVETICA                        |  105|
 * +--------------------------------------+-----+
 * |FONT_HELVETICA_OBLIQUE                |  106|
 * +--------------------------------------+-----+
 * |FONT_HELVETICA_BOLD                   |  107|
 * +--------------------------------------+-----+
 * |FONT_HELVETICA_BOLDOBLIQUE            |  108|
 * +--------------------------------------+-----+
 * |FONT_COURIER                          |  109|
 * +--------------------------------------+-----+
 * |FONT_COURIER_OBLIQUE                  |  110|
 * +--------------------------------------+-----+
 * |FONT_COURIER_BOLD                     |  111|
 * +--------------------------------------+-----+
 * |FONT_COURIER_BOLDOBLIQUE              |  112|
 * +--------------------------------------+-----+
 * |FONT_SYMBOL                           |  113|
 * +--------------------------------------+-----+
 * |FONT_BOOKMAN_LIGHT                    |  114|
 * +--------------------------------------+-----+
 * |FONT_BOOKMAN_LIGHTITALIC              |  115|
 * +--------------------------------------+-----+
 * |FONT_BOOKMAN_DEMI                     |  116|
 * +--------------------------------------+-----+
 * |FONT_BOOKMAN_DEMIITALIC               |  117|
 * +--------------------------------------+-----+
 * |FONT_NEWCENTURYSCHLBK_ROMAN           |  118|
 * +--------------------------------------+-----+
 * |FONT_NEWCENTURYSCHLBK_ITALIC          |  119|
 * +--------------------------------------+-----+
 * |FONT_NEWCENTURYSCHLBK_BOLD            |  120|
 * +--------------------------------------+-----+
 * |FONT_NEWCENTURYSCHLBK_BOLDITALIC      |  121|
 * +--------------------------------------+-----+
 * |FONT_AVANTGARDE_BOOK                  |  122|
 * +--------------------------------------+-----+
 * |FONT_AVANTGARDE_BOOKOBLIQUE           |  123|
 * +--------------------------------------+-----+
 * |FONT_AVANTGARDE_DEMI                  |  124|
 * +--------------------------------------+-----+
 * |FONT_AVANTGARDE_DEMIOBLIQUE           |  125|
 * +--------------------------------------+-----+
 * |FONT_PALATINO_ROMAN                   |  126|
 * +--------------------------------------+-----+
 * |FONT_PALATINO_ITALIC                  |  127|
 * +--------------------------------------+-----+
 * |FONT_PALATINO_BOLD                    |  128|
 * +--------------------------------------+-----+
 * |FONT_PALATINO_BOLDITALIC              |  129|
 * +--------------------------------------+-----+
 * |FONT_ZAPFCHANCERY_MEDIUMITALIC        |  130|
 * +--------------------------------------+-----+
 * |FONT_ZAPFDINGBATS                     |  131|
 * +--------------------------------------+-----+
 * 
 * The available text precisions are:
 * 
 * +---------------------------+---+--------------------------------------+
 * |TEXT_PRECISION_STRING      |  0|String precision (higher quality)     |
 * +---------------------------+---+--------------------------------------+
 * |TEXT_PRECISION_CHAR        |  1|Character precision (medium quality)  |
 * +---------------------------+---+--------------------------------------+
 * |TEXT_PRECISION_STROKE      |  2|Stroke precision (lower quality)      |
 * +---------------------------+---+--------------------------------------+
 * 
 * The appearance of a font depends on the text precision value specified.
 * STRING, CHARACTER or STROKE precision allows for a greater or lesser
 *   realization of the text primitives, for efficiency. STRING is the default
 *   precision for GR and produces the highest quality output.
 */
static VALUE settextfontprec(VALUE self, VALUE font, VALUE precision){
  int fontc = NUM2INT(font);
  int precisionc = NUM2INT(precision);
  gr_settextfontprec(fontc, precisionc);
  
  return Qtrue;
}

static VALUE setcharexpan(VALUE self,VALUE factor){
  double factorc = NUM2DBL(factor);
  gr_setcharexpan(factorc);
  return Qtrue;
}

static VALUE setcharspace(VALUE self,VALUE a){
  double ac = NUM2DBL(a);
  gr_setcharspace(ac);
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.settextcolorind(color) -> true
 *
 * Sets the current text color index.
 * 
 * **Parameters:**
 * 
 * `color` :
 * The text color index (COLOR < 1256)
 * 
 *   `settextcolorind` defines the color of subsequent text output primitives.
 *   GR uses the default foreground color (black=1) for the default text color index.
 */
static VALUE settextcolorind(VALUE self,VALUE color){
  int colorc = NUM2INT(color);
  gr_settextcolorind(colorc);
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.setcharheight(0.05) -> true
 *
 * Set the current character height.
 * 
 * **Parameters:**
 * 
 * `height` :
 * Text height value
 * 
 * `setcharheight` defines the height of subsequent text output primitives. Text height
 * is defined as a percentage of the default window. GR uses the default text height of
 * 0.027 (2.7% of the height of the default window).
 */
static VALUE setcharheight(VALUE self, VALUE height) {
  double heightc= NUM2DBL(height);
  gr_setcharheight(heightc);
  
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.setcharup(0, 0.5) -> true
 * 
 * Set the current character text angle up vector.
 * 
 * **Parameters:**
 * 
 * `ux`, `uy` :
 *   Text up vector
 * 
 *   `setcharup` defines the vertical rotation of subsequent text output primitives.
 *   The text up vector is initially set to (0, 1), horizontal to the baseline.
 */
static VALUE setcharup(VALUE self,VALUE ux,VALUE uy) {
  double uxc = NUM2DBL(ux);
  double uyc = NUM2DBL(uy);
  gr_setcharup(uxc,uyc);
  
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.settextpath(2) -> true
 *
 * Define the current direction in which subsequent text will be drawn.
 * 
 * **Parameters:**
 * 
 * `path` :
 * Text path (see table below)
 * 
 *   +----------------------+---+---------------+
 *   |TEXT_PATH_RIGHT       |  0|left-to-right  |
 *   +----------------------+---+---------------+
 *   |TEXT_PATH_LEFT        |  1|right-to-left  |
 *   +----------------------+---+---------------+
 *   |TEXT_PATH_UP          |  2|downside-up    |
 *   +----------------------+---+---------------+
 *   |TEXT_PATH_DOWN        |  3|upside-down    |
 *   +----------------------+---+---------------+
 */
static VALUE settextpath(VALUE self,VALUE path){
  int pathc = NUM2INT(path);
  
  gr_settextpath(pathc);
  return Qtrue;
}

/**
 *    call-seq:
 *      Rubyplot::GR.settextalign(Rubyplot::GR::TEXT_HALIGN_NORMAL, 
 *        Rubyplot::GR::TEXT_VALIGN_LEFT) -> true
 *
 *    Set the current horizontal and vertical alignment for text.
 *
 *    **Parameters:**
 *
 *    `horizontal` :
 *        Horizontal text alignment (see the table below)
 *    `vertical` :
 *        Vertical text alignment (see the table below)
 *
 *    `settextalign` specifies how the characters in a text primitive will be aligned
 *    in horizontal and vertical space. The default text alignment indicates horizontal left
 *    alignment and vertical baseline alignment.
 *
 *    +-------------------------+---+----------------+
 *    |TEXT_HALIGN_NORMAL       |  0|                |
 *    +-------------------------+---+----------------+
 *    |TEXT_HALIGN_LEFT         |  1|Left justify    |
 *    +-------------------------+---+----------------+
 *    |TEXT_HALIGN_CENTER       |  2|Center justify  |
 *    +-------------------------+---+----------------+
 *    |TEXT_HALIGN_RIGHT        |  3|Right justify   |
 *    +-------------------------+---+----------------+
 *
 *    +-------------------------+---+------------------------------------------------+
 *    |TEXT_VALIGN_NORMAL       |  0|                                                |
 *    +-------------------------+---+------------------------------------------------+
 *    |TEXT_VALIGN_TOP          |  1|Align with the top of the characters            |
 *    +-------------------------+---+------------------------------------------------+
 *    |TEXT_VALIGN_CAP          |  2|Aligned with the cap of the characters          |
 *    +-------------------------+---+------------------------------------------------+
 *    |TEXT_VALIGN_HALF         |  3|Aligned with the half line of the characters    |
 *    +-------------------------+---+------------------------------------------------+
 *    |TEXT_VALIGN_BASE         |  4|Aligned with the base line of the characters    |
 *    +-------------------------+---+------------------------------------------------+
 *    |TEXT_VALIGN_BOTTOM       |  5|Aligned with the bottom line of the characters  |
 *    +-------------------------+---+------------------------------------------------+
 */
static VALUE settextalign(VALUE self, VALUE horizontal, VALUE vertical) {
  int horizontalc = NUM2INT(horizontal);
  int verticalc   = NUM2INT(vertical);
  
  gr_settextalign(horizontalc,verticalc);
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.setfillintstyle(3) -> true
 *
 * Set the fill area interior style to be used for fill areas.
 * 
 * **Parameters:**
 * 
 * `style` :
 * The style of fill to be used
 * 
 * `setfillintstyle` defines the interior style  for subsequent fill area output
 * primitives. The default interior style is HOLLOW.
 * 
 * +------------------+-+-----------------------------------------------------------------------+
 * |INTSTYLE_HOLLOW  |0|No filling. Just draw the bounding polyline                            |
 * +------------------+-+-----------------------------------------------------------------------+
 * |INTSTYLE_SOLID   |1|Fill the interior of the polygon using the fill color index            |
 * +------------------+-+-----------------------------------------------------------------------+
 * |INTSTYLE_PATTERN |2|Fill the interior of the polygon using the style index as a pattern index|
 * +-----------------+--+------------------------------------------------------------------------+
 * |INTSTYLE_HATCH    |3|Fill the interior of the polygon using the style index as a cross-hatched style|
 * +-----------------+-+--------------------------------------------------------------------------+
 */
static VALUE setfillintstyle(VALUE self,VALUE style) {
  int stylec = NUM2INT(style);
  gr_setfillintstyle(stylec);
  
  return Qtrue;
}

/**
 *Sets the fill style to be used for subsequent fill areas.
 *
 ***Parameters:**
 *
 *`index` :
 *The fill style index to be used
 *
 *`setfillstyle` specifies an index when PATTERN fill or HATCH fill is requested by the
 *`setfillintstyle` function. If the interior style is set to PATTERN, the fill style
 *  index points to a device-independent pattern table. If interior style is set to HATCH
 *  the fill style index indicates different hatch styles. If HOLLOW or SOLID is specified
 *  for the interior style, the fill style index is unused.
 */
static VALUE setfillstyle(VALUE self,VALUE index){
  int indexc = NUM2INT(index);
  gr_setfillstyle(indexc);
  return Qtrue;
}

/*
 *Sets the current fill area color index.
 *
 ***Parameters:**
 *
 *`color` :
 *The fill area color index (COLOR < 1256)
 *
 *  `setfillcolorind` defines the color of subsequent fill area output primitives.
 *  GR uses the default foreground color (black=1) for the default fill area color index.
 */
static VALUE setfillcolorind(VALUE self,VALUE color) {
  int colorc = NUM2INT(color);
  gr_setfillcolorind(colorc);
  
  return Qtrue;
}

static VALUE setcolorrep(VALUE self,VALUE index,VALUE red,VALUE green,VALUE blue){
  int indexc = NUM2INT(index);
  double redc = NUM2DBL(red);
  double greenc = NUM2DBL(green);
  double bluec = NUM2DBL(blue);
  gr_setcolorrep(index,red,green,blue);
  return Qtrue;
}

/* 
 * call-seq:
 *   Rubyplot::GR.setwindow(xmin, xmax, ymin, ymax) -> true
 *
 * Set a window or rectangular subspace of world co-ordinates to be plotted.
 *
 * xmin [Numeric] : Minimum value of X data in this window.
 * xmax [Numeric] : Maximum value of X data in this window.
 * ymin [Numeric] : Minimum value of Y data in this window. 
 * ymax [Numeric] : Maximum value of Y data in this window.
 *
 */
static VALUE setwindow(VALUE self, VALUE xmin, VALUE xmax,VALUE ymin, VALUE ymax) {
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  gr_setwindow(xminc,xmaxc,yminc,ymaxc);
  return Qtrue;
}

static VALUE inqwindow(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d) {
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b);
  double *cc = rb_ar_2_dbl_ar(c);
  double *dc = rb_ar_2_dbl_ar(d);
  gr_inqwindow(ac,bc,cc,dc);
  return Qtrue;
}

/*
 * call-seq:
 *   Rubyplot::GR.setviewport(xmin, xmax, ymin, ymax) -> true
 * 
 * `setviewport` establishes a rectangular subspace of normalized device coordinates.
 *
 * `setviewport` defines the rectangular portion of the Normalized Device Coordinate
 * (NDC) space to be associated with the specified normalization transformation. The
 * NDC viewport and World Coordinate (WC) window define the normalization transformation
 * through which all output primitives pass. The WC window is mapped onto the rectangular
 * NDC viewport which is, in turn, mapped onto the display surface of the open and active
 * workstation, in device coordinates.
 *
 * xmin [Numeric] :
 * xmax [Numeric] :
 * ymin [Numeric] :
 * ymax [Numeric] :
 */
static VALUE setviewport(VALUE self, VALUE xmin, VALUE xmax, VALUE ymin, VALUE ymax) {
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  gr_setviewport(xminc,xmaxc,yminc,ymaxc);
  
  return Qtrue;
}

static VALUE inqviewport(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d){
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b);
  double *cc = rb_ar_2_dbl_ar(c);
  double *dc = rb_ar_2_dbl_ar(d);
  gr_inqviewport(ac,bc,cc,dc);
  return Qtrue;
}

static VALUE selntran(VALUE self,VALUE transform){
  int transformc = NUM2INT(transform);
  gr_selntran(transformc);
  return Qtrue;
}

static VALUE setclip(VALUE self,VALUE indicator){
  int indicatorc = NUM2INT(indicator);
  gr_setclip(indicatorc);
  return Qtrue;
}

/*
 * Set the area of the NDC viewport that is to be drawn in the workstation window.
 * 
 * **Parameters:**
 * 
 * `xmin` :
 * The left horizontal coordinate of the workstation window.
 * `xmax` :
 * The right horizontal coordinate of the workstation window (0 <= `xmin` < `xmax` <= 1).
 * `ymin` :
 * The bottom vertical coordinate of the workstation window.
 * `ymax` :
 * The top vertical coordinate of the workstation window (0 <= `ymin` < `ymax` <= 1).
 * 
 *   `setwswindow` defines the rectangular area of the Normalized Device Coordinate space
 *   to be output to the device. By default, the workstation transformation will map the
 *   range [0,1] x [0,1] in NDC onto the largest square on the workstation’s display
 *   surface. The aspect ratio of the workstation window is maintained at 1 to 1.
 **/
static VALUE setwswindow(VALUE self,VALUE xmin,VALUE xmax,VALUE ymin,VALUE ymax) {
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  gr_setwswindow(xminc,xmaxc,yminc,ymaxc);
  
  return Qtrue;
}

/*
 *    Define the size of the workstation graphics window in meters.
 *
 *    **Parameters:**
 *
 *    `xmin` :
 *        The left horizontal coordinate of the workstation viewport.
 *    `xmax` :
 *        The right horizontal coordinate of the workstation viewport.
 *    `ymin` :
 *        The bottom vertical coordinate of the workstation viewport.
 *    `ymax` :
 *        The top vertical coordinate of the workstation viewport.
 *
 *    `setwsviewport` places a workstation window on the display of the specified size in
 *    meters. This command allows the workstation window to be accurately sized for a
 *    display or hardcopy device, and is often useful for sizing graphs for desktop
 *    publishing applications.
 **/
static VALUE setwsviewport(VALUE self,VALUE xmin,VALUE xmax,VALUE ymin,VALUE ymax) {
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  gr_setwsviewport(xminc,xmaxc,yminc,ymaxc);
  
  return Qtrue;
}

static VALUE createseg(VALUE self,VALUE a){
  int ac = NUM2INT(a);
  gr_createseg(ac);
  return Qtrue;
}

static VALUE copysegws(VALUE self,VALUE a){
  int ac = NUM2INT(a);
  gr_copysegws(ac);
  return Qtrue;
}

static VALUE redrawsegws(VALUE self){
  gr_redrawsegws();
  return Qtrue;
}

static VALUE setsegtran(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d,VALUE e,VALUE f,VALUE g,VALUE h){
  int ac = NUM2INT(a);
  double bc = NUM2DBL(b);
  double cc = NUM2DBL(c);
  double dc = NUM2DBL(d);
  double ec = NUM2DBL(e);
  double fc = NUM2DBL(f);
  double gc = NUM2DBL(g);
  double hc = NUM2DBL(h);
  gr_setsegtran(a,b,c,d,e,f,g,h);
  return Qtrue;
}

static VALUE closeseg(VALUE self){
  gr_closeseg();
  return Qtrue;
}

static VALUE emergencyclosegks(VALUE self){
  gr_emergencyclosegks();
  return Qtrue;
}

static VALUE updategks(VALUE self){
  gr_updategks();
  return Qtrue;
}

static VALUE setspace(VALUE self, VALUE zmin, VALUE zmax,VALUE rotation, VALUE tilt){
  double zminc = NUM2DBL(zmin);
  double zmaxc = NUM2DBL(zmax);
  int rotationc = NUM2INT(rotation);
  int tiltc = NUM2INT(tilt);
  return INT2NUM(gr_setspace(zminc,zmaxc,rotationc,tiltc));
}

static VALUE inqspace(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d){
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b);
  int *cc = rb_ar_2_int_ar(c);
  int *dc = rb_ar_2_int_ar(d);
  gr_inqspace(ac,bc,cc,dc);
  return Qtrue;
}

static VALUE setscale(VALUE self,VALUE options){
  int optionsc = NUM2INT(options);
  return INT2NUM(gr_setscale(optionsc));
}

static VALUE inqscale(VALUE self,VALUE a){
  int *ac = rb_ar_2_int_ar(a);
  gr_inqscale(ac);
  return Qtrue;
}

/**
 *  call-seq:
 *    Rubyplot::GR.textext(x, y, "string to write") -> true    
 *
 *    Draw a text at position `x`, `y` using the current text attributes. Strings can be
 *    defined to create basic mathematical expressions and Greek letters.
 *
 *    **Parameters:**
 *
 *    `x` :
 *        The X coordinate of starting position of the text string
 *    `y` :
 *        The Y coordinate of starting position of the text string
 *    `string` :
 *        The text to be drawn
 *
 *    The values for X and Y are in normalized device coordinates.
 *    The attributes that control the appearance of text are text font and precision,
 *    character expansion factor, character spacing, text color index, character
 *    height, character up vector, text path and text alignment.
 *
 *    The character string is interpreted to be a simple mathematical formula.
 *    The following notations apply:
 *
 *    Subscripts and superscripts: These are indicated by carets ('^') and underscores
 *    ('_'). If the sub/superscript contains more than one character, it must be enclosed
 *    in curly braces ('{}').
 *
 *    Fractions are typeset with A '/' B, where A stands for the numerator and B for the
 *    denominator.
 *
 *    To include a Greek letter you must specify the corresponding keyword after a
 *    backslash ('\') character. The text translator produces uppercase or lowercase
 *    Greek letters depending on the case of the keyword.
 *
 *    +--------+---------+
 *    |Letter  |Keyword  |
 *    +--------+---------+
 *    |Α α     |alpha    |
 *    +--------+---------+
 *    |Β β     |beta     |
 *    +--------+---------+
 *    |Γ γ     |gamma    |
 *    +--------+---------+
 *    |Δ δ     |delta    |
 *    +--------+---------+
 *    |Ε ε     |epsilon  |
 *    +--------+---------+
 *    |Ζ ζ     |zeta     |
 *    +--------+---------+
 *    |Η η     |eta      |
 *    +--------+---------+
 *    |Θ θ     |theta    |
 *    +--------+---------+
 *    |Ι ι     |iota     |
 *    +--------+---------+
 *    |Κ κ     |kappa    |
 *    +--------+---------+
 *    |Λ λ     |lambda   |
 *    +--------+---------+
 *    |Μ μ     |mu       |
 *    +--------+---------+
 *    |Ν ν     |Nu / v   |
 *    +--------+---------+
 *    |Ξ ξ     |xi       |
 *    +--------+---------+
 *    |Ο ο     |omicron  |
 *    +--------+---------+
 *    |Π π     |pi       |
 *    +--------+---------+
 *    |Ρ ρ     |rho      |
 *    +--------+---------+
 *    |Σ σ     |sigma    |
 *    +--------+---------+
 *    |Τ τ     |tau      |
 *    +--------+---------+
 *    |Υ υ     |upsilon  |
 *    +--------+---------+
 *    |Φ φ     |phi      |
 *    +--------+---------+
 *    |Χ χ     |chi      |
 *    +--------+---------+
 *    |Ψ ψ     |psi      |
 *    +--------+---------+
 *    |Ω ω     |omega    |
 *    +--------+---------+
 *
 *    Note: `\v` is a replacement for `\nu` which would conflict with `\n` (newline)
 *
 *    For more sophisticated mathematical formulas, you should use the `gr.mathtex`
 *    function.
 */

static VALUE textext(VALUE self,VALUE x, VALUE y, VALUE string) {
  double xc=NUM2DBL(x);
  double yc=NUM2DBL(y);
  char *stringc=StringValueCStr(string);
  gr_textext(xc,yc,stringc);
  
  return Qtrue;
}

static VALUE inqtextext(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d,VALUE e) {
  double ac = NUM2DBL(a);
  double bc = NUM2DBL(b);
  char *cc = StringValueCStr(c);
  double *dc = rb_ar_2_dbl_ar(d);
  double *ec = rb_ar_2_dbl_ar(e);
  gr_inqtextext(ac,bc,cc,dc,ec);
  return Qtrue;
}

/* 
 * call-seq:
 *    Rubyplot::GR.axes(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size) -> true
 *
 * Draw X and Y co-ordinate axes with linear or logarithmically spaced tick marks.
 *
 *   `x_tick`, `y_tick` :
 *       The interval between minor tick marks on each axis.
 *   `x_org`, `y_org` :
 *       The world coordinates of the origin (point of intersection) of the X
 *       and Y axes.
 *   `major_x`, `major_y` :
 *       Unitless integer values specifying the number of minor tick intervals
 *       between major tick marks. Values of 0 or 1 imply no minor ticks.
 *       Negative values specify no labels will be drawn for the associated axis.
 *   `tick_size` :
 *       The length of minor tick marks specified in a normalized device
 *       coordinate unit. Major tick marks are twice as long as minor tick marks.
 *       A negative value reverses the tick marks on the axes from inward facing
 *       to outward facing (or vice versa).
 *
 *   Tick marks are positioned along each axis so that major tick marks fall on the axes
 *   origin (whether visible or not). Major tick marks are labeled with the corresponding
 *   data values. Axes are drawn according to the scale of the window. Axes and tick marks
 *   are drawn using solid lines; line color and width can be modified using the
 *   `setlinetype` and `setlinewidth` functions. Axes are drawn according to
 *   the linear or logarithmic transformation established by the `setscale` function.
 *
 */
static VALUE axes(VALUE self, VALUE x_tick, VALUE y_tick, VALUE x_org,
                  VALUE y_org, VALUE major_x, VALUE major_y, VALUE tick_size) {
  double x_tickc = NUM2DBL(x_tick);
  double y_tickc = NUM2DBL(y_tick);
  double x_orgc  = NUM2DBL(x_org);
  double y_orgc  = NUM2DBL(y_org);
  int major_xc   = NUM2INT(major_x);
  int major_yc   = NUM2INT(major_y);
  double tick_sizec=NUM2DBL(tick_size);
  
  gr_axes(x_tickc, y_tickc, x_orgc,y_orgc,major_xc,major_yc,tick_sizec);
  
  return Qtrue;
}

static VALUE global_fpx_proc;          /* Proc for axeslbl X axis. */
static VALUE global_fpy_proc;          /* Proc for axeslbl Y axis.  */

static void rb_grruby_axeslbl_fpx_internal_callback(double x, double y,
                                                    const char * svalue, double value) {
  rb_funcall(global_fpx_proc, rb_intern("call"), 4,
             DBL2NUM(x), DBL2NUM(y), rb_str_new2(svalue), DBL2NUM(value));
}

static void rb_grruby_axeslbl_fpy_internal_callback(double x, double y,
                                                    const char * svalue, double value) {
  rb_funcall(global_fpy_proc, rb_intern("call"), 4,
             DBL2NUM(x), DBL2NUM(y), rb_str_new2(svalue), DBL2NUM(value));  
}

/* call-seq:
 *    Rubyplot::GR.axeslbl(x_tick, y_tick, x_org, y_org, major_x, major_y, tick_size,
 *       fpx, fpy) -> true 
 *
 * Similar to axes() but allows more fine grained control over tick labels and
 * text positioning.
 * 
 * References:
 *   http://clalance.blogspot.com/2011/01/writing-ruby-extensions-in-c-part-11.html
 */
static VALUE axeslbl(VALUE self, VALUE x_tick, VALUE y_tick, VALUE x_org,
                     VALUE y_org, VALUE major_x, VALUE major_y ,VALUE tick_size,
                     VALUE fpx, VALUE fpy) {
  global_fpx_proc = fpx;
  global_fpy_proc = fpy;

  gr_axeslbl(NUM2DBL(x_tick),
             NUM2DBL(y_tick),
             NUM2DBL(x_org),
             NUM2DBL(y_org),
             NUM2INT(major_x),
             NUM2INT(major_y),
             NUM2DBL(tick_size),
             rb_grruby_axeslbl_fpx_internal_callback,
             rb_grruby_axeslbl_fpy_internal_callback);
  
  return Qtrue;
}

static VALUE grid(VALUE self,VALUE x_tick,VALUE y_tick,VALUE x_org,VALUE y_org,
                  VALUE major_x,VALUE major_y) {
  double x_tickc = NUM2DBL(x_tick);
  double y_tickc = NUM2DBL(y_tick);
  double x_orgc = NUM2DBL(x_org);
  double y_orgc = NUM2DBL(y_org);
  int major_xc=NUM2INT(major_x);
  int major_yc=NUM2INT(major_y);
  gr_grid(x_tickc,y_tickc,x_orgc,y_orgc,major_xc,major_yc);
  return Qtrue;
}

static VALUE grid3d(VALUE self,VALUE x_tick,VALUE y_tick,VALUE z_tick,VALUE x_org,
                    VALUE y_org,VALUE z_org,VALUE major_x,VALUE major_y,VALUE major_z) {
  double x_tickc = NUM2DBL(x_tick);
  double y_tickc = NUM2DBL(y_tick);
  double z_tickc = NUM2DBL(z_tick);
  double x_orgc = NUM2DBL(x_org);
  double y_orgc = NUM2DBL(y_org);
  double z_orgc = NUM2DBL(z_org);
  int major_xc=NUM2INT(major_x);
  int major_yc=NUM2INT(major_y);
  int major_zc=NUM2INT(major_z);
  gr_grid3d(x_tickc,y_tickc,z_tickc,x_orgc,y_orgc,z_orgc,major_xc,major_yc,major_zc);
  return Qtrue;
}

static VALUE verrorbars(VALUE self,VALUE px,VALUE py,VALUE e1,VALUE e2){
  int x_size = RARRAY_LEN(px);
  int y_size = RARRAY_LEN(py);
  int size = (x_size <= y_size)?x_size:y_size;
  double *pxc = rb_ar_2_dbl_ar(px);
  double *pyc = rb_ar_2_dbl_ar(py);
  double *e1c = rb_ar_2_dbl_ar(e1);
  double *e2c = rb_ar_2_dbl_ar(e2);
  gr_verrorbars(size,pxc,pyc,e1c,e2c);
  return Qtrue;
}

static VALUE herrorbars(VALUE self,VALUE px,VALUE py,VALUE e1,VALUE e2){
  int x_size = RARRAY_LEN(px);
  int y_size = RARRAY_LEN(py);
  int size = (x_size <= y_size)?x_size:y_size;
  double *pxc = rb_ar_2_dbl_ar(px);
  double *pyc = rb_ar_2_dbl_ar(py);
  double *e1c = rb_ar_2_dbl_ar(e1);
  double *e2c = rb_ar_2_dbl_ar(e2);
  gr_herrorbars(size,pxc,pyc,e1c,e2c);
  return Qtrue;
}

static VALUE polyline3d(VALUE self,VALUE px,VALUE py,VALUE pz){
  int x_size = RARRAY_LEN(px);
  int y_size = RARRAY_LEN(py);
  int z_size = RARRAY_LEN(pz);
  int size = (x_size <= y_size)?x_size:y_size;
  size = (size <= z_size)?size:z_size;
  double *xc = rb_ar_2_dbl_ar(px);
  double *yc = rb_ar_2_dbl_ar(py); 
  double *zc = rb_ar_2_dbl_ar(pz); 
  gr_polyline3d(size,xc,yc,zc);
  return Qtrue;
}

static VALUE polymarker3d(VALUE self,VALUE px,VALUE py,VALUE pz){
  int x_size = RARRAY_LEN(px);
  int y_size = RARRAY_LEN(py);
  int z_size = RARRAY_LEN(pz);
  int size = (x_size <= y_size)?x_size:y_size;
  size = (size <= z_size)?size:z_size;
  double *xc = rb_ar_2_dbl_ar(px);
  double *yc = rb_ar_2_dbl_ar(py); 
  double *zc = rb_ar_2_dbl_ar(pz); 
  gr_polymarker3d(size,xc,yc,zc);
  return Qtrue;
}

static VALUE axes3d(VALUE self,VALUE x_tick,VALUE y_tick,VALUE z_tick,VALUE x_org,VALUE y_org,VALUE z_org,VALUE major_x,VALUE major_y,VALUE major_z,VALUE tick_size){
  double x_tickc = NUM2DBL(x_tick);
  double y_tickc = NUM2DBL(y_tick);
  double z_tickc = NUM2DBL(z_tick);
  double x_orgc = NUM2DBL(x_org);
  double y_orgc = NUM2DBL(y_org);
  double z_orgc = NUM2DBL(z_org);
  int major_xc = NUM2INT(major_x);
  int major_yc = NUM2INT(major_y);
  int major_zc = NUM2INT(major_z);
  double tick_sizec = NUM2DBL(tick_size);
  gr_axes3d(x_tickc,y_tickc,z_tickc,x_orgc,y_orgc,z_orgc,major_xc,major_yc,major_zc,tick_sizec);
  return Qtrue;
}

static VALUE titles3d(VALUE self,VALUE x_title,VALUE y_title,VALUE z_title){
  char *x_titlec = StringValueCStr(x_title);
  char *y_titlec = StringValueCStr(y_title);
  char *z_titlec = StringValueCStr(z_title);
  gr_titles3d(x_titlec,y_titlec,z_titlec);
  return Qtrue;
}

static VALUE surface(VALUE self,VALUE px,VALUE py,VALUE pz,VALUE option){
  int nxc = RARRAY_LEN(px);
  int nyc = RARRAY_LEN(py);
  double *pxc = rb_ar_2_dbl_ar(px);
  double *pyc = rb_ar_2_dbl_ar(py);
  double *pzc = rb_ar_2_dbl_ar(pz);
  int optionc =  NUM2INT(option);
  gr_surface(nxc,nyc,pxc,pyc,pzc,optionc);
  return Qtrue;
}

static VALUE contour(VALUE self,VALUE px,VALUE py,VALUE ph,VALUE pz,VALUE major_h){
  int nxc = RARRAY_LEN(px);
  int nyc = RARRAY_LEN(py);
  int nhc = RARRAY_LEN(ph);
  double *pxc = rb_ar_2_dbl_ar(px);
  double *pyc = rb_ar_2_dbl_ar(py);
  double *phc = rb_ar_2_dbl_ar(ph);
  double *pzc = rb_ar_2_dbl_ar(pz);
  int major_hc =  NUM2INT(major_h);
  gr_contour(nxc,nyc,nhc,pxc,pyc,phc,pzc,major_hc);
  return Qtrue;
}

static VALUE tricontour(VALUE self,VALUE npoints,VALUE x,VALUE y,VALUE z,
                        VALUE nlevels,VALUE levels) {
  int npointsc = NUM2INT(npoints);
  double *xc = rb_ar_2_dbl_ar(x);
  double *yc = rb_ar_2_dbl_ar(y);
  double *zc = rb_ar_2_dbl_ar(z);
  int nlevelsc = NUM2INT(nlevels);
  double *levelsc = rb_ar_2_dbl_ar(levels);
  gr_tricontour(npointsc,xc,yc,zc,nlevelsc,levelsc);
  return Qtrue;
}

static VALUE hexbin(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d) {
  int ac = NUM2INT(a);
  double* bc = rb_ar_2_dbl_ar(b);
  double* cc = rb_ar_2_dbl_ar(c);
  int dc = NUM2INT(d);
  return INT2NUM(gr_hexbin(ac,bc,cc,dc));
}

static VALUE setcolormap(VALUE self,VALUE a) {
  int ac = NUM2INT(a);
  gr_setcolormap(ac);
  return Qtrue;
}

static VALUE inqcolormap(VALUE self,VALUE a){
  int *ac = rb_ar_2_int_ar(a);
  gr_inqcolormap(ac);
  return Qtrue;
}

static VALUE colorbar(VALUE self){
  gr_colorbar();
  return Qtrue;
}

static VALUE inqcolor(VALUE self,VALUE a,VALUE b){
  int ac = NUM2INT(a);
  int *bc = rb_ar_2_int_ar(b);
  gr_inqcolor(ac,bc);
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.inqcolorfromrgb(r, g, b) -> color_index
 *
 * Get a GR-compatible color index from RGB color values.
 * 
 * Arguments:
 * * `r` - Value between 0-255 representing red.
 * * `g` - Value between 0-255 representing green.
 * * `b` - Value between 0-255 representing blue.
 */
static VALUE inqcolorfromrgb(VALUE self,VALUE r,VALUE g,VALUE b){
  double ac = NUM2DBL(r);
  double bc = NUM2DBL(g);
  double cc = NUM2DBL(b);
  return INT2NUM(gr_inqcolorfromrgb(ac,bc,cc));
}

static VALUE hsvtorgb(VALUE self,VALUE h,VALUE s,VALUE v ,VALUE r,VALUE g,VALUE b){
  double hc = NUM2DBL(h);
  double sc = NUM2DBL(s);
  double vc = NUM2DBL(v);
  double *rc = rb_ar_2_dbl_ar(r);
  double *gc = rb_ar_2_dbl_ar(g);
  double *bc = rb_ar_2_dbl_ar(b);
  gr_hsvtorgb(hc,sc,vc,rc,gc,bc);
  return Qtrue;
}

/*
 * call-seq:
 *   Rubyplot::GR.tick(amin, amax) -> Numeric
 *
 * Return a tick unit that evenly divides into the difference between the maximum
 * and minimum values.
 */
static VALUE tick(VALUE self,VALUE amin,VALUE amax) {
  double ac = NUM2DBL(amin);
  double bc = NUM2DBL(amax);
  
  return DBL2NUM(gr_tick(ac,bc));
}

static VALUE validaterange(VALUE self,VALUE a,VALUE b){
  double ac = NUM2DBL(a);
  double bc = NUM2DBL(b);
  return INT2NUM(gr_validaterange(ac,bc));
}

/* 
 * call-seq:
 *   Rubyplot::GR.adjustlimits(amin, amax) -> [adjusted_amin, adjusted_amax]
 *
 */
static VALUE adjustlimits(VALUE self,VALUE amin,VALUE amax) {
  VALUE ret = rb_ary_new2(2);
  double ac = NUM2DBL(amin);
  double bc = NUM2DBL(amax);
  
  gr_adjustlimits(&ac,&bc);

  rb_ary_push(ret, DBL2NUM(ac));
  rb_ary_push(ret, DBL2NUM(bc));
  
  return ret;
}

static VALUE adjustrange(VALUE self,VALUE a,VALUE b){
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b);
  gr_adjustrange(ac,bc);
  return Qtrue;
}

/*
 *   Open and activate a print device.
 *
 *   **Parameters:**
 *
 *   `pathname` :
 *       Filename for the print device.
 *
 *   `beginprint` opens an additional graphics output device. The device type is obtained
 *   from the given file extension. The following file types are supported:
 *
 *   +-------------+---------------------------------------+
 *   |.ps, .eps    |PostScript                             |
 *   +-------------+---------------------------------------+
 *   |.pdf         |Portable Document Format               |
 *   +-------------+---------------------------------------+
 *   |.bmp         |Windows Bitmap (BMP)                   |
 *   +-------------+---------------------------------------+
 *   |.jpeg, .jpg  |JPEG image file                        |
 *   +-------------+---------------------------------------+
 *   |.png         |Portable Network Graphics file (PNG)   |
 *   +-------------+---------------------------------------+
 *   |.tiff, .tif  |Tagged Image File Format (TIFF)        |
 *   +-------------+---------------------------------------+
 *   |.fig         |Xfig vector graphics file              |
 *   +-------------+---------------------------------------+
 *   |.svg         |Scalable Vector Graphics               |
 *   +-------------+---------------------------------------+
 *   |.wmf         |Windows Metafile                       |
 *   +-------------+---------------------------------------+
 */
static VALUE beginprint(VALUE self, VALUE pathname) {
  char *pathnamec = StringValueCStr(pathname);
  
  gr_beginprint(pathnamec);
  return Qtrue;
}

static VALUE beginprintext(VALUE self, VALUE pathname, VALUE mode,
                           VALUE format, VALUE orientation){
  char *pathnamec = StringValueCStr(pathname);
  char *modec = StringValueCStr(mode);
  char *formatc = StringValueCStr(format);
  char *orientationc = StringValueCStr(orientation);
  gr_beginprintext(pathnamec,modec,formatc,orientationc);
  
  return Qtrue;
}

static VALUE endprint(VALUE self){
  gr_endprint();
  return Qtrue;
}

static VALUE ndctowc(VALUE self,VALUE a,VALUE b){
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b);
  gr_ndctowc(ac,bc);
  return Qtrue;
}

static VALUE wctondc(VALUE self,VALUE a,VALUE b){
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b);
  gr_wctondc(ac,bc);
  return Qtrue;
}

static VALUE wc3towc(VALUE self,VALUE a,VALUE b,VALUE c){
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b);
  double *cc = rb_ar_2_dbl_ar(c);
  gr_wc3towc(ac,bc,cc);
  return Qtrue;
}

/*
* Draw a rectangle using the current line attributes.
* 
* **Parameters:**
* 
* `xmin` :
*   Lower left edge of the rectangle
* `xmax` :
*   Lower right edge of the rectangle
* `ymin` :
*   Upper left edge of the rectangle
* `ymax` :
*   Upper right edge of the rectangle
*/
static VALUE drawrect(VALUE self,VALUE xmin,VALUE xmax,VALUE ymin,VALUE ymax) {
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  gr_drawrect(xminc,xmaxc,yminc,ymaxc);
  
  return Qtrue;
}

/*
 * Draw a filled rectangle using the current fill attributes.
 * 
 * **Parameters:**
 * 
 * `xmin` :
 *   Lower left edge of the rectangle
 * `xmax` :
 *   Lower right edge of the rectangle
 * `ymin` :
 *   Upper left edge of the rectangle
 * `ymax` :
 *   Upper right edge of the rectangle
 */
static VALUE fillrect(VALUE self,VALUE xmin,VALUE xmax,VALUE ymin,VALUE ymax){
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  gr_fillrect(xminc,xmaxc,yminc,ymaxc);
  
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.drawarc(0,1,0,1,0,360) -> true
 *
 * Draw a circular or elliptical arc covering the specified rectangle.
 * 
 * **Parameters:**
 * 
 * `xmin` :
 * Lower left edge of the rectangle
 * `xmax` :
 * Lower right edge of the rectangle
 * `ymin` :
 * Upper left edge of the rectangle
 * `ymax` :
 * Upper right edge of the rectangle
 * `a1` :
 * The start angle
 * `a2` :
 * The end angle
 * 
 * The resulting arc begins at `a1` and ends at `a2` degrees. Angles are interpreted
 * such that 0 degrees is at the 3 o'clock position. The center of the arc is the center
 * of the given rectangle.
 */
static VALUE drawarc(VALUE self,VALUE xmin,VALUE xmax,VALUE ymin,VALUE ymax,
                     VALUE a1,VALUE a2) {
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  int a1c = NUM2INT(a1);
  int a2c = NUM2INT(a2);
  gr_drawarc(xminc,xmaxc,yminc,ymaxc,a1c,a2c);
  
  return Qtrue;
}

/**
 * call-seq:
 *   Rubyplot::GR.drawarc(0,1,0,1,0,360) -> true
 *
 * Fill a circular or elliptical arc covering the specified rectangle.
 * 
 * **Parameters:**
 * 
 * `xmin` :
 * Lower left edge of the rectangle
 * `xmax` :
 * Lower right edge of the rectangle
 * `ymin` :
 * Upper left edge of the rectangle
 * `ymax` :
 * Upper right edge of the rectangle
 * `a1` :
 * The start angle
 * `a2` :
 * The end angle
 * 
 * The resulting arc begins at `a1` and ends at `a2` degrees. Angles are interpreted
 * such that 0 degrees is at the 3 o'clock position. The center of the arc is the center
 * of the given rectangle.
 */
static VALUE fillarc(VALUE self, VALUE xmin,VALUE xmax,VALUE ymin,VALUE ymax,
                     VALUE a1, VALUE a2) {
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  int a1c = NUM2INT(a1);
  int a2c = NUM2INT(a2);
  gr_fillarc(xminc,xmaxc,yminc,ymaxc,a1c,a2c);
  
  return Qtrue;
}

/*static VALUE drawpath(VALUE self,VALUE,VALUE,VALUE,VALUE){
  gr_drawpath();
  return Qtrue;
}
requires a struct do that
*/

static VALUE setarrowstyle(VALUE self,VALUE style){
  int stylec = NUM2INT(style);
  gr_setarrowstyle(stylec);
  return Qtrue;
}

static VALUE setarrowsize(VALUE self,VALUE size){
  int sizec = NUM2INT(size);
  gr_setarrowsize(size);
  return Qtrue;
}

static VALUE drawarrow(VALUE self,VALUE x1,VALUE y1,VALUE x2,VALUE y2){
  double x1c = NUM2DBL(x1);
  double x2c = NUM2DBL(x2);
  double y1c = NUM2DBL(y1);
  double y2c = NUM2DBL(y2);
  gr_drawarrow(x1c,x2c,y1c,y2c);
  return Qtrue;
}

/*static VALUE readimage(VALUE self,VALUE,VALUE,VALUE,VALUE){
  gr_readimage();
  return Qtrue;
}
requires 2d array
*/

static VALUE drawimage(VALUE self,VALUE xmin,VALUE xmax,VALUE ymin,VALUE ymax,VALUE width,VALUE height,VALUE data,VALUE model){
  double xminc = NUM2DBL(xmin);
  double xmaxc = NUM2DBL(xmax);
  double yminc = NUM2DBL(ymin);
  double ymaxc = NUM2DBL(ymax);
  int widthc = NUM2INT(width);
  int heightc = NUM2INT(height);
  int *datac = rb_ar_2_int_ar(data);
  int modelc = NUM2INT(model);
  gr_drawimage(xminc,xmaxc,yminc,ymaxc,widthc,heightc,datac,modelc);
  return Qtrue;
}

static VALUE importgraphics(VALUE self,VALUE a){
  char *ac = StringValueCStr(a);
  return INT2NUM(gr_importgraphics(ac));
}

static VALUE setshadow(VALUE self,VALUE offsetx,VALUE offsety,VALUE blur){
  double offsetxc = NUM2DBL(offsetx);
  double offsetyc = NUM2DBL(offsety);
  double blurc = NUM2DBL(blur);
  gr_setshadow(offsetxc,offsetyc,blurc);
  return Qtrue;
}


/**
 * call-seq:
 *   Rubyplot::GR.settransparency(alpha) -> true
 *
 * Set the value of the alpha component associated with GR colors
 * 
 * **Parameters:**
 * 
 * `alpha` :
 * An alpha value (0.0 - 1.0)
 */
static VALUE settransparency(VALUE self,VALUE alpha){
  gr_settransparency(NUM2DBL(alpha));
  
  return Qtrue;
}

/*static VALUE setcoordxform(VALUE self,VALUE){
  gr_setcoordxform();
  return Qtrue;
} 2d matrix*/

static VALUE begingraphics(VALUE self,VALUE path){
  char *pathc = StringValueCStr(path);
  gr_begingraphics(pathc);
  return Qtrue;
}

static VALUE endgraphics(VALUE self){
  gr_endgraphics();
  return Qtrue;
}

static VALUE getgraphics(VALUE self){
  char *ac = gr_getgraphics();
  return rb_str_new2(ac);
}

static VALUE drawgraphics(VALUE self,VALUE a){
  char *ac = StringValueCStr(a);
  return INT2NUM(gr_drawgraphics(ac));
}

static VALUE mathtex(VALUE self,VALUE x,VALUE y,VALUE string){
  double xc = NUM2DBL(x);
  double yc = NUM2DBL(y);
  char *stringc=StringValueCStr(string);
  gr_mathtex(xc,yc,stringc);
  return Qtrue;
}

static VALUE inqmathtex(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d,VALUE e){
  double ac = NUM2DBL(a);
  double bc = NUM2DBL(b);
  char *cc = StringValueCStr(c);
  double *dc = rb_ar_2_dbl_ar(d);
  double *ec = rb_ar_2_dbl_ar(e);
  gr_inqmathtex(ac,bc,cc,dc,ec);
  return Qtrue;
}

static VALUE beginselection(VALUE self,VALUE a,VALUE b){
  int ac = NUM2INT(a);
  int bc = NUM2INT(b);
  gr_beginselection(ac,bc);
  return Qtrue;
}

static VALUE endselection(VALUE self){
  gr_endselection();
  return Qtrue;
}

static VALUE moveselection(VALUE self,VALUE a,VALUE b){
  double ac = NUM2DBL(a);
  double bc = NUM2DBL(b);
  gr_moveselection(ac,bc);
  return Qtrue;
}

static VALUE resizeselection(VALUE self,VALUE a,VALUE b,VALUE c){
  int ac = NUM2INT(a);
  double bc = NUM2DBL(b);
  double cc = NUM2DBL(c);
  gr_resizeselection(ac,bc,cc);
  return Qtrue;
}

static VALUE inqbbox(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d){
  double *ac = rb_ar_2_dbl_ar(a);
  double *bc = rb_ar_2_dbl_ar(b);
  double *cc = rb_ar_2_dbl_ar(c);
  double *dc = rb_ar_2_dbl_ar(d);
  gr_inqbbox(ac,bc,cc,dc);
  return Qtrue; 
}

static VALUE precision(VALUE self) {
  return DBL2NUM(gr_precision());
}

static VALUE setregenflags(VALUE self,VALUE a){
  int ac = NUM2INT(a);
  gr_setregenflags(ac);
  return Qtrue;
}

static VALUE inqregenflags(VALUE self){
  return INT2NUM(gr_inqregenflags());
}

static VALUE savestate(VALUE self){
  gr_savestate();
  return Qtrue;
}

static VALUE restorestate(VALUE self){
  gr_restorestate();
  return Qtrue;
}

static VALUE selectcontext(VALUE self,VALUE a){
  int ac = NUM2INT(a);
  gr_selectcontext(ac);
  return Qtrue;
}

static VALUE destroycontext(VALUE self,VALUE a){
  int ac = NUM2INT(a);
  gr_destroycontext(ac);
  return Qtrue;
}

static VALUE uselinespec(VALUE self,VALUE a){
  char *ac = StringValueCStr(a);
  return INT2NUM(gr_uselinespec(ac));
}

/*static VALUE delaunay(VALUE self,VALUE,VALUE,VALUE,VALUE,VALUE){
  gr_delaunay();
  return Qtrue;
}

static VALUE reducepoints(VALUE self,VALUE,VALUE,VALUE,VALUE,VALUE,VALUE){
  gr_reducepoints();
  return Qtrue;
}
*/
static VALUE trisurface(VALUE self,VALUE px,VALUE py,VALUE pz) {
  int x_size = RARRAY_LEN(px);
  int y_size = RARRAY_LEN(py);
  int z_size = RARRAY_LEN(pz);
  int sizec = (x_size <= y_size)?x_size:y_size;
  sizec = (sizec <= z_size)?sizec:z_size;
  double *xc = rb_ar_2_dbl_ar(px);
  double *yc = rb_ar_2_dbl_ar(py); 
  double *zc = rb_ar_2_dbl_ar(pz); 
  gr_trisurface(sizec,xc,yc,zc);
  return Qtrue;
}

static VALUE gradient(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d,VALUE e,
                      VALUE f,VALUE g){
  int ac = NUM2INT(a);
  int bc = NUM2INT(b);
  double *cc = rb_ar_2_dbl_ar(c);
  double *dc = rb_ar_2_dbl_ar(d);
  double *ec = rb_ar_2_dbl_ar(e);
  double *fc = rb_ar_2_dbl_ar(f);
  double *gc = rb_ar_2_dbl_ar(g);
  gr_gradient(ac,bc,cc,dc,ec,fc,gc);
  return Qtrue;
}

static VALUE quiver(VALUE self,VALUE a,VALUE b,VALUE c,VALUE d,VALUE e,
                    VALUE f,VALUE g){
  int ac = NUM2INT(a);
  int bc = NUM2INT(b);
  double *cc = rb_ar_2_dbl_ar(c);
  double *dc = rb_ar_2_dbl_ar(d);
  double *ec = rb_ar_2_dbl_ar(e);
  double *fc = rb_ar_2_dbl_ar(f);
  int gc = NUM2INT(g);
  gr_quiver(ac,bc,cc,dc,ec,fc,gc);
  return Qtrue;
}

static VALUE version(VALUE self){
  const char *verc=gr_version();
  return rb_str_new2(verc);
}

void Init_grruby()
{
  /* Module definitions. */
  VALUE mRubyplot = rb_define_module("Rubyplot");
  VALUE mGRruby  = rb_define_module_under(mRubyplot, "GR");
  VALUE mGR3ruby = rb_define_module_under(mRubyplot, "GR3");

  /* Function definitions. */
  rb_define_singleton_method(mGRruby,"opengks",opengks,0);
  rb_define_singleton_method(mGRruby,"closegks",closegks,0);
  rb_define_singleton_method(mGRruby,"inqdspsize",inqdspsize,4);
  rb_define_singleton_method(mGRruby,"openws",openws,3);
  rb_define_singleton_method(mGRruby,"closews",closews,1);
  rb_define_singleton_method(mGRruby,"activatews",activatews,1);
  rb_define_singleton_method(mGRruby,"deactivatews",deactivatews,1);
  rb_define_singleton_method(mGRruby,"clearws",clearws,0);
  rb_define_singleton_method(mGRruby,"updatews",updatews,0);
  rb_define_singleton_method(mGRruby,"polyline",polyline,2);
  rb_define_singleton_method(mGRruby,"polymarker",polymarker,2);
  rb_define_singleton_method(mGRruby,"text",text,3);
  rb_define_singleton_method(mGRruby,"inqtext",inqtext,5);
  rb_define_singleton_method(mGRruby,"fillarea",fillarea,2);
  rb_define_singleton_method(mGRruby,"cellarray",cellarray,11);
  rb_define_singleton_method(mGRruby,"gdp",gdp,6);
  rb_define_singleton_method(mGRruby,"spline",spline,5);
  rb_define_singleton_method(mGRruby,"gridit",gridit,9);
  rb_define_singleton_method(mGRruby,"setlinetype",setlinetype,1);
  rb_define_singleton_method(mGRruby,"inqlinetype",inqlinetype,1);
  rb_define_singleton_method(mGRruby,"setlinewidth",setlinewidth,1);
  rb_define_singleton_method(mGRruby,"inqlinewidth",inqlinewidth,1);
  rb_define_singleton_method(mGRruby,"setlinecolorind",setlinecolorind,1);
  rb_define_singleton_method(mGRruby,"inqlinecolorind",inqlinecolorind,1);
  rb_define_singleton_method(mGRruby,"setmarkertype",setmarkertype,1);
  rb_define_singleton_method(mGRruby,"inqmarkertype",inqmarkertype,1);
  rb_define_singleton_method(mGRruby,"setmarkersize",setmarkersize,1);
  rb_define_singleton_method(mGRruby,"setmarkercolorind",setmarkercolorind,1);
  rb_define_singleton_method(mGRruby,"inqmarkercolorind",inqmarkercolorind,1);
  rb_define_singleton_method(mGRruby,"settextfontprec",settextfontprec,2);
  rb_define_singleton_method(mGRruby,"setcharexpan",setcharexpan,1);
  rb_define_singleton_method(mGRruby,"setcharspace",setcharspace,1);
  rb_define_singleton_method(mGRruby,"settextcolorind",settextcolorind,1);
  rb_define_singleton_method(mGRruby,"setcharheight",setcharheight,1);
  rb_define_singleton_method(mGRruby,"setcharup",setcharup,2);
  rb_define_singleton_method(mGRruby,"settextpath",settextpath,1);
  rb_define_singleton_method(mGRruby,"settextalign",settextalign,2);
  rb_define_singleton_method(mGRruby,"setfillintstyle",setfillintstyle,1);
  rb_define_singleton_method(mGRruby,"setfillstyle",setfillstyle,1);
  rb_define_singleton_method(mGRruby,"setfillcolorind",setfillcolorind,1);
  rb_define_singleton_method(mGRruby,"setcolorrep",setcolorrep,4);
  rb_define_singleton_method(mGRruby,"setwindow",setwindow,4);
  rb_define_singleton_method(mGRruby,"inqwindow",inqwindow,4);
  rb_define_singleton_method(mGRruby,"setviewport",setviewport,4);
  rb_define_singleton_method(mGRruby,"inqviewport",inqviewport,4);
  rb_define_singleton_method(mGRruby,"selntran",selntran,1);
  rb_define_singleton_method(mGRruby,"setclip",setclip,1);
  rb_define_singleton_method(mGRruby,"setwswindow",setwswindow,4);
  rb_define_singleton_method(mGRruby,"setwsviewport",setwsviewport,4);
  rb_define_singleton_method(mGRruby,"createseg",createseg,1);
  rb_define_singleton_method(mGRruby,"copysegws",copysegws,1);
  rb_define_singleton_method(mGRruby,"redrawsegws",redrawsegws,0);
  rb_define_singleton_method(mGRruby,"setsegtran",setsegtran,8);
  rb_define_singleton_method(mGRruby,"closeseg",closeseg,0);
  rb_define_singleton_method(mGRruby,"emergencyclosegks",emergencyclosegks,0);
  rb_define_singleton_method(mGRruby,"updategks",updategks,0);
  rb_define_singleton_method(mGRruby,"setspace",setspace,4);
  rb_define_singleton_method(mGRruby,"inqspace",inqspace,4);
  rb_define_singleton_method(mGRruby,"setscale",setscale,1);
  rb_define_singleton_method(mGRruby,"inqscale",inqscale,1);
  rb_define_singleton_method(mGRruby,"textext",textext,3);
  rb_define_singleton_method(mGRruby,"inqtextext",inqtextext,5);
  rb_define_singleton_method(mGRruby,"axes",axes,7);
  rb_define_singleton_method(mGRruby,"axeslbl",axeslbl, 9);
  rb_define_singleton_method(mGRruby,"grid",grid,6);
  rb_define_singleton_method(mGRruby,"grid3d",grid3d,9);
  rb_define_singleton_method(mGRruby,"verrorbars",verrorbars,4);
  rb_define_singleton_method(mGRruby,"herrorbars",herrorbars,4);
  rb_define_singleton_method(mGRruby,"polyline3d",polyline3d,3);
  rb_define_singleton_method(mGRruby,"polymarker3d",polymarker3d,3);
  rb_define_singleton_method(mGRruby,"axes3d",axes3d,10);
  rb_define_singleton_method(mGRruby,"titles3d",titles3d,3);
  rb_define_singleton_method(mGRruby,"surface",surface,4);
  rb_define_singleton_method(mGRruby,"contour",contour,5);
  rb_define_singleton_method(mGRruby,"tricontour",tricontour,6);
  rb_define_singleton_method(mGRruby,"hexbin",hexbin,4);
  rb_define_singleton_method(mGRruby,"setcolormap",setcolormap,1);
  rb_define_singleton_method(mGRruby,"inqcolormap",inqcolormap,1);
  rb_define_singleton_method(mGRruby,"colorbar",colorbar,0);
  rb_define_singleton_method(mGRruby,"inqcolor",inqcolor,2);
  rb_define_singleton_method(mGRruby,"inqcolorfromrgb",inqcolorfromrgb,3);
  rb_define_singleton_method(mGRruby,"hsvtorgb",hsvtorgb,6);
  rb_define_singleton_method(mGRruby,"tick",tick,2);
  rb_define_singleton_method(mGRruby,"validaterange",validaterange,2);
  rb_define_singleton_method(mGRruby,"adjustlimits",adjustlimits,2);
  rb_define_singleton_method(mGRruby,"adjustrange",adjustrange,2);
  rb_define_singleton_method(mGRruby,"beginprint",beginprint,1);
  rb_define_singleton_method(mGRruby,"beginprintext",beginprintext,4);
  rb_define_singleton_method(mGRruby,"endprint",endprint,0);
  rb_define_singleton_method(mGRruby,"ndctowc",ndctowc,2);
  rb_define_singleton_method(mGRruby,"wctondc",wctondc,2);
  rb_define_singleton_method(mGRruby,"wc3towc",wc3towc,3);
  rb_define_singleton_method(mGRruby,"drawrect",drawrect,4);
  rb_define_singleton_method(mGRruby,"fillrect",fillrect,4);
  rb_define_singleton_method(mGRruby,"drawarc",drawarc,6);
  rb_define_singleton_method(mGRruby,"fillarc",fillarc,6);
  rb_define_singleton_method(mGRruby,"setarrowstyle",setarrowstyle,1);
  rb_define_singleton_method(mGRruby,"setarrowsize",setarrowsize,1);
  rb_define_singleton_method(mGRruby,"drawarrow",drawarrow,4);
  rb_define_singleton_method(mGRruby,"drawimage",drawimage,8);
  rb_define_singleton_method(mGRruby,"importgraphics",importgraphics,1);
  rb_define_singleton_method(mGRruby,"setshadow",setshadow,3);
  rb_define_singleton_method(mGRruby,"settransparency",settransparency,1);
  rb_define_singleton_method(mGRruby,"begingraphics",begingraphics,1);
  rb_define_singleton_method(mGRruby,"endgraphics",endgraphics,0);
  rb_define_singleton_method(mGRruby,"getgraphics",getgraphics,0);
  rb_define_singleton_method(mGRruby,"drawgraphics",drawgraphics,1);
  rb_define_singleton_method(mGRruby,"mathtex",mathtex,3);
  rb_define_singleton_method(mGRruby,"inqmathtex",inqmathtex,5);
  rb_define_singleton_method(mGRruby,"beginselection",beginselection,2);
  rb_define_singleton_method(mGRruby,"endselection",endselection,0);
  rb_define_singleton_method(mGRruby,"moveselection",moveselection,2);
  rb_define_singleton_method(mGRruby,"resizeselection",resizeselection,3);
  rb_define_singleton_method(mGRruby,"inqbbox",inqbbox,4);
  rb_define_singleton_method(mGRruby,"precision",precision,0);
  rb_define_singleton_method(mGRruby,"setregenflags",setregenflags,1);
  rb_define_singleton_method(mGRruby,"inqregenflags",inqregenflags,0);
  rb_define_singleton_method(mGRruby,"savestate",savestate,0);
  rb_define_singleton_method(mGRruby,"restorestate",restorestate,0);
  rb_define_singleton_method(mGRruby,"selectcontext",selectcontext,1);
  rb_define_singleton_method(mGRruby,"destroycontext",destroycontext,1);
  rb_define_singleton_method(mGRruby,"uselinespec",uselinespec,1);
  rb_define_singleton_method(mGRruby,"trisurface",trisurface,3);
  rb_define_singleton_method(mGRruby,"gradient",gradient,7);
  rb_define_singleton_method(mGRruby,"quiver",quiver,7);
  rb_define_singleton_method(mGRruby,"version",version,0);

  /* Constants */
  rb_define_const(mGRruby, "TEXT_HALIGN_NORMAL", DBL2NUM(0));
  rb_define_const(mGRruby, "TEXT_HALIGN_LEFT", DBL2NUM(1));
  rb_define_const(mGRruby, "TEXT_HALIGN_CENTER", DBL2NUM(2));
  rb_define_const(mGRruby, "TEXT_HALIGN_RIGHT", DBL2NUM(3));

  rb_define_const(mGRruby, "TEXT_VALIGN_NORMAL", DBL2NUM(0));
  rb_define_const(mGRruby, "TEXT_VALIGN_TOP", DBL2NUM(1));
  rb_define_const(mGRruby, "TEXT_VALIGN_CAP", DBL2NUM(2));
  rb_define_const(mGRruby, "TEXT_VALIGN_HALF", DBL2NUM(3));
  rb_define_const(mGRruby, "TEXT_VALIGN_BASE", DBL2NUM(4));
  rb_define_const(mGRruby, "TEXT_VALIGN_BOTTOM", DBL2NUM(5));
    
  rb_define_const(mGRruby, "FONT_TIMES_ROMAN", DBL2NUM(101));
  rb_define_const(mGRruby, "FONT_TIMES_ITALIC", DBL2NUM(102));
  rb_define_const(mGRruby, "FONT_TIMES_BOLD", DBL2NUM(103));
  rb_define_const(mGRruby, "FONT_TIMES_BOLD_ITALIC", DBL2NUM(104));
  rb_define_const(mGRruby, "FONT_HELVETICA", DBL2NUM(105));
  rb_define_const(mGRruby, "FONT_HELVETICA_OBLIQUE", DBL2NUM(106));
  rb_define_const(mGRruby, "FONT_HELVETICA_BOLD", DBL2NUM(107));
  rb_define_const(mGRruby, "FONT_HELVETICA_BOLD_OBLIQUE", DBL2NUM(108));
  rb_define_const(mGRruby, "FONT_COURIER", DBL2NUM(109));
  rb_define_const(mGRruby, "FONT_COURIER_OBLIQUE", DBL2NUM(110));
  rb_define_const(mGRruby, "FONT_COURIER_BOLD", DBL2NUM(111));
  rb_define_const(mGRruby, "FONT_COURIER_BOLD_OBLIQUE", DBL2NUM(112));
  rb_define_const(mGRruby, "FONT_SYMBOL", DBL2NUM(113));
  rb_define_const(mGRruby, "FONT_BOOKMAN_LIGHT", DBL2NUM(114));
  rb_define_const(mGRruby, "FONT_BOOKMAN_LIGHT_ITALIC", DBL2NUM(115));
  rb_define_const(mGRruby, "FONT_BOOKMAN_DEMI", DBL2NUM(116));
  rb_define_const(mGRruby, "FONT_BOOKMAN_DEMI_ITALIC", DBL2NUM(117));
  rb_define_const(mGRruby, "FONT_NEWCENTURYSCHLBK_ROMAN", DBL2NUM(118));
  rb_define_const(mGRruby, "FONT_NEWCENTURYSCHLBK_ITALIC", DBL2NUM(119));
  rb_define_const(mGRruby, "FONT_NEWCENTURYSCHLBK_BOLD", DBL2NUM(120));
  rb_define_const(mGRruby, "FONT_NEWCENTURYSCHLBK_BOLD_ITALIC", DBL2NUM(121));
  rb_define_const(mGRruby, "FONT_AVANTGARDE_BOOK", DBL2NUM(122));
  rb_define_const(mGRruby, "FONT_AVANTGARDE_BOOK_OBLIQUE", DBL2NUM(123));
  rb_define_const(mGRruby, "FONT_AVANTGARDE_DEMI", DBL2NUM(124));
  rb_define_const(mGRruby, "FONT_AVANTGARDE_DEMI_OBLIQUE", DBL2NUM(125));
  rb_define_const(mGRruby, "FONT_PALATINO_ROMAN", DBL2NUM(126));
  rb_define_const(mGRruby, "FONT_PALATINO_ITALIC", DBL2NUM(127));
  rb_define_const(mGRruby, "FONT_PALATINO_BOLD", DBL2NUM(128));
  rb_define_const(mGRruby, "FONT_PALATINO_BOLD_ITALIC", DBL2NUM(129));
  rb_define_const(mGRruby, "FONT_ZAPFCHANCERY_MEDIUM_ITALIC", DBL2NUM(130));
  rb_define_const(mGRruby, "FONT_ZAPFDINGBATS", DBL2NUM(131));
  
  rb_define_const(mGRruby, "TEXT_PRECISION_STRING", DBL2NUM(0));
  rb_define_const(mGRruby, "TEXT_PRECISION_CHAR", DBL2NUM(1));
  rb_define_const(mGRruby, "TEXT_PRECISION_STROKE", DBL2NUM(2));

  rb_define_const(mGRruby, "TEXT_PATH_RIGHT", DBL2NUM(0));
  rb_define_const(mGRruby, "TEXT_PATH_LEFT", DBL2NUM(1));
  rb_define_const(mGRruby, "TEXT_PATH_UP", DBL2NUM(2));
  rb_define_const(mGRruby, "TEXT_PATH_DOWN", DBL2NUM(3));
  
  rb_define_const(mGRruby, "MARKERTYPE_DOT", DBL2NUM(1));
  rb_define_const(mGRruby, "MARKERTYPE_PLUS", DBL2NUM(2));
  rb_define_const(mGRruby, "MARKERTYPE_ASTERISK", DBL2NUM(3));
  rb_define_const(mGRruby, "MARKERTYPE_CIRCLE", DBL2NUM(4));
  rb_define_const(mGRruby, "MARKERTYPE_DIAGONAL_CROSS", DBL2NUM(5));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_CIRCLE", DBL2NUM(-1));
  rb_define_const(mGRruby, "MARKERTYPE_TRIANGLE_UP", DBL2NUM(-2));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_TRI_UP", DBL2NUM(-3));
  rb_define_const(mGRruby, "MARKERTYPE_TRIANGLE_DOWN", DBL2NUM(-4));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_TRI_DOWN", DBL2NUM(-5));
  rb_define_const(mGRruby, "MARKERTYPE_SQUARE", DBL2NUM(-6));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_SQUARE", DBL2NUM(-7));
  rb_define_const(mGRruby, "MARKERTYPE_BOWTIE", DBL2NUM(-8));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_BOWTIE", DBL2NUM(-9));
  rb_define_const(mGRruby, "MARKERTYPE_HGLASS", DBL2NUM(-10));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_HGLASS", DBL2NUM(-11));
  rb_define_const(mGRruby, "MARKERTYPE_DIAMOND", DBL2NUM(-12));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_DIAMOND", DBL2NUM(-13));
  rb_define_const(mGRruby, "MARKERTYPE_STAR", DBL2NUM(-14));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_STAR", DBL2NUM(-15));
  rb_define_const(mGRruby, "MARKERTYPE_TRI_UP_DOWN", DBL2NUM(-16));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_TRI_RIGHT", DBL2NUM(-17));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_TRI_LEFT", DBL2NUM(-18));
  rb_define_const(mGRruby, "MARKERTYPE_HOLLOW_PLUS", DBL2NUM(-19));
  rb_define_const(mGRruby, "MARKERTYPE_SOLID_PLUS", DBL2NUM(-20));
  rb_define_const(mGRruby, "MARKERTYPE_PENTAGON", DBL2NUM(-21));
  rb_define_const(mGRruby, "MARKERTYPE_HEXAGON", DBL2NUM(-22));
  rb_define_const(mGRruby, "MARKERTYPE_HEPTAGON", DBL2NUM(-23));
  rb_define_const(mGRruby, "MARKERTYPE_OCTAGON", DBL2NUM(-24));
  rb_define_const(mGRruby, "MARKERTYPE_STAR_4", DBL2NUM(-25));
  rb_define_const(mGRruby, "MARKERTYPE_STAR_5", DBL2NUM(-26));
  rb_define_const(mGRruby, "MARKERTYPE_STAR_6", DBL2NUM(-27));
  rb_define_const(mGRruby, "MARKERTYPE_STAR_7", DBL2NUM(-28));
  rb_define_const(mGRruby, "MARKERTYPE_STAR_8", DBL2NUM(-29));
  rb_define_const(mGRruby, "MARKERTYPE_VLINE", DBL2NUM(-30));
  rb_define_const(mGRruby, "MARKERTYPE_HLINE", DBL2NUM(-31));
  rb_define_const(mGRruby, "MARKERTYPE_OMARK", DBL2NUM(-32));
  
  rb_define_const(mGRruby, "LINETYPE_SOLID", DBL2NUM(1));
  rb_define_const(mGRruby, "LINETYPE_DASHED", DBL2NUM(2));
  rb_define_const(mGRruby, "LINETYPE_DOTTED", DBL2NUM(3));
  rb_define_const(mGRruby, "LINETYPE_DASHED_DOTTED", DBL2NUM(4));
  rb_define_const(mGRruby, "LINETYPE_DASH_2_DOT", DBL2NUM(-1));
  rb_define_const(mGRruby, "LINETYPE_DASH_3_DOT", DBL2NUM(-2));
  rb_define_const(mGRruby, "LINETYPE_LONG_DASH", DBL2NUM(-3));
  rb_define_const(mGRruby, "LINETYPE_LONG_SHORT_DASH", DBL2NUM(-4));
  rb_define_const(mGRruby, "LINETYPE_SPACED_DASH", DBL2NUM(-5));
  rb_define_const(mGRruby, "LINETYPE_SPACED_DOT", DBL2NUM(-6));
  rb_define_const(mGRruby, "LINETYPE_DOUBLE_DOT", DBL2NUM(-7));
  rb_define_const(mGRruby, "LINETYPE_TRIPLE_DOT", DBL2NUM(-8));
  
  rb_define_const(mGRruby, "FILLSTYLE_HOLLOW", DBL2NUM(0));
  rb_define_const(mGRruby, "FILLSTYLE_SOLID", DBL2NUM(1));
  rb_define_const(mGRruby, "FILLSTYLE_PATTERN", DBL2NUM(2));
  rb_define_const(mGRruby, "FILLSTYLE_HATCH", DBL2NUM(3));
}
