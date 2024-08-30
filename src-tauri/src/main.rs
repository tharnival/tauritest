// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::{Manager, State};

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
      minimize
    ])
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}
