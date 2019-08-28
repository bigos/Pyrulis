public class MyApp : Gtk.Application {
	public MyApp () {
		Object (
			application_id : "some.random.string",
			flags : ApplicationFlags.FLAGS_NONE
			);
	}

	protected override void activate () {
		var main_window = new Gtk.ApplicationWindow (this);
		main_window.default_height = 300;
		main_window.default_width = 300;
		main_window.title = "Hello World";
		main_window.show_all ();
	}

	public static int main(string[] args) {
		var app = new MyApp ();
		return app.run (args);	
	}
}

// run with
// vala --pkg gtk+-3.0 ./Application.vala 
