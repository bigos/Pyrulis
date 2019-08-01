#include <gtk/gtk.h>

int myMult(int x, int y, int (* cba)()) {
    int res = x * y;
    printf("%d\n", res);

    printf("callbacked %d\n", (cba)(3));

    return (res * 2);
}

void b2_quit(GtkWidget *widget, gpointer data) {
    printf("this is proper quit\n");
    gtk_main_quit ();
}

void bt1_click(GtkWidget *widget, gpointer data) {
    printf("\nyou have clicked button 1 - well done\n\n\n");

}

void tryUI(GtkBuilder *builder) {
    GtkWidget  *b1;
    GtkWidget  *b2;

    b1 =  GTK_WIDGET( gtk_builder_get_object( builder, "b1" ) );
    g_signal_connect(G_OBJECT(b1),
                     "clicked", G_CALLBACK(bt1_click), NULL);

    b2 =  GTK_WIDGET( gtk_builder_get_object( builder, "b2" ) );
    g_signal_connect(G_OBJECT(b2),
                     "clicked", G_CALLBACK(b2_quit), NULL);
}

int zzz ()
{
    int status = 0;

    int argc = 0;
    char **argv = (char *[]){"hello", "world"};

    GtkBuilder *builder;
    GError     *error = NULL;

    GtkWidget  *w1;

    /* Init Gtk3 */
    gtk_init( &argc, &argv);

    /* Create new GtkBuilder object */
    builder = gtk_builder_new();
    /* Load UI from file. If error occurs, report it and quit application.
     * Replace "tut.glade" with your saved project. */
    if( ! gtk_builder_add_from_file( builder, "ui.glade", &error ) )
    {
        g_warning( "%s", error->message );
        g_free( error );
        return( 1 );
    }

    /* Get main window pointer from UI */
    w1 = GTK_WIDGET( gtk_builder_get_object( builder, "w1" ) );
    g_signal_connect(G_OBJECT(w1),
                     "destroy", G_CALLBACK(b2_quit), NULL);

    tryUI(builder);

    /* Destroy builder, since we don't need it anymore */
    g_object_unref( G_OBJECT( builder ) );

    /* Show window */
    gtk_widget_show( w1 );

    /* Start main loop */
    gtk_main();

    return status;
}
