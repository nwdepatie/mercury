mod pynq;
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() == 2 {
        println!("Received argument: {}", args[1]);
    } else {
        eprintln!("This program requires exactly one argument.");
        std::process::exit(1);
    }

    println!("{}", &args[1]);

	pynq::load_bitstream(&args[1], &[pynq::Clock{ div0: 5, div1: 2 }]).unwrap();
}