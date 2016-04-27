package main

import "fmt"

type Person struct {
	name string
}

func (p Person) Name() string {
	return p.name
}

func (p Person) Greeting(q Person) string {
	return fmt.Sprintf("Hello %s, I'm %s\n", q.Name(), p.Name())
	// Notice we don't have to use getters, even on the other object:
	// return fmt.Sprintf("Hello %s, I'm %s\n", q.name, p.name)
}
