// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::sync::mpsc;
use tauri::{Manager, State};
use tauri::api::process::{Command, CommandEvent};

struct Window {
  main: tauri::Window,
}

#[tauri::command]
fn increment(current: f64) -> f64 {
  current + 1f64
}

#[tauri::command]
fn decrement(current: f64) -> f64 {
  current - 1f64
}

#[tauri::command]
fn minimize(window: State<Window>) {
  let _ = window.main.minimize();
}

#[tauri::command]
fn svn() -> String {
  let (mut scrx, mut _child) = Command::new_sidecar("svn")
    .map(|cmd| cmd.args(["status"]))
    .expect("Failed to create 'svn' binary command")
    .spawn()
    .expect("Failed to spawn sidecar");

  let (tx, rx) = mpsc::channel();
  tauri::async_runtime::spawn(async move {
    let mut output = "".to_string();
    while let Some(event) = scrx.recv().await {
      if let CommandEvent::Stderr(line) = event {
        output.push_str(&line);
      } else if let CommandEvent::Stdout(line) = event {
        output.push_str(&line);
      }
    }
    tx.send(output)
  });

  rx.recv().unwrap_or("".to_string())
}

fn main() {
  tauri::Builder::default()
    .setup(|app| {
      let main_window = app.get_window("main").unwrap();
      app.manage(Window { main: main_window });
      Ok(())
    })
    .invoke_handler(tauri::generate_handler![
      increment,
      decrement,
      minimize,
      svn
    ])
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}
