package main

import "fmt"

func main() {
	a := Person{"John"}
	b := Person{"Emma"}
	fmt.Println(a.Greeting(b))
}
