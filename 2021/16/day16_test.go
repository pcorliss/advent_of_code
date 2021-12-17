package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

var literalPacket = "D2FE28"

func TestPacketDecodeVersion(t *testing.T) {
	packet := PacketDecode(literalPacket)
	assert.Equal(t, 6, packet.version, "they should be equal")
}

func TestPacketDecodeType(t *testing.T) {
	packet := PacketDecode(literalPacket)
	assert.Equal(t, 4, packet.typ, "they should be equal")
}

func TestHexToBitArray(t *testing.T) {
	bitArr := HexToBitArray(literalPacket)
	assert.Equal(t, true, bitArr[0], "they should be equal")
	assert.Equal(t, true, bitArr[1], "they should be equal")
	assert.Equal(t, false, bitArr[2], "they should be equal")
	assert.Equal(t, false, bitArr[17], "they should be equal")
	assert.Equal(t, true, bitArr[18], "they should be equal")
	assert.Equal(t, 6*4, len(bitArr), "they should be equal")
}

// func TestHexToBitArrayFull(t *testing.T) {
// 	bitArr := HexToBitArray(literalPacket)
// 	PrintBitsAndHex(literalPacket, bitArr)
// }

// func TestPart1(t *testing.T) {
// 	assert.Equal(t, 0, Part1(inputStr), "they should be equal")
// }

// func TestPart2(t *testing.T) {
// 	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
// }
