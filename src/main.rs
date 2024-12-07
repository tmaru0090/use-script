
use std::env;
use std::fs::File;
use std::io::Write;

fn main() -> Result<(), String> {
    let args: Vec<String> = env::args().skip(1).collect();

    let flag = if args.len() > 0 { &args[0] } else { "--default" };

    match flag {
        "--out" => {
            let mut file = File::create("env-lists.txt").unwrap();
            println!("--env-lists--");
            for (key, value) in env::vars() {
                println!("{} {}", key, value);
                file.write_all(format!("{} {}\n", key, value).as_bytes())
                    .unwrap();
            }
        }
        "--default" => {
            println!("--env-lists--");
            for (key, value) in env::vars() {
                println!("{} {}", key, value);
            }
        }
        _ => {
        }
    }
    Ok(())
}
