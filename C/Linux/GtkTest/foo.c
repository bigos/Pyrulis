#include <stdio.h>
#include <gtk/gtk.h>

static void
activate (GtkApplication* app,
          gpointer        user_data)
{
    GtkWidget *window;

    window = gtk_application_window_new (app);
    gtk_window_set_title (GTK_WINDOW (window), "Window of shared library");
    gtk_window_set_default_size (GTK_WINDOW (window), 400, 200);
    gtk_widget_show_all (window);
}

int
mainz (void)
{
    int    argc = 0;
    char **argv = 0;

    GtkApplication *app;
    int status;

    app = gtk_application_new ("org.gtk.example", G_APPLICATION_FLAGS_NONE);
    g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
    status = g_application_run (G_APPLICATION (app), argc, argv);
    g_object_unref (app);

    return status;
}

void foo(void)
{
    puts("Hello, I am a shared library");
    mainz();
}
