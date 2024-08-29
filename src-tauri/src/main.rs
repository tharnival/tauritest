// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

#[tauri::command]
fn increment(current: f64) -> f64 {
  current + 1f64
}

#[tauri::command]
fn decrement(current: f64) -> f64 {
  current - 1f64
}

fn main() {
  tauri::Builder::default()
    .invoke_handler(tauri::generate_handler![increment, decrement])
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}
