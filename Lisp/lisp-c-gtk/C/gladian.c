#include <gtk/gtk.h>

/*
   https://developer.gnome.org/gtk3/stable/GtkBuilder.html
   https://de.wikibooks.org/wiki/GTK_mit_Builder:_Builder
   https://developer.gnome.org/gnome-devel-demos/stable/c.html.en
*/

int
foo (int   argc,
      char ** argv)
{
  GtkBuilder *builder;

  GtkWidget *window;

  gtk_init (&argc, &argv);

  /* Construct a GtkBuilder instance and load our UI description */
  builder = gtk_builder_new_from_file("/home/jacek/Programming/Pyrulis/Lisp/lisp-c-gtk/C/Glade.glade");


  window = GTK_WIDGET(gtk_builder_get_object (builder, "main-window"));
  gtk_builder_connect_signals(builder, NULL);

  quit_button = GTK_WIDGET(gtk_builder_get_object (builder, "quit"));

  g_signal_connect (button, "clicked", G_CALLBACK(on_button_clicked), NULL);

  g_object_unref(builder);

  gtk_widget_show_all(window);

  gtk_main ();
  return 0;
}
