package main

import (
	"fmt"
	"utils"
)

func main() {
	a := Person{"John"}
	b := Person{"Emma"}
	fmt.Println(a.Greeting(b))
	fmt.Println(AddThese(1, 2))
}
