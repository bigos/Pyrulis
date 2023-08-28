use std::env;

fn main() {
    println!("Hello, everyone!");
    println!("This is my first Rust program");
    println!("");
    println!("The args are:");
    let argz = env::args_os();
    println!("{:?}", argz);
}
