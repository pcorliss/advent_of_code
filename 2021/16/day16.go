package main

import (
	"encoding/hex"
	"fmt"
	"os"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("16/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 16")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Packet struct {
	version int
	typ     int
	// val     int
}

func GetBits(data []bool, position int, length int) int {
	// out := 0
	// for i := position; i < position+length; i++ {
	// 	// This is wrong...
	// 	// byt := position / 8
	// 	byt := 0
	// 	bytInt := int(data[byt])
	// 	out |= ((bytInt >> i) << (length - 1))
	// }
	// // for _, byt := range data {
	// // 	for bit := 0; bit < 8; bit++ {
	// // 		// Is the bit on?
	// // 		out = append(out, (byt>>bit)&1)
	// // 	}
	// // }

	// Get bits 3,4,5
	// (last bit is 5 so shift 8 - 5 - 1)    (select by using 1000 - 1 == 111)
	// int(data[0]) >> (8 - position - length) & ((1 << (length + 1)) - 1)

	// return int(data[0]) >> (8 - length)
	// return int(data[0]) >> (8 - position - length) & ((1 << (length + 1)) - 1)
	out := 0
	for i := position; i < position+length; i++ {
		out <<= 1
		if data[i] {
			out |= 1
		}
		// fmt.Println("Out:", out)
	}
	return out
	// return out

	// Convert byte to binary string
	// fmt.Sprintf("%0b", bytInt)

}

func PrintBitsAndHex(in string, bits []bool) {
	data, err := hex.DecodeString(in)
	if err != nil {
		panic(err)
	}
	fmt.Print("Hex:")
	for _, byt := range data {
		fmt.Printf("%08b", byt)
	}
	fmt.Print("\n")
	fmt.Print("Bit:")
	for _, bit := range bits {
		if bit {
			fmt.Print("1")
		} else {
			fmt.Print("0")
		}
	}
	fmt.Print("\n")
}

func HexToBitArray(in string) []bool {
	data, err := hex.DecodeString(in)
	if err != nil {
		panic(err)
	}
	out := make([]bool, len(in)*4)
	for i, byt := range data {
		for j := 0; j < 8; j++ {
			// fmt.Println("Pos:", (i*8 + j))
			// fmt.Printf("  Byt:%0b\n", byt)
			// fmt.Println("  Out:", out)
			out[i*8+j] = (byt>>(7-j))&1 == 1
		}
	}

	return out
}

func PacketDecode(in string) Packet {
	// data, _ := hex.DecodeString(in)
	data := HexToBitArray(in)
	packet := Packet{}
	packet.version = GetBits(data, 0, 3)
	packet.typ = GetBits(data, 3, 3)
	return packet
}

func Part1(input string) int {
	return 0
}

func Part2(input string) int {
	return 0
}
