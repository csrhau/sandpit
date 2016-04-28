package main

import (
	"fmt"
	"github.com/kidoman/embd"
	"github.com/kidoman/embd/convertors/mcp3008"
	_ "github.com/kidoman/embd/host/bbb"
	"time"
)

const (
	spi_speed = 1000000
	spi_delay = 0
	spi_bits  = 8
)

func main() {
	fmt.Println("Attempting to engage in Penguin SPI-ing")
	fmt.Printf("Speed: %d\n\tDelay: %d\n\tBPW: %d\n", spi_speed, spi_delay, spi_bits)

	if err := embd.InitSPI(); err != nil {
		fmt.Println("Having a wee panic")
		panic(err)
	}
	defer embd.CloseSPI()

	var channel byte = 0

	// Spi minor appears to be spi dev
	// Notes: chanel cf chip select
	// Todo, get spi1,2,and 2.1
	spiBus := embd.NewSPIBus(embd.SPIMode0, channel, spi_speed, spi_bits, spi_delay)
	defer spiBus.Close()

	adc := mcp3008.New(mcp3008.SingleMode, spiBus)

	for i := 0; i < 20; i++ {
		time.Sleep(1 * time.Second)

		for ch := 0; ch < 16; ch++ {
			val, err := adc.AnalogValueAt(0)
			if err != nil {
				panic(err)
			}
			fmt.Printf("analog channel %v value is: %v\n", ch, val)
		}
	}
}
