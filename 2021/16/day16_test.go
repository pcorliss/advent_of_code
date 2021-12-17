package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestHexToBitArray(t *testing.T) {
	bitArr := HexToBitArray(literalPacket)
	assert.Equal(t, true, bitArr[0], "they should be equal")
	assert.Equal(t, true, bitArr[1], "they should be equal")
	assert.Equal(t, false, bitArr[2], "they should be equal")
	assert.Equal(t, false, bitArr[17], "they should be equal")
	assert.Equal(t, true, bitArr[18], "they should be equal")
	assert.Equal(t, 6*4, len(bitArr), "they should be equal")
}

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

// represents an operator packet (version 4)
// which contains an operator packet (version 1)
// which contains an operator packet (version 5)
// which contains a literal value (version 6);
// this packet has a version sum of 16.
var v4Packet = "8A004A801A8002F478"

func TestPacketDecodeV4Packet(t *testing.T) {
	packet := PacketDecode(v4Packet)
	// fmt.Println("Packet:", packet)
	assert.Equal(t, 4, packet.version, "they should be equal")
	assert.Equal(t, 1, packet.sub[0].version, "they should be equal")
	assert.Equal(t, 5, packet.sub[0].sub[0].version, "they should be equal")
	assert.Equal(t, 6, packet.sub[0].sub[0].sub[0].version, "they should be equal")
}

// represents an operator packet (version 3)
// which contains two sub-packets;
// each sub-packet is an operator packet that contains two literal values.
// This packet has a version sum of 12.
var v3Packet = "620080001611562C8802118E34"

func TestPacketDecodeV3Packet(t *testing.T) {
	packet := PacketDecode(v3Packet)
	// fmt.Println("Packet:", packet)
	assert.Equal(t, 3, packet.version, "they should be equal")
	assert.Equal(t, 2, len(packet.sub), "they should be equal")
	assert.Equal(t, 2, len(packet.sub[0].sub), "they should be equal")
	assert.Equal(t, 2, len(packet.sub[1].sub), "they should be equal")
}

func TestVersionSum(t *testing.T) {
	packet := PacketDecode(v3Packet)
	assert.Equal(t, 12, VersionSum(packet), "they should be equal")
}

// has the same structure as the previous example,
// but the outermost packet uses a different length type ID.
// This packet has a version sum of 23.
var v3Packet2 = "C0015000016115A2E0802F182340"

func TestPacketDecodeV3Packet2(t *testing.T) {
	packet := PacketDecode(v3Packet2)
	// fmt.Println("Packet:", packet)
	assert.Equal(t, 2, len(packet.sub), "they should be equal")
	assert.Equal(t, 2, len(packet.sub[0].sub), "they should be equal")
	assert.Equal(t, 2, len(packet.sub[1].sub), "they should be equal")
}

func TestVersionSum2(t *testing.T) {
	packet := PacketDecode(v3Packet2)
	assert.Equal(t, 23, VersionSum(packet), "they should be equal")
}

// is an operator packet
// that contains an operator packet
// that contains an operator packet
// that contains five literal values;
// it has a version sum of 31.
var nestedOperator = "A0016C880162017C3686B18A3D4780"

func TestPacketDecodeSuperNested(t *testing.T) {
	packet := PacketDecode(nestedOperator)
	// fmt.Println("Packet:", packet)
	assert.Equal(t, 1, len(packet.sub), "they should be equal")
	assert.Equal(t, 1, len(packet.sub[0].sub), "they should be equal")
	assert.Equal(t, 5, len(packet.sub[0].sub[0].sub), "they should be equal")
}

func TestVersionSumSuperNested(t *testing.T) {
	packet := PacketDecode(nestedOperator)
	assert.Equal(t, 31, VersionSum(packet), "they should be equal")
}

// func TestPart1(t *testing.T) {
// 	assert.Equal(t, 0, Part1(inputStr), "they should be equal")
// }

// func TestPart2(t *testing.T) {
// 	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
// }
