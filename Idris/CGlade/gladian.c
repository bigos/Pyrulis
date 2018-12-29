#include <gtk/gtk.h>
#include <gladeui/glade.h>

void some_signal_handler_func(GtkWidget *widget, gpointer user_data) {
    /* do something useful here */
}

/* dead end - lack of contemporary tutorials */
int main(int argc, char *argv[]) {
    struct GladeProject *gp;

    gtk_init(&argc, &argv);

    gp = glade_project_new();

    /* load the interface */
    glade_project_load_from_file(*gp, "/home/jacek/Programming/Pyrulis/Idris/CGlade/gladian.glade");

    /* start the event loop */
    gtk_main();

    return 0;
}
