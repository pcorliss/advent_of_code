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

func TestPacketDecodeVal(t *testing.T) {
	packet := PacketDecode(literalPacket)
	assert.Equal(t, 2021, packet.val, "they should be equal")
}

var singlePacket = "38006F45291200"

func TestPacketDecodeOperatorNestedBitLengthPacket(t *testing.T) {
	packet := PacketDecode(singlePacket)
	assert.Equal(t, 1, packet.version, "they should be equal")
	assert.Equal(t, 6, packet.typ, "they should be equal")
	assert.Equal(t, 27, packet.length, "they should be equal")
	assert.Equal(t, 2, len(packet.sub), "they should be equal")
	a := packet.sub[0]
	b := packet.sub[1]

	assert.Equal(t, 10, a.val, "they should be equal")
	assert.Equal(t, 20, b.val, "they should be equal")
}

var multiPacket = "EE00D40C823060"

func TestPacketDecodeOperatorNestedPacketLengthPacket(t *testing.T) {
	packet := PacketDecode(multiPacket)
	assert.Equal(t, 7, packet.version, "they should be equal")
	assert.Equal(t, 3, packet.typ, "they should be equal")
	assert.Equal(t, 3, packet.length, "they should be equal")
	assert.Equal(t, 3, len(packet.sub), "they should be equal")
	a := packet.sub[0]
	b := packet.sub[1]
	c := packet.sub[2]

	assert.Equal(t, 1, a.val, "they should be equal")
	assert.Equal(t, 2, b.val, "they should be equal")
	assert.Equal(t, 3, c.val, "they should be equal")
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

// func TestPart1(t *testing.T) {
// 	assert.Equal(t, 0, Part1(inputStr), "they should be equal")
// }

// func TestPart2(t *testing.T) {
// 	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
// }
