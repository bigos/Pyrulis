// function experiment -  calling by reference

// define delegate for the method
static delegate void Delegate_myfun (int a);

void myfun(int a) {
	stdout.printf("booo %d\n", a);
}

// wrapper for calling myfun by reference
void call_that(Delegate_myfun fn, int a) {
	fn (a);
}

int main() {
	call_that(myfun, 12345);

	
	return 0;
}
