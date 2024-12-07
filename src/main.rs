/****main.rs****/
use std::env::*;
use std::fs::*;
use std::io::{BufRead, BufReader, Write};
#[derive(Clone)]
struct Config {
    text: Vec<String>,
    line: i32,
}
impl Config {
    fn new() -> Config {
        Config {
            text: Vec::new(),
            line: 0,
        }
    }
}
fn all_mk(config: &Config) {
    let mut path:String = String::new(); //
    let mut content = Vec::new(); // 
    let mut writing = false; // ファイル書き込み中かどうかを示すフラグ

    for text in &config.text {
        let trimmed_text = text.trim();

        if trimmed_text.starts_with(":w ") {
            if writing {
                // ファイル書き込み中の場合は内容を書き込んでリセット
                let mut file = File::create(path).unwrap();
                file.write_all(&content).unwrap();
                content.clear();
            }

            path = trimmed_text.trim_start_matches(":w ").trim().to_string();
            writing = true; // ファイル書き込み中に設定
        } else if trimmed_text == ":e" {
            if writing {
                let mut file = File::create(path).unwrap();
                file.write_all(&content).unwrap();
                path = "".to_string();
                content.clear();
                writing = false; // ファイル書き込み完了でリセット
            }
        } else {
            if path.is_empty() {
                path = trimmed_text.trim().to_string();
                if path.ends_with("/") {
                    match create_dir_all(path.clone()) {
                        Ok(_) => println!("{} directory created", path),
                        Err(err) => println!("{} directory creation failed: {}", path, err),
                    }
                    path = "".to_string();
                } else {
                    // ファイル名を取得して、書き込みフラグを立てる
                    if let Some(parent) = std::path::Path::new(&path).parent() {
                        if let Some(parent_str) = parent.to_str() {
                            if let Some(file_name) = std::path::Path::new(trimmed_text).file_name() {
                                let file_name = file_name.to_str().unwrap();
                                let full_path = format!("{}/{}", parent_str, file_name);
                                path = full_path;
                                writing = true;
                            }
                        }
                    }
                    path = "".to_string();
                }
                continue;
            }
            content.extend_from_slice(trimmed_text.as_bytes());
            content.push(b'\n');
        }
    }
}
fn main() {
    let args: Vec<String> = args().collect();
    let default_args: String = String::from("not found mkFiles");
    let path = args.get(1).unwrap_or(&default_args);
    let mut file = File::open(&path);
    if !path.is_empty() {
        file = File::open(path);
    }
    match file {
        Ok(val) => {
            let mut reader = BufReader::new(val);
            let mut conf = Config::new();
            let mut file_line = String::new();
            let mut line = 0;
            loop {
                file_line.clear();
                let file_len = reader.read_line(&mut file_line).unwrap();
                if file_len == 0 {
                    break;
                }
                line += 1;
                conf.line = line;
                conf.text.push(file_line.clone());
            }
            all_mk(&conf);
            println!("text:{:?} line:{:?}", conf.text, conf.line);
        }
        Err(err) => {
            println!("{}", err);
        }
    }
}
