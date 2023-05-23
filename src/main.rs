use warp::{Filter, Rejection, Reply};

type Result<T> = std::result::Result<T, Rejection>;

#[tokio::main]
async fn main() {
    let health_route = warp::path!("health").and_then(health_handler);
    let routes = health_route.with(warp::cors().allow_any_origin());
    println!("Started server at localhost:8001");
    warp::serve(routes).run(([0, 0, 0, 0], 8001)).await;
}

async fn health_handler() -> Result<impl Reply> {
    Ok("Ok")
}
