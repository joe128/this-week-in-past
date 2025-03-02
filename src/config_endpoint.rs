use std::env;

use crate::config;
use actix_web::get;
use actix_web::HttpResponse;

#[get("interval/slideshow")]
pub async fn get_slideshow_interval() -> HttpResponse {
    HttpResponse::Ok()
        .content_type("plain/text")
        .body(config::get_slideshow_interval_value().to_string())
}

#[get("interval/refresh")]
pub async fn get_refresh_interval() -> HttpResponse {
    HttpResponse::Ok()
        .content_type("plain/text")
        .body(config::get_refresh_interval_value().to_string())
}

#[get("show-hide-button")]
pub async fn get_hide_button_enabled() -> HttpResponse {
    HttpResponse::Ok()
        .content_type("plain/text")
        .body(env::var("SHOW_HIDE_BUTTON").unwrap_or_else(|_| "false".to_string()))
}

#[get("random-slideshow")]
pub async fn get_random_slideshow_enabled() -> HttpResponse {
    HttpResponse::Ok()
        .content_type("plain/text")
        .body(env::var("RANDOM_SLIDESHOW").unwrap_or_else(|_| "false".to_string()))
}

#[get("preload-images")]
pub async fn get_preload_images_enabled() -> HttpResponse {
    HttpResponse::Ok()
        .content_type("plain/text")
        .body(env::var("PRELOAD_IMAGES").unwrap_or_else(|_| "false".to_string()))
}
