class HelloName : GLib.Object {
	public static int main(string[] args) {
		stdout.printf("Hello, what is your name? ");
		string input = stdin.read_line().strip();		
		string response = @"Hi $input, it's nice to meet you";
		stdout.printf("%s\n", response);
		return 0;
	}
}

// running
// vala ./hello-name.vala 
