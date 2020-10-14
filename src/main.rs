use warp::{Filter};

#[tokio::main]
async fn main() {
    let health_route = warp::path::end()
        .map(|| "Hello, World!");

    let routes = health_route.with(warp::cors().allow_any_origin());

    println!("Started server at localhost:8000");
    warp::serve(routes).run(([0, 0, 0, 0], 8000)).await;
}

// async fn health_handler() -> Result<impl Reply> {
//     Ok("OK12")
// }

// async fn health_all_handler() -> Result<impl Reply> {
//     Ok("OK")
// }