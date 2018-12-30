#include <gtk/gtk.h>

/*
   https://developer.gnome.org/gtk3/stable/GtkBuilder.html
   https://de.wikibooks.org/wiki/GTK_mit_Builder:_Builder
   https://developer.gnome.org/gnome-devel-demos/stable/c.html.en
*/

int
main (int   argc,
      char *argv[])
{
  GtkBuilder *builder;
  GObject *window;

  gtk_init (&argc, &argv);

  /* Construct a GtkBuilder instance and load our UI description */
  builder = gtk_builder_new_from_file("/home/jacek/Programming/Pyrulis/Idris/CGlade/gladian.glade");
  window = gtk_builder_get_object(builder, "main-window");
  gtk_builder_connect_signals(builder, NULL);
  g_object_unref(builder);

  gtk_widget_show(window);
  gtk_main ();
  return 0;
}
