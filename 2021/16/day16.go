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
	val     int
	length  int
	sub     []Packet
}

func GetBits(data []bool, position int, length int) int {
	out := 0
	for i := position; i < position+length; i++ {
		out <<= 1
		if data[i] {
			out |= 1
		}
		// fmt.Println("Out:", out)
	}
	return out
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

func PacketDecodeLiteral(packet Packet, data []bool) Packet {
	// Read value
	val := 0
	pos := 6
	cycle := 0
	for {
		finished := GetBits(data, pos, 1) == 0
		// fmt.Println("LastSet?", finished)
		pos++
		val <<= 4
		val |= GetBits(data, pos, 4)
		// fmt.Println("Val:", val)
		pos += 4
		cycle++
		if finished {
			break
		}
		if cycle > 10 {
			panic("Too many cycles!!!")
		}
	}
	packet.val = val
	return packet
}

func PacketDecodeNested(packet Packet, data []bool) Packet {
	if GetBits(data, 6, 1) == 0 {
		packet.length = GetBits(data, 7, 15)
		// PacketDecode(data[8:8 + packet.length])
		// DecodeLiterals
	} else {
		// packet.sublength = ... // next 11 bits is the number of sub-packets
	}
	return packet
}

// PacketDecode -> PacketDecodeNested(data, container)

func PacketDecode(in string) Packet {
	data := HexToBitArray(in)
	packet := Packet{}
	packet.version = GetBits(data, 0, 3)
	packet.typ = GetBits(data, 3, 3)
	if packet.typ == 4 {
		return PacketDecodeLiteral(packet, data)
	}
	return PacketDecodeNested(packet, data)
}

func Part1(input string) int {
	return 0
}

func Part2(input string) int {
	return 0
}
