#include <gtk/gtk.h>

int myMult(int x, int y, int (* cba)()) {
    int res = x * y;
    printf("%d\n", res);

    printf("callbacked %d\n", (cba)(3));

    return (res * 2);
}

void b2_quit(a, b) {
    printf("this is proper quit\n");
    gtk_main_quit ();
}

void bt1_click(a, b) {
    printf("\nyou have clicked button 1 - good bye\n\n\n");

}

int zzz ()
{
    int status = 0;

    int argc = 0;
    char **argv = (char *[]){"hello", "world"};

    GtkBuilder *builder;
    GtkWidget  *window;
    GError     *error = NULL;

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
    window = GTK_WIDGET( gtk_builder_get_object( builder, "w1" ) );
    g_signal_connect(G_OBJECT(window),
                     "destroy", b2_quit, NULL);

    /* Connect signals */
    gtk_builder_connect_signals( builder, NULL );

    /* Destroy builder, since we don't need it anymore */
    g_object_unref( G_OBJECT( builder ) );

    /* Show window. All other widgets are automatically shown by GtkBuilder */
    gtk_widget_show( window );

    /* Start main loop */
    gtk_main();

    return status;
}
