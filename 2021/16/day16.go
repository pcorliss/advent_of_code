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

func PacketDecodeLiteralValue(data []bool) (int, int) {
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
	return val, pos
}

func PacketDecodeNested(packet Packet, data []bool) (Packet, int) {
	nestingType := GetBits(data, 6, 1)
	// fmt.Println("Nest:", nestingType, len(data))
	pos := 0
	if nestingType == 0 {
		packet.length = GetBits(data, 7, 15)
		// fmt.Println("Length: ", packet.length, 22, 22+packet.length)
		subPackets, _ := PacketDecoder(data[22:22+packet.length], 0)
		packet.sub = subPackets
		pos = 22 + packet.length
	} else {
		packet.length = GetBits(data, 7, 11)
		// fmt.Println("Anticipated Length: ", packet.length)
		subPackets, newPos := PacketDecoder(data[18:], packet.length)
		packet.sub = subPackets
		pos += 18 + newPos
		if len(packet.sub) != packet.length {
			fmt.Println("Got:", len(packet.sub), "Anticipated:", packet.length)
			panic("Got unexpected length of packets back")
		}

	}
	return packet, pos
}

// PacketDecode -> PacketDecodeNested(data, container)
func PacketDecoder(data []bool, limit int) ([]Packet, int) {
	pos := 0
	packets := []Packet{}
	for len(data)-pos >= 11 && (len(packets) < limit || limit == 0) {
		packet := Packet{}
		packet.version = GetBits(data, 0+pos, 3)
		packet.typ = GetBits(data, 3+pos, 3)
		if packet.typ == 4 {
			val, newPos := PacketDecodeLiteralValue(data[pos:])
			packet.val = val
			pos += newPos
		} else {
			// fmt.Println("Pre Nested:", packet, pos, len(data))
			newPacket, newPos := PacketDecodeNested(packet, data[pos:])
			packet = newPacket
			pos += newPos
			// fmt.Println("Post Nested:", packet, pos, len(data))
			// packets = append(packets, packet)
			// return packets, pos
		}
		packets = append(packets, packet)
		// fmt.Println("Packets:", packets, pos)
		if len(packets) > 500 {
			panic("Loop cycle control Too many packets!!")
		}
	}
	return packets, pos
}

func PacketDecode(in string) Packet {
	data := HexToBitArray(in)
	packets, _ := PacketDecoder(data, 0)
	return packets[0]
}

func VersionSum(packet Packet) int {
	sum := 0
	sum += packet.version
	for _, p := range packet.sub {
		sum += VersionSum(p)
	}
	return sum
}

func Part1(input string) int {
	packet := PacketDecode(input)
	return VersionSum(packet)
}

func Part2(input string) int {
	return 0
}
