// file2.rs

use std::env;
use std::fs::File;
use std::io;
use std::io::Read;

// this is example showing what standard library is doing
// and explains error handling
fn read_to_string(filename: &str) -> Result<String, io::Error> {
    let mut file = match File::open(&filename) {
        Ok(f) => f,
        Err(e) => return Err(e),
    };
    let mut text = String::new();
    match file.read_to_string(&mut text) {
        Ok(_) => Ok(text),
        Err(e) => Err(e),
    }
}

// fortunately Rust provides shortcut for the above

fn read_to_string_shortcut(filename: &str) -> io::Result<String> {
    let mut file = File::open(&filename)?;
    let mut text = String::new();
    file.read_to_string(&mut text)?;
    Ok(text)
}

fn main() {
    let file = env::args().nth(1).expect("please supply a filename");
    let text = read_to_string(&file).expect("bad filename");
    println!("file had {} bytes", text.len());
}
